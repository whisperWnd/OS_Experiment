
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 28 af 11 c0       	mov    $0xc011af28,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 01 5c 00 00       	call   c0105c63 <memset>

    cons_init();                // init the console
c0100062:	e8 7c 15 00 00       	call   c01015e3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 00 5e 10 c0 	movl   $0xc0105e00,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 1c 5e 10 c0 	movl   $0xc0105e1c,(%esp)
c010007c:	e8 c7 02 00 00       	call   c0100348 <cprintf>

    print_kerninfo();
c0100081:	e8 f6 07 00 00       	call   c010087c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 86 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 cd 42 00 00       	call   c010435d <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 b7 16 00 00       	call   c010174c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 09 18 00 00       	call   c01018a3 <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 fa 0c 00 00       	call   c0100d99 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 16 16 00 00       	call   c01016ba <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	55                   	push   %ebp
c01000a7:	89 e5                	mov    %esp,%ebp
c01000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b3:	00 
c01000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bb:	00 
c01000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c3:	e8 f2 0b 00 00       	call   c0100cba <mon_backtrace>
}
c01000c8:	c9                   	leave  
c01000c9:	c3                   	ret    

c01000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000ca:	55                   	push   %ebp
c01000cb:	89 e5                	mov    %esp,%ebp
c01000cd:	53                   	push   %ebx
c01000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000d7:	8d 55 08             	lea    0x8(%ebp),%edx
c01000da:	8b 45 08             	mov    0x8(%ebp),%eax
c01000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e9:	89 04 24             	mov    %eax,(%esp)
c01000ec:	e8 b5 ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000f1:	83 c4 14             	add    $0x14,%esp
c01000f4:	5b                   	pop    %ebx
c01000f5:	5d                   	pop    %ebp
c01000f6:	c3                   	ret    

c01000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f7:	55                   	push   %ebp
c01000f8:	89 e5                	mov    %esp,%ebp
c01000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100100:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100104:	8b 45 08             	mov    0x8(%ebp),%eax
c0100107:	89 04 24             	mov    %eax,(%esp)
c010010a:	e8 bb ff ff ff       	call   c01000ca <grade_backtrace1>
}
c010010f:	c9                   	leave  
c0100110:	c3                   	ret    

c0100111 <grade_backtrace>:

void
grade_backtrace(void) {
c0100111:	55                   	push   %ebp
c0100112:	89 e5                	mov    %esp,%ebp
c0100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100117:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100123:	ff 
c0100124:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010012f:	e8 c3 ff ff ff       	call   c01000f7 <grade_backtrace0>
}
c0100134:	c9                   	leave  
c0100135:	c3                   	ret    

c0100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100136:	55                   	push   %ebp
c0100137:	89 e5                	mov    %esp,%ebp
c0100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014c:	0f b7 c0             	movzwl %ax,%eax
c010014f:	83 e0 03             	and    $0x3,%eax
c0100152:	89 c2                	mov    %eax,%edx
c0100154:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100159:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100161:	c7 04 24 21 5e 10 c0 	movl   $0xc0105e21,(%esp)
c0100168:	e8 db 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100171:	0f b7 d0             	movzwl %ax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 2f 5e 10 c0 	movl   $0xc0105e2f,(%esp)
c0100188:	e8 bb 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	0f b7 d0             	movzwl %ax,%edx
c0100194:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100199:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a1:	c7 04 24 3d 5e 10 c0 	movl   $0xc0105e3d,(%esp)
c01001a8:	e8 9b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b1:	0f b7 d0             	movzwl %ax,%edx
c01001b4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c1:	c7 04 24 4b 5e 10 c0 	movl   $0xc0105e4b,(%esp)
c01001c8:	e8 7b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d1:	0f b7 d0             	movzwl %ax,%edx
c01001d4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e1:	c7 04 24 59 5e 10 c0 	movl   $0xc0105e59,(%esp)
c01001e8:	e8 5b 01 00 00       	call   c0100348 <cprintf>
    round ++;
c01001ed:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001f2:	83 c0 01             	add    $0x1,%eax
c01001f5:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001fa:	c9                   	leave  
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001ff:	5d                   	pop    %ebp
c0100200:	c3                   	ret    

c0100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100201:	55                   	push   %ebp
c0100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100204:	5d                   	pop    %ebp
c0100205:	c3                   	ret    

c0100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100206:	55                   	push   %ebp
c0100207:	89 e5                	mov    %esp,%ebp
c0100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020c:	e8 25 ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100211:	c7 04 24 68 5e 10 c0 	movl   $0xc0105e68,(%esp)
c0100218:	e8 2b 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_user();
c010021d:	e8 da ff ff ff       	call   c01001fc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100222:	e8 0f ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100227:	c7 04 24 88 5e 10 c0 	movl   $0xc0105e88,(%esp)
c010022e:	e8 15 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_kernel();
c0100233:	e8 c9 ff ff ff       	call   c0100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100238:	e8 f9 fe ff ff       	call   c0100136 <lab1_print_cur_status>
}
c010023d:	c9                   	leave  
c010023e:	c3                   	ret    

c010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010023f:	55                   	push   %ebp
c0100240:	89 e5                	mov    %esp,%ebp
c0100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100249:	74 13                	je     c010025e <readline+0x1f>
        cprintf("%s", prompt);
c010024b:	8b 45 08             	mov    0x8(%ebp),%eax
c010024e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100252:	c7 04 24 a7 5e 10 c0 	movl   $0xc0105ea7,(%esp)
c0100259:	e8 ea 00 00 00       	call   c0100348 <cprintf>
    }
    int i = 0, c;
c010025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100265:	e8 66 01 00 00       	call   c01003d0 <getchar>
c010026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100271:	79 07                	jns    c010027a <readline+0x3b>
            return NULL;
c0100273:	b8 00 00 00 00       	mov    $0x0,%eax
c0100278:	eb 79                	jmp    c01002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027e:	7e 28                	jle    c01002a8 <readline+0x69>
c0100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100287:	7f 1f                	jg     c01002a8 <readline+0x69>
            cputchar(c);
c0100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028c:	89 04 24             	mov    %eax,(%esp)
c010028f:	e8 da 00 00 00       	call   c010036e <cputchar>
            buf[i ++] = c;
c0100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100297:	8d 50 01             	lea    0x1(%eax),%edx
c010029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a0:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c01002a6:	eb 46                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002ac:	75 17                	jne    c01002c5 <readline+0x86>
c01002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b2:	7e 11                	jle    c01002c5 <readline+0x86>
            cputchar(c);
c01002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b7:	89 04 24             	mov    %eax,(%esp)
c01002ba:	e8 af 00 00 00       	call   c010036e <cputchar>
            i --;
c01002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c3:	eb 29                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c9:	74 06                	je     c01002d1 <readline+0x92>
c01002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002cf:	75 1d                	jne    c01002ee <readline+0xaf>
            cputchar(c);
c01002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d4:	89 04 24             	mov    %eax,(%esp)
c01002d7:	e8 92 00 00 00       	call   c010036e <cputchar>
            buf[i] = '\0';
c01002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002df:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e7:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01002ec:	eb 05                	jmp    c01002f3 <readline+0xb4>
        }
    }
c01002ee:	e9 72 ff ff ff       	jmp    c0100265 <readline+0x26>
}
c01002f3:	c9                   	leave  
c01002f4:	c3                   	ret    

c01002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f5:	55                   	push   %ebp
c01002f6:	89 e5                	mov    %esp,%ebp
c01002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fe:	89 04 24             	mov    %eax,(%esp)
c0100301:	e8 09 13 00 00       	call   c010160f <cons_putc>
    (*cnt) ++;
c0100306:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100309:	8b 00                	mov    (%eax),%eax
c010030b:	8d 50 01             	lea    0x1(%eax),%edx
c010030e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100311:	89 10                	mov    %edx,(%eax)
}
c0100313:	c9                   	leave  
c0100314:	c3                   	ret    

c0100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100315:	55                   	push   %ebp
c0100316:	89 e5                	mov    %esp,%ebp
c0100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100322:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100329:	8b 45 08             	mov    0x8(%ebp),%eax
c010032c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100333:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100337:	c7 04 24 f5 02 10 c0 	movl   $0xc01002f5,(%esp)
c010033e:	e8 39 51 00 00       	call   c010547c <vprintfmt>
    return cnt;
c0100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100346:	c9                   	leave  
c0100347:	c3                   	ret    

c0100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100348:	55                   	push   %ebp
c0100349:	89 e5                	mov    %esp,%ebp
c010034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100357:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035b:	8b 45 08             	mov    0x8(%ebp),%eax
c010035e:	89 04 24             	mov    %eax,(%esp)
c0100361:	e8 af ff ff ff       	call   c0100315 <vcprintf>
c0100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036c:	c9                   	leave  
c010036d:	c3                   	ret    

c010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036e:	55                   	push   %ebp
c010036f:	89 e5                	mov    %esp,%ebp
c0100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100374:	8b 45 08             	mov    0x8(%ebp),%eax
c0100377:	89 04 24             	mov    %eax,(%esp)
c010037a:	e8 90 12 00 00       	call   c010160f <cons_putc>
}
c010037f:	c9                   	leave  
c0100380:	c3                   	ret    

c0100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100381:	55                   	push   %ebp
c0100382:	89 e5                	mov    %esp,%ebp
c0100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038e:	eb 13                	jmp    c01003a3 <cputs+0x22>
        cputch(c, &cnt);
c0100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100397:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039b:	89 04 24             	mov    %eax,(%esp)
c010039e:	e8 52 ff ff ff       	call   c01002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a6:	8d 50 01             	lea    0x1(%eax),%edx
c01003a9:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ac:	0f b6 00             	movzbl (%eax),%eax
c01003af:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b6:	75 d8                	jne    c0100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c6:	e8 2a ff ff ff       	call   c01002f5 <cputch>
    return cnt;
c01003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ce:	c9                   	leave  
c01003cf:	c3                   	ret    

c01003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d0:	55                   	push   %ebp
c01003d1:	89 e5                	mov    %esp,%ebp
c01003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d6:	e8 70 12 00 00       	call   c010164b <cons_getc>
c01003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e2:	74 f2                	je     c01003d6 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e7:	c9                   	leave  
c01003e8:	c3                   	ret    

c01003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e9:	55                   	push   %ebp
c01003ea:	89 e5                	mov    %esp,%ebp
c01003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f2:	8b 00                	mov    (%eax),%eax
c01003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fa:	8b 00                	mov    (%eax),%eax
c01003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100406:	e9 d2 00 00 00       	jmp    c01004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100411:	01 d0                	add    %edx,%eax
c0100413:	89 c2                	mov    %eax,%edx
c0100415:	c1 ea 1f             	shr    $0x1f,%edx
c0100418:	01 d0                	add    %edx,%eax
c010041a:	d1 f8                	sar    %eax
c010041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100425:	eb 04                	jmp    c010042b <stab_binsearch+0x42>
            m --;
c0100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100431:	7c 1f                	jl     c0100452 <stab_binsearch+0x69>
c0100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100436:	89 d0                	mov    %edx,%eax
c0100438:	01 c0                	add    %eax,%eax
c010043a:	01 d0                	add    %edx,%eax
c010043c:	c1 e0 02             	shl    $0x2,%eax
c010043f:	89 c2                	mov    %eax,%edx
c0100441:	8b 45 08             	mov    0x8(%ebp),%eax
c0100444:	01 d0                	add    %edx,%eax
c0100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044a:	0f b6 c0             	movzbl %al,%eax
c010044d:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100450:	75 d5                	jne    c0100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100458:	7d 0b                	jge    c0100465 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010045d:	83 c0 01             	add    $0x1,%eax
c0100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100463:	eb 78                	jmp    c01004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046f:	89 d0                	mov    %edx,%eax
c0100471:	01 c0                	add    %eax,%eax
c0100473:	01 d0                	add    %edx,%eax
c0100475:	c1 e0 02             	shl    $0x2,%eax
c0100478:	89 c2                	mov    %eax,%edx
c010047a:	8b 45 08             	mov    0x8(%ebp),%eax
c010047d:	01 d0                	add    %edx,%eax
c010047f:	8b 40 08             	mov    0x8(%eax),%eax
c0100482:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100485:	73 13                	jae    c010049a <stab_binsearch+0xb1>
            *region_left = m;
c0100487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100492:	83 c0 01             	add    $0x1,%eax
c0100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100498:	eb 43                	jmp    c01004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049d:	89 d0                	mov    %edx,%eax
c010049f:	01 c0                	add    %eax,%eax
c01004a1:	01 d0                	add    %edx,%eax
c01004a3:	c1 e0 02             	shl    $0x2,%eax
c01004a6:	89 c2                	mov    %eax,%edx
c01004a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ab:	01 d0                	add    %edx,%eax
c01004ad:	8b 40 08             	mov    0x8(%eax),%eax
c01004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b3:	76 16                	jbe    c01004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	83 e8 01             	sub    $0x1,%eax
c01004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c9:	eb 12                	jmp    c01004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e3:	0f 8e 22 ff ff ff    	jle    c010040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004ed:	75 0f                	jne    c01004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f2:	8b 00                	mov    (%eax),%eax
c01004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fa:	89 10                	mov    %edx,(%eax)
c01004fc:	eb 3f                	jmp    c010053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100501:	8b 00                	mov    (%eax),%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100506:	eb 04                	jmp    c010050c <stab_binsearch+0x123>
c0100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050f:	8b 00                	mov    (%eax),%eax
c0100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100514:	7d 1f                	jge    c0100535 <stab_binsearch+0x14c>
c0100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100519:	89 d0                	mov    %edx,%eax
c010051b:	01 c0                	add    %eax,%eax
c010051d:	01 d0                	add    %edx,%eax
c010051f:	c1 e0 02             	shl    $0x2,%eax
c0100522:	89 c2                	mov    %eax,%edx
c0100524:	8b 45 08             	mov    0x8(%ebp),%eax
c0100527:	01 d0                	add    %edx,%eax
c0100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052d:	0f b6 c0             	movzbl %al,%eax
c0100530:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100533:	75 d3                	jne    c0100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100535:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053b:	89 10                	mov    %edx,(%eax)
    }
}
c010053d:	c9                   	leave  
c010053e:	c3                   	ret    

c010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053f:	55                   	push   %ebp
c0100540:	89 e5                	mov    %esp,%ebp
c0100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100548:	c7 00 ac 5e 10 c0    	movl   $0xc0105eac,(%eax)
    info->eip_line = 0;
c010054e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055b:	c7 40 08 ac 5e 10 c0 	movl   $0xc0105eac,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057f:	c7 45 f4 38 71 10 c0 	movl   $0xc0107138,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100586:	c7 45 f0 34 1a 11 c0 	movl   $0xc0111a34,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058d:	c7 45 ec 35 1a 11 c0 	movl   $0xc0111a35,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100594:	c7 45 e8 34 44 11 c0 	movl   $0xc0114434,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a1:	76 0d                	jbe    c01005b0 <debuginfo_eip+0x71>
c01005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a6:	83 e8 01             	sub    $0x1,%eax
c01005a9:	0f b6 00             	movzbl (%eax),%eax
c01005ac:	84 c0                	test   %al,%al
c01005ae:	74 0a                	je     c01005ba <debuginfo_eip+0x7b>
        return -1;
c01005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b5:	e9 c0 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005c7:	29 c2                	sub    %eax,%edx
c01005c9:	89 d0                	mov    %edx,%eax
c01005cb:	c1 f8 02             	sar    $0x2,%eax
c01005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d4:	83 e8 01             	sub    $0x1,%eax
c01005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005da:	8b 45 08             	mov    0x8(%ebp),%eax
c01005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e8:	00 
c01005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fa:	89 04 24             	mov    %eax,(%esp)
c01005fd:	e8 e7 fd ff ff       	call   c01003e9 <stab_binsearch>
    if (lfile == 0)
c0100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100605:	85 c0                	test   %eax,%eax
c0100607:	75 0a                	jne    c0100613 <debuginfo_eip+0xd4>
        return -1;
c0100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060e:	e9 67 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010061f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100622:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010062d:	00 
c010062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100631:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100638:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063f:	89 04 24             	mov    %eax,(%esp)
c0100642:	e8 a2 fd ff ff       	call   c01003e9 <stab_binsearch>

    if (lfun <= rfun) {
c0100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010064d:	39 c2                	cmp    %eax,%edx
c010064f:	7f 7c                	jg     c01006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100654:	89 c2                	mov    %eax,%edx
c0100656:	89 d0                	mov    %edx,%eax
c0100658:	01 c0                	add    %eax,%eax
c010065a:	01 d0                	add    %edx,%eax
c010065c:	c1 e0 02             	shl    $0x2,%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	8b 10                	mov    (%eax),%edx
c0100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066e:	29 c1                	sub    %eax,%ecx
c0100670:	89 c8                	mov    %ecx,%eax
c0100672:	39 c2                	cmp    %eax,%edx
c0100674:	73 22                	jae    c0100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100679:	89 c2                	mov    %eax,%edx
c010067b:	89 d0                	mov    %edx,%eax
c010067d:	01 c0                	add    %eax,%eax
c010067f:	01 d0                	add    %edx,%eax
c0100681:	c1 e0 02             	shl    $0x2,%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100689:	01 d0                	add    %edx,%eax
c010068b:	8b 10                	mov    (%eax),%edx
c010068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100690:	01 c2                	add    %eax,%edx
c0100692:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069b:	89 c2                	mov    %eax,%edx
c010069d:	89 d0                	mov    %edx,%eax
c010069f:	01 c0                	add    %eax,%eax
c01006a1:	01 d0                	add    %edx,%eax
c01006a3:	c1 e0 02             	shl    $0x2,%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ab:	01 d0                	add    %edx,%eax
c01006ad:	8b 50 08             	mov    0x8(%eax),%edx
c01006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	8b 40 10             	mov    0x10(%eax),%eax
c01006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006cb:	eb 15                	jmp    c01006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e5:	8b 40 08             	mov    0x8(%eax),%eax
c01006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ef:	00 
c01006f0:	89 04 24             	mov    %eax,(%esp)
c01006f3:	e8 df 53 00 00       	call   c0105ad7 <strfind>
c01006f8:	89 c2                	mov    %eax,%edx
c01006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fd:	8b 40 08             	mov    0x8(%eax),%eax
c0100700:	29 c2                	sub    %eax,%edx
c0100702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100708:	8b 45 08             	mov    0x8(%ebp),%eax
c010070b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100716:	00 
c0100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100721:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100728:	89 04 24             	mov    %eax,(%esp)
c010072b:	e8 b9 fc ff ff       	call   c01003e9 <stab_binsearch>
    if (lline <= rline) {
c0100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100736:	39 c2                	cmp    %eax,%edx
c0100738:	7f 24                	jg     c010075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073d:	89 c2                	mov    %eax,%edx
c010073f:	89 d0                	mov    %edx,%eax
c0100741:	01 c0                	add    %eax,%eax
c0100743:	01 d0                	add    %edx,%eax
c0100745:	c1 e0 02             	shl    $0x2,%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074d:	01 d0                	add    %edx,%eax
c010074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100753:	0f b7 d0             	movzwl %ax,%edx
c0100756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075c:	eb 13                	jmp    c0100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100763:	e9 12 01 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076b:	83 e8 01             	sub    $0x1,%eax
c010076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100777:	39 c2                	cmp    %eax,%edx
c0100779:	7c 56                	jl     c01007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	89 d0                	mov    %edx,%eax
c0100782:	01 c0                	add    %eax,%eax
c0100784:	01 d0                	add    %edx,%eax
c0100786:	c1 e0 02             	shl    $0x2,%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078e:	01 d0                	add    %edx,%eax
c0100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100794:	3c 84                	cmp    $0x84,%al
c0100796:	74 39                	je     c01007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	89 d0                	mov    %edx,%eax
c010079f:	01 c0                	add    %eax,%eax
c01007a1:	01 d0                	add    %edx,%eax
c01007a3:	c1 e0 02             	shl    $0x2,%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ab:	01 d0                	add    %edx,%eax
c01007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b1:	3c 64                	cmp    $0x64,%al
c01007b3:	75 b3                	jne    c0100768 <debuginfo_eip+0x229>
c01007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b8:	89 c2                	mov    %eax,%edx
c01007ba:	89 d0                	mov    %edx,%eax
c01007bc:	01 c0                	add    %eax,%eax
c01007be:	01 d0                	add    %edx,%eax
c01007c0:	c1 e0 02             	shl    $0x2,%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c8:	01 d0                	add    %edx,%eax
c01007ca:	8b 40 08             	mov    0x8(%eax),%eax
c01007cd:	85 c0                	test   %eax,%eax
c01007cf:	74 97                	je     c0100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007d7:	39 c2                	cmp    %eax,%edx
c01007d9:	7c 46                	jl     c0100821 <debuginfo_eip+0x2e2>
c01007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007de:	89 c2                	mov    %eax,%edx
c01007e0:	89 d0                	mov    %edx,%eax
c01007e2:	01 c0                	add    %eax,%eax
c01007e4:	01 d0                	add    %edx,%eax
c01007e6:	c1 e0 02             	shl    $0x2,%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ee:	01 d0                	add    %edx,%eax
c01007f0:	8b 10                	mov    (%eax),%edx
c01007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f8:	29 c1                	sub    %eax,%ecx
c01007fa:	89 c8                	mov    %ecx,%eax
c01007fc:	39 c2                	cmp    %eax,%edx
c01007fe:	73 21                	jae    c0100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	89 d0                	mov    %edx,%eax
c0100807:	01 c0                	add    %eax,%eax
c0100809:	01 d0                	add    %edx,%eax
c010080b:	c1 e0 02             	shl    $0x2,%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100813:	01 d0                	add    %edx,%eax
c0100815:	8b 10                	mov    (%eax),%edx
c0100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081a:	01 c2                	add    %eax,%edx
c010081c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100827:	39 c2                	cmp    %eax,%edx
c0100829:	7d 4a                	jge    c0100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082e:	83 c0 01             	add    $0x1,%eax
c0100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100834:	eb 18                	jmp    c010084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100836:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100839:	8b 40 14             	mov    0x14(%eax),%eax
c010083c:	8d 50 01             	lea    0x1(%eax),%edx
c010083f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100848:	83 c0 01             	add    $0x1,%eax
c010084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100854:	39 c2                	cmp    %eax,%edx
c0100856:	7d 1d                	jge    c0100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	89 d0                	mov    %edx,%eax
c010085f:	01 c0                	add    %eax,%eax
c0100861:	01 d0                	add    %edx,%eax
c0100863:	c1 e0 02             	shl    $0x2,%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100871:	3c a0                	cmp    $0xa0,%al
c0100873:	74 c1                	je     c0100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087a:	c9                   	leave  
c010087b:	c3                   	ret    

c010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087c:	55                   	push   %ebp
c010087d:	89 e5                	mov    %esp,%ebp
c010087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100882:	c7 04 24 b6 5e 10 c0 	movl   $0xc0105eb6,(%esp)
c0100889:	e8 ba fa ff ff       	call   c0100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100895:	c0 
c0100896:	c7 04 24 cf 5e 10 c0 	movl   $0xc0105ecf,(%esp)
c010089d:	e8 a6 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a2:	c7 44 24 04 ec 5d 10 	movl   $0xc0105dec,0x4(%esp)
c01008a9:	c0 
c01008aa:	c7 04 24 e7 5e 10 c0 	movl   $0xc0105ee7,(%esp)
c01008b1:	e8 92 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b6:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c01008bd:	c0 
c01008be:	c7 04 24 ff 5e 10 c0 	movl   $0xc0105eff,(%esp)
c01008c5:	e8 7e fa ff ff       	call   c0100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ca:	c7 44 24 04 28 af 11 	movl   $0xc011af28,0x4(%esp)
c01008d1:	c0 
c01008d2:	c7 04 24 17 5f 10 c0 	movl   $0xc0105f17,(%esp)
c01008d9:	e8 6a fa ff ff       	call   c0100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008de:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c01008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e9:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01008ee:	29 c2                	sub    %eax,%edx
c01008f0:	89 d0                	mov    %edx,%eax
c01008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f8:	85 c0                	test   %eax,%eax
c01008fa:	0f 48 c2             	cmovs  %edx,%eax
c01008fd:	c1 f8 0a             	sar    $0xa,%eax
c0100900:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100904:	c7 04 24 30 5f 10 c0 	movl   $0xc0105f30,(%esp)
c010090b:	e8 38 fa ff ff       	call   c0100348 <cprintf>
}
c0100910:	c9                   	leave  
c0100911:	c3                   	ret    

c0100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100912:	55                   	push   %ebp
c0100913:	89 e5                	mov    %esp,%ebp
c0100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010091e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100922:	8b 45 08             	mov    0x8(%ebp),%eax
c0100925:	89 04 24             	mov    %eax,(%esp)
c0100928:	e8 12 fc ff ff       	call   c010053f <debuginfo_eip>
c010092d:	85 c0                	test   %eax,%eax
c010092f:	74 15                	je     c0100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100931:	8b 45 08             	mov    0x8(%ebp),%eax
c0100934:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100938:	c7 04 24 5a 5f 10 c0 	movl   $0xc0105f5a,(%esp)
c010093f:	e8 04 fa ff ff       	call   c0100348 <cprintf>
c0100944:	eb 6d                	jmp    c01009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010094d:	eb 1c                	jmp    c010096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100955:	01 d0                	add    %edx,%eax
c0100957:	0f b6 00             	movzbl (%eax),%eax
c010095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100963:	01 ca                	add    %ecx,%edx
c0100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100971:	7f dc                	jg     c010094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097c:	01 d0                	add    %edx,%eax
c010097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100984:	8b 55 08             	mov    0x8(%ebp),%edx
c0100987:	89 d1                	mov    %edx,%ecx
c0100989:	29 c1                	sub    %eax,%ecx
c010098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010099f:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a7:	c7 04 24 76 5f 10 c0 	movl   $0xc0105f76,(%esp)
c01009ae:	e8 95 f9 ff ff       	call   c0100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b3:	c9                   	leave  
c01009b4:	c3                   	ret    

c01009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b5:	55                   	push   %ebp
c01009b6:	89 e5                	mov    %esp,%ebp
c01009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009bb:	8b 45 04             	mov    0x4(%ebp),%eax
c01009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c4:	c9                   	leave  
c01009c5:	c3                   	ret    

c01009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c6:	55                   	push   %ebp
c01009c7:	89 e5                	mov    %esp,%ebp
c01009c9:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cc:	89 e8                	mov    %ebp,%eax
c01009ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();//读取ebp和eip
c01009d7:	e8 d9 ff ff ff       	call   c01009b5 <read_eip>
c01009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int i, j;
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e6:	e9 82 00 00 00       	jmp    c0100a6d <print_stackframe+0xa7>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);//显示8位16进制数(32位二进制数)
c01009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009ee:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f9:	c7 04 24 88 5f 10 c0 	movl   $0xc0105f88,(%esp)
c0100a00:	e8 43 f9 ff ff       	call   c0100348 <cprintf>
        for (j = 0; j < 4; j ++) {
c0100a05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a0c:	eb 28                	jmp    c0100a36 <print_stackframe+0x70>
            cprintf("0x%08x ", ((uint32_t*)ebp + 2)[j]);//输出参数(4个32位二进制数)，参数的地址比ebp的地址高两位
c0100a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a11:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a1b:	01 d0                	add    %edx,%eax
c0100a1d:	83 c0 08             	add    $0x8,%eax
c0100a20:	8b 00                	mov    (%eax),%eax
c0100a22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a26:	c7 04 24 a4 5f 10 c0 	movl   $0xc0105fa4,(%esp)
c0100a2d:	e8 16 f9 ff ff       	call   c0100348 <cprintf>
	uint32_t eip = read_eip();//读取ebp和eip

	int i, j;
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);//显示8位16进制数(32位二进制数)
        for (j = 0; j < 4; j ++) {
c0100a32:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a36:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3a:	7e d2                	jle    c0100a0e <print_stackframe+0x48>
            cprintf("0x%08x ", ((uint32_t*)ebp + 2)[j]);//输出参数(4个32位二进制数)，参数的地址比ebp的地址高两位
        }
        cprintf("\n");
c0100a3c:	c7 04 24 ac 5f 10 c0 	movl   $0xc0105fac,(%esp)
c0100a43:	e8 00 f9 ff ff       	call   c0100348 <cprintf>
        print_debuginfo(eip - 1);//打印前一条指令的信息
c0100a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4b:	83 e8 01             	sub    $0x1,%eax
c0100a4e:	89 04 24             	mov    %eax,(%esp)
c0100a51:	e8 bc fe ff ff       	call   c0100912 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];//eip比ebp的地址高一位
c0100a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a59:	83 c0 04             	add    $0x4,%eax
c0100a5c:	8b 00                	mov    (%eax),%eax
c0100a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];//取出上一层函数的ebp
c0100a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a64:	8b 00                	mov    (%eax),%eax
c0100a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();//读取ebp和eip

	int i, j;
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a69:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a71:	74 0a                	je     c0100a7d <print_stackframe+0xb7>
c0100a73:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a77:	0f 8e 6e ff ff ff    	jle    c01009eb <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);//打印前一条指令的信息
        eip = ((uint32_t *)ebp)[1];//eip比ebp的地址高一位
        ebp = ((uint32_t *)ebp)[0];//取出上一层函数的ebp
    }
}
c0100a7d:	c9                   	leave  
c0100a7e:	c3                   	ret    

c0100a7f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a7f:	55                   	push   %ebp
c0100a80:	89 e5                	mov    %esp,%ebp
c0100a82:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8c:	eb 0c                	jmp    c0100a9a <parse+0x1b>
            *buf ++ = '\0';
c0100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a91:	8d 50 01             	lea    0x1(%eax),%edx
c0100a94:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a97:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9d:	0f b6 00             	movzbl (%eax),%eax
c0100aa0:	84 c0                	test   %al,%al
c0100aa2:	74 1d                	je     c0100ac1 <parse+0x42>
c0100aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa7:	0f b6 00             	movzbl (%eax),%eax
c0100aaa:	0f be c0             	movsbl %al,%eax
c0100aad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab1:	c7 04 24 30 60 10 c0 	movl   $0xc0106030,(%esp)
c0100ab8:	e8 e7 4f 00 00       	call   c0105aa4 <strchr>
c0100abd:	85 c0                	test   %eax,%eax
c0100abf:	75 cd                	jne    c0100a8e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac4:	0f b6 00             	movzbl (%eax),%eax
c0100ac7:	84 c0                	test   %al,%al
c0100ac9:	75 02                	jne    c0100acd <parse+0x4e>
            break;
c0100acb:	eb 67                	jmp    c0100b34 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100acd:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad1:	75 14                	jne    c0100ae7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ada:	00 
c0100adb:	c7 04 24 35 60 10 c0 	movl   $0xc0106035,(%esp)
c0100ae2:	e8 61 f8 ff ff       	call   c0100348 <cprintf>
        }
        argv[argc ++] = buf;
c0100ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aea:	8d 50 01             	lea    0x1(%eax),%edx
c0100aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afa:	01 c2                	add    %eax,%edx
c0100afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aff:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b01:	eb 04                	jmp    c0100b07 <parse+0x88>
            buf ++;
c0100b03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0a:	0f b6 00             	movzbl (%eax),%eax
c0100b0d:	84 c0                	test   %al,%al
c0100b0f:	74 1d                	je     c0100b2e <parse+0xaf>
c0100b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b14:	0f b6 00             	movzbl (%eax),%eax
c0100b17:	0f be c0             	movsbl %al,%eax
c0100b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1e:	c7 04 24 30 60 10 c0 	movl   $0xc0106030,(%esp)
c0100b25:	e8 7a 4f 00 00       	call   c0105aa4 <strchr>
c0100b2a:	85 c0                	test   %eax,%eax
c0100b2c:	74 d5                	je     c0100b03 <parse+0x84>
            buf ++;
        }
    }
c0100b2e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b2f:	e9 66 ff ff ff       	jmp    c0100a9a <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b37:	c9                   	leave  
c0100b38:	c3                   	ret    

c0100b39 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b39:	55                   	push   %ebp
c0100b3a:	89 e5                	mov    %esp,%ebp
c0100b3c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b3f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b46:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b49:	89 04 24             	mov    %eax,(%esp)
c0100b4c:	e8 2e ff ff ff       	call   c0100a7f <parse>
c0100b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b58:	75 0a                	jne    c0100b64 <runcmd+0x2b>
        return 0;
c0100b5a:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b5f:	e9 85 00 00 00       	jmp    c0100be9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6b:	eb 5c                	jmp    c0100bc9 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b6d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b73:	89 d0                	mov    %edx,%eax
c0100b75:	01 c0                	add    %eax,%eax
c0100b77:	01 d0                	add    %edx,%eax
c0100b79:	c1 e0 02             	shl    $0x2,%eax
c0100b7c:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100b81:	8b 00                	mov    (%eax),%eax
c0100b83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b87:	89 04 24             	mov    %eax,(%esp)
c0100b8a:	e8 76 4e 00 00       	call   c0105a05 <strcmp>
c0100b8f:	85 c0                	test   %eax,%eax
c0100b91:	75 32                	jne    c0100bc5 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b96:	89 d0                	mov    %edx,%eax
c0100b98:	01 c0                	add    %eax,%eax
c0100b9a:	01 d0                	add    %edx,%eax
c0100b9c:	c1 e0 02             	shl    $0x2,%eax
c0100b9f:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100ba4:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100baa:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bad:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb4:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb7:	83 c2 04             	add    $0x4,%edx
c0100bba:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bbe:	89 0c 24             	mov    %ecx,(%esp)
c0100bc1:	ff d0                	call   *%eax
c0100bc3:	eb 24                	jmp    c0100be9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcc:	83 f8 02             	cmp    $0x2,%eax
c0100bcf:	76 9c                	jbe    c0100b6d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd8:	c7 04 24 53 60 10 c0 	movl   $0xc0106053,(%esp)
c0100bdf:	e8 64 f7 ff ff       	call   c0100348 <cprintf>
    return 0;
c0100be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be9:	c9                   	leave  
c0100bea:	c3                   	ret    

c0100beb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100beb:	55                   	push   %ebp
c0100bec:	89 e5                	mov    %esp,%ebp
c0100bee:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf1:	c7 04 24 6c 60 10 c0 	movl   $0xc010606c,(%esp)
c0100bf8:	e8 4b f7 ff ff       	call   c0100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfd:	c7 04 24 94 60 10 c0 	movl   $0xc0106094,(%esp)
c0100c04:	e8 3f f7 ff ff       	call   c0100348 <cprintf>

    if (tf != NULL) {
c0100c09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c0d:	74 0b                	je     c0100c1a <kmonitor+0x2f>
        print_trapframe(tf);
c0100c0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c12:	89 04 24             	mov    %eax,(%esp)
c0100c15:	e8 41 0e 00 00       	call   c0101a5b <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1a:	c7 04 24 b9 60 10 c0 	movl   $0xc01060b9,(%esp)
c0100c21:	e8 19 f6 ff ff       	call   c010023f <readline>
c0100c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c2d:	74 18                	je     c0100c47 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c39:	89 04 24             	mov    %eax,(%esp)
c0100c3c:	e8 f8 fe ff ff       	call   c0100b39 <runcmd>
c0100c41:	85 c0                	test   %eax,%eax
c0100c43:	79 02                	jns    c0100c47 <kmonitor+0x5c>
                break;
c0100c45:	eb 02                	jmp    c0100c49 <kmonitor+0x5e>
            }
        }
    }
c0100c47:	eb d1                	jmp    c0100c1a <kmonitor+0x2f>
}
c0100c49:	c9                   	leave  
c0100c4a:	c3                   	ret    

c0100c4b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4b:	55                   	push   %ebp
c0100c4c:	89 e5                	mov    %esp,%ebp
c0100c4e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c58:	eb 3f                	jmp    c0100c99 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5d:	89 d0                	mov    %edx,%eax
c0100c5f:	01 c0                	add    %eax,%eax
c0100c61:	01 d0                	add    %edx,%eax
c0100c63:	c1 e0 02             	shl    $0x2,%eax
c0100c66:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c6b:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c71:	89 d0                	mov    %edx,%eax
c0100c73:	01 c0                	add    %eax,%eax
c0100c75:	01 d0                	add    %edx,%eax
c0100c77:	c1 e0 02             	shl    $0x2,%eax
c0100c7a:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c7f:	8b 00                	mov    (%eax),%eax
c0100c81:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c89:	c7 04 24 bd 60 10 c0 	movl   $0xc01060bd,(%esp)
c0100c90:	e8 b3 f6 ff ff       	call   c0100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9c:	83 f8 02             	cmp    $0x2,%eax
c0100c9f:	76 b9                	jbe    c0100c5a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca6:	c9                   	leave  
c0100ca7:	c3                   	ret    

c0100ca8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca8:	55                   	push   %ebp
c0100ca9:	89 e5                	mov    %esp,%ebp
c0100cab:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cae:	e8 c9 fb ff ff       	call   c010087c <print_kerninfo>
    return 0;
