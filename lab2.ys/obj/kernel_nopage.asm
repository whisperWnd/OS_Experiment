
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
  10005d:	e8 a5 5b 00 00       	call   105c07 <memset>

    cons_init();                // init the console
  100062:	e8 7c 15 00 00       	call   1015e3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 a0 5d 10 00 	movl   $0x105da0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 bc 5d 10 00 	movl   $0x105dbc,(%esp)
  10007c:	e8 c7 02 00 00       	call   100348 <cprintf>

    print_kerninfo();
  100081:	e8 f6 07 00 00       	call   10087c <print_kerninfo>

    grade_backtrace();
  100086:	e8 86 00 00 00       	call   100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 71 42 00 00       	call   104301 <pmm_init>

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
  100161:	c7 04 24 c1 5d 10 00 	movl   $0x105dc1,(%esp)
  100168:	e8 db 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100171:	0f b7 d0             	movzwl %ax,%edx
  100174:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100179:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100181:	c7 04 24 cf 5d 10 00 	movl   $0x105dcf,(%esp)
  100188:	e8 bb 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100191:	0f b7 d0             	movzwl %ax,%edx
  100194:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100199:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a1:	c7 04 24 dd 5d 10 00 	movl   $0x105ddd,(%esp)
  1001a8:	e8 9b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b1:	0f b7 d0             	movzwl %ax,%edx
  1001b4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 eb 5d 10 00 	movl   $0x105deb,(%esp)
  1001c8:	e8 7b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d1:	0f b7 d0             	movzwl %ax,%edx
  1001d4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e1:	c7 04 24 f9 5d 10 00 	movl   $0x105df9,(%esp)
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
  100211:	c7 04 24 08 5e 10 00 	movl   $0x105e08,(%esp)
  100218:	e8 2b 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_user();
  10021d:	e8 da ff ff ff       	call   1001fc <lab1_switch_to_user>
    lab1_print_cur_status();
  100222:	e8 0f ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100227:	c7 04 24 28 5e 10 00 	movl   $0x105e28,(%esp)
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
  100252:	c7 04 24 47 5e 10 00 	movl   $0x105e47,(%esp)
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
  10033e:	e8 dd 50 00 00       	call   105420 <vprintfmt>
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
  100548:	c7 00 4c 5e 10 00    	movl   $0x105e4c,(%eax)
    info->eip_line = 0;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	c7 40 08 4c 5e 10 00 	movl   $0x105e4c,0x8(%eax)
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
  10057f:	c7 45 f4 c0 70 10 00 	movl   $0x1070c0,-0xc(%ebp)
    stab_end = __STAB_END__;
  100586:	c7 45 f0 1c 1a 11 00 	movl   $0x111a1c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10058d:	c7 45 ec 1d 1a 11 00 	movl   $0x111a1d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100594:	c7 45 e8 30 44 11 00 	movl   $0x114430,-0x18(%ebp)

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
  1006f3:	e8 83 53 00 00       	call   105a7b <strfind>
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
  100882:	c7 04 24 56 5e 10 00 	movl   $0x105e56,(%esp)
  100889:	e8 ba fa ff ff       	call   100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100895:	00 
  100896:	c7 04 24 6f 5e 10 00 	movl   $0x105e6f,(%esp)
  10089d:	e8 a6 fa ff ff       	call   100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a2:	c7 44 24 04 90 5d 10 	movl   $0x105d90,0x4(%esp)
  1008a9:	00 
  1008aa:	c7 04 24 87 5e 10 00 	movl   $0x105e87,(%esp)
  1008b1:	e8 92 fa ff ff       	call   100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b6:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008bd:	00 
  1008be:	c7 04 24 9f 5e 10 00 	movl   $0x105e9f,(%esp)
  1008c5:	e8 7e fa ff ff       	call   100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008ca:	c7 44 24 04 28 af 11 	movl   $0x11af28,0x4(%esp)
  1008d1:	00 
  1008d2:	c7 04 24 b7 5e 10 00 	movl   $0x105eb7,(%esp)
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
  100904:	c7 04 24 d0 5e 10 00 	movl   $0x105ed0,(%esp)
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
  100938:	c7 04 24 fa 5e 10 00 	movl   $0x105efa,(%esp)
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
  1009a7:	c7 04 24 16 5f 10 00 	movl   $0x105f16,(%esp)
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
  1009f9:	c7 04 24 28 5f 10 00 	movl   $0x105f28,(%esp)
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
  100a26:	c7 04 24 44 5f 10 00 	movl   $0x105f44,(%esp)
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
  100a3c:	c7 04 24 4c 5f 10 00 	movl   $0x105f4c,(%esp)
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
  100ab1:	c7 04 24 d0 5f 10 00 	movl   $0x105fd0,(%esp)
  100ab8:	e8 8b 4f 00 00       	call   105a48 <strchr>
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
  100adb:	c7 04 24 d5 5f 10 00 	movl   $0x105fd5,(%esp)
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
  100b1e:	c7 04 24 d0 5f 10 00 	movl   $0x105fd0,(%esp)
  100b25:	e8 1e 4f 00 00       	call   105a48 <strchr>
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
  100b8a:	e8 1a 4e 00 00       	call   1059a9 <strcmp>
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
  100bd8:	c7 04 24 f3 5f 10 00 	movl   $0x105ff3,(%esp)
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
  100bf1:	c7 04 24 0c 60 10 00 	movl   $0x10600c,(%esp)
  100bf8:	e8 4b f7 ff ff       	call   100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfd:	c7 04 24 34 60 10 00 	movl   $0x106034,(%esp)
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
  100c1a:	c7 04 24 59 60 10 00 	movl   $0x106059,(%esp)
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
  100c89:	c7 04 24 5d 60 10 00 	movl   $0x10605d,(%esp)
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
  100cfb:	c7 04 24 66 60 10 00 	movl   $0x106066,(%esp)
  100d02:	e8 41 f6 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0e:	8b 45 10             	mov    0x10(%ebp),%eax
  100d11:	89 04 24             	mov    %eax,(%esp)
  100d14:	e8 fc f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d19:	c7 04 24 82 60 10 00 	movl   $0x106082,(%esp)
  100d20:	e8 23 f6 ff ff       	call   100348 <cprintf>
    
    cprintf("stack trackback:\n");
  100d25:	c7 04 24 84 60 10 00 	movl   $0x106084,(%esp)
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
  100d63:	c7 04 24 96 60 10 00 	movl   $0x106096,(%esp)
  100d6a:	e8 d9 f5 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d76:	8b 45 10             	mov    0x10(%ebp),%eax
  100d79:	89 04 24             	mov    %eax,(%esp)
  100d7c:	e8 94 f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d81:	c7 04 24 82 60 10 00 	movl   $0x106082,(%esp)
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
  100de2:	c7 04 24 b4 60 10 00 	movl   $0x1060b4,(%esp)
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
  10120c:	e8 35 4a 00 00       	call   105c46 <memmove>
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
  101592:	c7 04 24 cf 60 10 00 	movl   $0x1060cf,(%esp)
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
  101601:	c7 04 24 db 60 10 00 	movl   $0x1060db,(%esp)
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
  101895:	c7 04 24 00 61 10 00 	movl   $0x106100,(%esp)
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
  101a22:	8b 04 85 60 64 10 00 	mov    0x106460(,%eax,4),%eax
  101a29:	eb 18                	jmp    101a43 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a2b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a2f:	7e 0d                	jle    101a3e <trapname+0x2a>
  101a31:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a35:	7f 07                	jg     101a3e <trapname+0x2a>
        return "Hardware Interrupt";
  101a37:	b8 0a 61 10 00       	mov    $0x10610a,%eax
  101a3c:	eb 05                	jmp    101a43 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a3e:	b8 1d 61 10 00       	mov    $0x10611d,%eax
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
  101a68:	c7 04 24 5e 61 10 00 	movl   $0x10615e,(%esp)
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
  101a8d:	c7 04 24 6f 61 10 00 	movl   $0x10616f,(%esp)
  101a94:	e8 af e8 ff ff       	call   100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a99:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101aa0:	0f b7 c0             	movzwl %ax,%eax
  101aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa7:	c7 04 24 82 61 10 00 	movl   $0x106182,(%esp)
  101aae:	e8 95 e8 ff ff       	call   100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab6:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aba:	0f b7 c0             	movzwl %ax,%eax
  101abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac1:	c7 04 24 95 61 10 00 	movl   $0x106195,(%esp)
  101ac8:	e8 7b e8 ff ff       	call   100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101acd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad0:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ad4:	0f b7 c0             	movzwl %ax,%eax
  101ad7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101adb:	c7 04 24 a8 61 10 00 	movl   $0x1061a8,(%esp)
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
  101b03:	c7 04 24 bb 61 10 00 	movl   $0x1061bb,(%esp)
  101b0a:	e8 39 e8 ff ff       	call   100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b12:	8b 40 34             	mov    0x34(%eax),%eax
  101b15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b19:	c7 04 24 cd 61 10 00 	movl   $0x1061cd,(%esp)
  101b20:	e8 23 e8 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b25:	8b 45 08             	mov    0x8(%ebp),%eax
  101b28:	8b 40 38             	mov    0x38(%eax),%eax
  101b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b2f:	c7 04 24 dc 61 10 00 	movl   $0x1061dc,(%esp)
  101b36:	e8 0d e8 ff ff       	call   100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b42:	0f b7 c0             	movzwl %ax,%eax
  101b45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b49:	c7 04 24 eb 61 10 00 	movl   $0x1061eb,(%esp)
  101b50:	e8 f3 e7 ff ff       	call   100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b55:	8b 45 08             	mov    0x8(%ebp),%eax
  101b58:	8b 40 40             	mov    0x40(%eax),%eax
  101b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5f:	c7 04 24 fe 61 10 00 	movl   $0x1061fe,(%esp)
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
  101ba6:	c7 04 24 0d 62 10 00 	movl   $0x10620d,(%esp)
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
  101bd3:	c7 04 24 11 62 10 00 	movl   $0x106211,(%esp)
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
  101bf8:	c7 04 24 1a 62 10 00 	movl   $0x10621a,(%esp)
  101bff:	e8 44 e7 ff ff       	call   100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c04:	8b 45 08             	mov    0x8(%ebp),%eax
  101c07:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c0b:	0f b7 c0             	movzwl %ax,%eax
  101c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c12:	c7 04 24 29 62 10 00 	movl   $0x106229,(%esp)
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
  101c2f:	c7 04 24 3c 62 10 00 	movl   $0x10623c,(%esp)
  101c36:	e8 0d e7 ff ff       	call   100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3e:	8b 40 04             	mov    0x4(%eax),%eax
  101c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c45:	c7 04 24 4b 62 10 00 	movl   $0x10624b,(%esp)
  101c4c:	e8 f7 e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c51:	8b 45 08             	mov    0x8(%ebp),%eax
  101c54:	8b 40 08             	mov    0x8(%eax),%eax
  101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5b:	c7 04 24 5a 62 10 00 	movl   $0x10625a,(%esp)
  101c62:	e8 e1 e6 ff ff       	call   100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c67:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6a:	8b 40 0c             	mov    0xc(%eax),%eax
  101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c71:	c7 04 24 69 62 10 00 	movl   $0x106269,(%esp)
  101c78:	e8 cb e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c80:	8b 40 10             	mov    0x10(%eax),%eax
  101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c87:	c7 04 24 78 62 10 00 	movl   $0x106278,(%esp)
  101c8e:	e8 b5 e6 ff ff       	call   100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	8b 40 14             	mov    0x14(%eax),%eax
  101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9d:	c7 04 24 87 62 10 00 	movl   $0x106287,(%esp)
  101ca4:	e8 9f e6 ff ff       	call   100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cac:	8b 40 18             	mov    0x18(%eax),%eax
  101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb3:	c7 04 24 96 62 10 00 	movl   $0x106296,(%esp)
  101cba:	e8 89 e6 ff ff       	call   100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc2:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc9:	c7 04 24 a5 62 10 00 	movl   $0x1062a5,(%esp)
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
  101d6d:	c7 04 24 b4 62 10 00 	movl   $0x1062b4,(%esp)
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
  101d93:	c7 04 24 c6 62 10 00 	movl   $0x1062c6,(%esp)
  101d9a:	e8 a9 e5 ff ff       	call   100348 <cprintf>
        break;
  101d9f:	eb 55                	jmp    101df6 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101da1:	c7 44 24 08 d5 62 10 	movl   $0x1062d5,0x8(%esp)
  101da8:	00 
  101da9:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  101db0:	00 
  101db1:	c7 04 24 e5 62 10 00 	movl   $0x1062e5,(%esp)
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
  101dd9:	c7 44 24 08 f6 62 10 	movl   $0x1062f6,0x8(%esp)
  101de0:	00 
  101de1:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  101de8:	00 
  101de9:	c7 04 24 e5 62 10 00 	movl   $0x1062e5,(%esp)
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
    list_init(&free_list);  //初始化free_list
    nr_free = 0;  //空闲内存块的数量
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
  102916:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);  //判断n是否>0
  102919:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10291d:	75 24                	jne    102943 <default_init_memmap+0x30>
  10291f:	c7 44 24 0c b0 64 10 	movl   $0x1064b0,0xc(%esp)
  102926:	00 
  102927:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10292e:	00 
  10292f:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102936:	00 
  102937:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10293e:	e8 89 e3 ff ff       	call   100ccc <__panic>
    struct Page *p = base;
  102943:	8b 45 08             	mov    0x8(%ebp),%eax
  102946:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {  //初始化n块物理页
  102949:	e9 de 00 00 00       	jmp    102a2c <default_init_memmap+0x119>
        assert(PageReserved(p));  //检查此页是否为保留页
  10294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102951:	83 c0 04             	add    $0x4,%eax
  102954:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10295b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10295e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102961:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102964:	0f a3 10             	bt     %edx,(%eax)
  102967:	19 c0                	sbb    %eax,%eax
  102969:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10296c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102970:	0f 95 c0             	setne  %al
  102973:	0f b6 c0             	movzbl %al,%eax
  102976:	85 c0                	test   %eax,%eax
  102978:	75 24                	jne    10299e <default_init_memmap+0x8b>
  10297a:	c7 44 24 0c e1 64 10 	movl   $0x1064e1,0xc(%esp)
  102981:	00 
  102982:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102989:	00 
  10298a:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  102991:	00 
  102992:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102999:	e8 2e e3 ff ff       	call   100ccc <__panic>
        p->flags = p->property = 0;  //标志位清0,物理页属性和连续空页个数
  10299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029a1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ab:	8b 50 08             	mov    0x8(%eax),%edx
  1029ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029b1:	89 50 04             	mov    %edx,0x4(%eax)
	SetPageProperty(p);  //设置标志位为1
  1029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029b7:	83 c0 04             	add    $0x4,%eax
  1029ba:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029ca:	0f ab 10             	bts    %edx,(%eax)
        set_page_ref(p, 0);  //清除引用此页的虚拟页的个数
  1029cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029d4:	00 
  1029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d8:	89 04 24             	mov    %eax,(%esp)
  1029db:	e8 f9 fe ff ff       	call   1028d9 <set_page_ref>
	//加入空闲链表
	list_add_before(&free_list, &(p->page_link));
  1029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e3:	83 c0 0c             	add    $0xc,%eax
  1029e6:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
  1029ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1029f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029f3:	8b 00                	mov    (%eax),%eax
  1029f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1029f8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1029fb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1029fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a01:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a04:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a0a:	89 10                	mov    %edx,(%eax)
  102a0c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a0f:	8b 10                	mov    (%eax),%edx
  102a11:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a14:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a1a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a1d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a20:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a23:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a26:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);  //判断n是否>0
    struct Page *p = base;
    for (; p != base + n; p ++) {  //初始化n块物理页
  102a28:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a2f:	89 d0                	mov    %edx,%eax
  102a31:	c1 e0 02             	shl    $0x2,%eax
  102a34:	01 d0                	add    %edx,%eax
  102a36:	c1 e0 02             	shl    $0x2,%eax
  102a39:	89 c2                	mov    %eax,%edx
  102a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3e:	01 d0                	add    %edx,%eax
  102a40:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a43:	0f 85 05 ff ff ff    	jne    10294e <default_init_memmap+0x3b>
	SetPageProperty(p);  //设置标志位为1
        set_page_ref(p, 0);  //清除引用此页的虚拟页的个数
	//加入空闲链表
	list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;  //修改base的连续空闲页总数为n
  102a49:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a4f:	89 50 08             	mov    %edx,0x8(%eax)
    //SetPageProperty(base);
    nr_free += n;  //计算空闲页总数
  102a52:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a5b:	01 d0                	add    %edx,%eax
  102a5d:	a3 18 af 11 00       	mov    %eax,0x11af18
    //list_add(&free_list, &(base->page_link));
}
  102a62:	c9                   	leave  
  102a63:	c3                   	ret    

