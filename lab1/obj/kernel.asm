
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
  100027:	e8 ce 32 00 00       	call   1032fa <memset>

    cons_init();                // init the console
  10002c:	e8 44 15 00 00       	call   101575 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 a0 34 10 00 	movl   $0x1034a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 bc 34 10 00 	movl   $0x1034bc,(%esp)
  100046:	e8 cc 02 00 00       	call   100317 <cprintf>

    print_kerninfo();
  10004b:	e8 fb 07 00 00       	call   10084b <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 e6 28 00 00       	call   102940 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 59 16 00 00       	call   1016b8 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 ab 17 00 00       	call   10180f <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 ff 0c 00 00       	call   100d68 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 b8 15 00 00       	call   101626 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 62 01 00 00       	call   1001d5 <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 f2 0b 00 00       	call   100c89 <mon_backtrace>
}
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	55                   	push   %ebp
  10009a:	89 e5                	mov    %esp,%ebp
  10009c:	53                   	push   %ebx
  10009d:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a6:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b8:	89 04 24             	mov    %eax,(%esp)
  1000bb:	e8 b5 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c0:	83 c4 14             	add    $0x14,%esp
  1000c3:	5b                   	pop    %ebx
  1000c4:	5d                   	pop    %ebp
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 04 24             	mov    %eax,(%esp)
  1000d9:	e8 bb ff ff ff       	call   100099 <grade_backtrace1>
}
  1000de:	c9                   	leave  
  1000df:	c3                   	ret    

001000e0 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e0:	55                   	push   %ebp
  1000e1:	89 e5                	mov    %esp,%ebp
  1000e3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e6:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000eb:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f2:	ff 
  1000f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fe:	e8 c3 ff ff ff       	call   1000c6 <grade_backtrace0>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100111:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100114:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100117:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011b:	0f b7 c0             	movzwl %ax,%eax
  10011e:	83 e0 03             	and    $0x3,%eax
  100121:	89 c2                	mov    %eax,%edx
  100123:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100128:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 c1 34 10 00 	movl   $0x1034c1,(%esp)
  100137:	e8 db 01 00 00       	call   100317 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 cf 34 10 00 	movl   $0x1034cf,(%esp)
  100157:	e8 bb 01 00 00       	call   100317 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 dd 34 10 00 	movl   $0x1034dd,(%esp)
  100177:	e8 9b 01 00 00       	call   100317 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 eb 34 10 00 	movl   $0x1034eb,(%esp)
  100197:	e8 7b 01 00 00       	call   100317 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 f9 34 10 00 	movl   $0x1034f9,(%esp)
  1001b7:	e8 5b 01 00 00       	call   100317 <cprintf>
    round ++;
  1001bc:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c9:	c9                   	leave  
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001d3:	5d                   	pop    %ebp
  1001d4:	c3                   	ret    

001001d5 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d5:	55                   	push   %ebp
  1001d6:	89 e5                	mov    %esp,%ebp
  1001d8:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001db:	e8 25 ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e0:	c7 04 24 08 35 10 00 	movl   $0x103508,(%esp)
  1001e7:	e8 2b 01 00 00       	call   100317 <cprintf>
    lab1_switch_to_user();
  1001ec:	e8 da ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1001f1:	e8 0f ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f6:	c7 04 24 28 35 10 00 	movl   $0x103528,(%esp)
  1001fd:	e8 15 01 00 00       	call   100317 <cprintf>
    lab1_switch_to_kernel();
  100202:	e8 c9 ff ff ff       	call   1001d0 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100207:	e8 f9 fe ff ff       	call   100105 <lab1_print_cur_status>
}
  10020c:	c9                   	leave  
  10020d:	c3                   	ret    

0010020e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10020e:	55                   	push   %ebp
  10020f:	89 e5                	mov    %esp,%ebp
  100211:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100214:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100218:	74 13                	je     10022d <readline+0x1f>
        cprintf("%s", prompt);
  10021a:	8b 45 08             	mov    0x8(%ebp),%eax
  10021d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100221:	c7 04 24 47 35 10 00 	movl   $0x103547,(%esp)
  100228:	e8 ea 00 00 00       	call   100317 <cprintf>
    }
    int i = 0, c;
  10022d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100234:	e8 66 01 00 00       	call   10039f <getchar>
  100239:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10023c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100240:	79 07                	jns    100249 <readline+0x3b>
            return NULL;
  100242:	b8 00 00 00 00       	mov    $0x0,%eax
  100247:	eb 79                	jmp    1002c2 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100249:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10024d:	7e 28                	jle    100277 <readline+0x69>
  10024f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100256:	7f 1f                	jg     100277 <readline+0x69>
            cputchar(c);
  100258:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10025b:	89 04 24             	mov    %eax,(%esp)
  10025e:	e8 da 00 00 00       	call   10033d <cputchar>
            buf[i ++] = c;
  100263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100266:	8d 50 01             	lea    0x1(%eax),%edx
  100269:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10026c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026f:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100275:	eb 46                	jmp    1002bd <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100277:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10027b:	75 17                	jne    100294 <readline+0x86>
  10027d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100281:	7e 11                	jle    100294 <readline+0x86>
            cputchar(c);
  100283:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100286:	89 04 24             	mov    %eax,(%esp)
  100289:	e8 af 00 00 00       	call   10033d <cputchar>
            i --;
  10028e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100292:	eb 29                	jmp    1002bd <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  100294:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100298:	74 06                	je     1002a0 <readline+0x92>
  10029a:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10029e:	75 1d                	jne    1002bd <readline+0xaf>
            cputchar(c);
  1002a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a3:	89 04 24             	mov    %eax,(%esp)
  1002a6:	e8 92 00 00 00       	call   10033d <cputchar>
            buf[i] = '\0';
  1002ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002ae:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002b3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b6:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002bb:	eb 05                	jmp    1002c2 <readline+0xb4>
        }
    }
  1002bd:	e9 72 ff ff ff       	jmp    100234 <readline+0x26>
}
  1002c2:	c9                   	leave  
  1002c3:	c3                   	ret    

001002c4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002c4:	55                   	push   %ebp
  1002c5:	89 e5                	mov    %esp,%ebp
  1002c7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cd:	89 04 24             	mov    %eax,(%esp)
  1002d0:	e8 cc 12 00 00       	call   1015a1 <cons_putc>
    (*cnt) ++;
  1002d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d8:	8b 00                	mov    (%eax),%eax
  1002da:	8d 50 01             	lea    0x1(%eax),%edx
  1002dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e0:	89 10                	mov    %edx,(%eax)
}
  1002e2:	c9                   	leave  
  1002e3:	c3                   	ret    

001002e4 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002e4:	55                   	push   %ebp
  1002e5:	89 e5                	mov    %esp,%ebp
  1002e7:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100302:	89 44 24 04          	mov    %eax,0x4(%esp)
  100306:	c7 04 24 c4 02 10 00 	movl   $0x1002c4,(%esp)
  10030d:	e8 01 28 00 00       	call   102b13 <vprintfmt>
    return cnt;
  100312:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100315:	c9                   	leave  
  100316:	c3                   	ret    

00100317 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100317:	55                   	push   %ebp
  100318:	89 e5                	mov    %esp,%ebp
  10031a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10031d:	8d 45 0c             	lea    0xc(%ebp),%eax
  100320:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100326:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032a:	8b 45 08             	mov    0x8(%ebp),%eax
  10032d:	89 04 24             	mov    %eax,(%esp)
  100330:	e8 af ff ff ff       	call   1002e4 <vcprintf>
  100335:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100338:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033b:	c9                   	leave  
  10033c:	c3                   	ret    

0010033d <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10033d:	55                   	push   %ebp
  10033e:	89 e5                	mov    %esp,%ebp
  100340:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100343:	8b 45 08             	mov    0x8(%ebp),%eax
  100346:	89 04 24             	mov    %eax,(%esp)
  100349:	e8 53 12 00 00       	call   1015a1 <cons_putc>
}
  10034e:	c9                   	leave  
  10034f:	c3                   	ret    

00100350 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100350:	55                   	push   %ebp
  100351:	89 e5                	mov    %esp,%ebp
  100353:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100356:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10035d:	eb 13                	jmp    100372 <cputs+0x22>
        cputch(c, &cnt);
  10035f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100363:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100366:	89 54 24 04          	mov    %edx,0x4(%esp)
  10036a:	89 04 24             	mov    %eax,(%esp)
  10036d:	e8 52 ff ff ff       	call   1002c4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100372:	8b 45 08             	mov    0x8(%ebp),%eax
  100375:	8d 50 01             	lea    0x1(%eax),%edx
  100378:	89 55 08             	mov    %edx,0x8(%ebp)
  10037b:	0f b6 00             	movzbl (%eax),%eax
  10037e:	88 45 f7             	mov    %al,-0x9(%ebp)
  100381:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100385:	75 d8                	jne    10035f <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100387:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10038a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10038e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100395:	e8 2a ff ff ff       	call   1002c4 <cputch>
    return cnt;
  10039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10039d:	c9                   	leave  
  10039e:	c3                   	ret    

0010039f <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039f:	55                   	push   %ebp
  1003a0:	89 e5                	mov    %esp,%ebp
  1003a2:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a5:	e8 20 12 00 00       	call   1015ca <cons_getc>
  1003aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003b1:	74 f2                	je     1003a5 <getchar+0x6>
        /* do nothing */;
    return c;
  1003b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b6:	c9                   	leave  
  1003b7:	c3                   	ret    

001003b8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b8:	55                   	push   %ebp
  1003b9:	89 e5                	mov    %esp,%ebp
  1003bb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003c1:	8b 00                	mov    (%eax),%eax
  1003c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c9:	8b 00                	mov    (%eax),%eax
  1003cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d5:	e9 d2 00 00 00       	jmp    1004ac <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003e0:	01 d0                	add    %edx,%eax
  1003e2:	89 c2                	mov    %eax,%edx
  1003e4:	c1 ea 1f             	shr    $0x1f,%edx
  1003e7:	01 d0                	add    %edx,%eax
  1003e9:	d1 f8                	sar    %eax
  1003eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003f1:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f4:	eb 04                	jmp    1003fa <stab_binsearch+0x42>
            m --;
  1003f6:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100400:	7c 1f                	jl     100421 <stab_binsearch+0x69>
  100402:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100405:	89 d0                	mov    %edx,%eax
  100407:	01 c0                	add    %eax,%eax
  100409:	01 d0                	add    %edx,%eax
  10040b:	c1 e0 02             	shl    $0x2,%eax
  10040e:	89 c2                	mov    %eax,%edx
  100410:	8b 45 08             	mov    0x8(%ebp),%eax
  100413:	01 d0                	add    %edx,%eax
  100415:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100419:	0f b6 c0             	movzbl %al,%eax
  10041c:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041f:	75 d5                	jne    1003f6 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100421:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100424:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100427:	7d 0b                	jge    100434 <stab_binsearch+0x7c>
            l = true_m + 1;
  100429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10042c:	83 c0 01             	add    $0x1,%eax
  10042f:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100432:	eb 78                	jmp    1004ac <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100434:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10043b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10043e:	89 d0                	mov    %edx,%eax
  100440:	01 c0                	add    %eax,%eax
  100442:	01 d0                	add    %edx,%eax
  100444:	c1 e0 02             	shl    $0x2,%eax
  100447:	89 c2                	mov    %eax,%edx
  100449:	8b 45 08             	mov    0x8(%ebp),%eax
  10044c:	01 d0                	add    %edx,%eax
  10044e:	8b 40 08             	mov    0x8(%eax),%eax
  100451:	3b 45 18             	cmp    0x18(%ebp),%eax
  100454:	73 13                	jae    100469 <stab_binsearch+0xb1>
            *region_left = m;
  100456:	8b 45 0c             	mov    0xc(%ebp),%eax
  100459:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10045c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10045e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100461:	83 c0 01             	add    $0x1,%eax
  100464:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100467:	eb 43                	jmp    1004ac <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100469:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046c:	89 d0                	mov    %edx,%eax
  10046e:	01 c0                	add    %eax,%eax
  100470:	01 d0                	add    %edx,%eax
  100472:	c1 e0 02             	shl    $0x2,%eax
  100475:	89 c2                	mov    %eax,%edx
  100477:	8b 45 08             	mov    0x8(%ebp),%eax
  10047a:	01 d0                	add    %edx,%eax
  10047c:	8b 40 08             	mov    0x8(%eax),%eax
  10047f:	3b 45 18             	cmp    0x18(%ebp),%eax
  100482:	76 16                	jbe    10049a <stab_binsearch+0xe2>
            *region_right = m - 1;
  100484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100487:	8d 50 ff             	lea    -0x1(%eax),%edx
  10048a:	8b 45 10             	mov    0x10(%ebp),%eax
  10048d:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100492:	83 e8 01             	sub    $0x1,%eax
  100495:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100498:	eb 12                	jmp    1004ac <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10049a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004a0:	89 10                	mov    %edx,(%eax)
            l = m;
  1004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a8:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004af:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004b2:	0f 8e 22 ff ff ff    	jle    1003da <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004bc:	75 0f                	jne    1004cd <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c1:	8b 00                	mov    (%eax),%eax
  1004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c9:	89 10                	mov    %edx,(%eax)
  1004cb:	eb 3f                	jmp    10050c <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004cd:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d0:	8b 00                	mov    (%eax),%eax
  1004d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d5:	eb 04                	jmp    1004db <stab_binsearch+0x123>
  1004d7:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004de:	8b 00                	mov    (%eax),%eax
  1004e0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e3:	7d 1f                	jge    100504 <stab_binsearch+0x14c>
  1004e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e8:	89 d0                	mov    %edx,%eax
  1004ea:	01 c0                	add    %eax,%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	c1 e0 02             	shl    $0x2,%eax
  1004f1:	89 c2                	mov    %eax,%edx
  1004f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f6:	01 d0                	add    %edx,%eax
  1004f8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004fc:	0f b6 c0             	movzbl %al,%eax
  1004ff:	3b 45 14             	cmp    0x14(%ebp),%eax
  100502:	75 d3                	jne    1004d7 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100504:	8b 45 0c             	mov    0xc(%ebp),%eax
  100507:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050a:	89 10                	mov    %edx,(%eax)
    }
}
  10050c:	c9                   	leave  
  10050d:	c3                   	ret    

