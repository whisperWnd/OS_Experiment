
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 81 2a 00 00       	call   102aad <memset>

    cons_init();                // init the console
  10002c:	e8 42 15 00 00       	call   101573 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 c0 32 10 00 	movl   $0x1032c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 dc 32 10 00 	movl   $0x1032dc,(%esp)
  100046:	e8 11 02 00 00       	call   10025c <cprintf>

    print_kerninfo();
  10004b:	e8 b2 08 00 00       	call   100902 <print_kerninfo>

    grade_backtrace();
  100050:	e8 89 00 00 00       	call   1000de <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 28 27 00 00       	call   102782 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 53 16 00 00       	call   1016b2 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 b3 17 00 00       	call   101817 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 eb 0c 00 00       	call   100d54 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 7e 17 00 00       	call   1017ec <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 b0 0c 00 00       	call   100d42 <mon_backtrace>
}
  100092:	90                   	nop
  100093:	c9                   	leave  
  100094:	c3                   	ret    

00100095 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100095:	55                   	push   %ebp
  100096:	89 e5                	mov    %esp,%ebp
  100098:	53                   	push   %ebx
  100099:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009c:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  10009f:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a2:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b4:	89 04 24             	mov    %eax,(%esp)
  1000b7:	e8 b4 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bc:	90                   	nop
  1000bd:	83 c4 14             	add    $0x14,%esp
  1000c0:	5b                   	pop    %ebx
  1000c1:	5d                   	pop    %ebp
  1000c2:	c3                   	ret    

001000c3 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c3:	55                   	push   %ebp
  1000c4:	89 e5                	mov    %esp,%ebp
  1000c6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d3:	89 04 24             	mov    %eax,(%esp)
  1000d6:	e8 ba ff ff ff       	call   100095 <grade_backtrace1>
}
  1000db:	90                   	nop
  1000dc:	c9                   	leave  
  1000dd:	c3                   	ret    

001000de <grade_backtrace>:

void
grade_backtrace(void) {
  1000de:	55                   	push   %ebp
  1000df:	89 e5                	mov    %esp,%ebp
  1000e1:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e4:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e9:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f0:	ff 
  1000f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fc:	e8 c2 ff ff ff       	call   1000c3 <grade_backtrace0>
}
  100101:	90                   	nop
  100102:	c9                   	leave  
  100103:	c3                   	ret    

00100104 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100104:	55                   	push   %ebp
  100105:	89 e5                	mov    %esp,%ebp
  100107:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010a:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010d:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100110:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100113:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100116:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011a:	83 e0 03             	and    $0x3,%eax
  10011d:	89 c2                	mov    %eax,%edx
  10011f:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100124:	89 54 24 08          	mov    %edx,0x8(%esp)
  100128:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012c:	c7 04 24 e1 32 10 00 	movl   $0x1032e1,(%esp)
  100133:	e8 24 01 00 00       	call   10025c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100138:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013c:	89 c2                	mov    %eax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 ef 32 10 00 	movl   $0x1032ef,(%esp)
  100152:	e8 05 01 00 00       	call   10025c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	89 c2                	mov    %eax,%edx
  10015d:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100162:	89 54 24 08          	mov    %edx,0x8(%esp)
  100166:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016a:	c7 04 24 fd 32 10 00 	movl   $0x1032fd,(%esp)
  100171:	e8 e6 00 00 00       	call   10025c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100176:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017a:	89 c2                	mov    %eax,%edx
  10017c:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100181:	89 54 24 08          	mov    %edx,0x8(%esp)
  100185:	89 44 24 04          	mov    %eax,0x4(%esp)
  100189:	c7 04 24 0b 33 10 00 	movl   $0x10330b,(%esp)
  100190:	e8 c7 00 00 00       	call   10025c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100195:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  100199:	89 c2                	mov    %eax,%edx
  10019b:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a0:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a8:	c7 04 24 19 33 10 00 	movl   $0x103319,(%esp)
  1001af:	e8 a8 00 00 00       	call   10025c <cprintf>
    round ++;
  1001b4:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001b9:	40                   	inc    %eax
  1001ba:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001bf:	90                   	nop
  1001c0:	c9                   	leave  
  1001c1:	c3                   	ret    

001001c2 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c2:	55                   	push   %ebp
  1001c3:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c5:	90                   	nop
  1001c6:	5d                   	pop    %ebp
  1001c7:	c3                   	ret    

001001c8 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001c8:	55                   	push   %ebp
  1001c9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001cb:	90                   	nop
  1001cc:	5d                   	pop    %ebp
  1001cd:	c3                   	ret    

001001ce <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ce:	55                   	push   %ebp
  1001cf:	89 e5                	mov    %esp,%ebp
  1001d1:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d4:	e8 2b ff ff ff       	call   100104 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001d9:	c7 04 24 28 33 10 00 	movl   $0x103328,(%esp)
  1001e0:	e8 77 00 00 00       	call   10025c <cprintf>
    lab1_switch_to_user();
  1001e5:	e8 d8 ff ff ff       	call   1001c2 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ea:	e8 15 ff ff ff       	call   100104 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001ef:	c7 04 24 48 33 10 00 	movl   $0x103348,(%esp)
  1001f6:	e8 61 00 00 00       	call   10025c <cprintf>
    lab1_switch_to_kernel();
  1001fb:	e8 c8 ff ff ff       	call   1001c8 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100200:	e8 ff fe ff ff       	call   100104 <lab1_print_cur_status>
}
  100205:	90                   	nop
  100206:	c9                   	leave  
  100207:	c3                   	ret    

00100208 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100208:	55                   	push   %ebp
  100209:	89 e5                	mov    %esp,%ebp
  10020b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10020e:	8b 45 08             	mov    0x8(%ebp),%eax
  100211:	89 04 24             	mov    %eax,(%esp)
  100214:	e8 87 13 00 00       	call   1015a0 <cons_putc>
    (*cnt) ++;
  100219:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021c:	8b 00                	mov    (%eax),%eax
  10021e:	8d 50 01             	lea    0x1(%eax),%edx
  100221:	8b 45 0c             	mov    0xc(%ebp),%eax
  100224:	89 10                	mov    %edx,(%eax)
}
  100226:	90                   	nop
  100227:	c9                   	leave  
  100228:	c3                   	ret    

00100229 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100229:	55                   	push   %ebp
  10022a:	89 e5                	mov    %esp,%ebp
  10022c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10022f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100236:	8b 45 0c             	mov    0xc(%ebp),%eax
  100239:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10023d:	8b 45 08             	mov    0x8(%ebp),%eax
  100240:	89 44 24 08          	mov    %eax,0x8(%esp)
  100244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100247:	89 44 24 04          	mov    %eax,0x4(%esp)
  10024b:	c7 04 24 08 02 10 00 	movl   $0x100208,(%esp)
  100252:	e8 a9 2b 00 00       	call   102e00 <vprintfmt>
    return cnt;
  100257:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10025a:	c9                   	leave  
  10025b:	c3                   	ret    

0010025c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10025c:	55                   	push   %ebp
  10025d:	89 e5                	mov    %esp,%ebp
  10025f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100262:	8d 45 0c             	lea    0xc(%ebp),%eax
  100265:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10026b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10026f:	8b 45 08             	mov    0x8(%ebp),%eax
  100272:	89 04 24             	mov    %eax,(%esp)
  100275:	e8 af ff ff ff       	call   100229 <vcprintf>
  10027a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10027d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100280:	c9                   	leave  
  100281:	c3                   	ret    

00100282 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100282:	55                   	push   %ebp
  100283:	89 e5                	mov    %esp,%ebp
  100285:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100288:	8b 45 08             	mov    0x8(%ebp),%eax
  10028b:	89 04 24             	mov    %eax,(%esp)
  10028e:	e8 0d 13 00 00       	call   1015a0 <cons_putc>
}
  100293:	90                   	nop
  100294:	c9                   	leave  
  100295:	c3                   	ret    

00100296 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100296:	55                   	push   %ebp
  100297:	89 e5                	mov    %esp,%ebp
  100299:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10029c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002a3:	eb 13                	jmp    1002b8 <cputs+0x22>
        cputch(c, &cnt);
  1002a5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002a9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002b0:	89 04 24             	mov    %eax,(%esp)
  1002b3:	e8 50 ff ff ff       	call   100208 <cputch>
    while ((c = *str ++) != '\0') {
  1002b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002bb:	8d 50 01             	lea    0x1(%eax),%edx
  1002be:	89 55 08             	mov    %edx,0x8(%ebp)
  1002c1:	0f b6 00             	movzbl (%eax),%eax
  1002c4:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002c7:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002cb:	75 d8                	jne    1002a5 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002d4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002db:	e8 28 ff ff ff       	call   100208 <cputch>
    return cnt;
  1002e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002e3:	c9                   	leave  
  1002e4:	c3                   	ret    

001002e5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002e5:	55                   	push   %ebp
  1002e6:	89 e5                	mov    %esp,%ebp
  1002e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002eb:	e8 da 12 00 00       	call   1015ca <cons_getc>
  1002f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002f7:	74 f2                	je     1002eb <getchar+0x6>
        /* do nothing */;
    return c;
  1002f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002fc:	c9                   	leave  
  1002fd:	c3                   	ret    

001002fe <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002fe:	55                   	push   %ebp
  1002ff:	89 e5                	mov    %esp,%ebp
  100301:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100304:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100308:	74 13                	je     10031d <readline+0x1f>
        cprintf("%s", prompt);
  10030a:	8b 45 08             	mov    0x8(%ebp),%eax
  10030d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100311:	c7 04 24 67 33 10 00 	movl   $0x103367,(%esp)
  100318:	e8 3f ff ff ff       	call   10025c <cprintf>
    }
    int i = 0, c;
  10031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100324:	e8 bc ff ff ff       	call   1002e5 <getchar>
  100329:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10032c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100330:	79 07                	jns    100339 <readline+0x3b>
            return NULL;
  100332:	b8 00 00 00 00       	mov    $0x0,%eax
  100337:	eb 78                	jmp    1003b1 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100339:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10033d:	7e 28                	jle    100367 <readline+0x69>
  10033f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100346:	7f 1f                	jg     100367 <readline+0x69>
            cputchar(c);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 04 24             	mov    %eax,(%esp)
  10034e:	e8 2f ff ff ff       	call   100282 <cputchar>
            buf[i ++] = c;
  100353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100356:	8d 50 01             	lea    0x1(%eax),%edx
  100359:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10035c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10035f:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100365:	eb 45                	jmp    1003ac <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100367:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10036b:	75 16                	jne    100383 <readline+0x85>
  10036d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100371:	7e 10                	jle    100383 <readline+0x85>
            cputchar(c);
  100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100376:	89 04 24             	mov    %eax,(%esp)
  100379:	e8 04 ff ff ff       	call   100282 <cputchar>
            i --;
  10037e:	ff 4d f4             	decl   -0xc(%ebp)
  100381:	eb 29                	jmp    1003ac <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100383:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100387:	74 06                	je     10038f <readline+0x91>
  100389:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10038d:	75 95                	jne    100324 <readline+0x26>
            cputchar(c);
  10038f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100392:	89 04 24             	mov    %eax,(%esp)
  100395:	e8 e8 fe ff ff       	call   100282 <cputchar>
            buf[i] = '\0';
  10039a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003a2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003aa:	eb 05                	jmp    1003b1 <readline+0xb3>
        c = getchar();
  1003ac:	e9 73 ff ff ff       	jmp    100324 <readline+0x26>
        }
    }
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003b9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003be:	85 c0                	test   %eax,%eax
  1003c0:	75 5b                	jne    10041d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003c2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003c9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003cc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1003dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003e0:	c7 04 24 6a 33 10 00 	movl   $0x10336a,(%esp)
  1003e7:	e8 70 fe ff ff       	call   10025c <cprintf>
    vcprintf(fmt, ap);
  1003ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f3:	8b 45 10             	mov    0x10(%ebp),%eax
  1003f6:	89 04 24             	mov    %eax,(%esp)
  1003f9:	e8 2b fe ff ff       	call   100229 <vcprintf>
    cprintf("\n");
  1003fe:	c7 04 24 86 33 10 00 	movl   $0x103386,(%esp)
  100405:	e8 52 fe ff ff       	call   10025c <cprintf>
    
    cprintf("stack trackback:\n");
  10040a:	c7 04 24 88 33 10 00 	movl   $0x103388,(%esp)
  100411:	e8 46 fe ff ff       	call   10025c <cprintf>
    print_stackframe();
  100416:	e8 32 06 00 00       	call   100a4d <print_stackframe>
  10041b:	eb 01                	jmp    10041e <__panic+0x6b>
        goto panic_dead;
  10041d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10041e:	e8 d0 13 00 00       	call   1017f3 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100423:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10042a:	e8 46 08 00 00       	call   100c75 <kmonitor>
  10042f:	eb f2                	jmp    100423 <__panic+0x70>

00100431 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100431:	55                   	push   %ebp
  100432:	89 e5                	mov    %esp,%ebp
  100434:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100437:	8d 45 14             	lea    0x14(%ebp),%eax
  10043a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10043d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100440:	89 44 24 08          	mov    %eax,0x8(%esp)
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	89 44 24 04          	mov    %eax,0x4(%esp)
  10044b:	c7 04 24 9a 33 10 00 	movl   $0x10339a,(%esp)
  100452:	e8 05 fe ff ff       	call   10025c <cprintf>
    vcprintf(fmt, ap);
  100457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10045a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045e:	8b 45 10             	mov    0x10(%ebp),%eax
  100461:	89 04 24             	mov    %eax,(%esp)
  100464:	e8 c0 fd ff ff       	call   100229 <vcprintf>
    cprintf("\n");
  100469:	c7 04 24 86 33 10 00 	movl   $0x103386,(%esp)
  100470:	e8 e7 fd ff ff       	call   10025c <cprintf>
    va_end(ap);
}
  100475:	90                   	nop
  100476:	c9                   	leave  
  100477:	c3                   	ret    

00100478 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100478:	55                   	push   %ebp
  100479:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10047b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100480:	5d                   	pop    %ebp
  100481:	c3                   	ret    

00100482 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100482:	55                   	push   %ebp
  100483:	89 e5                	mov    %esp,%ebp
  100485:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100488:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048b:	8b 00                	mov    (%eax),%eax
  10048d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100490:	8b 45 10             	mov    0x10(%ebp),%eax
  100493:	8b 00                	mov    (%eax),%eax
  100495:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100498:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10049f:	e9 ca 00 00 00       	jmp    10056e <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004aa:	01 d0                	add    %edx,%eax
  1004ac:	89 c2                	mov    %eax,%edx
  1004ae:	c1 ea 1f             	shr    $0x1f,%edx
  1004b1:	01 d0                	add    %edx,%eax
  1004b3:	d1 f8                	sar    %eax
  1004b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004bb:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004be:	eb 03                	jmp    1004c3 <stab_binsearch+0x41>
            m --;
  1004c0:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004c9:	7c 1f                	jl     1004ea <stab_binsearch+0x68>
  1004cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ce:	89 d0                	mov    %edx,%eax
  1004d0:	01 c0                	add    %eax,%eax
  1004d2:	01 d0                	add    %edx,%eax
  1004d4:	c1 e0 02             	shl    $0x2,%eax
  1004d7:	89 c2                	mov    %eax,%edx
  1004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004dc:	01 d0                	add    %edx,%eax
  1004de:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004e2:	0f b6 c0             	movzbl %al,%eax
  1004e5:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004e8:	75 d6                	jne    1004c0 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ed:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004f0:	7d 09                	jge    1004fb <stab_binsearch+0x79>
            l = true_m + 1;
  1004f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004f5:	40                   	inc    %eax
  1004f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004f9:	eb 73                	jmp    10056e <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  1004fb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100502:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100505:	89 d0                	mov    %edx,%eax
  100507:	01 c0                	add    %eax,%eax
  100509:	01 d0                	add    %edx,%eax
  10050b:	c1 e0 02             	shl    $0x2,%eax
  10050e:	89 c2                	mov    %eax,%edx
  100510:	8b 45 08             	mov    0x8(%ebp),%eax
  100513:	01 d0                	add    %edx,%eax
  100515:	8b 40 08             	mov    0x8(%eax),%eax
  100518:	39 45 18             	cmp    %eax,0x18(%ebp)
  10051b:	76 11                	jbe    10052e <stab_binsearch+0xac>
            *region_left = m;
  10051d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100520:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100523:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100525:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100528:	40                   	inc    %eax
  100529:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10052c:	eb 40                	jmp    10056e <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  10052e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100531:	89 d0                	mov    %edx,%eax
  100533:	01 c0                	add    %eax,%eax
  100535:	01 d0                	add    %edx,%eax
  100537:	c1 e0 02             	shl    $0x2,%eax
  10053a:	89 c2                	mov    %eax,%edx
  10053c:	8b 45 08             	mov    0x8(%ebp),%eax
  10053f:	01 d0                	add    %edx,%eax
  100541:	8b 40 08             	mov    0x8(%eax),%eax
  100544:	39 45 18             	cmp    %eax,0x18(%ebp)
  100547:	73 14                	jae    10055d <stab_binsearch+0xdb>
            *region_right = m - 1;
  100549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10054f:	8b 45 10             	mov    0x10(%ebp),%eax
  100552:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100557:	48                   	dec    %eax
  100558:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10055b:	eb 11                	jmp    10056e <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100560:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100563:	89 10                	mov    %edx,(%eax)
            l = m;
  100565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100568:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10056b:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  10056e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100571:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100574:	0f 8e 2a ff ff ff    	jle    1004a4 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  10057a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10057e:	75 0f                	jne    10058f <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  100580:	8b 45 0c             	mov    0xc(%ebp),%eax
  100583:	8b 00                	mov    (%eax),%eax
  100585:	8d 50 ff             	lea    -0x1(%eax),%edx
  100588:	8b 45 10             	mov    0x10(%ebp),%eax
  10058b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10058d:	eb 3e                	jmp    1005cd <stab_binsearch+0x14b>
        l = *region_right;
  10058f:	8b 45 10             	mov    0x10(%ebp),%eax
  100592:	8b 00                	mov    (%eax),%eax
  100594:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100597:	eb 03                	jmp    10059c <stab_binsearch+0x11a>
  100599:	ff 4d fc             	decl   -0x4(%ebp)
  10059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10059f:	8b 00                	mov    (%eax),%eax
  1005a1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005a4:	7e 1f                	jle    1005c5 <stab_binsearch+0x143>
  1005a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005a9:	89 d0                	mov    %edx,%eax
  1005ab:	01 c0                	add    %eax,%eax
  1005ad:	01 d0                	add    %edx,%eax
  1005af:	c1 e0 02             	shl    $0x2,%eax
  1005b2:	89 c2                	mov    %eax,%edx
  1005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b7:	01 d0                	add    %edx,%eax
  1005b9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005bd:	0f b6 c0             	movzbl %al,%eax
  1005c0:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005c3:	75 d4                	jne    100599 <stab_binsearch+0x117>
        *region_left = l;
  1005c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005cb:	89 10                	mov    %edx,(%eax)
}
  1005cd:	90                   	nop
  1005ce:	c9                   	leave  
  1005cf:	c3                   	ret    