00102a64 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a64:	55                   	push   %ebp
  102a65:	89 e5                	mov    %esp,%ebp
  102a67:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102a6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a6e:	75 24                	jne    102a94 <default_alloc_pages+0x30>
  102a70:	c7 44 24 0c b0 64 10 	movl   $0x1064b0,0xc(%esp)
  102a77:	00 
  102a78:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102a7f:	00 
  102a80:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  102a87:	00 
  102a88:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102a8f:	e8 38 e2 ff ff       	call   100ccc <__panic>
    if (n > nr_free) {  //需要分配页的个数，<n直接返回
  102a94:	a1 18 af 11 00       	mov    0x11af18,%eax
  102a99:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a9c:	73 0a                	jae    102aa8 <default_alloc_pages+0x44>
        return NULL;
  102a9e:	b8 00 00 00 00       	mov    $0x0,%eax
  102aa3:	e9 3e 01 00 00       	jmp    102be6 <default_alloc_pages+0x182>
    }
    struct Page *page = NULL;
  102aa8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    list_entry_t *le = &free_list;  //链表头
  102aaf:	c7 45 f4 10 af 11 00 	movl   $0x11af10,-0xc(%ebp)
    list_entry_t *len;  //长度
    while((le=list_next(le)) != &free_list) {//遍历整个空闲链表
  102ab6:	e9 0a 01 00 00       	jmp    102bc5 <default_alloc_pages+0x161>
      struct Page *p = le2page(le, page_link); //转换为页结构
  102abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102abe:	83 e8 0c             	sub    $0xc,%eax
  102ac1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(p->property >= n){ //找到合适的空闲页
  102ac4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ac7:	8b 40 08             	mov    0x8(%eax),%eax
  102aca:	3b 45 08             	cmp    0x8(%ebp),%eax
  102acd:	0f 82 f2 00 00 00    	jb     102bc5 <default_alloc_pages+0x161>
        int i;
        for(i=0;i<n;i++){
  102ad3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102ada:	eb 7c                	jmp    102b58 <default_alloc_pages+0xf4>
  102adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102adf:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102ae2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ae5:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le); 
  102ae8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          struct Page *pp = le2page(le, page_link); //转换页结构
  102aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aee:	83 e8 0c             	sub    $0xc,%eax
  102af1:	89 45 e0             	mov    %eax,-0x20(%ebp)
          SetPageReserved(pp); //设置每一页的标志位
  102af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102af7:	83 c0 04             	add    $0x4,%eax
  102afa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  102b01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102b04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b07:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b0a:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp); 
  102b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b10:	83 c0 04             	add    $0x4,%eax
  102b13:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  102b1a:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b1d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102b20:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102b23:	0f b3 10             	btr    %edx,(%eax)
  102b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b29:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b2f:	8b 40 04             	mov    0x4(%eax),%eax
  102b32:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102b35:	8b 12                	mov    (%edx),%edx
  102b37:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102b3a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b3d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102b40:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b43:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b46:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b49:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b4c:	89 10                	mov    %edx,(%eax)
          list_del(le); //将此页从free_list中清除
          le = len;
  102b4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *len;  //长度
    while((le=list_next(le)) != &free_list) {//遍历整个空闲链表
      struct Page *p = le2page(le, page_link); //转换为页结构
      if(p->property >= n){ //找到合适的空闲页
        int i;
        for(i=0;i<n;i++){
  102b54:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b5b:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b5e:	0f 82 78 ff ff ff    	jb     102adc <default_alloc_pages+0x78>
          SetPageReserved(pp); //设置每一页的标志位
          ClearPageProperty(pp); 
          list_del(le); //将此页从free_list中清除
          le = len;
        }
        if(p->property>n){ //如果页块大小大于所需大小，分割页块
  102b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b67:	8b 40 08             	mov    0x8(%eax),%eax
  102b6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b6d:	76 12                	jbe    102b81 <default_alloc_pages+0x11d>
          (le2page(le,page_link))->property = p->property-n;
  102b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b72:	8d 50 f4             	lea    -0xc(%eax),%edx
  102b75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b78:	8b 40 08             	mov    0x8(%eax),%eax
  102b7b:	2b 45 08             	sub    0x8(%ebp),%eax
  102b7e:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
  102b81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b84:	83 c0 04             	add    $0x4,%eax
  102b87:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  102b8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102b91:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b94:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b97:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
  102b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b9d:	83 c0 04             	add    $0x4,%eax
  102ba0:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  102ba7:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102baa:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102bad:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102bb0:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n; //减去已经分配的页块大小
  102bb3:	a1 18 af 11 00       	mov    0x11af18,%eax
  102bb8:	2b 45 08             	sub    0x8(%ebp),%eax
  102bbb:	a3 18 af 11 00       	mov    %eax,0x11af18
        return p;
  102bc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bc3:	eb 21                	jmp    102be6 <default_alloc_pages+0x182>
  102bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc8:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102bcb:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102bce:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;  //链表头
    list_entry_t *len;  //长度
    while((le=list_next(le)) != &free_list) {//遍历整个空闲链表
  102bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bd4:	81 7d f4 10 af 11 00 	cmpl   $0x11af10,-0xc(%ebp)
  102bdb:	0f 85 da fe ff ff    	jne    102abb <default_alloc_pages+0x57>
        SetPageReserved(p);
        nr_free -= n; //减去已经分配的页块大小
        return p;
      }
    }
    return NULL;
  102be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102be6:	c9                   	leave  
  102be7:	c3                   	ret    

00102be8 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102be8:	55                   	push   %ebp
  102be9:	89 e5                	mov    %esp,%ebp
  102beb:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);  
  102bee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bf2:	75 24                	jne    102c18 <default_free_pages+0x30>
  102bf4:	c7 44 24 0c b0 64 10 	movl   $0x1064b0,0xc(%esp)
  102bfb:	00 
  102bfc:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102c03:	00 
  102c04:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  102c0b:	00 
  102c0c:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102c13:	e8 b4 e0 ff ff       	call   100ccc <__panic>
    assert(PageReserved(base));    //检查需要释放的页块是否已经被分配
  102c18:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1b:	83 c0 04             	add    $0x4,%eax
  102c1e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c25:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c2e:	0f a3 10             	bt     %edx,(%eax)
  102c31:	19 c0                	sbb    %eax,%eax
  102c33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c3a:	0f 95 c0             	setne  %al
  102c3d:	0f b6 c0             	movzbl %al,%eax
  102c40:	85 c0                	test   %eax,%eax
  102c42:	75 24                	jne    102c68 <default_free_pages+0x80>
  102c44:	c7 44 24 0c f1 64 10 	movl   $0x1064f1,0xc(%esp)
  102c4b:	00 
  102c4c:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102c53:	00 
  102c54:	c7 44 24 04 a1 00 00 	movl   $0xa1,0x4(%esp)
  102c5b:	00 
  102c5c:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102c63:	e8 64 e0 ff ff       	call   100ccc <__panic>
    list_entry_t *le = &free_list; 
  102c68:	c7 45 f4 10 af 11 00 	movl   $0x11af10,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {    //寻找合适的位置
  102c6f:	eb 13                	jmp    102c84 <default_free_pages+0x9c>
      p = le2page(le, page_link); //获取链表对应的Page
  102c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c74:	83 e8 0c             	sub    $0xc,%eax
  102c77:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){    
  102c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c7d:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c80:	76 02                	jbe    102c84 <default_free_pages+0x9c>
        break;
  102c82:	eb 18                	jmp    102c9c <default_free_pages+0xb4>
  102c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c87:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c8d:	8b 40 04             	mov    0x4(%eax),%eax
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);  
    assert(PageReserved(base));    //检查需要释放的页块是否已经被分配
    list_entry_t *le = &free_list; 
    struct Page * p;
    while((le=list_next(le)) != &free_list) {    //寻找合适的位置
  102c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c93:	81 7d f4 10 af 11 00 	cmpl   $0x11af10,-0xc(%ebp)
  102c9a:	75 d5                	jne    102c71 <default_free_pages+0x89>
      p = le2page(le, page_link); //获取链表对应的Page
      if(p>base){    
        break;
      }
    }
    for(p=base;p<base+n;p++){              
  102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ca2:	eb 4b                	jmp    102cef <default_free_pages+0x107>
      list_add_before(le, &(p->page_link)); //将每一空闲块对应的链表插入空闲链表中
  102ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ca7:	8d 50 0c             	lea    0xc(%eax),%edx
  102caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102cb0:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102cb3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cb6:	8b 00                	mov    (%eax),%eax
  102cb8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102cbb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102cbe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102cc1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cc4:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102cc7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ccd:	89 10                	mov    %edx,(%eax)
  102ccf:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cd2:	8b 10                	mov    (%eax),%edx
  102cd4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cd7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102cda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102cdd:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102ce0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102ce3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102ce6:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102ce9:	89 10                	mov    %edx,(%eax)
      p = le2page(le, page_link); //获取链表对应的Page
      if(p>base){    
        break;
      }
    }
    for(p=base;p<base+n;p++){              
  102ceb:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102cef:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cf2:	89 d0                	mov    %edx,%eax
  102cf4:	c1 e0 02             	shl    $0x2,%eax
  102cf7:	01 d0                	add    %edx,%eax
  102cf9:	c1 e0 02             	shl    $0x2,%eax
  102cfc:	89 c2                	mov    %eax,%edx
  102cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102d01:	01 d0                	add    %edx,%eax
  102d03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d06:	77 9c                	ja     102ca4 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link)); //将每一空闲块对应的链表插入空闲链表中
    }
    base->flags = 0;         //修改标志位
  102d08:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);    
  102d12:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d19:	00 
  102d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d1d:	89 04 24             	mov    %eax,(%esp)
  102d20:	e8 b4 fb ff ff       	call   1028d9 <set_page_ref>
    ClearPageProperty(base);
  102d25:	8b 45 08             	mov    0x8(%ebp),%eax
  102d28:	83 c0 04             	add    $0x4,%eax
  102d2b:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102d32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d35:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d38:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d3b:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d41:	83 c0 04             	add    $0x4,%eax
  102d44:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102d4b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d4e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d51:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102d54:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;      //设置连续大小为n
  102d57:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d5d:	89 50 08             	mov    %edx,0x8(%eax)
    //如果是高位，则向高地址合并
    p = le2page(le,page_link) ;
  102d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d63:	83 e8 0c             	sub    $0xc,%eax
  102d66:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
  102d69:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d6c:	89 d0                	mov    %edx,%eax
  102d6e:	c1 e0 02             	shl    $0x2,%eax
  102d71:	01 d0                	add    %edx,%eax
  102d73:	c1 e0 02             	shl    $0x2,%eax
  102d76:	89 c2                	mov    %eax,%edx
  102d78:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7b:	01 d0                	add    %edx,%eax
  102d7d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d80:	75 1e                	jne    102da0 <default_free_pages+0x1b8>
      base->property += p->property;
  102d82:	8b 45 08             	mov    0x8(%ebp),%eax
  102d85:	8b 50 08             	mov    0x8(%eax),%edx
  102d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d8b:	8b 40 08             	mov    0x8(%eax),%eax
  102d8e:	01 c2                	add    %eax,%edx
  102d90:	8b 45 08             	mov    0x8(%ebp),%eax
  102d93:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
  102d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d99:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
     //如果是低位且在范围内，则向低地址合并
    le = list_prev(&(base->page_link));
  102da0:	8b 45 08             	mov    0x8(%ebp),%eax
  102da3:	83 c0 0c             	add    $0xc,%eax
  102da6:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102da9:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dac:	8b 00                	mov    (%eax),%eax
  102dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
  102db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db4:	83 e8 0c             	sub    $0xc,%eax
  102db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){ //满足条件，未分配则合并
  102dba:	81 7d f4 10 af 11 00 	cmpl   $0x11af10,-0xc(%ebp)
  102dc1:	74 57                	je     102e1a <default_free_pages+0x232>
  102dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc6:	83 e8 14             	sub    $0x14,%eax
  102dc9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102dcc:	75 4c                	jne    102e1a <default_free_pages+0x232>
      while(le!=&free_list){
  102dce:	eb 41                	jmp    102e11 <default_free_pages+0x229>
        if(p->property){ //连续
  102dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dd3:	8b 40 08             	mov    0x8(%eax),%eax
  102dd6:	85 c0                	test   %eax,%eax
  102dd8:	74 20                	je     102dfa <default_free_pages+0x212>
          p->property += base->property;
  102dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ddd:	8b 50 08             	mov    0x8(%eax),%edx
  102de0:	8b 45 08             	mov    0x8(%ebp),%eax
  102de3:	8b 40 08             	mov    0x8(%eax),%eax
  102de6:	01 c2                	add    %eax,%edx
  102de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102deb:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
  102dee:	8b 45 08             	mov    0x8(%ebp),%eax
  102df1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
  102df8:	eb 20                	jmp    102e1a <default_free_pages+0x232>
  102dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dfd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102e00:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e03:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
  102e05:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
  102e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e0b:	83 e8 0c             	sub    $0xc,%eax
  102e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
     //如果是低位且在范围内，则向低地址合并
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){ //满足条件，未分配则合并
      while(le!=&free_list){
  102e11:	81 7d f4 10 af 11 00 	cmpl   $0x11af10,-0xc(%ebp)
  102e18:	75 b6                	jne    102dd0 <default_free_pages+0x1e8>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
  102e1a:	8b 15 18 af 11 00    	mov    0x11af18,%edx
  102e20:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e23:	01 d0                	add    %edx,%eax
  102e25:	a3 18 af 11 00       	mov    %eax,0x11af18
    return ;
  102e2a:	90                   	nop
}
  102e2b:	c9                   	leave  
  102e2c:	c3                   	ret    

00102e2d <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e2d:	55                   	push   %ebp
  102e2e:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e30:	a1 18 af 11 00       	mov    0x11af18,%eax
}
  102e35:	5d                   	pop    %ebp
  102e36:	c3                   	ret    

00102e37 <basic_check>:

static void
basic_check(void) {
  102e37:	55                   	push   %ebp
  102e38:	89 e5                	mov    %esp,%ebp
  102e3a:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e57:	e8 ce 0e 00 00       	call   103d2a <alloc_pages>
  102e5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e63:	75 24                	jne    102e89 <basic_check+0x52>
  102e65:	c7 44 24 0c 04 65 10 	movl   $0x106504,0xc(%esp)
  102e6c:	00 
  102e6d:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102e74:	00 
  102e75:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  102e7c:	00 
  102e7d:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102e84:	e8 43 de ff ff       	call   100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e90:	e8 95 0e 00 00       	call   103d2a <alloc_pages>
  102e95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e9c:	75 24                	jne    102ec2 <basic_check+0x8b>
  102e9e:	c7 44 24 0c 20 65 10 	movl   $0x106520,0xc(%esp)
  102ea5:	00 
  102ea6:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102ead:	00 
  102eae:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  102eb5:	00 
  102eb6:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102ebd:	e8 0a de ff ff       	call   100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
  102ec2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ec9:	e8 5c 0e 00 00       	call   103d2a <alloc_pages>
  102ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ed1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102ed5:	75 24                	jne    102efb <basic_check+0xc4>
  102ed7:	c7 44 24 0c 3c 65 10 	movl   $0x10653c,0xc(%esp)
  102ede:	00 
  102edf:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102ee6:	00 
  102ee7:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  102eee:	00 
  102eef:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102ef6:	e8 d1 dd ff ff       	call   100ccc <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102efe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102f01:	74 10                	je     102f13 <basic_check+0xdc>
  102f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f06:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f09:	74 08                	je     102f13 <basic_check+0xdc>
  102f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f0e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f11:	75 24                	jne    102f37 <basic_check+0x100>
  102f13:	c7 44 24 0c 58 65 10 	movl   $0x106558,0xc(%esp)
  102f1a:	00 
  102f1b:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102f22:	00 
  102f23:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  102f2a:	00 
  102f2b:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102f32:	e8 95 dd ff ff       	call   100ccc <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f3a:	89 04 24             	mov    %eax,(%esp)
  102f3d:	e8 8d f9 ff ff       	call   1028cf <page_ref>
  102f42:	85 c0                	test   %eax,%eax
  102f44:	75 1e                	jne    102f64 <basic_check+0x12d>
  102f46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f49:	89 04 24             	mov    %eax,(%esp)
  102f4c:	e8 7e f9 ff ff       	call   1028cf <page_ref>
  102f51:	85 c0                	test   %eax,%eax
  102f53:	75 0f                	jne    102f64 <basic_check+0x12d>
  102f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f58:	89 04 24             	mov    %eax,(%esp)
  102f5b:	e8 6f f9 ff ff       	call   1028cf <page_ref>
  102f60:	85 c0                	test   %eax,%eax
  102f62:	74 24                	je     102f88 <basic_check+0x151>
  102f64:	c7 44 24 0c 7c 65 10 	movl   $0x10657c,0xc(%esp)
  102f6b:	00 
  102f6c:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102f73:	00 
  102f74:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  102f7b:	00 
  102f7c:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102f83:	e8 44 dd ff ff       	call   100ccc <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f8b:	89 04 24             	mov    %eax,(%esp)
  102f8e:	e8 26 f9 ff ff       	call   1028b9 <page2pa>
  102f93:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  102f99:	c1 e2 0c             	shl    $0xc,%edx
  102f9c:	39 d0                	cmp    %edx,%eax
  102f9e:	72 24                	jb     102fc4 <basic_check+0x18d>
  102fa0:	c7 44 24 0c b8 65 10 	movl   $0x1065b8,0xc(%esp)
  102fa7:	00 
  102fa8:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102faf:	00 
  102fb0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  102fb7:	00 
  102fb8:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102fbf:	e8 08 dd ff ff       	call   100ccc <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fc7:	89 04 24             	mov    %eax,(%esp)
  102fca:	e8 ea f8 ff ff       	call   1028b9 <page2pa>
  102fcf:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  102fd5:	c1 e2 0c             	shl    $0xc,%edx
  102fd8:	39 d0                	cmp    %edx,%eax
  102fda:	72 24                	jb     103000 <basic_check+0x1c9>
  102fdc:	c7 44 24 0c d5 65 10 	movl   $0x1065d5,0xc(%esp)
  102fe3:	00 
  102fe4:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  102feb:	00 
  102fec:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102ff3:	00 
  102ff4:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  102ffb:	e8 cc dc ff ff       	call   100ccc <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103003:	89 04 24             	mov    %eax,(%esp)
  103006:	e8 ae f8 ff ff       	call   1028b9 <page2pa>
  10300b:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  103011:	c1 e2 0c             	shl    $0xc,%edx
  103014:	39 d0                	cmp    %edx,%eax
  103016:	72 24                	jb     10303c <basic_check+0x205>
  103018:	c7 44 24 0c f2 65 10 	movl   $0x1065f2,0xc(%esp)
  10301f:	00 
  103020:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103027:	00 
  103028:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  10302f:	00 
  103030:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103037:	e8 90 dc ff ff       	call   100ccc <__panic>

    list_entry_t free_list_store = free_list;
  10303c:	a1 10 af 11 00       	mov    0x11af10,%eax
  103041:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  103047:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10304a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10304d:	c7 45 e0 10 af 11 00 	movl   $0x11af10,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103054:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103057:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10305a:	89 50 04             	mov    %edx,0x4(%eax)
  10305d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103060:	8b 50 04             	mov    0x4(%eax),%edx
  103063:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103066:	89 10                	mov    %edx,(%eax)
  103068:	c7 45 dc 10 af 11 00 	movl   $0x11af10,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10306f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103072:	8b 40 04             	mov    0x4(%eax),%eax
  103075:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103078:	0f 94 c0             	sete   %al
  10307b:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10307e:	85 c0                	test   %eax,%eax
  103080:	75 24                	jne    1030a6 <basic_check+0x26f>
  103082:	c7 44 24 0c 0f 66 10 	movl   $0x10660f,0xc(%esp)
  103089:	00 
  10308a:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103091:	00 
  103092:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  103099:	00 
  10309a:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1030a1:	e8 26 dc ff ff       	call   100ccc <__panic>

    unsigned int nr_free_store = nr_free;
  1030a6:	a1 18 af 11 00       	mov    0x11af18,%eax
  1030ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1030ae:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  1030b5:	00 00 00 

    assert(alloc_page() == NULL);
  1030b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030bf:	e8 66 0c 00 00       	call   103d2a <alloc_pages>
  1030c4:	85 c0                	test   %eax,%eax
  1030c6:	74 24                	je     1030ec <basic_check+0x2b5>
  1030c8:	c7 44 24 0c 26 66 10 	movl   $0x106626,0xc(%esp)
  1030cf:	00 
  1030d0:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1030d7:	00 
  1030d8:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  1030df:	00 
  1030e0:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1030e7:	e8 e0 db ff ff       	call   100ccc <__panic>

    free_page(p0);
  1030ec:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030f3:	00 
  1030f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030f7:	89 04 24             	mov    %eax,(%esp)
  1030fa:	e8 63 0c 00 00       	call   103d62 <free_pages>
    free_page(p1);
  1030ff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103106:	00 
  103107:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10310a:	89 04 24             	mov    %eax,(%esp)
  10310d:	e8 50 0c 00 00       	call   103d62 <free_pages>
    free_page(p2);
  103112:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103119:	00 
  10311a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10311d:	89 04 24             	mov    %eax,(%esp)
  103120:	e8 3d 0c 00 00       	call   103d62 <free_pages>
    assert(nr_free == 3);
  103125:	a1 18 af 11 00       	mov    0x11af18,%eax
  10312a:	83 f8 03             	cmp    $0x3,%eax
  10312d:	74 24                	je     103153 <basic_check+0x31c>
  10312f:	c7 44 24 0c 3b 66 10 	movl   $0x10663b,0xc(%esp)
  103136:	00 
  103137:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10313e:	00 
  10313f:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103146:	00 
  103147:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10314e:	e8 79 db ff ff       	call   100ccc <__panic>

    assert((p0 = alloc_page()) != NULL);
  103153:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10315a:	e8 cb 0b 00 00       	call   103d2a <alloc_pages>
  10315f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103162:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103166:	75 24                	jne    10318c <basic_check+0x355>
  103168:	c7 44 24 0c 04 65 10 	movl   $0x106504,0xc(%esp)
  10316f:	00 
  103170:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103177:	00 
  103178:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  10317f:	00 
  103180:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103187:	e8 40 db ff ff       	call   100ccc <__panic>
    assert((p1 = alloc_page()) != NULL);
  10318c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103193:	e8 92 0b 00 00       	call   103d2a <alloc_pages>
  103198:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10319b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10319f:	75 24                	jne    1031c5 <basic_check+0x38e>
  1031a1:	c7 44 24 0c 20 65 10 	movl   $0x106520,0xc(%esp)
  1031a8:	00 
  1031a9:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1031b0:	00 
  1031b1:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  1031b8:	00 
  1031b9:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1031c0:	e8 07 db ff ff       	call   100ccc <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031cc:	e8 59 0b 00 00       	call   103d2a <alloc_pages>
  1031d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031d8:	75 24                	jne    1031fe <basic_check+0x3c7>
  1031da:	c7 44 24 0c 3c 65 10 	movl   $0x10653c,0xc(%esp)
  1031e1:	00 
  1031e2:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1031e9:	00 
  1031ea:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  1031f1:	00 
  1031f2:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1031f9:	e8 ce da ff ff       	call   100ccc <__panic>

    assert(alloc_page() == NULL);
  1031fe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103205:	e8 20 0b 00 00       	call   103d2a <alloc_pages>
  10320a:	85 c0                	test   %eax,%eax
  10320c:	74 24                	je     103232 <basic_check+0x3fb>
  10320e:	c7 44 24 0c 26 66 10 	movl   $0x106626,0xc(%esp)
  103215:	00 
  103216:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10321d:	00 
  10321e:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  103225:	00 
  103226:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10322d:	e8 9a da ff ff       	call   100ccc <__panic>

    free_page(p0);
  103232:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103239:	00 
  10323a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10323d:	89 04 24             	mov    %eax,(%esp)
  103240:	e8 1d 0b 00 00       	call   103d62 <free_pages>
  103245:	c7 45 d8 10 af 11 00 	movl   $0x11af10,-0x28(%ebp)
  10324c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10324f:	8b 40 04             	mov    0x4(%eax),%eax
  103252:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103255:	0f 94 c0             	sete   %al
  103258:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  10325b:	85 c0                	test   %eax,%eax
  10325d:	74 24                	je     103283 <basic_check+0x44c>
  10325f:	c7 44 24 0c 48 66 10 	movl   $0x106648,0xc(%esp)
  103266:	00 
  103267:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10326e:	00 
  10326f:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  103276:	00 
  103277:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10327e:	e8 49 da ff ff       	call   100ccc <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103283:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10328a:	e8 9b 0a 00 00       	call   103d2a <alloc_pages>
  10328f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103295:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103298:	74 24                	je     1032be <basic_check+0x487>
  10329a:	c7 44 24 0c 60 66 10 	movl   $0x106660,0xc(%esp)
  1032a1:	00 
  1032a2:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1032a9:	00 
  1032aa:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  1032b1:	00 
  1032b2:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1032b9:	e8 0e da ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  1032be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032c5:	e8 60 0a 00 00       	call   103d2a <alloc_pages>
  1032ca:	85 c0                	test   %eax,%eax
  1032cc:	74 24                	je     1032f2 <basic_check+0x4bb>
  1032ce:	c7 44 24 0c 26 66 10 	movl   $0x106626,0xc(%esp)
  1032d5:	00 
  1032d6:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1032dd:	00 
  1032de:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1032e5:	00 
  1032e6:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1032ed:	e8 da d9 ff ff       	call   100ccc <__panic>

    assert(nr_free == 0);
  1032f2:	a1 18 af 11 00       	mov    0x11af18,%eax
  1032f7:	85 c0                	test   %eax,%eax
  1032f9:	74 24                	je     10331f <basic_check+0x4e8>
  1032fb:	c7 44 24 0c 79 66 10 	movl   $0x106679,0xc(%esp)
  103302:	00 
  103303:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10330a:	00 
  10330b:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103312:	00 
  103313:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10331a:	e8 ad d9 ff ff       	call   100ccc <__panic>
    free_list = free_list_store;
  10331f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103322:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103325:	a3 10 af 11 00       	mov    %eax,0x11af10
  10332a:	89 15 14 af 11 00    	mov    %edx,0x11af14
    nr_free = nr_free_store;
  103330:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103333:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_page(p);
  103338:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10333f:	00 
  103340:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103343:	89 04 24             	mov    %eax,(%esp)
  103346:	e8 17 0a 00 00       	call   103d62 <free_pages>
    free_page(p1);
  10334b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103352:	00 
  103353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103356:	89 04 24             	mov    %eax,(%esp)
  103359:	e8 04 0a 00 00       	call   103d62 <free_pages>
    free_page(p2);
  10335e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103365:	00 
  103366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103369:	89 04 24             	mov    %eax,(%esp)
  10336c:	e8 f1 09 00 00       	call   103d62 <free_pages>
}
  103371:	c9                   	leave  
  103372:	c3                   	ret    

00103373 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103373:	55                   	push   %ebp
  103374:	89 e5                	mov    %esp,%ebp
  103376:	53                   	push   %ebx
  103377:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  10337d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103384:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10338b:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103392:	eb 6b                	jmp    1033ff <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103394:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103397:	83 e8 0c             	sub    $0xc,%eax
  10339a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10339d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033a0:	83 c0 04             	add    $0x4,%eax
  1033a3:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1033aa:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033ad:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1033b0:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1033b3:	0f a3 10             	bt     %edx,(%eax)
  1033b6:	19 c0                	sbb    %eax,%eax
  1033b8:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1033bb:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1033bf:	0f 95 c0             	setne  %al
  1033c2:	0f b6 c0             	movzbl %al,%eax
  1033c5:	85 c0                	test   %eax,%eax
  1033c7:	75 24                	jne    1033ed <default_check+0x7a>
  1033c9:	c7 44 24 0c 86 66 10 	movl   $0x106686,0xc(%esp)
  1033d0:	00 
  1033d1:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1033d8:	00 
  1033d9:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  1033e0:	00 
  1033e1:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1033e8:	e8 df d8 ff ff       	call   100ccc <__panic>
        count ++, total += p->property;
  1033ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1033f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033f4:	8b 50 08             	mov    0x8(%eax),%edx
  1033f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033fa:	01 d0                	add    %edx,%eax
  1033fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103402:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103405:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103408:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10340b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10340e:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  103415:	0f 85 79 ff ff ff    	jne    103394 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10341b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10341e:	e8 71 09 00 00       	call   103d94 <nr_free_pages>
  103423:	39 c3                	cmp    %eax,%ebx
  103425:	74 24                	je     10344b <default_check+0xd8>
  103427:	c7 44 24 0c 96 66 10 	movl   $0x106696,0xc(%esp)
  10342e:	00 
  10342f:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103436:	00 
  103437:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  10343e:	00 
  10343f:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103446:	e8 81 d8 ff ff       	call   100ccc <__panic>

    basic_check();
  10344b:	e8 e7 f9 ff ff       	call   102e37 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103450:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103457:	e8 ce 08 00 00       	call   103d2a <alloc_pages>
  10345c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10345f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103463:	75 24                	jne    103489 <default_check+0x116>
  103465:	c7 44 24 0c af 66 10 	movl   $0x1066af,0xc(%esp)
  10346c:	00 
  10346d:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103474:	00 
  103475:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  10347c:	00 
  10347d:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103484:	e8 43 d8 ff ff       	call   100ccc <__panic>
    assert(!PageProperty(p0));
  103489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10348c:	83 c0 04             	add    $0x4,%eax
  10348f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103496:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103499:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10349c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10349f:	0f a3 10             	bt     %edx,(%eax)
  1034a2:	19 c0                	sbb    %eax,%eax
  1034a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1034a7:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1034ab:	0f 95 c0             	setne  %al
  1034ae:	0f b6 c0             	movzbl %al,%eax
  1034b1:	85 c0                	test   %eax,%eax
  1034b3:	74 24                	je     1034d9 <default_check+0x166>
  1034b5:	c7 44 24 0c ba 66 10 	movl   $0x1066ba,0xc(%esp)
  1034bc:	00 
  1034bd:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1034c4:	00 
  1034c5:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  1034cc:	00 
  1034cd:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1034d4:	e8 f3 d7 ff ff       	call   100ccc <__panic>

    list_entry_t free_list_store = free_list;
  1034d9:	a1 10 af 11 00       	mov    0x11af10,%eax
  1034de:	8b 15 14 af 11 00    	mov    0x11af14,%edx
  1034e4:	89 45 80             	mov    %eax,-0x80(%ebp)
  1034e7:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1034ea:	c7 45 b4 10 af 11 00 	movl   $0x11af10,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1034f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034f4:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1034f7:	89 50 04             	mov    %edx,0x4(%eax)
  1034fa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034fd:	8b 50 04             	mov    0x4(%eax),%edx
  103500:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103503:	89 10                	mov    %edx,(%eax)
  103505:	c7 45 b0 10 af 11 00 	movl   $0x11af10,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10350c:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10350f:	8b 40 04             	mov    0x4(%eax),%eax
  103512:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103515:	0f 94 c0             	sete   %al
  103518:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10351b:	85 c0                	test   %eax,%eax
  10351d:	75 24                	jne    103543 <default_check+0x1d0>
  10351f:	c7 44 24 0c 0f 66 10 	movl   $0x10660f,0xc(%esp)
  103526:	00 
  103527:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10352e:	00 
  10352f:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  103536:	00 
  103537:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10353e:	e8 89 d7 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  103543:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10354a:	e8 db 07 00 00       	call   103d2a <alloc_pages>
  10354f:	85 c0                	test   %eax,%eax
  103551:	74 24                	je     103577 <default_check+0x204>
  103553:	c7 44 24 0c 26 66 10 	movl   $0x106626,0xc(%esp)
  10355a:	00 
  10355b:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103562:	00 
  103563:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  10356a:	00 
  10356b:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103572:	e8 55 d7 ff ff       	call   100ccc <__panic>

    unsigned int nr_free_store = nr_free;
  103577:	a1 18 af 11 00       	mov    0x11af18,%eax
  10357c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10357f:	c7 05 18 af 11 00 00 	movl   $0x0,0x11af18
  103586:	00 00 00 

    free_pages(p0 + 2, 3);
  103589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10358c:	83 c0 28             	add    $0x28,%eax
  10358f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103596:	00 
  103597:	89 04 24             	mov    %eax,(%esp)
  10359a:	e8 c3 07 00 00       	call   103d62 <free_pages>
    assert(alloc_pages(4) == NULL);
  10359f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1035a6:	e8 7f 07 00 00       	call   103d2a <alloc_pages>
  1035ab:	85 c0                	test   %eax,%eax
  1035ad:	74 24                	je     1035d3 <default_check+0x260>
  1035af:	c7 44 24 0c cc 66 10 	movl   $0x1066cc,0xc(%esp)
  1035b6:	00 
  1035b7:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1035be:	00 
  1035bf:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  1035c6:	00 
  1035c7:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1035ce:	e8 f9 d6 ff ff       	call   100ccc <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1035d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035d6:	83 c0 28             	add    $0x28,%eax
  1035d9:	83 c0 04             	add    $0x4,%eax
  1035dc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1035e3:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035e6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1035e9:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1035ec:	0f a3 10             	bt     %edx,(%eax)
  1035ef:	19 c0                	sbb    %eax,%eax
  1035f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1035f4:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1035f8:	0f 95 c0             	setne  %al
  1035fb:	0f b6 c0             	movzbl %al,%eax
  1035fe:	85 c0                	test   %eax,%eax
  103600:	74 0e                	je     103610 <default_check+0x29d>
  103602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103605:	83 c0 28             	add    $0x28,%eax
  103608:	8b 40 08             	mov    0x8(%eax),%eax
  10360b:	83 f8 03             	cmp    $0x3,%eax
  10360e:	74 24                	je     103634 <default_check+0x2c1>
  103610:	c7 44 24 0c e4 66 10 	movl   $0x1066e4,0xc(%esp)
  103617:	00 
  103618:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10361f:	00 
  103620:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  103627:	00 
  103628:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10362f:	e8 98 d6 ff ff       	call   100ccc <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103634:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10363b:	e8 ea 06 00 00       	call   103d2a <alloc_pages>
  103640:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103643:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103647:	75 24                	jne    10366d <default_check+0x2fa>
  103649:	c7 44 24 0c 10 67 10 	movl   $0x106710,0xc(%esp)
  103650:	00 
  103651:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103658:	00 
  103659:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  103660:	00 
  103661:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103668:	e8 5f d6 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  10366d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103674:	e8 b1 06 00 00       	call   103d2a <alloc_pages>
  103679:	85 c0                	test   %eax,%eax
  10367b:	74 24                	je     1036a1 <default_check+0x32e>
  10367d:	c7 44 24 0c 26 66 10 	movl   $0x106626,0xc(%esp)
  103684:	00 
  103685:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10368c:	00 
  10368d:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  103694:	00 
  103695:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10369c:	e8 2b d6 ff ff       	call   100ccc <__panic>
    assert(p0 + 2 == p1);
  1036a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036a4:	83 c0 28             	add    $0x28,%eax
  1036a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1036aa:	74 24                	je     1036d0 <default_check+0x35d>
  1036ac:	c7 44 24 0c 2e 67 10 	movl   $0x10672e,0xc(%esp)
  1036b3:	00 
  1036b4:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1036bb:	00 
  1036bc:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  1036c3:	00 
  1036c4:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1036cb:	e8 fc d5 ff ff       	call   100ccc <__panic>

    p2 = p0 + 1;
  1036d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036d3:	83 c0 14             	add    $0x14,%eax
  1036d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1036d9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036e0:	00 
  1036e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036e4:	89 04 24             	mov    %eax,(%esp)
  1036e7:	e8 76 06 00 00       	call   103d62 <free_pages>
    free_pages(p1, 3);
  1036ec:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036f3:	00 
  1036f4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036f7:	89 04 24             	mov    %eax,(%esp)
  1036fa:	e8 63 06 00 00       	call   103d62 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1036ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103702:	83 c0 04             	add    $0x4,%eax
  103705:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10370c:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10370f:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103712:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103715:	0f a3 10             	bt     %edx,(%eax)
  103718:	19 c0                	sbb    %eax,%eax
  10371a:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10371d:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103721:	0f 95 c0             	setne  %al
  103724:	0f b6 c0             	movzbl %al,%eax
  103727:	85 c0                	test   %eax,%eax
  103729:	74 0b                	je     103736 <default_check+0x3c3>
  10372b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10372e:	8b 40 08             	mov    0x8(%eax),%eax
  103731:	83 f8 01             	cmp    $0x1,%eax
  103734:	74 24                	je     10375a <default_check+0x3e7>
  103736:	c7 44 24 0c 3c 67 10 	movl   $0x10673c,0xc(%esp)
  10373d:	00 
  10373e:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103745:	00 
  103746:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  10374d:	00 
  10374e:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103755:	e8 72 d5 ff ff       	call   100ccc <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10375a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10375d:	83 c0 04             	add    $0x4,%eax
  103760:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103767:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10376a:	8b 45 90             	mov    -0x70(%ebp),%eax
  10376d:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103770:	0f a3 10             	bt     %edx,(%eax)
  103773:	19 c0                	sbb    %eax,%eax
  103775:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103778:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10377c:	0f 95 c0             	setne  %al
  10377f:	0f b6 c0             	movzbl %al,%eax
  103782:	85 c0                	test   %eax,%eax
  103784:	74 0b                	je     103791 <default_check+0x41e>
  103786:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103789:	8b 40 08             	mov    0x8(%eax),%eax
  10378c:	83 f8 03             	cmp    $0x3,%eax
  10378f:	74 24                	je     1037b5 <default_check+0x442>
  103791:	c7 44 24 0c 64 67 10 	movl   $0x106764,0xc(%esp)
  103798:	00 
  103799:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1037a0:	00 
  1037a1:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  1037a8:	00 
  1037a9:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1037b0:	e8 17 d5 ff ff       	call   100ccc <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1037b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037bc:	e8 69 05 00 00       	call   103d2a <alloc_pages>
  1037c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037c7:	83 e8 14             	sub    $0x14,%eax
  1037ca:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037cd:	74 24                	je     1037f3 <default_check+0x480>
  1037cf:	c7 44 24 0c 8a 67 10 	movl   $0x10678a,0xc(%esp)
  1037d6:	00 
  1037d7:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1037de:	00 
  1037df:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  1037e6:	00 
  1037e7:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1037ee:	e8 d9 d4 ff ff       	call   100ccc <__panic>
    free_page(p0);
  1037f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037fa:	00 
  1037fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037fe:	89 04 24             	mov    %eax,(%esp)
  103801:	e8 5c 05 00 00       	call   103d62 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103806:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10380d:	e8 18 05 00 00       	call   103d2a <alloc_pages>
  103812:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103815:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103818:	83 c0 14             	add    $0x14,%eax
  10381b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10381e:	74 24                	je     103844 <default_check+0x4d1>
  103820:	c7 44 24 0c a8 67 10 	movl   $0x1067a8,0xc(%esp)
  103827:	00 
  103828:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10382f:	00 
  103830:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  103837:	00 
  103838:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10383f:	e8 88 d4 ff ff       	call   100ccc <__panic>

    free_pages(p0, 2);
  103844:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10384b:	00 
  10384c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10384f:	89 04 24             	mov    %eax,(%esp)
  103852:	e8 0b 05 00 00       	call   103d62 <free_pages>
    free_page(p2);
  103857:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10385e:	00 
  10385f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103862:	89 04 24             	mov    %eax,(%esp)
  103865:	e8 f8 04 00 00       	call   103d62 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10386a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103871:	e8 b4 04 00 00       	call   103d2a <alloc_pages>
  103876:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103879:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10387d:	75 24                	jne    1038a3 <default_check+0x530>
  10387f:	c7 44 24 0c c8 67 10 	movl   $0x1067c8,0xc(%esp)
  103886:	00 
  103887:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  10388e:	00 
  10388f:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  103896:	00 
  103897:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  10389e:	e8 29 d4 ff ff       	call   100ccc <__panic>
    assert(alloc_page() == NULL);
  1038a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038aa:	e8 7b 04 00 00       	call   103d2a <alloc_pages>
  1038af:	85 c0                	test   %eax,%eax
  1038b1:	74 24                	je     1038d7 <default_check+0x564>
  1038b3:	c7 44 24 0c 26 66 10 	movl   $0x106626,0xc(%esp)
  1038ba:	00 
  1038bb:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1038c2:	00 
  1038c3:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  1038ca:	00 
  1038cb:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1038d2:	e8 f5 d3 ff ff       	call   100ccc <__panic>

    assert(nr_free == 0);
  1038d7:	a1 18 af 11 00       	mov    0x11af18,%eax
  1038dc:	85 c0                	test   %eax,%eax
  1038de:	74 24                	je     103904 <default_check+0x591>
  1038e0:	c7 44 24 0c 79 66 10 	movl   $0x106679,0xc(%esp)
  1038e7:	00 
  1038e8:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1038ef:	00 
  1038f0:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  1038f7:	00 
  1038f8:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1038ff:	e8 c8 d3 ff ff       	call   100ccc <__panic>
    nr_free = nr_free_store;
  103904:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103907:	a3 18 af 11 00       	mov    %eax,0x11af18

    free_list = free_list_store;
  10390c:	8b 45 80             	mov    -0x80(%ebp),%eax
  10390f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103912:	a3 10 af 11 00       	mov    %eax,0x11af10
  103917:	89 15 14 af 11 00    	mov    %edx,0x11af14
    free_pages(p0, 5);
  10391d:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103924:	00 
  103925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103928:	89 04 24             	mov    %eax,(%esp)
  10392b:	e8 32 04 00 00       	call   103d62 <free_pages>

    le = &free_list;
  103930:	c7 45 ec 10 af 11 00 	movl   $0x11af10,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103937:	eb 5b                	jmp    103994 <default_check+0x621>
        assert(le->next->prev == le && le->prev->next == le);
  103939:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10393c:	8b 40 04             	mov    0x4(%eax),%eax
  10393f:	8b 00                	mov    (%eax),%eax
  103941:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103944:	75 0d                	jne    103953 <default_check+0x5e0>
  103946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103949:	8b 00                	mov    (%eax),%eax
  10394b:	8b 40 04             	mov    0x4(%eax),%eax
  10394e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103951:	74 24                	je     103977 <default_check+0x604>
  103953:	c7 44 24 0c e8 67 10 	movl   $0x1067e8,0xc(%esp)
  10395a:	00 
  10395b:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  103962:	00 
  103963:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
  10396a:	00 
  10396b:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  103972:	e8 55 d3 ff ff       	call   100ccc <__panic>
        struct Page *p = le2page(le, page_link);
  103977:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10397a:	83 e8 0c             	sub    $0xc,%eax
  10397d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103980:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103984:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103987:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10398a:	8b 40 08             	mov    0x8(%eax),%eax
  10398d:	29 c2                	sub    %eax,%edx
  10398f:	89 d0                	mov    %edx,%eax
  103991:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103997:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10399a:	8b 45 88             	mov    -0x78(%ebp),%eax
  10399d:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1039a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1039a3:	81 7d ec 10 af 11 00 	cmpl   $0x11af10,-0x14(%ebp)
  1039aa:	75 8d                	jne    103939 <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1039ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1039b0:	74 24                	je     1039d6 <default_check+0x663>
  1039b2:	c7 44 24 0c 15 68 10 	movl   $0x106815,0xc(%esp)
  1039b9:	00 
  1039ba:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1039c1:	00 
  1039c2:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  1039c9:	00 
  1039ca:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1039d1:	e8 f6 d2 ff ff       	call   100ccc <__panic>
    assert(total == 0);
  1039d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039da:	74 24                	je     103a00 <default_check+0x68d>
  1039dc:	c7 44 24 0c 20 68 10 	movl   $0x106820,0xc(%esp)
  1039e3:	00 
  1039e4:	c7 44 24 08 b6 64 10 	movl   $0x1064b6,0x8(%esp)
  1039eb:	00 
  1039ec:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  1039f3:	00 
  1039f4:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  1039fb:	e8 cc d2 ff ff       	call   100ccc <__panic>
}
  103a00:	81 c4 94 00 00 00    	add    $0x94,%esp
  103a06:	5b                   	pop    %ebx
  103a07:	5d                   	pop    %ebp
  103a08:	c3                   	ret    

00103a09 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103a09:	55                   	push   %ebp
  103a0a:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103a0c:	8b 55 08             	mov    0x8(%ebp),%edx
  103a0f:	a1 24 af 11 00       	mov    0x11af24,%eax
  103a14:	29 c2                	sub    %eax,%edx
  103a16:	89 d0                	mov    %edx,%eax
  103a18:	c1 f8 02             	sar    $0x2,%eax
  103a1b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103a21:	5d                   	pop    %ebp
  103a22:	c3                   	ret    

00103a23 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103a23:	55                   	push   %ebp
  103a24:	89 e5                	mov    %esp,%ebp
  103a26:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103a29:	8b 45 08             	mov    0x8(%ebp),%eax
  103a2c:	89 04 24             	mov    %eax,(%esp)
  103a2f:	e8 d5 ff ff ff       	call   103a09 <page2ppn>
  103a34:	c1 e0 0c             	shl    $0xc,%eax
}
  103a37:	c9                   	leave  
  103a38:	c3                   	ret    