0010050e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10050e:	55                   	push   %ebp
  10050f:	89 e5                	mov    %esp,%ebp
  100511:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100514:	8b 45 0c             	mov    0xc(%ebp),%eax
  100517:	c7 00 4c 35 10 00    	movl   $0x10354c,(%eax)
    info->eip_line = 0;
  10051d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100520:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100527:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052a:	c7 40 08 4c 35 10 00 	movl   $0x10354c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100531:	8b 45 0c             	mov    0xc(%ebp),%eax
  100534:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10053b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053e:	8b 55 08             	mov    0x8(%ebp),%edx
  100541:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100544:	8b 45 0c             	mov    0xc(%ebp),%eax
  100547:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10054e:	c7 45 f4 ac 3d 10 00 	movl   $0x103dac,-0xc(%ebp)
    stab_end = __STAB_END__;
  100555:	c7 45 f0 d4 b4 10 00 	movl   $0x10b4d4,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10055c:	c7 45 ec d5 b4 10 00 	movl   $0x10b4d5,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100563:	c7 45 e8 ad d4 10 00 	movl   $0x10d4ad,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10056a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10056d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100570:	76 0d                	jbe    10057f <debuginfo_eip+0x71>
  100572:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100575:	83 e8 01             	sub    $0x1,%eax
  100578:	0f b6 00             	movzbl (%eax),%eax
  10057b:	84 c0                	test   %al,%al
  10057d:	74 0a                	je     100589 <debuginfo_eip+0x7b>
        return -1;
  10057f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100584:	e9 c0 02 00 00       	jmp    100849 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100589:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100590:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100596:	29 c2                	sub    %eax,%edx
  100598:	89 d0                	mov    %edx,%eax
  10059a:	c1 f8 02             	sar    $0x2,%eax
  10059d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005a3:	83 e8 01             	sub    $0x1,%eax
  1005a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005b0:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b7:	00 
  1005b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c9:	89 04 24             	mov    %eax,(%esp)
  1005cc:	e8 e7 fd ff ff       	call   1003b8 <stab_binsearch>
    if (lfile == 0)
  1005d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005d4:	85 c0                	test   %eax,%eax
  1005d6:	75 0a                	jne    1005e2 <debuginfo_eip+0xd4>
        return -1;
  1005d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005dd:	e9 67 02 00 00       	jmp    100849 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1005f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f5:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005fc:	00 
  1005fd:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100600:	89 44 24 08          	mov    %eax,0x8(%esp)
  100604:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100607:	89 44 24 04          	mov    %eax,0x4(%esp)
  10060b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10060e:	89 04 24             	mov    %eax,(%esp)
  100611:	e8 a2 fd ff ff       	call   1003b8 <stab_binsearch>

    if (lfun <= rfun) {
  100616:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100619:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10061c:	39 c2                	cmp    %eax,%edx
  10061e:	7f 7c                	jg     10069c <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100620:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100623:	89 c2                	mov    %eax,%edx
  100625:	89 d0                	mov    %edx,%eax
  100627:	01 c0                	add    %eax,%eax
  100629:	01 d0                	add    %edx,%eax
  10062b:	c1 e0 02             	shl    $0x2,%eax
  10062e:	89 c2                	mov    %eax,%edx
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	01 d0                	add    %edx,%eax
  100635:	8b 10                	mov    (%eax),%edx
  100637:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10063a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10063d:	29 c1                	sub    %eax,%ecx
  10063f:	89 c8                	mov    %ecx,%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	73 22                	jae    100667 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065f:	01 c2                	add    %eax,%edx
  100661:	8b 45 0c             	mov    0xc(%ebp),%eax
  100664:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100667:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066a:	89 c2                	mov    %eax,%edx
  10066c:	89 d0                	mov    %edx,%eax
  10066e:	01 c0                	add    %eax,%eax
  100670:	01 d0                	add    %edx,%eax
  100672:	c1 e0 02             	shl    $0x2,%eax
  100675:	89 c2                	mov    %eax,%edx
  100677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067a:	01 d0                	add    %edx,%eax
  10067c:	8b 50 08             	mov    0x8(%eax),%edx
  10067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100682:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100685:	8b 45 0c             	mov    0xc(%ebp),%eax
  100688:	8b 40 10             	mov    0x10(%eax),%eax
  10068b:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10068e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100691:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100694:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100697:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10069a:	eb 15                	jmp    1006b1 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069f:	8b 55 08             	mov    0x8(%ebp),%edx
  1006a2:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b4:	8b 40 08             	mov    0x8(%eax),%eax
  1006b7:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006be:	00 
  1006bf:	89 04 24             	mov    %eax,(%esp)
  1006c2:	e8 a7 2a 00 00       	call   10316e <strfind>
  1006c7:	89 c2                	mov    %eax,%edx
  1006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cc:	8b 40 08             	mov    0x8(%eax),%eax
  1006cf:	29 c2                	sub    %eax,%edx
  1006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d4:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1006da:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006de:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e5:	00 
  1006e6:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006ed:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f7:	89 04 24             	mov    %eax,(%esp)
  1006fa:	e8 b9 fc ff ff       	call   1003b8 <stab_binsearch>
    if (lline <= rline) {
  1006ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100702:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100705:	39 c2                	cmp    %eax,%edx
  100707:	7f 24                	jg     10072d <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100709:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10070c:	89 c2                	mov    %eax,%edx
  10070e:	89 d0                	mov    %edx,%eax
  100710:	01 c0                	add    %eax,%eax
  100712:	01 d0                	add    %edx,%eax
  100714:	c1 e0 02             	shl    $0x2,%eax
  100717:	89 c2                	mov    %eax,%edx
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	01 d0                	add    %edx,%eax
  10071e:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100722:	0f b7 d0             	movzwl %ax,%edx
  100725:	8b 45 0c             	mov    0xc(%ebp),%eax
  100728:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10072b:	eb 13                	jmp    100740 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10072d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100732:	e9 12 01 00 00       	jmp    100849 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100737:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10073a:	83 e8 01             	sub    $0x1,%eax
  10073d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100740:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100746:	39 c2                	cmp    %eax,%edx
  100748:	7c 56                	jl     1007a0 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10074a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10074d:	89 c2                	mov    %eax,%edx
  10074f:	89 d0                	mov    %edx,%eax
  100751:	01 c0                	add    %eax,%eax
  100753:	01 d0                	add    %edx,%eax
  100755:	c1 e0 02             	shl    $0x2,%eax
  100758:	89 c2                	mov    %eax,%edx
  10075a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10075d:	01 d0                	add    %edx,%eax
  10075f:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100763:	3c 84                	cmp    $0x84,%al
  100765:	74 39                	je     1007a0 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	89 d0                	mov    %edx,%eax
  10076e:	01 c0                	add    %eax,%eax
  100770:	01 d0                	add    %edx,%eax
  100772:	c1 e0 02             	shl    $0x2,%eax
  100775:	89 c2                	mov    %eax,%edx
  100777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10077a:	01 d0                	add    %edx,%eax
  10077c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100780:	3c 64                	cmp    $0x64,%al
  100782:	75 b3                	jne    100737 <debuginfo_eip+0x229>
  100784:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100787:	89 c2                	mov    %eax,%edx
  100789:	89 d0                	mov    %edx,%eax
  10078b:	01 c0                	add    %eax,%eax
  10078d:	01 d0                	add    %edx,%eax
  10078f:	c1 e0 02             	shl    $0x2,%eax
  100792:	89 c2                	mov    %eax,%edx
  100794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100797:	01 d0                	add    %edx,%eax
  100799:	8b 40 08             	mov    0x8(%eax),%eax
  10079c:	85 c0                	test   %eax,%eax
  10079e:	74 97                	je     100737 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a6:	39 c2                	cmp    %eax,%edx
  1007a8:	7c 46                	jl     1007f0 <debuginfo_eip+0x2e2>
  1007aa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ad:	89 c2                	mov    %eax,%edx
  1007af:	89 d0                	mov    %edx,%eax
  1007b1:	01 c0                	add    %eax,%eax
  1007b3:	01 d0                	add    %edx,%eax
  1007b5:	c1 e0 02             	shl    $0x2,%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bd:	01 d0                	add    %edx,%eax
  1007bf:	8b 10                	mov    (%eax),%edx
  1007c1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c7:	29 c1                	sub    %eax,%ecx
  1007c9:	89 c8                	mov    %ecx,%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	73 21                	jae    1007f0 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e9:	01 c2                	add    %eax,%edx
  1007eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ee:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f6:	39 c2                	cmp    %eax,%edx
  1007f8:	7d 4a                	jge    100844 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007fd:	83 c0 01             	add    $0x1,%eax
  100800:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100803:	eb 18                	jmp    10081d <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100805:	8b 45 0c             	mov    0xc(%ebp),%eax
  100808:	8b 40 14             	mov    0x14(%eax),%eax
  10080b:	8d 50 01             	lea    0x1(%eax),%edx
  10080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100811:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100814:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100817:	83 c0 01             	add    $0x1,%eax
  10081a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10081d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100820:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100823:	39 c2                	cmp    %eax,%edx
  100825:	7d 1d                	jge    100844 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100827:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082a:	89 c2                	mov    %eax,%edx
  10082c:	89 d0                	mov    %edx,%eax
  10082e:	01 c0                	add    %eax,%eax
  100830:	01 d0                	add    %edx,%eax
  100832:	c1 e0 02             	shl    $0x2,%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10083a:	01 d0                	add    %edx,%eax
  10083c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100840:	3c a0                	cmp    $0xa0,%al
  100842:	74 c1                	je     100805 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100849:	c9                   	leave  
  10084a:	c3                   	ret    

0010084b <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10084b:	55                   	push   %ebp
  10084c:	89 e5                	mov    %esp,%ebp
  10084e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100851:	c7 04 24 56 35 10 00 	movl   $0x103556,(%esp)
  100858:	e8 ba fa ff ff       	call   100317 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10085d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100864:	00 
  100865:	c7 04 24 6f 35 10 00 	movl   $0x10356f,(%esp)
  10086c:	e8 a6 fa ff ff       	call   100317 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100871:	c7 44 24 04 83 34 10 	movl   $0x103483,0x4(%esp)
  100878:	00 
  100879:	c7 04 24 87 35 10 00 	movl   $0x103587,(%esp)
  100880:	e8 92 fa ff ff       	call   100317 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100885:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  10088c:	00 
  10088d:	c7 04 24 9f 35 10 00 	movl   $0x10359f,(%esp)
  100894:	e8 7e fa ff ff       	call   100317 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100899:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  1008a0:	00 
  1008a1:	c7 04 24 b7 35 10 00 	movl   $0x1035b7,(%esp)
  1008a8:	e8 6a fa ff ff       	call   100317 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008ad:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008b2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b8:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008bd:	29 c2                	sub    %eax,%edx
  1008bf:	89 d0                	mov    %edx,%eax
  1008c1:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c7:	85 c0                	test   %eax,%eax
  1008c9:	0f 48 c2             	cmovs  %edx,%eax
  1008cc:	c1 f8 0a             	sar    $0xa,%eax
  1008cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008d3:	c7 04 24 d0 35 10 00 	movl   $0x1035d0,(%esp)
  1008da:	e8 38 fa ff ff       	call   100317 <cprintf>
}
  1008df:	c9                   	leave  
  1008e0:	c3                   	ret    

001008e1 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008e1:	55                   	push   %ebp
  1008e2:	89 e5                	mov    %esp,%ebp
  1008e4:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008ea:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1008f4:	89 04 24             	mov    %eax,(%esp)
  1008f7:	e8 12 fc ff ff       	call   10050e <debuginfo_eip>
  1008fc:	85 c0                	test   %eax,%eax
  1008fe:	74 15                	je     100915 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100900:	8b 45 08             	mov    0x8(%ebp),%eax
  100903:	89 44 24 04          	mov    %eax,0x4(%esp)
  100907:	c7 04 24 fa 35 10 00 	movl   $0x1035fa,(%esp)
  10090e:	e8 04 fa ff ff       	call   100317 <cprintf>
  100913:	eb 6d                	jmp    100982 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100915:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10091c:	eb 1c                	jmp    10093a <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10091e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100924:	01 d0                	add    %edx,%eax
  100926:	0f b6 00             	movzbl (%eax),%eax
  100929:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100932:	01 ca                	add    %ecx,%edx
  100934:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100936:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10093a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10093d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100940:	7f dc                	jg     10091e <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100942:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10094b:	01 d0                	add    %edx,%eax
  10094d:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100950:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100953:	8b 55 08             	mov    0x8(%ebp),%edx
  100956:	89 d1                	mov    %edx,%ecx
  100958:	29 c1                	sub    %eax,%ecx
  10095a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10095d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100960:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100964:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10096a:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10096e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100972:	89 44 24 04          	mov    %eax,0x4(%esp)
  100976:	c7 04 24 16 36 10 00 	movl   $0x103616,(%esp)
  10097d:	e8 95 f9 ff ff       	call   100317 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  100982:	c9                   	leave  
  100983:	c3                   	ret    

00100984 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100984:	55                   	push   %ebp
  100985:	89 e5                	mov    %esp,%ebp
  100987:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  10098a:	8b 45 04             	mov    0x4(%ebp),%eax
  10098d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100990:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100993:	c9                   	leave  
  100994:	c3                   	ret    

00100995 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100995:	55                   	push   %ebp
  100996:	89 e5                	mov    %esp,%ebp
  100998:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  10099b:	89 e8                	mov    %ebp,%eax
  10099d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp();
  1009a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip = read_eip();//读取ebp和eip
  1009a6:	e8 d9 ff ff ff       	call   100984 <read_eip>
  1009ab:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b5:	e9 82 00 00 00       	jmp    100a3c <print_stackframe+0xa7>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);//显示8位16进制数(32位二进制数)
  1009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c8:	c7 04 24 28 36 10 00 	movl   $0x103628,(%esp)
  1009cf:	e8 43 f9 ff ff       	call   100317 <cprintf>
        for (j = 0; j < 4; j ++) {
  1009d4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009db:	eb 28                	jmp    100a05 <print_stackframe+0x70>
            cprintf("0x%08x ", ((uint32_t*)ebp + 2)[j]);//输出参数(4个32位二进制数)，参数的地址比ebp的地址高两位
  1009dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ea:	01 d0                	add    %edx,%eax
  1009ec:	83 c0 08             	add    $0x8,%eax
  1009ef:	8b 00                	mov    (%eax),%eax
  1009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f5:	c7 04 24 44 36 10 00 	movl   $0x103644,(%esp)
  1009fc:	e8 16 f9 ff ff       	call   100317 <cprintf>
     uint32_t eip = read_eip();//读取ebp和eip

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);//显示8位16进制数(32位二进制数)
        for (j = 0; j < 4; j ++) {
  100a01:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a05:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a09:	7e d2                	jle    1009dd <print_stackframe+0x48>
            cprintf("0x%08x ", ((uint32_t*)ebp + 2)[j]);//输出参数(4个32位二进制数)，参数的地址比ebp的地址高两位
        }
        cprintf("\n");
  100a0b:	c7 04 24 4c 36 10 00 	movl   $0x10364c,(%esp)
  100a12:	e8 00 f9 ff ff       	call   100317 <cprintf>
        print_debuginfo(eip - 1);//打印前一条指令的信息
  100a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a1a:	83 e8 01             	sub    $0x1,%eax
  100a1d:	89 04 24             	mov    %eax,(%esp)
  100a20:	e8 bc fe ff ff       	call   1008e1 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];//eip比ebp的地址高一位
  100a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a28:	83 c0 04             	add    $0x4,%eax
  100a2b:	8b 00                	mov    (%eax),%eax
  100a2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];//取出上一层函数的ebp
  100a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a33:	8b 00                	mov    (%eax),%eax
  100a35:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */
     uint32_t ebp = read_ebp();
     uint32_t eip = read_eip();//读取ebp和eip

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a38:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a40:	74 0a                	je     100a4c <print_stackframe+0xb7>
  100a42:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a46:	0f 8e 6e ff ff ff    	jle    1009ba <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);//打印前一条指令的信息
        eip = ((uint32_t *)ebp)[1];//eip比ebp的地址高一位
        ebp = ((uint32_t *)ebp)[0];//取出上一层函数的ebp
    }
}
  100a4c:	c9                   	leave  
  100a4d:	c3                   	ret    

00100a4e <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a4e:	55                   	push   %ebp
  100a4f:	89 e5                	mov    %esp,%ebp
  100a51:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a5b:	eb 0c                	jmp    100a69 <parse+0x1b>
            *buf ++ = '\0';
  100a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a60:	8d 50 01             	lea    0x1(%eax),%edx
  100a63:	89 55 08             	mov    %edx,0x8(%ebp)
  100a66:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a69:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6c:	0f b6 00             	movzbl (%eax),%eax
  100a6f:	84 c0                	test   %al,%al
  100a71:	74 1d                	je     100a90 <parse+0x42>
  100a73:	8b 45 08             	mov    0x8(%ebp),%eax
  100a76:	0f b6 00             	movzbl (%eax),%eax
  100a79:	0f be c0             	movsbl %al,%eax
  100a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a80:	c7 04 24 d0 36 10 00 	movl   $0x1036d0,(%esp)
  100a87:	e8 af 26 00 00       	call   10313b <strchr>
  100a8c:	85 c0                	test   %eax,%eax
  100a8e:	75 cd                	jne    100a5d <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a90:	8b 45 08             	mov    0x8(%ebp),%eax
  100a93:	0f b6 00             	movzbl (%eax),%eax
  100a96:	84 c0                	test   %al,%al
  100a98:	75 02                	jne    100a9c <parse+0x4e>
            break;
  100a9a:	eb 67                	jmp    100b03 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a9c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aa0:	75 14                	jne    100ab6 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aa2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100aa9:	00 
  100aaa:	c7 04 24 d5 36 10 00 	movl   $0x1036d5,(%esp)
  100ab1:	e8 61 f8 ff ff       	call   100317 <cprintf>
        }
        argv[argc ++] = buf;
  100ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab9:	8d 50 01             	lea    0x1(%eax),%edx
  100abc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100abf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ac9:	01 c2                	add    %eax,%edx
  100acb:	8b 45 08             	mov    0x8(%ebp),%eax
  100ace:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad0:	eb 04                	jmp    100ad6 <parse+0x88>
            buf ++;
  100ad2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad9:	0f b6 00             	movzbl (%eax),%eax
  100adc:	84 c0                	test   %al,%al
  100ade:	74 1d                	je     100afd <parse+0xaf>
  100ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae3:	0f b6 00             	movzbl (%eax),%eax
  100ae6:	0f be c0             	movsbl %al,%eax
  100ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aed:	c7 04 24 d0 36 10 00 	movl   $0x1036d0,(%esp)
  100af4:	e8 42 26 00 00       	call   10313b <strchr>
  100af9:	85 c0                	test   %eax,%eax
  100afb:	74 d5                	je     100ad2 <parse+0x84>
            buf ++;
        }
    }
  100afd:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100afe:	e9 66 ff ff ff       	jmp    100a69 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b06:	c9                   	leave  
  100b07:	c3                   	ret    

00100b08 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b08:	55                   	push   %ebp
  100b09:	89 e5                	mov    %esp,%ebp
  100b0b:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b0e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b15:	8b 45 08             	mov    0x8(%ebp),%eax
  100b18:	89 04 24             	mov    %eax,(%esp)
  100b1b:	e8 2e ff ff ff       	call   100a4e <parse>
  100b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b27:	75 0a                	jne    100b33 <runcmd+0x2b>
        return 0;
  100b29:	b8 00 00 00 00       	mov    $0x0,%eax
  100b2e:	e9 85 00 00 00       	jmp    100bb8 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b3a:	eb 5c                	jmp    100b98 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b3c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b42:	89 d0                	mov    %edx,%eax
  100b44:	01 c0                	add    %eax,%eax
  100b46:	01 d0                	add    %edx,%eax
  100b48:	c1 e0 02             	shl    $0x2,%eax
  100b4b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b50:	8b 00                	mov    (%eax),%eax
  100b52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b56:	89 04 24             	mov    %eax,(%esp)
  100b59:	e8 3e 25 00 00       	call   10309c <strcmp>
  100b5e:	85 c0                	test   %eax,%eax
  100b60:	75 32                	jne    100b94 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b65:	89 d0                	mov    %edx,%eax
  100b67:	01 c0                	add    %eax,%eax
  100b69:	01 d0                	add    %edx,%eax
  100b6b:	c1 e0 02             	shl    $0x2,%eax
  100b6e:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b73:	8b 40 08             	mov    0x8(%eax),%eax
  100b76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b79:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b7f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b83:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b86:	83 c2 04             	add    $0x4,%edx
  100b89:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b8d:	89 0c 24             	mov    %ecx,(%esp)
  100b90:	ff d0                	call   *%eax
  100b92:	eb 24                	jmp    100bb8 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b9b:	83 f8 02             	cmp    $0x2,%eax
  100b9e:	76 9c                	jbe    100b3c <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ba0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ba7:	c7 04 24 f3 36 10 00 	movl   $0x1036f3,(%esp)
  100bae:	e8 64 f7 ff ff       	call   100317 <cprintf>
    return 0;
  100bb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bb8:	c9                   	leave  
  100bb9:	c3                   	ret    

00100bba <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bba:	55                   	push   %ebp
  100bbb:	89 e5                	mov    %esp,%ebp
  100bbd:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bc0:	c7 04 24 0c 37 10 00 	movl   $0x10370c,(%esp)
  100bc7:	e8 4b f7 ff ff       	call   100317 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bcc:	c7 04 24 34 37 10 00 	movl   $0x103734,(%esp)
  100bd3:	e8 3f f7 ff ff       	call   100317 <cprintf>

    if (tf != NULL) {
  100bd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bdc:	74 0b                	je     100be9 <kmonitor+0x2f>
        print_trapframe(tf);
  100bde:	8b 45 08             	mov    0x8(%ebp),%eax
  100be1:	89 04 24             	mov    %eax,(%esp)
  100be4:	e8 de 0d 00 00       	call   1019c7 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100be9:	c7 04 24 59 37 10 00 	movl   $0x103759,(%esp)
  100bf0:	e8 19 f6 ff ff       	call   10020e <readline>
  100bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100bfc:	74 18                	je     100c16 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  100c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c08:	89 04 24             	mov    %eax,(%esp)
  100c0b:	e8 f8 fe ff ff       	call   100b08 <runcmd>
  100c10:	85 c0                	test   %eax,%eax
  100c12:	79 02                	jns    100c16 <kmonitor+0x5c>
                break;
  100c14:	eb 02                	jmp    100c18 <kmonitor+0x5e>
            }
        }
    }
  100c16:	eb d1                	jmp    100be9 <kmonitor+0x2f>
}
  100c18:	c9                   	leave  
  100c19:	c3                   	ret    

00100c1a <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c1a:	55                   	push   %ebp
  100c1b:	89 e5                	mov    %esp,%ebp
  100c1d:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c27:	eb 3f                	jmp    100c68 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c29:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2c:	89 d0                	mov    %edx,%eax
  100c2e:	01 c0                	add    %eax,%eax
  100c30:	01 d0                	add    %edx,%eax
  100c32:	c1 e0 02             	shl    $0x2,%eax
  100c35:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c3a:	8b 48 04             	mov    0x4(%eax),%ecx
  100c3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c40:	89 d0                	mov    %edx,%eax
  100c42:	01 c0                	add    %eax,%eax
  100c44:	01 d0                	add    %edx,%eax
  100c46:	c1 e0 02             	shl    $0x2,%eax
  100c49:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c4e:	8b 00                	mov    (%eax),%eax
  100c50:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c54:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c58:	c7 04 24 5d 37 10 00 	movl   $0x10375d,(%esp)
  100c5f:	e8 b3 f6 ff ff       	call   100317 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6b:	83 f8 02             	cmp    $0x2,%eax
  100c6e:	76 b9                	jbe    100c29 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c75:	c9                   	leave  
  100c76:	c3                   	ret    

00100c77 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c77:	55                   	push   %ebp
  100c78:	89 e5                	mov    %esp,%ebp
  100c7a:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c7d:	e8 c9 fb ff ff       	call   10084b <print_kerninfo>
    return 0;
  100c82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c87:	c9                   	leave  
  100c88:	c3                   	ret    

00100c89 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c89:	55                   	push   %ebp
  100c8a:	89 e5                	mov    %esp,%ebp
  100c8c:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c8f:	e8 01 fd ff ff       	call   100995 <print_stackframe>
    return 0;
  100c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c99:	c9                   	leave  
  100c9a:	c3                   	ret    

00100c9b <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c9b:	55                   	push   %ebp
  100c9c:	89 e5                	mov    %esp,%ebp
  100c9e:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ca1:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100ca6:	85 c0                	test   %eax,%eax
  100ca8:	74 02                	je     100cac <__panic+0x11>
        goto panic_dead;
  100caa:	eb 59                	jmp    100d05 <__panic+0x6a>
    }
    is_panic = 1;
  100cac:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cb3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cb6:	8d 45 14             	lea    0x14(%ebp),%eax
  100cb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cca:	c7 04 24 66 37 10 00 	movl   $0x103766,(%esp)
  100cd1:	e8 41 f6 ff ff       	call   100317 <cprintf>
    vcprintf(fmt, ap);
  100cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cdd:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce0:	89 04 24             	mov    %eax,(%esp)
  100ce3:	e8 fc f5 ff ff       	call   1002e4 <vcprintf>
    cprintf("\n");
  100ce8:	c7 04 24 82 37 10 00 	movl   $0x103782,(%esp)
  100cef:	e8 23 f6 ff ff       	call   100317 <cprintf>
    
    cprintf("stack trackback:\n");
  100cf4:	c7 04 24 84 37 10 00 	movl   $0x103784,(%esp)
  100cfb:	e8 17 f6 ff ff       	call   100317 <cprintf>
    print_stackframe();
  100d00:	e8 90 fc ff ff       	call   100995 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d05:	e8 22 09 00 00       	call   10162c <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d0a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d11:	e8 a4 fe ff ff       	call   100bba <kmonitor>
    }
  100d16:	eb f2                	jmp    100d0a <__panic+0x6f>

00100d18 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d18:	55                   	push   %ebp
  100d19:	89 e5                	mov    %esp,%ebp
  100d1b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d1e:	8d 45 14             	lea    0x14(%ebp),%eax
  100d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d27:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d32:	c7 04 24 96 37 10 00 	movl   $0x103796,(%esp)
  100d39:	e8 d9 f5 ff ff       	call   100317 <cprintf>
    vcprintf(fmt, ap);
  100d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d45:	8b 45 10             	mov    0x10(%ebp),%eax
  100d48:	89 04 24             	mov    %eax,(%esp)
  100d4b:	e8 94 f5 ff ff       	call   1002e4 <vcprintf>
    cprintf("\n");
  100d50:	c7 04 24 82 37 10 00 	movl   $0x103782,(%esp)
  100d57:	e8 bb f5 ff ff       	call   100317 <cprintf>
    va_end(ap);
}
  100d5c:	c9                   	leave  
  100d5d:	c3                   	ret    

00100d5e <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d5e:	55                   	push   %ebp
  100d5f:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d61:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d66:	5d                   	pop    %ebp
  100d67:	c3                   	ret    

00100d68 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d68:	55                   	push   %ebp
  100d69:	89 e5                	mov    %esp,%ebp
  100d6b:	83 ec 28             	sub    $0x28,%esp
  100d6e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d74:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d78:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d7c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d80:	ee                   	out    %al,(%dx)
  100d81:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d87:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d8b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d8f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d93:	ee                   	out    %al,(%dx)
  100d94:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d9a:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d9e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100da6:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da7:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100dae:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db1:	c7 04 24 b4 37 10 00 	movl   $0x1037b4,(%esp)
  100db8:	e8 5a f5 ff ff       	call   100317 <cprintf>
    pic_enable(IRQ_TIMER);
  100dbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dc4:	e8 c1 08 00 00       	call   10168a <pic_enable>
}
  100dc9:	c9                   	leave  
  100dca:	c3                   	ret    

00100dcb <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dcb:	55                   	push   %ebp
  100dcc:	89 e5                	mov    %esp,%ebp
  100dce:	83 ec 10             	sub    $0x10,%esp
  100dd1:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dd7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ddb:	89 c2                	mov    %eax,%edx
  100ddd:	ec                   	in     (%dx),%al
  100dde:	88 45 fd             	mov    %al,-0x3(%ebp)
  100de1:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de7:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100deb:	89 c2                	mov    %eax,%edx
  100ded:	ec                   	in     (%dx),%al
  100dee:	88 45 f9             	mov    %al,-0x7(%ebp)
  100df1:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100df7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dfb:	89 c2                	mov    %eax,%edx
  100dfd:	ec                   	in     (%dx),%al
  100dfe:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e01:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e07:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e0b:	89 c2                	mov    %eax,%edx
  100e0d:	ec                   	in     (%dx),%al
  100e0e:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e11:	c9                   	leave  
  100e12:	c3                   	ret    

