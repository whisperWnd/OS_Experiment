
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba 28 af 11 00       	mov    $0x11af28,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 01 5c 00 00       	call   105c63 <memset>

    cons_init();                // init the console
  100062:	e8 7c 15 00 00       	call   1015e3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 00 5e 10 00 	movl   $0x105e00,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 1c 5e 10 00 	movl   $0x105e1c,(%esp)
  10007c:	e8 c7 02 00 00       	call   100348 <cprintf>

    print_kerninfo();
  100081:	e8 f6 07 00 00       	call   10087c <print_kerninfo>

    grade_backtrace();
  100086:	e8 86 00 00 00       	call   100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 cd 42 00 00       	call   10435d <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 b7 16 00 00       	call   10174c <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 09 18 00 00       	call   1018a3 <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 fa 0c 00 00       	call   100d99 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 16 16 00 00       	call   1016ba <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b3:	00 
  1000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bb:	00 
  1000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c3:	e8 f2 0b 00 00       	call   100cba <mon_backtrace>
}
  1000c8:	c9                   	leave  
  1000c9:	c3                   	ret    

001000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000ca:	55                   	push   %ebp
  1000cb:	89 e5                	mov    %esp,%ebp
  1000cd:	53                   	push   %ebx
  1000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000d7:	8d 55 08             	lea    0x8(%ebp),%edx
  1000da:	8b 45 08             	mov    0x8(%ebp),%eax
  1000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e9:	89 04 24             	mov    %eax,(%esp)
  1000ec:	e8 b5 ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000f1:	83 c4 14             	add    $0x14,%esp
  1000f4:	5b                   	pop    %ebx
  1000f5:	5d                   	pop    %ebp
  1000f6:	c3                   	ret    

001000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f7:	55                   	push   %ebp
  1000f8:	89 e5                	mov    %esp,%ebp
  1000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100100:	89 44 24 04          	mov    %eax,0x4(%esp)
  100104:	8b 45 08             	mov    0x8(%ebp),%eax
  100107:	89 04 24             	mov    %eax,(%esp)
  10010a:	e8 bb ff ff ff       	call   1000ca <grade_backtrace1>
}
  10010f:	c9                   	leave  
  100110:	c3                   	ret    

00100111 <grade_backtrace>:

void
grade_backtrace(void) {
  100111:	55                   	push   %ebp
  100112:	89 e5                	mov    %esp,%ebp
  100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100117:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100123:	ff 
  100124:	89 44 24 04          	mov    %eax,0x4(%esp)
  100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10012f:	e8 c3 ff ff ff       	call   1000f7 <grade_backtrace0>
}
  100134:	c9                   	leave  
  100135:	c3                   	ret    

00100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100136:	55                   	push   %ebp
  100137:	89 e5                	mov    %esp,%ebp
  100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014c:	0f b7 c0             	movzwl %ax,%eax
  10014f:	83 e0 03             	and    $0x3,%eax
  100152:	89 c2                	mov    %eax,%edx
  100154:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100159:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100161:	c7 04 24 21 5e 10 00 	movl   $0x105e21,(%esp)
  100168:	e8 db 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100171:	0f b7 d0             	movzwl %ax,%edx
  100174:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100179:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100181:	c7 04 24 2f 5e 10 00 	movl   $0x105e2f,(%esp)
  100188:	e8 bb 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100191:	0f b7 d0             	movzwl %ax,%edx
  100194:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100199:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a1:	c7 04 24 3d 5e 10 00 	movl   $0x105e3d,(%esp)
  1001a8:	e8 9b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b1:	0f b7 d0             	movzwl %ax,%edx
  1001b4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 4b 5e 10 00 	movl   $0x105e4b,(%esp)
  1001c8:	e8 7b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d1:	0f b7 d0             	movzwl %ax,%edx
  1001d4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e1:	c7 04 24 59 5e 10 00 	movl   $0x105e59,(%esp)
  1001e8:	e8 5b 01 00 00       	call   100348 <cprintf>
    round ++;
  1001ed:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001f2:	83 c0 01             	add    $0x1,%eax
  1001f5:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001fa:	c9                   	leave  
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001ff:	5d                   	pop    %ebp
  100200:	c3                   	ret    

00100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100201:	55                   	push   %ebp
  100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100204:	5d                   	pop    %ebp
  100205:	c3                   	ret    

00100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100206:	55                   	push   %ebp
  100207:	89 e5                	mov    %esp,%ebp
  100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020c:	e8 25 ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100211:	c7 04 24 68 5e 10 00 	movl   $0x105e68,(%esp)
  100218:	e8 2b 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_user();
  10021d:	e8 da ff ff ff       	call   1001fc <lab1_switch_to_user>
    lab1_print_cur_status();
  100222:	e8 0f ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100227:	c7 04 24 88 5e 10 00 	movl   $0x105e88,(%esp)
  10022e:	e8 15 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_kernel();
  100233:	e8 c9 ff ff ff       	call   100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100238:	e8 f9 fe ff ff       	call   100136 <lab1_print_cur_status>
}
  10023d:	c9                   	leave  
  10023e:	c3                   	ret    

0010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10023f:	55                   	push   %ebp
  100240:	89 e5                	mov    %esp,%ebp
  100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100249:	74 13                	je     10025e <readline+0x1f>
        cprintf("%s", prompt);
  10024b:	8b 45 08             	mov    0x8(%ebp),%eax
  10024e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100252:	c7 04 24 a7 5e 10 00 	movl   $0x105ea7,(%esp)
  100259:	e8 ea 00 00 00       	call   100348 <cprintf>
    }
    int i = 0, c;
  10025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100265:	e8 66 01 00 00       	call   1003d0 <getchar>
  10026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100271:	79 07                	jns    10027a <readline+0x3b>
            return NULL;
  100273:	b8 00 00 00 00       	mov    $0x0,%eax
  100278:	eb 79                	jmp    1002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027e:	7e 28                	jle    1002a8 <readline+0x69>
  100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100287:	7f 1f                	jg     1002a8 <readline+0x69>
            cputchar(c);
  100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028c:	89 04 24             	mov    %eax,(%esp)
  10028f:	e8 da 00 00 00       	call   10036e <cputchar>
            buf[i ++] = c;
  100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100297:	8d 50 01             	lea    0x1(%eax),%edx
  10029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a0:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  1002a6:	eb 46                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002ac:	75 17                	jne    1002c5 <readline+0x86>
  1002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002b2:	7e 11                	jle    1002c5 <readline+0x86>
            cputchar(c);
  1002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b7:	89 04 24             	mov    %eax,(%esp)
  1002ba:	e8 af 00 00 00       	call   10036e <cputchar>
            i --;
  1002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002c3:	eb 29                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c9:	74 06                	je     1002d1 <readline+0x92>
  1002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002cf:	75 1d                	jne    1002ee <readline+0xaf>
            cputchar(c);
  1002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d4:	89 04 24             	mov    %eax,(%esp)
  1002d7:	e8 92 00 00 00       	call   10036e <cputchar>
            buf[i] = '\0';
  1002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002df:	05 20 a0 11 00       	add    $0x11a020,%eax
  1002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e7:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1002ec:	eb 05                	jmp    1002f3 <readline+0xb4>
        }
    }
  1002ee:	e9 72 ff ff ff       	jmp    100265 <readline+0x26>
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fe:	89 04 24             	mov    %eax,(%esp)
  100301:	e8 09 13 00 00       	call   10160f <cons_putc>
    (*cnt) ++;
  100306:	8b 45 0c             	mov    0xc(%ebp),%eax
  100309:	8b 00                	mov    (%eax),%eax
  10030b:	8d 50 01             	lea    0x1(%eax),%edx
  10030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100311:	89 10                	mov    %edx,(%eax)
}
  100313:	c9                   	leave  
  100314:	c3                   	ret    

00100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100315:	55                   	push   %ebp
  100316:	89 e5                	mov    %esp,%ebp
  100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100322:	8b 45 0c             	mov    0xc(%ebp),%eax
  100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100329:	8b 45 08             	mov    0x8(%ebp),%eax
  10032c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100333:	89 44 24 04          	mov    %eax,0x4(%esp)
  100337:	c7 04 24 f5 02 10 00 	movl   $0x1002f5,(%esp)
  10033e:	e8 39 51 00 00       	call   10547c <vprintfmt>
    return cnt;
  100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034e:	8d 45 0c             	lea    0xc(%ebp),%eax
  100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100357:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035b:	8b 45 08             	mov    0x8(%ebp),%eax
  10035e:	89 04 24             	mov    %eax,(%esp)
  100361:	e8 af ff ff ff       	call   100315 <vcprintf>
  100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036c:	c9                   	leave  
  10036d:	c3                   	ret    

0010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036e:	55                   	push   %ebp
  10036f:	89 e5                	mov    %esp,%ebp
  100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100374:	8b 45 08             	mov    0x8(%ebp),%eax
  100377:	89 04 24             	mov    %eax,(%esp)
  10037a:	e8 90 12 00 00       	call   10160f <cons_putc>
}
  10037f:	c9                   	leave  
  100380:	c3                   	ret    

00100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100381:	55                   	push   %ebp
  100382:	89 e5                	mov    %esp,%ebp
  100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038e:	eb 13                	jmp    1003a3 <cputs+0x22>
        cputch(c, &cnt);
  100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100397:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039b:	89 04 24             	mov    %eax,(%esp)
  10039e:	e8 52 ff ff ff       	call   1002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a6:	8d 50 01             	lea    0x1(%eax),%edx
  1003a9:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ac:	0f b6 00             	movzbl (%eax),%eax
  1003af:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b6:	75 d8                	jne    100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003c6:	e8 2a ff ff ff       	call   1002f5 <cputch>
    return cnt;
  1003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ce:	c9                   	leave  
  1003cf:	c3                   	ret    

001003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d0:	55                   	push   %ebp
  1003d1:	89 e5                	mov    %esp,%ebp
  1003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003d6:	e8 70 12 00 00       	call   10164b <cons_getc>
  1003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e2:	74 f2                	je     1003d6 <getchar+0x6>
        /* do nothing */;
    return c;
  1003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003e7:	c9                   	leave  
  1003e8:	c3                   	ret    

001003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003e9:	55                   	push   %ebp
  1003ea:	89 e5                	mov    %esp,%ebp
  1003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f2:	8b 00                	mov    (%eax),%eax
  1003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1003fa:	8b 00                	mov    (%eax),%eax
  1003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100406:	e9 d2 00 00 00       	jmp    1004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100411:	01 d0                	add    %edx,%eax
  100413:	89 c2                	mov    %eax,%edx
  100415:	c1 ea 1f             	shr    $0x1f,%edx
  100418:	01 d0                	add    %edx,%eax
  10041a:	d1 f8                	sar    %eax
  10041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100425:	eb 04                	jmp    10042b <stab_binsearch+0x42>
            m --;
  100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100431:	7c 1f                	jl     100452 <stab_binsearch+0x69>
  100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100436:	89 d0                	mov    %edx,%eax
  100438:	01 c0                	add    %eax,%eax
  10043a:	01 d0                	add    %edx,%eax
  10043c:	c1 e0 02             	shl    $0x2,%eax
  10043f:	89 c2                	mov    %eax,%edx
  100441:	8b 45 08             	mov    0x8(%ebp),%eax
  100444:	01 d0                	add    %edx,%eax
  100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10044a:	0f b6 c0             	movzbl %al,%eax
  10044d:	3b 45 14             	cmp    0x14(%ebp),%eax
  100450:	75 d5                	jne    100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100458:	7d 0b                	jge    100465 <stab_binsearch+0x7c>
            l = true_m + 1;
  10045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045d:	83 c0 01             	add    $0x1,%eax
  100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100463:	eb 78                	jmp    1004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046f:	89 d0                	mov    %edx,%eax
  100471:	01 c0                	add    %eax,%eax
  100473:	01 d0                	add    %edx,%eax
  100475:	c1 e0 02             	shl    $0x2,%eax
  100478:	89 c2                	mov    %eax,%edx
  10047a:	8b 45 08             	mov    0x8(%ebp),%eax
  10047d:	01 d0                	add    %edx,%eax
  10047f:	8b 40 08             	mov    0x8(%eax),%eax
  100482:	3b 45 18             	cmp    0x18(%ebp),%eax
  100485:	73 13                	jae    10049a <stab_binsearch+0xb1>
            *region_left = m;
  100487:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100492:	83 c0 01             	add    $0x1,%eax
  100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100498:	eb 43                	jmp    1004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049d:	89 d0                	mov    %edx,%eax
  10049f:	01 c0                	add    %eax,%eax
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	c1 e0 02             	shl    $0x2,%eax
  1004a6:	89 c2                	mov    %eax,%edx
  1004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ab:	01 d0                	add    %edx,%eax
  1004ad:	8b 40 08             	mov    0x8(%eax),%eax
  1004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b3:	76 16                	jbe    1004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c3:	83 e8 01             	sub    $0x1,%eax
  1004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c9:	eb 12                	jmp    1004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d1:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e3:	0f 8e 22 ff ff ff    	jle    10040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004ed:	75 0f                	jne    1004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f2:	8b 00                	mov    (%eax),%eax
  1004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fa:	89 10                	mov    %edx,(%eax)
  1004fc:	eb 3f                	jmp    10053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  100501:	8b 00                	mov    (%eax),%eax
  100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100506:	eb 04                	jmp    10050c <stab_binsearch+0x123>
  100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050f:	8b 00                	mov    (%eax),%eax
  100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100514:	7d 1f                	jge    100535 <stab_binsearch+0x14c>
  100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100519:	89 d0                	mov    %edx,%eax
  10051b:	01 c0                	add    %eax,%eax
  10051d:	01 d0                	add    %edx,%eax
  10051f:	c1 e0 02             	shl    $0x2,%eax
  100522:	89 c2                	mov    %eax,%edx
  100524:	8b 45 08             	mov    0x8(%ebp),%eax
  100527:	01 d0                	add    %edx,%eax
  100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052d:	0f b6 c0             	movzbl %al,%eax
  100530:	3b 45 14             	cmp    0x14(%ebp),%eax
  100533:	75 d3                	jne    100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100535:	8b 45 0c             	mov    0xc(%ebp),%eax
  100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053b:	89 10                	mov    %edx,(%eax)
    }
}
  10053d:	c9                   	leave  
  10053e:	c3                   	ret    

0010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10053f:	55                   	push   %ebp
  100540:	89 e5                	mov    %esp,%ebp
  100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100545:	8b 45 0c             	mov    0xc(%ebp),%eax
  100548:	c7 00 ac 5e 10 00    	movl   $0x105eac,(%eax)
    info->eip_line = 0;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	c7 40 08 ac 5e 10 00 	movl   $0x105eac,0x8(%eax)
    info->eip_fn_namelen = 9;
  100562:	8b 45 0c             	mov    0xc(%ebp),%eax
  100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056f:	8b 55 08             	mov    0x8(%ebp),%edx
  100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100575:	8b 45 0c             	mov    0xc(%ebp),%eax
  100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10057f:	c7 45 f4 38 71 10 00 	movl   $0x107138,-0xc(%ebp)
    stab_end = __STAB_END__;
  100586:	c7 45 f0 34 1a 11 00 	movl   $0x111a34,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10058d:	c7 45 ec 35 1a 11 00 	movl   $0x111a35,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100594:	c7 45 e8 34 44 11 00 	movl   $0x114434,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a1:	76 0d                	jbe    1005b0 <debuginfo_eip+0x71>
  1005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a6:	83 e8 01             	sub    $0x1,%eax
  1005a9:	0f b6 00             	movzbl (%eax),%eax
  1005ac:	84 c0                	test   %al,%al
  1005ae:	74 0a                	je     1005ba <debuginfo_eip+0x7b>
        return -1;
  1005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b5:	e9 c0 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c7:	29 c2                	sub    %eax,%edx
  1005c9:	89 d0                	mov    %edx,%eax
  1005cb:	c1 f8 02             	sar    $0x2,%eax
  1005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d4:	83 e8 01             	sub    $0x1,%eax
  1005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005da:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e8:	00 
  1005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005fa:	89 04 24             	mov    %eax,(%esp)
  1005fd:	e8 e7 fd ff ff       	call   1003e9 <stab_binsearch>
    if (lfile == 0)
  100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100605:	85 c0                	test   %eax,%eax
  100607:	75 0a                	jne    100613 <debuginfo_eip+0xd4>
        return -1;
  100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10060e:	e9 67 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10061f:	8b 45 08             	mov    0x8(%ebp),%eax
  100622:	89 44 24 10          	mov    %eax,0x10(%esp)
  100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10062d:	00 
  10062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100631:	89 44 24 08          	mov    %eax,0x8(%esp)
  100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100638:	89 44 24 04          	mov    %eax,0x4(%esp)
  10063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063f:	89 04 24             	mov    %eax,(%esp)
  100642:	e8 a2 fd ff ff       	call   1003e9 <stab_binsearch>

    if (lfun <= rfun) {
  100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10064d:	39 c2                	cmp    %eax,%edx
  10064f:	7f 7c                	jg     1006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	89 d0                	mov    %edx,%eax
  100658:	01 c0                	add    %eax,%eax
  10065a:	01 d0                	add    %edx,%eax
  10065c:	c1 e0 02             	shl    $0x2,%eax
  10065f:	89 c2                	mov    %eax,%edx
  100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100664:	01 d0                	add    %edx,%eax
  100666:	8b 10                	mov    (%eax),%edx
  100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066e:	29 c1                	sub    %eax,%ecx
  100670:	89 c8                	mov    %ecx,%eax
  100672:	39 c2                	cmp    %eax,%edx
  100674:	73 22                	jae    100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100679:	89 c2                	mov    %eax,%edx
  10067b:	89 d0                	mov    %edx,%eax
  10067d:	01 c0                	add    %eax,%eax
  10067f:	01 d0                	add    %edx,%eax
  100681:	c1 e0 02             	shl    $0x2,%eax
  100684:	89 c2                	mov    %eax,%edx
  100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100689:	01 d0                	add    %edx,%eax
  10068b:	8b 10                	mov    (%eax),%edx
  10068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100690:	01 c2                	add    %eax,%edx
  100692:	8b 45 0c             	mov    0xc(%ebp),%eax
  100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069b:	89 c2                	mov    %eax,%edx
  10069d:	89 d0                	mov    %edx,%eax
  10069f:	01 c0                	add    %eax,%eax
  1006a1:	01 d0                	add    %edx,%eax
  1006a3:	c1 e0 02             	shl    $0x2,%eax
  1006a6:	89 c2                	mov    %eax,%edx
  1006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ab:	01 d0                	add    %edx,%eax
  1006ad:	8b 50 08             	mov    0x8(%eax),%edx
  1006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b9:	8b 40 10             	mov    0x10(%eax),%eax
  1006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006cb:	eb 15                	jmp    1006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e5:	8b 40 08             	mov    0x8(%eax),%eax
  1006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ef:	00 
  1006f0:	89 04 24             	mov    %eax,(%esp)
  1006f3:	e8 df 53 00 00       	call   105ad7 <strfind>
  1006f8:	89 c2                	mov    %eax,%edx
  1006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fd:	8b 40 08             	mov    0x8(%eax),%eax
  100700:	29 c2                	sub    %eax,%edx
  100702:	8b 45 0c             	mov    0xc(%ebp),%eax
  100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100708:	8b 45 08             	mov    0x8(%ebp),%eax
  10070b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100716:	00 
  100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100721:	89 44 24 04          	mov    %eax,0x4(%esp)
  100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100728:	89 04 24             	mov    %eax,(%esp)
  10072b:	e8 b9 fc ff ff       	call   1003e9 <stab_binsearch>
    if (lline <= rline) {
  100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100736:	39 c2                	cmp    %eax,%edx
  100738:	7f 24                	jg     10075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	89 d0                	mov    %edx,%eax
  100741:	01 c0                	add    %eax,%eax
  100743:	01 d0                	add    %edx,%eax
  100745:	c1 e0 02             	shl    $0x2,%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074d:	01 d0                	add    %edx,%eax
  10074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100753:	0f b7 d0             	movzwl %ax,%edx
  100756:	8b 45 0c             	mov    0xc(%ebp),%eax
  100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075c:	eb 13                	jmp    100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100763:	e9 12 01 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076b:	83 e8 01             	sub    $0x1,%eax
  10076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100777:	39 c2                	cmp    %eax,%edx
  100779:	7c 56                	jl     1007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077e:	89 c2                	mov    %eax,%edx
  100780:	89 d0                	mov    %edx,%eax
  100782:	01 c0                	add    %eax,%eax
  100784:	01 d0                	add    %edx,%eax
  100786:	c1 e0 02             	shl    $0x2,%eax
  100789:	89 c2                	mov    %eax,%edx
  10078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078e:	01 d0                	add    %edx,%eax
  100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100794:	3c 84                	cmp    $0x84,%al
  100796:	74 39                	je     1007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	89 d0                	mov    %edx,%eax
  10079f:	01 c0                	add    %eax,%eax
  1007a1:	01 d0                	add    %edx,%eax
  1007a3:	c1 e0 02             	shl    $0x2,%eax
  1007a6:	89 c2                	mov    %eax,%edx
  1007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ab:	01 d0                	add    %edx,%eax
  1007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b1:	3c 64                	cmp    $0x64,%al
  1007b3:	75 b3                	jne    100768 <debuginfo_eip+0x229>
  1007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	89 d0                	mov    %edx,%eax
  1007bc:	01 c0                	add    %eax,%eax
  1007be:	01 d0                	add    %edx,%eax
  1007c0:	c1 e0 02             	shl    $0x2,%eax
  1007c3:	89 c2                	mov    %eax,%edx
  1007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	8b 40 08             	mov    0x8(%eax),%eax
  1007cd:	85 c0                	test   %eax,%eax
  1007cf:	74 97                	je     100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d7:	39 c2                	cmp    %eax,%edx
  1007d9:	7c 46                	jl     100821 <debuginfo_eip+0x2e2>
  1007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007de:	89 c2                	mov    %eax,%edx
  1007e0:	89 d0                	mov    %edx,%eax
  1007e2:	01 c0                	add    %eax,%eax
  1007e4:	01 d0                	add    %edx,%eax
  1007e6:	c1 e0 02             	shl    $0x2,%eax
  1007e9:	89 c2                	mov    %eax,%edx
  1007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ee:	01 d0                	add    %edx,%eax
  1007f0:	8b 10                	mov    (%eax),%edx
  1007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f8:	29 c1                	sub    %eax,%ecx
  1007fa:	89 c8                	mov    %ecx,%eax
  1007fc:	39 c2                	cmp    %eax,%edx
  1007fe:	73 21                	jae    100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	8b 10                	mov    (%eax),%edx
  100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10081a:	01 c2                	add    %eax,%edx
  10081c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100827:	39 c2                	cmp    %eax,%edx
  100829:	7d 4a                	jge    100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082e:	83 c0 01             	add    $0x1,%eax
  100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100834:	eb 18                	jmp    10084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100836:	8b 45 0c             	mov    0xc(%ebp),%eax
  100839:	8b 40 14             	mov    0x14(%eax),%eax
  10083c:	8d 50 01             	lea    0x1(%eax),%edx
  10083f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100848:	83 c0 01             	add    $0x1,%eax
  10084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100854:	39 c2                	cmp    %eax,%edx
  100856:	7d 1d                	jge    100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	89 d0                	mov    %edx,%eax
  10085f:	01 c0                	add    %eax,%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	c1 e0 02             	shl    $0x2,%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100871:	3c a0                	cmp    $0xa0,%al
  100873:	74 c1                	je     100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10087a:	c9                   	leave  
  10087b:	c3                   	ret    

0010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10087c:	55                   	push   %ebp
  10087d:	89 e5                	mov    %esp,%ebp
  10087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100882:	c7 04 24 b6 5e 10 00 	movl   $0x105eb6,(%esp)
  100889:	e8 ba fa ff ff       	call   100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100895:	00 
  100896:	c7 04 24 cf 5e 10 00 	movl   $0x105ecf,(%esp)
  10089d:	e8 a6 fa ff ff       	call   100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a2:	c7 44 24 04 ec 5d 10 	movl   $0x105dec,0x4(%esp)
  1008a9:	00 
  1008aa:	c7 04 24 e7 5e 10 00 	movl   $0x105ee7,(%esp)
  1008b1:	e8 92 fa ff ff       	call   100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b6:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008bd:	00 
  1008be:	c7 04 24 ff 5e 10 00 	movl   $0x105eff,(%esp)
  1008c5:	e8 7e fa ff ff       	call   100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008ca:	c7 44 24 04 28 af 11 	movl   $0x11af28,0x4(%esp)
  1008d1:	00 
  1008d2:	c7 04 24 17 5f 10 00 	movl   $0x105f17,(%esp)
  1008d9:	e8 6a fa ff ff       	call   100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008de:	b8 28 af 11 00       	mov    $0x11af28,%eax
  1008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008e9:	b8 36 00 10 00       	mov    $0x100036,%eax
  1008ee:	29 c2                	sub    %eax,%edx
  1008f0:	89 d0                	mov    %edx,%eax
  1008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f8:	85 c0                	test   %eax,%eax
  1008fa:	0f 48 c2             	cmovs  %edx,%eax
  1008fd:	c1 f8 0a             	sar    $0xa,%eax
  100900:	89 44 24 04          	mov    %eax,0x4(%esp)
  100904:	c7 04 24 30 5f 10 00 	movl   $0x105f30,(%esp)
  10090b:	e8 38 fa ff ff       	call   100348 <cprintf>
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10091e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100922:	8b 45 08             	mov    0x8(%ebp),%eax
  100925:	89 04 24             	mov    %eax,(%esp)
  100928:	e8 12 fc ff ff       	call   10053f <debuginfo_eip>
  10092d:	85 c0                	test   %eax,%eax
  10092f:	74 15                	je     100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100931:	8b 45 08             	mov    0x8(%ebp),%eax
  100934:	89 44 24 04          	mov    %eax,0x4(%esp)
  100938:	c7 04 24 5a 5f 10 00 	movl   $0x105f5a,(%esp)
  10093f:	e8 04 fa ff ff       	call   100348 <cprintf>
  100944:	eb 6d                	jmp    1009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10094d:	eb 1c                	jmp    10096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100955:	01 d0                	add    %edx,%eax
  100957:	0f b6 00             	movzbl (%eax),%eax
  10095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100963:	01 ca                	add    %ecx,%edx
  100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100971:	7f dc                	jg     10094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097c:	01 d0                	add    %edx,%eax
  10097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100984:	8b 55 08             	mov    0x8(%ebp),%edx
  100987:	89 d1                	mov    %edx,%ecx
  100989:	29 c1                	sub    %eax,%ecx
  10098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10099f:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a7:	c7 04 24 76 5f 10 00 	movl   $0x105f76,(%esp)
  1009ae:	e8 95 f9 ff ff       	call   100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b3:	c9                   	leave  
  1009b4:	c3                   	ret    

001009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b5:	55                   	push   %ebp
  1009b6:	89 e5                	mov    %esp,%ebp
  1009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009bb:	8b 45 04             	mov    0x4(%ebp),%eax
  1009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c4:	c9                   	leave  
  1009c5:	c3                   	ret    

001009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c6:	55                   	push   %ebp
  1009c7:	89 e5                	mov    %esp,%ebp
  1009c9:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cc:	89 e8                	mov    %ebp,%eax
  1009ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  1009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();//读取ebp和eip
  1009d7:	e8 d9 ff ff ff       	call   1009b5 <read_eip>
  1009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int i, j;
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e6:	e9 82 00 00 00       	jmp    100a6d <print_stackframe+0xa7>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);//显示8位16进制数(32位二进制数)
  1009eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f9:	c7 04 24 88 5f 10 00 	movl   $0x105f88,(%esp)
  100a00:	e8 43 f9 ff ff       	call   100348 <cprintf>
        for (j = 0; j < 4; j ++) {
  100a05:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a0c:	eb 28                	jmp    100a36 <print_stackframe+0x70>
            cprintf("0x%08x ", ((uint32_t*)ebp + 2)[j]);//输出参数(4个32位二进制数)，参数的地址比ebp的地址高两位
  100a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a11:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a1b:	01 d0                	add    %edx,%eax
  100a1d:	83 c0 08             	add    $0x8,%eax
  100a20:	8b 00                	mov    (%eax),%eax
  100a22:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a26:	c7 04 24 a4 5f 10 00 	movl   $0x105fa4,(%esp)
  100a2d:	e8 16 f9 ff ff       	call   100348 <cprintf>
	uint32_t eip = read_eip();//读取ebp和eip

	int i, j;
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);//显示8位16进制数(32位二进制数)
        for (j = 0; j < 4; j ++) {
  100a32:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a36:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3a:	7e d2                	jle    100a0e <print_stackframe+0x48>
            cprintf("0x%08x ", ((uint32_t*)ebp + 2)[j]);//输出参数(4个32位二进制数)，参数的地址比ebp的地址高两位
        }
        cprintf("\n");
  100a3c:	c7 04 24 ac 5f 10 00 	movl   $0x105fac,(%esp)
  100a43:	e8 00 f9 ff ff       	call   100348 <cprintf>
        print_debuginfo(eip - 1);//打印前一条指令的信息
  100a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4b:	83 e8 01             	sub    $0x1,%eax
  100a4e:	89 04 24             	mov    %eax,(%esp)
  100a51:	e8 bc fe ff ff       	call   100912 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];//eip比ebp的地址高一位
  100a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a59:	83 c0 04             	add    $0x4,%eax
  100a5c:	8b 00                	mov    (%eax),%eax
  100a5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];//取出上一层函数的ebp
  100a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a64:	8b 00                	mov    (%eax),%eax
  100a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();//读取ebp和eip

	int i, j;
	for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a69:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a71:	74 0a                	je     100a7d <print_stackframe+0xb7>
  100a73:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a77:	0f 8e 6e ff ff ff    	jle    1009eb <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);//打印前一条指令的信息
        eip = ((uint32_t *)ebp)[1];//eip比ebp的地址高一位
        ebp = ((uint32_t *)ebp)[0];//取出上一层函数的ebp
    }
}
  100a7d:	c9                   	leave  
  100a7e:	c3                   	ret    

00100a7f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a7f:	55                   	push   %ebp
  100a80:	89 e5                	mov    %esp,%ebp
  100a82:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a85:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8c:	eb 0c                	jmp    100a9a <parse+0x1b>
            *buf ++ = '\0';
  100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a91:	8d 50 01             	lea    0x1(%eax),%edx
  100a94:	89 55 08             	mov    %edx,0x8(%ebp)
  100a97:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9d:	0f b6 00             	movzbl (%eax),%eax
  100aa0:	84 c0                	test   %al,%al
  100aa2:	74 1d                	je     100ac1 <parse+0x42>
  100aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa7:	0f b6 00             	movzbl (%eax),%eax
  100aaa:	0f be c0             	movsbl %al,%eax
  100aad:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab1:	c7 04 24 30 60 10 00 	movl   $0x106030,(%esp)
  100ab8:	e8 e7 4f 00 00       	call   105aa4 <strchr>
  100abd:	85 c0                	test   %eax,%eax
  100abf:	75 cd                	jne    100a8e <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac4:	0f b6 00             	movzbl (%eax),%eax
  100ac7:	84 c0                	test   %al,%al
  100ac9:	75 02                	jne    100acd <parse+0x4e>
            break;
  100acb:	eb 67                	jmp    100b34 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100acd:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad1:	75 14                	jne    100ae7 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ada:	00 
  100adb:	c7 04 24 35 60 10 00 	movl   $0x106035,(%esp)
  100ae2:	e8 61 f8 ff ff       	call   100348 <cprintf>
        }
        argv[argc ++] = buf;
  100ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aea:	8d 50 01             	lea    0x1(%eax),%edx
  100aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afa:	01 c2                	add    %eax,%edx
  100afc:	8b 45 08             	mov    0x8(%ebp),%eax
  100aff:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b01:	eb 04                	jmp    100b07 <parse+0x88>
            buf ++;
  100b03:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b07:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0a:	0f b6 00             	movzbl (%eax),%eax
  100b0d:	84 c0                	test   %al,%al
  100b0f:	74 1d                	je     100b2e <parse+0xaf>
  100b11:	8b 45 08             	mov    0x8(%ebp),%eax
  100b14:	0f b6 00             	movzbl (%eax),%eax
  100b17:	0f be c0             	movsbl %al,%eax
  100b1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1e:	c7 04 24 30 60 10 00 	movl   $0x106030,(%esp)
  100b25:	e8 7a 4f 00 00       	call   105aa4 <strchr>
  100b2a:	85 c0                	test   %eax,%eax
  100b2c:	74 d5                	je     100b03 <parse+0x84>
            buf ++;
        }
    }
  100b2e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b2f:	e9 66 ff ff ff       	jmp    100a9a <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b37:	c9                   	leave  
  100b38:	c3                   	ret    

00100b39 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b39:	55                   	push   %ebp
  100b3a:	89 e5                	mov    %esp,%ebp
  100b3c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b3f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b42:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b46:	8b 45 08             	mov    0x8(%ebp),%eax
  100b49:	89 04 24             	mov    %eax,(%esp)
  100b4c:	e8 2e ff ff ff       	call   100a7f <parse>
  100b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b58:	75 0a                	jne    100b64 <runcmd+0x2b>
        return 0;
  100b5a:	b8 00 00 00 00       	mov    $0x0,%eax
  100b5f:	e9 85 00 00 00       	jmp    100be9 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6b:	eb 5c                	jmp    100bc9 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6d:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b73:	89 d0                	mov    %edx,%eax
  100b75:	01 c0                	add    %eax,%eax
  100b77:	01 d0                	add    %edx,%eax
  100b79:	c1 e0 02             	shl    $0x2,%eax
  100b7c:	05 00 70 11 00       	add    $0x117000,%eax
  100b81:	8b 00                	mov    (%eax),%eax
  100b83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b87:	89 04 24             	mov    %eax,(%esp)
  100b8a:	e8 76 4e 00 00       	call   105a05 <strcmp>
  100b8f:	85 c0                	test   %eax,%eax
  100b91:	75 32                	jne    100bc5 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b96:	89 d0                	mov    %edx,%eax
  100b98:	01 c0                	add    %eax,%eax
  100b9a:	01 d0                	add    %edx,%eax
  100b9c:	c1 e0 02             	shl    $0x2,%eax
  100b9f:	05 00 70 11 00       	add    $0x117000,%eax
  100ba4:	8b 40 08             	mov    0x8(%eax),%eax
  100ba7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100baa:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bad:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb0:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb4:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb7:	83 c2 04             	add    $0x4,%edx
  100bba:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbe:	89 0c 24             	mov    %ecx,(%esp)
  100bc1:	ff d0                	call   *%eax
  100bc3:	eb 24                	jmp    100be9 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcc:	83 f8 02             	cmp    $0x2,%eax
  100bcf:	76 9c                	jbe    100b6d <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd8:	c7 04 24 53 60 10 00 	movl   $0x106053,(%esp)
  100bdf:	e8 64 f7 ff ff       	call   100348 <cprintf>
    return 0;
  100be4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be9:	c9                   	leave  
  100bea:	c3                   	ret    

00100beb <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100beb:	55                   	push   %ebp
  100bec:	89 e5                	mov    %esp,%ebp
  100bee:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf1:	c7 04 24 6c 60 10 00 	movl   $0x10606c,(%esp)
  100bf8:	e8 4b f7 ff ff       	call   100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfd:	c7 04 24 94 60 10 00 	movl   $0x106094,(%esp)
  100c04:	e8 3f f7 ff ff       	call   100348 <cprintf>

    if (tf != NULL) {
  100c09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0d:	74 0b                	je     100c1a <kmonitor+0x2f>
        print_trapframe(tf);
  100c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c12:	89 04 24             	mov    %eax,(%esp)
  100c15:	e8 41 0e 00 00       	call   101a5b <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1a:	c7 04 24 b9 60 10 00 	movl   $0x1060b9,(%esp)
  100c21:	e8 19 f6 ff ff       	call   10023f <readline>
  100c26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2d:	74 18                	je     100c47 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c39:	89 04 24             	mov    %eax,(%esp)
  100c3c:	e8 f8 fe ff ff       	call   100b39 <runcmd>
  100c41:	85 c0                	test   %eax,%eax
  100c43:	79 02                	jns    100c47 <kmonitor+0x5c>
                break;
  100c45:	eb 02                	jmp    100c49 <kmonitor+0x5e>
            }
        }
    }
  100c47:	eb d1                	jmp    100c1a <kmonitor+0x2f>
}
  100c49:	c9                   	leave  
  100c4a:	c3                   	ret    

00100c4b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4b:	55                   	push   %ebp
  100c4c:	89 e5                	mov    %esp,%ebp
  100c4e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c58:	eb 3f                	jmp    100c99 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5d:	89 d0                	mov    %edx,%eax
  100c5f:	01 c0                	add    %eax,%eax
  100c61:	01 d0                	add    %edx,%eax
  100c63:	c1 e0 02             	shl    $0x2,%eax
  100c66:	05 00 70 11 00       	add    $0x117000,%eax
  100c6b:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c71:	89 d0                	mov    %edx,%eax
  100c73:	01 c0                	add    %eax,%eax
  100c75:	01 d0                	add    %edx,%eax
  100c77:	c1 e0 02             	shl    $0x2,%eax
  100c7a:	05 00 70 11 00       	add    $0x117000,%eax
  100c7f:	8b 00                	mov    (%eax),%eax
  100c81:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c85:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c89:	c7 04 24 bd 60 10 00 	movl   $0x1060bd,(%esp)
  100c90:	e8 b3 f6 ff ff       	call   100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c95:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9c:	83 f8 02             	cmp    $0x2,%eax
  100c9f:	76 b9                	jbe    100c5a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca6:	c9                   	leave  
  100ca7:	c3                   	ret    

00100ca8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca8:	55                   	push   %ebp
  100ca9:	89 e5                	mov    %esp,%ebp
  100cab:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cae:	e8 c9 fb ff ff       	call   10087c <print_kerninfo>
    return 0;
  100cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb8:	c9                   	leave  
  100cb9:	c3                   	ret    