001005d0 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005d0:	55                   	push   %ebp
  1005d1:	89 e5                	mov    %esp,%ebp
  1005d3:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d9:	c7 00 b8 33 10 00    	movl   $0x1033b8,(%eax)
    info->eip_line = 0;
  1005df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ec:	c7 40 08 b8 33 10 00 	movl   $0x1033b8,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f6:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100600:	8b 55 08             	mov    0x8(%ebp),%edx
  100603:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100606:	8b 45 0c             	mov    0xc(%ebp),%eax
  100609:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100610:	c7 45 f4 cc 3b 10 00 	movl   $0x103bcc,-0xc(%ebp)
    stab_end = __STAB_END__;
  100617:	c7 45 f0 d4 b7 10 00 	movl   $0x10b7d4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10061e:	c7 45 ec d5 b7 10 00 	movl   $0x10b7d5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100625:	c7 45 e8 a4 d8 10 00 	movl   $0x10d8a4,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10062c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10062f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100632:	76 0b                	jbe    10063f <debuginfo_eip+0x6f>
  100634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100637:	48                   	dec    %eax
  100638:	0f b6 00             	movzbl (%eax),%eax
  10063b:	84 c0                	test   %al,%al
  10063d:	74 0a                	je     100649 <debuginfo_eip+0x79>
        return -1;
  10063f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100644:	e9 b7 02 00 00       	jmp    100900 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100649:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100650:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100656:	29 c2                	sub    %eax,%edx
  100658:	89 d0                	mov    %edx,%eax
  10065a:	c1 f8 02             	sar    $0x2,%eax
  10065d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100663:	48                   	dec    %eax
  100664:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100667:	8b 45 08             	mov    0x8(%ebp),%eax
  10066a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10066e:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100675:	00 
  100676:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100679:	89 44 24 08          	mov    %eax,0x8(%esp)
  10067d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100680:	89 44 24 04          	mov    %eax,0x4(%esp)
  100684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100687:	89 04 24             	mov    %eax,(%esp)
  10068a:	e8 f3 fd ff ff       	call   100482 <stab_binsearch>
    if (lfile == 0)
  10068f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100692:	85 c0                	test   %eax,%eax
  100694:	75 0a                	jne    1006a0 <debuginfo_eip+0xd0>
        return -1;
  100696:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10069b:	e9 60 02 00 00       	jmp    100900 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1006af:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006b3:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006ba:	00 
  1006bb:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006be:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006c2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006cc:	89 04 24             	mov    %eax,(%esp)
  1006cf:	e8 ae fd ff ff       	call   100482 <stab_binsearch>

    if (lfun <= rfun) {
  1006d4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006da:	39 c2                	cmp    %eax,%edx
  1006dc:	7f 7c                	jg     10075a <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006de:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006e1:	89 c2                	mov    %eax,%edx
  1006e3:	89 d0                	mov    %edx,%eax
  1006e5:	01 c0                	add    %eax,%eax
  1006e7:	01 d0                	add    %edx,%eax
  1006e9:	c1 e0 02             	shl    $0x2,%eax
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f1:	01 d0                	add    %edx,%eax
  1006f3:	8b 00                	mov    (%eax),%eax
  1006f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1006fb:	29 d1                	sub    %edx,%ecx
  1006fd:	89 ca                	mov    %ecx,%edx
  1006ff:	39 d0                	cmp    %edx,%eax
  100701:	73 22                	jae    100725 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100703:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100706:	89 c2                	mov    %eax,%edx
  100708:	89 d0                	mov    %edx,%eax
  10070a:	01 c0                	add    %eax,%eax
  10070c:	01 d0                	add    %edx,%eax
  10070e:	c1 e0 02             	shl    $0x2,%eax
  100711:	89 c2                	mov    %eax,%edx
  100713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100716:	01 d0                	add    %edx,%eax
  100718:	8b 10                	mov    (%eax),%edx
  10071a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10071d:	01 c2                	add    %eax,%edx
  10071f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100722:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100725:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100728:	89 c2                	mov    %eax,%edx
  10072a:	89 d0                	mov    %edx,%eax
  10072c:	01 c0                	add    %eax,%eax
  10072e:	01 d0                	add    %edx,%eax
  100730:	c1 e0 02             	shl    $0x2,%eax
  100733:	89 c2                	mov    %eax,%edx
  100735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100738:	01 d0                	add    %edx,%eax
  10073a:	8b 50 08             	mov    0x8(%eax),%edx
  10073d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100740:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100743:	8b 45 0c             	mov    0xc(%ebp),%eax
  100746:	8b 40 10             	mov    0x10(%eax),%eax
  100749:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10074c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100752:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100755:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100758:	eb 15                	jmp    10076f <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075d:	8b 55 08             	mov    0x8(%ebp),%edx
  100760:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100763:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100766:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10076c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10076f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100772:	8b 40 08             	mov    0x8(%eax),%eax
  100775:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10077c:	00 
  10077d:	89 04 24             	mov    %eax,(%esp)
  100780:	e8 a4 21 00 00       	call   102929 <strfind>
  100785:	89 c2                	mov    %eax,%edx
  100787:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078a:	8b 40 08             	mov    0x8(%eax),%eax
  10078d:	29 c2                	sub    %eax,%edx
  10078f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100792:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100795:	8b 45 08             	mov    0x8(%ebp),%eax
  100798:	89 44 24 10          	mov    %eax,0x10(%esp)
  10079c:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007a3:	00 
  1007a4:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007ab:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b5:	89 04 24             	mov    %eax,(%esp)
  1007b8:	e8 c5 fc ff ff       	call   100482 <stab_binsearch>
    if (lline <= rline) {
  1007bd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007c3:	39 c2                	cmp    %eax,%edx
  1007c5:	7f 23                	jg     1007ea <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  1007c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ca:	89 c2                	mov    %eax,%edx
  1007cc:	89 d0                	mov    %edx,%eax
  1007ce:	01 c0                	add    %eax,%eax
  1007d0:	01 d0                	add    %edx,%eax
  1007d2:	c1 e0 02             	shl    $0x2,%eax
  1007d5:	89 c2                	mov    %eax,%edx
  1007d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007da:	01 d0                	add    %edx,%eax
  1007dc:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007e0:	89 c2                	mov    %eax,%edx
  1007e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e8:	eb 11                	jmp    1007fb <debuginfo_eip+0x22b>
        return -1;
  1007ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ef:	e9 0c 01 00 00       	jmp    100900 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	48                   	dec    %eax
  1007f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  1007fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100801:	39 c2                	cmp    %eax,%edx
  100803:	7c 56                	jl     10085b <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  100805:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100808:	89 c2                	mov    %eax,%edx
  10080a:	89 d0                	mov    %edx,%eax
  10080c:	01 c0                	add    %eax,%eax
  10080e:	01 d0                	add    %edx,%eax
  100810:	c1 e0 02             	shl    $0x2,%eax
  100813:	89 c2                	mov    %eax,%edx
  100815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100818:	01 d0                	add    %edx,%eax
  10081a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10081e:	3c 84                	cmp    $0x84,%al
  100820:	74 39                	je     10085b <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c 64                	cmp    $0x64,%al
  10083d:	75 b5                	jne    1007f4 <debuginfo_eip+0x224>
  10083f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100842:	89 c2                	mov    %eax,%edx
  100844:	89 d0                	mov    %edx,%eax
  100846:	01 c0                	add    %eax,%eax
  100848:	01 d0                	add    %edx,%eax
  10084a:	c1 e0 02             	shl    $0x2,%eax
  10084d:	89 c2                	mov    %eax,%edx
  10084f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100852:	01 d0                	add    %edx,%eax
  100854:	8b 40 08             	mov    0x8(%eax),%eax
  100857:	85 c0                	test   %eax,%eax
  100859:	74 99                	je     1007f4 <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10085b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10085e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100861:	39 c2                	cmp    %eax,%edx
  100863:	7c 46                	jl     1008ab <debuginfo_eip+0x2db>
  100865:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100868:	89 c2                	mov    %eax,%edx
  10086a:	89 d0                	mov    %edx,%eax
  10086c:	01 c0                	add    %eax,%eax
  10086e:	01 d0                	add    %edx,%eax
  100870:	c1 e0 02             	shl    $0x2,%eax
  100873:	89 c2                	mov    %eax,%edx
  100875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100878:	01 d0                	add    %edx,%eax
  10087a:	8b 00                	mov    (%eax),%eax
  10087c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10087f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100882:	29 d1                	sub    %edx,%ecx
  100884:	89 ca                	mov    %ecx,%edx
  100886:	39 d0                	cmp    %edx,%eax
  100888:	73 21                	jae    1008ab <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10088a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10088d:	89 c2                	mov    %eax,%edx
  10088f:	89 d0                	mov    %edx,%eax
  100891:	01 c0                	add    %eax,%eax
  100893:	01 d0                	add    %edx,%eax
  100895:	c1 e0 02             	shl    $0x2,%eax
  100898:	89 c2                	mov    %eax,%edx
  10089a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10089d:	01 d0                	add    %edx,%eax
  10089f:	8b 10                	mov    (%eax),%edx
  1008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008a4:	01 c2                	add    %eax,%edx
  1008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008b1:	39 c2                	cmp    %eax,%edx
  1008b3:	7d 46                	jge    1008fb <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008b8:	40                   	inc    %eax
  1008b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008bc:	eb 16                	jmp    1008d4 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008c1:	8b 40 14             	mov    0x14(%eax),%eax
  1008c4:	8d 50 01             	lea    0x1(%eax),%edx
  1008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ca:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008cd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d0:	40                   	inc    %eax
  1008d1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008da:	39 c2                	cmp    %eax,%edx
  1008dc:	7d 1d                	jge    1008fb <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e1:	89 c2                	mov    %eax,%edx
  1008e3:	89 d0                	mov    %edx,%eax
  1008e5:	01 c0                	add    %eax,%eax
  1008e7:	01 d0                	add    %edx,%eax
  1008e9:	c1 e0 02             	shl    $0x2,%eax
  1008ec:	89 c2                	mov    %eax,%edx
  1008ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f1:	01 d0                	add    %edx,%eax
  1008f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008f7:	3c a0                	cmp    $0xa0,%al
  1008f9:	74 c3                	je     1008be <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  1008fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100900:	c9                   	leave  
  100901:	c3                   	ret    

00100902 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100902:	55                   	push   %ebp
  100903:	89 e5                	mov    %esp,%ebp
  100905:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100908:	c7 04 24 c2 33 10 00 	movl   $0x1033c2,(%esp)
  10090f:	e8 48 f9 ff ff       	call   10025c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100914:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10091b:	00 
  10091c:	c7 04 24 db 33 10 00 	movl   $0x1033db,(%esp)
  100923:	e8 34 f9 ff ff       	call   10025c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100928:	c7 44 24 04 a7 32 10 	movl   $0x1032a7,0x4(%esp)
  10092f:	00 
  100930:	c7 04 24 f3 33 10 00 	movl   $0x1033f3,(%esp)
  100937:	e8 20 f9 ff ff       	call   10025c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10093c:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100943:	00 
  100944:	c7 04 24 0b 34 10 00 	movl   $0x10340b,(%esp)
  10094b:	e8 0c f9 ff ff       	call   10025c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100950:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  100957:	00 
  100958:	c7 04 24 23 34 10 00 	movl   $0x103423,(%esp)
  10095f:	e8 f8 f8 ff ff       	call   10025c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100964:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  100969:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10096f:	b8 00 00 10 00       	mov    $0x100000,%eax
  100974:	29 c2                	sub    %eax,%edx
  100976:	89 d0                	mov    %edx,%eax
  100978:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10097e:	85 c0                	test   %eax,%eax
  100980:	0f 48 c2             	cmovs  %edx,%eax
  100983:	c1 f8 0a             	sar    $0xa,%eax
  100986:	89 44 24 04          	mov    %eax,0x4(%esp)
  10098a:	c7 04 24 3c 34 10 00 	movl   $0x10343c,(%esp)
  100991:	e8 c6 f8 ff ff       	call   10025c <cprintf>
}
  100996:	90                   	nop
  100997:	c9                   	leave  
  100998:	c3                   	ret    

00100999 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100999:	55                   	push   %ebp
  10099a:	89 e5                	mov    %esp,%ebp
  10099c:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009a2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ac:	89 04 24             	mov    %eax,(%esp)
  1009af:	e8 1c fc ff ff       	call   1005d0 <debuginfo_eip>
  1009b4:	85 c0                	test   %eax,%eax
  1009b6:	74 15                	je     1009cd <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009bf:	c7 04 24 66 34 10 00 	movl   $0x103466,(%esp)
  1009c6:	e8 91 f8 ff ff       	call   10025c <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009cb:	eb 6c                	jmp    100a39 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009d4:	eb 1b                	jmp    1009f1 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  1009d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009dc:	01 d0                	add    %edx,%eax
  1009de:	0f b6 00             	movzbl (%eax),%eax
  1009e1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009ea:	01 ca                	add    %ecx,%edx
  1009ec:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009ee:	ff 45 f4             	incl   -0xc(%ebp)
  1009f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1009f7:	7c dd                	jl     1009d6 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  1009f9:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  1009ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a02:	01 d0                	add    %edx,%eax
  100a04:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a07:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  100a0d:	89 d1                	mov    %edx,%ecx
  100a0f:	29 c1                	sub    %eax,%ecx
  100a11:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a17:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a1b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a21:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a25:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2d:	c7 04 24 82 34 10 00 	movl   $0x103482,(%esp)
  100a34:	e8 23 f8 ff ff       	call   10025c <cprintf>
}
  100a39:	90                   	nop
  100a3a:	c9                   	leave  
  100a3b:	c3                   	ret    

00100a3c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a3c:	55                   	push   %ebp
  100a3d:	89 e5                	mov    %esp,%ebp
  100a3f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a42:	8b 45 04             	mov    0x4(%ebp),%eax
  100a45:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a4b:	c9                   	leave  
  100a4c:	c3                   	ret    

00100a4d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a4d:	55                   	push   %ebp
  100a4e:	89 e5                	mov    %esp,%ebp
  100a50:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a53:	89 e8                	mov    %ebp,%eax
  100a55:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp(), eip = read_eip();
  100a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a5e:	e8 d9 ff ff ff       	call   100a3c <read_eip>
  100a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a66:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a6d:	e9 84 00 00 00       	jmp    100af6 <print_stackframe+0xa9>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100a72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a75:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a80:	c7 04 24 94 34 10 00 	movl   $0x103494,(%esp)
  100a87:	e8 d0 f7 ff ff       	call   10025c <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8f:	83 c0 08             	add    $0x8,%eax
  100a92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a95:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a9c:	eb 24                	jmp    100ac2 <print_stackframe+0x75>
            cprintf("0x%08x ", args[j]);
  100a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aa1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100aab:	01 d0                	add    %edx,%eax
  100aad:	8b 00                	mov    (%eax),%eax
  100aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab3:	c7 04 24 b0 34 10 00 	movl   $0x1034b0,(%esp)
  100aba:	e8 9d f7 ff ff       	call   10025c <cprintf>
        for (j = 0; j < 4; j ++) {
  100abf:	ff 45 e8             	incl   -0x18(%ebp)
  100ac2:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ac6:	7e d6                	jle    100a9e <print_stackframe+0x51>
        }
        cprintf("\n");
  100ac8:	c7 04 24 b8 34 10 00 	movl   $0x1034b8,(%esp)
  100acf:	e8 88 f7 ff ff       	call   10025c <cprintf>
        print_debuginfo(eip - 1);
  100ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ad7:	48                   	dec    %eax
  100ad8:	89 04 24             	mov    %eax,(%esp)
  100adb:	e8 b9 fe ff ff       	call   100999 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae3:	83 c0 04             	add    $0x4,%eax
  100ae6:	8b 00                	mov    (%eax),%eax
  100ae8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aee:	8b 00                	mov    (%eax),%eax
  100af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100af3:	ff 45 ec             	incl   -0x14(%ebp)
  100af6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100afa:	74 0a                	je     100b06 <print_stackframe+0xb9>
  100afc:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b00:	0f 8e 6c ff ff ff    	jle    100a72 <print_stackframe+0x25>
    }
}
  100b06:	90                   	nop
  100b07:	c9                   	leave  
  100b08:	c3                   	ret    

00100b09 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b09:	55                   	push   %ebp
  100b0a:	89 e5                	mov    %esp,%ebp
  100b0c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b16:	eb 0c                	jmp    100b24 <parse+0x1b>
            *buf ++ = '\0';
  100b18:	8b 45 08             	mov    0x8(%ebp),%eax
  100b1b:	8d 50 01             	lea    0x1(%eax),%edx
  100b1e:	89 55 08             	mov    %edx,0x8(%ebp)
  100b21:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b24:	8b 45 08             	mov    0x8(%ebp),%eax
  100b27:	0f b6 00             	movzbl (%eax),%eax
  100b2a:	84 c0                	test   %al,%al
  100b2c:	74 1d                	je     100b4b <parse+0x42>
  100b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b31:	0f b6 00             	movzbl (%eax),%eax
  100b34:	0f be c0             	movsbl %al,%eax
  100b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b3b:	c7 04 24 3c 35 10 00 	movl   $0x10353c,(%esp)
  100b42:	e8 b0 1d 00 00       	call   1028f7 <strchr>
  100b47:	85 c0                	test   %eax,%eax
  100b49:	75 cd                	jne    100b18 <parse+0xf>
        }
        if (*buf == '\0') {
  100b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4e:	0f b6 00             	movzbl (%eax),%eax
  100b51:	84 c0                	test   %al,%al
  100b53:	74 65                	je     100bba <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b55:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b59:	75 14                	jne    100b6f <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b5b:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b62:	00 
  100b63:	c7 04 24 41 35 10 00 	movl   $0x103541,(%esp)
  100b6a:	e8 ed f6 ff ff       	call   10025c <cprintf>
        }
        argv[argc ++] = buf;
  100b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b72:	8d 50 01             	lea    0x1(%eax),%edx
  100b75:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b78:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b82:	01 c2                	add    %eax,%edx
  100b84:	8b 45 08             	mov    0x8(%ebp),%eax
  100b87:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b89:	eb 03                	jmp    100b8e <parse+0x85>
            buf ++;
  100b8b:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b91:	0f b6 00             	movzbl (%eax),%eax
  100b94:	84 c0                	test   %al,%al
  100b96:	74 8c                	je     100b24 <parse+0x1b>
  100b98:	8b 45 08             	mov    0x8(%ebp),%eax
  100b9b:	0f b6 00             	movzbl (%eax),%eax
  100b9e:	0f be c0             	movsbl %al,%eax
  100ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba5:	c7 04 24 3c 35 10 00 	movl   $0x10353c,(%esp)
  100bac:	e8 46 1d 00 00       	call   1028f7 <strchr>
  100bb1:	85 c0                	test   %eax,%eax
  100bb3:	74 d6                	je     100b8b <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bb5:	e9 6a ff ff ff       	jmp    100b24 <parse+0x1b>
            break;
  100bba:	90                   	nop
        }
    }
    return argc;
  100bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bbe:	c9                   	leave  
  100bbf:	c3                   	ret    

00100bc0 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bc0:	55                   	push   %ebp
  100bc1:	89 e5                	mov    %esp,%ebp
  100bc3:	53                   	push   %ebx
  100bc4:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bc7:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bca:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bce:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd1:	89 04 24             	mov    %eax,(%esp)
  100bd4:	e8 30 ff ff ff       	call   100b09 <parse>
  100bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100be0:	75 0a                	jne    100bec <runcmd+0x2c>
        return 0;
  100be2:	b8 00 00 00 00       	mov    $0x0,%eax
  100be7:	e9 83 00 00 00       	jmp    100c6f <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bf3:	eb 5a                	jmp    100c4f <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bf5:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bfb:	89 d0                	mov    %edx,%eax
  100bfd:	01 c0                	add    %eax,%eax
  100bff:	01 d0                	add    %edx,%eax
  100c01:	c1 e0 02             	shl    $0x2,%eax
  100c04:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c09:	8b 00                	mov    (%eax),%eax
  100c0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c0f:	89 04 24             	mov    %eax,(%esp)
  100c12:	e8 43 1c 00 00       	call   10285a <strcmp>
  100c17:	85 c0                	test   %eax,%eax
  100c19:	75 31                	jne    100c4c <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c1e:	89 d0                	mov    %edx,%eax
  100c20:	01 c0                	add    %eax,%eax
  100c22:	01 d0                	add    %edx,%eax
  100c24:	c1 e0 02             	shl    $0x2,%eax
  100c27:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c2c:	8b 10                	mov    (%eax),%edx
  100c2e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c31:	83 c0 04             	add    $0x4,%eax
  100c34:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c37:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c45:	89 1c 24             	mov    %ebx,(%esp)
  100c48:	ff d2                	call   *%edx
  100c4a:	eb 23                	jmp    100c6f <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4c:	ff 45 f4             	incl   -0xc(%ebp)
  100c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c52:	83 f8 02             	cmp    $0x2,%eax
  100c55:	76 9e                	jbe    100bf5 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c57:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5e:	c7 04 24 5f 35 10 00 	movl   $0x10355f,(%esp)
  100c65:	e8 f2 f5 ff ff       	call   10025c <cprintf>
    return 0;
  100c6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c6f:	83 c4 64             	add    $0x64,%esp
  100c72:	5b                   	pop    %ebx
  100c73:	5d                   	pop    %ebp
  100c74:	c3                   	ret    

00100c75 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c75:	55                   	push   %ebp
  100c76:	89 e5                	mov    %esp,%ebp
  100c78:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c7b:	c7 04 24 78 35 10 00 	movl   $0x103578,(%esp)
  100c82:	e8 d5 f5 ff ff       	call   10025c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c87:	c7 04 24 a0 35 10 00 	movl   $0x1035a0,(%esp)
  100c8e:	e8 c9 f5 ff ff       	call   10025c <cprintf>

    if (tf != NULL) {
  100c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c97:	74 0b                	je     100ca4 <kmonitor+0x2f>
        print_trapframe(tf);
  100c99:	8b 45 08             	mov    0x8(%ebp),%eax
  100c9c:	89 04 24             	mov    %eax,(%esp)
  100c9f:	e8 bf 0b 00 00       	call   101863 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100ca4:	c7 04 24 c5 35 10 00 	movl   $0x1035c5,(%esp)
  100cab:	e8 4e f6 ff ff       	call   1002fe <readline>
  100cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cb7:	74 eb                	je     100ca4 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cc3:	89 04 24             	mov    %eax,(%esp)
  100cc6:	e8 f5 fe ff ff       	call   100bc0 <runcmd>
  100ccb:	85 c0                	test   %eax,%eax
  100ccd:	78 02                	js     100cd1 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100ccf:	eb d3                	jmp    100ca4 <kmonitor+0x2f>
                break;
  100cd1:	90                   	nop
            }
        }
    }
}
  100cd2:	90                   	nop
  100cd3:	c9                   	leave  
  100cd4:	c3                   	ret    

00100cd5 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cd5:	55                   	push   %ebp
  100cd6:	89 e5                	mov    %esp,%ebp
  100cd8:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100ce2:	eb 3d                	jmp    100d21 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100ce4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce7:	89 d0                	mov    %edx,%eax
  100ce9:	01 c0                	add    %eax,%eax
  100ceb:	01 d0                	add    %edx,%eax
  100ced:	c1 e0 02             	shl    $0x2,%eax
  100cf0:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cf5:	8b 08                	mov    (%eax),%ecx
  100cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cfa:	89 d0                	mov    %edx,%eax
  100cfc:	01 c0                	add    %eax,%eax
  100cfe:	01 d0                	add    %edx,%eax
  100d00:	c1 e0 02             	shl    $0x2,%eax
  100d03:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d08:	8b 00                	mov    (%eax),%eax
  100d0a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d12:	c7 04 24 c9 35 10 00 	movl   $0x1035c9,(%esp)
  100d19:	e8 3e f5 ff ff       	call   10025c <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d1e:	ff 45 f4             	incl   -0xc(%ebp)
  100d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d24:	83 f8 02             	cmp    $0x2,%eax
  100d27:	76 bb                	jbe    100ce4 <mon_help+0xf>
    }
    return 0;
  100d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d2e:	c9                   	leave  
  100d2f:	c3                   	ret    

00100d30 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d30:	55                   	push   %ebp
  100d31:	89 e5                	mov    %esp,%ebp
  100d33:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d36:	e8 c7 fb ff ff       	call   100902 <print_kerninfo>
    return 0;
  100d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d40:	c9                   	leave  
  100d41:	c3                   	ret    

00100d42 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d42:	55                   	push   %ebp
  100d43:	89 e5                	mov    %esp,%ebp
  100d45:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d48:	e8 00 fd ff ff       	call   100a4d <print_stackframe>
    return 0;
  100d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d52:	c9                   	leave  
  100d53:	c3                   	ret    

00100d54 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d54:	55                   	push   %ebp
  100d55:	89 e5                	mov    %esp,%ebp
  100d57:	83 ec 28             	sub    $0x28,%esp
  100d5a:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d60:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d64:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d68:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d6c:	ee                   	out    %al,(%dx)
  100d6d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d73:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d77:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d7b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d7f:	ee                   	out    %al,(%dx)
  100d80:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d86:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d8a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d8e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d92:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d93:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d9a:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d9d:	c7 04 24 d2 35 10 00 	movl   $0x1035d2,(%esp)
  100da4:	e8 b3 f4 ff ff       	call   10025c <cprintf>
    pic_enable(IRQ_TIMER);
  100da9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100db0:	e8 ca 08 00 00       	call   10167f <pic_enable>
}
  100db5:	90                   	nop
  100db6:	c9                   	leave  
  100db7:	c3                   	ret    

00100db8 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100db8:	55                   	push   %ebp
  100db9:	89 e5                	mov    %esp,%ebp
  100dbb:	83 ec 10             	sub    $0x10,%esp
  100dbe:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dc4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dc8:	89 c2                	mov    %eax,%edx
  100dca:	ec                   	in     (%dx),%al
  100dcb:	88 45 f1             	mov    %al,-0xf(%ebp)
  100dce:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dd4:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dd8:	89 c2                	mov    %eax,%edx
  100dda:	ec                   	in     (%dx),%al
  100ddb:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dde:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100de8:	89 c2                	mov    %eax,%edx
  100dea:	ec                   	in     (%dx),%al
  100deb:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dee:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100df4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100df8:	89 c2                	mov    %eax,%edx
  100dfa:	ec                   	in     (%dx),%al
  100dfb:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dfe:	90                   	nop
  100dff:	c9                   	leave  
  100e00:	c3                   	ret    

00100e01 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e01:	55                   	push   %ebp
  100e02:	89 e5                	mov    %esp,%ebp
  100e04:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e07:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e11:	0f b7 00             	movzwl (%eax),%eax
  100e14:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e23:	0f b7 00             	movzwl (%eax),%eax
  100e26:	0f b7 c0             	movzwl %ax,%eax
  100e29:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e2e:	74 12                	je     100e42 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e30:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e37:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e3e:	b4 03 
  100e40:	eb 13                	jmp    100e55 <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e45:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e49:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e4c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e53:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e55:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e5c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e60:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e64:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e68:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e6c:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e6d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e74:	40                   	inc    %eax
  100e75:	0f b7 c0             	movzwl %ax,%eax
  100e78:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e7c:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e80:	89 c2                	mov    %eax,%edx
  100e82:	ec                   	in     (%dx),%al
  100e83:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e86:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e8a:	0f b6 c0             	movzbl %al,%eax
  100e8d:	c1 e0 08             	shl    $0x8,%eax
  100e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e93:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e9e:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ea6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100eaa:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100eab:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb2:	40                   	inc    %eax
  100eb3:	0f b7 c0             	movzwl %ax,%eax
  100eb6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eba:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ebe:	89 c2                	mov    %eax,%edx
  100ec0:	ec                   	in     (%dx),%al
  100ec1:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100ec4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ec8:	0f b6 c0             	movzbl %al,%eax
  100ecb:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ece:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed1:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ed9:	0f b7 c0             	movzwl %ax,%eax
  100edc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ee2:	90                   	nop
  100ee3:	c9                   	leave  
  100ee4:	c3                   	ret    

