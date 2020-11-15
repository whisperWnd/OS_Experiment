
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
c010005d:	e8 a5 5b 00 00       	call   c0105c07 <memset>

    cons_init();                // init the console
c0100062:	e8 7c 15 00 00       	call   c01015e3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 a0 5d 10 c0 	movl   $0xc0105da0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 bc 5d 10 c0 	movl   $0xc0105dbc,(%esp)
c010007c:	e8 c7 02 00 00       	call   c0100348 <cprintf>

    print_kerninfo();
c0100081:	e8 f6 07 00 00       	call   c010087c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 86 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 71 42 00 00       	call   c0104301 <pmm_init>

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
c0100161:	c7 04 24 c1 5d 10 c0 	movl   $0xc0105dc1,(%esp)
c0100168:	e8 db 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100171:	0f b7 d0             	movzwl %ax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 cf 5d 10 c0 	movl   $0xc0105dcf,(%esp)
c0100188:	e8 bb 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	0f b7 d0             	movzwl %ax,%edx
c0100194:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100199:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a1:	c7 04 24 dd 5d 10 c0 	movl   $0xc0105ddd,(%esp)
c01001a8:	e8 9b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b1:	0f b7 d0             	movzwl %ax,%edx
c01001b4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c1:	c7 04 24 eb 5d 10 c0 	movl   $0xc0105deb,(%esp)
c01001c8:	e8 7b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d1:	0f b7 d0             	movzwl %ax,%edx
c01001d4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e1:	c7 04 24 f9 5d 10 c0 	movl   $0xc0105df9,(%esp)
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
c0100211:	c7 04 24 08 5e 10 c0 	movl   $0xc0105e08,(%esp)
c0100218:	e8 2b 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_user();
c010021d:	e8 da ff ff ff       	call   c01001fc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100222:	e8 0f ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100227:	c7 04 24 28 5e 10 c0 	movl   $0xc0105e28,(%esp)
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
c0100252:	c7 04 24 47 5e 10 c0 	movl   $0xc0105e47,(%esp)
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
c010033e:	e8 dd 50 00 00       	call   c0105420 <vprintfmt>
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
c0100548:	c7 00 4c 5e 10 c0    	movl   $0xc0105e4c,(%eax)
    info->eip_line = 0;
c010054e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055b:	c7 40 08 4c 5e 10 c0 	movl   $0xc0105e4c,0x8(%eax)
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
c010057f:	c7 45 f4 c0 70 10 c0 	movl   $0xc01070c0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100586:	c7 45 f0 1c 1a 11 c0 	movl   $0xc0111a1c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058d:	c7 45 ec 1d 1a 11 c0 	movl   $0xc0111a1d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100594:	c7 45 e8 30 44 11 c0 	movl   $0xc0114430,-0x18(%ebp)

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
c01006f3:	e8 83 53 00 00       	call   c0105a7b <strfind>
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
c0100882:	c7 04 24 56 5e 10 c0 	movl   $0xc0105e56,(%esp)
c0100889:	e8 ba fa ff ff       	call   c0100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100895:	c0 
c0100896:	c7 04 24 6f 5e 10 c0 	movl   $0xc0105e6f,(%esp)
c010089d:	e8 a6 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a2:	c7 44 24 04 90 5d 10 	movl   $0xc0105d90,0x4(%esp)
c01008a9:	c0 
c01008aa:	c7 04 24 87 5e 10 c0 	movl   $0xc0105e87,(%esp)
c01008b1:	e8 92 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b6:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c01008bd:	c0 
c01008be:	c7 04 24 9f 5e 10 c0 	movl   $0xc0105e9f,(%esp)
c01008c5:	e8 7e fa ff ff       	call   c0100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ca:	c7 44 24 04 28 af 11 	movl   $0xc011af28,0x4(%esp)
c01008d1:	c0 
c01008d2:	c7 04 24 b7 5e 10 c0 	movl   $0xc0105eb7,(%esp)
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
c0100904:	c7 04 24 d0 5e 10 c0 	movl   $0xc0105ed0,(%esp)
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
c0100938:	c7 04 24 fa 5e 10 c0 	movl   $0xc0105efa,(%esp)
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
c01009a7:	c7 04 24 16 5f 10 c0 	movl   $0xc0105f16,(%esp)
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
c01009f9:	c7 04 24 28 5f 10 c0 	movl   $0xc0105f28,(%esp)
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
c0100a26:	c7 04 24 44 5f 10 c0 	movl   $0xc0105f44,(%esp)
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
c0100a3c:	c7 04 24 4c 5f 10 c0 	movl   $0xc0105f4c,(%esp)
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
c0100ab1:	c7 04 24 d0 5f 10 c0 	movl   $0xc0105fd0,(%esp)
c0100ab8:	e8 8b 4f 00 00       	call   c0105a48 <strchr>
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
c0100adb:	c7 04 24 d5 5f 10 c0 	movl   $0xc0105fd5,(%esp)
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
c0100b1e:	c7 04 24 d0 5f 10 c0 	movl   $0xc0105fd0,(%esp)
c0100b25:	e8 1e 4f 00 00       	call   c0105a48 <strchr>
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
c0100b8a:	e8 1a 4e 00 00       	call   c01059a9 <strcmp>
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
c0100bd8:	c7 04 24 f3 5f 10 c0 	movl   $0xc0105ff3,(%esp)
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
c0100bf1:	c7 04 24 0c 60 10 c0 	movl   $0xc010600c,(%esp)
c0100bf8:	e8 4b f7 ff ff       	call   c0100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfd:	c7 04 24 34 60 10 c0 	movl   $0xc0106034,(%esp)
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
c0100c1a:	c7 04 24 59 60 10 c0 	movl   $0xc0106059,(%esp)
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
c0100c89:	c7 04 24 5d 60 10 c0 	movl   $0xc010605d,(%esp)
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
c0100cfb:	c7 04 24 66 60 10 c0 	movl   $0xc0106066,(%esp)
c0100d02:	e8 41 f6 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d11:	89 04 24             	mov    %eax,(%esp)
c0100d14:	e8 fc f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d19:	c7 04 24 82 60 10 c0 	movl   $0xc0106082,(%esp)
c0100d20:	e8 23 f6 ff ff       	call   c0100348 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d25:	c7 04 24 84 60 10 c0 	movl   $0xc0106084,(%esp)
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
c0100d63:	c7 04 24 96 60 10 c0 	movl   $0xc0106096,(%esp)
c0100d6a:	e8 d9 f5 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d76:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d79:	89 04 24             	mov    %eax,(%esp)
c0100d7c:	e8 94 f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d81:	c7 04 24 82 60 10 c0 	movl   $0xc0106082,(%esp)
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
c0100de2:	c7 04 24 b4 60 10 c0 	movl   $0xc01060b4,(%esp)
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
c010120c:	e8 35 4a 00 00       	call   c0105c46 <memmove>
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
c0101592:	c7 04 24 cf 60 10 c0 	movl   $0xc01060cf,(%esp)
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
c0101601:	c7 04 24 db 60 10 c0 	movl   $0xc01060db,(%esp)
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
c0101895:	c7 04 24 00 61 10 c0 	movl   $0xc0106100,(%esp)
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
c0101a22:	8b 04 85 60 64 10 c0 	mov    -0x3fef9ba0(,%eax,4),%eax
c0101a29:	eb 18                	jmp    c0101a43 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a2b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a2f:	7e 0d                	jle    c0101a3e <trapname+0x2a>
c0101a31:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a35:	7f 07                	jg     c0101a3e <trapname+0x2a>
        return "Hardware Interrupt";
c0101a37:	b8 0a 61 10 c0       	mov    $0xc010610a,%eax
c0101a3c:	eb 05                	jmp    c0101a43 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a3e:	b8 1d 61 10 c0       	mov    $0xc010611d,%eax
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
c0101a68:	c7 04 24 5e 61 10 c0 	movl   $0xc010615e,(%esp)
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
c0101a8d:	c7 04 24 6f 61 10 c0 	movl   $0xc010616f,(%esp)
c0101a94:	e8 af e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101aa0:	0f b7 c0             	movzwl %ax,%eax
c0101aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa7:	c7 04 24 82 61 10 c0 	movl   $0xc0106182,(%esp)
c0101aae:	e8 95 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab6:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101aba:	0f b7 c0             	movzwl %ax,%eax
c0101abd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac1:	c7 04 24 95 61 10 c0 	movl   $0xc0106195,(%esp)
c0101ac8:	e8 7b e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad0:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101ad4:	0f b7 c0             	movzwl %ax,%eax
c0101ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101adb:	c7 04 24 a8 61 10 c0 	movl   $0xc01061a8,(%esp)
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
c0101b03:	c7 04 24 bb 61 10 c0 	movl   $0xc01061bb,(%esp)
c0101b0a:	e8 39 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b12:	8b 40 34             	mov    0x34(%eax),%eax
c0101b15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b19:	c7 04 24 cd 61 10 c0 	movl   $0xc01061cd,(%esp)
c0101b20:	e8 23 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b28:	8b 40 38             	mov    0x38(%eax),%eax
c0101b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b2f:	c7 04 24 dc 61 10 c0 	movl   $0xc01061dc,(%esp)
c0101b36:	e8 0d e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b42:	0f b7 c0             	movzwl %ax,%eax
c0101b45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b49:	c7 04 24 eb 61 10 c0 	movl   $0xc01061eb,(%esp)
c0101b50:	e8 f3 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b58:	8b 40 40             	mov    0x40(%eax),%eax
c0101b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5f:	c7 04 24 fe 61 10 c0 	movl   $0xc01061fe,(%esp)
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
c0101ba6:	c7 04 24 0d 62 10 c0 	movl   $0xc010620d,(%esp)
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
c0101bd3:	c7 04 24 11 62 10 c0 	movl   $0xc0106211,(%esp)
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
c0101bf8:	c7 04 24 1a 62 10 c0 	movl   $0xc010621a,(%esp)
c0101bff:	e8 44 e7 ff ff       	call   c0100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c07:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c0b:	0f b7 c0             	movzwl %ax,%eax
c0101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c12:	c7 04 24 29 62 10 c0 	movl   $0xc0106229,(%esp)
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
c0101c2f:	c7 04 24 3c 62 10 c0 	movl   $0xc010623c,(%esp)
c0101c36:	e8 0d e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3e:	8b 40 04             	mov    0x4(%eax),%eax
c0101c41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c45:	c7 04 24 4b 62 10 c0 	movl   $0xc010624b,(%esp)
c0101c4c:	e8 f7 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c54:	8b 40 08             	mov    0x8(%eax),%eax
c0101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c5b:	c7 04 24 5a 62 10 c0 	movl   $0xc010625a,(%esp)
c0101c62:	e8 e1 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6a:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c71:	c7 04 24 69 62 10 c0 	movl   $0xc0106269,(%esp)
c0101c78:	e8 cb e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c80:	8b 40 10             	mov    0x10(%eax),%eax
c0101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c87:	c7 04 24 78 62 10 c0 	movl   $0xc0106278,(%esp)
c0101c8e:	e8 b5 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c96:	8b 40 14             	mov    0x14(%eax),%eax
c0101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9d:	c7 04 24 87 62 10 c0 	movl   $0xc0106287,(%esp)
c0101ca4:	e8 9f e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cac:	8b 40 18             	mov    0x18(%eax),%eax
c0101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb3:	c7 04 24 96 62 10 c0 	movl   $0xc0106296,(%esp)
c0101cba:	e8 89 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc2:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc9:	c7 04 24 a5 62 10 c0 	movl   $0xc01062a5,(%esp)
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
c0101d6d:	c7 04 24 b4 62 10 c0 	movl   $0xc01062b4,(%esp)
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
c0101d93:	c7 04 24 c6 62 10 c0 	movl   $0xc01062c6,(%esp)
c0101d9a:	e8 a9 e5 ff ff       	call   c0100348 <cprintf>
        break;
c0101d9f:	eb 55                	jmp    c0101df6 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101da1:	c7 44 24 08 d5 62 10 	movl   $0xc01062d5,0x8(%esp)
c0101da8:	c0 
c0101da9:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0101db0:	00 
c0101db1:	c7 04 24 e5 62 10 c0 	movl   $0xc01062e5,(%esp)
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
c0101dd9:	c7 44 24 08 f6 62 10 	movl   $0xc01062f6,0x8(%esp)
c0101de0:	c0 
c0101de1:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0101de8:	00 
c0101de9:	c7 04 24 e5 62 10 c0 	movl   $0xc01062e5,(%esp)
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
    list_init(&free_list);  //初始化free_list
    nr_free = 0;  //空闲内存块的数量
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
c0102916:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);  //判断n是否>0
c0102919:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010291d:	75 24                	jne    c0102943 <default_init_memmap+0x30>
c010291f:	c7 44 24 0c b0 64 10 	movl   $0xc01064b0,0xc(%esp)
c0102926:	c0 
c0102927:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010292e:	c0 
c010292f:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102936:	00 
c0102937:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010293e:	e8 89 e3 ff ff       	call   c0100ccc <__panic>
    struct Page *p = base;
c0102943:	8b 45 08             	mov    0x8(%ebp),%eax
c0102946:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {  //初始化n块物理页
c0102949:	e9 de 00 00 00       	jmp    c0102a2c <default_init_memmap+0x119>
        assert(PageReserved(p));  //检查此页是否为保留页
c010294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102951:	83 c0 04             	add    $0x4,%eax
c0102954:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010295b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010295e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102961:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102964:	0f a3 10             	bt     %edx,(%eax)
c0102967:	19 c0                	sbb    %eax,%eax
c0102969:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010296c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102970:	0f 95 c0             	setne  %al
c0102973:	0f b6 c0             	movzbl %al,%eax
c0102976:	85 c0                	test   %eax,%eax
c0102978:	75 24                	jne    c010299e <default_init_memmap+0x8b>
c010297a:	c7 44 24 0c e1 64 10 	movl   $0xc01064e1,0xc(%esp)
c0102981:	c0 
c0102982:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102989:	c0 
c010298a:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102991:	00 
c0102992:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102999:	e8 2e e3 ff ff       	call   c0100ccc <__panic>
        p->flags = p->property = 0;  //标志位清0,物理页属性和连续空页个数
c010299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ab:	8b 50 08             	mov    0x8(%eax),%edx
c01029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029b1:	89 50 04             	mov    %edx,0x4(%eax)
	SetPageProperty(p);  //设置标志位为1
c01029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029b7:	83 c0 04             	add    $0x4,%eax
c01029ba:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029ca:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);  //清除引用此页的虚拟页的个数
c01029cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029d4:	00 
c01029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d8:	89 04 24             	mov    %eax,(%esp)
c01029db:	e8 f9 fe ff ff       	call   c01028d9 <set_page_ref>
	//加入空闲链表
	list_add_before(&free_list, &(p->page_link));
c01029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e3:	83 c0 0c             	add    $0xc,%eax
c01029e6:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
c01029ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01029f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029f3:	8b 00                	mov    (%eax),%eax
c01029f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01029f8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01029fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01029fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a01:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a04:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a0a:	89 10                	mov    %edx,(%eax)
c0102a0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a0f:	8b 10                	mov    (%eax),%edx
c0102a11:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a14:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a1a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a1d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a23:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a26:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);  //判断n是否>0
    struct Page *p = base;
    for (; p != base + n; p ++) {  //初始化n块物理页
c0102a28:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a2f:	89 d0                	mov    %edx,%eax
c0102a31:	c1 e0 02             	shl    $0x2,%eax
c0102a34:	01 d0                	add    %edx,%eax
c0102a36:	c1 e0 02             	shl    $0x2,%eax
c0102a39:	89 c2                	mov    %eax,%edx
c0102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a3e:	01 d0                	add    %edx,%eax
c0102a40:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a43:	0f 85 05 ff ff ff    	jne    c010294e <default_init_memmap+0x3b>
	SetPageProperty(p);  //设置标志位为1
        set_page_ref(p, 0);  //清除引用此页的虚拟页的个数
	//加入空闲链表
	list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;  //修改base的连续空闲页总数为n
c0102a49:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a4f:	89 50 08             	mov    %edx,0x8(%eax)
    //SetPageProperty(base);
    nr_free += n;  //计算空闲页总数
c0102a52:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102a58:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a5b:	01 d0                	add    %edx,%eax
c0102a5d:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    //list_add(&free_list, &(base->page_link));
}
c0102a62:	c9                   	leave  
c0102a63:	c3                   	ret    

c0102a64 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a64:	55                   	push   %ebp
c0102a65:	89 e5                	mov    %esp,%ebp
c0102a67:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102a6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a6e:	75 24                	jne    c0102a94 <default_alloc_pages+0x30>
c0102a70:	c7 44 24 0c b0 64 10 	movl   $0xc01064b0,0xc(%esp)
c0102a77:	c0 
c0102a78:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102a7f:	c0 
c0102a80:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
c0102a87:	00 
c0102a88:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102a8f:	e8 38 e2 ff ff       	call   c0100ccc <__panic>
    if (n > nr_free) {  //需要分配页的个数，<n直接返回
c0102a94:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102a99:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a9c:	73 0a                	jae    c0102aa8 <default_alloc_pages+0x44>
        return NULL;
c0102a9e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102aa3:	e9 3e 01 00 00       	jmp    c0102be6 <default_alloc_pages+0x182>
    }
    struct Page *page = NULL;
c0102aa8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    list_entry_t *le = &free_list;  //链表头
c0102aaf:	c7 45 f4 10 af 11 c0 	movl   $0xc011af10,-0xc(%ebp)
    list_entry_t *len;  //长度
    while((le=list_next(le)) != &free_list) {//遍历整个空闲链表
c0102ab6:	e9 0a 01 00 00       	jmp    c0102bc5 <default_alloc_pages+0x161>
      struct Page *p = le2page(le, page_link); //转换为页结构
c0102abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102abe:	83 e8 0c             	sub    $0xc,%eax
c0102ac1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(p->property >= n){ //找到合适的空闲页
c0102ac4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ac7:	8b 40 08             	mov    0x8(%eax),%eax
c0102aca:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102acd:	0f 82 f2 00 00 00    	jb     c0102bc5 <default_alloc_pages+0x161>
        int i;
        for(i=0;i<n;i++){
c0102ad3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102ada:	eb 7c                	jmp    c0102b58 <default_alloc_pages+0xf4>
c0102adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102adf:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102ae2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ae5:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le); 
c0102ae8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          struct Page *pp = le2page(le, page_link); //转换页结构
c0102aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102aee:	83 e8 0c             	sub    $0xc,%eax
c0102af1:	89 45 e0             	mov    %eax,-0x20(%ebp)
          SetPageReserved(pp); //设置每一页的标志位
c0102af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102af7:	83 c0 04             	add    $0x4,%eax
c0102afa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c0102b01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102b04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b07:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b0a:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp); 
c0102b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b10:	83 c0 04             	add    $0x4,%eax
c0102b13:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0102b1a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102b20:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102b23:	0f b3 10             	btr    %edx,(%eax)
c0102b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b29:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b2f:	8b 40 04             	mov    0x4(%eax),%eax
c0102b32:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102b35:	8b 12                	mov    (%edx),%edx
c0102b37:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102b3a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b3d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102b40:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b43:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b46:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b49:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b4c:	89 10                	mov    %edx,(%eax)
          list_del(le); //将此页从free_list中清除
          le = len;
c0102b4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *len;  //长度
    while((le=list_next(le)) != &free_list) {//遍历整个空闲链表
      struct Page *p = le2page(le, page_link); //转换为页结构
      if(p->property >= n){ //找到合适的空闲页
        int i;
        for(i=0;i<n;i++){
c0102b54:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b5b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b5e:	0f 82 78 ff ff ff    	jb     c0102adc <default_alloc_pages+0x78>
          SetPageReserved(pp); //设置每一页的标志位
          ClearPageProperty(pp); 
          list_del(le); //将此页从free_list中清除
          le = len;
        }
        if(p->property>n){ //如果页块大小大于所需大小，分割页块
c0102b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b67:	8b 40 08             	mov    0x8(%eax),%eax
c0102b6a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b6d:	76 12                	jbe    c0102b81 <default_alloc_pages+0x11d>
          (le2page(le,page_link))->property = p->property-n;
c0102b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b72:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b78:	8b 40 08             	mov    0x8(%eax),%eax
c0102b7b:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b7e:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c0102b81:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b84:	83 c0 04             	add    $0x4,%eax
c0102b87:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0102b8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102b91:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b94:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b97:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c0102b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b9d:	83 c0 04             	add    $0x4,%eax
c0102ba0:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
c0102ba7:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102baa:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102bad:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102bb0:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n; //减去已经分配的页块大小
c0102bb3:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c0102bb8:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bbb:	a3 18 af 11 c0       	mov    %eax,0xc011af18
        return p;
c0102bc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bc3:	eb 21                	jmp    c0102be6 <default_alloc_pages+0x182>
c0102bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc8:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102bcb:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102bce:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;  //链表头
    list_entry_t *len;  //长度
    while((le=list_next(le)) != &free_list) {//遍历整个空闲链表
c0102bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102bd4:	81 7d f4 10 af 11 c0 	cmpl   $0xc011af10,-0xc(%ebp)
c0102bdb:	0f 85 da fe ff ff    	jne    c0102abb <default_alloc_pages+0x57>
        SetPageReserved(p);
        nr_free -= n; //减去已经分配的页块大小
        return p;
      }
    }
    return NULL;
c0102be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102be6:	c9                   	leave  
c0102be7:	c3                   	ret    

c0102be8 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102be8:	55                   	push   %ebp
c0102be9:	89 e5                	mov    %esp,%ebp
c0102beb:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);  
c0102bee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102bf2:	75 24                	jne    c0102c18 <default_free_pages+0x30>
c0102bf4:	c7 44 24 0c b0 64 10 	movl   $0xc01064b0,0xc(%esp)
c0102bfb:	c0 
c0102bfc:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102c03:	c0 
c0102c04:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0102c0b:	00 
c0102c0c:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102c13:	e8 b4 e0 ff ff       	call   c0100ccc <__panic>
    assert(PageReserved(base));    //检查需要释放的页块是否已经被分配
c0102c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c1b:	83 c0 04             	add    $0x4,%eax
c0102c1e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c25:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c2e:	0f a3 10             	bt     %edx,(%eax)
c0102c31:	19 c0                	sbb    %eax,%eax
c0102c33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c3a:	0f 95 c0             	setne  %al
c0102c3d:	0f b6 c0             	movzbl %al,%eax
c0102c40:	85 c0                	test   %eax,%eax
c0102c42:	75 24                	jne    c0102c68 <default_free_pages+0x80>
c0102c44:	c7 44 24 0c f1 64 10 	movl   $0xc01064f1,0xc(%esp)
c0102c4b:	c0 
c0102c4c:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102c53:	c0 
c0102c54:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
c0102c5b:	00 
c0102c5c:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102c63:	e8 64 e0 ff ff       	call   c0100ccc <__panic>
    list_entry_t *le = &free_list; 
c0102c68:	c7 45 f4 10 af 11 c0 	movl   $0xc011af10,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {    //寻找合适的位置
c0102c6f:	eb 13                	jmp    c0102c84 <default_free_pages+0x9c>
      p = le2page(le, page_link); //获取链表对应的Page
c0102c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c74:	83 e8 0c             	sub    $0xc,%eax
c0102c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){    
c0102c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c7d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c80:	76 02                	jbe    c0102c84 <default_free_pages+0x9c>
        break;
c0102c82:	eb 18                	jmp    c0102c9c <default_free_pages+0xb4>
c0102c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c87:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102c8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c8d:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);  
    assert(PageReserved(base));    //检查需要释放的页块是否已经被分配
    list_entry_t *le = &free_list; 
    struct Page * p;
    while((le=list_next(le)) != &free_list) {    //寻找合适的位置
c0102c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c93:	81 7d f4 10 af 11 c0 	cmpl   $0xc011af10,-0xc(%ebp)
c0102c9a:	75 d5                	jne    c0102c71 <default_free_pages+0x89>
      p = le2page(le, page_link); //获取链表对应的Page
      if(p>base){    
        break;
      }
    }
    for(p=base;p<base+n;p++){              
c0102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ca2:	eb 4b                	jmp    c0102cef <default_free_pages+0x107>
      list_add_before(le, &(p->page_link)); //将每一空闲块对应的链表插入空闲链表中
c0102ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ca7:	8d 50 0c             	lea    0xc(%eax),%edx
c0102caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cad:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102cb0:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102cb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cb6:	8b 00                	mov    (%eax),%eax
c0102cb8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102cbb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102cbe:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102cc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cc4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102cc7:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ccd:	89 10                	mov    %edx,(%eax)
c0102ccf:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cd2:	8b 10                	mov    (%eax),%edx
c0102cd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cd7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102cda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102cdd:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ce0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102ce3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102ce6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102ce9:	89 10                	mov    %edx,(%eax)
      p = le2page(le, page_link); //获取链表对应的Page
      if(p>base){    
        break;
      }
    }
    for(p=base;p<base+n;p++){              
c0102ceb:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0102cef:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cf2:	89 d0                	mov    %edx,%eax
c0102cf4:	c1 e0 02             	shl    $0x2,%eax
c0102cf7:	01 d0                	add    %edx,%eax
c0102cf9:	c1 e0 02             	shl    $0x2,%eax
c0102cfc:	89 c2                	mov    %eax,%edx
c0102cfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d01:	01 d0                	add    %edx,%eax
c0102d03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d06:	77 9c                	ja     c0102ca4 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link)); //将每一空闲块对应的链表插入空闲链表中
    }
    base->flags = 0;         //修改标志位
