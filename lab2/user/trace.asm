
user/_trace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	712d                	addi	sp,sp,-288
   2:	ee06                	sd	ra,280(sp)
   4:	ea22                	sd	s0,272(sp)
   6:	e626                	sd	s1,264(sp)
   8:	e24a                	sd	s2,256(sp)
   a:	1200                	addi	s0,sp,288
   c:	892e                	mv	s2,a1
  int i;
  char *nargv[MAXARG];

  if(argc < 3 || (argv[1][0] < '0' || argv[1][0] > '9')){
   e:	4789                	li	a5,2
  10:	00a7dd63          	bge	a5,a0,2a <main+0x2a>
  14:	84aa                	mv	s1,a0
  16:	6588                	ld	a0,8(a1)
  18:	00054783          	lbu	a5,0(a0)
  1c:	fd07879b          	addiw	a5,a5,-48
  20:	0ff7f793          	andi	a5,a5,255
  24:	4725                	li	a4,9
  26:	02f77263          	bgeu	a4,a5,4a <main+0x4a>
    fprintf(2, "Usage: %s mask command\n", argv[0]);
  2a:	00093603          	ld	a2,0(s2)
  2e:	00001597          	auipc	a1,0x1
  32:	86258593          	addi	a1,a1,-1950 # 890 <malloc+0xf2>
  36:	4509                	li	a0,2
  38:	00000097          	auipc	ra,0x0
  3c:	67a080e7          	jalr	1658(ra) # 6b2 <fprintf>
    exit(1);
  40:	4505                	li	a0,1
  42:	00000097          	auipc	ra,0x0
  46:	30e080e7          	jalr	782(ra) # 350 <exit>
  }

  if (trace(atoi(argv[1])) < 0) {
  4a:	00000097          	auipc	ra,0x0
  4e:	206080e7          	jalr	518(ra) # 250 <atoi>
  52:	00000097          	auipc	ra,0x0
  56:	3ae080e7          	jalr	942(ra) # 400 <trace>
  5a:	04054363          	bltz	a0,a0 <main+0xa0>
  5e:	01090793          	addi	a5,s2,16
  62:	ee040713          	addi	a4,s0,-288
  66:	ffd4869b          	addiw	a3,s1,-3
  6a:	1682                	slli	a3,a3,0x20
  6c:	9281                	srli	a3,a3,0x20
  6e:	068e                	slli	a3,a3,0x3
  70:	96be                	add	a3,a3,a5
  72:	10090913          	addi	s2,s2,256
    fprintf(2, "%s: trace failed\n", argv[0]);
    exit(1);
  }
  
  for(i = 2; i < argc && i < MAXARG; i++){
    nargv[i-2] = argv[i];
  76:	6390                	ld	a2,0(a5)
  78:	e310                	sd	a2,0(a4)
  for(i = 2; i < argc && i < MAXARG; i++){
  7a:	00d78663          	beq	a5,a3,86 <main+0x86>
  7e:	07a1                	addi	a5,a5,8
  80:	0721                	addi	a4,a4,8
  82:	ff279ae3          	bne	a5,s2,76 <main+0x76>
  }
  exec(nargv[0], nargv);
  86:	ee040593          	addi	a1,s0,-288
  8a:	ee043503          	ld	a0,-288(s0)
  8e:	00000097          	auipc	ra,0x0
  92:	2fa080e7          	jalr	762(ra) # 388 <exec>
  exit(0);
  96:	4501                	li	a0,0
  98:	00000097          	auipc	ra,0x0
  9c:	2b8080e7          	jalr	696(ra) # 350 <exit>
    fprintf(2, "%s: trace failed\n", argv[0]);
  a0:	00093603          	ld	a2,0(s2)
  a4:	00001597          	auipc	a1,0x1
  a8:	80458593          	addi	a1,a1,-2044 # 8a8 <malloc+0x10a>
  ac:	4509                	li	a0,2
  ae:	00000097          	auipc	ra,0x0
  b2:	604080e7          	jalr	1540(ra) # 6b2 <fprintf>
    exit(1);
  b6:	4505                	li	a0,1
  b8:	00000097          	auipc	ra,0x0
  bc:	298080e7          	jalr	664(ra) # 350 <exit>

00000000000000c0 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e406                	sd	ra,8(sp)
  c4:	e022                	sd	s0,0(sp)
  c6:	0800                	addi	s0,sp,16
  extern int main();
  main();
  c8:	00000097          	auipc	ra,0x0
  cc:	f38080e7          	jalr	-200(ra) # 0 <main>
  exit(0);
  d0:	4501                	li	a0,0
  d2:	00000097          	auipc	ra,0x0
  d6:	27e080e7          	jalr	638(ra) # 350 <exit>

00000000000000da <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e422                	sd	s0,8(sp)
  de:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e0:	87aa                	mv	a5,a0
  e2:	0585                	addi	a1,a1,1
  e4:	0785                	addi	a5,a5,1
  e6:	fff5c703          	lbu	a4,-1(a1)
  ea:	fee78fa3          	sb	a4,-1(a5)
  ee:	fb75                	bnez	a4,e2 <strcpy+0x8>
    ;
  return os;
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cb91                	beqz	a5,114 <strcmp+0x1e>
 102:	0005c703          	lbu	a4,0(a1)
 106:	00f71763          	bne	a4,a5,114 <strcmp+0x1e>
    p++, q++;
 10a:	0505                	addi	a0,a0,1
 10c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 10e:	00054783          	lbu	a5,0(a0)
 112:	fbe5                	bnez	a5,102 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 114:	0005c503          	lbu	a0,0(a1)
}
 118:	40a7853b          	subw	a0,a5,a0
 11c:	6422                	ld	s0,8(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strlen>:

uint
strlen(const char *s)
{
 122:	1141                	addi	sp,sp,-16
 124:	e422                	sd	s0,8(sp)
 126:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 128:	00054783          	lbu	a5,0(a0)
 12c:	cf91                	beqz	a5,148 <strlen+0x26>
 12e:	0505                	addi	a0,a0,1
 130:	87aa                	mv	a5,a0
 132:	4685                	li	a3,1
 134:	9e89                	subw	a3,a3,a0
 136:	00f6853b          	addw	a0,a3,a5
 13a:	0785                	addi	a5,a5,1
 13c:	fff7c703          	lbu	a4,-1(a5)
 140:	fb7d                	bnez	a4,136 <strlen+0x14>
    ;
  return n;
}
 142:	6422                	ld	s0,8(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret
  for(n = 0; s[n]; n++)
 148:	4501                	li	a0,0
 14a:	bfe5                	j	142 <strlen+0x20>

000000000000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	1141                	addi	sp,sp,-16
 14e:	e422                	sd	s0,8(sp)
 150:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 152:	ce09                	beqz	a2,16c <memset+0x20>
 154:	87aa                	mv	a5,a0
 156:	fff6071b          	addiw	a4,a2,-1
 15a:	1702                	slli	a4,a4,0x20
 15c:	9301                	srli	a4,a4,0x20
 15e:	0705                	addi	a4,a4,1
 160:	972a                	add	a4,a4,a0
    cdst[i] = c;
 162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 166:	0785                	addi	a5,a5,1
 168:	fee79de3          	bne	a5,a4,162 <memset+0x16>
  }
  return dst;
}
 16c:	6422                	ld	s0,8(sp)
 16e:	0141                	addi	sp,sp,16
 170:	8082                	ret