c0100cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb8:	c9                   	leave  
c0100cb9:	c3                   	ret    

c0100cba <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cba:	55                   	push   %ebp
c0100cbb:	89 e5                	mov    %esp,%ebp
c0100cbd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc0:	e8 01 fd ff ff       	call   c01009c6 <print_stackframe>
    return 0;
c0100cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cca:	c9                   	leave  
c0100ccb:	c3                   	ret    

c0100ccc <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccc:	55                   	push   %ebp
c0100ccd:	89 e5                	mov    %esp,%ebp
c0100ccf:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd2:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c0100cd7:	85 c0                	test   %eax,%eax
c0100cd9:	74 02                	je     c0100cdd <__panic+0x11>
        goto panic_dead;
c0100cdb:	eb 59                	jmp    c0100d36 <__panic+0x6a>
    }
    is_panic = 1;
c0100cdd:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c0100ce4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce7:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ced:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfb:	c7 04 24 c6 60 10 c0 	movl   $0xc01060c6,(%esp)
c0100d02:	e8 41 f6 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d11:	89 04 24             	mov    %eax,(%esp)
c0100d14:	e8 fc f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d19:	c7 04 24 e2 60 10 c0 	movl   $0xc01060e2,(%esp)
c0100d20:	e8 23 f6 ff ff       	call   c0100348 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d25:	c7 04 24 e4 60 10 c0 	movl   $0xc01060e4,(%esp)
c0100d2c:	e8 17 f6 ff ff       	call   c0100348 <cprintf>
    print_stackframe();
c0100d31:	e8 90 fc ff ff       	call   c01009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d36:	e8 85 09 00 00       	call   c01016c0 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d42:	e8 a4 fe ff ff       	call   c0100beb <kmonitor>
    }
c0100d47:	eb f2                	jmp    c0100d3b <__panic+0x6f>

c0100d49 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d49:	55                   	push   %ebp
c0100d4a:	89 e5                	mov    %esp,%ebp
c0100d4c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d4f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d58:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d63:	c7 04 24 f6 60 10 c0 	movl   $0xc01060f6,(%esp)
c0100d6a:	e8 d9 f5 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d76:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d79:	89 04 24             	mov    %eax,(%esp)
c0100d7c:	e8 94 f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d81:	c7 04 24 e2 60 10 c0 	movl   $0xc01060e2,(%esp)
c0100d88:	e8 bb f5 ff ff       	call   c0100348 <cprintf>
    va_end(ap);
}
c0100d8d:	c9                   	leave  
c0100d8e:	c3                   	ret    

c0100d8f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d8f:	55                   	push   %ebp
c0100d90:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d92:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c0100d97:	5d                   	pop    %ebp
c0100d98:	c3                   	ret    

c0100d99 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d99:	55                   	push   %ebp
c0100d9a:	89 e5                	mov    %esp,%ebp
c0100d9c:	83 ec 28             	sub    $0x28,%esp
c0100d9f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da5:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dad:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db1:	ee                   	out    %al,(%dx)
c0100db2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dbc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc4:	ee                   	out    %al,(%dx)
c0100dc5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dcb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dcf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd8:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100ddf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de2:	c7 04 24 14 61 10 c0 	movl   $0xc0106114,(%esp)
c0100de9:	e8 5a f5 ff ff       	call   c0100348 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df5:	e8 24 09 00 00       	call   c010171e <pic_enable>
}
c0100dfa:	c9                   	leave  
c0100dfb:	c3                   	ret    

c0100dfc <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dfc:	55                   	push   %ebp
c0100dfd:	89 e5                	mov    %esp,%ebp
c0100dff:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e02:	9c                   	pushf  
c0100e03:	58                   	pop    %eax
c0100e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e0a:	25 00 02 00 00       	and    $0x200,%eax
c0100e0f:	85 c0                	test   %eax,%eax
c0100e11:	74 0c                	je     c0100e1f <__intr_save+0x23>
        intr_disable();
c0100e13:	e8 a8 08 00 00       	call   c01016c0 <intr_disable>
        return 1;
c0100e18:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e1d:	eb 05                	jmp    c0100e24 <__intr_save+0x28>
    }
    return 0;
c0100e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e24:	c9                   	leave  
c0100e25:	c3                   	ret    

c0100e26 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e26:	55                   	push   %ebp
c0100e27:	89 e5                	mov    %esp,%ebp
c0100e29:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e30:	74 05                	je     c0100e37 <__intr_restore+0x11>
        intr_enable();
c0100e32:	e8 83 08 00 00       	call   c01016ba <intr_enable>
    }
}
c0100e37:	c9                   	leave  
c0100e38:	c3                   	ret    

c0100e39 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e39:	55                   	push   %ebp
c0100e3a:	89 e5                	mov    %esp,%ebp
c0100e3c:	83 ec 10             	sub    $0x10,%esp
c0100e3f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e45:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e49:	89 c2                	mov    %eax,%edx
c0100e4b:	ec                   	in     (%dx),%al
c0100e4c:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e55:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e59:	89 c2                	mov    %eax,%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e65:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e69:	89 c2                	mov    %eax,%edx
c0100e6b:	ec                   	in     (%dx),%al
c0100e6c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e79:	89 c2                	mov    %eax,%edx
c0100e7b:	ec                   	in     (%dx),%al
c0100e7c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7f:	c9                   	leave  
c0100e80:	c3                   	ret    

c0100e81 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e81:	55                   	push   %ebp
c0100e82:	89 e5                	mov    %esp,%ebp
c0100e84:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e87:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e91:	0f b7 00             	movzwl (%eax),%eax
c0100e94:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea3:	0f b7 00             	movzwl (%eax),%eax
c0100ea6:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eaa:	74 12                	je     c0100ebe <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eac:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb3:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100eba:	b4 03 
c0100ebc:	eb 13                	jmp    c0100ed1 <cga_init+0x50>
    } else {
        *cp = was;
c0100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec8:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ecf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed1:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ed8:	0f b7 c0             	movzwl %ax,%eax
c0100edb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100edf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eeb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eec:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ef3:	83 c0 01             	add    $0x1,%eax
c0100ef6:	0f b7 c0             	movzwl %ax,%eax
c0100ef9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efd:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f01:	89 c2                	mov    %eax,%edx
c0100f03:	ec                   	in     (%dx),%al
c0100f04:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f07:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0b:	0f b6 c0             	movzbl %al,%eax
c0100f0e:	c1 e0 08             	shl    $0x8,%eax
c0100f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f14:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f1b:	0f b7 c0             	movzwl %ax,%eax
c0100f1e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f22:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2f:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f36:	83 c0 01             	add    $0x1,%eax
c0100f39:	0f b7 c0             	movzwl %ax,%eax
c0100f3c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f40:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f44:	89 c2                	mov    %eax,%edx
c0100f46:	ec                   	in     (%dx),%al
c0100f47:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f4a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f4e:	0f b6 c0             	movzbl %al,%eax
c0100f51:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f57:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5f:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f65:	c9                   	leave  
c0100f66:	c3                   	ret    

c0100f67 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f67:	55                   	push   %ebp
c0100f68:	89 e5                	mov    %esp,%ebp
c0100f6a:	83 ec 48             	sub    $0x48,%esp
c0100f6d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f73:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f77:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7f:	ee                   	out    %al,(%dx)
c0100f80:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f86:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f8a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f8e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f92:	ee                   	out    %al,(%dx)
c0100f93:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f99:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f9d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa5:	ee                   	out    %al,(%dx)
c0100fa6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fac:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fb0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fb4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb8:	ee                   	out    %al,(%dx)
c0100fb9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fbf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fcb:	ee                   	out    %al,(%dx)
c0100fcc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fda:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fde:	ee                   	out    %al,(%dx)
c0100fdf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fed:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff1:	ee                   	out    %al,(%dx)
c0100ff2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ffc:	89 c2                	mov    %eax,%edx
c0100ffe:	ec                   	in     (%dx),%al
c0100fff:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101002:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101006:	3c ff                	cmp    $0xff,%al
c0101008:	0f 95 c0             	setne  %al
c010100b:	0f b6 c0             	movzbl %al,%eax
c010100e:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0101013:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101019:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010101d:	89 c2                	mov    %eax,%edx
c010101f:	ec                   	in     (%dx),%al
c0101020:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101023:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101029:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010102d:	89 c2                	mov    %eax,%edx
c010102f:	ec                   	in     (%dx),%al
c0101030:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101033:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101038:	85 c0                	test   %eax,%eax
c010103a:	74 0c                	je     c0101048 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010103c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101043:	e8 d6 06 00 00       	call   c010171e <pic_enable>
    }
}
c0101048:	c9                   	leave  
c0101049:	c3                   	ret    

c010104a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010104a:	55                   	push   %ebp
c010104b:	89 e5                	mov    %esp,%ebp
c010104d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101057:	eb 09                	jmp    c0101062 <lpt_putc_sub+0x18>
        delay();
c0101059:	e8 db fd ff ff       	call   c0100e39 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101062:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101068:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010106c:	89 c2                	mov    %eax,%edx
c010106e:	ec                   	in     (%dx),%al
c010106f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101072:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101076:	84 c0                	test   %al,%al
c0101078:	78 09                	js     c0101083 <lpt_putc_sub+0x39>
c010107a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101081:	7e d6                	jle    c0101059 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101083:	8b 45 08             	mov    0x8(%ebp),%eax
c0101086:	0f b6 c0             	movzbl %al,%eax
c0101089:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101092:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101096:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010109a:	ee                   	out    %al,(%dx)
c010109b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a1:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010ad:	ee                   	out    %al,(%dx)
c01010ae:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010b4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010bc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c1:	c9                   	leave  
c01010c2:	c3                   	ret    

c01010c3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c3:	55                   	push   %ebp
c01010c4:	89 e5                	mov    %esp,%ebp
c01010c6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010cd:	74 0d                	je     c01010dc <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d2:	89 04 24             	mov    %eax,(%esp)
c01010d5:	e8 70 ff ff ff       	call   c010104a <lpt_putc_sub>
c01010da:	eb 24                	jmp    c0101100 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e3:	e8 62 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ef:	e8 56 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fb:	e8 4a ff ff ff       	call   c010104a <lpt_putc_sub>
    }
}
c0101100:	c9                   	leave  
c0101101:	c3                   	ret    

c0101102 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101102:	55                   	push   %ebp
c0101103:	89 e5                	mov    %esp,%ebp
c0101105:	53                   	push   %ebx
c0101106:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101109:	8b 45 08             	mov    0x8(%ebp),%eax
c010110c:	b0 00                	mov    $0x0,%al
c010110e:	85 c0                	test   %eax,%eax
c0101110:	75 07                	jne    c0101119 <cga_putc+0x17>
        c |= 0x0700;
c0101112:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101119:	8b 45 08             	mov    0x8(%ebp),%eax
c010111c:	0f b6 c0             	movzbl %al,%eax
c010111f:	83 f8 0a             	cmp    $0xa,%eax
c0101122:	74 4c                	je     c0101170 <cga_putc+0x6e>
c0101124:	83 f8 0d             	cmp    $0xd,%eax
c0101127:	74 57                	je     c0101180 <cga_putc+0x7e>
c0101129:	83 f8 08             	cmp    $0x8,%eax
c010112c:	0f 85 88 00 00 00    	jne    c01011ba <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101132:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101139:	66 85 c0             	test   %ax,%ax
c010113c:	74 30                	je     c010116e <cga_putc+0x6c>
            crt_pos --;
c010113e:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101145:	83 e8 01             	sub    $0x1,%eax
c0101148:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010114e:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101153:	0f b7 15 44 a4 11 c0 	movzwl 0xc011a444,%edx
c010115a:	0f b7 d2             	movzwl %dx,%edx
c010115d:	01 d2                	add    %edx,%edx
c010115f:	01 c2                	add    %eax,%edx
c0101161:	8b 45 08             	mov    0x8(%ebp),%eax
c0101164:	b0 00                	mov    $0x0,%al
c0101166:	83 c8 20             	or     $0x20,%eax
c0101169:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010116c:	eb 72                	jmp    c01011e0 <cga_putc+0xde>
c010116e:	eb 70                	jmp    c01011e0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101170:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101177:	83 c0 50             	add    $0x50,%eax
c010117a:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101180:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c0101187:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c010118e:	0f b7 c1             	movzwl %cx,%eax
c0101191:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101197:	c1 e8 10             	shr    $0x10,%eax
c010119a:	89 c2                	mov    %eax,%edx
c010119c:	66 c1 ea 06          	shr    $0x6,%dx
c01011a0:	89 d0                	mov    %edx,%eax
c01011a2:	c1 e0 02             	shl    $0x2,%eax
c01011a5:	01 d0                	add    %edx,%eax
c01011a7:	c1 e0 04             	shl    $0x4,%eax
c01011aa:	29 c1                	sub    %eax,%ecx
c01011ac:	89 ca                	mov    %ecx,%edx
c01011ae:	89 d8                	mov    %ebx,%eax
c01011b0:	29 d0                	sub    %edx,%eax
c01011b2:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011b8:	eb 26                	jmp    c01011e0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ba:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011c0:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011c7:	8d 50 01             	lea    0x1(%eax),%edx
c01011ca:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011d1:	0f b7 c0             	movzwl %ax,%eax
c01011d4:	01 c0                	add    %eax,%eax
c01011d6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01011dc:	66 89 02             	mov    %ax,(%edx)
        break;
c01011df:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011e0:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011e7:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011eb:	76 5b                	jbe    c0101248 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ed:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011f2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f8:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011fd:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101204:	00 
c0101205:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101209:	89 04 24             	mov    %eax,(%esp)
c010120c:	e8 91 4a 00 00       	call   c0105ca2 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101211:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101218:	eb 15                	jmp    c010122f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010121a:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c010121f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101222:	01 d2                	add    %edx,%edx
c0101224:	01 d0                	add    %edx,%eax
c0101226:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101236:	7e e2                	jle    c010121a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101238:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010123f:	83 e8 50             	sub    $0x50,%eax
c0101242:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101248:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c010124f:	0f b7 c0             	movzwl %ax,%eax
c0101252:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101256:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010125a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010125e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101262:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101263:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010126a:	66 c1 e8 08          	shr    $0x8,%ax
c010126e:	0f b6 c0             	movzbl %al,%eax
c0101271:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c0101278:	83 c2 01             	add    $0x1,%edx
c010127b:	0f b7 d2             	movzwl %dx,%edx
c010127e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101282:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101285:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101289:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010128e:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101295:	0f b7 c0             	movzwl %ax,%eax
c0101298:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010129c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012a0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a9:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012b0:	0f b6 c0             	movzbl %al,%eax
c01012b3:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012ba:	83 c2 01             	add    $0x1,%edx
c01012bd:	0f b7 d2             	movzwl %dx,%edx
c01012c0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c4:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012cf:	ee                   	out    %al,(%dx)
}
c01012d0:	83 c4 34             	add    $0x34,%esp
c01012d3:	5b                   	pop    %ebx
c01012d4:	5d                   	pop    %ebp
c01012d5:	c3                   	ret    

c01012d6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d6:	55                   	push   %ebp
c01012d7:	89 e5                	mov    %esp,%ebp
c01012d9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e3:	eb 09                	jmp    c01012ee <serial_putc_sub+0x18>
        delay();
c01012e5:	e8 4f fb ff ff       	call   c0100e39 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f8:	89 c2                	mov    %eax,%edx
c01012fa:	ec                   	in     (%dx),%al
c01012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101302:	0f b6 c0             	movzbl %al,%eax
c0101305:	83 e0 20             	and    $0x20,%eax
c0101308:	85 c0                	test   %eax,%eax
c010130a:	75 09                	jne    c0101315 <serial_putc_sub+0x3f>
c010130c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101313:	7e d0                	jle    c01012e5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101315:	8b 45 08             	mov    0x8(%ebp),%eax
c0101318:	0f b6 c0             	movzbl %al,%eax
c010131b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101321:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101324:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101328:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132c:	ee                   	out    %al,(%dx)
}
c010132d:	c9                   	leave  
c010132e:	c3                   	ret    

c010132f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132f:	55                   	push   %ebp
c0101330:	89 e5                	mov    %esp,%ebp
c0101332:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101335:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101339:	74 0d                	je     c0101348 <serial_putc+0x19>
        serial_putc_sub(c);
c010133b:	8b 45 08             	mov    0x8(%ebp),%eax
c010133e:	89 04 24             	mov    %eax,(%esp)
c0101341:	e8 90 ff ff ff       	call   c01012d6 <serial_putc_sub>
c0101346:	eb 24                	jmp    c010136c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101348:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134f:	e8 82 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101354:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135b:	e8 76 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101360:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101367:	e8 6a ff ff ff       	call   c01012d6 <serial_putc_sub>
    }
}
c010136c:	c9                   	leave  
c010136d:	c3                   	ret    

c010136e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010136e:	55                   	push   %ebp
c010136f:	89 e5                	mov    %esp,%ebp
c0101371:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101374:	eb 33                	jmp    c01013a9 <cons_intr+0x3b>
        if (c != 0) {
c0101376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010137a:	74 2d                	je     c01013a9 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010137c:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101381:	8d 50 01             	lea    0x1(%eax),%edx
c0101384:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c010138a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010138d:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101393:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101398:	3d 00 02 00 00       	cmp    $0x200,%eax
c010139d:	75 0a                	jne    c01013a9 <cons_intr+0x3b>
                cons.wpos = 0;
c010139f:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01013a6:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ac:	ff d0                	call   *%eax
c01013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b5:	75 bf                	jne    c0101376 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b7:	c9                   	leave  
c01013b8:	c3                   	ret    

c01013b9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b9:	55                   	push   %ebp
c01013ba:	89 e5                	mov    %esp,%ebp
c01013bc:	83 ec 10             	sub    $0x10,%esp
c01013bf:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c9:	89 c2                	mov    %eax,%edx
c01013cb:	ec                   	in     (%dx),%al
c01013cc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013cf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d3:	0f b6 c0             	movzbl %al,%eax
c01013d6:	83 e0 01             	and    $0x1,%eax
c01013d9:	85 c0                	test   %eax,%eax
c01013db:	75 07                	jne    c01013e4 <serial_proc_data+0x2b>
        return -1;
c01013dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e2:	eb 2a                	jmp    c010140e <serial_proc_data+0x55>
c01013e4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ee:	89 c2                	mov    %eax,%edx
c01013f0:	ec                   	in     (%dx),%al
c01013f1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f8:	0f b6 c0             	movzbl %al,%eax
c01013fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013fe:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101402:	75 07                	jne    c010140b <serial_proc_data+0x52>
        c = '\b';
c0101404:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010140e:	c9                   	leave  
c010140f:	c3                   	ret    

c0101410 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101410:	55                   	push   %ebp
c0101411:	89 e5                	mov    %esp,%ebp
c0101413:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101416:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010141b:	85 c0                	test   %eax,%eax
c010141d:	74 0c                	je     c010142b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141f:	c7 04 24 b9 13 10 c0 	movl   $0xc01013b9,(%esp)
c0101426:	e8 43 ff ff ff       	call   c010136e <cons_intr>
    }
}
c010142b:	c9                   	leave  
c010142c:	c3                   	ret    

c010142d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010142d:	55                   	push   %ebp
c010142e:	89 e5                	mov    %esp,%ebp
c0101430:	83 ec 38             	sub    $0x38,%esp
c0101433:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101439:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143d:	89 c2                	mov    %eax,%edx
c010143f:	ec                   	in     (%dx),%al
c0101440:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101443:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101447:	0f b6 c0             	movzbl %al,%eax
c010144a:	83 e0 01             	and    $0x1,%eax
c010144d:	85 c0                	test   %eax,%eax
c010144f:	75 0a                	jne    c010145b <kbd_proc_data+0x2e>
        return -1;
c0101451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101456:	e9 59 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
c010145b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101461:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101465:	89 c2                	mov    %eax,%edx
c0101467:	ec                   	in     (%dx),%al
c0101468:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101472:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101476:	75 17                	jne    c010148f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101478:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010147d:	83 c8 40             	or     $0x40,%eax
c0101480:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c0101485:	b8 00 00 00 00       	mov    $0x0,%eax
c010148a:	e9 25 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101493:	84 c0                	test   %al,%al
c0101495:	79 47                	jns    c01014de <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101497:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010149c:	83 e0 40             	and    $0x40,%eax
c010149f:	85 c0                	test   %eax,%eax
c01014a1:	75 09                	jne    c01014ac <kbd_proc_data+0x7f>
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	83 e0 7f             	and    $0x7f,%eax
c01014aa:	eb 04                	jmp    c01014b0 <kbd_proc_data+0x83>
c01014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b7:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014be:	83 c8 40             	or     $0x40,%eax
c01014c1:	0f b6 c0             	movzbl %al,%eax
c01014c4:	f7 d0                	not    %eax
c01014c6:	89 c2                	mov    %eax,%edx
c01014c8:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014cd:	21 d0                	and    %edx,%eax
c01014cf:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014d4:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d9:	e9 d6 00 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014de:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014e3:	83 e0 40             	and    $0x40,%eax
c01014e6:	85 c0                	test   %eax,%eax
c01014e8:	74 11                	je     c01014fb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ea:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ee:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f3:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f6:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c01014fb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ff:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c0101506:	0f b6 d0             	movzbl %al,%edx
c0101509:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010150e:	09 d0                	or     %edx,%eax
c0101510:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c0101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101519:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101520:	0f b6 d0             	movzbl %al,%edx
c0101523:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101528:	31 d0                	xor    %edx,%eax
c010152a:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c010152f:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101534:	83 e0 03             	and    $0x3,%eax
c0101537:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c010153e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101542:	01 d0                	add    %edx,%eax
c0101544:	0f b6 00             	movzbl (%eax),%eax
c0101547:	0f b6 c0             	movzbl %al,%eax
c010154a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010154d:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101552:	83 e0 08             	and    $0x8,%eax
c0101555:	85 c0                	test   %eax,%eax
c0101557:	74 22                	je     c010157b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101559:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010155d:	7e 0c                	jle    c010156b <kbd_proc_data+0x13e>
c010155f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101563:	7f 06                	jg     c010156b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101565:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101569:	eb 10                	jmp    c010157b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156f:	7e 0a                	jle    c010157b <kbd_proc_data+0x14e>
c0101571:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101575:	7f 04                	jg     c010157b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101577:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157b:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101580:	f7 d0                	not    %eax
c0101582:	83 e0 06             	and    $0x6,%eax
c0101585:	85 c0                	test   %eax,%eax
c0101587:	75 28                	jne    c01015b1 <kbd_proc_data+0x184>
c0101589:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101590:	75 1f                	jne    c01015b1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101592:	c7 04 24 2f 61 10 c0 	movl   $0xc010612f,(%esp)
c0101599:	e8 aa ed ff ff       	call   c0100348 <cprintf>
c010159e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a4:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015ac:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015b0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b4:	c9                   	leave  
c01015b5:	c3                   	ret    

c01015b6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b6:	55                   	push   %ebp
c01015b7:	89 e5                	mov    %esp,%ebp
c01015b9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015bc:	c7 04 24 2d 14 10 c0 	movl   $0xc010142d,(%esp)
c01015c3:	e8 a6 fd ff ff       	call   c010136e <cons_intr>
}
c01015c8:	c9                   	leave  
c01015c9:	c3                   	ret    

c01015ca <kbd_init>:

static void
kbd_init(void) {
c01015ca:	55                   	push   %ebp
c01015cb:	89 e5                	mov    %esp,%ebp
c01015cd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015d0:	e8 e1 ff ff ff       	call   c01015b6 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015dc:	e8 3d 01 00 00       	call   c010171e <pic_enable>
}
c01015e1:	c9                   	leave  
c01015e2:	c3                   	ret    

c01015e3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e3:	55                   	push   %ebp
c01015e4:	89 e5                	mov    %esp,%ebp
c01015e6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e9:	e8 93 f8 ff ff       	call   c0100e81 <cga_init>
    serial_init();
c01015ee:	e8 74 f9 ff ff       	call   c0100f67 <serial_init>
    kbd_init();
c01015f3:	e8 d2 ff ff ff       	call   c01015ca <kbd_init>
    if (!serial_exists) {
c01015f8:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c01015fd:	85 c0                	test   %eax,%eax
c01015ff:	75 0c                	jne    c010160d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101601:	c7 04 24 3b 61 10 c0 	movl   $0xc010613b,(%esp)
c0101608:	e8 3b ed ff ff       	call   c0100348 <cprintf>
    }
}
c010160d:	c9                   	leave  
c010160e:	c3                   	ret    

c010160f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160f:	55                   	push   %ebp
c0101610:	89 e5                	mov    %esp,%ebp
c0101612:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101615:	e8 e2 f7 ff ff       	call   c0100dfc <__intr_save>
c010161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010161d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101620:	89 04 24             	mov    %eax,(%esp)
c0101623:	e8 9b fa ff ff       	call   c01010c3 <lpt_putc>
        cga_putc(c);
c0101628:	8b 45 08             	mov    0x8(%ebp),%eax
c010162b:	89 04 24             	mov    %eax,(%esp)
c010162e:	e8 cf fa ff ff       	call   c0101102 <cga_putc>
        serial_putc(c);
c0101633:	8b 45 08             	mov    0x8(%ebp),%eax
c0101636:	89 04 24             	mov    %eax,(%esp)
c0101639:	e8 f1 fc ff ff       	call   c010132f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101641:	89 04 24             	mov    %eax,(%esp)
c0101644:	e8 dd f7 ff ff       	call   c0100e26 <__intr_restore>
}
c0101649:	c9                   	leave  
c010164a:	c3                   	ret    

c010164b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164b:	55                   	push   %ebp
c010164c:	89 e5                	mov    %esp,%ebp
c010164e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101658:	e8 9f f7 ff ff       	call   c0100dfc <__intr_save>
c010165d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101660:	e8 ab fd ff ff       	call   c0101410 <serial_intr>
        kbd_intr();
c0101665:	e8 4c ff ff ff       	call   c01015b6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010166a:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101670:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101675:	39 c2                	cmp    %eax,%edx
c0101677:	74 31                	je     c01016aa <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101679:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c010167e:	8d 50 01             	lea    0x1(%eax),%edx
c0101681:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c0101687:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c010168e:	0f b6 c0             	movzbl %al,%eax
c0101691:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101694:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c0101699:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169e:	75 0a                	jne    c01016aa <cons_getc+0x5f>
                cons.rpos = 0;
c01016a0:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016a7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016ad:	89 04 24             	mov    %eax,(%esp)
c01016b0:	e8 71 f7 ff ff       	call   c0100e26 <__intr_restore>
    return c;
c01016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b8:	c9                   	leave  
c01016b9:	c3                   	ret    

c01016ba <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016ba:	55                   	push   %ebp
c01016bb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016bd:	fb                   	sti    
    sti();
}
c01016be:	5d                   	pop    %ebp
c01016bf:	c3                   	ret    

c01016c0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016c0:	55                   	push   %ebp
c01016c1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016c3:	fa                   	cli    
    cli();
}
c01016c4:	5d                   	pop    %ebp
c01016c5:	c3                   	ret    

c01016c6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016c6:	55                   	push   %ebp
c01016c7:	89 e5                	mov    %esp,%ebp
c01016c9:	83 ec 14             	sub    $0x14,%esp
c01016cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01016cf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016d3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d7:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016dd:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016e2:	85 c0                	test   %eax,%eax
c01016e4:	74 36                	je     c010171c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016e6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ea:	0f b6 c0             	movzbl %al,%eax
c01016ed:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016f3:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016f6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016fa:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016fe:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ff:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101703:	66 c1 e8 08          	shr    $0x8,%ax
c0101707:	0f b6 c0             	movzbl %al,%eax
c010170a:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101710:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101713:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101717:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010171b:	ee                   	out    %al,(%dx)
    }
}
c010171c:	c9                   	leave  
c010171d:	c3                   	ret    

c010171e <pic_enable>:

void
pic_enable(unsigned int irq) {
c010171e:	55                   	push   %ebp
c010171f:	89 e5                	mov    %esp,%ebp
c0101721:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101724:	8b 45 08             	mov    0x8(%ebp),%eax
c0101727:	ba 01 00 00 00       	mov    $0x1,%edx
c010172c:	89 c1                	mov    %eax,%ecx
c010172e:	d3 e2                	shl    %cl,%edx
c0101730:	89 d0                	mov    %edx,%eax
c0101732:	f7 d0                	not    %eax
c0101734:	89 c2                	mov    %eax,%edx
c0101736:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010173d:	21 d0                	and    %edx,%eax
c010173f:	0f b7 c0             	movzwl %ax,%eax
c0101742:	89 04 24             	mov    %eax,(%esp)
c0101745:	e8 7c ff ff ff       	call   c01016c6 <pic_setmask>
}
c010174a:	c9                   	leave  
c010174b:	c3                   	ret    

c010174c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010174c:	55                   	push   %ebp
c010174d:	89 e5                	mov    %esp,%ebp
c010174f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101752:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c0101759:	00 00 00 
c010175c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101762:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101766:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010176a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010176e:	ee                   	out    %al,(%dx)
c010176f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101775:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101779:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010177d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101781:	ee                   	out    %al,(%dx)
c0101782:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101788:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010178c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101790:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101794:	ee                   	out    %al,(%dx)
c0101795:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010179b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010179f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01017a3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017a7:	ee                   	out    %al,(%dx)
c01017a8:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017ae:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017b2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017b6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ba:	ee                   	out    %al,(%dx)
c01017bb:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017c1:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017c5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017c9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017cd:	ee                   	out    %al,(%dx)
c01017ce:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017d4:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017d8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017dc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017e0:	ee                   	out    %al,(%dx)
c01017e1:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017e7:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017eb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017ef:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017f3:	ee                   	out    %al,(%dx)
c01017f4:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017fa:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017fe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101802:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101806:	ee                   	out    %al,(%dx)
c0101807:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010180d:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101811:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101815:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101819:	ee                   	out    %al,(%dx)
c010181a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101820:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101824:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101828:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010182c:	ee                   	out    %al,(%dx)
c010182d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101833:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101837:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010183b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010183f:	ee                   	out    %al,(%dx)
c0101840:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101846:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010184a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010184e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101852:	ee                   	out    %al,(%dx)
c0101853:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101859:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010185d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101861:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101865:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101866:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010186d:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101871:	74 12                	je     c0101885 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101873:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010187a:	0f b7 c0             	movzwl %ax,%eax
c010187d:	89 04 24             	mov    %eax,(%esp)
c0101880:	e8 41 fe ff ff       	call   c01016c6 <pic_setmask>
    }
}
c0101885:	c9                   	leave  
c0101886:	c3                   	ret    

c0101887 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101887:	55                   	push   %ebp
c0101888:	89 e5                	mov    %esp,%ebp
c010188a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010188d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101894:	00 
c0101895:	c7 04 24 60 61 10 c0 	movl   $0xc0106160,(%esp)
c010189c:	e8 a7 ea ff ff       	call   c0100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01018a1:	c9                   	leave  
c01018a2:	c3                   	ret    

c01018a3 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018a3:	55                   	push   %ebp
c01018a4:	89 e5                	mov    %esp,%ebp
c01018a6:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {//在数组长度内初始化中断向量表
c01018a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018b0:	e9 c3 00 00 00       	jmp    c0101978 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);//使用非陷阱门描述符，在内核级设置中断向量表
c01018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b8:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018bf:	89 c2                	mov    %eax,%edx
c01018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c4:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c01018cb:	c0 
c01018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018cf:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c01018d6:	c0 08 00 
c01018d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018dc:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c01018e3:	c0 
c01018e4:	83 e2 e0             	and    $0xffffffe0,%edx
c01018e7:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c01018ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f1:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c01018f8:	c0 
c01018f9:	83 e2 1f             	and    $0x1f,%edx
c01018fc:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101906:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010190d:	c0 
c010190e:	83 e2 f0             	and    $0xfffffff0,%edx
c0101911:	83 ca 0e             	or     $0xe,%edx
c0101914:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010191b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191e:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101925:	c0 
c0101926:	83 e2 ef             	and    $0xffffffef,%edx
c0101929:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101930:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101933:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010193a:	c0 
c010193b:	83 e2 9f             	and    $0xffffff9f,%edx
c010193e:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101945:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101948:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010194f:	c0 
c0101950:	83 ca 80             	or     $0xffffff80,%edx
c0101953:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010195a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195d:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c0101964:	c1 e8 10             	shr    $0x10,%eax
c0101967:	89 c2                	mov    %eax,%edx
c0101969:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196c:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c0101973:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {//在数组长度内初始化中断向量表
c0101974:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197b:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101980:	0f 86 2f ff ff ff    	jbe    c01018b5 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);//使用非陷阱门描述符，在内核级设置中断向量表
	}
	// set for switch from user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);//设置用户级转向内核级的中断向量表
c0101986:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c010198b:	66 a3 48 aa 11 c0    	mov    %ax,0xc011aa48
c0101991:	66 c7 05 4a aa 11 c0 	movw   $0x8,0xc011aa4a
c0101998:	08 00 
c010199a:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019a1:	83 e0 e0             	and    $0xffffffe0,%eax
c01019a4:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019a9:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019b0:	83 e0 1f             	and    $0x1f,%eax
c01019b3:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019b8:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019bf:	83 e0 f0             	and    $0xfffffff0,%eax
c01019c2:	83 c8 0e             	or     $0xe,%eax
c01019c5:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c01019ca:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019d1:	83 e0 ef             	and    $0xffffffef,%eax
c01019d4:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c01019d9:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019e0:	83 c8 60             	or     $0x60,%eax
c01019e3:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c01019e8:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019ef:	83 c8 80             	or     $0xffffff80,%eax
c01019f2:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c01019f7:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c01019fc:	c1 e8 10             	shr    $0x10,%eax
c01019ff:	66 a3 4e aa 11 c0    	mov    %ax,0xc011aa4e
c0101a05:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a0f:	0f 01 18             	lidtl  (%eax)
	// load the IDT
	lidt(&idt_pd);//加载中断向量表
}
c0101a12:	c9                   	leave  
c0101a13:	c3                   	ret    

c0101a14 <trapname>:

static const char *
trapname(int trapno) {
c0101a14:	55                   	push   %ebp
c0101a15:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a17:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1a:	83 f8 13             	cmp    $0x13,%eax
c0101a1d:	77 0c                	ja     c0101a2b <trapname+0x17>
        return excnames[trapno];
c0101a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a22:	8b 04 85 c0 64 10 c0 	mov    -0x3fef9b40(,%eax,4),%eax
c0101a29:	eb 18                	jmp    c0101a43 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a2b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a2f:	7e 0d                	jle    c0101a3e <trapname+0x2a>
c0101a31:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a35:	7f 07                	jg     c0101a3e <trapname+0x2a>
        return "Hardware Interrupt";
c0101a37:	b8 6a 61 10 c0       	mov    $0xc010616a,%eax
c0101a3c:	eb 05                	jmp    c0101a43 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a3e:	b8 7d 61 10 c0       	mov    $0xc010617d,%eax
}
c0101a43:	5d                   	pop    %ebp
c0101a44:	c3                   	ret    

c0101a45 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a45:	55                   	push   %ebp
c0101a46:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a4f:	66 83 f8 08          	cmp    $0x8,%ax
c0101a53:	0f 94 c0             	sete   %al
c0101a56:	0f b6 c0             	movzbl %al,%eax
}
c0101a59:	5d                   	pop    %ebp
c0101a5a:	c3                   	ret    

c0101a5b <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a5b:	55                   	push   %ebp
c0101a5c:	89 e5                	mov    %esp,%ebp
c0101a5e:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a68:	c7 04 24 be 61 10 c0 	movl   $0xc01061be,(%esp)
c0101a6f:	e8 d4 e8 ff ff       	call   c0100348 <cprintf>
    print_regs(&tf->tf_regs);