00100cba <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cba:	55                   	push   %ebp
  100cbb:	89 e5                	mov    %esp,%ebp
  100cbd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc0:	e8 01 fd ff ff       	call   1009c6 <print_stackframe>
    return 0;
  100cc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cca:	c9                   	leave  
  100ccb:	c3                   	ret    

00100ccc <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccc:	55                   	push   %ebp
  100ccd:	89 e5                	mov    %esp,%ebp
  100ccf:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd2:	a1 20 a4 11 00       	mov    0x11a420,%eax
  100cd7:	85 c0                	test   %eax,%eax
  100cd9:	74 02                	je     100cdd <__panic+0x11>
        goto panic_dead;
  100cdb:	eb 59                	jmp    100d36 <__panic+0x6a>
    }
    is_panic = 1;
  100cdd:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  100ce4:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce7:	8d 45 14             	lea    0x14(%ebp),%eax
  100cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfb:	c7 04 24 c6 60 10 00 	movl   $0x1060c6,(%esp)
  100d02:	e8 41 f6 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  100d11:	89 04 24             	mov    %eax,(%esp)
  100d14:	e8 fc f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d19:	c7 04 24 e2 60 10 00 	movl   $0x1060e2,(%esp)
  100d20:	e8 23 f6 ff ff       	call   100348 <cprintf>
    
    cprintf("stack trackback:\n");
  100d25:	c7 04 24 e4 60 10 00 	movl   $0x1060e4,(%esp)
  100d2c:	e8 17 f6 ff ff       	call   100348 <cprintf>
    print_stackframe();
  100d31:	e8 90 fc ff ff       	call   1009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d36:	e8 85 09 00 00       	call   1016c0 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d42:	e8 a4 fe ff ff       	call   100beb <kmonitor>
    }
  100d47:	eb f2                	jmp    100d3b <__panic+0x6f>

00100d49 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d49:	55                   	push   %ebp
  100d4a:	89 e5                	mov    %esp,%ebp
  100d4c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d4f:	8d 45 14             	lea    0x14(%ebp),%eax
  100d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d58:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d63:	c7 04 24 f6 60 10 00 	movl   $0x1060f6,(%esp)
  100d6a:	e8 d9 f5 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d76:	8b 45 10             	mov    0x10(%ebp),%eax
  100d79:	89 04 24             	mov    %eax,(%esp)
  100d7c:	e8 94 f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d81:	c7 04 24 e2 60 10 00 	movl   $0x1060e2,(%esp)
  100d88:	e8 bb f5 ff ff       	call   100348 <cprintf>
    va_end(ap);
}
  100d8d:	c9                   	leave  
  100d8e:	c3                   	ret    

00100d8f <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d8f:	55                   	push   %ebp
  100d90:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d92:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  100d97:	5d                   	pop    %ebp
  100d98:	c3                   	ret    

00100d99 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d99:	55                   	push   %ebp
  100d9a:	89 e5                	mov    %esp,%ebp
  100d9c:	83 ec 28             	sub    $0x28,%esp
  100d9f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100da5:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100da9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dad:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100db1:	ee                   	out    %al,(%dx)
  100db2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dbc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dc4:	ee                   	out    %al,(%dx)
  100dc5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dcb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dcf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dd3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd8:	c7 05 0c af 11 00 00 	movl   $0x0,0x11af0c
  100ddf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100de2:	c7 04 24 14 61 10 00 	movl   $0x106114,(%esp)
  100de9:	e8 5a f5 ff ff       	call   100348 <cprintf>
    pic_enable(IRQ_TIMER);
  100dee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df5:	e8 24 09 00 00       	call   10171e <pic_enable>
}
  100dfa:	c9                   	leave  
  100dfb:	c3                   	ret    

00100dfc <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dfc:	55                   	push   %ebp
  100dfd:	89 e5                	mov    %esp,%ebp
  100dff:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e02:	9c                   	pushf  
  100e03:	58                   	pop    %eax
  100e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e0a:	25 00 02 00 00       	and    $0x200,%eax
  100e0f:	85 c0                	test   %eax,%eax
  100e11:	74 0c                	je     100e1f <__intr_save+0x23>
        intr_disable();
  100e13:	e8 a8 08 00 00       	call   1016c0 <intr_disable>
        return 1;
  100e18:	b8 01 00 00 00       	mov    $0x1,%eax
  100e1d:	eb 05                	jmp    100e24 <__intr_save+0x28>
    }
    return 0;
  100e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e24:	c9                   	leave  
  100e25:	c3                   	ret    

00100e26 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e26:	55                   	push   %ebp
  100e27:	89 e5                	mov    %esp,%ebp
  100e29:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e30:	74 05                	je     100e37 <__intr_restore+0x11>
        intr_enable();
  100e32:	e8 83 08 00 00       	call   1016ba <intr_enable>
    }
}
  100e37:	c9                   	leave  
  100e38:	c3                   	ret    

00100e39 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e39:	55                   	push   %ebp
  100e3a:	89 e5                	mov    %esp,%ebp
  100e3c:	83 ec 10             	sub    $0x10,%esp
  100e3f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e45:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e49:	89 c2                	mov    %eax,%edx
  100e4b:	ec                   	in     (%dx),%al
  100e4c:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e4f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e55:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e59:	89 c2                	mov    %eax,%edx
  100e5b:	ec                   	in     (%dx),%al
  100e5c:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e5f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e65:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e69:	89 c2                	mov    %eax,%edx
  100e6b:	ec                   	in     (%dx),%al
  100e6c:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e6f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e79:	89 c2                	mov    %eax,%edx
  100e7b:	ec                   	in     (%dx),%al
  100e7c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e7f:	c9                   	leave  
  100e80:	c3                   	ret    

00100e81 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e81:	55                   	push   %ebp
  100e82:	89 e5                	mov    %esp,%ebp
  100e84:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e87:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e91:	0f b7 00             	movzwl (%eax),%eax
  100e94:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea3:	0f b7 00             	movzwl (%eax),%eax
  100ea6:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100eaa:	74 12                	je     100ebe <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100eac:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eb3:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100eba:	b4 03 
  100ebc:	eb 13                	jmp    100ed1 <cga_init+0x50>
    } else {
        *cp = was;
  100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ec5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ec8:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ecf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ed1:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ed8:	0f b7 c0             	movzwl %ax,%eax
  100edb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100edf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ee7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100eeb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eec:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ef3:	83 c0 01             	add    $0x1,%eax
  100ef6:	0f b7 c0             	movzwl %ax,%eax
  100ef9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100efd:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f01:	89 c2                	mov    %eax,%edx
  100f03:	ec                   	in     (%dx),%al
  100f04:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f07:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f0b:	0f b6 c0             	movzbl %al,%eax
  100f0e:	c1 e0 08             	shl    $0x8,%eax
  100f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f14:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f1b:	0f b7 c0             	movzwl %ax,%eax
  100f1e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f22:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f2a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f2f:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f36:	83 c0 01             	add    $0x1,%eax
  100f39:	0f b7 c0             	movzwl %ax,%eax
  100f3c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f40:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f44:	89 c2                	mov    %eax,%edx
  100f46:	ec                   	in     (%dx),%al
  100f47:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f4a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f4e:	0f b6 c0             	movzbl %al,%eax
  100f51:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f57:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f5f:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100f65:	c9                   	leave  
  100f66:	c3                   	ret    

00100f67 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f67:	55                   	push   %ebp
  100f68:	89 e5                	mov    %esp,%ebp
  100f6a:	83 ec 48             	sub    $0x48,%esp
  100f6d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f73:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f77:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f7f:	ee                   	out    %al,(%dx)
  100f80:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f86:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f8a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f8e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f92:	ee                   	out    %al,(%dx)
  100f93:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f99:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f9d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fa1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fa5:	ee                   	out    %al,(%dx)
  100fa6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fac:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fb0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fb4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fb8:	ee                   	out    %al,(%dx)
  100fb9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fbf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fc3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fc7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fcb:	ee                   	out    %al,(%dx)
  100fcc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fd2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fd6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fda:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fde:	ee                   	out    %al,(%dx)
  100fdf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fe5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fe9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fed:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100ff1:	ee                   	out    %al,(%dx)
  100ff2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100ffc:	89 c2                	mov    %eax,%edx
  100ffe:	ec                   	in     (%dx),%al
  100fff:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  101002:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101006:	3c ff                	cmp    $0xff,%al
  101008:	0f 95 c0             	setne  %al
  10100b:	0f b6 c0             	movzbl %al,%eax
  10100e:	a3 48 a4 11 00       	mov    %eax,0x11a448
  101013:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101019:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10101d:	89 c2                	mov    %eax,%edx
  10101f:	ec                   	in     (%dx),%al
  101020:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101023:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101029:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10102d:	89 c2                	mov    %eax,%edx
  10102f:	ec                   	in     (%dx),%al
  101030:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101033:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101038:	85 c0                	test   %eax,%eax
  10103a:	74 0c                	je     101048 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10103c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101043:	e8 d6 06 00 00       	call   10171e <pic_enable>
    }
}
  101048:	c9                   	leave  
  101049:	c3                   	ret    

0010104a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10104a:	55                   	push   %ebp
  10104b:	89 e5                	mov    %esp,%ebp
  10104d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101057:	eb 09                	jmp    101062 <lpt_putc_sub+0x18>
        delay();
  101059:	e8 db fd ff ff       	call   100e39 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10105e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101062:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101068:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10106c:	89 c2                	mov    %eax,%edx
  10106e:	ec                   	in     (%dx),%al
  10106f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101072:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101076:	84 c0                	test   %al,%al
  101078:	78 09                	js     101083 <lpt_putc_sub+0x39>
  10107a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101081:	7e d6                	jle    101059 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101083:	8b 45 08             	mov    0x8(%ebp),%eax
  101086:	0f b6 c0             	movzbl %al,%eax
  101089:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10108f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101092:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101096:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10109a:	ee                   	out    %al,(%dx)
  10109b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010a1:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010ad:	ee                   	out    %al,(%dx)
  1010ae:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010b4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010b8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010bc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010c0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010c1:	c9                   	leave  
  1010c2:	c3                   	ret    

001010c3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010c3:	55                   	push   %ebp
  1010c4:	89 e5                	mov    %esp,%ebp
  1010c6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010c9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010cd:	74 0d                	je     1010dc <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d2:	89 04 24             	mov    %eax,(%esp)
  1010d5:	e8 70 ff ff ff       	call   10104a <lpt_putc_sub>
  1010da:	eb 24                	jmp    101100 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e3:	e8 62 ff ff ff       	call   10104a <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010ef:	e8 56 ff ff ff       	call   10104a <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010fb:	e8 4a ff ff ff       	call   10104a <lpt_putc_sub>
    }
}
  101100:	c9                   	leave  
  101101:	c3                   	ret    

00101102 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101102:	55                   	push   %ebp
  101103:	89 e5                	mov    %esp,%ebp
  101105:	53                   	push   %ebx
  101106:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101109:	8b 45 08             	mov    0x8(%ebp),%eax
  10110c:	b0 00                	mov    $0x0,%al
  10110e:	85 c0                	test   %eax,%eax
  101110:	75 07                	jne    101119 <cga_putc+0x17>
        c |= 0x0700;
  101112:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101119:	8b 45 08             	mov    0x8(%ebp),%eax
  10111c:	0f b6 c0             	movzbl %al,%eax
  10111f:	83 f8 0a             	cmp    $0xa,%eax
  101122:	74 4c                	je     101170 <cga_putc+0x6e>
  101124:	83 f8 0d             	cmp    $0xd,%eax
  101127:	74 57                	je     101180 <cga_putc+0x7e>
  101129:	83 f8 08             	cmp    $0x8,%eax
  10112c:	0f 85 88 00 00 00    	jne    1011ba <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101132:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101139:	66 85 c0             	test   %ax,%ax
  10113c:	74 30                	je     10116e <cga_putc+0x6c>
            crt_pos --;
  10113e:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101145:	83 e8 01             	sub    $0x1,%eax
  101148:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10114e:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101153:	0f b7 15 44 a4 11 00 	movzwl 0x11a444,%edx
  10115a:	0f b7 d2             	movzwl %dx,%edx
  10115d:	01 d2                	add    %edx,%edx
  10115f:	01 c2                	add    %eax,%edx
  101161:	8b 45 08             	mov    0x8(%ebp),%eax
  101164:	b0 00                	mov    $0x0,%al
  101166:	83 c8 20             	or     $0x20,%eax
  101169:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10116c:	eb 72                	jmp    1011e0 <cga_putc+0xde>
  10116e:	eb 70                	jmp    1011e0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101170:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101177:	83 c0 50             	add    $0x50,%eax
  10117a:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101180:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  101187:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  10118e:	0f b7 c1             	movzwl %cx,%eax
  101191:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101197:	c1 e8 10             	shr    $0x10,%eax
  10119a:	89 c2                	mov    %eax,%edx
  10119c:	66 c1 ea 06          	shr    $0x6,%dx
  1011a0:	89 d0                	mov    %edx,%eax
  1011a2:	c1 e0 02             	shl    $0x2,%eax
  1011a5:	01 d0                	add    %edx,%eax
  1011a7:	c1 e0 04             	shl    $0x4,%eax
  1011aa:	29 c1                	sub    %eax,%ecx
  1011ac:	89 ca                	mov    %ecx,%edx
  1011ae:	89 d8                	mov    %ebx,%eax
  1011b0:	29 d0                	sub    %edx,%eax
  1011b2:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011b8:	eb 26                	jmp    1011e0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011ba:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011c0:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011c7:	8d 50 01             	lea    0x1(%eax),%edx
  1011ca:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  1011d1:	0f b7 c0             	movzwl %ax,%eax
  1011d4:	01 c0                	add    %eax,%eax
  1011d6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1011dc:	66 89 02             	mov    %ax,(%edx)
        break;
  1011df:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011e0:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011e7:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011eb:	76 5b                	jbe    101248 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011ed:	a1 40 a4 11 00       	mov    0x11a440,%eax
  1011f2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011f8:	a1 40 a4 11 00       	mov    0x11a440,%eax
  1011fd:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101204:	00 
  101205:	89 54 24 04          	mov    %edx,0x4(%esp)
  101209:	89 04 24             	mov    %eax,(%esp)
  10120c:	e8 91 4a 00 00       	call   105ca2 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101211:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101218:	eb 15                	jmp    10122f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10121a:	a1 40 a4 11 00       	mov    0x11a440,%eax
  10121f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101222:	01 d2                	add    %edx,%edx
  101224:	01 d0                	add    %edx,%eax
  101226:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10122b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10122f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101236:	7e e2                	jle    10121a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101238:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10123f:	83 e8 50             	sub    $0x50,%eax
  101242:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101248:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  10124f:	0f b7 c0             	movzwl %ax,%eax
  101252:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101256:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10125a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10125e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101262:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101263:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10126a:	66 c1 e8 08          	shr    $0x8,%ax
  10126e:	0f b6 c0             	movzbl %al,%eax
  101271:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  101278:	83 c2 01             	add    $0x1,%edx
  10127b:	0f b7 d2             	movzwl %dx,%edx
  10127e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101282:	88 45 ed             	mov    %al,-0x13(%ebp)
  101285:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101289:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10128d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10128e:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101295:	0f b7 c0             	movzwl %ax,%eax
  101298:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10129c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012a0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012a4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012a8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012a9:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1012b0:	0f b6 c0             	movzbl %al,%eax
  1012b3:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1012ba:	83 c2 01             	add    $0x1,%edx
  1012bd:	0f b7 d2             	movzwl %dx,%edx
  1012c0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012c4:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012cf:	ee                   	out    %al,(%dx)
}
  1012d0:	83 c4 34             	add    $0x34,%esp
  1012d3:	5b                   	pop    %ebx
  1012d4:	5d                   	pop    %ebp
  1012d5:	c3                   	ret    

001012d6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012d6:	55                   	push   %ebp
  1012d7:	89 e5                	mov    %esp,%ebp
  1012d9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012e3:	eb 09                	jmp    1012ee <serial_putc_sub+0x18>
        delay();
  1012e5:	e8 4f fb ff ff       	call   100e39 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012f8:	89 c2                	mov    %eax,%edx
  1012fa:	ec                   	in     (%dx),%al
  1012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101302:	0f b6 c0             	movzbl %al,%eax
  101305:	83 e0 20             	and    $0x20,%eax
  101308:	85 c0                	test   %eax,%eax
  10130a:	75 09                	jne    101315 <serial_putc_sub+0x3f>
  10130c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101313:	7e d0                	jle    1012e5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101315:	8b 45 08             	mov    0x8(%ebp),%eax
  101318:	0f b6 c0             	movzbl %al,%eax
  10131b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101321:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101324:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101328:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10132c:	ee                   	out    %al,(%dx)
}
  10132d:	c9                   	leave  
  10132e:	c3                   	ret    

0010132f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10132f:	55                   	push   %ebp
  101330:	89 e5                	mov    %esp,%ebp
  101332:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101335:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101339:	74 0d                	je     101348 <serial_putc+0x19>
        serial_putc_sub(c);
  10133b:	8b 45 08             	mov    0x8(%ebp),%eax
  10133e:	89 04 24             	mov    %eax,(%esp)
  101341:	e8 90 ff ff ff       	call   1012d6 <serial_putc_sub>
  101346:	eb 24                	jmp    10136c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101348:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10134f:	e8 82 ff ff ff       	call   1012d6 <serial_putc_sub>
        serial_putc_sub(' ');
  101354:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10135b:	e8 76 ff ff ff       	call   1012d6 <serial_putc_sub>
        serial_putc_sub('\b');
  101360:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101367:	e8 6a ff ff ff       	call   1012d6 <serial_putc_sub>
    }
}
  10136c:	c9                   	leave  
  10136d:	c3                   	ret    

0010136e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10136e:	55                   	push   %ebp
  10136f:	89 e5                	mov    %esp,%ebp
  101371:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101374:	eb 33                	jmp    1013a9 <cons_intr+0x3b>
        if (c != 0) {
  101376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10137a:	74 2d                	je     1013a9 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10137c:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101381:	8d 50 01             	lea    0x1(%eax),%edx
  101384:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  10138a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10138d:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101393:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101398:	3d 00 02 00 00       	cmp    $0x200,%eax
  10139d:	75 0a                	jne    1013a9 <cons_intr+0x3b>
                cons.wpos = 0;
  10139f:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  1013a6:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1013a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ac:	ff d0                	call   *%eax
  1013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013b5:	75 bf                	jne    101376 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013b7:	c9                   	leave  
  1013b8:	c3                   	ret    

001013b9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013b9:	55                   	push   %ebp
  1013ba:	89 e5                	mov    %esp,%ebp
  1013bc:	83 ec 10             	sub    $0x10,%esp
  1013bf:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013c5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013c9:	89 c2                	mov    %eax,%edx
  1013cb:	ec                   	in     (%dx),%al
  1013cc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013cf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013d3:	0f b6 c0             	movzbl %al,%eax
  1013d6:	83 e0 01             	and    $0x1,%eax
  1013d9:	85 c0                	test   %eax,%eax
  1013db:	75 07                	jne    1013e4 <serial_proc_data+0x2b>
        return -1;
  1013dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e2:	eb 2a                	jmp    10140e <serial_proc_data+0x55>
  1013e4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013ee:	89 c2                	mov    %eax,%edx
  1013f0:	ec                   	in     (%dx),%al
  1013f1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013f4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013f8:	0f b6 c0             	movzbl %al,%eax
  1013fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013fe:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101402:	75 07                	jne    10140b <serial_proc_data+0x52>
        c = '\b';
  101404:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10140e:	c9                   	leave  
  10140f:	c3                   	ret    

00101410 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101410:	55                   	push   %ebp
  101411:	89 e5                	mov    %esp,%ebp
  101413:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101416:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10141b:	85 c0                	test   %eax,%eax
  10141d:	74 0c                	je     10142b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10141f:	c7 04 24 b9 13 10 00 	movl   $0x1013b9,(%esp)
  101426:	e8 43 ff ff ff       	call   10136e <cons_intr>
    }
}
  10142b:	c9                   	leave  
  10142c:	c3                   	ret    

0010142d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10142d:	55                   	push   %ebp
  10142e:	89 e5                	mov    %esp,%ebp
  101430:	83 ec 38             	sub    $0x38,%esp
  101433:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101439:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10143d:	89 c2                	mov    %eax,%edx
  10143f:	ec                   	in     (%dx),%al
  101440:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101443:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101447:	0f b6 c0             	movzbl %al,%eax
  10144a:	83 e0 01             	and    $0x1,%eax
  10144d:	85 c0                	test   %eax,%eax
  10144f:	75 0a                	jne    10145b <kbd_proc_data+0x2e>
        return -1;
  101451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101456:	e9 59 01 00 00       	jmp    1015b4 <kbd_proc_data+0x187>
  10145b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101461:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101465:	89 c2                	mov    %eax,%edx
  101467:	ec                   	in     (%dx),%al
  101468:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10146b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10146f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101472:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101476:	75 17                	jne    10148f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101478:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10147d:	83 c8 40             	or     $0x40,%eax
  101480:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  101485:	b8 00 00 00 00       	mov    $0x0,%eax
  10148a:	e9 25 01 00 00       	jmp    1015b4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101493:	84 c0                	test   %al,%al
  101495:	79 47                	jns    1014de <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101497:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10149c:	83 e0 40             	and    $0x40,%eax
  10149f:	85 c0                	test   %eax,%eax
  1014a1:	75 09                	jne    1014ac <kbd_proc_data+0x7f>
  1014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a7:	83 e0 7f             	and    $0x7f,%eax
  1014aa:	eb 04                	jmp    1014b0 <kbd_proc_data+0x83>
  1014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b7:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014be:	83 c8 40             	or     $0x40,%eax
  1014c1:	0f b6 c0             	movzbl %al,%eax
  1014c4:	f7 d0                	not    %eax
  1014c6:	89 c2                	mov    %eax,%edx
  1014c8:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014cd:	21 d0                	and    %edx,%eax
  1014cf:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014d4:	b8 00 00 00 00       	mov    $0x0,%eax
  1014d9:	e9 d6 00 00 00       	jmp    1015b4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014de:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014e3:	83 e0 40             	and    $0x40,%eax
  1014e6:	85 c0                	test   %eax,%eax
  1014e8:	74 11                	je     1014fb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014ea:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014ee:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014f3:	83 e0 bf             	and    $0xffffffbf,%eax
  1014f6:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  1014fb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ff:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  101506:	0f b6 d0             	movzbl %al,%edx
  101509:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10150e:	09 d0                	or     %edx,%eax
  101510:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101519:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  101520:	0f b6 d0             	movzbl %al,%edx
  101523:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101528:	31 d0                	xor    %edx,%eax
  10152a:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  10152f:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101534:	83 e0 03             	and    $0x3,%eax
  101537:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  10153e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101542:	01 d0                	add    %edx,%eax
  101544:	0f b6 00             	movzbl (%eax),%eax
  101547:	0f b6 c0             	movzbl %al,%eax
  10154a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10154d:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101552:	83 e0 08             	and    $0x8,%eax
  101555:	85 c0                	test   %eax,%eax
  101557:	74 22                	je     10157b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101559:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10155d:	7e 0c                	jle    10156b <kbd_proc_data+0x13e>
  10155f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101563:	7f 06                	jg     10156b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101565:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101569:	eb 10                	jmp    10157b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10156b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10156f:	7e 0a                	jle    10157b <kbd_proc_data+0x14e>
  101571:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101575:	7f 04                	jg     10157b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101577:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10157b:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101580:	f7 d0                	not    %eax
  101582:	83 e0 06             	and    $0x6,%eax
  101585:	85 c0                	test   %eax,%eax
  101587:	75 28                	jne    1015b1 <kbd_proc_data+0x184>
  101589:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101590:	75 1f                	jne    1015b1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101592:	c7 04 24 2f 61 10 00 	movl   $0x10612f,(%esp)
  101599:	e8 aa ed ff ff       	call   100348 <cprintf>
  10159e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015a4:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015a8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015ac:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015b0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015b4:	c9                   	leave  
  1015b5:	c3                   	ret    

001015b6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015b6:	55                   	push   %ebp
  1015b7:	89 e5                	mov    %esp,%ebp
  1015b9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015bc:	c7 04 24 2d 14 10 00 	movl   $0x10142d,(%esp)
  1015c3:	e8 a6 fd ff ff       	call   10136e <cons_intr>
}
  1015c8:	c9                   	leave  
  1015c9:	c3                   	ret    

001015ca <kbd_init>:

static void
kbd_init(void) {
  1015ca:	55                   	push   %ebp
  1015cb:	89 e5                	mov    %esp,%ebp
  1015cd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015d0:	e8 e1 ff ff ff       	call   1015b6 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015dc:	e8 3d 01 00 00       	call   10171e <pic_enable>
}
  1015e1:	c9                   	leave  
  1015e2:	c3                   	ret    

001015e3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015e3:	55                   	push   %ebp
  1015e4:	89 e5                	mov    %esp,%ebp
  1015e6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015e9:	e8 93 f8 ff ff       	call   100e81 <cga_init>
    serial_init();
  1015ee:	e8 74 f9 ff ff       	call   100f67 <serial_init>
    kbd_init();
  1015f3:	e8 d2 ff ff ff       	call   1015ca <kbd_init>
    if (!serial_exists) {
  1015f8:	a1 48 a4 11 00       	mov    0x11a448,%eax
  1015fd:	85 c0                	test   %eax,%eax
  1015ff:	75 0c                	jne    10160d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101601:	c7 04 24 3b 61 10 00 	movl   $0x10613b,(%esp)
  101608:	e8 3b ed ff ff       	call   100348 <cprintf>
    }
}
  10160d:	c9                   	leave  
  10160e:	c3                   	ret    

0010160f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10160f:	55                   	push   %ebp
  101610:	89 e5                	mov    %esp,%ebp
  101612:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101615:	e8 e2 f7 ff ff       	call   100dfc <__intr_save>
  10161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10161d:	8b 45 08             	mov    0x8(%ebp),%eax
  101620:	89 04 24             	mov    %eax,(%esp)
  101623:	e8 9b fa ff ff       	call   1010c3 <lpt_putc>
        cga_putc(c);
  101628:	8b 45 08             	mov    0x8(%ebp),%eax
  10162b:	89 04 24             	mov    %eax,(%esp)
  10162e:	e8 cf fa ff ff       	call   101102 <cga_putc>
        serial_putc(c);
  101633:	8b 45 08             	mov    0x8(%ebp),%eax
  101636:	89 04 24             	mov    %eax,(%esp)
  101639:	e8 f1 fc ff ff       	call   10132f <serial_putc>
    }
    local_intr_restore(intr_flag);
  10163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101641:	89 04 24             	mov    %eax,(%esp)
  101644:	e8 dd f7 ff ff       	call   100e26 <__intr_restore>
}
  101649:	c9                   	leave  
  10164a:	c3                   	ret    

0010164b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10164b:	55                   	push   %ebp
  10164c:	89 e5                	mov    %esp,%ebp
  10164e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101658:	e8 9f f7 ff ff       	call   100dfc <__intr_save>
  10165d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101660:	e8 ab fd ff ff       	call   101410 <serial_intr>
        kbd_intr();
  101665:	e8 4c ff ff ff       	call   1015b6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10166a:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  101670:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101675:	39 c2                	cmp    %eax,%edx
  101677:	74 31                	je     1016aa <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101679:	a1 60 a6 11 00       	mov    0x11a660,%eax
  10167e:	8d 50 01             	lea    0x1(%eax),%edx
  101681:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  101687:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  10168e:	0f b6 c0             	movzbl %al,%eax
  101691:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101694:	a1 60 a6 11 00       	mov    0x11a660,%eax
  101699:	3d 00 02 00 00       	cmp    $0x200,%eax
  10169e:	75 0a                	jne    1016aa <cons_getc+0x5f>
                cons.rpos = 0;
  1016a0:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  1016a7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016ad:	89 04 24             	mov    %eax,(%esp)
  1016b0:	e8 71 f7 ff ff       	call   100e26 <__intr_restore>
    return c;
  1016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016b8:	c9                   	leave  
  1016b9:	c3                   	ret    

001016ba <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016ba:	55                   	push   %ebp
  1016bb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016bd:	fb                   	sti    
    sti();
}
  1016be:	5d                   	pop    %ebp
  1016bf:	c3                   	ret    

001016c0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016c0:	55                   	push   %ebp
  1016c1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016c3:	fa                   	cli    
    cli();
}
  1016c4:	5d                   	pop    %ebp
  1016c5:	c3                   	ret    

001016c6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016c6:	55                   	push   %ebp
  1016c7:	89 e5                	mov    %esp,%ebp
  1016c9:	83 ec 14             	sub    $0x14,%esp
  1016cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1016cf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016d3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d7:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  1016dd:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  1016e2:	85 c0                	test   %eax,%eax
  1016e4:	74 36                	je     10171c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016e6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ea:	0f b6 c0             	movzbl %al,%eax
  1016ed:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016f3:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016f6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016fa:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016fe:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ff:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101703:	66 c1 e8 08          	shr    $0x8,%ax
  101707:	0f b6 c0             	movzbl %al,%eax
  10170a:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101710:	88 45 f9             	mov    %al,-0x7(%ebp)
  101713:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101717:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10171b:	ee                   	out    %al,(%dx)
    }
}
  10171c:	c9                   	leave  
  10171d:	c3                   	ret    

0010171e <pic_enable>:

void
pic_enable(unsigned int irq) {
  10171e:	55                   	push   %ebp
  10171f:	89 e5                	mov    %esp,%ebp
  101721:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101724:	8b 45 08             	mov    0x8(%ebp),%eax
  101727:	ba 01 00 00 00       	mov    $0x1,%edx
  10172c:	89 c1                	mov    %eax,%ecx
  10172e:	d3 e2                	shl    %cl,%edx
  101730:	89 d0                	mov    %edx,%eax
  101732:	f7 d0                	not    %eax
  101734:	89 c2                	mov    %eax,%edx
  101736:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10173d:	21 d0                	and    %edx,%eax
  10173f:	0f b7 c0             	movzwl %ax,%eax
  101742:	89 04 24             	mov    %eax,(%esp)
  101745:	e8 7c ff ff ff       	call   1016c6 <pic_setmask>
}
  10174a:	c9                   	leave  
  10174b:	c3                   	ret    

0010174c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10174c:	55                   	push   %ebp
  10174d:	89 e5                	mov    %esp,%ebp
  10174f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101752:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  101759:	00 00 00 
  10175c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101762:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101766:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10176a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
  10176f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101775:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101779:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10177d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
  101782:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101788:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10178c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101790:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
  101795:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10179b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10179f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017a3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017a7:	ee                   	out    %al,(%dx)
  1017a8:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017ae:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017b2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017b6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ba:	ee                   	out    %al,(%dx)
  1017bb:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017c1:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017c5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017c9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017cd:	ee                   	out    %al,(%dx)
  1017ce:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017d4:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017d8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017dc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017e0:	ee                   	out    %al,(%dx)
  1017e1:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017e7:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017eb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017ef:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017f3:	ee                   	out    %al,(%dx)
  1017f4:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017fa:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017fe:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101802:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101806:	ee                   	out    %al,(%dx)
  101807:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10180d:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101811:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101815:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101819:	ee                   	out    %al,(%dx)
  10181a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101820:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101824:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101828:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10182c:	ee                   	out    %al,(%dx)
  10182d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101833:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101837:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10183b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10183f:	ee                   	out    %al,(%dx)
  101840:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101846:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10184a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10184e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101852:	ee                   	out    %al,(%dx)
  101853:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101859:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10185d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101861:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101865:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101866:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10186d:	66 83 f8 ff          	cmp    $0xffff,%ax
  101871:	74 12                	je     101885 <pic_init+0x139>
        pic_setmask(irq_mask);
  101873:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10187a:	0f b7 c0             	movzwl %ax,%eax
  10187d:	89 04 24             	mov    %eax,(%esp)
  101880:	e8 41 fe ff ff       	call   1016c6 <pic_setmask>
    }
}
  101885:	c9                   	leave  
  101886:	c3                   	ret    

00101887 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101887:	55                   	push   %ebp
  101888:	89 e5                	mov    %esp,%ebp
  10188a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10188d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101894:	00 
  101895:	c7 04 24 60 61 10 00 	movl   $0x106160,(%esp)
  10189c:	e8 a7 ea ff ff       	call   100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018a1:	c9                   	leave  
  1018a2:	c3                   	ret    

001018a3 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018a3:	55                   	push   %ebp
  1018a4:	89 e5                	mov    %esp,%ebp
  1018a6:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {//在数组长度内初始化中断向量表
  1018a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018b0:	e9 c3 00 00 00       	jmp    101978 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);//使用非陷阱门描述符，在内核级设置中断向量表
  1018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b8:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018bf:	89 c2                	mov    %eax,%edx
  1018c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c4:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  1018cb:	00 
  1018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cf:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  1018d6:	00 08 00 
  1018d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dc:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  1018e3:	00 
  1018e4:	83 e2 e0             	and    $0xffffffe0,%edx
  1018e7:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  1018ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f1:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  1018f8:	00 
  1018f9:	83 e2 1f             	and    $0x1f,%edx
  1018fc:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101906:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10190d:	00 
  10190e:	83 e2 f0             	and    $0xfffffff0,%edx
  101911:	83 ca 0e             	or     $0xe,%edx
  101914:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10191b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191e:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101925:	00 
  101926:	83 e2 ef             	and    $0xffffffef,%edx
  101929:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101930:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101933:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10193a:	00 
  10193b:	83 e2 9f             	and    $0xffffff9f,%edx
  10193e:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101945:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101948:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10194f:	00 
  101950:	83 ca 80             	or     $0xffffff80,%edx
  101953:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10195a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195d:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  101964:	c1 e8 10             	shr    $0x10,%eax
  101967:	89 c2                	mov    %eax,%edx
  101969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196c:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  101973:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {//在数组长度内初始化中断向量表
  101974:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197b:	3d ff 00 00 00       	cmp    $0xff,%eax
  101980:	0f 86 2f ff ff ff    	jbe    1018b5 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);//使用非陷阱门描述符，在内核级设置中断向量表
	}
	// set for switch from user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);//设置用户级转向内核级的中断向量表
  101986:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  10198b:	66 a3 48 aa 11 00    	mov    %ax,0x11aa48
  101991:	66 c7 05 4a aa 11 00 	movw   $0x8,0x11aa4a
  101998:	08 00 
  10199a:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019a1:	83 e0 e0             	and    $0xffffffe0,%eax
  1019a4:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019a9:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019b0:	83 e0 1f             	and    $0x1f,%eax
  1019b3:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019b8:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019bf:	83 e0 f0             	and    $0xfffffff0,%eax
  1019c2:	83 c8 0e             	or     $0xe,%eax
  1019c5:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  1019ca:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019d1:	83 e0 ef             	and    $0xffffffef,%eax
  1019d4:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  1019d9:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019e0:	83 c8 60             	or     $0x60,%eax
  1019e3:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  1019e8:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019ef:	83 c8 80             	or     $0xffffff80,%eax
  1019f2:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  1019f7:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  1019fc:	c1 e8 10             	shr    $0x10,%eax
  1019ff:	66 a3 4e aa 11 00    	mov    %ax,0x11aa4e
  101a05:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a0f:	0f 01 18             	lidtl  (%eax)
	// load the IDT
	lidt(&idt_pd);//加载中断向量表
}
  101a12:	c9                   	leave  
  101a13:	c3                   	ret    

00101a14 <trapname>:

static const char *
trapname(int trapno) {
  101a14:	55                   	push   %ebp
  101a15:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a17:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1a:	83 f8 13             	cmp    $0x13,%eax
  101a1d:	77 0c                	ja     101a2b <trapname+0x17>
        return excnames[trapno];
  101a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a22:	8b 04 85 c0 64 10 00 	mov    0x1064c0(,%eax,4),%eax
  101a29:	eb 18                	jmp    101a43 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a2b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a2f:	7e 0d                	jle    101a3e <trapname+0x2a>
  101a31:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a35:	7f 07                	jg     101a3e <trapname+0x2a>
        return "Hardware Interrupt";
  101a37:	b8 6a 61 10 00       	mov    $0x10616a,%eax
  101a3c:	eb 05                	jmp    101a43 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a3e:	b8 7d 61 10 00       	mov    $0x10617d,%eax
}
  101a43:	5d                   	pop    %ebp
  101a44:	c3                   	ret    

00101a45 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a45:	55                   	push   %ebp
  101a46:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a48:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a4f:	66 83 f8 08          	cmp    $0x8,%ax
  101a53:	0f 94 c0             	sete   %al
  101a56:	0f b6 c0             	movzbl %al,%eax
}
  101a59:	5d                   	pop    %ebp
  101a5a:	c3                   	ret    