0000000000000172 <strchr>:

char*
strchr(const char *s, char c)
{
 172:	1141                	addi	sp,sp,-16
 174:	e422                	sd	s0,8(sp)
 176:	0800                	addi	s0,sp,16
  for(; *s; s++)
 178:	00054783          	lbu	a5,0(a0)
 17c:	cb99                	beqz	a5,192 <strchr+0x20>
    if(*s == c)
 17e:	00f58763          	beq	a1,a5,18c <strchr+0x1a>
  for(; *s; s++)
 182:	0505                	addi	a0,a0,1
 184:	00054783          	lbu	a5,0(a0)
 188:	fbfd                	bnez	a5,17e <strchr+0xc>
      return (char*)s;
  return 0;
 18a:	4501                	li	a0,0
}
 18c:	6422                	ld	s0,8(sp)
 18e:	0141                	addi	sp,sp,16
 190:	8082                	ret
  return 0;
 192:	4501                	li	a0,0
 194:	bfe5                	j	18c <strchr+0x1a>

0000000000000196 <gets>:

char*
gets(char *buf, int max)
{
 196:	711d                	addi	sp,sp,-96
 198:	ec86                	sd	ra,88(sp)
 19a:	e8a2                	sd	s0,80(sp)
 19c:	e4a6                	sd	s1,72(sp)
 19e:	e0ca                	sd	s2,64(sp)
 1a0:	fc4e                	sd	s3,56(sp)
 1a2:	f852                	sd	s4,48(sp)
 1a4:	f456                	sd	s5,40(sp)
 1a6:	f05a                	sd	s6,32(sp)
 1a8:	ec5e                	sd	s7,24(sp)
 1aa:	1080                	addi	s0,sp,96
 1ac:	8baa                	mv	s7,a0
 1ae:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b0:	892a                	mv	s2,a0
 1b2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1b4:	4aa9                	li	s5,10
 1b6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1b8:	89a6                	mv	s3,s1
 1ba:	2485                	addiw	s1,s1,1
 1bc:	0344d863          	bge	s1,s4,1ec <gets+0x56>
    cc = read(0, &c, 1);
 1c0:	4605                	li	a2,1
 1c2:	faf40593          	addi	a1,s0,-81
 1c6:	4501                	li	a0,0
 1c8:	00000097          	auipc	ra,0x0
 1cc:	1a0080e7          	jalr	416(ra) # 368 <read>
    if(cc < 1)
 1d0:	00a05e63          	blez	a0,1ec <gets+0x56>
    buf[i++] = c;
 1d4:	faf44783          	lbu	a5,-81(s0)
 1d8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1dc:	01578763          	beq	a5,s5,1ea <gets+0x54>
 1e0:	0905                	addi	s2,s2,1
 1e2:	fd679be3          	bne	a5,s6,1b8 <gets+0x22>
  for(i=0; i+1 < max; ){
 1e6:	89a6                	mv	s3,s1
 1e8:	a011                	j	1ec <gets+0x56>
 1ea:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1ec:	99de                	add	s3,s3,s7
 1ee:	00098023          	sb	zero,0(s3)
  return buf;
}
 1f2:	855e                	mv	a0,s7
 1f4:	60e6                	ld	ra,88(sp)
 1f6:	6446                	ld	s0,80(sp)
 1f8:	64a6                	ld	s1,72(sp)
 1fa:	6906                	ld	s2,64(sp)
 1fc:	79e2                	ld	s3,56(sp)
 1fe:	7a42                	ld	s4,48(sp)
 200:	7aa2                	ld	s5,40(sp)
 202:	7b02                	ld	s6,32(sp)
 204:	6be2                	ld	s7,24(sp)
 206:	6125                	addi	sp,sp,96
 208:	8082                	ret

000000000000020a <stat>:

int
stat(const char *n, struct stat *st)
{
 20a:	1101                	addi	sp,sp,-32
 20c:	ec06                	sd	ra,24(sp)
 20e:	e822                	sd	s0,16(sp)
 210:	e426                	sd	s1,8(sp)
 212:	e04a                	sd	s2,0(sp)
 214:	1000                	addi	s0,sp,32
 216:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 218:	4581                	li	a1,0
 21a:	00000097          	auipc	ra,0x0
 21e:	176080e7          	jalr	374(ra) # 390 <open>
  if(fd < 0)
 222:	02054563          	bltz	a0,24c <stat+0x42>
 226:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 228:	85ca                	mv	a1,s2
 22a:	00000097          	auipc	ra,0x0
 22e:	17e080e7          	jalr	382(ra) # 3a8 <fstat>
 232:	892a                	mv	s2,a0
  close(fd);
 234:	8526                	mv	a0,s1
 236:	00000097          	auipc	ra,0x0
 23a:	142080e7          	jalr	322(ra) # 378 <close>
  return r;
}
 23e:	854a                	mv	a0,s2
 240:	60e2                	ld	ra,24(sp)
 242:	6442                	ld	s0,16(sp)
 244:	64a2                	ld	s1,8(sp)
 246:	6902                	ld	s2,0(sp)
 248:	6105                	addi	sp,sp,32
 24a:	8082                	ret
    return -1;
 24c:	597d                	li	s2,-1
 24e:	bfc5                	j	23e <stat+0x34>

0000000000000250 <atoi>:

int
atoi(const char *s)
{
 250:	1141                	addi	sp,sp,-16
 252:	e422                	sd	s0,8(sp)
 254:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 256:	00054603          	lbu	a2,0(a0)
 25a:	fd06079b          	addiw	a5,a2,-48
 25e:	0ff7f793          	andi	a5,a5,255
 262:	4725                	li	a4,9
 264:	02f76963          	bltu	a4,a5,296 <atoi+0x46>
 268:	86aa                	mv	a3,a0
  n = 0;
 26a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 26c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 26e:	0685                	addi	a3,a3,1
 270:	0025179b          	slliw	a5,a0,0x2
 274:	9fa9                	addw	a5,a5,a0
 276:	0017979b          	slliw	a5,a5,0x1
 27a:	9fb1                	addw	a5,a5,a2
 27c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 280:	0006c603          	lbu	a2,0(a3)
 284:	fd06071b          	addiw	a4,a2,-48
 288:	0ff77713          	andi	a4,a4,255
 28c:	fee5f1e3          	bgeu	a1,a4,26e <atoi+0x1e>
  return n;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
  n = 0;
 296:	4501                	li	a0,0
 298:	bfe5                	j	290 <atoi+0x40>

000000000000029a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e422                	sd	s0,8(sp)
 29e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a0:	02b57663          	bgeu	a0,a1,2cc <memmove+0x32>
    while(n-- > 0)
 2a4:	02c05163          	blez	a2,2c6 <memmove+0x2c>
 2a8:	fff6079b          	addiw	a5,a2,-1
 2ac:	1782                	slli	a5,a5,0x20
 2ae:	9381                	srli	a5,a5,0x20
 2b0:	0785                	addi	a5,a5,1
 2b2:	97aa                	add	a5,a5,a0
  dst = vdst;
 2b4:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b6:	0585                	addi	a1,a1,1
 2b8:	0705                	addi	a4,a4,1
 2ba:	fff5c683          	lbu	a3,-1(a1)
 2be:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c2:	fee79ae3          	bne	a5,a4,2b6 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
    dst += n;
 2cc:	00c50733          	add	a4,a0,a2
    src += n;
 2d0:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d2:	fec05ae3          	blez	a2,2c6 <memmove+0x2c>
 2d6:	fff6079b          	addiw	a5,a2,-1
 2da:	1782                	slli	a5,a5,0x20
 2dc:	9381                	srli	a5,a5,0x20
 2de:	fff7c793          	not	a5,a5
 2e2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e4:	15fd                	addi	a1,a1,-1
 2e6:	177d                	addi	a4,a4,-1
 2e8:	0005c683          	lbu	a3,0(a1)
 2ec:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f0:	fee79ae3          	bne	a5,a4,2e4 <memmove+0x4a>
 2f4:	bfc9                	j	2c6 <memmove+0x2c>

00000000000002f6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fc:	ca05                	beqz	a2,32c <memcmp+0x36>
 2fe:	fff6069b          	addiw	a3,a2,-1
 302:	1682                	slli	a3,a3,0x20
 304:	9281                	srli	a3,a3,0x20
 306:	0685                	addi	a3,a3,1
 308:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 30a:	00054783          	lbu	a5,0(a0)
 30e:	0005c703          	lbu	a4,0(a1)
 312:	00e79863          	bne	a5,a4,322 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 316:	0505                	addi	a0,a0,1
    p2++;
 318:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 31a:	fed518e3          	bne	a0,a3,30a <memcmp+0x14>
  }
  return 0;
 31e:	4501                	li	a0,0
 320:	a019                	j	326 <memcmp+0x30>
      return *p1 - *p2;
 322:	40e7853b          	subw	a0,a5,a4
}
 326:	6422                	ld	s0,8(sp)
 328:	0141                	addi	sp,sp,16
 32a:	8082                	ret
  return 0;
 32c:	4501                	li	a0,0
 32e:	bfe5                	j	326 <memcmp+0x30>