c0101a74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a77:	89 04 24             	mov    %eax,(%esp)
c0101a7a:	e8 a1 01 00 00       	call   c0101c20 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a82:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a86:	0f b7 c0             	movzwl %ax,%eax
c0101a89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a8d:	c7 04 24 cf 61 10 c0 	movl   $0xc01061cf,(%esp)
c0101a94:	e8 af e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101aa0:	0f b7 c0             	movzwl %ax,%eax
c0101aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa7:	c7 04 24 e2 61 10 c0 	movl   $0xc01061e2,(%esp)
c0101aae:	e8 95 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab6:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aba:	0f b7 c0             	movzwl %ax,%eax
c0101abd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac1:	c7 04 24 f5 61 10 c0 	movl   $0xc01061f5,(%esp)
c0101ac8:	e8 7b e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad0:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ad4:	0f b7 c0             	movzwl %ax,%eax
c0101ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101adb:	c7 04 24 08 62 10 c0 	movl   $0xc0106208,(%esp)
c0101ae2:	e8 61 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aea:	8b 40 30             	mov    0x30(%eax),%eax
c0101aed:	89 04 24             	mov    %eax,(%esp)
c0101af0:	e8 1f ff ff ff       	call   c0101a14 <trapname>
c0101af5:	8b 55 08             	mov    0x8(%ebp),%edx
c0101af8:	8b 52 30             	mov    0x30(%edx),%edx
c0101afb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101aff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b03:	c7 04 24 1b 62 10 c0 	movl   $0xc010621b,(%esp)
c0101b0a:	e8 39 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b12:	8b 40 34             	mov    0x34(%eax),%eax
c0101b15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b19:	c7 04 24 2d 62 10 c0 	movl   $0xc010622d,(%esp)
c0101b20:	e8 23 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b28:	8b 40 38             	mov    0x38(%eax),%eax
c0101b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b2f:	c7 04 24 3c 62 10 c0 	movl   $0xc010623c,(%esp)
c0101b36:	e8 0d e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b42:	0f b7 c0             	movzwl %ax,%eax
c0101b45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b49:	c7 04 24 4b 62 10 c0 	movl   $0xc010624b,(%esp)
c0101b50:	e8 f3 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b58:	8b 40 40             	mov    0x40(%eax),%eax
c0101b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5f:	c7 04 24 5e 62 10 c0 	movl   $0xc010625e,(%esp)
c0101b66:	e8 dd e7 ff ff       	call   c0100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b72:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b79:	eb 3e                	jmp    c0101bb9 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7e:	8b 50 40             	mov    0x40(%eax),%edx
c0101b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b84:	21 d0                	and    %edx,%eax
c0101b86:	85 c0                	test   %eax,%eax
c0101b88:	74 28                	je     c0101bb2 <print_trapframe+0x157>
c0101b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b8d:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b94:	85 c0                	test   %eax,%eax
c0101b96:	74 1a                	je     c0101bb2 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b9b:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba6:	c7 04 24 6d 62 10 c0 	movl   $0xc010626d,(%esp)
c0101bad:	e8 96 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bb2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bb6:	d1 65 f0             	shll   -0x10(%ebp)
c0101bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bbc:	83 f8 17             	cmp    $0x17,%eax
c0101bbf:	76 ba                	jbe    c0101b7b <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc4:	8b 40 40             	mov    0x40(%eax),%eax
c0101bc7:	25 00 30 00 00       	and    $0x3000,%eax
c0101bcc:	c1 e8 0c             	shr    $0xc,%eax
c0101bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd3:	c7 04 24 71 62 10 c0 	movl   $0xc0106271,(%esp)
c0101bda:	e8 69 e7 ff ff       	call   c0100348 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be2:	89 04 24             	mov    %eax,(%esp)
c0101be5:	e8 5b fe ff ff       	call   c0101a45 <trap_in_kernel>
c0101bea:	85 c0                	test   %eax,%eax
c0101bec:	75 30                	jne    c0101c1e <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101bee:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf1:	8b 40 44             	mov    0x44(%eax),%eax
c0101bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf8:	c7 04 24 7a 62 10 c0 	movl   $0xc010627a,(%esp)
c0101bff:	e8 44 e7 ff ff       	call   c0100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c07:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c0b:	0f b7 c0             	movzwl %ax,%eax
c0101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c12:	c7 04 24 89 62 10 c0 	movl   $0xc0106289,(%esp)
c0101c19:	e8 2a e7 ff ff       	call   c0100348 <cprintf>
    }
}
c0101c1e:	c9                   	leave  
c0101c1f:	c3                   	ret    

c0101c20 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c20:	55                   	push   %ebp
c0101c21:	89 e5                	mov    %esp,%ebp
c0101c23:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c26:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c29:	8b 00                	mov    (%eax),%eax
c0101c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2f:	c7 04 24 9c 62 10 c0 	movl   $0xc010629c,(%esp)
c0101c36:	e8 0d e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3e:	8b 40 04             	mov    0x4(%eax),%eax
c0101c41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c45:	c7 04 24 ab 62 10 c0 	movl   $0xc01062ab,(%esp)
c0101c4c:	e8 f7 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c54:	8b 40 08             	mov    0x8(%eax),%eax
c0101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5b:	c7 04 24 ba 62 10 c0 	movl   $0xc01062ba,(%esp)
c0101c62:	e8 e1 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6a:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c71:	c7 04 24 c9 62 10 c0 	movl   $0xc01062c9,(%esp)
c0101c78:	e8 cb e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c80:	8b 40 10             	mov    0x10(%eax),%eax
c0101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c87:	c7 04 24 d8 62 10 c0 	movl   $0xc01062d8,(%esp)
c0101c8e:	e8 b5 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c96:	8b 40 14             	mov    0x14(%eax),%eax
c0101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9d:	c7 04 24 e7 62 10 c0 	movl   $0xc01062e7,(%esp)
c0101ca4:	e8 9f e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cac:	8b 40 18             	mov    0x18(%eax),%eax
c0101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb3:	c7 04 24 f6 62 10 c0 	movl   $0xc01062f6,(%esp)
c0101cba:	e8 89 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc2:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc9:	c7 04 24 05 63 10 c0 	movl   $0xc0106305,(%esp)
c0101cd0:	e8 73 e6 ff ff       	call   c0100348 <cprintf>
}
c0101cd5:	c9                   	leave  
c0101cd6:	c3                   	ret    

c0101cd7 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cd7:	55                   	push   %ebp
c0101cd8:	89 e5                	mov    %esp,%ebp
c0101cda:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce0:	8b 40 30             	mov    0x30(%eax),%eax
c0101ce3:	83 f8 2f             	cmp    $0x2f,%eax
c0101ce6:	77 21                	ja     c0101d09 <trap_dispatch+0x32>
c0101ce8:	83 f8 2e             	cmp    $0x2e,%eax
c0101ceb:	0f 83 04 01 00 00    	jae    c0101df5 <trap_dispatch+0x11e>
c0101cf1:	83 f8 21             	cmp    $0x21,%eax
c0101cf4:	0f 84 81 00 00 00    	je     c0101d7b <trap_dispatch+0xa4>
c0101cfa:	83 f8 24             	cmp    $0x24,%eax
c0101cfd:	74 56                	je     c0101d55 <trap_dispatch+0x7e>
c0101cff:	83 f8 20             	cmp    $0x20,%eax
c0101d02:	74 16                	je     c0101d1a <trap_dispatch+0x43>
c0101d04:	e9 b4 00 00 00       	jmp    c0101dbd <trap_dispatch+0xe6>
c0101d09:	83 e8 78             	sub    $0x78,%eax
c0101d0c:	83 f8 01             	cmp    $0x1,%eax
c0101d0f:	0f 87 a8 00 00 00    	ja     c0101dbd <trap_dispatch+0xe6>
c0101d15:	e9 87 00 00 00       	jmp    c0101da1 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
c0101d1a:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101d1f:	83 c0 01             	add    $0x1,%eax
c0101d22:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
	if(ticks%TICK_NUM == 0)
c0101d27:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101d2d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d32:	89 c8                	mov    %ecx,%eax
c0101d34:	f7 e2                	mul    %edx
c0101d36:	89 d0                	mov    %edx,%eax
c0101d38:	c1 e8 05             	shr    $0x5,%eax
c0101d3b:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d3e:	29 c1                	sub    %eax,%ecx
c0101d40:	89 c8                	mov    %ecx,%eax
c0101d42:	85 c0                	test   %eax,%eax
c0101d44:	75 0a                	jne    c0101d50 <trap_dispatch+0x79>
        {
            print_ticks();
c0101d46:	e8 3c fb ff ff       	call   c0101887 <print_ticks>
        }
        break;
c0101d4b:	e9 a6 00 00 00       	jmp    c0101df6 <trap_dispatch+0x11f>
c0101d50:	e9 a1 00 00 00       	jmp    c0101df6 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d55:	e8 f1 f8 ff ff       	call   c010164b <cons_getc>
c0101d5a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d5d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d61:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d65:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d6d:	c7 04 24 14 63 10 c0 	movl   $0xc0106314,(%esp)
c0101d74:	e8 cf e5 ff ff       	call   c0100348 <cprintf>
        break;
c0101d79:	eb 7b                	jmp    c0101df6 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d7b:	e8 cb f8 ff ff       	call   c010164b <cons_getc>
c0101d80:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d83:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d87:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d8b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d93:	c7 04 24 26 63 10 c0 	movl   $0xc0106326,(%esp)
c0101d9a:	e8 a9 e5 ff ff       	call   c0100348 <cprintf>
        break;
c0101d9f:	eb 55                	jmp    c0101df6 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101da1:	c7 44 24 08 35 63 10 	movl   $0xc0106335,0x8(%esp)
c0101da8:	c0 
c0101da9:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0101db0:	00 
c0101db1:	c7 04 24 45 63 10 c0 	movl   $0xc0106345,(%esp)
c0101db8:	e8 0f ef ff ff       	call   c0100ccc <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101dbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dc4:	0f b7 c0             	movzwl %ax,%eax
c0101dc7:	83 e0 03             	and    $0x3,%eax
c0101dca:	85 c0                	test   %eax,%eax
c0101dcc:	75 28                	jne    c0101df6 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101dce:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dd1:	89 04 24             	mov    %eax,(%esp)
c0101dd4:	e8 82 fc ff ff       	call   c0101a5b <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101dd9:	c7 44 24 08 56 63 10 	movl   $0xc0106356,0x8(%esp)
c0101de0:	c0 
c0101de1:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0101de8:	00 
c0101de9:	c7 04 24 45 63 10 c0 	movl   $0xc0106345,(%esp)
c0101df0:	e8 d7 ee ff ff       	call   c0100ccc <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101df5:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101df6:	c9                   	leave  
c0101df7:	c3                   	ret    

c0101df8 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101df8:	55                   	push   %ebp
c0101df9:	89 e5                	mov    %esp,%ebp
c0101dfb:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101dfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e01:	89 04 24             	mov    %eax,(%esp)
c0101e04:	e8 ce fe ff ff       	call   c0101cd7 <trap_dispatch>
}
c0101e09:	c9                   	leave  
c0101e0a:	c3                   	ret    

c0101e0b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e0b:	1e                   	push   %ds
    pushl %es
c0101e0c:	06                   	push   %es
    pushl %fs
c0101e0d:	0f a0                	push   %fs
    pushl %gs
c0101e0f:	0f a8                	push   %gs
    pushal
c0101e11:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e12:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e17:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e19:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e1b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e1c:	e8 d7 ff ff ff       	call   c0101df8 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e21:	5c                   	pop    %esp

c0101e22 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e22:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e23:	0f a9                	pop    %gs
    popl %fs
c0101e25:	0f a1                	pop    %fs
    popl %es
c0101e27:	07                   	pop    %es
    popl %ds
c0101e28:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e29:	83 c4 08             	add    $0x8,%esp
    iret
c0101e2c:	cf                   	iret   

c0101e2d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e2d:	6a 00                	push   $0x0
  pushl $0
c0101e2f:	6a 00                	push   $0x0
  jmp __alltraps
c0101e31:	e9 d5 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e36 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e36:	6a 00                	push   $0x0
  pushl $1
c0101e38:	6a 01                	push   $0x1
  jmp __alltraps
c0101e3a:	e9 cc ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e3f <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e3f:	6a 00                	push   $0x0
  pushl $2
c0101e41:	6a 02                	push   $0x2
  jmp __alltraps
c0101e43:	e9 c3 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e48 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e48:	6a 00                	push   $0x0
  pushl $3
c0101e4a:	6a 03                	push   $0x3
  jmp __alltraps
c0101e4c:	e9 ba ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e51 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e51:	6a 00                	push   $0x0
  pushl $4
c0101e53:	6a 04                	push   $0x4
  jmp __alltraps
c0101e55:	e9 b1 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e5a <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e5a:	6a 00                	push   $0x0
  pushl $5
c0101e5c:	6a 05                	push   $0x5
  jmp __alltraps
c0101e5e:	e9 a8 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e63 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e63:	6a 00                	push   $0x0
  pushl $6
c0101e65:	6a 06                	push   $0x6
  jmp __alltraps
c0101e67:	e9 9f ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e6c <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e6c:	6a 00                	push   $0x0
  pushl $7
c0101e6e:	6a 07                	push   $0x7
  jmp __alltraps
c0101e70:	e9 96 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e75 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e75:	6a 08                	push   $0x8
  jmp __alltraps
c0101e77:	e9 8f ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e7c <vector9>:
.globl vector9
vector9:
  pushl $0
c0101e7c:	6a 00                	push   $0x0
  pushl $9
c0101e7e:	6a 09                	push   $0x9
  jmp __alltraps
c0101e80:	e9 86 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e85 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e85:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e87:	e9 7f ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e8c <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e8c:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e8e:	e9 78 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e93 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e93:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e95:	e9 71 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101e9a <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e9a:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e9c:	e9 6a ff ff ff       	jmp    c0101e0b <__alltraps>

c0101ea1 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ea1:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ea3:	e9 63 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101ea8 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101ea8:	6a 00                	push   $0x0
  pushl $15
c0101eaa:	6a 0f                	push   $0xf
  jmp __alltraps
c0101eac:	e9 5a ff ff ff       	jmp    c0101e0b <__alltraps>

c0101eb1 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101eb1:	6a 00                	push   $0x0
  pushl $16
c0101eb3:	6a 10                	push   $0x10
  jmp __alltraps
c0101eb5:	e9 51 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101eba <vector17>:
.globl vector17
vector17:
  pushl $17
c0101eba:	6a 11                	push   $0x11
  jmp __alltraps
c0101ebc:	e9 4a ff ff ff       	jmp    c0101e0b <__alltraps>

c0101ec1 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101ec1:	6a 00                	push   $0x0
  pushl $18
c0101ec3:	6a 12                	push   $0x12
  jmp __alltraps
c0101ec5:	e9 41 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101eca <vector19>:
.globl vector19
vector19:
  pushl $0
c0101eca:	6a 00                	push   $0x0
  pushl $19
c0101ecc:	6a 13                	push   $0x13
  jmp __alltraps
c0101ece:	e9 38 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101ed3 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101ed3:	6a 00                	push   $0x0
  pushl $20
c0101ed5:	6a 14                	push   $0x14
  jmp __alltraps
c0101ed7:	e9 2f ff ff ff       	jmp    c0101e0b <__alltraps>

c0101edc <vector21>:
.globl vector21
vector21:
  pushl $0
c0101edc:	6a 00                	push   $0x0
  pushl $21
c0101ede:	6a 15                	push   $0x15
  jmp __alltraps
c0101ee0:	e9 26 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101ee5 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101ee5:	6a 00                	push   $0x0
  pushl $22
c0101ee7:	6a 16                	push   $0x16
  jmp __alltraps
c0101ee9:	e9 1d ff ff ff       	jmp    c0101e0b <__alltraps>

c0101eee <vector23>:
.globl vector23
vector23:
  pushl $0
c0101eee:	6a 00                	push   $0x0
  pushl $23
c0101ef0:	6a 17                	push   $0x17
  jmp __alltraps
c0101ef2:	e9 14 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101ef7 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ef7:	6a 00                	push   $0x0
  pushl $24
c0101ef9:	6a 18                	push   $0x18
  jmp __alltraps
c0101efb:	e9 0b ff ff ff       	jmp    c0101e0b <__alltraps>

c0101f00 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f00:	6a 00                	push   $0x0
  pushl $25
c0101f02:	6a 19                	push   $0x19
  jmp __alltraps
c0101f04:	e9 02 ff ff ff       	jmp    c0101e0b <__alltraps>

c0101f09 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f09:	6a 00                	push   $0x0
  pushl $26
c0101f0b:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f0d:	e9 f9 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f12 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f12:	6a 00                	push   $0x0
  pushl $27
c0101f14:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f16:	e9 f0 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f1b <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f1b:	6a 00                	push   $0x0
  pushl $28
c0101f1d:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f1f:	e9 e7 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f24 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f24:	6a 00                	push   $0x0
  pushl $29
c0101f26:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f28:	e9 de fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f2d <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f2d:	6a 00                	push   $0x0
  pushl $30
c0101f2f:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f31:	e9 d5 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f36 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f36:	6a 00                	push   $0x0
  pushl $31
c0101f38:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f3a:	e9 cc fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f3f <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f3f:	6a 00                	push   $0x0
  pushl $32
c0101f41:	6a 20                	push   $0x20
  jmp __alltraps
c0101f43:	e9 c3 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f48 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f48:	6a 00                	push   $0x0
  pushl $33
c0101f4a:	6a 21                	push   $0x21
  jmp __alltraps
c0101f4c:	e9 ba fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f51 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f51:	6a 00                	push   $0x0
  pushl $34
c0101f53:	6a 22                	push   $0x22
  jmp __alltraps
c0101f55:	e9 b1 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f5a <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f5a:	6a 00                	push   $0x0
  pushl $35
c0101f5c:	6a 23                	push   $0x23
  jmp __alltraps
c0101f5e:	e9 a8 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f63 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f63:	6a 00                	push   $0x0
  pushl $36
c0101f65:	6a 24                	push   $0x24
  jmp __alltraps
c0101f67:	e9 9f fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f6c <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f6c:	6a 00                	push   $0x0
  pushl $37
c0101f6e:	6a 25                	push   $0x25
  jmp __alltraps
c0101f70:	e9 96 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f75 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f75:	6a 00                	push   $0x0
  pushl $38
c0101f77:	6a 26                	push   $0x26
  jmp __alltraps
c0101f79:	e9 8d fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f7e <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f7e:	6a 00                	push   $0x0
  pushl $39
c0101f80:	6a 27                	push   $0x27
  jmp __alltraps
c0101f82:	e9 84 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f87 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f87:	6a 00                	push   $0x0
  pushl $40
c0101f89:	6a 28                	push   $0x28
  jmp __alltraps
c0101f8b:	e9 7b fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f90 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f90:	6a 00                	push   $0x0
  pushl $41
c0101f92:	6a 29                	push   $0x29
  jmp __alltraps
c0101f94:	e9 72 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101f99 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f99:	6a 00                	push   $0x0
  pushl $42
c0101f9b:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f9d:	e9 69 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101fa2 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fa2:	6a 00                	push   $0x0
  pushl $43
c0101fa4:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fa6:	e9 60 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101fab <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fab:	6a 00                	push   $0x0
  pushl $44
c0101fad:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101faf:	e9 57 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101fb4 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fb4:	6a 00                	push   $0x0
  pushl $45
c0101fb6:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fb8:	e9 4e fe ff ff       	jmp    c0101e0b <__alltraps>

c0101fbd <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fbd:	6a 00                	push   $0x0
  pushl $46
c0101fbf:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fc1:	e9 45 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101fc6 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $47
c0101fc8:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fca:	e9 3c fe ff ff       	jmp    c0101e0b <__alltraps>

c0101fcf <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $48
c0101fd1:	6a 30                	push   $0x30
  jmp __alltraps
c0101fd3:	e9 33 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101fd8 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $49
c0101fda:	6a 31                	push   $0x31
  jmp __alltraps
c0101fdc:	e9 2a fe ff ff       	jmp    c0101e0b <__alltraps>

c0101fe1 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $50
c0101fe3:	6a 32                	push   $0x32
  jmp __alltraps
c0101fe5:	e9 21 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101fea <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $51
c0101fec:	6a 33                	push   $0x33
  jmp __alltraps
c0101fee:	e9 18 fe ff ff       	jmp    c0101e0b <__alltraps>

c0101ff3 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $52
c0101ff5:	6a 34                	push   $0x34
  jmp __alltraps
c0101ff7:	e9 0f fe ff ff       	jmp    c0101e0b <__alltraps>

c0101ffc <vector53>:
.globl vector53
vector53:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $53
c0101ffe:	6a 35                	push   $0x35
  jmp __alltraps
c0102000:	e9 06 fe ff ff       	jmp    c0101e0b <__alltraps>

c0102005 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $54
c0102007:	6a 36                	push   $0x36
  jmp __alltraps
c0102009:	e9 fd fd ff ff       	jmp    c0101e0b <__alltraps>

c010200e <vector55>:
.globl vector55
vector55:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $55
c0102010:	6a 37                	push   $0x37
  jmp __alltraps
c0102012:	e9 f4 fd ff ff       	jmp    c0101e0b <__alltraps>

c0102017 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $56
c0102019:	6a 38                	push   $0x38
  jmp __alltraps
c010201b:	e9 eb fd ff ff       	jmp    c0101e0b <__alltraps>

c0102020 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $57
c0102022:	6a 39                	push   $0x39
  jmp __alltraps
c0102024:	e9 e2 fd ff ff       	jmp    c0101e0b <__alltraps>

c0102029 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $58
c010202b:	6a 3a                	push   $0x3a
  jmp __alltraps
c010202d:	e9 d9 fd ff ff       	jmp    c0101e0b <__alltraps>

c0102032 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $59
c0102034:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102036:	e9 d0 fd ff ff       	jmp    c0101e0b <__alltraps>

c010203b <vector60>:
.globl vector60
vector60:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $60
c010203d:	6a 3c                	push   $0x3c
  jmp __alltraps
c010203f:	e9 c7 fd ff ff       	jmp    c0101e0b <__alltraps>

c0102044 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $61
c0102046:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102048:	e9 be fd ff ff       	jmp    c0101e0b <__alltraps>

c010204d <vector62>:
.globl vector62
vector62:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $62
c010204f:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102051:	e9 b5 fd ff ff       	jmp    c0101e0b <__alltraps>

c0102056 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $63
c0102058:	6a 3f                	push   $0x3f
  jmp __alltraps
c010205a:	e9 ac fd ff ff       	jmp    c0101e0b <__alltraps>

c010205f <vector64>:
.globl vector64
vector64:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $64
c0102061:	6a 40                	push   $0x40
  jmp __alltraps
c0102063:	e9 a3 fd ff ff       	jmp    c0101e0b <__alltraps>

c0102068 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $65
c010206a:	6a 41                	push   $0x41
  jmp __alltraps
c010206c:	e9 9a fd ff ff       	jmp    c0101e0b <__alltraps>

c0102071 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $66
c0102073:	6a 42                	push   $0x42
  jmp __alltraps
c0102075:	e9 91 fd ff ff       	jmp    c0101e0b <__alltraps>

c010207a <vector67>:
.globl vector67
vector67:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $67
c010207c:	6a 43                	push   $0x43
  jmp __alltraps
c010207e:	e9 88 fd ff ff       	jmp    c0101e0b <__alltraps>

c0102083 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $68
c0102085:	6a 44                	push   $0x44
  jmp __alltraps
c0102087:	e9 7f fd ff ff       	jmp    c0101e0b <__alltraps>

c010208c <vector69>:
.globl vector69
vector69:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $69
c010208e:	6a 45                	push   $0x45
  jmp __alltraps
c0102090:	e9 76 fd ff ff       	jmp    c0101e0b <__alltraps>

c0102095 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $70
c0102097:	6a 46                	push   $0x46
  jmp __alltraps
c0102099:	e9 6d fd ff ff       	jmp    c0101e0b <__alltraps>

c010209e <vector71>:
.globl vector71
vector71:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $71
c01020a0:	6a 47                	push   $0x47
  jmp __alltraps
c01020a2:	e9 64 fd ff ff       	jmp    c0101e0b <__alltraps>

c01020a7 <vector72>:
.globl vector72
vector72:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $72
c01020a9:	6a 48                	push   $0x48
  jmp __alltraps
c01020ab:	e9 5b fd ff ff       	jmp    c0101e0b <__alltraps>

c01020b0 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $73
c01020b2:	6a 49                	push   $0x49
  jmp __alltraps
c01020b4:	e9 52 fd ff ff       	jmp    c0101e0b <__alltraps>

c01020b9 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $74
c01020bb:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020bd:	e9 49 fd ff ff       	jmp    c0101e0b <__alltraps>

c01020c2 <vector75>:
.globl vector75
vector75:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $75
c01020c4:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020c6:	e9 40 fd ff ff       	jmp    c0101e0b <__alltraps>

c01020cb <vector76>:
.globl vector76
vector76:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $76
c01020cd:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020cf:	e9 37 fd ff ff       	jmp    c0101e0b <__alltraps>

c01020d4 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $77
c01020d6:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020d8:	e9 2e fd ff ff       	jmp    c0101e0b <__alltraps>

c01020dd <vector78>:
.globl vector78
vector78:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $78
c01020df:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020e1:	e9 25 fd ff ff       	jmp    c0101e0b <__alltraps>

c01020e6 <vector79>:
.globl vector79
vector79:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $79
c01020e8:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020ea:	e9 1c fd ff ff       	jmp    c0101e0b <__alltraps>

c01020ef <vector80>:
.globl vector80
vector80:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $80
c01020f1:	6a 50                	push   $0x50
  jmp __alltraps
c01020f3:	e9 13 fd ff ff       	jmp    c0101e0b <__alltraps>

c01020f8 <vector81>:
.globl vector81
vector81:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $81
c01020fa:	6a 51                	push   $0x51
  jmp __alltraps
c01020fc:	e9 0a fd ff ff       	jmp    c0101e0b <__alltraps>

c0102101 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $82
c0102103:	6a 52                	push   $0x52
  jmp __alltraps
c0102105:	e9 01 fd ff ff       	jmp    c0101e0b <__alltraps>

c010210a <vector83>:
.globl vector83
vector83:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $83
c010210c:	6a 53                	push   $0x53
  jmp __alltraps
c010210e:	e9 f8 fc ff ff       	jmp    c0101e0b <__alltraps>

c0102113 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $84
c0102115:	6a 54                	push   $0x54
  jmp __alltraps
c0102117:	e9 ef fc ff ff       	jmp    c0101e0b <__alltraps>

c010211c <vector85>:
.globl vector85
vector85:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $85
c010211e:	6a 55                	push   $0x55
  jmp __alltraps
c0102120:	e9 e6 fc ff ff       	jmp    c0101e0b <__alltraps>

c0102125 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $86
c0102127:	6a 56                	push   $0x56
  jmp __alltraps
c0102129:	e9 dd fc ff ff       	jmp    c0101e0b <__alltraps>

c010212e <vector87>:
.globl vector87
vector87:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $87
c0102130:	6a 57                	push   $0x57
  jmp __alltraps
c0102132:	e9 d4 fc ff ff       	jmp    c0101e0b <__alltraps>

c0102137 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $88
c0102139:	6a 58                	push   $0x58
  jmp __alltraps
c010213b:	e9 cb fc ff ff       	jmp    c0101e0b <__alltraps>

c0102140 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $89
c0102142:	6a 59                	push   $0x59
  jmp __alltraps
c0102144:	e9 c2 fc ff ff       	jmp    c0101e0b <__alltraps>

c0102149 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $90
c010214b:	6a 5a                	push   $0x5a
  jmp __alltraps
c010214d:	e9 b9 fc ff ff       	jmp    c0101e0b <__alltraps>

c0102152 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $91
c0102154:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102156:	e9 b0 fc ff ff       	jmp    c0101e0b <__alltraps>

c010215b <vector92>:
.globl vector92
vector92:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $92
c010215d:	6a 5c                	push   $0x5c
  jmp __alltraps
c010215f:	e9 a7 fc ff ff       	jmp    c0101e0b <__alltraps>

c0102164 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $93
c0102166:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102168:	e9 9e fc ff ff       	jmp    c0101e0b <__alltraps>

c010216d <vector94>:
.globl vector94
vector94:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $94
c010216f:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102171:	e9 95 fc ff ff       	jmp    c0101e0b <__alltraps>

c0102176 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $95
c0102178:	6a 5f                	push   $0x5f
  jmp __alltraps
c010217a:	e9 8c fc ff ff       	jmp    c0101e0b <__alltraps>

c010217f <vector96>:
.globl vector96
vector96:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $96
c0102181:	6a 60                	push   $0x60
  jmp __alltraps
c0102183:	e9 83 fc ff ff       	jmp    c0101e0b <__alltraps>

c0102188 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $97
c010218a:	6a 61                	push   $0x61
  jmp __alltraps
c010218c:	e9 7a fc ff ff       	jmp    c0101e0b <__alltraps>

c0102191 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $98
c0102193:	6a 62                	push   $0x62
  jmp __alltraps
c0102195:	e9 71 fc ff ff       	jmp    c0101e0b <__alltraps>

c010219a <vector99>:
.globl vector99
vector99:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $99
c010219c:	6a 63                	push   $0x63
  jmp __alltraps
c010219e:	e9 68 fc ff ff       	jmp    c0101e0b <__alltraps>

c01021a3 <vector100>:
.globl vector100
vector100:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $100
c01021a5:	6a 64                	push   $0x64
  jmp __alltraps
c01021a7:	e9 5f fc ff ff       	jmp    c0101e0b <__alltraps>

c01021ac <vector101>:
.globl vector101
vector101:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $101
c01021ae:	6a 65                	push   $0x65
  jmp __alltraps
c01021b0:	e9 56 fc ff ff       	jmp    c0101e0b <__alltraps>

c01021b5 <vector102>:
.globl vector102
vector102:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $102
c01021b7:	6a 66                	push   $0x66
  jmp __alltraps
c01021b9:	e9 4d fc ff ff       	jmp    c0101e0b <__alltraps>

c01021be <vector103>:
.globl vector103
vector103:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $103
c01021c0:	6a 67                	push   $0x67
  jmp __alltraps
c01021c2:	e9 44 fc ff ff       	jmp    c0101e0b <__alltraps>

c01021c7 <vector104>:
.globl vector104
vector104:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $104
c01021c9:	6a 68                	push   $0x68
  jmp __alltraps
c01021cb:	e9 3b fc ff ff       	jmp    c0101e0b <__alltraps>

c01021d0 <vector105>:
.globl vector105
vector105:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $105
c01021d2:	6a 69                	push   $0x69
  jmp __alltraps
c01021d4:	e9 32 fc ff ff       	jmp    c0101e0b <__alltraps>

c01021d9 <vector106>:
.globl vector106
vector106:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $106
c01021db:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021dd:	e9 29 fc ff ff       	jmp    c0101e0b <__alltraps>

c01021e2 <vector107>:
.globl vector107
vector107:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $107
c01021e4:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021e6:	e9 20 fc ff ff       	jmp    c0101e0b <__alltraps>

c01021eb <vector108>:
.globl vector108
vector108:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $108
c01021ed:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021ef:	e9 17 fc ff ff       	jmp    c0101e0b <__alltraps>

c01021f4 <vector109>:
.globl vector109
vector109:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $109
c01021f6:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021f8:	e9 0e fc ff ff       	jmp    c0101e0b <__alltraps>

c01021fd <vector110>:
.globl vector110
vector110:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $110
c01021ff:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102201:	e9 05 fc ff ff       	jmp    c0101e0b <__alltraps>

c0102206 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $111
c0102208:	6a 6f                	push   $0x6f
  jmp __alltraps
c010220a:	e9 fc fb ff ff       	jmp    c0101e0b <__alltraps>

c010220f <vector112>:
.globl vector112
vector112:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $112
c0102211:	6a 70                	push   $0x70
  jmp __alltraps
c0102213:	e9 f3 fb ff ff       	jmp    c0101e0b <__alltraps>

c0102218 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $113
c010221a:	6a 71                	push   $0x71
  jmp __alltraps
c010221c:	e9 ea fb ff ff       	jmp    c0101e0b <__alltraps>

c0102221 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $114
c0102223:	6a 72                	push   $0x72
  jmp __alltraps
c0102225:	e9 e1 fb ff ff       	jmp    c0101e0b <__alltraps>

c010222a <vector115>:
.globl vector115
vector115:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $115
c010222c:	6a 73                	push   $0x73
  jmp __alltraps
c010222e:	e9 d8 fb ff ff       	jmp    c0101e0b <__alltraps>

c0102233 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $116
c0102235:	6a 74                	push   $0x74
  jmp __alltraps
c0102237:	e9 cf fb ff ff       	jmp    c0101e0b <__alltraps>

c010223c <vector117>:
.globl vector117
vector117:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $117
c010223e:	6a 75                	push   $0x75
  jmp __alltraps
c0102240:	e9 c6 fb ff ff       	jmp    c0101e0b <__alltraps>

c0102245 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $118
c0102247:	6a 76                	push   $0x76
  jmp __alltraps
c0102249:	e9 bd fb ff ff       	jmp    c0101e0b <__alltraps>

c010224e <vector119>:
.globl vector119
vector119:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $119
c0102250:	6a 77                	push   $0x77
  jmp __alltraps
c0102252:	e9 b4 fb ff ff       	jmp    c0101e0b <__alltraps>

c0102257 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102257:	6a 00                	push   $0x0
  pushl $120
c0102259:	6a 78                	push   $0x78
  jmp __alltraps
c010225b:	e9 ab fb ff ff       	jmp    c0101e0b <__alltraps>

c0102260 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $121
c0102262:	6a 79                	push   $0x79
  jmp __alltraps
c0102264:	e9 a2 fb ff ff       	jmp    c0101e0b <__alltraps>

c0102269 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $122
c010226b:	6a 7a                	push   $0x7a
  jmp __alltraps
c010226d:	e9 99 fb ff ff       	jmp    c0101e0b <__alltraps>

c0102272 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $123
c0102274:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102276:	e9 90 fb ff ff       	jmp    c0101e0b <__alltraps>

c010227b <vector124>:
.globl vector124
vector124:
  pushl $0
c010227b:	6a 00                	push   $0x0
  pushl $124
c010227d:	6a 7c                	push   $0x7c
  jmp __alltraps
c010227f:	e9 87 fb ff ff       	jmp    c0101e0b <__alltraps>

c0102284 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $125
c0102286:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102288:	e9 7e fb ff ff       	jmp    c0101e0b <__alltraps>

c010228d <vector126>:
.globl vector126
vector126:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $126
c010228f:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102291:	e9 75 fb ff ff       	jmp    c0101e0b <__alltraps>

c0102296 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $127
c0102298:	6a 7f                	push   $0x7f
  jmp __alltraps
c010229a:	e9 6c fb ff ff       	jmp    c0101e0b <__alltraps>

c010229f <vector128>:
.globl vector128
vector128:
  pushl $0
c010229f:	6a 00                	push   $0x0
  pushl $128
c01022a1:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022a6:	e9 60 fb ff ff       	jmp    c0101e0b <__alltraps>

c01022ab <vector129>:
.globl vector129
vector129:
  pushl $0
c01022ab:	6a 00                	push   $0x0
  pushl $129
c01022ad:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022b2:	e9 54 fb ff ff       	jmp    c0101e0b <__alltraps>

c01022b7 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022b7:	6a 00                	push   $0x0
  pushl $130
c01022b9:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022be:	e9 48 fb ff ff       	jmp    c0101e0b <__alltraps>

c01022c3 <vector131>:
.globl vector131
vector131:
  pushl $0
c01022c3:	6a 00                	push   $0x0
  pushl $131
c01022c5:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022ca:	e9 3c fb ff ff       	jmp    c0101e0b <__alltraps>

c01022cf <vector132>:
.globl vector132
vector132:
  pushl $0
c01022cf:	6a 00                	push   $0x0
  pushl $132
c01022d1:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022d6:	e9 30 fb ff ff       	jmp    c0101e0b <__alltraps>

c01022db <vector133>:
.globl vector133
vector133:
  pushl $0
c01022db:	6a 00                	push   $0x0
  pushl $133
c01022dd:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022e2:	e9 24 fb ff ff       	jmp    c0101e0b <__alltraps>

c01022e7 <vector134>:
.globl vector134
vector134:
  pushl $0
c01022e7:	6a 00                	push   $0x0
  pushl $134
c01022e9:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022ee:	e9 18 fb ff ff       	jmp    c0101e0b <__alltraps>

c01022f3 <vector135>:
.globl vector135
vector135:
  pushl $0
c01022f3:	6a 00                	push   $0x0
  pushl $135
c01022f5:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022fa:	e9 0c fb ff ff       	jmp    c0101e0b <__alltraps>

c01022ff <vector136>:
.globl vector136
vector136:
  pushl $0
c01022ff:	6a 00                	push   $0x0
  pushl $136
c0102301:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102306:	e9 00 fb ff ff       	jmp    c0101e0b <__alltraps>

c010230b <vector137>:
.globl vector137
vector137:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $137
c010230d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102312:	e9 f4 fa ff ff       	jmp    c0101e0b <__alltraps>

c0102317 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102317:	6a 00                	push   $0x0
  pushl $138
c0102319:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010231e:	e9 e8 fa ff ff       	jmp    c0101e0b <__alltraps>

c0102323 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102323:	6a 00                	push   $0x0
  pushl $139
c0102325:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010232a:	e9 dc fa ff ff       	jmp    c0101e0b <__alltraps>

c010232f <vector140>:
.globl vector140
vector140:
  pushl $0
c010232f:	6a 00                	push   $0x0
  pushl $140
c0102331:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102336:	e9 d0 fa ff ff       	jmp    c0101e0b <__alltraps>

c010233b <vector141>:
.globl vector141
vector141:
  pushl $0