c0102d08:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);    
c0102d12:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d19:	00 
c0102d1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d1d:	89 04 24             	mov    %eax,(%esp)
c0102d20:	e8 b4 fb ff ff       	call   c01028d9 <set_page_ref>
    ClearPageProperty(base);
c0102d25:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d28:	83 c0 04             	add    $0x4,%eax
c0102d2b:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102d32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d35:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d38:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d3b:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d41:	83 c0 04             	add    $0x4,%eax
c0102d44:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102d4b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d4e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d51:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d54:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;      //设置连续大小为n
c0102d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d5d:	89 50 08             	mov    %edx,0x8(%eax)
    //如果是高位，则向高地址合并
    p = le2page(le,page_link) ;
c0102d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d63:	83 e8 0c             	sub    $0xc,%eax
c0102d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c0102d69:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d6c:	89 d0                	mov    %edx,%eax
c0102d6e:	c1 e0 02             	shl    $0x2,%eax
c0102d71:	01 d0                	add    %edx,%eax
c0102d73:	c1 e0 02             	shl    $0x2,%eax
c0102d76:	89 c2                	mov    %eax,%edx
c0102d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d7b:	01 d0                	add    %edx,%eax
c0102d7d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d80:	75 1e                	jne    c0102da0 <default_free_pages+0x1b8>
      base->property += p->property;
c0102d82:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d85:	8b 50 08             	mov    0x8(%eax),%edx
c0102d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d8b:	8b 40 08             	mov    0x8(%eax),%eax
c0102d8e:	01 c2                	add    %eax,%edx
c0102d90:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d93:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0102d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
     //如果是低位且在范围内，则向低地址合并
    le = list_prev(&(base->page_link));