0000000000000330 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 338:	00000097          	auipc	ra,0x0
 33c:	f62080e7          	jalr	-158(ra) # 29a <memmove>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 348:	4885                	li	a7,1
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exit>:
.global exit
exit:
 li a7, SYS_exit
 350:	4889                	li	a7,2
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <wait>:
.global wait
wait:
 li a7, SYS_wait
 358:	488d                	li	a7,3
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 360:	4891                	li	a7,4
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <read>:
.global read
read:
 li a7, SYS_read
 368:	4895                	li	a7,5
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <write>:
.global write
write:
 li a7, SYS_write
 370:	48c1                	li	a7,16
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <close>:
.global close
close:
 li a7, SYS_close
 378:	48d5                	li	a7,21
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <kill>:
.global kill
kill:
 li a7, SYS_kill
 380:	4899                	li	a7,6
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exec>:
.global exec
exec:
 li a7, SYS_exec
 388:	489d                	li	a7,7
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <open>:
.global open
open:
 li a7, SYS_open
 390:	48bd                	li	a7,15
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 398:	48c5                	li	a7,17
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a0:	48c9                	li	a7,18
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a8:	48a1                	li	a7,8
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <link>:
.global link
link:
 li a7, SYS_link
 3b0:	48cd                	li	a7,19
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b8:	48d1                	li	a7,20
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c0:	48a5                	li	a7,9
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c8:	48a9                	li	a7,10
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d0:	48ad                	li	a7,11
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d8:	48b1                	li	a7,12
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3e0:	48b5                	li	a7,13
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e8:	48b9                	li	a7,14
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <procnum>:
.global procnum
procnum:
 li a7, SYS_procnum
 3f0:	48d9                	li	a7,22
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <freemem>:
.global freemem
freemem:
 li a7, SYS_freemem
 3f8:	48dd                	li	a7,23
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <trace>:
.global trace
trace:
 li a7, SYS_trace
 400:	48e1                	li	a7,24
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 408:	1101                	addi	sp,sp,-32
 40a:	ec06                	sd	ra,24(sp)
 40c:	e822                	sd	s0,16(sp)
 40e:	1000                	addi	s0,sp,32
 410:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 414:	4605                	li	a2,1
 416:	fef40593          	addi	a1,s0,-17
 41a:	00000097          	auipc	ra,0x0
 41e:	f56080e7          	jalr	-170(ra) # 370 <write>
}
 422:	60e2                	ld	ra,24(sp)
 424:	6442                	ld	s0,16(sp)
 426:	6105                	addi	sp,sp,32
 428:	8082                	ret