c010233b:	6a 00                	push   $0x0
  pushl $141
c010233d:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102342:	e9 c4 fa ff ff       	jmp    c0101e0b <__alltraps>

c0102347 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102347:	6a 00                	push   $0x0
  pushl $142
c0102349:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010234e:	e9 b8 fa ff ff       	jmp    c0101e0b <__alltraps>

c0102353 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102353:	6a 00                	push   $0x0
  pushl $143
c0102355:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010235a:	e9 ac fa ff ff       	jmp    c0101e0b <__alltraps>

c010235f <vector144>:
.globl vector144
vector144:
  pushl $0
c010235f:	6a 00                	push   $0x0
  pushl $144
c0102361:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102366:	e9 a0 fa ff ff       	jmp    c0101e0b <__alltraps>

c010236b <vector145>:
.globl vector145
vector145:
  pushl $0
c010236b:	6a 00                	push   $0x0
  pushl $145
c010236d:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102372:	e9 94 fa ff ff       	jmp    c0101e0b <__alltraps>

c0102377 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102377:	6a 00                	push   $0x0
  pushl $146
c0102379:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010237e:	e9 88 fa ff ff       	jmp    c0101e0b <__alltraps>

c0102383 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102383:	6a 00                	push   $0x0
  pushl $147
c0102385:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010238a:	e9 7c fa ff ff       	jmp    c0101e0b <__alltraps>

c010238f <vector148>:
.globl vector148
vector148:
  pushl $0
c010238f:	6a 00                	push   $0x0
  pushl $148
c0102391:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102396:	e9 70 fa ff ff       	jmp    c0101e0b <__alltraps>

c010239b <vector149>:
.globl vector149
vector149:
  pushl $0
c010239b:	6a 00                	push   $0x0
  pushl $149
c010239d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023a2:	e9 64 fa ff ff       	jmp    c0101e0b <__alltraps>

c01023a7 <vector150>:
.globl vector150
vector150:
  pushl $0
c01023a7:	6a 00                	push   $0x0
  pushl $150
c01023a9:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023ae:	e9 58 fa ff ff       	jmp    c0101e0b <__alltraps>

c01023b3 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023b3:	6a 00                	push   $0x0
  pushl $151
c01023b5:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023ba:	e9 4c fa ff ff       	jmp    c0101e0b <__alltraps>

c01023bf <vector152>:
.globl vector152
vector152:
  pushl $0
c01023bf:	6a 00                	push   $0x0
  pushl $152
c01023c1:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023c6:	e9 40 fa ff ff       	jmp    c0101e0b <__alltraps>

c01023cb <vector153>:
.globl vector153
vector153:
  pushl $0
c01023cb:	6a 00                	push   $0x0
  pushl $153
c01023cd:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023d2:	e9 34 fa ff ff       	jmp    c0101e0b <__alltraps>

c01023d7 <vector154>:
.globl vector154
vector154:
  pushl $0
c01023d7:	6a 00                	push   $0x0
  pushl $154
c01023d9:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023de:	e9 28 fa ff ff       	jmp    c0101e0b <__alltraps>

c01023e3 <vector155>:
.globl vector155
vector155:
  pushl $0
c01023e3:	6a 00                	push   $0x0
  pushl $155
c01023e5:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023ea:	e9 1c fa ff ff       	jmp    c0101e0b <__alltraps>

c01023ef <vector156>:
.globl vector156
vector156:
  pushl $0
c01023ef:	6a 00                	push   $0x0
  pushl $156
c01023f1:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023f6:	e9 10 fa ff ff       	jmp    c0101e0b <__alltraps>

c01023fb <vector157>:
.globl vector157
vector157:
  pushl $0
c01023fb:	6a 00                	push   $0x0
  pushl $157
c01023fd:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102402:	e9 04 fa ff ff       	jmp    c0101e0b <__alltraps>

c0102407 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102407:	6a 00                	push   $0x0
  pushl $158
c0102409:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010240e:	e9 f8 f9 ff ff       	jmp    c0101e0b <__alltraps>

c0102413 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102413:	6a 00                	push   $0x0
  pushl $159
c0102415:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010241a:	e9 ec f9 ff ff       	jmp    c0101e0b <__alltraps>

c010241f <vector160>:
.globl vector160
vector160:
  pushl $0
c010241f:	6a 00                	push   $0x0
  pushl $160
c0102421:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102426:	e9 e0 f9 ff ff       	jmp    c0101e0b <__alltraps>

c010242b <vector161>:
.globl vector161
vector161:
  pushl $0
c010242b:	6a 00                	push   $0x0
  pushl $161
c010242d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102432:	e9 d4 f9 ff ff       	jmp    c0101e0b <__alltraps>

c0102437 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102437:	6a 00                	push   $0x0
  pushl $162
c0102439:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010243e:	e9 c8 f9 ff ff       	jmp    c0101e0b <__alltraps>

c0102443 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102443:	6a 00                	push   $0x0
  pushl $163
c0102445:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010244a:	e9 bc f9 ff ff       	jmp    c0101e0b <__alltraps>

c010244f <vector164>:
.globl vector164
vector164:
  pushl $0
c010244f:	6a 00                	push   $0x0
  pushl $164
c0102451:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102456:	e9 b0 f9 ff ff       	jmp    c0101e0b <__alltraps>

c010245b <vector165>:
.globl vector165
vector165:
  pushl $0
c010245b:	6a 00                	push   $0x0
  pushl $165
c010245d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102462:	e9 a4 f9 ff ff       	jmp    c0101e0b <__alltraps>

c0102467 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102467:	6a 00                	push   $0x0
  pushl $166
c0102469:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c010246e:	e9 98 f9 ff ff       	jmp    c0101e0b <__alltraps>

c0102473 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102473:	6a 00                	push   $0x0
  pushl $167
c0102475:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010247a:	e9 8c f9 ff ff       	jmp    c0101e0b <__alltraps>

c010247f <vector168>:
.globl vector168
vector168:
  pushl $0
c010247f:	6a 00                	push   $0x0
  pushl $168
c0102481:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102486:	e9 80 f9 ff ff       	jmp    c0101e0b <__alltraps>

c010248b <vector169>:
.globl vector169
vector169:
  pushl $0
c010248b:	6a 00                	push   $0x0
  pushl $169
c010248d:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102492:	e9 74 f9 ff ff       	jmp    c0101e0b <__alltraps>

c0102497 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102497:	6a 00                	push   $0x0
  pushl $170
c0102499:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010249e:	e9 68 f9 ff ff       	jmp    c0101e0b <__alltraps>

c01024a3 <vector171>:
.globl vector171
vector171:
  pushl $0
c01024a3:	6a 00                	push   $0x0
  pushl $171
c01024a5:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024aa:	e9 5c f9 ff ff       	jmp    c0101e0b <__alltraps>

c01024af <vector172>:
.globl vector172
vector172:
  pushl $0
c01024af:	6a 00                	push   $0x0
  pushl $172
c01024b1:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024b6:	e9 50 f9 ff ff       	jmp    c0101e0b <__alltraps>

c01024bb <vector173>:
.globl vector173
vector173:
  pushl $0
c01024bb:	6a 00                	push   $0x0
  pushl $173
c01024bd:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024c2:	e9 44 f9 ff ff       	jmp    c0101e0b <__alltraps>

c01024c7 <vector174>:
.globl vector174
vector174:
  pushl $0
c01024c7:	6a 00                	push   $0x0
  pushl $174
c01024c9:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024ce:	e9 38 f9 ff ff       	jmp    c0101e0b <__alltraps>

c01024d3 <vector175>:
.globl vector175
vector175:
  pushl $0
c01024d3:	6a 00                	push   $0x0
  pushl $175
c01024d5:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024da:	e9 2c f9 ff ff       	jmp    c0101e0b <__alltraps>

c01024df <vector176>:
.globl vector176
vector176:
  pushl $0
c01024df:	6a 00                	push   $0x0
  pushl $176
c01024e1:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024e6:	e9 20 f9 ff ff       	jmp    c0101e0b <__alltraps>

c01024eb <vector177>:
.globl vector177
vector177:
  pushl $0
c01024eb:	6a 00                	push   $0x0
  pushl $177
c01024ed:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024f2:	e9 14 f9 ff ff       	jmp    c0101e0b <__alltraps>

c01024f7 <vector178>:
.globl vector178
vector178:
  pushl $0
c01024f7:	6a 00                	push   $0x0
  pushl $178
c01024f9:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024fe:	e9 08 f9 ff ff       	jmp    c0101e0b <__alltraps>

c0102503 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102503:	6a 00                	push   $0x0
  pushl $179
c0102505:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010250a:	e9 fc f8 ff ff       	jmp    c0101e0b <__alltraps>

c010250f <vector180>:
.globl vector180
vector180:
  pushl $0
c010250f:	6a 00                	push   $0x0
  pushl $180
c0102511:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102516:	e9 f0 f8 ff ff       	jmp    c0101e0b <__alltraps>

c010251b <vector181>:
.globl vector181
vector181:
  pushl $0
c010251b:	6a 00                	push   $0x0
  pushl $181
c010251d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102522:	e9 e4 f8 ff ff       	jmp    c0101e0b <__alltraps>

c0102527 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102527:	6a 00                	push   $0x0
  pushl $182
c0102529:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010252e:	e9 d8 f8 ff ff       	jmp    c0101e0b <__alltraps>

c0102533 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102533:	6a 00                	push   $0x0
  pushl $183
c0102535:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010253a:	e9 cc f8 ff ff       	jmp    c0101e0b <__alltraps>

c010253f <vector184>:
.globl vector184
vector184:
  pushl $0
c010253f:	6a 00                	push   $0x0
  pushl $184
c0102541:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102546:	e9 c0 f8 ff ff       	jmp    c0101e0b <__alltraps>

c010254b <vector185>:
.globl vector185
vector185:
  pushl $0
c010254b:	6a 00                	push   $0x0
  pushl $185
c010254d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102552:	e9 b4 f8 ff ff       	jmp    c0101e0b <__alltraps>

c0102557 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102557:	6a 00                	push   $0x0
  pushl $186
c0102559:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010255e:	e9 a8 f8 ff ff       	jmp    c0101e0b <__alltraps>

c0102563 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102563:	6a 00                	push   $0x0
  pushl $187
c0102565:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010256a:	e9 9c f8 ff ff       	jmp    c0101e0b <__alltraps>

c010256f <vector188>:
.globl vector188
vector188:
  pushl $0
c010256f:	6a 00                	push   $0x0
  pushl $188
c0102571:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102576:	e9 90 f8 ff ff       	jmp    c0101e0b <__alltraps>

c010257b <vector189>:
.globl vector189
vector189:
  pushl $0
c010257b:	6a 00                	push   $0x0
  pushl $189
c010257d:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102582:	e9 84 f8 ff ff       	jmp    c0101e0b <__alltraps>

c0102587 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102587:	6a 00                	push   $0x0
  pushl $190
c0102589:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010258e:	e9 78 f8 ff ff       	jmp    c0101e0b <__alltraps>

c0102593 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102593:	6a 00                	push   $0x0
  pushl $191
c0102595:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010259a:	e9 6c f8 ff ff       	jmp    c0101e0b <__alltraps>

c010259f <vector192>:
.globl vector192
vector192:
  pushl $0
c010259f:	6a 00                	push   $0x0
  pushl $192
c01025a1:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025a6:	e9 60 f8 ff ff       	jmp    c0101e0b <__alltraps>

c01025ab <vector193>:
.globl vector193
vector193:
  pushl $0
c01025ab:	6a 00                	push   $0x0
  pushl $193
c01025ad:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025b2:	e9 54 f8 ff ff       	jmp    c0101e0b <__alltraps>

c01025b7 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025b7:	6a 00                	push   $0x0
  pushl $194
c01025b9:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025be:	e9 48 f8 ff ff       	jmp    c0101e0b <__alltraps>

c01025c3 <vector195>:
.globl vector195
vector195:
  pushl $0
c01025c3:	6a 00                	push   $0x0
  pushl $195
c01025c5:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025ca:	e9 3c f8 ff ff       	jmp    c0101e0b <__alltraps>

c01025cf <vector196>:
.globl vector196
vector196:
  pushl $0
c01025cf:	6a 00                	push   $0x0
  pushl $196
c01025d1:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025d6:	e9 30 f8 ff ff       	jmp    c0101e0b <__alltraps>

c01025db <vector197>:
.globl vector197
vector197:
  pushl $0
c01025db:	6a 00                	push   $0x0
  pushl $197
c01025dd:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025e2:	e9 24 f8 ff ff       	jmp    c0101e0b <__alltraps>

c01025e7 <vector198>:
.globl vector198
vector198:
  pushl $0
c01025e7:	6a 00                	push   $0x0
  pushl $198
c01025e9:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025ee:	e9 18 f8 ff ff       	jmp    c0101e0b <__alltraps>

c01025f3 <vector199>:
.globl vector199
vector199:
  pushl $0
c01025f3:	6a 00                	push   $0x0
  pushl $199
c01025f5:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025fa:	e9 0c f8 ff ff       	jmp    c0101e0b <__alltraps>

c01025ff <vector200>:
.globl vector200
vector200:
  pushl $0
c01025ff:	6a 00                	push   $0x0
  pushl $200
c0102601:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102606:	e9 00 f8 ff ff       	jmp    c0101e0b <__alltraps>

c010260b <vector201>:
.globl vector201
vector201:
  pushl $0
c010260b:	6a 00                	push   $0x0
  pushl $201
c010260d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102612:	e9 f4 f7 ff ff       	jmp    c0101e0b <__alltraps>

c0102617 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102617:	6a 00                	push   $0x0
  pushl $202
c0102619:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010261e:	e9 e8 f7 ff ff       	jmp    c0101e0b <__alltraps>

c0102623 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102623:	6a 00                	push   $0x0
  pushl $203
c0102625:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010262a:	e9 dc f7 ff ff       	jmp    c0101e0b <__alltraps>

c010262f <vector204>:
.globl vector204
vector204:
  pushl $0
c010262f:	6a 00                	push   $0x0
  pushl $204
c0102631:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102636:	e9 d0 f7 ff ff       	jmp    c0101e0b <__alltraps>

c010263b <vector205>:
.globl vector205
vector205:
  pushl $0
c010263b:	6a 00                	push   $0x0
  pushl $205
c010263d:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102642:	e9 c4 f7 ff ff       	jmp    c0101e0b <__alltraps>

c0102647 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102647:	6a 00                	push   $0x0
  pushl $206
c0102649:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010264e:	e9 b8 f7 ff ff       	jmp    c0101e0b <__alltraps>

c0102653 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102653:	6a 00                	push   $0x0
  pushl $207
c0102655:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010265a:	e9 ac f7 ff ff       	jmp    c0101e0b <__alltraps>

c010265f <vector208>:
.globl vector208
vector208:
  pushl $0
c010265f:	6a 00                	push   $0x0
  pushl $208
c0102661:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102666:	e9 a0 f7 ff ff       	jmp    c0101e0b <__alltraps>

c010266b <vector209>:
.globl vector209
vector209:
  pushl $0
c010266b:	6a 00                	push   $0x0
  pushl $209
c010266d:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102672:	e9 94 f7 ff ff       	jmp    c0101e0b <__alltraps>

c0102677 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102677:	6a 00                	push   $0x0
  pushl $210
c0102679:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010267e:	e9 88 f7 ff ff       	jmp    c0101e0b <__alltraps>

c0102683 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102683:	6a 00                	push   $0x0
  pushl $211
c0102685:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010268a:	e9 7c f7 ff ff       	jmp    c0101e0b <__alltraps>

c010268f <vector212>:
.globl vector212
vector212:
  pushl $0
c010268f:	6a 00                	push   $0x0
  pushl $212
c0102691:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102696:	e9 70 f7 ff ff       	jmp    c0101e0b <__alltraps>

c010269b <vector213>:
.globl vector213
vector213:
  pushl $0
c010269b:	6a 00                	push   $0x0
  pushl $213
c010269d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026a2:	e9 64 f7 ff ff       	jmp    c0101e0b <__alltraps>

c01026a7 <vector214>:
.globl vector214
vector214:
  pushl $0
c01026a7:	6a 00                	push   $0x0
  pushl $214
c01026a9:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026ae:	e9 58 f7 ff ff       	jmp    c0101e0b <__alltraps>

c01026b3 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026b3:	6a 00                	push   $0x0
  pushl $215
c01026b5:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026ba:	e9 4c f7 ff ff       	jmp    c0101e0b <__alltraps>

c01026bf <vector216>:
.globl vector216
vector216:
  pushl $0
c01026bf:	6a 00                	push   $0x0
  pushl $216
c01026c1:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026c6:	e9 40 f7 ff ff       	jmp    c0101e0b <__alltraps>

c01026cb <vector217>:
.globl vector217
vector217:
  pushl $0
c01026cb:	6a 00                	push   $0x0
  pushl $217
c01026cd:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026d2:	e9 34 f7 ff ff       	jmp    c0101e0b <__alltraps>

c01026d7 <vector218>:
.globl vector218
vector218:
  pushl $0
c01026d7:	6a 00                	push   $0x0
  pushl $218
c01026d9:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026de:	e9 28 f7 ff ff       	jmp    c0101e0b <__alltraps>

c01026e3 <vector219>:
.globl vector219
vector219:
  pushl $0
c01026e3:	6a 00                	push   $0x0
  pushl $219
c01026e5:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026ea:	e9 1c f7 ff ff       	jmp    c0101e0b <__alltraps>

c01026ef <vector220>:
.globl vector220
vector220:
  pushl $0
c01026ef:	6a 00                	push   $0x0
  pushl $220
c01026f1:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026f6:	e9 10 f7 ff ff       	jmp    c0101e0b <__alltraps>

c01026fb <vector221>:
.globl vector221
vector221:
  pushl $0
c01026fb:	6a 00                	push   $0x0
  pushl $221
c01026fd:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102702:	e9 04 f7 ff ff       	jmp    c0101e0b <__alltraps>

c0102707 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102707:	6a 00                	push   $0x0
  pushl $222
c0102709:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010270e:	e9 f8 f6 ff ff       	jmp    c0101e0b <__alltraps>

c0102713 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102713:	6a 00                	push   $0x0
  pushl $223
c0102715:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010271a:	e9 ec f6 ff ff       	jmp    c0101e0b <__alltraps>

c010271f <vector224>:
.globl vector224
vector224:
  pushl $0
c010271f:	6a 00                	push   $0x0
  pushl $224
c0102721:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102726:	e9 e0 f6 ff ff       	jmp    c0101e0b <__alltraps>

c010272b <vector225>:
.globl vector225
vector225:
  pushl $0
c010272b:	6a 00                	push   $0x0
  pushl $225
c010272d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102732:	e9 d4 f6 ff ff       	jmp    c0101e0b <__alltraps>

c0102737 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102737:	6a 00                	push   $0x0
  pushl $226
c0102739:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010273e:	e9 c8 f6 ff ff       	jmp    c0101e0b <__alltraps>

c0102743 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102743:	6a 00                	push   $0x0
  pushl $227
c0102745:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010274a:	e9 bc f6 ff ff       	jmp    c0101e0b <__alltraps>

c010274f <vector228>:
.globl vector228
vector228:
  pushl $0
c010274f:	6a 00                	push   $0x0
  pushl $228
c0102751:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102756:	e9 b0 f6 ff ff       	jmp    c0101e0b <__alltraps>

c010275b <vector229>:
.globl vector229
vector229:
  pushl $0
c010275b:	6a 00                	push   $0x0
  pushl $229
c010275d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102762:	e9 a4 f6 ff ff       	jmp    c0101e0b <__alltraps>

c0102767 <vector230>:
.globl vector230
vector230:
  pushl $0
c0102767:	6a 00                	push   $0x0
  pushl $230
c0102769:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c010276e:	e9 98 f6 ff ff       	jmp    c0101e0b <__alltraps>

c0102773 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102773:	6a 00                	push   $0x0
  pushl $231
c0102775:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010277a:	e9 8c f6 ff ff       	jmp    c0101e0b <__alltraps>

c010277f <vector232>:
.globl vector232
vector232:
  pushl $0
c010277f:	6a 00                	push   $0x0
  pushl $232
c0102781:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102786:	e9 80 f6 ff ff       	jmp    c0101e0b <__alltraps>

c010278b <vector233>:
.globl vector233
vector233:
  pushl $0
c010278b:	6a 00                	push   $0x0
  pushl $233
c010278d:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102792:	e9 74 f6 ff ff       	jmp    c0101e0b <__alltraps>

c0102797 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102797:	6a 00                	push   $0x0
  pushl $234
c0102799:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010279e:	e9 68 f6 ff ff       	jmp    c0101e0b <__alltraps>

c01027a3 <vector235>:
.globl vector235
vector235:
  pushl $0
c01027a3:	6a 00                	push   $0x0
  pushl $235
c01027a5:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027aa:	e9 5c f6 ff ff       	jmp    c0101e0b <__alltraps>

c01027af <vector236>:
.globl vector236
vector236:
  pushl $0
c01027af:	6a 00                	push   $0x0
  pushl $236
c01027b1:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027b6:	e9 50 f6 ff ff       	jmp    c0101e0b <__alltraps>

c01027bb <vector237>:
.globl vector237
vector237:
  pushl $0
c01027bb:	6a 00                	push   $0x0
  pushl $237
c01027bd:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027c2:	e9 44 f6 ff ff       	jmp    c0101e0b <__alltraps>

c01027c7 <vector238>:
.globl vector238
vector238:
  pushl $0
c01027c7:	6a 00                	push   $0x0
  pushl $238
c01027c9:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027ce:	e9 38 f6 ff ff       	jmp    c0101e0b <__alltraps>

c01027d3 <vector239>:
.globl vector239
vector239:
  pushl $0
c01027d3:	6a 00                	push   $0x0
  pushl $239
c01027d5:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027da:	e9 2c f6 ff ff       	jmp    c0101e0b <__alltraps>

c01027df <vector240>:
.globl vector240
vector240:
  pushl $0
c01027df:	6a 00                	push   $0x0
  pushl $240
c01027e1:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027e6:	e9 20 f6 ff ff       	jmp    c0101e0b <__alltraps>

c01027eb <vector241>:
.globl vector241
vector241:
  pushl $0
c01027eb:	6a 00                	push   $0x0
  pushl $241
c01027ed:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027f2:	e9 14 f6 ff ff       	jmp    c0101e0b <__alltraps>

c01027f7 <vector242>:
.globl vector242
vector242:
  pushl $0
c01027f7:	6a 00                	push   $0x0
  pushl $242
c01027f9:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027fe:	e9 08 f6 ff ff       	jmp    c0101e0b <__alltraps>

c0102803 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102803:	6a 00                	push   $0x0
  pushl $243
c0102805:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010280a:	e9 fc f5 ff ff       	jmp    c0101e0b <__alltraps>

c010280f <vector244>:
.globl vector244
vector244:
  pushl $0
c010280f:	6a 00                	push   $0x0
  pushl $244
c0102811:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102816:	e9 f0 f5 ff ff       	jmp    c0101e0b <__alltraps>

c010281b <vector245>:
.globl vector245
vector245:
  pushl $0
c010281b:	6a 00                	push   $0x0
  pushl $245
c010281d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102822:	e9 e4 f5 ff ff       	jmp    c0101e0b <__alltraps>

c0102827 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102827:	6a 00                	push   $0x0
  pushl $246
c0102829:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010282e:	e9 d8 f5 ff ff       	jmp    c0101e0b <__alltraps>

c0102833 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102833:	6a 00                	push   $0x0
  pushl $247
c0102835:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010283a:	e9 cc f5 ff ff       	jmp    c0101e0b <__alltraps>

c010283f <vector248>:
.globl vector248
vector248:
  pushl $0
c010283f:	6a 00                	push   $0x0
  pushl $248
c0102841:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102846:	e9 c0 f5 ff ff       	jmp    c0101e0b <__alltraps>

c010284b <vector249>:
.globl vector249
vector249:
  pushl $0
c010284b:	6a 00                	push   $0x0
  pushl $249
c010284d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102852:	e9 b4 f5 ff ff       	jmp    c0101e0b <__alltraps>

c0102857 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102857:	6a 00                	push   $0x0
  pushl $250
c0102859:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010285e:	e9 a8 f5 ff ff       	jmp    c0101e0b <__alltraps>

c0102863 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102863:	6a 00                	push   $0x0
  pushl $251
c0102865:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010286a:	e9 9c f5 ff ff       	jmp    c0101e0b <__alltraps>

c010286f <vector252>:
.globl vector252
vector252:
  pushl $0
c010286f:	6a 00                	push   $0x0
  pushl $252
c0102871:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102876:	e9 90 f5 ff ff       	jmp    c0101e0b <__alltraps>

c010287b <vector253>:
.globl vector253
vector253:
  pushl $0
c010287b:	6a 00                	push   $0x0
  pushl $253
c010287d:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102882:	e9 84 f5 ff ff       	jmp    c0101e0b <__alltraps>

c0102887 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102887:	6a 00                	push   $0x0
  pushl $254
c0102889:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010288e:	e9 78 f5 ff ff       	jmp    c0101e0b <__alltraps>

c0102893 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102893:	6a 00                	push   $0x0
  pushl $255
c0102895:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010289a:	e9 6c f5 ff ff       	jmp    c0101e0b <__alltraps>

c010289f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010289f:	55                   	push   %ebp
c01028a0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028a2:	8b 55 08             	mov    0x8(%ebp),%edx
c01028a5:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c01028aa:	29 c2                	sub    %eax,%edx
c01028ac:	89 d0                	mov    %edx,%eax
c01028ae:	c1 f8 02             	sar    $0x2,%eax
c01028b1:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028b7:	5d                   	pop    %ebp
c01028b8:	c3                   	ret    

c01028b9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028b9:	55                   	push   %ebp
c01028ba:	89 e5                	mov    %esp,%ebp
c01028bc:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01028c2:	89 04 24             	mov    %eax,(%esp)
c01028c5:	e8 d5 ff ff ff       	call   c010289f <page2ppn>
c01028ca:	c1 e0 0c             	shl    $0xc,%eax
}
c01028cd:	c9                   	leave  
c01028ce:	c3                   	ret    

c01028cf <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028cf:	55                   	push   %ebp
c01028d0:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01028d5:	8b 00                	mov    (%eax),%eax
}
c01028d7:	5d                   	pop    %ebp
c01028d8:	c3                   	ret    

c01028d9 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028d9:	55                   	push   %ebp
c01028da:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01028df:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028e2:	89 10                	mov    %edx,(%eax)
}
c01028e4:	5d                   	pop    %ebp
c01028e5:	c3                   	ret    

c01028e6 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01028e6:	55                   	push   %ebp
c01028e7:	89 e5                	mov    %esp,%ebp
c01028e9:	83 ec 10             	sub    $0x10,%esp
c01028ec:	c7 45 fc 10 af 11 c0 	movl   $0xc011af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01028f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028f9:	89 50 04             	mov    %edx,0x4(%eax)
c01028fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028ff:	8b 50 04             	mov    0x4(%eax),%edx
c0102902:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102905:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102907:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c010290e:	00 00 00 
}
c0102911:	c9                   	leave  
c0102912:	c3                   	ret    

c0102913 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102913:	55                   	push   %ebp
c0102914:	89 e5                	mov    %esp,%ebp
c0102916:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102919:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010291d:	75 24                	jne    c0102943 <default_init_memmap+0x30>
c010291f:	c7 44 24 0c 10 65 10 	movl   $0xc0106510,0xc(%esp)
c0102926:	c0 
c0102927:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010292e:	c0 
c010292f:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102936:	00 
c0102937:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010293e:	e8 89 e3 ff ff       	call   c0100ccc <__panic>
    struct Page *p = base;
c0102943:	8b 45 08             	mov    0x8(%ebp),%eax
c0102946:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102949:	eb 7d                	jmp    c01029c8 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c010294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010294e:	83 c0 04             	add    $0x4,%eax
c0102951:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102958:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010295b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010295e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102961:	0f a3 10             	bt     %edx,(%eax)
c0102964:	19 c0                	sbb    %eax,%eax
c0102966:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102969:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010296d:	0f 95 c0             	setne  %al
c0102970:	0f b6 c0             	movzbl %al,%eax
c0102973:	85 c0                	test   %eax,%eax
c0102975:	75 24                	jne    c010299b <default_init_memmap+0x88>
c0102977:	c7 44 24 0c 41 65 10 	movl   $0xc0106541,0xc(%esp)
c010297e:	c0 
c010297f:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0102986:	c0 
c0102987:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010298e:	00 
c010298f:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0102996:	e8 31 e3 ff ff       	call   c0100ccc <__panic>
        p->flags = p->property = 0;
c010299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a8:	8b 50 08             	mov    0x8(%eax),%edx
c01029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ae:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01029b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029b8:	00 
c01029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029bc:	89 04 24             	mov    %eax,(%esp)
c01029bf:	e8 15 ff ff ff       	call   c01028d9 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029c4:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01029c8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029cb:	89 d0                	mov    %edx,%eax
c01029cd:	c1 e0 02             	shl    $0x2,%eax
c01029d0:	01 d0                	add    %edx,%eax
c01029d2:	c1 e0 02             	shl    $0x2,%eax
c01029d5:	89 c2                	mov    %eax,%edx
c01029d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029da:	01 d0                	add    %edx,%eax
c01029dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01029df:	0f 85 66 ff ff ff    	jne    c010294b <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c01029e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029eb:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c01029ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01029f1:	83 c0 04             	add    $0x4,%eax
c01029f4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a04:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0102a07:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a10:	01 d0                	add    %edx,%eax
c0102a12:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    list_add(&free_list, &(base->page_link));
c0102a17:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a1a:	83 c0 0c             	add    $0xc,%eax
c0102a1d:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
c0102a24:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a27:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a2a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102a2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a30:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102a33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a36:	8b 40 04             	mov    0x4(%eax),%eax
c0102a39:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a3c:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0102a3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a42:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102a45:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a48:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a4b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a4e:	89 10                	mov    %edx,(%eax)
c0102a50:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a53:	8b 10                	mov    (%eax),%edx
c0102a55:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102a58:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a5e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102a61:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a64:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a67:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102a6a:	89 10                	mov    %edx,(%eax)
}
c0102a6c:	c9                   	leave  
c0102a6d:	c3                   	ret    

c0102a6e <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a6e:	55                   	push   %ebp
c0102a6f:	89 e5                	mov    %esp,%ebp
c0102a71:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102a74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a78:	75 24                	jne    c0102a9e <default_alloc_pages+0x30>
c0102a7a:	c7 44 24 0c 10 65 10 	movl   $0xc0106510,0xc(%esp)
c0102a81:	c0 
c0102a82:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0102a89:	c0 
c0102a8a:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0102a91:	00 
c0102a92:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0102a99:	e8 2e e2 ff ff       	call   c0100ccc <__panic>
    if (n > nr_free) {
c0102a9e:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102aa3:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102aa6:	73 0a                	jae    c0102ab2 <default_alloc_pages+0x44>
        return NULL;
c0102aa8:	b8 00 00 00 00       	mov    $0x0,%eax
c0102aad:	e9 2a 01 00 00       	jmp    c0102bdc <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c0102ab2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102ab9:	c7 45 f0 10 af 11 c0 	movl   $0xc011af10,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102ac0:	eb 1c                	jmp    c0102ade <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ac5:	83 e8 0c             	sub    $0xc,%eax
c0102ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c0102acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ace:	8b 40 08             	mov    0x8(%eax),%eax
c0102ad1:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ad4:	72 08                	jb     c0102ade <default_alloc_pages+0x70>
            page = p;
c0102ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102adc:	eb 18                	jmp    c0102af6 <default_alloc_pages+0x88>
c0102ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ae7:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102aed:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102af4:	75 cc                	jne    c0102ac2 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102afa:	0f 84 d9 00 00 00    	je     c0102bd9 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c0102b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b03:	83 c0 0c             	add    $0xc,%eax
c0102b06:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b0c:	8b 40 04             	mov    0x4(%eax),%eax
c0102b0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b12:	8b 12                	mov    (%edx),%edx
c0102b14:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102b17:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b1d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b20:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b23:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102b26:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102b29:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0102b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b2e:	8b 40 08             	mov    0x8(%eax),%eax
c0102b31:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b34:	76 7d                	jbe    c0102bb3 <default_alloc_pages+0x145>
            struct Page *p = page + n;
c0102b36:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b39:	89 d0                	mov    %edx,%eax
c0102b3b:	c1 e0 02             	shl    $0x2,%eax
c0102b3e:	01 d0                	add    %edx,%eax
c0102b40:	c1 e0 02             	shl    $0x2,%eax
c0102b43:	89 c2                	mov    %eax,%edx
c0102b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b48:	01 d0                	add    %edx,%eax
c0102b4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b50:	8b 40 08             	mov    0x8(%eax),%eax
c0102b53:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b56:	89 c2                	mov    %eax,%edx
c0102b58:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b5b:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c0102b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b61:	83 c0 0c             	add    $0xc,%eax
c0102b64:	c7 45 d4 10 af 11 c0 	movl   $0xc011af10,-0x2c(%ebp)
c0102b6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102b6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b71:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102b74:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b77:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102b7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b7d:	8b 40 04             	mov    0x4(%eax),%eax
c0102b80:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b83:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102b86:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b89:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102b8c:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b8f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b92:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b95:	89 10                	mov    %edx,(%eax)
c0102b97:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b9a:	8b 10                	mov    (%eax),%edx
c0102b9c:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b9f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ba2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ba5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102ba8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102bab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102bae:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102bb1:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0102bb3:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102bb8:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bbb:	a3 18 af 11 c0       	mov    %eax,0xc011af18
        ClearPageProperty(page);
c0102bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc3:	83 c0 04             	add    $0x4,%eax
c0102bc6:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102bcd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102bd0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bd3:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102bd6:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bdc:	c9                   	leave  
c0102bdd:	c3                   	ret    

c0102bde <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102bde:	55                   	push   %ebp
c0102bdf:	89 e5                	mov    %esp,%ebp
c0102be1:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102beb:	75 24                	jne    c0102c11 <default_free_pages+0x33>
c0102bed:	c7 44 24 0c 10 65 10 	movl   $0xc0106510,0xc(%esp)
c0102bf4:	c0 
c0102bf5:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0102bfc:	c0 
c0102bfd:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0102c04:	00 
c0102c05:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0102c0c:	e8 bb e0 ff ff       	call   c0100ccc <__panic>
    struct Page *p = base;
c0102c11:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102c17:	e9 9d 00 00 00       	jmp    c0102cb9 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c1f:	83 c0 04             	add    $0x4,%eax
c0102c22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c29:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c32:	0f a3 10             	bt     %edx,(%eax)
c0102c35:	19 c0                	sbb    %eax,%eax
c0102c37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c3e:	0f 95 c0             	setne  %al
c0102c41:	0f b6 c0             	movzbl %al,%eax
c0102c44:	85 c0                	test   %eax,%eax
c0102c46:	75 2c                	jne    c0102c74 <default_free_pages+0x96>
c0102c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c4b:	83 c0 04             	add    $0x4,%eax
c0102c4e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c55:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c58:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c5e:	0f a3 10             	bt     %edx,(%eax)
c0102c61:	19 c0                	sbb    %eax,%eax
c0102c63:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102c66:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c6a:	0f 95 c0             	setne  %al
c0102c6d:	0f b6 c0             	movzbl %al,%eax
c0102c70:	85 c0                	test   %eax,%eax
c0102c72:	74 24                	je     c0102c98 <default_free_pages+0xba>
c0102c74:	c7 44 24 0c 54 65 10 	movl   $0xc0106554,0xc(%esp)
c0102c7b:	c0 
c0102c7c:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0102c83:	c0 
c0102c84:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0102c8b:	00 
c0102c8c:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0102c93:	e8 34 e0 ff ff       	call   c0100ccc <__panic>
        p->flags = 0;
c0102c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102ca2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102ca9:	00 
c0102caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cad:	89 04 24             	mov    %eax,(%esp)
c0102cb0:	e8 24 fc ff ff       	call   c01028d9 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102cb5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cbc:	89 d0                	mov    %edx,%eax
c0102cbe:	c1 e0 02             	shl    $0x2,%eax
c0102cc1:	01 d0                	add    %edx,%eax
c0102cc3:	c1 e0 02             	shl    $0x2,%eax
c0102cc6:	89 c2                	mov    %eax,%edx
c0102cc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ccb:	01 d0                	add    %edx,%eax
c0102ccd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cd0:	0f 85 46 ff ff ff    	jne    c0102c1c <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cdc:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102cdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce2:	83 c0 04             	add    $0x4,%eax
c0102ce5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102cec:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102cef:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cf2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102cf5:	0f ab 10             	bts    %edx,(%eax)
c0102cf8:	c7 45 cc 10 af 11 c0 	movl   $0xc011af10,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102cff:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d02:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102d08:	e9 08 01 00 00       	jmp    c0102e15 <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d10:	83 e8 0c             	sub    $0xc,%eax
c0102d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d19:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102d1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102d1f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d28:	8b 50 08             	mov    0x8(%eax),%edx
c0102d2b:	89 d0                	mov    %edx,%eax
c0102d2d:	c1 e0 02             	shl    $0x2,%eax
c0102d30:	01 d0                	add    %edx,%eax
c0102d32:	c1 e0 02             	shl    $0x2,%eax
c0102d35:	89 c2                	mov    %eax,%edx
c0102d37:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d3a:	01 d0                	add    %edx,%eax
c0102d3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d3f:	75 5a                	jne    c0102d9b <default_free_pages+0x1bd>
            base->property += p->property;
c0102d41:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d44:	8b 50 08             	mov    0x8(%eax),%edx
c0102d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d4a:	8b 40 08             	mov    0x8(%eax),%eax
c0102d4d:	01 c2                	add    %eax,%edx
c0102d4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d52:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d58:	83 c0 04             	add    $0x4,%eax
c0102d5b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102d62:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d65:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d68:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d6b:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d71:	83 c0 0c             	add    $0xc,%eax
c0102d74:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102d77:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d7a:	8b 40 04             	mov    0x4(%eax),%eax
c0102d7d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d80:	8b 12                	mov    (%edx),%edx
c0102d82:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102d85:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102d88:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d8b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102d8e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102d91:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d94:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d97:	89 10                	mov    %edx,(%eax)
c0102d99:	eb 7a                	jmp    c0102e15 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9e:	8b 50 08             	mov    0x8(%eax),%edx
c0102da1:	89 d0                	mov    %edx,%eax
c0102da3:	c1 e0 02             	shl    $0x2,%eax
c0102da6:	01 d0                	add    %edx,%eax
c0102da8:	c1 e0 02             	shl    $0x2,%eax
c0102dab:	89 c2                	mov    %eax,%edx
c0102dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db0:	01 d0                	add    %edx,%eax
c0102db2:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102db5:	75 5e                	jne    c0102e15 <default_free_pages+0x237>
            p->property += base->property;
c0102db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dba:	8b 50 08             	mov    0x8(%eax),%edx
c0102dbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc0:	8b 40 08             	mov    0x8(%eax),%eax
c0102dc3:	01 c2                	add    %eax,%edx
c0102dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc8:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102dcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dce:	83 c0 04             	add    $0x4,%eax
c0102dd1:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102dd8:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102ddb:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102dde:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102de1:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102de7:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ded:	83 c0 0c             	add    $0xc,%eax
c0102df0:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102df3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102df6:	8b 40 04             	mov    0x4(%eax),%eax
c0102df9:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102dfc:	8b 12                	mov    (%edx),%edx
c0102dfe:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102e01:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e04:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102e07:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102e0a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e0d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102e10:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102e13:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102e15:	81 7d f0 10 af 11 c0 	cmpl   $0xc011af10,-0x10(%ebp)
c0102e1c:	0f 85 eb fe ff ff    	jne    c0102d0d <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102e22:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102e28:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e2b:	01 d0                	add    %edx,%eax
c0102e2d:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    list_add(&free_list, &(base->page_link));
c0102e32:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e35:	83 c0 0c             	add    $0xc,%eax
c0102e38:	c7 45 9c 10 af 11 c0 	movl   $0xc011af10,-0x64(%ebp)
c0102e3f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102e42:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102e45:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102e48:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102e4b:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102e4e:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102e51:	8b 40 04             	mov    0x4(%eax),%eax
c0102e54:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102e57:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102e5a:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102e5d:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102e60:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102e63:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e66:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102e69:	89 10                	mov    %edx,(%eax)
c0102e6b:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102e6e:	8b 10                	mov    (%eax),%edx
c0102e70:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102e73:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102e76:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e79:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102e7c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102e7f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102e82:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102e85:	89 10                	mov    %edx,(%eax)
}
c0102e87:	c9                   	leave  
c0102e88:	c3                   	ret    