c0102da0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da3:	83 c0 0c             	add    $0xc,%eax
c0102da6:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102da9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dac:	8b 00                	mov    (%eax),%eax
c0102dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c0102db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db4:	83 e8 0c             	sub    $0xc,%eax
c0102db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){ //满足条件，未分配则合并
c0102dba:	81 7d f4 10 af 11 c0 	cmpl   $0xc011af10,-0xc(%ebp)
c0102dc1:	74 57                	je     c0102e1a <default_free_pages+0x232>
c0102dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc6:	83 e8 14             	sub    $0x14,%eax
c0102dc9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102dcc:	75 4c                	jne    c0102e1a <default_free_pages+0x232>
      while(le!=&free_list){
c0102dce:	eb 41                	jmp    c0102e11 <default_free_pages+0x229>
        if(p->property){ //连续
c0102dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dd3:	8b 40 08             	mov    0x8(%eax),%eax
c0102dd6:	85 c0                	test   %eax,%eax
c0102dd8:	74 20                	je     c0102dfa <default_free_pages+0x212>
          p->property += base->property;
c0102dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ddd:	8b 50 08             	mov    0x8(%eax),%edx
c0102de0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102de3:	8b 40 08             	mov    0x8(%eax),%eax
c0102de6:	01 c2                	add    %eax,%edx
c0102de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102deb:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c0102dee:	8b 45 08             	mov    0x8(%ebp),%eax
c0102df1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0102df8:	eb 20                	jmp    c0102e1a <default_free_pages+0x232>
c0102dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dfd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102e00:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e03:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0102e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0102e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e0b:	83 e8 0c             	sub    $0xc,%eax
c0102e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
     //如果是低位且在范围内，则向低地址合并
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){ //满足条件，未分配则合并
      while(le!=&free_list){
c0102e11:	81 7d f4 10 af 11 c0 	cmpl   $0xc011af10,-0xc(%ebp)
c0102e18:	75 b6                	jne    c0102dd0 <default_free_pages+0x1e8>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
c0102e1a:	8b 15 18 af 11 c0    	mov    0xc011af18,%edx
c0102e20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e23:	01 d0                	add    %edx,%eax
c0102e25:	a3 18 af 11 c0       	mov    %eax,0xc011af18
    return ;
c0102e2a:	90                   	nop
}
c0102e2b:	c9                   	leave  
c0102e2c:	c3                   	ret    

c0102e2d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e2d:	55                   	push   %ebp
c0102e2e:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e30:	a1 18 af 11 c0       	mov    0xc011af18,%eax
}
c0102e35:	5d                   	pop    %ebp
c0102e36:	c3                   	ret    

c0102e37 <basic_check>:

static void
basic_check(void) {
c0102e37:	55                   	push   %ebp
c0102e38:	89 e5                	mov    %esp,%ebp
c0102e3a:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e57:	e8 ce 0e 00 00       	call   c0103d2a <alloc_pages>
c0102e5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e63:	75 24                	jne    c0102e89 <basic_check+0x52>
c0102e65:	c7 44 24 0c 04 65 10 	movl   $0xc0106504,0xc(%esp)
c0102e6c:	c0 
c0102e6d:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102e74:	c0 
c0102e75:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0102e7c:	00 
c0102e7d:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102e84:	e8 43 de ff ff       	call   c0100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102e89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e90:	e8 95 0e 00 00       	call   c0103d2a <alloc_pages>
c0102e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102e9c:	75 24                	jne    c0102ec2 <basic_check+0x8b>
c0102e9e:	c7 44 24 0c 20 65 10 	movl   $0xc0106520,0xc(%esp)
c0102ea5:	c0 
c0102ea6:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102ead:	c0 
c0102eae:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0102eb5:	00 
c0102eb6:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102ebd:	e8 0a de ff ff       	call   c0100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102ec2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ec9:	e8 5c 0e 00 00       	call   c0103d2a <alloc_pages>
c0102ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102ed1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102ed5:	75 24                	jne    c0102efb <basic_check+0xc4>
c0102ed7:	c7 44 24 0c 3c 65 10 	movl   $0xc010653c,0xc(%esp)
c0102ede:	c0 
c0102edf:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102ee6:	c0 
c0102ee7:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0102eee:	00 
c0102eef:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102ef6:	e8 d1 dd ff ff       	call   c0100ccc <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102efe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f01:	74 10                	je     c0102f13 <basic_check+0xdc>
c0102f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f09:	74 08                	je     c0102f13 <basic_check+0xdc>
c0102f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f11:	75 24                	jne    c0102f37 <basic_check+0x100>
c0102f13:	c7 44 24 0c 58 65 10 	movl   $0xc0106558,0xc(%esp)
c0102f1a:	c0 
c0102f1b:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102f22:	c0 
c0102f23:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0102f2a:	00 
c0102f2b:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102f32:	e8 95 dd ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f3a:	89 04 24             	mov    %eax,(%esp)
c0102f3d:	e8 8d f9 ff ff       	call   c01028cf <page_ref>
c0102f42:	85 c0                	test   %eax,%eax
c0102f44:	75 1e                	jne    c0102f64 <basic_check+0x12d>
c0102f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f49:	89 04 24             	mov    %eax,(%esp)
c0102f4c:	e8 7e f9 ff ff       	call   c01028cf <page_ref>
c0102f51:	85 c0                	test   %eax,%eax
c0102f53:	75 0f                	jne    c0102f64 <basic_check+0x12d>
c0102f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f58:	89 04 24             	mov    %eax,(%esp)
c0102f5b:	e8 6f f9 ff ff       	call   c01028cf <page_ref>
c0102f60:	85 c0                	test   %eax,%eax
c0102f62:	74 24                	je     c0102f88 <basic_check+0x151>
c0102f64:	c7 44 24 0c 7c 65 10 	movl   $0xc010657c,0xc(%esp)
c0102f6b:	c0 
c0102f6c:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102f73:	c0 
c0102f74:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0102f7b:	00 
c0102f7c:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102f83:	e8 44 dd ff ff       	call   c0100ccc <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f8b:	89 04 24             	mov    %eax,(%esp)
c0102f8e:	e8 26 f9 ff ff       	call   c01028b9 <page2pa>
c0102f93:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0102f99:	c1 e2 0c             	shl    $0xc,%edx
c0102f9c:	39 d0                	cmp    %edx,%eax
c0102f9e:	72 24                	jb     c0102fc4 <basic_check+0x18d>
c0102fa0:	c7 44 24 0c b8 65 10 	movl   $0xc01065b8,0xc(%esp)
c0102fa7:	c0 
c0102fa8:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102faf:	c0 
c0102fb0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0102fb7:	00 
c0102fb8:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102fbf:	e8 08 dd ff ff       	call   c0100ccc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fc7:	89 04 24             	mov    %eax,(%esp)
c0102fca:	e8 ea f8 ff ff       	call   c01028b9 <page2pa>
c0102fcf:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0102fd5:	c1 e2 0c             	shl    $0xc,%edx
c0102fd8:	39 d0                	cmp    %edx,%eax
c0102fda:	72 24                	jb     c0103000 <basic_check+0x1c9>
c0102fdc:	c7 44 24 0c d5 65 10 	movl   $0xc01065d5,0xc(%esp)
c0102fe3:	c0 
c0102fe4:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0102feb:	c0 
c0102fec:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102ff3:	00 
c0102ff4:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0102ffb:	e8 cc dc ff ff       	call   c0100ccc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103000:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103003:	89 04 24             	mov    %eax,(%esp)
c0103006:	e8 ae f8 ff ff       	call   c01028b9 <page2pa>
c010300b:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103011:	c1 e2 0c             	shl    $0xc,%edx
c0103014:	39 d0                	cmp    %edx,%eax
c0103016:	72 24                	jb     c010303c <basic_check+0x205>
c0103018:	c7 44 24 0c f2 65 10 	movl   $0xc01065f2,0xc(%esp)
c010301f:	c0 
c0103020:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103027:	c0 
c0103028:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010302f:	00 
c0103030:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103037:	e8 90 dc ff ff       	call   c0100ccc <__panic>

    list_entry_t free_list_store = free_list;
c010303c:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c0103041:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c0103047:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010304a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010304d:	c7 45 e0 10 af 11 c0 	movl   $0xc011af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103054:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103057:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010305a:	89 50 04             	mov    %edx,0x4(%eax)
c010305d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103060:	8b 50 04             	mov    0x4(%eax),%edx
c0103063:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103066:	89 10                	mov    %edx,(%eax)
c0103068:	c7 45 dc 10 af 11 c0 	movl   $0xc011af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010306f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103072:	8b 40 04             	mov    0x4(%eax),%eax
c0103075:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103078:	0f 94 c0             	sete   %al
c010307b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010307e:	85 c0                	test   %eax,%eax
c0103080:	75 24                	jne    c01030a6 <basic_check+0x26f>
c0103082:	c7 44 24 0c 0f 66 10 	movl   $0xc010660f,0xc(%esp)
c0103089:	c0 
c010308a:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103091:	c0 
c0103092:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0103099:	00 
c010309a:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01030a1:	e8 26 dc ff ff       	call   c0100ccc <__panic>

    unsigned int nr_free_store = nr_free;
c01030a6:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01030ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030ae:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c01030b5:	00 00 00 

    assert(alloc_page() == NULL);
c01030b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030bf:	e8 66 0c 00 00       	call   c0103d2a <alloc_pages>
c01030c4:	85 c0                	test   %eax,%eax
c01030c6:	74 24                	je     c01030ec <basic_check+0x2b5>
c01030c8:	c7 44 24 0c 26 66 10 	movl   $0xc0106626,0xc(%esp)
c01030cf:	c0 
c01030d0:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01030d7:	c0 
c01030d8:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c01030df:	00 
c01030e0:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01030e7:	e8 e0 db ff ff       	call   c0100ccc <__panic>

    free_page(p0);
c01030ec:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030f3:	00 
c01030f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030f7:	89 04 24             	mov    %eax,(%esp)
c01030fa:	e8 63 0c 00 00       	call   c0103d62 <free_pages>
    free_page(p1);
c01030ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103106:	00 
c0103107:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010310a:	89 04 24             	mov    %eax,(%esp)
c010310d:	e8 50 0c 00 00       	call   c0103d62 <free_pages>
    free_page(p2);
c0103112:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103119:	00 
c010311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010311d:	89 04 24             	mov    %eax,(%esp)
c0103120:	e8 3d 0c 00 00       	call   c0103d62 <free_pages>
    assert(nr_free == 3);
c0103125:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c010312a:	83 f8 03             	cmp    $0x3,%eax
c010312d:	74 24                	je     c0103153 <basic_check+0x31c>
c010312f:	c7 44 24 0c 3b 66 10 	movl   $0xc010663b,0xc(%esp)
c0103136:	c0 
c0103137:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010313e:	c0 
c010313f:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103146:	00 
c0103147:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010314e:	e8 79 db ff ff       	call   c0100ccc <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103153:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010315a:	e8 cb 0b 00 00       	call   c0103d2a <alloc_pages>
c010315f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103162:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103166:	75 24                	jne    c010318c <basic_check+0x355>
c0103168:	c7 44 24 0c 04 65 10 	movl   $0xc0106504,0xc(%esp)
c010316f:	c0 
c0103170:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103177:	c0 
c0103178:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c010317f:	00 
c0103180:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103187:	e8 40 db ff ff       	call   c0100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
c010318c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103193:	e8 92 0b 00 00       	call   c0103d2a <alloc_pages>
c0103198:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010319b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010319f:	75 24                	jne    c01031c5 <basic_check+0x38e>
c01031a1:	c7 44 24 0c 20 65 10 	movl   $0xc0106520,0xc(%esp)
c01031a8:	c0 
c01031a9:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01031b0:	c0 
c01031b1:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01031b8:	00 
c01031b9:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01031c0:	e8 07 db ff ff       	call   c0100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031cc:	e8 59 0b 00 00       	call   c0103d2a <alloc_pages>
c01031d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031d8:	75 24                	jne    c01031fe <basic_check+0x3c7>
c01031da:	c7 44 24 0c 3c 65 10 	movl   $0xc010653c,0xc(%esp)
c01031e1:	c0 
c01031e2:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01031e9:	c0 
c01031ea:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c01031f1:	00 
c01031f2:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01031f9:	e8 ce da ff ff       	call   c0100ccc <__panic>

    assert(alloc_page() == NULL);
c01031fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103205:	e8 20 0b 00 00       	call   c0103d2a <alloc_pages>
c010320a:	85 c0                	test   %eax,%eax
c010320c:	74 24                	je     c0103232 <basic_check+0x3fb>
c010320e:	c7 44 24 0c 26 66 10 	movl   $0xc0106626,0xc(%esp)
c0103215:	c0 
c0103216:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010321d:	c0 
c010321e:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103225:	00 
c0103226:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010322d:	e8 9a da ff ff       	call   c0100ccc <__panic>

    free_page(p0);
c0103232:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103239:	00 
c010323a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010323d:	89 04 24             	mov    %eax,(%esp)
c0103240:	e8 1d 0b 00 00       	call   c0103d62 <free_pages>
c0103245:	c7 45 d8 10 af 11 c0 	movl   $0xc011af10,-0x28(%ebp)
c010324c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010324f:	8b 40 04             	mov    0x4(%eax),%eax
c0103252:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103255:	0f 94 c0             	sete   %al
c0103258:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c010325b:	85 c0                	test   %eax,%eax
c010325d:	74 24                	je     c0103283 <basic_check+0x44c>
c010325f:	c7 44 24 0c 48 66 10 	movl   $0xc0106648,0xc(%esp)
c0103266:	c0 
c0103267:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010326e:	c0 
c010326f:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103276:	00 
c0103277:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010327e:	e8 49 da ff ff       	call   c0100ccc <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103283:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010328a:	e8 9b 0a 00 00       	call   c0103d2a <alloc_pages>
c010328f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103295:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103298:	74 24                	je     c01032be <basic_check+0x487>
c010329a:	c7 44 24 0c 60 66 10 	movl   $0xc0106660,0xc(%esp)
c01032a1:	c0 
c01032a2:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01032a9:	c0 
c01032aa:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c01032b1:	00 
c01032b2:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01032b9:	e8 0e da ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c01032be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032c5:	e8 60 0a 00 00       	call   c0103d2a <alloc_pages>
c01032ca:	85 c0                	test   %eax,%eax
c01032cc:	74 24                	je     c01032f2 <basic_check+0x4bb>
c01032ce:	c7 44 24 0c 26 66 10 	movl   $0xc0106626,0xc(%esp)
c01032d5:	c0 
c01032d6:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01032dd:	c0 
c01032de:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01032e5:	00 
c01032e6:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01032ed:	e8 da d9 ff ff       	call   c0100ccc <__panic>

    assert(nr_free == 0);
c01032f2:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01032f7:	85 c0                	test   %eax,%eax
c01032f9:	74 24                	je     c010331f <basic_check+0x4e8>
c01032fb:	c7 44 24 0c 79 66 10 	movl   $0xc0106679,0xc(%esp)
c0103302:	c0 
c0103303:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010330a:	c0 
c010330b:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103312:	00 
c0103313:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010331a:	e8 ad d9 ff ff       	call   c0100ccc <__panic>
    free_list = free_list_store;
c010331f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103322:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103325:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c010332a:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    nr_free = nr_free_store;
c0103330:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103333:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_page(p);
c0103338:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010333f:	00 
c0103340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103343:	89 04 24             	mov    %eax,(%esp)
c0103346:	e8 17 0a 00 00       	call   c0103d62 <free_pages>
    free_page(p1);
c010334b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103352:	00 
c0103353:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103356:	89 04 24             	mov    %eax,(%esp)
c0103359:	e8 04 0a 00 00       	call   c0103d62 <free_pages>
    free_page(p2);
c010335e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103365:	00 
c0103366:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103369:	89 04 24             	mov    %eax,(%esp)
c010336c:	e8 f1 09 00 00       	call   c0103d62 <free_pages>
}
c0103371:	c9                   	leave  
c0103372:	c3                   	ret    

c0103373 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103373:	55                   	push   %ebp
c0103374:	89 e5                	mov    %esp,%ebp
c0103376:	53                   	push   %ebx
c0103377:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c010337d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103384:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010338b:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103392:	eb 6b                	jmp    c01033ff <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103394:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103397:	83 e8 0c             	sub    $0xc,%eax
c010339a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033a0:	83 c0 04             	add    $0x4,%eax
c01033a3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01033aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033b0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033b3:	0f a3 10             	bt     %edx,(%eax)
c01033b6:	19 c0                	sbb    %eax,%eax
c01033b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01033bb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01033bf:	0f 95 c0             	setne  %al
c01033c2:	0f b6 c0             	movzbl %al,%eax
c01033c5:	85 c0                	test   %eax,%eax
c01033c7:	75 24                	jne    c01033ed <default_check+0x7a>
c01033c9:	c7 44 24 0c 86 66 10 	movl   $0xc0106686,0xc(%esp)
c01033d0:	c0 
c01033d1:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01033d8:	c0 
c01033d9:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01033e0:	00 
c01033e1:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01033e8:	e8 df d8 ff ff       	call   c0100ccc <__panic>
        count ++, total += p->property;
c01033ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033f4:	8b 50 08             	mov    0x8(%eax),%edx
c01033f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033fa:	01 d0                	add    %edx,%eax
c01033fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103402:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103405:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103408:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010340b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010340e:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c0103415:	0f 85 79 ff ff ff    	jne    c0103394 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010341b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010341e:	e8 71 09 00 00       	call   c0103d94 <nr_free_pages>
c0103423:	39 c3                	cmp    %eax,%ebx
c0103425:	74 24                	je     c010344b <default_check+0xd8>
c0103427:	c7 44 24 0c 96 66 10 	movl   $0xc0106696,0xc(%esp)
c010342e:	c0 
c010342f:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103436:	c0 
c0103437:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c010343e:	00 
c010343f:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103446:	e8 81 d8 ff ff       	call   c0100ccc <__panic>

    basic_check();
c010344b:	e8 e7 f9 ff ff       	call   c0102e37 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103450:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103457:	e8 ce 08 00 00       	call   c0103d2a <alloc_pages>
c010345c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010345f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103463:	75 24                	jne    c0103489 <default_check+0x116>
c0103465:	c7 44 24 0c af 66 10 	movl   $0xc01066af,0xc(%esp)
c010346c:	c0 
c010346d:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103474:	c0 
c0103475:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c010347c:	00 
c010347d:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103484:	e8 43 d8 ff ff       	call   c0100ccc <__panic>
    assert(!PageProperty(p0));
c0103489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010348c:	83 c0 04             	add    $0x4,%eax
c010348f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103496:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103499:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010349c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010349f:	0f a3 10             	bt     %edx,(%eax)
c01034a2:	19 c0                	sbb    %eax,%eax
c01034a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01034a7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01034ab:	0f 95 c0             	setne  %al
c01034ae:	0f b6 c0             	movzbl %al,%eax
c01034b1:	85 c0                	test   %eax,%eax
c01034b3:	74 24                	je     c01034d9 <default_check+0x166>
c01034b5:	c7 44 24 0c ba 66 10 	movl   $0xc01066ba,0xc(%esp)
c01034bc:	c0 
c01034bd:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01034c4:	c0 
c01034c5:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c01034cc:	00 
c01034cd:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01034d4:	e8 f3 d7 ff ff       	call   c0100ccc <__panic>

    list_entry_t free_list_store = free_list;
c01034d9:	a1 10 af 11 c0       	mov    0xc011af10,%eax
c01034de:	8b 15 14 af 11 c0    	mov    0xc011af14,%edx
c01034e4:	89 45 80             	mov    %eax,-0x80(%ebp)
c01034e7:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01034ea:	c7 45 b4 10 af 11 c0 	movl   $0xc011af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034f4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01034f7:	89 50 04             	mov    %edx,0x4(%eax)
c01034fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034fd:	8b 50 04             	mov    0x4(%eax),%edx
c0103500:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103503:	89 10                	mov    %edx,(%eax)
c0103505:	c7 45 b0 10 af 11 c0 	movl   $0xc011af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010350c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010350f:	8b 40 04             	mov    0x4(%eax),%eax
c0103512:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103515:	0f 94 c0             	sete   %al
c0103518:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010351b:	85 c0                	test   %eax,%eax
c010351d:	75 24                	jne    c0103543 <default_check+0x1d0>
c010351f:	c7 44 24 0c 0f 66 10 	movl   $0xc010660f,0xc(%esp)
c0103526:	c0 
c0103527:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010352e:	c0 
c010352f:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103536:	00 
c0103537:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010353e:	e8 89 d7 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c0103543:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010354a:	e8 db 07 00 00       	call   c0103d2a <alloc_pages>
c010354f:	85 c0                	test   %eax,%eax
c0103551:	74 24                	je     c0103577 <default_check+0x204>
c0103553:	c7 44 24 0c 26 66 10 	movl   $0xc0106626,0xc(%esp)
c010355a:	c0 
c010355b:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103562:	c0 
c0103563:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c010356a:	00 
c010356b:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103572:	e8 55 d7 ff ff       	call   c0100ccc <__panic>

    unsigned int nr_free_store = nr_free;
c0103577:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c010357c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010357f:	c7 05 18 af 11 c0 00 	movl   $0x0,0xc011af18
c0103586:	00 00 00 

    free_pages(p0 + 2, 3);
c0103589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010358c:	83 c0 28             	add    $0x28,%eax
c010358f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103596:	00 
c0103597:	89 04 24             	mov    %eax,(%esp)
c010359a:	e8 c3 07 00 00       	call   c0103d62 <free_pages>
    assert(alloc_pages(4) == NULL);
c010359f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01035a6:	e8 7f 07 00 00       	call   c0103d2a <alloc_pages>
c01035ab:	85 c0                	test   %eax,%eax
c01035ad:	74 24                	je     c01035d3 <default_check+0x260>
c01035af:	c7 44 24 0c cc 66 10 	movl   $0xc01066cc,0xc(%esp)
c01035b6:	c0 
c01035b7:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01035be:	c0 
c01035bf:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01035c6:	00 
c01035c7:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01035ce:	e8 f9 d6 ff ff       	call   c0100ccc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01035d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035d6:	83 c0 28             	add    $0x28,%eax
c01035d9:	83 c0 04             	add    $0x4,%eax
c01035dc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01035e3:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035e6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035e9:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035ec:	0f a3 10             	bt     %edx,(%eax)
c01035ef:	19 c0                	sbb    %eax,%eax
c01035f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01035f4:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01035f8:	0f 95 c0             	setne  %al
c01035fb:	0f b6 c0             	movzbl %al,%eax
c01035fe:	85 c0                	test   %eax,%eax
c0103600:	74 0e                	je     c0103610 <default_check+0x29d>
c0103602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103605:	83 c0 28             	add    $0x28,%eax
c0103608:	8b 40 08             	mov    0x8(%eax),%eax
c010360b:	83 f8 03             	cmp    $0x3,%eax
c010360e:	74 24                	je     c0103634 <default_check+0x2c1>
c0103610:	c7 44 24 0c e4 66 10 	movl   $0xc01066e4,0xc(%esp)
c0103617:	c0 
c0103618:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010361f:	c0 
c0103620:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c0103627:	00 
c0103628:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010362f:	e8 98 d6 ff ff       	call   c0100ccc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103634:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010363b:	e8 ea 06 00 00       	call   c0103d2a <alloc_pages>
c0103640:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103643:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103647:	75 24                	jne    c010366d <default_check+0x2fa>
c0103649:	c7 44 24 0c 10 67 10 	movl   $0xc0106710,0xc(%esp)
c0103650:	c0 
c0103651:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103658:	c0 
c0103659:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0103660:	00 
c0103661:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103668:	e8 5f d6 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c010366d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103674:	e8 b1 06 00 00       	call   c0103d2a <alloc_pages>
c0103679:	85 c0                	test   %eax,%eax
c010367b:	74 24                	je     c01036a1 <default_check+0x32e>
c010367d:	c7 44 24 0c 26 66 10 	movl   $0xc0106626,0xc(%esp)
c0103684:	c0 
c0103685:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010368c:	c0 
c010368d:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0103694:	00 
c0103695:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010369c:	e8 2b d6 ff ff       	call   c0100ccc <__panic>
    assert(p0 + 2 == p1);
c01036a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036a4:	83 c0 28             	add    $0x28,%eax
c01036a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01036aa:	74 24                	je     c01036d0 <default_check+0x35d>
c01036ac:	c7 44 24 0c 2e 67 10 	movl   $0xc010672e,0xc(%esp)
c01036b3:	c0 
c01036b4:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01036bb:	c0 
c01036bc:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c01036c3:	00 
c01036c4:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01036cb:	e8 fc d5 ff ff       	call   c0100ccc <__panic>

    p2 = p0 + 1;
c01036d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036d3:	83 c0 14             	add    $0x14,%eax
c01036d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01036d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036e0:	00 
c01036e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036e4:	89 04 24             	mov    %eax,(%esp)
c01036e7:	e8 76 06 00 00       	call   c0103d62 <free_pages>
    free_pages(p1, 3);
c01036ec:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036f3:	00 
c01036f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036f7:	89 04 24             	mov    %eax,(%esp)
c01036fa:	e8 63 06 00 00       	call   c0103d62 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01036ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103702:	83 c0 04             	add    $0x4,%eax
c0103705:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010370c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010370f:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103712:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103715:	0f a3 10             	bt     %edx,(%eax)
c0103718:	19 c0                	sbb    %eax,%eax
c010371a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010371d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103721:	0f 95 c0             	setne  %al
c0103724:	0f b6 c0             	movzbl %al,%eax
c0103727:	85 c0                	test   %eax,%eax
c0103729:	74 0b                	je     c0103736 <default_check+0x3c3>
c010372b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010372e:	8b 40 08             	mov    0x8(%eax),%eax
c0103731:	83 f8 01             	cmp    $0x1,%eax
c0103734:	74 24                	je     c010375a <default_check+0x3e7>
c0103736:	c7 44 24 0c 3c 67 10 	movl   $0xc010673c,0xc(%esp)
c010373d:	c0 
c010373e:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103745:	c0 
c0103746:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c010374d:	00 
c010374e:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103755:	e8 72 d5 ff ff       	call   c0100ccc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010375a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010375d:	83 c0 04             	add    $0x4,%eax
c0103760:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103767:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010376a:	8b 45 90             	mov    -0x70(%ebp),%eax
c010376d:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103770:	0f a3 10             	bt     %edx,(%eax)
c0103773:	19 c0                	sbb    %eax,%eax
c0103775:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103778:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010377c:	0f 95 c0             	setne  %al
c010377f:	0f b6 c0             	movzbl %al,%eax
c0103782:	85 c0                	test   %eax,%eax
c0103784:	74 0b                	je     c0103791 <default_check+0x41e>
c0103786:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103789:	8b 40 08             	mov    0x8(%eax),%eax
c010378c:	83 f8 03             	cmp    $0x3,%eax
c010378f:	74 24                	je     c01037b5 <default_check+0x442>
c0103791:	c7 44 24 0c 64 67 10 	movl   $0xc0106764,0xc(%esp)
c0103798:	c0 
c0103799:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01037a0:	c0 
c01037a1:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01037a8:	00 
c01037a9:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01037b0:	e8 17 d5 ff ff       	call   c0100ccc <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01037b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037bc:	e8 69 05 00 00       	call   c0103d2a <alloc_pages>
c01037c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037c7:	83 e8 14             	sub    $0x14,%eax
c01037ca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037cd:	74 24                	je     c01037f3 <default_check+0x480>
c01037cf:	c7 44 24 0c 8a 67 10 	movl   $0xc010678a,0xc(%esp)
c01037d6:	c0 
c01037d7:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01037de:	c0 
c01037df:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c01037e6:	00 
c01037e7:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01037ee:	e8 d9 d4 ff ff       	call   c0100ccc <__panic>
    free_page(p0);
c01037f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037fa:	00 
c01037fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037fe:	89 04 24             	mov    %eax,(%esp)
c0103801:	e8 5c 05 00 00       	call   c0103d62 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103806:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010380d:	e8 18 05 00 00       	call   c0103d2a <alloc_pages>
c0103812:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103815:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103818:	83 c0 14             	add    $0x14,%eax
c010381b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010381e:	74 24                	je     c0103844 <default_check+0x4d1>
c0103820:	c7 44 24 0c a8 67 10 	movl   $0xc01067a8,0xc(%esp)
c0103827:	c0 
c0103828:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010382f:	c0 
c0103830:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
c0103837:	00 
c0103838:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010383f:	e8 88 d4 ff ff       	call   c0100ccc <__panic>

    free_pages(p0, 2);
c0103844:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010384b:	00 
c010384c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010384f:	89 04 24             	mov    %eax,(%esp)
c0103852:	e8 0b 05 00 00       	call   c0103d62 <free_pages>
    free_page(p2);
c0103857:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010385e:	00 
c010385f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103862:	89 04 24             	mov    %eax,(%esp)
c0103865:	e8 f8 04 00 00       	call   c0103d62 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010386a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103871:	e8 b4 04 00 00       	call   c0103d2a <alloc_pages>
c0103876:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103879:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010387d:	75 24                	jne    c01038a3 <default_check+0x530>
c010387f:	c7 44 24 0c c8 67 10 	movl   $0xc01067c8,0xc(%esp)
c0103886:	c0 
c0103887:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c010388e:	c0 
c010388f:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0103896:	00 
c0103897:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c010389e:	e8 29 d4 ff ff       	call   c0100ccc <__panic>
    assert(alloc_page() == NULL);
c01038a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038aa:	e8 7b 04 00 00       	call   c0103d2a <alloc_pages>
c01038af:	85 c0                	test   %eax,%eax
c01038b1:	74 24                	je     c01038d7 <default_check+0x564>
c01038b3:	c7 44 24 0c 26 66 10 	movl   $0xc0106626,0xc(%esp)
c01038ba:	c0 
c01038bb:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01038c2:	c0 
c01038c3:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c01038ca:	00 
c01038cb:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01038d2:	e8 f5 d3 ff ff       	call   c0100ccc <__panic>

    assert(nr_free == 0);
c01038d7:	a1 18 af 11 c0       	mov    0xc011af18,%eax
c01038dc:	85 c0                	test   %eax,%eax
c01038de:	74 24                	je     c0103904 <default_check+0x591>
c01038e0:	c7 44 24 0c 79 66 10 	movl   $0xc0106679,0xc(%esp)
c01038e7:	c0 
c01038e8:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01038ef:	c0 
c01038f0:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c01038f7:	00 
c01038f8:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01038ff:	e8 c8 d3 ff ff       	call   c0100ccc <__panic>
    nr_free = nr_free_store;
c0103904:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103907:	a3 18 af 11 c0       	mov    %eax,0xc011af18

    free_list = free_list_store;
c010390c:	8b 45 80             	mov    -0x80(%ebp),%eax
c010390f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103912:	a3 10 af 11 c0       	mov    %eax,0xc011af10
c0103917:	89 15 14 af 11 c0    	mov    %edx,0xc011af14
    free_pages(p0, 5);
c010391d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103924:	00 
c0103925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103928:	89 04 24             	mov    %eax,(%esp)
c010392b:	e8 32 04 00 00       	call   c0103d62 <free_pages>

    le = &free_list;
c0103930:	c7 45 ec 10 af 11 c0 	movl   $0xc011af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103937:	eb 5b                	jmp    c0103994 <default_check+0x621>
        assert(le->next->prev == le && le->prev->next == le);
c0103939:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010393c:	8b 40 04             	mov    0x4(%eax),%eax
c010393f:	8b 00                	mov    (%eax),%eax
c0103941:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103944:	75 0d                	jne    c0103953 <default_check+0x5e0>
c0103946:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103949:	8b 00                	mov    (%eax),%eax
c010394b:	8b 40 04             	mov    0x4(%eax),%eax
c010394e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103951:	74 24                	je     c0103977 <default_check+0x604>
c0103953:	c7 44 24 0c e8 67 10 	movl   $0xc01067e8,0xc(%esp)
c010395a:	c0 
c010395b:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c0103962:	c0 
c0103963:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c010396a:	00 
c010396b:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0103972:	e8 55 d3 ff ff       	call   c0100ccc <__panic>
        struct Page *p = le2page(le, page_link);
c0103977:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010397a:	83 e8 0c             	sub    $0xc,%eax
c010397d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103980:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103984:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103987:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010398a:	8b 40 08             	mov    0x8(%eax),%eax
c010398d:	29 c2                	sub    %eax,%edx
c010398f:	89 d0                	mov    %edx,%eax
c0103991:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103994:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103997:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010399a:	8b 45 88             	mov    -0x78(%ebp),%eax
c010399d:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01039a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01039a3:	81 7d ec 10 af 11 c0 	cmpl   $0xc011af10,-0x14(%ebp)
c01039aa:	75 8d                	jne    c0103939 <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01039ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039b0:	74 24                	je     c01039d6 <default_check+0x663>
c01039b2:	c7 44 24 0c 15 68 10 	movl   $0xc0106815,0xc(%esp)
c01039b9:	c0 
c01039ba:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01039c1:	c0 
c01039c2:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c01039c9:	00 
c01039ca:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01039d1:	e8 f6 d2 ff ff       	call   c0100ccc <__panic>
    assert(total == 0);
c01039d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039da:	74 24                	je     c0103a00 <default_check+0x68d>
c01039dc:	c7 44 24 0c 20 68 10 	movl   $0xc0106820,0xc(%esp)
c01039e3:	c0 
c01039e4:	c7 44 24 08 b6 64 10 	movl   $0xc01064b6,0x8(%esp)
c01039eb:	c0 
c01039ec:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c01039f3:	00 
c01039f4:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c01039fb:	e8 cc d2 ff ff       	call   c0100ccc <__panic>
}
c0103a00:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103a06:	5b                   	pop    %ebx
c0103a07:	5d                   	pop    %ebp
c0103a08:	c3                   	ret    

c0103a09 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a09:	55                   	push   %ebp
c0103a0a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a0c:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a0f:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0103a14:	29 c2                	sub    %eax,%edx
c0103a16:	89 d0                	mov    %edx,%eax
c0103a18:	c1 f8 02             	sar    $0x2,%eax
c0103a1b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a21:	5d                   	pop    %ebp
c0103a22:	c3                   	ret    

c0103a23 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a23:	55                   	push   %ebp
c0103a24:	89 e5                	mov    %esp,%ebp
c0103a26:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a2c:	89 04 24             	mov    %eax,(%esp)
c0103a2f:	e8 d5 ff ff ff       	call   c0103a09 <page2ppn>
c0103a34:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a37:	c9                   	leave  
c0103a38:	c3                   	ret    

c0103a39 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a39:	55                   	push   %ebp
c0103a3a:	89 e5                	mov    %esp,%ebp
c0103a3c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a42:	c1 e8 0c             	shr    $0xc,%eax
c0103a45:	89 c2                	mov    %eax,%edx
c0103a47:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103a4c:	39 c2                	cmp    %eax,%edx
c0103a4e:	72 1c                	jb     c0103a6c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a50:	c7 44 24 08 5c 68 10 	movl   $0xc010685c,0x8(%esp)
c0103a57:	c0 
c0103a58:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a5f:	00 
c0103a60:	c7 04 24 7b 68 10 c0 	movl   $0xc010687b,(%esp)
c0103a67:	e8 60 d2 ff ff       	call   c0100ccc <__panic>
    }
    return &pages[PPN(pa)];
c0103a6c:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a75:	c1 e8 0c             	shr    $0xc,%eax
c0103a78:	89 c2                	mov    %eax,%edx
c0103a7a:	89 d0                	mov    %edx,%eax
c0103a7c:	c1 e0 02             	shl    $0x2,%eax
c0103a7f:	01 d0                	add    %edx,%eax
c0103a81:	c1 e0 02             	shl    $0x2,%eax
c0103a84:	01 c8                	add    %ecx,%eax
}
c0103a86:	c9                   	leave  
c0103a87:	c3                   	ret    

c0103a88 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a88:	55                   	push   %ebp
c0103a89:	89 e5                	mov    %esp,%ebp
c0103a8b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a91:	89 04 24             	mov    %eax,(%esp)
c0103a94:	e8 8a ff ff ff       	call   c0103a23 <page2pa>
c0103a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a9f:	c1 e8 0c             	shr    $0xc,%eax
c0103aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103aa5:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103aaa:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103aad:	72 23                	jb     c0103ad2 <page2kva+0x4a>
c0103aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ab2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ab6:	c7 44 24 08 8c 68 10 	movl   $0xc010688c,0x8(%esp)
c0103abd:	c0 
c0103abe:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103ac5:	00 
c0103ac6:	c7 04 24 7b 68 10 c0 	movl   $0xc010687b,(%esp)
c0103acd:	e8 fa d1 ff ff       	call   c0100ccc <__panic>
c0103ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ad5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103ada:	c9                   	leave  
c0103adb:	c3                   	ret    

c0103adc <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103adc:	55                   	push   %ebp
c0103add:	89 e5                	mov    %esp,%ebp
c0103adf:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae5:	83 e0 01             	and    $0x1,%eax
c0103ae8:	85 c0                	test   %eax,%eax
c0103aea:	75 1c                	jne    c0103b08 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103aec:	c7 44 24 08 b0 68 10 	movl   $0xc01068b0,0x8(%esp)
c0103af3:	c0 
c0103af4:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103afb:	00 
c0103afc:	c7 04 24 7b 68 10 c0 	movl   $0xc010687b,(%esp)
c0103b03:	e8 c4 d1 ff ff       	call   c0100ccc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b10:	89 04 24             	mov    %eax,(%esp)
c0103b13:	e8 21 ff ff ff       	call   c0103a39 <pa2page>
}
c0103b18:	c9                   	leave  
c0103b19:	c3                   	ret    

c0103b1a <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103b1a:	55                   	push   %ebp
c0103b1b:	89 e5                	mov    %esp,%ebp
c0103b1d:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b28:	89 04 24             	mov    %eax,(%esp)
c0103b2b:	e8 09 ff ff ff       	call   c0103a39 <pa2page>
}
c0103b30:	c9                   	leave  
c0103b31:	c3                   	ret    