00101a5b <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a5b:	55                   	push   %ebp
  101a5c:	89 e5                	mov    %esp,%ebp
  101a5e:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a61:	8b 45 08             	mov    0x8(%ebp),%eax
  101a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a68:	c7 04 24 be 61 10 00 	movl   $0x1061be,(%esp)
  101a6f:	e8 d4 e8 ff ff       	call   100348 <cprintf>
    print_regs(&tf->tf_regs);
  101a74:	8b 45 08             	mov    0x8(%ebp),%eax
  101a77:	89 04 24             	mov    %eax,(%esp)
  101a7a:	e8 a1 01 00 00       	call   101c20 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a82:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a86:	0f b7 c0             	movzwl %ax,%eax
  101a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8d:	c7 04 24 cf 61 10 00 	movl   $0x1061cf,(%esp)
  101a94:	e8 af e8 ff ff       	call   100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a99:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101aa0:	0f b7 c0             	movzwl %ax,%eax
  101aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa7:	c7 04 24 e2 61 10 00 	movl   $0x1061e2,(%esp)
  101aae:	e8 95 e8 ff ff       	call   100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab6:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aba:	0f b7 c0             	movzwl %ax,%eax
  101abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac1:	c7 04 24 f5 61 10 00 	movl   $0x1061f5,(%esp)
  101ac8:	e8 7b e8 ff ff       	call   100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101acd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad0:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ad4:	0f b7 c0             	movzwl %ax,%eax
  101ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101adb:	c7 04 24 08 62 10 00 	movl   $0x106208,(%esp)
  101ae2:	e8 61 e8 ff ff       	call   100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aea:	8b 40 30             	mov    0x30(%eax),%eax
  101aed:	89 04 24             	mov    %eax,(%esp)
  101af0:	e8 1f ff ff ff       	call   101a14 <trapname>
  101af5:	8b 55 08             	mov    0x8(%ebp),%edx
  101af8:	8b 52 30             	mov    0x30(%edx),%edx
  101afb:	89 44 24 08          	mov    %eax,0x8(%esp)
  101aff:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b03:	c7 04 24 1b 62 10 00 	movl   $0x10621b,(%esp)
  101b0a:	e8 39 e8 ff ff       	call   100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b12:	8b 40 34             	mov    0x34(%eax),%eax
  101b15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b19:	c7 04 24 2d 62 10 00 	movl   $0x10622d,(%esp)
  101b20:	e8 23 e8 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b25:	8b 45 08             	mov    0x8(%ebp),%eax
  101b28:	8b 40 38             	mov    0x38(%eax),%eax
  101b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2f:	c7 04 24 3c 62 10 00 	movl   $0x10623c,(%esp)
  101b36:	e8 0d e8 ff ff       	call   100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b42:	0f b7 c0             	movzwl %ax,%eax
  101b45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b49:	c7 04 24 4b 62 10 00 	movl   $0x10624b,(%esp)
  101b50:	e8 f3 e7 ff ff       	call   100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b55:	8b 45 08             	mov    0x8(%ebp),%eax
  101b58:	8b 40 40             	mov    0x40(%eax),%eax
  101b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5f:	c7 04 24 5e 62 10 00 	movl   $0x10625e,(%esp)
  101b66:	e8 dd e7 ff ff       	call   100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b72:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b79:	eb 3e                	jmp    101bb9 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7e:	8b 50 40             	mov    0x40(%eax),%edx
  101b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b84:	21 d0                	and    %edx,%eax
  101b86:	85 c0                	test   %eax,%eax
  101b88:	74 28                	je     101bb2 <print_trapframe+0x157>
  101b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b8d:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101b94:	85 c0                	test   %eax,%eax
  101b96:	74 1a                	je     101bb2 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b9b:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba6:	c7 04 24 6d 62 10 00 	movl   $0x10626d,(%esp)
  101bad:	e8 96 e7 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bb2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bb6:	d1 65 f0             	shll   -0x10(%ebp)
  101bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bbc:	83 f8 17             	cmp    $0x17,%eax
  101bbf:	76 ba                	jbe    101b7b <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc4:	8b 40 40             	mov    0x40(%eax),%eax
  101bc7:	25 00 30 00 00       	and    $0x3000,%eax
  101bcc:	c1 e8 0c             	shr    $0xc,%eax
  101bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd3:	c7 04 24 71 62 10 00 	movl   $0x106271,(%esp)
  101bda:	e8 69 e7 ff ff       	call   100348 <cprintf>

    if (!trap_in_kernel(tf)) {
  101bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  101be2:	89 04 24             	mov    %eax,(%esp)
  101be5:	e8 5b fe ff ff       	call   101a45 <trap_in_kernel>
  101bea:	85 c0                	test   %eax,%eax
  101bec:	75 30                	jne    101c1e <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bee:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf1:	8b 40 44             	mov    0x44(%eax),%eax
  101bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf8:	c7 04 24 7a 62 10 00 	movl   $0x10627a,(%esp)
  101bff:	e8 44 e7 ff ff       	call   100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c04:	8b 45 08             	mov    0x8(%ebp),%eax
  101c07:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c0b:	0f b7 c0             	movzwl %ax,%eax
  101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c12:	c7 04 24 89 62 10 00 	movl   $0x106289,(%esp)
  101c19:	e8 2a e7 ff ff       	call   100348 <cprintf>
    }
}
  101c1e:	c9                   	leave  
  101c1f:	c3                   	ret    

00101c20 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c20:	55                   	push   %ebp
  101c21:	89 e5                	mov    %esp,%ebp
  101c23:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c26:	8b 45 08             	mov    0x8(%ebp),%eax
  101c29:	8b 00                	mov    (%eax),%eax
  101c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2f:	c7 04 24 9c 62 10 00 	movl   $0x10629c,(%esp)
  101c36:	e8 0d e7 ff ff       	call   100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3e:	8b 40 04             	mov    0x4(%eax),%eax
  101c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c45:	c7 04 24 ab 62 10 00 	movl   $0x1062ab,(%esp)
  101c4c:	e8 f7 e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c51:	8b 45 08             	mov    0x8(%ebp),%eax
  101c54:	8b 40 08             	mov    0x8(%eax),%eax
  101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5b:	c7 04 24 ba 62 10 00 	movl   $0x1062ba,(%esp)
  101c62:	e8 e1 e6 ff ff       	call   100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c67:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6a:	8b 40 0c             	mov    0xc(%eax),%eax
  101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c71:	c7 04 24 c9 62 10 00 	movl   $0x1062c9,(%esp)
  101c78:	e8 cb e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c80:	8b 40 10             	mov    0x10(%eax),%eax
  101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c87:	c7 04 24 d8 62 10 00 	movl   $0x1062d8,(%esp)
  101c8e:	e8 b5 e6 ff ff       	call   100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	8b 40 14             	mov    0x14(%eax),%eax
  101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9d:	c7 04 24 e7 62 10 00 	movl   $0x1062e7,(%esp)
  101ca4:	e8 9f e6 ff ff       	call   100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cac:	8b 40 18             	mov    0x18(%eax),%eax
  101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb3:	c7 04 24 f6 62 10 00 	movl   $0x1062f6,(%esp)
  101cba:	e8 89 e6 ff ff       	call   100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc2:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc9:	c7 04 24 05 63 10 00 	movl   $0x106305,(%esp)
  101cd0:	e8 73 e6 ff ff       	call   100348 <cprintf>
}
  101cd5:	c9                   	leave  
  101cd6:	c3                   	ret    

00101cd7 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cd7:	55                   	push   %ebp
  101cd8:	89 e5                	mov    %esp,%ebp
  101cda:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce0:	8b 40 30             	mov    0x30(%eax),%eax
  101ce3:	83 f8 2f             	cmp    $0x2f,%eax
  101ce6:	77 21                	ja     101d09 <trap_dispatch+0x32>
  101ce8:	83 f8 2e             	cmp    $0x2e,%eax
  101ceb:	0f 83 04 01 00 00    	jae    101df5 <trap_dispatch+0x11e>
  101cf1:	83 f8 21             	cmp    $0x21,%eax
  101cf4:	0f 84 81 00 00 00    	je     101d7b <trap_dispatch+0xa4>
  101cfa:	83 f8 24             	cmp    $0x24,%eax
  101cfd:	74 56                	je     101d55 <trap_dispatch+0x7e>
  101cff:	83 f8 20             	cmp    $0x20,%eax
  101d02:	74 16                	je     101d1a <trap_dispatch+0x43>
  101d04:	e9 b4 00 00 00       	jmp    101dbd <trap_dispatch+0xe6>
  101d09:	83 e8 78             	sub    $0x78,%eax
  101d0c:	83 f8 01             	cmp    $0x1,%eax
  101d0f:	0f 87 a8 00 00 00    	ja     101dbd <trap_dispatch+0xe6>
  101d15:	e9 87 00 00 00       	jmp    101da1 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
  101d1a:	a1 0c af 11 00       	mov    0x11af0c,%eax
  101d1f:	83 c0 01             	add    $0x1,%eax
  101d22:	a3 0c af 11 00       	mov    %eax,0x11af0c
	if(ticks%TICK_NUM == 0)
  101d27:	8b 0d 0c af 11 00    	mov    0x11af0c,%ecx
  101d2d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d32:	89 c8                	mov    %ecx,%eax
  101d34:	f7 e2                	mul    %edx
  101d36:	89 d0                	mov    %edx,%eax
  101d38:	c1 e8 05             	shr    $0x5,%eax
  101d3b:	6b c0 64             	imul   $0x64,%eax,%eax
  101d3e:	29 c1                	sub    %eax,%ecx
  101d40:	89 c8                	mov    %ecx,%eax
  101d42:	85 c0                	test   %eax,%eax
  101d44:	75 0a                	jne    101d50 <trap_dispatch+0x79>
        {
            print_ticks();
  101d46:	e8 3c fb ff ff       	call   101887 <print_ticks>
        }
        break;
  101d4b:	e9 a6 00 00 00       	jmp    101df6 <trap_dispatch+0x11f>
  101d50:	e9 a1 00 00 00       	jmp    101df6 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d55:	e8 f1 f8 ff ff       	call   10164b <cons_getc>
  101d5a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d5d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d61:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d65:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d6d:	c7 04 24 14 63 10 00 	movl   $0x106314,(%esp)
  101d74:	e8 cf e5 ff ff       	call   100348 <cprintf>
        break;
  101d79:	eb 7b                	jmp    101df6 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d7b:	e8 cb f8 ff ff       	call   10164b <cons_getc>
  101d80:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d83:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d87:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d93:	c7 04 24 26 63 10 00 	movl   $0x106326,(%esp)
  101d9a:	e8 a9 e5 ff ff       	call   100348 <cprintf>
        break;
  101d9f:	eb 55                	jmp    101df6 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101da1:	c7 44 24 08 35 63 10 	movl   $0x106335,0x8(%esp)
  101da8:	00 
  101da9:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  101db0:	00 
  101db1:	c7 04 24 45 63 10 00 	movl   $0x106345,(%esp)
  101db8:	e8 0f ef ff ff       	call   100ccc <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dc4:	0f b7 c0             	movzwl %ax,%eax
  101dc7:	83 e0 03             	and    $0x3,%eax
  101dca:	85 c0                	test   %eax,%eax
  101dcc:	75 28                	jne    101df6 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101dce:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd1:	89 04 24             	mov    %eax,(%esp)
  101dd4:	e8 82 fc ff ff       	call   101a5b <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101dd9:	c7 44 24 08 56 63 10 	movl   $0x106356,0x8(%esp)
  101de0:	00 
  101de1:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  101de8:	00 
  101de9:	c7 04 24 45 63 10 00 	movl   $0x106345,(%esp)
  101df0:	e8 d7 ee ff ff       	call   100ccc <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101df5:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101df6:	c9                   	leave  
  101df7:	c3                   	ret    

00101df8 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101df8:	55                   	push   %ebp
  101df9:	89 e5                	mov    %esp,%ebp
  101dfb:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101e01:	89 04 24             	mov    %eax,(%esp)
  101e04:	e8 ce fe ff ff       	call   101cd7 <trap_dispatch>
}
  101e09:	c9                   	leave  
  101e0a:	c3                   	ret    

00101e0b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e0b:	1e                   	push   %ds
    pushl %es
  101e0c:	06                   	push   %es
    pushl %fs
  101e0d:	0f a0                	push   %fs
    pushl %gs
  101e0f:	0f a8                	push   %gs
    pushal
  101e11:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e12:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e17:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e19:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e1b:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e1c:	e8 d7 ff ff ff       	call   101df8 <trap>

    # pop the pushed stack pointer
    popl %esp
  101e21:	5c                   	pop    %esp

00101e22 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e22:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e23:	0f a9                	pop    %gs
    popl %fs
  101e25:	0f a1                	pop    %fs
    popl %es
  101e27:	07                   	pop    %es
    popl %ds
  101e28:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e29:	83 c4 08             	add    $0x8,%esp
    iret
  101e2c:	cf                   	iret   

00101e2d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e2d:	6a 00                	push   $0x0
  pushl $0
  101e2f:	6a 00                	push   $0x0
  jmp __alltraps
  101e31:	e9 d5 ff ff ff       	jmp    101e0b <__alltraps>

00101e36 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $1
  101e38:	6a 01                	push   $0x1
  jmp __alltraps
  101e3a:	e9 cc ff ff ff       	jmp    101e0b <__alltraps>

00101e3f <vector2>:
.globl vector2
vector2:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $2
  101e41:	6a 02                	push   $0x2
  jmp __alltraps
  101e43:	e9 c3 ff ff ff       	jmp    101e0b <__alltraps>

00101e48 <vector3>:
.globl vector3
vector3:
  pushl $0
  101e48:	6a 00                	push   $0x0
  pushl $3
  101e4a:	6a 03                	push   $0x3
  jmp __alltraps
  101e4c:	e9 ba ff ff ff       	jmp    101e0b <__alltraps>

00101e51 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e51:	6a 00                	push   $0x0
  pushl $4
  101e53:	6a 04                	push   $0x4
  jmp __alltraps
  101e55:	e9 b1 ff ff ff       	jmp    101e0b <__alltraps>

00101e5a <vector5>:
.globl vector5
vector5:
  pushl $0
  101e5a:	6a 00                	push   $0x0
  pushl $5
  101e5c:	6a 05                	push   $0x5
  jmp __alltraps
  101e5e:	e9 a8 ff ff ff       	jmp    101e0b <__alltraps>

00101e63 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e63:	6a 00                	push   $0x0
  pushl $6
  101e65:	6a 06                	push   $0x6
  jmp __alltraps
  101e67:	e9 9f ff ff ff       	jmp    101e0b <__alltraps>

00101e6c <vector7>:
.globl vector7
vector7:
  pushl $0
  101e6c:	6a 00                	push   $0x0
  pushl $7
  101e6e:	6a 07                	push   $0x7
  jmp __alltraps
  101e70:	e9 96 ff ff ff       	jmp    101e0b <__alltraps>

00101e75 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e75:	6a 08                	push   $0x8
  jmp __alltraps
  101e77:	e9 8f ff ff ff       	jmp    101e0b <__alltraps>

00101e7c <vector9>:
.globl vector9
vector9:
  pushl $0
  101e7c:	6a 00                	push   $0x0
  pushl $9
  101e7e:	6a 09                	push   $0x9
  jmp __alltraps
  101e80:	e9 86 ff ff ff       	jmp    101e0b <__alltraps>

00101e85 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e85:	6a 0a                	push   $0xa
  jmp __alltraps
  101e87:	e9 7f ff ff ff       	jmp    101e0b <__alltraps>

00101e8c <vector11>:
.globl vector11
vector11:
  pushl $11
  101e8c:	6a 0b                	push   $0xb
  jmp __alltraps
  101e8e:	e9 78 ff ff ff       	jmp    101e0b <__alltraps>

00101e93 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e93:	6a 0c                	push   $0xc
  jmp __alltraps
  101e95:	e9 71 ff ff ff       	jmp    101e0b <__alltraps>

00101e9a <vector13>:
.globl vector13
vector13:
  pushl $13
  101e9a:	6a 0d                	push   $0xd
  jmp __alltraps
  101e9c:	e9 6a ff ff ff       	jmp    101e0b <__alltraps>

00101ea1 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ea1:	6a 0e                	push   $0xe
  jmp __alltraps
  101ea3:	e9 63 ff ff ff       	jmp    101e0b <__alltraps>

00101ea8 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ea8:	6a 00                	push   $0x0
  pushl $15
  101eaa:	6a 0f                	push   $0xf
  jmp __alltraps
  101eac:	e9 5a ff ff ff       	jmp    101e0b <__alltraps>

00101eb1 <vector16>:
.globl vector16
vector16:
  pushl $0
  101eb1:	6a 00                	push   $0x0
  pushl $16
  101eb3:	6a 10                	push   $0x10
  jmp __alltraps
  101eb5:	e9 51 ff ff ff       	jmp    101e0b <__alltraps>

00101eba <vector17>:
.globl vector17
vector17:
  pushl $17
  101eba:	6a 11                	push   $0x11
  jmp __alltraps
  101ebc:	e9 4a ff ff ff       	jmp    101e0b <__alltraps>

00101ec1 <vector18>:
.globl vector18
vector18:
  pushl $0
  101ec1:	6a 00                	push   $0x0
  pushl $18
  101ec3:	6a 12                	push   $0x12
  jmp __alltraps
  101ec5:	e9 41 ff ff ff       	jmp    101e0b <__alltraps>

00101eca <vector19>:
.globl vector19
vector19:
  pushl $0
  101eca:	6a 00                	push   $0x0
  pushl $19
  101ecc:	6a 13                	push   $0x13
  jmp __alltraps
  101ece:	e9 38 ff ff ff       	jmp    101e0b <__alltraps>

00101ed3 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ed3:	6a 00                	push   $0x0
  pushl $20
  101ed5:	6a 14                	push   $0x14
  jmp __alltraps
  101ed7:	e9 2f ff ff ff       	jmp    101e0b <__alltraps>

00101edc <vector21>:
.globl vector21
vector21:
  pushl $0
  101edc:	6a 00                	push   $0x0
  pushl $21
  101ede:	6a 15                	push   $0x15
  jmp __alltraps
  101ee0:	e9 26 ff ff ff       	jmp    101e0b <__alltraps>

00101ee5 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ee5:	6a 00                	push   $0x0
  pushl $22
  101ee7:	6a 16                	push   $0x16
  jmp __alltraps
  101ee9:	e9 1d ff ff ff       	jmp    101e0b <__alltraps>

00101eee <vector23>:
.globl vector23
vector23:
  pushl $0
  101eee:	6a 00                	push   $0x0
  pushl $23
  101ef0:	6a 17                	push   $0x17
  jmp __alltraps
  101ef2:	e9 14 ff ff ff       	jmp    101e0b <__alltraps>

00101ef7 <vector24>:
.globl vector24
vector24:
  pushl $0
  101ef7:	6a 00                	push   $0x0
  pushl $24
  101ef9:	6a 18                	push   $0x18
  jmp __alltraps
  101efb:	e9 0b ff ff ff       	jmp    101e0b <__alltraps>

00101f00 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f00:	6a 00                	push   $0x0
  pushl $25
  101f02:	6a 19                	push   $0x19
  jmp __alltraps
  101f04:	e9 02 ff ff ff       	jmp    101e0b <__alltraps>

00101f09 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f09:	6a 00                	push   $0x0
  pushl $26
  101f0b:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f0d:	e9 f9 fe ff ff       	jmp    101e0b <__alltraps>

00101f12 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f12:	6a 00                	push   $0x0
  pushl $27
  101f14:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f16:	e9 f0 fe ff ff       	jmp    101e0b <__alltraps>

00101f1b <vector28>:
.globl vector28
vector28:
  pushl $0
  101f1b:	6a 00                	push   $0x0
  pushl $28
  101f1d:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f1f:	e9 e7 fe ff ff       	jmp    101e0b <__alltraps>

00101f24 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f24:	6a 00                	push   $0x0
  pushl $29
  101f26:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f28:	e9 de fe ff ff       	jmp    101e0b <__alltraps>

00101f2d <vector30>:
.globl vector30
vector30:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $30
  101f2f:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f31:	e9 d5 fe ff ff       	jmp    101e0b <__alltraps>

00101f36 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $31
  101f38:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f3a:	e9 cc fe ff ff       	jmp    101e0b <__alltraps>

00101f3f <vector32>:
.globl vector32
vector32:
  pushl $0
  101f3f:	6a 00                	push   $0x0
  pushl $32
  101f41:	6a 20                	push   $0x20
  jmp __alltraps
  101f43:	e9 c3 fe ff ff       	jmp    101e0b <__alltraps>

00101f48 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $33
  101f4a:	6a 21                	push   $0x21
  jmp __alltraps
  101f4c:	e9 ba fe ff ff       	jmp    101e0b <__alltraps>

00101f51 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $34
  101f53:	6a 22                	push   $0x22
  jmp __alltraps
  101f55:	e9 b1 fe ff ff       	jmp    101e0b <__alltraps>

00101f5a <vector35>:
.globl vector35
vector35:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $35
  101f5c:	6a 23                	push   $0x23
  jmp __alltraps
  101f5e:	e9 a8 fe ff ff       	jmp    101e0b <__alltraps>

00101f63 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $36
  101f65:	6a 24                	push   $0x24
  jmp __alltraps
  101f67:	e9 9f fe ff ff       	jmp    101e0b <__alltraps>

00101f6c <vector37>:
.globl vector37
vector37:
  pushl $0
  101f6c:	6a 00                	push   $0x0
  pushl $37
  101f6e:	6a 25                	push   $0x25
  jmp __alltraps
  101f70:	e9 96 fe ff ff       	jmp    101e0b <__alltraps>

00101f75 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $38
  101f77:	6a 26                	push   $0x26
  jmp __alltraps
  101f79:	e9 8d fe ff ff       	jmp    101e0b <__alltraps>

00101f7e <vector39>:
.globl vector39
vector39:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $39
  101f80:	6a 27                	push   $0x27
  jmp __alltraps
  101f82:	e9 84 fe ff ff       	jmp    101e0b <__alltraps>

00101f87 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $40
  101f89:	6a 28                	push   $0x28
  jmp __alltraps
  101f8b:	e9 7b fe ff ff       	jmp    101e0b <__alltraps>

00101f90 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $41
  101f92:	6a 29                	push   $0x29
  jmp __alltraps
  101f94:	e9 72 fe ff ff       	jmp    101e0b <__alltraps>

00101f99 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $42
  101f9b:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f9d:	e9 69 fe ff ff       	jmp    101e0b <__alltraps>

00101fa2 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $43
  101fa4:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fa6:	e9 60 fe ff ff       	jmp    101e0b <__alltraps>

00101fab <vector44>:
.globl vector44
vector44:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $44
  101fad:	6a 2c                	push   $0x2c
  jmp __alltraps
  101faf:	e9 57 fe ff ff       	jmp    101e0b <__alltraps>

00101fb4 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $45
  101fb6:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fb8:	e9 4e fe ff ff       	jmp    101e0b <__alltraps>

00101fbd <vector46>:
.globl vector46
vector46:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $46
  101fbf:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fc1:	e9 45 fe ff ff       	jmp    101e0b <__alltraps>

00101fc6 <vector47>:
.globl vector47
vector47:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $47
  101fc8:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fca:	e9 3c fe ff ff       	jmp    101e0b <__alltraps>

00101fcf <vector48>:
.globl vector48
vector48:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $48
  101fd1:	6a 30                	push   $0x30
  jmp __alltraps
  101fd3:	e9 33 fe ff ff       	jmp    101e0b <__alltraps>

00101fd8 <vector49>:
.globl vector49
vector49:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $49
  101fda:	6a 31                	push   $0x31
  jmp __alltraps
  101fdc:	e9 2a fe ff ff       	jmp    101e0b <__alltraps>

00101fe1 <vector50>:
.globl vector50
vector50:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $50
  101fe3:	6a 32                	push   $0x32
  jmp __alltraps
  101fe5:	e9 21 fe ff ff       	jmp    101e0b <__alltraps>

00101fea <vector51>:
.globl vector51
vector51:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $51
  101fec:	6a 33                	push   $0x33
  jmp __alltraps
  101fee:	e9 18 fe ff ff       	jmp    101e0b <__alltraps>

00101ff3 <vector52>:
.globl vector52
vector52:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $52
  101ff5:	6a 34                	push   $0x34
  jmp __alltraps
  101ff7:	e9 0f fe ff ff       	jmp    101e0b <__alltraps>

00101ffc <vector53>:
.globl vector53
vector53:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $53
  101ffe:	6a 35                	push   $0x35
  jmp __alltraps
  102000:	e9 06 fe ff ff       	jmp    101e0b <__alltraps>

00102005 <vector54>:
.globl vector54
vector54:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $54
  102007:	6a 36                	push   $0x36
  jmp __alltraps
  102009:	e9 fd fd ff ff       	jmp    101e0b <__alltraps>

0010200e <vector55>:
.globl vector55
vector55:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $55
  102010:	6a 37                	push   $0x37
  jmp __alltraps
  102012:	e9 f4 fd ff ff       	jmp    101e0b <__alltraps>

00102017 <vector56>:
.globl vector56
vector56:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $56
  102019:	6a 38                	push   $0x38
  jmp __alltraps
  10201b:	e9 eb fd ff ff       	jmp    101e0b <__alltraps>

00102020 <vector57>:
.globl vector57
vector57:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $57
  102022:	6a 39                	push   $0x39
  jmp __alltraps
  102024:	e9 e2 fd ff ff       	jmp    101e0b <__alltraps>

00102029 <vector58>:
.globl vector58
vector58:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $58
  10202b:	6a 3a                	push   $0x3a
  jmp __alltraps
  10202d:	e9 d9 fd ff ff       	jmp    101e0b <__alltraps>

00102032 <vector59>:
.globl vector59
vector59:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $59
  102034:	6a 3b                	push   $0x3b
  jmp __alltraps
  102036:	e9 d0 fd ff ff       	jmp    101e0b <__alltraps>

0010203b <vector60>:
.globl vector60
vector60:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $60
  10203d:	6a 3c                	push   $0x3c
  jmp __alltraps
  10203f:	e9 c7 fd ff ff       	jmp    101e0b <__alltraps>

00102044 <vector61>:
.globl vector61
vector61:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $61
  102046:	6a 3d                	push   $0x3d
  jmp __alltraps
  102048:	e9 be fd ff ff       	jmp    101e0b <__alltraps>

0010204d <vector62>:
.globl vector62
vector62:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $62
  10204f:	6a 3e                	push   $0x3e
  jmp __alltraps
  102051:	e9 b5 fd ff ff       	jmp    101e0b <__alltraps>

00102056 <vector63>:
.globl vector63
vector63:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $63
  102058:	6a 3f                	push   $0x3f
  jmp __alltraps
  10205a:	e9 ac fd ff ff       	jmp    101e0b <__alltraps>

0010205f <vector64>:
.globl vector64
vector64:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $64
  102061:	6a 40                	push   $0x40
  jmp __alltraps
  102063:	e9 a3 fd ff ff       	jmp    101e0b <__alltraps>

00102068 <vector65>:
.globl vector65
vector65:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $65
  10206a:	6a 41                	push   $0x41
  jmp __alltraps
  10206c:	e9 9a fd ff ff       	jmp    101e0b <__alltraps>

00102071 <vector66>:
.globl vector66
vector66:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $66
  102073:	6a 42                	push   $0x42
  jmp __alltraps
  102075:	e9 91 fd ff ff       	jmp    101e0b <__alltraps>

0010207a <vector67>:
.globl vector67
vector67:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $67
  10207c:	6a 43                	push   $0x43
  jmp __alltraps
  10207e:	e9 88 fd ff ff       	jmp    101e0b <__alltraps>

00102083 <vector68>:
.globl vector68
vector68:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $68
  102085:	6a 44                	push   $0x44
  jmp __alltraps
  102087:	e9 7f fd ff ff       	jmp    101e0b <__alltraps>

0010208c <vector69>:
.globl vector69
vector69:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $69
  10208e:	6a 45                	push   $0x45
  jmp __alltraps
  102090:	e9 76 fd ff ff       	jmp    101e0b <__alltraps>

00102095 <vector70>:
.globl vector70
vector70:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $70
  102097:	6a 46                	push   $0x46
  jmp __alltraps
  102099:	e9 6d fd ff ff       	jmp    101e0b <__alltraps>

0010209e <vector71>:
.globl vector71
vector71:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $71
  1020a0:	6a 47                	push   $0x47
  jmp __alltraps
  1020a2:	e9 64 fd ff ff       	jmp    101e0b <__alltraps>

001020a7 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $72
  1020a9:	6a 48                	push   $0x48
  jmp __alltraps
  1020ab:	e9 5b fd ff ff       	jmp    101e0b <__alltraps>

001020b0 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $73
  1020b2:	6a 49                	push   $0x49
  jmp __alltraps
  1020b4:	e9 52 fd ff ff       	jmp    101e0b <__alltraps>

001020b9 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $74
  1020bb:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020bd:	e9 49 fd ff ff       	jmp    101e0b <__alltraps>

001020c2 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $75
  1020c4:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020c6:	e9 40 fd ff ff       	jmp    101e0b <__alltraps>

001020cb <vector76>:
.globl vector76
vector76:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $76
  1020cd:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020cf:	e9 37 fd ff ff       	jmp    101e0b <__alltraps>

001020d4 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $77
  1020d6:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020d8:	e9 2e fd ff ff       	jmp    101e0b <__alltraps>

001020dd <vector78>:
.globl vector78
vector78:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $78
  1020df:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020e1:	e9 25 fd ff ff       	jmp    101e0b <__alltraps>

001020e6 <vector79>:
.globl vector79
vector79:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $79
  1020e8:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020ea:	e9 1c fd ff ff       	jmp    101e0b <__alltraps>

001020ef <vector80>:
.globl vector80
vector80:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $80
  1020f1:	6a 50                	push   $0x50
  jmp __alltraps
  1020f3:	e9 13 fd ff ff       	jmp    101e0b <__alltraps>

001020f8 <vector81>:
.globl vector81
vector81:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $81
  1020fa:	6a 51                	push   $0x51
  jmp __alltraps
  1020fc:	e9 0a fd ff ff       	jmp    101e0b <__alltraps>

00102101 <vector82>:
.globl vector82
vector82:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $82
  102103:	6a 52                	push   $0x52
  jmp __alltraps
  102105:	e9 01 fd ff ff       	jmp    101e0b <__alltraps>

0010210a <vector83>:
.globl vector83
vector83:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $83
  10210c:	6a 53                	push   $0x53
  jmp __alltraps
  10210e:	e9 f8 fc ff ff       	jmp    101e0b <__alltraps>

00102113 <vector84>:
.globl vector84
vector84:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $84
  102115:	6a 54                	push   $0x54
  jmp __alltraps
  102117:	e9 ef fc ff ff       	jmp    101e0b <__alltraps>

0010211c <vector85>:
.globl vector85
vector85:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $85
  10211e:	6a 55                	push   $0x55
  jmp __alltraps
  102120:	e9 e6 fc ff ff       	jmp    101e0b <__alltraps>

00102125 <vector86>:
.globl vector86
vector86:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $86
  102127:	6a 56                	push   $0x56
  jmp __alltraps
  102129:	e9 dd fc ff ff       	jmp    101e0b <__alltraps>

0010212e <vector87>:
.globl vector87
vector87:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $87
  102130:	6a 57                	push   $0x57
  jmp __alltraps
  102132:	e9 d4 fc ff ff       	jmp    101e0b <__alltraps>

00102137 <vector88>:
.globl vector88
vector88:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $88
  102139:	6a 58                	push   $0x58
  jmp __alltraps
  10213b:	e9 cb fc ff ff       	jmp    101e0b <__alltraps>

00102140 <vector89>:
.globl vector89
vector89:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $89
  102142:	6a 59                	push   $0x59
  jmp __alltraps
  102144:	e9 c2 fc ff ff       	jmp    101e0b <__alltraps>

00102149 <vector90>:
.globl vector90
vector90:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $90
  10214b:	6a 5a                	push   $0x5a
  jmp __alltraps
  10214d:	e9 b9 fc ff ff       	jmp    101e0b <__alltraps>

00102152 <vector91>:
.globl vector91
vector91:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $91
  102154:	6a 5b                	push   $0x5b
  jmp __alltraps
  102156:	e9 b0 fc ff ff       	jmp    101e0b <__alltraps>

0010215b <vector92>:
.globl vector92
vector92:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $92
  10215d:	6a 5c                	push   $0x5c
  jmp __alltraps
  10215f:	e9 a7 fc ff ff       	jmp    101e0b <__alltraps>

00102164 <vector93>:
.globl vector93
vector93:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $93
  102166:	6a 5d                	push   $0x5d
  jmp __alltraps
  102168:	e9 9e fc ff ff       	jmp    101e0b <__alltraps>

0010216d <vector94>:
.globl vector94
vector94:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $94
  10216f:	6a 5e                	push   $0x5e
  jmp __alltraps
  102171:	e9 95 fc ff ff       	jmp    101e0b <__alltraps>

00102176 <vector95>:
.globl vector95
vector95:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $95
  102178:	6a 5f                	push   $0x5f
  jmp __alltraps
  10217a:	e9 8c fc ff ff       	jmp    101e0b <__alltraps>

0010217f <vector96>:
.globl vector96
vector96:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $96
  102181:	6a 60                	push   $0x60
  jmp __alltraps
  102183:	e9 83 fc ff ff       	jmp    101e0b <__alltraps>

00102188 <vector97>:
.globl vector97
vector97:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $97
  10218a:	6a 61                	push   $0x61
  jmp __alltraps
  10218c:	e9 7a fc ff ff       	jmp    101e0b <__alltraps>

00102191 <vector98>:
.globl vector98
vector98:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $98
  102193:	6a 62                	push   $0x62
  jmp __alltraps
  102195:	e9 71 fc ff ff       	jmp    101e0b <__alltraps>

0010219a <vector99>:
.globl vector99
vector99:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $99
  10219c:	6a 63                	push   $0x63
  jmp __alltraps
  10219e:	e9 68 fc ff ff       	jmp    101e0b <__alltraps>

001021a3 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $100
  1021a5:	6a 64                	push   $0x64
  jmp __alltraps
  1021a7:	e9 5f fc ff ff       	jmp    101e0b <__alltraps>

001021ac <vector101>:
.globl vector101
vector101:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $101
  1021ae:	6a 65                	push   $0x65
  jmp __alltraps
  1021b0:	e9 56 fc ff ff       	jmp    101e0b <__alltraps>

001021b5 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $102
  1021b7:	6a 66                	push   $0x66
  jmp __alltraps
  1021b9:	e9 4d fc ff ff       	jmp    101e0b <__alltraps>

001021be <vector103>:
.globl vector103
vector103:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $103
  1021c0:	6a 67                	push   $0x67
  jmp __alltraps
  1021c2:	e9 44 fc ff ff       	jmp    101e0b <__alltraps>

001021c7 <vector104>:
.globl vector104
vector104:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $104
  1021c9:	6a 68                	push   $0x68
  jmp __alltraps
  1021cb:	e9 3b fc ff ff       	jmp    101e0b <__alltraps>

001021d0 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $105
  1021d2:	6a 69                	push   $0x69
  jmp __alltraps
  1021d4:	e9 32 fc ff ff       	jmp    101e0b <__alltraps>

001021d9 <vector106>:
.globl vector106
vector106:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $106
  1021db:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021dd:	e9 29 fc ff ff       	jmp    101e0b <__alltraps>

001021e2 <vector107>:
.globl vector107
vector107:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $107
  1021e4:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021e6:	e9 20 fc ff ff       	jmp    101e0b <__alltraps>

001021eb <vector108>:
.globl vector108
vector108:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $108
  1021ed:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021ef:	e9 17 fc ff ff       	jmp    101e0b <__alltraps>

001021f4 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $109
  1021f6:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021f8:	e9 0e fc ff ff       	jmp    101e0b <__alltraps>

001021fd <vector110>:
.globl vector110
vector110:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $110
  1021ff:	6a 6e                	push   $0x6e
  jmp __alltraps
  102201:	e9 05 fc ff ff       	jmp    101e0b <__alltraps>

00102206 <vector111>:
.globl vector111
vector111:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $111
  102208:	6a 6f                	push   $0x6f
  jmp __alltraps
  10220a:	e9 fc fb ff ff       	jmp    101e0b <__alltraps>

0010220f <vector112>:
.globl vector112
vector112:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $112
  102211:	6a 70                	push   $0x70
  jmp __alltraps
  102213:	e9 f3 fb ff ff       	jmp    101e0b <__alltraps>

00102218 <vector113>:
.globl vector113
vector113:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $113
  10221a:	6a 71                	push   $0x71
  jmp __alltraps
  10221c:	e9 ea fb ff ff       	jmp    101e0b <__alltraps>

00102221 <vector114>:
.globl vector114
vector114:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $114
  102223:	6a 72                	push   $0x72
  jmp __alltraps
  102225:	e9 e1 fb ff ff       	jmp    101e0b <__alltraps>

0010222a <vector115>:
.globl vector115
vector115:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $115
  10222c:	6a 73                	push   $0x73
  jmp __alltraps
  10222e:	e9 d8 fb ff ff       	jmp    101e0b <__alltraps>

00102233 <vector116>:
.globl vector116
vector116:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $116
  102235:	6a 74                	push   $0x74
  jmp __alltraps
  102237:	e9 cf fb ff ff       	jmp    101e0b <__alltraps>

0010223c <vector117>:
.globl vector117
vector117:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $117
  10223e:	6a 75                	push   $0x75
  jmp __alltraps
  102240:	e9 c6 fb ff ff       	jmp    101e0b <__alltraps>

00102245 <vector118>:
.globl vector118
vector118:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $118
  102247:	6a 76                	push   $0x76
  jmp __alltraps
  102249:	e9 bd fb ff ff       	jmp    101e0b <__alltraps>

0010224e <vector119>:
.globl vector119
vector119:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $119
  102250:	6a 77                	push   $0x77
  jmp __alltraps
  102252:	e9 b4 fb ff ff       	jmp    101e0b <__alltraps>

00102257 <vector120>:
.globl vector120
vector120:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $120
  102259:	6a 78                	push   $0x78
  jmp __alltraps
  10225b:	e9 ab fb ff ff       	jmp    101e0b <__alltraps>

00102260 <vector121>:
.globl vector121
vector121:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $121
  102262:	6a 79                	push   $0x79
  jmp __alltraps
  102264:	e9 a2 fb ff ff       	jmp    101e0b <__alltraps>

00102269 <vector122>:
.globl vector122
vector122:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $122
  10226b:	6a 7a                	push   $0x7a
  jmp __alltraps
  10226d:	e9 99 fb ff ff       	jmp    101e0b <__alltraps>

00102272 <vector123>:
.globl vector123
vector123:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $123
  102274:	6a 7b                	push   $0x7b
  jmp __alltraps
  102276:	e9 90 fb ff ff       	jmp    101e0b <__alltraps>