c0102e89 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e89:	55                   	push   %ebp
c0102e8a:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e8c:	a1 18 af 11 c0       	mov    0xc011af18,%eax
}
c0102e91:	5d                   	pop    %ebp
c0102e92:	c3                   	ret    

c0102e93 <basic_check>:

static void
basic_check(void) {
c0102e93:	55                   	push   %ebp
c0102e94:	89 e5                	mov    %esp,%ebp
c0102e96:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ea9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102eac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102eb3:	e8 ce 0e 00 00       	call   c0103d86 <alloc_pages>
c0102eb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102ebb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102ebf:	75 24                	jne    c0102ee5 <basic_check+0x52>
c0102ec1:	c7 44 24 0c 79 65 10 	movl   $0xc0106579,0xc(%esp)
c0102ec8:	c0 
c0102ec9:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0102ed0:	c0 
c0102ed1:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0102ed8:	00 
c0102ed9:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0102ee0:	e8 e7 dd ff ff       	call   c0100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ee5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102eec:	e8 95 0e 00 00       	call   c0103d86 <alloc_pages>
c0102ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ef4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ef8:	75 24                	jne    c0102f1e <basic_check+0x8b>
c0102efa:	c7 44 24 0c 95 65 10 	movl   $0xc0106595,0xc(%esp)
c0102f01:	c0 
c0102f02:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0102f09:	c0 
c0102f0a:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0102f11:	00 
c0102f12:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0102f19:	e8 ae dd ff ff       	call   c0100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102f1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f25:	e8 5c 0e 00 00       	call   c0103d86 <alloc_pages>
c0102f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f31:	75 24                	jne    c0102f57 <basic_check+0xc4>
c0102f33:	c7 44 24 0c b1 65 10 	movl   $0xc01065b1,0xc(%esp)
c0102f3a:	c0 
c0102f3b:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0102f42:	c0 
c0102f43:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0102f4a:	00 
c0102f4b:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0102f52:	e8 75 dd ff ff       	call   c0100ccc <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f5a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f5d:	74 10                	je     c0102f6f <basic_check+0xdc>
c0102f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f65:	74 08                	je     c0102f6f <basic_check+0xdc>
c0102f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f6a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f6d:	75 24                	jne    c0102f93 <basic_check+0x100>
c0102f6f:	c7 44 24 0c d0 65 10 	movl   $0xc01065d0,0xc(%esp)
c0102f76:	c0 
c0102f77:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0102f7e:	c0 
c0102f7f:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0102f86:	00 
c0102f87:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0102f8e:	e8 39 dd ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f96:	89 04 24             	mov    %eax,(%esp)
c0102f99:	e8 31 f9 ff ff       	call   c01028cf <page_ref>
c0102f9e:	85 c0                	test   %eax,%eax
c0102fa0:	75 1e                	jne    c0102fc0 <basic_check+0x12d>
c0102fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fa5:	89 04 24             	mov    %eax,(%esp)
c0102fa8:	e8 22 f9 ff ff       	call   c01028cf <page_ref>
c0102fad:	85 c0                	test   %eax,%eax
c0102faf:	75 0f                	jne    c0102fc0 <basic_check+0x12d>
c0102fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fb4:	89 04 24             	mov    %eax,(%esp)
c0102fb7:	e8 13 f9 ff ff       	call   c01028cf <page_ref>
c0102fbc:	85 c0                	test   %eax,%eax
c0102fbe:	74 24                	je     c0102fe4 <basic_check+0x151>
c0102fc0:	c7 44 24 0c f4 65 10 	movl   $0xc01065f4,0xc(%esp)
c0102fc7:	c0 
c0102fc8:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0102fcf:	c0 
c0102fd0:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0102fd7:	00 
c0102fd8:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0102fdf:	e8 e8 dc ff ff       	call   c0100ccc <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fe7:	89 04 24             	mov    %eax,(%esp)
c0102fea:	e8 ca f8 ff ff       	call   c01028b9 <page2pa>
c0102fef:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0102ff5:	c1 e2 0c             	shl    $0xc,%edx
c0102ff8:	39 d0                	cmp    %edx,%eax
c0102ffa:	72 24                	jb     c0103020 <basic_check+0x18d>
c0102ffc:	c7 44 24 0c 30 66 10 	movl   $0xc0106630,0xc(%esp)
c0103003:	c0 
c0103004:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010300b:	c0 
c010300c:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103013:	00 
c0103014:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010301b:	e8 ac dc ff ff       	call   c0100ccc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103020:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103023:	89 04 24             	mov    %eax,(%esp)
c0103026:	e8 8e f8 ff ff       	call   c01028b9 <page2pa>
c010302b:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103031:	c1 e2 0c             	shl    $0xc,%edx
c0103034:	39 d0                	cmp    %edx,%eax
c0103036:	72 24                	jb     c010305c <basic_check+0x1c9>
c0103038:	c7 44 24 0c 4d 66 10 	movl   $0xc010664d,0xc(%esp)
c010303f:	c0 
c0103040:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103047:	c0 
c0103048:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c010304f:	00 
c0103050:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103057:	e8 70 dc ff ff       	call   c0100ccc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010305f:	89 04 24             	mov    %eax,(%esp)
c0103062:	e8 52 f8 ff ff       	call   c01028b9 <page2pa>
c0103067:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c010306d:	c1 e2 0c             	shl    $0xc,%edx
c0103070:	39 d0                	cmp    %edx,%eax
c0103072:	72 24                	jb     c0103098 <basic_check+0x205>
c0103074:	c7 44 24 0c 6a 66 10 	movl   $0xc010666a,0xc(%esp)
c010307b:	c0 
c010307c:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103083:	c0 
c0103084:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c010308b:	00 
c010308c:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103093:	e8 34 dc ff ff       	call   c0100ccc <__panic>

    list_entry_t free_list_store = free_list;
c0103098:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c010309d:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c01030a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030a6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01030a9:	c7 45 e0 10 af 11 c0 	movl   $0xc011af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01030b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01030b6:	89 50 04             	mov    %edx,0x4(%eax)
c01030b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030bc:	8b 50 04             	mov    0x4(%eax),%edx
c01030bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030c2:	89 10                	mov    %edx,(%eax)
c01030c4:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01030cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030ce:	8b 40 04             	mov    0x4(%eax),%eax
c01030d1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030d4:	0f 94 c0             	sete   %al
c01030d7:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030da:	85 c0                	test   %eax,%eax
c01030dc:	75 24                	jne    c0103102 <basic_check+0x26f>
c01030de:	c7 44 24 0c 87 66 10 	movl   $0xc0106687,0xc(%esp)
c01030e5:	c0 
c01030e6:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01030ed:	c0 
c01030ee:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c01030f5:	00 
c01030f6:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01030fd:	e8 ca db ff ff       	call   c0100ccc <__panic>

    unsigned int nr_free_store = nr_free;
c0103102:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103107:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010310a:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c0103111:	00 00 00 

    assert(alloc_page() == NULL);
c0103114:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010311b:	e8 66 0c 00 00       	call   c0103d86 <alloc_pages>
c0103120:	85 c0                	test   %eax,%eax
c0103122:	74 24                	je     c0103148 <basic_check+0x2b5>
c0103124:	c7 44 24 0c 9e 66 10 	movl   $0xc010669e,0xc(%esp)
c010312b:	c0 
c010312c:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103133:	c0 
c0103134:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c010313b:	00 
c010313c:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103143:	e8 84 db ff ff       	call   c0100ccc <__panic>

    free_page(p0);
c0103148:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010314f:	00 
c0103150:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103153:	89 04 24             	mov    %eax,(%esp)
c0103156:	e8 63 0c 00 00       	call   c0103dbe <free_pages>
    free_page(p1);
c010315b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103162:	00 
c0103163:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103166:	89 04 24             	mov    %eax,(%esp)
c0103169:	e8 50 0c 00 00       	call   c0103dbe <free_pages>
    free_page(p2);
c010316e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103175:	00 
c0103176:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103179:	89 04 24             	mov    %eax,(%esp)
c010317c:	e8 3d 0c 00 00       	call   c0103dbe <free_pages>
    assert(nr_free == 3);
c0103181:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103186:	83 f8 03             	cmp    $0x3,%eax
c0103189:	74 24                	je     c01031af <basic_check+0x31c>
c010318b:	c7 44 24 0c b3 66 10 	movl   $0xc01066b3,0xc(%esp)
c0103192:	c0 
c0103193:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010319a:	c0 
c010319b:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c01031a2:	00 
c01031a3:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01031aa:	e8 1d db ff ff       	call   c0100ccc <__panic>

    assert((p0 = alloc_page()) != NULL);
c01031af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031b6:	e8 cb 0b 00 00       	call   c0103d86 <alloc_pages>
c01031bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01031c2:	75 24                	jne    c01031e8 <basic_check+0x355>
c01031c4:	c7 44 24 0c 79 65 10 	movl   $0xc0106579,0xc(%esp)
c01031cb:	c0 
c01031cc:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01031d3:	c0 
c01031d4:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c01031db:	00 
c01031dc:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01031e3:	e8 e4 da ff ff       	call   c0100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031ef:	e8 92 0b 00 00       	call   c0103d86 <alloc_pages>
c01031f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031fb:	75 24                	jne    c0103221 <basic_check+0x38e>
c01031fd:	c7 44 24 0c 95 65 10 	movl   $0xc0106595,0xc(%esp)
c0103204:	c0 
c0103205:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010320c:	c0 
c010320d:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0103214:	00 
c0103215:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010321c:	e8 ab da ff ff       	call   c0100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103221:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103228:	e8 59 0b 00 00       	call   c0103d86 <alloc_pages>
c010322d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103234:	75 24                	jne    c010325a <basic_check+0x3c7>
c0103236:	c7 44 24 0c b1 65 10 	movl   $0xc01065b1,0xc(%esp)
c010323d:	c0 
c010323e:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103245:	c0 
c0103246:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010324d:	00 
c010324e:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103255:	e8 72 da ff ff       	call   c0100ccc <__panic>

    assert(alloc_page() == NULL);
c010325a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103261:	e8 20 0b 00 00       	call   c0103d86 <alloc_pages>
c0103266:	85 c0                	test   %eax,%eax
c0103268:	74 24                	je     c010328e <basic_check+0x3fb>
c010326a:	c7 44 24 0c 9e 66 10 	movl   $0xc010669e,0xc(%esp)
c0103271:	c0 
c0103272:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103279:	c0 
c010327a:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103281:	00 
c0103282:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103289:	e8 3e da ff ff       	call   c0100ccc <__panic>

    free_page(p0);
c010328e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103295:	00 
c0103296:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103299:	89 04 24             	mov    %eax,(%esp)
c010329c:	e8 1d 0b 00 00       	call   c0103dbe <free_pages>
c01032a1:	c7 45 d8 10 af 11 c0 	movl   $0xc011af10,-0x28(%ebp)
c01032a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01032ab:	8b 40 04             	mov    0x4(%eax),%eax
c01032ae:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01032b1:	0f 94 c0             	sete   %al
c01032b4:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01032b7:	85 c0                	test   %eax,%eax
c01032b9:	74 24                	je     c01032df <basic_check+0x44c>
c01032bb:	c7 44 24 0c c0 66 10 	movl   $0xc01066c0,0xc(%esp)
c01032c2:	c0 
c01032c3:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01032ca:	c0 
c01032cb:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01032d2:	00 
c01032d3:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01032da:	e8 ed d9 ff ff       	call   c0100ccc <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01032df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032e6:	e8 9b 0a 00 00       	call   c0103d86 <alloc_pages>
c01032eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032f4:	74 24                	je     c010331a <basic_check+0x487>
c01032f6:	c7 44 24 0c d8 66 10 	movl   $0xc01066d8,0xc(%esp)
c01032fd:	c0 
c01032fe:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103305:	c0 
c0103306:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c010330d:	00 
c010330e:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103315:	e8 b2 d9 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c010331a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103321:	e8 60 0a 00 00       	call   c0103d86 <alloc_pages>
c0103326:	85 c0                	test   %eax,%eax
c0103328:	74 24                	je     c010334e <basic_check+0x4bb>
c010332a:	c7 44 24 0c 9e 66 10 	movl   $0xc010669e,0xc(%esp)
c0103331:	c0 
c0103332:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103339:	c0 
c010333a:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103341:	00 
c0103342:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103349:	e8 7e d9 ff ff       	call   c0100ccc <__panic>

    assert(nr_free == 0);
c010334e:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103353:	85 c0                	test   %eax,%eax
c0103355:	74 24                	je     c010337b <basic_check+0x4e8>
c0103357:	c7 44 24 0c f1 66 10 	movl   $0xc01066f1,0xc(%esp)
c010335e:	c0 
c010335f:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103366:	c0 
c0103367:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010336e:	00 
c010336f:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103376:	e8 51 d9 ff ff       	call   c0100ccc <__panic>
    free_list = free_list_store;
c010337b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010337e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103381:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c0103386:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    nr_free = nr_free_store;
c010338c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010338f:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_page(p);
c0103394:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010339b:	00 
c010339c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010339f:	89 04 24             	mov    %eax,(%esp)
c01033a2:	e8 17 0a 00 00       	call   c0103dbe <free_pages>
    free_page(p1);
c01033a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033ae:	00 
c01033af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033b2:	89 04 24             	mov    %eax,(%esp)
c01033b5:	e8 04 0a 00 00       	call   c0103dbe <free_pages>
    free_page(p2);
c01033ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01033c1:	00 
c01033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033c5:	89 04 24             	mov    %eax,(%esp)
c01033c8:	e8 f1 09 00 00       	call   c0103dbe <free_pages>
}
c01033cd:	c9                   	leave  
c01033ce:	c3                   	ret    

c01033cf <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01033cf:	55                   	push   %ebp
c01033d0:	89 e5                	mov    %esp,%ebp
c01033d2:	53                   	push   %ebx
c01033d3:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01033d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01033e7:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033ee:	eb 6b                	jmp    c010345b <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01033f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033f3:	83 e8 0c             	sub    $0xc,%eax
c01033f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033fc:	83 c0 04             	add    $0x4,%eax
c01033ff:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103406:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103409:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010340c:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010340f:	0f a3 10             	bt     %edx,(%eax)
c0103412:	19 c0                	sbb    %eax,%eax
c0103414:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103417:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010341b:	0f 95 c0             	setne  %al
c010341e:	0f b6 c0             	movzbl %al,%eax
c0103421:	85 c0                	test   %eax,%eax
c0103423:	75 24                	jne    c0103449 <default_check+0x7a>
c0103425:	c7 44 24 0c fe 66 10 	movl   $0xc01066fe,0xc(%esp)
c010342c:	c0 
c010342d:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103434:	c0 
c0103435:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c010343c:	00 
c010343d:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103444:	e8 83 d8 ff ff       	call   c0100ccc <__panic>
        count ++, total += p->property;
c0103449:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010344d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103450:	8b 50 08             	mov    0x8(%eax),%edx
c0103453:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103456:	01 d0                	add    %edx,%eax
c0103458:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010345b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010345e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103461:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103464:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103467:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010346a:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c0103471:	0f 85 79 ff ff ff    	jne    c01033f0 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103477:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010347a:	e8 71 09 00 00       	call   c0103df0 <nr_free_pages>
c010347f:	39 c3                	cmp    %eax,%ebx
c0103481:	74 24                	je     c01034a7 <default_check+0xd8>
c0103483:	c7 44 24 0c 0e 67 10 	movl   $0xc010670e,0xc(%esp)
c010348a:	c0 
c010348b:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103492:	c0 
c0103493:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010349a:	00 
c010349b:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01034a2:	e8 25 d8 ff ff       	call   c0100ccc <__panic>

    basic_check();
c01034a7:	e8 e7 f9 ff ff       	call   c0102e93 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01034ac:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01034b3:	e8 ce 08 00 00       	call   c0103d86 <alloc_pages>
c01034b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01034bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01034bf:	75 24                	jne    c01034e5 <default_check+0x116>
c01034c1:	c7 44 24 0c 27 67 10 	movl   $0xc0106727,0xc(%esp)
c01034c8:	c0 
c01034c9:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01034d0:	c0 
c01034d1:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01034d8:	00 
c01034d9:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01034e0:	e8 e7 d7 ff ff       	call   c0100ccc <__panic>
    assert(!PageProperty(p0));
c01034e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034e8:	83 c0 04             	add    $0x4,%eax
c01034eb:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034f5:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034f8:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034fb:	0f a3 10             	bt     %edx,(%eax)
c01034fe:	19 c0                	sbb    %eax,%eax
c0103500:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103503:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103507:	0f 95 c0             	setne  %al
c010350a:	0f b6 c0             	movzbl %al,%eax
c010350d:	85 c0                	test   %eax,%eax
c010350f:	74 24                	je     c0103535 <default_check+0x166>
c0103511:	c7 44 24 0c 32 67 10 	movl   $0xc0106732,0xc(%esp)
c0103518:	c0 
c0103519:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103520:	c0 
c0103521:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103528:	00 
c0103529:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103530:	e8 97 d7 ff ff       	call   c0100ccc <__panic>

    list_entry_t free_list_store = free_list;
c0103535:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c010353a:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c0103540:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103543:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103546:	c7 45 b4 10 af 11 c0 	movl   $0xc011af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010354d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103550:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103553:	89 50 04             	mov    %edx,0x4(%eax)
c0103556:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103559:	8b 50 04             	mov    0x4(%eax),%edx
c010355c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010355f:	89 10                	mov    %edx,(%eax)
c0103561:	c7 45 b0 10 af 11 c0 	movl   $0xc011af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103568:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010356b:	8b 40 04             	mov    0x4(%eax),%eax
c010356e:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103571:	0f 94 c0             	sete   %al
c0103574:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103577:	85 c0                	test   %eax,%eax
c0103579:	75 24                	jne    c010359f <default_check+0x1d0>
c010357b:	c7 44 24 0c 87 66 10 	movl   $0xc0106687,0xc(%esp)
c0103582:	c0 
c0103583:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010358a:	c0 
c010358b:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0103592:	00 
c0103593:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010359a:	e8 2d d7 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c010359f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035a6:	e8 db 07 00 00       	call   c0103d86 <alloc_pages>
c01035ab:	85 c0                	test   %eax,%eax
c01035ad:	74 24                	je     c01035d3 <default_check+0x204>
c01035af:	c7 44 24 0c 9e 66 10 	movl   $0xc010669e,0xc(%esp)
c01035b6:	c0 
c01035b7:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01035be:	c0 
c01035bf:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01035c6:	00 
c01035c7:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01035ce:	e8 f9 d6 ff ff       	call   c0100ccc <__panic>

    unsigned int nr_free_store = nr_free;
c01035d3:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01035d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01035db:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c01035e2:	00 00 00 

    free_pages(p0 + 2, 3);
c01035e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035e8:	83 c0 28             	add    $0x28,%eax
c01035eb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035f2:	00 
c01035f3:	89 04 24             	mov    %eax,(%esp)
c01035f6:	e8 c3 07 00 00       	call   c0103dbe <free_pages>
    assert(alloc_pages(4) == NULL);
c01035fb:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103602:	e8 7f 07 00 00       	call   c0103d86 <alloc_pages>
c0103607:	85 c0                	test   %eax,%eax
c0103609:	74 24                	je     c010362f <default_check+0x260>
c010360b:	c7 44 24 0c 44 67 10 	movl   $0xc0106744,0xc(%esp)
c0103612:	c0 
c0103613:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010361a:	c0 
c010361b:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103622:	00 
c0103623:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010362a:	e8 9d d6 ff ff       	call   c0100ccc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103632:	83 c0 28             	add    $0x28,%eax
c0103635:	83 c0 04             	add    $0x4,%eax
c0103638:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010363f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103642:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103645:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103648:	0f a3 10             	bt     %edx,(%eax)
c010364b:	19 c0                	sbb    %eax,%eax
c010364d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103650:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103654:	0f 95 c0             	setne  %al
c0103657:	0f b6 c0             	movzbl %al,%eax
c010365a:	85 c0                	test   %eax,%eax
c010365c:	74 0e                	je     c010366c <default_check+0x29d>
c010365e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103661:	83 c0 28             	add    $0x28,%eax
c0103664:	8b 40 08             	mov    0x8(%eax),%eax
c0103667:	83 f8 03             	cmp    $0x3,%eax
c010366a:	74 24                	je     c0103690 <default_check+0x2c1>
c010366c:	c7 44 24 0c 5c 67 10 	movl   $0xc010675c,0xc(%esp)
c0103673:	c0 
c0103674:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010367b:	c0 
c010367c:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0103683:	00 
c0103684:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010368b:	e8 3c d6 ff ff       	call   c0100ccc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103690:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103697:	e8 ea 06 00 00       	call   c0103d86 <alloc_pages>
c010369c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010369f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01036a3:	75 24                	jne    c01036c9 <default_check+0x2fa>
c01036a5:	c7 44 24 0c 88 67 10 	movl   $0xc0106788,0xc(%esp)
c01036ac:	c0 
c01036ad:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01036b4:	c0 
c01036b5:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01036bc:	00 
c01036bd:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01036c4:	e8 03 d6 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c01036c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036d0:	e8 b1 06 00 00       	call   c0103d86 <alloc_pages>
c01036d5:	85 c0                	test   %eax,%eax
c01036d7:	74 24                	je     c01036fd <default_check+0x32e>
c01036d9:	c7 44 24 0c 9e 66 10 	movl   $0xc010669e,0xc(%esp)
c01036e0:	c0 
c01036e1:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01036e8:	c0 
c01036e9:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01036f0:	00 
c01036f1:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01036f8:	e8 cf d5 ff ff       	call   c0100ccc <__panic>
    assert(p0 + 2 == p1);
c01036fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103700:	83 c0 28             	add    $0x28,%eax
c0103703:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103706:	74 24                	je     c010372c <default_check+0x35d>
c0103708:	c7 44 24 0c a6 67 10 	movl   $0xc01067a6,0xc(%esp)
c010370f:	c0 
c0103710:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103717:	c0 
c0103718:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c010371f:	00 
c0103720:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103727:	e8 a0 d5 ff ff       	call   c0100ccc <__panic>

    p2 = p0 + 1;
c010372c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010372f:	83 c0 14             	add    $0x14,%eax
c0103732:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103735:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010373c:	00 
c010373d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103740:	89 04 24             	mov    %eax,(%esp)
c0103743:	e8 76 06 00 00       	call   c0103dbe <free_pages>
    free_pages(p1, 3);
c0103748:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010374f:	00 
c0103750:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103753:	89 04 24             	mov    %eax,(%esp)
c0103756:	e8 63 06 00 00       	call   c0103dbe <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010375b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010375e:	83 c0 04             	add    $0x4,%eax
c0103761:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103768:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010376b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010376e:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103771:	0f a3 10             	bt     %edx,(%eax)
c0103774:	19 c0                	sbb    %eax,%eax
c0103776:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103779:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010377d:	0f 95 c0             	setne  %al
c0103780:	0f b6 c0             	movzbl %al,%eax
c0103783:	85 c0                	test   %eax,%eax
c0103785:	74 0b                	je     c0103792 <default_check+0x3c3>
c0103787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010378a:	8b 40 08             	mov    0x8(%eax),%eax
c010378d:	83 f8 01             	cmp    $0x1,%eax
c0103790:	74 24                	je     c01037b6 <default_check+0x3e7>
c0103792:	c7 44 24 0c b4 67 10 	movl   $0xc01067b4,0xc(%esp)
c0103799:	c0 
c010379a:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01037a1:	c0 
c01037a2:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01037a9:	00 
c01037aa:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01037b1:	e8 16 d5 ff ff       	call   c0100ccc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01037b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037b9:	83 c0 04             	add    $0x4,%eax
c01037bc:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01037c3:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037c6:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037c9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037cc:	0f a3 10             	bt     %edx,(%eax)
c01037cf:	19 c0                	sbb    %eax,%eax
c01037d1:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01037d4:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01037d8:	0f 95 c0             	setne  %al
c01037db:	0f b6 c0             	movzbl %al,%eax
c01037de:	85 c0                	test   %eax,%eax
c01037e0:	74 0b                	je     c01037ed <default_check+0x41e>
c01037e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037e5:	8b 40 08             	mov    0x8(%eax),%eax
c01037e8:	83 f8 03             	cmp    $0x3,%eax
c01037eb:	74 24                	je     c0103811 <default_check+0x442>
c01037ed:	c7 44 24 0c dc 67 10 	movl   $0xc01067dc,0xc(%esp)
c01037f4:	c0 
c01037f5:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01037fc:	c0 
c01037fd:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0103804:	00 
c0103805:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010380c:	e8 bb d4 ff ff       	call   c0100ccc <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103811:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103818:	e8 69 05 00 00       	call   c0103d86 <alloc_pages>
c010381d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103820:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103823:	83 e8 14             	sub    $0x14,%eax
c0103826:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103829:	74 24                	je     c010384f <default_check+0x480>
c010382b:	c7 44 24 0c 02 68 10 	movl   $0xc0106802,0xc(%esp)
c0103832:	c0 
c0103833:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010383a:	c0 
c010383b:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0103842:	00 
c0103843:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010384a:	e8 7d d4 ff ff       	call   c0100ccc <__panic>
    free_page(p0);
c010384f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103856:	00 
c0103857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010385a:	89 04 24             	mov    %eax,(%esp)
c010385d:	e8 5c 05 00 00       	call   c0103dbe <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103862:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103869:	e8 18 05 00 00       	call   c0103d86 <alloc_pages>
c010386e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103871:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103874:	83 c0 14             	add    $0x14,%eax
c0103877:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010387a:	74 24                	je     c01038a0 <default_check+0x4d1>
c010387c:	c7 44 24 0c 20 68 10 	movl   $0xc0106820,0xc(%esp)
c0103883:	c0 
c0103884:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010388b:	c0 
c010388c:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103893:	00 
c0103894:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010389b:	e8 2c d4 ff ff       	call   c0100ccc <__panic>

    free_pages(p0, 2);
c01038a0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01038a7:	00 
c01038a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01038ab:	89 04 24             	mov    %eax,(%esp)
c01038ae:	e8 0b 05 00 00       	call   c0103dbe <free_pages>
    free_page(p2);
c01038b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01038ba:	00 
c01038bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01038be:	89 04 24             	mov    %eax,(%esp)
c01038c1:	e8 f8 04 00 00       	call   c0103dbe <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01038c6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01038cd:	e8 b4 04 00 00       	call   c0103d86 <alloc_pages>
c01038d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01038d9:	75 24                	jne    c01038ff <default_check+0x530>
c01038db:	c7 44 24 0c 40 68 10 	movl   $0xc0106840,0xc(%esp)
c01038e2:	c0 
c01038e3:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01038ea:	c0 
c01038eb:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01038f2:	00 
c01038f3:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01038fa:	e8 cd d3 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c01038ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103906:	e8 7b 04 00 00       	call   c0103d86 <alloc_pages>
c010390b:	85 c0                	test   %eax,%eax
c010390d:	74 24                	je     c0103933 <default_check+0x564>
c010390f:	c7 44 24 0c 9e 66 10 	movl   $0xc010669e,0xc(%esp)
c0103916:	c0 
c0103917:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010391e:	c0 
c010391f:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0103926:	00 
c0103927:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010392e:	e8 99 d3 ff ff       	call   c0100ccc <__panic>

    assert(nr_free == 0);
c0103933:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0103938:	85 c0                	test   %eax,%eax
c010393a:	74 24                	je     c0103960 <default_check+0x591>
c010393c:	c7 44 24 0c f1 66 10 	movl   $0xc01066f1,0xc(%esp)
c0103943:	c0 
c0103944:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c010394b:	c0 
c010394c:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c0103953:	00 
c0103954:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c010395b:	e8 6c d3 ff ff       	call   c0100ccc <__panic>
    nr_free = nr_free_store;
c0103960:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103963:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_list = free_list_store;
c0103968:	8b 45 80             	mov    -0x80(%ebp),%eax
c010396b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010396e:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c0103973:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    free_pages(p0, 5);
c0103979:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103980:	00 
c0103981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103984:	89 04 24             	mov    %eax,(%esp)
c0103987:	e8 32 04 00 00       	call   c0103dbe <free_pages>

    le = &free_list;
c010398c:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103993:	eb 5b                	jmp    c01039f0 <default_check+0x621>
        assert(le->next->prev == le && le->prev->next == le);
c0103995:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103998:	8b 40 04             	mov    0x4(%eax),%eax
c010399b:	8b 00                	mov    (%eax),%eax
c010399d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01039a0:	75 0d                	jne    c01039af <default_check+0x5e0>
c01039a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039a5:	8b 00                	mov    (%eax),%eax
c01039a7:	8b 40 04             	mov    0x4(%eax),%eax
c01039aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01039ad:	74 24                	je     c01039d3 <default_check+0x604>
c01039af:	c7 44 24 0c 60 68 10 	movl   $0xc0106860,0xc(%esp)
c01039b6:	c0 
c01039b7:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c01039be:	c0 
c01039bf:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c01039c6:	00 
c01039c7:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c01039ce:	e8 f9 d2 ff ff       	call   c0100ccc <__panic>
        struct Page *p = le2page(le, page_link);
c01039d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039d6:	83 e8 0c             	sub    $0xc,%eax
c01039d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01039dc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01039e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01039e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01039e6:	8b 40 08             	mov    0x8(%eax),%eax
c01039e9:	29 c2                	sub    %eax,%edx
c01039eb:	89 d0                	mov    %edx,%eax
c01039ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039f3:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01039f6:	8b 45 88             	mov    -0x78(%ebp),%eax
c01039f9:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01039fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039ff:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c0103a06:	75 8d                	jne    c0103995 <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103a0c:	74 24                	je     c0103a32 <default_check+0x663>
c0103a0e:	c7 44 24 0c 8d 68 10 	movl   $0xc010688d,0xc(%esp)
c0103a15:	c0 
c0103a16:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103a1d:	c0 
c0103a1e:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c0103a25:	00 
c0103a26:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103a2d:	e8 9a d2 ff ff       	call   c0100ccc <__panic>
    assert(total == 0);
c0103a32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a36:	74 24                	je     c0103a5c <default_check+0x68d>
c0103a38:	c7 44 24 0c 98 68 10 	movl   $0xc0106898,0xc(%esp)
c0103a3f:	c0 
c0103a40:	c7 44 24 08 16 65 10 	movl   $0xc0106516,0x8(%esp)
c0103a47:	c0 
c0103a48:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0103a4f:	00 
c0103a50:	c7 04 24 2b 65 10 c0 	movl   $0xc010652b,(%esp)
c0103a57:	e8 70 d2 ff ff       	call   c0100ccc <__panic>
}
c0103a5c:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103a62:	5b                   	pop    %ebx
c0103a63:	5d                   	pop    %ebp
c0103a64:	c3                   	ret    

c0103a65 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a65:	55                   	push   %ebp
c0103a66:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a68:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a6b:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0103a70:	29 c2                	sub    %eax,%edx
c0103a72:	89 d0                	mov    %edx,%eax
c0103a74:	c1 f8 02             	sar    $0x2,%eax
c0103a77:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a7d:	5d                   	pop    %ebp
c0103a7e:	c3                   	ret    

c0103a7f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a7f:	55                   	push   %ebp
c0103a80:	89 e5                	mov    %esp,%ebp
c0103a82:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a88:	89 04 24             	mov    %eax,(%esp)
c0103a8b:	e8 d5 ff ff ff       	call   c0103a65 <page2ppn>
c0103a90:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a93:	c9                   	leave  
c0103a94:	c3                   	ret    

c0103a95 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a95:	55                   	push   %ebp
c0103a96:	89 e5                	mov    %esp,%ebp
c0103a98:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a9e:	c1 e8 0c             	shr    $0xc,%eax
c0103aa1:	89 c2                	mov    %eax,%edx
c0103aa3:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103aa8:	39 c2                	cmp    %eax,%edx
c0103aaa:	72 1c                	jb     c0103ac8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103aac:	c7 44 24 08 d4 68 10 	movl   $0xc01068d4,0x8(%esp)
c0103ab3:	c0 
c0103ab4:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103abb:	00 
c0103abc:	c7 04 24 f3 68 10 c0 	movl   $0xc01068f3,(%esp)
c0103ac3:	e8 04 d2 ff ff       	call   c0100ccc <__panic>
    }
    return &pages[PPN(pa)];
c0103ac8:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103ace:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad1:	c1 e8 0c             	shr    $0xc,%eax
c0103ad4:	89 c2                	mov    %eax,%edx
c0103ad6:	89 d0                	mov    %edx,%eax
c0103ad8:	c1 e0 02             	shl    $0x2,%eax
c0103adb:	01 d0                	add    %edx,%eax
c0103add:	c1 e0 02             	shl    $0x2,%eax
c0103ae0:	01 c8                	add    %ecx,%eax
}
c0103ae2:	c9                   	leave  
c0103ae3:	c3                   	ret    