c0103b32 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103b32:	55                   	push   %ebp
c0103b33:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b38:	8b 00                	mov    (%eax),%eax
}
c0103b3a:	5d                   	pop    %ebp
c0103b3b:	c3                   	ret    

c0103b3c <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0103b3c:	55                   	push   %ebp
c0103b3d:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b42:	8b 00                	mov    (%eax),%eax
c0103b44:	8d 50 01             	lea    0x1(%eax),%edx
c0103b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4a:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4f:	8b 00                	mov    (%eax),%eax
}
c0103b51:	5d                   	pop    %ebp
c0103b52:	c3                   	ret    

c0103b53 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b53:	55                   	push   %ebp
c0103b54:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b59:	8b 00                	mov    (%eax),%eax
c0103b5b:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b61:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b63:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b66:	8b 00                	mov    (%eax),%eax
}
c0103b68:	5d                   	pop    %ebp
c0103b69:	c3                   	ret    

c0103b6a <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b6a:	55                   	push   %ebp
c0103b6b:	89 e5                	mov    %esp,%ebp
c0103b6d:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b70:	9c                   	pushf  
c0103b71:	58                   	pop    %eax
c0103b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b78:	25 00 02 00 00       	and    $0x200,%eax
c0103b7d:	85 c0                	test   %eax,%eax
c0103b7f:	74 0c                	je     c0103b8d <__intr_save+0x23>
        intr_disable();
c0103b81:	e8 3a db ff ff       	call   c01016c0 <intr_disable>
        return 1;
c0103b86:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b8b:	eb 05                	jmp    c0103b92 <__intr_save+0x28>
    }
    return 0;
c0103b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b92:	c9                   	leave  
c0103b93:	c3                   	ret    

c0103b94 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b94:	55                   	push   %ebp
c0103b95:	89 e5                	mov    %esp,%ebp
c0103b97:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b9e:	74 05                	je     c0103ba5 <__intr_restore+0x11>
        intr_enable();
c0103ba0:	e8 15 db ff ff       	call   c01016ba <intr_enable>
    }
}
c0103ba5:	c9                   	leave  
c0103ba6:	c3                   	ret    

c0103ba7 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103ba7:	55                   	push   %ebp
c0103ba8:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bad:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103bb0:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bb5:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103bb7:	b8 23 00 00 00       	mov    $0x23,%eax
c0103bbc:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103bbe:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bc3:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103bc5:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bca:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103bcc:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bd1:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103bd3:	ea da 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103bda
}
c0103bda:	5d                   	pop    %ebp
c0103bdb:	c3                   	ret    

c0103bdc <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103bdc:	55                   	push   %ebp
c0103bdd:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103bdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103be2:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0103be7:	5d                   	pop    %ebp
c0103be8:	c3                   	ret    

c0103be9 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103be9:	55                   	push   %ebp
c0103bea:	89 e5                	mov    %esp,%ebp
c0103bec:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103bef:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103bf4:	89 04 24             	mov    %eax,(%esp)
c0103bf7:	e8 e0 ff ff ff       	call   c0103bdc <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103bfc:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0103c03:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103c05:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103c0c:	68 00 
c0103c0e:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103c13:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c19:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103c1e:	c1 e8 10             	shr    $0x10,%eax
c0103c21:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c26:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c2d:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c30:	83 c8 09             	or     $0x9,%eax
c0103c33:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c38:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c3f:	83 e0 ef             	and    $0xffffffef,%eax
c0103c42:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c47:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c4e:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c51:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c56:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c5d:	83 c8 80             	or     $0xffffff80,%eax
c0103c60:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c65:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c6c:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c6f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c74:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c7b:	83 e0 ef             	and    $0xffffffef,%eax
c0103c7e:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c83:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c8a:	83 e0 df             	and    $0xffffffdf,%eax
c0103c8d:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c92:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c99:	83 c8 40             	or     $0x40,%eax
c0103c9c:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ca1:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ca8:	83 e0 7f             	and    $0x7f,%eax
c0103cab:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103cb0:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103cb5:	c1 e8 18             	shr    $0x18,%eax
c0103cb8:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103cbd:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103cc4:	e8 de fe ff ff       	call   c0103ba7 <lgdt>
c0103cc9:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103ccf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103cd3:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103cd6:	c9                   	leave  
c0103cd7:	c3                   	ret    

c0103cd8 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103cd8:	55                   	push   %ebp
c0103cd9:	89 e5                	mov    %esp,%ebp
c0103cdb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103cde:	c7 05 1c af 11 c0 40 	movl   $0xc0106840,0xc011af1c
c0103ce5:	68 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103ce8:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103ced:	8b 00                	mov    (%eax),%eax
c0103cef:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103cf3:	c7 04 24 dc 68 10 c0 	movl   $0xc01068dc,(%esp)
c0103cfa:	e8 49 c6 ff ff       	call   c0100348 <cprintf>
    pmm_manager->init();
c0103cff:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d04:	8b 40 04             	mov    0x4(%eax),%eax
c0103d07:	ff d0                	call   *%eax
}
c0103d09:	c9                   	leave  
c0103d0a:	c3                   	ret    

c0103d0b <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103d0b:	55                   	push   %ebp
c0103d0c:	89 e5                	mov    %esp,%ebp
c0103d0e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103d11:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d16:	8b 40 08             	mov    0x8(%eax),%eax
c0103d19:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d1c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d20:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d23:	89 14 24             	mov    %edx,(%esp)
c0103d26:	ff d0                	call   *%eax
}
c0103d28:	c9                   	leave  
c0103d29:	c3                   	ret    

c0103d2a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d2a:	55                   	push   %ebp
c0103d2b:	89 e5                	mov    %esp,%ebp
c0103d2d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d37:	e8 2e fe ff ff       	call   c0103b6a <__intr_save>
c0103d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d3f:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d44:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d47:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d4a:	89 14 24             	mov    %edx,(%esp)
c0103d4d:	ff d0                	call   *%eax
c0103d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d55:	89 04 24             	mov    %eax,(%esp)
c0103d58:	e8 37 fe ff ff       	call   c0103b94 <__intr_restore>
    return page;
c0103d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d60:	c9                   	leave  
c0103d61:	c3                   	ret    

c0103d62 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d62:	55                   	push   %ebp
c0103d63:	89 e5                	mov    %esp,%ebp
c0103d65:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d68:	e8 fd fd ff ff       	call   c0103b6a <__intr_save>
c0103d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d70:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103d75:	8b 40 10             	mov    0x10(%eax),%eax
c0103d78:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d7b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d7f:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d82:	89 14 24             	mov    %edx,(%esp)
c0103d85:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d8a:	89 04 24             	mov    %eax,(%esp)
c0103d8d:	e8 02 fe ff ff       	call   c0103b94 <__intr_restore>
}
c0103d92:	c9                   	leave  
c0103d93:	c3                   	ret    

c0103d94 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d94:	55                   	push   %ebp
c0103d95:	89 e5                	mov    %esp,%ebp
c0103d97:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d9a:	e8 cb fd ff ff       	call   c0103b6a <__intr_save>
c0103d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103da2:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c0103da7:	8b 40 14             	mov    0x14(%eax),%eax
c0103daa:	ff d0                	call   *%eax
c0103dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103db2:	89 04 24             	mov    %eax,(%esp)
c0103db5:	e8 da fd ff ff       	call   c0103b94 <__intr_restore>
    return ret;
c0103dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103dbd:	c9                   	leave  
c0103dbe:	c3                   	ret    

c0103dbf <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103dbf:	55                   	push   %ebp
c0103dc0:	89 e5                	mov    %esp,%ebp
c0103dc2:	57                   	push   %edi
c0103dc3:	56                   	push   %esi
c0103dc4:	53                   	push   %ebx
c0103dc5:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103dcb:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103dd2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103dd9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103de0:	c7 04 24 f3 68 10 c0 	movl   $0xc01068f3,(%esp)
c0103de7:	e8 5c c5 ff ff       	call   c0100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103dec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103df3:	e9 15 01 00 00       	jmp    c0103f0d <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103df8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dfe:	89 d0                	mov    %edx,%eax
c0103e00:	c1 e0 02             	shl    $0x2,%eax
c0103e03:	01 d0                	add    %edx,%eax
c0103e05:	c1 e0 02             	shl    $0x2,%eax
c0103e08:	01 c8                	add    %ecx,%eax
c0103e0a:	8b 50 08             	mov    0x8(%eax),%edx
c0103e0d:	8b 40 04             	mov    0x4(%eax),%eax
c0103e10:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e13:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e16:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e19:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e1c:	89 d0                	mov    %edx,%eax
c0103e1e:	c1 e0 02             	shl    $0x2,%eax
c0103e21:	01 d0                	add    %edx,%eax
c0103e23:	c1 e0 02             	shl    $0x2,%eax
c0103e26:	01 c8                	add    %ecx,%eax
c0103e28:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e2b:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e2e:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e31:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e34:	01 c8                	add    %ecx,%eax
c0103e36:	11 da                	adc    %ebx,%edx
c0103e38:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e3b:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e3e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e41:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e44:	89 d0                	mov    %edx,%eax
c0103e46:	c1 e0 02             	shl    $0x2,%eax
c0103e49:	01 d0                	add    %edx,%eax
c0103e4b:	c1 e0 02             	shl    $0x2,%eax
c0103e4e:	01 c8                	add    %ecx,%eax
c0103e50:	83 c0 14             	add    $0x14,%eax
c0103e53:	8b 00                	mov    (%eax),%eax
c0103e55:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e5e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e61:	83 c0 ff             	add    $0xffffffff,%eax
c0103e64:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e67:	89 c6                	mov    %eax,%esi
c0103e69:	89 d7                	mov    %edx,%edi
c0103e6b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e71:	89 d0                	mov    %edx,%eax
c0103e73:	c1 e0 02             	shl    $0x2,%eax
c0103e76:	01 d0                	add    %edx,%eax
c0103e78:	c1 e0 02             	shl    $0x2,%eax
c0103e7b:	01 c8                	add    %ecx,%eax
c0103e7d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e80:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e83:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e89:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e8d:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e91:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e95:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e98:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e9f:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103ea3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103ea7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103eab:	c7 04 24 00 69 10 c0 	movl   $0xc0106900,(%esp)
c0103eb2:	e8 91 c4 ff ff       	call   c0100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103eb7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103eba:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ebd:	89 d0                	mov    %edx,%eax
c0103ebf:	c1 e0 02             	shl    $0x2,%eax
c0103ec2:	01 d0                	add    %edx,%eax
c0103ec4:	c1 e0 02             	shl    $0x2,%eax
c0103ec7:	01 c8                	add    %ecx,%eax
c0103ec9:	83 c0 14             	add    $0x14,%eax
c0103ecc:	8b 00                	mov    (%eax),%eax
c0103ece:	83 f8 01             	cmp    $0x1,%eax
c0103ed1:	75 36                	jne    c0103f09 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ed6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ed9:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103edc:	77 2b                	ja     c0103f09 <page_init+0x14a>
c0103ede:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ee1:	72 05                	jb     c0103ee8 <page_init+0x129>
c0103ee3:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103ee6:	73 21                	jae    c0103f09 <page_init+0x14a>
c0103ee8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103eec:	77 1b                	ja     c0103f09 <page_init+0x14a>
c0103eee:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103ef2:	72 09                	jb     c0103efd <page_init+0x13e>
c0103ef4:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103efb:	77 0c                	ja     c0103f09 <page_init+0x14a>
                maxpa = end;
c0103efd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f00:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f03:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103f06:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103f09:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f0d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f10:	8b 00                	mov    (%eax),%eax
c0103f12:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f15:	0f 8f dd fe ff ff    	jg     c0103df8 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f1f:	72 1d                	jb     c0103f3e <page_init+0x17f>
c0103f21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f25:	77 09                	ja     c0103f30 <page_init+0x171>
c0103f27:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f2e:	76 0e                	jbe    c0103f3e <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f30:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f44:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f48:	c1 ea 0c             	shr    $0xc,%edx
c0103f4b:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f50:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f57:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
c0103f5c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f5f:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f62:	01 d0                	add    %edx,%eax
c0103f64:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f67:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f6a:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f6f:	f7 75 ac             	divl   -0x54(%ebp)
c0103f72:	89 d0                	mov    %edx,%eax
c0103f74:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f77:	29 c2                	sub    %eax,%edx
c0103f79:	89 d0                	mov    %edx,%eax
c0103f7b:	a3 24 af 11 c0       	mov    %eax,0xc011af24

    for (i = 0; i < npage; i ++) {
c0103f80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f87:	eb 2f                	jmp    c0103fb8 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f89:	8b 0d 24 af 11 c0    	mov    0xc011af24,%ecx
c0103f8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f92:	89 d0                	mov    %edx,%eax
c0103f94:	c1 e0 02             	shl    $0x2,%eax
c0103f97:	01 d0                	add    %edx,%eax
c0103f99:	c1 e0 02             	shl    $0x2,%eax
c0103f9c:	01 c8                	add    %ecx,%eax
c0103f9e:	83 c0 04             	add    $0x4,%eax
c0103fa1:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103fa8:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103fab:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103fae:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103fb1:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103fb4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103fb8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fbb:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103fc0:	39 c2                	cmp    %eax,%edx
c0103fc2:	72 c5                	jb     c0103f89 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103fc4:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103fca:	89 d0                	mov    %edx,%eax
c0103fcc:	c1 e0 02             	shl    $0x2,%eax
c0103fcf:	01 d0                	add    %edx,%eax
c0103fd1:	c1 e0 02             	shl    $0x2,%eax
c0103fd4:	89 c2                	mov    %eax,%edx
c0103fd6:	a1 24 af 11 c0       	mov    0xc011af24,%eax
c0103fdb:	01 d0                	add    %edx,%eax
c0103fdd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103fe0:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103fe7:	77 23                	ja     c010400c <page_init+0x24d>
c0103fe9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fec:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ff0:	c7 44 24 08 30 69 10 	movl   $0xc0106930,0x8(%esp)
c0103ff7:	c0 
c0103ff8:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103fff:	00 
c0104000:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104007:	e8 c0 cc ff ff       	call   c0100ccc <__panic>
c010400c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010400f:	05 00 00 00 40       	add    $0x40000000,%eax
c0104014:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104017:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010401e:	e9 74 01 00 00       	jmp    c0104197 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104023:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104026:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104029:	89 d0                	mov    %edx,%eax
c010402b:	c1 e0 02             	shl    $0x2,%eax
c010402e:	01 d0                	add    %edx,%eax
c0104030:	c1 e0 02             	shl    $0x2,%eax
c0104033:	01 c8                	add    %ecx,%eax
c0104035:	8b 50 08             	mov    0x8(%eax),%edx
c0104038:	8b 40 04             	mov    0x4(%eax),%eax
c010403b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010403e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104041:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104044:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104047:	89 d0                	mov    %edx,%eax
c0104049:	c1 e0 02             	shl    $0x2,%eax
c010404c:	01 d0                	add    %edx,%eax
c010404e:	c1 e0 02             	shl    $0x2,%eax
c0104051:	01 c8                	add    %ecx,%eax
c0104053:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104056:	8b 58 10             	mov    0x10(%eax),%ebx
c0104059:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010405c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010405f:	01 c8                	add    %ecx,%eax
c0104061:	11 da                	adc    %ebx,%edx
c0104063:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104066:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104069:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010406c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010406f:	89 d0                	mov    %edx,%eax
c0104071:	c1 e0 02             	shl    $0x2,%eax
c0104074:	01 d0                	add    %edx,%eax
c0104076:	c1 e0 02             	shl    $0x2,%eax
c0104079:	01 c8                	add    %ecx,%eax
c010407b:	83 c0 14             	add    $0x14,%eax
c010407e:	8b 00                	mov    (%eax),%eax
c0104080:	83 f8 01             	cmp    $0x1,%eax
c0104083:	0f 85 0a 01 00 00    	jne    c0104193 <page_init+0x3d4>
            if (begin < freemem) {
c0104089:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010408c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104091:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104094:	72 17                	jb     c01040ad <page_init+0x2ee>
c0104096:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104099:	77 05                	ja     c01040a0 <page_init+0x2e1>
c010409b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010409e:	76 0d                	jbe    c01040ad <page_init+0x2ee>
                begin = freemem;
c01040a0:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01040a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01040ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040b1:	72 1d                	jb     c01040d0 <page_init+0x311>
c01040b3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040b7:	77 09                	ja     c01040c2 <page_init+0x303>
c01040b9:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01040c0:	76 0e                	jbe    c01040d0 <page_init+0x311>
                end = KMEMSIZE;
c01040c2:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01040c9:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01040d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040d6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040d9:	0f 87 b4 00 00 00    	ja     c0104193 <page_init+0x3d4>
c01040df:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040e2:	72 09                	jb     c01040ed <page_init+0x32e>
c01040e4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040e7:	0f 83 a6 00 00 00    	jae    c0104193 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01040ed:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01040f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01040f7:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040fa:	01 d0                	add    %edx,%eax
c01040fc:	83 e8 01             	sub    $0x1,%eax
c01040ff:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104102:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104105:	ba 00 00 00 00       	mov    $0x0,%edx
c010410a:	f7 75 9c             	divl   -0x64(%ebp)
c010410d:	89 d0                	mov    %edx,%eax
c010410f:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104112:	29 c2                	sub    %eax,%edx
c0104114:	89 d0                	mov    %edx,%eax
c0104116:	ba 00 00 00 00       	mov    $0x0,%edx
c010411b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010411e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104121:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104124:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104127:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010412a:	ba 00 00 00 00       	mov    $0x0,%edx
c010412f:	89 c7                	mov    %eax,%edi
c0104131:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104137:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010413a:	89 d0                	mov    %edx,%eax
c010413c:	83 e0 00             	and    $0x0,%eax
c010413f:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104142:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104145:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104148:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010414b:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010414e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104151:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104154:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104157:	77 3a                	ja     c0104193 <page_init+0x3d4>
c0104159:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010415c:	72 05                	jb     c0104163 <page_init+0x3a4>
c010415e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104161:	73 30                	jae    c0104193 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104163:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104166:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104169:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010416c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010416f:	29 c8                	sub    %ecx,%eax
c0104171:	19 da                	sbb    %ebx,%edx
c0104173:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104177:	c1 ea 0c             	shr    $0xc,%edx
c010417a:	89 c3                	mov    %eax,%ebx
c010417c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010417f:	89 04 24             	mov    %eax,(%esp)
c0104182:	e8 b2 f8 ff ff       	call   c0103a39 <pa2page>
c0104187:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010418b:	89 04 24             	mov    %eax,(%esp)
c010418e:	e8 78 fb ff ff       	call   c0103d0b <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104193:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104197:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010419a:	8b 00                	mov    (%eax),%eax
c010419c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010419f:	0f 8f 7e fe ff ff    	jg     c0104023 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01041a5:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01041ab:	5b                   	pop    %ebx
c01041ac:	5e                   	pop    %esi
c01041ad:	5f                   	pop    %edi
c01041ae:	5d                   	pop    %ebp
c01041af:	c3                   	ret    

c01041b0 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01041b0:	55                   	push   %ebp
c01041b1:	89 e5                	mov    %esp,%ebp
c01041b3:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01041b6:	8b 45 14             	mov    0x14(%ebp),%eax
c01041b9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041bc:	31 d0                	xor    %edx,%eax
c01041be:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041c3:	85 c0                	test   %eax,%eax
c01041c5:	74 24                	je     c01041eb <boot_map_segment+0x3b>
c01041c7:	c7 44 24 0c 62 69 10 	movl   $0xc0106962,0xc(%esp)
c01041ce:	c0 
c01041cf:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c01041d6:	c0 
c01041d7:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01041de:	00 
c01041df:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c01041e6:	e8 e1 ca ff ff       	call   c0100ccc <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01041eb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01041f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041f5:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041fa:	89 c2                	mov    %eax,%edx
c01041fc:	8b 45 10             	mov    0x10(%ebp),%eax
c01041ff:	01 c2                	add    %eax,%edx
c0104201:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104204:	01 d0                	add    %edx,%eax
c0104206:	83 e8 01             	sub    $0x1,%eax
c0104209:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010420c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010420f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104214:	f7 75 f0             	divl   -0x10(%ebp)
c0104217:	89 d0                	mov    %edx,%eax
c0104219:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010421c:	29 c2                	sub    %eax,%edx
c010421e:	89 d0                	mov    %edx,%eax
c0104220:	c1 e8 0c             	shr    $0xc,%eax
c0104223:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104226:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104229:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010422c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010422f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104234:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104237:	8b 45 14             	mov    0x14(%ebp),%eax
c010423a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010423d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104240:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104245:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104248:	eb 6b                	jmp    c01042b5 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c010424a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104251:	00 
c0104252:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104255:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104259:	8b 45 08             	mov    0x8(%ebp),%eax
c010425c:	89 04 24             	mov    %eax,(%esp)
c010425f:	e8 82 01 00 00       	call   c01043e6 <get_pte>
c0104264:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104267:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c010426b:	75 24                	jne    c0104291 <boot_map_segment+0xe1>
c010426d:	c7 44 24 0c 8e 69 10 	movl   $0xc010698e,0xc(%esp)
c0104274:	c0 
c0104275:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c010427c:	c0 
c010427d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104284:	00 
c0104285:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c010428c:	e8 3b ca ff ff       	call   c0100ccc <__panic>
        *ptep = pa | PTE_P | perm;
c0104291:	8b 45 18             	mov    0x18(%ebp),%eax
c0104294:	8b 55 14             	mov    0x14(%ebp),%edx
c0104297:	09 d0                	or     %edx,%eax
c0104299:	83 c8 01             	or     $0x1,%eax
c010429c:	89 c2                	mov    %eax,%edx
c010429e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042a1:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042a3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042a7:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01042ae:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01042b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042b9:	75 8f                	jne    c010424a <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01042bb:	c9                   	leave  
c01042bc:	c3                   	ret    

c01042bd <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01042bd:	55                   	push   %ebp
c01042be:	89 e5                	mov    %esp,%ebp
c01042c0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01042c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042ca:	e8 5b fa ff ff       	call   c0103d2a <alloc_pages>
c01042cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01042d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042d6:	75 1c                	jne    c01042f4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01042d8:	c7 44 24 08 9b 69 10 	movl   $0xc010699b,0x8(%esp)
c01042df:	c0 
c01042e0:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01042e7:	00 
c01042e8:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c01042ef:	e8 d8 c9 ff ff       	call   c0100ccc <__panic>
    }
    return page2kva(p);
c01042f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042f7:	89 04 24             	mov    %eax,(%esp)
c01042fa:	e8 89 f7 ff ff       	call   c0103a88 <page2kva>
}
c01042ff:	c9                   	leave  
c0104300:	c3                   	ret    