00103a39 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a39:	55                   	push   %ebp
  103a3a:	89 e5                	mov    %esp,%ebp
  103a3c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103a42:	c1 e8 0c             	shr    $0xc,%eax
  103a45:	89 c2                	mov    %eax,%edx
  103a47:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103a4c:	39 c2                	cmp    %eax,%edx
  103a4e:	72 1c                	jb     103a6c <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103a50:	c7 44 24 08 5c 68 10 	movl   $0x10685c,0x8(%esp)
  103a57:	00 
  103a58:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a5f:	00 
  103a60:	c7 04 24 7b 68 10 00 	movl   $0x10687b,(%esp)
  103a67:	e8 60 d2 ff ff       	call   100ccc <__panic>
    }
    return &pages[PPN(pa)];
  103a6c:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  103a72:	8b 45 08             	mov    0x8(%ebp),%eax
  103a75:	c1 e8 0c             	shr    $0xc,%eax
  103a78:	89 c2                	mov    %eax,%edx
  103a7a:	89 d0                	mov    %edx,%eax
  103a7c:	c1 e0 02             	shl    $0x2,%eax
  103a7f:	01 d0                	add    %edx,%eax
  103a81:	c1 e0 02             	shl    $0x2,%eax
  103a84:	01 c8                	add    %ecx,%eax
}
  103a86:	c9                   	leave  
  103a87:	c3                   	ret    

00103a88 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a88:	55                   	push   %ebp
  103a89:	89 e5                	mov    %esp,%ebp
  103a8b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  103a91:	89 04 24             	mov    %eax,(%esp)
  103a94:	e8 8a ff ff ff       	call   103a23 <page2pa>
  103a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a9f:	c1 e8 0c             	shr    $0xc,%eax
  103aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103aa5:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103aaa:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103aad:	72 23                	jb     103ad2 <page2kva+0x4a>
  103aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ab2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ab6:	c7 44 24 08 8c 68 10 	movl   $0x10688c,0x8(%esp)
  103abd:	00 
  103abe:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103ac5:	00 
  103ac6:	c7 04 24 7b 68 10 00 	movl   $0x10687b,(%esp)
  103acd:	e8 fa d1 ff ff       	call   100ccc <__panic>
  103ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ad5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103ada:	c9                   	leave  
  103adb:	c3                   	ret    

00103adc <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103adc:	55                   	push   %ebp
  103add:	89 e5                	mov    %esp,%ebp
  103adf:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae5:	83 e0 01             	and    $0x1,%eax
  103ae8:	85 c0                	test   %eax,%eax
  103aea:	75 1c                	jne    103b08 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103aec:	c7 44 24 08 b0 68 10 	movl   $0x1068b0,0x8(%esp)
  103af3:	00 
  103af4:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103afb:	00 
  103afc:	c7 04 24 7b 68 10 00 	movl   $0x10687b,(%esp)
  103b03:	e8 c4 d1 ff ff       	call   100ccc <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103b08:	8b 45 08             	mov    0x8(%ebp),%eax
  103b0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b10:	89 04 24             	mov    %eax,(%esp)
  103b13:	e8 21 ff ff ff       	call   103a39 <pa2page>
}
  103b18:	c9                   	leave  
  103b19:	c3                   	ret    

00103b1a <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103b1a:	55                   	push   %ebp
  103b1b:	89 e5                	mov    %esp,%ebp
  103b1d:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103b20:	8b 45 08             	mov    0x8(%ebp),%eax
  103b23:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b28:	89 04 24             	mov    %eax,(%esp)
  103b2b:	e8 09 ff ff ff       	call   103a39 <pa2page>
}
  103b30:	c9                   	leave  
  103b31:	c3                   	ret    

00103b32 <page_ref>:

static inline int
page_ref(struct Page *page) {
  103b32:	55                   	push   %ebp
  103b33:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b35:	8b 45 08             	mov    0x8(%ebp),%eax
  103b38:	8b 00                	mov    (%eax),%eax
}
  103b3a:	5d                   	pop    %ebp
  103b3b:	c3                   	ret    

00103b3c <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  103b3c:	55                   	push   %ebp
  103b3d:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103b42:	8b 00                	mov    (%eax),%eax
  103b44:	8d 50 01             	lea    0x1(%eax),%edx
  103b47:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4a:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4f:	8b 00                	mov    (%eax),%eax
}
  103b51:	5d                   	pop    %ebp
  103b52:	c3                   	ret    