00100e13 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e13:	55                   	push   %ebp
  100e14:	89 e5                	mov    %esp,%ebp
  100e16:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e19:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e23:	0f b7 00             	movzwl (%eax),%eax
  100e26:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e35:	0f b7 00             	movzwl (%eax),%eax
  100e38:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e3c:	74 12                	je     100e50 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e3e:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e45:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e4c:	b4 03 
  100e4e:	eb 13                	jmp    100e63 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e50:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e53:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e57:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e5a:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e61:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e63:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e6a:	0f b7 c0             	movzwl %ax,%eax
  100e6d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e71:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e75:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e79:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e7d:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e7e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e85:	83 c0 01             	add    $0x1,%eax
  100e88:	0f b7 c0             	movzwl %ax,%eax
  100e8b:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e8f:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e93:	89 c2                	mov    %eax,%edx
  100e95:	ec                   	in     (%dx),%al
  100e96:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e9d:	0f b6 c0             	movzbl %al,%eax
  100ea0:	c1 e0 08             	shl    $0x8,%eax
  100ea3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ea6:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ead:	0f b7 c0             	movzwl %ax,%eax
  100eb0:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100eb4:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eb8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ebc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ec0:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ec1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ec8:	83 c0 01             	add    $0x1,%eax
  100ecb:	0f b7 c0             	movzwl %ax,%eax
  100ece:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ed2:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ed6:	89 c2                	mov    %eax,%edx
  100ed8:	ec                   	in     (%dx),%al
  100ed9:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100edc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee0:	0f b6 c0             	movzbl %al,%eax
  100ee3:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ee6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee9:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ef1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ef7:	c9                   	leave  
  100ef8:	c3                   	ret    

00100ef9 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ef9:	55                   	push   %ebp
  100efa:	89 e5                	mov    %esp,%ebp
  100efc:	83 ec 48             	sub    $0x48,%esp
  100eff:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f05:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f09:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f0d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f11:	ee                   	out    %al,(%dx)
  100f12:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f18:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f1c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f20:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f24:	ee                   	out    %al,(%dx)
  100f25:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f2b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f2f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f33:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f37:	ee                   	out    %al,(%dx)
  100f38:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f3e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f42:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f46:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f4a:	ee                   	out    %al,(%dx)
  100f4b:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f51:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f55:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f59:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5d:	ee                   	out    %al,(%dx)
  100f5e:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f64:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f68:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f6c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f70:	ee                   	out    %al,(%dx)
  100f71:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f77:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f7b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f7f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f83:	ee                   	out    %al,(%dx)
  100f84:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8a:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f8e:	89 c2                	mov    %eax,%edx
  100f90:	ec                   	in     (%dx),%al
  100f91:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f94:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f98:	3c ff                	cmp    $0xff,%al
  100f9a:	0f 95 c0             	setne  %al
  100f9d:	0f b6 c0             	movzbl %al,%eax
  100fa0:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fa5:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fab:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100faf:	89 c2                	mov    %eax,%edx
  100fb1:	ec                   	in     (%dx),%al
  100fb2:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fb5:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fbb:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fbf:	89 c2                	mov    %eax,%edx
  100fc1:	ec                   	in     (%dx),%al
  100fc2:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fc5:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fca:	85 c0                	test   %eax,%eax
  100fcc:	74 0c                	je     100fda <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fce:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fd5:	e8 b0 06 00 00       	call   10168a <pic_enable>
    }
}
  100fda:	c9                   	leave  
  100fdb:	c3                   	ret    

00100fdc <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fdc:	55                   	push   %ebp
  100fdd:	89 e5                	mov    %esp,%ebp
  100fdf:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fe9:	eb 09                	jmp    100ff4 <lpt_putc_sub+0x18>
        delay();
  100feb:	e8 db fd ff ff       	call   100dcb <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ff4:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ffa:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ffe:	89 c2                	mov    %eax,%edx
  101000:	ec                   	in     (%dx),%al
  101001:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101004:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101008:	84 c0                	test   %al,%al
  10100a:	78 09                	js     101015 <lpt_putc_sub+0x39>
  10100c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101013:	7e d6                	jle    100feb <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101015:	8b 45 08             	mov    0x8(%ebp),%eax
  101018:	0f b6 c0             	movzbl %al,%eax
  10101b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101021:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101024:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101028:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10102c:	ee                   	out    %al,(%dx)
  10102d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101033:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101037:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10103b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10103f:	ee                   	out    %al,(%dx)
  101040:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101046:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10104a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10104e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101052:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101053:	c9                   	leave  
  101054:	c3                   	ret    

00101055 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101055:	55                   	push   %ebp
  101056:	89 e5                	mov    %esp,%ebp
  101058:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10105b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10105f:	74 0d                	je     10106e <lpt_putc+0x19>
        lpt_putc_sub(c);
  101061:	8b 45 08             	mov    0x8(%ebp),%eax
  101064:	89 04 24             	mov    %eax,(%esp)
  101067:	e8 70 ff ff ff       	call   100fdc <lpt_putc_sub>
  10106c:	eb 24                	jmp    101092 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10106e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101075:	e8 62 ff ff ff       	call   100fdc <lpt_putc_sub>
        lpt_putc_sub(' ');
  10107a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101081:	e8 56 ff ff ff       	call   100fdc <lpt_putc_sub>
        lpt_putc_sub('\b');
  101086:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10108d:	e8 4a ff ff ff       	call   100fdc <lpt_putc_sub>
    }
}
  101092:	c9                   	leave  
  101093:	c3                   	ret    

00101094 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101094:	55                   	push   %ebp
  101095:	89 e5                	mov    %esp,%ebp
  101097:	53                   	push   %ebx
  101098:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10109b:	8b 45 08             	mov    0x8(%ebp),%eax
  10109e:	b0 00                	mov    $0x0,%al
  1010a0:	85 c0                	test   %eax,%eax
  1010a2:	75 07                	jne    1010ab <cga_putc+0x17>
        c |= 0x0700;
  1010a4:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ae:	0f b6 c0             	movzbl %al,%eax
  1010b1:	83 f8 0a             	cmp    $0xa,%eax
  1010b4:	74 4c                	je     101102 <cga_putc+0x6e>
  1010b6:	83 f8 0d             	cmp    $0xd,%eax
  1010b9:	74 57                	je     101112 <cga_putc+0x7e>
  1010bb:	83 f8 08             	cmp    $0x8,%eax
  1010be:	0f 85 88 00 00 00    	jne    10114c <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010c4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010cb:	66 85 c0             	test   %ax,%ax
  1010ce:	74 30                	je     101100 <cga_putc+0x6c>
            crt_pos --;
  1010d0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d7:	83 e8 01             	sub    $0x1,%eax
  1010da:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010e0:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010e5:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010ec:	0f b7 d2             	movzwl %dx,%edx
  1010ef:	01 d2                	add    %edx,%edx
  1010f1:	01 c2                	add    %eax,%edx
  1010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f6:	b0 00                	mov    $0x0,%al
  1010f8:	83 c8 20             	or     $0x20,%eax
  1010fb:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010fe:	eb 72                	jmp    101172 <cga_putc+0xde>
  101100:	eb 70                	jmp    101172 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101102:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101109:	83 c0 50             	add    $0x50,%eax
  10110c:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101112:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101119:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101120:	0f b7 c1             	movzwl %cx,%eax
  101123:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101129:	c1 e8 10             	shr    $0x10,%eax
  10112c:	89 c2                	mov    %eax,%edx
  10112e:	66 c1 ea 06          	shr    $0x6,%dx
  101132:	89 d0                	mov    %edx,%eax
  101134:	c1 e0 02             	shl    $0x2,%eax
  101137:	01 d0                	add    %edx,%eax
  101139:	c1 e0 04             	shl    $0x4,%eax
  10113c:	29 c1                	sub    %eax,%ecx
  10113e:	89 ca                	mov    %ecx,%edx
  101140:	89 d8                	mov    %ebx,%eax
  101142:	29 d0                	sub    %edx,%eax
  101144:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10114a:	eb 26                	jmp    101172 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10114c:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101152:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101159:	8d 50 01             	lea    0x1(%eax),%edx
  10115c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101163:	0f b7 c0             	movzwl %ax,%eax
  101166:	01 c0                	add    %eax,%eax
  101168:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10116b:	8b 45 08             	mov    0x8(%ebp),%eax
  10116e:	66 89 02             	mov    %ax,(%edx)
        break;
  101171:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101172:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101179:	66 3d cf 07          	cmp    $0x7cf,%ax
  10117d:	76 5b                	jbe    1011da <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10117f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101184:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10118a:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118f:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101196:	00 
  101197:	89 54 24 04          	mov    %edx,0x4(%esp)
  10119b:	89 04 24             	mov    %eax,(%esp)
  10119e:	e8 96 21 00 00       	call   103339 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a3:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011aa:	eb 15                	jmp    1011c1 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011ac:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011b4:	01 d2                	add    %edx,%edx
  1011b6:	01 d0                	add    %edx,%eax
  1011b8:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011bd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011c1:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011c8:	7e e2                	jle    1011ac <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011ca:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d1:	83 e8 50             	sub    $0x50,%eax
  1011d4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011da:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011e1:	0f b7 c0             	movzwl %ax,%eax
  1011e4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011e8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011ec:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011f0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011f4:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011f5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011fc:	66 c1 e8 08          	shr    $0x8,%ax
  101200:	0f b6 c0             	movzbl %al,%eax
  101203:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10120a:	83 c2 01             	add    $0x1,%edx
  10120d:	0f b7 d2             	movzwl %dx,%edx
  101210:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101214:	88 45 ed             	mov    %al,-0x13(%ebp)
  101217:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10121b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10121f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101220:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101227:	0f b7 c0             	movzwl %ax,%eax
  10122a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10122e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101232:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101236:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10123a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10123b:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101242:	0f b6 c0             	movzbl %al,%eax
  101245:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10124c:	83 c2 01             	add    $0x1,%edx
  10124f:	0f b7 d2             	movzwl %dx,%edx
  101252:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101256:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101259:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10125d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101261:	ee                   	out    %al,(%dx)
}
  101262:	83 c4 34             	add    $0x34,%esp
  101265:	5b                   	pop    %ebx
  101266:	5d                   	pop    %ebp
  101267:	c3                   	ret    

00101268 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101268:	55                   	push   %ebp
  101269:	89 e5                	mov    %esp,%ebp
  10126b:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101275:	eb 09                	jmp    101280 <serial_putc_sub+0x18>
        delay();
  101277:	e8 4f fb ff ff       	call   100dcb <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101280:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101286:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10128a:	89 c2                	mov    %eax,%edx
  10128c:	ec                   	in     (%dx),%al
  10128d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101290:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101294:	0f b6 c0             	movzbl %al,%eax
  101297:	83 e0 20             	and    $0x20,%eax
  10129a:	85 c0                	test   %eax,%eax
  10129c:	75 09                	jne    1012a7 <serial_putc_sub+0x3f>
  10129e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012a5:	7e d0                	jle    101277 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1012aa:	0f b6 c0             	movzbl %al,%eax
  1012ad:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012b3:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012ba:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012be:	ee                   	out    %al,(%dx)
}
  1012bf:	c9                   	leave  
  1012c0:	c3                   	ret    

001012c1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012c1:	55                   	push   %ebp
  1012c2:	89 e5                	mov    %esp,%ebp
  1012c4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012c7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012cb:	74 0d                	je     1012da <serial_putc+0x19>
        serial_putc_sub(c);
  1012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d0:	89 04 24             	mov    %eax,(%esp)
  1012d3:	e8 90 ff ff ff       	call   101268 <serial_putc_sub>
  1012d8:	eb 24                	jmp    1012fe <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012da:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e1:	e8 82 ff ff ff       	call   101268 <serial_putc_sub>
        serial_putc_sub(' ');
  1012e6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012ed:	e8 76 ff ff ff       	call   101268 <serial_putc_sub>
        serial_putc_sub('\b');
  1012f2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f9:	e8 6a ff ff ff       	call   101268 <serial_putc_sub>
    }
}
  1012fe:	c9                   	leave  
  1012ff:	c3                   	ret    

00101300 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101300:	55                   	push   %ebp
  101301:	89 e5                	mov    %esp,%ebp
  101303:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101306:	eb 33                	jmp    10133b <cons_intr+0x3b>
        if (c != 0) {
  101308:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10130c:	74 2d                	je     10133b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10130e:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101313:	8d 50 01             	lea    0x1(%eax),%edx
  101316:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10131c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10131f:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101325:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10132a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10132f:	75 0a                	jne    10133b <cons_intr+0x3b>
                cons.wpos = 0;
  101331:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101338:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10133b:	8b 45 08             	mov    0x8(%ebp),%eax
  10133e:	ff d0                	call   *%eax
  101340:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101343:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101347:	75 bf                	jne    101308 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
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
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
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
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
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
  1013b8:	e8 43 ff ff ff       	call   101300 <cons_intr>
    }
}
  1013bd:	c9                   	leave  
  1013be:	c3                   	ret    

001013bf <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013bf:	55                   	push   %ebp
  1013c0:	89 e5                	mov    %esp,%ebp
  1013c2:	83 ec 38             	sub    $0x38,%esp
  1013c5:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
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
  1013e1:	75 0a                	jne    1013ed <kbd_proc_data+0x2e>
        return -1;
  1013e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e8:	e9 59 01 00 00       	jmp    101546 <kbd_proc_data+0x187>
  1013ed:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013f7:	89 c2                	mov    %eax,%edx
  1013f9:	ec                   	in     (%dx),%al
  1013fa:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013fd:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101401:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101404:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101408:	75 17                	jne    101421 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10140a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10140f:	83 c8 40             	or     $0x40,%eax
  101412:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101417:	b8 00 00 00 00       	mov    $0x0,%eax
  10141c:	e9 25 01 00 00       	jmp    101546 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101421:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101425:	84 c0                	test   %al,%al
  101427:	79 47                	jns    101470 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101429:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142e:	83 e0 40             	and    $0x40,%eax
  101431:	85 c0                	test   %eax,%eax
  101433:	75 09                	jne    10143e <kbd_proc_data+0x7f>
  101435:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101439:	83 e0 7f             	and    $0x7f,%eax
  10143c:	eb 04                	jmp    101442 <kbd_proc_data+0x83>
  10143e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101442:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101445:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101449:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101450:	83 c8 40             	or     $0x40,%eax
  101453:	0f b6 c0             	movzbl %al,%eax
  101456:	f7 d0                	not    %eax
  101458:	89 c2                	mov    %eax,%edx
  10145a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10145f:	21 d0                	and    %edx,%eax
  101461:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101466:	b8 00 00 00 00       	mov    $0x0,%eax
  10146b:	e9 d6 00 00 00       	jmp    101546 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101470:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101475:	83 e0 40             	and    $0x40,%eax
  101478:	85 c0                	test   %eax,%eax
  10147a:	74 11                	je     10148d <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10147c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101480:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101485:	83 e0 bf             	and    $0xffffffbf,%eax
  101488:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10148d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101491:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101498:	0f b6 d0             	movzbl %al,%edx
  10149b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a0:	09 d0                	or     %edx,%eax
  1014a2:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014a7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ab:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014b2:	0f b6 d0             	movzbl %al,%edx
  1014b5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ba:	31 d0                	xor    %edx,%eax
  1014bc:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014c1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c6:	83 e0 03             	and    $0x3,%eax
  1014c9:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014d0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d4:	01 d0                	add    %edx,%eax
  1014d6:	0f b6 00             	movzbl (%eax),%eax
  1014d9:	0f b6 c0             	movzbl %al,%eax
  1014dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014df:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e4:	83 e0 08             	and    $0x8,%eax
  1014e7:	85 c0                	test   %eax,%eax
  1014e9:	74 22                	je     10150d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014eb:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014ef:	7e 0c                	jle    1014fd <kbd_proc_data+0x13e>
  1014f1:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f5:	7f 06                	jg     1014fd <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014f7:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014fb:	eb 10                	jmp    10150d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014fd:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101501:	7e 0a                	jle    10150d <kbd_proc_data+0x14e>
  101503:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101507:	7f 04                	jg     10150d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101509:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10150d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101512:	f7 d0                	not    %eax
  101514:	83 e0 06             	and    $0x6,%eax
  101517:	85 c0                	test   %eax,%eax
  101519:	75 28                	jne    101543 <kbd_proc_data+0x184>
  10151b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101522:	75 1f                	jne    101543 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101524:	c7 04 24 cf 37 10 00 	movl   $0x1037cf,(%esp)
  10152b:	e8 e7 ed ff ff       	call   100317 <cprintf>
  101530:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101536:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10153a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10153e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101542:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101543:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101546:	c9                   	leave  
  101547:	c3                   	ret    

00101548 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101548:	55                   	push   %ebp
  101549:	89 e5                	mov    %esp,%ebp
  10154b:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10154e:	c7 04 24 bf 13 10 00 	movl   $0x1013bf,(%esp)
  101555:	e8 a6 fd ff ff       	call   101300 <cons_intr>
}
  10155a:	c9                   	leave  
  10155b:	c3                   	ret    

0010155c <kbd_init>:

static void
kbd_init(void) {
  10155c:	55                   	push   %ebp
  10155d:	89 e5                	mov    %esp,%ebp
  10155f:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101562:	e8 e1 ff ff ff       	call   101548 <kbd_intr>
    pic_enable(IRQ_KBD);
  101567:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10156e:	e8 17 01 00 00       	call   10168a <pic_enable>
}
  101573:	c9                   	leave  
  101574:	c3                   	ret    

00101575 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101575:	55                   	push   %ebp
  101576:	89 e5                	mov    %esp,%ebp
  101578:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10157b:	e8 93 f8 ff ff       	call   100e13 <cga_init>
    serial_init();
  101580:	e8 74 f9 ff ff       	call   100ef9 <serial_init>
    kbd_init();
  101585:	e8 d2 ff ff ff       	call   10155c <kbd_init>
    if (!serial_exists) {
  10158a:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10158f:	85 c0                	test   %eax,%eax
  101591:	75 0c                	jne    10159f <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101593:	c7 04 24 db 37 10 00 	movl   $0x1037db,(%esp)
  10159a:	e8 78 ed ff ff       	call   100317 <cprintf>
    }
}
  10159f:	c9                   	leave  
  1015a0:	c3                   	ret    

001015a1 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015a1:	55                   	push   %ebp
  1015a2:	89 e5                	mov    %esp,%ebp
  1015a4:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015aa:	89 04 24             	mov    %eax,(%esp)
  1015ad:	e8 a3 fa ff ff       	call   101055 <lpt_putc>
    cga_putc(c);
  1015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b5:	89 04 24             	mov    %eax,(%esp)
  1015b8:	e8 d7 fa ff ff       	call   101094 <cga_putc>
    serial_putc(c);
  1015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c0:	89 04 24             	mov    %eax,(%esp)
  1015c3:	e8 f9 fc ff ff       	call   1012c1 <serial_putc>
}
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
  1015d5:	e8 6e ff ff ff       	call   101548 <kbd_intr>

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

00101626 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101626:	55                   	push   %ebp
  101627:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101629:	fb                   	sti    
    sti();
}
  10162a:	5d                   	pop    %ebp
  10162b:	c3                   	ret    

0010162c <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10162c:	55                   	push   %ebp
  10162d:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  10162f:	fa                   	cli    
    cli();
}
  101630:	5d                   	pop    %ebp
  101631:	c3                   	ret    

00101632 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101632:	55                   	push   %ebp
  101633:	89 e5                	mov    %esp,%ebp
  101635:	83 ec 14             	sub    $0x14,%esp
  101638:	8b 45 08             	mov    0x8(%ebp),%eax
  10163b:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10163f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101643:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101649:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  10164e:	85 c0                	test   %eax,%eax
  101650:	74 36                	je     101688 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101652:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101656:	0f b6 c0             	movzbl %al,%eax
  101659:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10165f:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101662:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101666:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10166a:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10166b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10166f:	66 c1 e8 08          	shr    $0x8,%ax
  101673:	0f b6 c0             	movzbl %al,%eax
  101676:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10167c:	88 45 f9             	mov    %al,-0x7(%ebp)
  10167f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101683:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101687:	ee                   	out    %al,(%dx)
    }
}
  101688:	c9                   	leave  
  101689:	c3                   	ret    

0010168a <pic_enable>:

void
pic_enable(unsigned int irq) {
  10168a:	55                   	push   %ebp
  10168b:	89 e5                	mov    %esp,%ebp
  10168d:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101690:	8b 45 08             	mov    0x8(%ebp),%eax
  101693:	ba 01 00 00 00       	mov    $0x1,%edx
  101698:	89 c1                	mov    %eax,%ecx
  10169a:	d3 e2                	shl    %cl,%edx
  10169c:	89 d0                	mov    %edx,%eax
  10169e:	f7 d0                	not    %eax
  1016a0:	89 c2                	mov    %eax,%edx
  1016a2:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016a9:	21 d0                	and    %edx,%eax
  1016ab:	0f b7 c0             	movzwl %ax,%eax
  1016ae:	89 04 24             	mov    %eax,(%esp)
  1016b1:	e8 7c ff ff ff       	call   101632 <pic_setmask>
}
  1016b6:	c9                   	leave  
  1016b7:	c3                   	ret    

001016b8 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016b8:	55                   	push   %ebp
  1016b9:	89 e5                	mov    %esp,%ebp
  1016bb:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016be:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016c5:	00 00 00 
  1016c8:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016ce:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016d2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016d6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016da:	ee                   	out    %al,(%dx)
  1016db:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016e1:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016e5:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016e9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016ed:	ee                   	out    %al,(%dx)
  1016ee:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016f4:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016f8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016fc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101700:	ee                   	out    %al,(%dx)
  101701:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101707:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10170b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10170f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101713:	ee                   	out    %al,(%dx)
  101714:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10171a:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10171e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101722:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101726:	ee                   	out    %al,(%dx)
  101727:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10172d:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101731:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101735:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101739:	ee                   	out    %al,(%dx)
  10173a:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101740:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101744:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101748:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10174c:	ee                   	out    %al,(%dx)
  10174d:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101753:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101757:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10175b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10175f:	ee                   	out    %al,(%dx)
  101760:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101766:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10176a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10176e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101772:	ee                   	out    %al,(%dx)
  101773:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101779:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10177d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101781:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101785:	ee                   	out    %al,(%dx)
  101786:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10178c:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101790:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101794:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101798:	ee                   	out    %al,(%dx)
  101799:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10179f:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017a3:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017a7:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017ab:	ee                   	out    %al,(%dx)
  1017ac:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017b2:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017b6:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017ba:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017be:	ee                   	out    %al,(%dx)
  1017bf:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017c5:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017c9:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017cd:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017d1:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017d2:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d9:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017dd:	74 12                	je     1017f1 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017df:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e6:	0f b7 c0             	movzwl %ax,%eax
  1017e9:	89 04 24             	mov    %eax,(%esp)
  1017ec:	e8 41 fe ff ff       	call   101632 <pic_setmask>
    }
}
  1017f1:	c9                   	leave  
  1017f2:	c3                   	ret    