c0103ae4 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103ae4:	55                   	push   %ebp
c0103ae5:	89 e5                	mov    %esp,%ebp
c0103ae7:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103aea:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aed:	89 04 24             	mov    %eax,(%esp)
c0103af0:	e8 8a ff ff ff       	call   c0103a7f <page2pa>
c0103af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103afb:	c1 e8 0c             	shr    $0xc,%eax
c0103afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b01:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103b06:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103b09:	72 23                	jb     c0103b2e <page2kva+0x4a>
c0103b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103b12:	c7 44 24 08 04 69 10 	movl   $0xc0106904,0x8(%esp)
c0103b19:	c0 
c0103b1a:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103b21:	00 
c0103b22:	c7 04 24 f3 68 10 c0 	movl   $0xc01068f3,(%esp)
c0103b29:	e8 9e d1 ff ff       	call   c0100ccc <__panic>
c0103b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b31:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103b36:	c9                   	leave  
c0103b37:	c3                   	ret    

c0103b38 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103b38:	55                   	push   %ebp
c0103b39:	89 e5                	mov    %esp,%ebp
c0103b3b:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b41:	83 e0 01             	and    $0x1,%eax
c0103b44:	85 c0                	test   %eax,%eax
c0103b46:	75 1c                	jne    c0103b64 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103b48:	c7 44 24 08 28 69 10 	movl   $0xc0106928,0x8(%esp)
c0103b4f:	c0 
c0103b50:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103b57:	00 
c0103b58:	c7 04 24 f3 68 10 c0 	movl   $0xc01068f3,(%esp)
c0103b5f:	e8 68 d1 ff ff       	call   c0100ccc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b6c:	89 04 24             	mov    %eax,(%esp)
c0103b6f:	e8 21 ff ff ff       	call   c0103a95 <pa2page>
}
c0103b74:	c9                   	leave  
c0103b75:	c3                   	ret    

c0103b76 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103b76:	55                   	push   %ebp
c0103b77:	89 e5                	mov    %esp,%ebp
c0103b79:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103b7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b84:	89 04 24             	mov    %eax,(%esp)
c0103b87:	e8 09 ff ff ff       	call   c0103a95 <pa2page>
}
c0103b8c:	c9                   	leave  
c0103b8d:	c3                   	ret    

c0103b8e <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103b8e:	55                   	push   %ebp
c0103b8f:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b91:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b94:	8b 00                	mov    (%eax),%eax
}
c0103b96:	5d                   	pop    %ebp
c0103b97:	c3                   	ret    

c0103b98 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0103b98:	55                   	push   %ebp
c0103b99:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b9e:	8b 00                	mov    (%eax),%eax
c0103ba0:	8d 50 01             	lea    0x1(%eax),%edx
c0103ba3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ba6:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ba8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bab:	8b 00                	mov    (%eax),%eax
}
c0103bad:	5d                   	pop    %ebp
c0103bae:	c3                   	ret    

c0103baf <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103baf:	55                   	push   %ebp
c0103bb0:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bb5:	8b 00                	mov    (%eax),%eax
c0103bb7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103bba:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bbd:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103bbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bc2:	8b 00                	mov    (%eax),%eax
}
c0103bc4:	5d                   	pop    %ebp
c0103bc5:	c3                   	ret    

c0103bc6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103bc6:	55                   	push   %ebp
c0103bc7:	89 e5                	mov    %esp,%ebp
c0103bc9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103bcc:	9c                   	pushf  
c0103bcd:	58                   	pop    %eax
c0103bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103bd4:	25 00 02 00 00       	and    $0x200,%eax
c0103bd9:	85 c0                	test   %eax,%eax
c0103bdb:	74 0c                	je     c0103be9 <__intr_save+0x23>
        intr_disable();
c0103bdd:	e8 de da ff ff       	call   c01016c0 <intr_disable>
        return 1;
c0103be2:	b8 01 00 00 00       	mov    $0x1,%eax
c0103be7:	eb 05                	jmp    c0103bee <__intr_save+0x28>
    }
    return 0;
c0103be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103bee:	c9                   	leave  
c0103bef:	c3                   	ret    

c0103bf0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103bf0:	55                   	push   %ebp
c0103bf1:	89 e5                	mov    %esp,%ebp
c0103bf3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103bf6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103bfa:	74 05                	je     c0103c01 <__intr_restore+0x11>
        intr_enable();
c0103bfc:	e8 b9 da ff ff       	call   c01016ba <intr_enable>
    }
}
c0103c01:	c9                   	leave  
c0103c02:	c3                   	ret    

c0103c03 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103c03:	55                   	push   %ebp
c0103c04:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c09:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103c0c:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c11:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103c13:	b8 23 00 00 00       	mov    $0x23,%eax
c0103c18:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103c1a:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c1f:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103c21:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c26:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103c28:	b8 10 00 00 00       	mov    $0x10,%eax
c0103c2d:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103c2f:	ea 36 3c 10 c0 08 00 	ljmp   $0x8,$0xc0103c36
}
c0103c36:	5d                   	pop    %ebp
c0103c37:	c3                   	ret    

c0103c38 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103c38:	55                   	push   %ebp
c0103c39:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c3e:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0103c43:	5d                   	pop    %ebp
c0103c44:	c3                   	ret    

c0103c45 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103c45:	55                   	push   %ebp
c0103c46:	89 e5                	mov    %esp,%ebp
c0103c48:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103c4b:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103c50:	89 04 24             	mov    %eax,(%esp)
c0103c53:	e8 e0 ff ff ff       	call   c0103c38 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103c58:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0103c5f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103c61:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103c68:	68 00 
c0103c6a:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103c6f:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c75:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103c7a:	c1 e8 10             	shr    $0x10,%eax
c0103c7d:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c82:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c89:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c8c:	83 c8 09             	or     $0x9,%eax
c0103c8f:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c94:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c9b:	83 e0 ef             	and    $0xffffffef,%eax
c0103c9e:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103ca3:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103caa:	83 e0 9f             	and    $0xffffff9f,%eax
c0103cad:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cb2:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103cb9:	83 c8 80             	or     $0xffffff80,%eax
c0103cbc:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103cc1:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cc8:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ccb:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cd0:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cd7:	83 e0 ef             	and    $0xffffffef,%eax
c0103cda:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cdf:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ce6:	83 e0 df             	and    $0xffffffdf,%eax
c0103ce9:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cee:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103cf5:	83 c8 40             	or     $0x40,%eax
c0103cf8:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cfd:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103d04:	83 e0 7f             	and    $0x7f,%eax
c0103d07:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103d0c:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103d11:	c1 e8 18             	shr    $0x18,%eax
c0103d14:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103d19:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103d20:	e8 de fe ff ff       	call   c0103c03 <lgdt>
c0103d25:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103d2b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103d2f:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103d32:	c9                   	leave  
c0103d33:	c3                   	ret    

c0103d34 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103d34:	55                   	push   %ebp
c0103d35:	89 e5                	mov    %esp,%ebp
c0103d37:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103d3a:	c7 05 1c af 11 c0 b8 	movl   $0xc01068b8,0xc011af1c
c0103d41:	68 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103d44:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d49:	8b 00                	mov    (%eax),%eax
c0103d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103d4f:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0103d56:	e8 ed c5 ff ff       	call   c0100348 <cprintf>
    pmm_manager->init();
c0103d5b:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d60:	8b 40 04             	mov    0x4(%eax),%eax
c0103d63:	ff d0                	call   *%eax
}
c0103d65:	c9                   	leave  
c0103d66:	c3                   	ret    

c0103d67 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103d67:	55                   	push   %ebp
c0103d68:	89 e5                	mov    %esp,%ebp
c0103d6a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d6d:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d72:	8b 40 08             	mov    0x8(%eax),%eax
c0103d75:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d78:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d7c:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d7f:	89 14 24             	mov    %edx,(%esp)
c0103d82:	ff d0                	call   *%eax
}
c0103d84:	c9                   	leave  
c0103d85:	c3                   	ret    

c0103d86 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d86:	55                   	push   %ebp
c0103d87:	89 e5                	mov    %esp,%ebp
c0103d89:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d93:	e8 2e fe ff ff       	call   c0103bc6 <__intr_save>
c0103d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d9b:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103da0:	8b 40 0c             	mov    0xc(%eax),%eax
c0103da3:	8b 55 08             	mov    0x8(%ebp),%edx
c0103da6:	89 14 24             	mov    %edx,(%esp)
c0103da9:	ff d0                	call   *%eax
c0103dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103db1:	89 04 24             	mov    %eax,(%esp)
c0103db4:	e8 37 fe ff ff       	call   c0103bf0 <__intr_restore>
    return page;
c0103db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103dbc:	c9                   	leave  
c0103dbd:	c3                   	ret    

c0103dbe <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103dbe:	55                   	push   %ebp
c0103dbf:	89 e5                	mov    %esp,%ebp
c0103dc1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103dc4:	e8 fd fd ff ff       	call   c0103bc6 <__intr_save>
c0103dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103dcc:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103dd1:	8b 40 10             	mov    0x10(%eax),%eax
c0103dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103dd7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ddb:	8b 55 08             	mov    0x8(%ebp),%edx
c0103dde:	89 14 24             	mov    %edx,(%esp)
c0103de1:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103de6:	89 04 24             	mov    %eax,(%esp)
c0103de9:	e8 02 fe ff ff       	call   c0103bf0 <__intr_restore>
}
c0103dee:	c9                   	leave  
c0103def:	c3                   	ret    

c0103df0 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103df0:	55                   	push   %ebp
c0103df1:	89 e5                	mov    %esp,%ebp
c0103df3:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103df6:	e8 cb fd ff ff       	call   c0103bc6 <__intr_save>
c0103dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103dfe:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103e03:	8b 40 14             	mov    0x14(%eax),%eax
c0103e06:	ff d0                	call   *%eax
c0103e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e0e:	89 04 24             	mov    %eax,(%esp)
c0103e11:	e8 da fd ff ff       	call   c0103bf0 <__intr_restore>
    return ret;
c0103e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103e19:	c9                   	leave  
c0103e1a:	c3                   	ret    

c0103e1b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103e1b:	55                   	push   %ebp
c0103e1c:	89 e5                	mov    %esp,%ebp
c0103e1e:	57                   	push   %edi
c0103e1f:	56                   	push   %esi
c0103e20:	53                   	push   %ebx
c0103e21:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103e27:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103e2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103e35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103e3c:	c7 04 24 6b 69 10 c0 	movl   $0xc010696b,(%esp)
c0103e43:	e8 00 c5 ff ff       	call   c0100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e48:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e4f:	e9 15 01 00 00       	jmp    c0103f69 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103e54:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e57:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e5a:	89 d0                	mov    %edx,%eax
c0103e5c:	c1 e0 02             	shl    $0x2,%eax
c0103e5f:	01 d0                	add    %edx,%eax
c0103e61:	c1 e0 02             	shl    $0x2,%eax
c0103e64:	01 c8                	add    %ecx,%eax
c0103e66:	8b 50 08             	mov    0x8(%eax),%edx
c0103e69:	8b 40 04             	mov    0x4(%eax),%eax
c0103e6c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e6f:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e72:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e75:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e78:	89 d0                	mov    %edx,%eax
c0103e7a:	c1 e0 02             	shl    $0x2,%eax
c0103e7d:	01 d0                	add    %edx,%eax
c0103e7f:	c1 e0 02             	shl    $0x2,%eax
c0103e82:	01 c8                	add    %ecx,%eax
c0103e84:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e87:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e8a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e8d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e90:	01 c8                	add    %ecx,%eax
c0103e92:	11 da                	adc    %ebx,%edx
c0103e94:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e97:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e9a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ea0:	89 d0                	mov    %edx,%eax
c0103ea2:	c1 e0 02             	shl    $0x2,%eax
c0103ea5:	01 d0                	add    %edx,%eax
c0103ea7:	c1 e0 02             	shl    $0x2,%eax
c0103eaa:	01 c8                	add    %ecx,%eax
c0103eac:	83 c0 14             	add    $0x14,%eax
c0103eaf:	8b 00                	mov    (%eax),%eax
c0103eb1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103eb7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103eba:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ebd:	83 c0 ff             	add    $0xffffffff,%eax
c0103ec0:	83 d2 ff             	adc    $0xffffffff,%edx
c0103ec3:	89 c6                	mov    %eax,%esi
c0103ec5:	89 d7                	mov    %edx,%edi
c0103ec7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103eca:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ecd:	89 d0                	mov    %edx,%eax
c0103ecf:	c1 e0 02             	shl    $0x2,%eax
c0103ed2:	01 d0                	add    %edx,%eax
c0103ed4:	c1 e0 02             	shl    $0x2,%eax
c0103ed7:	01 c8                	add    %ecx,%eax
c0103ed9:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103edc:	8b 58 10             	mov    0x10(%eax),%ebx
c0103edf:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103ee5:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103ee9:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103eed:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103ef1:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103ef4:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103ef7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103efb:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103eff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103f03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103f07:	c7 04 24 78 69 10 c0 	movl   $0xc0106978,(%esp)
c0103f0e:	e8 35 c4 ff ff       	call   c0100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103f13:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f16:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f19:	89 d0                	mov    %edx,%eax
c0103f1b:	c1 e0 02             	shl    $0x2,%eax
c0103f1e:	01 d0                	add    %edx,%eax
c0103f20:	c1 e0 02             	shl    $0x2,%eax
c0103f23:	01 c8                	add    %ecx,%eax
c0103f25:	83 c0 14             	add    $0x14,%eax
c0103f28:	8b 00                	mov    (%eax),%eax
c0103f2a:	83 f8 01             	cmp    $0x1,%eax
c0103f2d:	75 36                	jne    c0103f65 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f35:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f38:	77 2b                	ja     c0103f65 <page_init+0x14a>
c0103f3a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103f3d:	72 05                	jb     c0103f44 <page_init+0x129>
c0103f3f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103f42:	73 21                	jae    c0103f65 <page_init+0x14a>
c0103f44:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f48:	77 1b                	ja     c0103f65 <page_init+0x14a>
c0103f4a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103f4e:	72 09                	jb     c0103f59 <page_init+0x13e>
c0103f50:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103f57:	77 0c                	ja     c0103f65 <page_init+0x14a>
                maxpa = end;
c0103f59:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f5c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103f62:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f65:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f6c:	8b 00                	mov    (%eax),%eax
c0103f6e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f71:	0f 8f dd fe ff ff    	jg     c0103e54 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f7b:	72 1d                	jb     c0103f9a <page_init+0x17f>
c0103f7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f81:	77 09                	ja     c0103f8c <page_init+0x171>
c0103f83:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f8a:	76 0e                	jbe    c0103f9a <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f8c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f93:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103fa0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103fa4:	c1 ea 0c             	shr    $0xc,%edx
c0103fa7:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103fac:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103fb3:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c0103fb8:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103fbb:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103fbe:	01 d0                	add    %edx,%eax
c0103fc0:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103fc3:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103fc6:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fcb:	f7 75 ac             	divl   -0x54(%ebp)
c0103fce:	89 d0                	mov    %edx,%eax
c0103fd0:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103fd3:	29 c2                	sub    %eax,%edx
c0103fd5:	89 d0                	mov    %edx,%eax
c0103fd7:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    for (i = 0; i < npage; i ++) {
c0103fdc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fe3:	eb 2f                	jmp    c0104014 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103fe5:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103feb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fee:	89 d0                	mov    %edx,%eax
c0103ff0:	c1 e0 02             	shl    $0x2,%eax
c0103ff3:	01 d0                	add    %edx,%eax
c0103ff5:	c1 e0 02             	shl    $0x2,%eax
c0103ff8:	01 c8                	add    %ecx,%eax
c0103ffa:	83 c0 04             	add    $0x4,%eax
c0103ffd:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104004:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104007:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010400a:	8b 55 90             	mov    -0x70(%ebp),%edx
c010400d:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104010:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104014:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104017:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010401c:	39 c2                	cmp    %eax,%edx
c010401e:	72 c5                	jb     c0103fe5 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104020:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104026:	89 d0                	mov    %edx,%eax
c0104028:	c1 e0 02             	shl    $0x2,%eax
c010402b:	01 d0                	add    %edx,%eax
c010402d:	c1 e0 02             	shl    $0x2,%eax
c0104030:	89 c2                	mov    %eax,%edx
c0104032:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0104037:	01 d0                	add    %edx,%eax
c0104039:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010403c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104043:	77 23                	ja     c0104068 <page_init+0x24d>
c0104045:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104048:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010404c:	c7 44 24 08 a8 69 10 	movl   $0xc01069a8,0x8(%esp)
c0104053:	c0 
c0104054:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010405b:	00 
c010405c:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104063:	e8 64 cc ff ff       	call   c0100ccc <__panic>
c0104068:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010406b:	05 00 00 00 40       	add    $0x40000000,%eax
c0104070:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104073:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010407a:	e9 74 01 00 00       	jmp    c01041f3 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010407f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104082:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104085:	89 d0                	mov    %edx,%eax
c0104087:	c1 e0 02             	shl    $0x2,%eax
c010408a:	01 d0                	add    %edx,%eax
c010408c:	c1 e0 02             	shl    $0x2,%eax
c010408f:	01 c8                	add    %ecx,%eax
c0104091:	8b 50 08             	mov    0x8(%eax),%edx
c0104094:	8b 40 04             	mov    0x4(%eax),%eax
c0104097:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010409a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010409d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040a3:	89 d0                	mov    %edx,%eax
c01040a5:	c1 e0 02             	shl    $0x2,%eax
c01040a8:	01 d0                	add    %edx,%eax
c01040aa:	c1 e0 02             	shl    $0x2,%eax
c01040ad:	01 c8                	add    %ecx,%eax
c01040af:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040b2:	8b 58 10             	mov    0x10(%eax),%ebx
c01040b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040bb:	01 c8                	add    %ecx,%eax
c01040bd:	11 da                	adc    %ebx,%edx
c01040bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040c2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01040c5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040cb:	89 d0                	mov    %edx,%eax
c01040cd:	c1 e0 02             	shl    $0x2,%eax
c01040d0:	01 d0                	add    %edx,%eax
c01040d2:	c1 e0 02             	shl    $0x2,%eax
c01040d5:	01 c8                	add    %ecx,%eax
c01040d7:	83 c0 14             	add    $0x14,%eax
c01040da:	8b 00                	mov    (%eax),%eax
c01040dc:	83 f8 01             	cmp    $0x1,%eax
c01040df:	0f 85 0a 01 00 00    	jne    c01041ef <page_init+0x3d4>
            if (begin < freemem) {
c01040e5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040e8:	ba 00 00 00 00       	mov    $0x0,%edx
c01040ed:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040f0:	72 17                	jb     c0104109 <page_init+0x2ee>
c01040f2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01040f5:	77 05                	ja     c01040fc <page_init+0x2e1>
c01040f7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01040fa:	76 0d                	jbe    c0104109 <page_init+0x2ee>
                begin = freemem;
c01040fc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104102:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104109:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010410d:	72 1d                	jb     c010412c <page_init+0x311>
c010410f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104113:	77 09                	ja     c010411e <page_init+0x303>
c0104115:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010411c:	76 0e                	jbe    c010412c <page_init+0x311>
                end = KMEMSIZE;
c010411e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104125:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010412c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010412f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104132:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104135:	0f 87 b4 00 00 00    	ja     c01041ef <page_init+0x3d4>
c010413b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010413e:	72 09                	jb     c0104149 <page_init+0x32e>
c0104140:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104143:	0f 83 a6 00 00 00    	jae    c01041ef <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104149:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104150:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104153:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104156:	01 d0                	add    %edx,%eax
c0104158:	83 e8 01             	sub    $0x1,%eax
c010415b:	89 45 98             	mov    %eax,-0x68(%ebp)
c010415e:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104161:	ba 00 00 00 00       	mov    $0x0,%edx
c0104166:	f7 75 9c             	divl   -0x64(%ebp)
c0104169:	89 d0                	mov    %edx,%eax
c010416b:	8b 55 98             	mov    -0x68(%ebp),%edx
c010416e:	29 c2                	sub    %eax,%edx
c0104170:	89 d0                	mov    %edx,%eax
c0104172:	ba 00 00 00 00       	mov    $0x0,%edx
c0104177:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010417a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010417d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104180:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104183:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104186:	ba 00 00 00 00       	mov    $0x0,%edx
c010418b:	89 c7                	mov    %eax,%edi
c010418d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104193:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104196:	89 d0                	mov    %edx,%eax
c0104198:	83 e0 00             	and    $0x0,%eax
c010419b:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010419e:	8b 45 80             	mov    -0x80(%ebp),%eax
c01041a1:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01041a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01041a7:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01041aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01041b0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01041b3:	77 3a                	ja     c01041ef <page_init+0x3d4>
c01041b5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01041b8:	72 05                	jb     c01041bf <page_init+0x3a4>
c01041ba:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01041bd:	73 30                	jae    c01041ef <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01041bf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01041c2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01041c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01041c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01041cb:	29 c8                	sub    %ecx,%eax
c01041cd:	19 da                	sbb    %ebx,%edx
c01041cf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01041d3:	c1 ea 0c             	shr    $0xc,%edx
c01041d6:	89 c3                	mov    %eax,%ebx
c01041d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01041db:	89 04 24             	mov    %eax,(%esp)
c01041de:	e8 b2 f8 ff ff       	call   c0103a95 <pa2page>
c01041e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01041e7:	89 04 24             	mov    %eax,(%esp)
c01041ea:	e8 78 fb ff ff       	call   c0103d67 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01041ef:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01041f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01041f6:	8b 00                	mov    (%eax),%eax
c01041f8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01041fb:	0f 8f 7e fe ff ff    	jg     c010407f <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104201:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104207:	5b                   	pop    %ebx
c0104208:	5e                   	pop    %esi
c0104209:	5f                   	pop    %edi
c010420a:	5d                   	pop    %ebp
c010420b:	c3                   	ret    

c010420c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010420c:	55                   	push   %ebp
c010420d:	89 e5                	mov    %esp,%ebp
c010420f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104212:	8b 45 14             	mov    0x14(%ebp),%eax
c0104215:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104218:	31 d0                	xor    %edx,%eax
c010421a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010421f:	85 c0                	test   %eax,%eax
c0104221:	74 24                	je     c0104247 <boot_map_segment+0x3b>
c0104223:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c010422a:	c0 
c010422b:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104232:	c0 
c0104233:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010423a:	00 
c010423b:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104242:	e8 85 ca ff ff       	call   c0100ccc <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104247:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010424e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104251:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104256:	89 c2                	mov    %eax,%edx
c0104258:	8b 45 10             	mov    0x10(%ebp),%eax
c010425b:	01 c2                	add    %eax,%edx
c010425d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104260:	01 d0                	add    %edx,%eax
c0104262:	83 e8 01             	sub    $0x1,%eax
c0104265:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104268:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010426b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104270:	f7 75 f0             	divl   -0x10(%ebp)
c0104273:	89 d0                	mov    %edx,%eax
c0104275:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104278:	29 c2                	sub    %eax,%edx
c010427a:	89 d0                	mov    %edx,%eax
c010427c:	c1 e8 0c             	shr    $0xc,%eax
c010427f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104282:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104285:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104288:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010428b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104290:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104293:	8b 45 14             	mov    0x14(%ebp),%eax
c0104296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010429c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01042a1:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042a4:	eb 6b                	jmp    c0104311 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01042a6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01042ad:	00 
c01042ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01042b8:	89 04 24             	mov    %eax,(%esp)
c01042bb:	e8 82 01 00 00       	call   c0104442 <get_pte>
c01042c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01042c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01042c7:	75 24                	jne    c01042ed <boot_map_segment+0xe1>
c01042c9:	c7 44 24 0c 06 6a 10 	movl   $0xc0106a06,0xc(%esp)
c01042d0:	c0 
c01042d1:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c01042d8:	c0 
c01042d9:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c01042e0:	00 
c01042e1:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c01042e8:	e8 df c9 ff ff       	call   c0100ccc <__panic>
        *ptep = pa | PTE_P | perm;
c01042ed:	8b 45 18             	mov    0x18(%ebp),%eax
c01042f0:	8b 55 14             	mov    0x14(%ebp),%edx
c01042f3:	09 d0                	or     %edx,%eax
c01042f5:	83 c8 01             	or     $0x1,%eax
c01042f8:	89 c2                	mov    %eax,%edx
c01042fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042fd:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042ff:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104303:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010430a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104315:	75 8f                	jne    c01042a6 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104317:	c9                   	leave  
c0104318:	c3                   	ret    

c0104319 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104319:	55                   	push   %ebp
c010431a:	89 e5                	mov    %esp,%ebp
c010431c:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010431f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104326:	e8 5b fa ff ff       	call   c0103d86 <alloc_pages>
c010432b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010432e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104332:	75 1c                	jne    c0104350 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104334:	c7 44 24 08 13 6a 10 	movl   $0xc0106a13,0x8(%esp)
c010433b:	c0 
c010433c:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0104343:	00 
c0104344:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c010434b:	e8 7c c9 ff ff       	call   c0100ccc <__panic>
    }
    return page2kva(p);
c0104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104353:	89 04 24             	mov    %eax,(%esp)
c0104356:	e8 89 f7 ff ff       	call   c0103ae4 <page2kva>
}
c010435b:	c9                   	leave  
c010435c:	c3                   	ret    

c010435d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010435d:	55                   	push   %ebp
c010435e:	89 e5                	mov    %esp,%ebp
c0104360:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104363:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104368:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010436b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104372:	77 23                	ja     c0104397 <pmm_init+0x3a>
c0104374:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104377:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010437b:	c7 44 24 08 a8 69 10 	movl   $0xc01069a8,0x8(%esp)
c0104382:	c0 
c0104383:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010438a:	00 
c010438b:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104392:	e8 35 c9 ff ff       	call   c0100ccc <__panic>
c0104397:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439a:	05 00 00 00 40       	add    $0x40000000,%eax
c010439f:	a3 20 af 11 c0       	mov    %eax,0xc011af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01043a4:	e8 8b f9 ff ff       	call   c0103d34 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01043a9:	e8 6d fa ff ff       	call   c0103e1b <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01043ae:	e8 4c 02 00 00       	call   c01045ff <check_alloc_page>

    check_pgdir();
c01043b3:	e8 65 02 00 00       	call   c010461d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01043b8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01043bd:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043c3:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01043c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043cb:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043d2:	77 23                	ja     c01043f7 <pmm_init+0x9a>
c01043d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043db:	c7 44 24 08 a8 69 10 	movl   $0xc01069a8,0x8(%esp)
c01043e2:	c0 
c01043e3:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01043ea:	00 
c01043eb:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c01043f2:	e8 d5 c8 ff ff       	call   c0100ccc <__panic>
c01043f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043fa:	05 00 00 00 40       	add    $0x40000000,%eax
c01043ff:	83 c8 03             	or     $0x3,%eax
c0104402:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104404:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104409:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104410:	00 
c0104411:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104418:	00 
c0104419:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104420:	38 
c0104421:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104428:	c0 
c0104429:	89 04 24             	mov    %eax,(%esp)
c010442c:	e8 db fd ff ff       	call   c010420c <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104431:	e8 0f f8 ff ff       	call   c0103c45 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104436:	e8 7d 08 00 00       	call   c0104cb8 <check_boot_pgdir>

    print_pgdir();
c010443b:	e8 05 0d 00 00       	call   c0105145 <print_pgdir>

}
c0104440:	c9                   	leave  
c0104441:	c3                   	ret    

c0104442 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104442:	55                   	push   %ebp
c0104443:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c0104445:	5d                   	pop    %ebp
c0104446:	c3                   	ret    

c0104447 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104447:	55                   	push   %ebp
c0104448:	89 e5                	mov    %esp,%ebp
c010444a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010444d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104454:	00 
c0104455:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104458:	89 44 24 04          	mov    %eax,0x4(%esp)
c010445c:	8b 45 08             	mov    0x8(%ebp),%eax
c010445f:	89 04 24             	mov    %eax,(%esp)
c0104462:	e8 db ff ff ff       	call   c0104442 <get_pte>
c0104467:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010446a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010446e:	74 08                	je     c0104478 <get_page+0x31>
        *ptep_store = ptep;
c0104470:	8b 45 10             	mov    0x10(%ebp),%eax
c0104473:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104476:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010447c:	74 1b                	je     c0104499 <get_page+0x52>
c010447e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104481:	8b 00                	mov    (%eax),%eax
c0104483:	83 e0 01             	and    $0x1,%eax
c0104486:	85 c0                	test   %eax,%eax
c0104488:	74 0f                	je     c0104499 <get_page+0x52>
        return pte2page(*ptep);
c010448a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010448d:	8b 00                	mov    (%eax),%eax
c010448f:	89 04 24             	mov    %eax,(%esp)
c0104492:	e8 a1 f6 ff ff       	call   c0103b38 <pte2page>
c0104497:	eb 05                	jmp    c010449e <get_page+0x57>
    }
    return NULL;
c0104499:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010449e:	c9                   	leave  
c010449f:	c3                   	ret    

c01044a0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01044a0:	55                   	push   %ebp
c01044a1:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01044a3:	5d                   	pop    %ebp
c01044a4:	c3                   	ret    

c01044a5 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01044a5:	55                   	push   %ebp
c01044a6:	89 e5                	mov    %esp,%ebp
c01044a8:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01044ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044b2:	00 
c01044b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01044bd:	89 04 24             	mov    %eax,(%esp)
c01044c0:	e8 7d ff ff ff       	call   c0104442 <get_pte>
c01044c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01044c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01044cc:	74 19                	je     c01044e7 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01044ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01044d1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01044d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01044df:	89 04 24             	mov    %eax,(%esp)
c01044e2:	e8 b9 ff ff ff       	call   c01044a0 <page_remove_pte>
    }
}
c01044e7:	c9                   	leave  
c01044e8:	c3                   	ret    

c01044e9 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01044e9:	55                   	push   %ebp
c01044ea:	89 e5                	mov    %esp,%ebp
c01044ec:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01044ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01044f6:	00 
c01044f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01044fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0104501:	89 04 24             	mov    %eax,(%esp)
c0104504:	e8 39 ff ff ff       	call   c0104442 <get_pte>
c0104509:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010450c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104510:	75 0a                	jne    c010451c <page_insert+0x33>
        return -E_NO_MEM;
c0104512:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104517:	e9 84 00 00 00       	jmp    c01045a0 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010451c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010451f:	89 04 24             	mov    %eax,(%esp)
c0104522:	e8 71 f6 ff ff       	call   c0103b98 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104527:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452a:	8b 00                	mov    (%eax),%eax
c010452c:	83 e0 01             	and    $0x1,%eax
c010452f:	85 c0                	test   %eax,%eax
c0104531:	74 3e                	je     c0104571 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104533:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104536:	8b 00                	mov    (%eax),%eax
c0104538:	89 04 24             	mov    %eax,(%esp)
c010453b:	e8 f8 f5 ff ff       	call   c0103b38 <pte2page>
c0104540:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0104543:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104546:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104549:	75 0d                	jne    c0104558 <page_insert+0x6f>
            page_ref_dec(page);
c010454b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010454e:	89 04 24             	mov    %eax,(%esp)
c0104551:	e8 59 f6 ff ff       	call   c0103baf <page_ref_dec>
c0104556:	eb 19                	jmp    c0104571 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104558:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010455b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010455f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104562:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104566:	8b 45 08             	mov    0x8(%ebp),%eax
c0104569:	89 04 24             	mov    %eax,(%esp)
c010456c:	e8 2f ff ff ff       	call   c01044a0 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104571:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104574:	89 04 24             	mov    %eax,(%esp)
c0104577:	e8 03 f5 ff ff       	call   c0103a7f <page2pa>
c010457c:	0b 45 14             	or     0x14(%ebp),%eax
c010457f:	83 c8 01             	or     $0x1,%eax
c0104582:	89 c2                	mov    %eax,%edx
c0104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104587:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104589:	8b 45 10             	mov    0x10(%ebp),%eax
c010458c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104590:	8b 45 08             	mov    0x8(%ebp),%eax
c0104593:	89 04 24             	mov    %eax,(%esp)
c0104596:	e8 07 00 00 00       	call   c01045a2 <tlb_invalidate>
    return 0;
c010459b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045a0:	c9                   	leave  
c01045a1:	c3                   	ret    

c01045a2 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01045a2:	55                   	push   %ebp
c01045a3:	89 e5                	mov    %esp,%ebp
c01045a5:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01045a8:	0f 20 d8             	mov    %cr3,%eax
c01045ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01045ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01045b1:	89 c2                	mov    %eax,%edx
c01045b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045b9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01045c0:	77 23                	ja     c01045e5 <tlb_invalidate+0x43>
c01045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045c9:	c7 44 24 08 a8 69 10 	movl   $0xc01069a8,0x8(%esp)
c01045d0:	c0 
c01045d1:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c01045d8:	00 
c01045d9:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c01045e0:	e8 e7 c6 ff ff       	call   c0100ccc <__panic>
c01045e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045e8:	05 00 00 00 40       	add    $0x40000000,%eax
c01045ed:	39 c2                	cmp    %eax,%edx
c01045ef:	75 0c                	jne    c01045fd <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01045f1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01045f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045fa:	0f 01 38             	invlpg (%eax)
    }
}
c01045fd:	c9                   	leave  
c01045fe:	c3                   	ret    

c01045ff <check_alloc_page>:

static void
check_alloc_page(void) {
c01045ff:	55                   	push   %ebp
c0104600:	89 e5                	mov    %esp,%ebp
c0104602:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104605:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c010460a:	8b 40 18             	mov    0x18(%eax),%eax
c010460d:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c010460f:	c7 04 24 2c 6a 10 c0 	movl   $0xc0106a2c,(%esp)
c0104616:	e8 2d bd ff ff       	call   c0100348 <cprintf>
}
c010461b:	c9                   	leave  
c010461c:	c3                   	ret    

c010461d <check_pgdir>:

static void
check_pgdir(void) {
c010461d:	55                   	push   %ebp
c010461e:	89 e5                	mov    %esp,%ebp
c0104620:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104623:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104628:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010462d:	76 24                	jbe    c0104653 <check_pgdir+0x36>
c010462f:	c7 44 24 0c 4b 6a 10 	movl   $0xc0106a4b,0xc(%esp)
c0104636:	c0 
c0104637:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c010463e:	c0 
c010463f:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c0104646:	00 
c0104647:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c010464e:	e8 79 c6 ff ff       	call   c0100ccc <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104653:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104658:	85 c0                	test   %eax,%eax
c010465a:	74 0e                	je     c010466a <check_pgdir+0x4d>
c010465c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104661:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104666:	85 c0                	test   %eax,%eax
c0104668:	74 24                	je     c010468e <check_pgdir+0x71>
c010466a:	c7 44 24 0c 68 6a 10 	movl   $0xc0106a68,0xc(%esp)
c0104671:	c0 
c0104672:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104679:	c0 
c010467a:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c0104681:	00 
c0104682:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104689:	e8 3e c6 ff ff       	call   c0100ccc <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010468e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104693:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010469a:	00 
c010469b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046a2:	00 
c01046a3:	89 04 24             	mov    %eax,(%esp)
c01046a6:	e8 9c fd ff ff       	call   c0104447 <get_page>
c01046ab:	85 c0                	test   %eax,%eax
c01046ad:	74 24                	je     c01046d3 <check_pgdir+0xb6>
c01046af:	c7 44 24 0c a0 6a 10 	movl   $0xc0106aa0,0xc(%esp)
c01046b6:	c0 
c01046b7:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c01046be:	c0 
c01046bf:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c01046c6:	00 
c01046c7:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c01046ce:	e8 f9 c5 ff ff       	call   c0100ccc <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01046d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046da:	e8 a7 f6 ff ff       	call   c0103d86 <alloc_pages>
c01046df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01046e2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01046e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01046ee:	00 
c01046ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046f6:	00 
c01046f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01046fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046fe:	89 04 24             	mov    %eax,(%esp)
c0104701:	e8 e3 fd ff ff       	call   c01044e9 <page_insert>
c0104706:	85 c0                	test   %eax,%eax
c0104708:	74 24                	je     c010472e <check_pgdir+0x111>
c010470a:	c7 44 24 0c c8 6a 10 	movl   $0xc0106ac8,0xc(%esp)
c0104711:	c0 
c0104712:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104719:	c0 
c010471a:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c0104721:	00 
c0104722:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104729:	e8 9e c5 ff ff       	call   c0100ccc <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010472e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104733:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010473a:	00 
c010473b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104742:	00 
c0104743:	89 04 24             	mov    %eax,(%esp)
c0104746:	e8 f7 fc ff ff       	call   c0104442 <get_pte>
c010474b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010474e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104752:	75 24                	jne    c0104778 <check_pgdir+0x15b>
c0104754:	c7 44 24 0c f4 6a 10 	movl   $0xc0106af4,0xc(%esp)
c010475b:	c0 
c010475c:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104763:	c0 
c0104764:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c010476b:	00 
c010476c:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104773:	e8 54 c5 ff ff       	call   c0100ccc <__panic>
    assert(pte2page(*ptep) == p1);
c0104778:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010477b:	8b 00                	mov    (%eax),%eax
c010477d:	89 04 24             	mov    %eax,(%esp)
c0104780:	e8 b3 f3 ff ff       	call   c0103b38 <pte2page>
c0104785:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104788:	74 24                	je     c01047ae <check_pgdir+0x191>
c010478a:	c7 44 24 0c 21 6b 10 	movl   $0xc0106b21,0xc(%esp)
c0104791:	c0 
c0104792:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104799:	c0 
c010479a:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c01047a1:	00 
c01047a2:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c01047a9:	e8 1e c5 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p1) == 1);
c01047ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b1:	89 04 24             	mov    %eax,(%esp)
c01047b4:	e8 d5 f3 ff ff       	call   c0103b8e <page_ref>
c01047b9:	83 f8 01             	cmp    $0x1,%eax
c01047bc:	74 24                	je     c01047e2 <check_pgdir+0x1c5>
c01047be:	c7 44 24 0c 37 6b 10 	movl   $0xc0106b37,0xc(%esp)
c01047c5:	c0 
c01047c6:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c01047cd:	c0 
c01047ce:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c01047d5:	00 
c01047d6:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c01047dd:	e8 ea c4 ff ff       	call   c0100ccc <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01047e2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01047e7:	8b 00                	mov    (%eax),%eax
c01047e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01047ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01047f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047f4:	c1 e8 0c             	shr    $0xc,%eax
c01047f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01047fa:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01047ff:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104802:	72 23                	jb     c0104827 <check_pgdir+0x20a>
c0104804:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104807:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010480b:	c7 44 24 08 04 69 10 	movl   $0xc0106904,0x8(%esp)
c0104812:	c0 
c0104813:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c010481a:	00 
c010481b:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104822:	e8 a5 c4 ff ff       	call   c0100ccc <__panic>
c0104827:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010482a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010482f:	83 c0 04             	add    $0x4,%eax
c0104832:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104835:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010483a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104841:	00 
c0104842:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104849:	00 
c010484a:	89 04 24             	mov    %eax,(%esp)
c010484d:	e8 f0 fb ff ff       	call   c0104442 <get_pte>
c0104852:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104855:	74 24                	je     c010487b <check_pgdir+0x25e>
c0104857:	c7 44 24 0c 4c 6b 10 	movl   $0xc0106b4c,0xc(%esp)
c010485e:	c0 
c010485f:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104866:	c0 
c0104867:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c010486e:	00 
c010486f:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104876:	e8 51 c4 ff ff       	call   c0100ccc <__panic>

    p2 = alloc_page();