c0104301 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104301:	55                   	push   %ebp
c0104302:	89 e5                	mov    %esp,%ebp
c0104304:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c0104307:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010430c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010430f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104316:	77 23                	ja     c010433b <pmm_init+0x3a>
c0104318:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010431b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010431f:	c7 44 24 08 30 69 10 	movl   $0xc0106930,0x8(%esp)
c0104326:	c0 
c0104327:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010432e:	00 
c010432f:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104336:	e8 91 c9 ff ff       	call   c0100ccc <__panic>
c010433b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433e:	05 00 00 00 40       	add    $0x40000000,%eax
c0104343:	a3 20 af 11 c0       	mov    %eax,0xc011af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104348:	e8 8b f9 ff ff       	call   c0103cd8 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010434d:	e8 6d fa ff ff       	call   c0103dbf <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104352:	e8 4c 02 00 00       	call   c01045a3 <check_alloc_page>

    check_pgdir();
c0104357:	e8 65 02 00 00       	call   c01045c1 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c010435c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104361:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104367:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010436c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010436f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104376:	77 23                	ja     c010439b <pmm_init+0x9a>
c0104378:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010437b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010437f:	c7 44 24 08 30 69 10 	movl   $0xc0106930,0x8(%esp)
c0104386:	c0 
c0104387:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c010438e:	00 
c010438f:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104396:	e8 31 c9 ff ff       	call   c0100ccc <__panic>
c010439b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010439e:	05 00 00 00 40       	add    $0x40000000,%eax
c01043a3:	83 c8 03             	or     $0x3,%eax
c01043a6:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01043a8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01043ad:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01043b4:	00 
c01043b5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01043bc:	00 
c01043bd:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01043c4:	38 
c01043c5:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01043cc:	c0 
c01043cd:	89 04 24             	mov    %eax,(%esp)
c01043d0:	e8 db fd ff ff       	call   c01041b0 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01043d5:	e8 0f f8 ff ff       	call   c0103be9 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01043da:	e8 7d 08 00 00       	call   c0104c5c <check_boot_pgdir>

    print_pgdir();
c01043df:	e8 05 0d 00 00       	call   c01050e9 <print_pgdir>

}
c01043e4:	c9                   	leave  
c01043e5:	c3                   	ret    

c01043e6 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01043e6:	55                   	push   %ebp
c01043e7:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01043e9:	5d                   	pop    %ebp
c01043ea:	c3                   	ret    

c01043eb <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01043eb:	55                   	push   %ebp
c01043ec:	89 e5                	mov    %esp,%ebp
c01043ee:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01043f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01043f8:	00 
c01043f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104400:	8b 45 08             	mov    0x8(%ebp),%eax
c0104403:	89 04 24             	mov    %eax,(%esp)
c0104406:	e8 db ff ff ff       	call   c01043e6 <get_pte>
c010440b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010440e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104412:	74 08                	je     c010441c <get_page+0x31>
        *ptep_store = ptep;
c0104414:	8b 45 10             	mov    0x10(%ebp),%eax
c0104417:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010441a:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010441c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104420:	74 1b                	je     c010443d <get_page+0x52>
c0104422:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104425:	8b 00                	mov    (%eax),%eax
c0104427:	83 e0 01             	and    $0x1,%eax
c010442a:	85 c0                	test   %eax,%eax
c010442c:	74 0f                	je     c010443d <get_page+0x52>
        return pte2page(*ptep);
c010442e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104431:	8b 00                	mov    (%eax),%eax
c0104433:	89 04 24             	mov    %eax,(%esp)
c0104436:	e8 a1 f6 ff ff       	call   c0103adc <pte2page>
c010443b:	eb 05                	jmp    c0104442 <get_page+0x57>
    }
    return NULL;
c010443d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104442:	c9                   	leave  
c0104443:	c3                   	ret    

c0104444 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104444:	55                   	push   %ebp
c0104445:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c0104447:	5d                   	pop    %ebp
c0104448:	c3                   	ret    

c0104449 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104449:	55                   	push   %ebp
c010444a:	89 e5                	mov    %esp,%ebp
c010444c:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010444f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104456:	00 
c0104457:	8b 45 0c             	mov    0xc(%ebp),%eax
c010445a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010445e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104461:	89 04 24             	mov    %eax,(%esp)
c0104464:	e8 7d ff ff ff       	call   c01043e6 <get_pte>
c0104469:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c010446c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104470:	74 19                	je     c010448b <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104472:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104475:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104479:	8b 45 0c             	mov    0xc(%ebp),%eax
c010447c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104480:	8b 45 08             	mov    0x8(%ebp),%eax
c0104483:	89 04 24             	mov    %eax,(%esp)
c0104486:	e8 b9 ff ff ff       	call   c0104444 <page_remove_pte>
    }
}
c010448b:	c9                   	leave  
c010448c:	c3                   	ret    

c010448d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010448d:	55                   	push   %ebp
c010448e:	89 e5                	mov    %esp,%ebp
c0104490:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104493:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010449a:	00 
c010449b:	8b 45 10             	mov    0x10(%ebp),%eax
c010449e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a5:	89 04 24             	mov    %eax,(%esp)
c01044a8:	e8 39 ff ff ff       	call   c01043e6 <get_pte>
c01044ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01044b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044b4:	75 0a                	jne    c01044c0 <page_insert+0x33>
        return -E_NO_MEM;
c01044b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01044bb:	e9 84 00 00 00       	jmp    c0104544 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01044c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044c3:	89 04 24             	mov    %eax,(%esp)
c01044c6:	e8 71 f6 ff ff       	call   c0103b3c <page_ref_inc>
    if (*ptep & PTE_P) {
c01044cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ce:	8b 00                	mov    (%eax),%eax
c01044d0:	83 e0 01             	and    $0x1,%eax
c01044d3:	85 c0                	test   %eax,%eax
c01044d5:	74 3e                	je     c0104515 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044da:	8b 00                	mov    (%eax),%eax
c01044dc:	89 04 24             	mov    %eax,(%esp)
c01044df:	e8 f8 f5 ff ff       	call   c0103adc <pte2page>
c01044e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01044e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01044ed:	75 0d                	jne    c01044fc <page_insert+0x6f>
            page_ref_dec(page);
c01044ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044f2:	89 04 24             	mov    %eax,(%esp)
c01044f5:	e8 59 f6 ff ff       	call   c0103b53 <page_ref_dec>
c01044fa:	eb 19                	jmp    c0104515 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01044fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104503:	8b 45 10             	mov    0x10(%ebp),%eax
c0104506:	89 44 24 04          	mov    %eax,0x4(%esp)
c010450a:	8b 45 08             	mov    0x8(%ebp),%eax
c010450d:	89 04 24             	mov    %eax,(%esp)
c0104510:	e8 2f ff ff ff       	call   c0104444 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104515:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104518:	89 04 24             	mov    %eax,(%esp)
c010451b:	e8 03 f5 ff ff       	call   c0103a23 <page2pa>
c0104520:	0b 45 14             	or     0x14(%ebp),%eax
c0104523:	83 c8 01             	or     $0x1,%eax
c0104526:	89 c2                	mov    %eax,%edx
c0104528:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010452d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104530:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104534:	8b 45 08             	mov    0x8(%ebp),%eax
c0104537:	89 04 24             	mov    %eax,(%esp)
c010453a:	e8 07 00 00 00       	call   c0104546 <tlb_invalidate>
    return 0;
c010453f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104544:	c9                   	leave  
c0104545:	c3                   	ret    

c0104546 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104546:	55                   	push   %ebp
c0104547:	89 e5                	mov    %esp,%ebp
c0104549:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010454c:	0f 20 d8             	mov    %cr3,%eax
c010454f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104552:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104555:	89 c2                	mov    %eax,%edx
c0104557:	8b 45 08             	mov    0x8(%ebp),%eax
c010455a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010455d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104564:	77 23                	ja     c0104589 <tlb_invalidate+0x43>
c0104566:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104569:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010456d:	c7 44 24 08 30 69 10 	movl   $0xc0106930,0x8(%esp)
c0104574:	c0 
c0104575:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c010457c:	00 
c010457d:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104584:	e8 43 c7 ff ff       	call   c0100ccc <__panic>
c0104589:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010458c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104591:	39 c2                	cmp    %eax,%edx
c0104593:	75 0c                	jne    c01045a1 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104595:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104598:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010459b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010459e:	0f 01 38             	invlpg (%eax)
    }
}
c01045a1:	c9                   	leave  
c01045a2:	c3                   	ret    

c01045a3 <check_alloc_page>:

static void
check_alloc_page(void) {
c01045a3:	55                   	push   %ebp
c01045a4:	89 e5                	mov    %esp,%ebp
c01045a6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01045a9:	a1 1c af 11 c0       	mov    0xc011af1c,%eax
c01045ae:	8b 40 18             	mov    0x18(%eax),%eax
c01045b1:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01045b3:	c7 04 24 b4 69 10 c0 	movl   $0xc01069b4,(%esp)
c01045ba:	e8 89 bd ff ff       	call   c0100348 <cprintf>
}
c01045bf:	c9                   	leave  
c01045c0:	c3                   	ret    

c01045c1 <check_pgdir>:

static void
check_pgdir(void) {
c01045c1:	55                   	push   %ebp
c01045c2:	89 e5                	mov    %esp,%ebp
c01045c4:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01045c7:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01045cc:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01045d1:	76 24                	jbe    c01045f7 <check_pgdir+0x36>
c01045d3:	c7 44 24 0c d3 69 10 	movl   $0xc01069d3,0xc(%esp)
c01045da:	c0 
c01045db:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c01045e2:	c0 
c01045e3:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c01045ea:	00 
c01045eb:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c01045f2:	e8 d5 c6 ff ff       	call   c0100ccc <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01045f7:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01045fc:	85 c0                	test   %eax,%eax
c01045fe:	74 0e                	je     c010460e <check_pgdir+0x4d>
c0104600:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104605:	25 ff 0f 00 00       	and    $0xfff,%eax
c010460a:	85 c0                	test   %eax,%eax
c010460c:	74 24                	je     c0104632 <check_pgdir+0x71>
c010460e:	c7 44 24 0c f0 69 10 	movl   $0xc01069f0,0xc(%esp)
c0104615:	c0 
c0104616:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c010461d:	c0 
c010461e:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c0104625:	00 
c0104626:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c010462d:	e8 9a c6 ff ff       	call   c0100ccc <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104632:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104637:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010463e:	00 
c010463f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104646:	00 
c0104647:	89 04 24             	mov    %eax,(%esp)
c010464a:	e8 9c fd ff ff       	call   c01043eb <get_page>
c010464f:	85 c0                	test   %eax,%eax
c0104651:	74 24                	je     c0104677 <check_pgdir+0xb6>
c0104653:	c7 44 24 0c 28 6a 10 	movl   $0xc0106a28,0xc(%esp)
c010465a:	c0 
c010465b:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104662:	c0 
c0104663:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c010466a:	00 
c010466b:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104672:	e8 55 c6 ff ff       	call   c0100ccc <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104677:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010467e:	e8 a7 f6 ff ff       	call   c0103d2a <alloc_pages>
c0104683:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104686:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010468b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104692:	00 
c0104693:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010469a:	00 
c010469b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010469e:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046a2:	89 04 24             	mov    %eax,(%esp)
c01046a5:	e8 e3 fd ff ff       	call   c010448d <page_insert>
c01046aa:	85 c0                	test   %eax,%eax
c01046ac:	74 24                	je     c01046d2 <check_pgdir+0x111>
c01046ae:	c7 44 24 0c 50 6a 10 	movl   $0xc0106a50,0xc(%esp)
c01046b5:	c0 
c01046b6:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c01046bd:	c0 
c01046be:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c01046c5:	00 
c01046c6:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c01046cd:	e8 fa c5 ff ff       	call   c0100ccc <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01046d2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01046d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01046de:	00 
c01046df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01046e6:	00 
c01046e7:	89 04 24             	mov    %eax,(%esp)
c01046ea:	e8 f7 fc ff ff       	call   c01043e6 <get_pte>
c01046ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01046f6:	75 24                	jne    c010471c <check_pgdir+0x15b>
c01046f8:	c7 44 24 0c 7c 6a 10 	movl   $0xc0106a7c,0xc(%esp)
c01046ff:	c0 
c0104700:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104707:	c0 
c0104708:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c010470f:	00 
c0104710:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104717:	e8 b0 c5 ff ff       	call   c0100ccc <__panic>
    assert(pte2page(*ptep) == p1);
c010471c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010471f:	8b 00                	mov    (%eax),%eax
c0104721:	89 04 24             	mov    %eax,(%esp)
c0104724:	e8 b3 f3 ff ff       	call   c0103adc <pte2page>
c0104729:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010472c:	74 24                	je     c0104752 <check_pgdir+0x191>
c010472e:	c7 44 24 0c a9 6a 10 	movl   $0xc0106aa9,0xc(%esp)
c0104735:	c0 
c0104736:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c010473d:	c0 
c010473e:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c0104745:	00 
c0104746:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c010474d:	e8 7a c5 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p1) == 1);
c0104752:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104755:	89 04 24             	mov    %eax,(%esp)
c0104758:	e8 d5 f3 ff ff       	call   c0103b32 <page_ref>
c010475d:	83 f8 01             	cmp    $0x1,%eax
c0104760:	74 24                	je     c0104786 <check_pgdir+0x1c5>
c0104762:	c7 44 24 0c bf 6a 10 	movl   $0xc0106abf,0xc(%esp)
c0104769:	c0 
c010476a:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104771:	c0 
c0104772:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c0104779:	00 
c010477a:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104781:	e8 46 c5 ff ff       	call   c0100ccc <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104786:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010478b:	8b 00                	mov    (%eax),%eax
c010478d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104792:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104795:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104798:	c1 e8 0c             	shr    $0xc,%eax
c010479b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010479e:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01047a3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01047a6:	72 23                	jb     c01047cb <check_pgdir+0x20a>
c01047a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047af:	c7 44 24 08 8c 68 10 	movl   $0xc010688c,0x8(%esp)
c01047b6:	c0 
c01047b7:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c01047be:	00 
c01047bf:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c01047c6:	e8 01 c5 ff ff       	call   c0100ccc <__panic>
c01047cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047ce:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01047d3:	83 c0 04             	add    $0x4,%eax
c01047d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01047d9:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01047de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047e5:	00 
c01047e6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01047ed:	00 
c01047ee:	89 04 24             	mov    %eax,(%esp)
c01047f1:	e8 f0 fb ff ff       	call   c01043e6 <get_pte>
c01047f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01047f9:	74 24                	je     c010481f <check_pgdir+0x25e>
c01047fb:	c7 44 24 0c d4 6a 10 	movl   $0xc0106ad4,0xc(%esp)
c0104802:	c0 
c0104803:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c010480a:	c0 
c010480b:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c0104812:	00 
c0104813:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c010481a:	e8 ad c4 ff ff       	call   c0100ccc <__panic>

    p2 = alloc_page();
c010481f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104826:	e8 ff f4 ff ff       	call   c0103d2a <alloc_pages>
c010482b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010482e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104833:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010483a:	00 
c010483b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104842:	00 
c0104843:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104846:	89 54 24 04          	mov    %edx,0x4(%esp)
c010484a:	89 04 24             	mov    %eax,(%esp)
c010484d:	e8 3b fc ff ff       	call   c010448d <page_insert>
c0104852:	85 c0                	test   %eax,%eax
c0104854:	74 24                	je     c010487a <check_pgdir+0x2b9>
c0104856:	c7 44 24 0c fc 6a 10 	movl   $0xc0106afc,0xc(%esp)
c010485d:	c0 
c010485e:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104865:	c0 
c0104866:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c010486d:	00 
c010486e:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104875:	e8 52 c4 ff ff       	call   c0100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010487a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010487f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104886:	00 
c0104887:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010488e:	00 
c010488f:	89 04 24             	mov    %eax,(%esp)
c0104892:	e8 4f fb ff ff       	call   c01043e6 <get_pte>
c0104897:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010489a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010489e:	75 24                	jne    c01048c4 <check_pgdir+0x303>
c01048a0:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c01048a7:	c0 
c01048a8:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c01048af:	c0 
c01048b0:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c01048b7:	00 
c01048b8:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c01048bf:	e8 08 c4 ff ff       	call   c0100ccc <__panic>
    assert(*ptep & PTE_U);
c01048c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048c7:	8b 00                	mov    (%eax),%eax
c01048c9:	83 e0 04             	and    $0x4,%eax
c01048cc:	85 c0                	test   %eax,%eax
c01048ce:	75 24                	jne    c01048f4 <check_pgdir+0x333>
c01048d0:	c7 44 24 0c 64 6b 10 	movl   $0xc0106b64,0xc(%esp)
c01048d7:	c0 
c01048d8:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c01048df:	c0 
c01048e0:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c01048e7:	00 
c01048e8:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c01048ef:	e8 d8 c3 ff ff       	call   c0100ccc <__panic>
    assert(*ptep & PTE_W);
c01048f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048f7:	8b 00                	mov    (%eax),%eax
c01048f9:	83 e0 02             	and    $0x2,%eax
c01048fc:	85 c0                	test   %eax,%eax
c01048fe:	75 24                	jne    c0104924 <check_pgdir+0x363>
c0104900:	c7 44 24 0c 72 6b 10 	movl   $0xc0106b72,0xc(%esp)
c0104907:	c0 
c0104908:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c010490f:	c0 
c0104910:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0104917:	00 
c0104918:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c010491f:	e8 a8 c3 ff ff       	call   c0100ccc <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104924:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104929:	8b 00                	mov    (%eax),%eax
c010492b:	83 e0 04             	and    $0x4,%eax
c010492e:	85 c0                	test   %eax,%eax
c0104930:	75 24                	jne    c0104956 <check_pgdir+0x395>
c0104932:	c7 44 24 0c 80 6b 10 	movl   $0xc0106b80,0xc(%esp)
c0104939:	c0 
c010493a:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104941:	c0 
c0104942:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104949:	00 
c010494a:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104951:	e8 76 c3 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 1);
c0104956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104959:	89 04 24             	mov    %eax,(%esp)
c010495c:	e8 d1 f1 ff ff       	call   c0103b32 <page_ref>
c0104961:	83 f8 01             	cmp    $0x1,%eax
c0104964:	74 24                	je     c010498a <check_pgdir+0x3c9>
c0104966:	c7 44 24 0c 96 6b 10 	movl   $0xc0106b96,0xc(%esp)
c010496d:	c0 
c010496e:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104975:	c0 
c0104976:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c010497d:	00 
c010497e:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104985:	e8 42 c3 ff ff       	call   c0100ccc <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010498a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010498f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104996:	00 
c0104997:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010499e:	00 
c010499f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01049a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01049a6:	89 04 24             	mov    %eax,(%esp)
c01049a9:	e8 df fa ff ff       	call   c010448d <page_insert>
c01049ae:	85 c0                	test   %eax,%eax
c01049b0:	74 24                	je     c01049d6 <check_pgdir+0x415>
c01049b2:	c7 44 24 0c a8 6b 10 	movl   $0xc0106ba8,0xc(%esp)
c01049b9:	c0 
c01049ba:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c01049c1:	c0 
c01049c2:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c01049c9:	00 
c01049ca:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c01049d1:	e8 f6 c2 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p1) == 2);
c01049d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d9:	89 04 24             	mov    %eax,(%esp)
c01049dc:	e8 51 f1 ff ff       	call   c0103b32 <page_ref>
c01049e1:	83 f8 02             	cmp    $0x2,%eax
c01049e4:	74 24                	je     c0104a0a <check_pgdir+0x449>
c01049e6:	c7 44 24 0c d4 6b 10 	movl   $0xc0106bd4,0xc(%esp)
c01049ed:	c0 
c01049ee:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c01049f5:	c0 
c01049f6:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c01049fd:	00 
c01049fe:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104a05:	e8 c2 c2 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 0);
c0104a0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a0d:	89 04 24             	mov    %eax,(%esp)
c0104a10:	e8 1d f1 ff ff       	call   c0103b32 <page_ref>
c0104a15:	85 c0                	test   %eax,%eax
c0104a17:	74 24                	je     c0104a3d <check_pgdir+0x47c>
c0104a19:	c7 44 24 0c e6 6b 10 	movl   $0xc0106be6,0xc(%esp)
c0104a20:	c0 
c0104a21:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104a28:	c0 
c0104a29:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104a30:	00 
c0104a31:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104a38:	e8 8f c2 ff ff       	call   c0100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a3d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a42:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a49:	00 
c0104a4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a51:	00 
c0104a52:	89 04 24             	mov    %eax,(%esp)
c0104a55:	e8 8c f9 ff ff       	call   c01043e6 <get_pte>
c0104a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a61:	75 24                	jne    c0104a87 <check_pgdir+0x4c6>
c0104a63:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c0104a6a:	c0 
c0104a6b:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104a72:	c0 
c0104a73:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104a7a:	00 
c0104a7b:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104a82:	e8 45 c2 ff ff       	call   c0100ccc <__panic>
    assert(pte2page(*ptep) == p1);