001017f3 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017f3:	55                   	push   %ebp
  1017f4:	89 e5                	mov    %esp,%ebp
  1017f6:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101800:	00 
  101801:	c7 04 24 00 38 10 00 	movl   $0x103800,(%esp)
  101808:	e8 0a eb ff ff       	call   100317 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10180d:	c9                   	leave  
  10180e:	c3                   	ret    

0010180f <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10180f:	55                   	push   %ebp
  101810:	89 e5                	mov    %esp,%ebp
  101812:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {//在数组长度内初始化中断向量表
  101815:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10181c:	e9 c3 00 00 00       	jmp    1018e4 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);//使用非陷阱门描述符，在内核级设置中断向量表
  101821:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101824:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10182b:	89 c2                	mov    %eax,%edx
  10182d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101830:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101837:	00 
  101838:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183b:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101842:	00 08 00 
  101845:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101848:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10184f:	00 
  101850:	83 e2 e0             	and    $0xffffffe0,%edx
  101853:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10185a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185d:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101864:	00 
  101865:	83 e2 1f             	and    $0x1f,%edx
  101868:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101872:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101879:	00 
  10187a:	83 e2 f0             	and    $0xfffffff0,%edx
  10187d:	83 ca 0e             	or     $0xe,%edx
  101880:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101887:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188a:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101891:	00 
  101892:	83 e2 ef             	and    $0xffffffef,%edx
  101895:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10189c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a6:	00 
  1018a7:	83 e2 9f             	and    $0xffffff9f,%edx
  1018aa:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b4:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018bb:	00 
  1018bc:	83 ca 80             	or     $0xffffff80,%edx
  1018bf:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c9:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018d0:	c1 e8 10             	shr    $0x10,%eax
  1018d3:	89 c2                	mov    %eax,%edx
  1018d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d8:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018df:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
     extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {//在数组长度内初始化中断向量表
  1018e0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e7:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018ec:	0f 86 2f ff ff ff    	jbe    101821 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);//使用非陷阱门描述符，在内核级设置中断向量表
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);//设置用户级转向内核级的中断向量表
  1018f2:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018f7:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018fd:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101904:	08 00 
  101906:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10190d:	83 e0 e0             	and    $0xffffffe0,%eax
  101910:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101915:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10191c:	83 e0 1f             	and    $0x1f,%eax
  10191f:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101924:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10192b:	83 e0 f0             	and    $0xfffffff0,%eax
  10192e:	83 c8 0e             	or     $0xe,%eax
  101931:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101936:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10193d:	83 e0 ef             	and    $0xffffffef,%eax
  101940:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101945:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10194c:	83 c8 60             	or     $0x60,%eax
  10194f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101954:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10195b:	83 c8 80             	or     $0xffffff80,%eax
  10195e:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101963:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101968:	c1 e8 10             	shr    $0x10,%eax
  10196b:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101971:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101978:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10197b:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);//加载中断向量表
}
  10197e:	c9                   	leave  
  10197f:	c3                   	ret    

00101980 <trapname>:

static const char *
trapname(int trapno) {
  101980:	55                   	push   %ebp
  101981:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101983:	8b 45 08             	mov    0x8(%ebp),%eax
  101986:	83 f8 13             	cmp    $0x13,%eax
  101989:	77 0c                	ja     101997 <trapname+0x17>
        return excnames[trapno];
  10198b:	8b 45 08             	mov    0x8(%ebp),%eax
  10198e:	8b 04 85 60 3b 10 00 	mov    0x103b60(,%eax,4),%eax
  101995:	eb 18                	jmp    1019af <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101997:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  10199b:	7e 0d                	jle    1019aa <trapname+0x2a>
  10199d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019a1:	7f 07                	jg     1019aa <trapname+0x2a>
        return "Hardware Interrupt";
  1019a3:	b8 0a 38 10 00       	mov    $0x10380a,%eax
  1019a8:	eb 05                	jmp    1019af <trapname+0x2f>
    }
    return "(unknown trap)";
  1019aa:	b8 1d 38 10 00       	mov    $0x10381d,%eax
}
  1019af:	5d                   	pop    %ebp
  1019b0:	c3                   	ret    

001019b1 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019b1:	55                   	push   %ebp
  1019b2:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019bb:	66 83 f8 08          	cmp    $0x8,%ax
  1019bf:	0f 94 c0             	sete   %al
  1019c2:	0f b6 c0             	movzbl %al,%eax
}
  1019c5:	5d                   	pop    %ebp
  1019c6:	c3                   	ret    

001019c7 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019c7:	55                   	push   %ebp
  1019c8:	89 e5                	mov    %esp,%ebp
  1019ca:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019d4:	c7 04 24 5e 38 10 00 	movl   $0x10385e,(%esp)
  1019db:	e8 37 e9 ff ff       	call   100317 <cprintf>
    print_regs(&tf->tf_regs);
  1019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e3:	89 04 24             	mov    %eax,(%esp)
  1019e6:	e8 a1 01 00 00       	call   101b8c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ee:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019f2:	0f b7 c0             	movzwl %ax,%eax
  1019f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f9:	c7 04 24 6f 38 10 00 	movl   $0x10386f,(%esp)
  101a00:	e8 12 e9 ff ff       	call   100317 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a05:	8b 45 08             	mov    0x8(%ebp),%eax
  101a08:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a0c:	0f b7 c0             	movzwl %ax,%eax
  101a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a13:	c7 04 24 82 38 10 00 	movl   $0x103882,(%esp)
  101a1a:	e8 f8 e8 ff ff       	call   100317 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a22:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a26:	0f b7 c0             	movzwl %ax,%eax
  101a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2d:	c7 04 24 95 38 10 00 	movl   $0x103895,(%esp)
  101a34:	e8 de e8 ff ff       	call   100317 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a39:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3c:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a40:	0f b7 c0             	movzwl %ax,%eax
  101a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a47:	c7 04 24 a8 38 10 00 	movl   $0x1038a8,(%esp)
  101a4e:	e8 c4 e8 ff ff       	call   100317 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a53:	8b 45 08             	mov    0x8(%ebp),%eax
  101a56:	8b 40 30             	mov    0x30(%eax),%eax
  101a59:	89 04 24             	mov    %eax,(%esp)
  101a5c:	e8 1f ff ff ff       	call   101980 <trapname>
  101a61:	8b 55 08             	mov    0x8(%ebp),%edx
  101a64:	8b 52 30             	mov    0x30(%edx),%edx
  101a67:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a6b:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a6f:	c7 04 24 bb 38 10 00 	movl   $0x1038bb,(%esp)
  101a76:	e8 9c e8 ff ff       	call   100317 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7e:	8b 40 34             	mov    0x34(%eax),%eax
  101a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a85:	c7 04 24 cd 38 10 00 	movl   $0x1038cd,(%esp)
  101a8c:	e8 86 e8 ff ff       	call   100317 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a91:	8b 45 08             	mov    0x8(%ebp),%eax
  101a94:	8b 40 38             	mov    0x38(%eax),%eax
  101a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9b:	c7 04 24 dc 38 10 00 	movl   $0x1038dc,(%esp)
  101aa2:	e8 70 e8 ff ff       	call   100317 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aaa:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101aae:	0f b7 c0             	movzwl %ax,%eax
  101ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab5:	c7 04 24 eb 38 10 00 	movl   $0x1038eb,(%esp)
  101abc:	e8 56 e8 ff ff       	call   100317 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac4:	8b 40 40             	mov    0x40(%eax),%eax
  101ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acb:	c7 04 24 fe 38 10 00 	movl   $0x1038fe,(%esp)
  101ad2:	e8 40 e8 ff ff       	call   100317 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ad7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ade:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ae5:	eb 3e                	jmp    101b25 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aea:	8b 50 40             	mov    0x40(%eax),%edx
  101aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101af0:	21 d0                	and    %edx,%eax
  101af2:	85 c0                	test   %eax,%eax
  101af4:	74 28                	je     101b1e <print_trapframe+0x157>
  101af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101af9:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b00:	85 c0                	test   %eax,%eax
  101b02:	74 1a                	je     101b1e <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b07:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b12:	c7 04 24 0d 39 10 00 	movl   $0x10390d,(%esp)
  101b19:	e8 f9 e7 ff ff       	call   100317 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b1e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b22:	d1 65 f0             	shll   -0x10(%ebp)
  101b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b28:	83 f8 17             	cmp    $0x17,%eax
  101b2b:	76 ba                	jbe    101ae7 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b30:	8b 40 40             	mov    0x40(%eax),%eax
  101b33:	25 00 30 00 00       	and    $0x3000,%eax
  101b38:	c1 e8 0c             	shr    $0xc,%eax
  101b3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3f:	c7 04 24 11 39 10 00 	movl   $0x103911,(%esp)
  101b46:	e8 cc e7 ff ff       	call   100317 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4e:	89 04 24             	mov    %eax,(%esp)
  101b51:	e8 5b fe ff ff       	call   1019b1 <trap_in_kernel>
  101b56:	85 c0                	test   %eax,%eax
  101b58:	75 30                	jne    101b8a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5d:	8b 40 44             	mov    0x44(%eax),%eax
  101b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b64:	c7 04 24 1a 39 10 00 	movl   $0x10391a,(%esp)
  101b6b:	e8 a7 e7 ff ff       	call   100317 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b70:	8b 45 08             	mov    0x8(%ebp),%eax
  101b73:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b77:	0f b7 c0             	movzwl %ax,%eax
  101b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7e:	c7 04 24 29 39 10 00 	movl   $0x103929,(%esp)
  101b85:	e8 8d e7 ff ff       	call   100317 <cprintf>
    }
}
  101b8a:	c9                   	leave  
  101b8b:	c3                   	ret    

00101b8c <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b8c:	55                   	push   %ebp
  101b8d:	89 e5                	mov    %esp,%ebp
  101b8f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b92:	8b 45 08             	mov    0x8(%ebp),%eax
  101b95:	8b 00                	mov    (%eax),%eax
  101b97:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9b:	c7 04 24 3c 39 10 00 	movl   $0x10393c,(%esp)
  101ba2:	e8 70 e7 ff ff       	call   100317 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  101baa:	8b 40 04             	mov    0x4(%eax),%eax
  101bad:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb1:	c7 04 24 4b 39 10 00 	movl   $0x10394b,(%esp)
  101bb8:	e8 5a e7 ff ff       	call   100317 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc0:	8b 40 08             	mov    0x8(%eax),%eax
  101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc7:	c7 04 24 5a 39 10 00 	movl   $0x10395a,(%esp)
  101bce:	e8 44 e7 ff ff       	call   100317 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd6:	8b 40 0c             	mov    0xc(%eax),%eax
  101bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdd:	c7 04 24 69 39 10 00 	movl   $0x103969,(%esp)
  101be4:	e8 2e e7 ff ff       	call   100317 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101be9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bec:	8b 40 10             	mov    0x10(%eax),%eax
  101bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf3:	c7 04 24 78 39 10 00 	movl   $0x103978,(%esp)
  101bfa:	e8 18 e7 ff ff       	call   100317 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bff:	8b 45 08             	mov    0x8(%ebp),%eax
  101c02:	8b 40 14             	mov    0x14(%eax),%eax
  101c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c09:	c7 04 24 87 39 10 00 	movl   $0x103987,(%esp)
  101c10:	e8 02 e7 ff ff       	call   100317 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c15:	8b 45 08             	mov    0x8(%ebp),%eax
  101c18:	8b 40 18             	mov    0x18(%eax),%eax
  101c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1f:	c7 04 24 96 39 10 00 	movl   $0x103996,(%esp)
  101c26:	e8 ec e6 ff ff       	call   100317 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c35:	c7 04 24 a5 39 10 00 	movl   $0x1039a5,(%esp)
  101c3c:	e8 d6 e6 ff ff       	call   100317 <cprintf>
}
  101c41:	c9                   	leave  
  101c42:	c3                   	ret    

00101c43 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c43:	55                   	push   %ebp
  101c44:	89 e5                	mov    %esp,%ebp
  101c46:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c49:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4c:	8b 40 30             	mov    0x30(%eax),%eax
  101c4f:	83 f8 2f             	cmp    $0x2f,%eax
  101c52:	77 21                	ja     101c75 <trap_dispatch+0x32>
  101c54:	83 f8 2e             	cmp    $0x2e,%eax
  101c57:	0f 83 04 01 00 00    	jae    101d61 <trap_dispatch+0x11e>
  101c5d:	83 f8 21             	cmp    $0x21,%eax
  101c60:	0f 84 81 00 00 00    	je     101ce7 <trap_dispatch+0xa4>
  101c66:	83 f8 24             	cmp    $0x24,%eax
  101c69:	74 56                	je     101cc1 <trap_dispatch+0x7e>
  101c6b:	83 f8 20             	cmp    $0x20,%eax
  101c6e:	74 16                	je     101c86 <trap_dispatch+0x43>
  101c70:	e9 b4 00 00 00       	jmp    101d29 <trap_dispatch+0xe6>
  101c75:	83 e8 78             	sub    $0x78,%eax
  101c78:	83 f8 01             	cmp    $0x1,%eax
  101c7b:	0f 87 a8 00 00 00    	ja     101d29 <trap_dispatch+0xe6>
  101c81:	e9 87 00 00 00       	jmp    101d0d <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++;
  101c86:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c8b:	83 c0 01             	add    $0x1,%eax
  101c8e:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if(ticks%TICK_NUM == 0)
  101c93:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101c99:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c9e:	89 c8                	mov    %ecx,%eax
  101ca0:	f7 e2                	mul    %edx
  101ca2:	89 d0                	mov    %edx,%eax
  101ca4:	c1 e8 05             	shr    $0x5,%eax
  101ca7:	6b c0 64             	imul   $0x64,%eax,%eax
  101caa:	29 c1                	sub    %eax,%ecx
  101cac:	89 c8                	mov    %ecx,%eax
  101cae:	85 c0                	test   %eax,%eax
  101cb0:	75 0a                	jne    101cbc <trap_dispatch+0x79>
        {
            print_ticks();
  101cb2:	e8 3c fb ff ff       	call   1017f3 <print_ticks>
        }
        break;
  101cb7:	e9 a6 00 00 00       	jmp    101d62 <trap_dispatch+0x11f>
  101cbc:	e9 a1 00 00 00       	jmp    101d62 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cc1:	e8 04 f9 ff ff       	call   1015ca <cons_getc>
  101cc6:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cc9:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ccd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cd1:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd9:	c7 04 24 b4 39 10 00 	movl   $0x1039b4,(%esp)
  101ce0:	e8 32 e6 ff ff       	call   100317 <cprintf>
        break;
  101ce5:	eb 7b                	jmp    101d62 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ce7:	e8 de f8 ff ff       	call   1015ca <cons_getc>
  101cec:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101cef:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cff:	c7 04 24 c6 39 10 00 	movl   $0x1039c6,(%esp)
  101d06:	e8 0c e6 ff ff       	call   100317 <cprintf>
        break;
  101d0b:	eb 55                	jmp    101d62 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d0d:	c7 44 24 08 d5 39 10 	movl   $0x1039d5,0x8(%esp)
  101d14:	00 
  101d15:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  101d1c:	00 
  101d1d:	c7 04 24 e5 39 10 00 	movl   $0x1039e5,(%esp)
  101d24:	e8 72 ef ff ff       	call   100c9b <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d29:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d30:	0f b7 c0             	movzwl %ax,%eax
  101d33:	83 e0 03             	and    $0x3,%eax
  101d36:	85 c0                	test   %eax,%eax
  101d38:	75 28                	jne    101d62 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3d:	89 04 24             	mov    %eax,(%esp)
  101d40:	e8 82 fc ff ff       	call   1019c7 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d45:	c7 44 24 08 f6 39 10 	movl   $0x1039f6,0x8(%esp)
  101d4c:	00 
  101d4d:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  101d54:	00 
  101d55:	c7 04 24 e5 39 10 00 	movl   $0x1039e5,(%esp)
  101d5c:	e8 3a ef ff ff       	call   100c9b <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d61:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d62:	c9                   	leave  
  101d63:	c3                   	ret    

00101d64 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d64:	55                   	push   %ebp
  101d65:	89 e5                	mov    %esp,%ebp
  101d67:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6d:	89 04 24             	mov    %eax,(%esp)
  101d70:	e8 ce fe ff ff       	call   101c43 <trap_dispatch>
}
  101d75:	c9                   	leave  
  101d76:	c3                   	ret    

00101d77 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d77:	1e                   	push   %ds
    pushl %es
  101d78:	06                   	push   %es
    pushl %fs
  101d79:	0f a0                	push   %fs
    pushl %gs
  101d7b:	0f a8                	push   %gs
    pushal
  101d7d:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d7e:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d83:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d85:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d87:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d88:	e8 d7 ff ff ff       	call   101d64 <trap>

    # pop the pushed stack pointer
    popl %esp
  101d8d:	5c                   	pop    %esp

00101d8e <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d8e:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d8f:	0f a9                	pop    %gs
    popl %fs
  101d91:	0f a1                	pop    %fs
    popl %es
  101d93:	07                   	pop    %es
    popl %ds
  101d94:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d95:	83 c4 08             	add    $0x8,%esp
    iret
  101d98:	cf                   	iret   

00101d99 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d99:	6a 00                	push   $0x0
  pushl $0
  101d9b:	6a 00                	push   $0x0
  jmp __alltraps
  101d9d:	e9 d5 ff ff ff       	jmp    101d77 <__alltraps>

00101da2 <vector1>:
.globl vector1
vector1:
  pushl $0
  101da2:	6a 00                	push   $0x0
  pushl $1
  101da4:	6a 01                	push   $0x1
  jmp __alltraps
  101da6:	e9 cc ff ff ff       	jmp    101d77 <__alltraps>

00101dab <vector2>:
.globl vector2
vector2:
  pushl $0
  101dab:	6a 00                	push   $0x0
  pushl $2
  101dad:	6a 02                	push   $0x2
  jmp __alltraps
  101daf:	e9 c3 ff ff ff       	jmp    101d77 <__alltraps>

00101db4 <vector3>:
.globl vector3
vector3:
  pushl $0
  101db4:	6a 00                	push   $0x0
  pushl $3
  101db6:	6a 03                	push   $0x3
  jmp __alltraps
  101db8:	e9 ba ff ff ff       	jmp    101d77 <__alltraps>

00101dbd <vector4>:
.globl vector4
vector4:
  pushl $0
  101dbd:	6a 00                	push   $0x0
  pushl $4
  101dbf:	6a 04                	push   $0x4
  jmp __alltraps
  101dc1:	e9 b1 ff ff ff       	jmp    101d77 <__alltraps>

00101dc6 <vector5>:
.globl vector5
vector5:
  pushl $0
  101dc6:	6a 00                	push   $0x0
  pushl $5
  101dc8:	6a 05                	push   $0x5
  jmp __alltraps
  101dca:	e9 a8 ff ff ff       	jmp    101d77 <__alltraps>

00101dcf <vector6>:
.globl vector6
vector6:
  pushl $0
  101dcf:	6a 00                	push   $0x0
  pushl $6
  101dd1:	6a 06                	push   $0x6
  jmp __alltraps
  101dd3:	e9 9f ff ff ff       	jmp    101d77 <__alltraps>

00101dd8 <vector7>:
.globl vector7
vector7:
  pushl $0
  101dd8:	6a 00                	push   $0x0
  pushl $7
  101dda:	6a 07                	push   $0x7
  jmp __alltraps
  101ddc:	e9 96 ff ff ff       	jmp    101d77 <__alltraps>

00101de1 <vector8>:
.globl vector8
vector8:
  pushl $8
  101de1:	6a 08                	push   $0x8
  jmp __alltraps
  101de3:	e9 8f ff ff ff       	jmp    101d77 <__alltraps>

00101de8 <vector9>:
.globl vector9
vector9:
  pushl $0
  101de8:	6a 00                	push   $0x0
  pushl $9
  101dea:	6a 09                	push   $0x9
  jmp __alltraps
  101dec:	e9 86 ff ff ff       	jmp    101d77 <__alltraps>

00101df1 <vector10>:
.globl vector10
vector10:
  pushl $10
  101df1:	6a 0a                	push   $0xa
  jmp __alltraps
  101df3:	e9 7f ff ff ff       	jmp    101d77 <__alltraps>

00101df8 <vector11>:
.globl vector11
vector11:
  pushl $11
  101df8:	6a 0b                	push   $0xb
  jmp __alltraps
  101dfa:	e9 78 ff ff ff       	jmp    101d77 <__alltraps>

00101dff <vector12>:
.globl vector12
vector12:
  pushl $12
  101dff:	6a 0c                	push   $0xc
  jmp __alltraps
  101e01:	e9 71 ff ff ff       	jmp    101d77 <__alltraps>

00101e06 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e06:	6a 0d                	push   $0xd
  jmp __alltraps
  101e08:	e9 6a ff ff ff       	jmp    101d77 <__alltraps>