00103b53 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103b53:	55                   	push   %ebp
  103b54:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103b56:	8b 45 08             	mov    0x8(%ebp),%eax
  103b59:	8b 00                	mov    (%eax),%eax
  103b5b:	8d 50 ff             	lea    -0x1(%eax),%edx
  103b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  103b61:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b63:	8b 45 08             	mov    0x8(%ebp),%eax
  103b66:	8b 00                	mov    (%eax),%eax
}
  103b68:	5d                   	pop    %ebp
  103b69:	c3                   	ret    

00103b6a <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b6a:	55                   	push   %ebp
  103b6b:	89 e5                	mov    %esp,%ebp
  103b6d:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b70:	9c                   	pushf  
  103b71:	58                   	pop    %eax
  103b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b78:	25 00 02 00 00       	and    $0x200,%eax
  103b7d:	85 c0                	test   %eax,%eax
  103b7f:	74 0c                	je     103b8d <__intr_save+0x23>
        intr_disable();
  103b81:	e8 3a db ff ff       	call   1016c0 <intr_disable>
        return 1;
  103b86:	b8 01 00 00 00       	mov    $0x1,%eax
  103b8b:	eb 05                	jmp    103b92 <__intr_save+0x28>
    }
    return 0;
  103b8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b92:	c9                   	leave  
  103b93:	c3                   	ret    

00103b94 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b94:	55                   	push   %ebp
  103b95:	89 e5                	mov    %esp,%ebp
  103b97:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b9e:	74 05                	je     103ba5 <__intr_restore+0x11>
        intr_enable();
  103ba0:	e8 15 db ff ff       	call   1016ba <intr_enable>
    }
}
  103ba5:	c9                   	leave  
  103ba6:	c3                   	ret    

00103ba7 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103ba7:	55                   	push   %ebp
  103ba8:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103baa:	8b 45 08             	mov    0x8(%ebp),%eax
  103bad:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103bb0:	b8 23 00 00 00       	mov    $0x23,%eax
  103bb5:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103bb7:	b8 23 00 00 00       	mov    $0x23,%eax
  103bbc:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103bbe:	b8 10 00 00 00       	mov    $0x10,%eax
  103bc3:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103bc5:	b8 10 00 00 00       	mov    $0x10,%eax
  103bca:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103bcc:	b8 10 00 00 00       	mov    $0x10,%eax
  103bd1:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103bd3:	ea da 3b 10 00 08 00 	ljmp   $0x8,$0x103bda
}
  103bda:	5d                   	pop    %ebp
  103bdb:	c3                   	ret    

00103bdc <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103bdc:	55                   	push   %ebp
  103bdd:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  103be2:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  103be7:	5d                   	pop    %ebp
  103be8:	c3                   	ret    

00103be9 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103be9:	55                   	push   %ebp
  103bea:	89 e5                	mov    %esp,%ebp
  103bec:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103bef:	b8 00 70 11 00       	mov    $0x117000,%eax
  103bf4:	89 04 24             	mov    %eax,(%esp)
  103bf7:	e8 e0 ff ff ff       	call   103bdc <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103bfc:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  103c03:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103c05:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103c0c:	68 00 
  103c0e:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103c13:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103c19:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103c1e:	c1 e8 10             	shr    $0x10,%eax
  103c21:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103c26:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c2d:	83 e0 f0             	and    $0xfffffff0,%eax
  103c30:	83 c8 09             	or     $0x9,%eax
  103c33:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c38:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c3f:	83 e0 ef             	and    $0xffffffef,%eax
  103c42:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c47:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c4e:	83 e0 9f             	and    $0xffffff9f,%eax
  103c51:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c56:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c5d:	83 c8 80             	or     $0xffffff80,%eax
  103c60:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c65:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c6c:	83 e0 f0             	and    $0xfffffff0,%eax
  103c6f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c74:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c7b:	83 e0 ef             	and    $0xffffffef,%eax
  103c7e:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c83:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c8a:	83 e0 df             	and    $0xffffffdf,%eax
  103c8d:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c92:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c99:	83 c8 40             	or     $0x40,%eax
  103c9c:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ca1:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103ca8:	83 e0 7f             	and    $0x7f,%eax
  103cab:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103cb0:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103cb5:	c1 e8 18             	shr    $0x18,%eax
  103cb8:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103cbd:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103cc4:	e8 de fe ff ff       	call   103ba7 <lgdt>
  103cc9:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103ccf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103cd3:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103cd6:	c9                   	leave  
  103cd7:	c3                   	ret    

00103cd8 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103cd8:	55                   	push   %ebp
  103cd9:	89 e5                	mov    %esp,%ebp
  103cdb:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103cde:	c7 05 1c af 11 00 40 	movl   $0x106840,0x11af1c
  103ce5:	68 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103ce8:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103ced:	8b 00                	mov    (%eax),%eax
  103cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  103cf3:	c7 04 24 dc 68 10 00 	movl   $0x1068dc,(%esp)
  103cfa:	e8 49 c6 ff ff       	call   100348 <cprintf>
    pmm_manager->init();
  103cff:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103d04:	8b 40 04             	mov    0x4(%eax),%eax
  103d07:	ff d0                	call   *%eax
}
  103d09:	c9                   	leave  
  103d0a:	c3                   	ret    

00103d0b <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103d0b:	55                   	push   %ebp
  103d0c:	89 e5                	mov    %esp,%ebp
  103d0e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103d11:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103d16:	8b 40 08             	mov    0x8(%eax),%eax
  103d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d1c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d20:	8b 55 08             	mov    0x8(%ebp),%edx
  103d23:	89 14 24             	mov    %edx,(%esp)
  103d26:	ff d0                	call   *%eax
}
  103d28:	c9                   	leave  
  103d29:	c3                   	ret    

00103d2a <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103d2a:	55                   	push   %ebp
  103d2b:	89 e5                	mov    %esp,%ebp
  103d2d:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103d30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103d37:	e8 2e fe ff ff       	call   103b6a <__intr_save>
  103d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d3f:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103d44:	8b 40 0c             	mov    0xc(%eax),%eax
  103d47:	8b 55 08             	mov    0x8(%ebp),%edx
  103d4a:	89 14 24             	mov    %edx,(%esp)
  103d4d:	ff d0                	call   *%eax
  103d4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d55:	89 04 24             	mov    %eax,(%esp)
  103d58:	e8 37 fe ff ff       	call   103b94 <__intr_restore>
    return page;
  103d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103d60:	c9                   	leave  
  103d61:	c3                   	ret    

00103d62 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d62:	55                   	push   %ebp
  103d63:	89 e5                	mov    %esp,%ebp
  103d65:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d68:	e8 fd fd ff ff       	call   103b6a <__intr_save>
  103d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d70:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103d75:	8b 40 10             	mov    0x10(%eax),%eax
  103d78:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d7b:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  103d82:	89 14 24             	mov    %edx,(%esp)
  103d85:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d8a:	89 04 24             	mov    %eax,(%esp)
  103d8d:	e8 02 fe ff ff       	call   103b94 <__intr_restore>
}
  103d92:	c9                   	leave  
  103d93:	c3                   	ret    

00103d94 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d94:	55                   	push   %ebp
  103d95:	89 e5                	mov    %esp,%ebp
  103d97:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d9a:	e8 cb fd ff ff       	call   103b6a <__intr_save>
  103d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103da2:	a1 1c af 11 00       	mov    0x11af1c,%eax
  103da7:	8b 40 14             	mov    0x14(%eax),%eax
  103daa:	ff d0                	call   *%eax
  103dac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103db2:	89 04 24             	mov    %eax,(%esp)
  103db5:	e8 da fd ff ff       	call   103b94 <__intr_restore>
    return ret;
  103dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103dbd:	c9                   	leave  
  103dbe:	c3                   	ret    

00103dbf <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103dbf:	55                   	push   %ebp
  103dc0:	89 e5                	mov    %esp,%ebp
  103dc2:	57                   	push   %edi
  103dc3:	56                   	push   %esi
  103dc4:	53                   	push   %ebx
  103dc5:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103dcb:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103dd2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103dd9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103de0:	c7 04 24 f3 68 10 00 	movl   $0x1068f3,(%esp)
  103de7:	e8 5c c5 ff ff       	call   100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103dec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103df3:	e9 15 01 00 00       	jmp    103f0d <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103df8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dfb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dfe:	89 d0                	mov    %edx,%eax
  103e00:	c1 e0 02             	shl    $0x2,%eax
  103e03:	01 d0                	add    %edx,%eax
  103e05:	c1 e0 02             	shl    $0x2,%eax
  103e08:	01 c8                	add    %ecx,%eax
  103e0a:	8b 50 08             	mov    0x8(%eax),%edx
  103e0d:	8b 40 04             	mov    0x4(%eax),%eax
  103e10:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e13:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103e16:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e19:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e1c:	89 d0                	mov    %edx,%eax
  103e1e:	c1 e0 02             	shl    $0x2,%eax
  103e21:	01 d0                	add    %edx,%eax
  103e23:	c1 e0 02             	shl    $0x2,%eax
  103e26:	01 c8                	add    %ecx,%eax
  103e28:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e2b:	8b 58 10             	mov    0x10(%eax),%ebx
  103e2e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e31:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e34:	01 c8                	add    %ecx,%eax
  103e36:	11 da                	adc    %ebx,%edx
  103e38:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103e3b:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103e3e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e41:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e44:	89 d0                	mov    %edx,%eax
  103e46:	c1 e0 02             	shl    $0x2,%eax
  103e49:	01 d0                	add    %edx,%eax
  103e4b:	c1 e0 02             	shl    $0x2,%eax
  103e4e:	01 c8                	add    %ecx,%eax
  103e50:	83 c0 14             	add    $0x14,%eax
  103e53:	8b 00                	mov    (%eax),%eax
  103e55:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103e5b:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e5e:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e61:	83 c0 ff             	add    $0xffffffff,%eax
  103e64:	83 d2 ff             	adc    $0xffffffff,%edx
  103e67:	89 c6                	mov    %eax,%esi
  103e69:	89 d7                	mov    %edx,%edi
  103e6b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e6e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e71:	89 d0                	mov    %edx,%eax
  103e73:	c1 e0 02             	shl    $0x2,%eax
  103e76:	01 d0                	add    %edx,%eax
  103e78:	c1 e0 02             	shl    $0x2,%eax
  103e7b:	01 c8                	add    %ecx,%eax
  103e7d:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e80:	8b 58 10             	mov    0x10(%eax),%ebx
  103e83:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e89:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e8d:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e91:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e95:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e98:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e9f:	89 54 24 10          	mov    %edx,0x10(%esp)
  103ea3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103ea7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103eab:	c7 04 24 00 69 10 00 	movl   $0x106900,(%esp)
  103eb2:	e8 91 c4 ff ff       	call   100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103eb7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103eba:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ebd:	89 d0                	mov    %edx,%eax
  103ebf:	c1 e0 02             	shl    $0x2,%eax
  103ec2:	01 d0                	add    %edx,%eax
  103ec4:	c1 e0 02             	shl    $0x2,%eax
  103ec7:	01 c8                	add    %ecx,%eax
  103ec9:	83 c0 14             	add    $0x14,%eax
  103ecc:	8b 00                	mov    (%eax),%eax
  103ece:	83 f8 01             	cmp    $0x1,%eax
  103ed1:	75 36                	jne    103f09 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ed6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ed9:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103edc:	77 2b                	ja     103f09 <page_init+0x14a>
  103ede:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103ee1:	72 05                	jb     103ee8 <page_init+0x129>
  103ee3:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103ee6:	73 21                	jae    103f09 <page_init+0x14a>
  103ee8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103eec:	77 1b                	ja     103f09 <page_init+0x14a>
  103eee:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103ef2:	72 09                	jb     103efd <page_init+0x13e>
  103ef4:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103efb:	77 0c                	ja     103f09 <page_init+0x14a>
                maxpa = end;
  103efd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103f00:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103f03:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103f06:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103f09:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f0d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f10:	8b 00                	mov    (%eax),%eax
  103f12:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f15:	0f 8f dd fe ff ff    	jg     103df8 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103f1b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f1f:	72 1d                	jb     103f3e <page_init+0x17f>
  103f21:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f25:	77 09                	ja     103f30 <page_init+0x171>
  103f27:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f2e:	76 0e                	jbe    103f3e <page_init+0x17f>
        maxpa = KMEMSIZE;
  103f30:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103f37:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103f3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f44:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103f48:	c1 ea 0c             	shr    $0xc,%edx
  103f4b:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103f50:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103f57:	b8 28 af 11 00       	mov    $0x11af28,%eax
  103f5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  103f5f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f62:	01 d0                	add    %edx,%eax
  103f64:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f67:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f6a:	ba 00 00 00 00       	mov    $0x0,%edx
  103f6f:	f7 75 ac             	divl   -0x54(%ebp)
  103f72:	89 d0                	mov    %edx,%eax
  103f74:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f77:	29 c2                	sub    %eax,%edx
  103f79:	89 d0                	mov    %edx,%eax
  103f7b:	a3 24 af 11 00       	mov    %eax,0x11af24

    for (i = 0; i < npage; i ++) {
  103f80:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f87:	eb 2f                	jmp    103fb8 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f89:	8b 0d 24 af 11 00    	mov    0x11af24,%ecx
  103f8f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f92:	89 d0                	mov    %edx,%eax
  103f94:	c1 e0 02             	shl    $0x2,%eax
  103f97:	01 d0                	add    %edx,%eax
  103f99:	c1 e0 02             	shl    $0x2,%eax
  103f9c:	01 c8                	add    %ecx,%eax
  103f9e:	83 c0 04             	add    $0x4,%eax
  103fa1:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103fa8:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103fab:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103fae:	8b 55 90             	mov    -0x70(%ebp),%edx
  103fb1:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103fb4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103fb8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fbb:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103fc0:	39 c2                	cmp    %eax,%edx
  103fc2:	72 c5                	jb     103f89 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103fc4:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  103fca:	89 d0                	mov    %edx,%eax
  103fcc:	c1 e0 02             	shl    $0x2,%eax
  103fcf:	01 d0                	add    %edx,%eax
  103fd1:	c1 e0 02             	shl    $0x2,%eax
  103fd4:	89 c2                	mov    %eax,%edx
  103fd6:	a1 24 af 11 00       	mov    0x11af24,%eax
  103fdb:	01 d0                	add    %edx,%eax
  103fdd:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103fe0:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103fe7:	77 23                	ja     10400c <page_init+0x24d>
  103fe9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ff0:	c7 44 24 08 30 69 10 	movl   $0x106930,0x8(%esp)
  103ff7:	00 
  103ff8:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103fff:	00 
  104000:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104007:	e8 c0 cc ff ff       	call   100ccc <__panic>
  10400c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10400f:	05 00 00 00 40       	add    $0x40000000,%eax
  104014:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104017:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10401e:	e9 74 01 00 00       	jmp    104197 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104023:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104026:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104029:	89 d0                	mov    %edx,%eax
  10402b:	c1 e0 02             	shl    $0x2,%eax
  10402e:	01 d0                	add    %edx,%eax
  104030:	c1 e0 02             	shl    $0x2,%eax
  104033:	01 c8                	add    %ecx,%eax
  104035:	8b 50 08             	mov    0x8(%eax),%edx
  104038:	8b 40 04             	mov    0x4(%eax),%eax
  10403b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10403e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104041:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104044:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104047:	89 d0                	mov    %edx,%eax
  104049:	c1 e0 02             	shl    $0x2,%eax
  10404c:	01 d0                	add    %edx,%eax
  10404e:	c1 e0 02             	shl    $0x2,%eax
  104051:	01 c8                	add    %ecx,%eax
  104053:	8b 48 0c             	mov    0xc(%eax),%ecx
  104056:	8b 58 10             	mov    0x10(%eax),%ebx
  104059:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10405c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10405f:	01 c8                	add    %ecx,%eax
  104061:	11 da                	adc    %ebx,%edx
  104063:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104066:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104069:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10406c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10406f:	89 d0                	mov    %edx,%eax
  104071:	c1 e0 02             	shl    $0x2,%eax
  104074:	01 d0                	add    %edx,%eax
  104076:	c1 e0 02             	shl    $0x2,%eax
  104079:	01 c8                	add    %ecx,%eax
  10407b:	83 c0 14             	add    $0x14,%eax
  10407e:	8b 00                	mov    (%eax),%eax
  104080:	83 f8 01             	cmp    $0x1,%eax
  104083:	0f 85 0a 01 00 00    	jne    104193 <page_init+0x3d4>
            if (begin < freemem) {
  104089:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10408c:	ba 00 00 00 00       	mov    $0x0,%edx
  104091:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104094:	72 17                	jb     1040ad <page_init+0x2ee>
  104096:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104099:	77 05                	ja     1040a0 <page_init+0x2e1>
  10409b:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10409e:	76 0d                	jbe    1040ad <page_init+0x2ee>
                begin = freemem;
  1040a0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1040a3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1040ad:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040b1:	72 1d                	jb     1040d0 <page_init+0x311>
  1040b3:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040b7:	77 09                	ja     1040c2 <page_init+0x303>
  1040b9:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1040c0:	76 0e                	jbe    1040d0 <page_init+0x311>
                end = KMEMSIZE;
  1040c2:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1040c9:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1040d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040d3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040d6:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040d9:	0f 87 b4 00 00 00    	ja     104193 <page_init+0x3d4>
  1040df:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040e2:	72 09                	jb     1040ed <page_init+0x32e>
  1040e4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040e7:	0f 83 a6 00 00 00    	jae    104193 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1040ed:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1040f4:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1040f7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1040fa:	01 d0                	add    %edx,%eax
  1040fc:	83 e8 01             	sub    $0x1,%eax
  1040ff:	89 45 98             	mov    %eax,-0x68(%ebp)
  104102:	8b 45 98             	mov    -0x68(%ebp),%eax
  104105:	ba 00 00 00 00       	mov    $0x0,%edx
  10410a:	f7 75 9c             	divl   -0x64(%ebp)
  10410d:	89 d0                	mov    %edx,%eax
  10410f:	8b 55 98             	mov    -0x68(%ebp),%edx
  104112:	29 c2                	sub    %eax,%edx
  104114:	89 d0                	mov    %edx,%eax
  104116:	ba 00 00 00 00       	mov    $0x0,%edx
  10411b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10411e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104121:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104124:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104127:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10412a:	ba 00 00 00 00       	mov    $0x0,%edx
  10412f:	89 c7                	mov    %eax,%edi
  104131:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104137:	89 7d 80             	mov    %edi,-0x80(%ebp)
  10413a:	89 d0                	mov    %edx,%eax
  10413c:	83 e0 00             	and    $0x0,%eax
  10413f:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104142:	8b 45 80             	mov    -0x80(%ebp),%eax
  104145:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104148:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10414b:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10414e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104151:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104154:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104157:	77 3a                	ja     104193 <page_init+0x3d4>
  104159:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10415c:	72 05                	jb     104163 <page_init+0x3a4>
  10415e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104161:	73 30                	jae    104193 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104163:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104166:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104169:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10416c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10416f:	29 c8                	sub    %ecx,%eax
  104171:	19 da                	sbb    %ebx,%edx
  104173:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104177:	c1 ea 0c             	shr    $0xc,%edx
  10417a:	89 c3                	mov    %eax,%ebx
  10417c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10417f:	89 04 24             	mov    %eax,(%esp)
  104182:	e8 b2 f8 ff ff       	call   103a39 <pa2page>
  104187:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10418b:	89 04 24             	mov    %eax,(%esp)
  10418e:	e8 78 fb ff ff       	call   103d0b <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104193:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104197:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10419a:	8b 00                	mov    (%eax),%eax
  10419c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10419f:	0f 8f 7e fe ff ff    	jg     104023 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1041a5:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1041ab:	5b                   	pop    %ebx
  1041ac:	5e                   	pop    %esi
  1041ad:	5f                   	pop    %edi
  1041ae:	5d                   	pop    %ebp
  1041af:	c3                   	ret    

001041b0 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1041b0:	55                   	push   %ebp
  1041b1:	89 e5                	mov    %esp,%ebp
  1041b3:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1041b6:	8b 45 14             	mov    0x14(%ebp),%eax
  1041b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041bc:	31 d0                	xor    %edx,%eax
  1041be:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041c3:	85 c0                	test   %eax,%eax
  1041c5:	74 24                	je     1041eb <boot_map_segment+0x3b>
  1041c7:	c7 44 24 0c 62 69 10 	movl   $0x106962,0xc(%esp)
  1041ce:	00 
  1041cf:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  1041d6:	00 
  1041d7:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1041de:	00 
  1041df:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  1041e6:	e8 e1 ca ff ff       	call   100ccc <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1041eb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1041f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041f5:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041fa:	89 c2                	mov    %eax,%edx
  1041fc:	8b 45 10             	mov    0x10(%ebp),%eax
  1041ff:	01 c2                	add    %eax,%edx
  104201:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104204:	01 d0                	add    %edx,%eax
  104206:	83 e8 01             	sub    $0x1,%eax
  104209:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10420c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10420f:	ba 00 00 00 00       	mov    $0x0,%edx
  104214:	f7 75 f0             	divl   -0x10(%ebp)
  104217:	89 d0                	mov    %edx,%eax
  104219:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10421c:	29 c2                	sub    %eax,%edx
  10421e:	89 d0                	mov    %edx,%eax
  104220:	c1 e8 0c             	shr    $0xc,%eax
  104223:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104226:	8b 45 0c             	mov    0xc(%ebp),%eax
  104229:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10422c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10422f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104234:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104237:	8b 45 14             	mov    0x14(%ebp),%eax
  10423a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10423d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104240:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104245:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104248:	eb 6b                	jmp    1042b5 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10424a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104251:	00 
  104252:	8b 45 0c             	mov    0xc(%ebp),%eax
  104255:	89 44 24 04          	mov    %eax,0x4(%esp)
  104259:	8b 45 08             	mov    0x8(%ebp),%eax
  10425c:	89 04 24             	mov    %eax,(%esp)
  10425f:	e8 82 01 00 00       	call   1043e6 <get_pte>
  104264:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104267:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  10426b:	75 24                	jne    104291 <boot_map_segment+0xe1>
  10426d:	c7 44 24 0c 8e 69 10 	movl   $0x10698e,0xc(%esp)
  104274:	00 
  104275:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  10427c:	00 
  10427d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104284:	00 
  104285:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  10428c:	e8 3b ca ff ff       	call   100ccc <__panic>
        *ptep = pa | PTE_P | perm;
  104291:	8b 45 18             	mov    0x18(%ebp),%eax
  104294:	8b 55 14             	mov    0x14(%ebp),%edx
  104297:	09 d0                	or     %edx,%eax
  104299:	83 c8 01             	or     $0x1,%eax
  10429c:	89 c2                	mov    %eax,%edx
  10429e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042a1:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042a3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1042a7:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1042ae:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1042b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042b9:	75 8f                	jne    10424a <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1042bb:	c9                   	leave  
  1042bc:	c3                   	ret    

001042bd <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1042bd:	55                   	push   %ebp
  1042be:	89 e5                	mov    %esp,%ebp
  1042c0:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1042c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042ca:	e8 5b fa ff ff       	call   103d2a <alloc_pages>
  1042cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1042d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042d6:	75 1c                	jne    1042f4 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1042d8:	c7 44 24 08 9b 69 10 	movl   $0x10699b,0x8(%esp)
  1042df:	00 
  1042e0:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1042e7:	00 
  1042e8:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  1042ef:	e8 d8 c9 ff ff       	call   100ccc <__panic>
    }
    return page2kva(p);
  1042f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042f7:	89 04 24             	mov    %eax,(%esp)
  1042fa:	e8 89 f7 ff ff       	call   103a88 <page2kva>
}
  1042ff:	c9                   	leave  
  104300:	c3                   	ret    