00100ee5 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ee5:	55                   	push   %ebp
  100ee6:	89 e5                	mov    %esp,%ebp
  100ee8:	83 ec 48             	sub    $0x48,%esp
  100eeb:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ef1:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100ef9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100efd:	ee                   	out    %al,(%dx)
  100efe:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f04:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f08:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f0c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f10:	ee                   	out    %al,(%dx)
  100f11:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f17:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f1b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f1f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f23:	ee                   	out    %al,(%dx)
  100f24:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f2a:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f2e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f32:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f36:	ee                   	out    %al,(%dx)
  100f37:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f3d:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f41:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f45:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f49:	ee                   	out    %al,(%dx)
  100f4a:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f50:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f54:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f58:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5c:	ee                   	out    %al,(%dx)
  100f5d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f63:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f67:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f6b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f6f:	ee                   	out    %al,(%dx)
  100f70:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f76:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f7a:	89 c2                	mov    %eax,%edx
  100f7c:	ec                   	in     (%dx),%al
  100f7d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f84:	3c ff                	cmp    $0xff,%al
  100f86:	0f 95 c0             	setne  %al
  100f89:	0f b6 c0             	movzbl %al,%eax
  100f8c:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f91:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f97:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f9b:	89 c2                	mov    %eax,%edx
  100f9d:	ec                   	in     (%dx),%al
  100f9e:	88 45 f1             	mov    %al,-0xf(%ebp)
  100fa1:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100fa7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100fab:	89 c2                	mov    %eax,%edx
  100fad:	ec                   	in     (%dx),%al
  100fae:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fb1:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fb6:	85 c0                	test   %eax,%eax
  100fb8:	74 0c                	je     100fc6 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fba:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fc1:	e8 b9 06 00 00       	call   10167f <pic_enable>
    }
}
  100fc6:	90                   	nop
  100fc7:	c9                   	leave  
  100fc8:	c3                   	ret    

00100fc9 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fc9:	55                   	push   %ebp
  100fca:	89 e5                	mov    %esp,%ebp
  100fcc:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fcf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fd6:	eb 08                	jmp    100fe0 <lpt_putc_sub+0x17>
        delay();
  100fd8:	e8 db fd ff ff       	call   100db8 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fdd:	ff 45 fc             	incl   -0x4(%ebp)
  100fe0:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fe6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fea:	89 c2                	mov    %eax,%edx
  100fec:	ec                   	in     (%dx),%al
  100fed:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ff0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100ff4:	84 c0                	test   %al,%al
  100ff6:	78 09                	js     101001 <lpt_putc_sub+0x38>
  100ff8:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fff:	7e d7                	jle    100fd8 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101001:	8b 45 08             	mov    0x8(%ebp),%eax
  101004:	0f b6 c0             	movzbl %al,%eax
  101007:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  10100d:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101010:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101014:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101018:	ee                   	out    %al,(%dx)
  101019:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10101f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101023:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101027:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10102b:	ee                   	out    %al,(%dx)
  10102c:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101032:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101036:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10103a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10103e:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10103f:	90                   	nop
  101040:	c9                   	leave  
  101041:	c3                   	ret    

00101042 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101042:	55                   	push   %ebp
  101043:	89 e5                	mov    %esp,%ebp
  101045:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101048:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10104c:	74 0d                	je     10105b <lpt_putc+0x19>
        lpt_putc_sub(c);
  10104e:	8b 45 08             	mov    0x8(%ebp),%eax
  101051:	89 04 24             	mov    %eax,(%esp)
  101054:	e8 70 ff ff ff       	call   100fc9 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101059:	eb 24                	jmp    10107f <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  10105b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101062:	e8 62 ff ff ff       	call   100fc9 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101067:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10106e:	e8 56 ff ff ff       	call   100fc9 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101073:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107a:	e8 4a ff ff ff       	call   100fc9 <lpt_putc_sub>
}
  10107f:	90                   	nop
  101080:	c9                   	leave  
  101081:	c3                   	ret    

00101082 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101082:	55                   	push   %ebp
  101083:	89 e5                	mov    %esp,%ebp
  101085:	53                   	push   %ebx
  101086:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101089:	8b 45 08             	mov    0x8(%ebp),%eax
  10108c:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101091:	85 c0                	test   %eax,%eax
  101093:	75 07                	jne    10109c <cga_putc+0x1a>
        c |= 0x0700;
  101095:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10109c:	8b 45 08             	mov    0x8(%ebp),%eax
  10109f:	0f b6 c0             	movzbl %al,%eax
  1010a2:	83 f8 0a             	cmp    $0xa,%eax
  1010a5:	74 55                	je     1010fc <cga_putc+0x7a>
  1010a7:	83 f8 0d             	cmp    $0xd,%eax
  1010aa:	74 63                	je     10110f <cga_putc+0x8d>
  1010ac:	83 f8 08             	cmp    $0x8,%eax
  1010af:	0f 85 94 00 00 00    	jne    101149 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  1010b5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010bc:	85 c0                	test   %eax,%eax
  1010be:	0f 84 af 00 00 00    	je     101173 <cga_putc+0xf1>
            crt_pos --;
  1010c4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010cb:	48                   	dec    %eax
  1010cc:	0f b7 c0             	movzwl %ax,%eax
  1010cf:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d8:	98                   	cwtl   
  1010d9:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010de:	98                   	cwtl   
  1010df:	83 c8 20             	or     $0x20,%eax
  1010e2:	98                   	cwtl   
  1010e3:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  1010e9:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010f0:	01 c9                	add    %ecx,%ecx
  1010f2:	01 ca                	add    %ecx,%edx
  1010f4:	0f b7 c0             	movzwl %ax,%eax
  1010f7:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010fa:	eb 77                	jmp    101173 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  1010fc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101103:	83 c0 50             	add    $0x50,%eax
  101106:	0f b7 c0             	movzwl %ax,%eax
  101109:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10110f:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101116:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10111d:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101122:	89 c8                	mov    %ecx,%eax
  101124:	f7 e2                	mul    %edx
  101126:	c1 ea 06             	shr    $0x6,%edx
  101129:	89 d0                	mov    %edx,%eax
  10112b:	c1 e0 02             	shl    $0x2,%eax
  10112e:	01 d0                	add    %edx,%eax
  101130:	c1 e0 04             	shl    $0x4,%eax
  101133:	29 c1                	sub    %eax,%ecx
  101135:	89 c8                	mov    %ecx,%eax
  101137:	0f b7 c0             	movzwl %ax,%eax
  10113a:	29 c3                	sub    %eax,%ebx
  10113c:	89 d8                	mov    %ebx,%eax
  10113e:	0f b7 c0             	movzwl %ax,%eax
  101141:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101147:	eb 2b                	jmp    101174 <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101149:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10114f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101156:	8d 50 01             	lea    0x1(%eax),%edx
  101159:	0f b7 d2             	movzwl %dx,%edx
  10115c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101163:	01 c0                	add    %eax,%eax
  101165:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101168:	8b 45 08             	mov    0x8(%ebp),%eax
  10116b:	0f b7 c0             	movzwl %ax,%eax
  10116e:	66 89 02             	mov    %ax,(%edx)
        break;
  101171:	eb 01                	jmp    101174 <cga_putc+0xf2>
        break;
  101173:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101174:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10117b:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101180:	76 5d                	jbe    1011df <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101182:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101187:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10118d:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101192:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101199:	00 
  10119a:	89 54 24 04          	mov    %edx,0x4(%esp)
  10119e:	89 04 24             	mov    %eax,(%esp)
  1011a1:	e8 47 19 00 00       	call   102aed <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a6:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011ad:	eb 14                	jmp    1011c3 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  1011af:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011b7:	01 d2                	add    %edx,%edx
  1011b9:	01 d0                	add    %edx,%eax
  1011bb:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c0:	ff 45 f4             	incl   -0xc(%ebp)
  1011c3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011ca:	7e e3                	jle    1011af <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  1011cc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d3:	83 e8 50             	sub    $0x50,%eax
  1011d6:	0f b7 c0             	movzwl %ax,%eax
  1011d9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011df:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011e6:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011ea:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011ee:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011f2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011f6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011f7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011fe:	c1 e8 08             	shr    $0x8,%eax
  101201:	0f b7 c0             	movzwl %ax,%eax
  101204:	0f b6 c0             	movzbl %al,%eax
  101207:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10120e:	42                   	inc    %edx
  10120f:	0f b7 d2             	movzwl %dx,%edx
  101212:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101216:	88 45 e9             	mov    %al,-0x17(%ebp)
  101219:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10121d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101221:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101222:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101229:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  10122d:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101231:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101235:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101239:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10123a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101241:	0f b6 c0             	movzbl %al,%eax
  101244:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10124b:	42                   	inc    %edx
  10124c:	0f b7 d2             	movzwl %dx,%edx
  10124f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101253:	88 45 f1             	mov    %al,-0xf(%ebp)
  101256:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10125a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10125e:	ee                   	out    %al,(%dx)
}
  10125f:	90                   	nop
  101260:	83 c4 34             	add    $0x34,%esp
  101263:	5b                   	pop    %ebx
  101264:	5d                   	pop    %ebp
  101265:	c3                   	ret    

00101266 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101266:	55                   	push   %ebp
  101267:	89 e5                	mov    %esp,%ebp
  101269:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101273:	eb 08                	jmp    10127d <serial_putc_sub+0x17>
        delay();
  101275:	e8 3e fb ff ff       	call   100db8 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127a:	ff 45 fc             	incl   -0x4(%ebp)
  10127d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101283:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101287:	89 c2                	mov    %eax,%edx
  101289:	ec                   	in     (%dx),%al
  10128a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10128d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101291:	0f b6 c0             	movzbl %al,%eax
  101294:	83 e0 20             	and    $0x20,%eax
  101297:	85 c0                	test   %eax,%eax
  101299:	75 09                	jne    1012a4 <serial_putc_sub+0x3e>
  10129b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012a2:	7e d1                	jle    101275 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1012a7:	0f b6 c0             	movzbl %al,%eax
  1012aa:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012b0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012b7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012bb:	ee                   	out    %al,(%dx)
}
  1012bc:	90                   	nop
  1012bd:	c9                   	leave  
  1012be:	c3                   	ret    

001012bf <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012c5:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012c9:	74 0d                	je     1012d8 <serial_putc+0x19>
        serial_putc_sub(c);
  1012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ce:	89 04 24             	mov    %eax,(%esp)
  1012d1:	e8 90 ff ff ff       	call   101266 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012d6:	eb 24                	jmp    1012fc <serial_putc+0x3d>
        serial_putc_sub('\b');
  1012d8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012df:	e8 82 ff ff ff       	call   101266 <serial_putc_sub>
        serial_putc_sub(' ');
  1012e4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012eb:	e8 76 ff ff ff       	call   101266 <serial_putc_sub>
        serial_putc_sub('\b');
  1012f0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f7:	e8 6a ff ff ff       	call   101266 <serial_putc_sub>
}
  1012fc:	90                   	nop
  1012fd:	c9                   	leave  
  1012fe:	c3                   	ret    

001012ff <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012ff:	55                   	push   %ebp
  101300:	89 e5                	mov    %esp,%ebp
  101302:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101305:	eb 33                	jmp    10133a <cons_intr+0x3b>
        if (c != 0) {
  101307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10130b:	74 2d                	je     10133a <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10130d:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101312:	8d 50 01             	lea    0x1(%eax),%edx
  101315:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10131b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10131e:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101324:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101329:	3d 00 02 00 00       	cmp    $0x200,%eax
  10132e:	75 0a                	jne    10133a <cons_intr+0x3b>
                cons.wpos = 0;
  101330:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101337:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10133a:	8b 45 08             	mov    0x8(%ebp),%eax
  10133d:	ff d0                	call   *%eax
  10133f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101342:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101346:	75 bf                	jne    101307 <cons_intr+0x8>
            }
        }
    }
}
  101348:	90                   	nop
  101349:	c9                   	leave  
  10134a:	c3                   	ret    

0010134b <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10134b:	55                   	push   %ebp
  10134c:	89 e5                	mov    %esp,%ebp
  10134e:	83 ec 10             	sub    $0x10,%esp
  101351:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101357:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10135b:	89 c2                	mov    %eax,%edx
  10135d:	ec                   	in     (%dx),%al
  10135e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101361:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101365:	0f b6 c0             	movzbl %al,%eax
  101368:	83 e0 01             	and    $0x1,%eax
  10136b:	85 c0                	test   %eax,%eax
  10136d:	75 07                	jne    101376 <serial_proc_data+0x2b>
        return -1;
  10136f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101374:	eb 2a                	jmp    1013a0 <serial_proc_data+0x55>
  101376:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10137c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101380:	89 c2                	mov    %eax,%edx
  101382:	ec                   	in     (%dx),%al
  101383:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101386:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10138a:	0f b6 c0             	movzbl %al,%eax
  10138d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101390:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101394:	75 07                	jne    10139d <serial_proc_data+0x52>
        c = '\b';
  101396:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10139d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013a0:	c9                   	leave  
  1013a1:	c3                   	ret    

001013a2 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013a2:	55                   	push   %ebp
  1013a3:	89 e5                	mov    %esp,%ebp
  1013a5:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013a8:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013ad:	85 c0                	test   %eax,%eax
  1013af:	74 0c                	je     1013bd <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013b1:	c7 04 24 4b 13 10 00 	movl   $0x10134b,(%esp)
  1013b8:	e8 42 ff ff ff       	call   1012ff <cons_intr>
    }
}
  1013bd:	90                   	nop
  1013be:	c9                   	leave  
  1013bf:	c3                   	ret    

001013c0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c0:	55                   	push   %ebp
  1013c1:	89 e5                	mov    %esp,%ebp
  1013c3:	83 ec 38             	sub    $0x38,%esp
  1013c6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013cf:	89 c2                	mov    %eax,%edx
  1013d1:	ec                   	in     (%dx),%al
  1013d2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013d9:	0f b6 c0             	movzbl %al,%eax
  1013dc:	83 e0 01             	and    $0x1,%eax
  1013df:	85 c0                	test   %eax,%eax
  1013e1:	75 0a                	jne    1013ed <kbd_proc_data+0x2d>
        return -1;
  1013e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e8:	e9 55 01 00 00       	jmp    101542 <kbd_proc_data+0x182>
  1013ed:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1013f6:	89 c2                	mov    %eax,%edx
  1013f8:	ec                   	in     (%dx),%al
  1013f9:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013fc:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101400:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101403:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101407:	75 17                	jne    101420 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101409:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140e:	83 c8 40             	or     $0x40,%eax
  101411:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101416:	b8 00 00 00 00       	mov    $0x0,%eax
  10141b:	e9 22 01 00 00       	jmp    101542 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  101420:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101424:	84 c0                	test   %al,%al
  101426:	79 45                	jns    10146d <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101428:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142d:	83 e0 40             	and    $0x40,%eax
  101430:	85 c0                	test   %eax,%eax
  101432:	75 08                	jne    10143c <kbd_proc_data+0x7c>
  101434:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101438:	24 7f                	and    $0x7f,%al
  10143a:	eb 04                	jmp    101440 <kbd_proc_data+0x80>
  10143c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101440:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101443:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101447:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10144e:	0c 40                	or     $0x40,%al
  101450:	0f b6 c0             	movzbl %al,%eax
  101453:	f7 d0                	not    %eax
  101455:	89 c2                	mov    %eax,%edx
  101457:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10145c:	21 d0                	and    %edx,%eax
  10145e:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101463:	b8 00 00 00 00       	mov    $0x0,%eax
  101468:	e9 d5 00 00 00       	jmp    101542 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  10146d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101472:	83 e0 40             	and    $0x40,%eax
  101475:	85 c0                	test   %eax,%eax
  101477:	74 11                	je     10148a <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101479:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10147d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101482:	83 e0 bf             	and    $0xffffffbf,%eax
  101485:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10148a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148e:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101495:	0f b6 d0             	movzbl %al,%edx
  101498:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149d:	09 d0                	or     %edx,%eax
  10149f:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a8:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014af:	0f b6 d0             	movzbl %al,%edx
  1014b2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b7:	31 d0                	xor    %edx,%eax
  1014b9:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014be:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c3:	83 e0 03             	and    $0x3,%eax
  1014c6:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014cd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d1:	01 d0                	add    %edx,%eax
  1014d3:	0f b6 00             	movzbl (%eax),%eax
  1014d6:	0f b6 c0             	movzbl %al,%eax
  1014d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014dc:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e1:	83 e0 08             	and    $0x8,%eax
  1014e4:	85 c0                	test   %eax,%eax
  1014e6:	74 22                	je     10150a <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1014e8:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014ec:	7e 0c                	jle    1014fa <kbd_proc_data+0x13a>
  1014ee:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f2:	7f 06                	jg     1014fa <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1014f4:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014f8:	eb 10                	jmp    10150a <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1014fa:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014fe:	7e 0a                	jle    10150a <kbd_proc_data+0x14a>
  101500:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101504:	7f 04                	jg     10150a <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101506:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10150a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10150f:	f7 d0                	not    %eax
  101511:	83 e0 06             	and    $0x6,%eax
  101514:	85 c0                	test   %eax,%eax
  101516:	75 27                	jne    10153f <kbd_proc_data+0x17f>
  101518:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10151f:	75 1e                	jne    10153f <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  101521:	c7 04 24 ed 35 10 00 	movl   $0x1035ed,(%esp)
  101528:	e8 2f ed ff ff       	call   10025c <cprintf>
  10152d:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101533:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101537:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10153b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10153e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101542:	c9                   	leave  
  101543:	c3                   	ret    

00101544 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101544:	55                   	push   %ebp
  101545:	89 e5                	mov    %esp,%ebp
  101547:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10154a:	c7 04 24 c0 13 10 00 	movl   $0x1013c0,(%esp)
  101551:	e8 a9 fd ff ff       	call   1012ff <cons_intr>
}
  101556:	90                   	nop
  101557:	c9                   	leave  
  101558:	c3                   	ret    

00101559 <kbd_init>:

static void
kbd_init(void) {
  101559:	55                   	push   %ebp
  10155a:	89 e5                	mov    %esp,%ebp
  10155c:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10155f:	e8 e0 ff ff ff       	call   101544 <kbd_intr>
    pic_enable(IRQ_KBD);
  101564:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10156b:	e8 0f 01 00 00       	call   10167f <pic_enable>
}
  101570:	90                   	nop
  101571:	c9                   	leave  
  101572:	c3                   	ret    

00101573 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101573:	55                   	push   %ebp
  101574:	89 e5                	mov    %esp,%ebp
  101576:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101579:	e8 83 f8 ff ff       	call   100e01 <cga_init>
    serial_init();
  10157e:	e8 62 f9 ff ff       	call   100ee5 <serial_init>
    kbd_init();
  101583:	e8 d1 ff ff ff       	call   101559 <kbd_init>
    if (!serial_exists) {
  101588:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10158d:	85 c0                	test   %eax,%eax
  10158f:	75 0c                	jne    10159d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101591:	c7 04 24 f9 35 10 00 	movl   $0x1035f9,(%esp)
  101598:	e8 bf ec ff ff       	call   10025c <cprintf>
    }
}
  10159d:	90                   	nop
  10159e:	c9                   	leave  
  10159f:	c3                   	ret    

001015a0 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015a0:	55                   	push   %ebp
  1015a1:	89 e5                	mov    %esp,%ebp
  1015a3:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a9:	89 04 24             	mov    %eax,(%esp)
  1015ac:	e8 91 fa ff ff       	call   101042 <lpt_putc>
    cga_putc(c);
  1015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b4:	89 04 24             	mov    %eax,(%esp)
  1015b7:	e8 c6 fa ff ff       	call   101082 <cga_putc>
    serial_putc(c);
  1015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bf:	89 04 24             	mov    %eax,(%esp)
  1015c2:	e8 f8 fc ff ff       	call   1012bf <serial_putc>
}
  1015c7:	90                   	nop
  1015c8:	c9                   	leave  
  1015c9:	c3                   	ret    

001015ca <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ca:	55                   	push   %ebp
  1015cb:	89 e5                	mov    %esp,%ebp
  1015cd:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d0:	e8 cd fd ff ff       	call   1013a2 <serial_intr>
    kbd_intr();
  1015d5:	e8 6a ff ff ff       	call   101544 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015da:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015e5:	39 c2                	cmp    %eax,%edx
  1015e7:	74 36                	je     10161f <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015e9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015ee:	8d 50 01             	lea    0x1(%eax),%edx
  1015f1:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015f7:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015fe:	0f b6 c0             	movzbl %al,%eax
  101601:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101604:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101609:	3d 00 02 00 00       	cmp    $0x200,%eax
  10160e:	75 0a                	jne    10161a <cons_getc+0x50>
            cons.rpos = 0;
  101610:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101617:	00 00 00 
        }
        return c;
  10161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10161d:	eb 05                	jmp    101624 <cons_getc+0x5a>
    }
    return 0;
  10161f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101624:	c9                   	leave  
  101625:	c3                   	ret    

00101626 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101626:	55                   	push   %ebp
  101627:	89 e5                	mov    %esp,%ebp
  101629:	83 ec 14             	sub    $0x14,%esp
  10162c:	8b 45 08             	mov    0x8(%ebp),%eax
  10162f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101633:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101636:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10163c:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101641:	85 c0                	test   %eax,%eax
  101643:	74 37                	je     10167c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101648:	0f b6 c0             	movzbl %al,%eax
  10164b:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101651:	88 45 f9             	mov    %al,-0x7(%ebp)
  101654:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101658:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10165c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10165d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101661:	c1 e8 08             	shr    $0x8,%eax
  101664:	0f b7 c0             	movzwl %ax,%eax
  101667:	0f b6 c0             	movzbl %al,%eax
  10166a:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101670:	88 45 fd             	mov    %al,-0x3(%ebp)
  101673:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101677:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10167b:	ee                   	out    %al,(%dx)
    }
}
  10167c:	90                   	nop
  10167d:	c9                   	leave  
  10167e:	c3                   	ret    

0010167f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10167f:	55                   	push   %ebp
  101680:	89 e5                	mov    %esp,%ebp
  101682:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101685:	8b 45 08             	mov    0x8(%ebp),%eax
  101688:	ba 01 00 00 00       	mov    $0x1,%edx
  10168d:	88 c1                	mov    %al,%cl
  10168f:	d3 e2                	shl    %cl,%edx
  101691:	89 d0                	mov    %edx,%eax
  101693:	98                   	cwtl   
  101694:	f7 d0                	not    %eax
  101696:	0f bf d0             	movswl %ax,%edx
  101699:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016a0:	98                   	cwtl   
  1016a1:	21 d0                	and    %edx,%eax
  1016a3:	98                   	cwtl   
  1016a4:	0f b7 c0             	movzwl %ax,%eax
  1016a7:	89 04 24             	mov    %eax,(%esp)
  1016aa:	e8 77 ff ff ff       	call   101626 <pic_setmask>
}
  1016af:	90                   	nop
  1016b0:	c9                   	leave  
  1016b1:	c3                   	ret    