00101e0d <vector14>:
.globl vector14
vector14:
  pushl $14
  101e0d:	6a 0e                	push   $0xe
  jmp __alltraps
  101e0f:	e9 63 ff ff ff       	jmp    101d77 <__alltraps>

00101e14 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e14:	6a 00                	push   $0x0
  pushl $15
  101e16:	6a 0f                	push   $0xf
  jmp __alltraps
  101e18:	e9 5a ff ff ff       	jmp    101d77 <__alltraps>

00101e1d <vector16>:
.globl vector16
vector16:
  pushl $0
  101e1d:	6a 00                	push   $0x0
  pushl $16
  101e1f:	6a 10                	push   $0x10
  jmp __alltraps
  101e21:	e9 51 ff ff ff       	jmp    101d77 <__alltraps>

00101e26 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e26:	6a 11                	push   $0x11
  jmp __alltraps
  101e28:	e9 4a ff ff ff       	jmp    101d77 <__alltraps>

00101e2d <vector18>:
.globl vector18
vector18:
  pushl $0
  101e2d:	6a 00                	push   $0x0
  pushl $18
  101e2f:	6a 12                	push   $0x12
  jmp __alltraps
  101e31:	e9 41 ff ff ff       	jmp    101d77 <__alltraps>

00101e36 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $19
  101e38:	6a 13                	push   $0x13
  jmp __alltraps
  101e3a:	e9 38 ff ff ff       	jmp    101d77 <__alltraps>

00101e3f <vector20>:
.globl vector20
vector20:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $20
  101e41:	6a 14                	push   $0x14
  jmp __alltraps
  101e43:	e9 2f ff ff ff       	jmp    101d77 <__alltraps>

00101e48 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e48:	6a 00                	push   $0x0
  pushl $21
  101e4a:	6a 15                	push   $0x15
  jmp __alltraps
  101e4c:	e9 26 ff ff ff       	jmp    101d77 <__alltraps>

00101e51 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e51:	6a 00                	push   $0x0
  pushl $22
  101e53:	6a 16                	push   $0x16
  jmp __alltraps
  101e55:	e9 1d ff ff ff       	jmp    101d77 <__alltraps>

00101e5a <vector23>:
.globl vector23
vector23:
  pushl $0
  101e5a:	6a 00                	push   $0x0
  pushl $23
  101e5c:	6a 17                	push   $0x17
  jmp __alltraps
  101e5e:	e9 14 ff ff ff       	jmp    101d77 <__alltraps>

00101e63 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e63:	6a 00                	push   $0x0
  pushl $24
  101e65:	6a 18                	push   $0x18
  jmp __alltraps
  101e67:	e9 0b ff ff ff       	jmp    101d77 <__alltraps>

00101e6c <vector25>:
.globl vector25
vector25:
  pushl $0
  101e6c:	6a 00                	push   $0x0
  pushl $25
  101e6e:	6a 19                	push   $0x19
  jmp __alltraps
  101e70:	e9 02 ff ff ff       	jmp    101d77 <__alltraps>

00101e75 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e75:	6a 00                	push   $0x0
  pushl $26
  101e77:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e79:	e9 f9 fe ff ff       	jmp    101d77 <__alltraps>

00101e7e <vector27>:
.globl vector27
vector27:
  pushl $0
  101e7e:	6a 00                	push   $0x0
  pushl $27
  101e80:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e82:	e9 f0 fe ff ff       	jmp    101d77 <__alltraps>

00101e87 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e87:	6a 00                	push   $0x0
  pushl $28
  101e89:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e8b:	e9 e7 fe ff ff       	jmp    101d77 <__alltraps>

00101e90 <vector29>:
.globl vector29
vector29:
  pushl $0
  101e90:	6a 00                	push   $0x0
  pushl $29
  101e92:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e94:	e9 de fe ff ff       	jmp    101d77 <__alltraps>

00101e99 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e99:	6a 00                	push   $0x0
  pushl $30
  101e9b:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e9d:	e9 d5 fe ff ff       	jmp    101d77 <__alltraps>

00101ea2 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ea2:	6a 00                	push   $0x0
  pushl $31
  101ea4:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ea6:	e9 cc fe ff ff       	jmp    101d77 <__alltraps>

00101eab <vector32>:
.globl vector32
vector32:
  pushl $0
  101eab:	6a 00                	push   $0x0
  pushl $32
  101ead:	6a 20                	push   $0x20
  jmp __alltraps
  101eaf:	e9 c3 fe ff ff       	jmp    101d77 <__alltraps>

00101eb4 <vector33>:
.globl vector33
vector33:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $33
  101eb6:	6a 21                	push   $0x21
  jmp __alltraps
  101eb8:	e9 ba fe ff ff       	jmp    101d77 <__alltraps>

00101ebd <vector34>:
.globl vector34
vector34:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $34
  101ebf:	6a 22                	push   $0x22
  jmp __alltraps
  101ec1:	e9 b1 fe ff ff       	jmp    101d77 <__alltraps>

00101ec6 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $35
  101ec8:	6a 23                	push   $0x23
  jmp __alltraps
  101eca:	e9 a8 fe ff ff       	jmp    101d77 <__alltraps>

00101ecf <vector36>:
.globl vector36
vector36:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $36
  101ed1:	6a 24                	push   $0x24
  jmp __alltraps
  101ed3:	e9 9f fe ff ff       	jmp    101d77 <__alltraps>

00101ed8 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $37
  101eda:	6a 25                	push   $0x25
  jmp __alltraps
  101edc:	e9 96 fe ff ff       	jmp    101d77 <__alltraps>

00101ee1 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $38
  101ee3:	6a 26                	push   $0x26
  jmp __alltraps
  101ee5:	e9 8d fe ff ff       	jmp    101d77 <__alltraps>

00101eea <vector39>:
.globl vector39
vector39:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $39
  101eec:	6a 27                	push   $0x27
  jmp __alltraps
  101eee:	e9 84 fe ff ff       	jmp    101d77 <__alltraps>

00101ef3 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $40
  101ef5:	6a 28                	push   $0x28
  jmp __alltraps
  101ef7:	e9 7b fe ff ff       	jmp    101d77 <__alltraps>

00101efc <vector41>:
.globl vector41
vector41:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $41
  101efe:	6a 29                	push   $0x29
  jmp __alltraps
  101f00:	e9 72 fe ff ff       	jmp    101d77 <__alltraps>

00101f05 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f05:	6a 00                	push   $0x0
  pushl $42
  101f07:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f09:	e9 69 fe ff ff       	jmp    101d77 <__alltraps>

00101f0e <vector43>:
.globl vector43
vector43:
  pushl $0
  101f0e:	6a 00                	push   $0x0
  pushl $43
  101f10:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f12:	e9 60 fe ff ff       	jmp    101d77 <__alltraps>

00101f17 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f17:	6a 00                	push   $0x0
  pushl $44
  101f19:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f1b:	e9 57 fe ff ff       	jmp    101d77 <__alltraps>

00101f20 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f20:	6a 00                	push   $0x0
  pushl $45
  101f22:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f24:	e9 4e fe ff ff       	jmp    101d77 <__alltraps>

00101f29 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f29:	6a 00                	push   $0x0
  pushl $46
  101f2b:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f2d:	e9 45 fe ff ff       	jmp    101d77 <__alltraps>

00101f32 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $47
  101f34:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f36:	e9 3c fe ff ff       	jmp    101d77 <__alltraps>

00101f3b <vector48>:
.globl vector48
vector48:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $48
  101f3d:	6a 30                	push   $0x30
  jmp __alltraps
  101f3f:	e9 33 fe ff ff       	jmp    101d77 <__alltraps>

00101f44 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $49
  101f46:	6a 31                	push   $0x31
  jmp __alltraps
  101f48:	e9 2a fe ff ff       	jmp    101d77 <__alltraps>

00101f4d <vector50>:
.globl vector50
vector50:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $50
  101f4f:	6a 32                	push   $0x32
  jmp __alltraps
  101f51:	e9 21 fe ff ff       	jmp    101d77 <__alltraps>

00101f56 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $51
  101f58:	6a 33                	push   $0x33
  jmp __alltraps
  101f5a:	e9 18 fe ff ff       	jmp    101d77 <__alltraps>

00101f5f <vector52>:
.globl vector52
vector52:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $52
  101f61:	6a 34                	push   $0x34
  jmp __alltraps
  101f63:	e9 0f fe ff ff       	jmp    101d77 <__alltraps>

00101f68 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $53
  101f6a:	6a 35                	push   $0x35
  jmp __alltraps
  101f6c:	e9 06 fe ff ff       	jmp    101d77 <__alltraps>

00101f71 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $54
  101f73:	6a 36                	push   $0x36
  jmp __alltraps
  101f75:	e9 fd fd ff ff       	jmp    101d77 <__alltraps>

00101f7a <vector55>:
.globl vector55
vector55:
  pushl $0
  101f7a:	6a 00                	push   $0x0
  pushl $55
  101f7c:	6a 37                	push   $0x37
  jmp __alltraps
  101f7e:	e9 f4 fd ff ff       	jmp    101d77 <__alltraps>

00101f83 <vector56>:
.globl vector56
vector56:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $56
  101f85:	6a 38                	push   $0x38
  jmp __alltraps
  101f87:	e9 eb fd ff ff       	jmp    101d77 <__alltraps>

00101f8c <vector57>:
.globl vector57
vector57:
  pushl $0
  101f8c:	6a 00                	push   $0x0
  pushl $57
  101f8e:	6a 39                	push   $0x39
  jmp __alltraps
  101f90:	e9 e2 fd ff ff       	jmp    101d77 <__alltraps>

00101f95 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f95:	6a 00                	push   $0x0
  pushl $58
  101f97:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f99:	e9 d9 fd ff ff       	jmp    101d77 <__alltraps>

00101f9e <vector59>:
.globl vector59
vector59:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $59
  101fa0:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fa2:	e9 d0 fd ff ff       	jmp    101d77 <__alltraps>

00101fa7 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $60
  101fa9:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fab:	e9 c7 fd ff ff       	jmp    101d77 <__alltraps>

00101fb0 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $61
  101fb2:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fb4:	e9 be fd ff ff       	jmp    101d77 <__alltraps>

00101fb9 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $62
  101fbb:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fbd:	e9 b5 fd ff ff       	jmp    101d77 <__alltraps>

00101fc2 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $63
  101fc4:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fc6:	e9 ac fd ff ff       	jmp    101d77 <__alltraps>

00101fcb <vector64>:
.globl vector64
vector64:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $64
  101fcd:	6a 40                	push   $0x40
  jmp __alltraps
  101fcf:	e9 a3 fd ff ff       	jmp    101d77 <__alltraps>

00101fd4 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $65
  101fd6:	6a 41                	push   $0x41
  jmp __alltraps
  101fd8:	e9 9a fd ff ff       	jmp    101d77 <__alltraps>

00101fdd <vector66>:
.globl vector66
vector66:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $66
  101fdf:	6a 42                	push   $0x42
  jmp __alltraps
  101fe1:	e9 91 fd ff ff       	jmp    101d77 <__alltraps>

00101fe6 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $67
  101fe8:	6a 43                	push   $0x43
  jmp __alltraps
  101fea:	e9 88 fd ff ff       	jmp    101d77 <__alltraps>

00101fef <vector68>:
.globl vector68
vector68:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $68
  101ff1:	6a 44                	push   $0x44
  jmp __alltraps
  101ff3:	e9 7f fd ff ff       	jmp    101d77 <__alltraps>

00101ff8 <vector69>:
.globl vector69
vector69:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $69
  101ffa:	6a 45                	push   $0x45
  jmp __alltraps
  101ffc:	e9 76 fd ff ff       	jmp    101d77 <__alltraps>

00102001 <vector70>:
.globl vector70
vector70:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $70
  102003:	6a 46                	push   $0x46
  jmp __alltraps
  102005:	e9 6d fd ff ff       	jmp    101d77 <__alltraps>

0010200a <vector71>:
.globl vector71
vector71:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $71
  10200c:	6a 47                	push   $0x47
  jmp __alltraps
  10200e:	e9 64 fd ff ff       	jmp    101d77 <__alltraps>

00102013 <vector72>:
.globl vector72
vector72:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $72
  102015:	6a 48                	push   $0x48
  jmp __alltraps
  102017:	e9 5b fd ff ff       	jmp    101d77 <__alltraps>

0010201c <vector73>:
.globl vector73
vector73:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $73
  10201e:	6a 49                	push   $0x49
  jmp __alltraps
  102020:	e9 52 fd ff ff       	jmp    101d77 <__alltraps>

00102025 <vector74>:
.globl vector74
vector74:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $74
  102027:	6a 4a                	push   $0x4a
  jmp __alltraps
  102029:	e9 49 fd ff ff       	jmp    101d77 <__alltraps>

0010202e <vector75>:
.globl vector75
vector75:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $75
  102030:	6a 4b                	push   $0x4b
  jmp __alltraps
  102032:	e9 40 fd ff ff       	jmp    101d77 <__alltraps>

00102037 <vector76>:
.globl vector76
vector76:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $76
  102039:	6a 4c                	push   $0x4c
  jmp __alltraps
  10203b:	e9 37 fd ff ff       	jmp    101d77 <__alltraps>

00102040 <vector77>:
.globl vector77
vector77:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $77
  102042:	6a 4d                	push   $0x4d
  jmp __alltraps
  102044:	e9 2e fd ff ff       	jmp    101d77 <__alltraps>

00102049 <vector78>:
.globl vector78
vector78:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $78
  10204b:	6a 4e                	push   $0x4e
  jmp __alltraps
  10204d:	e9 25 fd ff ff       	jmp    101d77 <__alltraps>

00102052 <vector79>:
.globl vector79
vector79:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $79
  102054:	6a 4f                	push   $0x4f
  jmp __alltraps
  102056:	e9 1c fd ff ff       	jmp    101d77 <__alltraps>

0010205b <vector80>:
.globl vector80
vector80:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $80
  10205d:	6a 50                	push   $0x50
  jmp __alltraps
  10205f:	e9 13 fd ff ff       	jmp    101d77 <__alltraps>

00102064 <vector81>:
.globl vector81
vector81:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $81
  102066:	6a 51                	push   $0x51
  jmp __alltraps
  102068:	e9 0a fd ff ff       	jmp    101d77 <__alltraps>

0010206d <vector82>:
.globl vector82
vector82:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $82
  10206f:	6a 52                	push   $0x52
  jmp __alltraps
  102071:	e9 01 fd ff ff       	jmp    101d77 <__alltraps>

00102076 <vector83>:
.globl vector83
vector83:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $83
  102078:	6a 53                	push   $0x53
  jmp __alltraps
  10207a:	e9 f8 fc ff ff       	jmp    101d77 <__alltraps>

0010207f <vector84>:
.globl vector84
vector84:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $84
  102081:	6a 54                	push   $0x54
  jmp __alltraps
  102083:	e9 ef fc ff ff       	jmp    101d77 <__alltraps>

00102088 <vector85>:
.globl vector85
vector85:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $85
  10208a:	6a 55                	push   $0x55
  jmp __alltraps
  10208c:	e9 e6 fc ff ff       	jmp    101d77 <__alltraps>

00102091 <vector86>:
.globl vector86
vector86:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $86
  102093:	6a 56                	push   $0x56
  jmp __alltraps
  102095:	e9 dd fc ff ff       	jmp    101d77 <__alltraps>

0010209a <vector87>:
.globl vector87
vector87:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $87
  10209c:	6a 57                	push   $0x57
  jmp __alltraps
  10209e:	e9 d4 fc ff ff       	jmp    101d77 <__alltraps>

001020a3 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $88
  1020a5:	6a 58                	push   $0x58
  jmp __alltraps
  1020a7:	e9 cb fc ff ff       	jmp    101d77 <__alltraps>

001020ac <vector89>:
.globl vector89
vector89:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $89
  1020ae:	6a 59                	push   $0x59
  jmp __alltraps
  1020b0:	e9 c2 fc ff ff       	jmp    101d77 <__alltraps>

001020b5 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $90
  1020b7:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020b9:	e9 b9 fc ff ff       	jmp    101d77 <__alltraps>

001020be <vector91>:
.globl vector91
vector91:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $91
  1020c0:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020c2:	e9 b0 fc ff ff       	jmp    101d77 <__alltraps>

001020c7 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $92
  1020c9:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020cb:	e9 a7 fc ff ff       	jmp    101d77 <__alltraps>

001020d0 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $93
  1020d2:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020d4:	e9 9e fc ff ff       	jmp    101d77 <__alltraps>

001020d9 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $94
  1020db:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020dd:	e9 95 fc ff ff       	jmp    101d77 <__alltraps>

001020e2 <vector95>:
.globl vector95
vector95:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $95
  1020e4:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020e6:	e9 8c fc ff ff       	jmp    101d77 <__alltraps>

001020eb <vector96>:
.globl vector96
vector96:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $96
  1020ed:	6a 60                	push   $0x60
  jmp __alltraps
  1020ef:	e9 83 fc ff ff       	jmp    101d77 <__alltraps>

001020f4 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $97
  1020f6:	6a 61                	push   $0x61
  jmp __alltraps
  1020f8:	e9 7a fc ff ff       	jmp    101d77 <__alltraps>

001020fd <vector98>:
.globl vector98
vector98:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $98
  1020ff:	6a 62                	push   $0x62
  jmp __alltraps
  102101:	e9 71 fc ff ff       	jmp    101d77 <__alltraps>

00102106 <vector99>:
.globl vector99
vector99:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $99
  102108:	6a 63                	push   $0x63
  jmp __alltraps
  10210a:	e9 68 fc ff ff       	jmp    101d77 <__alltraps>

0010210f <vector100>:
.globl vector100
vector100:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $100
  102111:	6a 64                	push   $0x64
  jmp __alltraps
  102113:	e9 5f fc ff ff       	jmp    101d77 <__alltraps>

00102118 <vector101>:
.globl vector101
vector101:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $101
  10211a:	6a 65                	push   $0x65
  jmp __alltraps
  10211c:	e9 56 fc ff ff       	jmp    101d77 <__alltraps>

00102121 <vector102>:
.globl vector102
vector102:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $102
  102123:	6a 66                	push   $0x66
  jmp __alltraps
  102125:	e9 4d fc ff ff       	jmp    101d77 <__alltraps>

0010212a <vector103>:
.globl vector103
vector103:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $103
  10212c:	6a 67                	push   $0x67
  jmp __alltraps
  10212e:	e9 44 fc ff ff       	jmp    101d77 <__alltraps>

00102133 <vector104>:
.globl vector104
vector104:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $104
  102135:	6a 68                	push   $0x68
  jmp __alltraps
  102137:	e9 3b fc ff ff       	jmp    101d77 <__alltraps>

0010213c <vector105>:
.globl vector105
vector105:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $105
  10213e:	6a 69                	push   $0x69
  jmp __alltraps
  102140:	e9 32 fc ff ff       	jmp    101d77 <__alltraps>

00102145 <vector106>:
.globl vector106
vector106:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $106
  102147:	6a 6a                	push   $0x6a
  jmp __alltraps
  102149:	e9 29 fc ff ff       	jmp    101d77 <__alltraps>

0010214e <vector107>:
.globl vector107
vector107:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $107
  102150:	6a 6b                	push   $0x6b
  jmp __alltraps
  102152:	e9 20 fc ff ff       	jmp    101d77 <__alltraps>

00102157 <vector108>:
.globl vector108
vector108:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $108
  102159:	6a 6c                	push   $0x6c
  jmp __alltraps
  10215b:	e9 17 fc ff ff       	jmp    101d77 <__alltraps>

00102160 <vector109>:
.globl vector109
vector109:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $109
  102162:	6a 6d                	push   $0x6d
  jmp __alltraps
  102164:	e9 0e fc ff ff       	jmp    101d77 <__alltraps>

00102169 <vector110>:
.globl vector110
vector110:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $110
  10216b:	6a 6e                	push   $0x6e
  jmp __alltraps
  10216d:	e9 05 fc ff ff       	jmp    101d77 <__alltraps>

00102172 <vector111>:
.globl vector111
vector111:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $111
  102174:	6a 6f                	push   $0x6f
  jmp __alltraps
  102176:	e9 fc fb ff ff       	jmp    101d77 <__alltraps>

0010217b <vector112>:
.globl vector112
vector112:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $112
  10217d:	6a 70                	push   $0x70
  jmp __alltraps
  10217f:	e9 f3 fb ff ff       	jmp    101d77 <__alltraps>

00102184 <vector113>:
.globl vector113
vector113:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $113
  102186:	6a 71                	push   $0x71
  jmp __alltraps
  102188:	e9 ea fb ff ff       	jmp    101d77 <__alltraps>

0010218d <vector114>:
.globl vector114
vector114:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $114
  10218f:	6a 72                	push   $0x72
  jmp __alltraps
  102191:	e9 e1 fb ff ff       	jmp    101d77 <__alltraps>

00102196 <vector115>:
.globl vector115
vector115:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $115
  102198:	6a 73                	push   $0x73
  jmp __alltraps
  10219a:	e9 d8 fb ff ff       	jmp    101d77 <__alltraps>

0010219f <vector116>:
.globl vector116
vector116:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $116
  1021a1:	6a 74                	push   $0x74
  jmp __alltraps
  1021a3:	e9 cf fb ff ff       	jmp    101d77 <__alltraps>

001021a8 <vector117>:
.globl vector117
vector117:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $117
  1021aa:	6a 75                	push   $0x75
  jmp __alltraps
  1021ac:	e9 c6 fb ff ff       	jmp    101d77 <__alltraps>

001021b1 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $118
  1021b3:	6a 76                	push   $0x76
  jmp __alltraps
  1021b5:	e9 bd fb ff ff       	jmp    101d77 <__alltraps>