00104301 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104301:	55                   	push   %ebp
  104302:	89 e5                	mov    %esp,%ebp
  104304:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  104307:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10430c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10430f:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104316:	77 23                	ja     10433b <pmm_init+0x3a>
  104318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10431b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10431f:	c7 44 24 08 30 69 10 	movl   $0x106930,0x8(%esp)
  104326:	00 
  104327:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10432e:	00 
  10432f:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104336:	e8 91 c9 ff ff       	call   100ccc <__panic>
  10433b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10433e:	05 00 00 00 40       	add    $0x40000000,%eax
  104343:	a3 20 af 11 00       	mov    %eax,0x11af20
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104348:	e8 8b f9 ff ff       	call   103cd8 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10434d:	e8 6d fa ff ff       	call   103dbf <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104352:	e8 4c 02 00 00       	call   1045a3 <check_alloc_page>

    check_pgdir();
  104357:	e8 65 02 00 00       	call   1045c1 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  10435c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104361:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104367:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10436c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10436f:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104376:	77 23                	ja     10439b <pmm_init+0x9a>
  104378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10437b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10437f:	c7 44 24 08 30 69 10 	movl   $0x106930,0x8(%esp)
  104386:	00 
  104387:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  10438e:	00 
  10438f:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104396:	e8 31 c9 ff ff       	call   100ccc <__panic>
  10439b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10439e:	05 00 00 00 40       	add    $0x40000000,%eax
  1043a3:	83 c8 03             	or     $0x3,%eax
  1043a6:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1043a8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1043ad:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1043b4:	00 
  1043b5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1043bc:	00 
  1043bd:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1043c4:	38 
  1043c5:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1043cc:	c0 
  1043cd:	89 04 24             	mov    %eax,(%esp)
  1043d0:	e8 db fd ff ff       	call   1041b0 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1043d5:	e8 0f f8 ff ff       	call   103be9 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1043da:	e8 7d 08 00 00       	call   104c5c <check_boot_pgdir>

    print_pgdir();
  1043df:	e8 05 0d 00 00       	call   1050e9 <print_pgdir>

}
  1043e4:	c9                   	leave  
  1043e5:	c3                   	ret    

001043e6 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1043e6:	55                   	push   %ebp
  1043e7:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1043e9:	5d                   	pop    %ebp
  1043ea:	c3                   	ret    

001043eb <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1043eb:	55                   	push   %ebp
  1043ec:	89 e5                	mov    %esp,%ebp
  1043ee:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1043f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1043f8:	00 
  1043f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  104400:	8b 45 08             	mov    0x8(%ebp),%eax
  104403:	89 04 24             	mov    %eax,(%esp)
  104406:	e8 db ff ff ff       	call   1043e6 <get_pte>
  10440b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10440e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104412:	74 08                	je     10441c <get_page+0x31>
        *ptep_store = ptep;
  104414:	8b 45 10             	mov    0x10(%ebp),%eax
  104417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10441a:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10441c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104420:	74 1b                	je     10443d <get_page+0x52>
  104422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104425:	8b 00                	mov    (%eax),%eax
  104427:	83 e0 01             	and    $0x1,%eax
  10442a:	85 c0                	test   %eax,%eax
  10442c:	74 0f                	je     10443d <get_page+0x52>
        return pte2page(*ptep);
  10442e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104431:	8b 00                	mov    (%eax),%eax
  104433:	89 04 24             	mov    %eax,(%esp)
  104436:	e8 a1 f6 ff ff       	call   103adc <pte2page>
  10443b:	eb 05                	jmp    104442 <get_page+0x57>
    }
    return NULL;
  10443d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104442:	c9                   	leave  
  104443:	c3                   	ret    

00104444 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  104444:	55                   	push   %ebp
  104445:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  104447:	5d                   	pop    %ebp
  104448:	c3                   	ret    

00104449 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104449:	55                   	push   %ebp
  10444a:	89 e5                	mov    %esp,%ebp
  10444c:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10444f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104456:	00 
  104457:	8b 45 0c             	mov    0xc(%ebp),%eax
  10445a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10445e:	8b 45 08             	mov    0x8(%ebp),%eax
  104461:	89 04 24             	mov    %eax,(%esp)
  104464:	e8 7d ff ff ff       	call   1043e6 <get_pte>
  104469:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  10446c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  104470:	74 19                	je     10448b <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104472:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104475:	89 44 24 08          	mov    %eax,0x8(%esp)
  104479:	8b 45 0c             	mov    0xc(%ebp),%eax
  10447c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104480:	8b 45 08             	mov    0x8(%ebp),%eax
  104483:	89 04 24             	mov    %eax,(%esp)
  104486:	e8 b9 ff ff ff       	call   104444 <page_remove_pte>
    }
}
  10448b:	c9                   	leave  
  10448c:	c3                   	ret    

0010448d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10448d:	55                   	push   %ebp
  10448e:	89 e5                	mov    %esp,%ebp
  104490:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104493:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10449a:	00 
  10449b:	8b 45 10             	mov    0x10(%ebp),%eax
  10449e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1044a5:	89 04 24             	mov    %eax,(%esp)
  1044a8:	e8 39 ff ff ff       	call   1043e6 <get_pte>
  1044ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1044b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044b4:	75 0a                	jne    1044c0 <page_insert+0x33>
        return -E_NO_MEM;
  1044b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1044bb:	e9 84 00 00 00       	jmp    104544 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1044c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044c3:	89 04 24             	mov    %eax,(%esp)
  1044c6:	e8 71 f6 ff ff       	call   103b3c <page_ref_inc>
    if (*ptep & PTE_P) {
  1044cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ce:	8b 00                	mov    (%eax),%eax
  1044d0:	83 e0 01             	and    $0x1,%eax
  1044d3:	85 c0                	test   %eax,%eax
  1044d5:	74 3e                	je     104515 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044da:	8b 00                	mov    (%eax),%eax
  1044dc:	89 04 24             	mov    %eax,(%esp)
  1044df:	e8 f8 f5 ff ff       	call   103adc <pte2page>
  1044e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1044e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1044ed:	75 0d                	jne    1044fc <page_insert+0x6f>
            page_ref_dec(page);
  1044ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044f2:	89 04 24             	mov    %eax,(%esp)
  1044f5:	e8 59 f6 ff ff       	call   103b53 <page_ref_dec>
  1044fa:	eb 19                	jmp    104515 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1044fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  104503:	8b 45 10             	mov    0x10(%ebp),%eax
  104506:	89 44 24 04          	mov    %eax,0x4(%esp)
  10450a:	8b 45 08             	mov    0x8(%ebp),%eax
  10450d:	89 04 24             	mov    %eax,(%esp)
  104510:	e8 2f ff ff ff       	call   104444 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104515:	8b 45 0c             	mov    0xc(%ebp),%eax
  104518:	89 04 24             	mov    %eax,(%esp)
  10451b:	e8 03 f5 ff ff       	call   103a23 <page2pa>
  104520:	0b 45 14             	or     0x14(%ebp),%eax
  104523:	83 c8 01             	or     $0x1,%eax
  104526:	89 c2                	mov    %eax,%edx
  104528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10452b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10452d:	8b 45 10             	mov    0x10(%ebp),%eax
  104530:	89 44 24 04          	mov    %eax,0x4(%esp)
  104534:	8b 45 08             	mov    0x8(%ebp),%eax
  104537:	89 04 24             	mov    %eax,(%esp)
  10453a:	e8 07 00 00 00       	call   104546 <tlb_invalidate>
    return 0;
  10453f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104544:	c9                   	leave  
  104545:	c3                   	ret    

00104546 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104546:	55                   	push   %ebp
  104547:	89 e5                	mov    %esp,%ebp
  104549:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10454c:	0f 20 d8             	mov    %cr3,%eax
  10454f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104552:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104555:	89 c2                	mov    %eax,%edx
  104557:	8b 45 08             	mov    0x8(%ebp),%eax
  10455a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10455d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104564:	77 23                	ja     104589 <tlb_invalidate+0x43>
  104566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104569:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10456d:	c7 44 24 08 30 69 10 	movl   $0x106930,0x8(%esp)
  104574:	00 
  104575:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  10457c:	00 
  10457d:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104584:	e8 43 c7 ff ff       	call   100ccc <__panic>
  104589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10458c:	05 00 00 00 40       	add    $0x40000000,%eax
  104591:	39 c2                	cmp    %eax,%edx
  104593:	75 0c                	jne    1045a1 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104595:	8b 45 0c             	mov    0xc(%ebp),%eax
  104598:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10459b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10459e:	0f 01 38             	invlpg (%eax)
    }
}
  1045a1:	c9                   	leave  
  1045a2:	c3                   	ret    

001045a3 <check_alloc_page>:

static void
check_alloc_page(void) {
  1045a3:	55                   	push   %ebp
  1045a4:	89 e5                	mov    %esp,%ebp
  1045a6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1045a9:	a1 1c af 11 00       	mov    0x11af1c,%eax
  1045ae:	8b 40 18             	mov    0x18(%eax),%eax
  1045b1:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1045b3:	c7 04 24 b4 69 10 00 	movl   $0x1069b4,(%esp)
  1045ba:	e8 89 bd ff ff       	call   100348 <cprintf>
}
  1045bf:	c9                   	leave  
  1045c0:	c3                   	ret    

001045c1 <check_pgdir>:

static void
check_pgdir(void) {
  1045c1:	55                   	push   %ebp
  1045c2:	89 e5                	mov    %esp,%ebp
  1045c4:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1045c7:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1045cc:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1045d1:	76 24                	jbe    1045f7 <check_pgdir+0x36>
  1045d3:	c7 44 24 0c d3 69 10 	movl   $0x1069d3,0xc(%esp)
  1045da:	00 
  1045db:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  1045e2:	00 
  1045e3:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  1045ea:	00 
  1045eb:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  1045f2:	e8 d5 c6 ff ff       	call   100ccc <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1045f7:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1045fc:	85 c0                	test   %eax,%eax
  1045fe:	74 0e                	je     10460e <check_pgdir+0x4d>
  104600:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104605:	25 ff 0f 00 00       	and    $0xfff,%eax
  10460a:	85 c0                	test   %eax,%eax
  10460c:	74 24                	je     104632 <check_pgdir+0x71>
  10460e:	c7 44 24 0c f0 69 10 	movl   $0x1069f0,0xc(%esp)
  104615:	00 
  104616:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  10461d:	00 
  10461e:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  104625:	00 
  104626:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  10462d:	e8 9a c6 ff ff       	call   100ccc <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104632:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104637:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10463e:	00 
  10463f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104646:	00 
  104647:	89 04 24             	mov    %eax,(%esp)
  10464a:	e8 9c fd ff ff       	call   1043eb <get_page>
  10464f:	85 c0                	test   %eax,%eax
  104651:	74 24                	je     104677 <check_pgdir+0xb6>
  104653:	c7 44 24 0c 28 6a 10 	movl   $0x106a28,0xc(%esp)
  10465a:	00 
  10465b:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104662:	00 
  104663:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  10466a:	00 
  10466b:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104672:	e8 55 c6 ff ff       	call   100ccc <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104677:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10467e:	e8 a7 f6 ff ff       	call   103d2a <alloc_pages>
  104683:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104686:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10468b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104692:	00 
  104693:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10469a:	00 
  10469b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10469e:	89 54 24 04          	mov    %edx,0x4(%esp)
  1046a2:	89 04 24             	mov    %eax,(%esp)
  1046a5:	e8 e3 fd ff ff       	call   10448d <page_insert>
  1046aa:	85 c0                	test   %eax,%eax
  1046ac:	74 24                	je     1046d2 <check_pgdir+0x111>
  1046ae:	c7 44 24 0c 50 6a 10 	movl   $0x106a50,0xc(%esp)
  1046b5:	00 
  1046b6:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  1046bd:	00 
  1046be:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  1046c5:	00 
  1046c6:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  1046cd:	e8 fa c5 ff ff       	call   100ccc <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1046d2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1046d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1046de:	00 
  1046df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1046e6:	00 
  1046e7:	89 04 24             	mov    %eax,(%esp)
  1046ea:	e8 f7 fc ff ff       	call   1043e6 <get_pte>
  1046ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1046f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1046f6:	75 24                	jne    10471c <check_pgdir+0x15b>
  1046f8:	c7 44 24 0c 7c 6a 10 	movl   $0x106a7c,0xc(%esp)
  1046ff:	00 
  104700:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104707:	00 
  104708:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  10470f:	00 
  104710:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104717:	e8 b0 c5 ff ff       	call   100ccc <__panic>
    assert(pte2page(*ptep) == p1);
  10471c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10471f:	8b 00                	mov    (%eax),%eax
  104721:	89 04 24             	mov    %eax,(%esp)
  104724:	e8 b3 f3 ff ff       	call   103adc <pte2page>
  104729:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10472c:	74 24                	je     104752 <check_pgdir+0x191>
  10472e:	c7 44 24 0c a9 6a 10 	movl   $0x106aa9,0xc(%esp)
  104735:	00 
  104736:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  10473d:	00 
  10473e:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  104745:	00 
  104746:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  10474d:	e8 7a c5 ff ff       	call   100ccc <__panic>
    assert(page_ref(p1) == 1);
  104752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104755:	89 04 24             	mov    %eax,(%esp)
  104758:	e8 d5 f3 ff ff       	call   103b32 <page_ref>
  10475d:	83 f8 01             	cmp    $0x1,%eax
  104760:	74 24                	je     104786 <check_pgdir+0x1c5>
  104762:	c7 44 24 0c bf 6a 10 	movl   $0x106abf,0xc(%esp)
  104769:	00 
  10476a:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104771:	00 
  104772:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  104779:	00 
  10477a:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104781:	e8 46 c5 ff ff       	call   100ccc <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104786:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10478b:	8b 00                	mov    (%eax),%eax
  10478d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104792:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104798:	c1 e8 0c             	shr    $0xc,%eax
  10479b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10479e:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1047a3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1047a6:	72 23                	jb     1047cb <check_pgdir+0x20a>
  1047a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047af:	c7 44 24 08 8c 68 10 	movl   $0x10688c,0x8(%esp)
  1047b6:	00 
  1047b7:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  1047be:	00 
  1047bf:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  1047c6:	e8 01 c5 ff ff       	call   100ccc <__panic>
  1047cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1047ce:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1047d3:	83 c0 04             	add    $0x4,%eax
  1047d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1047d9:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1047de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047e5:	00 
  1047e6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1047ed:	00 
  1047ee:	89 04 24             	mov    %eax,(%esp)
  1047f1:	e8 f0 fb ff ff       	call   1043e6 <get_pte>
  1047f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1047f9:	74 24                	je     10481f <check_pgdir+0x25e>
  1047fb:	c7 44 24 0c d4 6a 10 	movl   $0x106ad4,0xc(%esp)
  104802:	00 
  104803:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  10480a:	00 
  10480b:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  104812:	00 
  104813:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  10481a:	e8 ad c4 ff ff       	call   100ccc <__panic>

    p2 = alloc_page();
  10481f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104826:	e8 ff f4 ff ff       	call   103d2a <alloc_pages>
  10482b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10482e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104833:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  10483a:	00 
  10483b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104842:	00 
  104843:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104846:	89 54 24 04          	mov    %edx,0x4(%esp)
  10484a:	89 04 24             	mov    %eax,(%esp)
  10484d:	e8 3b fc ff ff       	call   10448d <page_insert>
  104852:	85 c0                	test   %eax,%eax
  104854:	74 24                	je     10487a <check_pgdir+0x2b9>
  104856:	c7 44 24 0c fc 6a 10 	movl   $0x106afc,0xc(%esp)
  10485d:	00 
  10485e:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104865:	00 
  104866:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  10486d:	00 
  10486e:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104875:	e8 52 c4 ff ff       	call   100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  10487a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10487f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104886:	00 
  104887:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10488e:	00 
  10488f:	89 04 24             	mov    %eax,(%esp)
  104892:	e8 4f fb ff ff       	call   1043e6 <get_pte>
  104897:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10489a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10489e:	75 24                	jne    1048c4 <check_pgdir+0x303>
  1048a0:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  1048a7:	00 
  1048a8:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  1048af:	00 
  1048b0:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  1048b7:	00 
  1048b8:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  1048bf:	e8 08 c4 ff ff       	call   100ccc <__panic>
    assert(*ptep & PTE_U);
  1048c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048c7:	8b 00                	mov    (%eax),%eax
  1048c9:	83 e0 04             	and    $0x4,%eax
  1048cc:	85 c0                	test   %eax,%eax
  1048ce:	75 24                	jne    1048f4 <check_pgdir+0x333>
  1048d0:	c7 44 24 0c 64 6b 10 	movl   $0x106b64,0xc(%esp)
  1048d7:	00 
  1048d8:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  1048df:	00 
  1048e0:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  1048e7:	00 
  1048e8:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  1048ef:	e8 d8 c3 ff ff       	call   100ccc <__panic>
    assert(*ptep & PTE_W);
  1048f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048f7:	8b 00                	mov    (%eax),%eax
  1048f9:	83 e0 02             	and    $0x2,%eax
  1048fc:	85 c0                	test   %eax,%eax
  1048fe:	75 24                	jne    104924 <check_pgdir+0x363>
  104900:	c7 44 24 0c 72 6b 10 	movl   $0x106b72,0xc(%esp)
  104907:	00 
  104908:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  10490f:	00 
  104910:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  104917:	00 
  104918:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  10491f:	e8 a8 c3 ff ff       	call   100ccc <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104924:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104929:	8b 00                	mov    (%eax),%eax
  10492b:	83 e0 04             	and    $0x4,%eax
  10492e:	85 c0                	test   %eax,%eax
  104930:	75 24                	jne    104956 <check_pgdir+0x395>
  104932:	c7 44 24 0c 80 6b 10 	movl   $0x106b80,0xc(%esp)
  104939:	00 
  10493a:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104941:	00 
  104942:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  104949:	00 
  10494a:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104951:	e8 76 c3 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 1);
  104956:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104959:	89 04 24             	mov    %eax,(%esp)
  10495c:	e8 d1 f1 ff ff       	call   103b32 <page_ref>
  104961:	83 f8 01             	cmp    $0x1,%eax
  104964:	74 24                	je     10498a <check_pgdir+0x3c9>
  104966:	c7 44 24 0c 96 6b 10 	movl   $0x106b96,0xc(%esp)
  10496d:	00 
  10496e:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104975:	00 
  104976:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  10497d:	00 
  10497e:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104985:	e8 42 c3 ff ff       	call   100ccc <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  10498a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10498f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104996:	00 
  104997:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10499e:	00 
  10499f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1049a2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1049a6:	89 04 24             	mov    %eax,(%esp)
  1049a9:	e8 df fa ff ff       	call   10448d <page_insert>
  1049ae:	85 c0                	test   %eax,%eax
  1049b0:	74 24                	je     1049d6 <check_pgdir+0x415>
  1049b2:	c7 44 24 0c a8 6b 10 	movl   $0x106ba8,0xc(%esp)
  1049b9:	00 
  1049ba:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  1049c1:	00 
  1049c2:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  1049c9:	00 
  1049ca:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  1049d1:	e8 f6 c2 ff ff       	call   100ccc <__panic>
    assert(page_ref(p1) == 2);
  1049d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d9:	89 04 24             	mov    %eax,(%esp)
  1049dc:	e8 51 f1 ff ff       	call   103b32 <page_ref>
  1049e1:	83 f8 02             	cmp    $0x2,%eax
  1049e4:	74 24                	je     104a0a <check_pgdir+0x449>
  1049e6:	c7 44 24 0c d4 6b 10 	movl   $0x106bd4,0xc(%esp)
  1049ed:	00 
  1049ee:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  1049f5:	00 
  1049f6:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  1049fd:	00 
  1049fe:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104a05:	e8 c2 c2 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 0);
  104a0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a0d:	89 04 24             	mov    %eax,(%esp)
  104a10:	e8 1d f1 ff ff       	call   103b32 <page_ref>
  104a15:	85 c0                	test   %eax,%eax
  104a17:	74 24                	je     104a3d <check_pgdir+0x47c>
  104a19:	c7 44 24 0c e6 6b 10 	movl   $0x106be6,0xc(%esp)
  104a20:	00 
  104a21:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104a28:	00 
  104a29:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104a30:	00 
  104a31:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104a38:	e8 8f c2 ff ff       	call   100ccc <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a3d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104a42:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a49:	00 
  104a4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a51:	00 
  104a52:	89 04 24             	mov    %eax,(%esp)
  104a55:	e8 8c f9 ff ff       	call   1043e6 <get_pte>
  104a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a61:	75 24                	jne    104a87 <check_pgdir+0x4c6>
  104a63:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  104a6a:	00 
  104a6b:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104a72:	00 
  104a73:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104a7a:	00 
  104a7b:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104a82:	e8 45 c2 ff ff       	call   100ccc <__panic>
    assert(pte2page(*ptep) == p1);
  104a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a8a:	8b 00                	mov    (%eax),%eax
  104a8c:	89 04 24             	mov    %eax,(%esp)
  104a8f:	e8 48 f0 ff ff       	call   103adc <pte2page>
  104a94:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104a97:	74 24                	je     104abd <check_pgdir+0x4fc>
  104a99:	c7 44 24 0c a9 6a 10 	movl   $0x106aa9,0xc(%esp)
  104aa0:	00 
  104aa1:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104aa8:	00 
  104aa9:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104ab0:	00 
  104ab1:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104ab8:	e8 0f c2 ff ff       	call   100ccc <__panic>
    assert((*ptep & PTE_U) == 0);
  104abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ac0:	8b 00                	mov    (%eax),%eax
  104ac2:	83 e0 04             	and    $0x4,%eax
  104ac5:	85 c0                	test   %eax,%eax
  104ac7:	74 24                	je     104aed <check_pgdir+0x52c>
  104ac9:	c7 44 24 0c f8 6b 10 	movl   $0x106bf8,0xc(%esp)
  104ad0:	00 
  104ad1:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104ad8:	00 
  104ad9:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104ae0:	00 
  104ae1:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104ae8:	e8 df c1 ff ff       	call   100ccc <__panic>

    page_remove(boot_pgdir, 0x0);
  104aed:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104af2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104af9:	00 
  104afa:	89 04 24             	mov    %eax,(%esp)
  104afd:	e8 47 f9 ff ff       	call   104449 <page_remove>
    assert(page_ref(p1) == 1);
  104b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b05:	89 04 24             	mov    %eax,(%esp)
  104b08:	e8 25 f0 ff ff       	call   103b32 <page_ref>
  104b0d:	83 f8 01             	cmp    $0x1,%eax
  104b10:	74 24                	je     104b36 <check_pgdir+0x575>
  104b12:	c7 44 24 0c bf 6a 10 	movl   $0x106abf,0xc(%esp)
  104b19:	00 
  104b1a:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104b21:	00 
  104b22:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  104b29:	00 
  104b2a:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104b31:	e8 96 c1 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 0);
  104b36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b39:	89 04 24             	mov    %eax,(%esp)
  104b3c:	e8 f1 ef ff ff       	call   103b32 <page_ref>
  104b41:	85 c0                	test   %eax,%eax
  104b43:	74 24                	je     104b69 <check_pgdir+0x5a8>
  104b45:	c7 44 24 0c e6 6b 10 	movl   $0x106be6,0xc(%esp)
  104b4c:	00 
  104b4d:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104b54:	00 
  104b55:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104b5c:	00 
  104b5d:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104b64:	e8 63 c1 ff ff       	call   100ccc <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104b69:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104b6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b75:	00 
  104b76:	89 04 24             	mov    %eax,(%esp)
  104b79:	e8 cb f8 ff ff       	call   104449 <page_remove>
    assert(page_ref(p1) == 0);
  104b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b81:	89 04 24             	mov    %eax,(%esp)
  104b84:	e8 a9 ef ff ff       	call   103b32 <page_ref>
  104b89:	85 c0                	test   %eax,%eax
  104b8b:	74 24                	je     104bb1 <check_pgdir+0x5f0>
  104b8d:	c7 44 24 0c 0d 6c 10 	movl   $0x106c0d,0xc(%esp)
  104b94:	00 
  104b95:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104b9c:	00 
  104b9d:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104ba4:	00 
  104ba5:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104bac:	e8 1b c1 ff ff       	call   100ccc <__panic>
    assert(page_ref(p2) == 0);
  104bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bb4:	89 04 24             	mov    %eax,(%esp)
  104bb7:	e8 76 ef ff ff       	call   103b32 <page_ref>
  104bbc:	85 c0                	test   %eax,%eax
  104bbe:	74 24                	je     104be4 <check_pgdir+0x623>
  104bc0:	c7 44 24 0c e6 6b 10 	movl   $0x106be6,0xc(%esp)
  104bc7:	00 
  104bc8:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104bcf:	00 
  104bd0:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104bd7:	00 
  104bd8:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104bdf:	e8 e8 c0 ff ff       	call   100ccc <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104be4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104be9:	8b 00                	mov    (%eax),%eax
  104beb:	89 04 24             	mov    %eax,(%esp)
  104bee:	e8 27 ef ff ff       	call   103b1a <pde2page>
  104bf3:	89 04 24             	mov    %eax,(%esp)
  104bf6:	e8 37 ef ff ff       	call   103b32 <page_ref>
  104bfb:	83 f8 01             	cmp    $0x1,%eax
  104bfe:	74 24                	je     104c24 <check_pgdir+0x663>
  104c00:	c7 44 24 0c 20 6c 10 	movl   $0x106c20,0xc(%esp)
  104c07:	00 
  104c08:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104c0f:	00 
  104c10:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104c17:	00 
  104c18:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104c1f:	e8 a8 c0 ff ff       	call   100ccc <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104c24:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104c29:	8b 00                	mov    (%eax),%eax
  104c2b:	89 04 24             	mov    %eax,(%esp)
  104c2e:	e8 e7 ee ff ff       	call   103b1a <pde2page>
  104c33:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c3a:	00 
  104c3b:	89 04 24             	mov    %eax,(%esp)
  104c3e:	e8 1f f1 ff ff       	call   103d62 <free_pages>
    boot_pgdir[0] = 0;
  104c43:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104c48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104c4e:	c7 04 24 47 6c 10 00 	movl   $0x106c47,(%esp)
  104c55:	e8 ee b6 ff ff       	call   100348 <cprintf>
}
  104c5a:	c9                   	leave  
  104c5b:	c3                   	ret    