0010227b <vector124>:
.globl vector124
vector124:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $124
  10227d:	6a 7c                	push   $0x7c
  jmp __alltraps
  10227f:	e9 87 fb ff ff       	jmp    101e0b <__alltraps>

00102284 <vector125>:
.globl vector125
vector125:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $125
  102286:	6a 7d                	push   $0x7d
  jmp __alltraps
  102288:	e9 7e fb ff ff       	jmp    101e0b <__alltraps>

0010228d <vector126>:
.globl vector126
vector126:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $126
  10228f:	6a 7e                	push   $0x7e
  jmp __alltraps
  102291:	e9 75 fb ff ff       	jmp    101e0b <__alltraps>

00102296 <vector127>:
.globl vector127
vector127:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $127
  102298:	6a 7f                	push   $0x7f
  jmp __alltraps
  10229a:	e9 6c fb ff ff       	jmp    101e0b <__alltraps>

0010229f <vector128>:
.globl vector128
vector128:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $128
  1022a1:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022a6:	e9 60 fb ff ff       	jmp    101e0b <__alltraps>

001022ab <vector129>:
.globl vector129
vector129:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $129
  1022ad:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022b2:	e9 54 fb ff ff       	jmp    101e0b <__alltraps>

001022b7 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $130
  1022b9:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022be:	e9 48 fb ff ff       	jmp    101e0b <__alltraps>

001022c3 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $131
  1022c5:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022ca:	e9 3c fb ff ff       	jmp    101e0b <__alltraps>

001022cf <vector132>:
.globl vector132
vector132:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $132
  1022d1:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022d6:	e9 30 fb ff ff       	jmp    101e0b <__alltraps>

001022db <vector133>:
.globl vector133
vector133:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $133
  1022dd:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022e2:	e9 24 fb ff ff       	jmp    101e0b <__alltraps>

001022e7 <vector134>:
.globl vector134
vector134:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $134
  1022e9:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022ee:	e9 18 fb ff ff       	jmp    101e0b <__alltraps>

001022f3 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $135
  1022f5:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022fa:	e9 0c fb ff ff       	jmp    101e0b <__alltraps>

001022ff <vector136>:
.globl vector136
vector136:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $136
  102301:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102306:	e9 00 fb ff ff       	jmp    101e0b <__alltraps>

0010230b <vector137>:
.globl vector137
vector137:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $137
  10230d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102312:	e9 f4 fa ff ff       	jmp    101e0b <__alltraps>

00102317 <vector138>:
.globl vector138
vector138:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $138
  102319:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10231e:	e9 e8 fa ff ff       	jmp    101e0b <__alltraps>

00102323 <vector139>:
.globl vector139
vector139:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $139
  102325:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10232a:	e9 dc fa ff ff       	jmp    101e0b <__alltraps>

0010232f <vector140>:
.globl vector140
vector140:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $140
  102331:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102336:	e9 d0 fa ff ff       	jmp    101e0b <__alltraps>

0010233b <vector141>:
.globl vector141
vector141:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $141
  10233d:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102342:	e9 c4 fa ff ff       	jmp    101e0b <__alltraps>

00102347 <vector142>:
.globl vector142
vector142:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $142
  102349:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10234e:	e9 b8 fa ff ff       	jmp    101e0b <__alltraps>

00102353 <vector143>:
.globl vector143
vector143:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $143
  102355:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10235a:	e9 ac fa ff ff       	jmp    101e0b <__alltraps>

0010235f <vector144>:
.globl vector144
vector144:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $144
  102361:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102366:	e9 a0 fa ff ff       	jmp    101e0b <__alltraps>

0010236b <vector145>:
.globl vector145
vector145:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $145
  10236d:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102372:	e9 94 fa ff ff       	jmp    101e0b <__alltraps>

00102377 <vector146>:
.globl vector146
vector146:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $146
  102379:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10237e:	e9 88 fa ff ff       	jmp    101e0b <__alltraps>

00102383 <vector147>:
.globl vector147
vector147:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $147
  102385:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10238a:	e9 7c fa ff ff       	jmp    101e0b <__alltraps>

0010238f <vector148>:
.globl vector148
vector148:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $148
  102391:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102396:	e9 70 fa ff ff       	jmp    101e0b <__alltraps>

0010239b <vector149>:
.globl vector149
vector149:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $149
  10239d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023a2:	e9 64 fa ff ff       	jmp    101e0b <__alltraps>

001023a7 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $150
  1023a9:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023ae:	e9 58 fa ff ff       	jmp    101e0b <__alltraps>

001023b3 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $151
  1023b5:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023ba:	e9 4c fa ff ff       	jmp    101e0b <__alltraps>

001023bf <vector152>:
.globl vector152
vector152:
  pushl $0
  1023bf:	6a 00                	push   $0x0
  pushl $152
  1023c1:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023c6:	e9 40 fa ff ff       	jmp    101e0b <__alltraps>

001023cb <vector153>:
.globl vector153
vector153:
  pushl $0
  1023cb:	6a 00                	push   $0x0
  pushl $153
  1023cd:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023d2:	e9 34 fa ff ff       	jmp    101e0b <__alltraps>

001023d7 <vector154>:
.globl vector154
vector154:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $154
  1023d9:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023de:	e9 28 fa ff ff       	jmp    101e0b <__alltraps>

001023e3 <vector155>:
.globl vector155
vector155:
  pushl $0
  1023e3:	6a 00                	push   $0x0
  pushl $155
  1023e5:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023ea:	e9 1c fa ff ff       	jmp    101e0b <__alltraps>

001023ef <vector156>:
.globl vector156
vector156:
  pushl $0
  1023ef:	6a 00                	push   $0x0
  pushl $156
  1023f1:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023f6:	e9 10 fa ff ff       	jmp    101e0b <__alltraps>

001023fb <vector157>:
.globl vector157
vector157:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $157
  1023fd:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102402:	e9 04 fa ff ff       	jmp    101e0b <__alltraps>

00102407 <vector158>:
.globl vector158
vector158:
  pushl $0
  102407:	6a 00                	push   $0x0
  pushl $158
  102409:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10240e:	e9 f8 f9 ff ff       	jmp    101e0b <__alltraps>

00102413 <vector159>:
.globl vector159
vector159:
  pushl $0
  102413:	6a 00                	push   $0x0
  pushl $159
  102415:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10241a:	e9 ec f9 ff ff       	jmp    101e0b <__alltraps>

0010241f <vector160>:
.globl vector160
vector160:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $160
  102421:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102426:	e9 e0 f9 ff ff       	jmp    101e0b <__alltraps>

0010242b <vector161>:
.globl vector161
vector161:
  pushl $0
  10242b:	6a 00                	push   $0x0
  pushl $161
  10242d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102432:	e9 d4 f9 ff ff       	jmp    101e0b <__alltraps>

00102437 <vector162>:
.globl vector162
vector162:
  pushl $0
  102437:	6a 00                	push   $0x0
  pushl $162
  102439:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10243e:	e9 c8 f9 ff ff       	jmp    101e0b <__alltraps>

00102443 <vector163>:
.globl vector163
vector163:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $163
  102445:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10244a:	e9 bc f9 ff ff       	jmp    101e0b <__alltraps>

0010244f <vector164>:
.globl vector164
vector164:
  pushl $0
  10244f:	6a 00                	push   $0x0
  pushl $164
  102451:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102456:	e9 b0 f9 ff ff       	jmp    101e0b <__alltraps>

0010245b <vector165>:
.globl vector165
vector165:
  pushl $0
  10245b:	6a 00                	push   $0x0
  pushl $165
  10245d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102462:	e9 a4 f9 ff ff       	jmp    101e0b <__alltraps>

00102467 <vector166>:
.globl vector166
vector166:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $166
  102469:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10246e:	e9 98 f9 ff ff       	jmp    101e0b <__alltraps>

00102473 <vector167>:
.globl vector167
vector167:
  pushl $0
  102473:	6a 00                	push   $0x0
  pushl $167
  102475:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10247a:	e9 8c f9 ff ff       	jmp    101e0b <__alltraps>

0010247f <vector168>:
.globl vector168
vector168:
  pushl $0
  10247f:	6a 00                	push   $0x0
  pushl $168
  102481:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102486:	e9 80 f9 ff ff       	jmp    101e0b <__alltraps>

0010248b <vector169>:
.globl vector169
vector169:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $169
  10248d:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102492:	e9 74 f9 ff ff       	jmp    101e0b <__alltraps>

00102497 <vector170>:
.globl vector170
vector170:
  pushl $0
  102497:	6a 00                	push   $0x0
  pushl $170
  102499:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10249e:	e9 68 f9 ff ff       	jmp    101e0b <__alltraps>

001024a3 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024a3:	6a 00                	push   $0x0
  pushl $171
  1024a5:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024aa:	e9 5c f9 ff ff       	jmp    101e0b <__alltraps>

001024af <vector172>:
.globl vector172
vector172:
  pushl $0
  1024af:	6a 00                	push   $0x0
  pushl $172
  1024b1:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024b6:	e9 50 f9 ff ff       	jmp    101e0b <__alltraps>

001024bb <vector173>:
.globl vector173
vector173:
  pushl $0
  1024bb:	6a 00                	push   $0x0
  pushl $173
  1024bd:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024c2:	e9 44 f9 ff ff       	jmp    101e0b <__alltraps>

001024c7 <vector174>:
.globl vector174
vector174:
  pushl $0
  1024c7:	6a 00                	push   $0x0
  pushl $174
  1024c9:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024ce:	e9 38 f9 ff ff       	jmp    101e0b <__alltraps>

001024d3 <vector175>:
.globl vector175
vector175:
  pushl $0
  1024d3:	6a 00                	push   $0x0
  pushl $175
  1024d5:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024da:	e9 2c f9 ff ff       	jmp    101e0b <__alltraps>

001024df <vector176>:
.globl vector176
vector176:
  pushl $0
  1024df:	6a 00                	push   $0x0
  pushl $176
  1024e1:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024e6:	e9 20 f9 ff ff       	jmp    101e0b <__alltraps>

001024eb <vector177>:
.globl vector177
vector177:
  pushl $0
  1024eb:	6a 00                	push   $0x0
  pushl $177
  1024ed:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024f2:	e9 14 f9 ff ff       	jmp    101e0b <__alltraps>

001024f7 <vector178>:
.globl vector178
vector178:
  pushl $0
  1024f7:	6a 00                	push   $0x0
  pushl $178
  1024f9:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024fe:	e9 08 f9 ff ff       	jmp    101e0b <__alltraps>

00102503 <vector179>:
.globl vector179
vector179:
  pushl $0
  102503:	6a 00                	push   $0x0
  pushl $179
  102505:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10250a:	e9 fc f8 ff ff       	jmp    101e0b <__alltraps>

0010250f <vector180>:
.globl vector180
vector180:
  pushl $0
  10250f:	6a 00                	push   $0x0
  pushl $180
  102511:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102516:	e9 f0 f8 ff ff       	jmp    101e0b <__alltraps>

0010251b <vector181>:
.globl vector181
vector181:
  pushl $0
  10251b:	6a 00                	push   $0x0
  pushl $181
  10251d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102522:	e9 e4 f8 ff ff       	jmp    101e0b <__alltraps>

00102527 <vector182>:
.globl vector182
vector182:
  pushl $0
  102527:	6a 00                	push   $0x0
  pushl $182
  102529:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10252e:	e9 d8 f8 ff ff       	jmp    101e0b <__alltraps>

00102533 <vector183>:
.globl vector183
vector183:
  pushl $0
  102533:	6a 00                	push   $0x0
  pushl $183
  102535:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10253a:	e9 cc f8 ff ff       	jmp    101e0b <__alltraps>

0010253f <vector184>:
.globl vector184
vector184:
  pushl $0
  10253f:	6a 00                	push   $0x0
  pushl $184
  102541:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102546:	e9 c0 f8 ff ff       	jmp    101e0b <__alltraps>

0010254b <vector185>:
.globl vector185
vector185:
  pushl $0
  10254b:	6a 00                	push   $0x0
  pushl $185
  10254d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102552:	e9 b4 f8 ff ff       	jmp    101e0b <__alltraps>

00102557 <vector186>:
.globl vector186
vector186:
  pushl $0
  102557:	6a 00                	push   $0x0
  pushl $186
  102559:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10255e:	e9 a8 f8 ff ff       	jmp    101e0b <__alltraps>

00102563 <vector187>:
.globl vector187
vector187:
  pushl $0
  102563:	6a 00                	push   $0x0
  pushl $187
  102565:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10256a:	e9 9c f8 ff ff       	jmp    101e0b <__alltraps>

0010256f <vector188>:
.globl vector188
vector188:
  pushl $0
  10256f:	6a 00                	push   $0x0
  pushl $188
  102571:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102576:	e9 90 f8 ff ff       	jmp    101e0b <__alltraps>

0010257b <vector189>:
.globl vector189
vector189:
  pushl $0
  10257b:	6a 00                	push   $0x0
  pushl $189
  10257d:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102582:	e9 84 f8 ff ff       	jmp    101e0b <__alltraps>

00102587 <vector190>:
.globl vector190
vector190:
  pushl $0
  102587:	6a 00                	push   $0x0
  pushl $190
  102589:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10258e:	e9 78 f8 ff ff       	jmp    101e0b <__alltraps>

00102593 <vector191>:
.globl vector191
vector191:
  pushl $0
  102593:	6a 00                	push   $0x0
  pushl $191
  102595:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10259a:	e9 6c f8 ff ff       	jmp    101e0b <__alltraps>

0010259f <vector192>:
.globl vector192
vector192:
  pushl $0
  10259f:	6a 00                	push   $0x0
  pushl $192
  1025a1:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025a6:	e9 60 f8 ff ff       	jmp    101e0b <__alltraps>

001025ab <vector193>:
.globl vector193
vector193:
  pushl $0
  1025ab:	6a 00                	push   $0x0
  pushl $193
  1025ad:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025b2:	e9 54 f8 ff ff       	jmp    101e0b <__alltraps>

001025b7 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025b7:	6a 00                	push   $0x0
  pushl $194
  1025b9:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025be:	e9 48 f8 ff ff       	jmp    101e0b <__alltraps>

001025c3 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025c3:	6a 00                	push   $0x0
  pushl $195
  1025c5:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025ca:	e9 3c f8 ff ff       	jmp    101e0b <__alltraps>

001025cf <vector196>:
.globl vector196
vector196:
  pushl $0
  1025cf:	6a 00                	push   $0x0
  pushl $196
  1025d1:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025d6:	e9 30 f8 ff ff       	jmp    101e0b <__alltraps>

001025db <vector197>:
.globl vector197
vector197:
  pushl $0
  1025db:	6a 00                	push   $0x0
  pushl $197
  1025dd:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025e2:	e9 24 f8 ff ff       	jmp    101e0b <__alltraps>

001025e7 <vector198>:
.globl vector198
vector198:
  pushl $0
  1025e7:	6a 00                	push   $0x0
  pushl $198
  1025e9:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025ee:	e9 18 f8 ff ff       	jmp    101e0b <__alltraps>

001025f3 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025f3:	6a 00                	push   $0x0
  pushl $199
  1025f5:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025fa:	e9 0c f8 ff ff       	jmp    101e0b <__alltraps>

001025ff <vector200>:
.globl vector200
vector200:
  pushl $0
  1025ff:	6a 00                	push   $0x0
  pushl $200
  102601:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102606:	e9 00 f8 ff ff       	jmp    101e0b <__alltraps>

0010260b <vector201>:
.globl vector201
vector201:
  pushl $0
  10260b:	6a 00                	push   $0x0
  pushl $201
  10260d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102612:	e9 f4 f7 ff ff       	jmp    101e0b <__alltraps>

00102617 <vector202>:
.globl vector202
vector202:
  pushl $0
  102617:	6a 00                	push   $0x0
  pushl $202
  102619:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10261e:	e9 e8 f7 ff ff       	jmp    101e0b <__alltraps>

00102623 <vector203>:
.globl vector203
vector203:
  pushl $0
  102623:	6a 00                	push   $0x0
  pushl $203
  102625:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10262a:	e9 dc f7 ff ff       	jmp    101e0b <__alltraps>

0010262f <vector204>:
.globl vector204
vector204:
  pushl $0
  10262f:	6a 00                	push   $0x0
  pushl $204
  102631:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102636:	e9 d0 f7 ff ff       	jmp    101e0b <__alltraps>

0010263b <vector205>:
.globl vector205
vector205:
  pushl $0
  10263b:	6a 00                	push   $0x0
  pushl $205
  10263d:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102642:	e9 c4 f7 ff ff       	jmp    101e0b <__alltraps>

00102647 <vector206>:
.globl vector206
vector206:
  pushl $0
  102647:	6a 00                	push   $0x0
  pushl $206
  102649:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10264e:	e9 b8 f7 ff ff       	jmp    101e0b <__alltraps>

00102653 <vector207>:
.globl vector207
vector207:
  pushl $0
  102653:	6a 00                	push   $0x0
  pushl $207
  102655:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10265a:	e9 ac f7 ff ff       	jmp    101e0b <__alltraps>

0010265f <vector208>:
.globl vector208
vector208:
  pushl $0
  10265f:	6a 00                	push   $0x0
  pushl $208
  102661:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102666:	e9 a0 f7 ff ff       	jmp    101e0b <__alltraps>

0010266b <vector209>:
.globl vector209
vector209:
  pushl $0
  10266b:	6a 00                	push   $0x0
  pushl $209
  10266d:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102672:	e9 94 f7 ff ff       	jmp    101e0b <__alltraps>

00102677 <vector210>:
.globl vector210
vector210:
  pushl $0
  102677:	6a 00                	push   $0x0
  pushl $210
  102679:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10267e:	e9 88 f7 ff ff       	jmp    101e0b <__alltraps>

00102683 <vector211>:
.globl vector211
vector211:
  pushl $0
  102683:	6a 00                	push   $0x0
  pushl $211
  102685:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10268a:	e9 7c f7 ff ff       	jmp    101e0b <__alltraps>

0010268f <vector212>:
.globl vector212
vector212:
  pushl $0
  10268f:	6a 00                	push   $0x0
  pushl $212
  102691:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102696:	e9 70 f7 ff ff       	jmp    101e0b <__alltraps>

0010269b <vector213>:
.globl vector213
vector213:
  pushl $0
  10269b:	6a 00                	push   $0x0
  pushl $213
  10269d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026a2:	e9 64 f7 ff ff       	jmp    101e0b <__alltraps>

001026a7 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026a7:	6a 00                	push   $0x0
  pushl $214
  1026a9:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026ae:	e9 58 f7 ff ff       	jmp    101e0b <__alltraps>

001026b3 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026b3:	6a 00                	push   $0x0
  pushl $215
  1026b5:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026ba:	e9 4c f7 ff ff       	jmp    101e0b <__alltraps>

001026bf <vector216>:
.globl vector216
vector216:
  pushl $0
  1026bf:	6a 00                	push   $0x0
  pushl $216
  1026c1:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026c6:	e9 40 f7 ff ff       	jmp    101e0b <__alltraps>

001026cb <vector217>:
.globl vector217
vector217:
  pushl $0
  1026cb:	6a 00                	push   $0x0
  pushl $217
  1026cd:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026d2:	e9 34 f7 ff ff       	jmp    101e0b <__alltraps>

001026d7 <vector218>:
.globl vector218
vector218:
  pushl $0
  1026d7:	6a 00                	push   $0x0
  pushl $218
  1026d9:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026de:	e9 28 f7 ff ff       	jmp    101e0b <__alltraps>

001026e3 <vector219>:
.globl vector219
vector219:
  pushl $0
  1026e3:	6a 00                	push   $0x0
  pushl $219
  1026e5:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026ea:	e9 1c f7 ff ff       	jmp    101e0b <__alltraps>

001026ef <vector220>:
.globl vector220
vector220:
  pushl $0
  1026ef:	6a 00                	push   $0x0
  pushl $220
  1026f1:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026f6:	e9 10 f7 ff ff       	jmp    101e0b <__alltraps>

001026fb <vector221>:
.globl vector221
vector221:
  pushl $0
  1026fb:	6a 00                	push   $0x0
  pushl $221
  1026fd:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102702:	e9 04 f7 ff ff       	jmp    101e0b <__alltraps>

00102707 <vector222>:
.globl vector222
vector222:
  pushl $0
  102707:	6a 00                	push   $0x0
  pushl $222
  102709:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10270e:	e9 f8 f6 ff ff       	jmp    101e0b <__alltraps>

00102713 <vector223>:
.globl vector223
vector223:
  pushl $0
  102713:	6a 00                	push   $0x0
  pushl $223
  102715:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10271a:	e9 ec f6 ff ff       	jmp    101e0b <__alltraps>

0010271f <vector224>:
.globl vector224
vector224:
  pushl $0
  10271f:	6a 00                	push   $0x0
  pushl $224
  102721:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102726:	e9 e0 f6 ff ff       	jmp    101e0b <__alltraps>

0010272b <vector225>:
.globl vector225
vector225:
  pushl $0
  10272b:	6a 00                	push   $0x0
  pushl $225
  10272d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102732:	e9 d4 f6 ff ff       	jmp    101e0b <__alltraps>

00102737 <vector226>:
.globl vector226
vector226:
  pushl $0
  102737:	6a 00                	push   $0x0
  pushl $226
  102739:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10273e:	e9 c8 f6 ff ff       	jmp    101e0b <__alltraps>

00102743 <vector227>:
.globl vector227
vector227:
  pushl $0
  102743:	6a 00                	push   $0x0
  pushl $227
  102745:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10274a:	e9 bc f6 ff ff       	jmp    101e0b <__alltraps>

0010274f <vector228>:
.globl vector228
vector228:
  pushl $0
  10274f:	6a 00                	push   $0x0
  pushl $228
  102751:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102756:	e9 b0 f6 ff ff       	jmp    101e0b <__alltraps>

0010275b <vector229>:
.globl vector229
vector229:
  pushl $0
  10275b:	6a 00                	push   $0x0
  pushl $229
  10275d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102762:	e9 a4 f6 ff ff       	jmp    101e0b <__alltraps>

00102767 <vector230>:
.globl vector230
vector230:
  pushl $0
  102767:	6a 00                	push   $0x0
  pushl $230
  102769:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10276e:	e9 98 f6 ff ff       	jmp    101e0b <__alltraps>

00102773 <vector231>:
.globl vector231
vector231:
  pushl $0
  102773:	6a 00                	push   $0x0
  pushl $231
  102775:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10277a:	e9 8c f6 ff ff       	jmp    101e0b <__alltraps>

0010277f <vector232>:
.globl vector232
vector232:
  pushl $0
  10277f:	6a 00                	push   $0x0
  pushl $232
  102781:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102786:	e9 80 f6 ff ff       	jmp    101e0b <__alltraps>

0010278b <vector233>:
.globl vector233
vector233:
  pushl $0
  10278b:	6a 00                	push   $0x0
  pushl $233
  10278d:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102792:	e9 74 f6 ff ff       	jmp    101e0b <__alltraps>

00102797 <vector234>:
.globl vector234
vector234:
  pushl $0
  102797:	6a 00                	push   $0x0
  pushl $234
  102799:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10279e:	e9 68 f6 ff ff       	jmp    101e0b <__alltraps>

001027a3 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027a3:	6a 00                	push   $0x0
  pushl $235
  1027a5:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027aa:	e9 5c f6 ff ff       	jmp    101e0b <__alltraps>

001027af <vector236>:
.globl vector236
vector236:
  pushl $0
  1027af:	6a 00                	push   $0x0
  pushl $236
  1027b1:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027b6:	e9 50 f6 ff ff       	jmp    101e0b <__alltraps>

001027bb <vector237>:
.globl vector237
vector237:
  pushl $0
  1027bb:	6a 00                	push   $0x0
  pushl $237
  1027bd:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027c2:	e9 44 f6 ff ff       	jmp    101e0b <__alltraps>

001027c7 <vector238>:
.globl vector238
vector238:
  pushl $0
  1027c7:	6a 00                	push   $0x0
  pushl $238
  1027c9:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027ce:	e9 38 f6 ff ff       	jmp    101e0b <__alltraps>

001027d3 <vector239>:
.globl vector239
vector239:
  pushl $0
  1027d3:	6a 00                	push   $0x0
  pushl $239
  1027d5:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027da:	e9 2c f6 ff ff       	jmp    101e0b <__alltraps>

001027df <vector240>:
.globl vector240
vector240:
  pushl $0
  1027df:	6a 00                	push   $0x0
  pushl $240
  1027e1:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027e6:	e9 20 f6 ff ff       	jmp    101e0b <__alltraps>

001027eb <vector241>:
.globl vector241
vector241:
  pushl $0
  1027eb:	6a 00                	push   $0x0
  pushl $241
  1027ed:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027f2:	e9 14 f6 ff ff       	jmp    101e0b <__alltraps>

001027f7 <vector242>:
.globl vector242
vector242:
  pushl $0
  1027f7:	6a 00                	push   $0x0
  pushl $242
  1027f9:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027fe:	e9 08 f6 ff ff       	jmp    101e0b <__alltraps>

00102803 <vector243>:
.globl vector243
vector243:
  pushl $0
  102803:	6a 00                	push   $0x0
  pushl $243
  102805:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10280a:	e9 fc f5 ff ff       	jmp    101e0b <__alltraps>

0010280f <vector244>:
.globl vector244
vector244:
  pushl $0
  10280f:	6a 00                	push   $0x0
  pushl $244
  102811:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102816:	e9 f0 f5 ff ff       	jmp    101e0b <__alltraps>

0010281b <vector245>:
.globl vector245
vector245:
  pushl $0
  10281b:	6a 00                	push   $0x0
  pushl $245
  10281d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102822:	e9 e4 f5 ff ff       	jmp    101e0b <__alltraps>

00102827 <vector246>:
.globl vector246
vector246:
  pushl $0
  102827:	6a 00                	push   $0x0
  pushl $246
  102829:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10282e:	e9 d8 f5 ff ff       	jmp    101e0b <__alltraps>

00102833 <vector247>:
.globl vector247
vector247:
  pushl $0
  102833:	6a 00                	push   $0x0
  pushl $247
  102835:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10283a:	e9 cc f5 ff ff       	jmp    101e0b <__alltraps>

0010283f <vector248>:
.globl vector248
vector248:
  pushl $0
  10283f:	6a 00                	push   $0x0
  pushl $248
  102841:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102846:	e9 c0 f5 ff ff       	jmp    101e0b <__alltraps>

0010284b <vector249>:
.globl vector249
vector249:
  pushl $0
  10284b:	6a 00                	push   $0x0
  pushl $249
  10284d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102852:	e9 b4 f5 ff ff       	jmp    101e0b <__alltraps>

00102857 <vector250>:
.globl vector250
vector250:
  pushl $0
  102857:	6a 00                	push   $0x0
  pushl $250
  102859:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10285e:	e9 a8 f5 ff ff       	jmp    101e0b <__alltraps>

00102863 <vector251>:
.globl vector251
vector251:
  pushl $0
  102863:	6a 00                	push   $0x0
  pushl $251
  102865:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10286a:	e9 9c f5 ff ff       	jmp    101e0b <__alltraps>

0010286f <vector252>:
.globl vector252
vector252:
  pushl $0
  10286f:	6a 00                	push   $0x0
  pushl $252
  102871:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102876:	e9 90 f5 ff ff       	jmp    101e0b <__alltraps>

0010287b <vector253>:
.globl vector253
vector253:
  pushl $0
  10287b:	6a 00                	push   $0x0
  pushl $253
  10287d:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102882:	e9 84 f5 ff ff       	jmp    101e0b <__alltraps>

00102887 <vector254>:
.globl vector254
vector254:
  pushl $0
  102887:	6a 00                	push   $0x0
  pushl $254
  102889:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10288e:	e9 78 f5 ff ff       	jmp    101e0b <__alltraps>

00102893 <vector255>:
.globl vector255
vector255:
  pushl $0
  102893:	6a 00                	push   $0x0
  pushl $255
  102895:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10289a:	e9 6c f5 ff ff       	jmp    101e0b <__alltraps>

0010289f <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10289f:	55                   	push   %ebp
  1028a0:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028a2:	8b 55 08             	mov    0x8(%ebp),%edx
  1028a5:	a1 24 af 11 00       	mov    0x11af24,%eax
  1028aa:	29 c2                	sub    %eax,%edx
  1028ac:	89 d0                	mov    %edx,%eax
  1028ae:	c1 f8 02             	sar    $0x2,%eax
  1028b1:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028b7:	5d                   	pop    %ebp
  1028b8:	c3                   	ret    

001028b9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028b9:	55                   	push   %ebp
  1028ba:	89 e5                	mov    %esp,%ebp
  1028bc:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c2:	89 04 24             	mov    %eax,(%esp)
  1028c5:	e8 d5 ff ff ff       	call   10289f <page2ppn>
  1028ca:	c1 e0 0c             	shl    $0xc,%eax
}
  1028cd:	c9                   	leave  
  1028ce:	c3                   	ret    

001028cf <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028cf:	55                   	push   %ebp
  1028d0:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d5:	8b 00                	mov    (%eax),%eax
}
  1028d7:	5d                   	pop    %ebp
  1028d8:	c3                   	ret    

001028d9 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028d9:	55                   	push   %ebp
  1028da:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1028df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028e2:	89 10                	mov    %edx,(%eax)
}
  1028e4:	5d                   	pop    %ebp
  1028e5:	c3                   	ret    

001028e6 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1028e6:	55                   	push   %ebp
  1028e7:	89 e5                	mov    %esp,%ebp
  1028e9:	83 ec 10             	sub    $0x10,%esp
  1028ec:	c7 45 fc 10 af 11 00 	movl   $0x11af10,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1028f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1028f9:	89 50 04             	mov    %edx,0x4(%eax)
  1028fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028ff:	8b 50 04             	mov    0x4(%eax),%edx
  102902:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102905:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102907:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  10290e:	00 00 00 
}
  102911:	c9                   	leave  
  102912:	c3                   	ret    

00102913 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102913:	55                   	push   %ebp
  102914:	89 e5                	mov    %esp,%ebp
  102916:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102919:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10291d:	75 24                	jne    102943 <default_init_memmap+0x30>
  10291f:	c7 44 24 0c 10 65 10 	movl   $0x106510,0xc(%esp)
  102926:	00 
  102927:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10292e:	00 
  10292f:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102936:	00 
  102937:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10293e:	e8 89 e3 ff ff       	call   100ccc <__panic>
    struct Page *p = base;
  102943:	8b 45 08             	mov    0x8(%ebp),%eax
  102946:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102949:	eb 7d                	jmp    1029c8 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  10294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10294e:	83 c0 04             	add    $0x4,%eax
  102951:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102958:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10295b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10295e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102961:	0f a3 10             	bt     %edx,(%eax)
  102964:	19 c0                	sbb    %eax,%eax
  102966:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102969:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10296d:	0f 95 c0             	setne  %al
  102970:	0f b6 c0             	movzbl %al,%eax
  102973:	85 c0                	test   %eax,%eax
  102975:	75 24                	jne    10299b <default_init_memmap+0x88>
  102977:	c7 44 24 0c 41 65 10 	movl   $0x106541,0xc(%esp)
  10297e:	00 
  10297f:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  102986:	00 
  102987:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  10298e:	00 
  10298f:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  102996:	e8 31 e3 ff ff       	call   100ccc <__panic>
        p->flags = p->property = 0;
  10299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10299e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029a8:	8b 50 08             	mov    0x8(%eax),%edx
  1029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ae:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1029b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029b8:	00 
  1029b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029bc:	89 04 24             	mov    %eax,(%esp)
  1029bf:	e8 15 ff ff ff       	call   1028d9 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029c4:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1029c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029cb:	89 d0                	mov    %edx,%eax
  1029cd:	c1 e0 02             	shl    $0x2,%eax
  1029d0:	01 d0                	add    %edx,%eax
  1029d2:	c1 e0 02             	shl    $0x2,%eax
  1029d5:	89 c2                	mov    %eax,%edx
  1029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029da:	01 d0                	add    %edx,%eax
  1029dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1029df:	0f 85 66 ff ff ff    	jne    10294b <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  1029e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029eb:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1029f1:	83 c0 04             	add    $0x4,%eax
  1029f4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a01:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a04:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  102a07:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a10:	01 d0                	add    %edx,%eax
  102a12:	a3 18 af 11 00       	mov    %eax,0x11af18
    list_add(&free_list, &(base->page_link));
  102a17:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1a:	83 c0 0c             	add    $0xc,%eax
  102a1d:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
  102a24:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a2a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102a2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a30:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102a33:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a36:	8b 40 04             	mov    0x4(%eax),%eax
  102a39:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a3c:	89 55 cc             	mov    %edx,-0x34(%ebp)
  102a3f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a42:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102a45:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a48:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a4b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a4e:	89 10                	mov    %edx,(%eax)
  102a50:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a53:	8b 10                	mov    (%eax),%edx
  102a55:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102a58:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a5e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102a61:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a64:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a67:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102a6a:	89 10                	mov    %edx,(%eax)
}
  102a6c:	c9                   	leave  
  102a6d:	c3                   	ret    