001021ba <vector119>:
.globl vector119
vector119:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $119
  1021bc:	6a 77                	push   $0x77
  jmp __alltraps
  1021be:	e9 b4 fb ff ff       	jmp    101d77 <__alltraps>

001021c3 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $120
  1021c5:	6a 78                	push   $0x78
  jmp __alltraps
  1021c7:	e9 ab fb ff ff       	jmp    101d77 <__alltraps>

001021cc <vector121>:
.globl vector121
vector121:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $121
  1021ce:	6a 79                	push   $0x79
  jmp __alltraps
  1021d0:	e9 a2 fb ff ff       	jmp    101d77 <__alltraps>

001021d5 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $122
  1021d7:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021d9:	e9 99 fb ff ff       	jmp    101d77 <__alltraps>

001021de <vector123>:
.globl vector123
vector123:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $123
  1021e0:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021e2:	e9 90 fb ff ff       	jmp    101d77 <__alltraps>

001021e7 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $124
  1021e9:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021eb:	e9 87 fb ff ff       	jmp    101d77 <__alltraps>

001021f0 <vector125>:
.globl vector125
vector125:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $125
  1021f2:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021f4:	e9 7e fb ff ff       	jmp    101d77 <__alltraps>

001021f9 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $126
  1021fb:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021fd:	e9 75 fb ff ff       	jmp    101d77 <__alltraps>

00102202 <vector127>:
.globl vector127
vector127:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $127
  102204:	6a 7f                	push   $0x7f
  jmp __alltraps
  102206:	e9 6c fb ff ff       	jmp    101d77 <__alltraps>

0010220b <vector128>:
.globl vector128
vector128:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $128
  10220d:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102212:	e9 60 fb ff ff       	jmp    101d77 <__alltraps>

00102217 <vector129>:
.globl vector129
vector129:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $129
  102219:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10221e:	e9 54 fb ff ff       	jmp    101d77 <__alltraps>

00102223 <vector130>:
.globl vector130
vector130:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $130
  102225:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10222a:	e9 48 fb ff ff       	jmp    101d77 <__alltraps>

0010222f <vector131>:
.globl vector131
vector131:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $131
  102231:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102236:	e9 3c fb ff ff       	jmp    101d77 <__alltraps>

0010223b <vector132>:
.globl vector132
vector132:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $132
  10223d:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102242:	e9 30 fb ff ff       	jmp    101d77 <__alltraps>

00102247 <vector133>:
.globl vector133
vector133:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $133
  102249:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10224e:	e9 24 fb ff ff       	jmp    101d77 <__alltraps>

00102253 <vector134>:
.globl vector134
vector134:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $134
  102255:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10225a:	e9 18 fb ff ff       	jmp    101d77 <__alltraps>

0010225f <vector135>:
.globl vector135
vector135:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $135
  102261:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102266:	e9 0c fb ff ff       	jmp    101d77 <__alltraps>

0010226b <vector136>:
.globl vector136
vector136:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $136
  10226d:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102272:	e9 00 fb ff ff       	jmp    101d77 <__alltraps>

00102277 <vector137>:
.globl vector137
vector137:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $137
  102279:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10227e:	e9 f4 fa ff ff       	jmp    101d77 <__alltraps>

00102283 <vector138>:
.globl vector138
vector138:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $138
  102285:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10228a:	e9 e8 fa ff ff       	jmp    101d77 <__alltraps>

0010228f <vector139>:
.globl vector139
vector139:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $139
  102291:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102296:	e9 dc fa ff ff       	jmp    101d77 <__alltraps>

0010229b <vector140>:
.globl vector140
vector140:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $140
  10229d:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022a2:	e9 d0 fa ff ff       	jmp    101d77 <__alltraps>

001022a7 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $141
  1022a9:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022ae:	e9 c4 fa ff ff       	jmp    101d77 <__alltraps>

001022b3 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $142
  1022b5:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022ba:	e9 b8 fa ff ff       	jmp    101d77 <__alltraps>

001022bf <vector143>:
.globl vector143
vector143:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $143
  1022c1:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022c6:	e9 ac fa ff ff       	jmp    101d77 <__alltraps>

001022cb <vector144>:
.globl vector144
vector144:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $144
  1022cd:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022d2:	e9 a0 fa ff ff       	jmp    101d77 <__alltraps>

001022d7 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $145
  1022d9:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022de:	e9 94 fa ff ff       	jmp    101d77 <__alltraps>

001022e3 <vector146>:
.globl vector146
vector146:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $146
  1022e5:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022ea:	e9 88 fa ff ff       	jmp    101d77 <__alltraps>

001022ef <vector147>:
.globl vector147
vector147:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $147
  1022f1:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022f6:	e9 7c fa ff ff       	jmp    101d77 <__alltraps>

001022fb <vector148>:
.globl vector148
vector148:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $148
  1022fd:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102302:	e9 70 fa ff ff       	jmp    101d77 <__alltraps>

00102307 <vector149>:
.globl vector149
vector149:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $149
  102309:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10230e:	e9 64 fa ff ff       	jmp    101d77 <__alltraps>

00102313 <vector150>:
.globl vector150
vector150:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $150
  102315:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10231a:	e9 58 fa ff ff       	jmp    101d77 <__alltraps>

0010231f <vector151>:
.globl vector151
vector151:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $151
  102321:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102326:	e9 4c fa ff ff       	jmp    101d77 <__alltraps>

0010232b <vector152>:
.globl vector152
vector152:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $152
  10232d:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102332:	e9 40 fa ff ff       	jmp    101d77 <__alltraps>

00102337 <vector153>:
.globl vector153
vector153:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $153
  102339:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10233e:	e9 34 fa ff ff       	jmp    101d77 <__alltraps>

00102343 <vector154>:
.globl vector154
vector154:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $154
  102345:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10234a:	e9 28 fa ff ff       	jmp    101d77 <__alltraps>

0010234f <vector155>:
.globl vector155
vector155:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $155
  102351:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102356:	e9 1c fa ff ff       	jmp    101d77 <__alltraps>

0010235b <vector156>:
.globl vector156
vector156:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $156
  10235d:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102362:	e9 10 fa ff ff       	jmp    101d77 <__alltraps>

00102367 <vector157>:
.globl vector157
vector157:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $157
  102369:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10236e:	e9 04 fa ff ff       	jmp    101d77 <__alltraps>

00102373 <vector158>:
.globl vector158
vector158:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $158
  102375:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10237a:	e9 f8 f9 ff ff       	jmp    101d77 <__alltraps>

0010237f <vector159>:
.globl vector159
vector159:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $159
  102381:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102386:	e9 ec f9 ff ff       	jmp    101d77 <__alltraps>

0010238b <vector160>:
.globl vector160
vector160:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $160
  10238d:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102392:	e9 e0 f9 ff ff       	jmp    101d77 <__alltraps>

00102397 <vector161>:
.globl vector161
vector161:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $161
  102399:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10239e:	e9 d4 f9 ff ff       	jmp    101d77 <__alltraps>

001023a3 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $162
  1023a5:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023aa:	e9 c8 f9 ff ff       	jmp    101d77 <__alltraps>

001023af <vector163>:
.globl vector163
vector163:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $163
  1023b1:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023b6:	e9 bc f9 ff ff       	jmp    101d77 <__alltraps>

001023bb <vector164>:
.globl vector164
vector164:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $164
  1023bd:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023c2:	e9 b0 f9 ff ff       	jmp    101d77 <__alltraps>

001023c7 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $165
  1023c9:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023ce:	e9 a4 f9 ff ff       	jmp    101d77 <__alltraps>

001023d3 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $166
  1023d5:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023da:	e9 98 f9 ff ff       	jmp    101d77 <__alltraps>

001023df <vector167>:
.globl vector167
vector167:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $167
  1023e1:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023e6:	e9 8c f9 ff ff       	jmp    101d77 <__alltraps>

001023eb <vector168>:
.globl vector168
vector168:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $168
  1023ed:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023f2:	e9 80 f9 ff ff       	jmp    101d77 <__alltraps>

001023f7 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $169
  1023f9:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023fe:	e9 74 f9 ff ff       	jmp    101d77 <__alltraps>

00102403 <vector170>:
.globl vector170
vector170:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $170
  102405:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10240a:	e9 68 f9 ff ff       	jmp    101d77 <__alltraps>

0010240f <vector171>:
.globl vector171
vector171:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $171
  102411:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102416:	e9 5c f9 ff ff       	jmp    101d77 <__alltraps>

0010241b <vector172>:
.globl vector172
vector172:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $172
  10241d:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102422:	e9 50 f9 ff ff       	jmp    101d77 <__alltraps>

00102427 <vector173>:
.globl vector173
vector173:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $173
  102429:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10242e:	e9 44 f9 ff ff       	jmp    101d77 <__alltraps>

00102433 <vector174>:
.globl vector174
vector174:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $174
  102435:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10243a:	e9 38 f9 ff ff       	jmp    101d77 <__alltraps>

0010243f <vector175>:
.globl vector175
vector175:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $175
  102441:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102446:	e9 2c f9 ff ff       	jmp    101d77 <__alltraps>

0010244b <vector176>:
.globl vector176
vector176:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $176
  10244d:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102452:	e9 20 f9 ff ff       	jmp    101d77 <__alltraps>

00102457 <vector177>:
.globl vector177
vector177:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $177
  102459:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10245e:	e9 14 f9 ff ff       	jmp    101d77 <__alltraps>

00102463 <vector178>:
.globl vector178
vector178:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $178
  102465:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10246a:	e9 08 f9 ff ff       	jmp    101d77 <__alltraps>

0010246f <vector179>:
.globl vector179
vector179:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $179
  102471:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102476:	e9 fc f8 ff ff       	jmp    101d77 <__alltraps>

0010247b <vector180>:
.globl vector180
vector180:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $180
  10247d:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102482:	e9 f0 f8 ff ff       	jmp    101d77 <__alltraps>

00102487 <vector181>:
.globl vector181
vector181:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $181
  102489:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10248e:	e9 e4 f8 ff ff       	jmp    101d77 <__alltraps>

00102493 <vector182>:
.globl vector182
vector182:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $182
  102495:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10249a:	e9 d8 f8 ff ff       	jmp    101d77 <__alltraps>

0010249f <vector183>:
.globl vector183
vector183:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $183
  1024a1:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024a6:	e9 cc f8 ff ff       	jmp    101d77 <__alltraps>

001024ab <vector184>:
.globl vector184
vector184:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $184
  1024ad:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024b2:	e9 c0 f8 ff ff       	jmp    101d77 <__alltraps>

001024b7 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $185
  1024b9:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024be:	e9 b4 f8 ff ff       	jmp    101d77 <__alltraps>

001024c3 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $186
  1024c5:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024ca:	e9 a8 f8 ff ff       	jmp    101d77 <__alltraps>

001024cf <vector187>:
.globl vector187
vector187:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $187
  1024d1:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024d6:	e9 9c f8 ff ff       	jmp    101d77 <__alltraps>

001024db <vector188>:
.globl vector188
vector188:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $188
  1024dd:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024e2:	e9 90 f8 ff ff       	jmp    101d77 <__alltraps>

001024e7 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $189
  1024e9:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024ee:	e9 84 f8 ff ff       	jmp    101d77 <__alltraps>

001024f3 <vector190>:
.globl vector190
vector190:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $190
  1024f5:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024fa:	e9 78 f8 ff ff       	jmp    101d77 <__alltraps>

001024ff <vector191>:
.globl vector191
vector191:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $191
  102501:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102506:	e9 6c f8 ff ff       	jmp    101d77 <__alltraps>

0010250b <vector192>:
.globl vector192
vector192:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $192
  10250d:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102512:	e9 60 f8 ff ff       	jmp    101d77 <__alltraps>

00102517 <vector193>:
.globl vector193
vector193:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $193
  102519:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10251e:	e9 54 f8 ff ff       	jmp    101d77 <__alltraps>

00102523 <vector194>:
.globl vector194
vector194:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $194
  102525:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10252a:	e9 48 f8 ff ff       	jmp    101d77 <__alltraps>

0010252f <vector195>:
.globl vector195
vector195:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $195
  102531:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102536:	e9 3c f8 ff ff       	jmp    101d77 <__alltraps>

0010253b <vector196>:
.globl vector196
vector196:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $196
  10253d:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102542:	e9 30 f8 ff ff       	jmp    101d77 <__alltraps>

00102547 <vector197>:
.globl vector197
vector197:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $197
  102549:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10254e:	e9 24 f8 ff ff       	jmp    101d77 <__alltraps>

00102553 <vector198>:
.globl vector198
vector198:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $198
  102555:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10255a:	e9 18 f8 ff ff       	jmp    101d77 <__alltraps>

0010255f <vector199>:
.globl vector199
vector199:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $199
  102561:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102566:	e9 0c f8 ff ff       	jmp    101d77 <__alltraps>

0010256b <vector200>:
.globl vector200
vector200:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $200
  10256d:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102572:	e9 00 f8 ff ff       	jmp    101d77 <__alltraps>

00102577 <vector201>:
.globl vector201
vector201:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $201
  102579:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10257e:	e9 f4 f7 ff ff       	jmp    101d77 <__alltraps>

00102583 <vector202>:
.globl vector202
vector202:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $202
  102585:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10258a:	e9 e8 f7 ff ff       	jmp    101d77 <__alltraps>

0010258f <vector203>:
.globl vector203
vector203:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $203
  102591:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102596:	e9 dc f7 ff ff       	jmp    101d77 <__alltraps>

0010259b <vector204>:
.globl vector204
vector204:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $204
  10259d:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025a2:	e9 d0 f7 ff ff       	jmp    101d77 <__alltraps>

001025a7 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $205
  1025a9:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025ae:	e9 c4 f7 ff ff       	jmp    101d77 <__alltraps>

001025b3 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $206
  1025b5:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025ba:	e9 b8 f7 ff ff       	jmp    101d77 <__alltraps>

001025bf <vector207>:
.globl vector207
vector207:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $207
  1025c1:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025c6:	e9 ac f7 ff ff       	jmp    101d77 <__alltraps>

001025cb <vector208>:
.globl vector208
vector208:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $208
  1025cd:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025d2:	e9 a0 f7 ff ff       	jmp    101d77 <__alltraps>

001025d7 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $209
  1025d9:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025de:	e9 94 f7 ff ff       	jmp    101d77 <__alltraps>

001025e3 <vector210>:
.globl vector210
vector210:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $210
  1025e5:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025ea:	e9 88 f7 ff ff       	jmp    101d77 <__alltraps>

001025ef <vector211>:
.globl vector211
vector211:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $211
  1025f1:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025f6:	e9 7c f7 ff ff       	jmp    101d77 <__alltraps>

001025fb <vector212>:
.globl vector212
vector212:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $212
  1025fd:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102602:	e9 70 f7 ff ff       	jmp    101d77 <__alltraps>

00102607 <vector213>:
.globl vector213
vector213:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $213
  102609:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10260e:	e9 64 f7 ff ff       	jmp    101d77 <__alltraps>

00102613 <vector214>:
.globl vector214
vector214:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $214
  102615:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10261a:	e9 58 f7 ff ff       	jmp    101d77 <__alltraps>

0010261f <vector215>:
.globl vector215
vector215:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $215
  102621:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102626:	e9 4c f7 ff ff       	jmp    101d77 <__alltraps>

0010262b <vector216>:
.globl vector216
vector216:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $216
  10262d:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102632:	e9 40 f7 ff ff       	jmp    101d77 <__alltraps>

00102637 <vector217>:
.globl vector217
vector217:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $217
  102639:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10263e:	e9 34 f7 ff ff       	jmp    101d77 <__alltraps>

00102643 <vector218>:
.globl vector218
vector218:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $218
  102645:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10264a:	e9 28 f7 ff ff       	jmp    101d77 <__alltraps>

0010264f <vector219>:
.globl vector219
vector219:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $219
  102651:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102656:	e9 1c f7 ff ff       	jmp    101d77 <__alltraps>

0010265b <vector220>:
.globl vector220
vector220:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $220
  10265d:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102662:	e9 10 f7 ff ff       	jmp    101d77 <__alltraps>

00102667 <vector221>:
.globl vector221
vector221:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $221
  102669:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10266e:	e9 04 f7 ff ff       	jmp    101d77 <__alltraps>

00102673 <vector222>:
.globl vector222
vector222:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $222
  102675:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10267a:	e9 f8 f6 ff ff       	jmp    101d77 <__alltraps>

0010267f <vector223>:
.globl vector223
vector223:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $223
  102681:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102686:	e9 ec f6 ff ff       	jmp    101d77 <__alltraps>

0010268b <vector224>:
.globl vector224
vector224:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $224
  10268d:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102692:	e9 e0 f6 ff ff       	jmp    101d77 <__alltraps>

00102697 <vector225>:
.globl vector225
vector225:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $225
  102699:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10269e:	e9 d4 f6 ff ff       	jmp    101d77 <__alltraps>

001026a3 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $226
  1026a5:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026aa:	e9 c8 f6 ff ff       	jmp    101d77 <__alltraps>

001026af <vector227>:
.globl vector227
vector227:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $227
  1026b1:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026b6:	e9 bc f6 ff ff       	jmp    101d77 <__alltraps>

001026bb <vector228>:
.globl vector228
vector228:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $228
  1026bd:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026c2:	e9 b0 f6 ff ff       	jmp    101d77 <__alltraps>

001026c7 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $229
  1026c9:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026ce:	e9 a4 f6 ff ff       	jmp    101d77 <__alltraps>

001026d3 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $230
  1026d5:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026da:	e9 98 f6 ff ff       	jmp    101d77 <__alltraps>

001026df <vector231>:
.globl vector231
vector231:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $231
  1026e1:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026e6:	e9 8c f6 ff ff       	jmp    101d77 <__alltraps>

001026eb <vector232>:
.globl vector232
vector232:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $232
  1026ed:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026f2:	e9 80 f6 ff ff       	jmp    101d77 <__alltraps>

001026f7 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $233
  1026f9:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026fe:	e9 74 f6 ff ff       	jmp    101d77 <__alltraps>

00102703 <vector234>:
.globl vector234
vector234:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $234
  102705:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10270a:	e9 68 f6 ff ff       	jmp    101d77 <__alltraps>

0010270f <vector235>:
.globl vector235
vector235:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $235
  102711:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102716:	e9 5c f6 ff ff       	jmp    101d77 <__alltraps>

0010271b <vector236>:
.globl vector236
vector236:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $236
  10271d:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102722:	e9 50 f6 ff ff       	jmp    101d77 <__alltraps>

00102727 <vector237>:
.globl vector237
vector237:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $237
  102729:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10272e:	e9 44 f6 ff ff       	jmp    101d77 <__alltraps>

00102733 <vector238>:
.globl vector238
vector238:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $238
  102735:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10273a:	e9 38 f6 ff ff       	jmp    101d77 <__alltraps>

0010273f <vector239>:
.globl vector239
vector239:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $239
  102741:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102746:	e9 2c f6 ff ff       	jmp    101d77 <__alltraps>

0010274b <vector240>:
.globl vector240
vector240:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $240
  10274d:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102752:	e9 20 f6 ff ff       	jmp    101d77 <__alltraps>

00102757 <vector241>:
.globl vector241
vector241:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $241
  102759:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10275e:	e9 14 f6 ff ff       	jmp    101d77 <__alltraps>

00102763 <vector242>:
.globl vector242
vector242:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $242
  102765:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10276a:	e9 08 f6 ff ff       	jmp    101d77 <__alltraps>

0010276f <vector243>:
.globl vector243
vector243:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $243
  102771:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102776:	e9 fc f5 ff ff       	jmp    101d77 <__alltraps>

0010277b <vector244>:
.globl vector244
vector244:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $244
  10277d:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102782:	e9 f0 f5 ff ff       	jmp    101d77 <__alltraps>

00102787 <vector245>:
.globl vector245
vector245:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $245
  102789:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10278e:	e9 e4 f5 ff ff       	jmp    101d77 <__alltraps>

00102793 <vector246>:
.globl vector246
vector246:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $246
  102795:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10279a:	e9 d8 f5 ff ff       	jmp    101d77 <__alltraps>

0010279f <vector247>:
.globl vector247
vector247:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $247
  1027a1:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027a6:	e9 cc f5 ff ff       	jmp    101d77 <__alltraps>

001027ab <vector248>:
.globl vector248
vector248:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $248
  1027ad:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027b2:	e9 c0 f5 ff ff       	jmp    101d77 <__alltraps>

001027b7 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $249
  1027b9:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027be:	e9 b4 f5 ff ff       	jmp    101d77 <__alltraps>

001027c3 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $250
  1027c5:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027ca:	e9 a8 f5 ff ff       	jmp    101d77 <__alltraps>

001027cf <vector251>:
.globl vector251
vector251:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $251
  1027d1:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027d6:	e9 9c f5 ff ff       	jmp    101d77 <__alltraps>

001027db <vector252>:
.globl vector252
vector252:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $252
  1027dd:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027e2:	e9 90 f5 ff ff       	jmp    101d77 <__alltraps>

001027e7 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $253
  1027e9:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027ee:	e9 84 f5 ff ff       	jmp    101d77 <__alltraps>

001027f3 <vector254>:
.globl vector254
vector254:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $254
  1027f5:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027fa:	e9 78 f5 ff ff       	jmp    101d77 <__alltraps>

001027ff <vector255>:
.globl vector255
vector255:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $255
  102801:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102806:	e9 6c f5 ff ff       	jmp    101d77 <__alltraps>

0010280b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10280b:	55                   	push   %ebp
  10280c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10280e:	8b 45 08             	mov    0x8(%ebp),%eax
  102811:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102814:	b8 23 00 00 00       	mov    $0x23,%eax
  102819:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10281b:	b8 23 00 00 00       	mov    $0x23,%eax
  102820:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102822:	b8 10 00 00 00       	mov    $0x10,%eax
  102827:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102829:	b8 10 00 00 00       	mov    $0x10,%eax
  10282e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102830:	b8 10 00 00 00       	mov    $0x10,%eax
  102835:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102837:	ea 3e 28 10 00 08 00 	ljmp   $0x8,$0x10283e
}
  10283e:	5d                   	pop    %ebp
  10283f:	c3                   	ret    