00104c5c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104c5c:	55                   	push   %ebp
  104c5d:	89 e5                	mov    %esp,%ebp
  104c5f:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104c69:	e9 ca 00 00 00       	jmp    104d38 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c77:	c1 e8 0c             	shr    $0xc,%eax
  104c7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c7d:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104c82:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104c85:	72 23                	jb     104caa <check_boot_pgdir+0x4e>
  104c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104c8e:	c7 44 24 08 8c 68 10 	movl   $0x10688c,0x8(%esp)
  104c95:	00 
  104c96:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104c9d:	00 
  104c9e:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104ca5:	e8 22 c0 ff ff       	call   100ccc <__panic>
  104caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cad:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104cb2:	89 c2                	mov    %eax,%edx
  104cb4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104cb9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104cc0:	00 
  104cc1:	89 54 24 04          	mov    %edx,0x4(%esp)
  104cc5:	89 04 24             	mov    %eax,(%esp)
  104cc8:	e8 19 f7 ff ff       	call   1043e6 <get_pte>
  104ccd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104cd0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104cd4:	75 24                	jne    104cfa <check_boot_pgdir+0x9e>
  104cd6:	c7 44 24 0c 64 6c 10 	movl   $0x106c64,0xc(%esp)
  104cdd:	00 
  104cde:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104ce5:	00 
  104ce6:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104ced:	00 
  104cee:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104cf5:	e8 d2 bf ff ff       	call   100ccc <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104cfd:	8b 00                	mov    (%eax),%eax
  104cff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104d04:	89 c2                	mov    %eax,%edx
  104d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d09:	39 c2                	cmp    %eax,%edx
  104d0b:	74 24                	je     104d31 <check_boot_pgdir+0xd5>
  104d0d:	c7 44 24 0c a1 6c 10 	movl   $0x106ca1,0xc(%esp)
  104d14:	00 
  104d15:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104d1c:	00 
  104d1d:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104d24:	00 
  104d25:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104d2c:	e8 9b bf ff ff       	call   100ccc <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104d31:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d3b:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104d40:	39 c2                	cmp    %eax,%edx
  104d42:	0f 82 26 ff ff ff    	jb     104c6e <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104d48:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104d4d:	05 ac 0f 00 00       	add    $0xfac,%eax
  104d52:	8b 00                	mov    (%eax),%eax
  104d54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104d59:	89 c2                	mov    %eax,%edx
  104d5b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104d60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104d63:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104d6a:	77 23                	ja     104d8f <check_boot_pgdir+0x133>
  104d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d73:	c7 44 24 08 30 69 10 	movl   $0x106930,0x8(%esp)
  104d7a:	00 
  104d7b:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104d82:	00 
  104d83:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104d8a:	e8 3d bf ff ff       	call   100ccc <__panic>
  104d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d92:	05 00 00 00 40       	add    $0x40000000,%eax
  104d97:	39 c2                	cmp    %eax,%edx
  104d99:	74 24                	je     104dbf <check_boot_pgdir+0x163>
  104d9b:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  104da2:	00 
  104da3:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104daa:	00 
  104dab:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104db2:	00 
  104db3:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104dba:	e8 0d bf ff ff       	call   100ccc <__panic>

    assert(boot_pgdir[0] == 0);
  104dbf:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104dc4:	8b 00                	mov    (%eax),%eax
  104dc6:	85 c0                	test   %eax,%eax
  104dc8:	74 24                	je     104dee <check_boot_pgdir+0x192>
  104dca:	c7 44 24 0c ec 6c 10 	movl   $0x106cec,0xc(%esp)
  104dd1:	00 
  104dd2:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104dd9:	00 
  104dda:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104de1:	00 
  104de2:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104de9:	e8 de be ff ff       	call   100ccc <__panic>

    struct Page *p;
    p = alloc_page();
  104dee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104df5:	e8 30 ef ff ff       	call   103d2a <alloc_pages>
  104dfa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104dfd:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e02:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104e09:	00 
  104e0a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104e11:	00 
  104e12:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104e15:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e19:	89 04 24             	mov    %eax,(%esp)
  104e1c:	e8 6c f6 ff ff       	call   10448d <page_insert>
  104e21:	85 c0                	test   %eax,%eax
  104e23:	74 24                	je     104e49 <check_boot_pgdir+0x1ed>
  104e25:	c7 44 24 0c 00 6d 10 	movl   $0x106d00,0xc(%esp)
  104e2c:	00 
  104e2d:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104e34:	00 
  104e35:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104e3c:	00 
  104e3d:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104e44:	e8 83 be ff ff       	call   100ccc <__panic>
    assert(page_ref(p) == 1);
  104e49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104e4c:	89 04 24             	mov    %eax,(%esp)
  104e4f:	e8 de ec ff ff       	call   103b32 <page_ref>
  104e54:	83 f8 01             	cmp    $0x1,%eax
  104e57:	74 24                	je     104e7d <check_boot_pgdir+0x221>
  104e59:	c7 44 24 0c 2e 6d 10 	movl   $0x106d2e,0xc(%esp)
  104e60:	00 
  104e61:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104e68:	00 
  104e69:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104e70:	00 
  104e71:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104e78:	e8 4f be ff ff       	call   100ccc <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104e7d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e82:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104e89:	00 
  104e8a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104e91:	00 
  104e92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104e95:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e99:	89 04 24             	mov    %eax,(%esp)
  104e9c:	e8 ec f5 ff ff       	call   10448d <page_insert>
  104ea1:	85 c0                	test   %eax,%eax
  104ea3:	74 24                	je     104ec9 <check_boot_pgdir+0x26d>
  104ea5:	c7 44 24 0c 40 6d 10 	movl   $0x106d40,0xc(%esp)
  104eac:	00 
  104ead:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104eb4:	00 
  104eb5:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104ebc:	00 
  104ebd:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104ec4:	e8 03 be ff ff       	call   100ccc <__panic>
    assert(page_ref(p) == 2);
  104ec9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104ecc:	89 04 24             	mov    %eax,(%esp)
  104ecf:	e8 5e ec ff ff       	call   103b32 <page_ref>
  104ed4:	83 f8 02             	cmp    $0x2,%eax
  104ed7:	74 24                	je     104efd <check_boot_pgdir+0x2a1>
  104ed9:	c7 44 24 0c 77 6d 10 	movl   $0x106d77,0xc(%esp)
  104ee0:	00 
  104ee1:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104ee8:	00 
  104ee9:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104ef0:	00 
  104ef1:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104ef8:	e8 cf bd ff ff       	call   100ccc <__panic>

    const char *str = "ucore: Hello world!!";
  104efd:	c7 45 dc 88 6d 10 00 	movl   $0x106d88,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104f04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104f07:	89 44 24 04          	mov    %eax,0x4(%esp)
  104f0b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f12:	e8 19 0a 00 00       	call   105930 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104f17:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104f1e:	00 
  104f1f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f26:	e8 7e 0a 00 00       	call   1059a9 <strcmp>
  104f2b:	85 c0                	test   %eax,%eax
  104f2d:	74 24                	je     104f53 <check_boot_pgdir+0x2f7>
  104f2f:	c7 44 24 0c a0 6d 10 	movl   $0x106da0,0xc(%esp)
  104f36:	00 
  104f37:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104f3e:	00 
  104f3f:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104f46:	00 
  104f47:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104f4e:	e8 79 bd ff ff       	call   100ccc <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104f53:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f56:	89 04 24             	mov    %eax,(%esp)
  104f59:	e8 2a eb ff ff       	call   103a88 <page2kva>
  104f5e:	05 00 01 00 00       	add    $0x100,%eax
  104f63:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104f66:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104f6d:	e8 66 09 00 00       	call   1058d8 <strlen>
  104f72:	85 c0                	test   %eax,%eax
  104f74:	74 24                	je     104f9a <check_boot_pgdir+0x33e>
  104f76:	c7 44 24 0c d8 6d 10 	movl   $0x106dd8,0xc(%esp)
  104f7d:	00 
  104f7e:	c7 44 24 08 79 69 10 	movl   $0x106979,0x8(%esp)
  104f85:	00 
  104f86:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104f8d:	00 
  104f8e:	c7 04 24 54 69 10 00 	movl   $0x106954,(%esp)
  104f95:	e8 32 bd ff ff       	call   100ccc <__panic>

    free_page(p);
  104f9a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fa1:	00 
  104fa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fa5:	89 04 24             	mov    %eax,(%esp)
  104fa8:	e8 b5 ed ff ff       	call   103d62 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  104fad:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104fb2:	8b 00                	mov    (%eax),%eax
  104fb4:	89 04 24             	mov    %eax,(%esp)
  104fb7:	e8 5e eb ff ff       	call   103b1a <pde2page>
  104fbc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fc3:	00 
  104fc4:	89 04 24             	mov    %eax,(%esp)
  104fc7:	e8 96 ed ff ff       	call   103d62 <free_pages>
    boot_pgdir[0] = 0;
  104fcc:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104fd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104fd7:	c7 04 24 fc 6d 10 00 	movl   $0x106dfc,(%esp)
  104fde:	e8 65 b3 ff ff       	call   100348 <cprintf>
}
  104fe3:	c9                   	leave  
  104fe4:	c3                   	ret    

00104fe5 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104fe5:	55                   	push   %ebp
  104fe6:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  104feb:	83 e0 04             	and    $0x4,%eax
  104fee:	85 c0                	test   %eax,%eax
  104ff0:	74 07                	je     104ff9 <perm2str+0x14>
  104ff2:	b8 75 00 00 00       	mov    $0x75,%eax
  104ff7:	eb 05                	jmp    104ffe <perm2str+0x19>
  104ff9:	b8 2d 00 00 00       	mov    $0x2d,%eax
  104ffe:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  105003:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10500a:	8b 45 08             	mov    0x8(%ebp),%eax
  10500d:	83 e0 02             	and    $0x2,%eax
  105010:	85 c0                	test   %eax,%eax
  105012:	74 07                	je     10501b <perm2str+0x36>
  105014:	b8 77 00 00 00       	mov    $0x77,%eax
  105019:	eb 05                	jmp    105020 <perm2str+0x3b>
  10501b:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105020:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  105025:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  10502c:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  105031:	5d                   	pop    %ebp
  105032:	c3                   	ret    

00105033 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105033:	55                   	push   %ebp
  105034:	89 e5                	mov    %esp,%ebp
  105036:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  105039:	8b 45 10             	mov    0x10(%ebp),%eax
  10503c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10503f:	72 0a                	jb     10504b <get_pgtable_items+0x18>
        return 0;
  105041:	b8 00 00 00 00       	mov    $0x0,%eax
  105046:	e9 9c 00 00 00       	jmp    1050e7 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  10504b:	eb 04                	jmp    105051 <get_pgtable_items+0x1e>
        start ++;
  10504d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105051:	8b 45 10             	mov    0x10(%ebp),%eax
  105054:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105057:	73 18                	jae    105071 <get_pgtable_items+0x3e>
  105059:	8b 45 10             	mov    0x10(%ebp),%eax
  10505c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105063:	8b 45 14             	mov    0x14(%ebp),%eax
  105066:	01 d0                	add    %edx,%eax
  105068:	8b 00                	mov    (%eax),%eax
  10506a:	83 e0 01             	and    $0x1,%eax
  10506d:	85 c0                	test   %eax,%eax
  10506f:	74 dc                	je     10504d <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105071:	8b 45 10             	mov    0x10(%ebp),%eax
  105074:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105077:	73 69                	jae    1050e2 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  105079:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10507d:	74 08                	je     105087 <get_pgtable_items+0x54>
            *left_store = start;
  10507f:	8b 45 18             	mov    0x18(%ebp),%eax
  105082:	8b 55 10             	mov    0x10(%ebp),%edx
  105085:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105087:	8b 45 10             	mov    0x10(%ebp),%eax
  10508a:	8d 50 01             	lea    0x1(%eax),%edx
  10508d:	89 55 10             	mov    %edx,0x10(%ebp)
  105090:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105097:	8b 45 14             	mov    0x14(%ebp),%eax
  10509a:	01 d0                	add    %edx,%eax
  10509c:	8b 00                	mov    (%eax),%eax
  10509e:	83 e0 07             	and    $0x7,%eax
  1050a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1050a4:	eb 04                	jmp    1050aa <get_pgtable_items+0x77>
            start ++;
  1050a6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1050aa:	8b 45 10             	mov    0x10(%ebp),%eax
  1050ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1050b0:	73 1d                	jae    1050cf <get_pgtable_items+0x9c>
  1050b2:	8b 45 10             	mov    0x10(%ebp),%eax
  1050b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1050bc:	8b 45 14             	mov    0x14(%ebp),%eax
  1050bf:	01 d0                	add    %edx,%eax
  1050c1:	8b 00                	mov    (%eax),%eax
  1050c3:	83 e0 07             	and    $0x7,%eax
  1050c6:	89 c2                	mov    %eax,%edx
  1050c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1050cb:	39 c2                	cmp    %eax,%edx
  1050cd:	74 d7                	je     1050a6 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1050cf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1050d3:	74 08                	je     1050dd <get_pgtable_items+0xaa>
            *right_store = start;
  1050d5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1050d8:	8b 55 10             	mov    0x10(%ebp),%edx
  1050db:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1050dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1050e0:	eb 05                	jmp    1050e7 <get_pgtable_items+0xb4>
    }
    return 0;
  1050e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1050e7:	c9                   	leave  
  1050e8:	c3                   	ret    

001050e9 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1050e9:	55                   	push   %ebp
  1050ea:	89 e5                	mov    %esp,%ebp
  1050ec:	57                   	push   %edi
  1050ed:	56                   	push   %esi
  1050ee:	53                   	push   %ebx
  1050ef:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1050f2:	c7 04 24 1c 6e 10 00 	movl   $0x106e1c,(%esp)
  1050f9:	e8 4a b2 ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
  1050fe:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105105:	e9 fa 00 00 00       	jmp    105204 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10510a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10510d:	89 04 24             	mov    %eax,(%esp)
  105110:	e8 d0 fe ff ff       	call   104fe5 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105115:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105118:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10511b:	29 d1                	sub    %edx,%ecx
  10511d:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10511f:	89 d6                	mov    %edx,%esi
  105121:	c1 e6 16             	shl    $0x16,%esi
  105124:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105127:	89 d3                	mov    %edx,%ebx
  105129:	c1 e3 16             	shl    $0x16,%ebx
  10512c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10512f:	89 d1                	mov    %edx,%ecx
  105131:	c1 e1 16             	shl    $0x16,%ecx
  105134:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105137:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10513a:	29 d7                	sub    %edx,%edi
  10513c:	89 fa                	mov    %edi,%edx
  10513e:	89 44 24 14          	mov    %eax,0x14(%esp)
  105142:	89 74 24 10          	mov    %esi,0x10(%esp)
  105146:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10514a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10514e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105152:	c7 04 24 4d 6e 10 00 	movl   $0x106e4d,(%esp)
  105159:	e8 ea b1 ff ff       	call   100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  10515e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105161:	c1 e0 0a             	shl    $0xa,%eax
  105164:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105167:	eb 54                	jmp    1051bd <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10516c:	89 04 24             	mov    %eax,(%esp)
  10516f:	e8 71 fe ff ff       	call   104fe5 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105174:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105177:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10517a:	29 d1                	sub    %edx,%ecx
  10517c:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10517e:	89 d6                	mov    %edx,%esi
  105180:	c1 e6 0c             	shl    $0xc,%esi
  105183:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105186:	89 d3                	mov    %edx,%ebx
  105188:	c1 e3 0c             	shl    $0xc,%ebx
  10518b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10518e:	c1 e2 0c             	shl    $0xc,%edx
  105191:	89 d1                	mov    %edx,%ecx
  105193:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105196:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105199:	29 d7                	sub    %edx,%edi
  10519b:	89 fa                	mov    %edi,%edx
  10519d:	89 44 24 14          	mov    %eax,0x14(%esp)
  1051a1:	89 74 24 10          	mov    %esi,0x10(%esp)
  1051a5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1051a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1051ad:	89 54 24 04          	mov    %edx,0x4(%esp)
  1051b1:	c7 04 24 6c 6e 10 00 	movl   $0x106e6c,(%esp)
  1051b8:	e8 8b b1 ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1051bd:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1051c2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1051c5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1051c8:	89 ce                	mov    %ecx,%esi
  1051ca:	c1 e6 0a             	shl    $0xa,%esi
  1051cd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1051d0:	89 cb                	mov    %ecx,%ebx
  1051d2:	c1 e3 0a             	shl    $0xa,%ebx
  1051d5:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1051d8:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1051dc:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1051df:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1051e3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1051e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1051eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  1051ef:	89 1c 24             	mov    %ebx,(%esp)
  1051f2:	e8 3c fe ff ff       	call   105033 <get_pgtable_items>
  1051f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1051fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1051fe:	0f 85 65 ff ff ff    	jne    105169 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105204:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10520c:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10520f:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105213:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105216:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10521a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10521e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105222:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105229:	00 
  10522a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105231:	e8 fd fd ff ff       	call   105033 <get_pgtable_items>
  105236:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105239:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10523d:	0f 85 c7 fe ff ff    	jne    10510a <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105243:	c7 04 24 90 6e 10 00 	movl   $0x106e90,(%esp)
  10524a:	e8 f9 b0 ff ff       	call   100348 <cprintf>
}
  10524f:	83 c4 4c             	add    $0x4c,%esp
  105252:	5b                   	pop    %ebx
  105253:	5e                   	pop    %esi
  105254:	5f                   	pop    %edi
  105255:	5d                   	pop    %ebp
  105256:	c3                   	ret    