00102a6e <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a6e:	55                   	push   %ebp
  102a6f:	89 e5                	mov    %esp,%ebp
  102a71:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102a74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a78:	75 24                	jne    102a9e <default_alloc_pages+0x30>
  102a7a:	c7 44 24 0c 10 65 10 	movl   $0x106510,0xc(%esp)
  102a81:	00 
  102a82:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  102a89:	00 
  102a8a:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  102a91:	00 
  102a92:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  102a99:	e8 2e e2 ff ff       	call   100ccc <__panic>
    if (n > nr_free) {
  102a9e:	a1 18 af 11 00       	mov    0x11af18,%eax
  102aa3:	3b 45 08             	cmp    0x8(%ebp),%eax
  102aa6:	73 0a                	jae    102ab2 <default_alloc_pages+0x44>
        return NULL;
  102aa8:	b8 00 00 00 00       	mov    $0x0,%eax
  102aad:	e9 2a 01 00 00       	jmp    102bdc <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
  102ab2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102ab9:	c7 45 f0 10 af 11 00 	movl   $0x11af10,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102ac0:	eb 1c                	jmp    102ade <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102ac2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ac5:	83 e8 0c             	sub    $0xc,%eax
  102ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  102acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ace:	8b 40 08             	mov    0x8(%eax),%eax
  102ad1:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ad4:	72 08                	jb     102ade <default_alloc_pages+0x70>
            page = p;
  102ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102adc:	eb 18                	jmp    102af6 <default_alloc_pages+0x88>
  102ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102ae4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ae7:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102aed:	81 7d f0 10 af 11 00 	cmpl   $0x11af10,-0x10(%ebp)
  102af4:	75 cc                	jne    102ac2 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102afa:	0f 84 d9 00 00 00    	je     102bd9 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
  102b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b03:	83 c0 0c             	add    $0xc,%eax
  102b06:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b0c:	8b 40 04             	mov    0x4(%eax),%eax
  102b0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b12:	8b 12                	mov    (%edx),%edx
  102b14:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b17:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b1d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b20:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b26:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102b29:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  102b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b2e:	8b 40 08             	mov    0x8(%eax),%eax
  102b31:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b34:	76 7d                	jbe    102bb3 <default_alloc_pages+0x145>
            struct Page *p = page + n;
  102b36:	8b 55 08             	mov    0x8(%ebp),%edx
  102b39:	89 d0                	mov    %edx,%eax
  102b3b:	c1 e0 02             	shl    $0x2,%eax
  102b3e:	01 d0                	add    %edx,%eax
  102b40:	c1 e0 02             	shl    $0x2,%eax
  102b43:	89 c2                	mov    %eax,%edx
  102b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b48:	01 d0                	add    %edx,%eax
  102b4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b50:	8b 40 08             	mov    0x8(%eax),%eax
  102b53:	2b 45 08             	sub    0x8(%ebp),%eax
  102b56:	89 c2                	mov    %eax,%edx
  102b58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b5b:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  102b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b61:	83 c0 0c             	add    $0xc,%eax
  102b64:	c7 45 d4 10 af 11 00 	movl   $0x11af10,-0x2c(%ebp)
  102b6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b71:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102b74:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b77:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102b7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b7d:	8b 40 04             	mov    0x4(%eax),%eax
  102b80:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b83:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102b86:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b89:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102b8c:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b8f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b92:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b95:	89 10                	mov    %edx,(%eax)
  102b97:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b9a:	8b 10                	mov    (%eax),%edx
  102b9c:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b9f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ba2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ba5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102ba8:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102bab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102bae:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102bb1:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  102bb3:	a1 18 af 11 00       	mov    0x11af18,%eax
  102bb8:	2b 45 08             	sub    0x8(%ebp),%eax
  102bbb:	a3 18 af 11 00       	mov    %eax,0x11af18
        ClearPageProperty(page);
  102bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc3:	83 c0 04             	add    $0x4,%eax
  102bc6:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102bcd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102bd0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bd3:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102bd6:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102bdc:	c9                   	leave  
  102bdd:	c3                   	ret    

00102bde <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102bde:	55                   	push   %ebp
  102bdf:	89 e5                	mov    %esp,%ebp
  102be1:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102beb:	75 24                	jne    102c11 <default_free_pages+0x33>
  102bed:	c7 44 24 0c 10 65 10 	movl   $0x106510,0xc(%esp)
  102bf4:	00 
  102bf5:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  102bfc:	00 
  102bfd:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  102c04:	00 
  102c05:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  102c0c:	e8 bb e0 ff ff       	call   100ccc <__panic>
    struct Page *p = base;
  102c11:	8b 45 08             	mov    0x8(%ebp),%eax
  102c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102c17:	e9 9d 00 00 00       	jmp    102cb9 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c1f:	83 c0 04             	add    $0x4,%eax
  102c22:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c29:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c32:	0f a3 10             	bt     %edx,(%eax)
  102c35:	19 c0                	sbb    %eax,%eax
  102c37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c3e:	0f 95 c0             	setne  %al
  102c41:	0f b6 c0             	movzbl %al,%eax
  102c44:	85 c0                	test   %eax,%eax
  102c46:	75 2c                	jne    102c74 <default_free_pages+0x96>
  102c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c4b:	83 c0 04             	add    $0x4,%eax
  102c4e:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102c55:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c58:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102c5e:	0f a3 10             	bt     %edx,(%eax)
  102c61:	19 c0                	sbb    %eax,%eax
  102c63:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102c66:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102c6a:	0f 95 c0             	setne  %al
  102c6d:	0f b6 c0             	movzbl %al,%eax
  102c70:	85 c0                	test   %eax,%eax
  102c72:	74 24                	je     102c98 <default_free_pages+0xba>
  102c74:	c7 44 24 0c 54 65 10 	movl   $0x106554,0xc(%esp)
  102c7b:	00 
  102c7c:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  102c83:	00 
  102c84:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  102c8b:	00 
  102c8c:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  102c93:	e8 34 e0 ff ff       	call   100ccc <__panic>
        p->flags = 0;
  102c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102ca2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102ca9:	00 
  102caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cad:	89 04 24             	mov    %eax,(%esp)
  102cb0:	e8 24 fc ff ff       	call   1028d9 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102cb5:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102cb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cbc:	89 d0                	mov    %edx,%eax
  102cbe:	c1 e0 02             	shl    $0x2,%eax
  102cc1:	01 d0                	add    %edx,%eax
  102cc3:	c1 e0 02             	shl    $0x2,%eax
  102cc6:	89 c2                	mov    %eax,%edx
  102cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ccb:	01 d0                	add    %edx,%eax
  102ccd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cd0:	0f 85 46 ff ff ff    	jne    102c1c <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cdc:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce2:	83 c0 04             	add    $0x4,%eax
  102ce5:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102cec:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102cef:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cf2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cf5:	0f ab 10             	bts    %edx,(%eax)
  102cf8:	c7 45 cc 10 af 11 00 	movl   $0x11af10,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102cff:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d02:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102d05:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102d08:	e9 08 01 00 00       	jmp    102e15 <default_free_pages+0x237>
        p = le2page(le, page_link);
  102d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d10:	83 e8 0c             	sub    $0xc,%eax
  102d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d19:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102d1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102d1f:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102d25:	8b 45 08             	mov    0x8(%ebp),%eax
  102d28:	8b 50 08             	mov    0x8(%eax),%edx
  102d2b:	89 d0                	mov    %edx,%eax
  102d2d:	c1 e0 02             	shl    $0x2,%eax
  102d30:	01 d0                	add    %edx,%eax
  102d32:	c1 e0 02             	shl    $0x2,%eax
  102d35:	89 c2                	mov    %eax,%edx
  102d37:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3a:	01 d0                	add    %edx,%eax
  102d3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d3f:	75 5a                	jne    102d9b <default_free_pages+0x1bd>
            base->property += p->property;
  102d41:	8b 45 08             	mov    0x8(%ebp),%eax
  102d44:	8b 50 08             	mov    0x8(%eax),%edx
  102d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d4a:	8b 40 08             	mov    0x8(%eax),%eax
  102d4d:	01 c2                	add    %eax,%edx
  102d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d52:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d58:	83 c0 04             	add    $0x4,%eax
  102d5b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102d62:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d65:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d68:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d6b:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d71:	83 c0 0c             	add    $0xc,%eax
  102d74:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102d77:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d7a:	8b 40 04             	mov    0x4(%eax),%eax
  102d7d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d80:	8b 12                	mov    (%edx),%edx
  102d82:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102d85:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102d88:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d8b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102d8e:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102d91:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d94:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d97:	89 10                	mov    %edx,(%eax)
  102d99:	eb 7a                	jmp    102e15 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  102d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9e:	8b 50 08             	mov    0x8(%eax),%edx
  102da1:	89 d0                	mov    %edx,%eax
  102da3:	c1 e0 02             	shl    $0x2,%eax
  102da6:	01 d0                	add    %edx,%eax
  102da8:	c1 e0 02             	shl    $0x2,%eax
  102dab:	89 c2                	mov    %eax,%edx
  102dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db0:	01 d0                	add    %edx,%eax
  102db2:	3b 45 08             	cmp    0x8(%ebp),%eax
  102db5:	75 5e                	jne    102e15 <default_free_pages+0x237>
            p->property += base->property;
  102db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dba:	8b 50 08             	mov    0x8(%eax),%edx
  102dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc0:	8b 40 08             	mov    0x8(%eax),%eax
  102dc3:	01 c2                	add    %eax,%edx
  102dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc8:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dce:	83 c0 04             	add    $0x4,%eax
  102dd1:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102dd8:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102ddb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102dde:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102de1:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102de7:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ded:	83 c0 0c             	add    $0xc,%eax
  102df0:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102df3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102df6:	8b 40 04             	mov    0x4(%eax),%eax
  102df9:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102dfc:	8b 12                	mov    (%edx),%edx
  102dfe:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102e01:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e04:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102e07:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102e0a:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e0d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e10:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e13:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102e15:	81 7d f0 10 af 11 00 	cmpl   $0x11af10,-0x10(%ebp)
  102e1c:	0f 85 eb fe ff ff    	jne    102d0d <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  102e22:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2b:	01 d0                	add    %edx,%eax
  102e2d:	a3 18 af 11 00       	mov    %eax,0x11af18
    list_add(&free_list, &(base->page_link));
  102e32:	8b 45 08             	mov    0x8(%ebp),%eax
  102e35:	83 c0 0c             	add    $0xc,%eax
  102e38:	c7 45 9c 10 af 11 00 	movl   $0x11af10,-0x64(%ebp)
  102e3f:	89 45 98             	mov    %eax,-0x68(%ebp)
  102e42:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102e45:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102e48:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e4b:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102e4e:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102e51:	8b 40 04             	mov    0x4(%eax),%eax
  102e54:	8b 55 90             	mov    -0x70(%ebp),%edx
  102e57:	89 55 8c             	mov    %edx,-0x74(%ebp)
  102e5a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102e5d:	89 55 88             	mov    %edx,-0x78(%ebp)
  102e60:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102e63:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102e66:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102e69:	89 10                	mov    %edx,(%eax)
  102e6b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102e6e:	8b 10                	mov    (%eax),%edx
  102e70:	8b 45 88             	mov    -0x78(%ebp),%eax
  102e73:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102e76:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e79:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102e7c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102e7f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102e82:	8b 55 88             	mov    -0x78(%ebp),%edx
  102e85:	89 10                	mov    %edx,(%eax)
}
  102e87:	c9                   	leave  
  102e88:	c3                   	ret    

00102e89 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e89:	55                   	push   %ebp
  102e8a:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e8c:	a1 18 af 11 00       	mov    0x11af18,%eax
}
  102e91:	5d                   	pop    %ebp
  102e92:	c3                   	ret    

00102e93 <basic_check>:

static void
basic_check(void) {
  102e93:	55                   	push   %ebp
  102e94:	89 e5                	mov    %esp,%ebp
  102e96:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ea9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102eac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102eb3:	e8 ce 0e 00 00       	call   103d86 <alloc_pages>
  102eb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102ebb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102ebf:	75 24                	jne    102ee5 <basic_check+0x52>
  102ec1:	c7 44 24 0c 79 65 10 	movl   $0x106579,0xc(%esp)
  102ec8:	00 
  102ec9:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  102ed0:	00 
  102ed1:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  102ed8:	00 
  102ed9:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  102ee0:	e8 e7 dd ff ff       	call   100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
  102ee5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102eec:	e8 95 0e 00 00       	call   103d86 <alloc_pages>
  102ef1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ef4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ef8:	75 24                	jne    102f1e <basic_check+0x8b>
  102efa:	c7 44 24 0c 95 65 10 	movl   $0x106595,0xc(%esp)
  102f01:	00 
  102f02:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  102f09:	00 
  102f0a:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  102f11:	00 
  102f12:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  102f19:	e8 ae dd ff ff       	call   100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
  102f1e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f25:	e8 5c 0e 00 00       	call   103d86 <alloc_pages>
  102f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f31:	75 24                	jne    102f57 <basic_check+0xc4>
  102f33:	c7 44 24 0c b1 65 10 	movl   $0x1065b1,0xc(%esp)
  102f3a:	00 
  102f3b:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  102f42:	00 
  102f43:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  102f4a:	00 
  102f4b:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  102f52:	e8 75 dd ff ff       	call   100ccc <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102f57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f5a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102f5d:	74 10                	je     102f6f <basic_check+0xdc>
  102f5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f62:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f65:	74 08                	je     102f6f <basic_check+0xdc>
  102f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f6d:	75 24                	jne    102f93 <basic_check+0x100>
  102f6f:	c7 44 24 0c d0 65 10 	movl   $0x1065d0,0xc(%esp)
  102f76:	00 
  102f77:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  102f7e:	00 
  102f7f:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  102f86:	00 
  102f87:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  102f8e:	e8 39 dd ff ff       	call   100ccc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f96:	89 04 24             	mov    %eax,(%esp)
  102f99:	e8 31 f9 ff ff       	call   1028cf <page_ref>
  102f9e:	85 c0                	test   %eax,%eax
  102fa0:	75 1e                	jne    102fc0 <basic_check+0x12d>
  102fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa5:	89 04 24             	mov    %eax,(%esp)
  102fa8:	e8 22 f9 ff ff       	call   1028cf <page_ref>
  102fad:	85 c0                	test   %eax,%eax
  102faf:	75 0f                	jne    102fc0 <basic_check+0x12d>
  102fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fb4:	89 04 24             	mov    %eax,(%esp)
  102fb7:	e8 13 f9 ff ff       	call   1028cf <page_ref>
  102fbc:	85 c0                	test   %eax,%eax
  102fbe:	74 24                	je     102fe4 <basic_check+0x151>
  102fc0:	c7 44 24 0c f4 65 10 	movl   $0x1065f4,0xc(%esp)
  102fc7:	00 
  102fc8:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  102fcf:	00 
  102fd0:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  102fd7:	00 
  102fd8:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  102fdf:	e8 e8 dc ff ff       	call   100ccc <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fe7:	89 04 24             	mov    %eax,(%esp)
  102fea:	e8 ca f8 ff ff       	call   1028b9 <page2pa>
  102fef:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  102ff5:	c1 e2 0c             	shl    $0xc,%edx
  102ff8:	39 d0                	cmp    %edx,%eax
  102ffa:	72 24                	jb     103020 <basic_check+0x18d>
  102ffc:	c7 44 24 0c 30 66 10 	movl   $0x106630,0xc(%esp)
  103003:	00 
  103004:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10300b:	00 
  10300c:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  103013:	00 
  103014:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10301b:	e8 ac dc ff ff       	call   100ccc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103023:	89 04 24             	mov    %eax,(%esp)
  103026:	e8 8e f8 ff ff       	call   1028b9 <page2pa>
  10302b:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  103031:	c1 e2 0c             	shl    $0xc,%edx
  103034:	39 d0                	cmp    %edx,%eax
  103036:	72 24                	jb     10305c <basic_check+0x1c9>
  103038:	c7 44 24 0c 4d 66 10 	movl   $0x10664d,0xc(%esp)
  10303f:	00 
  103040:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103047:	00 
  103048:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  10304f:	00 
  103050:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103057:	e8 70 dc ff ff       	call   100ccc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10305f:	89 04 24             	mov    %eax,(%esp)
  103062:	e8 52 f8 ff ff       	call   1028b9 <page2pa>
  103067:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  10306d:	c1 e2 0c             	shl    $0xc,%edx
  103070:	39 d0                	cmp    %edx,%eax
  103072:	72 24                	jb     103098 <basic_check+0x205>
  103074:	c7 44 24 0c 6a 66 10 	movl   $0x10666a,0xc(%esp)
  10307b:	00 
  10307c:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103083:	00 
  103084:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  10308b:	00 
  10308c:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103093:	e8 34 dc ff ff       	call   100ccc <__panic>

    list_entry_t free_list_store = free_list;
  103098:	a1 10 af 11 00       	mov    0x11af10,%eax
  10309d:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  1030a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030a6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1030a9:	c7 45 e0 10 af 11 00 	movl   $0x11af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1030b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1030b6:	89 50 04             	mov    %edx,0x4(%eax)
  1030b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030bc:	8b 50 04             	mov    0x4(%eax),%edx
  1030bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030c2:	89 10                	mov    %edx,(%eax)
  1030c4:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1030cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030ce:	8b 40 04             	mov    0x4(%eax),%eax
  1030d1:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030d4:	0f 94 c0             	sete   %al
  1030d7:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1030da:	85 c0                	test   %eax,%eax
  1030dc:	75 24                	jne    103102 <basic_check+0x26f>
  1030de:	c7 44 24 0c 87 66 10 	movl   $0x106687,0xc(%esp)
  1030e5:	00 
  1030e6:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1030ed:	00 
  1030ee:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  1030f5:	00 
  1030f6:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1030fd:	e8 ca db ff ff       	call   100ccc <__panic>

    unsigned int nr_free_store = nr_free;
  103102:	a1 18 af 11 00       	mov    0x11af18,%eax
  103107:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10310a:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  103111:	00 00 00 

    assert(alloc_page() == NULL);
  103114:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10311b:	e8 66 0c 00 00       	call   103d86 <alloc_pages>
  103120:	85 c0                	test   %eax,%eax
  103122:	74 24                	je     103148 <basic_check+0x2b5>
  103124:	c7 44 24 0c 9e 66 10 	movl   $0x10669e,0xc(%esp)
  10312b:	00 
  10312c:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103133:	00 
  103134:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  10313b:	00 
  10313c:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103143:	e8 84 db ff ff       	call   100ccc <__panic>

    free_page(p0);
  103148:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10314f:	00 
  103150:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103153:	89 04 24             	mov    %eax,(%esp)
  103156:	e8 63 0c 00 00       	call   103dbe <free_pages>
    free_page(p1);
  10315b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103162:	00 
  103163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103166:	89 04 24             	mov    %eax,(%esp)
  103169:	e8 50 0c 00 00       	call   103dbe <free_pages>
    free_page(p2);
  10316e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103175:	00 
  103176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103179:	89 04 24             	mov    %eax,(%esp)
  10317c:	e8 3d 0c 00 00       	call   103dbe <free_pages>
    assert(nr_free == 3);
  103181:	a1 18 af 11 00       	mov    0x11af18,%eax
  103186:	83 f8 03             	cmp    $0x3,%eax
  103189:	74 24                	je     1031af <basic_check+0x31c>
  10318b:	c7 44 24 0c b3 66 10 	movl   $0x1066b3,0xc(%esp)
  103192:	00 
  103193:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10319a:	00 
  10319b:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  1031a2:	00 
  1031a3:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1031aa:	e8 1d db ff ff       	call   100ccc <__panic>

    assert((p0 = alloc_page()) != NULL);
  1031af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031b6:	e8 cb 0b 00 00       	call   103d86 <alloc_pages>
  1031bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1031c2:	75 24                	jne    1031e8 <basic_check+0x355>
  1031c4:	c7 44 24 0c 79 65 10 	movl   $0x106579,0xc(%esp)
  1031cb:	00 
  1031cc:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1031d3:	00 
  1031d4:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  1031db:	00 
  1031dc:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1031e3:	e8 e4 da ff ff       	call   100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
  1031e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031ef:	e8 92 0b 00 00       	call   103d86 <alloc_pages>
  1031f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1031fb:	75 24                	jne    103221 <basic_check+0x38e>
  1031fd:	c7 44 24 0c 95 65 10 	movl   $0x106595,0xc(%esp)
  103204:	00 
  103205:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10320c:	00 
  10320d:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  103214:	00 
  103215:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10321c:	e8 ab da ff ff       	call   100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
  103221:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103228:	e8 59 0b 00 00       	call   103d86 <alloc_pages>
  10322d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103234:	75 24                	jne    10325a <basic_check+0x3c7>
  103236:	c7 44 24 0c b1 65 10 	movl   $0x1065b1,0xc(%esp)
  10323d:	00 
  10323e:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103245:	00 
  103246:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  10324d:	00 
  10324e:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103255:	e8 72 da ff ff       	call   100ccc <__panic>

    assert(alloc_page() == NULL);
  10325a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103261:	e8 20 0b 00 00       	call   103d86 <alloc_pages>
  103266:	85 c0                	test   %eax,%eax
  103268:	74 24                	je     10328e <basic_check+0x3fb>
  10326a:	c7 44 24 0c 9e 66 10 	movl   $0x10669e,0xc(%esp)
  103271:	00 
  103272:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103279:	00 
  10327a:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103281:	00 
  103282:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103289:	e8 3e da ff ff       	call   100ccc <__panic>

    free_page(p0);
  10328e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103295:	00 
  103296:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103299:	89 04 24             	mov    %eax,(%esp)
  10329c:	e8 1d 0b 00 00       	call   103dbe <free_pages>
  1032a1:	c7 45 d8 10 af 11 00 	movl   $0x11af10,-0x28(%ebp)
  1032a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1032ab:	8b 40 04             	mov    0x4(%eax),%eax
  1032ae:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1032b1:	0f 94 c0             	sete   %al
  1032b4:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1032b7:	85 c0                	test   %eax,%eax
  1032b9:	74 24                	je     1032df <basic_check+0x44c>
  1032bb:	c7 44 24 0c c0 66 10 	movl   $0x1066c0,0xc(%esp)
  1032c2:	00 
  1032c3:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1032ca:	00 
  1032cb:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  1032d2:	00 
  1032d3:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1032da:	e8 ed d9 ff ff       	call   100ccc <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1032df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032e6:	e8 9b 0a 00 00       	call   103d86 <alloc_pages>
  1032eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032f4:	74 24                	je     10331a <basic_check+0x487>
  1032f6:	c7 44 24 0c d8 66 10 	movl   $0x1066d8,0xc(%esp)
  1032fd:	00 
  1032fe:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103305:	00 
  103306:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  10330d:	00 
  10330e:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103315:	e8 b2 d9 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  10331a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103321:	e8 60 0a 00 00       	call   103d86 <alloc_pages>
  103326:	85 c0                	test   %eax,%eax
  103328:	74 24                	je     10334e <basic_check+0x4bb>
  10332a:	c7 44 24 0c 9e 66 10 	movl   $0x10669e,0xc(%esp)
  103331:	00 
  103332:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103339:	00 
  10333a:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103341:	00 
  103342:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103349:	e8 7e d9 ff ff       	call   100ccc <__panic>

    assert(nr_free == 0);
  10334e:	a1 18 af 11 00       	mov    0x11af18,%eax
  103353:	85 c0                	test   %eax,%eax
  103355:	74 24                	je     10337b <basic_check+0x4e8>
  103357:	c7 44 24 0c f1 66 10 	movl   $0x1066f1,0xc(%esp)
  10335e:	00 
  10335f:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103366:	00 
  103367:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10336e:	00 
  10336f:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103376:	e8 51 d9 ff ff       	call   100ccc <__panic>
    free_list = free_list_store;
  10337b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10337e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103381:	a3 10 af 11 00       	mov    %eax,0x11af10
  103386:	89 15 14 af 11 00    	mov    %edx,0x11af14
    nr_free = nr_free_store;
  10338c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10338f:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_page(p);
  103394:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10339b:	00 
  10339c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10339f:	89 04 24             	mov    %eax,(%esp)
  1033a2:	e8 17 0a 00 00       	call   103dbe <free_pages>
    free_page(p1);
  1033a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033ae:	00 
  1033af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033b2:	89 04 24             	mov    %eax,(%esp)
  1033b5:	e8 04 0a 00 00       	call   103dbe <free_pages>
    free_page(p2);
  1033ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1033c1:	00 
  1033c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033c5:	89 04 24             	mov    %eax,(%esp)
  1033c8:	e8 f1 09 00 00       	call   103dbe <free_pages>
}
  1033cd:	c9                   	leave  
  1033ce:	c3                   	ret    

001033cf <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1033cf:	55                   	push   %ebp
  1033d0:	89 e5                	mov    %esp,%ebp
  1033d2:	53                   	push   %ebx
  1033d3:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1033d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1033e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1033e7:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1033ee:	eb 6b                	jmp    10345b <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1033f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033f3:	83 e8 0c             	sub    $0xc,%eax
  1033f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033fc:	83 c0 04             	add    $0x4,%eax
  1033ff:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103406:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103409:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10340c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10340f:	0f a3 10             	bt     %edx,(%eax)
  103412:	19 c0                	sbb    %eax,%eax
  103414:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103417:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10341b:	0f 95 c0             	setne  %al
  10341e:	0f b6 c0             	movzbl %al,%eax
  103421:	85 c0                	test   %eax,%eax
  103423:	75 24                	jne    103449 <default_check+0x7a>
  103425:	c7 44 24 0c fe 66 10 	movl   $0x1066fe,0xc(%esp)
  10342c:	00 
  10342d:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103434:	00 
  103435:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  10343c:	00 
  10343d:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103444:	e8 83 d8 ff ff       	call   100ccc <__panic>
        count ++, total += p->property;
  103449:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10344d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103450:	8b 50 08             	mov    0x8(%eax),%edx
  103453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103456:	01 d0                	add    %edx,%eax
  103458:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10345b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10345e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103461:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103464:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103467:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10346a:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  103471:	0f 85 79 ff ff ff    	jne    1033f0 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103477:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10347a:	e8 71 09 00 00       	call   103df0 <nr_free_pages>
  10347f:	39 c3                	cmp    %eax,%ebx
  103481:	74 24                	je     1034a7 <default_check+0xd8>
  103483:	c7 44 24 0c 0e 67 10 	movl   $0x10670e,0xc(%esp)
  10348a:	00 
  10348b:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103492:	00 
  103493:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  10349a:	00 
  10349b:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1034a2:	e8 25 d8 ff ff       	call   100ccc <__panic>

    basic_check();
  1034a7:	e8 e7 f9 ff ff       	call   102e93 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1034ac:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1034b3:	e8 ce 08 00 00       	call   103d86 <alloc_pages>
  1034b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1034bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034bf:	75 24                	jne    1034e5 <default_check+0x116>
  1034c1:	c7 44 24 0c 27 67 10 	movl   $0x106727,0xc(%esp)
  1034c8:	00 
  1034c9:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1034d0:	00 
  1034d1:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1034d8:	00 
  1034d9:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1034e0:	e8 e7 d7 ff ff       	call   100ccc <__panic>
    assert(!PageProperty(p0));
  1034e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034e8:	83 c0 04             	add    $0x4,%eax
  1034eb:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1034f2:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034f5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1034f8:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1034fb:	0f a3 10             	bt     %edx,(%eax)
  1034fe:	19 c0                	sbb    %eax,%eax
  103500:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103503:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103507:	0f 95 c0             	setne  %al
  10350a:	0f b6 c0             	movzbl %al,%eax
  10350d:	85 c0                	test   %eax,%eax
  10350f:	74 24                	je     103535 <default_check+0x166>
  103511:	c7 44 24 0c 32 67 10 	movl   $0x106732,0xc(%esp)
  103518:	00 
  103519:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103520:	00 
  103521:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103528:	00 
  103529:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103530:	e8 97 d7 ff ff       	call   100ccc <__panic>

    list_entry_t free_list_store = free_list;
  103535:	a1 10 af 11 00       	mov    0x11af10,%eax
  10353a:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  103540:	89 45 80             	mov    %eax,-0x80(%ebp)
  103543:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103546:	c7 45 b4 10 af 11 00 	movl   $0x11af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10354d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103550:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103553:	89 50 04             	mov    %edx,0x4(%eax)
  103556:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103559:	8b 50 04             	mov    0x4(%eax),%edx
  10355c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10355f:	89 10                	mov    %edx,(%eax)
  103561:	c7 45 b0 10 af 11 00 	movl   $0x11af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103568:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10356b:	8b 40 04             	mov    0x4(%eax),%eax
  10356e:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103571:	0f 94 c0             	sete   %al
  103574:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103577:	85 c0                	test   %eax,%eax
  103579:	75 24                	jne    10359f <default_check+0x1d0>
  10357b:	c7 44 24 0c 87 66 10 	movl   $0x106687,0xc(%esp)
  103582:	00 
  103583:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10358a:	00 
  10358b:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  103592:	00 
  103593:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10359a:	e8 2d d7 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  10359f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035a6:	e8 db 07 00 00       	call   103d86 <alloc_pages>
  1035ab:	85 c0                	test   %eax,%eax
  1035ad:	74 24                	je     1035d3 <default_check+0x204>
  1035af:	c7 44 24 0c 9e 66 10 	movl   $0x10669e,0xc(%esp)
  1035b6:	00 
  1035b7:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1035be:	00 
  1035bf:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  1035c6:	00 
  1035c7:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1035ce:	e8 f9 d6 ff ff       	call   100ccc <__panic>

    unsigned int nr_free_store = nr_free;
  1035d3:	a1 18 af 11 00       	mov    0x11af18,%eax
  1035d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1035db:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  1035e2:	00 00 00 

    free_pages(p0 + 2, 3);
  1035e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e8:	83 c0 28             	add    $0x28,%eax
  1035eb:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1035f2:	00 
  1035f3:	89 04 24             	mov    %eax,(%esp)
  1035f6:	e8 c3 07 00 00       	call   103dbe <free_pages>
    assert(alloc_pages(4) == NULL);
  1035fb:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103602:	e8 7f 07 00 00       	call   103d86 <alloc_pages>
  103607:	85 c0                	test   %eax,%eax
  103609:	74 24                	je     10362f <default_check+0x260>
  10360b:	c7 44 24 0c 44 67 10 	movl   $0x106744,0xc(%esp)
  103612:	00 
  103613:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10361a:	00 
  10361b:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  103622:	00 
  103623:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10362a:	e8 9d d6 ff ff       	call   100ccc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103632:	83 c0 28             	add    $0x28,%eax
  103635:	83 c0 04             	add    $0x4,%eax
  103638:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10363f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103642:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103645:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103648:	0f a3 10             	bt     %edx,(%eax)
  10364b:	19 c0                	sbb    %eax,%eax
  10364d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103650:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103654:	0f 95 c0             	setne  %al
  103657:	0f b6 c0             	movzbl %al,%eax
  10365a:	85 c0                	test   %eax,%eax
  10365c:	74 0e                	je     10366c <default_check+0x29d>
  10365e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103661:	83 c0 28             	add    $0x28,%eax
  103664:	8b 40 08             	mov    0x8(%eax),%eax
  103667:	83 f8 03             	cmp    $0x3,%eax
  10366a:	74 24                	je     103690 <default_check+0x2c1>
  10366c:	c7 44 24 0c 5c 67 10 	movl   $0x10675c,0xc(%esp)
  103673:	00 
  103674:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10367b:	00 
  10367c:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  103683:	00 
  103684:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10368b:	e8 3c d6 ff ff       	call   100ccc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103690:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103697:	e8 ea 06 00 00       	call   103d86 <alloc_pages>
  10369c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10369f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1036a3:	75 24                	jne    1036c9 <default_check+0x2fa>
  1036a5:	c7 44 24 0c 88 67 10 	movl   $0x106788,0xc(%esp)
  1036ac:	00 
  1036ad:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1036b4:	00 
  1036b5:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  1036bc:	00 
  1036bd:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1036c4:	e8 03 d6 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  1036c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036d0:	e8 b1 06 00 00       	call   103d86 <alloc_pages>
  1036d5:	85 c0                	test   %eax,%eax
  1036d7:	74 24                	je     1036fd <default_check+0x32e>
  1036d9:	c7 44 24 0c 9e 66 10 	movl   $0x10669e,0xc(%esp)
  1036e0:	00 
  1036e1:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1036e8:	00 
  1036e9:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1036f0:	00 
  1036f1:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1036f8:	e8 cf d5 ff ff       	call   100ccc <__panic>
    assert(p0 + 2 == p1);
  1036fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103700:	83 c0 28             	add    $0x28,%eax
  103703:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103706:	74 24                	je     10372c <default_check+0x35d>
  103708:	c7 44 24 0c a6 67 10 	movl   $0x1067a6,0xc(%esp)
  10370f:	00 
  103710:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103717:	00 
  103718:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  10371f:	00 
  103720:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103727:	e8 a0 d5 ff ff       	call   100ccc <__panic>

    p2 = p0 + 1;
  10372c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10372f:	83 c0 14             	add    $0x14,%eax
  103732:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103735:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10373c:	00 
  10373d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103740:	89 04 24             	mov    %eax,(%esp)
  103743:	e8 76 06 00 00       	call   103dbe <free_pages>
    free_pages(p1, 3);
  103748:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10374f:	00 
  103750:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103753:	89 04 24             	mov    %eax,(%esp)
  103756:	e8 63 06 00 00       	call   103dbe <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10375b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10375e:	83 c0 04             	add    $0x4,%eax
  103761:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103768:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10376b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10376e:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103771:	0f a3 10             	bt     %edx,(%eax)
  103774:	19 c0                	sbb    %eax,%eax
  103776:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103779:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10377d:	0f 95 c0             	setne  %al
  103780:	0f b6 c0             	movzbl %al,%eax
  103783:	85 c0                	test   %eax,%eax
  103785:	74 0b                	je     103792 <default_check+0x3c3>
  103787:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10378a:	8b 40 08             	mov    0x8(%eax),%eax
  10378d:	83 f8 01             	cmp    $0x1,%eax
  103790:	74 24                	je     1037b6 <default_check+0x3e7>
  103792:	c7 44 24 0c b4 67 10 	movl   $0x1067b4,0xc(%esp)
  103799:	00 
  10379a:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1037a1:	00 
  1037a2:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  1037a9:	00 
  1037aa:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1037b1:	e8 16 d5 ff ff       	call   100ccc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1037b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037b9:	83 c0 04             	add    $0x4,%eax
  1037bc:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1037c3:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  1037c9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1037cc:	0f a3 10             	bt     %edx,(%eax)
  1037cf:	19 c0                	sbb    %eax,%eax
  1037d1:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1037d4:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1037d8:	0f 95 c0             	setne  %al
  1037db:	0f b6 c0             	movzbl %al,%eax
  1037de:	85 c0                	test   %eax,%eax
  1037e0:	74 0b                	je     1037ed <default_check+0x41e>
  1037e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037e5:	8b 40 08             	mov    0x8(%eax),%eax
  1037e8:	83 f8 03             	cmp    $0x3,%eax
  1037eb:	74 24                	je     103811 <default_check+0x442>
  1037ed:	c7 44 24 0c dc 67 10 	movl   $0x1067dc,0xc(%esp)
  1037f4:	00 
  1037f5:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1037fc:	00 
  1037fd:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  103804:	00 
  103805:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10380c:	e8 bb d4 ff ff       	call   100ccc <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103811:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103818:	e8 69 05 00 00       	call   103d86 <alloc_pages>
  10381d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103820:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103823:	83 e8 14             	sub    $0x14,%eax
  103826:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103829:	74 24                	je     10384f <default_check+0x480>
  10382b:	c7 44 24 0c 02 68 10 	movl   $0x106802,0xc(%esp)
  103832:	00 
  103833:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10383a:	00 
  10383b:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  103842:	00 
  103843:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10384a:	e8 7d d4 ff ff       	call   100ccc <__panic>
    free_page(p0);
  10384f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103856:	00 
  103857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10385a:	89 04 24             	mov    %eax,(%esp)
  10385d:	e8 5c 05 00 00       	call   103dbe <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103862:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103869:	e8 18 05 00 00       	call   103d86 <alloc_pages>
  10386e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103871:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103874:	83 c0 14             	add    $0x14,%eax
  103877:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10387a:	74 24                	je     1038a0 <default_check+0x4d1>
  10387c:	c7 44 24 0c 20 68 10 	movl   $0x106820,0xc(%esp)
  103883:	00 
  103884:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10388b:	00 
  10388c:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  103893:	00 
  103894:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10389b:	e8 2c d4 ff ff       	call   100ccc <__panic>

    free_pages(p0, 2);
  1038a0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  1038a7:	00 
  1038a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1038ab:	89 04 24             	mov    %eax,(%esp)
  1038ae:	e8 0b 05 00 00       	call   103dbe <free_pages>
    free_page(p2);
  1038b3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1038ba:	00 
  1038bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1038be:	89 04 24             	mov    %eax,(%esp)
  1038c1:	e8 f8 04 00 00       	call   103dbe <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1038c6:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1038cd:	e8 b4 04 00 00       	call   103d86 <alloc_pages>
  1038d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1038d9:	75 24                	jne    1038ff <default_check+0x530>
  1038db:	c7 44 24 0c 40 68 10 	movl   $0x106840,0xc(%esp)
  1038e2:	00 
  1038e3:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1038ea:	00 
  1038eb:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  1038f2:	00 
  1038f3:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1038fa:	e8 cd d3 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  1038ff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103906:	e8 7b 04 00 00       	call   103d86 <alloc_pages>
  10390b:	85 c0                	test   %eax,%eax
  10390d:	74 24                	je     103933 <default_check+0x564>
  10390f:	c7 44 24 0c 9e 66 10 	movl   $0x10669e,0xc(%esp)
  103916:	00 
  103917:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10391e:	00 
  10391f:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  103926:	00 
  103927:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10392e:	e8 99 d3 ff ff       	call   100ccc <__panic>

    assert(nr_free == 0);
  103933:	a1 18 af 11 00       	mov    0x11af18,%eax
  103938:	85 c0                	test   %eax,%eax
  10393a:	74 24                	je     103960 <default_check+0x591>
  10393c:	c7 44 24 0c f1 66 10 	movl   $0x1066f1,0xc(%esp)
  103943:	00 
  103944:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  10394b:	00 
  10394c:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  103953:	00 
  103954:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  10395b:	e8 6c d3 ff ff       	call   100ccc <__panic>
    nr_free = nr_free_store;
  103960:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103963:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_list = free_list_store;
  103968:	8b 45 80             	mov    -0x80(%ebp),%eax
  10396b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10396e:	a3 10 af 11 00       	mov    %eax,0x11af10
  103973:	89 15 14 af 11 00    	mov    %edx,0x11af14
    free_pages(p0, 5);
  103979:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103980:	00 
  103981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103984:	89 04 24             	mov    %eax,(%esp)
  103987:	e8 32 04 00 00       	call   103dbe <free_pages>

    le = &free_list;
  10398c:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103993:	eb 5b                	jmp    1039f0 <default_check+0x621>
        assert(le->next->prev == le && le->prev->next == le);
  103995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103998:	8b 40 04             	mov    0x4(%eax),%eax
  10399b:	8b 00                	mov    (%eax),%eax
  10399d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1039a0:	75 0d                	jne    1039af <default_check+0x5e0>
  1039a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039a5:	8b 00                	mov    (%eax),%eax
  1039a7:	8b 40 04             	mov    0x4(%eax),%eax
  1039aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1039ad:	74 24                	je     1039d3 <default_check+0x604>
  1039af:	c7 44 24 0c 60 68 10 	movl   $0x106860,0xc(%esp)
  1039b6:	00 
  1039b7:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  1039be:	00 
  1039bf:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  1039c6:	00 
  1039c7:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  1039ce:	e8 f9 d2 ff ff       	call   100ccc <__panic>
        struct Page *p = le2page(le, page_link);
  1039d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039d6:	83 e8 0c             	sub    $0xc,%eax
  1039d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  1039dc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1039e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1039e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1039e6:	8b 40 08             	mov    0x8(%eax),%eax
  1039e9:	29 c2                	sub    %eax,%edx
  1039eb:	89 d0                	mov    %edx,%eax
  1039ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1039f3:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1039f6:	8b 45 88             	mov    -0x78(%ebp),%eax
  1039f9:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1039fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039ff:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  103a06:	75 8d                	jne    103995 <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103a08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103a0c:	74 24                	je     103a32 <default_check+0x663>
  103a0e:	c7 44 24 0c 8d 68 10 	movl   $0x10688d,0xc(%esp)
  103a15:	00 
  103a16:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103a1d:	00 
  103a1e:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  103a25:	00 
  103a26:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103a2d:	e8 9a d2 ff ff       	call   100ccc <__panic>
    assert(total == 0);
  103a32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a36:	74 24                	je     103a5c <default_check+0x68d>
  103a38:	c7 44 24 0c 98 68 10 	movl   $0x106898,0xc(%esp)
  103a3f:	00 
  103a40:	c7 44 24 08 16 65 10 	movl   $0x106516,0x8(%esp)
  103a47:	00 
  103a48:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  103a4f:	00 
  103a50:	c7 04 24 2b 65 10 00 	movl   $0x10652b,(%esp)
  103a57:	e8 70 d2 ff ff       	call   100ccc <__panic>
}
  103a5c:	81 c4 94 00 00 00    	add    $0x94,%esp
  103a62:	5b                   	pop    %ebx
  103a63:	5d                   	pop    %ebp
  103a64:	c3                   	ret    

00103a65 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103a65:	55                   	push   %ebp
  103a66:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103a68:	8b 55 08             	mov    0x8(%ebp),%edx
  103a6b:	a1 24 af 11 00       	mov    0x11af24,%eax
  103a70:	29 c2                	sub    %eax,%edx
  103a72:	89 d0                	mov    %edx,%eax
  103a74:	c1 f8 02             	sar    $0x2,%eax
  103a77:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103a7d:	5d                   	pop    %ebp
  103a7e:	c3                   	ret    

00103a7f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103a7f:	55                   	push   %ebp
  103a80:	89 e5                	mov    %esp,%ebp
  103a82:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103a85:	8b 45 08             	mov    0x8(%ebp),%eax
  103a88:	89 04 24             	mov    %eax,(%esp)
  103a8b:	e8 d5 ff ff ff       	call   103a65 <page2ppn>
  103a90:	c1 e0 0c             	shl    $0xc,%eax
}
  103a93:	c9                   	leave  
  103a94:	c3                   	ret    