c010487b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104882:	e8 ff f4 ff ff       	call   c0103d86 <alloc_pages>
c0104887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010488a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010488f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104896:	00 
c0104897:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010489e:	00 
c010489f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01048a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048a6:	89 04 24             	mov    %eax,(%esp)
c01048a9:	e8 3b fc ff ff       	call   c01044e9 <page_insert>
c01048ae:	85 c0                	test   %eax,%eax
c01048b0:	74 24                	je     c01048d6 <check_pgdir+0x2b9>
c01048b2:	c7 44 24 0c 74 6b 10 	movl   $0xc0106b74,0xc(%esp)
c01048b9:	c0 
c01048ba:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c01048c1:	c0 
c01048c2:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c01048c9:	00 
c01048ca:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c01048d1:	e8 f6 c3 ff ff       	call   c0100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01048d6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01048db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048e2:	00 
c01048e3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01048ea:	00 
c01048eb:	89 04 24             	mov    %eax,(%esp)
c01048ee:	e8 4f fb ff ff       	call   c0104442 <get_pte>
c01048f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048fa:	75 24                	jne    c0104920 <check_pgdir+0x303>
c01048fc:	c7 44 24 0c ac 6b 10 	movl   $0xc0106bac,0xc(%esp)
c0104903:	c0 
c0104904:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c010490b:	c0 
c010490c:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c0104913:	00 
c0104914:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c010491b:	e8 ac c3 ff ff       	call   c0100ccc <__panic>
    assert(*ptep & PTE_U);
c0104920:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104923:	8b 00                	mov    (%eax),%eax
c0104925:	83 e0 04             	and    $0x4,%eax
c0104928:	85 c0                	test   %eax,%eax
c010492a:	75 24                	jne    c0104950 <check_pgdir+0x333>
c010492c:	c7 44 24 0c dc 6b 10 	movl   $0xc0106bdc,0xc(%esp)
c0104933:	c0 
c0104934:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c010493b:	c0 
c010493c:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c0104943:	00 
c0104944:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c010494b:	e8 7c c3 ff ff       	call   c0100ccc <__panic>
    assert(*ptep & PTE_W);
c0104950:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104953:	8b 00                	mov    (%eax),%eax
c0104955:	83 e0 02             	and    $0x2,%eax
c0104958:	85 c0                	test   %eax,%eax
c010495a:	75 24                	jne    c0104980 <check_pgdir+0x363>
c010495c:	c7 44 24 0c ea 6b 10 	movl   $0xc0106bea,0xc(%esp)
c0104963:	c0 
c0104964:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c010496b:	c0 
c010496c:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0104973:	00 
c0104974:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c010497b:	e8 4c c3 ff ff       	call   c0100ccc <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104980:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104985:	8b 00                	mov    (%eax),%eax
c0104987:	83 e0 04             	and    $0x4,%eax
c010498a:	85 c0                	test   %eax,%eax
c010498c:	75 24                	jne    c01049b2 <check_pgdir+0x395>
c010498e:	c7 44 24 0c f8 6b 10 	movl   $0xc0106bf8,0xc(%esp)
c0104995:	c0 
c0104996:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c010499d:	c0 
c010499e:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01049a5:	00 
c01049a6:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c01049ad:	e8 1a c3 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 1);
c01049b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049b5:	89 04 24             	mov    %eax,(%esp)
c01049b8:	e8 d1 f1 ff ff       	call   c0103b8e <page_ref>
c01049bd:	83 f8 01             	cmp    $0x1,%eax
c01049c0:	74 24                	je     c01049e6 <check_pgdir+0x3c9>
c01049c2:	c7 44 24 0c 0e 6c 10 	movl   $0xc0106c0e,0xc(%esp)
c01049c9:	c0 
c01049ca:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c01049d1:	c0 
c01049d2:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c01049d9:	00 
c01049da:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c01049e1:	e8 e6 c2 ff ff       	call   c0100ccc <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01049e6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01049eb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01049f2:	00 
c01049f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01049fa:	00 
c01049fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01049fe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a02:	89 04 24             	mov    %eax,(%esp)
c0104a05:	e8 df fa ff ff       	call   c01044e9 <page_insert>
c0104a0a:	85 c0                	test   %eax,%eax
c0104a0c:	74 24                	je     c0104a32 <check_pgdir+0x415>
c0104a0e:	c7 44 24 0c 20 6c 10 	movl   $0xc0106c20,0xc(%esp)
c0104a15:	c0 
c0104a16:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104a1d:	c0 
c0104a1e:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0104a25:	00 
c0104a26:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104a2d:	e8 9a c2 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p1) == 2);
c0104a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a35:	89 04 24             	mov    %eax,(%esp)
c0104a38:	e8 51 f1 ff ff       	call   c0103b8e <page_ref>
c0104a3d:	83 f8 02             	cmp    $0x2,%eax
c0104a40:	74 24                	je     c0104a66 <check_pgdir+0x449>
c0104a42:	c7 44 24 0c 4c 6c 10 	movl   $0xc0106c4c,0xc(%esp)
c0104a49:	c0 
c0104a4a:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104a51:	c0 
c0104a52:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0104a59:	00 
c0104a5a:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104a61:	e8 66 c2 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 0);
c0104a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a69:	89 04 24             	mov    %eax,(%esp)
c0104a6c:	e8 1d f1 ff ff       	call   c0103b8e <page_ref>
c0104a71:	85 c0                	test   %eax,%eax
c0104a73:	74 24                	je     c0104a99 <check_pgdir+0x47c>
c0104a75:	c7 44 24 0c 5e 6c 10 	movl   $0xc0106c5e,0xc(%esp)
c0104a7c:	c0 
c0104a7d:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104a84:	c0 
c0104a85:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104a8c:	00 
c0104a8d:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104a94:	e8 33 c2 ff ff       	call   c0100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a99:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a9e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104aa5:	00 
c0104aa6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104aad:	00 
c0104aae:	89 04 24             	mov    %eax,(%esp)
c0104ab1:	e8 8c f9 ff ff       	call   c0104442 <get_pte>
c0104ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ab9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104abd:	75 24                	jne    c0104ae3 <check_pgdir+0x4c6>
c0104abf:	c7 44 24 0c ac 6b 10 	movl   $0xc0106bac,0xc(%esp)
c0104ac6:	c0 
c0104ac7:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104ace:	c0 
c0104acf:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104ad6:	00 
c0104ad7:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104ade:	e8 e9 c1 ff ff       	call   c0100ccc <__panic>
    assert(pte2page(*ptep) == p1);
c0104ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ae6:	8b 00                	mov    (%eax),%eax
c0104ae8:	89 04 24             	mov    %eax,(%esp)
c0104aeb:	e8 48 f0 ff ff       	call   c0103b38 <pte2page>
c0104af0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104af3:	74 24                	je     c0104b19 <check_pgdir+0x4fc>
c0104af5:	c7 44 24 0c 21 6b 10 	movl   $0xc0106b21,0xc(%esp)
c0104afc:	c0 
c0104afd:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104b04:	c0 
c0104b05:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104b0c:	00 
c0104b0d:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104b14:	e8 b3 c1 ff ff       	call   c0100ccc <__panic>
    assert((*ptep & PTE_U) == 0);
c0104b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b1c:	8b 00                	mov    (%eax),%eax
c0104b1e:	83 e0 04             	and    $0x4,%eax
c0104b21:	85 c0                	test   %eax,%eax
c0104b23:	74 24                	je     c0104b49 <check_pgdir+0x52c>
c0104b25:	c7 44 24 0c 70 6c 10 	movl   $0xc0106c70,0xc(%esp)
c0104b2c:	c0 
c0104b2d:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104b34:	c0 
c0104b35:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104b3c:	00 
c0104b3d:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104b44:	e8 83 c1 ff ff       	call   c0100ccc <__panic>

    page_remove(boot_pgdir, 0x0);
c0104b49:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b55:	00 
c0104b56:	89 04 24             	mov    %eax,(%esp)
c0104b59:	e8 47 f9 ff ff       	call   c01044a5 <page_remove>
    assert(page_ref(p1) == 1);
c0104b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b61:	89 04 24             	mov    %eax,(%esp)
c0104b64:	e8 25 f0 ff ff       	call   c0103b8e <page_ref>
c0104b69:	83 f8 01             	cmp    $0x1,%eax
c0104b6c:	74 24                	je     c0104b92 <check_pgdir+0x575>
c0104b6e:	c7 44 24 0c 37 6b 10 	movl   $0xc0106b37,0xc(%esp)
c0104b75:	c0 
c0104b76:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104b7d:	c0 
c0104b7e:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104b85:	00 
c0104b86:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104b8d:	e8 3a c1 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 0);
c0104b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b95:	89 04 24             	mov    %eax,(%esp)
c0104b98:	e8 f1 ef ff ff       	call   c0103b8e <page_ref>
c0104b9d:	85 c0                	test   %eax,%eax
c0104b9f:	74 24                	je     c0104bc5 <check_pgdir+0x5a8>
c0104ba1:	c7 44 24 0c 5e 6c 10 	movl   $0xc0106c5e,0xc(%esp)
c0104ba8:	c0 
c0104ba9:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104bb0:	c0 
c0104bb1:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104bb8:	00 
c0104bb9:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104bc0:	e8 07 c1 ff ff       	call   c0100ccc <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104bc5:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104bca:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104bd1:	00 
c0104bd2:	89 04 24             	mov    %eax,(%esp)
c0104bd5:	e8 cb f8 ff ff       	call   c01044a5 <page_remove>
    assert(page_ref(p1) == 0);
c0104bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bdd:	89 04 24             	mov    %eax,(%esp)
c0104be0:	e8 a9 ef ff ff       	call   c0103b8e <page_ref>
c0104be5:	85 c0                	test   %eax,%eax
c0104be7:	74 24                	je     c0104c0d <check_pgdir+0x5f0>
c0104be9:	c7 44 24 0c 85 6c 10 	movl   $0xc0106c85,0xc(%esp)
c0104bf0:	c0 
c0104bf1:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104bf8:	c0 
c0104bf9:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104c00:	00 
c0104c01:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104c08:	e8 bf c0 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 0);
c0104c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c10:	89 04 24             	mov    %eax,(%esp)
c0104c13:	e8 76 ef ff ff       	call   c0103b8e <page_ref>
c0104c18:	85 c0                	test   %eax,%eax
c0104c1a:	74 24                	je     c0104c40 <check_pgdir+0x623>
c0104c1c:	c7 44 24 0c 5e 6c 10 	movl   $0xc0106c5e,0xc(%esp)
c0104c23:	c0 
c0104c24:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104c2b:	c0 
c0104c2c:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104c33:	00 
c0104c34:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104c3b:	e8 8c c0 ff ff       	call   c0100ccc <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104c40:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c45:	8b 00                	mov    (%eax),%eax
c0104c47:	89 04 24             	mov    %eax,(%esp)
c0104c4a:	e8 27 ef ff ff       	call   c0103b76 <pde2page>
c0104c4f:	89 04 24             	mov    %eax,(%esp)
c0104c52:	e8 37 ef ff ff       	call   c0103b8e <page_ref>
c0104c57:	83 f8 01             	cmp    $0x1,%eax
c0104c5a:	74 24                	je     c0104c80 <check_pgdir+0x663>
c0104c5c:	c7 44 24 0c 98 6c 10 	movl   $0xc0106c98,0xc(%esp)
c0104c63:	c0 
c0104c64:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104c6b:	c0 
c0104c6c:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104c73:	00 
c0104c74:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104c7b:	e8 4c c0 ff ff       	call   c0100ccc <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104c80:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c85:	8b 00                	mov    (%eax),%eax
c0104c87:	89 04 24             	mov    %eax,(%esp)
c0104c8a:	e8 e7 ee ff ff       	call   c0103b76 <pde2page>
c0104c8f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c96:	00 
c0104c97:	89 04 24             	mov    %eax,(%esp)
c0104c9a:	e8 1f f1 ff ff       	call   c0103dbe <free_pages>
    boot_pgdir[0] = 0;
c0104c9f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104ca4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104caa:	c7 04 24 bf 6c 10 c0 	movl   $0xc0106cbf,(%esp)
c0104cb1:	e8 92 b6 ff ff       	call   c0100348 <cprintf>
}
c0104cb6:	c9                   	leave  
c0104cb7:	c3                   	ret    

c0104cb8 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104cb8:	55                   	push   %ebp
c0104cb9:	89 e5                	mov    %esp,%ebp
c0104cbb:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104cc5:	e9 ca 00 00 00       	jmp    c0104d94 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cd3:	c1 e8 0c             	shr    $0xc,%eax
c0104cd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104cd9:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104cde:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104ce1:	72 23                	jb     c0104d06 <check_boot_pgdir+0x4e>
c0104ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ce6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104cea:	c7 44 24 08 04 69 10 	movl   $0xc0106904,0x8(%esp)
c0104cf1:	c0 
c0104cf2:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104cf9:	00 
c0104cfa:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104d01:	e8 c6 bf ff ff       	call   c0100ccc <__panic>
c0104d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d09:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104d0e:	89 c2                	mov    %eax,%edx
c0104d10:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104d15:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104d1c:	00 
c0104d1d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d21:	89 04 24             	mov    %eax,(%esp)
c0104d24:	e8 19 f7 ff ff       	call   c0104442 <get_pte>
c0104d29:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104d30:	75 24                	jne    c0104d56 <check_boot_pgdir+0x9e>
c0104d32:	c7 44 24 0c dc 6c 10 	movl   $0xc0106cdc,0xc(%esp)
c0104d39:	c0 
c0104d3a:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104d41:	c0 
c0104d42:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104d49:	00 
c0104d4a:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104d51:	e8 76 bf ff ff       	call   c0100ccc <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d59:	8b 00                	mov    (%eax),%eax
c0104d5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d60:	89 c2                	mov    %eax,%edx
c0104d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d65:	39 c2                	cmp    %eax,%edx
c0104d67:	74 24                	je     c0104d8d <check_boot_pgdir+0xd5>
c0104d69:	c7 44 24 0c 19 6d 10 	movl   $0xc0106d19,0xc(%esp)
c0104d70:	c0 
c0104d71:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104d78:	c0 
c0104d79:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104d80:	00 
c0104d81:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104d88:	e8 3f bf ff ff       	call   c0100ccc <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104d8d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d97:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104d9c:	39 c2                	cmp    %eax,%edx
c0104d9e:	0f 82 26 ff ff ff    	jb     c0104cca <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104da4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104da9:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104dae:	8b 00                	mov    (%eax),%eax
c0104db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104db5:	89 c2                	mov    %eax,%edx
c0104db7:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104dbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104dbf:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104dc6:	77 23                	ja     c0104deb <check_boot_pgdir+0x133>
c0104dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104dcf:	c7 44 24 08 a8 69 10 	movl   $0xc01069a8,0x8(%esp)
c0104dd6:	c0 
c0104dd7:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104dde:	00 
c0104ddf:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104de6:	e8 e1 be ff ff       	call   c0100ccc <__panic>
c0104deb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dee:	05 00 00 00 40       	add    $0x40000000,%eax
c0104df3:	39 c2                	cmp    %eax,%edx
c0104df5:	74 24                	je     c0104e1b <check_boot_pgdir+0x163>
c0104df7:	c7 44 24 0c 30 6d 10 	movl   $0xc0106d30,0xc(%esp)
c0104dfe:	c0 
c0104dff:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104e06:	c0 
c0104e07:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104e0e:	00 
c0104e0f:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104e16:	e8 b1 be ff ff       	call   c0100ccc <__panic>

    assert(boot_pgdir[0] == 0);
c0104e1b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e20:	8b 00                	mov    (%eax),%eax
c0104e22:	85 c0                	test   %eax,%eax
c0104e24:	74 24                	je     c0104e4a <check_boot_pgdir+0x192>
c0104e26:	c7 44 24 0c 64 6d 10 	movl   $0xc0106d64,0xc(%esp)
c0104e2d:	c0 
c0104e2e:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104e35:	c0 
c0104e36:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104e3d:	00 
c0104e3e:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104e45:	e8 82 be ff ff       	call   c0100ccc <__panic>

    struct Page *p;
    p = alloc_page();
c0104e4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e51:	e8 30 ef ff ff       	call   c0103d86 <alloc_pages>
c0104e56:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104e59:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e5e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104e65:	00 
c0104e66:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104e6d:	00 
c0104e6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e71:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e75:	89 04 24             	mov    %eax,(%esp)
c0104e78:	e8 6c f6 ff ff       	call   c01044e9 <page_insert>
c0104e7d:	85 c0                	test   %eax,%eax
c0104e7f:	74 24                	je     c0104ea5 <check_boot_pgdir+0x1ed>
c0104e81:	c7 44 24 0c 78 6d 10 	movl   $0xc0106d78,0xc(%esp)
c0104e88:	c0 
c0104e89:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104e90:	c0 
c0104e91:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104e98:	00 
c0104e99:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104ea0:	e8 27 be ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p) == 1);
c0104ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ea8:	89 04 24             	mov    %eax,(%esp)
c0104eab:	e8 de ec ff ff       	call   c0103b8e <page_ref>
c0104eb0:	83 f8 01             	cmp    $0x1,%eax
c0104eb3:	74 24                	je     c0104ed9 <check_boot_pgdir+0x221>
c0104eb5:	c7 44 24 0c a6 6d 10 	movl   $0xc0106da6,0xc(%esp)
c0104ebc:	c0 
c0104ebd:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104ec4:	c0 
c0104ec5:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104ecc:	00 
c0104ecd:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104ed4:	e8 f3 bd ff ff       	call   c0100ccc <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104ed9:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104ede:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104ee5:	00 
c0104ee6:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104eed:	00 
c0104eee:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104ef1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ef5:	89 04 24             	mov    %eax,(%esp)
c0104ef8:	e8 ec f5 ff ff       	call   c01044e9 <page_insert>
c0104efd:	85 c0                	test   %eax,%eax
c0104eff:	74 24                	je     c0104f25 <check_boot_pgdir+0x26d>
c0104f01:	c7 44 24 0c b8 6d 10 	movl   $0xc0106db8,0xc(%esp)
c0104f08:	c0 
c0104f09:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104f10:	c0 
c0104f11:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104f18:	00 
c0104f19:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104f20:	e8 a7 bd ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p) == 2);
c0104f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f28:	89 04 24             	mov    %eax,(%esp)
c0104f2b:	e8 5e ec ff ff       	call   c0103b8e <page_ref>
c0104f30:	83 f8 02             	cmp    $0x2,%eax
c0104f33:	74 24                	je     c0104f59 <check_boot_pgdir+0x2a1>
c0104f35:	c7 44 24 0c ef 6d 10 	movl   $0xc0106def,0xc(%esp)
c0104f3c:	c0 
c0104f3d:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104f44:	c0 
c0104f45:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104f4c:	00 
c0104f4d:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104f54:	e8 73 bd ff ff       	call   c0100ccc <__panic>

    const char *str = "ucore: Hello world!!";
c0104f59:	c7 45 dc 00 6e 10 c0 	movl   $0xc0106e00,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f67:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f6e:	e8 19 0a 00 00       	call   c010598c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104f73:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104f7a:	00 
c0104f7b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f82:	e8 7e 0a 00 00       	call   c0105a05 <strcmp>
c0104f87:	85 c0                	test   %eax,%eax
c0104f89:	74 24                	je     c0104faf <check_boot_pgdir+0x2f7>
c0104f8b:	c7 44 24 0c 18 6e 10 	movl   $0xc0106e18,0xc(%esp)
c0104f92:	c0 
c0104f93:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104f9a:	c0 
c0104f9b:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104fa2:	00 
c0104fa3:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104faa:	e8 1d bd ff ff       	call   c0100ccc <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104faf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fb2:	89 04 24             	mov    %eax,(%esp)
c0104fb5:	e8 2a eb ff ff       	call   c0103ae4 <page2kva>
c0104fba:	05 00 01 00 00       	add    $0x100,%eax
c0104fbf:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104fc2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104fc9:	e8 66 09 00 00       	call   c0105934 <strlen>
c0104fce:	85 c0                	test   %eax,%eax
c0104fd0:	74 24                	je     c0104ff6 <check_boot_pgdir+0x33e>
c0104fd2:	c7 44 24 0c 50 6e 10 	movl   $0xc0106e50,0xc(%esp)
c0104fd9:	c0 
c0104fda:	c7 44 24 08 f1 69 10 	movl   $0xc01069f1,0x8(%esp)
c0104fe1:	c0 
c0104fe2:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104fe9:	00 
c0104fea:	c7 04 24 cc 69 10 c0 	movl   $0xc01069cc,(%esp)
c0104ff1:	e8 d6 bc ff ff       	call   c0100ccc <__panic>

    free_page(p);
c0104ff6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ffd:	00 
c0104ffe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105001:	89 04 24             	mov    %eax,(%esp)
c0105004:	e8 b5 ed ff ff       	call   c0103dbe <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105009:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010500e:	8b 00                	mov    (%eax),%eax
c0105010:	89 04 24             	mov    %eax,(%esp)
c0105013:	e8 5e eb ff ff       	call   c0103b76 <pde2page>
c0105018:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010501f:	00 
c0105020:	89 04 24             	mov    %eax,(%esp)
c0105023:	e8 96 ed ff ff       	call   c0103dbe <free_pages>
    boot_pgdir[0] = 0;
c0105028:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010502d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105033:	c7 04 24 74 6e 10 c0 	movl   $0xc0106e74,(%esp)
c010503a:	e8 09 b3 ff ff       	call   c0100348 <cprintf>
}
c010503f:	c9                   	leave  
c0105040:	c3                   	ret    

c0105041 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105041:	55                   	push   %ebp
c0105042:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105044:	8b 45 08             	mov    0x8(%ebp),%eax
c0105047:	83 e0 04             	and    $0x4,%eax
c010504a:	85 c0                	test   %eax,%eax
c010504c:	74 07                	je     c0105055 <perm2str+0x14>
c010504e:	b8 75 00 00 00       	mov    $0x75,%eax
c0105053:	eb 05                	jmp    c010505a <perm2str+0x19>
c0105055:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010505a:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c010505f:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105066:	8b 45 08             	mov    0x8(%ebp),%eax
c0105069:	83 e0 02             	and    $0x2,%eax
c010506c:	85 c0                	test   %eax,%eax
c010506e:	74 07                	je     c0105077 <perm2str+0x36>
c0105070:	b8 77 00 00 00       	mov    $0x77,%eax
c0105075:	eb 05                	jmp    c010507c <perm2str+0x3b>
c0105077:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010507c:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c0105081:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c0105088:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c010508d:	5d                   	pop    %ebp
c010508e:	c3                   	ret    

c010508f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010508f:	55                   	push   %ebp
c0105090:	89 e5                	mov    %esp,%ebp
c0105092:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105095:	8b 45 10             	mov    0x10(%ebp),%eax
c0105098:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010509b:	72 0a                	jb     c01050a7 <get_pgtable_items+0x18>
        return 0;
c010509d:	b8 00 00 00 00       	mov    $0x0,%eax
c01050a2:	e9 9c 00 00 00       	jmp    c0105143 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050a7:	eb 04                	jmp    c01050ad <get_pgtable_items+0x1e>
        start ++;
c01050a9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01050ad:	8b 45 10             	mov    0x10(%ebp),%eax
c01050b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050b3:	73 18                	jae    c01050cd <get_pgtable_items+0x3e>
c01050b5:	8b 45 10             	mov    0x10(%ebp),%eax
c01050b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050bf:	8b 45 14             	mov    0x14(%ebp),%eax
c01050c2:	01 d0                	add    %edx,%eax
c01050c4:	8b 00                	mov    (%eax),%eax
c01050c6:	83 e0 01             	and    $0x1,%eax
c01050c9:	85 c0                	test   %eax,%eax
c01050cb:	74 dc                	je     c01050a9 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01050cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01050d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050d3:	73 69                	jae    c010513e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01050d5:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01050d9:	74 08                	je     c01050e3 <get_pgtable_items+0x54>
            *left_store = start;
c01050db:	8b 45 18             	mov    0x18(%ebp),%eax
c01050de:	8b 55 10             	mov    0x10(%ebp),%edx
c01050e1:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01050e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01050e6:	8d 50 01             	lea    0x1(%eax),%edx
c01050e9:	89 55 10             	mov    %edx,0x10(%ebp)
c01050ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050f3:	8b 45 14             	mov    0x14(%ebp),%eax
c01050f6:	01 d0                	add    %edx,%eax
c01050f8:	8b 00                	mov    (%eax),%eax
c01050fa:	83 e0 07             	and    $0x7,%eax
c01050fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105100:	eb 04                	jmp    c0105106 <get_pgtable_items+0x77>
            start ++;
c0105102:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105106:	8b 45 10             	mov    0x10(%ebp),%eax
c0105109:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010510c:	73 1d                	jae    c010512b <get_pgtable_items+0x9c>
c010510e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105111:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105118:	8b 45 14             	mov    0x14(%ebp),%eax
c010511b:	01 d0                	add    %edx,%eax
c010511d:	8b 00                	mov    (%eax),%eax
c010511f:	83 e0 07             	and    $0x7,%eax
c0105122:	89 c2                	mov    %eax,%edx
c0105124:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105127:	39 c2                	cmp    %eax,%edx
c0105129:	74 d7                	je     c0105102 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c010512b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010512f:	74 08                	je     c0105139 <get_pgtable_items+0xaa>
            *right_store = start;
c0105131:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105134:	8b 55 10             	mov    0x10(%ebp),%edx
c0105137:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105139:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010513c:	eb 05                	jmp    c0105143 <get_pgtable_items+0xb4>
    }
    return 0;
c010513e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105143:	c9                   	leave  
c0105144:	c3                   	ret    

c0105145 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105145:	55                   	push   %ebp
c0105146:	89 e5                	mov    %esp,%ebp
c0105148:	57                   	push   %edi
c0105149:	56                   	push   %esi
c010514a:	53                   	push   %ebx
c010514b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010514e:	c7 04 24 94 6e 10 c0 	movl   $0xc0106e94,(%esp)
c0105155:	e8 ee b1 ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
c010515a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105161:	e9 fa 00 00 00       	jmp    c0105260 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105169:	89 04 24             	mov    %eax,(%esp)
c010516c:	e8 d0 fe ff ff       	call   c0105041 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105171:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105174:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105177:	29 d1                	sub    %edx,%ecx
c0105179:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010517b:	89 d6                	mov    %edx,%esi
c010517d:	c1 e6 16             	shl    $0x16,%esi
c0105180:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105183:	89 d3                	mov    %edx,%ebx
c0105185:	c1 e3 16             	shl    $0x16,%ebx
c0105188:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010518b:	89 d1                	mov    %edx,%ecx
c010518d:	c1 e1 16             	shl    $0x16,%ecx
c0105190:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105193:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105196:	29 d7                	sub    %edx,%edi
c0105198:	89 fa                	mov    %edi,%edx
c010519a:	89 44 24 14          	mov    %eax,0x14(%esp)
c010519e:	89 74 24 10          	mov    %esi,0x10(%esp)
c01051a2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01051a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01051aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051ae:	c7 04 24 c5 6e 10 c0 	movl   $0xc0106ec5,(%esp)
c01051b5:	e8 8e b1 ff ff       	call   c0100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01051ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051bd:	c1 e0 0a             	shl    $0xa,%eax
c01051c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01051c3:	eb 54                	jmp    c0105219 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01051c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051c8:	89 04 24             	mov    %eax,(%esp)
c01051cb:	e8 71 fe ff ff       	call   c0105041 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01051d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01051d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01051d6:	29 d1                	sub    %edx,%ecx
c01051d8:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01051da:	89 d6                	mov    %edx,%esi
c01051dc:	c1 e6 0c             	shl    $0xc,%esi
c01051df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051e2:	89 d3                	mov    %edx,%ebx
c01051e4:	c1 e3 0c             	shl    $0xc,%ebx
c01051e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01051ea:	c1 e2 0c             	shl    $0xc,%edx
c01051ed:	89 d1                	mov    %edx,%ecx
c01051ef:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01051f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01051f5:	29 d7                	sub    %edx,%edi
c01051f7:	89 fa                	mov    %edi,%edx
c01051f9:	89 44 24 14          	mov    %eax,0x14(%esp)
c01051fd:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105201:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105205:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105209:	89 54 24 04          	mov    %edx,0x4(%esp)
c010520d:	c7 04 24 e4 6e 10 c0 	movl   $0xc0106ee4,(%esp)
c0105214:	e8 2f b1 ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105219:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c010521e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105221:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105224:	89 ce                	mov    %ecx,%esi
c0105226:	c1 e6 0a             	shl    $0xa,%esi
c0105229:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010522c:	89 cb                	mov    %ecx,%ebx
c010522e:	c1 e3 0a             	shl    $0xa,%ebx
c0105231:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105234:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105238:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010523b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010523f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105243:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105247:	89 74 24 04          	mov    %esi,0x4(%esp)
c010524b:	89 1c 24             	mov    %ebx,(%esp)
c010524e:	e8 3c fe ff ff       	call   c010508f <get_pgtable_items>
c0105253:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105256:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010525a:	0f 85 65 ff ff ff    	jne    c01051c5 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105260:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105265:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105268:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010526b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010526f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105272:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105276:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010527a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010527e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105285:	00 
c0105286:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010528d:	e8 fd fd ff ff       	call   c010508f <get_pgtable_items>
c0105292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105295:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105299:	0f 85 c7 fe ff ff    	jne    c0105166 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c010529f:	c7 04 24 08 6f 10 c0 	movl   $0xc0106f08,(%esp)
c01052a6:	e8 9d b0 ff ff       	call   c0100348 <cprintf>
}
c01052ab:	83 c4 4c             	add    $0x4c,%esp
c01052ae:	5b                   	pop    %ebx
c01052af:	5e                   	pop    %esi
c01052b0:	5f                   	pop    %edi
c01052b1:	5d                   	pop    %ebp
c01052b2:	c3                   	ret    

c01052b3 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01052b3:	55                   	push   %ebp
c01052b4:	89 e5                	mov    %esp,%ebp
c01052b6:	83 ec 58             	sub    $0x58,%esp
c01052b9:	8b 45 10             	mov    0x10(%ebp),%eax
c01052bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01052bf:	8b 45 14             	mov    0x14(%ebp),%eax
c01052c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01052c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01052cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01052d1:	8b 45 18             	mov    0x18(%ebp),%eax
c01052d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052da:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01052dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052e0:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01052e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01052e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01052ed:	74 1c                	je     c010530b <printnum+0x58>
c01052ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052f2:	ba 00 00 00 00       	mov    $0x0,%edx
c01052f7:	f7 75 e4             	divl   -0x1c(%ebp)
c01052fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01052fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105300:	ba 00 00 00 00       	mov    $0x0,%edx
c0105305:	f7 75 e4             	divl   -0x1c(%ebp)
c0105308:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010530b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010530e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105311:	f7 75 e4             	divl   -0x1c(%ebp)
c0105314:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105317:	89 55 dc             	mov    %edx,-0x24(%ebp)
c010531a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010531d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105320:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105323:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105326:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105329:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010532c:	8b 45 18             	mov    0x18(%ebp),%eax
c010532f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105334:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105337:	77 56                	ja     c010538f <printnum+0xdc>
c0105339:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010533c:	72 05                	jb     c0105343 <printnum+0x90>
c010533e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105341:	77 4c                	ja     c010538f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105343:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105346:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105349:	8b 45 20             	mov    0x20(%ebp),%eax
c010534c:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105350:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105354:	8b 45 18             	mov    0x18(%ebp),%eax
c0105357:	89 44 24 10          	mov    %eax,0x10(%esp)
c010535b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010535e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105361:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105365:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105369:	8b 45 0c             	mov    0xc(%ebp),%eax
c010536c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105370:	8b 45 08             	mov    0x8(%ebp),%eax
c0105373:	89 04 24             	mov    %eax,(%esp)
c0105376:	e8 38 ff ff ff       	call   c01052b3 <printnum>
c010537b:	eb 1c                	jmp    c0105399 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010537d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105380:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105384:	8b 45 20             	mov    0x20(%ebp),%eax
c0105387:	89 04 24             	mov    %eax,(%esp)
c010538a:	8b 45 08             	mov    0x8(%ebp),%eax
c010538d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010538f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105393:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105397:	7f e4                	jg     c010537d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105399:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010539c:	05 bc 6f 10 c0       	add    $0xc0106fbc,%eax
c01053a1:	0f b6 00             	movzbl (%eax),%eax
c01053a4:	0f be c0             	movsbl %al,%eax
c01053a7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053ae:	89 04 24             	mov    %eax,(%esp)
c01053b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b4:	ff d0                	call   *%eax
}
c01053b6:	c9                   	leave  
c01053b7:	c3                   	ret    

c01053b8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01053b8:	55                   	push   %ebp
c01053b9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01053bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01053bf:	7e 14                	jle    c01053d5 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01053c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01053c4:	8b 00                	mov    (%eax),%eax
c01053c6:	8d 48 08             	lea    0x8(%eax),%ecx
c01053c9:	8b 55 08             	mov    0x8(%ebp),%edx
c01053cc:	89 0a                	mov    %ecx,(%edx)
c01053ce:	8b 50 04             	mov    0x4(%eax),%edx
c01053d1:	8b 00                	mov    (%eax),%eax
c01053d3:	eb 30                	jmp    c0105405 <getuint+0x4d>
    }
    else if (lflag) {
c01053d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01053d9:	74 16                	je     c01053f1 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01053db:	8b 45 08             	mov    0x8(%ebp),%eax
c01053de:	8b 00                	mov    (%eax),%eax
c01053e0:	8d 48 04             	lea    0x4(%eax),%ecx
c01053e3:	8b 55 08             	mov    0x8(%ebp),%edx
c01053e6:	89 0a                	mov    %ecx,(%edx)
c01053e8:	8b 00                	mov    (%eax),%eax
c01053ea:	ba 00 00 00 00       	mov    $0x0,%edx
c01053ef:	eb 14                	jmp    c0105405 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01053f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f4:	8b 00                	mov    (%eax),%eax
c01053f6:	8d 48 04             	lea    0x4(%eax),%ecx
c01053f9:	8b 55 08             	mov    0x8(%ebp),%edx
c01053fc:	89 0a                	mov    %ecx,(%edx)
c01053fe:	8b 00                	mov    (%eax),%eax
c0105400:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105405:	5d                   	pop    %ebp
c0105406:	c3                   	ret    

c0105407 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105407:	55                   	push   %ebp
c0105408:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010540a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010540e:	7e 14                	jle    c0105424 <getint+0x1d>
        return va_arg(*ap, long long);
c0105410:	8b 45 08             	mov    0x8(%ebp),%eax
c0105413:	8b 00                	mov    (%eax),%eax
c0105415:	8d 48 08             	lea    0x8(%eax),%ecx
c0105418:	8b 55 08             	mov    0x8(%ebp),%edx
c010541b:	89 0a                	mov    %ecx,(%edx)
c010541d:	8b 50 04             	mov    0x4(%eax),%edx
c0105420:	8b 00                	mov    (%eax),%eax
c0105422:	eb 28                	jmp    c010544c <getint+0x45>
    }
    else if (lflag) {
c0105424:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105428:	74 12                	je     c010543c <getint+0x35>
        return va_arg(*ap, long);
c010542a:	8b 45 08             	mov    0x8(%ebp),%eax
c010542d:	8b 00                	mov    (%eax),%eax
c010542f:	8d 48 04             	lea    0x4(%eax),%ecx
c0105432:	8b 55 08             	mov    0x8(%ebp),%edx
c0105435:	89 0a                	mov    %ecx,(%edx)
c0105437:	8b 00                	mov    (%eax),%eax
c0105439:	99                   	cltd   
c010543a:	eb 10                	jmp    c010544c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c010543c:	8b 45 08             	mov    0x8(%ebp),%eax
c010543f:	8b 00                	mov    (%eax),%eax
c0105441:	8d 48 04             	lea    0x4(%eax),%ecx
c0105444:	8b 55 08             	mov    0x8(%ebp),%edx
c0105447:	89 0a                	mov    %ecx,(%edx)
c0105449:	8b 00                	mov    (%eax),%eax
c010544b:	99                   	cltd   
    }
}
c010544c:	5d                   	pop    %ebp
c010544d:	c3                   	ret    