001016b2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016b2:	55                   	push   %ebp
  1016b3:	89 e5                	mov    %esp,%ebp
  1016b5:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016b8:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016bf:	00 00 00 
  1016c2:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016c8:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016cc:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016d0:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016d4:	ee                   	out    %al,(%dx)
  1016d5:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016db:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016df:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016e3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
  1016e8:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016ee:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1016f2:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016f6:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016fa:	ee                   	out    %al,(%dx)
  1016fb:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101701:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101705:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101709:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
  10170e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101714:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101718:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10171c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101720:	ee                   	out    %al,(%dx)
  101721:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101727:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  10172b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10172f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101733:	ee                   	out    %al,(%dx)
  101734:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10173a:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  10173e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101742:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101746:	ee                   	out    %al,(%dx)
  101747:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10174d:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101751:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101755:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101759:	ee                   	out    %al,(%dx)
  10175a:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101760:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  101764:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101768:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
  10176d:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101773:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  101777:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10177b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10177f:	ee                   	out    %al,(%dx)
  101780:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101786:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10178a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
  101793:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101799:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10179d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017a1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017a5:	ee                   	out    %al,(%dx)
  1017a6:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1017ac:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  1017b0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017b4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017b8:	ee                   	out    %al,(%dx)
  1017b9:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017bf:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017c3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017c7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017cb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017cc:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d3:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1017d8:	74 0f                	je     1017e9 <pic_init+0x137>
        pic_setmask(irq_mask);
  1017da:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e1:	89 04 24             	mov    %eax,(%esp)
  1017e4:	e8 3d fe ff ff       	call   101626 <pic_setmask>
    }
}
  1017e9:	90                   	nop
  1017ea:	c9                   	leave  
  1017eb:	c3                   	ret    

001017ec <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017ec:	55                   	push   %ebp
  1017ed:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017ef:	fb                   	sti    
    sti();
}
  1017f0:	90                   	nop
  1017f1:	5d                   	pop    %ebp
  1017f2:	c3                   	ret    

001017f3 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017f3:	55                   	push   %ebp
  1017f4:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017f6:	fa                   	cli    
    cli();
}
  1017f7:	90                   	nop
  1017f8:	5d                   	pop    %ebp
  1017f9:	c3                   	ret    

001017fa <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017fa:	55                   	push   %ebp
  1017fb:	89 e5                	mov    %esp,%ebp
  1017fd:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101800:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101807:	00 
  101808:	c7 04 24 20 36 10 00 	movl   $0x103620,(%esp)
  10180f:	e8 48 ea ff ff       	call   10025c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101814:	90                   	nop
  101815:	c9                   	leave  
  101816:	c3                   	ret    

00101817 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101817:	55                   	push   %ebp
  101818:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  10181a:	90                   	nop
  10181b:	5d                   	pop    %ebp
  10181c:	c3                   	ret    

0010181d <trapname>:

static const char *
trapname(int trapno) {
  10181d:	55                   	push   %ebp
  10181e:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101820:	8b 45 08             	mov    0x8(%ebp),%eax
  101823:	83 f8 13             	cmp    $0x13,%eax
  101826:	77 0c                	ja     101834 <trapname+0x17>
        return excnames[trapno];
  101828:	8b 45 08             	mov    0x8(%ebp),%eax
  10182b:	8b 04 85 80 39 10 00 	mov    0x103980(,%eax,4),%eax
  101832:	eb 18                	jmp    10184c <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101834:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101838:	7e 0d                	jle    101847 <trapname+0x2a>
  10183a:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10183e:	7f 07                	jg     101847 <trapname+0x2a>
        return "Hardware Interrupt";
  101840:	b8 2a 36 10 00       	mov    $0x10362a,%eax
  101845:	eb 05                	jmp    10184c <trapname+0x2f>
    }
    return "(unknown trap)";
  101847:	b8 3d 36 10 00       	mov    $0x10363d,%eax
}
  10184c:	5d                   	pop    %ebp
  10184d:	c3                   	ret    

0010184e <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  10184e:	55                   	push   %ebp
  10184f:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101851:	8b 45 08             	mov    0x8(%ebp),%eax
  101854:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101858:	83 f8 08             	cmp    $0x8,%eax
  10185b:	0f 94 c0             	sete   %al
  10185e:	0f b6 c0             	movzbl %al,%eax
}
  101861:	5d                   	pop    %ebp
  101862:	c3                   	ret    

00101863 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101863:	55                   	push   %ebp
  101864:	89 e5                	mov    %esp,%ebp
  101866:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101869:	8b 45 08             	mov    0x8(%ebp),%eax
  10186c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101870:	c7 04 24 7e 36 10 00 	movl   $0x10367e,(%esp)
  101877:	e8 e0 e9 ff ff       	call   10025c <cprintf>
    print_regs(&tf->tf_regs);
  10187c:	8b 45 08             	mov    0x8(%ebp),%eax
  10187f:	89 04 24             	mov    %eax,(%esp)
  101882:	e8 8f 01 00 00       	call   101a16 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101887:	8b 45 08             	mov    0x8(%ebp),%eax
  10188a:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  10188e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101892:	c7 04 24 8f 36 10 00 	movl   $0x10368f,(%esp)
  101899:	e8 be e9 ff ff       	call   10025c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  10189e:	8b 45 08             	mov    0x8(%ebp),%eax
  1018a1:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1018a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018a9:	c7 04 24 a2 36 10 00 	movl   $0x1036a2,(%esp)
  1018b0:	e8 a7 e9 ff ff       	call   10025c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b8:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1018bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018c0:	c7 04 24 b5 36 10 00 	movl   $0x1036b5,(%esp)
  1018c7:	e8 90 e9 ff ff       	call   10025c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1018cf:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1018d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018d7:	c7 04 24 c8 36 10 00 	movl   $0x1036c8,(%esp)
  1018de:	e8 79 e9 ff ff       	call   10025c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1018e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1018e6:	8b 40 30             	mov    0x30(%eax),%eax
  1018e9:	89 04 24             	mov    %eax,(%esp)
  1018ec:	e8 2c ff ff ff       	call   10181d <trapname>
  1018f1:	89 c2                	mov    %eax,%edx
  1018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1018f6:	8b 40 30             	mov    0x30(%eax),%eax
  1018f9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1018fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101901:	c7 04 24 db 36 10 00 	movl   $0x1036db,(%esp)
  101908:	e8 4f e9 ff ff       	call   10025c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  10190d:	8b 45 08             	mov    0x8(%ebp),%eax
  101910:	8b 40 34             	mov    0x34(%eax),%eax
  101913:	89 44 24 04          	mov    %eax,0x4(%esp)
  101917:	c7 04 24 ed 36 10 00 	movl   $0x1036ed,(%esp)
  10191e:	e8 39 e9 ff ff       	call   10025c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101923:	8b 45 08             	mov    0x8(%ebp),%eax
  101926:	8b 40 38             	mov    0x38(%eax),%eax
  101929:	89 44 24 04          	mov    %eax,0x4(%esp)
  10192d:	c7 04 24 fc 36 10 00 	movl   $0x1036fc,(%esp)
  101934:	e8 23 e9 ff ff       	call   10025c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101939:	8b 45 08             	mov    0x8(%ebp),%eax
  10193c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101940:	89 44 24 04          	mov    %eax,0x4(%esp)
  101944:	c7 04 24 0b 37 10 00 	movl   $0x10370b,(%esp)
  10194b:	e8 0c e9 ff ff       	call   10025c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101950:	8b 45 08             	mov    0x8(%ebp),%eax
  101953:	8b 40 40             	mov    0x40(%eax),%eax
  101956:	89 44 24 04          	mov    %eax,0x4(%esp)
  10195a:	c7 04 24 1e 37 10 00 	movl   $0x10371e,(%esp)
  101961:	e8 f6 e8 ff ff       	call   10025c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101966:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10196d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101974:	eb 3d                	jmp    1019b3 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101976:	8b 45 08             	mov    0x8(%ebp),%eax
  101979:	8b 50 40             	mov    0x40(%eax),%edx
  10197c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10197f:	21 d0                	and    %edx,%eax
  101981:	85 c0                	test   %eax,%eax
  101983:	74 28                	je     1019ad <print_trapframe+0x14a>
  101985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101988:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  10198f:	85 c0                	test   %eax,%eax
  101991:	74 1a                	je     1019ad <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101996:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  10199d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019a1:	c7 04 24 2d 37 10 00 	movl   $0x10372d,(%esp)
  1019a8:	e8 af e8 ff ff       	call   10025c <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019ad:	ff 45 f4             	incl   -0xc(%ebp)
  1019b0:	d1 65 f0             	shll   -0x10(%ebp)
  1019b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019b6:	83 f8 17             	cmp    $0x17,%eax
  1019b9:	76 bb                	jbe    101976 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  1019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019be:	8b 40 40             	mov    0x40(%eax),%eax
  1019c1:	c1 e8 0c             	shr    $0xc,%eax
  1019c4:	83 e0 03             	and    $0x3,%eax
  1019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019cb:	c7 04 24 31 37 10 00 	movl   $0x103731,(%esp)
  1019d2:	e8 85 e8 ff ff       	call   10025c <cprintf>

    if (!trap_in_kernel(tf)) {
  1019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019da:	89 04 24             	mov    %eax,(%esp)
  1019dd:	e8 6c fe ff ff       	call   10184e <trap_in_kernel>
  1019e2:	85 c0                	test   %eax,%eax
  1019e4:	75 2d                	jne    101a13 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e9:	8b 40 44             	mov    0x44(%eax),%eax
  1019ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f0:	c7 04 24 3a 37 10 00 	movl   $0x10373a,(%esp)
  1019f7:	e8 60 e8 ff ff       	call   10025c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  1019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ff:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a07:	c7 04 24 49 37 10 00 	movl   $0x103749,(%esp)
  101a0e:	e8 49 e8 ff ff       	call   10025c <cprintf>
    }
}
  101a13:	90                   	nop
  101a14:	c9                   	leave  
  101a15:	c3                   	ret    

00101a16 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101a16:	55                   	push   %ebp
  101a17:	89 e5                	mov    %esp,%ebp
  101a19:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1f:	8b 00                	mov    (%eax),%eax
  101a21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a25:	c7 04 24 5c 37 10 00 	movl   $0x10375c,(%esp)
  101a2c:	e8 2b e8 ff ff       	call   10025c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a31:	8b 45 08             	mov    0x8(%ebp),%eax
  101a34:	8b 40 04             	mov    0x4(%eax),%eax
  101a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3b:	c7 04 24 6b 37 10 00 	movl   $0x10376b,(%esp)
  101a42:	e8 15 e8 ff ff       	call   10025c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a47:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4a:	8b 40 08             	mov    0x8(%eax),%eax
  101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a51:	c7 04 24 7a 37 10 00 	movl   $0x10377a,(%esp)
  101a58:	e8 ff e7 ff ff       	call   10025c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	8b 40 0c             	mov    0xc(%eax),%eax
  101a63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a67:	c7 04 24 89 37 10 00 	movl   $0x103789,(%esp)
  101a6e:	e8 e9 e7 ff ff       	call   10025c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a73:	8b 45 08             	mov    0x8(%ebp),%eax
  101a76:	8b 40 10             	mov    0x10(%eax),%eax
  101a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7d:	c7 04 24 98 37 10 00 	movl   $0x103798,(%esp)
  101a84:	e8 d3 e7 ff ff       	call   10025c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101a89:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8c:	8b 40 14             	mov    0x14(%eax),%eax
  101a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a93:	c7 04 24 a7 37 10 00 	movl   $0x1037a7,(%esp)
  101a9a:	e8 bd e7 ff ff       	call   10025c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	8b 40 18             	mov    0x18(%eax),%eax
  101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa9:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  101ab0:	e8 a7 e7 ff ff       	call   10025c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab8:	8b 40 1c             	mov    0x1c(%eax),%eax
  101abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abf:	c7 04 24 c5 37 10 00 	movl   $0x1037c5,(%esp)
  101ac6:	e8 91 e7 ff ff       	call   10025c <cprintf>
}
  101acb:	90                   	nop
  101acc:	c9                   	leave  
  101acd:	c3                   	ret    

00101ace <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ace:	55                   	push   %ebp
  101acf:	89 e5                	mov    %esp,%ebp
  101ad1:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad7:	8b 40 30             	mov    0x30(%eax),%eax
  101ada:	83 f8 2f             	cmp    $0x2f,%eax
  101add:	77 1e                	ja     101afd <trap_dispatch+0x2f>
  101adf:	83 f8 2e             	cmp    $0x2e,%eax
  101ae2:	0f 83 bc 00 00 00    	jae    101ba4 <trap_dispatch+0xd6>
  101ae8:	83 f8 21             	cmp    $0x21,%eax
  101aeb:	74 40                	je     101b2d <trap_dispatch+0x5f>
  101aed:	83 f8 24             	cmp    $0x24,%eax
  101af0:	74 15                	je     101b07 <trap_dispatch+0x39>
  101af2:	83 f8 20             	cmp    $0x20,%eax
  101af5:	0f 84 ac 00 00 00    	je     101ba7 <trap_dispatch+0xd9>
  101afb:	eb 72                	jmp    101b6f <trap_dispatch+0xa1>
  101afd:	83 e8 78             	sub    $0x78,%eax
  101b00:	83 f8 01             	cmp    $0x1,%eax
  101b03:	77 6a                	ja     101b6f <trap_dispatch+0xa1>
  101b05:	eb 4c                	jmp    101b53 <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101b07:	e8 be fa ff ff       	call   1015ca <cons_getc>
  101b0c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101b0f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b13:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b17:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1f:	c7 04 24 d4 37 10 00 	movl   $0x1037d4,(%esp)
  101b26:	e8 31 e7 ff ff       	call   10025c <cprintf>
        break;
  101b2b:	eb 7b                	jmp    101ba8 <trap_dispatch+0xda>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101b2d:	e8 98 fa ff ff       	call   1015ca <cons_getc>
  101b32:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b35:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b39:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b3d:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b45:	c7 04 24 e6 37 10 00 	movl   $0x1037e6,(%esp)
  101b4c:	e8 0b e7 ff ff       	call   10025c <cprintf>
        break;
  101b51:	eb 55                	jmp    101ba8 <trap_dispatch+0xda>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101b53:	c7 44 24 08 f5 37 10 	movl   $0x1037f5,0x8(%esp)
  101b5a:	00 
  101b5b:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101b62:	00 
  101b63:	c7 04 24 05 38 10 00 	movl   $0x103805,(%esp)
  101b6a:	e8 44 e8 ff ff       	call   1003b3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b72:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b76:	83 e0 03             	and    $0x3,%eax
  101b79:	85 c0                	test   %eax,%eax
  101b7b:	75 2b                	jne    101ba8 <trap_dispatch+0xda>
            print_trapframe(tf);
  101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b80:	89 04 24             	mov    %eax,(%esp)
  101b83:	e8 db fc ff ff       	call   101863 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101b88:	c7 44 24 08 16 38 10 	movl   $0x103816,0x8(%esp)
  101b8f:	00 
  101b90:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101b97:	00 
  101b98:	c7 04 24 05 38 10 00 	movl   $0x103805,(%esp)
  101b9f:	e8 0f e8 ff ff       	call   1003b3 <__panic>
        break;
  101ba4:	90                   	nop
  101ba5:	eb 01                	jmp    101ba8 <trap_dispatch+0xda>
        break;
  101ba7:	90                   	nop
        }
    }
}
  101ba8:	90                   	nop
  101ba9:	c9                   	leave  
  101baa:	c3                   	ret    

00101bab <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101bab:	55                   	push   %ebp
  101bac:	89 e5                	mov    %esp,%ebp
  101bae:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb4:	89 04 24             	mov    %eax,(%esp)
  101bb7:	e8 12 ff ff ff       	call   101ace <trap_dispatch>
}
  101bbc:	90                   	nop
  101bbd:	c9                   	leave  
  101bbe:	c3                   	ret    

00101bbf <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101bbf:	6a 00                	push   $0x0
  pushl $0
  101bc1:	6a 00                	push   $0x0
  jmp __alltraps
  101bc3:	e9 69 0a 00 00       	jmp    102631 <__alltraps>

00101bc8 <vector1>:
.globl vector1
vector1:
  pushl $0
  101bc8:	6a 00                	push   $0x0
  pushl $1
  101bca:	6a 01                	push   $0x1
  jmp __alltraps
  101bcc:	e9 60 0a 00 00       	jmp    102631 <__alltraps>

00101bd1 <vector2>:
.globl vector2
vector2:
  pushl $0
  101bd1:	6a 00                	push   $0x0
  pushl $2
  101bd3:	6a 02                	push   $0x2
  jmp __alltraps
  101bd5:	e9 57 0a 00 00       	jmp    102631 <__alltraps>

00101bda <vector3>:
.globl vector3
vector3:
  pushl $0
  101bda:	6a 00                	push   $0x0
  pushl $3
  101bdc:	6a 03                	push   $0x3
  jmp __alltraps
  101bde:	e9 4e 0a 00 00       	jmp    102631 <__alltraps>

00101be3 <vector4>:
.globl vector4
vector4:
  pushl $0
  101be3:	6a 00                	push   $0x0
  pushl $4
  101be5:	6a 04                	push   $0x4
  jmp __alltraps
  101be7:	e9 45 0a 00 00       	jmp    102631 <__alltraps>

00101bec <vector5>:
.globl vector5
vector5:
  pushl $0
  101bec:	6a 00                	push   $0x0
  pushl $5
  101bee:	6a 05                	push   $0x5
  jmp __alltraps
  101bf0:	e9 3c 0a 00 00       	jmp    102631 <__alltraps>

00101bf5 <vector6>:
.globl vector6
vector6:
  pushl $0
  101bf5:	6a 00                	push   $0x0
  pushl $6
  101bf7:	6a 06                	push   $0x6
  jmp __alltraps
  101bf9:	e9 33 0a 00 00       	jmp    102631 <__alltraps>

00101bfe <vector7>:
.globl vector7
vector7:
  pushl $0
  101bfe:	6a 00                	push   $0x0
  pushl $7
  101c00:	6a 07                	push   $0x7
  jmp __alltraps
  101c02:	e9 2a 0a 00 00       	jmp    102631 <__alltraps>

00101c07 <vector8>:
.globl vector8
vector8:
  pushl $8
  101c07:	6a 08                	push   $0x8
  jmp __alltraps
  101c09:	e9 23 0a 00 00       	jmp    102631 <__alltraps>

00101c0e <vector9>:
.globl vector9
vector9:
  pushl $0
  101c0e:	6a 00                	push   $0x0
  pushl $9
  101c10:	6a 09                	push   $0x9
  jmp __alltraps
  101c12:	e9 1a 0a 00 00       	jmp    102631 <__alltraps>

00101c17 <vector10>:
.globl vector10
vector10:
  pushl $10
  101c17:	6a 0a                	push   $0xa
  jmp __alltraps
  101c19:	e9 13 0a 00 00       	jmp    102631 <__alltraps>

00101c1e <vector11>:
.globl vector11
vector11:
  pushl $11
  101c1e:	6a 0b                	push   $0xb
  jmp __alltraps
  101c20:	e9 0c 0a 00 00       	jmp    102631 <__alltraps>

00101c25 <vector12>:
.globl vector12
vector12:
  pushl $12
  101c25:	6a 0c                	push   $0xc
  jmp __alltraps
  101c27:	e9 05 0a 00 00       	jmp    102631 <__alltraps>

00101c2c <vector13>:
.globl vector13
vector13:
  pushl $13
  101c2c:	6a 0d                	push   $0xd
  jmp __alltraps
  101c2e:	e9 fe 09 00 00       	jmp    102631 <__alltraps>

00101c33 <vector14>:
.globl vector14
vector14:
  pushl $14
  101c33:	6a 0e                	push   $0xe
  jmp __alltraps
  101c35:	e9 f7 09 00 00       	jmp    102631 <__alltraps>

00101c3a <vector15>:
.globl vector15
vector15:
  pushl $0
  101c3a:	6a 00                	push   $0x0
  pushl $15
  101c3c:	6a 0f                	push   $0xf
  jmp __alltraps
  101c3e:	e9 ee 09 00 00       	jmp    102631 <__alltraps>

00101c43 <vector16>:
.globl vector16
vector16:
  pushl $0
  101c43:	6a 00                	push   $0x0
  pushl $16
  101c45:	6a 10                	push   $0x10
  jmp __alltraps
  101c47:	e9 e5 09 00 00       	jmp    102631 <__alltraps>

00101c4c <vector17>:
.globl vector17
vector17:
  pushl $17
  101c4c:	6a 11                	push   $0x11
  jmp __alltraps
  101c4e:	e9 de 09 00 00       	jmp    102631 <__alltraps>

00101c53 <vector18>:
.globl vector18
vector18:
  pushl $0
  101c53:	6a 00                	push   $0x0
  pushl $18
  101c55:	6a 12                	push   $0x12
  jmp __alltraps
  101c57:	e9 d5 09 00 00       	jmp    102631 <__alltraps>

00101c5c <vector19>:
.globl vector19
vector19:
  pushl $0
  101c5c:	6a 00                	push   $0x0
  pushl $19
  101c5e:	6a 13                	push   $0x13
  jmp __alltraps
  101c60:	e9 cc 09 00 00       	jmp    102631 <__alltraps>

00101c65 <vector20>:
.globl vector20
vector20:
  pushl $0
  101c65:	6a 00                	push   $0x0
  pushl $20
  101c67:	6a 14                	push   $0x14
  jmp __alltraps
  101c69:	e9 c3 09 00 00       	jmp    102631 <__alltraps>

00101c6e <vector21>:
.globl vector21
vector21:
  pushl $0
  101c6e:	6a 00                	push   $0x0
  pushl $21
  101c70:	6a 15                	push   $0x15
  jmp __alltraps
  101c72:	e9 ba 09 00 00       	jmp    102631 <__alltraps>

00101c77 <vector22>:
.globl vector22
vector22:
  pushl $0
  101c77:	6a 00                	push   $0x0
  pushl $22
  101c79:	6a 16                	push   $0x16
  jmp __alltraps
  101c7b:	e9 b1 09 00 00       	jmp    102631 <__alltraps>

00101c80 <vector23>:
.globl vector23
vector23:
  pushl $0
  101c80:	6a 00                	push   $0x0
  pushl $23
  101c82:	6a 17                	push   $0x17
  jmp __alltraps
  101c84:	e9 a8 09 00 00       	jmp    102631 <__alltraps>

00101c89 <vector24>:
.globl vector24
vector24:
  pushl $0
  101c89:	6a 00                	push   $0x0
  pushl $24
  101c8b:	6a 18                	push   $0x18
  jmp __alltraps
  101c8d:	e9 9f 09 00 00       	jmp    102631 <__alltraps>

00101c92 <vector25>:
.globl vector25
vector25:
  pushl $0
  101c92:	6a 00                	push   $0x0
  pushl $25
  101c94:	6a 19                	push   $0x19
  jmp __alltraps
  101c96:	e9 96 09 00 00       	jmp    102631 <__alltraps>

00101c9b <vector26>:
.globl vector26
vector26:
  pushl $0
  101c9b:	6a 00                	push   $0x0
  pushl $26
  101c9d:	6a 1a                	push   $0x1a
  jmp __alltraps
  101c9f:	e9 8d 09 00 00       	jmp    102631 <__alltraps>

00101ca4 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ca4:	6a 00                	push   $0x0
  pushl $27
  101ca6:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ca8:	e9 84 09 00 00       	jmp    102631 <__alltraps>

00101cad <vector28>:
.globl vector28
vector28:
  pushl $0
  101cad:	6a 00                	push   $0x0
  pushl $28
  101caf:	6a 1c                	push   $0x1c
  jmp __alltraps
  101cb1:	e9 7b 09 00 00       	jmp    102631 <__alltraps>

00101cb6 <vector29>:
.globl vector29
vector29:
  pushl $0
  101cb6:	6a 00                	push   $0x0
  pushl $29
  101cb8:	6a 1d                	push   $0x1d
  jmp __alltraps
  101cba:	e9 72 09 00 00       	jmp    102631 <__alltraps>