00103a95 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a95:	55                   	push   %ebp
  103a96:	89 e5                	mov    %esp,%ebp
  103a98:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  103a9e:	c1 e8 0c             	shr    $0xc,%eax
  103aa1:	89 c2                	mov    %eax,%edx
  103aa3:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103aa8:	39 c2                	cmp    %eax,%edx
  103aaa:	72 1c                	jb     103ac8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103aac:	c7 44 24 08 d4 68 10 	movl   $0x1068d4,0x8(%esp)
  103ab3:	00 
  103ab4:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103abb:	00 
  103abc:	c7 04 24 f3 68 10 00 	movl   $0x1068f3,(%esp)
  103ac3:	e8 04 d2 ff ff       	call   100ccc <__panic>
    }
    return &pages[PPN(pa)];
  103ac8:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  103ace:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad1:	c1 e8 0c             	shr    $0xc,%eax
  103ad4:	89 c2                	mov    %eax,%edx
  103ad6:	89 d0                	mov    %edx,%eax
  103ad8:	c1 e0 02             	shl    $0x2,%eax
  103adb:	01 d0                	add    %edx,%eax
  103add:	c1 e0 02             	shl    $0x2,%eax
  103ae0:	01 c8                	add    %ecx,%eax
}
  103ae2:	c9                   	leave  
  103ae3:	c3                   	ret    

00103ae4 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103ae4:	55                   	push   %ebp
  103ae5:	89 e5                	mov    %esp,%ebp
  103ae7:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103aea:	8b 45 08             	mov    0x8(%ebp),%eax
  103aed:	89 04 24             	mov    %eax,(%esp)
  103af0:	e8 8a ff ff ff       	call   103a7f <page2pa>
  103af5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103afb:	c1 e8 0c             	shr    $0xc,%eax
  103afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b01:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103b06:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103b09:	72 23                	jb     103b2e <page2kva+0x4a>
  103b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b0e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103b12:	c7 44 24 08 04 69 10 	movl   $0x106904,0x8(%esp)
  103b19:	00 
  103b1a:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103b21:	00 
  103b22:	c7 04 24 f3 68 10 00 	movl   $0x1068f3,(%esp)
  103b29:	e8 9e d1 ff ff       	call   100ccc <__panic>
  103b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b31:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103b36:	c9                   	leave  
  103b37:	c3                   	ret    

00103b38 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103b38:	55                   	push   %ebp
  103b39:	89 e5                	mov    %esp,%ebp
  103b3b:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  103b41:	83 e0 01             	and    $0x1,%eax
  103b44:	85 c0                	test   %eax,%eax
  103b46:	75 1c                	jne    103b64 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103b48:	c7 44 24 08 28 69 10 	movl   $0x106928,0x8(%esp)
  103b4f:	00 
  103b50:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103b57:	00 
  103b58:	c7 04 24 f3 68 10 00 	movl   $0x1068f3,(%esp)
  103b5f:	e8 68 d1 ff ff       	call   100ccc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103b64:	8b 45 08             	mov    0x8(%ebp),%eax
  103b67:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b6c:	89 04 24             	mov    %eax,(%esp)
  103b6f:	e8 21 ff ff ff       	call   103a95 <pa2page>
}
  103b74:	c9                   	leave  
  103b75:	c3                   	ret    

00103b76 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103b76:	55                   	push   %ebp
  103b77:	89 e5                	mov    %esp,%ebp
  103b79:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  103b7f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b84:	89 04 24             	mov    %eax,(%esp)
  103b87:	e8 09 ff ff ff       	call   103a95 <pa2page>
}
  103b8c:	c9                   	leave  
  103b8d:	c3                   	ret    

00103b8e <page_ref>:

static inline int
page_ref(struct Page *page) {
  103b8e:	55                   	push   %ebp
  103b8f:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b91:	8b 45 08             	mov    0x8(%ebp),%eax
  103b94:	8b 00                	mov    (%eax),%eax
}
  103b96:	5d                   	pop    %ebp
  103b97:	c3                   	ret    

00103b98 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  103b98:	55                   	push   %ebp
  103b99:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  103b9e:	8b 00                	mov    (%eax),%eax
  103ba0:	8d 50 01             	lea    0x1(%eax),%edx
  103ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ba6:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  103bab:	8b 00                	mov    (%eax),%eax
}
  103bad:	5d                   	pop    %ebp
  103bae:	c3                   	ret    

00103baf <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103baf:	55                   	push   %ebp
  103bb0:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  103bb5:	8b 00                	mov    (%eax),%eax
  103bb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  103bba:	8b 45 08             	mov    0x8(%ebp),%eax
  103bbd:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  103bc2:	8b 00                	mov    (%eax),%eax
}
  103bc4:	5d                   	pop    %ebp
  103bc5:	c3                   	ret    

00103bc6 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103bc6:	55                   	push   %ebp
  103bc7:	89 e5                	mov    %esp,%ebp
  103bc9:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103bcc:	9c                   	pushf  
  103bcd:	58                   	pop    %eax
  103bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103bd4:	25 00 02 00 00       	and    $0x200,%eax
  103bd9:	85 c0                	test   %eax,%eax
  103bdb:	74 0c                	je     103be9 <__intr_save+0x23>
        intr_disable();
  103bdd:	e8 de da ff ff       	call   1016c0 <intr_disable>
        return 1;
  103be2:	b8 01 00 00 00       	mov    $0x1,%eax
  103be7:	eb 05                	jmp    103bee <__intr_save+0x28>
    }
    return 0;
  103be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103bee:	c9                   	leave  
  103bef:	c3                   	ret    

00103bf0 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103bf0:	55                   	push   %ebp
  103bf1:	89 e5                	mov    %esp,%ebp
  103bf3:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103bf6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103bfa:	74 05                	je     103c01 <__intr_restore+0x11>
        intr_enable();
  103bfc:	e8 b9 da ff ff       	call   1016ba <intr_enable>
    }
}
  103c01:	c9                   	leave  
  103c02:	c3                   	ret    

00103c03 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103c03:	55                   	push   %ebp
  103c04:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103c06:	8b 45 08             	mov    0x8(%ebp),%eax
  103c09:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103c0c:	b8 23 00 00 00       	mov    $0x23,%eax
  103c11:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103c13:	b8 23 00 00 00       	mov    $0x23,%eax
  103c18:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103c1a:	b8 10 00 00 00       	mov    $0x10,%eax
  103c1f:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103c21:	b8 10 00 00 00       	mov    $0x10,%eax
  103c26:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103c28:	b8 10 00 00 00       	mov    $0x10,%eax
  103c2d:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103c2f:	ea 36 3c 10 00 08 00 	ljmp   $0x8,$0x103c36
}
  103c36:	5d                   	pop    %ebp
  103c37:	c3                   	ret    

00103c38 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103c38:	55                   	push   %ebp
  103c39:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  103c3e:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  103c43:	5d                   	pop    %ebp
  103c44:	c3                   	ret    

00103c45 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103c45:	55                   	push   %ebp
  103c46:	89 e5                	mov    %esp,%ebp
  103c48:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103c4b:	b8 00 70 11 00       	mov    $0x117000,%eax
  103c50:	89 04 24             	mov    %eax,(%esp)
  103c53:	e8 e0 ff ff ff       	call   103c38 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103c58:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  103c5f:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103c61:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103c68:	68 00 
  103c6a:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103c6f:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103c75:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103c7a:	c1 e8 10             	shr    $0x10,%eax
  103c7d:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103c82:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c89:	83 e0 f0             	and    $0xfffffff0,%eax
  103c8c:	83 c8 09             	or     $0x9,%eax
  103c8f:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c94:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c9b:	83 e0 ef             	and    $0xffffffef,%eax
  103c9e:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103ca3:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103caa:	83 e0 9f             	and    $0xffffff9f,%eax
  103cad:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cb2:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103cb9:	83 c8 80             	or     $0xffffff80,%eax
  103cbc:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103cc1:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cc8:	83 e0 f0             	and    $0xfffffff0,%eax
  103ccb:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cd0:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cd7:	83 e0 ef             	and    $0xffffffef,%eax
  103cda:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cdf:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103ce6:	83 e0 df             	and    $0xffffffdf,%eax
  103ce9:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cee:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103cf5:	83 c8 40             	or     $0x40,%eax
  103cf8:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cfd:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103d04:	83 e0 7f             	and    $0x7f,%eax
  103d07:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103d0c:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103d11:	c1 e8 18             	shr    $0x18,%eax
  103d14:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103d19:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103d20:	e8 de fe ff ff       	call   103c03 <lgdt>
  103d25:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103d2b:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103d2f:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103d32:	c9                   	leave  
  103d33:	c3                   	ret    

00103d34 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103d34:	55                   	push   %ebp
  103d35:	89 e5                	mov    %esp,%ebp
  103d37:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103d3a:	c7 05 1c af 11 00 b8 	movl   $0x1068b8,0x11af1c
  103d41:	68 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103d44:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103d49:	8b 00                	mov    (%eax),%eax
  103d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  103d4f:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  103d56:	e8 ed c5 ff ff       	call   100348 <cprintf>
    pmm_manager->init();
  103d5b:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103d60:	8b 40 04             	mov    0x4(%eax),%eax
  103d63:	ff d0                	call   *%eax
}
  103d65:	c9                   	leave  
  103d66:	c3                   	ret    

00103d67 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103d67:	55                   	push   %ebp
  103d68:	89 e5                	mov    %esp,%ebp
  103d6a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103d6d:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103d72:	8b 40 08             	mov    0x8(%eax),%eax
  103d75:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d78:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  103d7f:	89 14 24             	mov    %edx,(%esp)
  103d82:	ff d0                	call   *%eax
}
  103d84:	c9                   	leave  
  103d85:	c3                   	ret    

00103d86 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103d86:	55                   	push   %ebp
  103d87:	89 e5                	mov    %esp,%ebp
  103d89:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103d93:	e8 2e fe ff ff       	call   103bc6 <__intr_save>
  103d98:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d9b:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103da0:	8b 40 0c             	mov    0xc(%eax),%eax
  103da3:	8b 55 08             	mov    0x8(%ebp),%edx
  103da6:	89 14 24             	mov    %edx,(%esp)
  103da9:	ff d0                	call   *%eax
  103dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103db1:	89 04 24             	mov    %eax,(%esp)
  103db4:	e8 37 fe ff ff       	call   103bf0 <__intr_restore>
    return page;
  103db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103dbc:	c9                   	leave  
  103dbd:	c3                   	ret    

00103dbe <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103dbe:	55                   	push   %ebp
  103dbf:	89 e5                	mov    %esp,%ebp
  103dc1:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103dc4:	e8 fd fd ff ff       	call   103bc6 <__intr_save>
  103dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103dcc:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103dd1:	8b 40 10             	mov    0x10(%eax),%eax
  103dd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  103dd7:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  103dde:	89 14 24             	mov    %edx,(%esp)
  103de1:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103de6:	89 04 24             	mov    %eax,(%esp)
  103de9:	e8 02 fe ff ff       	call   103bf0 <__intr_restore>
}
  103dee:	c9                   	leave  
  103def:	c3                   	ret    

00103df0 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103df0:	55                   	push   %ebp
  103df1:	89 e5                	mov    %esp,%ebp
  103df3:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103df6:	e8 cb fd ff ff       	call   103bc6 <__intr_save>
  103dfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103dfe:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103e03:	8b 40 14             	mov    0x14(%eax),%eax
  103e06:	ff d0                	call   *%eax
  103e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e0e:	89 04 24             	mov    %eax,(%esp)
  103e11:	e8 da fd ff ff       	call   103bf0 <__intr_restore>
    return ret;
  103e16:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103e19:	c9                   	leave  
  103e1a:	c3                   	ret    

00103e1b <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103e1b:	55                   	push   %ebp
  103e1c:	89 e5                	mov    %esp,%ebp
  103e1e:	57                   	push   %edi
  103e1f:	56                   	push   %esi
  103e20:	53                   	push   %ebx
  103e21:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103e27:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103e2e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103e35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103e3c:	c7 04 24 6b 69 10 00 	movl   $0x10696b,(%esp)
  103e43:	e8 00 c5 ff ff       	call   100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e48:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e4f:	e9 15 01 00 00       	jmp    103f69 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103e54:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e57:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e5a:	89 d0                	mov    %edx,%eax
  103e5c:	c1 e0 02             	shl    $0x2,%eax
  103e5f:	01 d0                	add    %edx,%eax
  103e61:	c1 e0 02             	shl    $0x2,%eax
  103e64:	01 c8                	add    %ecx,%eax
  103e66:	8b 50 08             	mov    0x8(%eax),%edx
  103e69:	8b 40 04             	mov    0x4(%eax),%eax
  103e6c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e6f:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103e72:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e75:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e78:	89 d0                	mov    %edx,%eax
  103e7a:	c1 e0 02             	shl    $0x2,%eax
  103e7d:	01 d0                	add    %edx,%eax
  103e7f:	c1 e0 02             	shl    $0x2,%eax
  103e82:	01 c8                	add    %ecx,%eax
  103e84:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e87:	8b 58 10             	mov    0x10(%eax),%ebx
  103e8a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e8d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e90:	01 c8                	add    %ecx,%eax
  103e92:	11 da                	adc    %ebx,%edx
  103e94:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103e97:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103e9a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ea0:	89 d0                	mov    %edx,%eax
  103ea2:	c1 e0 02             	shl    $0x2,%eax
  103ea5:	01 d0                	add    %edx,%eax
  103ea7:	c1 e0 02             	shl    $0x2,%eax
  103eaa:	01 c8                	add    %ecx,%eax
  103eac:	83 c0 14             	add    $0x14,%eax
  103eaf:	8b 00                	mov    (%eax),%eax
  103eb1:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103eb7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103eba:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103ebd:	83 c0 ff             	add    $0xffffffff,%eax
  103ec0:	83 d2 ff             	adc    $0xffffffff,%edx
  103ec3:	89 c6                	mov    %eax,%esi
  103ec5:	89 d7                	mov    %edx,%edi
  103ec7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103eca:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ecd:	89 d0                	mov    %edx,%eax
  103ecf:	c1 e0 02             	shl    $0x2,%eax
  103ed2:	01 d0                	add    %edx,%eax
  103ed4:	c1 e0 02             	shl    $0x2,%eax
  103ed7:	01 c8                	add    %ecx,%eax
  103ed9:	8b 48 0c             	mov    0xc(%eax),%ecx
  103edc:	8b 58 10             	mov    0x10(%eax),%ebx
  103edf:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103ee5:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103ee9:	89 74 24 14          	mov    %esi,0x14(%esp)
  103eed:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103ef1:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103ef4:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103ef7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103efb:	89 54 24 10          	mov    %edx,0x10(%esp)
  103eff:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103f03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103f07:	c7 04 24 78 69 10 00 	movl   $0x106978,(%esp)
  103f0e:	e8 35 c4 ff ff       	call   100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103f13:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f19:	89 d0                	mov    %edx,%eax
  103f1b:	c1 e0 02             	shl    $0x2,%eax
  103f1e:	01 d0                	add    %edx,%eax
  103f20:	c1 e0 02             	shl    $0x2,%eax
  103f23:	01 c8                	add    %ecx,%eax
  103f25:	83 c0 14             	add    $0x14,%eax
  103f28:	8b 00                	mov    (%eax),%eax
  103f2a:	83 f8 01             	cmp    $0x1,%eax
  103f2d:	75 36                	jne    103f65 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f35:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f38:	77 2b                	ja     103f65 <page_init+0x14a>
  103f3a:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103f3d:	72 05                	jb     103f44 <page_init+0x129>
  103f3f:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103f42:	73 21                	jae    103f65 <page_init+0x14a>
  103f44:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f48:	77 1b                	ja     103f65 <page_init+0x14a>
  103f4a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103f4e:	72 09                	jb     103f59 <page_init+0x13e>
  103f50:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103f57:	77 0c                	ja     103f65 <page_init+0x14a>
                maxpa = end;
  103f59:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103f5c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103f62:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103f65:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f6c:	8b 00                	mov    (%eax),%eax
  103f6e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f71:	0f 8f dd fe ff ff    	jg     103e54 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f7b:	72 1d                	jb     103f9a <page_init+0x17f>
  103f7d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f81:	77 09                	ja     103f8c <page_init+0x171>
  103f83:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f8a:	76 0e                	jbe    103f9a <page_init+0x17f>
        maxpa = KMEMSIZE;
  103f8c:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103f93:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103f9a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103fa0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103fa4:	c1 ea 0c             	shr    $0xc,%edx
  103fa7:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103fac:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103fb3:	b8 28 af 11 00       	mov    $0x11af28,%eax
  103fb8:	8d 50 ff             	lea    -0x1(%eax),%edx
  103fbb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103fbe:	01 d0                	add    %edx,%eax
  103fc0:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103fc3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103fc6:	ba 00 00 00 00       	mov    $0x0,%edx
  103fcb:	f7 75 ac             	divl   -0x54(%ebp)
  103fce:	89 d0                	mov    %edx,%eax
  103fd0:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103fd3:	29 c2                	sub    %eax,%edx
  103fd5:	89 d0                	mov    %edx,%eax
  103fd7:	a3 24 af 11 00       	mov    %eax,0x11af24

    for (i = 0; i < npage; i ++) {
  103fdc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fe3:	eb 2f                	jmp    104014 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103fe5:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  103feb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fee:	89 d0                	mov    %edx,%eax
  103ff0:	c1 e0 02             	shl    $0x2,%eax
  103ff3:	01 d0                	add    %edx,%eax
  103ff5:	c1 e0 02             	shl    $0x2,%eax
  103ff8:	01 c8                	add    %ecx,%eax
  103ffa:	83 c0 04             	add    $0x4,%eax
  103ffd:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  104004:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104007:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10400a:	8b 55 90             	mov    -0x70(%ebp),%edx
  10400d:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  104010:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104014:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104017:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  10401c:	39 c2                	cmp    %eax,%edx
  10401e:	72 c5                	jb     103fe5 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  104020:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  104026:	89 d0                	mov    %edx,%eax
  104028:	c1 e0 02             	shl    $0x2,%eax
  10402b:	01 d0                	add    %edx,%eax
  10402d:	c1 e0 02             	shl    $0x2,%eax
  104030:	89 c2                	mov    %eax,%edx
  104032:	a1 24 af 11 00       	mov    0x11af24,%eax
  104037:	01 d0                	add    %edx,%eax
  104039:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  10403c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  104043:	77 23                	ja     104068 <page_init+0x24d>
  104045:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104048:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10404c:	c7 44 24 08 a8 69 10 	movl   $0x1069a8,0x8(%esp)
  104053:	00 
  104054:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  10405b:	00 
  10405c:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104063:	e8 64 cc ff ff       	call   100ccc <__panic>
  104068:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10406b:	05 00 00 00 40       	add    $0x40000000,%eax
  104070:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104073:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10407a:	e9 74 01 00 00       	jmp    1041f3 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10407f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104082:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104085:	89 d0                	mov    %edx,%eax
  104087:	c1 e0 02             	shl    $0x2,%eax
  10408a:	01 d0                	add    %edx,%eax
  10408c:	c1 e0 02             	shl    $0x2,%eax
  10408f:	01 c8                	add    %ecx,%eax
  104091:	8b 50 08             	mov    0x8(%eax),%edx
  104094:	8b 40 04             	mov    0x4(%eax),%eax
  104097:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10409a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10409d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040a0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040a3:	89 d0                	mov    %edx,%eax
  1040a5:	c1 e0 02             	shl    $0x2,%eax
  1040a8:	01 d0                	add    %edx,%eax
  1040aa:	c1 e0 02             	shl    $0x2,%eax
  1040ad:	01 c8                	add    %ecx,%eax
  1040af:	8b 48 0c             	mov    0xc(%eax),%ecx
  1040b2:	8b 58 10             	mov    0x10(%eax),%ebx
  1040b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040b8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040bb:	01 c8                	add    %ecx,%eax
  1040bd:	11 da                	adc    %ebx,%edx
  1040bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040c2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1040c5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040cb:	89 d0                	mov    %edx,%eax
  1040cd:	c1 e0 02             	shl    $0x2,%eax
  1040d0:	01 d0                	add    %edx,%eax
  1040d2:	c1 e0 02             	shl    $0x2,%eax
  1040d5:	01 c8                	add    %ecx,%eax
  1040d7:	83 c0 14             	add    $0x14,%eax
  1040da:	8b 00                	mov    (%eax),%eax
  1040dc:	83 f8 01             	cmp    $0x1,%eax
  1040df:	0f 85 0a 01 00 00    	jne    1041ef <page_init+0x3d4>
            if (begin < freemem) {
  1040e5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040e8:	ba 00 00 00 00       	mov    $0x0,%edx
  1040ed:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1040f0:	72 17                	jb     104109 <page_init+0x2ee>
  1040f2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1040f5:	77 05                	ja     1040fc <page_init+0x2e1>
  1040f7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1040fa:	76 0d                	jbe    104109 <page_init+0x2ee>
                begin = freemem;
  1040fc:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104102:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104109:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10410d:	72 1d                	jb     10412c <page_init+0x311>
  10410f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104113:	77 09                	ja     10411e <page_init+0x303>
  104115:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10411c:	76 0e                	jbe    10412c <page_init+0x311>
                end = KMEMSIZE;
  10411e:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  104125:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10412c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10412f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104132:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104135:	0f 87 b4 00 00 00    	ja     1041ef <page_init+0x3d4>
  10413b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10413e:	72 09                	jb     104149 <page_init+0x32e>
  104140:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104143:	0f 83 a6 00 00 00    	jae    1041ef <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104149:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104150:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104153:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104156:	01 d0                	add    %edx,%eax
  104158:	83 e8 01             	sub    $0x1,%eax
  10415b:	89 45 98             	mov    %eax,-0x68(%ebp)
  10415e:	8b 45 98             	mov    -0x68(%ebp),%eax
  104161:	ba 00 00 00 00       	mov    $0x0,%edx
  104166:	f7 75 9c             	divl   -0x64(%ebp)
  104169:	89 d0                	mov    %edx,%eax
  10416b:	8b 55 98             	mov    -0x68(%ebp),%edx
  10416e:	29 c2                	sub    %eax,%edx
  104170:	89 d0                	mov    %edx,%eax
  104172:	ba 00 00 00 00       	mov    $0x0,%edx
  104177:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10417a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10417d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104180:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104183:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104186:	ba 00 00 00 00       	mov    $0x0,%edx
  10418b:	89 c7                	mov    %eax,%edi
  10418d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104193:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104196:	89 d0                	mov    %edx,%eax
  104198:	83 e0 00             	and    $0x0,%eax
  10419b:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10419e:	8b 45 80             	mov    -0x80(%ebp),%eax
  1041a1:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1041a4:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1041a7:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1041aa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1041b0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1041b3:	77 3a                	ja     1041ef <page_init+0x3d4>
  1041b5:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1041b8:	72 05                	jb     1041bf <page_init+0x3a4>
  1041ba:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1041bd:	73 30                	jae    1041ef <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1041bf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1041c2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1041c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1041c8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1041cb:	29 c8                	sub    %ecx,%eax
  1041cd:	19 da                	sbb    %ebx,%edx
  1041cf:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1041d3:	c1 ea 0c             	shr    $0xc,%edx
  1041d6:	89 c3                	mov    %eax,%ebx
  1041d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1041db:	89 04 24             	mov    %eax,(%esp)
  1041de:	e8 b2 f8 ff ff       	call   103a95 <pa2page>
  1041e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1041e7:	89 04 24             	mov    %eax,(%esp)
  1041ea:	e8 78 fb ff ff       	call   103d67 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1041ef:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1041f3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1041f6:	8b 00                	mov    (%eax),%eax
  1041f8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1041fb:	0f 8f 7e fe ff ff    	jg     10407f <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104201:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104207:	5b                   	pop    %ebx
  104208:	5e                   	pop    %esi
  104209:	5f                   	pop    %edi
  10420a:	5d                   	pop    %ebp
  10420b:	c3                   	ret    

0010420c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10420c:	55                   	push   %ebp
  10420d:	89 e5                	mov    %esp,%ebp
  10420f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104212:	8b 45 14             	mov    0x14(%ebp),%eax
  104215:	8b 55 0c             	mov    0xc(%ebp),%edx
  104218:	31 d0                	xor    %edx,%eax
  10421a:	25 ff 0f 00 00       	and    $0xfff,%eax
  10421f:	85 c0                	test   %eax,%eax
  104221:	74 24                	je     104247 <boot_map_segment+0x3b>
  104223:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  10422a:	00 
  10422b:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104232:	00 
  104233:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  10423a:	00 
  10423b:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104242:	e8 85 ca ff ff       	call   100ccc <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104247:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10424e:	8b 45 0c             	mov    0xc(%ebp),%eax
  104251:	25 ff 0f 00 00       	and    $0xfff,%eax
  104256:	89 c2                	mov    %eax,%edx
  104258:	8b 45 10             	mov    0x10(%ebp),%eax
  10425b:	01 c2                	add    %eax,%edx
  10425d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104260:	01 d0                	add    %edx,%eax
  104262:	83 e8 01             	sub    $0x1,%eax
  104265:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104268:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10426b:	ba 00 00 00 00       	mov    $0x0,%edx
  104270:	f7 75 f0             	divl   -0x10(%ebp)
  104273:	89 d0                	mov    %edx,%eax
  104275:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104278:	29 c2                	sub    %eax,%edx
  10427a:	89 d0                	mov    %edx,%eax
  10427c:	c1 e8 0c             	shr    $0xc,%eax
  10427f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104282:	8b 45 0c             	mov    0xc(%ebp),%eax
  104285:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104288:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10428b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104290:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104293:	8b 45 14             	mov    0x14(%ebp),%eax
  104296:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104299:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10429c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1042a1:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042a4:	eb 6b                	jmp    104311 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1042a6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1042ad:	00 
  1042ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1042b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1042b8:	89 04 24             	mov    %eax,(%esp)
  1042bb:	e8 82 01 00 00       	call   104442 <get_pte>
  1042c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1042c3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1042c7:	75 24                	jne    1042ed <boot_map_segment+0xe1>
  1042c9:	c7 44 24 0c 06 6a 10 	movl   $0x106a06,0xc(%esp)
  1042d0:	00 
  1042d1:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  1042d8:	00 
  1042d9:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1042e0:	00 
  1042e1:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  1042e8:	e8 df c9 ff ff       	call   100ccc <__panic>
        *ptep = pa | PTE_P | perm;
  1042ed:	8b 45 18             	mov    0x18(%ebp),%eax
  1042f0:	8b 55 14             	mov    0x14(%ebp),%edx
  1042f3:	09 d0                	or     %edx,%eax
  1042f5:	83 c8 01             	or     $0x1,%eax
  1042f8:	89 c2                	mov    %eax,%edx
  1042fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042fd:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042ff:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104303:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10430a:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104315:	75 8f                	jne    1042a6 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104317:	c9                   	leave  
  104318:	c3                   	ret    

00104319 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104319:	55                   	push   %ebp
  10431a:	89 e5                	mov    %esp,%ebp
  10431c:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10431f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104326:	e8 5b fa ff ff       	call   103d86 <alloc_pages>
  10432b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10432e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104332:	75 1c                	jne    104350 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104334:	c7 44 24 08 13 6a 10 	movl   $0x106a13,0x8(%esp)
  10433b:	00 
  10433c:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  104343:	00 
  104344:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  10434b:	e8 7c c9 ff ff       	call   100ccc <__panic>
    }
    return page2kva(p);
  104350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104353:	89 04 24             	mov    %eax,(%esp)
  104356:	e8 89 f7 ff ff       	call   103ae4 <page2kva>
}
  10435b:	c9                   	leave  
  10435c:	c3                   	ret    

0010435d <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10435d:	55                   	push   %ebp
  10435e:	89 e5                	mov    %esp,%ebp
  104360:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  104363:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10436b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104372:	77 23                	ja     104397 <pmm_init+0x3a>
  104374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104377:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10437b:	c7 44 24 08 a8 69 10 	movl   $0x1069a8,0x8(%esp)
  104382:	00 
  104383:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10438a:	00 
  10438b:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104392:	e8 35 c9 ff ff       	call   100ccc <__panic>
  104397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10439a:	05 00 00 00 40       	add    $0x40000000,%eax
  10439f:	a3 20 af 11 00       	mov    %eax,0x11af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1043a4:	e8 8b f9 ff ff       	call   103d34 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1043a9:	e8 6d fa ff ff       	call   103e1b <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1043ae:	e8 4c 02 00 00       	call   1045ff <check_alloc_page>

    check_pgdir();
  1043b3:	e8 65 02 00 00       	call   10461d <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1043b8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1043bd:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1043c3:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1043c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1043cb:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1043d2:	77 23                	ja     1043f7 <pmm_init+0x9a>
  1043d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043db:	c7 44 24 08 a8 69 10 	movl   $0x1069a8,0x8(%esp)
  1043e2:	00 
  1043e3:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1043ea:	00 
  1043eb:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  1043f2:	e8 d5 c8 ff ff       	call   100ccc <__panic>
  1043f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043fa:	05 00 00 00 40       	add    $0x40000000,%eax
  1043ff:	83 c8 03             	or     $0x3,%eax
  104402:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  104404:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104409:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104410:	00 
  104411:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104418:	00 
  104419:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104420:	38 
  104421:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104428:	c0 
  104429:	89 04 24             	mov    %eax,(%esp)
  10442c:	e8 db fd ff ff       	call   10420c <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104431:	e8 0f f8 ff ff       	call   103c45 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104436:	e8 7d 08 00 00       	call   104cb8 <check_boot_pgdir>

    print_pgdir();
  10443b:	e8 05 0d 00 00       	call   105145 <print_pgdir>

}
  104440:	c9                   	leave  
  104441:	c3                   	ret    

00104442 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104442:	55                   	push   %ebp
  104443:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  104445:	5d                   	pop    %ebp
  104446:	c3                   	ret    

00104447 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  104447:	55                   	push   %ebp
  104448:	89 e5                	mov    %esp,%ebp
  10444a:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10444d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104454:	00 
  104455:	8b 45 0c             	mov    0xc(%ebp),%eax
  104458:	89 44 24 04          	mov    %eax,0x4(%esp)
  10445c:	8b 45 08             	mov    0x8(%ebp),%eax
  10445f:	89 04 24             	mov    %eax,(%esp)
  104462:	e8 db ff ff ff       	call   104442 <get_pte>
  104467:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10446a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10446e:	74 08                	je     104478 <get_page+0x31>
        *ptep_store = ptep;
  104470:	8b 45 10             	mov    0x10(%ebp),%eax
  104473:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104476:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10447c:	74 1b                	je     104499 <get_page+0x52>
  10447e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104481:	8b 00                	mov    (%eax),%eax
  104483:	83 e0 01             	and    $0x1,%eax
  104486:	85 c0                	test   %eax,%eax
  104488:	74 0f                	je     104499 <get_page+0x52>
        return pte2page(*ptep);
  10448a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10448d:	8b 00                	mov    (%eax),%eax
  10448f:	89 04 24             	mov    %eax,(%esp)
  104492:	e8 a1 f6 ff ff       	call   103b38 <pte2page>
  104497:	eb 05                	jmp    10449e <get_page+0x57>
    }
    return NULL;
  104499:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10449e:	c9                   	leave  
  10449f:	c3                   	ret    

001044a0 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1044a0:	55                   	push   %ebp
  1044a1:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  1044a3:	5d                   	pop    %ebp
  1044a4:	c3                   	ret    

001044a5 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1044a5:	55                   	push   %ebp
  1044a6:	89 e5                	mov    %esp,%ebp
  1044a8:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1044ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044b2:	00 
  1044b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1044bd:	89 04 24             	mov    %eax,(%esp)
  1044c0:	e8 7d ff ff ff       	call   104442 <get_pte>
  1044c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  1044c8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1044cc:	74 19                	je     1044e7 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1044ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1044d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1044d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1044df:	89 04 24             	mov    %eax,(%esp)
  1044e2:	e8 b9 ff ff ff       	call   1044a0 <page_remove_pte>
    }
}
  1044e7:	c9                   	leave  
  1044e8:	c3                   	ret    

001044e9 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1044e9:	55                   	push   %ebp
  1044ea:	89 e5                	mov    %esp,%ebp
  1044ec:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1044ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1044f6:	00 
  1044f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1044fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044fe:	8b 45 08             	mov    0x8(%ebp),%eax
  104501:	89 04 24             	mov    %eax,(%esp)
  104504:	e8 39 ff ff ff       	call   104442 <get_pte>
  104509:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10450c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104510:	75 0a                	jne    10451c <page_insert+0x33>
        return -E_NO_MEM;
  104512:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104517:	e9 84 00 00 00       	jmp    1045a0 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10451c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10451f:	89 04 24             	mov    %eax,(%esp)
  104522:	e8 71 f6 ff ff       	call   103b98 <page_ref_inc>
    if (*ptep & PTE_P) {
  104527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10452a:	8b 00                	mov    (%eax),%eax
  10452c:	83 e0 01             	and    $0x1,%eax
  10452f:	85 c0                	test   %eax,%eax
  104531:	74 3e                	je     104571 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  104533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104536:	8b 00                	mov    (%eax),%eax
  104538:	89 04 24             	mov    %eax,(%esp)
  10453b:	e8 f8 f5 ff ff       	call   103b38 <pte2page>
  104540:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  104543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104546:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104549:	75 0d                	jne    104558 <page_insert+0x6f>
            page_ref_dec(page);
  10454b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10454e:	89 04 24             	mov    %eax,(%esp)
  104551:	e8 59 f6 ff ff       	call   103baf <page_ref_dec>
  104556:	eb 19                	jmp    104571 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10455b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10455f:	8b 45 10             	mov    0x10(%ebp),%eax
  104562:	89 44 24 04          	mov    %eax,0x4(%esp)
  104566:	8b 45 08             	mov    0x8(%ebp),%eax
  104569:	89 04 24             	mov    %eax,(%esp)
  10456c:	e8 2f ff ff ff       	call   1044a0 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104571:	8b 45 0c             	mov    0xc(%ebp),%eax
  104574:	89 04 24             	mov    %eax,(%esp)
  104577:	e8 03 f5 ff ff       	call   103a7f <page2pa>
  10457c:	0b 45 14             	or     0x14(%ebp),%eax
  10457f:	83 c8 01             	or     $0x1,%eax
  104582:	89 c2                	mov    %eax,%edx
  104584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104587:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104589:	8b 45 10             	mov    0x10(%ebp),%eax
  10458c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104590:	8b 45 08             	mov    0x8(%ebp),%eax
  104593:	89 04 24             	mov    %eax,(%esp)
  104596:	e8 07 00 00 00       	call   1045a2 <tlb_invalidate>
    return 0;
  10459b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045a0:	c9                   	leave  
  1045a1:	c3                   	ret    

001045a2 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1045a2:	55                   	push   %ebp
  1045a3:	89 e5                	mov    %esp,%ebp
  1045a5:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1045a8:	0f 20 d8             	mov    %cr3,%eax
  1045ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1045ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1045b1:	89 c2                	mov    %eax,%edx
  1045b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1045b9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1045c0:	77 23                	ja     1045e5 <tlb_invalidate+0x43>
  1045c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045c9:	c7 44 24 08 a8 69 10 	movl   $0x1069a8,0x8(%esp)
  1045d0:	00 
  1045d1:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  1045d8:	00 
  1045d9:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  1045e0:	e8 e7 c6 ff ff       	call   100ccc <__panic>
  1045e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045e8:	05 00 00 00 40       	add    $0x40000000,%eax
  1045ed:	39 c2                	cmp    %eax,%edx
  1045ef:	75 0c                	jne    1045fd <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1045f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1045f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045fa:	0f 01 38             	invlpg (%eax)
    }
}
  1045fd:	c9                   	leave  
  1045fe:	c3                   	ret    

001045ff <check_alloc_page>:

static void
check_alloc_page(void) {
  1045ff:	55                   	push   %ebp
  104600:	89 e5                	mov    %esp,%ebp
  104602:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104605:	a1 1c af 11 00       	mov    0x11af1c,%eax
  10460a:	8b 40 18             	mov    0x18(%eax),%eax
  10460d:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  10460f:	c7 04 24 2c 6a 10 00 	movl   $0x106a2c,(%esp)
  104616:	e8 2d bd ff ff       	call   100348 <cprintf>
}
  10461b:	c9                   	leave  
  10461c:	c3                   	ret    

0010461d <check_pgdir>:

static void
check_pgdir(void) {
  10461d:	55                   	push   %ebp
  10461e:	89 e5                	mov    %esp,%ebp
  104620:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104623:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104628:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10462d:	76 24                	jbe    104653 <check_pgdir+0x36>
  10462f:	c7 44 24 0c 4b 6a 10 	movl   $0x106a4b,0xc(%esp)
  104636:	00 
  104637:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  10463e:	00 
  10463f:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  104646:	00 
  104647:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  10464e:	e8 79 c6 ff ff       	call   100ccc <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104653:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104658:	85 c0                	test   %eax,%eax
  10465a:	74 0e                	je     10466a <check_pgdir+0x4d>
  10465c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104661:	25 ff 0f 00 00       	and    $0xfff,%eax
  104666:	85 c0                	test   %eax,%eax
  104668:	74 24                	je     10468e <check_pgdir+0x71>
  10466a:	c7 44 24 0c 68 6a 10 	movl   $0x106a68,0xc(%esp)
  104671:	00 
  104672:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104679:	00 
  10467a:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  104681:	00 
  104682:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104689:	e8 3e c6 ff ff       	call   100ccc <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10468e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104693:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10469a:	00 
  10469b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046a2:	00 
  1046a3:	89 04 24             	mov    %eax,(%esp)
  1046a6:	e8 9c fd ff ff       	call   104447 <get_page>
  1046ab:	85 c0                	test   %eax,%eax
  1046ad:	74 24                	je     1046d3 <check_pgdir+0xb6>
  1046af:	c7 44 24 0c a0 6a 10 	movl   $0x106aa0,0xc(%esp)
  1046b6:	00 
  1046b7:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  1046be:	00 
  1046bf:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  1046c6:	00 
  1046c7:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  1046ce:	e8 f9 c5 ff ff       	call   100ccc <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1046d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1046da:	e8 a7 f6 ff ff       	call   103d86 <alloc_pages>
  1046df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1046e2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1046e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1046ee:	00 
  1046ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046f6:	00 
  1046f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1046fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046fe:	89 04 24             	mov    %eax,(%esp)
  104701:	e8 e3 fd ff ff       	call   1044e9 <page_insert>
  104706:	85 c0                	test   %eax,%eax
  104708:	74 24                	je     10472e <check_pgdir+0x111>
  10470a:	c7 44 24 0c c8 6a 10 	movl   $0x106ac8,0xc(%esp)
  104711:	00 
  104712:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104719:	00 
  10471a:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  104721:	00 
  104722:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104729:	e8 9e c5 ff ff       	call   100ccc <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10472e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104733:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10473a:	00 
  10473b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104742:	00 
  104743:	89 04 24             	mov    %eax,(%esp)
  104746:	e8 f7 fc ff ff       	call   104442 <get_pte>
  10474b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10474e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104752:	75 24                	jne    104778 <check_pgdir+0x15b>
  104754:	c7 44 24 0c f4 6a 10 	movl   $0x106af4,0xc(%esp)
  10475b:	00 
  10475c:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104763:	00 
  104764:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  10476b:	00 
  10476c:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104773:	e8 54 c5 ff ff       	call   100ccc <__panic>
    assert(pte2page(*ptep) == p1);
  104778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10477b:	8b 00                	mov    (%eax),%eax
  10477d:	89 04 24             	mov    %eax,(%esp)
  104780:	e8 b3 f3 ff ff       	call   103b38 <pte2page>
  104785:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104788:	74 24                	je     1047ae <check_pgdir+0x191>
  10478a:	c7 44 24 0c 21 6b 10 	movl   $0x106b21,0xc(%esp)
  104791:	00 
  104792:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104799:	00 
  10479a:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  1047a1:	00 
  1047a2:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  1047a9:	e8 1e c5 ff ff       	call   100ccc <__panic>
    assert(page_ref(p1) == 1);
  1047ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047b1:	89 04 24             	mov    %eax,(%esp)
  1047b4:	e8 d5 f3 ff ff       	call   103b8e <page_ref>
  1047b9:	83 f8 01             	cmp    $0x1,%eax
  1047bc:	74 24                	je     1047e2 <check_pgdir+0x1c5>
  1047be:	c7 44 24 0c 37 6b 10 	movl   $0x106b37,0xc(%esp)
  1047c5:	00 
  1047c6:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  1047cd:	00 
  1047ce:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  1047d5:	00 
  1047d6:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  1047dd:	e8 ea c4 ff ff       	call   100ccc <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1047e2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1047e7:	8b 00                	mov    (%eax),%eax
  1047e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1047ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1047f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047f4:	c1 e8 0c             	shr    $0xc,%eax
  1047f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1047fa:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1047ff:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104802:	72 23                	jb     104827 <check_pgdir+0x20a>
  104804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104807:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10480b:	c7 44 24 08 04 69 10 	movl   $0x106904,0x8(%esp)
  104812:	00 
  104813:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  10481a:	00 
  10481b:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104822:	e8 a5 c4 ff ff       	call   100ccc <__panic>
  104827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10482a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10482f:	83 c0 04             	add    $0x4,%eax
  104832:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104835:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10483a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104841:	00 
  104842:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104849:	00 
  10484a:	89 04 24             	mov    %eax,(%esp)
  10484d:	e8 f0 fb ff ff       	call   104442 <get_pte>
  104852:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104855:	74 24                	je     10487b <check_pgdir+0x25e>
  104857:	c7 44 24 0c 4c 6b 10 	movl   $0x106b4c,0xc(%esp)
  10485e:	00 
  10485f:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104866:	00 
  104867:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  10486e:	00 
  10486f:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104876:	e8 51 c4 ff ff       	call   100ccc <__panic>

    p2 = alloc_page();
  10487b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104882:	e8 ff f4 ff ff       	call   103d86 <alloc_pages>
  104887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10488a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10488f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104896:	00 
  104897:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10489e:	00 
  10489f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1048a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048a6:	89 04 24             	mov    %eax,(%esp)
  1048a9:	e8 3b fc ff ff       	call   1044e9 <page_insert>
  1048ae:	85 c0                	test   %eax,%eax
  1048b0:	74 24                	je     1048d6 <check_pgdir+0x2b9>
  1048b2:	c7 44 24 0c 74 6b 10 	movl   $0x106b74,0xc(%esp)
  1048b9:	00 
  1048ba:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  1048c1:	00 
  1048c2:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  1048c9:	00 
  1048ca:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  1048d1:	e8 f6 c3 ff ff       	call   100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1048d6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1048db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048e2:	00 
  1048e3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1048ea:	00 
  1048eb:	89 04 24             	mov    %eax,(%esp)
  1048ee:	e8 4f fb ff ff       	call   104442 <get_pte>
  1048f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048fa:	75 24                	jne    104920 <check_pgdir+0x303>
  1048fc:	c7 44 24 0c ac 6b 10 	movl   $0x106bac,0xc(%esp)
  104903:	00 
  104904:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  10490b:	00 
  10490c:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  104913:	00 
  104914:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  10491b:	e8 ac c3 ff ff       	call   100ccc <__panic>
    assert(*ptep & PTE_U);
  104920:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104923:	8b 00                	mov    (%eax),%eax
  104925:	83 e0 04             	and    $0x4,%eax
  104928:	85 c0                	test   %eax,%eax
  10492a:	75 24                	jne    104950 <check_pgdir+0x333>
  10492c:	c7 44 24 0c dc 6b 10 	movl   $0x106bdc,0xc(%esp)
  104933:	00 
  104934:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  10493b:	00 
  10493c:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  104943:	00 
  104944:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  10494b:	e8 7c c3 ff ff       	call   100ccc <__panic>
    assert(*ptep & PTE_W);
  104950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104953:	8b 00                	mov    (%eax),%eax
  104955:	83 e0 02             	and    $0x2,%eax
  104958:	85 c0                	test   %eax,%eax
  10495a:	75 24                	jne    104980 <check_pgdir+0x363>
  10495c:	c7 44 24 0c ea 6b 10 	movl   $0x106bea,0xc(%esp)
  104963:	00 
  104964:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  10496b:	00 
  10496c:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  104973:	00 
  104974:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  10497b:	e8 4c c3 ff ff       	call   100ccc <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104980:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104985:	8b 00                	mov    (%eax),%eax
  104987:	83 e0 04             	and    $0x4,%eax
  10498a:	85 c0                	test   %eax,%eax
  10498c:	75 24                	jne    1049b2 <check_pgdir+0x395>
  10498e:	c7 44 24 0c f8 6b 10 	movl   $0x106bf8,0xc(%esp)
  104995:	00 
  104996:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  10499d:	00 
  10499e:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  1049a5:	00 
  1049a6:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  1049ad:	e8 1a c3 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 1);
  1049b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049b5:	89 04 24             	mov    %eax,(%esp)
  1049b8:	e8 d1 f1 ff ff       	call   103b8e <page_ref>
  1049bd:	83 f8 01             	cmp    $0x1,%eax
  1049c0:	74 24                	je     1049e6 <check_pgdir+0x3c9>
  1049c2:	c7 44 24 0c 0e 6c 10 	movl   $0x106c0e,0xc(%esp)
  1049c9:	00 
  1049ca:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  1049d1:	00 
  1049d2:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  1049d9:	00 
  1049da:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  1049e1:	e8 e6 c2 ff ff       	call   100ccc <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  1049e6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1049eb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1049f2:	00 
  1049f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1049fa:	00 
  1049fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1049fe:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a02:	89 04 24             	mov    %eax,(%esp)
  104a05:	e8 df fa ff ff       	call   1044e9 <page_insert>
  104a0a:	85 c0                	test   %eax,%eax
  104a0c:	74 24                	je     104a32 <check_pgdir+0x415>
  104a0e:	c7 44 24 0c 20 6c 10 	movl   $0x106c20,0xc(%esp)
  104a15:	00 
  104a16:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104a1d:	00 
  104a1e:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  104a25:	00 
  104a26:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104a2d:	e8 9a c2 ff ff       	call   100ccc <__panic>
    assert(page_ref(p1) == 2);
  104a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a35:	89 04 24             	mov    %eax,(%esp)
  104a38:	e8 51 f1 ff ff       	call   103b8e <page_ref>
  104a3d:	83 f8 02             	cmp    $0x2,%eax
  104a40:	74 24                	je     104a66 <check_pgdir+0x449>
  104a42:	c7 44 24 0c 4c 6c 10 	movl   $0x106c4c,0xc(%esp)
  104a49:	00 
  104a4a:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104a51:	00 
  104a52:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  104a59:	00 
  104a5a:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104a61:	e8 66 c2 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 0);
  104a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a69:	89 04 24             	mov    %eax,(%esp)
  104a6c:	e8 1d f1 ff ff       	call   103b8e <page_ref>
  104a71:	85 c0                	test   %eax,%eax
  104a73:	74 24                	je     104a99 <check_pgdir+0x47c>
  104a75:	c7 44 24 0c 5e 6c 10 	movl   $0x106c5e,0xc(%esp)
  104a7c:	00 
  104a7d:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104a84:	00 
  104a85:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104a8c:	00 
  104a8d:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104a94:	e8 33 c2 ff ff       	call   100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a99:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104a9e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104aa5:	00 
  104aa6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104aad:	00 
  104aae:	89 04 24             	mov    %eax,(%esp)
  104ab1:	e8 8c f9 ff ff       	call   104442 <get_pte>
  104ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ab9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104abd:	75 24                	jne    104ae3 <check_pgdir+0x4c6>
  104abf:	c7 44 24 0c ac 6b 10 	movl   $0x106bac,0xc(%esp)
  104ac6:	00 
  104ac7:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104ace:	00 
  104acf:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104ad6:	00 
  104ad7:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104ade:	e8 e9 c1 ff ff       	call   100ccc <__panic>
    assert(pte2page(*ptep) == p1);
  104ae3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ae6:	8b 00                	mov    (%eax),%eax
  104ae8:	89 04 24             	mov    %eax,(%esp)
  104aeb:	e8 48 f0 ff ff       	call   103b38 <pte2page>
  104af0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104af3:	74 24                	je     104b19 <check_pgdir+0x4fc>
  104af5:	c7 44 24 0c 21 6b 10 	movl   $0x106b21,0xc(%esp)
  104afc:	00 
  104afd:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104b04:	00 
  104b05:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104b0c:	00 
  104b0d:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104b14:	e8 b3 c1 ff ff       	call   100ccc <__panic>
    assert((*ptep & PTE_U) == 0);
  104b19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b1c:	8b 00                	mov    (%eax),%eax
  104b1e:	83 e0 04             	and    $0x4,%eax
  104b21:	85 c0                	test   %eax,%eax
  104b23:	74 24                	je     104b49 <check_pgdir+0x52c>
  104b25:	c7 44 24 0c 70 6c 10 	movl   $0x106c70,0xc(%esp)
  104b2c:	00 
  104b2d:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104b34:	00 
  104b35:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104b3c:	00 
  104b3d:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104b44:	e8 83 c1 ff ff       	call   100ccc <__panic>

    page_remove(boot_pgdir, 0x0);
  104b49:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104b4e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b55:	00 
  104b56:	89 04 24             	mov    %eax,(%esp)
  104b59:	e8 47 f9 ff ff       	call   1044a5 <page_remove>
    assert(page_ref(p1) == 1);
  104b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b61:	89 04 24             	mov    %eax,(%esp)
  104b64:	e8 25 f0 ff ff       	call   103b8e <page_ref>
  104b69:	83 f8 01             	cmp    $0x1,%eax
  104b6c:	74 24                	je     104b92 <check_pgdir+0x575>
  104b6e:	c7 44 24 0c 37 6b 10 	movl   $0x106b37,0xc(%esp)
  104b75:	00 
  104b76:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104b7d:	00 
  104b7e:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  104b85:	00 
  104b86:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104b8d:	e8 3a c1 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 0);
  104b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b95:	89 04 24             	mov    %eax,(%esp)
  104b98:	e8 f1 ef ff ff       	call   103b8e <page_ref>
  104b9d:	85 c0                	test   %eax,%eax
  104b9f:	74 24                	je     104bc5 <check_pgdir+0x5a8>
  104ba1:	c7 44 24 0c 5e 6c 10 	movl   $0x106c5e,0xc(%esp)
  104ba8:	00 
  104ba9:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104bb0:	00 
  104bb1:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104bb8:	00 
  104bb9:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104bc0:	e8 07 c1 ff ff       	call   100ccc <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104bc5:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104bca:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104bd1:	00 
  104bd2:	89 04 24             	mov    %eax,(%esp)
  104bd5:	e8 cb f8 ff ff       	call   1044a5 <page_remove>
    assert(page_ref(p1) == 0);
  104bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bdd:	89 04 24             	mov    %eax,(%esp)
  104be0:	e8 a9 ef ff ff       	call   103b8e <page_ref>
  104be5:	85 c0                	test   %eax,%eax
  104be7:	74 24                	je     104c0d <check_pgdir+0x5f0>
  104be9:	c7 44 24 0c 85 6c 10 	movl   $0x106c85,0xc(%esp)
  104bf0:	00 
  104bf1:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104bf8:	00 
  104bf9:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104c00:	00 
  104c01:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104c08:	e8 bf c0 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 0);
  104c0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c10:	89 04 24             	mov    %eax,(%esp)
  104c13:	e8 76 ef ff ff       	call   103b8e <page_ref>
  104c18:	85 c0                	test   %eax,%eax
  104c1a:	74 24                	je     104c40 <check_pgdir+0x623>
  104c1c:	c7 44 24 0c 5e 6c 10 	movl   $0x106c5e,0xc(%esp)
  104c23:	00 
  104c24:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104c2b:	00 
  104c2c:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104c33:	00 
  104c34:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104c3b:	e8 8c c0 ff ff       	call   100ccc <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104c40:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104c45:	8b 00                	mov    (%eax),%eax
  104c47:	89 04 24             	mov    %eax,(%esp)
  104c4a:	e8 27 ef ff ff       	call   103b76 <pde2page>
  104c4f:	89 04 24             	mov    %eax,(%esp)
  104c52:	e8 37 ef ff ff       	call   103b8e <page_ref>
  104c57:	83 f8 01             	cmp    $0x1,%eax
  104c5a:	74 24                	je     104c80 <check_pgdir+0x663>
  104c5c:	c7 44 24 0c 98 6c 10 	movl   $0x106c98,0xc(%esp)
  104c63:	00 
  104c64:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104c6b:	00 
  104c6c:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104c73:	00 
  104c74:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104c7b:	e8 4c c0 ff ff       	call   100ccc <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104c80:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104c85:	8b 00                	mov    (%eax),%eax
  104c87:	89 04 24             	mov    %eax,(%esp)
  104c8a:	e8 e7 ee ff ff       	call   103b76 <pde2page>
  104c8f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c96:	00 
  104c97:	89 04 24             	mov    %eax,(%esp)
  104c9a:	e8 1f f1 ff ff       	call   103dbe <free_pages>
    boot_pgdir[0] = 0;
  104c9f:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104ca4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104caa:	c7 04 24 bf 6c 10 00 	movl   $0x106cbf,(%esp)
  104cb1:	e8 92 b6 ff ff       	call   100348 <cprintf>
}
  104cb6:	c9                   	leave  
  104cb7:	c3                   	ret    

00104cb8 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104cb8:	55                   	push   %ebp
  104cb9:	89 e5                	mov    %esp,%ebp
  104cbb:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104cc5:	e9 ca 00 00 00       	jmp    104d94 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ccd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cd3:	c1 e8 0c             	shr    $0xc,%eax
  104cd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104cd9:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104cde:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104ce1:	72 23                	jb     104d06 <check_boot_pgdir+0x4e>
  104ce3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ce6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104cea:	c7 44 24 08 04 69 10 	movl   $0x106904,0x8(%esp)
  104cf1:	00 
  104cf2:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104cf9:	00 
  104cfa:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104d01:	e8 c6 bf ff ff       	call   100ccc <__panic>
  104d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d09:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104d0e:	89 c2                	mov    %eax,%edx
  104d10:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104d15:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104d1c:	00 
  104d1d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d21:	89 04 24             	mov    %eax,(%esp)
  104d24:	e8 19 f7 ff ff       	call   104442 <get_pte>
  104d29:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104d2c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104d30:	75 24                	jne    104d56 <check_boot_pgdir+0x9e>
  104d32:	c7 44 24 0c dc 6c 10 	movl   $0x106cdc,0xc(%esp)
  104d39:	00 
  104d3a:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104d41:	00 
  104d42:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104d49:	00 
  104d4a:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104d51:	e8 76 bf ff ff       	call   100ccc <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104d56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d59:	8b 00                	mov    (%eax),%eax
  104d5b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104d60:	89 c2                	mov    %eax,%edx
  104d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d65:	39 c2                	cmp    %eax,%edx
  104d67:	74 24                	je     104d8d <check_boot_pgdir+0xd5>
  104d69:	c7 44 24 0c 19 6d 10 	movl   $0x106d19,0xc(%esp)
  104d70:	00 
  104d71:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104d78:	00 
  104d79:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104d80:	00 
  104d81:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104d88:	e8 3f bf ff ff       	call   100ccc <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104d8d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d97:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104d9c:	39 c2                	cmp    %eax,%edx
  104d9e:	0f 82 26 ff ff ff    	jb     104cca <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104da4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104da9:	05 ac 0f 00 00       	add    $0xfac,%eax
  104dae:	8b 00                	mov    (%eax),%eax
  104db0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104db5:	89 c2                	mov    %eax,%edx
  104db7:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104dbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104dbf:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104dc6:	77 23                	ja     104deb <check_boot_pgdir+0x133>
  104dc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104dcf:	c7 44 24 08 a8 69 10 	movl   $0x1069a8,0x8(%esp)
  104dd6:	00 
  104dd7:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104dde:	00 
  104ddf:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104de6:	e8 e1 be ff ff       	call   100ccc <__panic>
  104deb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dee:	05 00 00 00 40       	add    $0x40000000,%eax
  104df3:	39 c2                	cmp    %eax,%edx
  104df5:	74 24                	je     104e1b <check_boot_pgdir+0x163>
  104df7:	c7 44 24 0c 30 6d 10 	movl   $0x106d30,0xc(%esp)
  104dfe:	00 
  104dff:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104e06:	00 
  104e07:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104e0e:	00 
  104e0f:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104e16:	e8 b1 be ff ff       	call   100ccc <__panic>

    assert(boot_pgdir[0] == 0);
  104e1b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e20:	8b 00                	mov    (%eax),%eax
  104e22:	85 c0                	test   %eax,%eax
  104e24:	74 24                	je     104e4a <check_boot_pgdir+0x192>
  104e26:	c7 44 24 0c 64 6d 10 	movl   $0x106d64,0xc(%esp)
  104e2d:	00 
  104e2e:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104e35:	00 
  104e36:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104e3d:	00 
  104e3e:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104e45:	e8 82 be ff ff       	call   100ccc <__panic>

    struct Page *p;
    p = alloc_page();
  104e4a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e51:	e8 30 ef ff ff       	call   103d86 <alloc_pages>
  104e56:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104e59:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e5e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104e65:	00 
  104e66:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104e6d:	00 
  104e6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104e71:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e75:	89 04 24             	mov    %eax,(%esp)
  104e78:	e8 6c f6 ff ff       	call   1044e9 <page_insert>
  104e7d:	85 c0                	test   %eax,%eax
  104e7f:	74 24                	je     104ea5 <check_boot_pgdir+0x1ed>
  104e81:	c7 44 24 0c 78 6d 10 	movl   $0x106d78,0xc(%esp)
  104e88:	00 
  104e89:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104e90:	00 
  104e91:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104e98:	00 
  104e99:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104ea0:	e8 27 be ff ff       	call   100ccc <__panic>
    assert(page_ref(p) == 1);
  104ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ea8:	89 04 24             	mov    %eax,(%esp)
  104eab:	e8 de ec ff ff       	call   103b8e <page_ref>
  104eb0:	83 f8 01             	cmp    $0x1,%eax
  104eb3:	74 24                	je     104ed9 <check_boot_pgdir+0x221>
  104eb5:	c7 44 24 0c a6 6d 10 	movl   $0x106da6,0xc(%esp)
  104ebc:	00 
  104ebd:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104ec4:	00 
  104ec5:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104ecc:	00 
  104ecd:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104ed4:	e8 f3 bd ff ff       	call   100ccc <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104ed9:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104ede:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104ee5:	00 
  104ee6:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104eed:	00 
  104eee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104ef1:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ef5:	89 04 24             	mov    %eax,(%esp)
  104ef8:	e8 ec f5 ff ff       	call   1044e9 <page_insert>
  104efd:	85 c0                	test   %eax,%eax
  104eff:	74 24                	je     104f25 <check_boot_pgdir+0x26d>
  104f01:	c7 44 24 0c b8 6d 10 	movl   $0x106db8,0xc(%esp)
  104f08:	00 
  104f09:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104f10:	00 
  104f11:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104f18:	00 
  104f19:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104f20:	e8 a7 bd ff ff       	call   100ccc <__panic>
    assert(page_ref(p) == 2);
  104f25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f28:	89 04 24             	mov    %eax,(%esp)
  104f2b:	e8 5e ec ff ff       	call   103b8e <page_ref>
  104f30:	83 f8 02             	cmp    $0x2,%eax
  104f33:	74 24                	je     104f59 <check_boot_pgdir+0x2a1>
  104f35:	c7 44 24 0c ef 6d 10 	movl   $0x106def,0xc(%esp)
  104f3c:	00 
  104f3d:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104f44:	00 
  104f45:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104f4c:	00 
  104f4d:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104f54:	e8 73 bd ff ff       	call   100ccc <__panic>

    const char *str = "ucore: Hello world!!";
  104f59:	c7 45 dc 00 6e 10 00 	movl   $0x106e00,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104f60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f63:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f67:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f6e:	e8 19 0a 00 00       	call   10598c <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104f73:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104f7a:	00 
  104f7b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f82:	e8 7e 0a 00 00       	call   105a05 <strcmp>
  104f87:	85 c0                	test   %eax,%eax
  104f89:	74 24                	je     104faf <check_boot_pgdir+0x2f7>
  104f8b:	c7 44 24 0c 18 6e 10 	movl   $0x106e18,0xc(%esp)
  104f92:	00 
  104f93:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104f9a:	00 
  104f9b:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104fa2:	00 
  104fa3:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104faa:	e8 1d bd ff ff       	call   100ccc <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104faf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fb2:	89 04 24             	mov    %eax,(%esp)
  104fb5:	e8 2a eb ff ff       	call   103ae4 <page2kva>
  104fba:	05 00 01 00 00       	add    $0x100,%eax
  104fbf:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104fc2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104fc9:	e8 66 09 00 00       	call   105934 <strlen>
  104fce:	85 c0                	test   %eax,%eax
  104fd0:	74 24                	je     104ff6 <check_boot_pgdir+0x33e>
  104fd2:	c7 44 24 0c 50 6e 10 	movl   $0x106e50,0xc(%esp)
  104fd9:	00 
  104fda:	c7 44 24 08 f1 69 10 	movl   $0x1069f1,0x8(%esp)
  104fe1:	00 
  104fe2:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104fe9:	00 
  104fea:	c7 04 24 cc 69 10 00 	movl   $0x1069cc,(%esp)
  104ff1:	e8 d6 bc ff ff       	call   100ccc <__panic>

    free_page(p);
  104ff6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ffd:	00 
  104ffe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105001:	89 04 24             	mov    %eax,(%esp)
  105004:	e8 b5 ed ff ff       	call   103dbe <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105009:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10500e:	8b 00                	mov    (%eax),%eax
  105010:	89 04 24             	mov    %eax,(%esp)
  105013:	e8 5e eb ff ff       	call   103b76 <pde2page>
  105018:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10501f:	00 
  105020:	89 04 24             	mov    %eax,(%esp)
  105023:	e8 96 ed ff ff       	call   103dbe <free_pages>
    boot_pgdir[0] = 0;
  105028:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10502d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105033:	c7 04 24 74 6e 10 00 	movl   $0x106e74,(%esp)
  10503a:	e8 09 b3 ff ff       	call   100348 <cprintf>
}
  10503f:	c9                   	leave  
  105040:	c3                   	ret    

00105041 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105041:	55                   	push   %ebp
  105042:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105044:	8b 45 08             	mov    0x8(%ebp),%eax
  105047:	83 e0 04             	and    $0x4,%eax
  10504a:	85 c0                	test   %eax,%eax
  10504c:	74 07                	je     105055 <perm2str+0x14>
  10504e:	b8 75 00 00 00       	mov    $0x75,%eax
  105053:	eb 05                	jmp    10505a <perm2str+0x19>
  105055:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10505a:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  10505f:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105066:	8b 45 08             	mov    0x8(%ebp),%eax
  105069:	83 e0 02             	and    $0x2,%eax
  10506c:	85 c0                	test   %eax,%eax
  10506e:	74 07                	je     105077 <perm2str+0x36>
  105070:	b8 77 00 00 00       	mov    $0x77,%eax
  105075:	eb 05                	jmp    10507c <perm2str+0x3b>
  105077:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10507c:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  105081:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  105088:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  10508d:	5d                   	pop    %ebp
  10508e:	c3                   	ret    

0010508f <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10508f:	55                   	push   %ebp
  105090:	89 e5                	mov    %esp,%ebp
  105092:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105095:	8b 45 10             	mov    0x10(%ebp),%eax
  105098:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10509b:	72 0a                	jb     1050a7 <get_pgtable_items+0x18>
        return 0;
  10509d:	b8 00 00 00 00       	mov    $0x0,%eax
  1050a2:	e9 9c 00 00 00       	jmp    105143 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1050a7:	eb 04                	jmp    1050ad <get_pgtable_items+0x1e>
        start ++;
  1050a9:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1050ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1050b0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050b3:	73 18                	jae    1050cd <get_pgtable_items+0x3e>
  1050b5:	8b 45 10             	mov    0x10(%ebp),%eax
  1050b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1050bf:	8b 45 14             	mov    0x14(%ebp),%eax
  1050c2:	01 d0                	add    %edx,%eax
  1050c4:	8b 00                	mov    (%eax),%eax
  1050c6:	83 e0 01             	and    $0x1,%eax
  1050c9:	85 c0                	test   %eax,%eax
  1050cb:	74 dc                	je     1050a9 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1050cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1050d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050d3:	73 69                	jae    10513e <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1050d5:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1050d9:	74 08                	je     1050e3 <get_pgtable_items+0x54>
            *left_store = start;
  1050db:	8b 45 18             	mov    0x18(%ebp),%eax
  1050de:	8b 55 10             	mov    0x10(%ebp),%edx
  1050e1:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1050e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1050e6:	8d 50 01             	lea    0x1(%eax),%edx
  1050e9:	89 55 10             	mov    %edx,0x10(%ebp)
  1050ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1050f3:	8b 45 14             	mov    0x14(%ebp),%eax
  1050f6:	01 d0                	add    %edx,%eax
  1050f8:	8b 00                	mov    (%eax),%eax
  1050fa:	83 e0 07             	and    $0x7,%eax
  1050fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105100:	eb 04                	jmp    105106 <get_pgtable_items+0x77>
            start ++;
  105102:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105106:	8b 45 10             	mov    0x10(%ebp),%eax
  105109:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10510c:	73 1d                	jae    10512b <get_pgtable_items+0x9c>
  10510e:	8b 45 10             	mov    0x10(%ebp),%eax
  105111:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105118:	8b 45 14             	mov    0x14(%ebp),%eax
  10511b:	01 d0                	add    %edx,%eax
  10511d:	8b 00                	mov    (%eax),%eax
  10511f:	83 e0 07             	and    $0x7,%eax
  105122:	89 c2                	mov    %eax,%edx
  105124:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105127:	39 c2                	cmp    %eax,%edx
  105129:	74 d7                	je     105102 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  10512b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10512f:	74 08                	je     105139 <get_pgtable_items+0xaa>
            *right_store = start;
  105131:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105134:	8b 55 10             	mov    0x10(%ebp),%edx
  105137:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105139:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10513c:	eb 05                	jmp    105143 <get_pgtable_items+0xb4>
    }
    return 0;
  10513e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105143:	c9                   	leave  
  105144:	c3                   	ret    

00105145 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105145:	55                   	push   %ebp
  105146:	89 e5                	mov    %esp,%ebp
  105148:	57                   	push   %edi
  105149:	56                   	push   %esi
  10514a:	53                   	push   %ebx
  10514b:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10514e:	c7 04 24 94 6e 10 00 	movl   $0x106e94,(%esp)
  105155:	e8 ee b1 ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
  10515a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105161:	e9 fa 00 00 00       	jmp    105260 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105169:	89 04 24             	mov    %eax,(%esp)
  10516c:	e8 d0 fe ff ff       	call   105041 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105171:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105174:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105177:	29 d1                	sub    %edx,%ecx
  105179:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10517b:	89 d6                	mov    %edx,%esi
  10517d:	c1 e6 16             	shl    $0x16,%esi
  105180:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105183:	89 d3                	mov    %edx,%ebx
  105185:	c1 e3 16             	shl    $0x16,%ebx
  105188:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10518b:	89 d1                	mov    %edx,%ecx
  10518d:	c1 e1 16             	shl    $0x16,%ecx
  105190:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105193:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105196:	29 d7                	sub    %edx,%edi
  105198:	89 fa                	mov    %edi,%edx
  10519a:	89 44 24 14          	mov    %eax,0x14(%esp)
  10519e:	89 74 24 10          	mov    %esi,0x10(%esp)
  1051a2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1051a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1051aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051ae:	c7 04 24 c5 6e 10 00 	movl   $0x106ec5,(%esp)
  1051b5:	e8 8e b1 ff ff       	call   100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1051ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051bd:	c1 e0 0a             	shl    $0xa,%eax
  1051c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1051c3:	eb 54                	jmp    105219 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1051c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051c8:	89 04 24             	mov    %eax,(%esp)
  1051cb:	e8 71 fe ff ff       	call   105041 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1051d0:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1051d3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1051d6:	29 d1                	sub    %edx,%ecx
  1051d8:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1051da:	89 d6                	mov    %edx,%esi
  1051dc:	c1 e6 0c             	shl    $0xc,%esi
  1051df:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1051e2:	89 d3                	mov    %edx,%ebx
  1051e4:	c1 e3 0c             	shl    $0xc,%ebx
  1051e7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1051ea:	c1 e2 0c             	shl    $0xc,%edx
  1051ed:	89 d1                	mov    %edx,%ecx
  1051ef:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1051f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1051f5:	29 d7                	sub    %edx,%edi
  1051f7:	89 fa                	mov    %edi,%edx
  1051f9:	89 44 24 14          	mov    %eax,0x14(%esp)
  1051fd:	89 74 24 10          	mov    %esi,0x10(%esp)
  105201:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105205:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105209:	89 54 24 04          	mov    %edx,0x4(%esp)
  10520d:	c7 04 24 e4 6e 10 00 	movl   $0x106ee4,(%esp)
  105214:	e8 2f b1 ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105219:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  10521e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105221:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105224:	89 ce                	mov    %ecx,%esi
  105226:	c1 e6 0a             	shl    $0xa,%esi
  105229:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10522c:	89 cb                	mov    %ecx,%ebx
  10522e:	c1 e3 0a             	shl    $0xa,%ebx
  105231:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105234:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105238:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10523b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10523f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105243:	89 44 24 08          	mov    %eax,0x8(%esp)
  105247:	89 74 24 04          	mov    %esi,0x4(%esp)
  10524b:	89 1c 24             	mov    %ebx,(%esp)
  10524e:	e8 3c fe ff ff       	call   10508f <get_pgtable_items>
  105253:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105256:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10525a:	0f 85 65 ff ff ff    	jne    1051c5 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105260:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105265:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105268:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10526b:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10526f:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105272:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105276:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10527a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10527e:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105285:	00 
  105286:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10528d:	e8 fd fd ff ff       	call   10508f <get_pgtable_items>
  105292:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105295:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105299:	0f 85 c7 fe ff ff    	jne    105166 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10529f:	c7 04 24 08 6f 10 00 	movl   $0x106f08,(%esp)
  1052a6:	e8 9d b0 ff ff       	call   100348 <cprintf>
}
  1052ab:	83 c4 4c             	add    $0x4c,%esp
  1052ae:	5b                   	pop    %ebx
  1052af:	5e                   	pop    %esi
  1052b0:	5f                   	pop    %edi
  1052b1:	5d                   	pop    %ebp
  1052b2:	c3                   	ret    

001052b3 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1052b3:	55                   	push   %ebp
  1052b4:	89 e5                	mov    %esp,%ebp
  1052b6:	83 ec 58             	sub    $0x58,%esp
  1052b9:	8b 45 10             	mov    0x10(%ebp),%eax
  1052bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1052bf:	8b 45 14             	mov    0x14(%ebp),%eax
  1052c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1052c5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1052c8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1052cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052ce:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1052d1:	8b 45 18             	mov    0x18(%ebp),%eax
  1052d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1052d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1052dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052e0:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1052e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1052e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1052ed:	74 1c                	je     10530b <printnum+0x58>
  1052ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052f2:	ba 00 00 00 00       	mov    $0x0,%edx
  1052f7:	f7 75 e4             	divl   -0x1c(%ebp)
  1052fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1052fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105300:	ba 00 00 00 00       	mov    $0x0,%edx
  105305:	f7 75 e4             	divl   -0x1c(%ebp)
  105308:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10530b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10530e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105311:	f7 75 e4             	divl   -0x1c(%ebp)
  105314:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105317:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10531a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10531d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105320:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105323:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105326:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105329:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10532c:	8b 45 18             	mov    0x18(%ebp),%eax
  10532f:	ba 00 00 00 00       	mov    $0x0,%edx
  105334:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105337:	77 56                	ja     10538f <printnum+0xdc>
  105339:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10533c:	72 05                	jb     105343 <printnum+0x90>
  10533e:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105341:	77 4c                	ja     10538f <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105343:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105346:	8d 50 ff             	lea    -0x1(%eax),%edx
  105349:	8b 45 20             	mov    0x20(%ebp),%eax
  10534c:	89 44 24 18          	mov    %eax,0x18(%esp)
  105350:	89 54 24 14          	mov    %edx,0x14(%esp)
  105354:	8b 45 18             	mov    0x18(%ebp),%eax
  105357:	89 44 24 10          	mov    %eax,0x10(%esp)
  10535b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10535e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105361:	89 44 24 08          	mov    %eax,0x8(%esp)
  105365:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105369:	8b 45 0c             	mov    0xc(%ebp),%eax
  10536c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105370:	8b 45 08             	mov    0x8(%ebp),%eax
  105373:	89 04 24             	mov    %eax,(%esp)
  105376:	e8 38 ff ff ff       	call   1052b3 <printnum>
  10537b:	eb 1c                	jmp    105399 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10537d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105380:	89 44 24 04          	mov    %eax,0x4(%esp)
  105384:	8b 45 20             	mov    0x20(%ebp),%eax
  105387:	89 04 24             	mov    %eax,(%esp)
  10538a:	8b 45 08             	mov    0x8(%ebp),%eax
  10538d:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  10538f:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105393:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105397:	7f e4                	jg     10537d <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105399:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10539c:	05 bc 6f 10 00       	add    $0x106fbc,%eax
  1053a1:	0f b6 00             	movzbl (%eax),%eax
  1053a4:	0f be c0             	movsbl %al,%eax
  1053a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1053aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053ae:	89 04 24             	mov    %eax,(%esp)
  1053b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1053b4:	ff d0                	call   *%eax
}
  1053b6:	c9                   	leave  
  1053b7:	c3                   	ret    

001053b8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1053b8:	55                   	push   %ebp
  1053b9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1053bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1053bf:	7e 14                	jle    1053d5 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1053c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1053c4:	8b 00                	mov    (%eax),%eax
  1053c6:	8d 48 08             	lea    0x8(%eax),%ecx
  1053c9:	8b 55 08             	mov    0x8(%ebp),%edx
  1053cc:	89 0a                	mov    %ecx,(%edx)
  1053ce:	8b 50 04             	mov    0x4(%eax),%edx
  1053d1:	8b 00                	mov    (%eax),%eax
  1053d3:	eb 30                	jmp    105405 <getuint+0x4d>
    }
    else if (lflag) {
  1053d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1053d9:	74 16                	je     1053f1 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1053db:	8b 45 08             	mov    0x8(%ebp),%eax
  1053de:	8b 00                	mov    (%eax),%eax
  1053e0:	8d 48 04             	lea    0x4(%eax),%ecx
  1053e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1053e6:	89 0a                	mov    %ecx,(%edx)
  1053e8:	8b 00                	mov    (%eax),%eax
  1053ea:	ba 00 00 00 00       	mov    $0x0,%edx
  1053ef:	eb 14                	jmp    105405 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1053f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1053f4:	8b 00                	mov    (%eax),%eax
  1053f6:	8d 48 04             	lea    0x4(%eax),%ecx
  1053f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1053fc:	89 0a                	mov    %ecx,(%edx)
  1053fe:	8b 00                	mov    (%eax),%eax
  105400:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105405:	5d                   	pop    %ebp
  105406:	c3                   	ret    

00105407 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105407:	55                   	push   %ebp
  105408:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10540a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  10540e:	7e 14                	jle    105424 <getint+0x1d>
        return va_arg(*ap, long long);
  105410:	8b 45 08             	mov    0x8(%ebp),%eax
  105413:	8b 00                	mov    (%eax),%eax
  105415:	8d 48 08             	lea    0x8(%eax),%ecx
  105418:	8b 55 08             	mov    0x8(%ebp),%edx
  10541b:	89 0a                	mov    %ecx,(%edx)
  10541d:	8b 50 04             	mov    0x4(%eax),%edx
  105420:	8b 00                	mov    (%eax),%eax
  105422:	eb 28                	jmp    10544c <getint+0x45>
    }
    else if (lflag) {
  105424:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105428:	74 12                	je     10543c <getint+0x35>
        return va_arg(*ap, long);
  10542a:	8b 45 08             	mov    0x8(%ebp),%eax
  10542d:	8b 00                	mov    (%eax),%eax
  10542f:	8d 48 04             	lea    0x4(%eax),%ecx
  105432:	8b 55 08             	mov    0x8(%ebp),%edx
  105435:	89 0a                	mov    %ecx,(%edx)
  105437:	8b 00                	mov    (%eax),%eax
  105439:	99                   	cltd   
  10543a:	eb 10                	jmp    10544c <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10543c:	8b 45 08             	mov    0x8(%ebp),%eax
  10543f:	8b 00                	mov    (%eax),%eax
  105441:	8d 48 04             	lea    0x4(%eax),%ecx
  105444:	8b 55 08             	mov    0x8(%ebp),%edx
  105447:	89 0a                	mov    %ecx,(%edx)
  105449:	8b 00                	mov    (%eax),%eax
  10544b:	99                   	cltd   
    }
}
  10544c:	5d                   	pop    %ebp
  10544d:	c3                   	ret    