c010544e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010544e:	55                   	push   %ebp
c010544f:	89 e5                	mov    %esp,%ebp
c0105451:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105454:	8d 45 14             	lea    0x14(%ebp),%eax
c0105457:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010545a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010545d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105461:	8b 45 10             	mov    0x10(%ebp),%eax
c0105464:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105468:	8b 45 0c             	mov    0xc(%ebp),%eax
c010546b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010546f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105472:	89 04 24             	mov    %eax,(%esp)
c0105475:	e8 02 00 00 00       	call   c010547c <vprintfmt>
    va_end(ap);
}
c010547a:	c9                   	leave  
c010547b:	c3                   	ret    

c010547c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010547c:	55                   	push   %ebp
c010547d:	89 e5                	mov    %esp,%ebp
c010547f:	56                   	push   %esi
c0105480:	53                   	push   %ebx
c0105481:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105484:	eb 18                	jmp    c010549e <vprintfmt+0x22>
            if (ch == '\0') {
c0105486:	85 db                	test   %ebx,%ebx
c0105488:	75 05                	jne    c010548f <vprintfmt+0x13>
                return;
c010548a:	e9 d1 03 00 00       	jmp    c0105860 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c010548f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105492:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105496:	89 1c 24             	mov    %ebx,(%esp)
c0105499:	8b 45 08             	mov    0x8(%ebp),%eax
c010549c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010549e:	8b 45 10             	mov    0x10(%ebp),%eax
c01054a1:	8d 50 01             	lea    0x1(%eax),%edx
c01054a4:	89 55 10             	mov    %edx,0x10(%ebp)
c01054a7:	0f b6 00             	movzbl (%eax),%eax
c01054aa:	0f b6 d8             	movzbl %al,%ebx
c01054ad:	83 fb 25             	cmp    $0x25,%ebx
c01054b0:	75 d4                	jne    c0105486 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01054b2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01054b6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01054bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01054c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01054ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054cd:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01054d0:	8b 45 10             	mov    0x10(%ebp),%eax
c01054d3:	8d 50 01             	lea    0x1(%eax),%edx
c01054d6:	89 55 10             	mov    %edx,0x10(%ebp)
c01054d9:	0f b6 00             	movzbl (%eax),%eax
c01054dc:	0f b6 d8             	movzbl %al,%ebx
c01054df:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01054e2:	83 f8 55             	cmp    $0x55,%eax
c01054e5:	0f 87 44 03 00 00    	ja     c010582f <vprintfmt+0x3b3>
c01054eb:	8b 04 85 e0 6f 10 c0 	mov    -0x3fef9020(,%eax,4),%eax
c01054f2:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01054f4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01054f8:	eb d6                	jmp    c01054d0 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01054fa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01054fe:	eb d0                	jmp    c01054d0 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105500:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105507:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010550a:	89 d0                	mov    %edx,%eax
c010550c:	c1 e0 02             	shl    $0x2,%eax
c010550f:	01 d0                	add    %edx,%eax
c0105511:	01 c0                	add    %eax,%eax
c0105513:	01 d8                	add    %ebx,%eax
c0105515:	83 e8 30             	sub    $0x30,%eax
c0105518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010551b:	8b 45 10             	mov    0x10(%ebp),%eax
c010551e:	0f b6 00             	movzbl (%eax),%eax
c0105521:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105524:	83 fb 2f             	cmp    $0x2f,%ebx
c0105527:	7e 0b                	jle    c0105534 <vprintfmt+0xb8>
c0105529:	83 fb 39             	cmp    $0x39,%ebx
c010552c:	7f 06                	jg     c0105534 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010552e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105532:	eb d3                	jmp    c0105507 <vprintfmt+0x8b>
            goto process_precision;
c0105534:	eb 33                	jmp    c0105569 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105536:	8b 45 14             	mov    0x14(%ebp),%eax
c0105539:	8d 50 04             	lea    0x4(%eax),%edx
c010553c:	89 55 14             	mov    %edx,0x14(%ebp)
c010553f:	8b 00                	mov    (%eax),%eax
c0105541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105544:	eb 23                	jmp    c0105569 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105546:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010554a:	79 0c                	jns    c0105558 <vprintfmt+0xdc>
                width = 0;
c010554c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105553:	e9 78 ff ff ff       	jmp    c01054d0 <vprintfmt+0x54>
c0105558:	e9 73 ff ff ff       	jmp    c01054d0 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010555d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105564:	e9 67 ff ff ff       	jmp    c01054d0 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105569:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010556d:	79 12                	jns    c0105581 <vprintfmt+0x105>
                width = precision, precision = -1;
c010556f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105572:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105575:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010557c:	e9 4f ff ff ff       	jmp    c01054d0 <vprintfmt+0x54>
c0105581:	e9 4a ff ff ff       	jmp    c01054d0 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105586:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010558a:	e9 41 ff ff ff       	jmp    c01054d0 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010558f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105592:	8d 50 04             	lea    0x4(%eax),%edx
c0105595:	89 55 14             	mov    %edx,0x14(%ebp)
c0105598:	8b 00                	mov    (%eax),%eax
c010559a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010559d:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055a1:	89 04 24             	mov    %eax,(%esp)
c01055a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a7:	ff d0                	call   *%eax
            break;
c01055a9:	e9 ac 02 00 00       	jmp    c010585a <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01055ae:	8b 45 14             	mov    0x14(%ebp),%eax
c01055b1:	8d 50 04             	lea    0x4(%eax),%edx
c01055b4:	89 55 14             	mov    %edx,0x14(%ebp)
c01055b7:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01055b9:	85 db                	test   %ebx,%ebx
c01055bb:	79 02                	jns    c01055bf <vprintfmt+0x143>
                err = -err;
c01055bd:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01055bf:	83 fb 06             	cmp    $0x6,%ebx
c01055c2:	7f 0b                	jg     c01055cf <vprintfmt+0x153>
c01055c4:	8b 34 9d a0 6f 10 c0 	mov    -0x3fef9060(,%ebx,4),%esi
c01055cb:	85 f6                	test   %esi,%esi
c01055cd:	75 23                	jne    c01055f2 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01055cf:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01055d3:	c7 44 24 08 cd 6f 10 	movl   $0xc0106fcd,0x8(%esp)
c01055da:	c0 
c01055db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e5:	89 04 24             	mov    %eax,(%esp)
c01055e8:	e8 61 fe ff ff       	call   c010544e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01055ed:	e9 68 02 00 00       	jmp    c010585a <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01055f2:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01055f6:	c7 44 24 08 d6 6f 10 	movl   $0xc0106fd6,0x8(%esp)
c01055fd:	c0 
c01055fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105601:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105605:	8b 45 08             	mov    0x8(%ebp),%eax
c0105608:	89 04 24             	mov    %eax,(%esp)
c010560b:	e8 3e fe ff ff       	call   c010544e <printfmt>
            }
            break;
c0105610:	e9 45 02 00 00       	jmp    c010585a <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105615:	8b 45 14             	mov    0x14(%ebp),%eax
c0105618:	8d 50 04             	lea    0x4(%eax),%edx
c010561b:	89 55 14             	mov    %edx,0x14(%ebp)
c010561e:	8b 30                	mov    (%eax),%esi
c0105620:	85 f6                	test   %esi,%esi
c0105622:	75 05                	jne    c0105629 <vprintfmt+0x1ad>
                p = "(null)";
c0105624:	be d9 6f 10 c0       	mov    $0xc0106fd9,%esi
            }
            if (width > 0 && padc != '-') {
c0105629:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010562d:	7e 3e                	jle    c010566d <vprintfmt+0x1f1>
c010562f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105633:	74 38                	je     c010566d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105635:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010563b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010563f:	89 34 24             	mov    %esi,(%esp)
c0105642:	e8 15 03 00 00       	call   c010595c <strnlen>
c0105647:	29 c3                	sub    %eax,%ebx
c0105649:	89 d8                	mov    %ebx,%eax
c010564b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010564e:	eb 17                	jmp    c0105667 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105650:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105654:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105657:	89 54 24 04          	mov    %edx,0x4(%esp)
c010565b:	89 04 24             	mov    %eax,(%esp)
c010565e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105661:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105663:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105667:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010566b:	7f e3                	jg     c0105650 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010566d:	eb 38                	jmp    c01056a7 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c010566f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105673:	74 1f                	je     c0105694 <vprintfmt+0x218>
c0105675:	83 fb 1f             	cmp    $0x1f,%ebx
c0105678:	7e 05                	jle    c010567f <vprintfmt+0x203>
c010567a:	83 fb 7e             	cmp    $0x7e,%ebx
c010567d:	7e 15                	jle    c0105694 <vprintfmt+0x218>
                    putch('?', putdat);
c010567f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105682:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105686:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010568d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105690:	ff d0                	call   *%eax
c0105692:	eb 0f                	jmp    c01056a3 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105694:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105697:	89 44 24 04          	mov    %eax,0x4(%esp)
c010569b:	89 1c 24             	mov    %ebx,(%esp)
c010569e:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a1:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01056a3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056a7:	89 f0                	mov    %esi,%eax
c01056a9:	8d 70 01             	lea    0x1(%eax),%esi
c01056ac:	0f b6 00             	movzbl (%eax),%eax
c01056af:	0f be d8             	movsbl %al,%ebx
c01056b2:	85 db                	test   %ebx,%ebx
c01056b4:	74 10                	je     c01056c6 <vprintfmt+0x24a>
c01056b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056ba:	78 b3                	js     c010566f <vprintfmt+0x1f3>
c01056bc:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01056c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056c4:	79 a9                	jns    c010566f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01056c6:	eb 17                	jmp    c01056df <vprintfmt+0x263>
                putch(' ', putdat);
c01056c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056cf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01056d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d9:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01056db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01056df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056e3:	7f e3                	jg     c01056c8 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01056e5:	e9 70 01 00 00       	jmp    c010585a <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01056ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056f1:	8d 45 14             	lea    0x14(%ebp),%eax
c01056f4:	89 04 24             	mov    %eax,(%esp)
c01056f7:	e8 0b fd ff ff       	call   c0105407 <getint>
c01056fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105702:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105705:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105708:	85 d2                	test   %edx,%edx
c010570a:	79 26                	jns    c0105732 <vprintfmt+0x2b6>
                putch('-', putdat);
c010570c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010570f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105713:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010571a:	8b 45 08             	mov    0x8(%ebp),%eax
c010571d:	ff d0                	call   *%eax
                num = -(long long)num;
c010571f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105722:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105725:	f7 d8                	neg    %eax
c0105727:	83 d2 00             	adc    $0x0,%edx
c010572a:	f7 da                	neg    %edx
c010572c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010572f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105732:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105739:	e9 a8 00 00 00       	jmp    c01057e6 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010573e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105741:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105745:	8d 45 14             	lea    0x14(%ebp),%eax
c0105748:	89 04 24             	mov    %eax,(%esp)
c010574b:	e8 68 fc ff ff       	call   c01053b8 <getuint>
c0105750:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105753:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105756:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010575d:	e9 84 00 00 00       	jmp    c01057e6 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105762:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105765:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105769:	8d 45 14             	lea    0x14(%ebp),%eax
c010576c:	89 04 24             	mov    %eax,(%esp)
c010576f:	e8 44 fc ff ff       	call   c01053b8 <getuint>
c0105774:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105777:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010577a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105781:	eb 63                	jmp    c01057e6 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105783:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105786:	89 44 24 04          	mov    %eax,0x4(%esp)
c010578a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105791:	8b 45 08             	mov    0x8(%ebp),%eax
c0105794:	ff d0                	call   *%eax
            putch('x', putdat);
c0105796:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105799:	89 44 24 04          	mov    %eax,0x4(%esp)
c010579d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c01057a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a7:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c01057a9:	8b 45 14             	mov    0x14(%ebp),%eax
c01057ac:	8d 50 04             	lea    0x4(%eax),%edx
c01057af:	89 55 14             	mov    %edx,0x14(%ebp)
c01057b2:	8b 00                	mov    (%eax),%eax
c01057b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01057be:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01057c5:	eb 1f                	jmp    c01057e6 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01057c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ce:	8d 45 14             	lea    0x14(%ebp),%eax
c01057d1:	89 04 24             	mov    %eax,(%esp)
c01057d4:	e8 df fb ff ff       	call   c01053b8 <getuint>
c01057d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01057df:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01057e6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01057ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057ed:	89 54 24 18          	mov    %edx,0x18(%esp)
c01057f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01057f4:	89 54 24 14          	mov    %edx,0x14(%esp)
c01057f8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01057fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105802:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105806:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010580a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105811:	8b 45 08             	mov    0x8(%ebp),%eax
c0105814:	89 04 24             	mov    %eax,(%esp)
c0105817:	e8 97 fa ff ff       	call   c01052b3 <printnum>
            break;
c010581c:	eb 3c                	jmp    c010585a <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010581e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105821:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105825:	89 1c 24             	mov    %ebx,(%esp)
c0105828:	8b 45 08             	mov    0x8(%ebp),%eax
c010582b:	ff d0                	call   *%eax
            break;
c010582d:	eb 2b                	jmp    c010585a <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010582f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105832:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105836:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010583d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105840:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105842:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105846:	eb 04                	jmp    c010584c <vprintfmt+0x3d0>
c0105848:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010584c:	8b 45 10             	mov    0x10(%ebp),%eax
c010584f:	83 e8 01             	sub    $0x1,%eax
c0105852:	0f b6 00             	movzbl (%eax),%eax
c0105855:	3c 25                	cmp    $0x25,%al
c0105857:	75 ef                	jne    c0105848 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105859:	90                   	nop
        }
    }
c010585a:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010585b:	e9 3e fc ff ff       	jmp    c010549e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105860:	83 c4 40             	add    $0x40,%esp
c0105863:	5b                   	pop    %ebx
c0105864:	5e                   	pop    %esi
c0105865:	5d                   	pop    %ebp
c0105866:	c3                   	ret    

c0105867 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105867:	55                   	push   %ebp
c0105868:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010586a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586d:	8b 40 08             	mov    0x8(%eax),%eax
c0105870:	8d 50 01             	lea    0x1(%eax),%edx
c0105873:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105876:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105879:	8b 45 0c             	mov    0xc(%ebp),%eax
c010587c:	8b 10                	mov    (%eax),%edx
c010587e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105881:	8b 40 04             	mov    0x4(%eax),%eax
c0105884:	39 c2                	cmp    %eax,%edx
c0105886:	73 12                	jae    c010589a <sprintputch+0x33>
        *b->buf ++ = ch;
c0105888:	8b 45 0c             	mov    0xc(%ebp),%eax
c010588b:	8b 00                	mov    (%eax),%eax
c010588d:	8d 48 01             	lea    0x1(%eax),%ecx
c0105890:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105893:	89 0a                	mov    %ecx,(%edx)
c0105895:	8b 55 08             	mov    0x8(%ebp),%edx
c0105898:	88 10                	mov    %dl,(%eax)
    }
}
c010589a:	5d                   	pop    %ebp
c010589b:	c3                   	ret    

c010589c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010589c:	55                   	push   %ebp
c010589d:	89 e5                	mov    %esp,%ebp
c010589f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01058a2:	8d 45 14             	lea    0x14(%ebp),%eax
c01058a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c01058a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058af:	8b 45 10             	mov    0x10(%ebp),%eax
c01058b2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c0:	89 04 24             	mov    %eax,(%esp)
c01058c3:	e8 08 00 00 00       	call   c01058d0 <vsnprintf>
c01058c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01058cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058ce:	c9                   	leave  
c01058cf:	c3                   	ret    

c01058d0 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01058d0:	55                   	push   %ebp
c01058d1:	89 e5                	mov    %esp,%ebp
c01058d3:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01058d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01058dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058df:	8d 50 ff             	lea    -0x1(%eax),%edx
c01058e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e5:	01 d0                	add    %edx,%eax
c01058e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01058f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01058f5:	74 0a                	je     c0105901 <vsnprintf+0x31>
c01058f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01058fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058fd:	39 c2                	cmp    %eax,%edx
c01058ff:	76 07                	jbe    c0105908 <vsnprintf+0x38>
        return -E_INVAL;
c0105901:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105906:	eb 2a                	jmp    c0105932 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105908:	8b 45 14             	mov    0x14(%ebp),%eax
c010590b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010590f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105912:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105916:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105919:	89 44 24 04          	mov    %eax,0x4(%esp)
c010591d:	c7 04 24 67 58 10 c0 	movl   $0xc0105867,(%esp)
c0105924:	e8 53 fb ff ff       	call   c010547c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105929:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010592c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010592f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105932:	c9                   	leave  
c0105933:	c3                   	ret    

c0105934 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105934:	55                   	push   %ebp
c0105935:	89 e5                	mov    %esp,%ebp
c0105937:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010593a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105941:	eb 04                	jmp    c0105947 <strlen+0x13>
        cnt ++;
c0105943:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105947:	8b 45 08             	mov    0x8(%ebp),%eax
c010594a:	8d 50 01             	lea    0x1(%eax),%edx
c010594d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105950:	0f b6 00             	movzbl (%eax),%eax
c0105953:	84 c0                	test   %al,%al
c0105955:	75 ec                	jne    c0105943 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105957:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010595a:	c9                   	leave  
c010595b:	c3                   	ret    

c010595c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010595c:	55                   	push   %ebp
c010595d:	89 e5                	mov    %esp,%ebp
c010595f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105962:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105969:	eb 04                	jmp    c010596f <strnlen+0x13>
        cnt ++;
c010596b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010596f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105972:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105975:	73 10                	jae    c0105987 <strnlen+0x2b>
c0105977:	8b 45 08             	mov    0x8(%ebp),%eax
c010597a:	8d 50 01             	lea    0x1(%eax),%edx
c010597d:	89 55 08             	mov    %edx,0x8(%ebp)
c0105980:	0f b6 00             	movzbl (%eax),%eax
c0105983:	84 c0                	test   %al,%al
c0105985:	75 e4                	jne    c010596b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105987:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010598a:	c9                   	leave  
c010598b:	c3                   	ret    

c010598c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010598c:	55                   	push   %ebp
c010598d:	89 e5                	mov    %esp,%ebp
c010598f:	57                   	push   %edi
c0105990:	56                   	push   %esi
c0105991:	83 ec 20             	sub    $0x20,%esp
c0105994:	8b 45 08             	mov    0x8(%ebp),%eax
c0105997:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010599a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010599d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01059a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01059a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059a6:	89 d1                	mov    %edx,%ecx
c01059a8:	89 c2                	mov    %eax,%edx
c01059aa:	89 ce                	mov    %ecx,%esi
c01059ac:	89 d7                	mov    %edx,%edi
c01059ae:	ac                   	lods   %ds:(%esi),%al
c01059af:	aa                   	stos   %al,%es:(%edi)
c01059b0:	84 c0                	test   %al,%al
c01059b2:	75 fa                	jne    c01059ae <strcpy+0x22>
c01059b4:	89 fa                	mov    %edi,%edx
c01059b6:	89 f1                	mov    %esi,%ecx
c01059b8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01059bb:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01059be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c01059c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c01059c4:	83 c4 20             	add    $0x20,%esp
c01059c7:	5e                   	pop    %esi
c01059c8:	5f                   	pop    %edi
c01059c9:	5d                   	pop    %ebp
c01059ca:	c3                   	ret    

c01059cb <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c01059cb:	55                   	push   %ebp
c01059cc:	89 e5                	mov    %esp,%ebp
c01059ce:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c01059d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01059d7:	eb 21                	jmp    c01059fa <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01059d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059dc:	0f b6 10             	movzbl (%eax),%edx
c01059df:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059e2:	88 10                	mov    %dl,(%eax)
c01059e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01059e7:	0f b6 00             	movzbl (%eax),%eax
c01059ea:	84 c0                	test   %al,%al
c01059ec:	74 04                	je     c01059f2 <strncpy+0x27>
            src ++;
c01059ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01059f2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01059f6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01059fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01059fe:	75 d9                	jne    c01059d9 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105a00:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105a03:	c9                   	leave  
c0105a04:	c3                   	ret    

c0105a05 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105a05:	55                   	push   %ebp
c0105a06:	89 e5                	mov    %esp,%ebp
c0105a08:	57                   	push   %edi
c0105a09:	56                   	push   %esi
c0105a0a:	83 ec 20             	sub    $0x20,%esp
c0105a0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a1f:	89 d1                	mov    %edx,%ecx
c0105a21:	89 c2                	mov    %eax,%edx
c0105a23:	89 ce                	mov    %ecx,%esi
c0105a25:	89 d7                	mov    %edx,%edi
c0105a27:	ac                   	lods   %ds:(%esi),%al
c0105a28:	ae                   	scas   %es:(%edi),%al
c0105a29:	75 08                	jne    c0105a33 <strcmp+0x2e>
c0105a2b:	84 c0                	test   %al,%al
c0105a2d:	75 f8                	jne    c0105a27 <strcmp+0x22>
c0105a2f:	31 c0                	xor    %eax,%eax
c0105a31:	eb 04                	jmp    c0105a37 <strcmp+0x32>
c0105a33:	19 c0                	sbb    %eax,%eax
c0105a35:	0c 01                	or     $0x1,%al
c0105a37:	89 fa                	mov    %edi,%edx
c0105a39:	89 f1                	mov    %esi,%ecx
c0105a3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a3e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105a41:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105a47:	83 c4 20             	add    $0x20,%esp
c0105a4a:	5e                   	pop    %esi
c0105a4b:	5f                   	pop    %edi
c0105a4c:	5d                   	pop    %ebp
c0105a4d:	c3                   	ret    

c0105a4e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105a4e:	55                   	push   %ebp
c0105a4f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a51:	eb 0c                	jmp    c0105a5f <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105a53:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105a57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105a5b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a63:	74 1a                	je     c0105a7f <strncmp+0x31>
c0105a65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a68:	0f b6 00             	movzbl (%eax),%eax
c0105a6b:	84 c0                	test   %al,%al
c0105a6d:	74 10                	je     c0105a7f <strncmp+0x31>
c0105a6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a72:	0f b6 10             	movzbl (%eax),%edx
c0105a75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a78:	0f b6 00             	movzbl (%eax),%eax
c0105a7b:	38 c2                	cmp    %al,%dl
c0105a7d:	74 d4                	je     c0105a53 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a83:	74 18                	je     c0105a9d <strncmp+0x4f>
c0105a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a88:	0f b6 00             	movzbl (%eax),%eax
c0105a8b:	0f b6 d0             	movzbl %al,%edx
c0105a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a91:	0f b6 00             	movzbl (%eax),%eax
c0105a94:	0f b6 c0             	movzbl %al,%eax
c0105a97:	29 c2                	sub    %eax,%edx
c0105a99:	89 d0                	mov    %edx,%eax
c0105a9b:	eb 05                	jmp    c0105aa2 <strncmp+0x54>
c0105a9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105aa2:	5d                   	pop    %ebp
c0105aa3:	c3                   	ret    

c0105aa4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105aa4:	55                   	push   %ebp
c0105aa5:	89 e5                	mov    %esp,%ebp
c0105aa7:	83 ec 04             	sub    $0x4,%esp
c0105aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aad:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ab0:	eb 14                	jmp    c0105ac6 <strchr+0x22>
        if (*s == c) {
c0105ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab5:	0f b6 00             	movzbl (%eax),%eax
c0105ab8:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105abb:	75 05                	jne    c0105ac2 <strchr+0x1e>
            return (char *)s;
c0105abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac0:	eb 13                	jmp    c0105ad5 <strchr+0x31>
        }
        s ++;
c0105ac2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105ac6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac9:	0f b6 00             	movzbl (%eax),%eax
c0105acc:	84 c0                	test   %al,%al
c0105ace:	75 e2                	jne    c0105ab2 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ad5:	c9                   	leave  
c0105ad6:	c3                   	ret    

c0105ad7 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105ad7:	55                   	push   %ebp
c0105ad8:	89 e5                	mov    %esp,%ebp
c0105ada:	83 ec 04             	sub    $0x4,%esp
c0105add:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105ae3:	eb 11                	jmp    c0105af6 <strfind+0x1f>
        if (*s == c) {
c0105ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae8:	0f b6 00             	movzbl (%eax),%eax
c0105aeb:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105aee:	75 02                	jne    c0105af2 <strfind+0x1b>
            break;
c0105af0:	eb 0e                	jmp    c0105b00 <strfind+0x29>
        }
        s ++;
c0105af2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af9:	0f b6 00             	movzbl (%eax),%eax
c0105afc:	84 c0                	test   %al,%al
c0105afe:	75 e5                	jne    c0105ae5 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105b00:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b03:	c9                   	leave  
c0105b04:	c3                   	ret    

c0105b05 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105b05:	55                   	push   %ebp
c0105b06:	89 e5                	mov    %esp,%ebp
c0105b08:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105b0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105b12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b19:	eb 04                	jmp    c0105b1f <strtol+0x1a>
        s ++;
c0105b1b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b22:	0f b6 00             	movzbl (%eax),%eax
c0105b25:	3c 20                	cmp    $0x20,%al
c0105b27:	74 f2                	je     c0105b1b <strtol+0x16>
c0105b29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2c:	0f b6 00             	movzbl (%eax),%eax
c0105b2f:	3c 09                	cmp    $0x9,%al
c0105b31:	74 e8                	je     c0105b1b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105b33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b36:	0f b6 00             	movzbl (%eax),%eax
c0105b39:	3c 2b                	cmp    $0x2b,%al
c0105b3b:	75 06                	jne    c0105b43 <strtol+0x3e>
        s ++;
c0105b3d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b41:	eb 15                	jmp    c0105b58 <strtol+0x53>
    }
    else if (*s == '-') {
c0105b43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b46:	0f b6 00             	movzbl (%eax),%eax
c0105b49:	3c 2d                	cmp    $0x2d,%al
c0105b4b:	75 0b                	jne    c0105b58 <strtol+0x53>
        s ++, neg = 1;
c0105b4d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b51:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105b58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b5c:	74 06                	je     c0105b64 <strtol+0x5f>
c0105b5e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105b62:	75 24                	jne    c0105b88 <strtol+0x83>
c0105b64:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b67:	0f b6 00             	movzbl (%eax),%eax
c0105b6a:	3c 30                	cmp    $0x30,%al
c0105b6c:	75 1a                	jne    c0105b88 <strtol+0x83>
c0105b6e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b71:	83 c0 01             	add    $0x1,%eax
c0105b74:	0f b6 00             	movzbl (%eax),%eax
c0105b77:	3c 78                	cmp    $0x78,%al
c0105b79:	75 0d                	jne    c0105b88 <strtol+0x83>
        s += 2, base = 16;
c0105b7b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105b7f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105b86:	eb 2a                	jmp    c0105bb2 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105b88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b8c:	75 17                	jne    c0105ba5 <strtol+0xa0>
c0105b8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b91:	0f b6 00             	movzbl (%eax),%eax
c0105b94:	3c 30                	cmp    $0x30,%al
c0105b96:	75 0d                	jne    c0105ba5 <strtol+0xa0>
        s ++, base = 8;
c0105b98:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b9c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105ba3:	eb 0d                	jmp    c0105bb2 <strtol+0xad>
    }
    else if (base == 0) {
c0105ba5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ba9:	75 07                	jne    c0105bb2 <strtol+0xad>
        base = 10;
c0105bab:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105bb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb5:	0f b6 00             	movzbl (%eax),%eax
c0105bb8:	3c 2f                	cmp    $0x2f,%al
c0105bba:	7e 1b                	jle    c0105bd7 <strtol+0xd2>
c0105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bbf:	0f b6 00             	movzbl (%eax),%eax
c0105bc2:	3c 39                	cmp    $0x39,%al
c0105bc4:	7f 11                	jg     c0105bd7 <strtol+0xd2>
            dig = *s - '0';
c0105bc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc9:	0f b6 00             	movzbl (%eax),%eax
c0105bcc:	0f be c0             	movsbl %al,%eax
c0105bcf:	83 e8 30             	sub    $0x30,%eax
c0105bd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bd5:	eb 48                	jmp    c0105c1f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105bd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bda:	0f b6 00             	movzbl (%eax),%eax
c0105bdd:	3c 60                	cmp    $0x60,%al
c0105bdf:	7e 1b                	jle    c0105bfc <strtol+0xf7>
c0105be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be4:	0f b6 00             	movzbl (%eax),%eax
c0105be7:	3c 7a                	cmp    $0x7a,%al
c0105be9:	7f 11                	jg     c0105bfc <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105beb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bee:	0f b6 00             	movzbl (%eax),%eax
c0105bf1:	0f be c0             	movsbl %al,%eax
c0105bf4:	83 e8 57             	sub    $0x57,%eax
c0105bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bfa:	eb 23                	jmp    c0105c1f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105bfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bff:	0f b6 00             	movzbl (%eax),%eax
c0105c02:	3c 40                	cmp    $0x40,%al
c0105c04:	7e 3d                	jle    c0105c43 <strtol+0x13e>
c0105c06:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c09:	0f b6 00             	movzbl (%eax),%eax
c0105c0c:	3c 5a                	cmp    $0x5a,%al
c0105c0e:	7f 33                	jg     c0105c43 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c13:	0f b6 00             	movzbl (%eax),%eax
c0105c16:	0f be c0             	movsbl %al,%eax
c0105c19:	83 e8 37             	sub    $0x37,%eax
c0105c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c22:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105c25:	7c 02                	jl     c0105c29 <strtol+0x124>
            break;
c0105c27:	eb 1a                	jmp    c0105c43 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105c29:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c30:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105c34:	89 c2                	mov    %eax,%edx
c0105c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c39:	01 d0                	add    %edx,%eax
c0105c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105c3e:	e9 6f ff ff ff       	jmp    c0105bb2 <strtol+0xad>

    if (endptr) {
c0105c43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c47:	74 08                	je     c0105c51 <strtol+0x14c>
        *endptr = (char *) s;
c0105c49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c4c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c4f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105c51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105c55:	74 07                	je     c0105c5e <strtol+0x159>
c0105c57:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105c5a:	f7 d8                	neg    %eax
c0105c5c:	eb 03                	jmp    c0105c61 <strtol+0x15c>
c0105c5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105c61:	c9                   	leave  
c0105c62:	c3                   	ret    

c0105c63 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105c63:	55                   	push   %ebp
c0105c64:	89 e5                	mov    %esp,%ebp
c0105c66:	57                   	push   %edi
c0105c67:	83 ec 24             	sub    $0x24,%esp
c0105c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c6d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105c70:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105c74:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c77:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105c7a:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105c7d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105c83:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105c86:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105c8a:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105c8d:	89 d7                	mov    %edx,%edi
c0105c8f:	f3 aa                	rep stos %al,%es:(%edi)
c0105c91:	89 fa                	mov    %edi,%edx
c0105c93:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105c96:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105c9c:	83 c4 24             	add    $0x24,%esp
c0105c9f:	5f                   	pop    %edi
c0105ca0:	5d                   	pop    %ebp
c0105ca1:	c3                   	ret    

c0105ca2 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105ca2:	55                   	push   %ebp
c0105ca3:	89 e5                	mov    %esp,%ebp
c0105ca5:	57                   	push   %edi
c0105ca6:	56                   	push   %esi
c0105ca7:	53                   	push   %ebx
c0105ca8:	83 ec 30             	sub    $0x30,%esp
c0105cab:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cb4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105cb7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cba:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cc0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105cc3:	73 42                	jae    c0105d07 <memmove+0x65>
c0105cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cce:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105cd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cd4:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105cd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105cda:	c1 e8 02             	shr    $0x2,%eax
c0105cdd:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105cdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ce2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ce5:	89 d7                	mov    %edx,%edi
c0105ce7:	89 c6                	mov    %eax,%esi
c0105ce9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105ceb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105cee:	83 e1 03             	and    $0x3,%ecx
c0105cf1:	74 02                	je     c0105cf5 <memmove+0x53>
c0105cf3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105cf5:	89 f0                	mov    %esi,%eax
c0105cf7:	89 fa                	mov    %edi,%edx
c0105cf9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105cfc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105cff:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d05:	eb 36                	jmp    c0105d3d <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105d07:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d0a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d10:	01 c2                	add    %eax,%edx
c0105d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d15:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d1b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d21:	89 c1                	mov    %eax,%ecx
c0105d23:	89 d8                	mov    %ebx,%eax
c0105d25:	89 d6                	mov    %edx,%esi
c0105d27:	89 c7                	mov    %eax,%edi
c0105d29:	fd                   	std    
c0105d2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d2c:	fc                   	cld    
c0105d2d:	89 f8                	mov    %edi,%eax
c0105d2f:	89 f2                	mov    %esi,%edx
c0105d31:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105d34:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105d37:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105d3d:	83 c4 30             	add    $0x30,%esp
c0105d40:	5b                   	pop    %ebx
c0105d41:	5e                   	pop    %esi
c0105d42:	5f                   	pop    %edi
c0105d43:	5d                   	pop    %ebp
c0105d44:	c3                   	ret    

c0105d45 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105d45:	55                   	push   %ebp
c0105d46:	89 e5                	mov    %esp,%ebp
c0105d48:	57                   	push   %edi
c0105d49:	56                   	push   %esi
c0105d4a:	83 ec 20             	sub    $0x20,%esp
c0105d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d59:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d62:	c1 e8 02             	shr    $0x2,%eax
c0105d65:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d6d:	89 d7                	mov    %edx,%edi
c0105d6f:	89 c6                	mov    %eax,%esi
c0105d71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d73:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105d76:	83 e1 03             	and    $0x3,%ecx
c0105d79:	74 02                	je     c0105d7d <memcpy+0x38>
c0105d7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d7d:	89 f0                	mov    %esi,%eax
c0105d7f:	89 fa                	mov    %edi,%edx
c0105d81:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d84:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105d8d:	83 c4 20             	add    $0x20,%esp
c0105d90:	5e                   	pop    %esi
c0105d91:	5f                   	pop    %edi
c0105d92:	5d                   	pop    %ebp
c0105d93:	c3                   	ret    

c0105d94 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105d94:	55                   	push   %ebp
c0105d95:	89 e5                	mov    %esp,%ebp
c0105d97:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105d9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105da0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105da6:	eb 30                	jmp    c0105dd8 <memcmp+0x44>
        if (*s1 != *s2) {
c0105da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dab:	0f b6 10             	movzbl (%eax),%edx
c0105dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105db1:	0f b6 00             	movzbl (%eax),%eax
c0105db4:	38 c2                	cmp    %al,%dl
c0105db6:	74 18                	je     c0105dd0 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dbb:	0f b6 00             	movzbl (%eax),%eax
c0105dbe:	0f b6 d0             	movzbl %al,%edx
c0105dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dc4:	0f b6 00             	movzbl (%eax),%eax
c0105dc7:	0f b6 c0             	movzbl %al,%eax
c0105dca:	29 c2                	sub    %eax,%edx
c0105dcc:	89 d0                	mov    %edx,%eax
c0105dce:	eb 1a                	jmp    c0105dea <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105dd0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105dd4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105dd8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ddb:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105dde:	89 55 10             	mov    %edx,0x10(%ebp)
c0105de1:	85 c0                	test   %eax,%eax
c0105de3:	75 c3                	jne    c0105da8 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105dea:	c9                   	leave  
c0105deb:	c3                   	ret    