000000000000042a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 42a:	7139                	addi	sp,sp,-64
 42c:	fc06                	sd	ra,56(sp)
 42e:	f822                	sd	s0,48(sp)
 430:	f426                	sd	s1,40(sp)
 432:	f04a                	sd	s2,32(sp)
 434:	ec4e                	sd	s3,24(sp)
 436:	0080                	addi	s0,sp,64
 438:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 43a:	c299                	beqz	a3,440 <printint+0x16>
 43c:	0805c863          	bltz	a1,4cc <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 440:	2581                	sext.w	a1,a1
  neg = 0;
 442:	4881                	li	a7,0
 444:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 448:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 44a:	2601                	sext.w	a2,a2
 44c:	00000517          	auipc	a0,0x0
 450:	47c50513          	addi	a0,a0,1148 # 8c8 <digits>
 454:	883a                	mv	a6,a4
 456:	2705                	addiw	a4,a4,1
 458:	02c5f7bb          	remuw	a5,a1,a2
 45c:	1782                	slli	a5,a5,0x20
 45e:	9381                	srli	a5,a5,0x20
 460:	97aa                	add	a5,a5,a0
 462:	0007c783          	lbu	a5,0(a5)
 466:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 46a:	0005879b          	sext.w	a5,a1
 46e:	02c5d5bb          	divuw	a1,a1,a2
 472:	0685                	addi	a3,a3,1
 474:	fec7f0e3          	bgeu	a5,a2,454 <printint+0x2a>
  if(neg)
 478:	00088b63          	beqz	a7,48e <printint+0x64>
    buf[i++] = '-';
 47c:	fd040793          	addi	a5,s0,-48
 480:	973e                	add	a4,a4,a5
 482:	02d00793          	li	a5,45
 486:	fef70823          	sb	a5,-16(a4)
 48a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 48e:	02e05863          	blez	a4,4be <printint+0x94>
 492:	fc040793          	addi	a5,s0,-64
 496:	00e78933          	add	s2,a5,a4
 49a:	fff78993          	addi	s3,a5,-1
 49e:	99ba                	add	s3,s3,a4
 4a0:	377d                	addiw	a4,a4,-1
 4a2:	1702                	slli	a4,a4,0x20
 4a4:	9301                	srli	a4,a4,0x20
 4a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4aa:	fff94583          	lbu	a1,-1(s2)
 4ae:	8526                	mv	a0,s1
 4b0:	00000097          	auipc	ra,0x0
 4b4:	f58080e7          	jalr	-168(ra) # 408 <putc>
  while(--i >= 0)
 4b8:	197d                	addi	s2,s2,-1
 4ba:	ff3918e3          	bne	s2,s3,4aa <printint+0x80>
}
 4be:	70e2                	ld	ra,56(sp)
 4c0:	7442                	ld	s0,48(sp)
 4c2:	74a2                	ld	s1,40(sp)
 4c4:	7902                	ld	s2,32(sp)
 4c6:	69e2                	ld	s3,24(sp)
 4c8:	6121                	addi	sp,sp,64
 4ca:	8082                	ret
    x = -xx;
 4cc:	40b005bb          	negw	a1,a1
    neg = 1;
 4d0:	4885                	li	a7,1
    x = -xx;
 4d2:	bf8d                	j	444 <printint+0x1a>