00105257 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105257:	55                   	push   %ebp
  105258:	89 e5                	mov    %esp,%ebp
  10525a:	83 ec 58             	sub    $0x58,%esp
  10525d:	8b 45 10             	mov    0x10(%ebp),%eax
  105260:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105263:	8b 45 14             	mov    0x14(%ebp),%eax
  105266:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105269:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10526c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10526f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105272:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105275:	8b 45 18             	mov    0x18(%ebp),%eax
  105278:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10527b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10527e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105281:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105284:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10528a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10528d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105291:	74 1c                	je     1052af <printnum+0x58>
  105293:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105296:	ba 00 00 00 00       	mov    $0x0,%edx
  10529b:	f7 75 e4             	divl   -0x1c(%ebp)
  10529e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1052a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1052a4:	ba 00 00 00 00       	mov    $0x0,%edx
  1052a9:	f7 75 e4             	divl   -0x1c(%ebp)
  1052ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1052af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1052b5:	f7 75 e4             	divl   -0x1c(%ebp)
  1052b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1052bb:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1052be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1052c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1052c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1052ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052cd:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1052d0:	8b 45 18             	mov    0x18(%ebp),%eax
  1052d3:	ba 00 00 00 00       	mov    $0x0,%edx
  1052d8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1052db:	77 56                	ja     105333 <printnum+0xdc>
  1052dd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1052e0:	72 05                	jb     1052e7 <printnum+0x90>
  1052e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1052e5:	77 4c                	ja     105333 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1052e7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052ea:	8d 50 ff             	lea    -0x1(%eax),%edx
  1052ed:	8b 45 20             	mov    0x20(%ebp),%eax
  1052f0:	89 44 24 18          	mov    %eax,0x18(%esp)
  1052f4:	89 54 24 14          	mov    %edx,0x14(%esp)
  1052f8:	8b 45 18             	mov    0x18(%ebp),%eax
  1052fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  1052ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105302:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105305:	89 44 24 08          	mov    %eax,0x8(%esp)
  105309:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10530d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105310:	89 44 24 04          	mov    %eax,0x4(%esp)
  105314:	8b 45 08             	mov    0x8(%ebp),%eax
  105317:	89 04 24             	mov    %eax,(%esp)
  10531a:	e8 38 ff ff ff       	call   105257 <printnum>
  10531f:	eb 1c                	jmp    10533d <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105321:	8b 45 0c             	mov    0xc(%ebp),%eax
  105324:	89 44 24 04          	mov    %eax,0x4(%esp)
  105328:	8b 45 20             	mov    0x20(%ebp),%eax
  10532b:	89 04 24             	mov    %eax,(%esp)
  10532e:	8b 45 08             	mov    0x8(%ebp),%eax
  105331:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105333:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105337:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10533b:	7f e4                	jg     105321 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10533d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105340:	05 44 6f 10 00       	add    $0x106f44,%eax
  105345:	0f b6 00             	movzbl (%eax),%eax
  105348:	0f be c0             	movsbl %al,%eax
  10534b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10534e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105352:	89 04 24             	mov    %eax,(%esp)
  105355:	8b 45 08             	mov    0x8(%ebp),%eax
  105358:	ff d0                	call   *%eax
}
  10535a:	c9                   	leave  
  10535b:	c3                   	ret    

0010535c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10535c:	55                   	push   %ebp
  10535d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10535f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105363:	7e 14                	jle    105379 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105365:	8b 45 08             	mov    0x8(%ebp),%eax
  105368:	8b 00                	mov    (%eax),%eax
  10536a:	8d 48 08             	lea    0x8(%eax),%ecx
  10536d:	8b 55 08             	mov    0x8(%ebp),%edx
  105370:	89 0a                	mov    %ecx,(%edx)
  105372:	8b 50 04             	mov    0x4(%eax),%edx
  105375:	8b 00                	mov    (%eax),%eax
  105377:	eb 30                	jmp    1053a9 <getuint+0x4d>
    }
    else if (lflag) {
  105379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10537d:	74 16                	je     105395 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10537f:	8b 45 08             	mov    0x8(%ebp),%eax
  105382:	8b 00                	mov    (%eax),%eax
  105384:	8d 48 04             	lea    0x4(%eax),%ecx
  105387:	8b 55 08             	mov    0x8(%ebp),%edx
  10538a:	89 0a                	mov    %ecx,(%edx)
  10538c:	8b 00                	mov    (%eax),%eax
  10538e:	ba 00 00 00 00       	mov    $0x0,%edx
  105393:	eb 14                	jmp    1053a9 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105395:	8b 45 08             	mov    0x8(%ebp),%eax
  105398:	8b 00                	mov    (%eax),%eax
  10539a:	8d 48 04             	lea    0x4(%eax),%ecx
  10539d:	8b 55 08             	mov    0x8(%ebp),%edx
  1053a0:	89 0a                	mov    %ecx,(%edx)
  1053a2:	8b 00                	mov    (%eax),%eax
  1053a4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1053a9:	5d                   	pop    %ebp
  1053aa:	c3                   	ret    

001053ab <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1053ab:	55                   	push   %ebp
  1053ac:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1053ae:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1053b2:	7e 14                	jle    1053c8 <getint+0x1d>
        return va_arg(*ap, long long);
  1053b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1053b7:	8b 00                	mov    (%eax),%eax
  1053b9:	8d 48 08             	lea    0x8(%eax),%ecx
  1053bc:	8b 55 08             	mov    0x8(%ebp),%edx
  1053bf:	89 0a                	mov    %ecx,(%edx)
  1053c1:	8b 50 04             	mov    0x4(%eax),%edx
  1053c4:	8b 00                	mov    (%eax),%eax
  1053c6:	eb 28                	jmp    1053f0 <getint+0x45>
    }
    else if (lflag) {
  1053c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1053cc:	74 12                	je     1053e0 <getint+0x35>
        return va_arg(*ap, long);
  1053ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1053d1:	8b 00                	mov    (%eax),%eax
  1053d3:	8d 48 04             	lea    0x4(%eax),%ecx
  1053d6:	8b 55 08             	mov    0x8(%ebp),%edx
  1053d9:	89 0a                	mov    %ecx,(%edx)
  1053db:	8b 00                	mov    (%eax),%eax
  1053dd:	99                   	cltd   
  1053de:	eb 10                	jmp    1053f0 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1053e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1053e3:	8b 00                	mov    (%eax),%eax
  1053e5:	8d 48 04             	lea    0x4(%eax),%ecx
  1053e8:	8b 55 08             	mov    0x8(%ebp),%edx
  1053eb:	89 0a                	mov    %ecx,(%edx)
  1053ed:	8b 00                	mov    (%eax),%eax
  1053ef:	99                   	cltd   
    }
}
  1053f0:	5d                   	pop    %ebp
  1053f1:	c3                   	ret    

001053f2 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1053f2:	55                   	push   %ebp
  1053f3:	89 e5                	mov    %esp,%ebp
  1053f5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1053f8:	8d 45 14             	lea    0x14(%ebp),%eax
  1053fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1053fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105401:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105405:	8b 45 10             	mov    0x10(%ebp),%eax
  105408:	89 44 24 08          	mov    %eax,0x8(%esp)
  10540c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10540f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105413:	8b 45 08             	mov    0x8(%ebp),%eax
  105416:	89 04 24             	mov    %eax,(%esp)
  105419:	e8 02 00 00 00       	call   105420 <vprintfmt>
    va_end(ap);
}
  10541e:	c9                   	leave  
  10541f:	c3                   	ret    

00105420 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105420:	55                   	push   %ebp
  105421:	89 e5                	mov    %esp,%ebp
  105423:	56                   	push   %esi
  105424:	53                   	push   %ebx
  105425:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105428:	eb 18                	jmp    105442 <vprintfmt+0x22>
            if (ch == '\0') {
  10542a:	85 db                	test   %ebx,%ebx
  10542c:	75 05                	jne    105433 <vprintfmt+0x13>
                return;
  10542e:	e9 d1 03 00 00       	jmp    105804 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105433:	8b 45 0c             	mov    0xc(%ebp),%eax
  105436:	89 44 24 04          	mov    %eax,0x4(%esp)
  10543a:	89 1c 24             	mov    %ebx,(%esp)
  10543d:	8b 45 08             	mov    0x8(%ebp),%eax
  105440:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105442:	8b 45 10             	mov    0x10(%ebp),%eax
  105445:	8d 50 01             	lea    0x1(%eax),%edx
  105448:	89 55 10             	mov    %edx,0x10(%ebp)
  10544b:	0f b6 00             	movzbl (%eax),%eax
  10544e:	0f b6 d8             	movzbl %al,%ebx
  105451:	83 fb 25             	cmp    $0x25,%ebx
  105454:	75 d4                	jne    10542a <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105456:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10545a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105464:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105467:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10546e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105471:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105474:	8b 45 10             	mov    0x10(%ebp),%eax
  105477:	8d 50 01             	lea    0x1(%eax),%edx
  10547a:	89 55 10             	mov    %edx,0x10(%ebp)
  10547d:	0f b6 00             	movzbl (%eax),%eax
  105480:	0f b6 d8             	movzbl %al,%ebx
  105483:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105486:	83 f8 55             	cmp    $0x55,%eax
  105489:	0f 87 44 03 00 00    	ja     1057d3 <vprintfmt+0x3b3>
  10548f:	8b 04 85 68 6f 10 00 	mov    0x106f68(,%eax,4),%eax
  105496:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105498:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10549c:	eb d6                	jmp    105474 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10549e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1054a2:	eb d0                	jmp    105474 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1054a4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1054ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1054ae:	89 d0                	mov    %edx,%eax
  1054b0:	c1 e0 02             	shl    $0x2,%eax
  1054b3:	01 d0                	add    %edx,%eax
  1054b5:	01 c0                	add    %eax,%eax
  1054b7:	01 d8                	add    %ebx,%eax
  1054b9:	83 e8 30             	sub    $0x30,%eax
  1054bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1054bf:	8b 45 10             	mov    0x10(%ebp),%eax
  1054c2:	0f b6 00             	movzbl (%eax),%eax
  1054c5:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1054c8:	83 fb 2f             	cmp    $0x2f,%ebx
  1054cb:	7e 0b                	jle    1054d8 <vprintfmt+0xb8>
  1054cd:	83 fb 39             	cmp    $0x39,%ebx
  1054d0:	7f 06                	jg     1054d8 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1054d2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1054d6:	eb d3                	jmp    1054ab <vprintfmt+0x8b>
            goto process_precision;
  1054d8:	eb 33                	jmp    10550d <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1054da:	8b 45 14             	mov    0x14(%ebp),%eax
  1054dd:	8d 50 04             	lea    0x4(%eax),%edx
  1054e0:	89 55 14             	mov    %edx,0x14(%ebp)
  1054e3:	8b 00                	mov    (%eax),%eax
  1054e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1054e8:	eb 23                	jmp    10550d <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1054ea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1054ee:	79 0c                	jns    1054fc <vprintfmt+0xdc>
                width = 0;
  1054f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1054f7:	e9 78 ff ff ff       	jmp    105474 <vprintfmt+0x54>
  1054fc:	e9 73 ff ff ff       	jmp    105474 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105501:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105508:	e9 67 ff ff ff       	jmp    105474 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  10550d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105511:	79 12                	jns    105525 <vprintfmt+0x105>
                width = precision, precision = -1;
  105513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105516:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105519:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105520:	e9 4f ff ff ff       	jmp    105474 <vprintfmt+0x54>
  105525:	e9 4a ff ff ff       	jmp    105474 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10552a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10552e:	e9 41 ff ff ff       	jmp    105474 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105533:	8b 45 14             	mov    0x14(%ebp),%eax
  105536:	8d 50 04             	lea    0x4(%eax),%edx
  105539:	89 55 14             	mov    %edx,0x14(%ebp)
  10553c:	8b 00                	mov    (%eax),%eax
  10553e:	8b 55 0c             	mov    0xc(%ebp),%edx
  105541:	89 54 24 04          	mov    %edx,0x4(%esp)
  105545:	89 04 24             	mov    %eax,(%esp)
  105548:	8b 45 08             	mov    0x8(%ebp),%eax
  10554b:	ff d0                	call   *%eax
            break;
  10554d:	e9 ac 02 00 00       	jmp    1057fe <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105552:	8b 45 14             	mov    0x14(%ebp),%eax
  105555:	8d 50 04             	lea    0x4(%eax),%edx
  105558:	89 55 14             	mov    %edx,0x14(%ebp)
  10555b:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10555d:	85 db                	test   %ebx,%ebx
  10555f:	79 02                	jns    105563 <vprintfmt+0x143>
                err = -err;
  105561:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105563:	83 fb 06             	cmp    $0x6,%ebx
  105566:	7f 0b                	jg     105573 <vprintfmt+0x153>
  105568:	8b 34 9d 28 6f 10 00 	mov    0x106f28(,%ebx,4),%esi
  10556f:	85 f6                	test   %esi,%esi
  105571:	75 23                	jne    105596 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105573:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105577:	c7 44 24 08 55 6f 10 	movl   $0x106f55,0x8(%esp)
  10557e:	00 
  10557f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105582:	89 44 24 04          	mov    %eax,0x4(%esp)
  105586:	8b 45 08             	mov    0x8(%ebp),%eax
  105589:	89 04 24             	mov    %eax,(%esp)
  10558c:	e8 61 fe ff ff       	call   1053f2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105591:	e9 68 02 00 00       	jmp    1057fe <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105596:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10559a:	c7 44 24 08 5e 6f 10 	movl   $0x106f5e,0x8(%esp)
  1055a1:	00 
  1055a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055ac:	89 04 24             	mov    %eax,(%esp)
  1055af:	e8 3e fe ff ff       	call   1053f2 <printfmt>
            }
            break;
  1055b4:	e9 45 02 00 00       	jmp    1057fe <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1055b9:	8b 45 14             	mov    0x14(%ebp),%eax
  1055bc:	8d 50 04             	lea    0x4(%eax),%edx
  1055bf:	89 55 14             	mov    %edx,0x14(%ebp)
  1055c2:	8b 30                	mov    (%eax),%esi
  1055c4:	85 f6                	test   %esi,%esi
  1055c6:	75 05                	jne    1055cd <vprintfmt+0x1ad>
                p = "(null)";
  1055c8:	be 61 6f 10 00       	mov    $0x106f61,%esi
            }
            if (width > 0 && padc != '-') {
  1055cd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1055d1:	7e 3e                	jle    105611 <vprintfmt+0x1f1>
  1055d3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1055d7:	74 38                	je     105611 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1055d9:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1055dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055e3:	89 34 24             	mov    %esi,(%esp)
  1055e6:	e8 15 03 00 00       	call   105900 <strnlen>
  1055eb:	29 c3                	sub    %eax,%ebx
  1055ed:	89 d8                	mov    %ebx,%eax
  1055ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055f2:	eb 17                	jmp    10560b <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1055f4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1055f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1055fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055ff:	89 04 24             	mov    %eax,(%esp)
  105602:	8b 45 08             	mov    0x8(%ebp),%eax
  105605:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105607:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10560b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10560f:	7f e3                	jg     1055f4 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105611:	eb 38                	jmp    10564b <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105613:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105617:	74 1f                	je     105638 <vprintfmt+0x218>
  105619:	83 fb 1f             	cmp    $0x1f,%ebx
  10561c:	7e 05                	jle    105623 <vprintfmt+0x203>
  10561e:	83 fb 7e             	cmp    $0x7e,%ebx
  105621:	7e 15                	jle    105638 <vprintfmt+0x218>
                    putch('?', putdat);
  105623:	8b 45 0c             	mov    0xc(%ebp),%eax
  105626:	89 44 24 04          	mov    %eax,0x4(%esp)
  10562a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105631:	8b 45 08             	mov    0x8(%ebp),%eax
  105634:	ff d0                	call   *%eax
  105636:	eb 0f                	jmp    105647 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105638:	8b 45 0c             	mov    0xc(%ebp),%eax
  10563b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10563f:	89 1c 24             	mov    %ebx,(%esp)
  105642:	8b 45 08             	mov    0x8(%ebp),%eax
  105645:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105647:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10564b:	89 f0                	mov    %esi,%eax
  10564d:	8d 70 01             	lea    0x1(%eax),%esi
  105650:	0f b6 00             	movzbl (%eax),%eax
  105653:	0f be d8             	movsbl %al,%ebx
  105656:	85 db                	test   %ebx,%ebx
  105658:	74 10                	je     10566a <vprintfmt+0x24a>
  10565a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10565e:	78 b3                	js     105613 <vprintfmt+0x1f3>
  105660:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105664:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105668:	79 a9                	jns    105613 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10566a:	eb 17                	jmp    105683 <vprintfmt+0x263>
                putch(' ', putdat);
  10566c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10566f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105673:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10567a:	8b 45 08             	mov    0x8(%ebp),%eax
  10567d:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10567f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105683:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105687:	7f e3                	jg     10566c <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105689:	e9 70 01 00 00       	jmp    1057fe <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10568e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105691:	89 44 24 04          	mov    %eax,0x4(%esp)
  105695:	8d 45 14             	lea    0x14(%ebp),%eax
  105698:	89 04 24             	mov    %eax,(%esp)
  10569b:	e8 0b fd ff ff       	call   1053ab <getint>
  1056a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1056a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056ac:	85 d2                	test   %edx,%edx
  1056ae:	79 26                	jns    1056d6 <vprintfmt+0x2b6>
                putch('-', putdat);
  1056b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056b7:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1056be:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c1:	ff d0                	call   *%eax
                num = -(long long)num;
  1056c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1056c9:	f7 d8                	neg    %eax
  1056cb:	83 d2 00             	adc    $0x0,%edx
  1056ce:	f7 da                	neg    %edx
  1056d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1056d6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1056dd:	e9 a8 00 00 00       	jmp    10578a <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1056e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1056e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056e9:	8d 45 14             	lea    0x14(%ebp),%eax
  1056ec:	89 04 24             	mov    %eax,(%esp)
  1056ef:	e8 68 fc ff ff       	call   10535c <getuint>
  1056f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1056f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1056fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105701:	e9 84 00 00 00       	jmp    10578a <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105706:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105709:	89 44 24 04          	mov    %eax,0x4(%esp)
  10570d:	8d 45 14             	lea    0x14(%ebp),%eax
  105710:	89 04 24             	mov    %eax,(%esp)
  105713:	e8 44 fc ff ff       	call   10535c <getuint>
  105718:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10571b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10571e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105725:	eb 63                	jmp    10578a <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105727:	8b 45 0c             	mov    0xc(%ebp),%eax
  10572a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10572e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105735:	8b 45 08             	mov    0x8(%ebp),%eax
  105738:	ff d0                	call   *%eax
            putch('x', putdat);
  10573a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10573d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105741:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105748:	8b 45 08             	mov    0x8(%ebp),%eax
  10574b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10574d:	8b 45 14             	mov    0x14(%ebp),%eax
  105750:	8d 50 04             	lea    0x4(%eax),%edx
  105753:	89 55 14             	mov    %edx,0x14(%ebp)
  105756:	8b 00                	mov    (%eax),%eax
  105758:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10575b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105762:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105769:	eb 1f                	jmp    10578a <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10576b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10576e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105772:	8d 45 14             	lea    0x14(%ebp),%eax
  105775:	89 04 24             	mov    %eax,(%esp)
  105778:	e8 df fb ff ff       	call   10535c <getuint>
  10577d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105780:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105783:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10578a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10578e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105791:	89 54 24 18          	mov    %edx,0x18(%esp)
  105795:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105798:	89 54 24 14          	mov    %edx,0x14(%esp)
  10579c:	89 44 24 10          	mov    %eax,0x10(%esp)
  1057a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1057ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1057b8:	89 04 24             	mov    %eax,(%esp)
  1057bb:	e8 97 fa ff ff       	call   105257 <printnum>
            break;
  1057c0:	eb 3c                	jmp    1057fe <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1057c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057c9:	89 1c 24             	mov    %ebx,(%esp)
  1057cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1057cf:	ff d0                	call   *%eax
            break;
  1057d1:	eb 2b                	jmp    1057fe <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1057d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057da:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1057e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e4:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1057e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1057ea:	eb 04                	jmp    1057f0 <vprintfmt+0x3d0>
  1057ec:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1057f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1057f3:	83 e8 01             	sub    $0x1,%eax
  1057f6:	0f b6 00             	movzbl (%eax),%eax
  1057f9:	3c 25                	cmp    $0x25,%al
  1057fb:	75 ef                	jne    1057ec <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1057fd:	90                   	nop
        }
    }
  1057fe:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057ff:	e9 3e fc ff ff       	jmp    105442 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105804:	83 c4 40             	add    $0x40,%esp
  105807:	5b                   	pop    %ebx
  105808:	5e                   	pop    %esi
  105809:	5d                   	pop    %ebp
  10580a:	c3                   	ret    