c0104a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a8a:	8b 00                	mov    (%eax),%eax
c0104a8c:	89 04 24             	mov    %eax,(%esp)
c0104a8f:	e8 48 f0 ff ff       	call   c0103adc <pte2page>
c0104a94:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a97:	74 24                	je     c0104abd <check_pgdir+0x4fc>
c0104a99:	c7 44 24 0c a9 6a 10 	movl   $0xc0106aa9,0xc(%esp)
c0104aa0:	c0 
c0104aa1:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104aa8:	c0 
c0104aa9:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104ab0:	00 
c0104ab1:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104ab8:	e8 0f c2 ff ff       	call   c0100ccc <__panic>
    assert((*ptep & PTE_U) == 0);
c0104abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ac0:	8b 00                	mov    (%eax),%eax
c0104ac2:	83 e0 04             	and    $0x4,%eax
c0104ac5:	85 c0                	test   %eax,%eax
c0104ac7:	74 24                	je     c0104aed <check_pgdir+0x52c>
c0104ac9:	c7 44 24 0c f8 6b 10 	movl   $0xc0106bf8,0xc(%esp)
c0104ad0:	c0 
c0104ad1:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104ad8:	c0 
c0104ad9:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104ae0:	00 
c0104ae1:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104ae8:	e8 df c1 ff ff       	call   c0100ccc <__panic>

    page_remove(boot_pgdir, 0x0);
c0104aed:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104af2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104af9:	00 
c0104afa:	89 04 24             	mov    %eax,(%esp)
c0104afd:	e8 47 f9 ff ff       	call   c0104449 <page_remove>
    assert(page_ref(p1) == 1);
c0104b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b05:	89 04 24             	mov    %eax,(%esp)
c0104b08:	e8 25 f0 ff ff       	call   c0103b32 <page_ref>
c0104b0d:	83 f8 01             	cmp    $0x1,%eax
c0104b10:	74 24                	je     c0104b36 <check_pgdir+0x575>
c0104b12:	c7 44 24 0c bf 6a 10 	movl   $0xc0106abf,0xc(%esp)
c0104b19:	c0 
c0104b1a:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104b21:	c0 
c0104b22:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104b29:	00 
c0104b2a:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104b31:	e8 96 c1 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 0);
c0104b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b39:	89 04 24             	mov    %eax,(%esp)
c0104b3c:	e8 f1 ef ff ff       	call   c0103b32 <page_ref>
c0104b41:	85 c0                	test   %eax,%eax
c0104b43:	74 24                	je     c0104b69 <check_pgdir+0x5a8>
c0104b45:	c7 44 24 0c e6 6b 10 	movl   $0xc0106be6,0xc(%esp)
c0104b4c:	c0 
c0104b4d:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104b54:	c0 
c0104b55:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104b5c:	00 
c0104b5d:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104b64:	e8 63 c1 ff ff       	call   c0100ccc <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104b69:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b75:	00 
c0104b76:	89 04 24             	mov    %eax,(%esp)
c0104b79:	e8 cb f8 ff ff       	call   c0104449 <page_remove>
    assert(page_ref(p1) == 0);
c0104b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b81:	89 04 24             	mov    %eax,(%esp)
c0104b84:	e8 a9 ef ff ff       	call   c0103b32 <page_ref>
c0104b89:	85 c0                	test   %eax,%eax
c0104b8b:	74 24                	je     c0104bb1 <check_pgdir+0x5f0>
c0104b8d:	c7 44 24 0c 0d 6c 10 	movl   $0xc0106c0d,0xc(%esp)
c0104b94:	c0 
c0104b95:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104b9c:	c0 
c0104b9d:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104ba4:	00 
c0104ba5:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104bac:	e8 1b c1 ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p2) == 0);
c0104bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bb4:	89 04 24             	mov    %eax,(%esp)
c0104bb7:	e8 76 ef ff ff       	call   c0103b32 <page_ref>
c0104bbc:	85 c0                	test   %eax,%eax
c0104bbe:	74 24                	je     c0104be4 <check_pgdir+0x623>
c0104bc0:	c7 44 24 0c e6 6b 10 	movl   $0xc0106be6,0xc(%esp)
c0104bc7:	c0 
c0104bc8:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104bcf:	c0 
c0104bd0:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104bd7:	00 
c0104bd8:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104bdf:	e8 e8 c0 ff ff       	call   c0100ccc <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104be4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104be9:	8b 00                	mov    (%eax),%eax
c0104beb:	89 04 24             	mov    %eax,(%esp)
c0104bee:	e8 27 ef ff ff       	call   c0103b1a <pde2page>
c0104bf3:	89 04 24             	mov    %eax,(%esp)
c0104bf6:	e8 37 ef ff ff       	call   c0103b32 <page_ref>
c0104bfb:	83 f8 01             	cmp    $0x1,%eax
c0104bfe:	74 24                	je     c0104c24 <check_pgdir+0x663>
c0104c00:	c7 44 24 0c 20 6c 10 	movl   $0xc0106c20,0xc(%esp)
c0104c07:	c0 
c0104c08:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104c0f:	c0 
c0104c10:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104c17:	00 
c0104c18:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104c1f:	e8 a8 c0 ff ff       	call   c0100ccc <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104c24:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c29:	8b 00                	mov    (%eax),%eax
c0104c2b:	89 04 24             	mov    %eax,(%esp)
c0104c2e:	e8 e7 ee ff ff       	call   c0103b1a <pde2page>
c0104c33:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c3a:	00 
c0104c3b:	89 04 24             	mov    %eax,(%esp)
c0104c3e:	e8 1f f1 ff ff       	call   c0103d62 <free_pages>
    boot_pgdir[0] = 0;
c0104c43:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104c4e:	c7 04 24 47 6c 10 c0 	movl   $0xc0106c47,(%esp)
c0104c55:	e8 ee b6 ff ff       	call   c0100348 <cprintf>
}
c0104c5a:	c9                   	leave  
c0104c5b:	c3                   	ret    

c0104c5c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104c5c:	55                   	push   %ebp
c0104c5d:	89 e5                	mov    %esp,%ebp
c0104c5f:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104c69:	e9 ca 00 00 00       	jmp    c0104d38 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c77:	c1 e8 0c             	shr    $0xc,%eax
c0104c7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c7d:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104c82:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104c85:	72 23                	jb     c0104caa <check_boot_pgdir+0x4e>
c0104c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c8e:	c7 44 24 08 8c 68 10 	movl   $0xc010688c,0x8(%esp)
c0104c95:	c0 
c0104c96:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104c9d:	00 
c0104c9e:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104ca5:	e8 22 c0 ff ff       	call   c0100ccc <__panic>
c0104caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cad:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104cb2:	89 c2                	mov    %eax,%edx
c0104cb4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104cb9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104cc0:	00 
c0104cc1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104cc5:	89 04 24             	mov    %eax,(%esp)
c0104cc8:	e8 19 f7 ff ff       	call   c01043e6 <get_pte>
c0104ccd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104cd0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104cd4:	75 24                	jne    c0104cfa <check_boot_pgdir+0x9e>
c0104cd6:	c7 44 24 0c 64 6c 10 	movl   $0xc0106c64,0xc(%esp)
c0104cdd:	c0 
c0104cde:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104ce5:	c0 
c0104ce6:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104ced:	00 
c0104cee:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104cf5:	e8 d2 bf ff ff       	call   c0100ccc <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104cfd:	8b 00                	mov    (%eax),%eax
c0104cff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d04:	89 c2                	mov    %eax,%edx
c0104d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d09:	39 c2                	cmp    %eax,%edx
c0104d0b:	74 24                	je     c0104d31 <check_boot_pgdir+0xd5>
c0104d0d:	c7 44 24 0c a1 6c 10 	movl   $0xc0106ca1,0xc(%esp)
c0104d14:	c0 
c0104d15:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104d1c:	c0 
c0104d1d:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104d24:	00 
c0104d25:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104d2c:	e8 9b bf ff ff       	call   c0100ccc <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104d31:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d3b:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104d40:	39 c2                	cmp    %eax,%edx
c0104d42:	0f 82 26 ff ff ff    	jb     c0104c6e <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104d48:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104d4d:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104d52:	8b 00                	mov    (%eax),%eax
c0104d54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d59:	89 c2                	mov    %eax,%edx
c0104d5b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104d60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104d63:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104d6a:	77 23                	ja     c0104d8f <check_boot_pgdir+0x133>
c0104d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d73:	c7 44 24 08 30 69 10 	movl   $0xc0106930,0x8(%esp)
c0104d7a:	c0 
c0104d7b:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104d82:	00 
c0104d83:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104d8a:	e8 3d bf ff ff       	call   c0100ccc <__panic>
c0104d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d92:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d97:	39 c2                	cmp    %eax,%edx
c0104d99:	74 24                	je     c0104dbf <check_boot_pgdir+0x163>
c0104d9b:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c0104da2:	c0 
c0104da3:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104daa:	c0 
c0104dab:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104db2:	00 
c0104db3:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104dba:	e8 0d bf ff ff       	call   c0100ccc <__panic>

    assert(boot_pgdir[0] == 0);
c0104dbf:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104dc4:	8b 00                	mov    (%eax),%eax
c0104dc6:	85 c0                	test   %eax,%eax
c0104dc8:	74 24                	je     c0104dee <check_boot_pgdir+0x192>
c0104dca:	c7 44 24 0c ec 6c 10 	movl   $0xc0106cec,0xc(%esp)
c0104dd1:	c0 
c0104dd2:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104dd9:	c0 
c0104dda:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104de1:	00 
c0104de2:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104de9:	e8 de be ff ff       	call   c0100ccc <__panic>

    struct Page *p;
    p = alloc_page();
c0104dee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104df5:	e8 30 ef ff ff       	call   c0103d2a <alloc_pages>
c0104dfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104dfd:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e02:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104e09:	00 
c0104e0a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104e11:	00 
c0104e12:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e15:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e19:	89 04 24             	mov    %eax,(%esp)
c0104e1c:	e8 6c f6 ff ff       	call   c010448d <page_insert>
c0104e21:	85 c0                	test   %eax,%eax
c0104e23:	74 24                	je     c0104e49 <check_boot_pgdir+0x1ed>
c0104e25:	c7 44 24 0c 00 6d 10 	movl   $0xc0106d00,0xc(%esp)
c0104e2c:	c0 
c0104e2d:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104e34:	c0 
c0104e35:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104e3c:	00 
c0104e3d:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104e44:	e8 83 be ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p) == 1);
c0104e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e4c:	89 04 24             	mov    %eax,(%esp)
c0104e4f:	e8 de ec ff ff       	call   c0103b32 <page_ref>
c0104e54:	83 f8 01             	cmp    $0x1,%eax
c0104e57:	74 24                	je     c0104e7d <check_boot_pgdir+0x221>
c0104e59:	c7 44 24 0c 2e 6d 10 	movl   $0xc0106d2e,0xc(%esp)
c0104e60:	c0 
c0104e61:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104e68:	c0 
c0104e69:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104e70:	00 
c0104e71:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104e78:	e8 4f be ff ff       	call   c0100ccc <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104e7d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e82:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104e89:	00 
c0104e8a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104e91:	00 
c0104e92:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104e95:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e99:	89 04 24             	mov    %eax,(%esp)
c0104e9c:	e8 ec f5 ff ff       	call   c010448d <page_insert>
c0104ea1:	85 c0                	test   %eax,%eax
c0104ea3:	74 24                	je     c0104ec9 <check_boot_pgdir+0x26d>
c0104ea5:	c7 44 24 0c 40 6d 10 	movl   $0xc0106d40,0xc(%esp)
c0104eac:	c0 
c0104ead:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104eb4:	c0 
c0104eb5:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104ebc:	00 
c0104ebd:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104ec4:	e8 03 be ff ff       	call   c0100ccc <__panic>
    assert(page_ref(p) == 2);
c0104ec9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104ecc:	89 04 24             	mov    %eax,(%esp)
c0104ecf:	e8 5e ec ff ff       	call   c0103b32 <page_ref>
c0104ed4:	83 f8 02             	cmp    $0x2,%eax
c0104ed7:	74 24                	je     c0104efd <check_boot_pgdir+0x2a1>
c0104ed9:	c7 44 24 0c 77 6d 10 	movl   $0xc0106d77,0xc(%esp)
c0104ee0:	c0 
c0104ee1:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104ee8:	c0 
c0104ee9:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104ef0:	00 
c0104ef1:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104ef8:	e8 cf bd ff ff       	call   c0100ccc <__panic>

    const char *str = "ucore: Hello world!!";
c0104efd:	c7 45 dc 88 6d 10 c0 	movl   $0xc0106d88,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104f04:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104f07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f0b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f12:	e8 19 0a 00 00       	call   c0105930 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104f17:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104f1e:	00 
c0104f1f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f26:	e8 7e 0a 00 00       	call   c01059a9 <strcmp>
c0104f2b:	85 c0                	test   %eax,%eax
c0104f2d:	74 24                	je     c0104f53 <check_boot_pgdir+0x2f7>
c0104f2f:	c7 44 24 0c a0 6d 10 	movl   $0xc0106da0,0xc(%esp)
c0104f36:	c0 
c0104f37:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104f3e:	c0 
c0104f3f:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104f46:	00 
c0104f47:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104f4e:	e8 79 bd ff ff       	call   c0100ccc <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104f53:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f56:	89 04 24             	mov    %eax,(%esp)
c0104f59:	e8 2a eb ff ff       	call   c0103a88 <page2kva>
c0104f5e:	05 00 01 00 00       	add    $0x100,%eax
c0104f63:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104f66:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104f6d:	e8 66 09 00 00       	call   c01058d8 <strlen>
c0104f72:	85 c0                	test   %eax,%eax
c0104f74:	74 24                	je     c0104f9a <check_boot_pgdir+0x33e>
c0104f76:	c7 44 24 0c d8 6d 10 	movl   $0xc0106dd8,0xc(%esp)
c0104f7d:	c0 
c0104f7e:	c7 44 24 08 79 69 10 	movl   $0xc0106979,0x8(%esp)
c0104f85:	c0 
c0104f86:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104f8d:	00 
c0104f8e:	c7 04 24 54 69 10 c0 	movl   $0xc0106954,(%esp)
c0104f95:	e8 32 bd ff ff       	call   c0100ccc <__panic>

    free_page(p);
c0104f9a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fa1:	00 
c0104fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fa5:	89 04 24             	mov    %eax,(%esp)
c0104fa8:	e8 b5 ed ff ff       	call   c0103d62 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0104fad:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104fb2:	8b 00                	mov    (%eax),%eax
c0104fb4:	89 04 24             	mov    %eax,(%esp)
c0104fb7:	e8 5e eb ff ff       	call   c0103b1a <pde2page>
c0104fbc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fc3:	00 
c0104fc4:	89 04 24             	mov    %eax,(%esp)
c0104fc7:	e8 96 ed ff ff       	call   c0103d62 <free_pages>
    boot_pgdir[0] = 0;
c0104fcc:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104fd7:	c7 04 24 fc 6d 10 c0 	movl   $0xc0106dfc,(%esp)
c0104fde:	e8 65 b3 ff ff       	call   c0100348 <cprintf>
}
c0104fe3:	c9                   	leave  
c0104fe4:	c3                   	ret    

c0104fe5 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104fe5:	55                   	push   %ebp
c0104fe6:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104fe8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104feb:	83 e0 04             	and    $0x4,%eax
c0104fee:	85 c0                	test   %eax,%eax
c0104ff0:	74 07                	je     c0104ff9 <perm2str+0x14>
c0104ff2:	b8 75 00 00 00       	mov    $0x75,%eax
c0104ff7:	eb 05                	jmp    c0104ffe <perm2str+0x19>
c0104ff9:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104ffe:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c0105003:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010500a:	8b 45 08             	mov    0x8(%ebp),%eax
c010500d:	83 e0 02             	and    $0x2,%eax
c0105010:	85 c0                	test   %eax,%eax
c0105012:	74 07                	je     c010501b <perm2str+0x36>
c0105014:	b8 77 00 00 00       	mov    $0x77,%eax
c0105019:	eb 05                	jmp    c0105020 <perm2str+0x3b>
c010501b:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105020:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c0105025:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c010502c:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c0105031:	5d                   	pop    %ebp
c0105032:	c3                   	ret    

c0105033 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105033:	55                   	push   %ebp
c0105034:	89 e5                	mov    %esp,%ebp
c0105036:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105039:	8b 45 10             	mov    0x10(%ebp),%eax
c010503c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010503f:	72 0a                	jb     c010504b <get_pgtable_items+0x18>
        return 0;
c0105041:	b8 00 00 00 00       	mov    $0x0,%eax
c0105046:	e9 9c 00 00 00       	jmp    c01050e7 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010504b:	eb 04                	jmp    c0105051 <get_pgtable_items+0x1e>
        start ++;
c010504d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105051:	8b 45 10             	mov    0x10(%ebp),%eax
c0105054:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105057:	73 18                	jae    c0105071 <get_pgtable_items+0x3e>
c0105059:	8b 45 10             	mov    0x10(%ebp),%eax
c010505c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105063:	8b 45 14             	mov    0x14(%ebp),%eax
c0105066:	01 d0                	add    %edx,%eax
c0105068:	8b 00                	mov    (%eax),%eax
c010506a:	83 e0 01             	and    $0x1,%eax
c010506d:	85 c0                	test   %eax,%eax
c010506f:	74 dc                	je     c010504d <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105071:	8b 45 10             	mov    0x10(%ebp),%eax
c0105074:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105077:	73 69                	jae    c01050e2 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105079:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010507d:	74 08                	je     c0105087 <get_pgtable_items+0x54>
            *left_store = start;
c010507f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105082:	8b 55 10             	mov    0x10(%ebp),%edx
c0105085:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105087:	8b 45 10             	mov    0x10(%ebp),%eax
c010508a:	8d 50 01             	lea    0x1(%eax),%edx
c010508d:	89 55 10             	mov    %edx,0x10(%ebp)
c0105090:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105097:	8b 45 14             	mov    0x14(%ebp),%eax
c010509a:	01 d0                	add    %edx,%eax
c010509c:	8b 00                	mov    (%eax),%eax
c010509e:	83 e0 07             	and    $0x7,%eax
c01050a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01050a4:	eb 04                	jmp    c01050aa <get_pgtable_items+0x77>
            start ++;
c01050a6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01050aa:	8b 45 10             	mov    0x10(%ebp),%eax
c01050ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01050b0:	73 1d                	jae    c01050cf <get_pgtable_items+0x9c>
c01050b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01050b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01050bc:	8b 45 14             	mov    0x14(%ebp),%eax
c01050bf:	01 d0                	add    %edx,%eax
c01050c1:	8b 00                	mov    (%eax),%eax
c01050c3:	83 e0 07             	and    $0x7,%eax
c01050c6:	89 c2                	mov    %eax,%edx
c01050c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050cb:	39 c2                	cmp    %eax,%edx
c01050cd:	74 d7                	je     c01050a6 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01050cf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01050d3:	74 08                	je     c01050dd <get_pgtable_items+0xaa>
            *right_store = start;
c01050d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01050d8:	8b 55 10             	mov    0x10(%ebp),%edx
c01050db:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01050dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01050e0:	eb 05                	jmp    c01050e7 <get_pgtable_items+0xb4>
    }
    return 0;
c01050e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050e7:	c9                   	leave  
c01050e8:	c3                   	ret    

c01050e9 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01050e9:	55                   	push   %ebp
c01050ea:	89 e5                	mov    %esp,%ebp
c01050ec:	57                   	push   %edi
c01050ed:	56                   	push   %esi
c01050ee:	53                   	push   %ebx
c01050ef:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01050f2:	c7 04 24 1c 6e 10 c0 	movl   $0xc0106e1c,(%esp)
c01050f9:	e8 4a b2 ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
c01050fe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105105:	e9 fa 00 00 00       	jmp    c0105204 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010510a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010510d:	89 04 24             	mov    %eax,(%esp)
c0105110:	e8 d0 fe ff ff       	call   c0104fe5 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105115:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105118:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010511b:	29 d1                	sub    %edx,%ecx
c010511d:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010511f:	89 d6                	mov    %edx,%esi
c0105121:	c1 e6 16             	shl    $0x16,%esi
c0105124:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105127:	89 d3                	mov    %edx,%ebx
c0105129:	c1 e3 16             	shl    $0x16,%ebx
c010512c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010512f:	89 d1                	mov    %edx,%ecx
c0105131:	c1 e1 16             	shl    $0x16,%ecx
c0105134:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105137:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010513a:	29 d7                	sub    %edx,%edi
c010513c:	89 fa                	mov    %edi,%edx
c010513e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105142:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105146:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010514a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010514e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105152:	c7 04 24 4d 6e 10 c0 	movl   $0xc0106e4d,(%esp)
c0105159:	e8 ea b1 ff ff       	call   c0100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010515e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105161:	c1 e0 0a             	shl    $0xa,%eax
c0105164:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105167:	eb 54                	jmp    c01051bd <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010516c:	89 04 24             	mov    %eax,(%esp)
c010516f:	e8 71 fe ff ff       	call   c0104fe5 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105174:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105177:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010517a:	29 d1                	sub    %edx,%ecx
c010517c:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010517e:	89 d6                	mov    %edx,%esi
c0105180:	c1 e6 0c             	shl    $0xc,%esi
c0105183:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105186:	89 d3                	mov    %edx,%ebx
c0105188:	c1 e3 0c             	shl    $0xc,%ebx
c010518b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010518e:	c1 e2 0c             	shl    $0xc,%edx
c0105191:	89 d1                	mov    %edx,%ecx
c0105193:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105196:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105199:	29 d7                	sub    %edx,%edi
c010519b:	89 fa                	mov    %edi,%edx
c010519d:	89 44 24 14          	mov    %eax,0x14(%esp)
c01051a1:	89 74 24 10          	mov    %esi,0x10(%esp)
c01051a5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01051a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01051ad:	89 54 24 04          	mov    %edx,0x4(%esp)
c01051b1:	c7 04 24 6c 6e 10 c0 	movl   $0xc0106e6c,(%esp)
c01051b8:	e8 8b b1 ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01051bd:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01051c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01051c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01051c8:	89 ce                	mov    %ecx,%esi
c01051ca:	c1 e6 0a             	shl    $0xa,%esi
c01051cd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01051d0:	89 cb                	mov    %ecx,%ebx
c01051d2:	c1 e3 0a             	shl    $0xa,%ebx
c01051d5:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01051d8:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01051dc:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01051df:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01051e3:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01051e7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01051eb:	89 74 24 04          	mov    %esi,0x4(%esp)
c01051ef:	89 1c 24             	mov    %ebx,(%esp)
c01051f2:	e8 3c fe ff ff       	call   c0105033 <get_pgtable_items>
c01051f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01051fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01051fe:	0f 85 65 ff ff ff    	jne    c0105169 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105204:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105209:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010520c:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010520f:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105213:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105216:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010521a:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010521e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105222:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105229:	00 
c010522a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105231:	e8 fd fd ff ff       	call   c0105033 <get_pgtable_items>
c0105236:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105239:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010523d:	0f 85 c7 fe ff ff    	jne    c010510a <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105243:	c7 04 24 90 6e 10 c0 	movl   $0xc0106e90,(%esp)
c010524a:	e8 f9 b0 ff ff       	call   c0100348 <cprintf>
}
c010524f:	83 c4 4c             	add    $0x4c,%esp
c0105252:	5b                   	pop    %ebx
c0105253:	5e                   	pop    %esi
c0105254:	5f                   	pop    %edi
c0105255:	5d                   	pop    %ebp
c0105256:	c3                   	ret    