00000000000004d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4d4:	7119                	addi	sp,sp,-128
 4d6:	fc86                	sd	ra,120(sp)
 4d8:	f8a2                	sd	s0,112(sp)
 4da:	f4a6                	sd	s1,104(sp)
 4dc:	f0ca                	sd	s2,96(sp)
 4de:	ecce                	sd	s3,88(sp)
 4e0:	e8d2                	sd	s4,80(sp)
 4e2:	e4d6                	sd	s5,72(sp)
 4e4:	e0da                	sd	s6,64(sp)
 4e6:	fc5e                	sd	s7,56(sp)
 4e8:	f862                	sd	s8,48(sp)
 4ea:	f466                	sd	s9,40(sp)
 4ec:	f06a                	sd	s10,32(sp)
 4ee:	ec6e                	sd	s11,24(sp)
 4f0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f2:	0005c903          	lbu	s2,0(a1)
 4f6:	18090f63          	beqz	s2,694 <vprintf+0x1c0>
 4fa:	8aaa                	mv	s5,a0
 4fc:	8b32                	mv	s6,a2
 4fe:	00158493          	addi	s1,a1,1
  state = 0;
 502:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 504:	02500a13          	li	s4,37
      if(c == 'd'){
 508:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 50c:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 510:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 514:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 518:	00000b97          	auipc	s7,0x0
 51c:	3b0b8b93          	addi	s7,s7,944 # 8c8 <digits>
 520:	a839                	j	53e <vprintf+0x6a>
        putc(fd, c);
 522:	85ca                	mv	a1,s2
 524:	8556                	mv	a0,s5
 526:	00000097          	auipc	ra,0x0
 52a:	ee2080e7          	jalr	-286(ra) # 408 <putc>
 52e:	a019                	j	534 <vprintf+0x60>
    } else if(state == '%'){
 530:	01498f63          	beq	s3,s4,54e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 534:	0485                	addi	s1,s1,1
 536:	fff4c903          	lbu	s2,-1(s1)
 53a:	14090d63          	beqz	s2,694 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 53e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 542:	fe0997e3          	bnez	s3,530 <vprintf+0x5c>
      if(c == '%'){
 546:	fd479ee3          	bne	a5,s4,522 <vprintf+0x4e>
        state = '%';
 54a:	89be                	mv	s3,a5
 54c:	b7e5                	j	534 <vprintf+0x60>
      if(c == 'd'){
 54e:	05878063          	beq	a5,s8,58e <vprintf+0xba>
      } else if(c == 'l') {
 552:	05978c63          	beq	a5,s9,5aa <vprintf+0xd6>
      } else if(c == 'x') {
 556:	07a78863          	beq	a5,s10,5c6 <vprintf+0xf2>
      } else if(c == 'p') {
 55a:	09b78463          	beq	a5,s11,5e2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 55e:	07300713          	li	a4,115
 562:	0ce78663          	beq	a5,a4,62e <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 566:	06300713          	li	a4,99
 56a:	0ee78e63          	beq	a5,a4,666 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 56e:	11478863          	beq	a5,s4,67e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 572:	85d2                	mv	a1,s4
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	e92080e7          	jalr	-366(ra) # 408 <putc>
        putc(fd, c);
 57e:	85ca                	mv	a1,s2
 580:	8556                	mv	a0,s5
 582:	00000097          	auipc	ra,0x0
 586:	e86080e7          	jalr	-378(ra) # 408 <putc>
      }
      state = 0;
 58a:	4981                	li	s3,0
 58c:	b765                	j	534 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 58e:	008b0913          	addi	s2,s6,8
 592:	4685                	li	a3,1
 594:	4629                	li	a2,10
 596:	000b2583          	lw	a1,0(s6)
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	e8e080e7          	jalr	-370(ra) # 42a <printint>
 5a4:	8b4a                	mv	s6,s2
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b771                	j	534 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5aa:	008b0913          	addi	s2,s6,8
 5ae:	4681                	li	a3,0
 5b0:	4629                	li	a2,10
 5b2:	000b2583          	lw	a1,0(s6)
 5b6:	8556                	mv	a0,s5
 5b8:	00000097          	auipc	ra,0x0
 5bc:	e72080e7          	jalr	-398(ra) # 42a <printint>
 5c0:	8b4a                	mv	s6,s2
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	bf85                	j	534 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 5c6:	008b0913          	addi	s2,s6,8
 5ca:	4681                	li	a3,0
 5cc:	4641                	li	a2,16
 5ce:	000b2583          	lw	a1,0(s6)
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	e56080e7          	jalr	-426(ra) # 42a <printint>
 5dc:	8b4a                	mv	s6,s2
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bf91                	j	534 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 5e2:	008b0793          	addi	a5,s6,8
 5e6:	f8f43423          	sd	a5,-120(s0)
 5ea:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 5ee:	03000593          	li	a1,48
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e14080e7          	jalr	-492(ra) # 408 <putc>
  putc(fd, 'x');
 5fc:	85ea                	mv	a1,s10
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	e08080e7          	jalr	-504(ra) # 408 <putc>
 608:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60a:	03c9d793          	srli	a5,s3,0x3c
 60e:	97de                	add	a5,a5,s7
 610:	0007c583          	lbu	a1,0(a5)
 614:	8556                	mv	a0,s5
 616:	00000097          	auipc	ra,0x0
 61a:	df2080e7          	jalr	-526(ra) # 408 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61e:	0992                	slli	s3,s3,0x4
 620:	397d                	addiw	s2,s2,-1
 622:	fe0914e3          	bnez	s2,60a <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 626:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b721                	j	534 <vprintf+0x60>
        s = va_arg(ap, char*);
 62e:	008b0993          	addi	s3,s6,8
 632:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 636:	02090163          	beqz	s2,658 <vprintf+0x184>
        while(*s != 0){
 63a:	00094583          	lbu	a1,0(s2)
 63e:	c9a1                	beqz	a1,68e <vprintf+0x1ba>
          putc(fd, *s);
 640:	8556                	mv	a0,s5
 642:	00000097          	auipc	ra,0x0
 646:	dc6080e7          	jalr	-570(ra) # 408 <putc>
          s++;
 64a:	0905                	addi	s2,s2,1
        while(*s != 0){
 64c:	00094583          	lbu	a1,0(s2)
 650:	f9e5                	bnez	a1,640 <vprintf+0x16c>
        s = va_arg(ap, char*);
 652:	8b4e                	mv	s6,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	bdf9                	j	534 <vprintf+0x60>
          s = "(null)";
 658:	00000917          	auipc	s2,0x0
 65c:	26890913          	addi	s2,s2,616 # 8c0 <malloc+0x122>
        while(*s != 0){
 660:	02800593          	li	a1,40
 664:	bff1                	j	640 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 666:	008b0913          	addi	s2,s6,8
 66a:	000b4583          	lbu	a1,0(s6)
 66e:	8556                	mv	a0,s5
 670:	00000097          	auipc	ra,0x0
 674:	d98080e7          	jalr	-616(ra) # 408 <putc>
 678:	8b4a                	mv	s6,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	bd65                	j	534 <vprintf+0x60>
        putc(fd, c);
 67e:	85d2                	mv	a1,s4
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	d86080e7          	jalr	-634(ra) # 408 <putc>
      state = 0;
 68a:	4981                	li	s3,0
 68c:	b565                	j	534 <vprintf+0x60>
        s = va_arg(ap, char*);
 68e:	8b4e                	mv	s6,s3
      state = 0;
 690:	4981                	li	s3,0
 692:	b54d                	j	534 <vprintf+0x60>
    }
  }
}
 694:	70e6                	ld	ra,120(sp)
 696:	7446                	ld	s0,112(sp)
 698:	74a6                	ld	s1,104(sp)
 69a:	7906                	ld	s2,96(sp)
 69c:	69e6                	ld	s3,88(sp)
 69e:	6a46                	ld	s4,80(sp)
 6a0:	6aa6                	ld	s5,72(sp)
 6a2:	6b06                	ld	s6,64(sp)
 6a4:	7be2                	ld	s7,56(sp)
 6a6:	7c42                	ld	s8,48(sp)
 6a8:	7ca2                	ld	s9,40(sp)
 6aa:	7d02                	ld	s10,32(sp)
 6ac:	6de2                	ld	s11,24(sp)
 6ae:	6109                	addi	sp,sp,128
 6b0:	8082                	ret

00000000000006b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b2:	715d                	addi	sp,sp,-80
 6b4:	ec06                	sd	ra,24(sp)
 6b6:	e822                	sd	s0,16(sp)
 6b8:	1000                	addi	s0,sp,32
 6ba:	e010                	sd	a2,0(s0)
 6bc:	e414                	sd	a3,8(s0)
 6be:	e818                	sd	a4,16(s0)
 6c0:	ec1c                	sd	a5,24(s0)
 6c2:	03043023          	sd	a6,32(s0)
 6c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ce:	8622                	mv	a2,s0
 6d0:	00000097          	auipc	ra,0x0
 6d4:	e04080e7          	jalr	-508(ra) # 4d4 <vprintf>
}
 6d8:	60e2                	ld	ra,24(sp)
 6da:	6442                	ld	s0,16(sp)
 6dc:	6161                	addi	sp,sp,80
 6de:	8082                	ret

00000000000006e0 <printf>:

void
printf(const char *fmt, ...)
{
 6e0:	711d                	addi	sp,sp,-96
 6e2:	ec06                	sd	ra,24(sp)
 6e4:	e822                	sd	s0,16(sp)
 6e6:	1000                	addi	s0,sp,32
 6e8:	e40c                	sd	a1,8(s0)
 6ea:	e810                	sd	a2,16(s0)
 6ec:	ec14                	sd	a3,24(s0)
 6ee:	f018                	sd	a4,32(s0)
 6f0:	f41c                	sd	a5,40(s0)
 6f2:	03043823          	sd	a6,48(s0)
 6f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6fa:	00840613          	addi	a2,s0,8
 6fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 702:	85aa                	mv	a1,a0
 704:	4505                	li	a0,1
 706:	00000097          	auipc	ra,0x0
 70a:	dce080e7          	jalr	-562(ra) # 4d4 <vprintf>
}
 70e:	60e2                	ld	ra,24(sp)
 710:	6442                	ld	s0,16(sp)
 712:	6125                	addi	sp,sp,96
 714:	8082                	ret

0000000000000716 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 716:	1141                	addi	sp,sp,-16
 718:	e422                	sd	s0,8(sp)
 71a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 720:	00001797          	auipc	a5,0x1
 724:	8e07b783          	ld	a5,-1824(a5) # 1000 <freep>
 728:	a805                	j	758 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 72a:	4618                	lw	a4,8(a2)
 72c:	9db9                	addw	a1,a1,a4
 72e:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 732:	6398                	ld	a4,0(a5)
 734:	6318                	ld	a4,0(a4)
 736:	fee53823          	sd	a4,-16(a0)
 73a:	a091                	j	77e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 73c:	ff852703          	lw	a4,-8(a0)
 740:	9e39                	addw	a2,a2,a4
 742:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 744:	ff053703          	ld	a4,-16(a0)
 748:	e398                	sd	a4,0(a5)
 74a:	a099                	j	790 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74c:	6398                	ld	a4,0(a5)
 74e:	00e7e463          	bltu	a5,a4,756 <free+0x40>
 752:	00e6ea63          	bltu	a3,a4,766 <free+0x50>
{
 756:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	fed7fae3          	bgeu	a5,a3,74c <free+0x36>
 75c:	6398                	ld	a4,0(a5)
 75e:	00e6e463          	bltu	a3,a4,766 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	fee7eae3          	bltu	a5,a4,756 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 766:	ff852583          	lw	a1,-8(a0)
 76a:	6390                	ld	a2,0(a5)
 76c:	02059713          	slli	a4,a1,0x20
 770:	9301                	srli	a4,a4,0x20
 772:	0712                	slli	a4,a4,0x4
 774:	9736                	add	a4,a4,a3
 776:	fae60ae3          	beq	a2,a4,72a <free+0x14>
    bp->s.ptr = p->s.ptr;
 77a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77e:	4790                	lw	a2,8(a5)
 780:	02061713          	slli	a4,a2,0x20
 784:	9301                	srli	a4,a4,0x20
 786:	0712                	slli	a4,a4,0x4
 788:	973e                	add	a4,a4,a5
 78a:	fae689e3          	beq	a3,a4,73c <free+0x26>
  } else
    p->s.ptr = bp;
 78e:	e394                	sd	a3,0(a5)
  freep = p;
 790:	00001717          	auipc	a4,0x1
 794:	86f73823          	sd	a5,-1936(a4) # 1000 <freep>
}
 798:	6422                	ld	s0,8(sp)
 79a:	0141                	addi	sp,sp,16
 79c:	8082                	ret