00101cbf <vector30>:
.globl vector30
vector30:
  pushl $0
  101cbf:	6a 00                	push   $0x0
  pushl $30
  101cc1:	6a 1e                	push   $0x1e
  jmp __alltraps
  101cc3:	e9 69 09 00 00       	jmp    102631 <__alltraps>

00101cc8 <vector31>:
.globl vector31
vector31:
  pushl $0
  101cc8:	6a 00                	push   $0x0
  pushl $31
  101cca:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ccc:	e9 60 09 00 00       	jmp    102631 <__alltraps>

00101cd1 <vector32>:
.globl vector32
vector32:
  pushl $0
  101cd1:	6a 00                	push   $0x0
  pushl $32
  101cd3:	6a 20                	push   $0x20
  jmp __alltraps
  101cd5:	e9 57 09 00 00       	jmp    102631 <__alltraps>

00101cda <vector33>:
.globl vector33
vector33:
  pushl $0
  101cda:	6a 00                	push   $0x0
  pushl $33
  101cdc:	6a 21                	push   $0x21
  jmp __alltraps
  101cde:	e9 4e 09 00 00       	jmp    102631 <__alltraps>

00101ce3 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ce3:	6a 00                	push   $0x0
  pushl $34
  101ce5:	6a 22                	push   $0x22
  jmp __alltraps
  101ce7:	e9 45 09 00 00       	jmp    102631 <__alltraps>

00101cec <vector35>:
.globl vector35
vector35:
  pushl $0
  101cec:	6a 00                	push   $0x0
  pushl $35
  101cee:	6a 23                	push   $0x23
  jmp __alltraps
  101cf0:	e9 3c 09 00 00       	jmp    102631 <__alltraps>

00101cf5 <vector36>:
.globl vector36
vector36:
  pushl $0
  101cf5:	6a 00                	push   $0x0
  pushl $36
  101cf7:	6a 24                	push   $0x24
  jmp __alltraps
  101cf9:	e9 33 09 00 00       	jmp    102631 <__alltraps>

00101cfe <vector37>:
.globl vector37
vector37:
  pushl $0
  101cfe:	6a 00                	push   $0x0
  pushl $37
  101d00:	6a 25                	push   $0x25
  jmp __alltraps
  101d02:	e9 2a 09 00 00       	jmp    102631 <__alltraps>

00101d07 <vector38>:
.globl vector38
vector38:
  pushl $0
  101d07:	6a 00                	push   $0x0
  pushl $38
  101d09:	6a 26                	push   $0x26
  jmp __alltraps
  101d0b:	e9 21 09 00 00       	jmp    102631 <__alltraps>

00101d10 <vector39>:
.globl vector39
vector39:
  pushl $0
  101d10:	6a 00                	push   $0x0
  pushl $39
  101d12:	6a 27                	push   $0x27
  jmp __alltraps
  101d14:	e9 18 09 00 00       	jmp    102631 <__alltraps>

00101d19 <vector40>:
.globl vector40
vector40:
  pushl $0
  101d19:	6a 00                	push   $0x0
  pushl $40
  101d1b:	6a 28                	push   $0x28
  jmp __alltraps
  101d1d:	e9 0f 09 00 00       	jmp    102631 <__alltraps>

00101d22 <vector41>:
.globl vector41
vector41:
  pushl $0
  101d22:	6a 00                	push   $0x0
  pushl $41
  101d24:	6a 29                	push   $0x29
  jmp __alltraps
  101d26:	e9 06 09 00 00       	jmp    102631 <__alltraps>

00101d2b <vector42>:
.globl vector42
vector42:
  pushl $0
  101d2b:	6a 00                	push   $0x0
  pushl $42
  101d2d:	6a 2a                	push   $0x2a
  jmp __alltraps
  101d2f:	e9 fd 08 00 00       	jmp    102631 <__alltraps>

00101d34 <vector43>:
.globl vector43
vector43:
  pushl $0
  101d34:	6a 00                	push   $0x0
  pushl $43
  101d36:	6a 2b                	push   $0x2b
  jmp __alltraps
  101d38:	e9 f4 08 00 00       	jmp    102631 <__alltraps>

00101d3d <vector44>:
.globl vector44
vector44:
  pushl $0
  101d3d:	6a 00                	push   $0x0
  pushl $44
  101d3f:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d41:	e9 eb 08 00 00       	jmp    102631 <__alltraps>

00101d46 <vector45>:
.globl vector45
vector45:
  pushl $0
  101d46:	6a 00                	push   $0x0
  pushl $45
  101d48:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d4a:	e9 e2 08 00 00       	jmp    102631 <__alltraps>

00101d4f <vector46>:
.globl vector46
vector46:
  pushl $0
  101d4f:	6a 00                	push   $0x0
  pushl $46
  101d51:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d53:	e9 d9 08 00 00       	jmp    102631 <__alltraps>

00101d58 <vector47>:
.globl vector47
vector47:
  pushl $0
  101d58:	6a 00                	push   $0x0
  pushl $47
  101d5a:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d5c:	e9 d0 08 00 00       	jmp    102631 <__alltraps>

00101d61 <vector48>:
.globl vector48
vector48:
  pushl $0
  101d61:	6a 00                	push   $0x0
  pushl $48
  101d63:	6a 30                	push   $0x30
  jmp __alltraps
  101d65:	e9 c7 08 00 00       	jmp    102631 <__alltraps>

00101d6a <vector49>:
.globl vector49
vector49:
  pushl $0
  101d6a:	6a 00                	push   $0x0
  pushl $49
  101d6c:	6a 31                	push   $0x31
  jmp __alltraps
  101d6e:	e9 be 08 00 00       	jmp    102631 <__alltraps>

00101d73 <vector50>:
.globl vector50
vector50:
  pushl $0
  101d73:	6a 00                	push   $0x0
  pushl $50
  101d75:	6a 32                	push   $0x32
  jmp __alltraps
  101d77:	e9 b5 08 00 00       	jmp    102631 <__alltraps>

00101d7c <vector51>:
.globl vector51
vector51:
  pushl $0
  101d7c:	6a 00                	push   $0x0
  pushl $51
  101d7e:	6a 33                	push   $0x33
  jmp __alltraps
  101d80:	e9 ac 08 00 00       	jmp    102631 <__alltraps>

00101d85 <vector52>:
.globl vector52
vector52:
  pushl $0
  101d85:	6a 00                	push   $0x0
  pushl $52
  101d87:	6a 34                	push   $0x34
  jmp __alltraps
  101d89:	e9 a3 08 00 00       	jmp    102631 <__alltraps>

00101d8e <vector53>:
.globl vector53
vector53:
  pushl $0
  101d8e:	6a 00                	push   $0x0
  pushl $53
  101d90:	6a 35                	push   $0x35
  jmp __alltraps
  101d92:	e9 9a 08 00 00       	jmp    102631 <__alltraps>

00101d97 <vector54>:
.globl vector54
vector54:
  pushl $0
  101d97:	6a 00                	push   $0x0
  pushl $54
  101d99:	6a 36                	push   $0x36
  jmp __alltraps
  101d9b:	e9 91 08 00 00       	jmp    102631 <__alltraps>

00101da0 <vector55>:
.globl vector55
vector55:
  pushl $0
  101da0:	6a 00                	push   $0x0
  pushl $55
  101da2:	6a 37                	push   $0x37
  jmp __alltraps
  101da4:	e9 88 08 00 00       	jmp    102631 <__alltraps>

00101da9 <vector56>:
.globl vector56
vector56:
  pushl $0
  101da9:	6a 00                	push   $0x0
  pushl $56
  101dab:	6a 38                	push   $0x38
  jmp __alltraps
  101dad:	e9 7f 08 00 00       	jmp    102631 <__alltraps>

00101db2 <vector57>:
.globl vector57
vector57:
  pushl $0
  101db2:	6a 00                	push   $0x0
  pushl $57
  101db4:	6a 39                	push   $0x39
  jmp __alltraps
  101db6:	e9 76 08 00 00       	jmp    102631 <__alltraps>

00101dbb <vector58>:
.globl vector58
vector58:
  pushl $0
  101dbb:	6a 00                	push   $0x0
  pushl $58
  101dbd:	6a 3a                	push   $0x3a
  jmp __alltraps
  101dbf:	e9 6d 08 00 00       	jmp    102631 <__alltraps>

00101dc4 <vector59>:
.globl vector59
vector59:
  pushl $0
  101dc4:	6a 00                	push   $0x0
  pushl $59
  101dc6:	6a 3b                	push   $0x3b
  jmp __alltraps
  101dc8:	e9 64 08 00 00       	jmp    102631 <__alltraps>

00101dcd <vector60>:
.globl vector60
vector60:
  pushl $0
  101dcd:	6a 00                	push   $0x0
  pushl $60
  101dcf:	6a 3c                	push   $0x3c
  jmp __alltraps
  101dd1:	e9 5b 08 00 00       	jmp    102631 <__alltraps>

00101dd6 <vector61>:
.globl vector61
vector61:
  pushl $0
  101dd6:	6a 00                	push   $0x0
  pushl $61
  101dd8:	6a 3d                	push   $0x3d
  jmp __alltraps
  101dda:	e9 52 08 00 00       	jmp    102631 <__alltraps>

00101ddf <vector62>:
.globl vector62
vector62:
  pushl $0
  101ddf:	6a 00                	push   $0x0
  pushl $62
  101de1:	6a 3e                	push   $0x3e
  jmp __alltraps
  101de3:	e9 49 08 00 00       	jmp    102631 <__alltraps>

00101de8 <vector63>:
.globl vector63
vector63:
  pushl $0
  101de8:	6a 00                	push   $0x0
  pushl $63
  101dea:	6a 3f                	push   $0x3f
  jmp __alltraps
  101dec:	e9 40 08 00 00       	jmp    102631 <__alltraps>

00101df1 <vector64>:
.globl vector64
vector64:
  pushl $0
  101df1:	6a 00                	push   $0x0
  pushl $64
  101df3:	6a 40                	push   $0x40
  jmp __alltraps
  101df5:	e9 37 08 00 00       	jmp    102631 <__alltraps>

00101dfa <vector65>:
.globl vector65
vector65:
  pushl $0
  101dfa:	6a 00                	push   $0x0
  pushl $65
  101dfc:	6a 41                	push   $0x41
  jmp __alltraps
  101dfe:	e9 2e 08 00 00       	jmp    102631 <__alltraps>

00101e03 <vector66>:
.globl vector66
vector66:
  pushl $0
  101e03:	6a 00                	push   $0x0
  pushl $66
  101e05:	6a 42                	push   $0x42
  jmp __alltraps
  101e07:	e9 25 08 00 00       	jmp    102631 <__alltraps>

00101e0c <vector67>:
.globl vector67
vector67:
  pushl $0
  101e0c:	6a 00                	push   $0x0
  pushl $67
  101e0e:	6a 43                	push   $0x43
  jmp __alltraps
  101e10:	e9 1c 08 00 00       	jmp    102631 <__alltraps>

00101e15 <vector68>:
.globl vector68
vector68:
  pushl $0
  101e15:	6a 00                	push   $0x0
  pushl $68
  101e17:	6a 44                	push   $0x44
  jmp __alltraps
  101e19:	e9 13 08 00 00       	jmp    102631 <__alltraps>

00101e1e <vector69>:
.globl vector69
vector69:
  pushl $0
  101e1e:	6a 00                	push   $0x0
  pushl $69
  101e20:	6a 45                	push   $0x45
  jmp __alltraps
  101e22:	e9 0a 08 00 00       	jmp    102631 <__alltraps>

00101e27 <vector70>:
.globl vector70
vector70:
  pushl $0
  101e27:	6a 00                	push   $0x0
  pushl $70
  101e29:	6a 46                	push   $0x46
  jmp __alltraps
  101e2b:	e9 01 08 00 00       	jmp    102631 <__alltraps>

00101e30 <vector71>:
.globl vector71
vector71:
  pushl $0
  101e30:	6a 00                	push   $0x0
  pushl $71
  101e32:	6a 47                	push   $0x47
  jmp __alltraps
  101e34:	e9 f8 07 00 00       	jmp    102631 <__alltraps>

00101e39 <vector72>:
.globl vector72
vector72:
  pushl $0
  101e39:	6a 00                	push   $0x0
  pushl $72
  101e3b:	6a 48                	push   $0x48
  jmp __alltraps
  101e3d:	e9 ef 07 00 00       	jmp    102631 <__alltraps>

00101e42 <vector73>:
.globl vector73
vector73:
  pushl $0
  101e42:	6a 00                	push   $0x0
  pushl $73
  101e44:	6a 49                	push   $0x49
  jmp __alltraps
  101e46:	e9 e6 07 00 00       	jmp    102631 <__alltraps>

00101e4b <vector74>:
.globl vector74
vector74:
  pushl $0
  101e4b:	6a 00                	push   $0x0
  pushl $74
  101e4d:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e4f:	e9 dd 07 00 00       	jmp    102631 <__alltraps>

00101e54 <vector75>:
.globl vector75
vector75:
  pushl $0
  101e54:	6a 00                	push   $0x0
  pushl $75
  101e56:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e58:	e9 d4 07 00 00       	jmp    102631 <__alltraps>

00101e5d <vector76>:
.globl vector76
vector76:
  pushl $0
  101e5d:	6a 00                	push   $0x0
  pushl $76
  101e5f:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e61:	e9 cb 07 00 00       	jmp    102631 <__alltraps>

00101e66 <vector77>:
.globl vector77
vector77:
  pushl $0
  101e66:	6a 00                	push   $0x0
  pushl $77
  101e68:	6a 4d                	push   $0x4d
  jmp __alltraps
  101e6a:	e9 c2 07 00 00       	jmp    102631 <__alltraps>

00101e6f <vector78>:
.globl vector78
vector78:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $78
  101e71:	6a 4e                	push   $0x4e
  jmp __alltraps
  101e73:	e9 b9 07 00 00       	jmp    102631 <__alltraps>

00101e78 <vector79>:
.globl vector79
vector79:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $79
  101e7a:	6a 4f                	push   $0x4f
  jmp __alltraps
  101e7c:	e9 b0 07 00 00       	jmp    102631 <__alltraps>

00101e81 <vector80>:
.globl vector80
vector80:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $80
  101e83:	6a 50                	push   $0x50
  jmp __alltraps
  101e85:	e9 a7 07 00 00       	jmp    102631 <__alltraps>

00101e8a <vector81>:
.globl vector81
vector81:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $81
  101e8c:	6a 51                	push   $0x51
  jmp __alltraps
  101e8e:	e9 9e 07 00 00       	jmp    102631 <__alltraps>

00101e93 <vector82>:
.globl vector82
vector82:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $82
  101e95:	6a 52                	push   $0x52
  jmp __alltraps
  101e97:	e9 95 07 00 00       	jmp    102631 <__alltraps>

00101e9c <vector83>:
.globl vector83
vector83:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $83
  101e9e:	6a 53                	push   $0x53
  jmp __alltraps
  101ea0:	e9 8c 07 00 00       	jmp    102631 <__alltraps>

00101ea5 <vector84>:
.globl vector84
vector84:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $84
  101ea7:	6a 54                	push   $0x54
  jmp __alltraps
  101ea9:	e9 83 07 00 00       	jmp    102631 <__alltraps>

00101eae <vector85>:
.globl vector85
vector85:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $85
  101eb0:	6a 55                	push   $0x55
  jmp __alltraps
  101eb2:	e9 7a 07 00 00       	jmp    102631 <__alltraps>

00101eb7 <vector86>:
.globl vector86
vector86:
  pushl $0
  101eb7:	6a 00                	push   $0x0
  pushl $86
  101eb9:	6a 56                	push   $0x56
  jmp __alltraps
  101ebb:	e9 71 07 00 00       	jmp    102631 <__alltraps>

00101ec0 <vector87>:
.globl vector87
vector87:
  pushl $0
  101ec0:	6a 00                	push   $0x0
  pushl $87
  101ec2:	6a 57                	push   $0x57
  jmp __alltraps
  101ec4:	e9 68 07 00 00       	jmp    102631 <__alltraps>

00101ec9 <vector88>:
.globl vector88
vector88:
  pushl $0
  101ec9:	6a 00                	push   $0x0
  pushl $88
  101ecb:	6a 58                	push   $0x58
  jmp __alltraps
  101ecd:	e9 5f 07 00 00       	jmp    102631 <__alltraps>

00101ed2 <vector89>:
.globl vector89
vector89:
  pushl $0
  101ed2:	6a 00                	push   $0x0
  pushl $89
  101ed4:	6a 59                	push   $0x59
  jmp __alltraps
  101ed6:	e9 56 07 00 00       	jmp    102631 <__alltraps>

00101edb <vector90>:
.globl vector90
vector90:
  pushl $0
  101edb:	6a 00                	push   $0x0
  pushl $90
  101edd:	6a 5a                	push   $0x5a
  jmp __alltraps
  101edf:	e9 4d 07 00 00       	jmp    102631 <__alltraps>

00101ee4 <vector91>:
.globl vector91
vector91:
  pushl $0
  101ee4:	6a 00                	push   $0x0
  pushl $91
  101ee6:	6a 5b                	push   $0x5b
  jmp __alltraps
  101ee8:	e9 44 07 00 00       	jmp    102631 <__alltraps>

00101eed <vector92>:
.globl vector92
vector92:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $92
  101eef:	6a 5c                	push   $0x5c
  jmp __alltraps
  101ef1:	e9 3b 07 00 00       	jmp    102631 <__alltraps>

00101ef6 <vector93>:
.globl vector93
vector93:
  pushl $0
  101ef6:	6a 00                	push   $0x0
  pushl $93
  101ef8:	6a 5d                	push   $0x5d
  jmp __alltraps
  101efa:	e9 32 07 00 00       	jmp    102631 <__alltraps>

00101eff <vector94>:
.globl vector94
vector94:
  pushl $0
  101eff:	6a 00                	push   $0x0
  pushl $94
  101f01:	6a 5e                	push   $0x5e
  jmp __alltraps
  101f03:	e9 29 07 00 00       	jmp    102631 <__alltraps>

00101f08 <vector95>:
.globl vector95
vector95:
  pushl $0
  101f08:	6a 00                	push   $0x0
  pushl $95
  101f0a:	6a 5f                	push   $0x5f
  jmp __alltraps
  101f0c:	e9 20 07 00 00       	jmp    102631 <__alltraps>

00101f11 <vector96>:
.globl vector96
vector96:
  pushl $0
  101f11:	6a 00                	push   $0x0
  pushl $96
  101f13:	6a 60                	push   $0x60
  jmp __alltraps
  101f15:	e9 17 07 00 00       	jmp    102631 <__alltraps>

00101f1a <vector97>:
.globl vector97
vector97:
  pushl $0
  101f1a:	6a 00                	push   $0x0
  pushl $97
  101f1c:	6a 61                	push   $0x61
  jmp __alltraps
  101f1e:	e9 0e 07 00 00       	jmp    102631 <__alltraps>

00101f23 <vector98>:
.globl vector98
vector98:
  pushl $0
  101f23:	6a 00                	push   $0x0
  pushl $98
  101f25:	6a 62                	push   $0x62
  jmp __alltraps
  101f27:	e9 05 07 00 00       	jmp    102631 <__alltraps>

00101f2c <vector99>:
.globl vector99
vector99:
  pushl $0
  101f2c:	6a 00                	push   $0x0
  pushl $99
  101f2e:	6a 63                	push   $0x63
  jmp __alltraps
  101f30:	e9 fc 06 00 00       	jmp    102631 <__alltraps>

00101f35 <vector100>:
.globl vector100
vector100:
  pushl $0
  101f35:	6a 00                	push   $0x0
  pushl $100
  101f37:	6a 64                	push   $0x64
  jmp __alltraps
  101f39:	e9 f3 06 00 00       	jmp    102631 <__alltraps>

00101f3e <vector101>:
.globl vector101
vector101:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $101
  101f40:	6a 65                	push   $0x65
  jmp __alltraps
  101f42:	e9 ea 06 00 00       	jmp    102631 <__alltraps>

00101f47 <vector102>:
.globl vector102
vector102:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $102
  101f49:	6a 66                	push   $0x66
  jmp __alltraps
  101f4b:	e9 e1 06 00 00       	jmp    102631 <__alltraps>

00101f50 <vector103>:
.globl vector103
vector103:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $103
  101f52:	6a 67                	push   $0x67
  jmp __alltraps
  101f54:	e9 d8 06 00 00       	jmp    102631 <__alltraps>

00101f59 <vector104>:
.globl vector104
vector104:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $104
  101f5b:	6a 68                	push   $0x68
  jmp __alltraps
  101f5d:	e9 cf 06 00 00       	jmp    102631 <__alltraps>

00101f62 <vector105>:
.globl vector105
vector105:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $105
  101f64:	6a 69                	push   $0x69
  jmp __alltraps
  101f66:	e9 c6 06 00 00       	jmp    102631 <__alltraps>

00101f6b <vector106>:
.globl vector106
vector106:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $106
  101f6d:	6a 6a                	push   $0x6a
  jmp __alltraps
  101f6f:	e9 bd 06 00 00       	jmp    102631 <__alltraps>

00101f74 <vector107>:
.globl vector107
vector107:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $107
  101f76:	6a 6b                	push   $0x6b
  jmp __alltraps
  101f78:	e9 b4 06 00 00       	jmp    102631 <__alltraps>

00101f7d <vector108>:
.globl vector108
vector108:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $108
  101f7f:	6a 6c                	push   $0x6c
  jmp __alltraps
  101f81:	e9 ab 06 00 00       	jmp    102631 <__alltraps>

00101f86 <vector109>:
.globl vector109
vector109:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $109
  101f88:	6a 6d                	push   $0x6d
  jmp __alltraps
  101f8a:	e9 a2 06 00 00       	jmp    102631 <__alltraps>

00101f8f <vector110>:
.globl vector110
vector110:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $110
  101f91:	6a 6e                	push   $0x6e
  jmp __alltraps
  101f93:	e9 99 06 00 00       	jmp    102631 <__alltraps>

00101f98 <vector111>:
.globl vector111
vector111:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $111
  101f9a:	6a 6f                	push   $0x6f
  jmp __alltraps
  101f9c:	e9 90 06 00 00       	jmp    102631 <__alltraps>

00101fa1 <vector112>:
.globl vector112
vector112:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $112
  101fa3:	6a 70                	push   $0x70
  jmp __alltraps
  101fa5:	e9 87 06 00 00       	jmp    102631 <__alltraps>

00101faa <vector113>:
.globl vector113
vector113:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $113
  101fac:	6a 71                	push   $0x71
  jmp __alltraps
  101fae:	e9 7e 06 00 00       	jmp    102631 <__alltraps>

00101fb3 <vector114>:
.globl vector114
vector114:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $114
  101fb5:	6a 72                	push   $0x72
  jmp __alltraps
  101fb7:	e9 75 06 00 00       	jmp    102631 <__alltraps>

00101fbc <vector115>:
.globl vector115
vector115:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $115
  101fbe:	6a 73                	push   $0x73
  jmp __alltraps
  101fc0:	e9 6c 06 00 00       	jmp    102631 <__alltraps>

00101fc5 <vector116>:
.globl vector116
vector116:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $116
  101fc7:	6a 74                	push   $0x74
  jmp __alltraps
  101fc9:	e9 63 06 00 00       	jmp    102631 <__alltraps>

00101fce <vector117>:
.globl vector117
vector117:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $117
  101fd0:	6a 75                	push   $0x75
  jmp __alltraps
  101fd2:	e9 5a 06 00 00       	jmp    102631 <__alltraps>