c0105257 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105257:	55                   	push   %ebp
c0105258:	89 e5                	mov    %esp,%ebp
c010525a:	83 ec 58             	sub    $0x58,%esp
c010525d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105260:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105263:	8b 45 14             	mov    0x14(%ebp),%eax
c0105266:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105269:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010526c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010526f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105272:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105275:	8b 45 18             	mov    0x18(%ebp),%eax
c0105278:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010527b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010527e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105281:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105284:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105287:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010528a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010528d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105291:	74 1c                	je     c01052af <printnum+0x58>
c0105293:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105296:	ba 00 00 00 00       	mov    $0x0,%edx
c010529b:	f7 75 e4             	divl   -0x1c(%ebp)
c010529e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01052a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01052a4:	ba 00 00 00 00       	mov    $0x0,%edx
c01052a9:	f7 75 e4             	divl   -0x1c(%ebp)
c01052ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01052af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01052b5:	f7 75 e4             	divl   -0x1c(%ebp)
c01052b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01052bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01052be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01052c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01052ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052cd:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01052d0:	8b 45 18             	mov    0x18(%ebp),%eax
c01052d3:	ba 00 00 00 00       	mov    $0x0,%edx
c01052d8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01052db:	77 56                	ja     c0105333 <printnum+0xdc>
c01052dd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01052e0:	72 05                	jb     c01052e7 <printnum+0x90>
c01052e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01052e5:	77 4c                	ja     c0105333 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01052e7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052ea:	8d 50 ff             	lea    -0x1(%eax),%edx
c01052ed:	8b 45 20             	mov    0x20(%ebp),%eax
c01052f0:	89 44 24 18          	mov    %eax,0x18(%esp)
c01052f4:	89 54 24 14          	mov    %edx,0x14(%esp)
c01052f8:	8b 45 18             	mov    0x18(%ebp),%eax
c01052fb:	89 44 24 10          	mov    %eax,0x10(%esp)
c01052ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105302:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105305:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105309:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010530d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105310:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105314:	8b 45 08             	mov    0x8(%ebp),%eax
c0105317:	89 04 24             	mov    %eax,(%esp)
c010531a:	e8 38 ff ff ff       	call   c0105257 <printnum>
c010531f:	eb 1c                	jmp    c010533d <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105321:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105324:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105328:	8b 45 20             	mov    0x20(%ebp),%eax
c010532b:	89 04 24             	mov    %eax,(%esp)
c010532e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105331:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105333:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105337:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010533b:	7f e4                	jg     c0105321 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010533d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105340:	05 44 6f 10 c0       	add    $0xc0106f44,%eax
c0105345:	0f b6 00             	movzbl (%eax),%eax
c0105348:	0f be c0             	movsbl %al,%eax
c010534b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010534e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105352:	89 04 24             	mov    %eax,(%esp)
c0105355:	8b 45 08             	mov    0x8(%ebp),%eax
c0105358:	ff d0                	call   *%eax
}
c010535a:	c9                   	leave  
c010535b:	c3                   	ret    

c010535c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010535c:	55                   	push   %ebp
c010535d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010535f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105363:	7e 14                	jle    c0105379 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105365:	8b 45 08             	mov    0x8(%ebp),%eax
c0105368:	8b 00                	mov    (%eax),%eax
c010536a:	8d 48 08             	lea    0x8(%eax),%ecx
c010536d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105370:	89 0a                	mov    %ecx,(%edx)
c0105372:	8b 50 04             	mov    0x4(%eax),%edx
c0105375:	8b 00                	mov    (%eax),%eax
c0105377:	eb 30                	jmp    c01053a9 <getuint+0x4d>
    }
    else if (lflag) {
c0105379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010537d:	74 16                	je     c0105395 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010537f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105382:	8b 00                	mov    (%eax),%eax
c0105384:	8d 48 04             	lea    0x4(%eax),%ecx
c0105387:	8b 55 08             	mov    0x8(%ebp),%edx
c010538a:	89 0a                	mov    %ecx,(%edx)
c010538c:	8b 00                	mov    (%eax),%eax
c010538e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105393:	eb 14                	jmp    c01053a9 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105395:	8b 45 08             	mov    0x8(%ebp),%eax
c0105398:	8b 00                	mov    (%eax),%eax
c010539a:	8d 48 04             	lea    0x4(%eax),%ecx
c010539d:	8b 55 08             	mov    0x8(%ebp),%edx
c01053a0:	89 0a                	mov    %ecx,(%edx)
c01053a2:	8b 00                	mov    (%eax),%eax
c01053a4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01053a9:	5d                   	pop    %ebp
c01053aa:	c3                   	ret    

c01053ab <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01053ab:	55                   	push   %ebp
c01053ac:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01053ae:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01053b2:	7e 14                	jle    c01053c8 <getint+0x1d>
        return va_arg(*ap, long long);
c01053b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b7:	8b 00                	mov    (%eax),%eax
c01053b9:	8d 48 08             	lea    0x8(%eax),%ecx
c01053bc:	8b 55 08             	mov    0x8(%ebp),%edx
c01053bf:	89 0a                	mov    %ecx,(%edx)
c01053c1:	8b 50 04             	mov    0x4(%eax),%edx
c01053c4:	8b 00                	mov    (%eax),%eax
c01053c6:	eb 28                	jmp    c01053f0 <getint+0x45>
    }
    else if (lflag) {
c01053c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01053cc:	74 12                	je     c01053e0 <getint+0x35>
        return va_arg(*ap, long);
c01053ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01053d1:	8b 00                	mov    (%eax),%eax
c01053d3:	8d 48 04             	lea    0x4(%eax),%ecx
c01053d6:	8b 55 08             	mov    0x8(%ebp),%edx
c01053d9:	89 0a                	mov    %ecx,(%edx)
c01053db:	8b 00                	mov    (%eax),%eax
c01053dd:	99                   	cltd   
c01053de:	eb 10                	jmp    c01053f0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01053e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01053e3:	8b 00                	mov    (%eax),%eax
c01053e5:	8d 48 04             	lea    0x4(%eax),%ecx
c01053e8:	8b 55 08             	mov    0x8(%ebp),%edx
c01053eb:	89 0a                	mov    %ecx,(%edx)
c01053ed:	8b 00                	mov    (%eax),%eax
c01053ef:	99                   	cltd   
    }
}
c01053f0:	5d                   	pop    %ebp
c01053f1:	c3                   	ret    

c01053f2 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01053f2:	55                   	push   %ebp
c01053f3:	89 e5                	mov    %esp,%ebp
c01053f5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01053f8:	8d 45 14             	lea    0x14(%ebp),%eax
c01053fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01053fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105401:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105405:	8b 45 10             	mov    0x10(%ebp),%eax
c0105408:	89 44 24 08          	mov    %eax,0x8(%esp)
c010540c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010540f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105413:	8b 45 08             	mov    0x8(%ebp),%eax
c0105416:	89 04 24             	mov    %eax,(%esp)
c0105419:	e8 02 00 00 00       	call   c0105420 <vprintfmt>
    va_end(ap);
}
c010541e:	c9                   	leave  
c010541f:	c3                   	ret    

c0105420 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105420:	55                   	push   %ebp
c0105421:	89 e5                	mov    %esp,%ebp
c0105423:	56                   	push   %esi
c0105424:	53                   	push   %ebx
c0105425:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105428:	eb 18                	jmp    c0105442 <vprintfmt+0x22>
            if (ch == '\0') {
c010542a:	85 db                	test   %ebx,%ebx
c010542c:	75 05                	jne    c0105433 <vprintfmt+0x13>
                return;
c010542e:	e9 d1 03 00 00       	jmp    c0105804 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105433:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105436:	89 44 24 04          	mov    %eax,0x4(%esp)
c010543a:	89 1c 24             	mov    %ebx,(%esp)
c010543d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105440:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105442:	8b 45 10             	mov    0x10(%ebp),%eax
c0105445:	8d 50 01             	lea    0x1(%eax),%edx
c0105448:	89 55 10             	mov    %edx,0x10(%ebp)
c010544b:	0f b6 00             	movzbl (%eax),%eax
c010544e:	0f b6 d8             	movzbl %al,%ebx
c0105451:	83 fb 25             	cmp    $0x25,%ebx
c0105454:	75 d4                	jne    c010542a <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105456:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010545a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105464:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105467:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010546e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105471:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105474:	8b 45 10             	mov    0x10(%ebp),%eax
c0105477:	8d 50 01             	lea    0x1(%eax),%edx
c010547a:	89 55 10             	mov    %edx,0x10(%ebp)
c010547d:	0f b6 00             	movzbl (%eax),%eax
c0105480:	0f b6 d8             	movzbl %al,%ebx
c0105483:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105486:	83 f8 55             	cmp    $0x55,%eax
c0105489:	0f 87 44 03 00 00    	ja     c01057d3 <vprintfmt+0x3b3>
c010548f:	8b 04 85 68 6f 10 c0 	mov    -0x3fef9098(,%eax,4),%eax
c0105496:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105498:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010549c:	eb d6                	jmp    c0105474 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010549e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01054a2:	eb d0                	jmp    c0105474 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01054a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01054ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01054ae:	89 d0                	mov    %edx,%eax
c01054b0:	c1 e0 02             	shl    $0x2,%eax
c01054b3:	01 d0                	add    %edx,%eax
c01054b5:	01 c0                	add    %eax,%eax
c01054b7:	01 d8                	add    %ebx,%eax
c01054b9:	83 e8 30             	sub    $0x30,%eax
c01054bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01054bf:	8b 45 10             	mov    0x10(%ebp),%eax
c01054c2:	0f b6 00             	movzbl (%eax),%eax
c01054c5:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01054c8:	83 fb 2f             	cmp    $0x2f,%ebx
c01054cb:	7e 0b                	jle    c01054d8 <vprintfmt+0xb8>
c01054cd:	83 fb 39             	cmp    $0x39,%ebx
c01054d0:	7f 06                	jg     c01054d8 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01054d2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01054d6:	eb d3                	jmp    c01054ab <vprintfmt+0x8b>
            goto process_precision;
c01054d8:	eb 33                	jmp    c010550d <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01054da:	8b 45 14             	mov    0x14(%ebp),%eax
c01054dd:	8d 50 04             	lea    0x4(%eax),%edx
c01054e0:	89 55 14             	mov    %edx,0x14(%ebp)
c01054e3:	8b 00                	mov    (%eax),%eax
c01054e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01054e8:	eb 23                	jmp    c010550d <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01054ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01054ee:	79 0c                	jns    c01054fc <vprintfmt+0xdc>
                width = 0;
c01054f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01054f7:	e9 78 ff ff ff       	jmp    c0105474 <vprintfmt+0x54>
c01054fc:	e9 73 ff ff ff       	jmp    c0105474 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105501:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105508:	e9 67 ff ff ff       	jmp    c0105474 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010550d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105511:	79 12                	jns    c0105525 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105516:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105519:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105520:	e9 4f ff ff ff       	jmp    c0105474 <vprintfmt+0x54>
c0105525:	e9 4a ff ff ff       	jmp    c0105474 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010552a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010552e:	e9 41 ff ff ff       	jmp    c0105474 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105533:	8b 45 14             	mov    0x14(%ebp),%eax
c0105536:	8d 50 04             	lea    0x4(%eax),%edx
c0105539:	89 55 14             	mov    %edx,0x14(%ebp)
c010553c:	8b 00                	mov    (%eax),%eax
c010553e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105541:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105545:	89 04 24             	mov    %eax,(%esp)
c0105548:	8b 45 08             	mov    0x8(%ebp),%eax
c010554b:	ff d0                	call   *%eax
            break;
c010554d:	e9 ac 02 00 00       	jmp    c01057fe <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105552:	8b 45 14             	mov    0x14(%ebp),%eax
c0105555:	8d 50 04             	lea    0x4(%eax),%edx
c0105558:	89 55 14             	mov    %edx,0x14(%ebp)
c010555b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010555d:	85 db                	test   %ebx,%ebx
c010555f:	79 02                	jns    c0105563 <vprintfmt+0x143>
                err = -err;
c0105561:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105563:	83 fb 06             	cmp    $0x6,%ebx
c0105566:	7f 0b                	jg     c0105573 <vprintfmt+0x153>
c0105568:	8b 34 9d 28 6f 10 c0 	mov    -0x3fef90d8(,%ebx,4),%esi
c010556f:	85 f6                	test   %esi,%esi
c0105571:	75 23                	jne    c0105596 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105573:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105577:	c7 44 24 08 55 6f 10 	movl   $0xc0106f55,0x8(%esp)
c010557e:	c0 
c010557f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105582:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105586:	8b 45 08             	mov    0x8(%ebp),%eax
c0105589:	89 04 24             	mov    %eax,(%esp)
c010558c:	e8 61 fe ff ff       	call   c01053f2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105591:	e9 68 02 00 00       	jmp    c01057fe <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105596:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010559a:	c7 44 24 08 5e 6f 10 	movl   $0xc0106f5e,0x8(%esp)
c01055a1:	c0 
c01055a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055ac:	89 04 24             	mov    %eax,(%esp)
c01055af:	e8 3e fe ff ff       	call   c01053f2 <printfmt>
            }
            break;
c01055b4:	e9 45 02 00 00       	jmp    c01057fe <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01055b9:	8b 45 14             	mov    0x14(%ebp),%eax
c01055bc:	8d 50 04             	lea    0x4(%eax),%edx
c01055bf:	89 55 14             	mov    %edx,0x14(%ebp)
c01055c2:	8b 30                	mov    (%eax),%esi
c01055c4:	85 f6                	test   %esi,%esi
c01055c6:	75 05                	jne    c01055cd <vprintfmt+0x1ad>
                p = "(null)";
c01055c8:	be 61 6f 10 c0       	mov    $0xc0106f61,%esi
            }
            if (width > 0 && padc != '-') {
c01055cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01055d1:	7e 3e                	jle    c0105611 <vprintfmt+0x1f1>
c01055d3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01055d7:	74 38                	je     c0105611 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01055d9:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01055dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e3:	89 34 24             	mov    %esi,(%esp)
c01055e6:	e8 15 03 00 00       	call   c0105900 <strnlen>
c01055eb:	29 c3                	sub    %eax,%ebx
c01055ed:	89 d8                	mov    %ebx,%eax
c01055ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055f2:	eb 17                	jmp    c010560b <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01055f4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01055f8:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055fb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055ff:	89 04 24             	mov    %eax,(%esp)
c0105602:	8b 45 08             	mov    0x8(%ebp),%eax
c0105605:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105607:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010560b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010560f:	7f e3                	jg     c01055f4 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105611:	eb 38                	jmp    c010564b <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105613:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105617:	74 1f                	je     c0105638 <vprintfmt+0x218>
c0105619:	83 fb 1f             	cmp    $0x1f,%ebx
c010561c:	7e 05                	jle    c0105623 <vprintfmt+0x203>
c010561e:	83 fb 7e             	cmp    $0x7e,%ebx
c0105621:	7e 15                	jle    c0105638 <vprintfmt+0x218>
                    putch('?', putdat);
c0105623:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105626:	89 44 24 04          	mov    %eax,0x4(%esp)
c010562a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105631:	8b 45 08             	mov    0x8(%ebp),%eax
c0105634:	ff d0                	call   *%eax
c0105636:	eb 0f                	jmp    c0105647 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105638:	8b 45 0c             	mov    0xc(%ebp),%eax
c010563b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010563f:	89 1c 24             	mov    %ebx,(%esp)
c0105642:	8b 45 08             	mov    0x8(%ebp),%eax
c0105645:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105647:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010564b:	89 f0                	mov    %esi,%eax
c010564d:	8d 70 01             	lea    0x1(%eax),%esi
c0105650:	0f b6 00             	movzbl (%eax),%eax
c0105653:	0f be d8             	movsbl %al,%ebx
c0105656:	85 db                	test   %ebx,%ebx
c0105658:	74 10                	je     c010566a <vprintfmt+0x24a>
c010565a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010565e:	78 b3                	js     c0105613 <vprintfmt+0x1f3>
c0105660:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105664:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105668:	79 a9                	jns    c0105613 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010566a:	eb 17                	jmp    c0105683 <vprintfmt+0x263>
                putch(' ', putdat);
c010566c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010566f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105673:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010567a:	8b 45 08             	mov    0x8(%ebp),%eax
c010567d:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010567f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105683:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105687:	7f e3                	jg     c010566c <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105689:	e9 70 01 00 00       	jmp    c01057fe <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010568e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105691:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105695:	8d 45 14             	lea    0x14(%ebp),%eax
c0105698:	89 04 24             	mov    %eax,(%esp)
c010569b:	e8 0b fd ff ff       	call   c01053ab <getint>
c01056a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01056a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056ac:	85 d2                	test   %edx,%edx
c01056ae:	79 26                	jns    c01056d6 <vprintfmt+0x2b6>
                putch('-', putdat);
c01056b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056b7:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01056be:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c1:	ff d0                	call   *%eax
                num = -(long long)num;
c01056c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01056c9:	f7 d8                	neg    %eax
c01056cb:	83 d2 00             	adc    $0x0,%edx
c01056ce:	f7 da                	neg    %edx
c01056d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01056d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01056dd:	e9 a8 00 00 00       	jmp    c010578a <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01056e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01056e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056e9:	8d 45 14             	lea    0x14(%ebp),%eax
c01056ec:	89 04 24             	mov    %eax,(%esp)
c01056ef:	e8 68 fc ff ff       	call   c010535c <getuint>
c01056f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01056f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01056fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105701:	e9 84 00 00 00       	jmp    c010578a <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105706:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105709:	89 44 24 04          	mov    %eax,0x4(%esp)
c010570d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105710:	89 04 24             	mov    %eax,(%esp)
c0105713:	e8 44 fc ff ff       	call   c010535c <getuint>
c0105718:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010571b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010571e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105725:	eb 63                	jmp    c010578a <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105727:	8b 45 0c             	mov    0xc(%ebp),%eax
c010572a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010572e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105735:	8b 45 08             	mov    0x8(%ebp),%eax
c0105738:	ff d0                	call   *%eax
            putch('x', putdat);
c010573a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010573d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105741:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105748:	8b 45 08             	mov    0x8(%ebp),%eax
c010574b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010574d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105750:	8d 50 04             	lea    0x4(%eax),%edx
c0105753:	89 55 14             	mov    %edx,0x14(%ebp)
c0105756:	8b 00                	mov    (%eax),%eax
c0105758:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010575b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105762:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105769:	eb 1f                	jmp    c010578a <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010576b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010576e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105772:	8d 45 14             	lea    0x14(%ebp),%eax
c0105775:	89 04 24             	mov    %eax,(%esp)
c0105778:	e8 df fb ff ff       	call   c010535c <getuint>
c010577d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105780:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105783:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010578a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010578e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105791:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105795:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105798:	89 54 24 14          	mov    %edx,0x14(%esp)
c010579c:	89 44 24 10          	mov    %eax,0x10(%esp)
c01057a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01057ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b8:	89 04 24             	mov    %eax,(%esp)
c01057bb:	e8 97 fa ff ff       	call   c0105257 <printnum>
            break;
c01057c0:	eb 3c                	jmp    c01057fe <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01057c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c9:	89 1c 24             	mov    %ebx,(%esp)
c01057cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cf:	ff d0                	call   *%eax
            break;
c01057d1:	eb 2b                	jmp    c01057fe <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01057d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057da:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01057e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057e4:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01057e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01057ea:	eb 04                	jmp    c01057f0 <vprintfmt+0x3d0>
c01057ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01057f0:	8b 45 10             	mov    0x10(%ebp),%eax
c01057f3:	83 e8 01             	sub    $0x1,%eax
c01057f6:	0f b6 00             	movzbl (%eax),%eax
c01057f9:	3c 25                	cmp    $0x25,%al
c01057fb:	75 ef                	jne    c01057ec <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01057fd:	90                   	nop
        }
    }
c01057fe:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057ff:	e9 3e fc ff ff       	jmp    c0105442 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105804:	83 c4 40             	add    $0x40,%esp
c0105807:	5b                   	pop    %ebx
c0105808:	5e                   	pop    %esi
c0105809:	5d                   	pop    %ebp
c010580a:	c3                   	ret    