000000000000079e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79e:	7139                	addi	sp,sp,-64
 7a0:	fc06                	sd	ra,56(sp)
 7a2:	f822                	sd	s0,48(sp)
 7a4:	f426                	sd	s1,40(sp)
 7a6:	f04a                	sd	s2,32(sp)
 7a8:	ec4e                	sd	s3,24(sp)
 7aa:	e852                	sd	s4,16(sp)
 7ac:	e456                	sd	s5,8(sp)
 7ae:	e05a                	sd	s6,0(sp)
 7b0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b2:	02051493          	slli	s1,a0,0x20
 7b6:	9081                	srli	s1,s1,0x20
 7b8:	04bd                	addi	s1,s1,15
 7ba:	8091                	srli	s1,s1,0x4
 7bc:	0014899b          	addiw	s3,s1,1
 7c0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c2:	00001517          	auipc	a0,0x1
 7c6:	83e53503          	ld	a0,-1986(a0) # 1000 <freep>
 7ca:	c515                	beqz	a0,7f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7cc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ce:	4798                	lw	a4,8(a5)
 7d0:	02977f63          	bgeu	a4,s1,80e <malloc+0x70>
 7d4:	8a4e                	mv	s4,s3
 7d6:	0009871b          	sext.w	a4,s3
 7da:	6685                	lui	a3,0x1
 7dc:	00d77363          	bgeu	a4,a3,7e2 <malloc+0x44>
 7e0:	6a05                	lui	s4,0x1
 7e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7ea:	00001917          	auipc	s2,0x1
 7ee:	81690913          	addi	s2,s2,-2026 # 1000 <freep>
  if(p == (char*)-1)
 7f2:	5afd                	li	s5,-1
 7f4:	a88d                	j	866 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 7f6:	00001797          	auipc	a5,0x1
 7fa:	81a78793          	addi	a5,a5,-2022 # 1010 <base>
 7fe:	00001717          	auipc	a4,0x1
 802:	80f73123          	sd	a5,-2046(a4) # 1000 <freep>
 806:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 808:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 80c:	b7e1                	j	7d4 <malloc+0x36>
      if(p->s.size == nunits)
 80e:	02e48b63          	beq	s1,a4,844 <malloc+0xa6>
        p->s.size -= nunits;
 812:	4137073b          	subw	a4,a4,s3
 816:	c798                	sw	a4,8(a5)
        p += p->s.size;
 818:	1702                	slli	a4,a4,0x20
 81a:	9301                	srli	a4,a4,0x20
 81c:	0712                	slli	a4,a4,0x4
 81e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 820:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 824:	00000717          	auipc	a4,0x0
 828:	7ca73e23          	sd	a0,2012(a4) # 1000 <freep>
      return (void*)(p + 1);
 82c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 830:	70e2                	ld	ra,56(sp)
 832:	7442                	ld	s0,48(sp)
 834:	74a2                	ld	s1,40(sp)
 836:	7902                	ld	s2,32(sp)
 838:	69e2                	ld	s3,24(sp)
 83a:	6a42                	ld	s4,16(sp)
 83c:	6aa2                	ld	s5,8(sp)
 83e:	6b02                	ld	s6,0(sp)
 840:	6121                	addi	sp,sp,64
 842:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 844:	6398                	ld	a4,0(a5)
 846:	e118                	sd	a4,0(a0)
 848:	bff1                	j	824 <malloc+0x86>
  hp->s.size = nu;
 84a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 84e:	0541                	addi	a0,a0,16
 850:	00000097          	auipc	ra,0x0
 854:	ec6080e7          	jalr	-314(ra) # 716 <free>
  return freep;
 858:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 85c:	d971                	beqz	a0,830 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 860:	4798                	lw	a4,8(a5)
 862:	fa9776e3          	bgeu	a4,s1,80e <malloc+0x70>
    if(p == freep)
 866:	00093703          	ld	a4,0(s2)
 86a:	853e                	mv	a0,a5
 86c:	fef719e3          	bne	a4,a5,85e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 870:	8552                	mv	a0,s4
 872:	00000097          	auipc	ra,0x0
 876:	b66080e7          	jalr	-1178(ra) # 3d8 <sbrk>
  if(p == (char*)-1)
 87a:	fd5518e3          	bne	a0,s5,84a <malloc+0xac>
        return 0;
 87e:	4501                	li	a0,0
 880:	bf45                	j	830 <malloc+0x92>