00101fd7 <vector118>:
.globl vector118
vector118:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $118
  101fd9:	6a 76                	push   $0x76
  jmp __alltraps
  101fdb:	e9 51 06 00 00       	jmp    102631 <__alltraps>

00101fe0 <vector119>:
.globl vector119
vector119:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $119
  101fe2:	6a 77                	push   $0x77
  jmp __alltraps
  101fe4:	e9 48 06 00 00       	jmp    102631 <__alltraps>

00101fe9 <vector120>:
.globl vector120
vector120:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $120
  101feb:	6a 78                	push   $0x78
  jmp __alltraps
  101fed:	e9 3f 06 00 00       	jmp    102631 <__alltraps>

00101ff2 <vector121>:
.globl vector121
vector121:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $121
  101ff4:	6a 79                	push   $0x79
  jmp __alltraps
  101ff6:	e9 36 06 00 00       	jmp    102631 <__alltraps>

00101ffb <vector122>:
.globl vector122
vector122:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $122
  101ffd:	6a 7a                	push   $0x7a
  jmp __alltraps
  101fff:	e9 2d 06 00 00       	jmp    102631 <__alltraps>

00102004 <vector123>:
.globl vector123
vector123:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $123
  102006:	6a 7b                	push   $0x7b
  jmp __alltraps
  102008:	e9 24 06 00 00       	jmp    102631 <__alltraps>

0010200d <vector124>:
.globl vector124
vector124:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $124
  10200f:	6a 7c                	push   $0x7c
  jmp __alltraps
  102011:	e9 1b 06 00 00       	jmp    102631 <__alltraps>

00102016 <vector125>:
.globl vector125
vector125:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $125
  102018:	6a 7d                	push   $0x7d
  jmp __alltraps
  10201a:	e9 12 06 00 00       	jmp    102631 <__alltraps>

0010201f <vector126>:
.globl vector126
vector126:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $126
  102021:	6a 7e                	push   $0x7e
  jmp __alltraps
  102023:	e9 09 06 00 00       	jmp    102631 <__alltraps>

00102028 <vector127>:
.globl vector127
vector127:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $127
  10202a:	6a 7f                	push   $0x7f
  jmp __alltraps
  10202c:	e9 00 06 00 00       	jmp    102631 <__alltraps>

00102031 <vector128>:
.globl vector128
vector128:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $128
  102033:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102038:	e9 f4 05 00 00       	jmp    102631 <__alltraps>

0010203d <vector129>:
.globl vector129
vector129:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $129
  10203f:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102044:	e9 e8 05 00 00       	jmp    102631 <__alltraps>

00102049 <vector130>:
.globl vector130
vector130:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $130
  10204b:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102050:	e9 dc 05 00 00       	jmp    102631 <__alltraps>

00102055 <vector131>:
.globl vector131
vector131:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $131
  102057:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10205c:	e9 d0 05 00 00       	jmp    102631 <__alltraps>

00102061 <vector132>:
.globl vector132
vector132:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $132
  102063:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102068:	e9 c4 05 00 00       	jmp    102631 <__alltraps>

0010206d <vector133>:
.globl vector133
vector133:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $133
  10206f:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102074:	e9 b8 05 00 00       	jmp    102631 <__alltraps>

00102079 <vector134>:
.globl vector134
vector134:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $134
  10207b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102080:	e9 ac 05 00 00       	jmp    102631 <__alltraps>

00102085 <vector135>:
.globl vector135
vector135:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $135
  102087:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10208c:	e9 a0 05 00 00       	jmp    102631 <__alltraps>

00102091 <vector136>:
.globl vector136
vector136:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $136
  102093:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102098:	e9 94 05 00 00       	jmp    102631 <__alltraps>

0010209d <vector137>:
.globl vector137
vector137:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $137
  10209f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1020a4:	e9 88 05 00 00       	jmp    102631 <__alltraps>

001020a9 <vector138>:
.globl vector138
vector138:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $138
  1020ab:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1020b0:	e9 7c 05 00 00       	jmp    102631 <__alltraps>

001020b5 <vector139>:
.globl vector139
vector139:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $139
  1020b7:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1020bc:	e9 70 05 00 00       	jmp    102631 <__alltraps>

001020c1 <vector140>:
.globl vector140
vector140:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $140
  1020c3:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1020c8:	e9 64 05 00 00       	jmp    102631 <__alltraps>

001020cd <vector141>:
.globl vector141
vector141:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $141
  1020cf:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1020d4:	e9 58 05 00 00       	jmp    102631 <__alltraps>

001020d9 <vector142>:
.globl vector142
vector142:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $142
  1020db:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1020e0:	e9 4c 05 00 00       	jmp    102631 <__alltraps>

001020e5 <vector143>:
.globl vector143
vector143:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $143
  1020e7:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1020ec:	e9 40 05 00 00       	jmp    102631 <__alltraps>

001020f1 <vector144>:
.globl vector144
vector144:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $144
  1020f3:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1020f8:	e9 34 05 00 00       	jmp    102631 <__alltraps>

001020fd <vector145>:
.globl vector145
vector145:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $145
  1020ff:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102104:	e9 28 05 00 00       	jmp    102631 <__alltraps>

00102109 <vector146>:
.globl vector146
vector146:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $146
  10210b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102110:	e9 1c 05 00 00       	jmp    102631 <__alltraps>

00102115 <vector147>:
.globl vector147
vector147:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $147
  102117:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10211c:	e9 10 05 00 00       	jmp    102631 <__alltraps>

00102121 <vector148>:
.globl vector148
vector148:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $148
  102123:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102128:	e9 04 05 00 00       	jmp    102631 <__alltraps>

0010212d <vector149>:
.globl vector149
vector149:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $149
  10212f:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102134:	e9 f8 04 00 00       	jmp    102631 <__alltraps>

00102139 <vector150>:
.globl vector150
vector150:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $150
  10213b:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102140:	e9 ec 04 00 00       	jmp    102631 <__alltraps>

00102145 <vector151>:
.globl vector151
vector151:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $151
  102147:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10214c:	e9 e0 04 00 00       	jmp    102631 <__alltraps>

00102151 <vector152>:
.globl vector152
vector152:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $152
  102153:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102158:	e9 d4 04 00 00       	jmp    102631 <__alltraps>

0010215d <vector153>:
.globl vector153
vector153:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $153
  10215f:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102164:	e9 c8 04 00 00       	jmp    102631 <__alltraps>

00102169 <vector154>:
.globl vector154
vector154:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $154
  10216b:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102170:	e9 bc 04 00 00       	jmp    102631 <__alltraps>

00102175 <vector155>:
.globl vector155
vector155:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $155
  102177:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10217c:	e9 b0 04 00 00       	jmp    102631 <__alltraps>

00102181 <vector156>:
.globl vector156
vector156:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $156
  102183:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102188:	e9 a4 04 00 00       	jmp    102631 <__alltraps>

0010218d <vector157>:
.globl vector157
vector157:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $157
  10218f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102194:	e9 98 04 00 00       	jmp    102631 <__alltraps>

00102199 <vector158>:
.globl vector158
vector158:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $158
  10219b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1021a0:	e9 8c 04 00 00       	jmp    102631 <__alltraps>

001021a5 <vector159>:
.globl vector159
vector159:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $159
  1021a7:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1021ac:	e9 80 04 00 00       	jmp    102631 <__alltraps>

001021b1 <vector160>:
.globl vector160
vector160:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $160
  1021b3:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1021b8:	e9 74 04 00 00       	jmp    102631 <__alltraps>

001021bd <vector161>:
.globl vector161
vector161:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $161
  1021bf:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1021c4:	e9 68 04 00 00       	jmp    102631 <__alltraps>

001021c9 <vector162>:
.globl vector162
vector162:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $162
  1021cb:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1021d0:	e9 5c 04 00 00       	jmp    102631 <__alltraps>

001021d5 <vector163>:
.globl vector163
vector163:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $163
  1021d7:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1021dc:	e9 50 04 00 00       	jmp    102631 <__alltraps>

001021e1 <vector164>:
.globl vector164
vector164:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $164
  1021e3:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1021e8:	e9 44 04 00 00       	jmp    102631 <__alltraps>

001021ed <vector165>:
.globl vector165
vector165:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $165
  1021ef:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1021f4:	e9 38 04 00 00       	jmp    102631 <__alltraps>

001021f9 <vector166>:
.globl vector166
vector166:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $166
  1021fb:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102200:	e9 2c 04 00 00       	jmp    102631 <__alltraps>

00102205 <vector167>:
.globl vector167
vector167:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $167
  102207:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10220c:	e9 20 04 00 00       	jmp    102631 <__alltraps>

00102211 <vector168>:
.globl vector168
vector168:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $168
  102213:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102218:	e9 14 04 00 00       	jmp    102631 <__alltraps>

0010221d <vector169>:
.globl vector169
vector169:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $169
  10221f:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102224:	e9 08 04 00 00       	jmp    102631 <__alltraps>

00102229 <vector170>:
.globl vector170
vector170:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $170
  10222b:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102230:	e9 fc 03 00 00       	jmp    102631 <__alltraps>

00102235 <vector171>:
.globl vector171
vector171:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $171
  102237:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10223c:	e9 f0 03 00 00       	jmp    102631 <__alltraps>

00102241 <vector172>:
.globl vector172
vector172:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $172
  102243:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102248:	e9 e4 03 00 00       	jmp    102631 <__alltraps>

0010224d <vector173>:
.globl vector173
vector173:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $173
  10224f:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102254:	e9 d8 03 00 00       	jmp    102631 <__alltraps>

00102259 <vector174>:
.globl vector174
vector174:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $174
  10225b:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102260:	e9 cc 03 00 00       	jmp    102631 <__alltraps>

00102265 <vector175>:
.globl vector175
vector175:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $175
  102267:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10226c:	e9 c0 03 00 00       	jmp    102631 <__alltraps>

00102271 <vector176>:
.globl vector176
vector176:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $176
  102273:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102278:	e9 b4 03 00 00       	jmp    102631 <__alltraps>

0010227d <vector177>:
.globl vector177
vector177:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $177
  10227f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102284:	e9 a8 03 00 00       	jmp    102631 <__alltraps>

00102289 <vector178>:
.globl vector178
vector178:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $178
  10228b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102290:	e9 9c 03 00 00       	jmp    102631 <__alltraps>

00102295 <vector179>:
.globl vector179
vector179:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $179
  102297:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10229c:	e9 90 03 00 00       	jmp    102631 <__alltraps>

001022a1 <vector180>:
.globl vector180
vector180:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $180
  1022a3:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1022a8:	e9 84 03 00 00       	jmp    102631 <__alltraps>

001022ad <vector181>:
.globl vector181
vector181:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $181
  1022af:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1022b4:	e9 78 03 00 00       	jmp    102631 <__alltraps>

001022b9 <vector182>:
.globl vector182
vector182:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $182
  1022bb:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1022c0:	e9 6c 03 00 00       	jmp    102631 <__alltraps>

001022c5 <vector183>:
.globl vector183
vector183:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $183
  1022c7:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1022cc:	e9 60 03 00 00       	jmp    102631 <__alltraps>

001022d1 <vector184>:
.globl vector184
vector184:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $184
  1022d3:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1022d8:	e9 54 03 00 00       	jmp    102631 <__alltraps>

001022dd <vector185>:
.globl vector185
vector185:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $185
  1022df:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1022e4:	e9 48 03 00 00       	jmp    102631 <__alltraps>

001022e9 <vector186>:
.globl vector186
vector186:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $186
  1022eb:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1022f0:	e9 3c 03 00 00       	jmp    102631 <__alltraps>

001022f5 <vector187>:
.globl vector187
vector187:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $187
  1022f7:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1022fc:	e9 30 03 00 00       	jmp    102631 <__alltraps>

00102301 <vector188>:
.globl vector188
vector188:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $188
  102303:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102308:	e9 24 03 00 00       	jmp    102631 <__alltraps>

0010230d <vector189>:
.globl vector189
vector189:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $189
  10230f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102314:	e9 18 03 00 00       	jmp    102631 <__alltraps>

00102319 <vector190>:
.globl vector190
vector190:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $190
  10231b:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102320:	e9 0c 03 00 00       	jmp    102631 <__alltraps>

00102325 <vector191>:
.globl vector191
vector191:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $191
  102327:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10232c:	e9 00 03 00 00       	jmp    102631 <__alltraps>

00102331 <vector192>:
.globl vector192
vector192:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $192
  102333:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102338:	e9 f4 02 00 00       	jmp    102631 <__alltraps>

0010233d <vector193>:
.globl vector193
vector193:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $193
  10233f:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102344:	e9 e8 02 00 00       	jmp    102631 <__alltraps>

00102349 <vector194>:
.globl vector194
vector194:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $194
  10234b:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102350:	e9 dc 02 00 00       	jmp    102631 <__alltraps>

00102355 <vector195>:
.globl vector195
vector195:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $195
  102357:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10235c:	e9 d0 02 00 00       	jmp    102631 <__alltraps>

00102361 <vector196>:
.globl vector196
vector196:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $196
  102363:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102368:	e9 c4 02 00 00       	jmp    102631 <__alltraps>

0010236d <vector197>:
.globl vector197
vector197:
  pushl $0
  10236d:	6a 00                	push   $0x0
  pushl $197
  10236f:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102374:	e9 b8 02 00 00       	jmp    102631 <__alltraps>

00102379 <vector198>:
.globl vector198
vector198:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $198
  10237b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102380:	e9 ac 02 00 00       	jmp    102631 <__alltraps>

00102385 <vector199>:
.globl vector199
vector199:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $199
  102387:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10238c:	e9 a0 02 00 00       	jmp    102631 <__alltraps>

00102391 <vector200>:
.globl vector200
vector200:
  pushl $0
  102391:	6a 00                	push   $0x0
  pushl $200
  102393:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102398:	e9 94 02 00 00       	jmp    102631 <__alltraps>

0010239d <vector201>:
.globl vector201
vector201:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $201
  10239f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1023a4:	e9 88 02 00 00       	jmp    102631 <__alltraps>

001023a9 <vector202>:
.globl vector202
vector202:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $202
  1023ab:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1023b0:	e9 7c 02 00 00       	jmp    102631 <__alltraps>

001023b5 <vector203>:
.globl vector203
vector203:
  pushl $0
  1023b5:	6a 00                	push   $0x0
  pushl $203
  1023b7:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1023bc:	e9 70 02 00 00       	jmp    102631 <__alltraps>

001023c1 <vector204>:
.globl vector204
vector204:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $204
  1023c3:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1023c8:	e9 64 02 00 00       	jmp    102631 <__alltraps>

001023cd <vector205>:
.globl vector205
vector205:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $205
  1023cf:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1023d4:	e9 58 02 00 00       	jmp    102631 <__alltraps>

001023d9 <vector206>:
.globl vector206
vector206:
  pushl $0
  1023d9:	6a 00                	push   $0x0
  pushl $206
  1023db:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1023e0:	e9 4c 02 00 00       	jmp    102631 <__alltraps>

001023e5 <vector207>:
.globl vector207
vector207:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $207
  1023e7:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1023ec:	e9 40 02 00 00       	jmp    102631 <__alltraps>

001023f1 <vector208>:
.globl vector208
vector208:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $208
  1023f3:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1023f8:	e9 34 02 00 00       	jmp    102631 <__alltraps>

001023fd <vector209>:
.globl vector209
vector209:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $209
  1023ff:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102404:	e9 28 02 00 00       	jmp    102631 <__alltraps>

00102409 <vector210>:
.globl vector210
vector210:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $210
  10240b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102410:	e9 1c 02 00 00       	jmp    102631 <__alltraps>

00102415 <vector211>:
.globl vector211
vector211:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $211
  102417:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10241c:	e9 10 02 00 00       	jmp    102631 <__alltraps>

00102421 <vector212>:
.globl vector212
vector212:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $212
  102423:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102428:	e9 04 02 00 00       	jmp    102631 <__alltraps>

0010242d <vector213>:
.globl vector213
vector213:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $213
  10242f:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102434:	e9 f8 01 00 00       	jmp    102631 <__alltraps>

00102439 <vector214>:
.globl vector214
vector214:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $214
  10243b:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102440:	e9 ec 01 00 00       	jmp    102631 <__alltraps>

00102445 <vector215>:
.globl vector215
vector215:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $215
  102447:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10244c:	e9 e0 01 00 00       	jmp    102631 <__alltraps>

00102451 <vector216>:
.globl vector216
vector216:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $216
  102453:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102458:	e9 d4 01 00 00       	jmp    102631 <__alltraps>

0010245d <vector217>:
.globl vector217
vector217:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $217
  10245f:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102464:	e9 c8 01 00 00       	jmp    102631 <__alltraps>

00102469 <vector218>:
.globl vector218
vector218:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $218
  10246b:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102470:	e9 bc 01 00 00       	jmp    102631 <__alltraps>

00102475 <vector219>:
.globl vector219
vector219:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $219
  102477:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10247c:	e9 b0 01 00 00       	jmp    102631 <__alltraps>

00102481 <vector220>:
.globl vector220
vector220:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $220
  102483:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102488:	e9 a4 01 00 00       	jmp    102631 <__alltraps>

0010248d <vector221>:
.globl vector221
vector221:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $221
  10248f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102494:	e9 98 01 00 00       	jmp    102631 <__alltraps>

00102499 <vector222>:
.globl vector222
vector222:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $222
  10249b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1024a0:	e9 8c 01 00 00       	jmp    102631 <__alltraps>

001024a5 <vector223>:
.globl vector223
vector223:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $223
  1024a7:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1024ac:	e9 80 01 00 00       	jmp    102631 <__alltraps>

001024b1 <vector224>:
.globl vector224
vector224:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $224
  1024b3:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1024b8:	e9 74 01 00 00       	jmp    102631 <__alltraps>

001024bd <vector225>:
.globl vector225
vector225:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $225
  1024bf:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1024c4:	e9 68 01 00 00       	jmp    102631 <__alltraps>

001024c9 <vector226>:
.globl vector226
vector226:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $226
  1024cb:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1024d0:	e9 5c 01 00 00       	jmp    102631 <__alltraps>

001024d5 <vector227>:
.globl vector227
vector227:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $227
  1024d7:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1024dc:	e9 50 01 00 00       	jmp    102631 <__alltraps>

001024e1 <vector228>:
.globl vector228
vector228:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $228
  1024e3:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1024e8:	e9 44 01 00 00       	jmp    102631 <__alltraps>

001024ed <vector229>:
.globl vector229
vector229:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $229
  1024ef:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1024f4:	e9 38 01 00 00       	jmp    102631 <__alltraps>

001024f9 <vector230>:
.globl vector230
vector230:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $230
  1024fb:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102500:	e9 2c 01 00 00       	jmp    102631 <__alltraps>

00102505 <vector231>:
.globl vector231
vector231:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $231
  102507:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10250c:	e9 20 01 00 00       	jmp    102631 <__alltraps>

00102511 <vector232>:
.globl vector232
vector232:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $232
  102513:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102518:	e9 14 01 00 00       	jmp    102631 <__alltraps>

0010251d <vector233>:
.globl vector233
vector233:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $233
  10251f:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102524:	e9 08 01 00 00       	jmp    102631 <__alltraps>

00102529 <vector234>:
.globl vector234
vector234:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $234
  10252b:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102530:	e9 fc 00 00 00       	jmp    102631 <__alltraps>

00102535 <vector235>:
.globl vector235
vector235:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $235
  102537:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10253c:	e9 f0 00 00 00       	jmp    102631 <__alltraps>

00102541 <vector236>:
.globl vector236
vector236:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $236
  102543:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102548:	e9 e4 00 00 00       	jmp    102631 <__alltraps>

0010254d <vector237>:
.globl vector237
vector237:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $237
  10254f:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102554:	e9 d8 00 00 00       	jmp    102631 <__alltraps>

00102559 <vector238>:
.globl vector238
vector238:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $238
  10255b:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102560:	e9 cc 00 00 00       	jmp    102631 <__alltraps>

00102565 <vector239>:
.globl vector239
vector239:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $239
  102567:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10256c:	e9 c0 00 00 00       	jmp    102631 <__alltraps>

00102571 <vector240>:
.globl vector240
vector240:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $240
  102573:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102578:	e9 b4 00 00 00       	jmp    102631 <__alltraps>

0010257d <vector241>:
.globl vector241
vector241:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $241
  10257f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102584:	e9 a8 00 00 00       	jmp    102631 <__alltraps>

00102589 <vector242>:
.globl vector242
vector242:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $242
  10258b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102590:	e9 9c 00 00 00       	jmp    102631 <__alltraps>

00102595 <vector243>:
.globl vector243
vector243:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $243
  102597:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10259c:	e9 90 00 00 00       	jmp    102631 <__alltraps>

001025a1 <vector244>:
.globl vector244
vector244:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $244
  1025a3:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1025a8:	e9 84 00 00 00       	jmp    102631 <__alltraps>

001025ad <vector245>:
.globl vector245
vector245:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $245
  1025af:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1025b4:	e9 78 00 00 00       	jmp    102631 <__alltraps>

001025b9 <vector246>:
.globl vector246
vector246:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $246
  1025bb:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1025c0:	e9 6c 00 00 00       	jmp    102631 <__alltraps>

001025c5 <vector247>:
.globl vector247
vector247:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $247
  1025c7:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1025cc:	e9 60 00 00 00       	jmp    102631 <__alltraps>

001025d1 <vector248>:
.globl vector248
vector248:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $248
  1025d3:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1025d8:	e9 54 00 00 00       	jmp    102631 <__alltraps>

001025dd <vector249>:
.globl vector249
vector249:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $249
  1025df:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1025e4:	e9 48 00 00 00       	jmp    102631 <__alltraps>

001025e9 <vector250>:
.globl vector250
vector250:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $250
  1025eb:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1025f0:	e9 3c 00 00 00       	jmp    102631 <__alltraps>

001025f5 <vector251>:
.globl vector251
vector251:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $251
  1025f7:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1025fc:	e9 30 00 00 00       	jmp    102631 <__alltraps>

00102601 <vector252>:
.globl vector252
vector252:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $252
  102603:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102608:	e9 24 00 00 00       	jmp    102631 <__alltraps>

0010260d <vector253>:
.globl vector253
vector253:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $253
  10260f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102614:	e9 18 00 00 00       	jmp    102631 <__alltraps>

00102619 <vector254>:
.globl vector254
vector254:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $254
  10261b:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102620:	e9 0c 00 00 00       	jmp    102631 <__alltraps>

00102625 <vector255>:
.globl vector255
vector255:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $255
  102627:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10262c:	e9 00 00 00 00       	jmp    102631 <__alltraps>

00102631 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102631:	1e                   	push   %ds
    pushl %es
  102632:	06                   	push   %es
    pushl %fs
  102633:	0f a0                	push   %fs
    pushl %gs
  102635:	0f a8                	push   %gs
    pushal
  102637:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102638:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10263d:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10263f:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102641:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102642:	e8 64 f5 ff ff       	call   101bab <trap>

    # pop the pushed stack pointer
    popl %esp
  102647:	5c                   	pop    %esp

00102648 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102648:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102649:	0f a9                	pop    %gs
    popl %fs
  10264b:	0f a1                	pop    %fs
    popl %es
  10264d:	07                   	pop    %es
    popl %ds
  10264e:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10264f:	83 c4 08             	add    $0x8,%esp
    iret
  102652:	cf                   	iret   