00102840 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102840:	55                   	push   %ebp
  102841:	89 e5                	mov    %esp,%ebp
  102843:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102846:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  10284b:	05 00 04 00 00       	add    $0x400,%eax
  102850:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102855:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  10285c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10285e:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102865:	68 00 
  102867:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10286c:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102872:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102877:	c1 e8 10             	shr    $0x10,%eax
  10287a:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10287f:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102886:	83 e0 f0             	and    $0xfffffff0,%eax
  102889:	83 c8 09             	or     $0x9,%eax
  10288c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102891:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102898:	83 c8 10             	or     $0x10,%eax
  10289b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028a0:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028a7:	83 e0 9f             	and    $0xffffff9f,%eax
  1028aa:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028af:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028b6:	83 c8 80             	or     $0xffffff80,%eax
  1028b9:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028be:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028c5:	83 e0 f0             	and    $0xfffffff0,%eax
  1028c8:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028cd:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028d4:	83 e0 ef             	and    $0xffffffef,%eax
  1028d7:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028dc:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028e3:	83 e0 df             	and    $0xffffffdf,%eax
  1028e6:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028eb:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028f2:	83 c8 40             	or     $0x40,%eax
  1028f5:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028fa:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102901:	83 e0 7f             	and    $0x7f,%eax
  102904:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102909:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10290e:	c1 e8 18             	shr    $0x18,%eax
  102911:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102916:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10291d:	83 e0 ef             	and    $0xffffffef,%eax
  102920:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102925:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10292c:	e8 da fe ff ff       	call   10280b <lgdt>
  102931:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102937:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10293b:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10293e:	c9                   	leave  
  10293f:	c3                   	ret    

00102940 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102940:	55                   	push   %ebp
  102941:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102943:	e8 f8 fe ff ff       	call   102840 <gdt_init>
}
  102948:	5d                   	pop    %ebp
  102949:	c3                   	ret    

0010294a <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10294a:	55                   	push   %ebp
  10294b:	89 e5                	mov    %esp,%ebp
  10294d:	83 ec 58             	sub    $0x58,%esp
  102950:	8b 45 10             	mov    0x10(%ebp),%eax
  102953:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102956:	8b 45 14             	mov    0x14(%ebp),%eax
  102959:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10295c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10295f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102962:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102965:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102968:	8b 45 18             	mov    0x18(%ebp),%eax
  10296b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10296e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102971:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102974:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102977:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10297d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102984:	74 1c                	je     1029a2 <printnum+0x58>
  102986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102989:	ba 00 00 00 00       	mov    $0x0,%edx
  10298e:	f7 75 e4             	divl   -0x1c(%ebp)
  102991:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102997:	ba 00 00 00 00       	mov    $0x0,%edx
  10299c:	f7 75 e4             	divl   -0x1c(%ebp)
  10299f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029a8:	f7 75 e4             	divl   -0x1c(%ebp)
  1029ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029ba:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029c0:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029c3:	8b 45 18             	mov    0x18(%ebp),%eax
  1029c6:	ba 00 00 00 00       	mov    $0x0,%edx
  1029cb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029ce:	77 56                	ja     102a26 <printnum+0xdc>
  1029d0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029d3:	72 05                	jb     1029da <printnum+0x90>
  1029d5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1029d8:	77 4c                	ja     102a26 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1029da:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1029dd:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029e0:	8b 45 20             	mov    0x20(%ebp),%eax
  1029e3:	89 44 24 18          	mov    %eax,0x18(%esp)
  1029e7:	89 54 24 14          	mov    %edx,0x14(%esp)
  1029eb:	8b 45 18             	mov    0x18(%ebp),%eax
  1029ee:	89 44 24 10          	mov    %eax,0x10(%esp)
  1029f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1029fc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102a00:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a07:	8b 45 08             	mov    0x8(%ebp),%eax
  102a0a:	89 04 24             	mov    %eax,(%esp)
  102a0d:	e8 38 ff ff ff       	call   10294a <printnum>
  102a12:	eb 1c                	jmp    102a30 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a14:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a1b:	8b 45 20             	mov    0x20(%ebp),%eax
  102a1e:	89 04 24             	mov    %eax,(%esp)
  102a21:	8b 45 08             	mov    0x8(%ebp),%eax
  102a24:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a26:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a2a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a2e:	7f e4                	jg     102a14 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a30:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a33:	05 30 3c 10 00       	add    $0x103c30,%eax
  102a38:	0f b6 00             	movzbl (%eax),%eax
  102a3b:	0f be c0             	movsbl %al,%eax
  102a3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a41:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a45:	89 04 24             	mov    %eax,(%esp)
  102a48:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4b:	ff d0                	call   *%eax
}
  102a4d:	c9                   	leave  
  102a4e:	c3                   	ret    

00102a4f <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a4f:	55                   	push   %ebp
  102a50:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a52:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a56:	7e 14                	jle    102a6c <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a58:	8b 45 08             	mov    0x8(%ebp),%eax
  102a5b:	8b 00                	mov    (%eax),%eax
  102a5d:	8d 48 08             	lea    0x8(%eax),%ecx
  102a60:	8b 55 08             	mov    0x8(%ebp),%edx
  102a63:	89 0a                	mov    %ecx,(%edx)
  102a65:	8b 50 04             	mov    0x4(%eax),%edx
  102a68:	8b 00                	mov    (%eax),%eax
  102a6a:	eb 30                	jmp    102a9c <getuint+0x4d>
    }
    else if (lflag) {
  102a6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a70:	74 16                	je     102a88 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a72:	8b 45 08             	mov    0x8(%ebp),%eax
  102a75:	8b 00                	mov    (%eax),%eax
  102a77:	8d 48 04             	lea    0x4(%eax),%ecx
  102a7a:	8b 55 08             	mov    0x8(%ebp),%edx
  102a7d:	89 0a                	mov    %ecx,(%edx)
  102a7f:	8b 00                	mov    (%eax),%eax
  102a81:	ba 00 00 00 00       	mov    $0x0,%edx
  102a86:	eb 14                	jmp    102a9c <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a88:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8b:	8b 00                	mov    (%eax),%eax
  102a8d:	8d 48 04             	lea    0x4(%eax),%ecx
  102a90:	8b 55 08             	mov    0x8(%ebp),%edx
  102a93:	89 0a                	mov    %ecx,(%edx)
  102a95:	8b 00                	mov    (%eax),%eax
  102a97:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102a9c:	5d                   	pop    %ebp
  102a9d:	c3                   	ret    

00102a9e <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102a9e:	55                   	push   %ebp
  102a9f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102aa1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102aa5:	7e 14                	jle    102abb <getint+0x1d>
        return va_arg(*ap, long long);
  102aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  102aaa:	8b 00                	mov    (%eax),%eax
  102aac:	8d 48 08             	lea    0x8(%eax),%ecx
  102aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  102ab2:	89 0a                	mov    %ecx,(%edx)
  102ab4:	8b 50 04             	mov    0x4(%eax),%edx
  102ab7:	8b 00                	mov    (%eax),%eax
  102ab9:	eb 28                	jmp    102ae3 <getint+0x45>
    }
    else if (lflag) {
  102abb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102abf:	74 12                	je     102ad3 <getint+0x35>
        return va_arg(*ap, long);
  102ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac4:	8b 00                	mov    (%eax),%eax
  102ac6:	8d 48 04             	lea    0x4(%eax),%ecx
  102ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  102acc:	89 0a                	mov    %ecx,(%edx)
  102ace:	8b 00                	mov    (%eax),%eax
  102ad0:	99                   	cltd   
  102ad1:	eb 10                	jmp    102ae3 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad6:	8b 00                	mov    (%eax),%eax
  102ad8:	8d 48 04             	lea    0x4(%eax),%ecx
  102adb:	8b 55 08             	mov    0x8(%ebp),%edx
  102ade:	89 0a                	mov    %ecx,(%edx)
  102ae0:	8b 00                	mov    (%eax),%eax
  102ae2:	99                   	cltd   
    }
}
  102ae3:	5d                   	pop    %ebp
  102ae4:	c3                   	ret    

00102ae5 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102ae5:	55                   	push   %ebp
  102ae6:	89 e5                	mov    %esp,%ebp
  102ae8:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102aeb:	8d 45 14             	lea    0x14(%ebp),%eax
  102aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102af8:	8b 45 10             	mov    0x10(%ebp),%eax
  102afb:	89 44 24 08          	mov    %eax,0x8(%esp)
  102aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b02:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b06:	8b 45 08             	mov    0x8(%ebp),%eax
  102b09:	89 04 24             	mov    %eax,(%esp)
  102b0c:	e8 02 00 00 00       	call   102b13 <vprintfmt>
    va_end(ap);
}
  102b11:	c9                   	leave  
  102b12:	c3                   	ret    

00102b13 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b13:	55                   	push   %ebp
  102b14:	89 e5                	mov    %esp,%ebp
  102b16:	56                   	push   %esi
  102b17:	53                   	push   %ebx
  102b18:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b1b:	eb 18                	jmp    102b35 <vprintfmt+0x22>
            if (ch == '\0') {
  102b1d:	85 db                	test   %ebx,%ebx
  102b1f:	75 05                	jne    102b26 <vprintfmt+0x13>
                return;
  102b21:	e9 d1 03 00 00       	jmp    102ef7 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b26:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b2d:	89 1c 24             	mov    %ebx,(%esp)
  102b30:	8b 45 08             	mov    0x8(%ebp),%eax
  102b33:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b35:	8b 45 10             	mov    0x10(%ebp),%eax
  102b38:	8d 50 01             	lea    0x1(%eax),%edx
  102b3b:	89 55 10             	mov    %edx,0x10(%ebp)
  102b3e:	0f b6 00             	movzbl (%eax),%eax
  102b41:	0f b6 d8             	movzbl %al,%ebx
  102b44:	83 fb 25             	cmp    $0x25,%ebx
  102b47:	75 d4                	jne    102b1d <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b49:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b4d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b57:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b5a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b61:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b64:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b67:	8b 45 10             	mov    0x10(%ebp),%eax
  102b6a:	8d 50 01             	lea    0x1(%eax),%edx
  102b6d:	89 55 10             	mov    %edx,0x10(%ebp)
  102b70:	0f b6 00             	movzbl (%eax),%eax
  102b73:	0f b6 d8             	movzbl %al,%ebx
  102b76:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b79:	83 f8 55             	cmp    $0x55,%eax
  102b7c:	0f 87 44 03 00 00    	ja     102ec6 <vprintfmt+0x3b3>
  102b82:	8b 04 85 54 3c 10 00 	mov    0x103c54(,%eax,4),%eax
  102b89:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b8b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b8f:	eb d6                	jmp    102b67 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b91:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b95:	eb d0                	jmp    102b67 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b97:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102b9e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ba1:	89 d0                	mov    %edx,%eax
  102ba3:	c1 e0 02             	shl    $0x2,%eax
  102ba6:	01 d0                	add    %edx,%eax
  102ba8:	01 c0                	add    %eax,%eax
  102baa:	01 d8                	add    %ebx,%eax
  102bac:	83 e8 30             	sub    $0x30,%eax
  102baf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  102bb5:	0f b6 00             	movzbl (%eax),%eax
  102bb8:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102bbb:	83 fb 2f             	cmp    $0x2f,%ebx
  102bbe:	7e 0b                	jle    102bcb <vprintfmt+0xb8>
  102bc0:	83 fb 39             	cmp    $0x39,%ebx
  102bc3:	7f 06                	jg     102bcb <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bc5:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102bc9:	eb d3                	jmp    102b9e <vprintfmt+0x8b>
            goto process_precision;
  102bcb:	eb 33                	jmp    102c00 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102bcd:	8b 45 14             	mov    0x14(%ebp),%eax
  102bd0:	8d 50 04             	lea    0x4(%eax),%edx
  102bd3:	89 55 14             	mov    %edx,0x14(%ebp)
  102bd6:	8b 00                	mov    (%eax),%eax
  102bd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102bdb:	eb 23                	jmp    102c00 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102bdd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102be1:	79 0c                	jns    102bef <vprintfmt+0xdc>
                width = 0;
  102be3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102bea:	e9 78 ff ff ff       	jmp    102b67 <vprintfmt+0x54>
  102bef:	e9 73 ff ff ff       	jmp    102b67 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102bf4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102bfb:	e9 67 ff ff ff       	jmp    102b67 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102c00:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c04:	79 12                	jns    102c18 <vprintfmt+0x105>
                width = precision, precision = -1;
  102c06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c09:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c0c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c13:	e9 4f ff ff ff       	jmp    102b67 <vprintfmt+0x54>
  102c18:	e9 4a ff ff ff       	jmp    102b67 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c1d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102c21:	e9 41 ff ff ff       	jmp    102b67 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c26:	8b 45 14             	mov    0x14(%ebp),%eax
  102c29:	8d 50 04             	lea    0x4(%eax),%edx
  102c2c:	89 55 14             	mov    %edx,0x14(%ebp)
  102c2f:	8b 00                	mov    (%eax),%eax
  102c31:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c34:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c38:	89 04 24             	mov    %eax,(%esp)
  102c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3e:	ff d0                	call   *%eax
            break;
  102c40:	e9 ac 02 00 00       	jmp    102ef1 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c45:	8b 45 14             	mov    0x14(%ebp),%eax
  102c48:	8d 50 04             	lea    0x4(%eax),%edx
  102c4b:	89 55 14             	mov    %edx,0x14(%ebp)
  102c4e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c50:	85 db                	test   %ebx,%ebx
  102c52:	79 02                	jns    102c56 <vprintfmt+0x143>
                err = -err;
  102c54:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c56:	83 fb 06             	cmp    $0x6,%ebx
  102c59:	7f 0b                	jg     102c66 <vprintfmt+0x153>
  102c5b:	8b 34 9d 14 3c 10 00 	mov    0x103c14(,%ebx,4),%esi
  102c62:	85 f6                	test   %esi,%esi
  102c64:	75 23                	jne    102c89 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c66:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c6a:	c7 44 24 08 41 3c 10 	movl   $0x103c41,0x8(%esp)
  102c71:	00 
  102c72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c79:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7c:	89 04 24             	mov    %eax,(%esp)
  102c7f:	e8 61 fe ff ff       	call   102ae5 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c84:	e9 68 02 00 00       	jmp    102ef1 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c89:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102c8d:	c7 44 24 08 4a 3c 10 	movl   $0x103c4a,0x8(%esp)
  102c94:	00 
  102c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9f:	89 04 24             	mov    %eax,(%esp)
  102ca2:	e8 3e fe ff ff       	call   102ae5 <printfmt>
            }
            break;
  102ca7:	e9 45 02 00 00       	jmp    102ef1 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102cac:	8b 45 14             	mov    0x14(%ebp),%eax
  102caf:	8d 50 04             	lea    0x4(%eax),%edx
  102cb2:	89 55 14             	mov    %edx,0x14(%ebp)
  102cb5:	8b 30                	mov    (%eax),%esi
  102cb7:	85 f6                	test   %esi,%esi
  102cb9:	75 05                	jne    102cc0 <vprintfmt+0x1ad>
                p = "(null)";
  102cbb:	be 4d 3c 10 00       	mov    $0x103c4d,%esi
            }
            if (width > 0 && padc != '-') {
  102cc0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cc4:	7e 3e                	jle    102d04 <vprintfmt+0x1f1>
  102cc6:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cca:	74 38                	je     102d04 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ccc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102ccf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cd6:	89 34 24             	mov    %esi,(%esp)
  102cd9:	e8 15 03 00 00       	call   102ff3 <strnlen>
  102cde:	29 c3                	sub    %eax,%ebx
  102ce0:	89 d8                	mov    %ebx,%eax
  102ce2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ce5:	eb 17                	jmp    102cfe <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102ce7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102ceb:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cee:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cf2:	89 04 24             	mov    %eax,(%esp)
  102cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf8:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cfa:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102cfe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d02:	7f e3                	jg     102ce7 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d04:	eb 38                	jmp    102d3e <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d06:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d0a:	74 1f                	je     102d2b <vprintfmt+0x218>
  102d0c:	83 fb 1f             	cmp    $0x1f,%ebx
  102d0f:	7e 05                	jle    102d16 <vprintfmt+0x203>
  102d11:	83 fb 7e             	cmp    $0x7e,%ebx
  102d14:	7e 15                	jle    102d2b <vprintfmt+0x218>
                    putch('?', putdat);
  102d16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d1d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d24:	8b 45 08             	mov    0x8(%ebp),%eax
  102d27:	ff d0                	call   *%eax
  102d29:	eb 0f                	jmp    102d3a <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d32:	89 1c 24             	mov    %ebx,(%esp)
  102d35:	8b 45 08             	mov    0x8(%ebp),%eax
  102d38:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d3a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d3e:	89 f0                	mov    %esi,%eax
  102d40:	8d 70 01             	lea    0x1(%eax),%esi
  102d43:	0f b6 00             	movzbl (%eax),%eax
  102d46:	0f be d8             	movsbl %al,%ebx
  102d49:	85 db                	test   %ebx,%ebx
  102d4b:	74 10                	je     102d5d <vprintfmt+0x24a>
  102d4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d51:	78 b3                	js     102d06 <vprintfmt+0x1f3>
  102d53:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d5b:	79 a9                	jns    102d06 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d5d:	eb 17                	jmp    102d76 <vprintfmt+0x263>
                putch(' ', putdat);
  102d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d66:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d70:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d72:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d7a:	7f e3                	jg     102d5f <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102d7c:	e9 70 01 00 00       	jmp    102ef1 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d84:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d88:	8d 45 14             	lea    0x14(%ebp),%eax
  102d8b:	89 04 24             	mov    %eax,(%esp)
  102d8e:	e8 0b fd ff ff       	call   102a9e <getint>
  102d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d9f:	85 d2                	test   %edx,%edx
  102da1:	79 26                	jns    102dc9 <vprintfmt+0x2b6>
                putch('-', putdat);
  102da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102da6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102daa:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102db1:	8b 45 08             	mov    0x8(%ebp),%eax
  102db4:	ff d0                	call   *%eax
                num = -(long long)num;
  102db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dbc:	f7 d8                	neg    %eax
  102dbe:	83 d2 00             	adc    $0x0,%edx
  102dc1:	f7 da                	neg    %edx
  102dc3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102dc9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dd0:	e9 a8 00 00 00       	jmp    102e7d <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102dd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ddc:	8d 45 14             	lea    0x14(%ebp),%eax
  102ddf:	89 04 24             	mov    %eax,(%esp)
  102de2:	e8 68 fc ff ff       	call   102a4f <getuint>
  102de7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dea:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102ded:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102df4:	e9 84 00 00 00       	jmp    102e7d <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e00:	8d 45 14             	lea    0x14(%ebp),%eax
  102e03:	89 04 24             	mov    %eax,(%esp)
  102e06:	e8 44 fc ff ff       	call   102a4f <getuint>
  102e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e11:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e18:	eb 63                	jmp    102e7d <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e21:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e28:	8b 45 08             	mov    0x8(%ebp),%eax
  102e2b:	ff d0                	call   *%eax
            putch('x', putdat);
  102e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e34:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e40:	8b 45 14             	mov    0x14(%ebp),%eax
  102e43:	8d 50 04             	lea    0x4(%eax),%edx
  102e46:	89 55 14             	mov    %edx,0x14(%ebp)
  102e49:	8b 00                	mov    (%eax),%eax
  102e4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e55:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e5c:	eb 1f                	jmp    102e7d <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e61:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e65:	8d 45 14             	lea    0x14(%ebp),%eax
  102e68:	89 04 24             	mov    %eax,(%esp)
  102e6b:	e8 df fb ff ff       	call   102a4f <getuint>
  102e70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e73:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e76:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e7d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e84:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e8b:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e8f:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e99:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e9d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  102eab:	89 04 24             	mov    %eax,(%esp)
  102eae:	e8 97 fa ff ff       	call   10294a <printnum>
            break;
  102eb3:	eb 3c                	jmp    102ef1 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ebc:	89 1c 24             	mov    %ebx,(%esp)
  102ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec2:	ff d0                	call   *%eax
            break;
  102ec4:	eb 2b                	jmp    102ef1 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ecd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed7:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102ed9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102edd:	eb 04                	jmp    102ee3 <vprintfmt+0x3d0>
  102edf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  102ee6:	83 e8 01             	sub    $0x1,%eax
  102ee9:	0f b6 00             	movzbl (%eax),%eax
  102eec:	3c 25                	cmp    $0x25,%al
  102eee:	75 ef                	jne    102edf <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102ef0:	90                   	nop
        }
    }
  102ef1:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ef2:	e9 3e fc ff ff       	jmp    102b35 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102ef7:	83 c4 40             	add    $0x40,%esp
  102efa:	5b                   	pop    %ebx
  102efb:	5e                   	pop    %esi
  102efc:	5d                   	pop    %ebp
  102efd:	c3                   	ret    

00102efe <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102efe:	55                   	push   %ebp
  102eff:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f04:	8b 40 08             	mov    0x8(%eax),%eax
  102f07:	8d 50 01             	lea    0x1(%eax),%edx
  102f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f0d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f10:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f13:	8b 10                	mov    (%eax),%edx
  102f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f18:	8b 40 04             	mov    0x4(%eax),%eax
  102f1b:	39 c2                	cmp    %eax,%edx
  102f1d:	73 12                	jae    102f31 <sprintputch+0x33>
        *b->buf ++ = ch;
  102f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f22:	8b 00                	mov    (%eax),%eax
  102f24:	8d 48 01             	lea    0x1(%eax),%ecx
  102f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f2a:	89 0a                	mov    %ecx,(%edx)
  102f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  102f2f:	88 10                	mov    %dl,(%eax)
    }
}
  102f31:	5d                   	pop    %ebp
  102f32:	c3                   	ret    