0010580b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10580b:	55                   	push   %ebp
  10580c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10580e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105811:	8b 40 08             	mov    0x8(%eax),%eax
  105814:	8d 50 01             	lea    0x1(%eax),%edx
  105817:	8b 45 0c             	mov    0xc(%ebp),%eax
  10581a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10581d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105820:	8b 10                	mov    (%eax),%edx
  105822:	8b 45 0c             	mov    0xc(%ebp),%eax
  105825:	8b 40 04             	mov    0x4(%eax),%eax
  105828:	39 c2                	cmp    %eax,%edx
  10582a:	73 12                	jae    10583e <sprintputch+0x33>
        *b->buf ++ = ch;
  10582c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582f:	8b 00                	mov    (%eax),%eax
  105831:	8d 48 01             	lea    0x1(%eax),%ecx
  105834:	8b 55 0c             	mov    0xc(%ebp),%edx
  105837:	89 0a                	mov    %ecx,(%edx)
  105839:	8b 55 08             	mov    0x8(%ebp),%edx
  10583c:	88 10                	mov    %dl,(%eax)
    }
}
  10583e:	5d                   	pop    %ebp
  10583f:	c3                   	ret    

00105840 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105840:	55                   	push   %ebp
  105841:	89 e5                	mov    %esp,%ebp
  105843:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105846:	8d 45 14             	lea    0x14(%ebp),%eax
  105849:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10584c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10584f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105853:	8b 45 10             	mov    0x10(%ebp),%eax
  105856:	89 44 24 08          	mov    %eax,0x8(%esp)
  10585a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10585d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105861:	8b 45 08             	mov    0x8(%ebp),%eax
  105864:	89 04 24             	mov    %eax,(%esp)
  105867:	e8 08 00 00 00       	call   105874 <vsnprintf>
  10586c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10586f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105872:	c9                   	leave  
  105873:	c3                   	ret    

00105874 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105874:	55                   	push   %ebp
  105875:	89 e5                	mov    %esp,%ebp
  105877:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10587a:	8b 45 08             	mov    0x8(%ebp),%eax
  10587d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105880:	8b 45 0c             	mov    0xc(%ebp),%eax
  105883:	8d 50 ff             	lea    -0x1(%eax),%edx
  105886:	8b 45 08             	mov    0x8(%ebp),%eax
  105889:	01 d0                	add    %edx,%eax
  10588b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10588e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105895:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105899:	74 0a                	je     1058a5 <vsnprintf+0x31>
  10589b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10589e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058a1:	39 c2                	cmp    %eax,%edx
  1058a3:	76 07                	jbe    1058ac <vsnprintf+0x38>
        return -E_INVAL;
  1058a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1058aa:	eb 2a                	jmp    1058d6 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1058ac:	8b 45 14             	mov    0x14(%ebp),%eax
  1058af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1058b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1058bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058c1:	c7 04 24 0b 58 10 00 	movl   $0x10580b,(%esp)
  1058c8:	e8 53 fb ff ff       	call   105420 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1058cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058d0:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1058d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1058d6:	c9                   	leave  
  1058d7:	c3                   	ret    

001058d8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1058d8:	55                   	push   %ebp
  1058d9:	89 e5                	mov    %esp,%ebp
  1058db:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1058de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1058e5:	eb 04                	jmp    1058eb <strlen+0x13>
        cnt ++;
  1058e7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1058eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ee:	8d 50 01             	lea    0x1(%eax),%edx
  1058f1:	89 55 08             	mov    %edx,0x8(%ebp)
  1058f4:	0f b6 00             	movzbl (%eax),%eax
  1058f7:	84 c0                	test   %al,%al
  1058f9:	75 ec                	jne    1058e7 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1058fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1058fe:	c9                   	leave  
  1058ff:	c3                   	ret    

00105900 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105900:	55                   	push   %ebp
  105901:	89 e5                	mov    %esp,%ebp
  105903:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105906:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10590d:	eb 04                	jmp    105913 <strnlen+0x13>
        cnt ++;
  10590f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105913:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105916:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105919:	73 10                	jae    10592b <strnlen+0x2b>
  10591b:	8b 45 08             	mov    0x8(%ebp),%eax
  10591e:	8d 50 01             	lea    0x1(%eax),%edx
  105921:	89 55 08             	mov    %edx,0x8(%ebp)
  105924:	0f b6 00             	movzbl (%eax),%eax
  105927:	84 c0                	test   %al,%al
  105929:	75 e4                	jne    10590f <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10592b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10592e:	c9                   	leave  
  10592f:	c3                   	ret    

00105930 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105930:	55                   	push   %ebp
  105931:	89 e5                	mov    %esp,%ebp
  105933:	57                   	push   %edi
  105934:	56                   	push   %esi
  105935:	83 ec 20             	sub    $0x20,%esp
  105938:	8b 45 08             	mov    0x8(%ebp),%eax
  10593b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10593e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105941:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105944:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10594a:	89 d1                	mov    %edx,%ecx
  10594c:	89 c2                	mov    %eax,%edx
  10594e:	89 ce                	mov    %ecx,%esi
  105950:	89 d7                	mov    %edx,%edi
  105952:	ac                   	lods   %ds:(%esi),%al
  105953:	aa                   	stos   %al,%es:(%edi)
  105954:	84 c0                	test   %al,%al
  105956:	75 fa                	jne    105952 <strcpy+0x22>
  105958:	89 fa                	mov    %edi,%edx
  10595a:	89 f1                	mov    %esi,%ecx
  10595c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10595f:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105962:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105965:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105968:	83 c4 20             	add    $0x20,%esp
  10596b:	5e                   	pop    %esi
  10596c:	5f                   	pop    %edi
  10596d:	5d                   	pop    %ebp
  10596e:	c3                   	ret    

0010596f <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10596f:	55                   	push   %ebp
  105970:	89 e5                	mov    %esp,%ebp
  105972:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105975:	8b 45 08             	mov    0x8(%ebp),%eax
  105978:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10597b:	eb 21                	jmp    10599e <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10597d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105980:	0f b6 10             	movzbl (%eax),%edx
  105983:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105986:	88 10                	mov    %dl,(%eax)
  105988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10598b:	0f b6 00             	movzbl (%eax),%eax
  10598e:	84 c0                	test   %al,%al
  105990:	74 04                	je     105996 <strncpy+0x27>
            src ++;
  105992:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105996:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10599a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10599e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1059a2:	75 d9                	jne    10597d <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1059a4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1059a7:	c9                   	leave  
  1059a8:	c3                   	ret    

001059a9 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1059a9:	55                   	push   %ebp
  1059aa:	89 e5                	mov    %esp,%ebp
  1059ac:	57                   	push   %edi
  1059ad:	56                   	push   %esi
  1059ae:	83 ec 20             	sub    $0x20,%esp
  1059b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1059bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059c3:	89 d1                	mov    %edx,%ecx
  1059c5:	89 c2                	mov    %eax,%edx
  1059c7:	89 ce                	mov    %ecx,%esi
  1059c9:	89 d7                	mov    %edx,%edi
  1059cb:	ac                   	lods   %ds:(%esi),%al
  1059cc:	ae                   	scas   %es:(%edi),%al
  1059cd:	75 08                	jne    1059d7 <strcmp+0x2e>
  1059cf:	84 c0                	test   %al,%al
  1059d1:	75 f8                	jne    1059cb <strcmp+0x22>
  1059d3:	31 c0                	xor    %eax,%eax
  1059d5:	eb 04                	jmp    1059db <strcmp+0x32>
  1059d7:	19 c0                	sbb    %eax,%eax
  1059d9:	0c 01                	or     $0x1,%al
  1059db:	89 fa                	mov    %edi,%edx
  1059dd:	89 f1                	mov    %esi,%ecx
  1059df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1059e2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1059e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  1059e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1059eb:	83 c4 20             	add    $0x20,%esp
  1059ee:	5e                   	pop    %esi
  1059ef:	5f                   	pop    %edi
  1059f0:	5d                   	pop    %ebp
  1059f1:	c3                   	ret    

001059f2 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1059f2:	55                   	push   %ebp
  1059f3:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1059f5:	eb 0c                	jmp    105a03 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1059f7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1059ff:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105a03:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a07:	74 1a                	je     105a23 <strncmp+0x31>
  105a09:	8b 45 08             	mov    0x8(%ebp),%eax
  105a0c:	0f b6 00             	movzbl (%eax),%eax
  105a0f:	84 c0                	test   %al,%al
  105a11:	74 10                	je     105a23 <strncmp+0x31>
  105a13:	8b 45 08             	mov    0x8(%ebp),%eax
  105a16:	0f b6 10             	movzbl (%eax),%edx
  105a19:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1c:	0f b6 00             	movzbl (%eax),%eax
  105a1f:	38 c2                	cmp    %al,%dl
  105a21:	74 d4                	je     1059f7 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105a27:	74 18                	je     105a41 <strncmp+0x4f>
  105a29:	8b 45 08             	mov    0x8(%ebp),%eax
  105a2c:	0f b6 00             	movzbl (%eax),%eax
  105a2f:	0f b6 d0             	movzbl %al,%edx
  105a32:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a35:	0f b6 00             	movzbl (%eax),%eax
  105a38:	0f b6 c0             	movzbl %al,%eax
  105a3b:	29 c2                	sub    %eax,%edx
  105a3d:	89 d0                	mov    %edx,%eax
  105a3f:	eb 05                	jmp    105a46 <strncmp+0x54>
  105a41:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a46:	5d                   	pop    %ebp
  105a47:	c3                   	ret    

00105a48 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105a48:	55                   	push   %ebp
  105a49:	89 e5                	mov    %esp,%ebp
  105a4b:	83 ec 04             	sub    $0x4,%esp
  105a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a51:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105a54:	eb 14                	jmp    105a6a <strchr+0x22>
        if (*s == c) {
  105a56:	8b 45 08             	mov    0x8(%ebp),%eax
  105a59:	0f b6 00             	movzbl (%eax),%eax
  105a5c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105a5f:	75 05                	jne    105a66 <strchr+0x1e>
            return (char *)s;
  105a61:	8b 45 08             	mov    0x8(%ebp),%eax
  105a64:	eb 13                	jmp    105a79 <strchr+0x31>
        }
        s ++;
  105a66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a6d:	0f b6 00             	movzbl (%eax),%eax
  105a70:	84 c0                	test   %al,%al
  105a72:	75 e2                	jne    105a56 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a79:	c9                   	leave  
  105a7a:	c3                   	ret    

00105a7b <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105a7b:	55                   	push   %ebp
  105a7c:	89 e5                	mov    %esp,%ebp
  105a7e:	83 ec 04             	sub    $0x4,%esp
  105a81:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a84:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105a87:	eb 11                	jmp    105a9a <strfind+0x1f>
        if (*s == c) {
  105a89:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8c:	0f b6 00             	movzbl (%eax),%eax
  105a8f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105a92:	75 02                	jne    105a96 <strfind+0x1b>
            break;
  105a94:	eb 0e                	jmp    105aa4 <strfind+0x29>
        }
        s ++;
  105a96:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a9d:	0f b6 00             	movzbl (%eax),%eax
  105aa0:	84 c0                	test   %al,%al
  105aa2:	75 e5                	jne    105a89 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105aa7:	c9                   	leave  
  105aa8:	c3                   	ret    

00105aa9 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105aa9:	55                   	push   %ebp
  105aaa:	89 e5                	mov    %esp,%ebp
  105aac:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105aaf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105ab6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105abd:	eb 04                	jmp    105ac3 <strtol+0x1a>
        s ++;
  105abf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac6:	0f b6 00             	movzbl (%eax),%eax
  105ac9:	3c 20                	cmp    $0x20,%al
  105acb:	74 f2                	je     105abf <strtol+0x16>
  105acd:	8b 45 08             	mov    0x8(%ebp),%eax
  105ad0:	0f b6 00             	movzbl (%eax),%eax
  105ad3:	3c 09                	cmp    $0x9,%al
  105ad5:	74 e8                	je     105abf <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  105ada:	0f b6 00             	movzbl (%eax),%eax
  105add:	3c 2b                	cmp    $0x2b,%al
  105adf:	75 06                	jne    105ae7 <strtol+0x3e>
        s ++;
  105ae1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ae5:	eb 15                	jmp    105afc <strtol+0x53>
    }
    else if (*s == '-') {
  105ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  105aea:	0f b6 00             	movzbl (%eax),%eax
  105aed:	3c 2d                	cmp    $0x2d,%al
  105aef:	75 0b                	jne    105afc <strtol+0x53>
        s ++, neg = 1;
  105af1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105af5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105afc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b00:	74 06                	je     105b08 <strtol+0x5f>
  105b02:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105b06:	75 24                	jne    105b2c <strtol+0x83>
  105b08:	8b 45 08             	mov    0x8(%ebp),%eax
  105b0b:	0f b6 00             	movzbl (%eax),%eax
  105b0e:	3c 30                	cmp    $0x30,%al
  105b10:	75 1a                	jne    105b2c <strtol+0x83>
  105b12:	8b 45 08             	mov    0x8(%ebp),%eax
  105b15:	83 c0 01             	add    $0x1,%eax
  105b18:	0f b6 00             	movzbl (%eax),%eax
  105b1b:	3c 78                	cmp    $0x78,%al
  105b1d:	75 0d                	jne    105b2c <strtol+0x83>
        s += 2, base = 16;
  105b1f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105b23:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105b2a:	eb 2a                	jmp    105b56 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105b2c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b30:	75 17                	jne    105b49 <strtol+0xa0>
  105b32:	8b 45 08             	mov    0x8(%ebp),%eax
  105b35:	0f b6 00             	movzbl (%eax),%eax
  105b38:	3c 30                	cmp    $0x30,%al
  105b3a:	75 0d                	jne    105b49 <strtol+0xa0>
        s ++, base = 8;
  105b3c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b40:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105b47:	eb 0d                	jmp    105b56 <strtol+0xad>
    }
    else if (base == 0) {
  105b49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b4d:	75 07                	jne    105b56 <strtol+0xad>
        base = 10;
  105b4f:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105b56:	8b 45 08             	mov    0x8(%ebp),%eax
  105b59:	0f b6 00             	movzbl (%eax),%eax
  105b5c:	3c 2f                	cmp    $0x2f,%al
  105b5e:	7e 1b                	jle    105b7b <strtol+0xd2>
  105b60:	8b 45 08             	mov    0x8(%ebp),%eax
  105b63:	0f b6 00             	movzbl (%eax),%eax
  105b66:	3c 39                	cmp    $0x39,%al
  105b68:	7f 11                	jg     105b7b <strtol+0xd2>
            dig = *s - '0';
  105b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6d:	0f b6 00             	movzbl (%eax),%eax
  105b70:	0f be c0             	movsbl %al,%eax
  105b73:	83 e8 30             	sub    $0x30,%eax
  105b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b79:	eb 48                	jmp    105bc3 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7e:	0f b6 00             	movzbl (%eax),%eax
  105b81:	3c 60                	cmp    $0x60,%al
  105b83:	7e 1b                	jle    105ba0 <strtol+0xf7>
  105b85:	8b 45 08             	mov    0x8(%ebp),%eax
  105b88:	0f b6 00             	movzbl (%eax),%eax
  105b8b:	3c 7a                	cmp    $0x7a,%al
  105b8d:	7f 11                	jg     105ba0 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b92:	0f b6 00             	movzbl (%eax),%eax
  105b95:	0f be c0             	movsbl %al,%eax
  105b98:	83 e8 57             	sub    $0x57,%eax
  105b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b9e:	eb 23                	jmp    105bc3 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba3:	0f b6 00             	movzbl (%eax),%eax
  105ba6:	3c 40                	cmp    $0x40,%al
  105ba8:	7e 3d                	jle    105be7 <strtol+0x13e>
  105baa:	8b 45 08             	mov    0x8(%ebp),%eax
  105bad:	0f b6 00             	movzbl (%eax),%eax
  105bb0:	3c 5a                	cmp    $0x5a,%al
  105bb2:	7f 33                	jg     105be7 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb7:	0f b6 00             	movzbl (%eax),%eax
  105bba:	0f be c0             	movsbl %al,%eax
  105bbd:	83 e8 37             	sub    $0x37,%eax
  105bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bc6:	3b 45 10             	cmp    0x10(%ebp),%eax
  105bc9:	7c 02                	jl     105bcd <strtol+0x124>
            break;
  105bcb:	eb 1a                	jmp    105be7 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105bcd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bd4:	0f af 45 10          	imul   0x10(%ebp),%eax
  105bd8:	89 c2                	mov    %eax,%edx
  105bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bdd:	01 d0                	add    %edx,%eax
  105bdf:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105be2:	e9 6f ff ff ff       	jmp    105b56 <strtol+0xad>

    if (endptr) {
  105be7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105beb:	74 08                	je     105bf5 <strtol+0x14c>
        *endptr = (char *) s;
  105bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  105bf3:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105bf5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105bf9:	74 07                	je     105c02 <strtol+0x159>
  105bfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105bfe:	f7 d8                	neg    %eax
  105c00:	eb 03                	jmp    105c05 <strtol+0x15c>
  105c02:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105c05:	c9                   	leave  
  105c06:	c3                   	ret    

00105c07 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105c07:	55                   	push   %ebp
  105c08:	89 e5                	mov    %esp,%ebp
  105c0a:	57                   	push   %edi
  105c0b:	83 ec 24             	sub    $0x24,%esp
  105c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c11:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105c14:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105c18:	8b 55 08             	mov    0x8(%ebp),%edx
  105c1b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105c1e:	88 45 f7             	mov    %al,-0x9(%ebp)
  105c21:	8b 45 10             	mov    0x10(%ebp),%eax
  105c24:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105c27:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105c2a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105c2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105c31:	89 d7                	mov    %edx,%edi
  105c33:	f3 aa                	rep stos %al,%es:(%edi)
  105c35:	89 fa                	mov    %edi,%edx
  105c37:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105c3a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105c3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105c40:	83 c4 24             	add    $0x24,%esp
  105c43:	5f                   	pop    %edi
  105c44:	5d                   	pop    %ebp
  105c45:	c3                   	ret    

00105c46 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105c46:	55                   	push   %ebp
  105c47:	89 e5                	mov    %esp,%ebp
  105c49:	57                   	push   %edi
  105c4a:	56                   	push   %esi
  105c4b:	53                   	push   %ebx
  105c4c:	83 ec 30             	sub    $0x30,%esp
  105c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  105c5e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c64:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105c67:	73 42                	jae    105cab <memmove+0x65>
  105c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105c6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105c75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105c78:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105c7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105c7e:	c1 e8 02             	shr    $0x2,%eax
  105c81:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105c83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105c89:	89 d7                	mov    %edx,%edi
  105c8b:	89 c6                	mov    %eax,%esi
  105c8d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105c8f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105c92:	83 e1 03             	and    $0x3,%ecx
  105c95:	74 02                	je     105c99 <memmove+0x53>
  105c97:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105c99:	89 f0                	mov    %esi,%eax
  105c9b:	89 fa                	mov    %edi,%edx
  105c9d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105ca0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105ca3:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ca9:	eb 36                	jmp    105ce1 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105cab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cae:	8d 50 ff             	lea    -0x1(%eax),%edx
  105cb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105cb4:	01 c2                	add    %eax,%edx
  105cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cb9:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cbf:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105cc5:	89 c1                	mov    %eax,%ecx
  105cc7:	89 d8                	mov    %ebx,%eax
  105cc9:	89 d6                	mov    %edx,%esi
  105ccb:	89 c7                	mov    %eax,%edi
  105ccd:	fd                   	std    
  105cce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105cd0:	fc                   	cld    
  105cd1:	89 f8                	mov    %edi,%eax
  105cd3:	89 f2                	mov    %esi,%edx
  105cd5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105cd8:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105cdb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105ce1:	83 c4 30             	add    $0x30,%esp
  105ce4:	5b                   	pop    %ebx
  105ce5:	5e                   	pop    %esi
  105ce6:	5f                   	pop    %edi
  105ce7:	5d                   	pop    %ebp
  105ce8:	c3                   	ret    

00105ce9 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ce9:	55                   	push   %ebp
  105cea:	89 e5                	mov    %esp,%ebp
  105cec:	57                   	push   %edi
  105ced:	56                   	push   %esi
  105cee:	83 ec 20             	sub    $0x20,%esp
  105cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  105cf4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  105d00:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105d03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d06:	c1 e8 02             	shr    $0x2,%eax
  105d09:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d11:	89 d7                	mov    %edx,%edi
  105d13:	89 c6                	mov    %eax,%esi
  105d15:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105d17:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105d1a:	83 e1 03             	and    $0x3,%ecx
  105d1d:	74 02                	je     105d21 <memcpy+0x38>
  105d1f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105d21:	89 f0                	mov    %esi,%eax
  105d23:	89 fa                	mov    %edi,%edx
  105d25:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105d2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105d31:	83 c4 20             	add    $0x20,%esp
  105d34:	5e                   	pop    %esi
  105d35:	5f                   	pop    %edi
  105d36:	5d                   	pop    %ebp
  105d37:	c3                   	ret    

00105d38 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105d38:	55                   	push   %ebp
  105d39:	89 e5                	mov    %esp,%ebp
  105d3b:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  105d41:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d47:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105d4a:	eb 30                	jmp    105d7c <memcmp+0x44>
        if (*s1 != *s2) {
  105d4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d4f:	0f b6 10             	movzbl (%eax),%edx
  105d52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d55:	0f b6 00             	movzbl (%eax),%eax
  105d58:	38 c2                	cmp    %al,%dl
  105d5a:	74 18                	je     105d74 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d5f:	0f b6 00             	movzbl (%eax),%eax
  105d62:	0f b6 d0             	movzbl %al,%edx
  105d65:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d68:	0f b6 00             	movzbl (%eax),%eax
  105d6b:	0f b6 c0             	movzbl %al,%eax
  105d6e:	29 c2                	sub    %eax,%edx
  105d70:	89 d0                	mov    %edx,%eax
  105d72:	eb 1a                	jmp    105d8e <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105d74:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105d78:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105d7c:	8b 45 10             	mov    0x10(%ebp),%eax
  105d7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  105d82:	89 55 10             	mov    %edx,0x10(%ebp)
  105d85:	85 c0                	test   %eax,%eax
  105d87:	75 c3                	jne    105d4c <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105d89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105d8e:	c9                   	leave  
  105d8f:	c3                   	ret    