00102653 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102653:	55                   	push   %ebp
  102654:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102656:	8b 45 08             	mov    0x8(%ebp),%eax
  102659:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10265c:	b8 23 00 00 00       	mov    $0x23,%eax
  102661:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102663:	b8 23 00 00 00       	mov    $0x23,%eax
  102668:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10266a:	b8 10 00 00 00       	mov    $0x10,%eax
  10266f:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102671:	b8 10 00 00 00       	mov    $0x10,%eax
  102676:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102678:	b8 10 00 00 00       	mov    $0x10,%eax
  10267d:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10267f:	ea 86 26 10 00 08 00 	ljmp   $0x8,$0x102686
}
  102686:	90                   	nop
  102687:	5d                   	pop    %ebp
  102688:	c3                   	ret    

00102689 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102689:	55                   	push   %ebp
  10268a:	89 e5                	mov    %esp,%ebp
  10268c:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10268f:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102694:	05 00 04 00 00       	add    $0x400,%eax
  102699:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10269e:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1026a5:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1026a7:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1026ae:	68 00 
  1026b0:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026b5:	0f b7 c0             	movzwl %ax,%eax
  1026b8:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1026be:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026c3:	c1 e8 10             	shr    $0x10,%eax
  1026c6:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1026cb:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026d2:	24 f0                	and    $0xf0,%al
  1026d4:	0c 09                	or     $0x9,%al
  1026d6:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026db:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026e2:	0c 10                	or     $0x10,%al
  1026e4:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026e9:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026f0:	24 9f                	and    $0x9f,%al
  1026f2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026f7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026fe:	0c 80                	or     $0x80,%al
  102700:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102705:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10270c:	24 f0                	and    $0xf0,%al
  10270e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102713:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10271a:	24 ef                	and    $0xef,%al
  10271c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102721:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102728:	24 df                	and    $0xdf,%al
  10272a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10272f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102736:	0c 40                	or     $0x40,%al
  102738:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10273d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102744:	24 7f                	and    $0x7f,%al
  102746:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10274b:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102750:	c1 e8 18             	shr    $0x18,%eax
  102753:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102758:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10275f:	24 ef                	and    $0xef,%al
  102761:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102766:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10276d:	e8 e1 fe ff ff       	call   102653 <lgdt>
  102772:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102778:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10277c:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10277f:	90                   	nop
  102780:	c9                   	leave  
  102781:	c3                   	ret    

00102782 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102782:	55                   	push   %ebp
  102783:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102785:	e8 ff fe ff ff       	call   102689 <gdt_init>
}
  10278a:	90                   	nop
  10278b:	5d                   	pop    %ebp
  10278c:	c3                   	ret    

0010278d <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10278d:	55                   	push   %ebp
  10278e:	89 e5                	mov    %esp,%ebp
  102790:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102793:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10279a:	eb 03                	jmp    10279f <strlen+0x12>
        cnt ++;
  10279c:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  10279f:	8b 45 08             	mov    0x8(%ebp),%eax
  1027a2:	8d 50 01             	lea    0x1(%eax),%edx
  1027a5:	89 55 08             	mov    %edx,0x8(%ebp)
  1027a8:	0f b6 00             	movzbl (%eax),%eax
  1027ab:	84 c0                	test   %al,%al
  1027ad:	75 ed                	jne    10279c <strlen+0xf>
    }
    return cnt;
  1027af:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1027b2:	c9                   	leave  
  1027b3:	c3                   	ret    

001027b4 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1027b4:	55                   	push   %ebp
  1027b5:	89 e5                	mov    %esp,%ebp
  1027b7:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1027ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1027c1:	eb 03                	jmp    1027c6 <strnlen+0x12>
        cnt ++;
  1027c3:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1027c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1027c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1027cc:	73 10                	jae    1027de <strnlen+0x2a>
  1027ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1027d1:	8d 50 01             	lea    0x1(%eax),%edx
  1027d4:	89 55 08             	mov    %edx,0x8(%ebp)
  1027d7:	0f b6 00             	movzbl (%eax),%eax
  1027da:	84 c0                	test   %al,%al
  1027dc:	75 e5                	jne    1027c3 <strnlen+0xf>
    }
    return cnt;
  1027de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1027e1:	c9                   	leave  
  1027e2:	c3                   	ret    

001027e3 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1027e3:	55                   	push   %ebp
  1027e4:	89 e5                	mov    %esp,%ebp
  1027e6:	57                   	push   %edi
  1027e7:	56                   	push   %esi
  1027e8:	83 ec 20             	sub    $0x20,%esp
  1027eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1027ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1027f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1027f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1027f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1027fd:	89 d1                	mov    %edx,%ecx
  1027ff:	89 c2                	mov    %eax,%edx
  102801:	89 ce                	mov    %ecx,%esi
  102803:	89 d7                	mov    %edx,%edi
  102805:	ac                   	lods   %ds:(%esi),%al
  102806:	aa                   	stos   %al,%es:(%edi)
  102807:	84 c0                	test   %al,%al
  102809:	75 fa                	jne    102805 <strcpy+0x22>
  10280b:	89 fa                	mov    %edi,%edx
  10280d:	89 f1                	mov    %esi,%ecx
  10280f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102812:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102818:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  10281b:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10281c:	83 c4 20             	add    $0x20,%esp
  10281f:	5e                   	pop    %esi
  102820:	5f                   	pop    %edi
  102821:	5d                   	pop    %ebp
  102822:	c3                   	ret    

00102823 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102823:	55                   	push   %ebp
  102824:	89 e5                	mov    %esp,%ebp
  102826:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102829:	8b 45 08             	mov    0x8(%ebp),%eax
  10282c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10282f:	eb 1e                	jmp    10284f <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  102831:	8b 45 0c             	mov    0xc(%ebp),%eax
  102834:	0f b6 10             	movzbl (%eax),%edx
  102837:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10283a:	88 10                	mov    %dl,(%eax)
  10283c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10283f:	0f b6 00             	movzbl (%eax),%eax
  102842:	84 c0                	test   %al,%al
  102844:	74 03                	je     102849 <strncpy+0x26>
            src ++;
  102846:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102849:	ff 45 fc             	incl   -0x4(%ebp)
  10284c:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  10284f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102853:	75 dc                	jne    102831 <strncpy+0xe>
    }
    return dst;
  102855:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102858:	c9                   	leave  
  102859:	c3                   	ret    

0010285a <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10285a:	55                   	push   %ebp
  10285b:	89 e5                	mov    %esp,%ebp
  10285d:	57                   	push   %edi
  10285e:	56                   	push   %esi
  10285f:	83 ec 20             	sub    $0x20,%esp
  102862:	8b 45 08             	mov    0x8(%ebp),%eax
  102865:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102868:	8b 45 0c             	mov    0xc(%ebp),%eax
  10286b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  10286e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102874:	89 d1                	mov    %edx,%ecx
  102876:	89 c2                	mov    %eax,%edx
  102878:	89 ce                	mov    %ecx,%esi
  10287a:	89 d7                	mov    %edx,%edi
  10287c:	ac                   	lods   %ds:(%esi),%al
  10287d:	ae                   	scas   %es:(%edi),%al
  10287e:	75 08                	jne    102888 <strcmp+0x2e>
  102880:	84 c0                	test   %al,%al
  102882:	75 f8                	jne    10287c <strcmp+0x22>
  102884:	31 c0                	xor    %eax,%eax
  102886:	eb 04                	jmp    10288c <strcmp+0x32>
  102888:	19 c0                	sbb    %eax,%eax
  10288a:	0c 01                	or     $0x1,%al
  10288c:	89 fa                	mov    %edi,%edx
  10288e:	89 f1                	mov    %esi,%ecx
  102890:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102893:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102896:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102899:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  10289c:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10289d:	83 c4 20             	add    $0x20,%esp
  1028a0:	5e                   	pop    %esi
  1028a1:	5f                   	pop    %edi
  1028a2:	5d                   	pop    %ebp
  1028a3:	c3                   	ret    

001028a4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1028a4:	55                   	push   %ebp
  1028a5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1028a7:	eb 09                	jmp    1028b2 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  1028a9:	ff 4d 10             	decl   0x10(%ebp)
  1028ac:	ff 45 08             	incl   0x8(%ebp)
  1028af:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1028b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1028b6:	74 1a                	je     1028d2 <strncmp+0x2e>
  1028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1028bb:	0f b6 00             	movzbl (%eax),%eax
  1028be:	84 c0                	test   %al,%al
  1028c0:	74 10                	je     1028d2 <strncmp+0x2e>
  1028c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1028c5:	0f b6 10             	movzbl (%eax),%edx
  1028c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028cb:	0f b6 00             	movzbl (%eax),%eax
  1028ce:	38 c2                	cmp    %al,%dl
  1028d0:	74 d7                	je     1028a9 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1028d2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1028d6:	74 18                	je     1028f0 <strncmp+0x4c>
  1028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1028db:	0f b6 00             	movzbl (%eax),%eax
  1028de:	0f b6 d0             	movzbl %al,%edx
  1028e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028e4:	0f b6 00             	movzbl (%eax),%eax
  1028e7:	0f b6 c0             	movzbl %al,%eax
  1028ea:	29 c2                	sub    %eax,%edx
  1028ec:	89 d0                	mov    %edx,%eax
  1028ee:	eb 05                	jmp    1028f5 <strncmp+0x51>
  1028f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1028f5:	5d                   	pop    %ebp
  1028f6:	c3                   	ret    

001028f7 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1028f7:	55                   	push   %ebp
  1028f8:	89 e5                	mov    %esp,%ebp
  1028fa:	83 ec 04             	sub    $0x4,%esp
  1028fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102900:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102903:	eb 13                	jmp    102918 <strchr+0x21>
        if (*s == c) {
  102905:	8b 45 08             	mov    0x8(%ebp),%eax
  102908:	0f b6 00             	movzbl (%eax),%eax
  10290b:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10290e:	75 05                	jne    102915 <strchr+0x1e>
            return (char *)s;
  102910:	8b 45 08             	mov    0x8(%ebp),%eax
  102913:	eb 12                	jmp    102927 <strchr+0x30>
        }
        s ++;
  102915:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102918:	8b 45 08             	mov    0x8(%ebp),%eax
  10291b:	0f b6 00             	movzbl (%eax),%eax
  10291e:	84 c0                	test   %al,%al
  102920:	75 e3                	jne    102905 <strchr+0xe>
    }
    return NULL;
  102922:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102927:	c9                   	leave  
  102928:	c3                   	ret    

00102929 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102929:	55                   	push   %ebp
  10292a:	89 e5                	mov    %esp,%ebp
  10292c:	83 ec 04             	sub    $0x4,%esp
  10292f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102932:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102935:	eb 0e                	jmp    102945 <strfind+0x1c>
        if (*s == c) {
  102937:	8b 45 08             	mov    0x8(%ebp),%eax
  10293a:	0f b6 00             	movzbl (%eax),%eax
  10293d:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102940:	74 0f                	je     102951 <strfind+0x28>
            break;
        }
        s ++;
  102942:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102945:	8b 45 08             	mov    0x8(%ebp),%eax
  102948:	0f b6 00             	movzbl (%eax),%eax
  10294b:	84 c0                	test   %al,%al
  10294d:	75 e8                	jne    102937 <strfind+0xe>
  10294f:	eb 01                	jmp    102952 <strfind+0x29>
            break;
  102951:	90                   	nop
    }
    return (char *)s;
  102952:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102955:	c9                   	leave  
  102956:	c3                   	ret    

00102957 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102957:	55                   	push   %ebp
  102958:	89 e5                	mov    %esp,%ebp
  10295a:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10295d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102964:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10296b:	eb 03                	jmp    102970 <strtol+0x19>
        s ++;
  10296d:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102970:	8b 45 08             	mov    0x8(%ebp),%eax
  102973:	0f b6 00             	movzbl (%eax),%eax
  102976:	3c 20                	cmp    $0x20,%al
  102978:	74 f3                	je     10296d <strtol+0x16>
  10297a:	8b 45 08             	mov    0x8(%ebp),%eax
  10297d:	0f b6 00             	movzbl (%eax),%eax
  102980:	3c 09                	cmp    $0x9,%al
  102982:	74 e9                	je     10296d <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102984:	8b 45 08             	mov    0x8(%ebp),%eax
  102987:	0f b6 00             	movzbl (%eax),%eax
  10298a:	3c 2b                	cmp    $0x2b,%al
  10298c:	75 05                	jne    102993 <strtol+0x3c>
        s ++;
  10298e:	ff 45 08             	incl   0x8(%ebp)
  102991:	eb 14                	jmp    1029a7 <strtol+0x50>
    }
    else if (*s == '-') {
  102993:	8b 45 08             	mov    0x8(%ebp),%eax
  102996:	0f b6 00             	movzbl (%eax),%eax
  102999:	3c 2d                	cmp    $0x2d,%al
  10299b:	75 0a                	jne    1029a7 <strtol+0x50>
        s ++, neg = 1;
  10299d:	ff 45 08             	incl   0x8(%ebp)
  1029a0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1029a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029ab:	74 06                	je     1029b3 <strtol+0x5c>
  1029ad:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1029b1:	75 22                	jne    1029d5 <strtol+0x7e>
  1029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b6:	0f b6 00             	movzbl (%eax),%eax
  1029b9:	3c 30                	cmp    $0x30,%al
  1029bb:	75 18                	jne    1029d5 <strtol+0x7e>
  1029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c0:	40                   	inc    %eax
  1029c1:	0f b6 00             	movzbl (%eax),%eax
  1029c4:	3c 78                	cmp    $0x78,%al
  1029c6:	75 0d                	jne    1029d5 <strtol+0x7e>
        s += 2, base = 16;
  1029c8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1029cc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1029d3:	eb 29                	jmp    1029fe <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  1029d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029d9:	75 16                	jne    1029f1 <strtol+0x9a>
  1029db:	8b 45 08             	mov    0x8(%ebp),%eax
  1029de:	0f b6 00             	movzbl (%eax),%eax
  1029e1:	3c 30                	cmp    $0x30,%al
  1029e3:	75 0c                	jne    1029f1 <strtol+0x9a>
        s ++, base = 8;
  1029e5:	ff 45 08             	incl   0x8(%ebp)
  1029e8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1029ef:	eb 0d                	jmp    1029fe <strtol+0xa7>
    }
    else if (base == 0) {
  1029f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029f5:	75 07                	jne    1029fe <strtol+0xa7>
        base = 10;
  1029f7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  102a01:	0f b6 00             	movzbl (%eax),%eax
  102a04:	3c 2f                	cmp    $0x2f,%al
  102a06:	7e 1b                	jle    102a23 <strtol+0xcc>
  102a08:	8b 45 08             	mov    0x8(%ebp),%eax
  102a0b:	0f b6 00             	movzbl (%eax),%eax
  102a0e:	3c 39                	cmp    $0x39,%al
  102a10:	7f 11                	jg     102a23 <strtol+0xcc>
            dig = *s - '0';
  102a12:	8b 45 08             	mov    0x8(%ebp),%eax
  102a15:	0f b6 00             	movzbl (%eax),%eax
  102a18:	0f be c0             	movsbl %al,%eax
  102a1b:	83 e8 30             	sub    $0x30,%eax
  102a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a21:	eb 48                	jmp    102a6b <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102a23:	8b 45 08             	mov    0x8(%ebp),%eax
  102a26:	0f b6 00             	movzbl (%eax),%eax
  102a29:	3c 60                	cmp    $0x60,%al
  102a2b:	7e 1b                	jle    102a48 <strtol+0xf1>
  102a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a30:	0f b6 00             	movzbl (%eax),%eax
  102a33:	3c 7a                	cmp    $0x7a,%al
  102a35:	7f 11                	jg     102a48 <strtol+0xf1>
            dig = *s - 'a' + 10;
  102a37:	8b 45 08             	mov    0x8(%ebp),%eax
  102a3a:	0f b6 00             	movzbl (%eax),%eax
  102a3d:	0f be c0             	movsbl %al,%eax
  102a40:	83 e8 57             	sub    $0x57,%eax
  102a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a46:	eb 23                	jmp    102a6b <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102a48:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4b:	0f b6 00             	movzbl (%eax),%eax
  102a4e:	3c 40                	cmp    $0x40,%al
  102a50:	7e 3b                	jle    102a8d <strtol+0x136>
  102a52:	8b 45 08             	mov    0x8(%ebp),%eax
  102a55:	0f b6 00             	movzbl (%eax),%eax
  102a58:	3c 5a                	cmp    $0x5a,%al
  102a5a:	7f 31                	jg     102a8d <strtol+0x136>
            dig = *s - 'A' + 10;
  102a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5f:	0f b6 00             	movzbl (%eax),%eax
  102a62:	0f be c0             	movsbl %al,%eax
  102a65:	83 e8 37             	sub    $0x37,%eax
  102a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a6e:	3b 45 10             	cmp    0x10(%ebp),%eax
  102a71:	7d 19                	jge    102a8c <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  102a73:	ff 45 08             	incl   0x8(%ebp)
  102a76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102a79:	0f af 45 10          	imul   0x10(%ebp),%eax
  102a7d:	89 c2                	mov    %eax,%edx
  102a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a82:	01 d0                	add    %edx,%eax
  102a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102a87:	e9 72 ff ff ff       	jmp    1029fe <strtol+0xa7>
            break;
  102a8c:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102a8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a91:	74 08                	je     102a9b <strtol+0x144>
        *endptr = (char *) s;
  102a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a96:	8b 55 08             	mov    0x8(%ebp),%edx
  102a99:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102a9b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102a9f:	74 07                	je     102aa8 <strtol+0x151>
  102aa1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102aa4:	f7 d8                	neg    %eax
  102aa6:	eb 03                	jmp    102aab <strtol+0x154>
  102aa8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102aab:	c9                   	leave  
  102aac:	c3                   	ret    

00102aad <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102aad:	55                   	push   %ebp
  102aae:	89 e5                	mov    %esp,%ebp
  102ab0:	57                   	push   %edi
  102ab1:	83 ec 24             	sub    $0x24,%esp
  102ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ab7:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102aba:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102abe:	8b 55 08             	mov    0x8(%ebp),%edx
  102ac1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102ac4:	88 45 f7             	mov    %al,-0x9(%ebp)
  102ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  102aca:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102acd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102ad0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102ad4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102ad7:	89 d7                	mov    %edx,%edi
  102ad9:	f3 aa                	rep stos %al,%es:(%edi)
  102adb:	89 fa                	mov    %edi,%edx
  102add:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102ae0:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102ae3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ae6:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102ae7:	83 c4 24             	add    $0x24,%esp
  102aea:	5f                   	pop    %edi
  102aeb:	5d                   	pop    %ebp
  102aec:	c3                   	ret    

00102aed <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102aed:	55                   	push   %ebp
  102aee:	89 e5                	mov    %esp,%ebp
  102af0:	57                   	push   %edi
  102af1:	56                   	push   %esi
  102af2:	53                   	push   %ebx
  102af3:	83 ec 30             	sub    $0x30,%esp
  102af6:	8b 45 08             	mov    0x8(%ebp),%eax
  102af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102aff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102b02:	8b 45 10             	mov    0x10(%ebp),%eax
  102b05:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b0b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102b0e:	73 42                	jae    102b52 <memmove+0x65>
  102b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102b16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b19:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b1f:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102b22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b25:	c1 e8 02             	shr    $0x2,%eax
  102b28:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102b2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b30:	89 d7                	mov    %edx,%edi
  102b32:	89 c6                	mov    %eax,%esi
  102b34:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102b36:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102b39:	83 e1 03             	and    $0x3,%ecx
  102b3c:	74 02                	je     102b40 <memmove+0x53>
  102b3e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102b40:	89 f0                	mov    %esi,%eax
  102b42:	89 fa                	mov    %edi,%edx
  102b44:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102b47:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102b4a:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102b50:	eb 36                	jmp    102b88 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b55:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b5b:	01 c2                	add    %eax,%edx
  102b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b60:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b66:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102b69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b6c:	89 c1                	mov    %eax,%ecx
  102b6e:	89 d8                	mov    %ebx,%eax
  102b70:	89 d6                	mov    %edx,%esi
  102b72:	89 c7                	mov    %eax,%edi
  102b74:	fd                   	std    
  102b75:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102b77:	fc                   	cld    
  102b78:	89 f8                	mov    %edi,%eax
  102b7a:	89 f2                	mov    %esi,%edx
  102b7c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102b7f:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102b82:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102b88:	83 c4 30             	add    $0x30,%esp
  102b8b:	5b                   	pop    %ebx
  102b8c:	5e                   	pop    %esi
  102b8d:	5f                   	pop    %edi
  102b8e:	5d                   	pop    %ebp
  102b8f:	c3                   	ret    

00102b90 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102b90:	55                   	push   %ebp
  102b91:	89 e5                	mov    %esp,%ebp
  102b93:	57                   	push   %edi
  102b94:	56                   	push   %esi
  102b95:	83 ec 20             	sub    $0x20,%esp
  102b98:	8b 45 08             	mov    0x8(%ebp),%eax
  102b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  102ba7:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102baa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bad:	c1 e8 02             	shr    $0x2,%eax
  102bb0:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bb8:	89 d7                	mov    %edx,%edi
  102bba:	89 c6                	mov    %eax,%esi
  102bbc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102bbe:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102bc1:	83 e1 03             	and    $0x3,%ecx
  102bc4:	74 02                	je     102bc8 <memcpy+0x38>
  102bc6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102bc8:	89 f0                	mov    %esi,%eax
  102bca:	89 fa                	mov    %edi,%edx
  102bcc:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102bcf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102bd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102bd8:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102bd9:	83 c4 20             	add    $0x20,%esp
  102bdc:	5e                   	pop    %esi
  102bdd:	5f                   	pop    %edi
  102bde:	5d                   	pop    %ebp
  102bdf:	c3                   	ret    

00102be0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102be0:	55                   	push   %ebp
  102be1:	89 e5                	mov    %esp,%ebp
  102be3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102be6:	8b 45 08             	mov    0x8(%ebp),%eax
  102be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102bec:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bef:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102bf2:	eb 2e                	jmp    102c22 <memcmp+0x42>
        if (*s1 != *s2) {
  102bf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102bf7:	0f b6 10             	movzbl (%eax),%edx
  102bfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102bfd:	0f b6 00             	movzbl (%eax),%eax
  102c00:	38 c2                	cmp    %al,%dl
  102c02:	74 18                	je     102c1c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c07:	0f b6 00             	movzbl (%eax),%eax
  102c0a:	0f b6 d0             	movzbl %al,%edx
  102c0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c10:	0f b6 00             	movzbl (%eax),%eax
  102c13:	0f b6 c0             	movzbl %al,%eax
  102c16:	29 c2                	sub    %eax,%edx
  102c18:	89 d0                	mov    %edx,%eax
  102c1a:	eb 18                	jmp    102c34 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  102c1c:	ff 45 fc             	incl   -0x4(%ebp)
  102c1f:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  102c22:	8b 45 10             	mov    0x10(%ebp),%eax
  102c25:	8d 50 ff             	lea    -0x1(%eax),%edx
  102c28:	89 55 10             	mov    %edx,0x10(%ebp)
  102c2b:	85 c0                	test   %eax,%eax
  102c2d:	75 c5                	jne    102bf4 <memcmp+0x14>
    }
    return 0;
  102c2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c34:	c9                   	leave  
  102c35:	c3                   	ret    

00102c36 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102c36:	55                   	push   %ebp
  102c37:	89 e5                	mov    %esp,%ebp
  102c39:	83 ec 58             	sub    $0x58,%esp
  102c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  102c3f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c42:	8b 45 14             	mov    0x14(%ebp),%eax
  102c45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102c48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c4b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c4e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c51:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102c54:	8b 45 18             	mov    0x18(%ebp),%eax
  102c57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c5d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c60:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c63:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102c70:	74 1c                	je     102c8e <printnum+0x58>
  102c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c75:	ba 00 00 00 00       	mov    $0x0,%edx
  102c7a:	f7 75 e4             	divl   -0x1c(%ebp)
  102c7d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c83:	ba 00 00 00 00       	mov    $0x0,%edx
  102c88:	f7 75 e4             	divl   -0x1c(%ebp)
  102c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102c94:	f7 75 e4             	divl   -0x1c(%ebp)
  102c97:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c9a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ca0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ca3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ca6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102ca9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cac:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102caf:	8b 45 18             	mov    0x18(%ebp),%eax
  102cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  102cb7:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102cba:	72 56                	jb     102d12 <printnum+0xdc>
  102cbc:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102cbf:	77 05                	ja     102cc6 <printnum+0x90>
  102cc1:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102cc4:	72 4c                	jb     102d12 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102cc6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102cc9:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ccc:	8b 45 20             	mov    0x20(%ebp),%eax
  102ccf:	89 44 24 18          	mov    %eax,0x18(%esp)
  102cd3:	89 54 24 14          	mov    %edx,0x14(%esp)
  102cd7:	8b 45 18             	mov    0x18(%ebp),%eax
  102cda:	89 44 24 10          	mov    %eax,0x10(%esp)
  102cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ce1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ce4:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ce8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102cec:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf6:	89 04 24             	mov    %eax,(%esp)
  102cf9:	e8 38 ff ff ff       	call   102c36 <printnum>
  102cfe:	eb 1b                	jmp    102d1b <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d07:	8b 45 20             	mov    0x20(%ebp),%eax
  102d0a:	89 04 24             	mov    %eax,(%esp)
  102d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d10:	ff d0                	call   *%eax
        while (-- width > 0)
  102d12:	ff 4d 1c             	decl   0x1c(%ebp)
  102d15:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102d19:	7f e5                	jg     102d00 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102d1b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d1e:	05 50 3a 10 00       	add    $0x103a50,%eax
  102d23:	0f b6 00             	movzbl (%eax),%eax
  102d26:	0f be c0             	movsbl %al,%eax
  102d29:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d2c:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d30:	89 04 24             	mov    %eax,(%esp)
  102d33:	8b 45 08             	mov    0x8(%ebp),%eax
  102d36:	ff d0                	call   *%eax
}
  102d38:	90                   	nop
  102d39:	c9                   	leave  
  102d3a:	c3                   	ret    