00102f33 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f33:	55                   	push   %ebp
  102f34:	89 e5                	mov    %esp,%ebp
  102f36:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f39:	8d 45 14             	lea    0x14(%ebp),%eax
  102f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f42:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f46:	8b 45 10             	mov    0x10(%ebp),%eax
  102f49:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f50:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f54:	8b 45 08             	mov    0x8(%ebp),%eax
  102f57:	89 04 24             	mov    %eax,(%esp)
  102f5a:	e8 08 00 00 00       	call   102f67 <vsnprintf>
  102f5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f65:	c9                   	leave  
  102f66:	c3                   	ret    

00102f67 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f67:	55                   	push   %ebp
  102f68:	89 e5                	mov    %esp,%ebp
  102f6a:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f76:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f79:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7c:	01 d0                	add    %edx,%eax
  102f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f8c:	74 0a                	je     102f98 <vsnprintf+0x31>
  102f8e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f94:	39 c2                	cmp    %eax,%edx
  102f96:	76 07                	jbe    102f9f <vsnprintf+0x38>
        return -E_INVAL;
  102f98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f9d:	eb 2a                	jmp    102fc9 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f9f:	8b 45 14             	mov    0x14(%ebp),%eax
  102fa2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fa6:	8b 45 10             	mov    0x10(%ebp),%eax
  102fa9:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fad:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102fb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fb4:	c7 04 24 fe 2e 10 00 	movl   $0x102efe,(%esp)
  102fbb:	e8 53 fb ff ff       	call   102b13 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc3:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102fc9:	c9                   	leave  
  102fca:	c3                   	ret    

00102fcb <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102fcb:	55                   	push   %ebp
  102fcc:	89 e5                	mov    %esp,%ebp
  102fce:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fd8:	eb 04                	jmp    102fde <strlen+0x13>
        cnt ++;
  102fda:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102fde:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe1:	8d 50 01             	lea    0x1(%eax),%edx
  102fe4:	89 55 08             	mov    %edx,0x8(%ebp)
  102fe7:	0f b6 00             	movzbl (%eax),%eax
  102fea:	84 c0                	test   %al,%al
  102fec:	75 ec                	jne    102fda <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ff1:	c9                   	leave  
  102ff2:	c3                   	ret    

00102ff3 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102ff3:	55                   	push   %ebp
  102ff4:	89 e5                	mov    %esp,%ebp
  102ff6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ff9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103000:	eb 04                	jmp    103006 <strnlen+0x13>
        cnt ++;
  103002:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  103006:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103009:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10300c:	73 10                	jae    10301e <strnlen+0x2b>
  10300e:	8b 45 08             	mov    0x8(%ebp),%eax
  103011:	8d 50 01             	lea    0x1(%eax),%edx
  103014:	89 55 08             	mov    %edx,0x8(%ebp)
  103017:	0f b6 00             	movzbl (%eax),%eax
  10301a:	84 c0                	test   %al,%al
  10301c:	75 e4                	jne    103002 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10301e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103021:	c9                   	leave  
  103022:	c3                   	ret    

00103023 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103023:	55                   	push   %ebp
  103024:	89 e5                	mov    %esp,%ebp
  103026:	57                   	push   %edi
  103027:	56                   	push   %esi
  103028:	83 ec 20             	sub    $0x20,%esp
  10302b:	8b 45 08             	mov    0x8(%ebp),%eax
  10302e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103031:	8b 45 0c             	mov    0xc(%ebp),%eax
  103034:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103037:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10303d:	89 d1                	mov    %edx,%ecx
  10303f:	89 c2                	mov    %eax,%edx
  103041:	89 ce                	mov    %ecx,%esi
  103043:	89 d7                	mov    %edx,%edi
  103045:	ac                   	lods   %ds:(%esi),%al
  103046:	aa                   	stos   %al,%es:(%edi)
  103047:	84 c0                	test   %al,%al
  103049:	75 fa                	jne    103045 <strcpy+0x22>
  10304b:	89 fa                	mov    %edi,%edx
  10304d:	89 f1                	mov    %esi,%ecx
  10304f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103052:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103055:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103058:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10305b:	83 c4 20             	add    $0x20,%esp
  10305e:	5e                   	pop    %esi
  10305f:	5f                   	pop    %edi
  103060:	5d                   	pop    %ebp
  103061:	c3                   	ret    

00103062 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103062:	55                   	push   %ebp
  103063:	89 e5                	mov    %esp,%ebp
  103065:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103068:	8b 45 08             	mov    0x8(%ebp),%eax
  10306b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10306e:	eb 21                	jmp    103091 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  103070:	8b 45 0c             	mov    0xc(%ebp),%eax
  103073:	0f b6 10             	movzbl (%eax),%edx
  103076:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103079:	88 10                	mov    %dl,(%eax)
  10307b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10307e:	0f b6 00             	movzbl (%eax),%eax
  103081:	84 c0                	test   %al,%al
  103083:	74 04                	je     103089 <strncpy+0x27>
            src ++;
  103085:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103089:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10308d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  103091:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103095:	75 d9                	jne    103070 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103097:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10309a:	c9                   	leave  
  10309b:	c3                   	ret    

0010309c <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10309c:	55                   	push   %ebp
  10309d:	89 e5                	mov    %esp,%ebp
  10309f:	57                   	push   %edi
  1030a0:	56                   	push   %esi
  1030a1:	83 ec 20             	sub    $0x20,%esp
  1030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1030b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b6:	89 d1                	mov    %edx,%ecx
  1030b8:	89 c2                	mov    %eax,%edx
  1030ba:	89 ce                	mov    %ecx,%esi
  1030bc:	89 d7                	mov    %edx,%edi
  1030be:	ac                   	lods   %ds:(%esi),%al
  1030bf:	ae                   	scas   %es:(%edi),%al
  1030c0:	75 08                	jne    1030ca <strcmp+0x2e>
  1030c2:	84 c0                	test   %al,%al
  1030c4:	75 f8                	jne    1030be <strcmp+0x22>
  1030c6:	31 c0                	xor    %eax,%eax
  1030c8:	eb 04                	jmp    1030ce <strcmp+0x32>
  1030ca:	19 c0                	sbb    %eax,%eax
  1030cc:	0c 01                	or     $0x1,%al
  1030ce:	89 fa                	mov    %edi,%edx
  1030d0:	89 f1                	mov    %esi,%ecx
  1030d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030d5:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030d8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1030db:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1030de:	83 c4 20             	add    $0x20,%esp
  1030e1:	5e                   	pop    %esi
  1030e2:	5f                   	pop    %edi
  1030e3:	5d                   	pop    %ebp
  1030e4:	c3                   	ret    

001030e5 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1030e5:	55                   	push   %ebp
  1030e6:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030e8:	eb 0c                	jmp    1030f6 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1030ea:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030f2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030fa:	74 1a                	je     103116 <strncmp+0x31>
  1030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ff:	0f b6 00             	movzbl (%eax),%eax
  103102:	84 c0                	test   %al,%al
  103104:	74 10                	je     103116 <strncmp+0x31>
  103106:	8b 45 08             	mov    0x8(%ebp),%eax
  103109:	0f b6 10             	movzbl (%eax),%edx
  10310c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310f:	0f b6 00             	movzbl (%eax),%eax
  103112:	38 c2                	cmp    %al,%dl
  103114:	74 d4                	je     1030ea <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103116:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10311a:	74 18                	je     103134 <strncmp+0x4f>
  10311c:	8b 45 08             	mov    0x8(%ebp),%eax
  10311f:	0f b6 00             	movzbl (%eax),%eax
  103122:	0f b6 d0             	movzbl %al,%edx
  103125:	8b 45 0c             	mov    0xc(%ebp),%eax
  103128:	0f b6 00             	movzbl (%eax),%eax
  10312b:	0f b6 c0             	movzbl %al,%eax
  10312e:	29 c2                	sub    %eax,%edx
  103130:	89 d0                	mov    %edx,%eax
  103132:	eb 05                	jmp    103139 <strncmp+0x54>
  103134:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103139:	5d                   	pop    %ebp
  10313a:	c3                   	ret    

0010313b <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10313b:	55                   	push   %ebp
  10313c:	89 e5                	mov    %esp,%ebp
  10313e:	83 ec 04             	sub    $0x4,%esp
  103141:	8b 45 0c             	mov    0xc(%ebp),%eax
  103144:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103147:	eb 14                	jmp    10315d <strchr+0x22>
        if (*s == c) {
  103149:	8b 45 08             	mov    0x8(%ebp),%eax
  10314c:	0f b6 00             	movzbl (%eax),%eax
  10314f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103152:	75 05                	jne    103159 <strchr+0x1e>
            return (char *)s;
  103154:	8b 45 08             	mov    0x8(%ebp),%eax
  103157:	eb 13                	jmp    10316c <strchr+0x31>
        }
        s ++;
  103159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10315d:	8b 45 08             	mov    0x8(%ebp),%eax
  103160:	0f b6 00             	movzbl (%eax),%eax
  103163:	84 c0                	test   %al,%al
  103165:	75 e2                	jne    103149 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103167:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10316c:	c9                   	leave  
  10316d:	c3                   	ret    

0010316e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10316e:	55                   	push   %ebp
  10316f:	89 e5                	mov    %esp,%ebp
  103171:	83 ec 04             	sub    $0x4,%esp
  103174:	8b 45 0c             	mov    0xc(%ebp),%eax
  103177:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10317a:	eb 11                	jmp    10318d <strfind+0x1f>
        if (*s == c) {
  10317c:	8b 45 08             	mov    0x8(%ebp),%eax
  10317f:	0f b6 00             	movzbl (%eax),%eax
  103182:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103185:	75 02                	jne    103189 <strfind+0x1b>
            break;
  103187:	eb 0e                	jmp    103197 <strfind+0x29>
        }
        s ++;
  103189:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  10318d:	8b 45 08             	mov    0x8(%ebp),%eax
  103190:	0f b6 00             	movzbl (%eax),%eax
  103193:	84 c0                	test   %al,%al
  103195:	75 e5                	jne    10317c <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103197:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10319a:	c9                   	leave  
  10319b:	c3                   	ret    

0010319c <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10319c:	55                   	push   %ebp
  10319d:	89 e5                	mov    %esp,%ebp
  10319f:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1031a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1031a9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031b0:	eb 04                	jmp    1031b6 <strtol+0x1a>
        s ++;
  1031b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b9:	0f b6 00             	movzbl (%eax),%eax
  1031bc:	3c 20                	cmp    $0x20,%al
  1031be:	74 f2                	je     1031b2 <strtol+0x16>
  1031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c3:	0f b6 00             	movzbl (%eax),%eax
  1031c6:	3c 09                	cmp    $0x9,%al
  1031c8:	74 e8                	je     1031b2 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1031cd:	0f b6 00             	movzbl (%eax),%eax
  1031d0:	3c 2b                	cmp    $0x2b,%al
  1031d2:	75 06                	jne    1031da <strtol+0x3e>
        s ++;
  1031d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031d8:	eb 15                	jmp    1031ef <strtol+0x53>
    }
    else if (*s == '-') {
  1031da:	8b 45 08             	mov    0x8(%ebp),%eax
  1031dd:	0f b6 00             	movzbl (%eax),%eax
  1031e0:	3c 2d                	cmp    $0x2d,%al
  1031e2:	75 0b                	jne    1031ef <strtol+0x53>
        s ++, neg = 1;
  1031e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1031ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031f3:	74 06                	je     1031fb <strtol+0x5f>
  1031f5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031f9:	75 24                	jne    10321f <strtol+0x83>
  1031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fe:	0f b6 00             	movzbl (%eax),%eax
  103201:	3c 30                	cmp    $0x30,%al
  103203:	75 1a                	jne    10321f <strtol+0x83>
  103205:	8b 45 08             	mov    0x8(%ebp),%eax
  103208:	83 c0 01             	add    $0x1,%eax
  10320b:	0f b6 00             	movzbl (%eax),%eax
  10320e:	3c 78                	cmp    $0x78,%al
  103210:	75 0d                	jne    10321f <strtol+0x83>
        s += 2, base = 16;
  103212:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103216:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10321d:	eb 2a                	jmp    103249 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10321f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103223:	75 17                	jne    10323c <strtol+0xa0>
  103225:	8b 45 08             	mov    0x8(%ebp),%eax
  103228:	0f b6 00             	movzbl (%eax),%eax
  10322b:	3c 30                	cmp    $0x30,%al
  10322d:	75 0d                	jne    10323c <strtol+0xa0>
        s ++, base = 8;
  10322f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103233:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10323a:	eb 0d                	jmp    103249 <strtol+0xad>
    }
    else if (base == 0) {
  10323c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103240:	75 07                	jne    103249 <strtol+0xad>
        base = 10;
  103242:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103249:	8b 45 08             	mov    0x8(%ebp),%eax
  10324c:	0f b6 00             	movzbl (%eax),%eax
  10324f:	3c 2f                	cmp    $0x2f,%al
  103251:	7e 1b                	jle    10326e <strtol+0xd2>
  103253:	8b 45 08             	mov    0x8(%ebp),%eax
  103256:	0f b6 00             	movzbl (%eax),%eax
  103259:	3c 39                	cmp    $0x39,%al
  10325b:	7f 11                	jg     10326e <strtol+0xd2>
            dig = *s - '0';
  10325d:	8b 45 08             	mov    0x8(%ebp),%eax
  103260:	0f b6 00             	movzbl (%eax),%eax
  103263:	0f be c0             	movsbl %al,%eax
  103266:	83 e8 30             	sub    $0x30,%eax
  103269:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10326c:	eb 48                	jmp    1032b6 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10326e:	8b 45 08             	mov    0x8(%ebp),%eax
  103271:	0f b6 00             	movzbl (%eax),%eax
  103274:	3c 60                	cmp    $0x60,%al
  103276:	7e 1b                	jle    103293 <strtol+0xf7>
  103278:	8b 45 08             	mov    0x8(%ebp),%eax
  10327b:	0f b6 00             	movzbl (%eax),%eax
  10327e:	3c 7a                	cmp    $0x7a,%al
  103280:	7f 11                	jg     103293 <strtol+0xf7>
            dig = *s - 'a' + 10;
  103282:	8b 45 08             	mov    0x8(%ebp),%eax
  103285:	0f b6 00             	movzbl (%eax),%eax
  103288:	0f be c0             	movsbl %al,%eax
  10328b:	83 e8 57             	sub    $0x57,%eax
  10328e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103291:	eb 23                	jmp    1032b6 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103293:	8b 45 08             	mov    0x8(%ebp),%eax
  103296:	0f b6 00             	movzbl (%eax),%eax
  103299:	3c 40                	cmp    $0x40,%al
  10329b:	7e 3d                	jle    1032da <strtol+0x13e>
  10329d:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a0:	0f b6 00             	movzbl (%eax),%eax
  1032a3:	3c 5a                	cmp    $0x5a,%al
  1032a5:	7f 33                	jg     1032da <strtol+0x13e>
            dig = *s - 'A' + 10;
  1032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032aa:	0f b6 00             	movzbl (%eax),%eax
  1032ad:	0f be c0             	movsbl %al,%eax
  1032b0:	83 e8 37             	sub    $0x37,%eax
  1032b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032b9:	3b 45 10             	cmp    0x10(%ebp),%eax
  1032bc:	7c 02                	jl     1032c0 <strtol+0x124>
            break;
  1032be:	eb 1a                	jmp    1032da <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1032c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032c7:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032cb:	89 c2                	mov    %eax,%edx
  1032cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032d0:	01 d0                	add    %edx,%eax
  1032d2:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1032d5:	e9 6f ff ff ff       	jmp    103249 <strtol+0xad>

    if (endptr) {
  1032da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032de:	74 08                	je     1032e8 <strtol+0x14c>
        *endptr = (char *) s;
  1032e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1032e6:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1032e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1032ec:	74 07                	je     1032f5 <strtol+0x159>
  1032ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032f1:	f7 d8                	neg    %eax
  1032f3:	eb 03                	jmp    1032f8 <strtol+0x15c>
  1032f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032f8:	c9                   	leave  
  1032f9:	c3                   	ret    

001032fa <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032fa:	55                   	push   %ebp
  1032fb:	89 e5                	mov    %esp,%ebp
  1032fd:	57                   	push   %edi
  1032fe:	83 ec 24             	sub    $0x24,%esp
  103301:	8b 45 0c             	mov    0xc(%ebp),%eax
  103304:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103307:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10330b:	8b 55 08             	mov    0x8(%ebp),%edx
  10330e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103311:	88 45 f7             	mov    %al,-0x9(%ebp)
  103314:	8b 45 10             	mov    0x10(%ebp),%eax
  103317:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10331a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10331d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103321:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103324:	89 d7                	mov    %edx,%edi
  103326:	f3 aa                	rep stos %al,%es:(%edi)
  103328:	89 fa                	mov    %edi,%edx
  10332a:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10332d:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103330:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103333:	83 c4 24             	add    $0x24,%esp
  103336:	5f                   	pop    %edi
  103337:	5d                   	pop    %ebp
  103338:	c3                   	ret    

00103339 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103339:	55                   	push   %ebp
  10333a:	89 e5                	mov    %esp,%ebp
  10333c:	57                   	push   %edi
  10333d:	56                   	push   %esi
  10333e:	53                   	push   %ebx
  10333f:	83 ec 30             	sub    $0x30,%esp
  103342:	8b 45 08             	mov    0x8(%ebp),%eax
  103345:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103348:	8b 45 0c             	mov    0xc(%ebp),%eax
  10334b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10334e:	8b 45 10             	mov    0x10(%ebp),%eax
  103351:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103357:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10335a:	73 42                	jae    10339e <memmove+0x65>
  10335c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103365:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103368:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10336b:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10336e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103371:	c1 e8 02             	shr    $0x2,%eax
  103374:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103376:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10337c:	89 d7                	mov    %edx,%edi
  10337e:	89 c6                	mov    %eax,%esi
  103380:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103382:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103385:	83 e1 03             	and    $0x3,%ecx
  103388:	74 02                	je     10338c <memmove+0x53>
  10338a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10338c:	89 f0                	mov    %esi,%eax
  10338e:	89 fa                	mov    %edi,%edx
  103390:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103393:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103396:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103399:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10339c:	eb 36                	jmp    1033d4 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10339e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033a7:	01 c2                	add    %eax,%edx
  1033a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033ac:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1033af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033b2:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1033b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033b8:	89 c1                	mov    %eax,%ecx
  1033ba:	89 d8                	mov    %ebx,%eax
  1033bc:	89 d6                	mov    %edx,%esi
  1033be:	89 c7                	mov    %eax,%edi
  1033c0:	fd                   	std    
  1033c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033c3:	fc                   	cld    
  1033c4:	89 f8                	mov    %edi,%eax
  1033c6:	89 f2                	mov    %esi,%edx
  1033c8:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033cb:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033ce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1033d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033d4:	83 c4 30             	add    $0x30,%esp
  1033d7:	5b                   	pop    %ebx
  1033d8:	5e                   	pop    %esi
  1033d9:	5f                   	pop    %edi
  1033da:	5d                   	pop    %ebp
  1033db:	c3                   	ret    

001033dc <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033dc:	55                   	push   %ebp
  1033dd:	89 e5                	mov    %esp,%ebp
  1033df:	57                   	push   %edi
  1033e0:	56                   	push   %esi
  1033e1:	83 ec 20             	sub    $0x20,%esp
  1033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033f0:	8b 45 10             	mov    0x10(%ebp),%eax
  1033f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033f9:	c1 e8 02             	shr    $0x2,%eax
  1033fc:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103404:	89 d7                	mov    %edx,%edi
  103406:	89 c6                	mov    %eax,%esi
  103408:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10340a:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10340d:	83 e1 03             	and    $0x3,%ecx
  103410:	74 02                	je     103414 <memcpy+0x38>
  103412:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103414:	89 f0                	mov    %esi,%eax
  103416:	89 fa                	mov    %edi,%edx
  103418:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10341b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10341e:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103421:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103424:	83 c4 20             	add    $0x20,%esp
  103427:	5e                   	pop    %esi
  103428:	5f                   	pop    %edi
  103429:	5d                   	pop    %ebp
  10342a:	c3                   	ret    

0010342b <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10342b:	55                   	push   %ebp
  10342c:	89 e5                	mov    %esp,%ebp
  10342e:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103431:	8b 45 08             	mov    0x8(%ebp),%eax
  103434:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103437:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343a:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10343d:	eb 30                	jmp    10346f <memcmp+0x44>
        if (*s1 != *s2) {
  10343f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103442:	0f b6 10             	movzbl (%eax),%edx
  103445:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103448:	0f b6 00             	movzbl (%eax),%eax
  10344b:	38 c2                	cmp    %al,%dl
  10344d:	74 18                	je     103467 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10344f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103452:	0f b6 00             	movzbl (%eax),%eax
  103455:	0f b6 d0             	movzbl %al,%edx
  103458:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10345b:	0f b6 00             	movzbl (%eax),%eax
  10345e:	0f b6 c0             	movzbl %al,%eax
  103461:	29 c2                	sub    %eax,%edx
  103463:	89 d0                	mov    %edx,%eax
  103465:	eb 1a                	jmp    103481 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103467:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10346b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10346f:	8b 45 10             	mov    0x10(%ebp),%eax
  103472:	8d 50 ff             	lea    -0x1(%eax),%edx
  103475:	89 55 10             	mov    %edx,0x10(%ebp)
  103478:	85 c0                	test   %eax,%eax
  10347a:	75 c3                	jne    10343f <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10347c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103481:	c9                   	leave  
  103482:	c3                   	ret    