c010580b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010580b:	55                   	push   %ebp
c010580c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010580e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105811:	8b 40 08             	mov    0x8(%eax),%eax
c0105814:	8d 50 01             	lea    0x1(%eax),%edx
c0105817:	8b 45 0c             	mov    0xc(%ebp),%eax
c010581a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010581d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105820:	8b 10                	mov    (%eax),%edx
c0105822:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105825:	8b 40 04             	mov    0x4(%eax),%eax
c0105828:	39 c2                	cmp    %eax,%edx
c010582a:	73 12                	jae    c010583e <sprintputch+0x33>
        *b->buf ++ = ch;
c010582c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582f:	8b 00                	mov    (%eax),%eax
c0105831:	8d 48 01             	lea    0x1(%eax),%ecx
c0105834:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105837:	89 0a                	mov    %ecx,(%edx)
c0105839:	8b 55 08             	mov    0x8(%ebp),%edx
c010583c:	88 10                	mov    %dl,(%eax)
    }
}
c010583e:	5d                   	pop    %ebp
c010583f:	c3                   	ret    

c0105840 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105840:	55                   	push   %ebp
c0105841:	89 e5                	mov    %esp,%ebp
c0105843:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105846:	8d 45 14             	lea    0x14(%ebp),%eax
c0105849:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010584c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010584f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105853:	8b 45 10             	mov    0x10(%ebp),%eax
c0105856:	89 44 24 08          	mov    %eax,0x8(%esp)
c010585a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010585d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105861:	8b 45 08             	mov    0x8(%ebp),%eax
c0105864:	89 04 24             	mov    %eax,(%esp)
c0105867:	e8 08 00 00 00       	call   c0105874 <vsnprintf>
c010586c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010586f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105872:	c9                   	leave  
c0105873:	c3                   	ret    

c0105874 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105874:	55                   	push   %ebp
c0105875:	89 e5                	mov    %esp,%ebp
c0105877:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010587a:	8b 45 08             	mov    0x8(%ebp),%eax
c010587d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105880:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105883:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105886:	8b 45 08             	mov    0x8(%ebp),%eax
c0105889:	01 d0                	add    %edx,%eax
c010588b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010588e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105895:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105899:	74 0a                	je     c01058a5 <vsnprintf+0x31>
c010589b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010589e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058a1:	39 c2                	cmp    %eax,%edx
c01058a3:	76 07                	jbe    c01058ac <vsnprintf+0x38>
        return -E_INVAL;
c01058a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01058aa:	eb 2a                	jmp    c01058d6 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01058ac:	8b 45 14             	mov    0x14(%ebp),%eax
c01058af:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058b3:	8b 45 10             	mov    0x10(%ebp),%eax
c01058b6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01058bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058c1:	c7 04 24 0b 58 10 c0 	movl   $0xc010580b,(%esp)
c01058c8:	e8 53 fb ff ff       	call   c0105420 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01058cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058d0:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01058d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058d6:	c9                   	leave  
c01058d7:	c3                   	ret    

c01058d8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01058d8:	55                   	push   %ebp
c01058d9:	89 e5                	mov    %esp,%ebp
c01058db:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01058de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01058e5:	eb 04                	jmp    c01058eb <strlen+0x13>
        cnt ++;
c01058e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01058eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ee:	8d 50 01             	lea    0x1(%eax),%edx
c01058f1:	89 55 08             	mov    %edx,0x8(%ebp)
c01058f4:	0f b6 00             	movzbl (%eax),%eax
c01058f7:	84 c0                	test   %al,%al
c01058f9:	75 ec                	jne    c01058e7 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01058fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01058fe:	c9                   	leave  
c01058ff:	c3                   	ret    

c0105900 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105900:	55                   	push   %ebp
c0105901:	89 e5                	mov    %esp,%ebp
c0105903:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105906:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010590d:	eb 04                	jmp    c0105913 <strnlen+0x13>
        cnt ++;
c010590f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105913:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105916:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105919:	73 10                	jae    c010592b <strnlen+0x2b>
c010591b:	8b 45 08             	mov    0x8(%ebp),%eax
c010591e:	8d 50 01             	lea    0x1(%eax),%edx
c0105921:	89 55 08             	mov    %edx,0x8(%ebp)
c0105924:	0f b6 00             	movzbl (%eax),%eax
c0105927:	84 c0                	test   %al,%al
c0105929:	75 e4                	jne    c010590f <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010592b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010592e:	c9                   	leave  
c010592f:	c3                   	ret    

c0105930 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105930:	55                   	push   %ebp
c0105931:	89 e5                	mov    %esp,%ebp
c0105933:	57                   	push   %edi
c0105934:	56                   	push   %esi
c0105935:	83 ec 20             	sub    $0x20,%esp
c0105938:	8b 45 08             	mov    0x8(%ebp),%eax
c010593b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010593e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105941:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105944:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105947:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010594a:	89 d1                	mov    %edx,%ecx
c010594c:	89 c2                	mov    %eax,%edx
c010594e:	89 ce                	mov    %ecx,%esi
c0105950:	89 d7                	mov    %edx,%edi
c0105952:	ac                   	lods   %ds:(%esi),%al
c0105953:	aa                   	stos   %al,%es:(%edi)
c0105954:	84 c0                	test   %al,%al
c0105956:	75 fa                	jne    c0105952 <strcpy+0x22>
c0105958:	89 fa                	mov    %edi,%edx
c010595a:	89 f1                	mov    %esi,%ecx
c010595c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010595f:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105962:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105965:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105968:	83 c4 20             	add    $0x20,%esp
c010596b:	5e                   	pop    %esi
c010596c:	5f                   	pop    %edi
c010596d:	5d                   	pop    %ebp
c010596e:	c3                   	ret    

c010596f <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010596f:	55                   	push   %ebp
c0105970:	89 e5                	mov    %esp,%ebp
c0105972:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105975:	8b 45 08             	mov    0x8(%ebp),%eax
c0105978:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010597b:	eb 21                	jmp    c010599e <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010597d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105980:	0f b6 10             	movzbl (%eax),%edx
c0105983:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105986:	88 10                	mov    %dl,(%eax)
c0105988:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010598b:	0f b6 00             	movzbl (%eax),%eax
c010598e:	84 c0                	test   %al,%al
c0105990:	74 04                	je     c0105996 <strncpy+0x27>
            src ++;
c0105992:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105996:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010599a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010599e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01059a2:	75 d9                	jne    c010597d <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01059a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01059a7:	c9                   	leave  
c01059a8:	c3                   	ret    

c01059a9 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01059a9:	55                   	push   %ebp
c01059aa:	89 e5                	mov    %esp,%ebp
c01059ac:	57                   	push   %edi
c01059ad:	56                   	push   %esi
c01059ae:	83 ec 20             	sub    $0x20,%esp
c01059b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01059bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059c3:	89 d1                	mov    %edx,%ecx
c01059c5:	89 c2                	mov    %eax,%edx
c01059c7:	89 ce                	mov    %ecx,%esi
c01059c9:	89 d7                	mov    %edx,%edi
c01059cb:	ac                   	lods   %ds:(%esi),%al
c01059cc:	ae                   	scas   %es:(%edi),%al
c01059cd:	75 08                	jne    c01059d7 <strcmp+0x2e>
c01059cf:	84 c0                	test   %al,%al
c01059d1:	75 f8                	jne    c01059cb <strcmp+0x22>
c01059d3:	31 c0                	xor    %eax,%eax
c01059d5:	eb 04                	jmp    c01059db <strcmp+0x32>
c01059d7:	19 c0                	sbb    %eax,%eax
c01059d9:	0c 01                	or     $0x1,%al
c01059db:	89 fa                	mov    %edi,%edx
c01059dd:	89 f1                	mov    %esi,%ecx
c01059df:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01059e2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01059e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01059e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01059eb:	83 c4 20             	add    $0x20,%esp
c01059ee:	5e                   	pop    %esi
c01059ef:	5f                   	pop    %edi
c01059f0:	5d                   	pop    %ebp
c01059f1:	c3                   	ret    

c01059f2 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01059f2:	55                   	push   %ebp
c01059f3:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01059f5:	eb 0c                	jmp    c0105a03 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01059f7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01059ff:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105a03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a07:	74 1a                	je     c0105a23 <strncmp+0x31>
c0105a09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a0c:	0f b6 00             	movzbl (%eax),%eax
c0105a0f:	84 c0                	test   %al,%al
c0105a11:	74 10                	je     c0105a23 <strncmp+0x31>
c0105a13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a16:	0f b6 10             	movzbl (%eax),%edx
c0105a19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1c:	0f b6 00             	movzbl (%eax),%eax
c0105a1f:	38 c2                	cmp    %al,%dl
c0105a21:	74 d4                	je     c01059f7 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a27:	74 18                	je     c0105a41 <strncmp+0x4f>
c0105a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a2c:	0f b6 00             	movzbl (%eax),%eax
c0105a2f:	0f b6 d0             	movzbl %al,%edx
c0105a32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a35:	0f b6 00             	movzbl (%eax),%eax
c0105a38:	0f b6 c0             	movzbl %al,%eax
c0105a3b:	29 c2                	sub    %eax,%edx
c0105a3d:	89 d0                	mov    %edx,%eax
c0105a3f:	eb 05                	jmp    c0105a46 <strncmp+0x54>
c0105a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a46:	5d                   	pop    %ebp
c0105a47:	c3                   	ret    

c0105a48 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105a48:	55                   	push   %ebp
c0105a49:	89 e5                	mov    %esp,%ebp
c0105a4b:	83 ec 04             	sub    $0x4,%esp
c0105a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a51:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105a54:	eb 14                	jmp    c0105a6a <strchr+0x22>
        if (*s == c) {
c0105a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a59:	0f b6 00             	movzbl (%eax),%eax
c0105a5c:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105a5f:	75 05                	jne    c0105a66 <strchr+0x1e>
            return (char *)s;
c0105a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a64:	eb 13                	jmp    c0105a79 <strchr+0x31>
        }
        s ++;
c0105a66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a6d:	0f b6 00             	movzbl (%eax),%eax
c0105a70:	84 c0                	test   %al,%al
c0105a72:	75 e2                	jne    c0105a56 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a79:	c9                   	leave  
c0105a7a:	c3                   	ret    

c0105a7b <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105a7b:	55                   	push   %ebp
c0105a7c:	89 e5                	mov    %esp,%ebp
c0105a7e:	83 ec 04             	sub    $0x4,%esp
c0105a81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a84:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105a87:	eb 11                	jmp    c0105a9a <strfind+0x1f>
        if (*s == c) {
c0105a89:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8c:	0f b6 00             	movzbl (%eax),%eax
c0105a8f:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105a92:	75 02                	jne    c0105a96 <strfind+0x1b>
            break;
c0105a94:	eb 0e                	jmp    c0105aa4 <strfind+0x29>
        }
        s ++;
c0105a96:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a9d:	0f b6 00             	movzbl (%eax),%eax
c0105aa0:	84 c0                	test   %al,%al
c0105aa2:	75 e5                	jne    c0105a89 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105aa7:	c9                   	leave  
c0105aa8:	c3                   	ret    

c0105aa9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105aa9:	55                   	push   %ebp
c0105aaa:	89 e5                	mov    %esp,%ebp
c0105aac:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105aaf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105ab6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105abd:	eb 04                	jmp    c0105ac3 <strtol+0x1a>
        s ++;
c0105abf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105ac3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac6:	0f b6 00             	movzbl (%eax),%eax
c0105ac9:	3c 20                	cmp    $0x20,%al
c0105acb:	74 f2                	je     c0105abf <strtol+0x16>
c0105acd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ad0:	0f b6 00             	movzbl (%eax),%eax
c0105ad3:	3c 09                	cmp    $0x9,%al
c0105ad5:	74 e8                	je     c0105abf <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ada:	0f b6 00             	movzbl (%eax),%eax
c0105add:	3c 2b                	cmp    $0x2b,%al
c0105adf:	75 06                	jne    c0105ae7 <strtol+0x3e>
        s ++;
c0105ae1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ae5:	eb 15                	jmp    c0105afc <strtol+0x53>
    }
    else if (*s == '-') {
c0105ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aea:	0f b6 00             	movzbl (%eax),%eax
c0105aed:	3c 2d                	cmp    $0x2d,%al
c0105aef:	75 0b                	jne    c0105afc <strtol+0x53>
        s ++, neg = 1;
c0105af1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105af5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105afc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b00:	74 06                	je     c0105b08 <strtol+0x5f>
c0105b02:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105b06:	75 24                	jne    c0105b2c <strtol+0x83>
c0105b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b0b:	0f b6 00             	movzbl (%eax),%eax
c0105b0e:	3c 30                	cmp    $0x30,%al
c0105b10:	75 1a                	jne    c0105b2c <strtol+0x83>
c0105b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b15:	83 c0 01             	add    $0x1,%eax
c0105b18:	0f b6 00             	movzbl (%eax),%eax
c0105b1b:	3c 78                	cmp    $0x78,%al
c0105b1d:	75 0d                	jne    c0105b2c <strtol+0x83>
        s += 2, base = 16;
c0105b1f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105b23:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105b2a:	eb 2a                	jmp    c0105b56 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105b2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b30:	75 17                	jne    c0105b49 <strtol+0xa0>
c0105b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b35:	0f b6 00             	movzbl (%eax),%eax
c0105b38:	3c 30                	cmp    $0x30,%al
c0105b3a:	75 0d                	jne    c0105b49 <strtol+0xa0>
        s ++, base = 8;
c0105b3c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b40:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105b47:	eb 0d                	jmp    c0105b56 <strtol+0xad>
    }
    else if (base == 0) {
c0105b49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b4d:	75 07                	jne    c0105b56 <strtol+0xad>
        base = 10;
c0105b4f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105b56:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b59:	0f b6 00             	movzbl (%eax),%eax
c0105b5c:	3c 2f                	cmp    $0x2f,%al
c0105b5e:	7e 1b                	jle    c0105b7b <strtol+0xd2>
c0105b60:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b63:	0f b6 00             	movzbl (%eax),%eax
c0105b66:	3c 39                	cmp    $0x39,%al
c0105b68:	7f 11                	jg     c0105b7b <strtol+0xd2>
            dig = *s - '0';
c0105b6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6d:	0f b6 00             	movzbl (%eax),%eax
c0105b70:	0f be c0             	movsbl %al,%eax
c0105b73:	83 e8 30             	sub    $0x30,%eax
c0105b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b79:	eb 48                	jmp    c0105bc3 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105b7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7e:	0f b6 00             	movzbl (%eax),%eax
c0105b81:	3c 60                	cmp    $0x60,%al
c0105b83:	7e 1b                	jle    c0105ba0 <strtol+0xf7>
c0105b85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b88:	0f b6 00             	movzbl (%eax),%eax
c0105b8b:	3c 7a                	cmp    $0x7a,%al
c0105b8d:	7f 11                	jg     c0105ba0 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105b8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b92:	0f b6 00             	movzbl (%eax),%eax
c0105b95:	0f be c0             	movsbl %al,%eax
c0105b98:	83 e8 57             	sub    $0x57,%eax
c0105b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b9e:	eb 23                	jmp    c0105bc3 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105ba0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba3:	0f b6 00             	movzbl (%eax),%eax
c0105ba6:	3c 40                	cmp    $0x40,%al
c0105ba8:	7e 3d                	jle    c0105be7 <strtol+0x13e>
c0105baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bad:	0f b6 00             	movzbl (%eax),%eax
c0105bb0:	3c 5a                	cmp    $0x5a,%al
c0105bb2:	7f 33                	jg     c0105be7 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105bb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb7:	0f b6 00             	movzbl (%eax),%eax
c0105bba:	0f be c0             	movsbl %al,%eax
c0105bbd:	83 e8 37             	sub    $0x37,%eax
c0105bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bc6:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105bc9:	7c 02                	jl     c0105bcd <strtol+0x124>
            break;
c0105bcb:	eb 1a                	jmp    c0105be7 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105bcd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105bd4:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105bd8:	89 c2                	mov    %eax,%edx
c0105bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bdd:	01 d0                	add    %edx,%eax
c0105bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105be2:	e9 6f ff ff ff       	jmp    c0105b56 <strtol+0xad>

    if (endptr) {
c0105be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105beb:	74 08                	je     c0105bf5 <strtol+0x14c>
        *endptr = (char *) s;
c0105bed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bf0:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bf3:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105bf5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105bf9:	74 07                	je     c0105c02 <strtol+0x159>
c0105bfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105bfe:	f7 d8                	neg    %eax
c0105c00:	eb 03                	jmp    c0105c05 <strtol+0x15c>
c0105c02:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105c05:	c9                   	leave  
c0105c06:	c3                   	ret    

c0105c07 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105c07:	55                   	push   %ebp
c0105c08:	89 e5                	mov    %esp,%ebp
c0105c0a:	57                   	push   %edi
c0105c0b:	83 ec 24             	sub    $0x24,%esp
c0105c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c11:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105c14:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105c18:	8b 55 08             	mov    0x8(%ebp),%edx
c0105c1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105c1e:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105c21:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105c27:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105c2a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105c2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105c31:	89 d7                	mov    %edx,%edi
c0105c33:	f3 aa                	rep stos %al,%es:(%edi)
c0105c35:	89 fa                	mov    %edi,%edx
c0105c37:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105c3a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105c3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105c40:	83 c4 24             	add    $0x24,%esp
c0105c43:	5f                   	pop    %edi
c0105c44:	5d                   	pop    %ebp
c0105c45:	c3                   	ret    

c0105c46 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105c46:	55                   	push   %ebp
c0105c47:	89 e5                	mov    %esp,%ebp
c0105c49:	57                   	push   %edi
c0105c4a:	56                   	push   %esi
c0105c4b:	53                   	push   %ebx
c0105c4c:	83 ec 30             	sub    $0x30,%esp
c0105c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c58:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c5b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c5e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c64:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105c67:	73 42                	jae    c0105cab <memmove+0x65>
c0105c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105c75:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105c78:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105c7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c7e:	c1 e8 02             	shr    $0x2,%eax
c0105c81:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105c83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c89:	89 d7                	mov    %edx,%edi
c0105c8b:	89 c6                	mov    %eax,%esi
c0105c8d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105c8f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105c92:	83 e1 03             	and    $0x3,%ecx
c0105c95:	74 02                	je     c0105c99 <memmove+0x53>
c0105c97:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105c99:	89 f0                	mov    %esi,%eax
c0105c9b:	89 fa                	mov    %edi,%edx
c0105c9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105ca0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105ca3:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ca9:	eb 36                	jmp    c0105ce1 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cae:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105cb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105cb4:	01 c2                	add    %eax,%edx
c0105cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cb9:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cbf:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105cc5:	89 c1                	mov    %eax,%ecx
c0105cc7:	89 d8                	mov    %ebx,%eax
c0105cc9:	89 d6                	mov    %edx,%esi
c0105ccb:	89 c7                	mov    %eax,%edi
c0105ccd:	fd                   	std    
c0105cce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105cd0:	fc                   	cld    
c0105cd1:	89 f8                	mov    %edi,%eax
c0105cd3:	89 f2                	mov    %esi,%edx
c0105cd5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105cd8:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105cdb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ce1:	83 c4 30             	add    $0x30,%esp
c0105ce4:	5b                   	pop    %ebx
c0105ce5:	5e                   	pop    %esi
c0105ce6:	5f                   	pop    %edi
c0105ce7:	5d                   	pop    %ebp
c0105ce8:	c3                   	ret    

c0105ce9 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ce9:	55                   	push   %ebp
c0105cea:	89 e5                	mov    %esp,%ebp
c0105cec:	57                   	push   %edi
c0105ced:	56                   	push   %esi
c0105cee:	83 ec 20             	sub    $0x20,%esp
c0105cf1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cfd:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d00:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d06:	c1 e8 02             	shr    $0x2,%eax
c0105d09:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d11:	89 d7                	mov    %edx,%edi
c0105d13:	89 c6                	mov    %eax,%esi
c0105d15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105d17:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105d1a:	83 e1 03             	and    $0x3,%ecx
c0105d1d:	74 02                	je     c0105d21 <memcpy+0x38>
c0105d1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105d21:	89 f0                	mov    %esi,%eax
c0105d23:	89 fa                	mov    %edi,%edx
c0105d25:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105d2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105d31:	83 c4 20             	add    $0x20,%esp
c0105d34:	5e                   	pop    %esi
c0105d35:	5f                   	pop    %edi
c0105d36:	5d                   	pop    %ebp
c0105d37:	c3                   	ret    

c0105d38 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105d38:	55                   	push   %ebp
c0105d39:	89 e5                	mov    %esp,%ebp
c0105d3b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105d3e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d41:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105d44:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d47:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105d4a:	eb 30                	jmp    c0105d7c <memcmp+0x44>
        if (*s1 != *s2) {
c0105d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d4f:	0f b6 10             	movzbl (%eax),%edx
c0105d52:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d55:	0f b6 00             	movzbl (%eax),%eax
c0105d58:	38 c2                	cmp    %al,%dl
c0105d5a:	74 18                	je     c0105d74 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d5f:	0f b6 00             	movzbl (%eax),%eax
c0105d62:	0f b6 d0             	movzbl %al,%edx
c0105d65:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d68:	0f b6 00             	movzbl (%eax),%eax
c0105d6b:	0f b6 c0             	movzbl %al,%eax
c0105d6e:	29 c2                	sub    %eax,%edx
c0105d70:	89 d0                	mov    %edx,%eax
c0105d72:	eb 1a                	jmp    c0105d8e <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105d74:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105d78:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105d7c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d7f:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105d82:	89 55 10             	mov    %edx,0x10(%ebp)
c0105d85:	85 c0                	test   %eax,%eax
c0105d87:	75 c3                	jne    c0105d4c <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105d8e:	c9                   	leave  
c0105d8f:	c3                   	ret    