00102d3b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102d3b:	55                   	push   %ebp
  102d3c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102d3e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102d42:	7e 14                	jle    102d58 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102d44:	8b 45 08             	mov    0x8(%ebp),%eax
  102d47:	8b 00                	mov    (%eax),%eax
  102d49:	8d 48 08             	lea    0x8(%eax),%ecx
  102d4c:	8b 55 08             	mov    0x8(%ebp),%edx
  102d4f:	89 0a                	mov    %ecx,(%edx)
  102d51:	8b 50 04             	mov    0x4(%eax),%edx
  102d54:	8b 00                	mov    (%eax),%eax
  102d56:	eb 30                	jmp    102d88 <getuint+0x4d>
    }
    else if (lflag) {
  102d58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d5c:	74 16                	je     102d74 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d61:	8b 00                	mov    (%eax),%eax
  102d63:	8d 48 04             	lea    0x4(%eax),%ecx
  102d66:	8b 55 08             	mov    0x8(%ebp),%edx
  102d69:	89 0a                	mov    %ecx,(%edx)
  102d6b:	8b 00                	mov    (%eax),%eax
  102d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  102d72:	eb 14                	jmp    102d88 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102d74:	8b 45 08             	mov    0x8(%ebp),%eax
  102d77:	8b 00                	mov    (%eax),%eax
  102d79:	8d 48 04             	lea    0x4(%eax),%ecx
  102d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  102d7f:	89 0a                	mov    %ecx,(%edx)
  102d81:	8b 00                	mov    (%eax),%eax
  102d83:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102d88:	5d                   	pop    %ebp
  102d89:	c3                   	ret    

00102d8a <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102d8a:	55                   	push   %ebp
  102d8b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102d8d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102d91:	7e 14                	jle    102da7 <getint+0x1d>
        return va_arg(*ap, long long);
  102d93:	8b 45 08             	mov    0x8(%ebp),%eax
  102d96:	8b 00                	mov    (%eax),%eax
  102d98:	8d 48 08             	lea    0x8(%eax),%ecx
  102d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  102d9e:	89 0a                	mov    %ecx,(%edx)
  102da0:	8b 50 04             	mov    0x4(%eax),%edx
  102da3:	8b 00                	mov    (%eax),%eax
  102da5:	eb 28                	jmp    102dcf <getint+0x45>
    }
    else if (lflag) {
  102da7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102dab:	74 12                	je     102dbf <getint+0x35>
        return va_arg(*ap, long);
  102dad:	8b 45 08             	mov    0x8(%ebp),%eax
  102db0:	8b 00                	mov    (%eax),%eax
  102db2:	8d 48 04             	lea    0x4(%eax),%ecx
  102db5:	8b 55 08             	mov    0x8(%ebp),%edx
  102db8:	89 0a                	mov    %ecx,(%edx)
  102dba:	8b 00                	mov    (%eax),%eax
  102dbc:	99                   	cltd   
  102dbd:	eb 10                	jmp    102dcf <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc2:	8b 00                	mov    (%eax),%eax
  102dc4:	8d 48 04             	lea    0x4(%eax),%ecx
  102dc7:	8b 55 08             	mov    0x8(%ebp),%edx
  102dca:	89 0a                	mov    %ecx,(%edx)
  102dcc:	8b 00                	mov    (%eax),%eax
  102dce:	99                   	cltd   
    }
}
  102dcf:	5d                   	pop    %ebp
  102dd0:	c3                   	ret    

00102dd1 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102dd1:	55                   	push   %ebp
  102dd2:	89 e5                	mov    %esp,%ebp
  102dd4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102dd7:	8d 45 14             	lea    0x14(%ebp),%eax
  102dda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102ddd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102de0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102de4:	8b 45 10             	mov    0x10(%ebp),%eax
  102de7:	89 44 24 08          	mov    %eax,0x8(%esp)
  102deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dee:	89 44 24 04          	mov    %eax,0x4(%esp)
  102df2:	8b 45 08             	mov    0x8(%ebp),%eax
  102df5:	89 04 24             	mov    %eax,(%esp)
  102df8:	e8 03 00 00 00       	call   102e00 <vprintfmt>
    va_end(ap);
}
  102dfd:	90                   	nop
  102dfe:	c9                   	leave  
  102dff:	c3                   	ret    

00102e00 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102e00:	55                   	push   %ebp
  102e01:	89 e5                	mov    %esp,%ebp
  102e03:	56                   	push   %esi
  102e04:	53                   	push   %ebx
  102e05:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e08:	eb 17                	jmp    102e21 <vprintfmt+0x21>
            if (ch == '\0') {
  102e0a:	85 db                	test   %ebx,%ebx
  102e0c:	0f 84 bf 03 00 00    	je     1031d1 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  102e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e15:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e19:	89 1c 24             	mov    %ebx,(%esp)
  102e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1f:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e21:	8b 45 10             	mov    0x10(%ebp),%eax
  102e24:	8d 50 01             	lea    0x1(%eax),%edx
  102e27:	89 55 10             	mov    %edx,0x10(%ebp)
  102e2a:	0f b6 00             	movzbl (%eax),%eax
  102e2d:	0f b6 d8             	movzbl %al,%ebx
  102e30:	83 fb 25             	cmp    $0x25,%ebx
  102e33:	75 d5                	jne    102e0a <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102e35:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102e39:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102e40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e43:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102e46:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e50:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102e53:	8b 45 10             	mov    0x10(%ebp),%eax
  102e56:	8d 50 01             	lea    0x1(%eax),%edx
  102e59:	89 55 10             	mov    %edx,0x10(%ebp)
  102e5c:	0f b6 00             	movzbl (%eax),%eax
  102e5f:	0f b6 d8             	movzbl %al,%ebx
  102e62:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102e65:	83 f8 55             	cmp    $0x55,%eax
  102e68:	0f 87 37 03 00 00    	ja     1031a5 <vprintfmt+0x3a5>
  102e6e:	8b 04 85 74 3a 10 00 	mov    0x103a74(,%eax,4),%eax
  102e75:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102e77:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102e7b:	eb d6                	jmp    102e53 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102e7d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102e81:	eb d0                	jmp    102e53 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102e83:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102e8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e8d:	89 d0                	mov    %edx,%eax
  102e8f:	c1 e0 02             	shl    $0x2,%eax
  102e92:	01 d0                	add    %edx,%eax
  102e94:	01 c0                	add    %eax,%eax
  102e96:	01 d8                	add    %ebx,%eax
  102e98:	83 e8 30             	sub    $0x30,%eax
  102e9b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  102ea1:	0f b6 00             	movzbl (%eax),%eax
  102ea4:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102ea7:	83 fb 2f             	cmp    $0x2f,%ebx
  102eaa:	7e 38                	jle    102ee4 <vprintfmt+0xe4>
  102eac:	83 fb 39             	cmp    $0x39,%ebx
  102eaf:	7f 33                	jg     102ee4 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  102eb1:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  102eb4:	eb d4                	jmp    102e8a <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  102eb6:	8b 45 14             	mov    0x14(%ebp),%eax
  102eb9:	8d 50 04             	lea    0x4(%eax),%edx
  102ebc:	89 55 14             	mov    %edx,0x14(%ebp)
  102ebf:	8b 00                	mov    (%eax),%eax
  102ec1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102ec4:	eb 1f                	jmp    102ee5 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  102ec6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102eca:	79 87                	jns    102e53 <vprintfmt+0x53>
                width = 0;
  102ecc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102ed3:	e9 7b ff ff ff       	jmp    102e53 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  102ed8:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102edf:	e9 6f ff ff ff       	jmp    102e53 <vprintfmt+0x53>
            goto process_precision;
  102ee4:	90                   	nop

        process_precision:
            if (width < 0)
  102ee5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ee9:	0f 89 64 ff ff ff    	jns    102e53 <vprintfmt+0x53>
                width = precision, precision = -1;
  102eef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ef2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ef5:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102efc:	e9 52 ff ff ff       	jmp    102e53 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102f01:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  102f04:	e9 4a ff ff ff       	jmp    102e53 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102f09:	8b 45 14             	mov    0x14(%ebp),%eax
  102f0c:	8d 50 04             	lea    0x4(%eax),%edx
  102f0f:	89 55 14             	mov    %edx,0x14(%ebp)
  102f12:	8b 00                	mov    (%eax),%eax
  102f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f17:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f1b:	89 04 24             	mov    %eax,(%esp)
  102f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102f21:	ff d0                	call   *%eax
            break;
  102f23:	e9 a4 02 00 00       	jmp    1031cc <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102f28:	8b 45 14             	mov    0x14(%ebp),%eax
  102f2b:	8d 50 04             	lea    0x4(%eax),%edx
  102f2e:	89 55 14             	mov    %edx,0x14(%ebp)
  102f31:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102f33:	85 db                	test   %ebx,%ebx
  102f35:	79 02                	jns    102f39 <vprintfmt+0x139>
                err = -err;
  102f37:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102f39:	83 fb 06             	cmp    $0x6,%ebx
  102f3c:	7f 0b                	jg     102f49 <vprintfmt+0x149>
  102f3e:	8b 34 9d 34 3a 10 00 	mov    0x103a34(,%ebx,4),%esi
  102f45:	85 f6                	test   %esi,%esi
  102f47:	75 23                	jne    102f6c <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  102f49:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102f4d:	c7 44 24 08 61 3a 10 	movl   $0x103a61,0x8(%esp)
  102f54:	00 
  102f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f58:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f5f:	89 04 24             	mov    %eax,(%esp)
  102f62:	e8 6a fe ff ff       	call   102dd1 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102f67:	e9 60 02 00 00       	jmp    1031cc <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  102f6c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102f70:	c7 44 24 08 6a 3a 10 	movl   $0x103a6a,0x8(%esp)
  102f77:	00 
  102f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f82:	89 04 24             	mov    %eax,(%esp)
  102f85:	e8 47 fe ff ff       	call   102dd1 <printfmt>
            break;
  102f8a:	e9 3d 02 00 00       	jmp    1031cc <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102f8f:	8b 45 14             	mov    0x14(%ebp),%eax
  102f92:	8d 50 04             	lea    0x4(%eax),%edx
  102f95:	89 55 14             	mov    %edx,0x14(%ebp)
  102f98:	8b 30                	mov    (%eax),%esi
  102f9a:	85 f6                	test   %esi,%esi
  102f9c:	75 05                	jne    102fa3 <vprintfmt+0x1a3>
                p = "(null)";
  102f9e:	be 6d 3a 10 00       	mov    $0x103a6d,%esi
            }
            if (width > 0 && padc != '-') {
  102fa3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102fa7:	7e 76                	jle    10301f <vprintfmt+0x21f>
  102fa9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102fad:	74 70                	je     10301f <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102fb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fb6:	89 34 24             	mov    %esi,(%esp)
  102fb9:	e8 f6 f7 ff ff       	call   1027b4 <strnlen>
  102fbe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102fc1:	29 c2                	sub    %eax,%edx
  102fc3:	89 d0                	mov    %edx,%eax
  102fc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fc8:	eb 16                	jmp    102fe0 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  102fca:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102fce:	8b 55 0c             	mov    0xc(%ebp),%edx
  102fd1:	89 54 24 04          	mov    %edx,0x4(%esp)
  102fd5:	89 04 24             	mov    %eax,(%esp)
  102fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  102fdb:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  102fdd:	ff 4d e8             	decl   -0x18(%ebp)
  102fe0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102fe4:	7f e4                	jg     102fca <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102fe6:	eb 37                	jmp    10301f <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  102fe8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102fec:	74 1f                	je     10300d <vprintfmt+0x20d>
  102fee:	83 fb 1f             	cmp    $0x1f,%ebx
  102ff1:	7e 05                	jle    102ff8 <vprintfmt+0x1f8>
  102ff3:	83 fb 7e             	cmp    $0x7e,%ebx
  102ff6:	7e 15                	jle    10300d <vprintfmt+0x20d>
                    putch('?', putdat);
  102ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ffb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fff:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103006:	8b 45 08             	mov    0x8(%ebp),%eax
  103009:	ff d0                	call   *%eax
  10300b:	eb 0f                	jmp    10301c <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  10300d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103010:	89 44 24 04          	mov    %eax,0x4(%esp)
  103014:	89 1c 24             	mov    %ebx,(%esp)
  103017:	8b 45 08             	mov    0x8(%ebp),%eax
  10301a:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10301c:	ff 4d e8             	decl   -0x18(%ebp)
  10301f:	89 f0                	mov    %esi,%eax
  103021:	8d 70 01             	lea    0x1(%eax),%esi
  103024:	0f b6 00             	movzbl (%eax),%eax
  103027:	0f be d8             	movsbl %al,%ebx
  10302a:	85 db                	test   %ebx,%ebx
  10302c:	74 27                	je     103055 <vprintfmt+0x255>
  10302e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103032:	78 b4                	js     102fe8 <vprintfmt+0x1e8>
  103034:	ff 4d e4             	decl   -0x1c(%ebp)
  103037:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10303b:	79 ab                	jns    102fe8 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  10303d:	eb 16                	jmp    103055 <vprintfmt+0x255>
                putch(' ', putdat);
  10303f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103042:	89 44 24 04          	mov    %eax,0x4(%esp)
  103046:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10304d:	8b 45 08             	mov    0x8(%ebp),%eax
  103050:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103052:	ff 4d e8             	decl   -0x18(%ebp)
  103055:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103059:	7f e4                	jg     10303f <vprintfmt+0x23f>
            }
            break;
  10305b:	e9 6c 01 00 00       	jmp    1031cc <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103060:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103063:	89 44 24 04          	mov    %eax,0x4(%esp)
  103067:	8d 45 14             	lea    0x14(%ebp),%eax
  10306a:	89 04 24             	mov    %eax,(%esp)
  10306d:	e8 18 fd ff ff       	call   102d8a <getint>
  103072:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103075:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103078:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10307b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10307e:	85 d2                	test   %edx,%edx
  103080:	79 26                	jns    1030a8 <vprintfmt+0x2a8>
                putch('-', putdat);
  103082:	8b 45 0c             	mov    0xc(%ebp),%eax
  103085:	89 44 24 04          	mov    %eax,0x4(%esp)
  103089:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  103090:	8b 45 08             	mov    0x8(%ebp),%eax
  103093:	ff d0                	call   *%eax
                num = -(long long)num;
  103095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103098:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10309b:	f7 d8                	neg    %eax
  10309d:	83 d2 00             	adc    $0x0,%edx
  1030a0:	f7 da                	neg    %edx
  1030a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1030a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1030af:	e9 a8 00 00 00       	jmp    10315c <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1030b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030bb:	8d 45 14             	lea    0x14(%ebp),%eax
  1030be:	89 04 24             	mov    %eax,(%esp)
  1030c1:	e8 75 fc ff ff       	call   102d3b <getuint>
  1030c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1030cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1030d3:	e9 84 00 00 00       	jmp    10315c <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1030d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030df:	8d 45 14             	lea    0x14(%ebp),%eax
  1030e2:	89 04 24             	mov    %eax,(%esp)
  1030e5:	e8 51 fc ff ff       	call   102d3b <getuint>
  1030ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1030f0:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1030f7:	eb 63                	jmp    10315c <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  1030f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  103100:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103107:	8b 45 08             	mov    0x8(%ebp),%eax
  10310a:	ff d0                	call   *%eax
            putch('x', putdat);
  10310c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103113:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10311a:	8b 45 08             	mov    0x8(%ebp),%eax
  10311d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10311f:	8b 45 14             	mov    0x14(%ebp),%eax
  103122:	8d 50 04             	lea    0x4(%eax),%edx
  103125:	89 55 14             	mov    %edx,0x14(%ebp)
  103128:	8b 00                	mov    (%eax),%eax
  10312a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10312d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103134:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10313b:	eb 1f                	jmp    10315c <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10313d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103140:	89 44 24 04          	mov    %eax,0x4(%esp)
  103144:	8d 45 14             	lea    0x14(%ebp),%eax
  103147:	89 04 24             	mov    %eax,(%esp)
  10314a:	e8 ec fb ff ff       	call   102d3b <getuint>
  10314f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103152:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103155:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10315c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103160:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103163:	89 54 24 18          	mov    %edx,0x18(%esp)
  103167:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10316a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10316e:	89 44 24 10          	mov    %eax,0x10(%esp)
  103172:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103175:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103178:	89 44 24 08          	mov    %eax,0x8(%esp)
  10317c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103180:	8b 45 0c             	mov    0xc(%ebp),%eax
  103183:	89 44 24 04          	mov    %eax,0x4(%esp)
  103187:	8b 45 08             	mov    0x8(%ebp),%eax
  10318a:	89 04 24             	mov    %eax,(%esp)
  10318d:	e8 a4 fa ff ff       	call   102c36 <printnum>
            break;
  103192:	eb 38                	jmp    1031cc <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103194:	8b 45 0c             	mov    0xc(%ebp),%eax
  103197:	89 44 24 04          	mov    %eax,0x4(%esp)
  10319b:	89 1c 24             	mov    %ebx,(%esp)
  10319e:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a1:	ff d0                	call   *%eax
            break;
  1031a3:	eb 27                	jmp    1031cc <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1031a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031ac:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b6:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1031b8:	ff 4d 10             	decl   0x10(%ebp)
  1031bb:	eb 03                	jmp    1031c0 <vprintfmt+0x3c0>
  1031bd:	ff 4d 10             	decl   0x10(%ebp)
  1031c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1031c3:	48                   	dec    %eax
  1031c4:	0f b6 00             	movzbl (%eax),%eax
  1031c7:	3c 25                	cmp    $0x25,%al
  1031c9:	75 f2                	jne    1031bd <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  1031cb:	90                   	nop
    while (1) {
  1031cc:	e9 37 fc ff ff       	jmp    102e08 <vprintfmt+0x8>
                return;
  1031d1:	90                   	nop
        }
    }
}
  1031d2:	83 c4 40             	add    $0x40,%esp
  1031d5:	5b                   	pop    %ebx
  1031d6:	5e                   	pop    %esi
  1031d7:	5d                   	pop    %ebp
  1031d8:	c3                   	ret    

001031d9 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1031d9:	55                   	push   %ebp
  1031da:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1031dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031df:	8b 40 08             	mov    0x8(%eax),%eax
  1031e2:	8d 50 01             	lea    0x1(%eax),%edx
  1031e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e8:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1031eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ee:	8b 10                	mov    (%eax),%edx
  1031f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f3:	8b 40 04             	mov    0x4(%eax),%eax
  1031f6:	39 c2                	cmp    %eax,%edx
  1031f8:	73 12                	jae    10320c <sprintputch+0x33>
        *b->buf ++ = ch;
  1031fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031fd:	8b 00                	mov    (%eax),%eax
  1031ff:	8d 48 01             	lea    0x1(%eax),%ecx
  103202:	8b 55 0c             	mov    0xc(%ebp),%edx
  103205:	89 0a                	mov    %ecx,(%edx)
  103207:	8b 55 08             	mov    0x8(%ebp),%edx
  10320a:	88 10                	mov    %dl,(%eax)
    }
}
  10320c:	90                   	nop
  10320d:	5d                   	pop    %ebp
  10320e:	c3                   	ret    

0010320f <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10320f:	55                   	push   %ebp
  103210:	89 e5                	mov    %esp,%ebp
  103212:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103215:	8d 45 14             	lea    0x14(%ebp),%eax
  103218:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10321b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10321e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103222:	8b 45 10             	mov    0x10(%ebp),%eax
  103225:	89 44 24 08          	mov    %eax,0x8(%esp)
  103229:	8b 45 0c             	mov    0xc(%ebp),%eax
  10322c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103230:	8b 45 08             	mov    0x8(%ebp),%eax
  103233:	89 04 24             	mov    %eax,(%esp)
  103236:	e8 08 00 00 00       	call   103243 <vsnprintf>
  10323b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10323e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103241:	c9                   	leave  
  103242:	c3                   	ret    

00103243 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103243:	55                   	push   %ebp
  103244:	89 e5                	mov    %esp,%ebp
  103246:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103249:	8b 45 08             	mov    0x8(%ebp),%eax
  10324c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10324f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103252:	8d 50 ff             	lea    -0x1(%eax),%edx
  103255:	8b 45 08             	mov    0x8(%ebp),%eax
  103258:	01 d0                	add    %edx,%eax
  10325a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10325d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103264:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103268:	74 0a                	je     103274 <vsnprintf+0x31>
  10326a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10326d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103270:	39 c2                	cmp    %eax,%edx
  103272:	76 07                	jbe    10327b <vsnprintf+0x38>
        return -E_INVAL;
  103274:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103279:	eb 2a                	jmp    1032a5 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10327b:	8b 45 14             	mov    0x14(%ebp),%eax
  10327e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103282:	8b 45 10             	mov    0x10(%ebp),%eax
  103285:	89 44 24 08          	mov    %eax,0x8(%esp)
  103289:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10328c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103290:	c7 04 24 d9 31 10 00 	movl   $0x1031d9,(%esp)
  103297:	e8 64 fb ff ff       	call   102e00 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10329c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10329f:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1032a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1032a5:	c9                   	leave  
  1032a6:	c3                   	ret    