0010544e <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10544e:	55                   	push   %ebp
  10544f:	89 e5                	mov    %esp,%ebp
  105451:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105454:	8d 45 14             	lea    0x14(%ebp),%eax
  105457:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10545a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10545d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105461:	8b 45 10             	mov    0x10(%ebp),%eax
  105464:	89 44 24 08          	mov    %eax,0x8(%esp)
  105468:	8b 45 0c             	mov    0xc(%ebp),%eax
  10546b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10546f:	8b 45 08             	mov    0x8(%ebp),%eax
  105472:	89 04 24             	mov    %eax,(%esp)
  105475:	e8 02 00 00 00       	call   10547c <vprintfmt>
    va_end(ap);
}
  10547a:	c9                   	leave  
  10547b:	c3                   	ret    

0010547c <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10547c:	55                   	push   %ebp
  10547d:	89 e5                	mov    %esp,%ebp
  10547f:	56                   	push   %esi
  105480:	53                   	push   %ebx
  105481:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105484:	eb 18                	jmp    10549e <vprintfmt+0x22>
            if (ch == '\0') {
  105486:	85 db                	test   %ebx,%ebx
  105488:	75 05                	jne    10548f <vprintfmt+0x13>
                return;
  10548a:	e9 d1 03 00 00       	jmp    105860 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  10548f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105492:	89 44 24 04          	mov    %eax,0x4(%esp)
  105496:	89 1c 24             	mov    %ebx,(%esp)
  105499:	8b 45 08             	mov    0x8(%ebp),%eax
  10549c:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10549e:	8b 45 10             	mov    0x10(%ebp),%eax
  1054a1:	8d 50 01             	lea    0x1(%eax),%edx
  1054a4:	89 55 10             	mov    %edx,0x10(%ebp)
  1054a7:	0f b6 00             	movzbl (%eax),%eax
  1054aa:	0f b6 d8             	movzbl %al,%ebx
  1054ad:	83 fb 25             	cmp    $0x25,%ebx
  1054b0:	75 d4                	jne    105486 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1054b2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1054b6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1054bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1054c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1054ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054cd:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1054d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1054d3:	8d 50 01             	lea    0x1(%eax),%edx
  1054d6:	89 55 10             	mov    %edx,0x10(%ebp)
  1054d9:	0f b6 00             	movzbl (%eax),%eax
  1054dc:	0f b6 d8             	movzbl %al,%ebx
  1054df:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1054e2:	83 f8 55             	cmp    $0x55,%eax
  1054e5:	0f 87 44 03 00 00    	ja     10582f <vprintfmt+0x3b3>
  1054eb:	8b 04 85 e0 6f 10 00 	mov    0x106fe0(,%eax,4),%eax
  1054f2:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1054f4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1054f8:	eb d6                	jmp    1054d0 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1054fa:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1054fe:	eb d0                	jmp    1054d0 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105500:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105507:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10550a:	89 d0                	mov    %edx,%eax
  10550c:	c1 e0 02             	shl    $0x2,%eax
  10550f:	01 d0                	add    %edx,%eax
  105511:	01 c0                	add    %eax,%eax
  105513:	01 d8                	add    %ebx,%eax
  105515:	83 e8 30             	sub    $0x30,%eax
  105518:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10551b:	8b 45 10             	mov    0x10(%ebp),%eax
  10551e:	0f b6 00             	movzbl (%eax),%eax
  105521:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105524:	83 fb 2f             	cmp    $0x2f,%ebx
  105527:	7e 0b                	jle    105534 <vprintfmt+0xb8>
  105529:	83 fb 39             	cmp    $0x39,%ebx
  10552c:	7f 06                	jg     105534 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10552e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105532:	eb d3                	jmp    105507 <vprintfmt+0x8b>
            goto process_precision;
  105534:	eb 33                	jmp    105569 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105536:	8b 45 14             	mov    0x14(%ebp),%eax
  105539:	8d 50 04             	lea    0x4(%eax),%edx
  10553c:	89 55 14             	mov    %edx,0x14(%ebp)
  10553f:	8b 00                	mov    (%eax),%eax
  105541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105544:	eb 23                	jmp    105569 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105546:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10554a:	79 0c                	jns    105558 <vprintfmt+0xdc>
                width = 0;
  10554c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105553:	e9 78 ff ff ff       	jmp    1054d0 <vprintfmt+0x54>
  105558:	e9 73 ff ff ff       	jmp    1054d0 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  10555d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105564:	e9 67 ff ff ff       	jmp    1054d0 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105569:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10556d:	79 12                	jns    105581 <vprintfmt+0x105>
                width = precision, precision = -1;
  10556f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105572:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105575:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10557c:	e9 4f ff ff ff       	jmp    1054d0 <vprintfmt+0x54>
  105581:	e9 4a ff ff ff       	jmp    1054d0 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105586:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10558a:	e9 41 ff ff ff       	jmp    1054d0 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  10558f:	8b 45 14             	mov    0x14(%ebp),%eax
  105592:	8d 50 04             	lea    0x4(%eax),%edx
  105595:	89 55 14             	mov    %edx,0x14(%ebp)
  105598:	8b 00                	mov    (%eax),%eax
  10559a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10559d:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055a1:	89 04 24             	mov    %eax,(%esp)
  1055a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a7:	ff d0                	call   *%eax
            break;
  1055a9:	e9 ac 02 00 00       	jmp    10585a <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1055ae:	8b 45 14             	mov    0x14(%ebp),%eax
  1055b1:	8d 50 04             	lea    0x4(%eax),%edx
  1055b4:	89 55 14             	mov    %edx,0x14(%ebp)
  1055b7:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1055b9:	85 db                	test   %ebx,%ebx
  1055bb:	79 02                	jns    1055bf <vprintfmt+0x143>
                err = -err;
  1055bd:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1055bf:	83 fb 06             	cmp    $0x6,%ebx
  1055c2:	7f 0b                	jg     1055cf <vprintfmt+0x153>
  1055c4:	8b 34 9d a0 6f 10 00 	mov    0x106fa0(,%ebx,4),%esi
  1055cb:	85 f6                	test   %esi,%esi
  1055cd:	75 23                	jne    1055f2 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1055cf:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1055d3:	c7 44 24 08 cd 6f 10 	movl   $0x106fcd,0x8(%esp)
  1055da:	00 
  1055db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e5:	89 04 24             	mov    %eax,(%esp)
  1055e8:	e8 61 fe ff ff       	call   10544e <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1055ed:	e9 68 02 00 00       	jmp    10585a <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1055f2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1055f6:	c7 44 24 08 d6 6f 10 	movl   $0x106fd6,0x8(%esp)
  1055fd:	00 
  1055fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105601:	89 44 24 04          	mov    %eax,0x4(%esp)
  105605:	8b 45 08             	mov    0x8(%ebp),%eax
  105608:	89 04 24             	mov    %eax,(%esp)
  10560b:	e8 3e fe ff ff       	call   10544e <printfmt>
            }
            break;
  105610:	e9 45 02 00 00       	jmp    10585a <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105615:	8b 45 14             	mov    0x14(%ebp),%eax
  105618:	8d 50 04             	lea    0x4(%eax),%edx
  10561b:	89 55 14             	mov    %edx,0x14(%ebp)
  10561e:	8b 30                	mov    (%eax),%esi
  105620:	85 f6                	test   %esi,%esi
  105622:	75 05                	jne    105629 <vprintfmt+0x1ad>
                p = "(null)";
  105624:	be d9 6f 10 00       	mov    $0x106fd9,%esi
            }
            if (width > 0 && padc != '-') {
  105629:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10562d:	7e 3e                	jle    10566d <vprintfmt+0x1f1>
  10562f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105633:	74 38                	je     10566d <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105635:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10563b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10563f:	89 34 24             	mov    %esi,(%esp)
  105642:	e8 15 03 00 00       	call   10595c <strnlen>
  105647:	29 c3                	sub    %eax,%ebx
  105649:	89 d8                	mov    %ebx,%eax
  10564b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10564e:	eb 17                	jmp    105667 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105650:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105654:	8b 55 0c             	mov    0xc(%ebp),%edx
  105657:	89 54 24 04          	mov    %edx,0x4(%esp)
  10565b:	89 04 24             	mov    %eax,(%esp)
  10565e:	8b 45 08             	mov    0x8(%ebp),%eax
  105661:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105663:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105667:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10566b:	7f e3                	jg     105650 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10566d:	eb 38                	jmp    1056a7 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  10566f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105673:	74 1f                	je     105694 <vprintfmt+0x218>
  105675:	83 fb 1f             	cmp    $0x1f,%ebx
  105678:	7e 05                	jle    10567f <vprintfmt+0x203>
  10567a:	83 fb 7e             	cmp    $0x7e,%ebx
  10567d:	7e 15                	jle    105694 <vprintfmt+0x218>
                    putch('?', putdat);
  10567f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105682:	89 44 24 04          	mov    %eax,0x4(%esp)
  105686:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10568d:	8b 45 08             	mov    0x8(%ebp),%eax
  105690:	ff d0                	call   *%eax
  105692:	eb 0f                	jmp    1056a3 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105694:	8b 45 0c             	mov    0xc(%ebp),%eax
  105697:	89 44 24 04          	mov    %eax,0x4(%esp)
  10569b:	89 1c 24             	mov    %ebx,(%esp)
  10569e:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a1:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1056a3:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056a7:	89 f0                	mov    %esi,%eax
  1056a9:	8d 70 01             	lea    0x1(%eax),%esi
  1056ac:	0f b6 00             	movzbl (%eax),%eax
  1056af:	0f be d8             	movsbl %al,%ebx
  1056b2:	85 db                	test   %ebx,%ebx
  1056b4:	74 10                	je     1056c6 <vprintfmt+0x24a>
  1056b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1056ba:	78 b3                	js     10566f <vprintfmt+0x1f3>
  1056bc:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1056c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1056c4:	79 a9                	jns    10566f <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1056c6:	eb 17                	jmp    1056df <vprintfmt+0x263>
                putch(' ', putdat);
  1056c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056cf:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1056d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d9:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1056db:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1056df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056e3:	7f e3                	jg     1056c8 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  1056e5:	e9 70 01 00 00       	jmp    10585a <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1056ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056f1:	8d 45 14             	lea    0x14(%ebp),%eax
  1056f4:	89 04 24             	mov    %eax,(%esp)
  1056f7:	e8 0b fd ff ff       	call   105407 <getint>
  1056fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056ff:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105708:	85 d2                	test   %edx,%edx
  10570a:	79 26                	jns    105732 <vprintfmt+0x2b6>
                putch('-', putdat);
  10570c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10570f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105713:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10571a:	8b 45 08             	mov    0x8(%ebp),%eax
  10571d:	ff d0                	call   *%eax
                num = -(long long)num;
  10571f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105725:	f7 d8                	neg    %eax
  105727:	83 d2 00             	adc    $0x0,%edx
  10572a:	f7 da                	neg    %edx
  10572c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10572f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105732:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105739:	e9 a8 00 00 00       	jmp    1057e6 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  10573e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105741:	89 44 24 04          	mov    %eax,0x4(%esp)
  105745:	8d 45 14             	lea    0x14(%ebp),%eax
  105748:	89 04 24             	mov    %eax,(%esp)
  10574b:	e8 68 fc ff ff       	call   1053b8 <getuint>
  105750:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105753:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105756:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10575d:	e9 84 00 00 00       	jmp    1057e6 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105762:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105765:	89 44 24 04          	mov    %eax,0x4(%esp)
  105769:	8d 45 14             	lea    0x14(%ebp),%eax
  10576c:	89 04 24             	mov    %eax,(%esp)
  10576f:	e8 44 fc ff ff       	call   1053b8 <getuint>
  105774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105777:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10577a:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105781:	eb 63                	jmp    1057e6 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105783:	8b 45 0c             	mov    0xc(%ebp),%eax
  105786:	89 44 24 04          	mov    %eax,0x4(%esp)
  10578a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105791:	8b 45 08             	mov    0x8(%ebp),%eax
  105794:	ff d0                	call   *%eax
            putch('x', putdat);
  105796:	8b 45 0c             	mov    0xc(%ebp),%eax
  105799:	89 44 24 04          	mov    %eax,0x4(%esp)
  10579d:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1057a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a7:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1057a9:	8b 45 14             	mov    0x14(%ebp),%eax
  1057ac:	8d 50 04             	lea    0x4(%eax),%edx
  1057af:	89 55 14             	mov    %edx,0x14(%ebp)
  1057b2:	8b 00                	mov    (%eax),%eax
  1057b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1057be:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1057c5:	eb 1f                	jmp    1057e6 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1057c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ce:	8d 45 14             	lea    0x14(%ebp),%eax
  1057d1:	89 04 24             	mov    %eax,(%esp)
  1057d4:	e8 df fb ff ff       	call   1053b8 <getuint>
  1057d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1057df:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1057e6:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1057ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057ed:	89 54 24 18          	mov    %edx,0x18(%esp)
  1057f1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1057f4:	89 54 24 14          	mov    %edx,0x14(%esp)
  1057f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1057fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105802:	89 44 24 08          	mov    %eax,0x8(%esp)
  105806:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10580a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10580d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105811:	8b 45 08             	mov    0x8(%ebp),%eax
  105814:	89 04 24             	mov    %eax,(%esp)
  105817:	e8 97 fa ff ff       	call   1052b3 <printnum>
            break;
  10581c:	eb 3c                	jmp    10585a <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10581e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105821:	89 44 24 04          	mov    %eax,0x4(%esp)
  105825:	89 1c 24             	mov    %ebx,(%esp)
  105828:	8b 45 08             	mov    0x8(%ebp),%eax
  10582b:	ff d0                	call   *%eax
            break;
  10582d:	eb 2b                	jmp    10585a <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10582f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105832:	89 44 24 04          	mov    %eax,0x4(%esp)
  105836:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10583d:	8b 45 08             	mov    0x8(%ebp),%eax
  105840:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105842:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105846:	eb 04                	jmp    10584c <vprintfmt+0x3d0>
  105848:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10584c:	8b 45 10             	mov    0x10(%ebp),%eax
  10584f:	83 e8 01             	sub    $0x1,%eax
  105852:	0f b6 00             	movzbl (%eax),%eax
  105855:	3c 25                	cmp    $0x25,%al
  105857:	75 ef                	jne    105848 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105859:	90                   	nop
        }
    }
  10585a:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10585b:	e9 3e fc ff ff       	jmp    10549e <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105860:	83 c4 40             	add    $0x40,%esp
  105863:	5b                   	pop    %ebx
  105864:	5e                   	pop    %esi
  105865:	5d                   	pop    %ebp
  105866:	c3                   	ret    

00105867 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105867:	55                   	push   %ebp
  105868:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10586a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10586d:	8b 40 08             	mov    0x8(%eax),%eax
  105870:	8d 50 01             	lea    0x1(%eax),%edx
  105873:	8b 45 0c             	mov    0xc(%ebp),%eax
  105876:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105879:	8b 45 0c             	mov    0xc(%ebp),%eax
  10587c:	8b 10                	mov    (%eax),%edx
  10587e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105881:	8b 40 04             	mov    0x4(%eax),%eax
  105884:	39 c2                	cmp    %eax,%edx
  105886:	73 12                	jae    10589a <sprintputch+0x33>
        *b->buf ++ = ch;
  105888:	8b 45 0c             	mov    0xc(%ebp),%eax
  10588b:	8b 00                	mov    (%eax),%eax
  10588d:	8d 48 01             	lea    0x1(%eax),%ecx
  105890:	8b 55 0c             	mov    0xc(%ebp),%edx
  105893:	89 0a                	mov    %ecx,(%edx)
  105895:	8b 55 08             	mov    0x8(%ebp),%edx
  105898:	88 10                	mov    %dl,(%eax)
    }
}
  10589a:	5d                   	pop    %ebp
  10589b:	c3                   	ret    

0010589c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10589c:	55                   	push   %ebp
  10589d:	89 e5                	mov    %esp,%ebp
  10589f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1058a2:	8d 45 14             	lea    0x14(%ebp),%eax
  1058a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1058a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058af:	8b 45 10             	mov    0x10(%ebp),%eax
  1058b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c0:	89 04 24             	mov    %eax,(%esp)
  1058c3:	e8 08 00 00 00       	call   1058d0 <vsnprintf>
  1058c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1058cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1058ce:	c9                   	leave  
  1058cf:	c3                   	ret    

001058d0 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1058d0:	55                   	push   %ebp
  1058d1:	89 e5                	mov    %esp,%ebp
  1058d3:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1058d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1058d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1058dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058df:	8d 50 ff             	lea    -0x1(%eax),%edx
  1058e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e5:	01 d0                	add    %edx,%eax
  1058e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1058f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1058f5:	74 0a                	je     105901 <vsnprintf+0x31>
  1058f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1058fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058fd:	39 c2                	cmp    %eax,%edx
  1058ff:	76 07                	jbe    105908 <vsnprintf+0x38>
        return -E_INVAL;
  105901:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105906:	eb 2a                	jmp    105932 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105908:	8b 45 14             	mov    0x14(%ebp),%eax
  10590b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10590f:	8b 45 10             	mov    0x10(%ebp),%eax
  105912:	89 44 24 08          	mov    %eax,0x8(%esp)
  105916:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105919:	89 44 24 04          	mov    %eax,0x4(%esp)
  10591d:	c7 04 24 67 58 10 00 	movl   $0x105867,(%esp)
  105924:	e8 53 fb ff ff       	call   10547c <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10592c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10592f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105932:	c9                   	leave  
  105933:	c3                   	ret    

00105934 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105934:	55                   	push   %ebp
  105935:	89 e5                	mov    %esp,%ebp
  105937:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10593a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105941:	eb 04                	jmp    105947 <strlen+0x13>
        cnt ++;
  105943:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105947:	8b 45 08             	mov    0x8(%ebp),%eax
  10594a:	8d 50 01             	lea    0x1(%eax),%edx
  10594d:	89 55 08             	mov    %edx,0x8(%ebp)
  105950:	0f b6 00             	movzbl (%eax),%eax
  105953:	84 c0                	test   %al,%al
  105955:	75 ec                	jne    105943 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105957:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10595a:	c9                   	leave  
  10595b:	c3                   	ret    

0010595c <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10595c:	55                   	push   %ebp
  10595d:	89 e5                	mov    %esp,%ebp
  10595f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105962:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105969:	eb 04                	jmp    10596f <strnlen+0x13>
        cnt ++;
  10596b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10596f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105972:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105975:	73 10                	jae    105987 <strnlen+0x2b>
  105977:	8b 45 08             	mov    0x8(%ebp),%eax
  10597a:	8d 50 01             	lea    0x1(%eax),%edx
  10597d:	89 55 08             	mov    %edx,0x8(%ebp)
  105980:	0f b6 00             	movzbl (%eax),%eax
  105983:	84 c0                	test   %al,%al
  105985:	75 e4                	jne    10596b <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105987:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10598a:	c9                   	leave  
  10598b:	c3                   	ret    

0010598c <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10598c:	55                   	push   %ebp
  10598d:	89 e5                	mov    %esp,%ebp
  10598f:	57                   	push   %edi
  105990:	56                   	push   %esi
  105991:	83 ec 20             	sub    $0x20,%esp
  105994:	8b 45 08             	mov    0x8(%ebp),%eax
  105997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10599a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10599d:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1059a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1059a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059a6:	89 d1                	mov    %edx,%ecx
  1059a8:	89 c2                	mov    %eax,%edx
  1059aa:	89 ce                	mov    %ecx,%esi
  1059ac:	89 d7                	mov    %edx,%edi
  1059ae:	ac                   	lods   %ds:(%esi),%al
  1059af:	aa                   	stos   %al,%es:(%edi)
  1059b0:	84 c0                	test   %al,%al
  1059b2:	75 fa                	jne    1059ae <strcpy+0x22>
  1059b4:	89 fa                	mov    %edi,%edx
  1059b6:	89 f1                	mov    %esi,%ecx
  1059b8:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1059bb:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1059be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  1059c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1059c4:	83 c4 20             	add    $0x20,%esp
  1059c7:	5e                   	pop    %esi
  1059c8:	5f                   	pop    %edi
  1059c9:	5d                   	pop    %ebp
  1059ca:	c3                   	ret    

001059cb <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1059cb:	55                   	push   %ebp
  1059cc:	89 e5                	mov    %esp,%ebp
  1059ce:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1059d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1059d7:	eb 21                	jmp    1059fa <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1059d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059dc:	0f b6 10             	movzbl (%eax),%edx
  1059df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059e2:	88 10                	mov    %dl,(%eax)
  1059e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1059e7:	0f b6 00             	movzbl (%eax),%eax
  1059ea:	84 c0                	test   %al,%al
  1059ec:	74 04                	je     1059f2 <strncpy+0x27>
            src ++;
  1059ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1059f2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1059f6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1059fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1059fe:	75 d9                	jne    1059d9 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105a00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105a03:	c9                   	leave  
  105a04:	c3                   	ret    

00105a05 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105a05:	55                   	push   %ebp
  105a06:	89 e5                	mov    %esp,%ebp
  105a08:	57                   	push   %edi
  105a09:	56                   	push   %esi
  105a0a:	83 ec 20             	sub    $0x20,%esp
  105a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105a19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a1f:	89 d1                	mov    %edx,%ecx
  105a21:	89 c2                	mov    %eax,%edx
  105a23:	89 ce                	mov    %ecx,%esi
  105a25:	89 d7                	mov    %edx,%edi
  105a27:	ac                   	lods   %ds:(%esi),%al
  105a28:	ae                   	scas   %es:(%edi),%al
  105a29:	75 08                	jne    105a33 <strcmp+0x2e>
  105a2b:	84 c0                	test   %al,%al
  105a2d:	75 f8                	jne    105a27 <strcmp+0x22>
  105a2f:	31 c0                	xor    %eax,%eax
  105a31:	eb 04                	jmp    105a37 <strcmp+0x32>
  105a33:	19 c0                	sbb    %eax,%eax
  105a35:	0c 01                	or     $0x1,%al
  105a37:	89 fa                	mov    %edi,%edx
  105a39:	89 f1                	mov    %esi,%ecx
  105a3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a3e:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105a41:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105a44:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105a47:	83 c4 20             	add    $0x20,%esp
  105a4a:	5e                   	pop    %esi
  105a4b:	5f                   	pop    %edi
  105a4c:	5d                   	pop    %ebp
  105a4d:	c3                   	ret    

00105a4e <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105a4e:	55                   	push   %ebp
  105a4f:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a51:	eb 0c                	jmp    105a5f <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105a53:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105a57:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105a5b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a63:	74 1a                	je     105a7f <strncmp+0x31>
  105a65:	8b 45 08             	mov    0x8(%ebp),%eax
  105a68:	0f b6 00             	movzbl (%eax),%eax
  105a6b:	84 c0                	test   %al,%al
  105a6d:	74 10                	je     105a7f <strncmp+0x31>
  105a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a72:	0f b6 10             	movzbl (%eax),%edx
  105a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a78:	0f b6 00             	movzbl (%eax),%eax
  105a7b:	38 c2                	cmp    %al,%dl
  105a7d:	74 d4                	je     105a53 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a83:	74 18                	je     105a9d <strncmp+0x4f>
  105a85:	8b 45 08             	mov    0x8(%ebp),%eax
  105a88:	0f b6 00             	movzbl (%eax),%eax
  105a8b:	0f b6 d0             	movzbl %al,%edx
  105a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a91:	0f b6 00             	movzbl (%eax),%eax
  105a94:	0f b6 c0             	movzbl %al,%eax
  105a97:	29 c2                	sub    %eax,%edx
  105a99:	89 d0                	mov    %edx,%eax
  105a9b:	eb 05                	jmp    105aa2 <strncmp+0x54>
  105a9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105aa2:	5d                   	pop    %ebp
  105aa3:	c3                   	ret    

00105aa4 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105aa4:	55                   	push   %ebp
  105aa5:	89 e5                	mov    %esp,%ebp
  105aa7:	83 ec 04             	sub    $0x4,%esp
  105aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aad:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105ab0:	eb 14                	jmp    105ac6 <strchr+0x22>
        if (*s == c) {
  105ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab5:	0f b6 00             	movzbl (%eax),%eax
  105ab8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105abb:	75 05                	jne    105ac2 <strchr+0x1e>
            return (char *)s;
  105abd:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac0:	eb 13                	jmp    105ad5 <strchr+0x31>
        }
        s ++;
  105ac2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac9:	0f b6 00             	movzbl (%eax),%eax
  105acc:	84 c0                	test   %al,%al
  105ace:	75 e2                	jne    105ab2 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105ad0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105ad5:	c9                   	leave  
  105ad6:	c3                   	ret    

00105ad7 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105ad7:	55                   	push   %ebp
  105ad8:	89 e5                	mov    %esp,%ebp
  105ada:	83 ec 04             	sub    $0x4,%esp
  105add:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae0:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105ae3:	eb 11                	jmp    105af6 <strfind+0x1f>
        if (*s == c) {
  105ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae8:	0f b6 00             	movzbl (%eax),%eax
  105aeb:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105aee:	75 02                	jne    105af2 <strfind+0x1b>
            break;
  105af0:	eb 0e                	jmp    105b00 <strfind+0x29>
        }
        s ++;
  105af2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105af6:	8b 45 08             	mov    0x8(%ebp),%eax
  105af9:	0f b6 00             	movzbl (%eax),%eax
  105afc:	84 c0                	test   %al,%al
  105afe:	75 e5                	jne    105ae5 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105b00:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b03:	c9                   	leave  
  105b04:	c3                   	ret    

00105b05 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105b05:	55                   	push   %ebp
  105b06:	89 e5                	mov    %esp,%ebp
  105b08:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105b0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105b12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105b19:	eb 04                	jmp    105b1f <strtol+0x1a>
        s ++;
  105b1b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b22:	0f b6 00             	movzbl (%eax),%eax
  105b25:	3c 20                	cmp    $0x20,%al
  105b27:	74 f2                	je     105b1b <strtol+0x16>
  105b29:	8b 45 08             	mov    0x8(%ebp),%eax
  105b2c:	0f b6 00             	movzbl (%eax),%eax
  105b2f:	3c 09                	cmp    $0x9,%al
  105b31:	74 e8                	je     105b1b <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105b33:	8b 45 08             	mov    0x8(%ebp),%eax
  105b36:	0f b6 00             	movzbl (%eax),%eax
  105b39:	3c 2b                	cmp    $0x2b,%al
  105b3b:	75 06                	jne    105b43 <strtol+0x3e>
        s ++;
  105b3d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b41:	eb 15                	jmp    105b58 <strtol+0x53>
    }
    else if (*s == '-') {
  105b43:	8b 45 08             	mov    0x8(%ebp),%eax
  105b46:	0f b6 00             	movzbl (%eax),%eax
  105b49:	3c 2d                	cmp    $0x2d,%al
  105b4b:	75 0b                	jne    105b58 <strtol+0x53>
        s ++, neg = 1;
  105b4d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b51:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105b58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b5c:	74 06                	je     105b64 <strtol+0x5f>
  105b5e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105b62:	75 24                	jne    105b88 <strtol+0x83>
  105b64:	8b 45 08             	mov    0x8(%ebp),%eax
  105b67:	0f b6 00             	movzbl (%eax),%eax
  105b6a:	3c 30                	cmp    $0x30,%al
  105b6c:	75 1a                	jne    105b88 <strtol+0x83>
  105b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b71:	83 c0 01             	add    $0x1,%eax
  105b74:	0f b6 00             	movzbl (%eax),%eax
  105b77:	3c 78                	cmp    $0x78,%al
  105b79:	75 0d                	jne    105b88 <strtol+0x83>
        s += 2, base = 16;
  105b7b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105b7f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105b86:	eb 2a                	jmp    105bb2 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105b88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b8c:	75 17                	jne    105ba5 <strtol+0xa0>
  105b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  105b91:	0f b6 00             	movzbl (%eax),%eax
  105b94:	3c 30                	cmp    $0x30,%al
  105b96:	75 0d                	jne    105ba5 <strtol+0xa0>
        s ++, base = 8;
  105b98:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b9c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105ba3:	eb 0d                	jmp    105bb2 <strtol+0xad>
    }
    else if (base == 0) {
  105ba5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ba9:	75 07                	jne    105bb2 <strtol+0xad>
        base = 10;
  105bab:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb5:	0f b6 00             	movzbl (%eax),%eax
  105bb8:	3c 2f                	cmp    $0x2f,%al
  105bba:	7e 1b                	jle    105bd7 <strtol+0xd2>
  105bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bbf:	0f b6 00             	movzbl (%eax),%eax
  105bc2:	3c 39                	cmp    $0x39,%al
  105bc4:	7f 11                	jg     105bd7 <strtol+0xd2>
            dig = *s - '0';
  105bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc9:	0f b6 00             	movzbl (%eax),%eax
  105bcc:	0f be c0             	movsbl %al,%eax
  105bcf:	83 e8 30             	sub    $0x30,%eax
  105bd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bd5:	eb 48                	jmp    105c1f <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  105bda:	0f b6 00             	movzbl (%eax),%eax
  105bdd:	3c 60                	cmp    $0x60,%al
  105bdf:	7e 1b                	jle    105bfc <strtol+0xf7>
  105be1:	8b 45 08             	mov    0x8(%ebp),%eax
  105be4:	0f b6 00             	movzbl (%eax),%eax
  105be7:	3c 7a                	cmp    $0x7a,%al
  105be9:	7f 11                	jg     105bfc <strtol+0xf7>
            dig = *s - 'a' + 10;
  105beb:	8b 45 08             	mov    0x8(%ebp),%eax
  105bee:	0f b6 00             	movzbl (%eax),%eax
  105bf1:	0f be c0             	movsbl %al,%eax
  105bf4:	83 e8 57             	sub    $0x57,%eax
  105bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bfa:	eb 23                	jmp    105c1f <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  105bff:	0f b6 00             	movzbl (%eax),%eax
  105c02:	3c 40                	cmp    $0x40,%al
  105c04:	7e 3d                	jle    105c43 <strtol+0x13e>
  105c06:	8b 45 08             	mov    0x8(%ebp),%eax
  105c09:	0f b6 00             	movzbl (%eax),%eax
  105c0c:	3c 5a                	cmp    $0x5a,%al
  105c0e:	7f 33                	jg     105c43 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105c10:	8b 45 08             	mov    0x8(%ebp),%eax
  105c13:	0f b6 00             	movzbl (%eax),%eax
  105c16:	0f be c0             	movsbl %al,%eax
  105c19:	83 e8 37             	sub    $0x37,%eax
  105c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c22:	3b 45 10             	cmp    0x10(%ebp),%eax
  105c25:	7c 02                	jl     105c29 <strtol+0x124>
            break;
  105c27:	eb 1a                	jmp    105c43 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105c29:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c30:	0f af 45 10          	imul   0x10(%ebp),%eax
  105c34:	89 c2                	mov    %eax,%edx
  105c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c39:	01 d0                	add    %edx,%eax
  105c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105c3e:	e9 6f ff ff ff       	jmp    105bb2 <strtol+0xad>

    if (endptr) {
  105c43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105c47:	74 08                	je     105c51 <strtol+0x14c>
        *endptr = (char *) s;
  105c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  105c4f:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105c51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105c55:	74 07                	je     105c5e <strtol+0x159>
  105c57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105c5a:	f7 d8                	neg    %eax
  105c5c:	eb 03                	jmp    105c61 <strtol+0x15c>
  105c5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105c61:	c9                   	leave  
  105c62:	c3                   	ret    

00105c63 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105c63:	55                   	push   %ebp
  105c64:	89 e5                	mov    %esp,%ebp
  105c66:	57                   	push   %edi
  105c67:	83 ec 24             	sub    $0x24,%esp
  105c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c6d:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105c70:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105c74:	8b 55 08             	mov    0x8(%ebp),%edx
  105c77:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105c7a:	88 45 f7             	mov    %al,-0x9(%ebp)
  105c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  105c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105c83:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105c86:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105c8a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105c8d:	89 d7                	mov    %edx,%edi
  105c8f:	f3 aa                	rep stos %al,%es:(%edi)
  105c91:	89 fa                	mov    %edi,%edx
  105c93:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105c96:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105c9c:	83 c4 24             	add    $0x24,%esp
  105c9f:	5f                   	pop    %edi
  105ca0:	5d                   	pop    %ebp
  105ca1:	c3                   	ret    

00105ca2 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105ca2:	55                   	push   %ebp
  105ca3:	89 e5                	mov    %esp,%ebp
  105ca5:	57                   	push   %edi
  105ca6:	56                   	push   %esi
  105ca7:	53                   	push   %ebx
  105ca8:	83 ec 30             	sub    $0x30,%esp
  105cab:	8b 45 08             	mov    0x8(%ebp),%eax
  105cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cb4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105cb7:	8b 45 10             	mov    0x10(%ebp),%eax
  105cba:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cc0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105cc3:	73 42                	jae    105d07 <memmove+0x65>
  105cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105cce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105cd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cd4:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105cd7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105cda:	c1 e8 02             	shr    $0x2,%eax
  105cdd:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105cdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ce2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ce5:	89 d7                	mov    %edx,%edi
  105ce7:	89 c6                	mov    %eax,%esi
  105ce9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ceb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105cee:	83 e1 03             	and    $0x3,%ecx
  105cf1:	74 02                	je     105cf5 <memmove+0x53>
  105cf3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105cf5:	89 f0                	mov    %esi,%eax
  105cf7:	89 fa                	mov    %edi,%edx
  105cf9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105cfc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105cff:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105d02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d05:	eb 36                	jmp    105d3d <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105d07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d10:	01 c2                	add    %eax,%edx
  105d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d15:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d1b:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d21:	89 c1                	mov    %eax,%ecx
  105d23:	89 d8                	mov    %ebx,%eax
  105d25:	89 d6                	mov    %edx,%esi
  105d27:	89 c7                	mov    %eax,%edi
  105d29:	fd                   	std    
  105d2a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d2c:	fc                   	cld    
  105d2d:	89 f8                	mov    %edi,%eax
  105d2f:	89 f2                	mov    %esi,%edx
  105d31:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105d34:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105d37:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105d3d:	83 c4 30             	add    $0x30,%esp
  105d40:	5b                   	pop    %ebx
  105d41:	5e                   	pop    %esi
  105d42:	5f                   	pop    %edi
  105d43:	5d                   	pop    %ebp
  105d44:	c3                   	ret    

00105d45 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105d45:	55                   	push   %ebp
  105d46:	89 e5                	mov    %esp,%ebp
  105d48:	57                   	push   %edi
  105d49:	56                   	push   %esi
  105d4a:	83 ec 20             	sub    $0x20,%esp
  105d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d53:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d59:	8b 45 10             	mov    0x10(%ebp),%eax
  105d5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d62:	c1 e8 02             	shr    $0x2,%eax
  105d65:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105d67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d6d:	89 d7                	mov    %edx,%edi
  105d6f:	89 c6                	mov    %eax,%esi
  105d71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d73:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105d76:	83 e1 03             	and    $0x3,%ecx
  105d79:	74 02                	je     105d7d <memcpy+0x38>
  105d7b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d7d:	89 f0                	mov    %esi,%eax
  105d7f:	89 fa                	mov    %edi,%edx
  105d81:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d84:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105d87:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105d8d:	83 c4 20             	add    $0x20,%esp
  105d90:	5e                   	pop    %esi
  105d91:	5f                   	pop    %edi
  105d92:	5d                   	pop    %ebp
  105d93:	c3                   	ret    

00105d94 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105d94:	55                   	push   %ebp
  105d95:	89 e5                	mov    %esp,%ebp
  105d97:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105da3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105da6:	eb 30                	jmp    105dd8 <memcmp+0x44>
        if (*s1 != *s2) {
  105da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105dab:	0f b6 10             	movzbl (%eax),%edx
  105dae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105db1:	0f b6 00             	movzbl (%eax),%eax
  105db4:	38 c2                	cmp    %al,%dl
  105db6:	74 18                	je     105dd0 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105dbb:	0f b6 00             	movzbl (%eax),%eax
  105dbe:	0f b6 d0             	movzbl %al,%edx
  105dc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dc4:	0f b6 00             	movzbl (%eax),%eax
  105dc7:	0f b6 c0             	movzbl %al,%eax
  105dca:	29 c2                	sub    %eax,%edx
  105dcc:	89 d0                	mov    %edx,%eax
  105dce:	eb 1a                	jmp    105dea <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105dd0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105dd4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105dd8:	8b 45 10             	mov    0x10(%ebp),%eax
  105ddb:	8d 50 ff             	lea    -0x1(%eax),%edx
  105dde:	89 55 10             	mov    %edx,0x10(%ebp)
  105de1:	85 c0                	test   %eax,%eax
  105de3:	75 c3                	jne    105da8 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105dea:	c9                   	leave  
  105deb:	c3                   	ret    
