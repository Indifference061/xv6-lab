
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a4813103          	ld	sp,-1464(sp) # 80008a48 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	0b7050ef          	jal	ra,800058cc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	0d078793          	addi	a5,a5,208 # 80022100 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	156080e7          	jalr	342(ra) # 8000019e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	a4090913          	addi	s2,s2,-1472 # 80008a90 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	272080e7          	jalr	626(ra) # 800062cc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	312080e7          	jalr	786(ra) # 80006380 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	cf8080e7          	jalr	-776(ra) # 80005d82 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	9a450513          	addi	a0,a0,-1628 # 80008a90 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	148080e7          	jalr	328(ra) # 8000623c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	00050513          	mv	a0,a0
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	96e48493          	addi	s1,s1,-1682 # 80008a90 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	1a0080e7          	jalr	416(ra) # 800062cc <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	95650513          	addi	a0,a0,-1706 # 80008a90 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	23c080e7          	jalr	572(ra) # 80006380 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	04c080e7          	jalr	76(ra) # 8000019e <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	92a50513          	addi	a0,a0,-1750 # 80008a90 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	212080e7          	jalr	530(ra) # 80006380 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <free_mem>:

//new
uint64 
free_mem(void)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  struct run *r;
  r=kmem.freelist;
    8000017e:	00009797          	auipc	a5,0x9
    80000182:	92a7b783          	ld	a5,-1750(a5) # 80008aa8 <kmem+0x18>
  int cnt=0;
  while(r)
    80000186:	cb91                	beqz	a5,8000019a <free_mem+0x22>
  int cnt=0;
    80000188:	4501                	li	a0,0
  {
    cnt++;
    8000018a:	2505                	addiw	a0,a0,1
    r=r->next;
    8000018c:	639c                	ld	a5,0(a5)
  while(r)
    8000018e:	fff5                	bnez	a5,8000018a <free_mem+0x12>
  }
  return cnt*PGSIZE;
    80000190:	00c5151b          	slliw	a0,a0,0xc
    80000194:	6422                	ld	s0,8(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret
  int cnt=0;
    8000019a:	4501                	li	a0,0
    8000019c:	bfd5                	j	80000190 <free_mem+0x18>

000000008000019e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a4:	ce09                	beqz	a2,800001be <memset+0x20>
    800001a6:	87aa                	mv	a5,a0
    800001a8:	fff6071b          	addiw	a4,a2,-1
    800001ac:	1702                	slli	a4,a4,0x20
    800001ae:	9301                	srli	a4,a4,0x20
    800001b0:	0705                	addi	a4,a4,1
    800001b2:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b8:	0785                	addi	a5,a5,1
    800001ba:	fee79de3          	bne	a5,a4,800001b4 <memset+0x16>
  }
  return dst;
}
    800001be:	6422                	ld	s0,8(sp)
    800001c0:	0141                	addi	sp,sp,16
    800001c2:	8082                	ret

00000000800001c4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c4:	1141                	addi	sp,sp,-16
    800001c6:	e422                	sd	s0,8(sp)
    800001c8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001ca:	ca05                	beqz	a2,800001fa <memcmp+0x36>
    800001cc:	fff6069b          	addiw	a3,a2,-1
    800001d0:	1682                	slli	a3,a3,0x20
    800001d2:	9281                	srli	a3,a3,0x20
    800001d4:	0685                	addi	a3,a3,1
    800001d6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d8:	00054783          	lbu	a5,0(a0)
    800001dc:	0005c703          	lbu	a4,0(a1)
    800001e0:	00e79863          	bne	a5,a4,800001f0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e4:	0505                	addi	a0,a0,1
    800001e6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e8:	fed518e3          	bne	a0,a3,800001d8 <memcmp+0x14>
  }

  return 0;
    800001ec:	4501                	li	a0,0
    800001ee:	a019                	j	800001f4 <memcmp+0x30>
      return *s1 - *s2;
    800001f0:	40e7853b          	subw	a0,a5,a4
}
    800001f4:	6422                	ld	s0,8(sp)
    800001f6:	0141                	addi	sp,sp,16
    800001f8:	8082                	ret
  return 0;
    800001fa:	4501                	li	a0,0
    800001fc:	bfe5                	j	800001f4 <memcmp+0x30>

00000000800001fe <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fe:	1141                	addi	sp,sp,-16
    80000200:	e422                	sd	s0,8(sp)
    80000202:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000204:	ca0d                	beqz	a2,80000236 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000206:	00a5f963          	bgeu	a1,a0,80000218 <memmove+0x1a>
    8000020a:	02061693          	slli	a3,a2,0x20
    8000020e:	9281                	srli	a3,a3,0x20
    80000210:	00d58733          	add	a4,a1,a3
    80000214:	02e56463          	bltu	a0,a4,8000023c <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	0785                	addi	a5,a5,1
    80000222:	97ae                	add	a5,a5,a1
    80000224:	872a                	mv	a4,a0
      *d++ = *s++;
    80000226:	0585                	addi	a1,a1,1
    80000228:	0705                	addi	a4,a4,1
    8000022a:	fff5c683          	lbu	a3,-1(a1)
    8000022e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000232:	fef59ae3          	bne	a1,a5,80000226 <memmove+0x28>

  return dst;
}
    80000236:	6422                	ld	s0,8(sp)
    80000238:	0141                	addi	sp,sp,16
    8000023a:	8082                	ret
    d += n;
    8000023c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000023e:	fff6079b          	addiw	a5,a2,-1
    80000242:	1782                	slli	a5,a5,0x20
    80000244:	9381                	srli	a5,a5,0x20
    80000246:	fff7c793          	not	a5,a5
    8000024a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000024c:	177d                	addi	a4,a4,-1
    8000024e:	16fd                	addi	a3,a3,-1
    80000250:	00074603          	lbu	a2,0(a4)
    80000254:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000258:	fef71ae3          	bne	a4,a5,8000024c <memmove+0x4e>
    8000025c:	bfe9                	j	80000236 <memmove+0x38>

000000008000025e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000025e:	1141                	addi	sp,sp,-16
    80000260:	e406                	sd	ra,8(sp)
    80000262:	e022                	sd	s0,0(sp)
    80000264:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000266:	00000097          	auipc	ra,0x0
    8000026a:	f98080e7          	jalr	-104(ra) # 800001fe <memmove>
}
    8000026e:	60a2                	ld	ra,8(sp)
    80000270:	6402                	ld	s0,0(sp)
    80000272:	0141                	addi	sp,sp,16
    80000274:	8082                	ret

0000000080000276 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000276:	1141                	addi	sp,sp,-16
    80000278:	e422                	sd	s0,8(sp)
    8000027a:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000027c:	ce11                	beqz	a2,80000298 <strncmp+0x22>
    8000027e:	00054783          	lbu	a5,0(a0)
    80000282:	cf89                	beqz	a5,8000029c <strncmp+0x26>
    80000284:	0005c703          	lbu	a4,0(a1)
    80000288:	00f71a63          	bne	a4,a5,8000029c <strncmp+0x26>
    n--, p++, q++;
    8000028c:	367d                	addiw	a2,a2,-1
    8000028e:	0505                	addi	a0,a0,1
    80000290:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000292:	f675                	bnez	a2,8000027e <strncmp+0x8>
  if(n == 0)
    return 0;
    80000294:	4501                	li	a0,0
    80000296:	a809                	j	800002a8 <strncmp+0x32>
    80000298:	4501                	li	a0,0
    8000029a:	a039                	j	800002a8 <strncmp+0x32>
  if(n == 0)
    8000029c:	ca09                	beqz	a2,800002ae <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000029e:	00054503          	lbu	a0,0(a0)
    800002a2:	0005c783          	lbu	a5,0(a1)
    800002a6:	9d1d                	subw	a0,a0,a5
}
    800002a8:	6422                	ld	s0,8(sp)
    800002aa:	0141                	addi	sp,sp,16
    800002ac:	8082                	ret
    return 0;
    800002ae:	4501                	li	a0,0
    800002b0:	bfe5                	j	800002a8 <strncmp+0x32>

00000000800002b2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e422                	sd	s0,8(sp)
    800002b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b8:	872a                	mv	a4,a0
    800002ba:	8832                	mv	a6,a2
    800002bc:	367d                	addiw	a2,a2,-1
    800002be:	01005963          	blez	a6,800002d0 <strncpy+0x1e>
    800002c2:	0705                	addi	a4,a4,1
    800002c4:	0005c783          	lbu	a5,0(a1)
    800002c8:	fef70fa3          	sb	a5,-1(a4)
    800002cc:	0585                	addi	a1,a1,1
    800002ce:	f7f5                	bnez	a5,800002ba <strncpy+0x8>
    ;
  while(n-- > 0)
    800002d0:	00c05d63          	blez	a2,800002ea <strncpy+0x38>
    800002d4:	86ba                	mv	a3,a4
    *s++ = 0;
    800002d6:	0685                	addi	a3,a3,1
    800002d8:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002dc:	fff6c793          	not	a5,a3
    800002e0:	9fb9                	addw	a5,a5,a4
    800002e2:	010787bb          	addw	a5,a5,a6
    800002e6:	fef048e3          	bgtz	a5,800002d6 <strncpy+0x24>
  return os;
}
    800002ea:	6422                	ld	s0,8(sp)
    800002ec:	0141                	addi	sp,sp,16
    800002ee:	8082                	ret

00000000800002f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002f0:	1141                	addi	sp,sp,-16
    800002f2:	e422                	sd	s0,8(sp)
    800002f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002f6:	02c05363          	blez	a2,8000031c <safestrcpy+0x2c>
    800002fa:	fff6069b          	addiw	a3,a2,-1
    800002fe:	1682                	slli	a3,a3,0x20
    80000300:	9281                	srli	a3,a3,0x20
    80000302:	96ae                	add	a3,a3,a1
    80000304:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000306:	00d58963          	beq	a1,a3,80000318 <safestrcpy+0x28>
    8000030a:	0585                	addi	a1,a1,1
    8000030c:	0785                	addi	a5,a5,1
    8000030e:	fff5c703          	lbu	a4,-1(a1)
    80000312:	fee78fa3          	sb	a4,-1(a5)
    80000316:	fb65                	bnez	a4,80000306 <safestrcpy+0x16>
    ;
  *s = 0;
    80000318:	00078023          	sb	zero,0(a5)
  return os;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret

0000000080000322 <strlen>:

int
strlen(const char *s)
{
    80000322:	1141                	addi	sp,sp,-16
    80000324:	e422                	sd	s0,8(sp)
    80000326:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000328:	00054783          	lbu	a5,0(a0)
    8000032c:	cf91                	beqz	a5,80000348 <strlen+0x26>
    8000032e:	0505                	addi	a0,a0,1
    80000330:	87aa                	mv	a5,a0
    80000332:	4685                	li	a3,1
    80000334:	9e89                	subw	a3,a3,a0
    80000336:	00f6853b          	addw	a0,a3,a5
    8000033a:	0785                	addi	a5,a5,1
    8000033c:	fff7c703          	lbu	a4,-1(a5)
    80000340:	fb7d                	bnez	a4,80000336 <strlen+0x14>
    ;
  return n;
}
    80000342:	6422                	ld	s0,8(sp)
    80000344:	0141                	addi	sp,sp,16
    80000346:	8082                	ret
  for(n = 0; s[n]; n++)
    80000348:	4501                	li	a0,0
    8000034a:	bfe5                	j	80000342 <strlen+0x20>

000000008000034c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000034c:	1141                	addi	sp,sp,-16
    8000034e:	e406                	sd	ra,8(sp)
    80000350:	e022                	sd	s0,0(sp)
    80000352:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000354:	00001097          	auipc	ra,0x1
    80000358:	afe080e7          	jalr	-1282(ra) # 80000e52 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000035c:	00008717          	auipc	a4,0x8
    80000360:	70470713          	addi	a4,a4,1796 # 80008a60 <started>
  if(cpuid() == 0){
    80000364:	c139                	beqz	a0,800003aa <main+0x5e>
    while(started == 0)
    80000366:	431c                	lw	a5,0(a4)
    80000368:	2781                	sext.w	a5,a5
    8000036a:	dff5                	beqz	a5,80000366 <main+0x1a>
      ;
    __sync_synchronize();
    8000036c:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000370:	00001097          	auipc	ra,0x1
    80000374:	ae2080e7          	jalr	-1310(ra) # 80000e52 <cpuid>
    80000378:	85aa                	mv	a1,a0
    8000037a:	00008517          	auipc	a0,0x8
    8000037e:	cbe50513          	addi	a0,a0,-834 # 80008038 <etext+0x38>
    80000382:	00006097          	auipc	ra,0x6
    80000386:	a4a080e7          	jalr	-1462(ra) # 80005dcc <printf>
    kvminithart();    // turn on paging
    8000038a:	00000097          	auipc	ra,0x0
    8000038e:	0d8080e7          	jalr	216(ra) # 80000462 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000392:	00001097          	auipc	ra,0x1
    80000396:	7e0080e7          	jalr	2016(ra) # 80001b72 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000039a:	00005097          	auipc	ra,0x5
    8000039e:	e86080e7          	jalr	-378(ra) # 80005220 <plicinithart>
  }

  scheduler();        
    800003a2:	00001097          	auipc	ra,0x1
    800003a6:	fd6080e7          	jalr	-42(ra) # 80001378 <scheduler>
    consoleinit();
    800003aa:	00006097          	auipc	ra,0x6
    800003ae:	8ea080e7          	jalr	-1814(ra) # 80005c94 <consoleinit>
    printfinit();
    800003b2:	00006097          	auipc	ra,0x6
    800003b6:	c00080e7          	jalr	-1024(ra) # 80005fb2 <printfinit>
    printf("\n");
    800003ba:	00008517          	auipc	a0,0x8
    800003be:	c8e50513          	addi	a0,a0,-882 # 80008048 <etext+0x48>
    800003c2:	00006097          	auipc	ra,0x6
    800003c6:	a0a080e7          	jalr	-1526(ra) # 80005dcc <printf>
    printf("xv6 kernel is booting\n");
    800003ca:	00008517          	auipc	a0,0x8
    800003ce:	c5650513          	addi	a0,a0,-938 # 80008020 <etext+0x20>
    800003d2:	00006097          	auipc	ra,0x6
    800003d6:	9fa080e7          	jalr	-1542(ra) # 80005dcc <printf>
    printf("\n");
    800003da:	00008517          	auipc	a0,0x8
    800003de:	c6e50513          	addi	a0,a0,-914 # 80008048 <etext+0x48>
    800003e2:	00006097          	auipc	ra,0x6
    800003e6:	9ea080e7          	jalr	-1558(ra) # 80005dcc <printf>
    kinit();         // physical page allocator
    800003ea:	00000097          	auipc	ra,0x0
    800003ee:	cf2080e7          	jalr	-782(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003f2:	00000097          	auipc	ra,0x0
    800003f6:	326080e7          	jalr	806(ra) # 80000718 <kvminit>
    kvminithart();   // turn on paging
    800003fa:	00000097          	auipc	ra,0x0
    800003fe:	068080e7          	jalr	104(ra) # 80000462 <kvminithart>
    procinit();      // process table
    80000402:	00001097          	auipc	ra,0x1
    80000406:	99c080e7          	jalr	-1636(ra) # 80000d9e <procinit>
    trapinit();      // trap vectors
    8000040a:	00001097          	auipc	ra,0x1
    8000040e:	740080e7          	jalr	1856(ra) # 80001b4a <trapinit>
    trapinithart();  // install kernel trap vector
    80000412:	00001097          	auipc	ra,0x1
    80000416:	760080e7          	jalr	1888(ra) # 80001b72 <trapinithart>
    plicinit();      // set up interrupt controller
    8000041a:	00005097          	auipc	ra,0x5
    8000041e:	df0080e7          	jalr	-528(ra) # 8000520a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000422:	00005097          	auipc	ra,0x5
    80000426:	dfe080e7          	jalr	-514(ra) # 80005220 <plicinithart>
    binit();         // buffer cache
    8000042a:	00002097          	auipc	ra,0x2
    8000042e:	faa080e7          	jalr	-86(ra) # 800023d4 <binit>
    iinit();         // inode table
    80000432:	00002097          	auipc	ra,0x2
    80000436:	64e080e7          	jalr	1614(ra) # 80002a80 <iinit>
    fileinit();      // file table
    8000043a:	00003097          	auipc	ra,0x3
    8000043e:	5ec080e7          	jalr	1516(ra) # 80003a26 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000442:	00005097          	auipc	ra,0x5
    80000446:	ee6080e7          	jalr	-282(ra) # 80005328 <virtio_disk_init>
    userinit();      // first user process
    8000044a:	00001097          	auipc	ra,0x1
    8000044e:	d0c080e7          	jalr	-756(ra) # 80001156 <userinit>
    __sync_synchronize();
    80000452:	0ff0000f          	fence
    started = 1;
    80000456:	4785                	li	a5,1
    80000458:	00008717          	auipc	a4,0x8
    8000045c:	60f72423          	sw	a5,1544(a4) # 80008a60 <started>
    80000460:	b789                	j	800003a2 <main+0x56>

0000000080000462 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000462:	1141                	addi	sp,sp,-16
    80000464:	e422                	sd	s0,8(sp)
    80000466:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000468:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000046c:	00008797          	auipc	a5,0x8
    80000470:	5fc7b783          	ld	a5,1532(a5) # 80008a68 <kernel_pagetable>
    80000474:	83b1                	srli	a5,a5,0xc
    80000476:	577d                	li	a4,-1
    80000478:	177e                	slli	a4,a4,0x3f
    8000047a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000047c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000480:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000484:	6422                	ld	s0,8(sp)
    80000486:	0141                	addi	sp,sp,16
    80000488:	8082                	ret

000000008000048a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000048a:	7139                	addi	sp,sp,-64
    8000048c:	fc06                	sd	ra,56(sp)
    8000048e:	f822                	sd	s0,48(sp)
    80000490:	f426                	sd	s1,40(sp)
    80000492:	f04a                	sd	s2,32(sp)
    80000494:	ec4e                	sd	s3,24(sp)
    80000496:	e852                	sd	s4,16(sp)
    80000498:	e456                	sd	s5,8(sp)
    8000049a:	e05a                	sd	s6,0(sp)
    8000049c:	0080                	addi	s0,sp,64
    8000049e:	84aa                	mv	s1,a0
    800004a0:	89ae                	mv	s3,a1
    800004a2:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004a4:	57fd                	li	a5,-1
    800004a6:	83e9                	srli	a5,a5,0x1a
    800004a8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004aa:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004ac:	04b7f263          	bgeu	a5,a1,800004f0 <walk+0x66>
    panic("walk");
    800004b0:	00008517          	auipc	a0,0x8
    800004b4:	ba050513          	addi	a0,a0,-1120 # 80008050 <etext+0x50>
    800004b8:	00006097          	auipc	ra,0x6
    800004bc:	8ca080e7          	jalr	-1846(ra) # 80005d82 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004c0:	060a8663          	beqz	s5,8000052c <walk+0xa2>
    800004c4:	00000097          	auipc	ra,0x0
    800004c8:	c54080e7          	jalr	-940(ra) # 80000118 <kalloc>
    800004cc:	84aa                	mv	s1,a0
    800004ce:	c529                	beqz	a0,80000518 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004d0:	6605                	lui	a2,0x1
    800004d2:	4581                	li	a1,0
    800004d4:	00000097          	auipc	ra,0x0
    800004d8:	cca080e7          	jalr	-822(ra) # 8000019e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004dc:	00c4d793          	srli	a5,s1,0xc
    800004e0:	07aa                	slli	a5,a5,0xa
    800004e2:	0017e793          	ori	a5,a5,1
    800004e6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004ea:	3a5d                	addiw	s4,s4,-9
    800004ec:	036a0063          	beq	s4,s6,8000050c <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004f0:	0149d933          	srl	s2,s3,s4
    800004f4:	1ff97913          	andi	s2,s2,511
    800004f8:	090e                	slli	s2,s2,0x3
    800004fa:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004fc:	00093483          	ld	s1,0(s2)
    80000500:	0014f793          	andi	a5,s1,1
    80000504:	dfd5                	beqz	a5,800004c0 <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000506:	80a9                	srli	s1,s1,0xa
    80000508:	04b2                	slli	s1,s1,0xc
    8000050a:	b7c5                	j	800004ea <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000050c:	00c9d513          	srli	a0,s3,0xc
    80000510:	1ff57513          	andi	a0,a0,511
    80000514:	050e                	slli	a0,a0,0x3
    80000516:	9526                	add	a0,a0,s1
}
    80000518:	70e2                	ld	ra,56(sp)
    8000051a:	7442                	ld	s0,48(sp)
    8000051c:	74a2                	ld	s1,40(sp)
    8000051e:	7902                	ld	s2,32(sp)
    80000520:	69e2                	ld	s3,24(sp)
    80000522:	6a42                	ld	s4,16(sp)
    80000524:	6aa2                	ld	s5,8(sp)
    80000526:	6b02                	ld	s6,0(sp)
    80000528:	6121                	addi	sp,sp,64
    8000052a:	8082                	ret
        return 0;
    8000052c:	4501                	li	a0,0
    8000052e:	b7ed                	j	80000518 <walk+0x8e>

0000000080000530 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000530:	57fd                	li	a5,-1
    80000532:	83e9                	srli	a5,a5,0x1a
    80000534:	00b7f463          	bgeu	a5,a1,8000053c <walkaddr+0xc>
    return 0;
    80000538:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000053a:	8082                	ret
{
    8000053c:	1141                	addi	sp,sp,-16
    8000053e:	e406                	sd	ra,8(sp)
    80000540:	e022                	sd	s0,0(sp)
    80000542:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000544:	4601                	li	a2,0
    80000546:	00000097          	auipc	ra,0x0
    8000054a:	f44080e7          	jalr	-188(ra) # 8000048a <walk>
  if(pte == 0)
    8000054e:	c105                	beqz	a0,8000056e <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    80000550:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000552:	0117f693          	andi	a3,a5,17
    80000556:	4745                	li	a4,17
    return 0;
    80000558:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000055a:	00e68663          	beq	a3,a4,80000566 <walkaddr+0x36>
}
    8000055e:	60a2                	ld	ra,8(sp)
    80000560:	6402                	ld	s0,0(sp)
    80000562:	0141                	addi	sp,sp,16
    80000564:	8082                	ret
  pa = PTE2PA(*pte);
    80000566:	00a7d513          	srli	a0,a5,0xa
    8000056a:	0532                	slli	a0,a0,0xc
  return pa;
    8000056c:	bfcd                	j	8000055e <walkaddr+0x2e>
    return 0;
    8000056e:	4501                	li	a0,0
    80000570:	b7fd                	j	8000055e <walkaddr+0x2e>

0000000080000572 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000572:	715d                	addi	sp,sp,-80
    80000574:	e486                	sd	ra,72(sp)
    80000576:	e0a2                	sd	s0,64(sp)
    80000578:	fc26                	sd	s1,56(sp)
    8000057a:	f84a                	sd	s2,48(sp)
    8000057c:	f44e                	sd	s3,40(sp)
    8000057e:	f052                	sd	s4,32(sp)
    80000580:	ec56                	sd	s5,24(sp)
    80000582:	e85a                	sd	s6,16(sp)
    80000584:	e45e                	sd	s7,8(sp)
    80000586:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000588:	c205                	beqz	a2,800005a8 <mappages+0x36>
    8000058a:	8aaa                	mv	s5,a0
    8000058c:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000058e:	77fd                	lui	a5,0xfffff
    80000590:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000594:	15fd                	addi	a1,a1,-1
    80000596:	00c589b3          	add	s3,a1,a2
    8000059a:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000059e:	8952                	mv	s2,s4
    800005a0:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005a4:	6b85                	lui	s7,0x1
    800005a6:	a015                	j	800005ca <mappages+0x58>
    panic("mappages: size");
    800005a8:	00008517          	auipc	a0,0x8
    800005ac:	ab050513          	addi	a0,a0,-1360 # 80008058 <etext+0x58>
    800005b0:	00005097          	auipc	ra,0x5
    800005b4:	7d2080e7          	jalr	2002(ra) # 80005d82 <panic>
      panic("mappages: remap");
    800005b8:	00008517          	auipc	a0,0x8
    800005bc:	ab050513          	addi	a0,a0,-1360 # 80008068 <etext+0x68>
    800005c0:	00005097          	auipc	ra,0x5
    800005c4:	7c2080e7          	jalr	1986(ra) # 80005d82 <panic>
    a += PGSIZE;
    800005c8:	995e                	add	s2,s2,s7
  for(;;){
    800005ca:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005ce:	4605                	li	a2,1
    800005d0:	85ca                	mv	a1,s2
    800005d2:	8556                	mv	a0,s5
    800005d4:	00000097          	auipc	ra,0x0
    800005d8:	eb6080e7          	jalr	-330(ra) # 8000048a <walk>
    800005dc:	cd19                	beqz	a0,800005fa <mappages+0x88>
    if(*pte & PTE_V)
    800005de:	611c                	ld	a5,0(a0)
    800005e0:	8b85                	andi	a5,a5,1
    800005e2:	fbf9                	bnez	a5,800005b8 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e4:	80b1                	srli	s1,s1,0xc
    800005e6:	04aa                	slli	s1,s1,0xa
    800005e8:	0164e4b3          	or	s1,s1,s6
    800005ec:	0014e493          	ori	s1,s1,1
    800005f0:	e104                	sd	s1,0(a0)
    if(a == last)
    800005f2:	fd391be3          	bne	s2,s3,800005c8 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005f6:	4501                	li	a0,0
    800005f8:	a011                	j	800005fc <mappages+0x8a>
      return -1;
    800005fa:	557d                	li	a0,-1
}
    800005fc:	60a6                	ld	ra,72(sp)
    800005fe:	6406                	ld	s0,64(sp)
    80000600:	74e2                	ld	s1,56(sp)
    80000602:	7942                	ld	s2,48(sp)
    80000604:	79a2                	ld	s3,40(sp)
    80000606:	7a02                	ld	s4,32(sp)
    80000608:	6ae2                	ld	s5,24(sp)
    8000060a:	6b42                	ld	s6,16(sp)
    8000060c:	6ba2                	ld	s7,8(sp)
    8000060e:	6161                	addi	sp,sp,80
    80000610:	8082                	ret

0000000080000612 <kvmmap>:
{
    80000612:	1141                	addi	sp,sp,-16
    80000614:	e406                	sd	ra,8(sp)
    80000616:	e022                	sd	s0,0(sp)
    80000618:	0800                	addi	s0,sp,16
    8000061a:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000061c:	86b2                	mv	a3,a2
    8000061e:	863e                	mv	a2,a5
    80000620:	00000097          	auipc	ra,0x0
    80000624:	f52080e7          	jalr	-174(ra) # 80000572 <mappages>
    80000628:	e509                	bnez	a0,80000632 <kvmmap+0x20>
}
    8000062a:	60a2                	ld	ra,8(sp)
    8000062c:	6402                	ld	s0,0(sp)
    8000062e:	0141                	addi	sp,sp,16
    80000630:	8082                	ret
    panic("kvmmap");
    80000632:	00008517          	auipc	a0,0x8
    80000636:	a4650513          	addi	a0,a0,-1466 # 80008078 <etext+0x78>
    8000063a:	00005097          	auipc	ra,0x5
    8000063e:	748080e7          	jalr	1864(ra) # 80005d82 <panic>

0000000080000642 <kvmmake>:
{
    80000642:	1101                	addi	sp,sp,-32
    80000644:	ec06                	sd	ra,24(sp)
    80000646:	e822                	sd	s0,16(sp)
    80000648:	e426                	sd	s1,8(sp)
    8000064a:	e04a                	sd	s2,0(sp)
    8000064c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000064e:	00000097          	auipc	ra,0x0
    80000652:	aca080e7          	jalr	-1334(ra) # 80000118 <kalloc>
    80000656:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000658:	6605                	lui	a2,0x1
    8000065a:	4581                	li	a1,0
    8000065c:	00000097          	auipc	ra,0x0
    80000660:	b42080e7          	jalr	-1214(ra) # 8000019e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000664:	4719                	li	a4,6
    80000666:	6685                	lui	a3,0x1
    80000668:	10000637          	lui	a2,0x10000
    8000066c:	100005b7          	lui	a1,0x10000
    80000670:	8526                	mv	a0,s1
    80000672:	00000097          	auipc	ra,0x0
    80000676:	fa0080e7          	jalr	-96(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000067a:	4719                	li	a4,6
    8000067c:	6685                	lui	a3,0x1
    8000067e:	10001637          	lui	a2,0x10001
    80000682:	100015b7          	lui	a1,0x10001
    80000686:	8526                	mv	a0,s1
    80000688:	00000097          	auipc	ra,0x0
    8000068c:	f8a080e7          	jalr	-118(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80000690:	4719                	li	a4,6
    80000692:	004006b7          	lui	a3,0x400
    80000696:	0c000637          	lui	a2,0xc000
    8000069a:	0c0005b7          	lui	a1,0xc000
    8000069e:	8526                	mv	a0,s1
    800006a0:	00000097          	auipc	ra,0x0
    800006a4:	f72080e7          	jalr	-142(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a8:	00008917          	auipc	s2,0x8
    800006ac:	95890913          	addi	s2,s2,-1704 # 80008000 <etext>
    800006b0:	4729                	li	a4,10
    800006b2:	80008697          	auipc	a3,0x80008
    800006b6:	94e68693          	addi	a3,a3,-1714 # 8000 <_entry-0x7fff8000>
    800006ba:	4605                	li	a2,1
    800006bc:	067e                	slli	a2,a2,0x1f
    800006be:	85b2                	mv	a1,a2
    800006c0:	8526                	mv	a0,s1
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	f50080e7          	jalr	-176(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006ca:	4719                	li	a4,6
    800006cc:	46c5                	li	a3,17
    800006ce:	06ee                	slli	a3,a3,0x1b
    800006d0:	412686b3          	sub	a3,a3,s2
    800006d4:	864a                	mv	a2,s2
    800006d6:	85ca                	mv	a1,s2
    800006d8:	8526                	mv	a0,s1
    800006da:	00000097          	auipc	ra,0x0
    800006de:	f38080e7          	jalr	-200(ra) # 80000612 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006e2:	4729                	li	a4,10
    800006e4:	6685                	lui	a3,0x1
    800006e6:	00007617          	auipc	a2,0x7
    800006ea:	91a60613          	addi	a2,a2,-1766 # 80007000 <_trampoline>
    800006ee:	040005b7          	lui	a1,0x4000
    800006f2:	15fd                	addi	a1,a1,-1
    800006f4:	05b2                	slli	a1,a1,0xc
    800006f6:	8526                	mv	a0,s1
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	f1a080e7          	jalr	-230(ra) # 80000612 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000700:	8526                	mv	a0,s1
    80000702:	00000097          	auipc	ra,0x0
    80000706:	606080e7          	jalr	1542(ra) # 80000d08 <proc_mapstacks>
}
    8000070a:	8526                	mv	a0,s1
    8000070c:	60e2                	ld	ra,24(sp)
    8000070e:	6442                	ld	s0,16(sp)
    80000710:	64a2                	ld	s1,8(sp)
    80000712:	6902                	ld	s2,0(sp)
    80000714:	6105                	addi	sp,sp,32
    80000716:	8082                	ret

0000000080000718 <kvminit>:
{
    80000718:	1141                	addi	sp,sp,-16
    8000071a:	e406                	sd	ra,8(sp)
    8000071c:	e022                	sd	s0,0(sp)
    8000071e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000720:	00000097          	auipc	ra,0x0
    80000724:	f22080e7          	jalr	-222(ra) # 80000642 <kvmmake>
    80000728:	00008797          	auipc	a5,0x8
    8000072c:	34a7b023          	sd	a0,832(a5) # 80008a68 <kernel_pagetable>
}
    80000730:	60a2                	ld	ra,8(sp)
    80000732:	6402                	ld	s0,0(sp)
    80000734:	0141                	addi	sp,sp,16
    80000736:	8082                	ret

0000000080000738 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000738:	715d                	addi	sp,sp,-80
    8000073a:	e486                	sd	ra,72(sp)
    8000073c:	e0a2                	sd	s0,64(sp)
    8000073e:	fc26                	sd	s1,56(sp)
    80000740:	f84a                	sd	s2,48(sp)
    80000742:	f44e                	sd	s3,40(sp)
    80000744:	f052                	sd	s4,32(sp)
    80000746:	ec56                	sd	s5,24(sp)
    80000748:	e85a                	sd	s6,16(sp)
    8000074a:	e45e                	sd	s7,8(sp)
    8000074c:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000074e:	03459793          	slli	a5,a1,0x34
    80000752:	e795                	bnez	a5,8000077e <uvmunmap+0x46>
    80000754:	8a2a                	mv	s4,a0
    80000756:	892e                	mv	s2,a1
    80000758:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000075a:	0632                	slli	a2,a2,0xc
    8000075c:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000760:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000762:	6b05                	lui	s6,0x1
    80000764:	0735e863          	bltu	a1,s3,800007d4 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000768:	60a6                	ld	ra,72(sp)
    8000076a:	6406                	ld	s0,64(sp)
    8000076c:	74e2                	ld	s1,56(sp)
    8000076e:	7942                	ld	s2,48(sp)
    80000770:	79a2                	ld	s3,40(sp)
    80000772:	7a02                	ld	s4,32(sp)
    80000774:	6ae2                	ld	s5,24(sp)
    80000776:	6b42                	ld	s6,16(sp)
    80000778:	6ba2                	ld	s7,8(sp)
    8000077a:	6161                	addi	sp,sp,80
    8000077c:	8082                	ret
    panic("uvmunmap: not aligned");
    8000077e:	00008517          	auipc	a0,0x8
    80000782:	90250513          	addi	a0,a0,-1790 # 80008080 <etext+0x80>
    80000786:	00005097          	auipc	ra,0x5
    8000078a:	5fc080e7          	jalr	1532(ra) # 80005d82 <panic>
      panic("uvmunmap: walk");
    8000078e:	00008517          	auipc	a0,0x8
    80000792:	90a50513          	addi	a0,a0,-1782 # 80008098 <etext+0x98>
    80000796:	00005097          	auipc	ra,0x5
    8000079a:	5ec080e7          	jalr	1516(ra) # 80005d82 <panic>
      panic("uvmunmap: not mapped");
    8000079e:	00008517          	auipc	a0,0x8
    800007a2:	90a50513          	addi	a0,a0,-1782 # 800080a8 <etext+0xa8>
    800007a6:	00005097          	auipc	ra,0x5
    800007aa:	5dc080e7          	jalr	1500(ra) # 80005d82 <panic>
      panic("uvmunmap: not a leaf");
    800007ae:	00008517          	auipc	a0,0x8
    800007b2:	91250513          	addi	a0,a0,-1774 # 800080c0 <etext+0xc0>
    800007b6:	00005097          	auipc	ra,0x5
    800007ba:	5cc080e7          	jalr	1484(ra) # 80005d82 <panic>
      uint64 pa = PTE2PA(*pte);
    800007be:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007c0:	0532                	slli	a0,a0,0xc
    800007c2:	00000097          	auipc	ra,0x0
    800007c6:	85a080e7          	jalr	-1958(ra) # 8000001c <kfree>
    *pte = 0;
    800007ca:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007ce:	995a                	add	s2,s2,s6
    800007d0:	f9397ce3          	bgeu	s2,s3,80000768 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d4:	4601                	li	a2,0
    800007d6:	85ca                	mv	a1,s2
    800007d8:	8552                	mv	a0,s4
    800007da:	00000097          	auipc	ra,0x0
    800007de:	cb0080e7          	jalr	-848(ra) # 8000048a <walk>
    800007e2:	84aa                	mv	s1,a0
    800007e4:	d54d                	beqz	a0,8000078e <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e6:	6108                	ld	a0,0(a0)
    800007e8:	00157793          	andi	a5,a0,1
    800007ec:	dbcd                	beqz	a5,8000079e <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ee:	3ff57793          	andi	a5,a0,1023
    800007f2:	fb778ee3          	beq	a5,s7,800007ae <uvmunmap+0x76>
    if(do_free){
    800007f6:	fc0a8ae3          	beqz	s5,800007ca <uvmunmap+0x92>
    800007fa:	b7d1                	j	800007be <uvmunmap+0x86>

00000000800007fc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fc:	1101                	addi	sp,sp,-32
    800007fe:	ec06                	sd	ra,24(sp)
    80000800:	e822                	sd	s0,16(sp)
    80000802:	e426                	sd	s1,8(sp)
    80000804:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	912080e7          	jalr	-1774(ra) # 80000118 <kalloc>
    8000080e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000810:	c519                	beqz	a0,8000081e <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000812:	6605                	lui	a2,0x1
    80000814:	4581                	li	a1,0
    80000816:	00000097          	auipc	ra,0x0
    8000081a:	988080e7          	jalr	-1656(ra) # 8000019e <memset>
  return pagetable;
}
    8000081e:	8526                	mv	a0,s1
    80000820:	60e2                	ld	ra,24(sp)
    80000822:	6442                	ld	s0,16(sp)
    80000824:	64a2                	ld	s1,8(sp)
    80000826:	6105                	addi	sp,sp,32
    80000828:	8082                	ret

000000008000082a <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000082a:	7179                	addi	sp,sp,-48
    8000082c:	f406                	sd	ra,40(sp)
    8000082e:	f022                	sd	s0,32(sp)
    80000830:	ec26                	sd	s1,24(sp)
    80000832:	e84a                	sd	s2,16(sp)
    80000834:	e44e                	sd	s3,8(sp)
    80000836:	e052                	sd	s4,0(sp)
    80000838:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000083a:	6785                	lui	a5,0x1
    8000083c:	04f67863          	bgeu	a2,a5,8000088c <uvmfirst+0x62>
    80000840:	8a2a                	mv	s4,a0
    80000842:	89ae                	mv	s3,a1
    80000844:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	8d2080e7          	jalr	-1838(ra) # 80000118 <kalloc>
    8000084e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000850:	6605                	lui	a2,0x1
    80000852:	4581                	li	a1,0
    80000854:	00000097          	auipc	ra,0x0
    80000858:	94a080e7          	jalr	-1718(ra) # 8000019e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085c:	4779                	li	a4,30
    8000085e:	86ca                	mv	a3,s2
    80000860:	6605                	lui	a2,0x1
    80000862:	4581                	li	a1,0
    80000864:	8552                	mv	a0,s4
    80000866:	00000097          	auipc	ra,0x0
    8000086a:	d0c080e7          	jalr	-756(ra) # 80000572 <mappages>
  memmove(mem, src, sz);
    8000086e:	8626                	mv	a2,s1
    80000870:	85ce                	mv	a1,s3
    80000872:	854a                	mv	a0,s2
    80000874:	00000097          	auipc	ra,0x0
    80000878:	98a080e7          	jalr	-1654(ra) # 800001fe <memmove>
}
    8000087c:	70a2                	ld	ra,40(sp)
    8000087e:	7402                	ld	s0,32(sp)
    80000880:	64e2                	ld	s1,24(sp)
    80000882:	6942                	ld	s2,16(sp)
    80000884:	69a2                	ld	s3,8(sp)
    80000886:	6a02                	ld	s4,0(sp)
    80000888:	6145                	addi	sp,sp,48
    8000088a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088c:	00008517          	auipc	a0,0x8
    80000890:	84c50513          	addi	a0,a0,-1972 # 800080d8 <etext+0xd8>
    80000894:	00005097          	auipc	ra,0x5
    80000898:	4ee080e7          	jalr	1262(ra) # 80005d82 <panic>

000000008000089c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089c:	1101                	addi	sp,sp,-32
    8000089e:	ec06                	sd	ra,24(sp)
    800008a0:	e822                	sd	s0,16(sp)
    800008a2:	e426                	sd	s1,8(sp)
    800008a4:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a6:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a8:	00b67d63          	bgeu	a2,a1,800008c2 <uvmdealloc+0x26>
    800008ac:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ae:	6785                	lui	a5,0x1
    800008b0:	17fd                	addi	a5,a5,-1
    800008b2:	00f60733          	add	a4,a2,a5
    800008b6:	767d                	lui	a2,0xfffff
    800008b8:	8f71                	and	a4,a4,a2
    800008ba:	97ae                	add	a5,a5,a1
    800008bc:	8ff1                	and	a5,a5,a2
    800008be:	00f76863          	bltu	a4,a5,800008ce <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c2:	8526                	mv	a0,s1
    800008c4:	60e2                	ld	ra,24(sp)
    800008c6:	6442                	ld	s0,16(sp)
    800008c8:	64a2                	ld	s1,8(sp)
    800008ca:	6105                	addi	sp,sp,32
    800008cc:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008ce:	8f99                	sub	a5,a5,a4
    800008d0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d2:	4685                	li	a3,1
    800008d4:	0007861b          	sext.w	a2,a5
    800008d8:	85ba                	mv	a1,a4
    800008da:	00000097          	auipc	ra,0x0
    800008de:	e5e080e7          	jalr	-418(ra) # 80000738 <uvmunmap>
    800008e2:	b7c5                	j	800008c2 <uvmdealloc+0x26>

00000000800008e4 <uvmalloc>:
  if(newsz < oldsz)
    800008e4:	0ab66563          	bltu	a2,a1,8000098e <uvmalloc+0xaa>
{
    800008e8:	7139                	addi	sp,sp,-64
    800008ea:	fc06                	sd	ra,56(sp)
    800008ec:	f822                	sd	s0,48(sp)
    800008ee:	f426                	sd	s1,40(sp)
    800008f0:	f04a                	sd	s2,32(sp)
    800008f2:	ec4e                	sd	s3,24(sp)
    800008f4:	e852                	sd	s4,16(sp)
    800008f6:	e456                	sd	s5,8(sp)
    800008f8:	e05a                	sd	s6,0(sp)
    800008fa:	0080                	addi	s0,sp,64
    800008fc:	8aaa                	mv	s5,a0
    800008fe:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000900:	6985                	lui	s3,0x1
    80000902:	19fd                	addi	s3,s3,-1
    80000904:	95ce                	add	a1,a1,s3
    80000906:	79fd                	lui	s3,0xfffff
    80000908:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090c:	08c9f363          	bgeu	s3,a2,80000992 <uvmalloc+0xae>
    80000910:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000912:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	802080e7          	jalr	-2046(ra) # 80000118 <kalloc>
    8000091e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000920:	c51d                	beqz	a0,8000094e <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000922:	6605                	lui	a2,0x1
    80000924:	4581                	li	a1,0
    80000926:	00000097          	auipc	ra,0x0
    8000092a:	878080e7          	jalr	-1928(ra) # 8000019e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092e:	875a                	mv	a4,s6
    80000930:	86a6                	mv	a3,s1
    80000932:	6605                	lui	a2,0x1
    80000934:	85ca                	mv	a1,s2
    80000936:	8556                	mv	a0,s5
    80000938:	00000097          	auipc	ra,0x0
    8000093c:	c3a080e7          	jalr	-966(ra) # 80000572 <mappages>
    80000940:	e90d                	bnez	a0,80000972 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000942:	6785                	lui	a5,0x1
    80000944:	993e                	add	s2,s2,a5
    80000946:	fd4968e3          	bltu	s2,s4,80000916 <uvmalloc+0x32>
  return newsz;
    8000094a:	8552                	mv	a0,s4
    8000094c:	a809                	j	8000095e <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000094e:	864e                	mv	a2,s3
    80000950:	85ca                	mv	a1,s2
    80000952:	8556                	mv	a0,s5
    80000954:	00000097          	auipc	ra,0x0
    80000958:	f48080e7          	jalr	-184(ra) # 8000089c <uvmdealloc>
      return 0;
    8000095c:	4501                	li	a0,0
}
    8000095e:	70e2                	ld	ra,56(sp)
    80000960:	7442                	ld	s0,48(sp)
    80000962:	74a2                	ld	s1,40(sp)
    80000964:	7902                	ld	s2,32(sp)
    80000966:	69e2                	ld	s3,24(sp)
    80000968:	6a42                	ld	s4,16(sp)
    8000096a:	6aa2                	ld	s5,8(sp)
    8000096c:	6b02                	ld	s6,0(sp)
    8000096e:	6121                	addi	sp,sp,64
    80000970:	8082                	ret
      kfree(mem);
    80000972:	8526                	mv	a0,s1
    80000974:	fffff097          	auipc	ra,0xfffff
    80000978:	6a8080e7          	jalr	1704(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000097c:	864e                	mv	a2,s3
    8000097e:	85ca                	mv	a1,s2
    80000980:	8556                	mv	a0,s5
    80000982:	00000097          	auipc	ra,0x0
    80000986:	f1a080e7          	jalr	-230(ra) # 8000089c <uvmdealloc>
      return 0;
    8000098a:	4501                	li	a0,0
    8000098c:	bfc9                	j	8000095e <uvmalloc+0x7a>
    return oldsz;
    8000098e:	852e                	mv	a0,a1
}
    80000990:	8082                	ret
  return newsz;
    80000992:	8532                	mv	a0,a2
    80000994:	b7e9                	j	8000095e <uvmalloc+0x7a>

0000000080000996 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000996:	7179                	addi	sp,sp,-48
    80000998:	f406                	sd	ra,40(sp)
    8000099a:	f022                	sd	s0,32(sp)
    8000099c:	ec26                	sd	s1,24(sp)
    8000099e:	e84a                	sd	s2,16(sp)
    800009a0:	e44e                	sd	s3,8(sp)
    800009a2:	e052                	sd	s4,0(sp)
    800009a4:	1800                	addi	s0,sp,48
    800009a6:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009a8:	84aa                	mv	s1,a0
    800009aa:	6905                	lui	s2,0x1
    800009ac:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ae:	4985                	li	s3,1
    800009b0:	a821                	j	800009c8 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009b2:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009b4:	0532                	slli	a0,a0,0xc
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	fe0080e7          	jalr	-32(ra) # 80000996 <freewalk>
      pagetable[i] = 0;
    800009be:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009c2:	04a1                	addi	s1,s1,8
    800009c4:	03248163          	beq	s1,s2,800009e6 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009c8:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ca:	00f57793          	andi	a5,a0,15
    800009ce:	ff3782e3          	beq	a5,s3,800009b2 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009d2:	8905                	andi	a0,a0,1
    800009d4:	d57d                	beqz	a0,800009c2 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009d6:	00007517          	auipc	a0,0x7
    800009da:	72250513          	addi	a0,a0,1826 # 800080f8 <etext+0xf8>
    800009de:	00005097          	auipc	ra,0x5
    800009e2:	3a4080e7          	jalr	932(ra) # 80005d82 <panic>
    }
  }
  kfree((void*)pagetable);
    800009e6:	8552                	mv	a0,s4
    800009e8:	fffff097          	auipc	ra,0xfffff
    800009ec:	634080e7          	jalr	1588(ra) # 8000001c <kfree>
}
    800009f0:	70a2                	ld	ra,40(sp)
    800009f2:	7402                	ld	s0,32(sp)
    800009f4:	64e2                	ld	s1,24(sp)
    800009f6:	6942                	ld	s2,16(sp)
    800009f8:	69a2                	ld	s3,8(sp)
    800009fa:	6a02                	ld	s4,0(sp)
    800009fc:	6145                	addi	sp,sp,48
    800009fe:	8082                	ret

0000000080000a00 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a00:	1101                	addi	sp,sp,-32
    80000a02:	ec06                	sd	ra,24(sp)
    80000a04:	e822                	sd	s0,16(sp)
    80000a06:	e426                	sd	s1,8(sp)
    80000a08:	1000                	addi	s0,sp,32
    80000a0a:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a0c:	e999                	bnez	a1,80000a22 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a0e:	8526                	mv	a0,s1
    80000a10:	00000097          	auipc	ra,0x0
    80000a14:	f86080e7          	jalr	-122(ra) # 80000996 <freewalk>
}
    80000a18:	60e2                	ld	ra,24(sp)
    80000a1a:	6442                	ld	s0,16(sp)
    80000a1c:	64a2                	ld	s1,8(sp)
    80000a1e:	6105                	addi	sp,sp,32
    80000a20:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a22:	6605                	lui	a2,0x1
    80000a24:	167d                	addi	a2,a2,-1
    80000a26:	962e                	add	a2,a2,a1
    80000a28:	4685                	li	a3,1
    80000a2a:	8231                	srli	a2,a2,0xc
    80000a2c:	4581                	li	a1,0
    80000a2e:	00000097          	auipc	ra,0x0
    80000a32:	d0a080e7          	jalr	-758(ra) # 80000738 <uvmunmap>
    80000a36:	bfe1                	j	80000a0e <uvmfree+0xe>

0000000080000a38 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a38:	c679                	beqz	a2,80000b06 <uvmcopy+0xce>
{
    80000a3a:	715d                	addi	sp,sp,-80
    80000a3c:	e486                	sd	ra,72(sp)
    80000a3e:	e0a2                	sd	s0,64(sp)
    80000a40:	fc26                	sd	s1,56(sp)
    80000a42:	f84a                	sd	s2,48(sp)
    80000a44:	f44e                	sd	s3,40(sp)
    80000a46:	f052                	sd	s4,32(sp)
    80000a48:	ec56                	sd	s5,24(sp)
    80000a4a:	e85a                	sd	s6,16(sp)
    80000a4c:	e45e                	sd	s7,8(sp)
    80000a4e:	0880                	addi	s0,sp,80
    80000a50:	8b2a                	mv	s6,a0
    80000a52:	8aae                	mv	s5,a1
    80000a54:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a56:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a58:	4601                	li	a2,0
    80000a5a:	85ce                	mv	a1,s3
    80000a5c:	855a                	mv	a0,s6
    80000a5e:	00000097          	auipc	ra,0x0
    80000a62:	a2c080e7          	jalr	-1492(ra) # 8000048a <walk>
    80000a66:	c531                	beqz	a0,80000ab2 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a68:	6118                	ld	a4,0(a0)
    80000a6a:	00177793          	andi	a5,a4,1
    80000a6e:	cbb1                	beqz	a5,80000ac2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a70:	00a75593          	srli	a1,a4,0xa
    80000a74:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a78:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a7c:	fffff097          	auipc	ra,0xfffff
    80000a80:	69c080e7          	jalr	1692(ra) # 80000118 <kalloc>
    80000a84:	892a                	mv	s2,a0
    80000a86:	c939                	beqz	a0,80000adc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a88:	6605                	lui	a2,0x1
    80000a8a:	85de                	mv	a1,s7
    80000a8c:	fffff097          	auipc	ra,0xfffff
    80000a90:	772080e7          	jalr	1906(ra) # 800001fe <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a94:	8726                	mv	a4,s1
    80000a96:	86ca                	mv	a3,s2
    80000a98:	6605                	lui	a2,0x1
    80000a9a:	85ce                	mv	a1,s3
    80000a9c:	8556                	mv	a0,s5
    80000a9e:	00000097          	auipc	ra,0x0
    80000aa2:	ad4080e7          	jalr	-1324(ra) # 80000572 <mappages>
    80000aa6:	e515                	bnez	a0,80000ad2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aa8:	6785                	lui	a5,0x1
    80000aaa:	99be                	add	s3,s3,a5
    80000aac:	fb49e6e3          	bltu	s3,s4,80000a58 <uvmcopy+0x20>
    80000ab0:	a081                	j	80000af0 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ab2:	00007517          	auipc	a0,0x7
    80000ab6:	65650513          	addi	a0,a0,1622 # 80008108 <etext+0x108>
    80000aba:	00005097          	auipc	ra,0x5
    80000abe:	2c8080e7          	jalr	712(ra) # 80005d82 <panic>
      panic("uvmcopy: page not present");
    80000ac2:	00007517          	auipc	a0,0x7
    80000ac6:	66650513          	addi	a0,a0,1638 # 80008128 <etext+0x128>
    80000aca:	00005097          	auipc	ra,0x5
    80000ace:	2b8080e7          	jalr	696(ra) # 80005d82 <panic>
      kfree(mem);
    80000ad2:	854a                	mv	a0,s2
    80000ad4:	fffff097          	auipc	ra,0xfffff
    80000ad8:	548080e7          	jalr	1352(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000adc:	4685                	li	a3,1
    80000ade:	00c9d613          	srli	a2,s3,0xc
    80000ae2:	4581                	li	a1,0
    80000ae4:	8556                	mv	a0,s5
    80000ae6:	00000097          	auipc	ra,0x0
    80000aea:	c52080e7          	jalr	-942(ra) # 80000738 <uvmunmap>
  return -1;
    80000aee:	557d                	li	a0,-1
}
    80000af0:	60a6                	ld	ra,72(sp)
    80000af2:	6406                	ld	s0,64(sp)
    80000af4:	74e2                	ld	s1,56(sp)
    80000af6:	7942                	ld	s2,48(sp)
    80000af8:	79a2                	ld	s3,40(sp)
    80000afa:	7a02                	ld	s4,32(sp)
    80000afc:	6ae2                	ld	s5,24(sp)
    80000afe:	6b42                	ld	s6,16(sp)
    80000b00:	6ba2                	ld	s7,8(sp)
    80000b02:	6161                	addi	sp,sp,80
    80000b04:	8082                	ret
  return 0;
    80000b06:	4501                	li	a0,0
}
    80000b08:	8082                	ret

0000000080000b0a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b0a:	1141                	addi	sp,sp,-16
    80000b0c:	e406                	sd	ra,8(sp)
    80000b0e:	e022                	sd	s0,0(sp)
    80000b10:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b12:	4601                	li	a2,0
    80000b14:	00000097          	auipc	ra,0x0
    80000b18:	976080e7          	jalr	-1674(ra) # 8000048a <walk>
  if(pte == 0)
    80000b1c:	c901                	beqz	a0,80000b2c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b1e:	611c                	ld	a5,0(a0)
    80000b20:	9bbd                	andi	a5,a5,-17
    80000b22:	e11c                	sd	a5,0(a0)
}
    80000b24:	60a2                	ld	ra,8(sp)
    80000b26:	6402                	ld	s0,0(sp)
    80000b28:	0141                	addi	sp,sp,16
    80000b2a:	8082                	ret
    panic("uvmclear");
    80000b2c:	00007517          	auipc	a0,0x7
    80000b30:	61c50513          	addi	a0,a0,1564 # 80008148 <etext+0x148>
    80000b34:	00005097          	auipc	ra,0x5
    80000b38:	24e080e7          	jalr	590(ra) # 80005d82 <panic>

0000000080000b3c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b3c:	c6bd                	beqz	a3,80000baa <copyout+0x6e>
{
    80000b3e:	715d                	addi	sp,sp,-80
    80000b40:	e486                	sd	ra,72(sp)
    80000b42:	e0a2                	sd	s0,64(sp)
    80000b44:	fc26                	sd	s1,56(sp)
    80000b46:	f84a                	sd	s2,48(sp)
    80000b48:	f44e                	sd	s3,40(sp)
    80000b4a:	f052                	sd	s4,32(sp)
    80000b4c:	ec56                	sd	s5,24(sp)
    80000b4e:	e85a                	sd	s6,16(sp)
    80000b50:	e45e                	sd	s7,8(sp)
    80000b52:	e062                	sd	s8,0(sp)
    80000b54:	0880                	addi	s0,sp,80
    80000b56:	8b2a                	mv	s6,a0
    80000b58:	8c2e                	mv	s8,a1
    80000b5a:	8a32                	mv	s4,a2
    80000b5c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b5e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b60:	6a85                	lui	s5,0x1
    80000b62:	a015                	j	80000b86 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b64:	9562                	add	a0,a0,s8
    80000b66:	0004861b          	sext.w	a2,s1
    80000b6a:	85d2                	mv	a1,s4
    80000b6c:	41250533          	sub	a0,a0,s2
    80000b70:	fffff097          	auipc	ra,0xfffff
    80000b74:	68e080e7          	jalr	1678(ra) # 800001fe <memmove>

    len -= n;
    80000b78:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b7c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b7e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b82:	02098263          	beqz	s3,80000ba6 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b86:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b8a:	85ca                	mv	a1,s2
    80000b8c:	855a                	mv	a0,s6
    80000b8e:	00000097          	auipc	ra,0x0
    80000b92:	9a2080e7          	jalr	-1630(ra) # 80000530 <walkaddr>
    if(pa0 == 0)
    80000b96:	cd01                	beqz	a0,80000bae <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b98:	418904b3          	sub	s1,s2,s8
    80000b9c:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b9e:	fc99f3e3          	bgeu	s3,s1,80000b64 <copyout+0x28>
    80000ba2:	84ce                	mv	s1,s3
    80000ba4:	b7c1                	j	80000b64 <copyout+0x28>
  }
  return 0;
    80000ba6:	4501                	li	a0,0
    80000ba8:	a021                	j	80000bb0 <copyout+0x74>
    80000baa:	4501                	li	a0,0
}
    80000bac:	8082                	ret
      return -1;
    80000bae:	557d                	li	a0,-1
}
    80000bb0:	60a6                	ld	ra,72(sp)
    80000bb2:	6406                	ld	s0,64(sp)
    80000bb4:	74e2                	ld	s1,56(sp)
    80000bb6:	7942                	ld	s2,48(sp)
    80000bb8:	79a2                	ld	s3,40(sp)
    80000bba:	7a02                	ld	s4,32(sp)
    80000bbc:	6ae2                	ld	s5,24(sp)
    80000bbe:	6b42                	ld	s6,16(sp)
    80000bc0:	6ba2                	ld	s7,8(sp)
    80000bc2:	6c02                	ld	s8,0(sp)
    80000bc4:	6161                	addi	sp,sp,80
    80000bc6:	8082                	ret

0000000080000bc8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bc8:	c6bd                	beqz	a3,80000c36 <copyin+0x6e>
{
    80000bca:	715d                	addi	sp,sp,-80
    80000bcc:	e486                	sd	ra,72(sp)
    80000bce:	e0a2                	sd	s0,64(sp)
    80000bd0:	fc26                	sd	s1,56(sp)
    80000bd2:	f84a                	sd	s2,48(sp)
    80000bd4:	f44e                	sd	s3,40(sp)
    80000bd6:	f052                	sd	s4,32(sp)
    80000bd8:	ec56                	sd	s5,24(sp)
    80000bda:	e85a                	sd	s6,16(sp)
    80000bdc:	e45e                	sd	s7,8(sp)
    80000bde:	e062                	sd	s8,0(sp)
    80000be0:	0880                	addi	s0,sp,80
    80000be2:	8b2a                	mv	s6,a0
    80000be4:	8a2e                	mv	s4,a1
    80000be6:	8c32                	mv	s8,a2
    80000be8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bea:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bec:	6a85                	lui	s5,0x1
    80000bee:	a015                	j	80000c12 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bf0:	9562                	add	a0,a0,s8
    80000bf2:	0004861b          	sext.w	a2,s1
    80000bf6:	412505b3          	sub	a1,a0,s2
    80000bfa:	8552                	mv	a0,s4
    80000bfc:	fffff097          	auipc	ra,0xfffff
    80000c00:	602080e7          	jalr	1538(ra) # 800001fe <memmove>

    len -= n;
    80000c04:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c08:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c0a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c0e:	02098263          	beqz	s3,80000c32 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c12:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c16:	85ca                	mv	a1,s2
    80000c18:	855a                	mv	a0,s6
    80000c1a:	00000097          	auipc	ra,0x0
    80000c1e:	916080e7          	jalr	-1770(ra) # 80000530 <walkaddr>
    if(pa0 == 0)
    80000c22:	cd01                	beqz	a0,80000c3a <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c24:	418904b3          	sub	s1,s2,s8
    80000c28:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c2a:	fc99f3e3          	bgeu	s3,s1,80000bf0 <copyin+0x28>
    80000c2e:	84ce                	mv	s1,s3
    80000c30:	b7c1                	j	80000bf0 <copyin+0x28>
  }
  return 0;
    80000c32:	4501                	li	a0,0
    80000c34:	a021                	j	80000c3c <copyin+0x74>
    80000c36:	4501                	li	a0,0
}
    80000c38:	8082                	ret
      return -1;
    80000c3a:	557d                	li	a0,-1
}
    80000c3c:	60a6                	ld	ra,72(sp)
    80000c3e:	6406                	ld	s0,64(sp)
    80000c40:	74e2                	ld	s1,56(sp)
    80000c42:	7942                	ld	s2,48(sp)
    80000c44:	79a2                	ld	s3,40(sp)
    80000c46:	7a02                	ld	s4,32(sp)
    80000c48:	6ae2                	ld	s5,24(sp)
    80000c4a:	6b42                	ld	s6,16(sp)
    80000c4c:	6ba2                	ld	s7,8(sp)
    80000c4e:	6c02                	ld	s8,0(sp)
    80000c50:	6161                	addi	sp,sp,80
    80000c52:	8082                	ret

0000000080000c54 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c54:	c6c5                	beqz	a3,80000cfc <copyinstr+0xa8>
{
    80000c56:	715d                	addi	sp,sp,-80
    80000c58:	e486                	sd	ra,72(sp)
    80000c5a:	e0a2                	sd	s0,64(sp)
    80000c5c:	fc26                	sd	s1,56(sp)
    80000c5e:	f84a                	sd	s2,48(sp)
    80000c60:	f44e                	sd	s3,40(sp)
    80000c62:	f052                	sd	s4,32(sp)
    80000c64:	ec56                	sd	s5,24(sp)
    80000c66:	e85a                	sd	s6,16(sp)
    80000c68:	e45e                	sd	s7,8(sp)
    80000c6a:	0880                	addi	s0,sp,80
    80000c6c:	8a2a                	mv	s4,a0
    80000c6e:	8b2e                	mv	s6,a1
    80000c70:	8bb2                	mv	s7,a2
    80000c72:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c74:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c76:	6985                	lui	s3,0x1
    80000c78:	a035                	j	80000ca4 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c7a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c7e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c80:	0017b793          	seqz	a5,a5
    80000c84:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c88:	60a6                	ld	ra,72(sp)
    80000c8a:	6406                	ld	s0,64(sp)
    80000c8c:	74e2                	ld	s1,56(sp)
    80000c8e:	7942                	ld	s2,48(sp)
    80000c90:	79a2                	ld	s3,40(sp)
    80000c92:	7a02                	ld	s4,32(sp)
    80000c94:	6ae2                	ld	s5,24(sp)
    80000c96:	6b42                	ld	s6,16(sp)
    80000c98:	6ba2                	ld	s7,8(sp)
    80000c9a:	6161                	addi	sp,sp,80
    80000c9c:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c9e:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000ca2:	c8a9                	beqz	s1,80000cf4 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000ca4:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000ca8:	85ca                	mv	a1,s2
    80000caa:	8552                	mv	a0,s4
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	884080e7          	jalr	-1916(ra) # 80000530 <walkaddr>
    if(pa0 == 0)
    80000cb4:	c131                	beqz	a0,80000cf8 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cb6:	41790833          	sub	a6,s2,s7
    80000cba:	984e                	add	a6,a6,s3
    if(n > max)
    80000cbc:	0104f363          	bgeu	s1,a6,80000cc2 <copyinstr+0x6e>
    80000cc0:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cc2:	955e                	add	a0,a0,s7
    80000cc4:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cc8:	fc080be3          	beqz	a6,80000c9e <copyinstr+0x4a>
    80000ccc:	985a                	add	a6,a6,s6
    80000cce:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cd0:	41650633          	sub	a2,a0,s6
    80000cd4:	14fd                	addi	s1,s1,-1
    80000cd6:	9b26                	add	s6,s6,s1
    80000cd8:	00f60733          	add	a4,a2,a5
    80000cdc:	00074703          	lbu	a4,0(a4)
    80000ce0:	df49                	beqz	a4,80000c7a <copyinstr+0x26>
        *dst = *p;
    80000ce2:	00e78023          	sb	a4,0(a5)
      --max;
    80000ce6:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cea:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cec:	ff0796e3          	bne	a5,a6,80000cd8 <copyinstr+0x84>
      dst++;
    80000cf0:	8b42                	mv	s6,a6
    80000cf2:	b775                	j	80000c9e <copyinstr+0x4a>
    80000cf4:	4781                	li	a5,0
    80000cf6:	b769                	j	80000c80 <copyinstr+0x2c>
      return -1;
    80000cf8:	557d                	li	a0,-1
    80000cfa:	b779                	j	80000c88 <copyinstr+0x34>
  int got_null = 0;
    80000cfc:	4781                	li	a5,0
  if(got_null){
    80000cfe:	0017b793          	seqz	a5,a5
    80000d02:	40f00533          	neg	a0,a5
}
    80000d06:	8082                	ret

0000000080000d08 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d08:	7139                	addi	sp,sp,-64
    80000d0a:	fc06                	sd	ra,56(sp)
    80000d0c:	f822                	sd	s0,48(sp)
    80000d0e:	f426                	sd	s1,40(sp)
    80000d10:	f04a                	sd	s2,32(sp)
    80000d12:	ec4e                	sd	s3,24(sp)
    80000d14:	e852                	sd	s4,16(sp)
    80000d16:	e456                	sd	s5,8(sp)
    80000d18:	e05a                	sd	s6,0(sp)
    80000d1a:	0080                	addi	s0,sp,64
    80000d1c:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d1e:	00008497          	auipc	s1,0x8
    80000d22:	1c248493          	addi	s1,s1,450 # 80008ee0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d26:	8b26                	mv	s6,s1
    80000d28:	00007a97          	auipc	s5,0x7
    80000d2c:	2d8a8a93          	addi	s5,s5,728 # 80008000 <etext>
    80000d30:	04000937          	lui	s2,0x4000
    80000d34:	197d                	addi	s2,s2,-1
    80000d36:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d38:	0000ea17          	auipc	s4,0xe
    80000d3c:	da8a0a13          	addi	s4,s4,-600 # 8000eae0 <tickslock>
    char *pa = kalloc();
    80000d40:	fffff097          	auipc	ra,0xfffff
    80000d44:	3d8080e7          	jalr	984(ra) # 80000118 <kalloc>
    80000d48:	862a                	mv	a2,a0
    if(pa == 0)
    80000d4a:	c131                	beqz	a0,80000d8e <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d4c:	416485b3          	sub	a1,s1,s6
    80000d50:	8591                	srai	a1,a1,0x4
    80000d52:	000ab783          	ld	a5,0(s5)
    80000d56:	02f585b3          	mul	a1,a1,a5
    80000d5a:	2585                	addiw	a1,a1,1
    80000d5c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d60:	4719                	li	a4,6
    80000d62:	6685                	lui	a3,0x1
    80000d64:	40b905b3          	sub	a1,s2,a1
    80000d68:	854e                	mv	a0,s3
    80000d6a:	00000097          	auipc	ra,0x0
    80000d6e:	8a8080e7          	jalr	-1880(ra) # 80000612 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d72:	17048493          	addi	s1,s1,368
    80000d76:	fd4495e3          	bne	s1,s4,80000d40 <proc_mapstacks+0x38>
  }
}
    80000d7a:	70e2                	ld	ra,56(sp)
    80000d7c:	7442                	ld	s0,48(sp)
    80000d7e:	74a2                	ld	s1,40(sp)
    80000d80:	7902                	ld	s2,32(sp)
    80000d82:	69e2                	ld	s3,24(sp)
    80000d84:	6a42                	ld	s4,16(sp)
    80000d86:	6aa2                	ld	s5,8(sp)
    80000d88:	6b02                	ld	s6,0(sp)
    80000d8a:	6121                	addi	sp,sp,64
    80000d8c:	8082                	ret
      panic("kalloc");
    80000d8e:	00007517          	auipc	a0,0x7
    80000d92:	3ca50513          	addi	a0,a0,970 # 80008158 <etext+0x158>
    80000d96:	00005097          	auipc	ra,0x5
    80000d9a:	fec080e7          	jalr	-20(ra) # 80005d82 <panic>

0000000080000d9e <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d9e:	7139                	addi	sp,sp,-64
    80000da0:	fc06                	sd	ra,56(sp)
    80000da2:	f822                	sd	s0,48(sp)
    80000da4:	f426                	sd	s1,40(sp)
    80000da6:	f04a                	sd	s2,32(sp)
    80000da8:	ec4e                	sd	s3,24(sp)
    80000daa:	e852                	sd	s4,16(sp)
    80000dac:	e456                	sd	s5,8(sp)
    80000dae:	e05a                	sd	s6,0(sp)
    80000db0:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000db2:	00007597          	auipc	a1,0x7
    80000db6:	3ae58593          	addi	a1,a1,942 # 80008160 <etext+0x160>
    80000dba:	00008517          	auipc	a0,0x8
    80000dbe:	cf650513          	addi	a0,a0,-778 # 80008ab0 <pid_lock>
    80000dc2:	00005097          	auipc	ra,0x5
    80000dc6:	47a080e7          	jalr	1146(ra) # 8000623c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dca:	00007597          	auipc	a1,0x7
    80000dce:	39e58593          	addi	a1,a1,926 # 80008168 <etext+0x168>
    80000dd2:	00008517          	auipc	a0,0x8
    80000dd6:	cf650513          	addi	a0,a0,-778 # 80008ac8 <wait_lock>
    80000dda:	00005097          	auipc	ra,0x5
    80000dde:	462080e7          	jalr	1122(ra) # 8000623c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de2:	00008497          	auipc	s1,0x8
    80000de6:	0fe48493          	addi	s1,s1,254 # 80008ee0 <proc>
      initlock(&p->lock, "proc");
    80000dea:	00007b17          	auipc	s6,0x7
    80000dee:	38eb0b13          	addi	s6,s6,910 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000df2:	8aa6                	mv	s5,s1
    80000df4:	00007a17          	auipc	s4,0x7
    80000df8:	20ca0a13          	addi	s4,s4,524 # 80008000 <etext>
    80000dfc:	04000937          	lui	s2,0x4000
    80000e00:	197d                	addi	s2,s2,-1
    80000e02:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e04:	0000e997          	auipc	s3,0xe
    80000e08:	cdc98993          	addi	s3,s3,-804 # 8000eae0 <tickslock>
      initlock(&p->lock, "proc");
    80000e0c:	85da                	mv	a1,s6
    80000e0e:	8526                	mv	a0,s1
    80000e10:	00005097          	auipc	ra,0x5
    80000e14:	42c080e7          	jalr	1068(ra) # 8000623c <initlock>
      p->state = UNUSED;
    80000e18:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e1c:	415487b3          	sub	a5,s1,s5
    80000e20:	8791                	srai	a5,a5,0x4
    80000e22:	000a3703          	ld	a4,0(s4)
    80000e26:	02e787b3          	mul	a5,a5,a4
    80000e2a:	2785                	addiw	a5,a5,1
    80000e2c:	00d7979b          	slliw	a5,a5,0xd
    80000e30:	40f907b3          	sub	a5,s2,a5
    80000e34:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e36:	17048493          	addi	s1,s1,368
    80000e3a:	fd3499e3          	bne	s1,s3,80000e0c <procinit+0x6e>
  }
}
    80000e3e:	70e2                	ld	ra,56(sp)
    80000e40:	7442                	ld	s0,48(sp)
    80000e42:	74a2                	ld	s1,40(sp)
    80000e44:	7902                	ld	s2,32(sp)
    80000e46:	69e2                	ld	s3,24(sp)
    80000e48:	6a42                	ld	s4,16(sp)
    80000e4a:	6aa2                	ld	s5,8(sp)
    80000e4c:	6b02                	ld	s6,0(sp)
    80000e4e:	6121                	addi	sp,sp,64
    80000e50:	8082                	ret

0000000080000e52 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e52:	1141                	addi	sp,sp,-16
    80000e54:	e422                	sd	s0,8(sp)
    80000e56:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e58:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e5a:	2501                	sext.w	a0,a0
    80000e5c:	6422                	ld	s0,8(sp)
    80000e5e:	0141                	addi	sp,sp,16
    80000e60:	8082                	ret

0000000080000e62 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e422                	sd	s0,8(sp)
    80000e66:	0800                	addi	s0,sp,16
    80000e68:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e6a:	2781                	sext.w	a5,a5
    80000e6c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e6e:	00008517          	auipc	a0,0x8
    80000e72:	c7250513          	addi	a0,a0,-910 # 80008ae0 <cpus>
    80000e76:	953e                	add	a0,a0,a5
    80000e78:	6422                	ld	s0,8(sp)
    80000e7a:	0141                	addi	sp,sp,16
    80000e7c:	8082                	ret

0000000080000e7e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e7e:	1101                	addi	sp,sp,-32
    80000e80:	ec06                	sd	ra,24(sp)
    80000e82:	e822                	sd	s0,16(sp)
    80000e84:	e426                	sd	s1,8(sp)
    80000e86:	1000                	addi	s0,sp,32
  push_off();
    80000e88:	00005097          	auipc	ra,0x5
    80000e8c:	3f8080e7          	jalr	1016(ra) # 80006280 <push_off>
    80000e90:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e92:	2781                	sext.w	a5,a5
    80000e94:	079e                	slli	a5,a5,0x7
    80000e96:	00008717          	auipc	a4,0x8
    80000e9a:	c1a70713          	addi	a4,a4,-998 # 80008ab0 <pid_lock>
    80000e9e:	97ba                	add	a5,a5,a4
    80000ea0:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ea2:	00005097          	auipc	ra,0x5
    80000ea6:	47e080e7          	jalr	1150(ra) # 80006320 <pop_off>
  return p;
}
    80000eaa:	8526                	mv	a0,s1
    80000eac:	60e2                	ld	ra,24(sp)
    80000eae:	6442                	ld	s0,16(sp)
    80000eb0:	64a2                	ld	s1,8(sp)
    80000eb2:	6105                	addi	sp,sp,32
    80000eb4:	8082                	ret

0000000080000eb6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eb6:	1141                	addi	sp,sp,-16
    80000eb8:	e406                	sd	ra,8(sp)
    80000eba:	e022                	sd	s0,0(sp)
    80000ebc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ebe:	00000097          	auipc	ra,0x0
    80000ec2:	fc0080e7          	jalr	-64(ra) # 80000e7e <myproc>
    80000ec6:	00005097          	auipc	ra,0x5
    80000eca:	4ba080e7          	jalr	1210(ra) # 80006380 <release>

  if (first) {
    80000ece:	00008797          	auipc	a5,0x8
    80000ed2:	a627a783          	lw	a5,-1438(a5) # 80008930 <first.1683>
    80000ed6:	eb89                	bnez	a5,80000ee8 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed8:	00001097          	auipc	ra,0x1
    80000edc:	cb2080e7          	jalr	-846(ra) # 80001b8a <usertrapret>
}
    80000ee0:	60a2                	ld	ra,8(sp)
    80000ee2:	6402                	ld	s0,0(sp)
    80000ee4:	0141                	addi	sp,sp,16
    80000ee6:	8082                	ret
    first = 0;
    80000ee8:	00008797          	auipc	a5,0x8
    80000eec:	a407a423          	sw	zero,-1464(a5) # 80008930 <first.1683>
    fsinit(ROOTDEV);
    80000ef0:	4505                	li	a0,1
    80000ef2:	00002097          	auipc	ra,0x2
    80000ef6:	b0e080e7          	jalr	-1266(ra) # 80002a00 <fsinit>
    80000efa:	bff9                	j	80000ed8 <forkret+0x22>

0000000080000efc <allocpid>:
{
    80000efc:	1101                	addi	sp,sp,-32
    80000efe:	ec06                	sd	ra,24(sp)
    80000f00:	e822                	sd	s0,16(sp)
    80000f02:	e426                	sd	s1,8(sp)
    80000f04:	e04a                	sd	s2,0(sp)
    80000f06:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f08:	00008917          	auipc	s2,0x8
    80000f0c:	ba890913          	addi	s2,s2,-1112 # 80008ab0 <pid_lock>
    80000f10:	854a                	mv	a0,s2
    80000f12:	00005097          	auipc	ra,0x5
    80000f16:	3ba080e7          	jalr	954(ra) # 800062cc <acquire>
  pid = nextpid;
    80000f1a:	00008797          	auipc	a5,0x8
    80000f1e:	a1a78793          	addi	a5,a5,-1510 # 80008934 <nextpid>
    80000f22:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f24:	0014871b          	addiw	a4,s1,1
    80000f28:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f2a:	854a                	mv	a0,s2
    80000f2c:	00005097          	auipc	ra,0x5
    80000f30:	454080e7          	jalr	1108(ra) # 80006380 <release>
}
    80000f34:	8526                	mv	a0,s1
    80000f36:	60e2                	ld	ra,24(sp)
    80000f38:	6442                	ld	s0,16(sp)
    80000f3a:	64a2                	ld	s1,8(sp)
    80000f3c:	6902                	ld	s2,0(sp)
    80000f3e:	6105                	addi	sp,sp,32
    80000f40:	8082                	ret

0000000080000f42 <proc_pagetable>:
{
    80000f42:	1101                	addi	sp,sp,-32
    80000f44:	ec06                	sd	ra,24(sp)
    80000f46:	e822                	sd	s0,16(sp)
    80000f48:	e426                	sd	s1,8(sp)
    80000f4a:	e04a                	sd	s2,0(sp)
    80000f4c:	1000                	addi	s0,sp,32
    80000f4e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f50:	00000097          	auipc	ra,0x0
    80000f54:	8ac080e7          	jalr	-1876(ra) # 800007fc <uvmcreate>
    80000f58:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f5a:	c121                	beqz	a0,80000f9a <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f5c:	4729                	li	a4,10
    80000f5e:	00006697          	auipc	a3,0x6
    80000f62:	0a268693          	addi	a3,a3,162 # 80007000 <_trampoline>
    80000f66:	6605                	lui	a2,0x1
    80000f68:	040005b7          	lui	a1,0x4000
    80000f6c:	15fd                	addi	a1,a1,-1
    80000f6e:	05b2                	slli	a1,a1,0xc
    80000f70:	fffff097          	auipc	ra,0xfffff
    80000f74:	602080e7          	jalr	1538(ra) # 80000572 <mappages>
    80000f78:	02054863          	bltz	a0,80000fa8 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f7c:	4719                	li	a4,6
    80000f7e:	05893683          	ld	a3,88(s2)
    80000f82:	6605                	lui	a2,0x1
    80000f84:	020005b7          	lui	a1,0x2000
    80000f88:	15fd                	addi	a1,a1,-1
    80000f8a:	05b6                	slli	a1,a1,0xd
    80000f8c:	8526                	mv	a0,s1
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	5e4080e7          	jalr	1508(ra) # 80000572 <mappages>
    80000f96:	02054163          	bltz	a0,80000fb8 <proc_pagetable+0x76>
}
    80000f9a:	8526                	mv	a0,s1
    80000f9c:	60e2                	ld	ra,24(sp)
    80000f9e:	6442                	ld	s0,16(sp)
    80000fa0:	64a2                	ld	s1,8(sp)
    80000fa2:	6902                	ld	s2,0(sp)
    80000fa4:	6105                	addi	sp,sp,32
    80000fa6:	8082                	ret
    uvmfree(pagetable, 0);
    80000fa8:	4581                	li	a1,0
    80000faa:	8526                	mv	a0,s1
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	a54080e7          	jalr	-1452(ra) # 80000a00 <uvmfree>
    return 0;
    80000fb4:	4481                	li	s1,0
    80000fb6:	b7d5                	j	80000f9a <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb8:	4681                	li	a3,0
    80000fba:	4605                	li	a2,1
    80000fbc:	040005b7          	lui	a1,0x4000
    80000fc0:	15fd                	addi	a1,a1,-1
    80000fc2:	05b2                	slli	a1,a1,0xc
    80000fc4:	8526                	mv	a0,s1
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	772080e7          	jalr	1906(ra) # 80000738 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fce:	4581                	li	a1,0
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	00000097          	auipc	ra,0x0
    80000fd6:	a2e080e7          	jalr	-1490(ra) # 80000a00 <uvmfree>
    return 0;
    80000fda:	4481                	li	s1,0
    80000fdc:	bf7d                	j	80000f9a <proc_pagetable+0x58>

0000000080000fde <proc_freepagetable>:
{
    80000fde:	1101                	addi	sp,sp,-32
    80000fe0:	ec06                	sd	ra,24(sp)
    80000fe2:	e822                	sd	s0,16(sp)
    80000fe4:	e426                	sd	s1,8(sp)
    80000fe6:	e04a                	sd	s2,0(sp)
    80000fe8:	1000                	addi	s0,sp,32
    80000fea:	84aa                	mv	s1,a0
    80000fec:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fee:	4681                	li	a3,0
    80000ff0:	4605                	li	a2,1
    80000ff2:	040005b7          	lui	a1,0x4000
    80000ff6:	15fd                	addi	a1,a1,-1
    80000ff8:	05b2                	slli	a1,a1,0xc
    80000ffa:	fffff097          	auipc	ra,0xfffff
    80000ffe:	73e080e7          	jalr	1854(ra) # 80000738 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001002:	4681                	li	a3,0
    80001004:	4605                	li	a2,1
    80001006:	020005b7          	lui	a1,0x2000
    8000100a:	15fd                	addi	a1,a1,-1
    8000100c:	05b6                	slli	a1,a1,0xd
    8000100e:	8526                	mv	a0,s1
    80001010:	fffff097          	auipc	ra,0xfffff
    80001014:	728080e7          	jalr	1832(ra) # 80000738 <uvmunmap>
  uvmfree(pagetable, sz);
    80001018:	85ca                	mv	a1,s2
    8000101a:	8526                	mv	a0,s1
    8000101c:	00000097          	auipc	ra,0x0
    80001020:	9e4080e7          	jalr	-1564(ra) # 80000a00 <uvmfree>
}
    80001024:	60e2                	ld	ra,24(sp)
    80001026:	6442                	ld	s0,16(sp)
    80001028:	64a2                	ld	s1,8(sp)
    8000102a:	6902                	ld	s2,0(sp)
    8000102c:	6105                	addi	sp,sp,32
    8000102e:	8082                	ret

0000000080001030 <freeproc>:
{
    80001030:	1101                	addi	sp,sp,-32
    80001032:	ec06                	sd	ra,24(sp)
    80001034:	e822                	sd	s0,16(sp)
    80001036:	e426                	sd	s1,8(sp)
    80001038:	1000                	addi	s0,sp,32
    8000103a:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000103c:	6d28                	ld	a0,88(a0)
    8000103e:	c509                	beqz	a0,80001048 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001040:	fffff097          	auipc	ra,0xfffff
    80001044:	fdc080e7          	jalr	-36(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001048:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000104c:	68a8                	ld	a0,80(s1)
    8000104e:	c511                	beqz	a0,8000105a <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001050:	64ac                	ld	a1,72(s1)
    80001052:	00000097          	auipc	ra,0x0
    80001056:	f8c080e7          	jalr	-116(ra) # 80000fde <proc_freepagetable>
  p->pagetable = 0;
    8000105a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000105e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001062:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001066:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000106a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000106e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001072:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001076:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000107a:	0004ac23          	sw	zero,24(s1)
}
    8000107e:	60e2                	ld	ra,24(sp)
    80001080:	6442                	ld	s0,16(sp)
    80001082:	64a2                	ld	s1,8(sp)
    80001084:	6105                	addi	sp,sp,32
    80001086:	8082                	ret

0000000080001088 <allocproc>:
{
    80001088:	1101                	addi	sp,sp,-32
    8000108a:	ec06                	sd	ra,24(sp)
    8000108c:	e822                	sd	s0,16(sp)
    8000108e:	e426                	sd	s1,8(sp)
    80001090:	e04a                	sd	s2,0(sp)
    80001092:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001094:	00008497          	auipc	s1,0x8
    80001098:	e4c48493          	addi	s1,s1,-436 # 80008ee0 <proc>
    8000109c:	0000e917          	auipc	s2,0xe
    800010a0:	a4490913          	addi	s2,s2,-1468 # 8000eae0 <tickslock>
    acquire(&p->lock);
    800010a4:	8526                	mv	a0,s1
    800010a6:	00005097          	auipc	ra,0x5
    800010aa:	226080e7          	jalr	550(ra) # 800062cc <acquire>
    if(p->state == UNUSED) {
    800010ae:	4c9c                	lw	a5,24(s1)
    800010b0:	cf81                	beqz	a5,800010c8 <allocproc+0x40>
      release(&p->lock);
    800010b2:	8526                	mv	a0,s1
    800010b4:	00005097          	auipc	ra,0x5
    800010b8:	2cc080e7          	jalr	716(ra) # 80006380 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010bc:	17048493          	addi	s1,s1,368
    800010c0:	ff2492e3          	bne	s1,s2,800010a4 <allocproc+0x1c>
  return 0;
    800010c4:	4481                	li	s1,0
    800010c6:	a889                	j	80001118 <allocproc+0x90>
  p->pid = allocpid();
    800010c8:	00000097          	auipc	ra,0x0
    800010cc:	e34080e7          	jalr	-460(ra) # 80000efc <allocpid>
    800010d0:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010d2:	4785                	li	a5,1
    800010d4:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010d6:	fffff097          	auipc	ra,0xfffff
    800010da:	042080e7          	jalr	66(ra) # 80000118 <kalloc>
    800010de:	892a                	mv	s2,a0
    800010e0:	eca8                	sd	a0,88(s1)
    800010e2:	c131                	beqz	a0,80001126 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010e4:	8526                	mv	a0,s1
    800010e6:	00000097          	auipc	ra,0x0
    800010ea:	e5c080e7          	jalr	-420(ra) # 80000f42 <proc_pagetable>
    800010ee:	892a                	mv	s2,a0
    800010f0:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010f2:	c531                	beqz	a0,8000113e <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010f4:	07000613          	li	a2,112
    800010f8:	4581                	li	a1,0
    800010fa:	06048513          	addi	a0,s1,96
    800010fe:	fffff097          	auipc	ra,0xfffff
    80001102:	0a0080e7          	jalr	160(ra) # 8000019e <memset>
  p->context.ra = (uint64)forkret;
    80001106:	00000797          	auipc	a5,0x0
    8000110a:	db078793          	addi	a5,a5,-592 # 80000eb6 <forkret>
    8000110e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001110:	60bc                	ld	a5,64(s1)
    80001112:	6705                	lui	a4,0x1
    80001114:	97ba                	add	a5,a5,a4
    80001116:	f4bc                	sd	a5,104(s1)
}
    80001118:	8526                	mv	a0,s1
    8000111a:	60e2                	ld	ra,24(sp)
    8000111c:	6442                	ld	s0,16(sp)
    8000111e:	64a2                	ld	s1,8(sp)
    80001120:	6902                	ld	s2,0(sp)
    80001122:	6105                	addi	sp,sp,32
    80001124:	8082                	ret
    freeproc(p);
    80001126:	8526                	mv	a0,s1
    80001128:	00000097          	auipc	ra,0x0
    8000112c:	f08080e7          	jalr	-248(ra) # 80001030 <freeproc>
    release(&p->lock);
    80001130:	8526                	mv	a0,s1
    80001132:	00005097          	auipc	ra,0x5
    80001136:	24e080e7          	jalr	590(ra) # 80006380 <release>
    return 0;
    8000113a:	84ca                	mv	s1,s2
    8000113c:	bff1                	j	80001118 <allocproc+0x90>
    freeproc(p);
    8000113e:	8526                	mv	a0,s1
    80001140:	00000097          	auipc	ra,0x0
    80001144:	ef0080e7          	jalr	-272(ra) # 80001030 <freeproc>
    release(&p->lock);
    80001148:	8526                	mv	a0,s1
    8000114a:	00005097          	auipc	ra,0x5
    8000114e:	236080e7          	jalr	566(ra) # 80006380 <release>
    return 0;
    80001152:	84ca                	mv	s1,s2
    80001154:	b7d1                	j	80001118 <allocproc+0x90>

0000000080001156 <userinit>:
{
    80001156:	1101                	addi	sp,sp,-32
    80001158:	ec06                	sd	ra,24(sp)
    8000115a:	e822                	sd	s0,16(sp)
    8000115c:	e426                	sd	s1,8(sp)
    8000115e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001160:	00000097          	auipc	ra,0x0
    80001164:	f28080e7          	jalr	-216(ra) # 80001088 <allocproc>
    80001168:	84aa                	mv	s1,a0
  initproc = p;
    8000116a:	00008797          	auipc	a5,0x8
    8000116e:	90a7b323          	sd	a0,-1786(a5) # 80008a70 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001172:	03400613          	li	a2,52
    80001176:	00007597          	auipc	a1,0x7
    8000117a:	7ca58593          	addi	a1,a1,1994 # 80008940 <initcode>
    8000117e:	6928                	ld	a0,80(a0)
    80001180:	fffff097          	auipc	ra,0xfffff
    80001184:	6aa080e7          	jalr	1706(ra) # 8000082a <uvmfirst>
  p->sz = PGSIZE;
    80001188:	6785                	lui	a5,0x1
    8000118a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000118c:	6cb8                	ld	a4,88(s1)
    8000118e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001192:	6cb8                	ld	a4,88(s1)
    80001194:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001196:	4641                	li	a2,16
    80001198:	00007597          	auipc	a1,0x7
    8000119c:	fe858593          	addi	a1,a1,-24 # 80008180 <etext+0x180>
    800011a0:	15848513          	addi	a0,s1,344
    800011a4:	fffff097          	auipc	ra,0xfffff
    800011a8:	14c080e7          	jalr	332(ra) # 800002f0 <safestrcpy>
  p->cwd = namei("/");
    800011ac:	00007517          	auipc	a0,0x7
    800011b0:	fe450513          	addi	a0,a0,-28 # 80008190 <etext+0x190>
    800011b4:	00002097          	auipc	ra,0x2
    800011b8:	26e080e7          	jalr	622(ra) # 80003422 <namei>
    800011bc:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011c0:	478d                	li	a5,3
    800011c2:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011c4:	8526                	mv	a0,s1
    800011c6:	00005097          	auipc	ra,0x5
    800011ca:	1ba080e7          	jalr	442(ra) # 80006380 <release>
}
    800011ce:	60e2                	ld	ra,24(sp)
    800011d0:	6442                	ld	s0,16(sp)
    800011d2:	64a2                	ld	s1,8(sp)
    800011d4:	6105                	addi	sp,sp,32
    800011d6:	8082                	ret

00000000800011d8 <growproc>:
{
    800011d8:	1101                	addi	sp,sp,-32
    800011da:	ec06                	sd	ra,24(sp)
    800011dc:	e822                	sd	s0,16(sp)
    800011de:	e426                	sd	s1,8(sp)
    800011e0:	e04a                	sd	s2,0(sp)
    800011e2:	1000                	addi	s0,sp,32
    800011e4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011e6:	00000097          	auipc	ra,0x0
    800011ea:	c98080e7          	jalr	-872(ra) # 80000e7e <myproc>
    800011ee:	84aa                	mv	s1,a0
  sz = p->sz;
    800011f0:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011f2:	01204c63          	bgtz	s2,8000120a <growproc+0x32>
  } else if(n < 0){
    800011f6:	02094663          	bltz	s2,80001222 <growproc+0x4a>
  p->sz = sz;
    800011fa:	e4ac                	sd	a1,72(s1)
  return 0;
    800011fc:	4501                	li	a0,0
}
    800011fe:	60e2                	ld	ra,24(sp)
    80001200:	6442                	ld	s0,16(sp)
    80001202:	64a2                	ld	s1,8(sp)
    80001204:	6902                	ld	s2,0(sp)
    80001206:	6105                	addi	sp,sp,32
    80001208:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000120a:	4691                	li	a3,4
    8000120c:	00b90633          	add	a2,s2,a1
    80001210:	6928                	ld	a0,80(a0)
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	6d2080e7          	jalr	1746(ra) # 800008e4 <uvmalloc>
    8000121a:	85aa                	mv	a1,a0
    8000121c:	fd79                	bnez	a0,800011fa <growproc+0x22>
      return -1;
    8000121e:	557d                	li	a0,-1
    80001220:	bff9                	j	800011fe <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001222:	00b90633          	add	a2,s2,a1
    80001226:	6928                	ld	a0,80(a0)
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	674080e7          	jalr	1652(ra) # 8000089c <uvmdealloc>
    80001230:	85aa                	mv	a1,a0
    80001232:	b7e1                	j	800011fa <growproc+0x22>

0000000080001234 <fork>:
{
    80001234:	7179                	addi	sp,sp,-48
    80001236:	f406                	sd	ra,40(sp)
    80001238:	f022                	sd	s0,32(sp)
    8000123a:	ec26                	sd	s1,24(sp)
    8000123c:	e84a                	sd	s2,16(sp)
    8000123e:	e44e                	sd	s3,8(sp)
    80001240:	e052                	sd	s4,0(sp)
    80001242:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001244:	00000097          	auipc	ra,0x0
    80001248:	c3a080e7          	jalr	-966(ra) # 80000e7e <myproc>
    8000124c:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	e3a080e7          	jalr	-454(ra) # 80001088 <allocproc>
    80001256:	10050f63          	beqz	a0,80001374 <fork+0x140>
    8000125a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000125c:	04893603          	ld	a2,72(s2)
    80001260:	692c                	ld	a1,80(a0)
    80001262:	05093503          	ld	a0,80(s2)
    80001266:	fffff097          	auipc	ra,0xfffff
    8000126a:	7d2080e7          	jalr	2002(ra) # 80000a38 <uvmcopy>
    8000126e:	04054a63          	bltz	a0,800012c2 <fork+0x8e>
  np->sz = p->sz;
    80001272:	04893783          	ld	a5,72(s2)
    80001276:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000127a:	05893683          	ld	a3,88(s2)
    8000127e:	87b6                	mv	a5,a3
    80001280:	0589b703          	ld	a4,88(s3)
    80001284:	12068693          	addi	a3,a3,288
    80001288:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000128c:	6788                	ld	a0,8(a5)
    8000128e:	6b8c                	ld	a1,16(a5)
    80001290:	6f90                	ld	a2,24(a5)
    80001292:	01073023          	sd	a6,0(a4)
    80001296:	e708                	sd	a0,8(a4)
    80001298:	eb0c                	sd	a1,16(a4)
    8000129a:	ef10                	sd	a2,24(a4)
    8000129c:	02078793          	addi	a5,a5,32
    800012a0:	02070713          	addi	a4,a4,32
    800012a4:	fed792e3          	bne	a5,a3,80001288 <fork+0x54>
  np->trapframe->a0 = 0;
    800012a8:	0589b783          	ld	a5,88(s3)
    800012ac:	0607b823          	sd	zero,112(a5)
  np->mask=p->mask;
    800012b0:	16892783          	lw	a5,360(s2)
    800012b4:	16f9a423          	sw	a5,360(s3)
    800012b8:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012bc:	15000a13          	li	s4,336
    800012c0:	a03d                	j	800012ee <fork+0xba>
    freeproc(np);
    800012c2:	854e                	mv	a0,s3
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	d6c080e7          	jalr	-660(ra) # 80001030 <freeproc>
    release(&np->lock);
    800012cc:	854e                	mv	a0,s3
    800012ce:	00005097          	auipc	ra,0x5
    800012d2:	0b2080e7          	jalr	178(ra) # 80006380 <release>
    return -1;
    800012d6:	5a7d                	li	s4,-1
    800012d8:	a069                	j	80001362 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    800012da:	00002097          	auipc	ra,0x2
    800012de:	7de080e7          	jalr	2014(ra) # 80003ab8 <filedup>
    800012e2:	009987b3          	add	a5,s3,s1
    800012e6:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012e8:	04a1                	addi	s1,s1,8
    800012ea:	01448763          	beq	s1,s4,800012f8 <fork+0xc4>
    if(p->ofile[i])
    800012ee:	009907b3          	add	a5,s2,s1
    800012f2:	6388                	ld	a0,0(a5)
    800012f4:	f17d                	bnez	a0,800012da <fork+0xa6>
    800012f6:	bfcd                	j	800012e8 <fork+0xb4>
  np->cwd = idup(p->cwd);
    800012f8:	15093503          	ld	a0,336(s2)
    800012fc:	00002097          	auipc	ra,0x2
    80001300:	942080e7          	jalr	-1726(ra) # 80002c3e <idup>
    80001304:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001308:	4641                	li	a2,16
    8000130a:	15890593          	addi	a1,s2,344
    8000130e:	15898513          	addi	a0,s3,344
    80001312:	fffff097          	auipc	ra,0xfffff
    80001316:	fde080e7          	jalr	-34(ra) # 800002f0 <safestrcpy>
  pid = np->pid;
    8000131a:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    8000131e:	854e                	mv	a0,s3
    80001320:	00005097          	auipc	ra,0x5
    80001324:	060080e7          	jalr	96(ra) # 80006380 <release>
  acquire(&wait_lock);
    80001328:	00007497          	auipc	s1,0x7
    8000132c:	7a048493          	addi	s1,s1,1952 # 80008ac8 <wait_lock>
    80001330:	8526                	mv	a0,s1
    80001332:	00005097          	auipc	ra,0x5
    80001336:	f9a080e7          	jalr	-102(ra) # 800062cc <acquire>
  np->parent = p;
    8000133a:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000133e:	8526                	mv	a0,s1
    80001340:	00005097          	auipc	ra,0x5
    80001344:	040080e7          	jalr	64(ra) # 80006380 <release>
  acquire(&np->lock);
    80001348:	854e                	mv	a0,s3
    8000134a:	00005097          	auipc	ra,0x5
    8000134e:	f82080e7          	jalr	-126(ra) # 800062cc <acquire>
  np->state = RUNNABLE;
    80001352:	478d                	li	a5,3
    80001354:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001358:	854e                	mv	a0,s3
    8000135a:	00005097          	auipc	ra,0x5
    8000135e:	026080e7          	jalr	38(ra) # 80006380 <release>
}
    80001362:	8552                	mv	a0,s4
    80001364:	70a2                	ld	ra,40(sp)
    80001366:	7402                	ld	s0,32(sp)
    80001368:	64e2                	ld	s1,24(sp)
    8000136a:	6942                	ld	s2,16(sp)
    8000136c:	69a2                	ld	s3,8(sp)
    8000136e:	6a02                	ld	s4,0(sp)
    80001370:	6145                	addi	sp,sp,48
    80001372:	8082                	ret
    return -1;
    80001374:	5a7d                	li	s4,-1
    80001376:	b7f5                	j	80001362 <fork+0x12e>

0000000080001378 <scheduler>:
{
    80001378:	7139                	addi	sp,sp,-64
    8000137a:	fc06                	sd	ra,56(sp)
    8000137c:	f822                	sd	s0,48(sp)
    8000137e:	f426                	sd	s1,40(sp)
    80001380:	f04a                	sd	s2,32(sp)
    80001382:	ec4e                	sd	s3,24(sp)
    80001384:	e852                	sd	s4,16(sp)
    80001386:	e456                	sd	s5,8(sp)
    80001388:	e05a                	sd	s6,0(sp)
    8000138a:	0080                	addi	s0,sp,64
    8000138c:	8792                	mv	a5,tp
  int id = r_tp();
    8000138e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001390:	00779a93          	slli	s5,a5,0x7
    80001394:	00007717          	auipc	a4,0x7
    80001398:	71c70713          	addi	a4,a4,1820 # 80008ab0 <pid_lock>
    8000139c:	9756                	add	a4,a4,s5
    8000139e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013a2:	00007717          	auipc	a4,0x7
    800013a6:	74670713          	addi	a4,a4,1862 # 80008ae8 <cpus+0x8>
    800013aa:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013ac:	498d                	li	s3,3
        p->state = RUNNING;
    800013ae:	4b11                	li	s6,4
        c->proc = p;
    800013b0:	079e                	slli	a5,a5,0x7
    800013b2:	00007a17          	auipc	s4,0x7
    800013b6:	6fea0a13          	addi	s4,s4,1790 # 80008ab0 <pid_lock>
    800013ba:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013bc:	0000d917          	auipc	s2,0xd
    800013c0:	72490913          	addi	s2,s2,1828 # 8000eae0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013c8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013cc:	10079073          	csrw	sstatus,a5
    800013d0:	00008497          	auipc	s1,0x8
    800013d4:	b1048493          	addi	s1,s1,-1264 # 80008ee0 <proc>
    800013d8:	a03d                	j	80001406 <scheduler+0x8e>
        p->state = RUNNING;
    800013da:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013de:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013e2:	06048593          	addi	a1,s1,96
    800013e6:	8556                	mv	a0,s5
    800013e8:	00000097          	auipc	ra,0x0
    800013ec:	6f8080e7          	jalr	1784(ra) # 80001ae0 <swtch>
        c->proc = 0;
    800013f0:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013f4:	8526                	mv	a0,s1
    800013f6:	00005097          	auipc	ra,0x5
    800013fa:	f8a080e7          	jalr	-118(ra) # 80006380 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fe:	17048493          	addi	s1,s1,368
    80001402:	fd2481e3          	beq	s1,s2,800013c4 <scheduler+0x4c>
      acquire(&p->lock);
    80001406:	8526                	mv	a0,s1
    80001408:	00005097          	auipc	ra,0x5
    8000140c:	ec4080e7          	jalr	-316(ra) # 800062cc <acquire>
      if(p->state == RUNNABLE) {
    80001410:	4c9c                	lw	a5,24(s1)
    80001412:	ff3791e3          	bne	a5,s3,800013f4 <scheduler+0x7c>
    80001416:	b7d1                	j	800013da <scheduler+0x62>

0000000080001418 <sched>:
{
    80001418:	7179                	addi	sp,sp,-48
    8000141a:	f406                	sd	ra,40(sp)
    8000141c:	f022                	sd	s0,32(sp)
    8000141e:	ec26                	sd	s1,24(sp)
    80001420:	e84a                	sd	s2,16(sp)
    80001422:	e44e                	sd	s3,8(sp)
    80001424:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001426:	00000097          	auipc	ra,0x0
    8000142a:	a58080e7          	jalr	-1448(ra) # 80000e7e <myproc>
    8000142e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001430:	00005097          	auipc	ra,0x5
    80001434:	e22080e7          	jalr	-478(ra) # 80006252 <holding>
    80001438:	c93d                	beqz	a0,800014ae <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000143a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000143c:	2781                	sext.w	a5,a5
    8000143e:	079e                	slli	a5,a5,0x7
    80001440:	00007717          	auipc	a4,0x7
    80001444:	67070713          	addi	a4,a4,1648 # 80008ab0 <pid_lock>
    80001448:	97ba                	add	a5,a5,a4
    8000144a:	0a87a703          	lw	a4,168(a5)
    8000144e:	4785                	li	a5,1
    80001450:	06f71763          	bne	a4,a5,800014be <sched+0xa6>
  if(p->state == RUNNING)
    80001454:	4c98                	lw	a4,24(s1)
    80001456:	4791                	li	a5,4
    80001458:	06f70b63          	beq	a4,a5,800014ce <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000145c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001460:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001462:	efb5                	bnez	a5,800014de <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001464:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001466:	00007917          	auipc	s2,0x7
    8000146a:	64a90913          	addi	s2,s2,1610 # 80008ab0 <pid_lock>
    8000146e:	2781                	sext.w	a5,a5
    80001470:	079e                	slli	a5,a5,0x7
    80001472:	97ca                	add	a5,a5,s2
    80001474:	0ac7a983          	lw	s3,172(a5)
    80001478:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000147a:	2781                	sext.w	a5,a5
    8000147c:	079e                	slli	a5,a5,0x7
    8000147e:	00007597          	auipc	a1,0x7
    80001482:	66a58593          	addi	a1,a1,1642 # 80008ae8 <cpus+0x8>
    80001486:	95be                	add	a1,a1,a5
    80001488:	06048513          	addi	a0,s1,96
    8000148c:	00000097          	auipc	ra,0x0
    80001490:	654080e7          	jalr	1620(ra) # 80001ae0 <swtch>
    80001494:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001496:	2781                	sext.w	a5,a5
    80001498:	079e                	slli	a5,a5,0x7
    8000149a:	97ca                	add	a5,a5,s2
    8000149c:	0b37a623          	sw	s3,172(a5)
}
    800014a0:	70a2                	ld	ra,40(sp)
    800014a2:	7402                	ld	s0,32(sp)
    800014a4:	64e2                	ld	s1,24(sp)
    800014a6:	6942                	ld	s2,16(sp)
    800014a8:	69a2                	ld	s3,8(sp)
    800014aa:	6145                	addi	sp,sp,48
    800014ac:	8082                	ret
    panic("sched p->lock");
    800014ae:	00007517          	auipc	a0,0x7
    800014b2:	cea50513          	addi	a0,a0,-790 # 80008198 <etext+0x198>
    800014b6:	00005097          	auipc	ra,0x5
    800014ba:	8cc080e7          	jalr	-1844(ra) # 80005d82 <panic>
    panic("sched locks");
    800014be:	00007517          	auipc	a0,0x7
    800014c2:	cea50513          	addi	a0,a0,-790 # 800081a8 <etext+0x1a8>
    800014c6:	00005097          	auipc	ra,0x5
    800014ca:	8bc080e7          	jalr	-1860(ra) # 80005d82 <panic>
    panic("sched running");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	cea50513          	addi	a0,a0,-790 # 800081b8 <etext+0x1b8>
    800014d6:	00005097          	auipc	ra,0x5
    800014da:	8ac080e7          	jalr	-1876(ra) # 80005d82 <panic>
    panic("sched interruptible");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	cea50513          	addi	a0,a0,-790 # 800081c8 <etext+0x1c8>
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	89c080e7          	jalr	-1892(ra) # 80005d82 <panic>

00000000800014ee <yield>:
{
    800014ee:	1101                	addi	sp,sp,-32
    800014f0:	ec06                	sd	ra,24(sp)
    800014f2:	e822                	sd	s0,16(sp)
    800014f4:	e426                	sd	s1,8(sp)
    800014f6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014f8:	00000097          	auipc	ra,0x0
    800014fc:	986080e7          	jalr	-1658(ra) # 80000e7e <myproc>
    80001500:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001502:	00005097          	auipc	ra,0x5
    80001506:	dca080e7          	jalr	-566(ra) # 800062cc <acquire>
  p->state = RUNNABLE;
    8000150a:	478d                	li	a5,3
    8000150c:	cc9c                	sw	a5,24(s1)
  sched();
    8000150e:	00000097          	auipc	ra,0x0
    80001512:	f0a080e7          	jalr	-246(ra) # 80001418 <sched>
  release(&p->lock);
    80001516:	8526                	mv	a0,s1
    80001518:	00005097          	auipc	ra,0x5
    8000151c:	e68080e7          	jalr	-408(ra) # 80006380 <release>
}
    80001520:	60e2                	ld	ra,24(sp)
    80001522:	6442                	ld	s0,16(sp)
    80001524:	64a2                	ld	s1,8(sp)
    80001526:	6105                	addi	sp,sp,32
    80001528:	8082                	ret

000000008000152a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000152a:	7179                	addi	sp,sp,-48
    8000152c:	f406                	sd	ra,40(sp)
    8000152e:	f022                	sd	s0,32(sp)
    80001530:	ec26                	sd	s1,24(sp)
    80001532:	e84a                	sd	s2,16(sp)
    80001534:	e44e                	sd	s3,8(sp)
    80001536:	1800                	addi	s0,sp,48
    80001538:	89aa                	mv	s3,a0
    8000153a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	942080e7          	jalr	-1726(ra) # 80000e7e <myproc>
    80001544:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001546:	00005097          	auipc	ra,0x5
    8000154a:	d86080e7          	jalr	-634(ra) # 800062cc <acquire>
  release(lk);
    8000154e:	854a                	mv	a0,s2
    80001550:	00005097          	auipc	ra,0x5
    80001554:	e30080e7          	jalr	-464(ra) # 80006380 <release>

  // Go to sleep.
  p->chan = chan;
    80001558:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000155c:	4789                	li	a5,2
    8000155e:	cc9c                	sw	a5,24(s1)

  sched();
    80001560:	00000097          	auipc	ra,0x0
    80001564:	eb8080e7          	jalr	-328(ra) # 80001418 <sched>

  // Tidy up.
  p->chan = 0;
    80001568:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000156c:	8526                	mv	a0,s1
    8000156e:	00005097          	auipc	ra,0x5
    80001572:	e12080e7          	jalr	-494(ra) # 80006380 <release>
  acquire(lk);
    80001576:	854a                	mv	a0,s2
    80001578:	00005097          	auipc	ra,0x5
    8000157c:	d54080e7          	jalr	-684(ra) # 800062cc <acquire>
}
    80001580:	70a2                	ld	ra,40(sp)
    80001582:	7402                	ld	s0,32(sp)
    80001584:	64e2                	ld	s1,24(sp)
    80001586:	6942                	ld	s2,16(sp)
    80001588:	69a2                	ld	s3,8(sp)
    8000158a:	6145                	addi	sp,sp,48
    8000158c:	8082                	ret

000000008000158e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000158e:	7139                	addi	sp,sp,-64
    80001590:	fc06                	sd	ra,56(sp)
    80001592:	f822                	sd	s0,48(sp)
    80001594:	f426                	sd	s1,40(sp)
    80001596:	f04a                	sd	s2,32(sp)
    80001598:	ec4e                	sd	s3,24(sp)
    8000159a:	e852                	sd	s4,16(sp)
    8000159c:	e456                	sd	s5,8(sp)
    8000159e:	0080                	addi	s0,sp,64
    800015a0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015a2:	00008497          	auipc	s1,0x8
    800015a6:	93e48493          	addi	s1,s1,-1730 # 80008ee0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015aa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015ac:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015ae:	0000d917          	auipc	s2,0xd
    800015b2:	53290913          	addi	s2,s2,1330 # 8000eae0 <tickslock>
    800015b6:	a821                	j	800015ce <wakeup+0x40>
        p->state = RUNNABLE;
    800015b8:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    800015bc:	8526                	mv	a0,s1
    800015be:	00005097          	auipc	ra,0x5
    800015c2:	dc2080e7          	jalr	-574(ra) # 80006380 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015c6:	17048493          	addi	s1,s1,368
    800015ca:	03248463          	beq	s1,s2,800015f2 <wakeup+0x64>
    if(p != myproc()){
    800015ce:	00000097          	auipc	ra,0x0
    800015d2:	8b0080e7          	jalr	-1872(ra) # 80000e7e <myproc>
    800015d6:	fea488e3          	beq	s1,a0,800015c6 <wakeup+0x38>
      acquire(&p->lock);
    800015da:	8526                	mv	a0,s1
    800015dc:	00005097          	auipc	ra,0x5
    800015e0:	cf0080e7          	jalr	-784(ra) # 800062cc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015e4:	4c9c                	lw	a5,24(s1)
    800015e6:	fd379be3          	bne	a5,s3,800015bc <wakeup+0x2e>
    800015ea:	709c                	ld	a5,32(s1)
    800015ec:	fd4798e3          	bne	a5,s4,800015bc <wakeup+0x2e>
    800015f0:	b7e1                	j	800015b8 <wakeup+0x2a>
    }
  }
}
    800015f2:	70e2                	ld	ra,56(sp)
    800015f4:	7442                	ld	s0,48(sp)
    800015f6:	74a2                	ld	s1,40(sp)
    800015f8:	7902                	ld	s2,32(sp)
    800015fa:	69e2                	ld	s3,24(sp)
    800015fc:	6a42                	ld	s4,16(sp)
    800015fe:	6aa2                	ld	s5,8(sp)
    80001600:	6121                	addi	sp,sp,64
    80001602:	8082                	ret

0000000080001604 <reparent>:
{
    80001604:	7179                	addi	sp,sp,-48
    80001606:	f406                	sd	ra,40(sp)
    80001608:	f022                	sd	s0,32(sp)
    8000160a:	ec26                	sd	s1,24(sp)
    8000160c:	e84a                	sd	s2,16(sp)
    8000160e:	e44e                	sd	s3,8(sp)
    80001610:	e052                	sd	s4,0(sp)
    80001612:	1800                	addi	s0,sp,48
    80001614:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001616:	00008497          	auipc	s1,0x8
    8000161a:	8ca48493          	addi	s1,s1,-1846 # 80008ee0 <proc>
      pp->parent = initproc;
    8000161e:	00007a17          	auipc	s4,0x7
    80001622:	452a0a13          	addi	s4,s4,1106 # 80008a70 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001626:	0000d997          	auipc	s3,0xd
    8000162a:	4ba98993          	addi	s3,s3,1210 # 8000eae0 <tickslock>
    8000162e:	a029                	j	80001638 <reparent+0x34>
    80001630:	17048493          	addi	s1,s1,368
    80001634:	01348d63          	beq	s1,s3,8000164e <reparent+0x4a>
    if(pp->parent == p){
    80001638:	7c9c                	ld	a5,56(s1)
    8000163a:	ff279be3          	bne	a5,s2,80001630 <reparent+0x2c>
      pp->parent = initproc;
    8000163e:	000a3503          	ld	a0,0(s4)
    80001642:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001644:	00000097          	auipc	ra,0x0
    80001648:	f4a080e7          	jalr	-182(ra) # 8000158e <wakeup>
    8000164c:	b7d5                	j	80001630 <reparent+0x2c>
}
    8000164e:	70a2                	ld	ra,40(sp)
    80001650:	7402                	ld	s0,32(sp)
    80001652:	64e2                	ld	s1,24(sp)
    80001654:	6942                	ld	s2,16(sp)
    80001656:	69a2                	ld	s3,8(sp)
    80001658:	6a02                	ld	s4,0(sp)
    8000165a:	6145                	addi	sp,sp,48
    8000165c:	8082                	ret

000000008000165e <exit>:
{
    8000165e:	7179                	addi	sp,sp,-48
    80001660:	f406                	sd	ra,40(sp)
    80001662:	f022                	sd	s0,32(sp)
    80001664:	ec26                	sd	s1,24(sp)
    80001666:	e84a                	sd	s2,16(sp)
    80001668:	e44e                	sd	s3,8(sp)
    8000166a:	e052                	sd	s4,0(sp)
    8000166c:	1800                	addi	s0,sp,48
    8000166e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001670:	00000097          	auipc	ra,0x0
    80001674:	80e080e7          	jalr	-2034(ra) # 80000e7e <myproc>
    80001678:	89aa                	mv	s3,a0
  if(p == initproc)
    8000167a:	00007797          	auipc	a5,0x7
    8000167e:	3f67b783          	ld	a5,1014(a5) # 80008a70 <initproc>
    80001682:	0d050493          	addi	s1,a0,208
    80001686:	15050913          	addi	s2,a0,336
    8000168a:	02a79363          	bne	a5,a0,800016b0 <exit+0x52>
    panic("init exiting");
    8000168e:	00007517          	auipc	a0,0x7
    80001692:	b5250513          	addi	a0,a0,-1198 # 800081e0 <etext+0x1e0>
    80001696:	00004097          	auipc	ra,0x4
    8000169a:	6ec080e7          	jalr	1772(ra) # 80005d82 <panic>
      fileclose(f);
    8000169e:	00002097          	auipc	ra,0x2
    800016a2:	46c080e7          	jalr	1132(ra) # 80003b0a <fileclose>
      p->ofile[fd] = 0;
    800016a6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016aa:	04a1                	addi	s1,s1,8
    800016ac:	01248563          	beq	s1,s2,800016b6 <exit+0x58>
    if(p->ofile[fd]){
    800016b0:	6088                	ld	a0,0(s1)
    800016b2:	f575                	bnez	a0,8000169e <exit+0x40>
    800016b4:	bfdd                	j	800016aa <exit+0x4c>
  begin_op();
    800016b6:	00002097          	auipc	ra,0x2
    800016ba:	f88080e7          	jalr	-120(ra) # 8000363e <begin_op>
  iput(p->cwd);
    800016be:	1509b503          	ld	a0,336(s3)
    800016c2:	00001097          	auipc	ra,0x1
    800016c6:	774080e7          	jalr	1908(ra) # 80002e36 <iput>
  end_op();
    800016ca:	00002097          	auipc	ra,0x2
    800016ce:	ff4080e7          	jalr	-12(ra) # 800036be <end_op>
  p->cwd = 0;
    800016d2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016d6:	00007497          	auipc	s1,0x7
    800016da:	3f248493          	addi	s1,s1,1010 # 80008ac8 <wait_lock>
    800016de:	8526                	mv	a0,s1
    800016e0:	00005097          	auipc	ra,0x5
    800016e4:	bec080e7          	jalr	-1044(ra) # 800062cc <acquire>
  reparent(p);
    800016e8:	854e                	mv	a0,s3
    800016ea:	00000097          	auipc	ra,0x0
    800016ee:	f1a080e7          	jalr	-230(ra) # 80001604 <reparent>
  wakeup(p->parent);
    800016f2:	0389b503          	ld	a0,56(s3)
    800016f6:	00000097          	auipc	ra,0x0
    800016fa:	e98080e7          	jalr	-360(ra) # 8000158e <wakeup>
  acquire(&p->lock);
    800016fe:	854e                	mv	a0,s3
    80001700:	00005097          	auipc	ra,0x5
    80001704:	bcc080e7          	jalr	-1076(ra) # 800062cc <acquire>
  p->xstate = status;
    80001708:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000170c:	4795                	li	a5,5
    8000170e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001712:	8526                	mv	a0,s1
    80001714:	00005097          	auipc	ra,0x5
    80001718:	c6c080e7          	jalr	-916(ra) # 80006380 <release>
  sched();
    8000171c:	00000097          	auipc	ra,0x0
    80001720:	cfc080e7          	jalr	-772(ra) # 80001418 <sched>
  panic("zombie exit");
    80001724:	00007517          	auipc	a0,0x7
    80001728:	acc50513          	addi	a0,a0,-1332 # 800081f0 <etext+0x1f0>
    8000172c:	00004097          	auipc	ra,0x4
    80001730:	656080e7          	jalr	1622(ra) # 80005d82 <panic>

0000000080001734 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001734:	7179                	addi	sp,sp,-48
    80001736:	f406                	sd	ra,40(sp)
    80001738:	f022                	sd	s0,32(sp)
    8000173a:	ec26                	sd	s1,24(sp)
    8000173c:	e84a                	sd	s2,16(sp)
    8000173e:	e44e                	sd	s3,8(sp)
    80001740:	1800                	addi	s0,sp,48
    80001742:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001744:	00007497          	auipc	s1,0x7
    80001748:	79c48493          	addi	s1,s1,1948 # 80008ee0 <proc>
    8000174c:	0000d997          	auipc	s3,0xd
    80001750:	39498993          	addi	s3,s3,916 # 8000eae0 <tickslock>
    acquire(&p->lock);
    80001754:	8526                	mv	a0,s1
    80001756:	00005097          	auipc	ra,0x5
    8000175a:	b76080e7          	jalr	-1162(ra) # 800062cc <acquire>
    if(p->pid == pid){
    8000175e:	589c                	lw	a5,48(s1)
    80001760:	01278d63          	beq	a5,s2,8000177a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001764:	8526                	mv	a0,s1
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	c1a080e7          	jalr	-998(ra) # 80006380 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000176e:	17048493          	addi	s1,s1,368
    80001772:	ff3491e3          	bne	s1,s3,80001754 <kill+0x20>
  }
  return -1;
    80001776:	557d                	li	a0,-1
    80001778:	a829                	j	80001792 <kill+0x5e>
      p->killed = 1;
    8000177a:	4785                	li	a5,1
    8000177c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000177e:	4c98                	lw	a4,24(s1)
    80001780:	4789                	li	a5,2
    80001782:	00f70f63          	beq	a4,a5,800017a0 <kill+0x6c>
      release(&p->lock);
    80001786:	8526                	mv	a0,s1
    80001788:	00005097          	auipc	ra,0x5
    8000178c:	bf8080e7          	jalr	-1032(ra) # 80006380 <release>
      return 0;
    80001790:	4501                	li	a0,0
}
    80001792:	70a2                	ld	ra,40(sp)
    80001794:	7402                	ld	s0,32(sp)
    80001796:	64e2                	ld	s1,24(sp)
    80001798:	6942                	ld	s2,16(sp)
    8000179a:	69a2                	ld	s3,8(sp)
    8000179c:	6145                	addi	sp,sp,48
    8000179e:	8082                	ret
        p->state = RUNNABLE;
    800017a0:	478d                	li	a5,3
    800017a2:	cc9c                	sw	a5,24(s1)
    800017a4:	b7cd                	j	80001786 <kill+0x52>

00000000800017a6 <setkilled>:

void
setkilled(struct proc *p)
{
    800017a6:	1101                	addi	sp,sp,-32
    800017a8:	ec06                	sd	ra,24(sp)
    800017aa:	e822                	sd	s0,16(sp)
    800017ac:	e426                	sd	s1,8(sp)
    800017ae:	1000                	addi	s0,sp,32
    800017b0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017b2:	00005097          	auipc	ra,0x5
    800017b6:	b1a080e7          	jalr	-1254(ra) # 800062cc <acquire>
  p->killed = 1;
    800017ba:	4785                	li	a5,1
    800017bc:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017be:	8526                	mv	a0,s1
    800017c0:	00005097          	auipc	ra,0x5
    800017c4:	bc0080e7          	jalr	-1088(ra) # 80006380 <release>
}
    800017c8:	60e2                	ld	ra,24(sp)
    800017ca:	6442                	ld	s0,16(sp)
    800017cc:	64a2                	ld	s1,8(sp)
    800017ce:	6105                	addi	sp,sp,32
    800017d0:	8082                	ret

00000000800017d2 <killed>:

int
killed(struct proc *p)
{
    800017d2:	1101                	addi	sp,sp,-32
    800017d4:	ec06                	sd	ra,24(sp)
    800017d6:	e822                	sd	s0,16(sp)
    800017d8:	e426                	sd	s1,8(sp)
    800017da:	e04a                	sd	s2,0(sp)
    800017dc:	1000                	addi	s0,sp,32
    800017de:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	aec080e7          	jalr	-1300(ra) # 800062cc <acquire>
  k = p->killed;
    800017e8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017ec:	8526                	mv	a0,s1
    800017ee:	00005097          	auipc	ra,0x5
    800017f2:	b92080e7          	jalr	-1134(ra) # 80006380 <release>
  return k;
}
    800017f6:	854a                	mv	a0,s2
    800017f8:	60e2                	ld	ra,24(sp)
    800017fa:	6442                	ld	s0,16(sp)
    800017fc:	64a2                	ld	s1,8(sp)
    800017fe:	6902                	ld	s2,0(sp)
    80001800:	6105                	addi	sp,sp,32
    80001802:	8082                	ret

0000000080001804 <wait>:
{
    80001804:	715d                	addi	sp,sp,-80
    80001806:	e486                	sd	ra,72(sp)
    80001808:	e0a2                	sd	s0,64(sp)
    8000180a:	fc26                	sd	s1,56(sp)
    8000180c:	f84a                	sd	s2,48(sp)
    8000180e:	f44e                	sd	s3,40(sp)
    80001810:	f052                	sd	s4,32(sp)
    80001812:	ec56                	sd	s5,24(sp)
    80001814:	e85a                	sd	s6,16(sp)
    80001816:	e45e                	sd	s7,8(sp)
    80001818:	e062                	sd	s8,0(sp)
    8000181a:	0880                	addi	s0,sp,80
    8000181c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000181e:	fffff097          	auipc	ra,0xfffff
    80001822:	660080e7          	jalr	1632(ra) # 80000e7e <myproc>
    80001826:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001828:	00007517          	auipc	a0,0x7
    8000182c:	2a050513          	addi	a0,a0,672 # 80008ac8 <wait_lock>
    80001830:	00005097          	auipc	ra,0x5
    80001834:	a9c080e7          	jalr	-1380(ra) # 800062cc <acquire>
    havekids = 0;
    80001838:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000183a:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000183c:	0000d997          	auipc	s3,0xd
    80001840:	2a498993          	addi	s3,s3,676 # 8000eae0 <tickslock>
        havekids = 1;
    80001844:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001846:	00007c17          	auipc	s8,0x7
    8000184a:	282c0c13          	addi	s8,s8,642 # 80008ac8 <wait_lock>
    havekids = 0;
    8000184e:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001850:	00007497          	auipc	s1,0x7
    80001854:	69048493          	addi	s1,s1,1680 # 80008ee0 <proc>
    80001858:	a0bd                	j	800018c6 <wait+0xc2>
          pid = pp->pid;
    8000185a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000185e:	000b0e63          	beqz	s6,8000187a <wait+0x76>
    80001862:	4691                	li	a3,4
    80001864:	02c48613          	addi	a2,s1,44
    80001868:	85da                	mv	a1,s6
    8000186a:	05093503          	ld	a0,80(s2)
    8000186e:	fffff097          	auipc	ra,0xfffff
    80001872:	2ce080e7          	jalr	718(ra) # 80000b3c <copyout>
    80001876:	02054563          	bltz	a0,800018a0 <wait+0x9c>
          freeproc(pp);
    8000187a:	8526                	mv	a0,s1
    8000187c:	fffff097          	auipc	ra,0xfffff
    80001880:	7b4080e7          	jalr	1972(ra) # 80001030 <freeproc>
          release(&pp->lock);
    80001884:	8526                	mv	a0,s1
    80001886:	00005097          	auipc	ra,0x5
    8000188a:	afa080e7          	jalr	-1286(ra) # 80006380 <release>
          release(&wait_lock);
    8000188e:	00007517          	auipc	a0,0x7
    80001892:	23a50513          	addi	a0,a0,570 # 80008ac8 <wait_lock>
    80001896:	00005097          	auipc	ra,0x5
    8000189a:	aea080e7          	jalr	-1302(ra) # 80006380 <release>
          return pid;
    8000189e:	a0b5                	j	8000190a <wait+0x106>
            release(&pp->lock);
    800018a0:	8526                	mv	a0,s1
    800018a2:	00005097          	auipc	ra,0x5
    800018a6:	ade080e7          	jalr	-1314(ra) # 80006380 <release>
            release(&wait_lock);
    800018aa:	00007517          	auipc	a0,0x7
    800018ae:	21e50513          	addi	a0,a0,542 # 80008ac8 <wait_lock>
    800018b2:	00005097          	auipc	ra,0x5
    800018b6:	ace080e7          	jalr	-1330(ra) # 80006380 <release>
            return -1;
    800018ba:	59fd                	li	s3,-1
    800018bc:	a0b9                	j	8000190a <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018be:	17048493          	addi	s1,s1,368
    800018c2:	03348463          	beq	s1,s3,800018ea <wait+0xe6>
      if(pp->parent == p){
    800018c6:	7c9c                	ld	a5,56(s1)
    800018c8:	ff279be3          	bne	a5,s2,800018be <wait+0xba>
        acquire(&pp->lock);
    800018cc:	8526                	mv	a0,s1
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	9fe080e7          	jalr	-1538(ra) # 800062cc <acquire>
        if(pp->state == ZOMBIE){
    800018d6:	4c9c                	lw	a5,24(s1)
    800018d8:	f94781e3          	beq	a5,s4,8000185a <wait+0x56>
        release(&pp->lock);
    800018dc:	8526                	mv	a0,s1
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	aa2080e7          	jalr	-1374(ra) # 80006380 <release>
        havekids = 1;
    800018e6:	8756                	mv	a4,s5
    800018e8:	bfd9                	j	800018be <wait+0xba>
    if(!havekids || killed(p)){
    800018ea:	c719                	beqz	a4,800018f8 <wait+0xf4>
    800018ec:	854a                	mv	a0,s2
    800018ee:	00000097          	auipc	ra,0x0
    800018f2:	ee4080e7          	jalr	-284(ra) # 800017d2 <killed>
    800018f6:	c51d                	beqz	a0,80001924 <wait+0x120>
      release(&wait_lock);
    800018f8:	00007517          	auipc	a0,0x7
    800018fc:	1d050513          	addi	a0,a0,464 # 80008ac8 <wait_lock>
    80001900:	00005097          	auipc	ra,0x5
    80001904:	a80080e7          	jalr	-1408(ra) # 80006380 <release>
      return -1;
    80001908:	59fd                	li	s3,-1
}
    8000190a:	854e                	mv	a0,s3
    8000190c:	60a6                	ld	ra,72(sp)
    8000190e:	6406                	ld	s0,64(sp)
    80001910:	74e2                	ld	s1,56(sp)
    80001912:	7942                	ld	s2,48(sp)
    80001914:	79a2                	ld	s3,40(sp)
    80001916:	7a02                	ld	s4,32(sp)
    80001918:	6ae2                	ld	s5,24(sp)
    8000191a:	6b42                	ld	s6,16(sp)
    8000191c:	6ba2                	ld	s7,8(sp)
    8000191e:	6c02                	ld	s8,0(sp)
    80001920:	6161                	addi	sp,sp,80
    80001922:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001924:	85e2                	mv	a1,s8
    80001926:	854a                	mv	a0,s2
    80001928:	00000097          	auipc	ra,0x0
    8000192c:	c02080e7          	jalr	-1022(ra) # 8000152a <sleep>
    havekids = 0;
    80001930:	bf39                	j	8000184e <wait+0x4a>

0000000080001932 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001932:	7179                	addi	sp,sp,-48
    80001934:	f406                	sd	ra,40(sp)
    80001936:	f022                	sd	s0,32(sp)
    80001938:	ec26                	sd	s1,24(sp)
    8000193a:	e84a                	sd	s2,16(sp)
    8000193c:	e44e                	sd	s3,8(sp)
    8000193e:	e052                	sd	s4,0(sp)
    80001940:	1800                	addi	s0,sp,48
    80001942:	84aa                	mv	s1,a0
    80001944:	892e                	mv	s2,a1
    80001946:	89b2                	mv	s3,a2
    80001948:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000194a:	fffff097          	auipc	ra,0xfffff
    8000194e:	534080e7          	jalr	1332(ra) # 80000e7e <myproc>
  if(user_dst){
    80001952:	c08d                	beqz	s1,80001974 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001954:	86d2                	mv	a3,s4
    80001956:	864e                	mv	a2,s3
    80001958:	85ca                	mv	a1,s2
    8000195a:	6928                	ld	a0,80(a0)
    8000195c:	fffff097          	auipc	ra,0xfffff
    80001960:	1e0080e7          	jalr	480(ra) # 80000b3c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001964:	70a2                	ld	ra,40(sp)
    80001966:	7402                	ld	s0,32(sp)
    80001968:	64e2                	ld	s1,24(sp)
    8000196a:	6942                	ld	s2,16(sp)
    8000196c:	69a2                	ld	s3,8(sp)
    8000196e:	6a02                	ld	s4,0(sp)
    80001970:	6145                	addi	sp,sp,48
    80001972:	8082                	ret
    memmove((char *)dst, src, len);
    80001974:	000a061b          	sext.w	a2,s4
    80001978:	85ce                	mv	a1,s3
    8000197a:	854a                	mv	a0,s2
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	882080e7          	jalr	-1918(ra) # 800001fe <memmove>
    return 0;
    80001984:	8526                	mv	a0,s1
    80001986:	bff9                	j	80001964 <either_copyout+0x32>

0000000080001988 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001988:	7179                	addi	sp,sp,-48
    8000198a:	f406                	sd	ra,40(sp)
    8000198c:	f022                	sd	s0,32(sp)
    8000198e:	ec26                	sd	s1,24(sp)
    80001990:	e84a                	sd	s2,16(sp)
    80001992:	e44e                	sd	s3,8(sp)
    80001994:	e052                	sd	s4,0(sp)
    80001996:	1800                	addi	s0,sp,48
    80001998:	892a                	mv	s2,a0
    8000199a:	84ae                	mv	s1,a1
    8000199c:	89b2                	mv	s3,a2
    8000199e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019a0:	fffff097          	auipc	ra,0xfffff
    800019a4:	4de080e7          	jalr	1246(ra) # 80000e7e <myproc>
  if(user_src){
    800019a8:	c08d                	beqz	s1,800019ca <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019aa:	86d2                	mv	a3,s4
    800019ac:	864e                	mv	a2,s3
    800019ae:	85ca                	mv	a1,s2
    800019b0:	6928                	ld	a0,80(a0)
    800019b2:	fffff097          	auipc	ra,0xfffff
    800019b6:	216080e7          	jalr	534(ra) # 80000bc8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019ba:	70a2                	ld	ra,40(sp)
    800019bc:	7402                	ld	s0,32(sp)
    800019be:	64e2                	ld	s1,24(sp)
    800019c0:	6942                	ld	s2,16(sp)
    800019c2:	69a2                	ld	s3,8(sp)
    800019c4:	6a02                	ld	s4,0(sp)
    800019c6:	6145                	addi	sp,sp,48
    800019c8:	8082                	ret
    memmove(dst, (char*)src, len);
    800019ca:	000a061b          	sext.w	a2,s4
    800019ce:	85ce                	mv	a1,s3
    800019d0:	854a                	mv	a0,s2
    800019d2:	fffff097          	auipc	ra,0xfffff
    800019d6:	82c080e7          	jalr	-2004(ra) # 800001fe <memmove>
    return 0;
    800019da:	8526                	mv	a0,s1
    800019dc:	bff9                	j	800019ba <either_copyin+0x32>

00000000800019de <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019de:	715d                	addi	sp,sp,-80
    800019e0:	e486                	sd	ra,72(sp)
    800019e2:	e0a2                	sd	s0,64(sp)
    800019e4:	fc26                	sd	s1,56(sp)
    800019e6:	f84a                	sd	s2,48(sp)
    800019e8:	f44e                	sd	s3,40(sp)
    800019ea:	f052                	sd	s4,32(sp)
    800019ec:	ec56                	sd	s5,24(sp)
    800019ee:	e85a                	sd	s6,16(sp)
    800019f0:	e45e                	sd	s7,8(sp)
    800019f2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019f4:	00006517          	auipc	a0,0x6
    800019f8:	65450513          	addi	a0,a0,1620 # 80008048 <etext+0x48>
    800019fc:	00004097          	auipc	ra,0x4
    80001a00:	3d0080e7          	jalr	976(ra) # 80005dcc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a04:	00007497          	auipc	s1,0x7
    80001a08:	63448493          	addi	s1,s1,1588 # 80009038 <proc+0x158>
    80001a0c:	0000d917          	auipc	s2,0xd
    80001a10:	22c90913          	addi	s2,s2,556 # 8000ec38 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a14:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a16:	00006997          	auipc	s3,0x6
    80001a1a:	7ea98993          	addi	s3,s3,2026 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a1e:	00006a97          	auipc	s5,0x6
    80001a22:	7eaa8a93          	addi	s5,s5,2026 # 80008208 <etext+0x208>
    printf("\n");
    80001a26:	00006a17          	auipc	s4,0x6
    80001a2a:	622a0a13          	addi	s4,s4,1570 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2e:	00007b97          	auipc	s7,0x7
    80001a32:	81ab8b93          	addi	s7,s7,-2022 # 80008248 <states.1727>
    80001a36:	a00d                	j	80001a58 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a38:	ed86a583          	lw	a1,-296(a3)
    80001a3c:	8556                	mv	a0,s5
    80001a3e:	00004097          	auipc	ra,0x4
    80001a42:	38e080e7          	jalr	910(ra) # 80005dcc <printf>
    printf("\n");
    80001a46:	8552                	mv	a0,s4
    80001a48:	00004097          	auipc	ra,0x4
    80001a4c:	384080e7          	jalr	900(ra) # 80005dcc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a50:	17048493          	addi	s1,s1,368
    80001a54:	03248163          	beq	s1,s2,80001a76 <procdump+0x98>
    if(p->state == UNUSED)
    80001a58:	86a6                	mv	a3,s1
    80001a5a:	ec04a783          	lw	a5,-320(s1)
    80001a5e:	dbed                	beqz	a5,80001a50 <procdump+0x72>
      state = "???";
    80001a60:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a62:	fcfb6be3          	bltu	s6,a5,80001a38 <procdump+0x5a>
    80001a66:	1782                	slli	a5,a5,0x20
    80001a68:	9381                	srli	a5,a5,0x20
    80001a6a:	078e                	slli	a5,a5,0x3
    80001a6c:	97de                	add	a5,a5,s7
    80001a6e:	6390                	ld	a2,0(a5)
    80001a70:	f661                	bnez	a2,80001a38 <procdump+0x5a>
      state = "???";
    80001a72:	864e                	mv	a2,s3
    80001a74:	b7d1                	j	80001a38 <procdump+0x5a>
  }
}
    80001a76:	60a6                	ld	ra,72(sp)
    80001a78:	6406                	ld	s0,64(sp)
    80001a7a:	74e2                	ld	s1,56(sp)
    80001a7c:	7942                	ld	s2,48(sp)
    80001a7e:	79a2                	ld	s3,40(sp)
    80001a80:	7a02                	ld	s4,32(sp)
    80001a82:	6ae2                	ld	s5,24(sp)
    80001a84:	6b42                	ld	s6,16(sp)
    80001a86:	6ba2                	ld	s7,8(sp)
    80001a88:	6161                	addi	sp,sp,80
    80001a8a:	8082                	ret

0000000080001a8c <proc_num>:
//修改代码添加proc_num()计算UNUSED进程数
uint64
proc_num(void)
{
    80001a8c:	7179                	addi	sp,sp,-48
    80001a8e:	f406                	sd	ra,40(sp)
    80001a90:	f022                	sd	s0,32(sp)
    80001a92:	ec26                	sd	s1,24(sp)
    80001a94:	e84a                	sd	s2,16(sp)
    80001a96:	e44e                	sd	s3,8(sp)
    80001a98:	1800                	addi	s0,sp,48
  uint64 n=0;
  struct proc *p;
  for(p=proc;p<&proc[NPROC];p++)
    80001a9a:	00007497          	auipc	s1,0x7
    80001a9e:	44648493          	addi	s1,s1,1094 # 80008ee0 <proc>
  uint64 n=0;
    80001aa2:	4901                	li	s2,0
  for(p=proc;p<&proc[NPROC];p++)
    80001aa4:	0000d997          	auipc	s3,0xd
    80001aa8:	03c98993          	addi	s3,s3,60 # 8000eae0 <tickslock>
  {
    acquire(&p->lock);
    80001aac:	8526                	mv	a0,s1
    80001aae:	00005097          	auipc	ra,0x5
    80001ab2:	81e080e7          	jalr	-2018(ra) # 800062cc <acquire>
    if(p->state!=UNUSED) n++;
    80001ab6:	4c9c                	lw	a5,24(s1)
    80001ab8:	00f037b3          	snez	a5,a5
    80001abc:	993e                	add	s2,s2,a5
    release(&p->lock);
    80001abe:	8526                	mv	a0,s1
    80001ac0:	00005097          	auipc	ra,0x5
    80001ac4:	8c0080e7          	jalr	-1856(ra) # 80006380 <release>
  for(p=proc;p<&proc[NPROC];p++)
    80001ac8:	17048493          	addi	s1,s1,368
    80001acc:	ff3490e3          	bne	s1,s3,80001aac <proc_num+0x20>
  }
  return n;
}
    80001ad0:	854a                	mv	a0,s2
    80001ad2:	70a2                	ld	ra,40(sp)
    80001ad4:	7402                	ld	s0,32(sp)
    80001ad6:	64e2                	ld	s1,24(sp)
    80001ad8:	6942                	ld	s2,16(sp)
    80001ada:	69a2                	ld	s3,8(sp)
    80001adc:	6145                	addi	sp,sp,48
    80001ade:	8082                	ret

0000000080001ae0 <swtch>:
    80001ae0:	00153023          	sd	ra,0(a0)
    80001ae4:	00253423          	sd	sp,8(a0)
    80001ae8:	e900                	sd	s0,16(a0)
    80001aea:	ed04                	sd	s1,24(a0)
    80001aec:	03253023          	sd	s2,32(a0)
    80001af0:	03353423          	sd	s3,40(a0)
    80001af4:	03453823          	sd	s4,48(a0)
    80001af8:	03553c23          	sd	s5,56(a0)
    80001afc:	05653023          	sd	s6,64(a0)
    80001b00:	05753423          	sd	s7,72(a0)
    80001b04:	05853823          	sd	s8,80(a0)
    80001b08:	05953c23          	sd	s9,88(a0)
    80001b0c:	07a53023          	sd	s10,96(a0)
    80001b10:	07b53423          	sd	s11,104(a0)
    80001b14:	0005b083          	ld	ra,0(a1)
    80001b18:	0085b103          	ld	sp,8(a1)
    80001b1c:	6980                	ld	s0,16(a1)
    80001b1e:	6d84                	ld	s1,24(a1)
    80001b20:	0205b903          	ld	s2,32(a1)
    80001b24:	0285b983          	ld	s3,40(a1)
    80001b28:	0305ba03          	ld	s4,48(a1)
    80001b2c:	0385ba83          	ld	s5,56(a1)
    80001b30:	0405bb03          	ld	s6,64(a1)
    80001b34:	0485bb83          	ld	s7,72(a1)
    80001b38:	0505bc03          	ld	s8,80(a1)
    80001b3c:	0585bc83          	ld	s9,88(a1)
    80001b40:	0605bd03          	ld	s10,96(a1)
    80001b44:	0685bd83          	ld	s11,104(a1)
    80001b48:	8082                	ret

0000000080001b4a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b4a:	1141                	addi	sp,sp,-16
    80001b4c:	e406                	sd	ra,8(sp)
    80001b4e:	e022                	sd	s0,0(sp)
    80001b50:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b52:	00006597          	auipc	a1,0x6
    80001b56:	72658593          	addi	a1,a1,1830 # 80008278 <states.1727+0x30>
    80001b5a:	0000d517          	auipc	a0,0xd
    80001b5e:	f8650513          	addi	a0,a0,-122 # 8000eae0 <tickslock>
    80001b62:	00004097          	auipc	ra,0x4
    80001b66:	6da080e7          	jalr	1754(ra) # 8000623c <initlock>
}
    80001b6a:	60a2                	ld	ra,8(sp)
    80001b6c:	6402                	ld	s0,0(sp)
    80001b6e:	0141                	addi	sp,sp,16
    80001b70:	8082                	ret

0000000080001b72 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b72:	1141                	addi	sp,sp,-16
    80001b74:	e422                	sd	s0,8(sp)
    80001b76:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b78:	00003797          	auipc	a5,0x3
    80001b7c:	5d878793          	addi	a5,a5,1496 # 80005150 <kernelvec>
    80001b80:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b84:	6422                	ld	s0,8(sp)
    80001b86:	0141                	addi	sp,sp,16
    80001b88:	8082                	ret

0000000080001b8a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b8a:	1141                	addi	sp,sp,-16
    80001b8c:	e406                	sd	ra,8(sp)
    80001b8e:	e022                	sd	s0,0(sp)
    80001b90:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b92:	fffff097          	auipc	ra,0xfffff
    80001b96:	2ec080e7          	jalr	748(ra) # 80000e7e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b9a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b9e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ba4:	00005617          	auipc	a2,0x5
    80001ba8:	45c60613          	addi	a2,a2,1116 # 80007000 <_trampoline>
    80001bac:	00005697          	auipc	a3,0x5
    80001bb0:	45468693          	addi	a3,a3,1108 # 80007000 <_trampoline>
    80001bb4:	8e91                	sub	a3,a3,a2
    80001bb6:	040007b7          	lui	a5,0x4000
    80001bba:	17fd                	addi	a5,a5,-1
    80001bbc:	07b2                	slli	a5,a5,0xc
    80001bbe:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bc0:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bc4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bc6:	180026f3          	csrr	a3,satp
    80001bca:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bcc:	6d38                	ld	a4,88(a0)
    80001bce:	6134                	ld	a3,64(a0)
    80001bd0:	6585                	lui	a1,0x1
    80001bd2:	96ae                	add	a3,a3,a1
    80001bd4:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bd6:	6d38                	ld	a4,88(a0)
    80001bd8:	00000697          	auipc	a3,0x0
    80001bdc:	13068693          	addi	a3,a3,304 # 80001d08 <usertrap>
    80001be0:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001be2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001be4:	8692                	mv	a3,tp
    80001be6:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001be8:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bec:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bf0:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bf4:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bf8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bfa:	6f18                	ld	a4,24(a4)
    80001bfc:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001c00:	6928                	ld	a0,80(a0)
    80001c02:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001c04:	00005717          	auipc	a4,0x5
    80001c08:	49870713          	addi	a4,a4,1176 # 8000709c <userret>
    80001c0c:	8f11                	sub	a4,a4,a2
    80001c0e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c10:	577d                	li	a4,-1
    80001c12:	177e                	slli	a4,a4,0x3f
    80001c14:	8d59                	or	a0,a0,a4
    80001c16:	9782                	jalr	a5
}
    80001c18:	60a2                	ld	ra,8(sp)
    80001c1a:	6402                	ld	s0,0(sp)
    80001c1c:	0141                	addi	sp,sp,16
    80001c1e:	8082                	ret

0000000080001c20 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c20:	1101                	addi	sp,sp,-32
    80001c22:	ec06                	sd	ra,24(sp)
    80001c24:	e822                	sd	s0,16(sp)
    80001c26:	e426                	sd	s1,8(sp)
    80001c28:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c2a:	0000d497          	auipc	s1,0xd
    80001c2e:	eb648493          	addi	s1,s1,-330 # 8000eae0 <tickslock>
    80001c32:	8526                	mv	a0,s1
    80001c34:	00004097          	auipc	ra,0x4
    80001c38:	698080e7          	jalr	1688(ra) # 800062cc <acquire>
  ticks++;
    80001c3c:	00007517          	auipc	a0,0x7
    80001c40:	e3c50513          	addi	a0,a0,-452 # 80008a78 <ticks>
    80001c44:	411c                	lw	a5,0(a0)
    80001c46:	2785                	addiw	a5,a5,1
    80001c48:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c4a:	00000097          	auipc	ra,0x0
    80001c4e:	944080e7          	jalr	-1724(ra) # 8000158e <wakeup>
  release(&tickslock);
    80001c52:	8526                	mv	a0,s1
    80001c54:	00004097          	auipc	ra,0x4
    80001c58:	72c080e7          	jalr	1836(ra) # 80006380 <release>
}
    80001c5c:	60e2                	ld	ra,24(sp)
    80001c5e:	6442                	ld	s0,16(sp)
    80001c60:	64a2                	ld	s1,8(sp)
    80001c62:	6105                	addi	sp,sp,32
    80001c64:	8082                	ret

0000000080001c66 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c66:	1101                	addi	sp,sp,-32
    80001c68:	ec06                	sd	ra,24(sp)
    80001c6a:	e822                	sd	s0,16(sp)
    80001c6c:	e426                	sd	s1,8(sp)
    80001c6e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c70:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c74:	00074d63          	bltz	a4,80001c8e <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c78:	57fd                	li	a5,-1
    80001c7a:	17fe                	slli	a5,a5,0x3f
    80001c7c:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c7e:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c80:	06f70363          	beq	a4,a5,80001ce6 <devintr+0x80>
  }
}
    80001c84:	60e2                	ld	ra,24(sp)
    80001c86:	6442                	ld	s0,16(sp)
    80001c88:	64a2                	ld	s1,8(sp)
    80001c8a:	6105                	addi	sp,sp,32
    80001c8c:	8082                	ret
     (scause & 0xff) == 9){
    80001c8e:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c92:	46a5                	li	a3,9
    80001c94:	fed792e3          	bne	a5,a3,80001c78 <devintr+0x12>
    int irq = plic_claim();
    80001c98:	00003097          	auipc	ra,0x3
    80001c9c:	5c0080e7          	jalr	1472(ra) # 80005258 <plic_claim>
    80001ca0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ca2:	47a9                	li	a5,10
    80001ca4:	02f50763          	beq	a0,a5,80001cd2 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001ca8:	4785                	li	a5,1
    80001caa:	02f50963          	beq	a0,a5,80001cdc <devintr+0x76>
    return 1;
    80001cae:	4505                	li	a0,1
    } else if(irq){
    80001cb0:	d8f1                	beqz	s1,80001c84 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001cb2:	85a6                	mv	a1,s1
    80001cb4:	00006517          	auipc	a0,0x6
    80001cb8:	5cc50513          	addi	a0,a0,1484 # 80008280 <states.1727+0x38>
    80001cbc:	00004097          	auipc	ra,0x4
    80001cc0:	110080e7          	jalr	272(ra) # 80005dcc <printf>
      plic_complete(irq);
    80001cc4:	8526                	mv	a0,s1
    80001cc6:	00003097          	auipc	ra,0x3
    80001cca:	5b6080e7          	jalr	1462(ra) # 8000527c <plic_complete>
    return 1;
    80001cce:	4505                	li	a0,1
    80001cd0:	bf55                	j	80001c84 <devintr+0x1e>
      uartintr();
    80001cd2:	00004097          	auipc	ra,0x4
    80001cd6:	51a080e7          	jalr	1306(ra) # 800061ec <uartintr>
    80001cda:	b7ed                	j	80001cc4 <devintr+0x5e>
      virtio_disk_intr();
    80001cdc:	00004097          	auipc	ra,0x4
    80001ce0:	aca080e7          	jalr	-1334(ra) # 800057a6 <virtio_disk_intr>
    80001ce4:	b7c5                	j	80001cc4 <devintr+0x5e>
    if(cpuid() == 0){
    80001ce6:	fffff097          	auipc	ra,0xfffff
    80001cea:	16c080e7          	jalr	364(ra) # 80000e52 <cpuid>
    80001cee:	c901                	beqz	a0,80001cfe <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cf0:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001cf4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cf6:	14479073          	csrw	sip,a5
    return 2;
    80001cfa:	4509                	li	a0,2
    80001cfc:	b761                	j	80001c84 <devintr+0x1e>
      clockintr();
    80001cfe:	00000097          	auipc	ra,0x0
    80001d02:	f22080e7          	jalr	-222(ra) # 80001c20 <clockintr>
    80001d06:	b7ed                	j	80001cf0 <devintr+0x8a>

0000000080001d08 <usertrap>:
{
    80001d08:	1101                	addi	sp,sp,-32
    80001d0a:	ec06                	sd	ra,24(sp)
    80001d0c:	e822                	sd	s0,16(sp)
    80001d0e:	e426                	sd	s1,8(sp)
    80001d10:	e04a                	sd	s2,0(sp)
    80001d12:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d14:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d18:	1007f793          	andi	a5,a5,256
    80001d1c:	e3b1                	bnez	a5,80001d60 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d1e:	00003797          	auipc	a5,0x3
    80001d22:	43278793          	addi	a5,a5,1074 # 80005150 <kernelvec>
    80001d26:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d2a:	fffff097          	auipc	ra,0xfffff
    80001d2e:	154080e7          	jalr	340(ra) # 80000e7e <myproc>
    80001d32:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d34:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d36:	14102773          	csrr	a4,sepc
    80001d3a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d3c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d40:	47a1                	li	a5,8
    80001d42:	02f70763          	beq	a4,a5,80001d70 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	f20080e7          	jalr	-224(ra) # 80001c66 <devintr>
    80001d4e:	892a                	mv	s2,a0
    80001d50:	c151                	beqz	a0,80001dd4 <usertrap+0xcc>
  if(killed(p))
    80001d52:	8526                	mv	a0,s1
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	a7e080e7          	jalr	-1410(ra) # 800017d2 <killed>
    80001d5c:	c929                	beqz	a0,80001dae <usertrap+0xa6>
    80001d5e:	a099                	j	80001da4 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d60:	00006517          	auipc	a0,0x6
    80001d64:	54050513          	addi	a0,a0,1344 # 800082a0 <states.1727+0x58>
    80001d68:	00004097          	auipc	ra,0x4
    80001d6c:	01a080e7          	jalr	26(ra) # 80005d82 <panic>
    if(killed(p))
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	a62080e7          	jalr	-1438(ra) # 800017d2 <killed>
    80001d78:	e921                	bnez	a0,80001dc8 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d7a:	6cb8                	ld	a4,88(s1)
    80001d7c:	6f1c                	ld	a5,24(a4)
    80001d7e:	0791                	addi	a5,a5,4
    80001d80:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d82:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d86:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d8a:	10079073          	csrw	sstatus,a5
    syscall();
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	2d4080e7          	jalr	724(ra) # 80002062 <syscall>
  if(killed(p))
    80001d96:	8526                	mv	a0,s1
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	a3a080e7          	jalr	-1478(ra) # 800017d2 <killed>
    80001da0:	c911                	beqz	a0,80001db4 <usertrap+0xac>
    80001da2:	4901                	li	s2,0
    exit(-1);
    80001da4:	557d                	li	a0,-1
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	8b8080e7          	jalr	-1864(ra) # 8000165e <exit>
  if(which_dev == 2)
    80001dae:	4789                	li	a5,2
    80001db0:	04f90f63          	beq	s2,a5,80001e0e <usertrap+0x106>
  usertrapret();
    80001db4:	00000097          	auipc	ra,0x0
    80001db8:	dd6080e7          	jalr	-554(ra) # 80001b8a <usertrapret>
}
    80001dbc:	60e2                	ld	ra,24(sp)
    80001dbe:	6442                	ld	s0,16(sp)
    80001dc0:	64a2                	ld	s1,8(sp)
    80001dc2:	6902                	ld	s2,0(sp)
    80001dc4:	6105                	addi	sp,sp,32
    80001dc6:	8082                	ret
      exit(-1);
    80001dc8:	557d                	li	a0,-1
    80001dca:	00000097          	auipc	ra,0x0
    80001dce:	894080e7          	jalr	-1900(ra) # 8000165e <exit>
    80001dd2:	b765                	j	80001d7a <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dd4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dd8:	5890                	lw	a2,48(s1)
    80001dda:	00006517          	auipc	a0,0x6
    80001dde:	4e650513          	addi	a0,a0,1254 # 800082c0 <states.1727+0x78>
    80001de2:	00004097          	auipc	ra,0x4
    80001de6:	fea080e7          	jalr	-22(ra) # 80005dcc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dea:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dee:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001df2:	00006517          	auipc	a0,0x6
    80001df6:	4fe50513          	addi	a0,a0,1278 # 800082f0 <states.1727+0xa8>
    80001dfa:	00004097          	auipc	ra,0x4
    80001dfe:	fd2080e7          	jalr	-46(ra) # 80005dcc <printf>
    setkilled(p);
    80001e02:	8526                	mv	a0,s1
    80001e04:	00000097          	auipc	ra,0x0
    80001e08:	9a2080e7          	jalr	-1630(ra) # 800017a6 <setkilled>
    80001e0c:	b769                	j	80001d96 <usertrap+0x8e>
    yield();
    80001e0e:	fffff097          	auipc	ra,0xfffff
    80001e12:	6e0080e7          	jalr	1760(ra) # 800014ee <yield>
    80001e16:	bf79                	j	80001db4 <usertrap+0xac>

0000000080001e18 <kerneltrap>:
{
    80001e18:	7179                	addi	sp,sp,-48
    80001e1a:	f406                	sd	ra,40(sp)
    80001e1c:	f022                	sd	s0,32(sp)
    80001e1e:	ec26                	sd	s1,24(sp)
    80001e20:	e84a                	sd	s2,16(sp)
    80001e22:	e44e                	sd	s3,8(sp)
    80001e24:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e26:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e2a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e2e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e32:	1004f793          	andi	a5,s1,256
    80001e36:	cb85                	beqz	a5,80001e66 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e38:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e3c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e3e:	ef85                	bnez	a5,80001e76 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e40:	00000097          	auipc	ra,0x0
    80001e44:	e26080e7          	jalr	-474(ra) # 80001c66 <devintr>
    80001e48:	cd1d                	beqz	a0,80001e86 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e4a:	4789                	li	a5,2
    80001e4c:	06f50a63          	beq	a0,a5,80001ec0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e50:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e54:	10049073          	csrw	sstatus,s1
}
    80001e58:	70a2                	ld	ra,40(sp)
    80001e5a:	7402                	ld	s0,32(sp)
    80001e5c:	64e2                	ld	s1,24(sp)
    80001e5e:	6942                	ld	s2,16(sp)
    80001e60:	69a2                	ld	s3,8(sp)
    80001e62:	6145                	addi	sp,sp,48
    80001e64:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e66:	00006517          	auipc	a0,0x6
    80001e6a:	4aa50513          	addi	a0,a0,1194 # 80008310 <states.1727+0xc8>
    80001e6e:	00004097          	auipc	ra,0x4
    80001e72:	f14080e7          	jalr	-236(ra) # 80005d82 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e76:	00006517          	auipc	a0,0x6
    80001e7a:	4c250513          	addi	a0,a0,1218 # 80008338 <states.1727+0xf0>
    80001e7e:	00004097          	auipc	ra,0x4
    80001e82:	f04080e7          	jalr	-252(ra) # 80005d82 <panic>
    printf("scause %p\n", scause);
    80001e86:	85ce                	mv	a1,s3
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	4d050513          	addi	a0,a0,1232 # 80008358 <states.1727+0x110>
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	f3c080e7          	jalr	-196(ra) # 80005dcc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e98:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e9c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ea0:	00006517          	auipc	a0,0x6
    80001ea4:	4c850513          	addi	a0,a0,1224 # 80008368 <states.1727+0x120>
    80001ea8:	00004097          	auipc	ra,0x4
    80001eac:	f24080e7          	jalr	-220(ra) # 80005dcc <printf>
    panic("kerneltrap");
    80001eb0:	00006517          	auipc	a0,0x6
    80001eb4:	4d050513          	addi	a0,a0,1232 # 80008380 <states.1727+0x138>
    80001eb8:	00004097          	auipc	ra,0x4
    80001ebc:	eca080e7          	jalr	-310(ra) # 80005d82 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ec0:	fffff097          	auipc	ra,0xfffff
    80001ec4:	fbe080e7          	jalr	-66(ra) # 80000e7e <myproc>
    80001ec8:	d541                	beqz	a0,80001e50 <kerneltrap+0x38>
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	fb4080e7          	jalr	-76(ra) # 80000e7e <myproc>
    80001ed2:	4d18                	lw	a4,24(a0)
    80001ed4:	4791                	li	a5,4
    80001ed6:	f6f71de3          	bne	a4,a5,80001e50 <kerneltrap+0x38>
    yield();
    80001eda:	fffff097          	auipc	ra,0xfffff
    80001ede:	614080e7          	jalr	1556(ra) # 800014ee <yield>
    80001ee2:	b7bd                	j	80001e50 <kerneltrap+0x38>

0000000080001ee4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ee4:	1101                	addi	sp,sp,-32
    80001ee6:	ec06                	sd	ra,24(sp)
    80001ee8:	e822                	sd	s0,16(sp)
    80001eea:	e426                	sd	s1,8(sp)
    80001eec:	1000                	addi	s0,sp,32
    80001eee:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ef0:	fffff097          	auipc	ra,0xfffff
    80001ef4:	f8e080e7          	jalr	-114(ra) # 80000e7e <myproc>
  switch (n) {
    80001ef8:	4795                	li	a5,5
    80001efa:	0497e163          	bltu	a5,s1,80001f3c <argraw+0x58>
    80001efe:	048a                	slli	s1,s1,0x2
    80001f00:	00006717          	auipc	a4,0x6
    80001f04:	59870713          	addi	a4,a4,1432 # 80008498 <states.1727+0x250>
    80001f08:	94ba                	add	s1,s1,a4
    80001f0a:	409c                	lw	a5,0(s1)
    80001f0c:	97ba                	add	a5,a5,a4
    80001f0e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f10:	6d3c                	ld	a5,88(a0)
    80001f12:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f14:	60e2                	ld	ra,24(sp)
    80001f16:	6442                	ld	s0,16(sp)
    80001f18:	64a2                	ld	s1,8(sp)
    80001f1a:	6105                	addi	sp,sp,32
    80001f1c:	8082                	ret
    return p->trapframe->a1;
    80001f1e:	6d3c                	ld	a5,88(a0)
    80001f20:	7fa8                	ld	a0,120(a5)
    80001f22:	bfcd                	j	80001f14 <argraw+0x30>
    return p->trapframe->a2;
    80001f24:	6d3c                	ld	a5,88(a0)
    80001f26:	63c8                	ld	a0,128(a5)
    80001f28:	b7f5                	j	80001f14 <argraw+0x30>
    return p->trapframe->a3;
    80001f2a:	6d3c                	ld	a5,88(a0)
    80001f2c:	67c8                	ld	a0,136(a5)
    80001f2e:	b7dd                	j	80001f14 <argraw+0x30>
    return p->trapframe->a4;
    80001f30:	6d3c                	ld	a5,88(a0)
    80001f32:	6bc8                	ld	a0,144(a5)
    80001f34:	b7c5                	j	80001f14 <argraw+0x30>
    return p->trapframe->a5;
    80001f36:	6d3c                	ld	a5,88(a0)
    80001f38:	6fc8                	ld	a0,152(a5)
    80001f3a:	bfe9                	j	80001f14 <argraw+0x30>
  panic("argraw");
    80001f3c:	00006517          	auipc	a0,0x6
    80001f40:	45450513          	addi	a0,a0,1108 # 80008390 <states.1727+0x148>
    80001f44:	00004097          	auipc	ra,0x4
    80001f48:	e3e080e7          	jalr	-450(ra) # 80005d82 <panic>

0000000080001f4c <fetchaddr>:
{
    80001f4c:	1101                	addi	sp,sp,-32
    80001f4e:	ec06                	sd	ra,24(sp)
    80001f50:	e822                	sd	s0,16(sp)
    80001f52:	e426                	sd	s1,8(sp)
    80001f54:	e04a                	sd	s2,0(sp)
    80001f56:	1000                	addi	s0,sp,32
    80001f58:	84aa                	mv	s1,a0
    80001f5a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	f22080e7          	jalr	-222(ra) # 80000e7e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f64:	653c                	ld	a5,72(a0)
    80001f66:	02f4f863          	bgeu	s1,a5,80001f96 <fetchaddr+0x4a>
    80001f6a:	00848713          	addi	a4,s1,8
    80001f6e:	02e7e663          	bltu	a5,a4,80001f9a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f72:	46a1                	li	a3,8
    80001f74:	8626                	mv	a2,s1
    80001f76:	85ca                	mv	a1,s2
    80001f78:	6928                	ld	a0,80(a0)
    80001f7a:	fffff097          	auipc	ra,0xfffff
    80001f7e:	c4e080e7          	jalr	-946(ra) # 80000bc8 <copyin>
    80001f82:	00a03533          	snez	a0,a0
    80001f86:	40a00533          	neg	a0,a0
}
    80001f8a:	60e2                	ld	ra,24(sp)
    80001f8c:	6442                	ld	s0,16(sp)
    80001f8e:	64a2                	ld	s1,8(sp)
    80001f90:	6902                	ld	s2,0(sp)
    80001f92:	6105                	addi	sp,sp,32
    80001f94:	8082                	ret
    return -1;
    80001f96:	557d                	li	a0,-1
    80001f98:	bfcd                	j	80001f8a <fetchaddr+0x3e>
    80001f9a:	557d                	li	a0,-1
    80001f9c:	b7fd                	j	80001f8a <fetchaddr+0x3e>

0000000080001f9e <fetchstr>:
{
    80001f9e:	7179                	addi	sp,sp,-48
    80001fa0:	f406                	sd	ra,40(sp)
    80001fa2:	f022                	sd	s0,32(sp)
    80001fa4:	ec26                	sd	s1,24(sp)
    80001fa6:	e84a                	sd	s2,16(sp)
    80001fa8:	e44e                	sd	s3,8(sp)
    80001faa:	1800                	addi	s0,sp,48
    80001fac:	892a                	mv	s2,a0
    80001fae:	84ae                	mv	s1,a1
    80001fb0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fb2:	fffff097          	auipc	ra,0xfffff
    80001fb6:	ecc080e7          	jalr	-308(ra) # 80000e7e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fba:	86ce                	mv	a3,s3
    80001fbc:	864a                	mv	a2,s2
    80001fbe:	85a6                	mv	a1,s1
    80001fc0:	6928                	ld	a0,80(a0)
    80001fc2:	fffff097          	auipc	ra,0xfffff
    80001fc6:	c92080e7          	jalr	-878(ra) # 80000c54 <copyinstr>
    80001fca:	00054e63          	bltz	a0,80001fe6 <fetchstr+0x48>
  return strlen(buf);
    80001fce:	8526                	mv	a0,s1
    80001fd0:	ffffe097          	auipc	ra,0xffffe
    80001fd4:	352080e7          	jalr	850(ra) # 80000322 <strlen>
}
    80001fd8:	70a2                	ld	ra,40(sp)
    80001fda:	7402                	ld	s0,32(sp)
    80001fdc:	64e2                	ld	s1,24(sp)
    80001fde:	6942                	ld	s2,16(sp)
    80001fe0:	69a2                	ld	s3,8(sp)
    80001fe2:	6145                	addi	sp,sp,48
    80001fe4:	8082                	ret
    return -1;
    80001fe6:	557d                	li	a0,-1
    80001fe8:	bfc5                	j	80001fd8 <fetchstr+0x3a>

0000000080001fea <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fea:	1101                	addi	sp,sp,-32
    80001fec:	ec06                	sd	ra,24(sp)
    80001fee:	e822                	sd	s0,16(sp)
    80001ff0:	e426                	sd	s1,8(sp)
    80001ff2:	1000                	addi	s0,sp,32
    80001ff4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001ff6:	00000097          	auipc	ra,0x0
    80001ffa:	eee080e7          	jalr	-274(ra) # 80001ee4 <argraw>
    80001ffe:	c088                	sw	a0,0(s1)
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6105                	addi	sp,sp,32
    80002008:	8082                	ret

000000008000200a <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    8000200a:	1101                	addi	sp,sp,-32
    8000200c:	ec06                	sd	ra,24(sp)
    8000200e:	e822                	sd	s0,16(sp)
    80002010:	e426                	sd	s1,8(sp)
    80002012:	1000                	addi	s0,sp,32
    80002014:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002016:	00000097          	auipc	ra,0x0
    8000201a:	ece080e7          	jalr	-306(ra) # 80001ee4 <argraw>
    8000201e:	e088                	sd	a0,0(s1)
}
    80002020:	60e2                	ld	ra,24(sp)
    80002022:	6442                	ld	s0,16(sp)
    80002024:	64a2                	ld	s1,8(sp)
    80002026:	6105                	addi	sp,sp,32
    80002028:	8082                	ret

000000008000202a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000202a:	7179                	addi	sp,sp,-48
    8000202c:	f406                	sd	ra,40(sp)
    8000202e:	f022                	sd	s0,32(sp)
    80002030:	ec26                	sd	s1,24(sp)
    80002032:	e84a                	sd	s2,16(sp)
    80002034:	1800                	addi	s0,sp,48
    80002036:	84ae                	mv	s1,a1
    80002038:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000203a:	fd840593          	addi	a1,s0,-40
    8000203e:	00000097          	auipc	ra,0x0
    80002042:	fcc080e7          	jalr	-52(ra) # 8000200a <argaddr>
  return fetchstr(addr, buf, max);
    80002046:	864a                	mv	a2,s2
    80002048:	85a6                	mv	a1,s1
    8000204a:	fd843503          	ld	a0,-40(s0)
    8000204e:	00000097          	auipc	ra,0x0
    80002052:	f50080e7          	jalr	-176(ra) # 80001f9e <fetchstr>
}
    80002056:	70a2                	ld	ra,40(sp)
    80002058:	7402                	ld	s0,32(sp)
    8000205a:	64e2                	ld	s1,24(sp)
    8000205c:	6942                	ld	s2,16(sp)
    8000205e:	6145                	addi	sp,sp,48
    80002060:	8082                	ret

0000000080002062 <syscall>:
[SYS_freemem] "sys_freemem",
[SYS_trace]   "trace",
};
void
syscall(void)
{
    80002062:	7179                	addi	sp,sp,-48
    80002064:	f406                	sd	ra,40(sp)
    80002066:	f022                	sd	s0,32(sp)
    80002068:	ec26                	sd	s1,24(sp)
    8000206a:	e84a                	sd	s2,16(sp)
    8000206c:	e44e                	sd	s3,8(sp)
    8000206e:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();//p为当前进程
    80002070:	fffff097          	auipc	ra,0xfffff
    80002074:	e0e080e7          	jalr	-498(ra) # 80000e7e <myproc>
    80002078:	84aa                	mv	s1,a0

  num = p->trapframe->a7;//num决定调用那个系统调用
    8000207a:	05853903          	ld	s2,88(a0)
    8000207e:	0a893783          	ld	a5,168(s2)
    80002082:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002086:	37fd                	addiw	a5,a5,-1
    80002088:	475d                	li	a4,23
    8000208a:	04f76863          	bltu	a4,a5,800020da <syscall+0x78>
    8000208e:	00399713          	slli	a4,s3,0x3
    80002092:	00006797          	auipc	a5,0x6
    80002096:	41e78793          	addi	a5,a5,1054 # 800084b0 <syscalls>
    8000209a:	97ba                	add	a5,a5,a4
    8000209c:	639c                	ld	a5,0(a5)
    8000209e:	cf95                	beqz	a5,800020da <syscall+0x78>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800020a0:	9782                	jalr	a5
    800020a2:	06a93823          	sd	a0,112(s2)
    if((1<<num)&p->mask)
    800020a6:	1684a783          	lw	a5,360(s1)
    800020aa:	4137d7bb          	sraw	a5,a5,s3
    800020ae:	8b85                	andi	a5,a5,1
    800020b0:	c7a1                	beqz	a5,800020f8 <syscall+0x96>
    {
      printf("%d: syscall %s -> %d\n",p->pid,syscalls_name[num],p->trapframe->a0);
    800020b2:	6cb8                	ld	a4,88(s1)
    800020b4:	098e                	slli	s3,s3,0x3
    800020b6:	00007797          	auipc	a5,0x7
    800020ba:	8c278793          	addi	a5,a5,-1854 # 80008978 <syscalls_name>
    800020be:	99be                	add	s3,s3,a5
    800020c0:	7b34                	ld	a3,112(a4)
    800020c2:	0009b603          	ld	a2,0(s3)
    800020c6:	588c                	lw	a1,48(s1)
    800020c8:	00006517          	auipc	a0,0x6
    800020cc:	2d050513          	addi	a0,a0,720 # 80008398 <states.1727+0x150>
    800020d0:	00004097          	auipc	ra,0x4
    800020d4:	cfc080e7          	jalr	-772(ra) # 80005dcc <printf>
    800020d8:	a005                	j	800020f8 <syscall+0x96>
    }
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020da:	86ce                	mv	a3,s3
    800020dc:	15848613          	addi	a2,s1,344
    800020e0:	588c                	lw	a1,48(s1)
    800020e2:	00006517          	auipc	a0,0x6
    800020e6:	2ce50513          	addi	a0,a0,718 # 800083b0 <states.1727+0x168>
    800020ea:	00004097          	auipc	ra,0x4
    800020ee:	ce2080e7          	jalr	-798(ra) # 80005dcc <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020f2:	6cbc                	ld	a5,88(s1)
    800020f4:	577d                	li	a4,-1
    800020f6:	fbb8                	sd	a4,112(a5)
  }
}
    800020f8:	70a2                	ld	ra,40(sp)
    800020fa:	7402                	ld	s0,32(sp)
    800020fc:	64e2                	ld	s1,24(sp)
    800020fe:	6942                	ld	s2,16(sp)
    80002100:	69a2                	ld	s3,8(sp)
    80002102:	6145                	addi	sp,sp,48
    80002104:	8082                	ret

0000000080002106 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002106:	1101                	addi	sp,sp,-32
    80002108:	ec06                	sd	ra,24(sp)
    8000210a:	e822                	sd	s0,16(sp)
    8000210c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000210e:	fec40593          	addi	a1,s0,-20
    80002112:	4501                	li	a0,0
    80002114:	00000097          	auipc	ra,0x0
    80002118:	ed6080e7          	jalr	-298(ra) # 80001fea <argint>
  exit(n);
    8000211c:	fec42503          	lw	a0,-20(s0)
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	53e080e7          	jalr	1342(ra) # 8000165e <exit>
  return 0;  // not reached
}
    80002128:	4501                	li	a0,0
    8000212a:	60e2                	ld	ra,24(sp)
    8000212c:	6442                	ld	s0,16(sp)
    8000212e:	6105                	addi	sp,sp,32
    80002130:	8082                	ret

0000000080002132 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002132:	1141                	addi	sp,sp,-16
    80002134:	e406                	sd	ra,8(sp)
    80002136:	e022                	sd	s0,0(sp)
    80002138:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	d44080e7          	jalr	-700(ra) # 80000e7e <myproc>
}
    80002142:	5908                	lw	a0,48(a0)
    80002144:	60a2                	ld	ra,8(sp)
    80002146:	6402                	ld	s0,0(sp)
    80002148:	0141                	addi	sp,sp,16
    8000214a:	8082                	ret

000000008000214c <sys_fork>:

uint64
sys_fork(void)
{
    8000214c:	1141                	addi	sp,sp,-16
    8000214e:	e406                	sd	ra,8(sp)
    80002150:	e022                	sd	s0,0(sp)
    80002152:	0800                	addi	s0,sp,16
  return fork();
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	0e0080e7          	jalr	224(ra) # 80001234 <fork>
}
    8000215c:	60a2                	ld	ra,8(sp)
    8000215e:	6402                	ld	s0,0(sp)
    80002160:	0141                	addi	sp,sp,16
    80002162:	8082                	ret

0000000080002164 <sys_wait>:

uint64
sys_wait(void)
{
    80002164:	1101                	addi	sp,sp,-32
    80002166:	ec06                	sd	ra,24(sp)
    80002168:	e822                	sd	s0,16(sp)
    8000216a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000216c:	fe840593          	addi	a1,s0,-24
    80002170:	4501                	li	a0,0
    80002172:	00000097          	auipc	ra,0x0
    80002176:	e98080e7          	jalr	-360(ra) # 8000200a <argaddr>
  return wait(p);
    8000217a:	fe843503          	ld	a0,-24(s0)
    8000217e:	fffff097          	auipc	ra,0xfffff
    80002182:	686080e7          	jalr	1670(ra) # 80001804 <wait>
}
    80002186:	60e2                	ld	ra,24(sp)
    80002188:	6442                	ld	s0,16(sp)
    8000218a:	6105                	addi	sp,sp,32
    8000218c:	8082                	ret

000000008000218e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000218e:	7179                	addi	sp,sp,-48
    80002190:	f406                	sd	ra,40(sp)
    80002192:	f022                	sd	s0,32(sp)
    80002194:	ec26                	sd	s1,24(sp)
    80002196:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002198:	fdc40593          	addi	a1,s0,-36
    8000219c:	4501                	li	a0,0
    8000219e:	00000097          	auipc	ra,0x0
    800021a2:	e4c080e7          	jalr	-436(ra) # 80001fea <argint>
  addr = myproc()->sz;
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	cd8080e7          	jalr	-808(ra) # 80000e7e <myproc>
    800021ae:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021b0:	fdc42503          	lw	a0,-36(s0)
    800021b4:	fffff097          	auipc	ra,0xfffff
    800021b8:	024080e7          	jalr	36(ra) # 800011d8 <growproc>
    800021bc:	00054863          	bltz	a0,800021cc <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021c0:	8526                	mv	a0,s1
    800021c2:	70a2                	ld	ra,40(sp)
    800021c4:	7402                	ld	s0,32(sp)
    800021c6:	64e2                	ld	s1,24(sp)
    800021c8:	6145                	addi	sp,sp,48
    800021ca:	8082                	ret
    return -1;
    800021cc:	54fd                	li	s1,-1
    800021ce:	bfcd                	j	800021c0 <sys_sbrk+0x32>

00000000800021d0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021d0:	7139                	addi	sp,sp,-64
    800021d2:	fc06                	sd	ra,56(sp)
    800021d4:	f822                	sd	s0,48(sp)
    800021d6:	f426                	sd	s1,40(sp)
    800021d8:	f04a                	sd	s2,32(sp)
    800021da:	ec4e                	sd	s3,24(sp)
    800021dc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021de:	fcc40593          	addi	a1,s0,-52
    800021e2:	4501                	li	a0,0
    800021e4:	00000097          	auipc	ra,0x0
    800021e8:	e06080e7          	jalr	-506(ra) # 80001fea <argint>
  if(n < 0)
    800021ec:	fcc42783          	lw	a5,-52(s0)
    800021f0:	0607cf63          	bltz	a5,8000226e <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021f4:	0000d517          	auipc	a0,0xd
    800021f8:	8ec50513          	addi	a0,a0,-1812 # 8000eae0 <tickslock>
    800021fc:	00004097          	auipc	ra,0x4
    80002200:	0d0080e7          	jalr	208(ra) # 800062cc <acquire>
  ticks0 = ticks;
    80002204:	00007917          	auipc	s2,0x7
    80002208:	87492903          	lw	s2,-1932(s2) # 80008a78 <ticks>
  while(ticks - ticks0 < n){
    8000220c:	fcc42783          	lw	a5,-52(s0)
    80002210:	cf9d                	beqz	a5,8000224e <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002212:	0000d997          	auipc	s3,0xd
    80002216:	8ce98993          	addi	s3,s3,-1842 # 8000eae0 <tickslock>
    8000221a:	00007497          	auipc	s1,0x7
    8000221e:	85e48493          	addi	s1,s1,-1954 # 80008a78 <ticks>
    if(killed(myproc())){
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	c5c080e7          	jalr	-932(ra) # 80000e7e <myproc>
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	5a8080e7          	jalr	1448(ra) # 800017d2 <killed>
    80002232:	e129                	bnez	a0,80002274 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002234:	85ce                	mv	a1,s3
    80002236:	8526                	mv	a0,s1
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	2f2080e7          	jalr	754(ra) # 8000152a <sleep>
  while(ticks - ticks0 < n){
    80002240:	409c                	lw	a5,0(s1)
    80002242:	412787bb          	subw	a5,a5,s2
    80002246:	fcc42703          	lw	a4,-52(s0)
    8000224a:	fce7ece3          	bltu	a5,a4,80002222 <sys_sleep+0x52>
  }
  release(&tickslock);
    8000224e:	0000d517          	auipc	a0,0xd
    80002252:	89250513          	addi	a0,a0,-1902 # 8000eae0 <tickslock>
    80002256:	00004097          	auipc	ra,0x4
    8000225a:	12a080e7          	jalr	298(ra) # 80006380 <release>
  return 0;
    8000225e:	4501                	li	a0,0
}
    80002260:	70e2                	ld	ra,56(sp)
    80002262:	7442                	ld	s0,48(sp)
    80002264:	74a2                	ld	s1,40(sp)
    80002266:	7902                	ld	s2,32(sp)
    80002268:	69e2                	ld	s3,24(sp)
    8000226a:	6121                	addi	sp,sp,64
    8000226c:	8082                	ret
    n = 0;
    8000226e:	fc042623          	sw	zero,-52(s0)
    80002272:	b749                	j	800021f4 <sys_sleep+0x24>
      release(&tickslock);
    80002274:	0000d517          	auipc	a0,0xd
    80002278:	86c50513          	addi	a0,a0,-1940 # 8000eae0 <tickslock>
    8000227c:	00004097          	auipc	ra,0x4
    80002280:	104080e7          	jalr	260(ra) # 80006380 <release>
      return -1;
    80002284:	557d                	li	a0,-1
    80002286:	bfe9                	j	80002260 <sys_sleep+0x90>

0000000080002288 <sys_kill>:

uint64
sys_kill(void)
{
    80002288:	1101                	addi	sp,sp,-32
    8000228a:	ec06                	sd	ra,24(sp)
    8000228c:	e822                	sd	s0,16(sp)
    8000228e:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002290:	fec40593          	addi	a1,s0,-20
    80002294:	4501                	li	a0,0
    80002296:	00000097          	auipc	ra,0x0
    8000229a:	d54080e7          	jalr	-684(ra) # 80001fea <argint>
  return kill(pid);
    8000229e:	fec42503          	lw	a0,-20(s0)
    800022a2:	fffff097          	auipc	ra,0xfffff
    800022a6:	492080e7          	jalr	1170(ra) # 80001734 <kill>
}
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	6105                	addi	sp,sp,32
    800022b0:	8082                	ret

00000000800022b2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022b2:	1101                	addi	sp,sp,-32
    800022b4:	ec06                	sd	ra,24(sp)
    800022b6:	e822                	sd	s0,16(sp)
    800022b8:	e426                	sd	s1,8(sp)
    800022ba:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022bc:	0000d517          	auipc	a0,0xd
    800022c0:	82450513          	addi	a0,a0,-2012 # 8000eae0 <tickslock>
    800022c4:	00004097          	auipc	ra,0x4
    800022c8:	008080e7          	jalr	8(ra) # 800062cc <acquire>
  xticks = ticks;
    800022cc:	00006497          	auipc	s1,0x6
    800022d0:	7ac4a483          	lw	s1,1964(s1) # 80008a78 <ticks>
  release(&tickslock);
    800022d4:	0000d517          	auipc	a0,0xd
    800022d8:	80c50513          	addi	a0,a0,-2036 # 8000eae0 <tickslock>
    800022dc:	00004097          	auipc	ra,0x4
    800022e0:	0a4080e7          	jalr	164(ra) # 80006380 <release>
  return xticks;
}
    800022e4:	02049513          	slli	a0,s1,0x20
    800022e8:	9101                	srli	a0,a0,0x20
    800022ea:	60e2                	ld	ra,24(sp)
    800022ec:	6442                	ld	s0,16(sp)
    800022ee:	64a2                	ld	s1,8(sp)
    800022f0:	6105                	addi	sp,sp,32
    800022f2:	8082                	ret

00000000800022f4 <sys_procnum>:
//new
uint64
sys_procnum(void)
{
    800022f4:	7179                	addi	sp,sp,-48
    800022f6:	f406                	sd	ra,40(sp)
    800022f8:	f022                	sd	s0,32(sp)
    800022fa:	ec26                	sd	s1,24(sp)
    800022fc:	1800                	addi	s0,sp,48
  // int num=proc_num();
  // if(num>0) return num;
  // else
  //   return -1;
  uint64 addr;
  struct proc *p=myproc();
    800022fe:	fffff097          	auipc	ra,0xfffff
    80002302:	b80080e7          	jalr	-1152(ra) # 80000e7e <myproc>
    80002306:	84aa                	mv	s1,a0
  argaddr(0,&addr);
    80002308:	fd840593          	addi	a1,s0,-40
    8000230c:	4501                	li	a0,0
    8000230e:	00000097          	auipc	ra,0x0
    80002312:	cfc080e7          	jalr	-772(ra) # 8000200a <argaddr>
  int num;
  num=proc_num();
    80002316:	fffff097          	auipc	ra,0xfffff
    8000231a:	776080e7          	jalr	1910(ra) # 80001a8c <proc_num>
    8000231e:	fca42a23          	sw	a0,-44(s0)
  if(copyout(p->pagetable,addr,(char *)&num,sizeof(num))<0)
    80002322:	4691                	li	a3,4
    80002324:	fd440613          	addi	a2,s0,-44
    80002328:	fd843583          	ld	a1,-40(s0)
    8000232c:	68a8                	ld	a0,80(s1)
    8000232e:	fffff097          	auipc	ra,0xfffff
    80002332:	80e080e7          	jalr	-2034(ra) # 80000b3c <copyout>
    80002336:	00054963          	bltz	a0,80002348 <sys_procnum+0x54>
    return -1;
  return num;
    8000233a:	fd442503          	lw	a0,-44(s0)
}
    8000233e:	70a2                	ld	ra,40(sp)
    80002340:	7402                	ld	s0,32(sp)
    80002342:	64e2                	ld	s1,24(sp)
    80002344:	6145                	addi	sp,sp,48
    80002346:	8082                	ret
    return -1;
    80002348:	557d                	li	a0,-1
    8000234a:	bfd5                	j	8000233e <sys_procnum+0x4a>

000000008000234c <sys_freemem>:
//new
uint64
sys_freemem(void)
{
    8000234c:	7179                	addi	sp,sp,-48
    8000234e:	f406                	sd	ra,40(sp)
    80002350:	f022                	sd	s0,32(sp)
    80002352:	ec26                	sd	s1,24(sp)
    80002354:	1800                	addi	s0,sp,48
  uint64 addr;
  struct proc *p=myproc();
    80002356:	fffff097          	auipc	ra,0xfffff
    8000235a:	b28080e7          	jalr	-1240(ra) # 80000e7e <myproc>
    8000235e:	84aa                	mv	s1,a0
  argaddr(0,&addr);
    80002360:	fd840593          	addi	a1,s0,-40
    80002364:	4501                	li	a0,0
    80002366:	00000097          	auipc	ra,0x0
    8000236a:	ca4080e7          	jalr	-860(ra) # 8000200a <argaddr>
  int num;
  num=free_mem();
    8000236e:	ffffe097          	auipc	ra,0xffffe
    80002372:	e0a080e7          	jalr	-502(ra) # 80000178 <free_mem>
    80002376:	fca42a23          	sw	a0,-44(s0)
  if(copyout(p->pagetable,addr,(char *)&num,sizeof(num))<0)
    8000237a:	4691                	li	a3,4
    8000237c:	fd440613          	addi	a2,s0,-44
    80002380:	fd843583          	ld	a1,-40(s0)
    80002384:	68a8                	ld	a0,80(s1)
    80002386:	ffffe097          	auipc	ra,0xffffe
    8000238a:	7b6080e7          	jalr	1974(ra) # 80000b3c <copyout>
    8000238e:	00054963          	bltz	a0,800023a0 <sys_freemem+0x54>
    return -1;
  return num;
    80002392:	fd442503          	lw	a0,-44(s0)
  // int num=free_mem();
  // if(num>0) return num;
  // return -1;
}
    80002396:	70a2                	ld	ra,40(sp)
    80002398:	7402                	ld	s0,32(sp)
    8000239a:	64e2                	ld	s1,24(sp)
    8000239c:	6145                	addi	sp,sp,48
    8000239e:	8082                	ret
    return -1;
    800023a0:	557d                	li	a0,-1
    800023a2:	bfd5                	j	80002396 <sys_freemem+0x4a>

00000000800023a4 <sys_trace>:
//trace
uint64
sys_trace(void)
{
    800023a4:	1101                	addi	sp,sp,-32
    800023a6:	ec06                	sd	ra,24(sp)
    800023a8:	e822                	sd	s0,16(sp)
    800023aa:	1000                	addi	s0,sp,32
  int mask;
  argint(0,&mask);
    800023ac:	fec40593          	addi	a1,s0,-20
    800023b0:	4501                	li	a0,0
    800023b2:	00000097          	auipc	ra,0x0
    800023b6:	c38080e7          	jalr	-968(ra) # 80001fea <argint>
  myproc()->mask=mask;
    800023ba:	fffff097          	auipc	ra,0xfffff
    800023be:	ac4080e7          	jalr	-1340(ra) # 80000e7e <myproc>
    800023c2:	fec42783          	lw	a5,-20(s0)
    800023c6:	16f52423          	sw	a5,360(a0)
  return 0;
}
    800023ca:	4501                	li	a0,0
    800023cc:	60e2                	ld	ra,24(sp)
    800023ce:	6442                	ld	s0,16(sp)
    800023d0:	6105                	addi	sp,sp,32
    800023d2:	8082                	ret

00000000800023d4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023d4:	7179                	addi	sp,sp,-48
    800023d6:	f406                	sd	ra,40(sp)
    800023d8:	f022                	sd	s0,32(sp)
    800023da:	ec26                	sd	s1,24(sp)
    800023dc:	e84a                	sd	s2,16(sp)
    800023de:	e44e                	sd	s3,8(sp)
    800023e0:	e052                	sd	s4,0(sp)
    800023e2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023e4:	00006597          	auipc	a1,0x6
    800023e8:	19458593          	addi	a1,a1,404 # 80008578 <syscalls+0xc8>
    800023ec:	0000c517          	auipc	a0,0xc
    800023f0:	70c50513          	addi	a0,a0,1804 # 8000eaf8 <bcache>
    800023f4:	00004097          	auipc	ra,0x4
    800023f8:	e48080e7          	jalr	-440(ra) # 8000623c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023fc:	00014797          	auipc	a5,0x14
    80002400:	6fc78793          	addi	a5,a5,1788 # 80016af8 <bcache+0x8000>
    80002404:	00015717          	auipc	a4,0x15
    80002408:	95c70713          	addi	a4,a4,-1700 # 80016d60 <bcache+0x8268>
    8000240c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002410:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002414:	0000c497          	auipc	s1,0xc
    80002418:	6fc48493          	addi	s1,s1,1788 # 8000eb10 <bcache+0x18>
    b->next = bcache.head.next;
    8000241c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000241e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002420:	00006a17          	auipc	s4,0x6
    80002424:	160a0a13          	addi	s4,s4,352 # 80008580 <syscalls+0xd0>
    b->next = bcache.head.next;
    80002428:	2b893783          	ld	a5,696(s2)
    8000242c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000242e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002432:	85d2                	mv	a1,s4
    80002434:	01048513          	addi	a0,s1,16
    80002438:	00001097          	auipc	ra,0x1
    8000243c:	4c4080e7          	jalr	1220(ra) # 800038fc <initsleeplock>
    bcache.head.next->prev = b;
    80002440:	2b893783          	ld	a5,696(s2)
    80002444:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002446:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000244a:	45848493          	addi	s1,s1,1112
    8000244e:	fd349de3          	bne	s1,s3,80002428 <binit+0x54>
  }
}
    80002452:	70a2                	ld	ra,40(sp)
    80002454:	7402                	ld	s0,32(sp)
    80002456:	64e2                	ld	s1,24(sp)
    80002458:	6942                	ld	s2,16(sp)
    8000245a:	69a2                	ld	s3,8(sp)
    8000245c:	6a02                	ld	s4,0(sp)
    8000245e:	6145                	addi	sp,sp,48
    80002460:	8082                	ret

0000000080002462 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002462:	7179                	addi	sp,sp,-48
    80002464:	f406                	sd	ra,40(sp)
    80002466:	f022                	sd	s0,32(sp)
    80002468:	ec26                	sd	s1,24(sp)
    8000246a:	e84a                	sd	s2,16(sp)
    8000246c:	e44e                	sd	s3,8(sp)
    8000246e:	1800                	addi	s0,sp,48
    80002470:	89aa                	mv	s3,a0
    80002472:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002474:	0000c517          	auipc	a0,0xc
    80002478:	68450513          	addi	a0,a0,1668 # 8000eaf8 <bcache>
    8000247c:	00004097          	auipc	ra,0x4
    80002480:	e50080e7          	jalr	-432(ra) # 800062cc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002484:	00015497          	auipc	s1,0x15
    80002488:	92c4b483          	ld	s1,-1748(s1) # 80016db0 <bcache+0x82b8>
    8000248c:	00015797          	auipc	a5,0x15
    80002490:	8d478793          	addi	a5,a5,-1836 # 80016d60 <bcache+0x8268>
    80002494:	02f48f63          	beq	s1,a5,800024d2 <bread+0x70>
    80002498:	873e                	mv	a4,a5
    8000249a:	a021                	j	800024a2 <bread+0x40>
    8000249c:	68a4                	ld	s1,80(s1)
    8000249e:	02e48a63          	beq	s1,a4,800024d2 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800024a2:	449c                	lw	a5,8(s1)
    800024a4:	ff379ce3          	bne	a5,s3,8000249c <bread+0x3a>
    800024a8:	44dc                	lw	a5,12(s1)
    800024aa:	ff2799e3          	bne	a5,s2,8000249c <bread+0x3a>
      b->refcnt++;
    800024ae:	40bc                	lw	a5,64(s1)
    800024b0:	2785                	addiw	a5,a5,1
    800024b2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b4:	0000c517          	auipc	a0,0xc
    800024b8:	64450513          	addi	a0,a0,1604 # 8000eaf8 <bcache>
    800024bc:	00004097          	auipc	ra,0x4
    800024c0:	ec4080e7          	jalr	-316(ra) # 80006380 <release>
      acquiresleep(&b->lock);
    800024c4:	01048513          	addi	a0,s1,16
    800024c8:	00001097          	auipc	ra,0x1
    800024cc:	46e080e7          	jalr	1134(ra) # 80003936 <acquiresleep>
      return b;
    800024d0:	a8b9                	j	8000252e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024d2:	00015497          	auipc	s1,0x15
    800024d6:	8d64b483          	ld	s1,-1834(s1) # 80016da8 <bcache+0x82b0>
    800024da:	00015797          	auipc	a5,0x15
    800024de:	88678793          	addi	a5,a5,-1914 # 80016d60 <bcache+0x8268>
    800024e2:	00f48863          	beq	s1,a5,800024f2 <bread+0x90>
    800024e6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024e8:	40bc                	lw	a5,64(s1)
    800024ea:	cf81                	beqz	a5,80002502 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024ec:	64a4                	ld	s1,72(s1)
    800024ee:	fee49de3          	bne	s1,a4,800024e8 <bread+0x86>
  panic("bget: no buffers");
    800024f2:	00006517          	auipc	a0,0x6
    800024f6:	09650513          	addi	a0,a0,150 # 80008588 <syscalls+0xd8>
    800024fa:	00004097          	auipc	ra,0x4
    800024fe:	888080e7          	jalr	-1912(ra) # 80005d82 <panic>
      b->dev = dev;
    80002502:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002506:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000250a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000250e:	4785                	li	a5,1
    80002510:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002512:	0000c517          	auipc	a0,0xc
    80002516:	5e650513          	addi	a0,a0,1510 # 8000eaf8 <bcache>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	e66080e7          	jalr	-410(ra) # 80006380 <release>
      acquiresleep(&b->lock);
    80002522:	01048513          	addi	a0,s1,16
    80002526:	00001097          	auipc	ra,0x1
    8000252a:	410080e7          	jalr	1040(ra) # 80003936 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000252e:	409c                	lw	a5,0(s1)
    80002530:	cb89                	beqz	a5,80002542 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002532:	8526                	mv	a0,s1
    80002534:	70a2                	ld	ra,40(sp)
    80002536:	7402                	ld	s0,32(sp)
    80002538:	64e2                	ld	s1,24(sp)
    8000253a:	6942                	ld	s2,16(sp)
    8000253c:	69a2                	ld	s3,8(sp)
    8000253e:	6145                	addi	sp,sp,48
    80002540:	8082                	ret
    virtio_disk_rw(b, 0);
    80002542:	4581                	li	a1,0
    80002544:	8526                	mv	a0,s1
    80002546:	00003097          	auipc	ra,0x3
    8000254a:	fd2080e7          	jalr	-46(ra) # 80005518 <virtio_disk_rw>
    b->valid = 1;
    8000254e:	4785                	li	a5,1
    80002550:	c09c                	sw	a5,0(s1)
  return b;
    80002552:	b7c5                	j	80002532 <bread+0xd0>

0000000080002554 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002554:	1101                	addi	sp,sp,-32
    80002556:	ec06                	sd	ra,24(sp)
    80002558:	e822                	sd	s0,16(sp)
    8000255a:	e426                	sd	s1,8(sp)
    8000255c:	1000                	addi	s0,sp,32
    8000255e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002560:	0541                	addi	a0,a0,16
    80002562:	00001097          	auipc	ra,0x1
    80002566:	46e080e7          	jalr	1134(ra) # 800039d0 <holdingsleep>
    8000256a:	cd01                	beqz	a0,80002582 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000256c:	4585                	li	a1,1
    8000256e:	8526                	mv	a0,s1
    80002570:	00003097          	auipc	ra,0x3
    80002574:	fa8080e7          	jalr	-88(ra) # 80005518 <virtio_disk_rw>
}
    80002578:	60e2                	ld	ra,24(sp)
    8000257a:	6442                	ld	s0,16(sp)
    8000257c:	64a2                	ld	s1,8(sp)
    8000257e:	6105                	addi	sp,sp,32
    80002580:	8082                	ret
    panic("bwrite");
    80002582:	00006517          	auipc	a0,0x6
    80002586:	01e50513          	addi	a0,a0,30 # 800085a0 <syscalls+0xf0>
    8000258a:	00003097          	auipc	ra,0x3
    8000258e:	7f8080e7          	jalr	2040(ra) # 80005d82 <panic>

0000000080002592 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002592:	1101                	addi	sp,sp,-32
    80002594:	ec06                	sd	ra,24(sp)
    80002596:	e822                	sd	s0,16(sp)
    80002598:	e426                	sd	s1,8(sp)
    8000259a:	e04a                	sd	s2,0(sp)
    8000259c:	1000                	addi	s0,sp,32
    8000259e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800025a0:	01050913          	addi	s2,a0,16
    800025a4:	854a                	mv	a0,s2
    800025a6:	00001097          	auipc	ra,0x1
    800025aa:	42a080e7          	jalr	1066(ra) # 800039d0 <holdingsleep>
    800025ae:	c92d                	beqz	a0,80002620 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025b0:	854a                	mv	a0,s2
    800025b2:	00001097          	auipc	ra,0x1
    800025b6:	3da080e7          	jalr	986(ra) # 8000398c <releasesleep>

  acquire(&bcache.lock);
    800025ba:	0000c517          	auipc	a0,0xc
    800025be:	53e50513          	addi	a0,a0,1342 # 8000eaf8 <bcache>
    800025c2:	00004097          	auipc	ra,0x4
    800025c6:	d0a080e7          	jalr	-758(ra) # 800062cc <acquire>
  b->refcnt--;
    800025ca:	40bc                	lw	a5,64(s1)
    800025cc:	37fd                	addiw	a5,a5,-1
    800025ce:	0007871b          	sext.w	a4,a5
    800025d2:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025d4:	eb05                	bnez	a4,80002604 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025d6:	68bc                	ld	a5,80(s1)
    800025d8:	64b8                	ld	a4,72(s1)
    800025da:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025dc:	64bc                	ld	a5,72(s1)
    800025de:	68b8                	ld	a4,80(s1)
    800025e0:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025e2:	00014797          	auipc	a5,0x14
    800025e6:	51678793          	addi	a5,a5,1302 # 80016af8 <bcache+0x8000>
    800025ea:	2b87b703          	ld	a4,696(a5)
    800025ee:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025f0:	00014717          	auipc	a4,0x14
    800025f4:	77070713          	addi	a4,a4,1904 # 80016d60 <bcache+0x8268>
    800025f8:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025fa:	2b87b703          	ld	a4,696(a5)
    800025fe:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002600:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002604:	0000c517          	auipc	a0,0xc
    80002608:	4f450513          	addi	a0,a0,1268 # 8000eaf8 <bcache>
    8000260c:	00004097          	auipc	ra,0x4
    80002610:	d74080e7          	jalr	-652(ra) # 80006380 <release>
}
    80002614:	60e2                	ld	ra,24(sp)
    80002616:	6442                	ld	s0,16(sp)
    80002618:	64a2                	ld	s1,8(sp)
    8000261a:	6902                	ld	s2,0(sp)
    8000261c:	6105                	addi	sp,sp,32
    8000261e:	8082                	ret
    panic("brelse");
    80002620:	00006517          	auipc	a0,0x6
    80002624:	f8850513          	addi	a0,a0,-120 # 800085a8 <syscalls+0xf8>
    80002628:	00003097          	auipc	ra,0x3
    8000262c:	75a080e7          	jalr	1882(ra) # 80005d82 <panic>

0000000080002630 <bpin>:

void
bpin(struct buf *b) {
    80002630:	1101                	addi	sp,sp,-32
    80002632:	ec06                	sd	ra,24(sp)
    80002634:	e822                	sd	s0,16(sp)
    80002636:	e426                	sd	s1,8(sp)
    80002638:	1000                	addi	s0,sp,32
    8000263a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000263c:	0000c517          	auipc	a0,0xc
    80002640:	4bc50513          	addi	a0,a0,1212 # 8000eaf8 <bcache>
    80002644:	00004097          	auipc	ra,0x4
    80002648:	c88080e7          	jalr	-888(ra) # 800062cc <acquire>
  b->refcnt++;
    8000264c:	40bc                	lw	a5,64(s1)
    8000264e:	2785                	addiw	a5,a5,1
    80002650:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002652:	0000c517          	auipc	a0,0xc
    80002656:	4a650513          	addi	a0,a0,1190 # 8000eaf8 <bcache>
    8000265a:	00004097          	auipc	ra,0x4
    8000265e:	d26080e7          	jalr	-730(ra) # 80006380 <release>
}
    80002662:	60e2                	ld	ra,24(sp)
    80002664:	6442                	ld	s0,16(sp)
    80002666:	64a2                	ld	s1,8(sp)
    80002668:	6105                	addi	sp,sp,32
    8000266a:	8082                	ret

000000008000266c <bunpin>:

void
bunpin(struct buf *b) {
    8000266c:	1101                	addi	sp,sp,-32
    8000266e:	ec06                	sd	ra,24(sp)
    80002670:	e822                	sd	s0,16(sp)
    80002672:	e426                	sd	s1,8(sp)
    80002674:	1000                	addi	s0,sp,32
    80002676:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002678:	0000c517          	auipc	a0,0xc
    8000267c:	48050513          	addi	a0,a0,1152 # 8000eaf8 <bcache>
    80002680:	00004097          	auipc	ra,0x4
    80002684:	c4c080e7          	jalr	-948(ra) # 800062cc <acquire>
  b->refcnt--;
    80002688:	40bc                	lw	a5,64(s1)
    8000268a:	37fd                	addiw	a5,a5,-1
    8000268c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000268e:	0000c517          	auipc	a0,0xc
    80002692:	46a50513          	addi	a0,a0,1130 # 8000eaf8 <bcache>
    80002696:	00004097          	auipc	ra,0x4
    8000269a:	cea080e7          	jalr	-790(ra) # 80006380 <release>
}
    8000269e:	60e2                	ld	ra,24(sp)
    800026a0:	6442                	ld	s0,16(sp)
    800026a2:	64a2                	ld	s1,8(sp)
    800026a4:	6105                	addi	sp,sp,32
    800026a6:	8082                	ret

00000000800026a8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800026a8:	1101                	addi	sp,sp,-32
    800026aa:	ec06                	sd	ra,24(sp)
    800026ac:	e822                	sd	s0,16(sp)
    800026ae:	e426                	sd	s1,8(sp)
    800026b0:	e04a                	sd	s2,0(sp)
    800026b2:	1000                	addi	s0,sp,32
    800026b4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800026b6:	00d5d59b          	srliw	a1,a1,0xd
    800026ba:	00015797          	auipc	a5,0x15
    800026be:	b1a7a783          	lw	a5,-1254(a5) # 800171d4 <sb+0x1c>
    800026c2:	9dbd                	addw	a1,a1,a5
    800026c4:	00000097          	auipc	ra,0x0
    800026c8:	d9e080e7          	jalr	-610(ra) # 80002462 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800026cc:	0074f713          	andi	a4,s1,7
    800026d0:	4785                	li	a5,1
    800026d2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800026d6:	14ce                	slli	s1,s1,0x33
    800026d8:	90d9                	srli	s1,s1,0x36
    800026da:	00950733          	add	a4,a0,s1
    800026de:	05874703          	lbu	a4,88(a4)
    800026e2:	00e7f6b3          	and	a3,a5,a4
    800026e6:	c69d                	beqz	a3,80002714 <bfree+0x6c>
    800026e8:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800026ea:	94aa                	add	s1,s1,a0
    800026ec:	fff7c793          	not	a5,a5
    800026f0:	8ff9                	and	a5,a5,a4
    800026f2:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800026f6:	00001097          	auipc	ra,0x1
    800026fa:	120080e7          	jalr	288(ra) # 80003816 <log_write>
  brelse(bp);
    800026fe:	854a                	mv	a0,s2
    80002700:	00000097          	auipc	ra,0x0
    80002704:	e92080e7          	jalr	-366(ra) # 80002592 <brelse>
}
    80002708:	60e2                	ld	ra,24(sp)
    8000270a:	6442                	ld	s0,16(sp)
    8000270c:	64a2                	ld	s1,8(sp)
    8000270e:	6902                	ld	s2,0(sp)
    80002710:	6105                	addi	sp,sp,32
    80002712:	8082                	ret
    panic("freeing free block");
    80002714:	00006517          	auipc	a0,0x6
    80002718:	e9c50513          	addi	a0,a0,-356 # 800085b0 <syscalls+0x100>
    8000271c:	00003097          	auipc	ra,0x3
    80002720:	666080e7          	jalr	1638(ra) # 80005d82 <panic>

0000000080002724 <balloc>:
{
    80002724:	711d                	addi	sp,sp,-96
    80002726:	ec86                	sd	ra,88(sp)
    80002728:	e8a2                	sd	s0,80(sp)
    8000272a:	e4a6                	sd	s1,72(sp)
    8000272c:	e0ca                	sd	s2,64(sp)
    8000272e:	fc4e                	sd	s3,56(sp)
    80002730:	f852                	sd	s4,48(sp)
    80002732:	f456                	sd	s5,40(sp)
    80002734:	f05a                	sd	s6,32(sp)
    80002736:	ec5e                	sd	s7,24(sp)
    80002738:	e862                	sd	s8,16(sp)
    8000273a:	e466                	sd	s9,8(sp)
    8000273c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000273e:	00015797          	auipc	a5,0x15
    80002742:	a7e7a783          	lw	a5,-1410(a5) # 800171bc <sb+0x4>
    80002746:	10078163          	beqz	a5,80002848 <balloc+0x124>
    8000274a:	8baa                	mv	s7,a0
    8000274c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000274e:	00015b17          	auipc	s6,0x15
    80002752:	a6ab0b13          	addi	s6,s6,-1430 # 800171b8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002756:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002758:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000275a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000275c:	6c89                	lui	s9,0x2
    8000275e:	a061                	j	800027e6 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002760:	974a                	add	a4,a4,s2
    80002762:	8fd5                	or	a5,a5,a3
    80002764:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002768:	854a                	mv	a0,s2
    8000276a:	00001097          	auipc	ra,0x1
    8000276e:	0ac080e7          	jalr	172(ra) # 80003816 <log_write>
        brelse(bp);
    80002772:	854a                	mv	a0,s2
    80002774:	00000097          	auipc	ra,0x0
    80002778:	e1e080e7          	jalr	-482(ra) # 80002592 <brelse>
  bp = bread(dev, bno);
    8000277c:	85a6                	mv	a1,s1
    8000277e:	855e                	mv	a0,s7
    80002780:	00000097          	auipc	ra,0x0
    80002784:	ce2080e7          	jalr	-798(ra) # 80002462 <bread>
    80002788:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000278a:	40000613          	li	a2,1024
    8000278e:	4581                	li	a1,0
    80002790:	05850513          	addi	a0,a0,88
    80002794:	ffffe097          	auipc	ra,0xffffe
    80002798:	a0a080e7          	jalr	-1526(ra) # 8000019e <memset>
  log_write(bp);
    8000279c:	854a                	mv	a0,s2
    8000279e:	00001097          	auipc	ra,0x1
    800027a2:	078080e7          	jalr	120(ra) # 80003816 <log_write>
  brelse(bp);
    800027a6:	854a                	mv	a0,s2
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	dea080e7          	jalr	-534(ra) # 80002592 <brelse>
}
    800027b0:	8526                	mv	a0,s1
    800027b2:	60e6                	ld	ra,88(sp)
    800027b4:	6446                	ld	s0,80(sp)
    800027b6:	64a6                	ld	s1,72(sp)
    800027b8:	6906                	ld	s2,64(sp)
    800027ba:	79e2                	ld	s3,56(sp)
    800027bc:	7a42                	ld	s4,48(sp)
    800027be:	7aa2                	ld	s5,40(sp)
    800027c0:	7b02                	ld	s6,32(sp)
    800027c2:	6be2                	ld	s7,24(sp)
    800027c4:	6c42                	ld	s8,16(sp)
    800027c6:	6ca2                	ld	s9,8(sp)
    800027c8:	6125                	addi	sp,sp,96
    800027ca:	8082                	ret
    brelse(bp);
    800027cc:	854a                	mv	a0,s2
    800027ce:	00000097          	auipc	ra,0x0
    800027d2:	dc4080e7          	jalr	-572(ra) # 80002592 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800027d6:	015c87bb          	addw	a5,s9,s5
    800027da:	00078a9b          	sext.w	s5,a5
    800027de:	004b2703          	lw	a4,4(s6)
    800027e2:	06eaf363          	bgeu	s5,a4,80002848 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800027e6:	41fad79b          	sraiw	a5,s5,0x1f
    800027ea:	0137d79b          	srliw	a5,a5,0x13
    800027ee:	015787bb          	addw	a5,a5,s5
    800027f2:	40d7d79b          	sraiw	a5,a5,0xd
    800027f6:	01cb2583          	lw	a1,28(s6)
    800027fa:	9dbd                	addw	a1,a1,a5
    800027fc:	855e                	mv	a0,s7
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	c64080e7          	jalr	-924(ra) # 80002462 <bread>
    80002806:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002808:	004b2503          	lw	a0,4(s6)
    8000280c:	000a849b          	sext.w	s1,s5
    80002810:	8662                	mv	a2,s8
    80002812:	faa4fde3          	bgeu	s1,a0,800027cc <balloc+0xa8>
      m = 1 << (bi % 8);
    80002816:	41f6579b          	sraiw	a5,a2,0x1f
    8000281a:	01d7d69b          	srliw	a3,a5,0x1d
    8000281e:	00c6873b          	addw	a4,a3,a2
    80002822:	00777793          	andi	a5,a4,7
    80002826:	9f95                	subw	a5,a5,a3
    80002828:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000282c:	4037571b          	sraiw	a4,a4,0x3
    80002830:	00e906b3          	add	a3,s2,a4
    80002834:	0586c683          	lbu	a3,88(a3)
    80002838:	00d7f5b3          	and	a1,a5,a3
    8000283c:	d195                	beqz	a1,80002760 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000283e:	2605                	addiw	a2,a2,1
    80002840:	2485                	addiw	s1,s1,1
    80002842:	fd4618e3          	bne	a2,s4,80002812 <balloc+0xee>
    80002846:	b759                	j	800027cc <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002848:	00006517          	auipc	a0,0x6
    8000284c:	d8050513          	addi	a0,a0,-640 # 800085c8 <syscalls+0x118>
    80002850:	00003097          	auipc	ra,0x3
    80002854:	57c080e7          	jalr	1404(ra) # 80005dcc <printf>
  return 0;
    80002858:	4481                	li	s1,0
    8000285a:	bf99                	j	800027b0 <balloc+0x8c>

000000008000285c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000285c:	7179                	addi	sp,sp,-48
    8000285e:	f406                	sd	ra,40(sp)
    80002860:	f022                	sd	s0,32(sp)
    80002862:	ec26                	sd	s1,24(sp)
    80002864:	e84a                	sd	s2,16(sp)
    80002866:	e44e                	sd	s3,8(sp)
    80002868:	e052                	sd	s4,0(sp)
    8000286a:	1800                	addi	s0,sp,48
    8000286c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000286e:	47ad                	li	a5,11
    80002870:	02b7e763          	bltu	a5,a1,8000289e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002874:	02059493          	slli	s1,a1,0x20
    80002878:	9081                	srli	s1,s1,0x20
    8000287a:	048a                	slli	s1,s1,0x2
    8000287c:	94aa                	add	s1,s1,a0
    8000287e:	0504a903          	lw	s2,80(s1)
    80002882:	06091e63          	bnez	s2,800028fe <bmap+0xa2>
      addr = balloc(ip->dev);
    80002886:	4108                	lw	a0,0(a0)
    80002888:	00000097          	auipc	ra,0x0
    8000288c:	e9c080e7          	jalr	-356(ra) # 80002724 <balloc>
    80002890:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002894:	06090563          	beqz	s2,800028fe <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002898:	0524a823          	sw	s2,80(s1)
    8000289c:	a08d                	j	800028fe <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000289e:	ff45849b          	addiw	s1,a1,-12
    800028a2:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800028a6:	0ff00793          	li	a5,255
    800028aa:	08e7e563          	bltu	a5,a4,80002934 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800028ae:	08052903          	lw	s2,128(a0)
    800028b2:	00091d63          	bnez	s2,800028cc <bmap+0x70>
      addr = balloc(ip->dev);
    800028b6:	4108                	lw	a0,0(a0)
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	e6c080e7          	jalr	-404(ra) # 80002724 <balloc>
    800028c0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800028c4:	02090d63          	beqz	s2,800028fe <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800028c8:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800028cc:	85ca                	mv	a1,s2
    800028ce:	0009a503          	lw	a0,0(s3)
    800028d2:	00000097          	auipc	ra,0x0
    800028d6:	b90080e7          	jalr	-1136(ra) # 80002462 <bread>
    800028da:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800028dc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800028e0:	02049593          	slli	a1,s1,0x20
    800028e4:	9181                	srli	a1,a1,0x20
    800028e6:	058a                	slli	a1,a1,0x2
    800028e8:	00b784b3          	add	s1,a5,a1
    800028ec:	0004a903          	lw	s2,0(s1)
    800028f0:	02090063          	beqz	s2,80002910 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800028f4:	8552                	mv	a0,s4
    800028f6:	00000097          	auipc	ra,0x0
    800028fa:	c9c080e7          	jalr	-868(ra) # 80002592 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800028fe:	854a                	mv	a0,s2
    80002900:	70a2                	ld	ra,40(sp)
    80002902:	7402                	ld	s0,32(sp)
    80002904:	64e2                	ld	s1,24(sp)
    80002906:	6942                	ld	s2,16(sp)
    80002908:	69a2                	ld	s3,8(sp)
    8000290a:	6a02                	ld	s4,0(sp)
    8000290c:	6145                	addi	sp,sp,48
    8000290e:	8082                	ret
      addr = balloc(ip->dev);
    80002910:	0009a503          	lw	a0,0(s3)
    80002914:	00000097          	auipc	ra,0x0
    80002918:	e10080e7          	jalr	-496(ra) # 80002724 <balloc>
    8000291c:	0005091b          	sext.w	s2,a0
      if(addr){
    80002920:	fc090ae3          	beqz	s2,800028f4 <bmap+0x98>
        a[bn] = addr;
    80002924:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002928:	8552                	mv	a0,s4
    8000292a:	00001097          	auipc	ra,0x1
    8000292e:	eec080e7          	jalr	-276(ra) # 80003816 <log_write>
    80002932:	b7c9                	j	800028f4 <bmap+0x98>
  panic("bmap: out of range");
    80002934:	00006517          	auipc	a0,0x6
    80002938:	cac50513          	addi	a0,a0,-852 # 800085e0 <syscalls+0x130>
    8000293c:	00003097          	auipc	ra,0x3
    80002940:	446080e7          	jalr	1094(ra) # 80005d82 <panic>

0000000080002944 <iget>:
{
    80002944:	7179                	addi	sp,sp,-48
    80002946:	f406                	sd	ra,40(sp)
    80002948:	f022                	sd	s0,32(sp)
    8000294a:	ec26                	sd	s1,24(sp)
    8000294c:	e84a                	sd	s2,16(sp)
    8000294e:	e44e                	sd	s3,8(sp)
    80002950:	e052                	sd	s4,0(sp)
    80002952:	1800                	addi	s0,sp,48
    80002954:	89aa                	mv	s3,a0
    80002956:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002958:	00015517          	auipc	a0,0x15
    8000295c:	88050513          	addi	a0,a0,-1920 # 800171d8 <itable>
    80002960:	00004097          	auipc	ra,0x4
    80002964:	96c080e7          	jalr	-1684(ra) # 800062cc <acquire>
  empty = 0;
    80002968:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000296a:	00015497          	auipc	s1,0x15
    8000296e:	88648493          	addi	s1,s1,-1914 # 800171f0 <itable+0x18>
    80002972:	00016697          	auipc	a3,0x16
    80002976:	30e68693          	addi	a3,a3,782 # 80018c80 <log>
    8000297a:	a039                	j	80002988 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000297c:	02090b63          	beqz	s2,800029b2 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002980:	08848493          	addi	s1,s1,136
    80002984:	02d48a63          	beq	s1,a3,800029b8 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002988:	449c                	lw	a5,8(s1)
    8000298a:	fef059e3          	blez	a5,8000297c <iget+0x38>
    8000298e:	4098                	lw	a4,0(s1)
    80002990:	ff3716e3          	bne	a4,s3,8000297c <iget+0x38>
    80002994:	40d8                	lw	a4,4(s1)
    80002996:	ff4713e3          	bne	a4,s4,8000297c <iget+0x38>
      ip->ref++;
    8000299a:	2785                	addiw	a5,a5,1
    8000299c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000299e:	00015517          	auipc	a0,0x15
    800029a2:	83a50513          	addi	a0,a0,-1990 # 800171d8 <itable>
    800029a6:	00004097          	auipc	ra,0x4
    800029aa:	9da080e7          	jalr	-1574(ra) # 80006380 <release>
      return ip;
    800029ae:	8926                	mv	s2,s1
    800029b0:	a03d                	j	800029de <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800029b2:	f7f9                	bnez	a5,80002980 <iget+0x3c>
    800029b4:	8926                	mv	s2,s1
    800029b6:	b7e9                	j	80002980 <iget+0x3c>
  if(empty == 0)
    800029b8:	02090c63          	beqz	s2,800029f0 <iget+0xac>
  ip->dev = dev;
    800029bc:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800029c0:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800029c4:	4785                	li	a5,1
    800029c6:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800029ca:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800029ce:	00015517          	auipc	a0,0x15
    800029d2:	80a50513          	addi	a0,a0,-2038 # 800171d8 <itable>
    800029d6:	00004097          	auipc	ra,0x4
    800029da:	9aa080e7          	jalr	-1622(ra) # 80006380 <release>
}
    800029de:	854a                	mv	a0,s2
    800029e0:	70a2                	ld	ra,40(sp)
    800029e2:	7402                	ld	s0,32(sp)
    800029e4:	64e2                	ld	s1,24(sp)
    800029e6:	6942                	ld	s2,16(sp)
    800029e8:	69a2                	ld	s3,8(sp)
    800029ea:	6a02                	ld	s4,0(sp)
    800029ec:	6145                	addi	sp,sp,48
    800029ee:	8082                	ret
    panic("iget: no inodes");
    800029f0:	00006517          	auipc	a0,0x6
    800029f4:	c0850513          	addi	a0,a0,-1016 # 800085f8 <syscalls+0x148>
    800029f8:	00003097          	auipc	ra,0x3
    800029fc:	38a080e7          	jalr	906(ra) # 80005d82 <panic>

0000000080002a00 <fsinit>:
fsinit(int dev) {
    80002a00:	7179                	addi	sp,sp,-48
    80002a02:	f406                	sd	ra,40(sp)
    80002a04:	f022                	sd	s0,32(sp)
    80002a06:	ec26                	sd	s1,24(sp)
    80002a08:	e84a                	sd	s2,16(sp)
    80002a0a:	e44e                	sd	s3,8(sp)
    80002a0c:	1800                	addi	s0,sp,48
    80002a0e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a10:	4585                	li	a1,1
    80002a12:	00000097          	auipc	ra,0x0
    80002a16:	a50080e7          	jalr	-1456(ra) # 80002462 <bread>
    80002a1a:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a1c:	00014997          	auipc	s3,0x14
    80002a20:	79c98993          	addi	s3,s3,1948 # 800171b8 <sb>
    80002a24:	02000613          	li	a2,32
    80002a28:	05850593          	addi	a1,a0,88
    80002a2c:	854e                	mv	a0,s3
    80002a2e:	ffffd097          	auipc	ra,0xffffd
    80002a32:	7d0080e7          	jalr	2000(ra) # 800001fe <memmove>
  brelse(bp);
    80002a36:	8526                	mv	a0,s1
    80002a38:	00000097          	auipc	ra,0x0
    80002a3c:	b5a080e7          	jalr	-1190(ra) # 80002592 <brelse>
  if(sb.magic != FSMAGIC)
    80002a40:	0009a703          	lw	a4,0(s3)
    80002a44:	102037b7          	lui	a5,0x10203
    80002a48:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a4c:	02f71263          	bne	a4,a5,80002a70 <fsinit+0x70>
  initlog(dev, &sb);
    80002a50:	00014597          	auipc	a1,0x14
    80002a54:	76858593          	addi	a1,a1,1896 # 800171b8 <sb>
    80002a58:	854a                	mv	a0,s2
    80002a5a:	00001097          	auipc	ra,0x1
    80002a5e:	b40080e7          	jalr	-1216(ra) # 8000359a <initlog>
}
    80002a62:	70a2                	ld	ra,40(sp)
    80002a64:	7402                	ld	s0,32(sp)
    80002a66:	64e2                	ld	s1,24(sp)
    80002a68:	6942                	ld	s2,16(sp)
    80002a6a:	69a2                	ld	s3,8(sp)
    80002a6c:	6145                	addi	sp,sp,48
    80002a6e:	8082                	ret
    panic("invalid file system");
    80002a70:	00006517          	auipc	a0,0x6
    80002a74:	b9850513          	addi	a0,a0,-1128 # 80008608 <syscalls+0x158>
    80002a78:	00003097          	auipc	ra,0x3
    80002a7c:	30a080e7          	jalr	778(ra) # 80005d82 <panic>

0000000080002a80 <iinit>:
{
    80002a80:	7179                	addi	sp,sp,-48
    80002a82:	f406                	sd	ra,40(sp)
    80002a84:	f022                	sd	s0,32(sp)
    80002a86:	ec26                	sd	s1,24(sp)
    80002a88:	e84a                	sd	s2,16(sp)
    80002a8a:	e44e                	sd	s3,8(sp)
    80002a8c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a8e:	00006597          	auipc	a1,0x6
    80002a92:	b9258593          	addi	a1,a1,-1134 # 80008620 <syscalls+0x170>
    80002a96:	00014517          	auipc	a0,0x14
    80002a9a:	74250513          	addi	a0,a0,1858 # 800171d8 <itable>
    80002a9e:	00003097          	auipc	ra,0x3
    80002aa2:	79e080e7          	jalr	1950(ra) # 8000623c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002aa6:	00014497          	auipc	s1,0x14
    80002aaa:	75a48493          	addi	s1,s1,1882 # 80017200 <itable+0x28>
    80002aae:	00016997          	auipc	s3,0x16
    80002ab2:	1e298993          	addi	s3,s3,482 # 80018c90 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ab6:	00006917          	auipc	s2,0x6
    80002aba:	b7290913          	addi	s2,s2,-1166 # 80008628 <syscalls+0x178>
    80002abe:	85ca                	mv	a1,s2
    80002ac0:	8526                	mv	a0,s1
    80002ac2:	00001097          	auipc	ra,0x1
    80002ac6:	e3a080e7          	jalr	-454(ra) # 800038fc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002aca:	08848493          	addi	s1,s1,136
    80002ace:	ff3498e3          	bne	s1,s3,80002abe <iinit+0x3e>
}
    80002ad2:	70a2                	ld	ra,40(sp)
    80002ad4:	7402                	ld	s0,32(sp)
    80002ad6:	64e2                	ld	s1,24(sp)
    80002ad8:	6942                	ld	s2,16(sp)
    80002ada:	69a2                	ld	s3,8(sp)
    80002adc:	6145                	addi	sp,sp,48
    80002ade:	8082                	ret

0000000080002ae0 <ialloc>:
{
    80002ae0:	715d                	addi	sp,sp,-80
    80002ae2:	e486                	sd	ra,72(sp)
    80002ae4:	e0a2                	sd	s0,64(sp)
    80002ae6:	fc26                	sd	s1,56(sp)
    80002ae8:	f84a                	sd	s2,48(sp)
    80002aea:	f44e                	sd	s3,40(sp)
    80002aec:	f052                	sd	s4,32(sp)
    80002aee:	ec56                	sd	s5,24(sp)
    80002af0:	e85a                	sd	s6,16(sp)
    80002af2:	e45e                	sd	s7,8(sp)
    80002af4:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002af6:	00014717          	auipc	a4,0x14
    80002afa:	6ce72703          	lw	a4,1742(a4) # 800171c4 <sb+0xc>
    80002afe:	4785                	li	a5,1
    80002b00:	04e7fa63          	bgeu	a5,a4,80002b54 <ialloc+0x74>
    80002b04:	8aaa                	mv	s5,a0
    80002b06:	8bae                	mv	s7,a1
    80002b08:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002b0a:	00014a17          	auipc	s4,0x14
    80002b0e:	6aea0a13          	addi	s4,s4,1710 # 800171b8 <sb>
    80002b12:	00048b1b          	sext.w	s6,s1
    80002b16:	0044d593          	srli	a1,s1,0x4
    80002b1a:	018a2783          	lw	a5,24(s4)
    80002b1e:	9dbd                	addw	a1,a1,a5
    80002b20:	8556                	mv	a0,s5
    80002b22:	00000097          	auipc	ra,0x0
    80002b26:	940080e7          	jalr	-1728(ra) # 80002462 <bread>
    80002b2a:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b2c:	05850993          	addi	s3,a0,88
    80002b30:	00f4f793          	andi	a5,s1,15
    80002b34:	079a                	slli	a5,a5,0x6
    80002b36:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b38:	00099783          	lh	a5,0(s3)
    80002b3c:	c3a1                	beqz	a5,80002b7c <ialloc+0x9c>
    brelse(bp);
    80002b3e:	00000097          	auipc	ra,0x0
    80002b42:	a54080e7          	jalr	-1452(ra) # 80002592 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b46:	0485                	addi	s1,s1,1
    80002b48:	00ca2703          	lw	a4,12(s4)
    80002b4c:	0004879b          	sext.w	a5,s1
    80002b50:	fce7e1e3          	bltu	a5,a4,80002b12 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002b54:	00006517          	auipc	a0,0x6
    80002b58:	adc50513          	addi	a0,a0,-1316 # 80008630 <syscalls+0x180>
    80002b5c:	00003097          	auipc	ra,0x3
    80002b60:	270080e7          	jalr	624(ra) # 80005dcc <printf>
  return 0;
    80002b64:	4501                	li	a0,0
}
    80002b66:	60a6                	ld	ra,72(sp)
    80002b68:	6406                	ld	s0,64(sp)
    80002b6a:	74e2                	ld	s1,56(sp)
    80002b6c:	7942                	ld	s2,48(sp)
    80002b6e:	79a2                	ld	s3,40(sp)
    80002b70:	7a02                	ld	s4,32(sp)
    80002b72:	6ae2                	ld	s5,24(sp)
    80002b74:	6b42                	ld	s6,16(sp)
    80002b76:	6ba2                	ld	s7,8(sp)
    80002b78:	6161                	addi	sp,sp,80
    80002b7a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b7c:	04000613          	li	a2,64
    80002b80:	4581                	li	a1,0
    80002b82:	854e                	mv	a0,s3
    80002b84:	ffffd097          	auipc	ra,0xffffd
    80002b88:	61a080e7          	jalr	1562(ra) # 8000019e <memset>
      dip->type = type;
    80002b8c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b90:	854a                	mv	a0,s2
    80002b92:	00001097          	auipc	ra,0x1
    80002b96:	c84080e7          	jalr	-892(ra) # 80003816 <log_write>
      brelse(bp);
    80002b9a:	854a                	mv	a0,s2
    80002b9c:	00000097          	auipc	ra,0x0
    80002ba0:	9f6080e7          	jalr	-1546(ra) # 80002592 <brelse>
      return iget(dev, inum);
    80002ba4:	85da                	mv	a1,s6
    80002ba6:	8556                	mv	a0,s5
    80002ba8:	00000097          	auipc	ra,0x0
    80002bac:	d9c080e7          	jalr	-612(ra) # 80002944 <iget>
    80002bb0:	bf5d                	j	80002b66 <ialloc+0x86>

0000000080002bb2 <iupdate>:
{
    80002bb2:	1101                	addi	sp,sp,-32
    80002bb4:	ec06                	sd	ra,24(sp)
    80002bb6:	e822                	sd	s0,16(sp)
    80002bb8:	e426                	sd	s1,8(sp)
    80002bba:	e04a                	sd	s2,0(sp)
    80002bbc:	1000                	addi	s0,sp,32
    80002bbe:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bc0:	415c                	lw	a5,4(a0)
    80002bc2:	0047d79b          	srliw	a5,a5,0x4
    80002bc6:	00014597          	auipc	a1,0x14
    80002bca:	60a5a583          	lw	a1,1546(a1) # 800171d0 <sb+0x18>
    80002bce:	9dbd                	addw	a1,a1,a5
    80002bd0:	4108                	lw	a0,0(a0)
    80002bd2:	00000097          	auipc	ra,0x0
    80002bd6:	890080e7          	jalr	-1904(ra) # 80002462 <bread>
    80002bda:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bdc:	05850793          	addi	a5,a0,88
    80002be0:	40c8                	lw	a0,4(s1)
    80002be2:	893d                	andi	a0,a0,15
    80002be4:	051a                	slli	a0,a0,0x6
    80002be6:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002be8:	04449703          	lh	a4,68(s1)
    80002bec:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002bf0:	04649703          	lh	a4,70(s1)
    80002bf4:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002bf8:	04849703          	lh	a4,72(s1)
    80002bfc:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002c00:	04a49703          	lh	a4,74(s1)
    80002c04:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002c08:	44f8                	lw	a4,76(s1)
    80002c0a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c0c:	03400613          	li	a2,52
    80002c10:	05048593          	addi	a1,s1,80
    80002c14:	0531                	addi	a0,a0,12
    80002c16:	ffffd097          	auipc	ra,0xffffd
    80002c1a:	5e8080e7          	jalr	1512(ra) # 800001fe <memmove>
  log_write(bp);
    80002c1e:	854a                	mv	a0,s2
    80002c20:	00001097          	auipc	ra,0x1
    80002c24:	bf6080e7          	jalr	-1034(ra) # 80003816 <log_write>
  brelse(bp);
    80002c28:	854a                	mv	a0,s2
    80002c2a:	00000097          	auipc	ra,0x0
    80002c2e:	968080e7          	jalr	-1688(ra) # 80002592 <brelse>
}
    80002c32:	60e2                	ld	ra,24(sp)
    80002c34:	6442                	ld	s0,16(sp)
    80002c36:	64a2                	ld	s1,8(sp)
    80002c38:	6902                	ld	s2,0(sp)
    80002c3a:	6105                	addi	sp,sp,32
    80002c3c:	8082                	ret

0000000080002c3e <idup>:
{
    80002c3e:	1101                	addi	sp,sp,-32
    80002c40:	ec06                	sd	ra,24(sp)
    80002c42:	e822                	sd	s0,16(sp)
    80002c44:	e426                	sd	s1,8(sp)
    80002c46:	1000                	addi	s0,sp,32
    80002c48:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c4a:	00014517          	auipc	a0,0x14
    80002c4e:	58e50513          	addi	a0,a0,1422 # 800171d8 <itable>
    80002c52:	00003097          	auipc	ra,0x3
    80002c56:	67a080e7          	jalr	1658(ra) # 800062cc <acquire>
  ip->ref++;
    80002c5a:	449c                	lw	a5,8(s1)
    80002c5c:	2785                	addiw	a5,a5,1
    80002c5e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c60:	00014517          	auipc	a0,0x14
    80002c64:	57850513          	addi	a0,a0,1400 # 800171d8 <itable>
    80002c68:	00003097          	auipc	ra,0x3
    80002c6c:	718080e7          	jalr	1816(ra) # 80006380 <release>
}
    80002c70:	8526                	mv	a0,s1
    80002c72:	60e2                	ld	ra,24(sp)
    80002c74:	6442                	ld	s0,16(sp)
    80002c76:	64a2                	ld	s1,8(sp)
    80002c78:	6105                	addi	sp,sp,32
    80002c7a:	8082                	ret

0000000080002c7c <ilock>:
{
    80002c7c:	1101                	addi	sp,sp,-32
    80002c7e:	ec06                	sd	ra,24(sp)
    80002c80:	e822                	sd	s0,16(sp)
    80002c82:	e426                	sd	s1,8(sp)
    80002c84:	e04a                	sd	s2,0(sp)
    80002c86:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c88:	c115                	beqz	a0,80002cac <ilock+0x30>
    80002c8a:	84aa                	mv	s1,a0
    80002c8c:	451c                	lw	a5,8(a0)
    80002c8e:	00f05f63          	blez	a5,80002cac <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c92:	0541                	addi	a0,a0,16
    80002c94:	00001097          	auipc	ra,0x1
    80002c98:	ca2080e7          	jalr	-862(ra) # 80003936 <acquiresleep>
  if(ip->valid == 0){
    80002c9c:	40bc                	lw	a5,64(s1)
    80002c9e:	cf99                	beqz	a5,80002cbc <ilock+0x40>
}
    80002ca0:	60e2                	ld	ra,24(sp)
    80002ca2:	6442                	ld	s0,16(sp)
    80002ca4:	64a2                	ld	s1,8(sp)
    80002ca6:	6902                	ld	s2,0(sp)
    80002ca8:	6105                	addi	sp,sp,32
    80002caa:	8082                	ret
    panic("ilock");
    80002cac:	00006517          	auipc	a0,0x6
    80002cb0:	99c50513          	addi	a0,a0,-1636 # 80008648 <syscalls+0x198>
    80002cb4:	00003097          	auipc	ra,0x3
    80002cb8:	0ce080e7          	jalr	206(ra) # 80005d82 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cbc:	40dc                	lw	a5,4(s1)
    80002cbe:	0047d79b          	srliw	a5,a5,0x4
    80002cc2:	00014597          	auipc	a1,0x14
    80002cc6:	50e5a583          	lw	a1,1294(a1) # 800171d0 <sb+0x18>
    80002cca:	9dbd                	addw	a1,a1,a5
    80002ccc:	4088                	lw	a0,0(s1)
    80002cce:	fffff097          	auipc	ra,0xfffff
    80002cd2:	794080e7          	jalr	1940(ra) # 80002462 <bread>
    80002cd6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cd8:	05850593          	addi	a1,a0,88
    80002cdc:	40dc                	lw	a5,4(s1)
    80002cde:	8bbd                	andi	a5,a5,15
    80002ce0:	079a                	slli	a5,a5,0x6
    80002ce2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ce4:	00059783          	lh	a5,0(a1)
    80002ce8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cec:	00259783          	lh	a5,2(a1)
    80002cf0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cf4:	00459783          	lh	a5,4(a1)
    80002cf8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cfc:	00659783          	lh	a5,6(a1)
    80002d00:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d04:	459c                	lw	a5,8(a1)
    80002d06:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d08:	03400613          	li	a2,52
    80002d0c:	05b1                	addi	a1,a1,12
    80002d0e:	05048513          	addi	a0,s1,80
    80002d12:	ffffd097          	auipc	ra,0xffffd
    80002d16:	4ec080e7          	jalr	1260(ra) # 800001fe <memmove>
    brelse(bp);
    80002d1a:	854a                	mv	a0,s2
    80002d1c:	00000097          	auipc	ra,0x0
    80002d20:	876080e7          	jalr	-1930(ra) # 80002592 <brelse>
    ip->valid = 1;
    80002d24:	4785                	li	a5,1
    80002d26:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d28:	04449783          	lh	a5,68(s1)
    80002d2c:	fbb5                	bnez	a5,80002ca0 <ilock+0x24>
      panic("ilock: no type");
    80002d2e:	00006517          	auipc	a0,0x6
    80002d32:	92250513          	addi	a0,a0,-1758 # 80008650 <syscalls+0x1a0>
    80002d36:	00003097          	auipc	ra,0x3
    80002d3a:	04c080e7          	jalr	76(ra) # 80005d82 <panic>

0000000080002d3e <iunlock>:
{
    80002d3e:	1101                	addi	sp,sp,-32
    80002d40:	ec06                	sd	ra,24(sp)
    80002d42:	e822                	sd	s0,16(sp)
    80002d44:	e426                	sd	s1,8(sp)
    80002d46:	e04a                	sd	s2,0(sp)
    80002d48:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d4a:	c905                	beqz	a0,80002d7a <iunlock+0x3c>
    80002d4c:	84aa                	mv	s1,a0
    80002d4e:	01050913          	addi	s2,a0,16
    80002d52:	854a                	mv	a0,s2
    80002d54:	00001097          	auipc	ra,0x1
    80002d58:	c7c080e7          	jalr	-900(ra) # 800039d0 <holdingsleep>
    80002d5c:	cd19                	beqz	a0,80002d7a <iunlock+0x3c>
    80002d5e:	449c                	lw	a5,8(s1)
    80002d60:	00f05d63          	blez	a5,80002d7a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002d64:	854a                	mv	a0,s2
    80002d66:	00001097          	auipc	ra,0x1
    80002d6a:	c26080e7          	jalr	-986(ra) # 8000398c <releasesleep>
}
    80002d6e:	60e2                	ld	ra,24(sp)
    80002d70:	6442                	ld	s0,16(sp)
    80002d72:	64a2                	ld	s1,8(sp)
    80002d74:	6902                	ld	s2,0(sp)
    80002d76:	6105                	addi	sp,sp,32
    80002d78:	8082                	ret
    panic("iunlock");
    80002d7a:	00006517          	auipc	a0,0x6
    80002d7e:	8e650513          	addi	a0,a0,-1818 # 80008660 <syscalls+0x1b0>
    80002d82:	00003097          	auipc	ra,0x3
    80002d86:	000080e7          	jalr	ra # 80005d82 <panic>

0000000080002d8a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d8a:	7179                	addi	sp,sp,-48
    80002d8c:	f406                	sd	ra,40(sp)
    80002d8e:	f022                	sd	s0,32(sp)
    80002d90:	ec26                	sd	s1,24(sp)
    80002d92:	e84a                	sd	s2,16(sp)
    80002d94:	e44e                	sd	s3,8(sp)
    80002d96:	e052                	sd	s4,0(sp)
    80002d98:	1800                	addi	s0,sp,48
    80002d9a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d9c:	05050493          	addi	s1,a0,80
    80002da0:	08050913          	addi	s2,a0,128
    80002da4:	a021                	j	80002dac <itrunc+0x22>
    80002da6:	0491                	addi	s1,s1,4
    80002da8:	01248d63          	beq	s1,s2,80002dc2 <itrunc+0x38>
    if(ip->addrs[i]){
    80002dac:	408c                	lw	a1,0(s1)
    80002dae:	dde5                	beqz	a1,80002da6 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002db0:	0009a503          	lw	a0,0(s3)
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	8f4080e7          	jalr	-1804(ra) # 800026a8 <bfree>
      ip->addrs[i] = 0;
    80002dbc:	0004a023          	sw	zero,0(s1)
    80002dc0:	b7dd                	j	80002da6 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002dc2:	0809a583          	lw	a1,128(s3)
    80002dc6:	e185                	bnez	a1,80002de6 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dc8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dcc:	854e                	mv	a0,s3
    80002dce:	00000097          	auipc	ra,0x0
    80002dd2:	de4080e7          	jalr	-540(ra) # 80002bb2 <iupdate>
}
    80002dd6:	70a2                	ld	ra,40(sp)
    80002dd8:	7402                	ld	s0,32(sp)
    80002dda:	64e2                	ld	s1,24(sp)
    80002ddc:	6942                	ld	s2,16(sp)
    80002dde:	69a2                	ld	s3,8(sp)
    80002de0:	6a02                	ld	s4,0(sp)
    80002de2:	6145                	addi	sp,sp,48
    80002de4:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002de6:	0009a503          	lw	a0,0(s3)
    80002dea:	fffff097          	auipc	ra,0xfffff
    80002dee:	678080e7          	jalr	1656(ra) # 80002462 <bread>
    80002df2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002df4:	05850493          	addi	s1,a0,88
    80002df8:	45850913          	addi	s2,a0,1112
    80002dfc:	a811                	j	80002e10 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002dfe:	0009a503          	lw	a0,0(s3)
    80002e02:	00000097          	auipc	ra,0x0
    80002e06:	8a6080e7          	jalr	-1882(ra) # 800026a8 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002e0a:	0491                	addi	s1,s1,4
    80002e0c:	01248563          	beq	s1,s2,80002e16 <itrunc+0x8c>
      if(a[j])
    80002e10:	408c                	lw	a1,0(s1)
    80002e12:	dde5                	beqz	a1,80002e0a <itrunc+0x80>
    80002e14:	b7ed                	j	80002dfe <itrunc+0x74>
    brelse(bp);
    80002e16:	8552                	mv	a0,s4
    80002e18:	fffff097          	auipc	ra,0xfffff
    80002e1c:	77a080e7          	jalr	1914(ra) # 80002592 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e20:	0809a583          	lw	a1,128(s3)
    80002e24:	0009a503          	lw	a0,0(s3)
    80002e28:	00000097          	auipc	ra,0x0
    80002e2c:	880080e7          	jalr	-1920(ra) # 800026a8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e30:	0809a023          	sw	zero,128(s3)
    80002e34:	bf51                	j	80002dc8 <itrunc+0x3e>

0000000080002e36 <iput>:
{
    80002e36:	1101                	addi	sp,sp,-32
    80002e38:	ec06                	sd	ra,24(sp)
    80002e3a:	e822                	sd	s0,16(sp)
    80002e3c:	e426                	sd	s1,8(sp)
    80002e3e:	e04a                	sd	s2,0(sp)
    80002e40:	1000                	addi	s0,sp,32
    80002e42:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e44:	00014517          	auipc	a0,0x14
    80002e48:	39450513          	addi	a0,a0,916 # 800171d8 <itable>
    80002e4c:	00003097          	auipc	ra,0x3
    80002e50:	480080e7          	jalr	1152(ra) # 800062cc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e54:	4498                	lw	a4,8(s1)
    80002e56:	4785                	li	a5,1
    80002e58:	02f70363          	beq	a4,a5,80002e7e <iput+0x48>
  ip->ref--;
    80002e5c:	449c                	lw	a5,8(s1)
    80002e5e:	37fd                	addiw	a5,a5,-1
    80002e60:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e62:	00014517          	auipc	a0,0x14
    80002e66:	37650513          	addi	a0,a0,886 # 800171d8 <itable>
    80002e6a:	00003097          	auipc	ra,0x3
    80002e6e:	516080e7          	jalr	1302(ra) # 80006380 <release>
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6902                	ld	s2,0(sp)
    80002e7a:	6105                	addi	sp,sp,32
    80002e7c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e7e:	40bc                	lw	a5,64(s1)
    80002e80:	dff1                	beqz	a5,80002e5c <iput+0x26>
    80002e82:	04a49783          	lh	a5,74(s1)
    80002e86:	fbf9                	bnez	a5,80002e5c <iput+0x26>
    acquiresleep(&ip->lock);
    80002e88:	01048913          	addi	s2,s1,16
    80002e8c:	854a                	mv	a0,s2
    80002e8e:	00001097          	auipc	ra,0x1
    80002e92:	aa8080e7          	jalr	-1368(ra) # 80003936 <acquiresleep>
    release(&itable.lock);
    80002e96:	00014517          	auipc	a0,0x14
    80002e9a:	34250513          	addi	a0,a0,834 # 800171d8 <itable>
    80002e9e:	00003097          	auipc	ra,0x3
    80002ea2:	4e2080e7          	jalr	1250(ra) # 80006380 <release>
    itrunc(ip);
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	00000097          	auipc	ra,0x0
    80002eac:	ee2080e7          	jalr	-286(ra) # 80002d8a <itrunc>
    ip->type = 0;
    80002eb0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	00000097          	auipc	ra,0x0
    80002eba:	cfc080e7          	jalr	-772(ra) # 80002bb2 <iupdate>
    ip->valid = 0;
    80002ebe:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ec2:	854a                	mv	a0,s2
    80002ec4:	00001097          	auipc	ra,0x1
    80002ec8:	ac8080e7          	jalr	-1336(ra) # 8000398c <releasesleep>
    acquire(&itable.lock);
    80002ecc:	00014517          	auipc	a0,0x14
    80002ed0:	30c50513          	addi	a0,a0,780 # 800171d8 <itable>
    80002ed4:	00003097          	auipc	ra,0x3
    80002ed8:	3f8080e7          	jalr	1016(ra) # 800062cc <acquire>
    80002edc:	b741                	j	80002e5c <iput+0x26>

0000000080002ede <iunlockput>:
{
    80002ede:	1101                	addi	sp,sp,-32
    80002ee0:	ec06                	sd	ra,24(sp)
    80002ee2:	e822                	sd	s0,16(sp)
    80002ee4:	e426                	sd	s1,8(sp)
    80002ee6:	1000                	addi	s0,sp,32
    80002ee8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eea:	00000097          	auipc	ra,0x0
    80002eee:	e54080e7          	jalr	-428(ra) # 80002d3e <iunlock>
  iput(ip);
    80002ef2:	8526                	mv	a0,s1
    80002ef4:	00000097          	auipc	ra,0x0
    80002ef8:	f42080e7          	jalr	-190(ra) # 80002e36 <iput>
}
    80002efc:	60e2                	ld	ra,24(sp)
    80002efe:	6442                	ld	s0,16(sp)
    80002f00:	64a2                	ld	s1,8(sp)
    80002f02:	6105                	addi	sp,sp,32
    80002f04:	8082                	ret

0000000080002f06 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002f06:	1141                	addi	sp,sp,-16
    80002f08:	e422                	sd	s0,8(sp)
    80002f0a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002f0c:	411c                	lw	a5,0(a0)
    80002f0e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002f10:	415c                	lw	a5,4(a0)
    80002f12:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002f14:	04451783          	lh	a5,68(a0)
    80002f18:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002f1c:	04a51783          	lh	a5,74(a0)
    80002f20:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002f24:	04c56783          	lwu	a5,76(a0)
    80002f28:	e99c                	sd	a5,16(a1)
}
    80002f2a:	6422                	ld	s0,8(sp)
    80002f2c:	0141                	addi	sp,sp,16
    80002f2e:	8082                	ret

0000000080002f30 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f30:	457c                	lw	a5,76(a0)
    80002f32:	0ed7e963          	bltu	a5,a3,80003024 <readi+0xf4>
{
    80002f36:	7159                	addi	sp,sp,-112
    80002f38:	f486                	sd	ra,104(sp)
    80002f3a:	f0a2                	sd	s0,96(sp)
    80002f3c:	eca6                	sd	s1,88(sp)
    80002f3e:	e8ca                	sd	s2,80(sp)
    80002f40:	e4ce                	sd	s3,72(sp)
    80002f42:	e0d2                	sd	s4,64(sp)
    80002f44:	fc56                	sd	s5,56(sp)
    80002f46:	f85a                	sd	s6,48(sp)
    80002f48:	f45e                	sd	s7,40(sp)
    80002f4a:	f062                	sd	s8,32(sp)
    80002f4c:	ec66                	sd	s9,24(sp)
    80002f4e:	e86a                	sd	s10,16(sp)
    80002f50:	e46e                	sd	s11,8(sp)
    80002f52:	1880                	addi	s0,sp,112
    80002f54:	8b2a                	mv	s6,a0
    80002f56:	8bae                	mv	s7,a1
    80002f58:	8a32                	mv	s4,a2
    80002f5a:	84b6                	mv	s1,a3
    80002f5c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002f5e:	9f35                	addw	a4,a4,a3
    return 0;
    80002f60:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002f62:	0ad76063          	bltu	a4,a3,80003002 <readi+0xd2>
  if(off + n > ip->size)
    80002f66:	00e7f463          	bgeu	a5,a4,80002f6e <readi+0x3e>
    n = ip->size - off;
    80002f6a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f6e:	0a0a8963          	beqz	s5,80003020 <readi+0xf0>
    80002f72:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f74:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f78:	5c7d                	li	s8,-1
    80002f7a:	a82d                	j	80002fb4 <readi+0x84>
    80002f7c:	020d1d93          	slli	s11,s10,0x20
    80002f80:	020ddd93          	srli	s11,s11,0x20
    80002f84:	05890613          	addi	a2,s2,88
    80002f88:	86ee                	mv	a3,s11
    80002f8a:	963a                	add	a2,a2,a4
    80002f8c:	85d2                	mv	a1,s4
    80002f8e:	855e                	mv	a0,s7
    80002f90:	fffff097          	auipc	ra,0xfffff
    80002f94:	9a2080e7          	jalr	-1630(ra) # 80001932 <either_copyout>
    80002f98:	05850d63          	beq	a0,s8,80002ff2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f9c:	854a                	mv	a0,s2
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	5f4080e7          	jalr	1524(ra) # 80002592 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fa6:	013d09bb          	addw	s3,s10,s3
    80002faa:	009d04bb          	addw	s1,s10,s1
    80002fae:	9a6e                	add	s4,s4,s11
    80002fb0:	0559f763          	bgeu	s3,s5,80002ffe <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002fb4:	00a4d59b          	srliw	a1,s1,0xa
    80002fb8:	855a                	mv	a0,s6
    80002fba:	00000097          	auipc	ra,0x0
    80002fbe:	8a2080e7          	jalr	-1886(ra) # 8000285c <bmap>
    80002fc2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002fc6:	cd85                	beqz	a1,80002ffe <readi+0xce>
    bp = bread(ip->dev, addr);
    80002fc8:	000b2503          	lw	a0,0(s6)
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	496080e7          	jalr	1174(ra) # 80002462 <bread>
    80002fd4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fd6:	3ff4f713          	andi	a4,s1,1023
    80002fda:	40ec87bb          	subw	a5,s9,a4
    80002fde:	413a86bb          	subw	a3,s5,s3
    80002fe2:	8d3e                	mv	s10,a5
    80002fe4:	2781                	sext.w	a5,a5
    80002fe6:	0006861b          	sext.w	a2,a3
    80002fea:	f8f679e3          	bgeu	a2,a5,80002f7c <readi+0x4c>
    80002fee:	8d36                	mv	s10,a3
    80002ff0:	b771                	j	80002f7c <readi+0x4c>
      brelse(bp);
    80002ff2:	854a                	mv	a0,s2
    80002ff4:	fffff097          	auipc	ra,0xfffff
    80002ff8:	59e080e7          	jalr	1438(ra) # 80002592 <brelse>
      tot = -1;
    80002ffc:	59fd                	li	s3,-1
  }
  return tot;
    80002ffe:	0009851b          	sext.w	a0,s3
}
    80003002:	70a6                	ld	ra,104(sp)
    80003004:	7406                	ld	s0,96(sp)
    80003006:	64e6                	ld	s1,88(sp)
    80003008:	6946                	ld	s2,80(sp)
    8000300a:	69a6                	ld	s3,72(sp)
    8000300c:	6a06                	ld	s4,64(sp)
    8000300e:	7ae2                	ld	s5,56(sp)
    80003010:	7b42                	ld	s6,48(sp)
    80003012:	7ba2                	ld	s7,40(sp)
    80003014:	7c02                	ld	s8,32(sp)
    80003016:	6ce2                	ld	s9,24(sp)
    80003018:	6d42                	ld	s10,16(sp)
    8000301a:	6da2                	ld	s11,8(sp)
    8000301c:	6165                	addi	sp,sp,112
    8000301e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003020:	89d6                	mv	s3,s5
    80003022:	bff1                	j	80002ffe <readi+0xce>
    return 0;
    80003024:	4501                	li	a0,0
}
    80003026:	8082                	ret

0000000080003028 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003028:	457c                	lw	a5,76(a0)
    8000302a:	10d7e863          	bltu	a5,a3,8000313a <writei+0x112>
{
    8000302e:	7159                	addi	sp,sp,-112
    80003030:	f486                	sd	ra,104(sp)
    80003032:	f0a2                	sd	s0,96(sp)
    80003034:	eca6                	sd	s1,88(sp)
    80003036:	e8ca                	sd	s2,80(sp)
    80003038:	e4ce                	sd	s3,72(sp)
    8000303a:	e0d2                	sd	s4,64(sp)
    8000303c:	fc56                	sd	s5,56(sp)
    8000303e:	f85a                	sd	s6,48(sp)
    80003040:	f45e                	sd	s7,40(sp)
    80003042:	f062                	sd	s8,32(sp)
    80003044:	ec66                	sd	s9,24(sp)
    80003046:	e86a                	sd	s10,16(sp)
    80003048:	e46e                	sd	s11,8(sp)
    8000304a:	1880                	addi	s0,sp,112
    8000304c:	8aaa                	mv	s5,a0
    8000304e:	8bae                	mv	s7,a1
    80003050:	8a32                	mv	s4,a2
    80003052:	8936                	mv	s2,a3
    80003054:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003056:	00e687bb          	addw	a5,a3,a4
    8000305a:	0ed7e263          	bltu	a5,a3,8000313e <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000305e:	00043737          	lui	a4,0x43
    80003062:	0ef76063          	bltu	a4,a5,80003142 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003066:	0c0b0863          	beqz	s6,80003136 <writei+0x10e>
    8000306a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000306c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003070:	5c7d                	li	s8,-1
    80003072:	a091                	j	800030b6 <writei+0x8e>
    80003074:	020d1d93          	slli	s11,s10,0x20
    80003078:	020ddd93          	srli	s11,s11,0x20
    8000307c:	05848513          	addi	a0,s1,88
    80003080:	86ee                	mv	a3,s11
    80003082:	8652                	mv	a2,s4
    80003084:	85de                	mv	a1,s7
    80003086:	953a                	add	a0,a0,a4
    80003088:	fffff097          	auipc	ra,0xfffff
    8000308c:	900080e7          	jalr	-1792(ra) # 80001988 <either_copyin>
    80003090:	07850263          	beq	a0,s8,800030f4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003094:	8526                	mv	a0,s1
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	780080e7          	jalr	1920(ra) # 80003816 <log_write>
    brelse(bp);
    8000309e:	8526                	mv	a0,s1
    800030a0:	fffff097          	auipc	ra,0xfffff
    800030a4:	4f2080e7          	jalr	1266(ra) # 80002592 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030a8:	013d09bb          	addw	s3,s10,s3
    800030ac:	012d093b          	addw	s2,s10,s2
    800030b0:	9a6e                	add	s4,s4,s11
    800030b2:	0569f663          	bgeu	s3,s6,800030fe <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    800030b6:	00a9559b          	srliw	a1,s2,0xa
    800030ba:	8556                	mv	a0,s5
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	7a0080e7          	jalr	1952(ra) # 8000285c <bmap>
    800030c4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030c8:	c99d                	beqz	a1,800030fe <writei+0xd6>
    bp = bread(ip->dev, addr);
    800030ca:	000aa503          	lw	a0,0(s5)
    800030ce:	fffff097          	auipc	ra,0xfffff
    800030d2:	394080e7          	jalr	916(ra) # 80002462 <bread>
    800030d6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030d8:	3ff97713          	andi	a4,s2,1023
    800030dc:	40ec87bb          	subw	a5,s9,a4
    800030e0:	413b06bb          	subw	a3,s6,s3
    800030e4:	8d3e                	mv	s10,a5
    800030e6:	2781                	sext.w	a5,a5
    800030e8:	0006861b          	sext.w	a2,a3
    800030ec:	f8f674e3          	bgeu	a2,a5,80003074 <writei+0x4c>
    800030f0:	8d36                	mv	s10,a3
    800030f2:	b749                	j	80003074 <writei+0x4c>
      brelse(bp);
    800030f4:	8526                	mv	a0,s1
    800030f6:	fffff097          	auipc	ra,0xfffff
    800030fa:	49c080e7          	jalr	1180(ra) # 80002592 <brelse>
  }

  if(off > ip->size)
    800030fe:	04caa783          	lw	a5,76(s5)
    80003102:	0127f463          	bgeu	a5,s2,8000310a <writei+0xe2>
    ip->size = off;
    80003106:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000310a:	8556                	mv	a0,s5
    8000310c:	00000097          	auipc	ra,0x0
    80003110:	aa6080e7          	jalr	-1370(ra) # 80002bb2 <iupdate>

  return tot;
    80003114:	0009851b          	sext.w	a0,s3
}
    80003118:	70a6                	ld	ra,104(sp)
    8000311a:	7406                	ld	s0,96(sp)
    8000311c:	64e6                	ld	s1,88(sp)
    8000311e:	6946                	ld	s2,80(sp)
    80003120:	69a6                	ld	s3,72(sp)
    80003122:	6a06                	ld	s4,64(sp)
    80003124:	7ae2                	ld	s5,56(sp)
    80003126:	7b42                	ld	s6,48(sp)
    80003128:	7ba2                	ld	s7,40(sp)
    8000312a:	7c02                	ld	s8,32(sp)
    8000312c:	6ce2                	ld	s9,24(sp)
    8000312e:	6d42                	ld	s10,16(sp)
    80003130:	6da2                	ld	s11,8(sp)
    80003132:	6165                	addi	sp,sp,112
    80003134:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003136:	89da                	mv	s3,s6
    80003138:	bfc9                	j	8000310a <writei+0xe2>
    return -1;
    8000313a:	557d                	li	a0,-1
}
    8000313c:	8082                	ret
    return -1;
    8000313e:	557d                	li	a0,-1
    80003140:	bfe1                	j	80003118 <writei+0xf0>
    return -1;
    80003142:	557d                	li	a0,-1
    80003144:	bfd1                	j	80003118 <writei+0xf0>

0000000080003146 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003146:	1141                	addi	sp,sp,-16
    80003148:	e406                	sd	ra,8(sp)
    8000314a:	e022                	sd	s0,0(sp)
    8000314c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000314e:	4639                	li	a2,14
    80003150:	ffffd097          	auipc	ra,0xffffd
    80003154:	126080e7          	jalr	294(ra) # 80000276 <strncmp>
}
    80003158:	60a2                	ld	ra,8(sp)
    8000315a:	6402                	ld	s0,0(sp)
    8000315c:	0141                	addi	sp,sp,16
    8000315e:	8082                	ret

0000000080003160 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003160:	7139                	addi	sp,sp,-64
    80003162:	fc06                	sd	ra,56(sp)
    80003164:	f822                	sd	s0,48(sp)
    80003166:	f426                	sd	s1,40(sp)
    80003168:	f04a                	sd	s2,32(sp)
    8000316a:	ec4e                	sd	s3,24(sp)
    8000316c:	e852                	sd	s4,16(sp)
    8000316e:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003170:	04451703          	lh	a4,68(a0)
    80003174:	4785                	li	a5,1
    80003176:	00f71a63          	bne	a4,a5,8000318a <dirlookup+0x2a>
    8000317a:	892a                	mv	s2,a0
    8000317c:	89ae                	mv	s3,a1
    8000317e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003180:	457c                	lw	a5,76(a0)
    80003182:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003184:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003186:	e79d                	bnez	a5,800031b4 <dirlookup+0x54>
    80003188:	a8a5                	j	80003200 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000318a:	00005517          	auipc	a0,0x5
    8000318e:	4de50513          	addi	a0,a0,1246 # 80008668 <syscalls+0x1b8>
    80003192:	00003097          	auipc	ra,0x3
    80003196:	bf0080e7          	jalr	-1040(ra) # 80005d82 <panic>
      panic("dirlookup read");
    8000319a:	00005517          	auipc	a0,0x5
    8000319e:	4e650513          	addi	a0,a0,1254 # 80008680 <syscalls+0x1d0>
    800031a2:	00003097          	auipc	ra,0x3
    800031a6:	be0080e7          	jalr	-1056(ra) # 80005d82 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800031aa:	24c1                	addiw	s1,s1,16
    800031ac:	04c92783          	lw	a5,76(s2)
    800031b0:	04f4f763          	bgeu	s1,a5,800031fe <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031b4:	4741                	li	a4,16
    800031b6:	86a6                	mv	a3,s1
    800031b8:	fc040613          	addi	a2,s0,-64
    800031bc:	4581                	li	a1,0
    800031be:	854a                	mv	a0,s2
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	d70080e7          	jalr	-656(ra) # 80002f30 <readi>
    800031c8:	47c1                	li	a5,16
    800031ca:	fcf518e3          	bne	a0,a5,8000319a <dirlookup+0x3a>
    if(de.inum == 0)
    800031ce:	fc045783          	lhu	a5,-64(s0)
    800031d2:	dfe1                	beqz	a5,800031aa <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800031d4:	fc240593          	addi	a1,s0,-62
    800031d8:	854e                	mv	a0,s3
    800031da:	00000097          	auipc	ra,0x0
    800031de:	f6c080e7          	jalr	-148(ra) # 80003146 <namecmp>
    800031e2:	f561                	bnez	a0,800031aa <dirlookup+0x4a>
      if(poff)
    800031e4:	000a0463          	beqz	s4,800031ec <dirlookup+0x8c>
        *poff = off;
    800031e8:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800031ec:	fc045583          	lhu	a1,-64(s0)
    800031f0:	00092503          	lw	a0,0(s2)
    800031f4:	fffff097          	auipc	ra,0xfffff
    800031f8:	750080e7          	jalr	1872(ra) # 80002944 <iget>
    800031fc:	a011                	j	80003200 <dirlookup+0xa0>
  return 0;
    800031fe:	4501                	li	a0,0
}
    80003200:	70e2                	ld	ra,56(sp)
    80003202:	7442                	ld	s0,48(sp)
    80003204:	74a2                	ld	s1,40(sp)
    80003206:	7902                	ld	s2,32(sp)
    80003208:	69e2                	ld	s3,24(sp)
    8000320a:	6a42                	ld	s4,16(sp)
    8000320c:	6121                	addi	sp,sp,64
    8000320e:	8082                	ret

0000000080003210 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003210:	711d                	addi	sp,sp,-96
    80003212:	ec86                	sd	ra,88(sp)
    80003214:	e8a2                	sd	s0,80(sp)
    80003216:	e4a6                	sd	s1,72(sp)
    80003218:	e0ca                	sd	s2,64(sp)
    8000321a:	fc4e                	sd	s3,56(sp)
    8000321c:	f852                	sd	s4,48(sp)
    8000321e:	f456                	sd	s5,40(sp)
    80003220:	f05a                	sd	s6,32(sp)
    80003222:	ec5e                	sd	s7,24(sp)
    80003224:	e862                	sd	s8,16(sp)
    80003226:	e466                	sd	s9,8(sp)
    80003228:	1080                	addi	s0,sp,96
    8000322a:	84aa                	mv	s1,a0
    8000322c:	8b2e                	mv	s6,a1
    8000322e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003230:	00054703          	lbu	a4,0(a0)
    80003234:	02f00793          	li	a5,47
    80003238:	02f70363          	beq	a4,a5,8000325e <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000323c:	ffffe097          	auipc	ra,0xffffe
    80003240:	c42080e7          	jalr	-958(ra) # 80000e7e <myproc>
    80003244:	15053503          	ld	a0,336(a0)
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	9f6080e7          	jalr	-1546(ra) # 80002c3e <idup>
    80003250:	89aa                	mv	s3,a0
  while(*path == '/')
    80003252:	02f00913          	li	s2,47
  len = path - s;
    80003256:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003258:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000325a:	4c05                	li	s8,1
    8000325c:	a865                	j	80003314 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000325e:	4585                	li	a1,1
    80003260:	4505                	li	a0,1
    80003262:	fffff097          	auipc	ra,0xfffff
    80003266:	6e2080e7          	jalr	1762(ra) # 80002944 <iget>
    8000326a:	89aa                	mv	s3,a0
    8000326c:	b7dd                	j	80003252 <namex+0x42>
      iunlockput(ip);
    8000326e:	854e                	mv	a0,s3
    80003270:	00000097          	auipc	ra,0x0
    80003274:	c6e080e7          	jalr	-914(ra) # 80002ede <iunlockput>
      return 0;
    80003278:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000327a:	854e                	mv	a0,s3
    8000327c:	60e6                	ld	ra,88(sp)
    8000327e:	6446                	ld	s0,80(sp)
    80003280:	64a6                	ld	s1,72(sp)
    80003282:	6906                	ld	s2,64(sp)
    80003284:	79e2                	ld	s3,56(sp)
    80003286:	7a42                	ld	s4,48(sp)
    80003288:	7aa2                	ld	s5,40(sp)
    8000328a:	7b02                	ld	s6,32(sp)
    8000328c:	6be2                	ld	s7,24(sp)
    8000328e:	6c42                	ld	s8,16(sp)
    80003290:	6ca2                	ld	s9,8(sp)
    80003292:	6125                	addi	sp,sp,96
    80003294:	8082                	ret
      iunlock(ip);
    80003296:	854e                	mv	a0,s3
    80003298:	00000097          	auipc	ra,0x0
    8000329c:	aa6080e7          	jalr	-1370(ra) # 80002d3e <iunlock>
      return ip;
    800032a0:	bfe9                	j	8000327a <namex+0x6a>
      iunlockput(ip);
    800032a2:	854e                	mv	a0,s3
    800032a4:	00000097          	auipc	ra,0x0
    800032a8:	c3a080e7          	jalr	-966(ra) # 80002ede <iunlockput>
      return 0;
    800032ac:	89d2                	mv	s3,s4
    800032ae:	b7f1                	j	8000327a <namex+0x6a>
  len = path - s;
    800032b0:	40b48633          	sub	a2,s1,a1
    800032b4:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    800032b8:	094cd463          	bge	s9,s4,80003340 <namex+0x130>
    memmove(name, s, DIRSIZ);
    800032bc:	4639                	li	a2,14
    800032be:	8556                	mv	a0,s5
    800032c0:	ffffd097          	auipc	ra,0xffffd
    800032c4:	f3e080e7          	jalr	-194(ra) # 800001fe <memmove>
  while(*path == '/')
    800032c8:	0004c783          	lbu	a5,0(s1)
    800032cc:	01279763          	bne	a5,s2,800032da <namex+0xca>
    path++;
    800032d0:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032d2:	0004c783          	lbu	a5,0(s1)
    800032d6:	ff278de3          	beq	a5,s2,800032d0 <namex+0xc0>
    ilock(ip);
    800032da:	854e                	mv	a0,s3
    800032dc:	00000097          	auipc	ra,0x0
    800032e0:	9a0080e7          	jalr	-1632(ra) # 80002c7c <ilock>
    if(ip->type != T_DIR){
    800032e4:	04499783          	lh	a5,68(s3)
    800032e8:	f98793e3          	bne	a5,s8,8000326e <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800032ec:	000b0563          	beqz	s6,800032f6 <namex+0xe6>
    800032f0:	0004c783          	lbu	a5,0(s1)
    800032f4:	d3cd                	beqz	a5,80003296 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800032f6:	865e                	mv	a2,s7
    800032f8:	85d6                	mv	a1,s5
    800032fa:	854e                	mv	a0,s3
    800032fc:	00000097          	auipc	ra,0x0
    80003300:	e64080e7          	jalr	-412(ra) # 80003160 <dirlookup>
    80003304:	8a2a                	mv	s4,a0
    80003306:	dd51                	beqz	a0,800032a2 <namex+0x92>
    iunlockput(ip);
    80003308:	854e                	mv	a0,s3
    8000330a:	00000097          	auipc	ra,0x0
    8000330e:	bd4080e7          	jalr	-1068(ra) # 80002ede <iunlockput>
    ip = next;
    80003312:	89d2                	mv	s3,s4
  while(*path == '/')
    80003314:	0004c783          	lbu	a5,0(s1)
    80003318:	05279763          	bne	a5,s2,80003366 <namex+0x156>
    path++;
    8000331c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000331e:	0004c783          	lbu	a5,0(s1)
    80003322:	ff278de3          	beq	a5,s2,8000331c <namex+0x10c>
  if(*path == 0)
    80003326:	c79d                	beqz	a5,80003354 <namex+0x144>
    path++;
    80003328:	85a6                	mv	a1,s1
  len = path - s;
    8000332a:	8a5e                	mv	s4,s7
    8000332c:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000332e:	01278963          	beq	a5,s2,80003340 <namex+0x130>
    80003332:	dfbd                	beqz	a5,800032b0 <namex+0xa0>
    path++;
    80003334:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003336:	0004c783          	lbu	a5,0(s1)
    8000333a:	ff279ce3          	bne	a5,s2,80003332 <namex+0x122>
    8000333e:	bf8d                	j	800032b0 <namex+0xa0>
    memmove(name, s, len);
    80003340:	2601                	sext.w	a2,a2
    80003342:	8556                	mv	a0,s5
    80003344:	ffffd097          	auipc	ra,0xffffd
    80003348:	eba080e7          	jalr	-326(ra) # 800001fe <memmove>
    name[len] = 0;
    8000334c:	9a56                	add	s4,s4,s5
    8000334e:	000a0023          	sb	zero,0(s4)
    80003352:	bf9d                	j	800032c8 <namex+0xb8>
  if(nameiparent){
    80003354:	f20b03e3          	beqz	s6,8000327a <namex+0x6a>
    iput(ip);
    80003358:	854e                	mv	a0,s3
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	adc080e7          	jalr	-1316(ra) # 80002e36 <iput>
    return 0;
    80003362:	4981                	li	s3,0
    80003364:	bf19                	j	8000327a <namex+0x6a>
  if(*path == 0)
    80003366:	d7fd                	beqz	a5,80003354 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003368:	0004c783          	lbu	a5,0(s1)
    8000336c:	85a6                	mv	a1,s1
    8000336e:	b7d1                	j	80003332 <namex+0x122>

0000000080003370 <dirlink>:
{
    80003370:	7139                	addi	sp,sp,-64
    80003372:	fc06                	sd	ra,56(sp)
    80003374:	f822                	sd	s0,48(sp)
    80003376:	f426                	sd	s1,40(sp)
    80003378:	f04a                	sd	s2,32(sp)
    8000337a:	ec4e                	sd	s3,24(sp)
    8000337c:	e852                	sd	s4,16(sp)
    8000337e:	0080                	addi	s0,sp,64
    80003380:	892a                	mv	s2,a0
    80003382:	8a2e                	mv	s4,a1
    80003384:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003386:	4601                	li	a2,0
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	dd8080e7          	jalr	-552(ra) # 80003160 <dirlookup>
    80003390:	e93d                	bnez	a0,80003406 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003392:	04c92483          	lw	s1,76(s2)
    80003396:	c49d                	beqz	s1,800033c4 <dirlink+0x54>
    80003398:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000339a:	4741                	li	a4,16
    8000339c:	86a6                	mv	a3,s1
    8000339e:	fc040613          	addi	a2,s0,-64
    800033a2:	4581                	li	a1,0
    800033a4:	854a                	mv	a0,s2
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	b8a080e7          	jalr	-1142(ra) # 80002f30 <readi>
    800033ae:	47c1                	li	a5,16
    800033b0:	06f51163          	bne	a0,a5,80003412 <dirlink+0xa2>
    if(de.inum == 0)
    800033b4:	fc045783          	lhu	a5,-64(s0)
    800033b8:	c791                	beqz	a5,800033c4 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033ba:	24c1                	addiw	s1,s1,16
    800033bc:	04c92783          	lw	a5,76(s2)
    800033c0:	fcf4ede3          	bltu	s1,a5,8000339a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800033c4:	4639                	li	a2,14
    800033c6:	85d2                	mv	a1,s4
    800033c8:	fc240513          	addi	a0,s0,-62
    800033cc:	ffffd097          	auipc	ra,0xffffd
    800033d0:	ee6080e7          	jalr	-282(ra) # 800002b2 <strncpy>
  de.inum = inum;
    800033d4:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033d8:	4741                	li	a4,16
    800033da:	86a6                	mv	a3,s1
    800033dc:	fc040613          	addi	a2,s0,-64
    800033e0:	4581                	li	a1,0
    800033e2:	854a                	mv	a0,s2
    800033e4:	00000097          	auipc	ra,0x0
    800033e8:	c44080e7          	jalr	-956(ra) # 80003028 <writei>
    800033ec:	1541                	addi	a0,a0,-16
    800033ee:	00a03533          	snez	a0,a0
    800033f2:	40a00533          	neg	a0,a0
}
    800033f6:	70e2                	ld	ra,56(sp)
    800033f8:	7442                	ld	s0,48(sp)
    800033fa:	74a2                	ld	s1,40(sp)
    800033fc:	7902                	ld	s2,32(sp)
    800033fe:	69e2                	ld	s3,24(sp)
    80003400:	6a42                	ld	s4,16(sp)
    80003402:	6121                	addi	sp,sp,64
    80003404:	8082                	ret
    iput(ip);
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	a30080e7          	jalr	-1488(ra) # 80002e36 <iput>
    return -1;
    8000340e:	557d                	li	a0,-1
    80003410:	b7dd                	j	800033f6 <dirlink+0x86>
      panic("dirlink read");
    80003412:	00005517          	auipc	a0,0x5
    80003416:	27e50513          	addi	a0,a0,638 # 80008690 <syscalls+0x1e0>
    8000341a:	00003097          	auipc	ra,0x3
    8000341e:	968080e7          	jalr	-1688(ra) # 80005d82 <panic>

0000000080003422 <namei>:

struct inode*
namei(char *path)
{
    80003422:	1101                	addi	sp,sp,-32
    80003424:	ec06                	sd	ra,24(sp)
    80003426:	e822                	sd	s0,16(sp)
    80003428:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000342a:	fe040613          	addi	a2,s0,-32
    8000342e:	4581                	li	a1,0
    80003430:	00000097          	auipc	ra,0x0
    80003434:	de0080e7          	jalr	-544(ra) # 80003210 <namex>
}
    80003438:	60e2                	ld	ra,24(sp)
    8000343a:	6442                	ld	s0,16(sp)
    8000343c:	6105                	addi	sp,sp,32
    8000343e:	8082                	ret

0000000080003440 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003440:	1141                	addi	sp,sp,-16
    80003442:	e406                	sd	ra,8(sp)
    80003444:	e022                	sd	s0,0(sp)
    80003446:	0800                	addi	s0,sp,16
    80003448:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000344a:	4585                	li	a1,1
    8000344c:	00000097          	auipc	ra,0x0
    80003450:	dc4080e7          	jalr	-572(ra) # 80003210 <namex>
}
    80003454:	60a2                	ld	ra,8(sp)
    80003456:	6402                	ld	s0,0(sp)
    80003458:	0141                	addi	sp,sp,16
    8000345a:	8082                	ret

000000008000345c <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000345c:	1101                	addi	sp,sp,-32
    8000345e:	ec06                	sd	ra,24(sp)
    80003460:	e822                	sd	s0,16(sp)
    80003462:	e426                	sd	s1,8(sp)
    80003464:	e04a                	sd	s2,0(sp)
    80003466:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003468:	00016917          	auipc	s2,0x16
    8000346c:	81890913          	addi	s2,s2,-2024 # 80018c80 <log>
    80003470:	01892583          	lw	a1,24(s2)
    80003474:	02892503          	lw	a0,40(s2)
    80003478:	fffff097          	auipc	ra,0xfffff
    8000347c:	fea080e7          	jalr	-22(ra) # 80002462 <bread>
    80003480:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003482:	02c92683          	lw	a3,44(s2)
    80003486:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003488:	02d05763          	blez	a3,800034b6 <write_head+0x5a>
    8000348c:	00016797          	auipc	a5,0x16
    80003490:	82478793          	addi	a5,a5,-2012 # 80018cb0 <log+0x30>
    80003494:	05c50713          	addi	a4,a0,92
    80003498:	36fd                	addiw	a3,a3,-1
    8000349a:	1682                	slli	a3,a3,0x20
    8000349c:	9281                	srli	a3,a3,0x20
    8000349e:	068a                	slli	a3,a3,0x2
    800034a0:	00016617          	auipc	a2,0x16
    800034a4:	81460613          	addi	a2,a2,-2028 # 80018cb4 <log+0x34>
    800034a8:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034aa:	4390                	lw	a2,0(a5)
    800034ac:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034ae:	0791                	addi	a5,a5,4
    800034b0:	0711                	addi	a4,a4,4
    800034b2:	fed79ce3          	bne	a5,a3,800034aa <write_head+0x4e>
  }
  bwrite(buf);
    800034b6:	8526                	mv	a0,s1
    800034b8:	fffff097          	auipc	ra,0xfffff
    800034bc:	09c080e7          	jalr	156(ra) # 80002554 <bwrite>
  brelse(buf);
    800034c0:	8526                	mv	a0,s1
    800034c2:	fffff097          	auipc	ra,0xfffff
    800034c6:	0d0080e7          	jalr	208(ra) # 80002592 <brelse>
}
    800034ca:	60e2                	ld	ra,24(sp)
    800034cc:	6442                	ld	s0,16(sp)
    800034ce:	64a2                	ld	s1,8(sp)
    800034d0:	6902                	ld	s2,0(sp)
    800034d2:	6105                	addi	sp,sp,32
    800034d4:	8082                	ret

00000000800034d6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d6:	00015797          	auipc	a5,0x15
    800034da:	7d67a783          	lw	a5,2006(a5) # 80018cac <log+0x2c>
    800034de:	0af05d63          	blez	a5,80003598 <install_trans+0xc2>
{
    800034e2:	7139                	addi	sp,sp,-64
    800034e4:	fc06                	sd	ra,56(sp)
    800034e6:	f822                	sd	s0,48(sp)
    800034e8:	f426                	sd	s1,40(sp)
    800034ea:	f04a                	sd	s2,32(sp)
    800034ec:	ec4e                	sd	s3,24(sp)
    800034ee:	e852                	sd	s4,16(sp)
    800034f0:	e456                	sd	s5,8(sp)
    800034f2:	e05a                	sd	s6,0(sp)
    800034f4:	0080                	addi	s0,sp,64
    800034f6:	8b2a                	mv	s6,a0
    800034f8:	00015a97          	auipc	s5,0x15
    800034fc:	7b8a8a93          	addi	s5,s5,1976 # 80018cb0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003500:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003502:	00015997          	auipc	s3,0x15
    80003506:	77e98993          	addi	s3,s3,1918 # 80018c80 <log>
    8000350a:	a035                	j	80003536 <install_trans+0x60>
      bunpin(dbuf);
    8000350c:	8526                	mv	a0,s1
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	15e080e7          	jalr	350(ra) # 8000266c <bunpin>
    brelse(lbuf);
    80003516:	854a                	mv	a0,s2
    80003518:	fffff097          	auipc	ra,0xfffff
    8000351c:	07a080e7          	jalr	122(ra) # 80002592 <brelse>
    brelse(dbuf);
    80003520:	8526                	mv	a0,s1
    80003522:	fffff097          	auipc	ra,0xfffff
    80003526:	070080e7          	jalr	112(ra) # 80002592 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000352a:	2a05                	addiw	s4,s4,1
    8000352c:	0a91                	addi	s5,s5,4
    8000352e:	02c9a783          	lw	a5,44(s3)
    80003532:	04fa5963          	bge	s4,a5,80003584 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003536:	0189a583          	lw	a1,24(s3)
    8000353a:	014585bb          	addw	a1,a1,s4
    8000353e:	2585                	addiw	a1,a1,1
    80003540:	0289a503          	lw	a0,40(s3)
    80003544:	fffff097          	auipc	ra,0xfffff
    80003548:	f1e080e7          	jalr	-226(ra) # 80002462 <bread>
    8000354c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000354e:	000aa583          	lw	a1,0(s5)
    80003552:	0289a503          	lw	a0,40(s3)
    80003556:	fffff097          	auipc	ra,0xfffff
    8000355a:	f0c080e7          	jalr	-244(ra) # 80002462 <bread>
    8000355e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003560:	40000613          	li	a2,1024
    80003564:	05890593          	addi	a1,s2,88
    80003568:	05850513          	addi	a0,a0,88
    8000356c:	ffffd097          	auipc	ra,0xffffd
    80003570:	c92080e7          	jalr	-878(ra) # 800001fe <memmove>
    bwrite(dbuf);  // write dst to disk
    80003574:	8526                	mv	a0,s1
    80003576:	fffff097          	auipc	ra,0xfffff
    8000357a:	fde080e7          	jalr	-34(ra) # 80002554 <bwrite>
    if(recovering == 0)
    8000357e:	f80b1ce3          	bnez	s6,80003516 <install_trans+0x40>
    80003582:	b769                	j	8000350c <install_trans+0x36>
}
    80003584:	70e2                	ld	ra,56(sp)
    80003586:	7442                	ld	s0,48(sp)
    80003588:	74a2                	ld	s1,40(sp)
    8000358a:	7902                	ld	s2,32(sp)
    8000358c:	69e2                	ld	s3,24(sp)
    8000358e:	6a42                	ld	s4,16(sp)
    80003590:	6aa2                	ld	s5,8(sp)
    80003592:	6b02                	ld	s6,0(sp)
    80003594:	6121                	addi	sp,sp,64
    80003596:	8082                	ret
    80003598:	8082                	ret

000000008000359a <initlog>:
{
    8000359a:	7179                	addi	sp,sp,-48
    8000359c:	f406                	sd	ra,40(sp)
    8000359e:	f022                	sd	s0,32(sp)
    800035a0:	ec26                	sd	s1,24(sp)
    800035a2:	e84a                	sd	s2,16(sp)
    800035a4:	e44e                	sd	s3,8(sp)
    800035a6:	1800                	addi	s0,sp,48
    800035a8:	892a                	mv	s2,a0
    800035aa:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035ac:	00015497          	auipc	s1,0x15
    800035b0:	6d448493          	addi	s1,s1,1748 # 80018c80 <log>
    800035b4:	00005597          	auipc	a1,0x5
    800035b8:	0ec58593          	addi	a1,a1,236 # 800086a0 <syscalls+0x1f0>
    800035bc:	8526                	mv	a0,s1
    800035be:	00003097          	auipc	ra,0x3
    800035c2:	c7e080e7          	jalr	-898(ra) # 8000623c <initlock>
  log.start = sb->logstart;
    800035c6:	0149a583          	lw	a1,20(s3)
    800035ca:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035cc:	0109a783          	lw	a5,16(s3)
    800035d0:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035d2:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035d6:	854a                	mv	a0,s2
    800035d8:	fffff097          	auipc	ra,0xfffff
    800035dc:	e8a080e7          	jalr	-374(ra) # 80002462 <bread>
  log.lh.n = lh->n;
    800035e0:	4d3c                	lw	a5,88(a0)
    800035e2:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035e4:	02f05563          	blez	a5,8000360e <initlog+0x74>
    800035e8:	05c50713          	addi	a4,a0,92
    800035ec:	00015697          	auipc	a3,0x15
    800035f0:	6c468693          	addi	a3,a3,1732 # 80018cb0 <log+0x30>
    800035f4:	37fd                	addiw	a5,a5,-1
    800035f6:	1782                	slli	a5,a5,0x20
    800035f8:	9381                	srli	a5,a5,0x20
    800035fa:	078a                	slli	a5,a5,0x2
    800035fc:	06050613          	addi	a2,a0,96
    80003600:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003602:	4310                	lw	a2,0(a4)
    80003604:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003606:	0711                	addi	a4,a4,4
    80003608:	0691                	addi	a3,a3,4
    8000360a:	fef71ce3          	bne	a4,a5,80003602 <initlog+0x68>
  brelse(buf);
    8000360e:	fffff097          	auipc	ra,0xfffff
    80003612:	f84080e7          	jalr	-124(ra) # 80002592 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003616:	4505                	li	a0,1
    80003618:	00000097          	auipc	ra,0x0
    8000361c:	ebe080e7          	jalr	-322(ra) # 800034d6 <install_trans>
  log.lh.n = 0;
    80003620:	00015797          	auipc	a5,0x15
    80003624:	6807a623          	sw	zero,1676(a5) # 80018cac <log+0x2c>
  write_head(); // clear the log
    80003628:	00000097          	auipc	ra,0x0
    8000362c:	e34080e7          	jalr	-460(ra) # 8000345c <write_head>
}
    80003630:	70a2                	ld	ra,40(sp)
    80003632:	7402                	ld	s0,32(sp)
    80003634:	64e2                	ld	s1,24(sp)
    80003636:	6942                	ld	s2,16(sp)
    80003638:	69a2                	ld	s3,8(sp)
    8000363a:	6145                	addi	sp,sp,48
    8000363c:	8082                	ret

000000008000363e <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000363e:	1101                	addi	sp,sp,-32
    80003640:	ec06                	sd	ra,24(sp)
    80003642:	e822                	sd	s0,16(sp)
    80003644:	e426                	sd	s1,8(sp)
    80003646:	e04a                	sd	s2,0(sp)
    80003648:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000364a:	00015517          	auipc	a0,0x15
    8000364e:	63650513          	addi	a0,a0,1590 # 80018c80 <log>
    80003652:	00003097          	auipc	ra,0x3
    80003656:	c7a080e7          	jalr	-902(ra) # 800062cc <acquire>
  while(1){
    if(log.committing){
    8000365a:	00015497          	auipc	s1,0x15
    8000365e:	62648493          	addi	s1,s1,1574 # 80018c80 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003662:	4979                	li	s2,30
    80003664:	a039                	j	80003672 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003666:	85a6                	mv	a1,s1
    80003668:	8526                	mv	a0,s1
    8000366a:	ffffe097          	auipc	ra,0xffffe
    8000366e:	ec0080e7          	jalr	-320(ra) # 8000152a <sleep>
    if(log.committing){
    80003672:	50dc                	lw	a5,36(s1)
    80003674:	fbed                	bnez	a5,80003666 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003676:	509c                	lw	a5,32(s1)
    80003678:	0017871b          	addiw	a4,a5,1
    8000367c:	0007069b          	sext.w	a3,a4
    80003680:	0027179b          	slliw	a5,a4,0x2
    80003684:	9fb9                	addw	a5,a5,a4
    80003686:	0017979b          	slliw	a5,a5,0x1
    8000368a:	54d8                	lw	a4,44(s1)
    8000368c:	9fb9                	addw	a5,a5,a4
    8000368e:	00f95963          	bge	s2,a5,800036a0 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003692:	85a6                	mv	a1,s1
    80003694:	8526                	mv	a0,s1
    80003696:	ffffe097          	auipc	ra,0xffffe
    8000369a:	e94080e7          	jalr	-364(ra) # 8000152a <sleep>
    8000369e:	bfd1                	j	80003672 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800036a0:	00015517          	auipc	a0,0x15
    800036a4:	5e050513          	addi	a0,a0,1504 # 80018c80 <log>
    800036a8:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036aa:	00003097          	auipc	ra,0x3
    800036ae:	cd6080e7          	jalr	-810(ra) # 80006380 <release>
      break;
    }
  }
}
    800036b2:	60e2                	ld	ra,24(sp)
    800036b4:	6442                	ld	s0,16(sp)
    800036b6:	64a2                	ld	s1,8(sp)
    800036b8:	6902                	ld	s2,0(sp)
    800036ba:	6105                	addi	sp,sp,32
    800036bc:	8082                	ret

00000000800036be <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036be:	7139                	addi	sp,sp,-64
    800036c0:	fc06                	sd	ra,56(sp)
    800036c2:	f822                	sd	s0,48(sp)
    800036c4:	f426                	sd	s1,40(sp)
    800036c6:	f04a                	sd	s2,32(sp)
    800036c8:	ec4e                	sd	s3,24(sp)
    800036ca:	e852                	sd	s4,16(sp)
    800036cc:	e456                	sd	s5,8(sp)
    800036ce:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036d0:	00015497          	auipc	s1,0x15
    800036d4:	5b048493          	addi	s1,s1,1456 # 80018c80 <log>
    800036d8:	8526                	mv	a0,s1
    800036da:	00003097          	auipc	ra,0x3
    800036de:	bf2080e7          	jalr	-1038(ra) # 800062cc <acquire>
  log.outstanding -= 1;
    800036e2:	509c                	lw	a5,32(s1)
    800036e4:	37fd                	addiw	a5,a5,-1
    800036e6:	0007891b          	sext.w	s2,a5
    800036ea:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036ec:	50dc                	lw	a5,36(s1)
    800036ee:	efb9                	bnez	a5,8000374c <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036f0:	06091663          	bnez	s2,8000375c <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036f4:	00015497          	auipc	s1,0x15
    800036f8:	58c48493          	addi	s1,s1,1420 # 80018c80 <log>
    800036fc:	4785                	li	a5,1
    800036fe:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003700:	8526                	mv	a0,s1
    80003702:	00003097          	auipc	ra,0x3
    80003706:	c7e080e7          	jalr	-898(ra) # 80006380 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000370a:	54dc                	lw	a5,44(s1)
    8000370c:	06f04763          	bgtz	a5,8000377a <end_op+0xbc>
    acquire(&log.lock);
    80003710:	00015497          	auipc	s1,0x15
    80003714:	57048493          	addi	s1,s1,1392 # 80018c80 <log>
    80003718:	8526                	mv	a0,s1
    8000371a:	00003097          	auipc	ra,0x3
    8000371e:	bb2080e7          	jalr	-1102(ra) # 800062cc <acquire>
    log.committing = 0;
    80003722:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003726:	8526                	mv	a0,s1
    80003728:	ffffe097          	auipc	ra,0xffffe
    8000372c:	e66080e7          	jalr	-410(ra) # 8000158e <wakeup>
    release(&log.lock);
    80003730:	8526                	mv	a0,s1
    80003732:	00003097          	auipc	ra,0x3
    80003736:	c4e080e7          	jalr	-946(ra) # 80006380 <release>
}
    8000373a:	70e2                	ld	ra,56(sp)
    8000373c:	7442                	ld	s0,48(sp)
    8000373e:	74a2                	ld	s1,40(sp)
    80003740:	7902                	ld	s2,32(sp)
    80003742:	69e2                	ld	s3,24(sp)
    80003744:	6a42                	ld	s4,16(sp)
    80003746:	6aa2                	ld	s5,8(sp)
    80003748:	6121                	addi	sp,sp,64
    8000374a:	8082                	ret
    panic("log.committing");
    8000374c:	00005517          	auipc	a0,0x5
    80003750:	f5c50513          	addi	a0,a0,-164 # 800086a8 <syscalls+0x1f8>
    80003754:	00002097          	auipc	ra,0x2
    80003758:	62e080e7          	jalr	1582(ra) # 80005d82 <panic>
    wakeup(&log);
    8000375c:	00015497          	auipc	s1,0x15
    80003760:	52448493          	addi	s1,s1,1316 # 80018c80 <log>
    80003764:	8526                	mv	a0,s1
    80003766:	ffffe097          	auipc	ra,0xffffe
    8000376a:	e28080e7          	jalr	-472(ra) # 8000158e <wakeup>
  release(&log.lock);
    8000376e:	8526                	mv	a0,s1
    80003770:	00003097          	auipc	ra,0x3
    80003774:	c10080e7          	jalr	-1008(ra) # 80006380 <release>
  if(do_commit){
    80003778:	b7c9                	j	8000373a <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000377a:	00015a97          	auipc	s5,0x15
    8000377e:	536a8a93          	addi	s5,s5,1334 # 80018cb0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003782:	00015a17          	auipc	s4,0x15
    80003786:	4fea0a13          	addi	s4,s4,1278 # 80018c80 <log>
    8000378a:	018a2583          	lw	a1,24(s4)
    8000378e:	012585bb          	addw	a1,a1,s2
    80003792:	2585                	addiw	a1,a1,1
    80003794:	028a2503          	lw	a0,40(s4)
    80003798:	fffff097          	auipc	ra,0xfffff
    8000379c:	cca080e7          	jalr	-822(ra) # 80002462 <bread>
    800037a0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037a2:	000aa583          	lw	a1,0(s5)
    800037a6:	028a2503          	lw	a0,40(s4)
    800037aa:	fffff097          	auipc	ra,0xfffff
    800037ae:	cb8080e7          	jalr	-840(ra) # 80002462 <bread>
    800037b2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037b4:	40000613          	li	a2,1024
    800037b8:	05850593          	addi	a1,a0,88
    800037bc:	05848513          	addi	a0,s1,88
    800037c0:	ffffd097          	auipc	ra,0xffffd
    800037c4:	a3e080e7          	jalr	-1474(ra) # 800001fe <memmove>
    bwrite(to);  // write the log
    800037c8:	8526                	mv	a0,s1
    800037ca:	fffff097          	auipc	ra,0xfffff
    800037ce:	d8a080e7          	jalr	-630(ra) # 80002554 <bwrite>
    brelse(from);
    800037d2:	854e                	mv	a0,s3
    800037d4:	fffff097          	auipc	ra,0xfffff
    800037d8:	dbe080e7          	jalr	-578(ra) # 80002592 <brelse>
    brelse(to);
    800037dc:	8526                	mv	a0,s1
    800037de:	fffff097          	auipc	ra,0xfffff
    800037e2:	db4080e7          	jalr	-588(ra) # 80002592 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037e6:	2905                	addiw	s2,s2,1
    800037e8:	0a91                	addi	s5,s5,4
    800037ea:	02ca2783          	lw	a5,44(s4)
    800037ee:	f8f94ee3          	blt	s2,a5,8000378a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037f2:	00000097          	auipc	ra,0x0
    800037f6:	c6a080e7          	jalr	-918(ra) # 8000345c <write_head>
    install_trans(0); // Now install writes to home locations
    800037fa:	4501                	li	a0,0
    800037fc:	00000097          	auipc	ra,0x0
    80003800:	cda080e7          	jalr	-806(ra) # 800034d6 <install_trans>
    log.lh.n = 0;
    80003804:	00015797          	auipc	a5,0x15
    80003808:	4a07a423          	sw	zero,1192(a5) # 80018cac <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000380c:	00000097          	auipc	ra,0x0
    80003810:	c50080e7          	jalr	-944(ra) # 8000345c <write_head>
    80003814:	bdf5                	j	80003710 <end_op+0x52>

0000000080003816 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003816:	1101                	addi	sp,sp,-32
    80003818:	ec06                	sd	ra,24(sp)
    8000381a:	e822                	sd	s0,16(sp)
    8000381c:	e426                	sd	s1,8(sp)
    8000381e:	e04a                	sd	s2,0(sp)
    80003820:	1000                	addi	s0,sp,32
    80003822:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003824:	00015917          	auipc	s2,0x15
    80003828:	45c90913          	addi	s2,s2,1116 # 80018c80 <log>
    8000382c:	854a                	mv	a0,s2
    8000382e:	00003097          	auipc	ra,0x3
    80003832:	a9e080e7          	jalr	-1378(ra) # 800062cc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003836:	02c92603          	lw	a2,44(s2)
    8000383a:	47f5                	li	a5,29
    8000383c:	06c7c563          	blt	a5,a2,800038a6 <log_write+0x90>
    80003840:	00015797          	auipc	a5,0x15
    80003844:	45c7a783          	lw	a5,1116(a5) # 80018c9c <log+0x1c>
    80003848:	37fd                	addiw	a5,a5,-1
    8000384a:	04f65e63          	bge	a2,a5,800038a6 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000384e:	00015797          	auipc	a5,0x15
    80003852:	4527a783          	lw	a5,1106(a5) # 80018ca0 <log+0x20>
    80003856:	06f05063          	blez	a5,800038b6 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000385a:	4781                	li	a5,0
    8000385c:	06c05563          	blez	a2,800038c6 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003860:	44cc                	lw	a1,12(s1)
    80003862:	00015717          	auipc	a4,0x15
    80003866:	44e70713          	addi	a4,a4,1102 # 80018cb0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000386a:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000386c:	4314                	lw	a3,0(a4)
    8000386e:	04b68c63          	beq	a3,a1,800038c6 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003872:	2785                	addiw	a5,a5,1
    80003874:	0711                	addi	a4,a4,4
    80003876:	fef61be3          	bne	a2,a5,8000386c <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000387a:	0621                	addi	a2,a2,8
    8000387c:	060a                	slli	a2,a2,0x2
    8000387e:	00015797          	auipc	a5,0x15
    80003882:	40278793          	addi	a5,a5,1026 # 80018c80 <log>
    80003886:	963e                	add	a2,a2,a5
    80003888:	44dc                	lw	a5,12(s1)
    8000388a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000388c:	8526                	mv	a0,s1
    8000388e:	fffff097          	auipc	ra,0xfffff
    80003892:	da2080e7          	jalr	-606(ra) # 80002630 <bpin>
    log.lh.n++;
    80003896:	00015717          	auipc	a4,0x15
    8000389a:	3ea70713          	addi	a4,a4,1002 # 80018c80 <log>
    8000389e:	575c                	lw	a5,44(a4)
    800038a0:	2785                	addiw	a5,a5,1
    800038a2:	d75c                	sw	a5,44(a4)
    800038a4:	a835                	j	800038e0 <log_write+0xca>
    panic("too big a transaction");
    800038a6:	00005517          	auipc	a0,0x5
    800038aa:	e1250513          	addi	a0,a0,-494 # 800086b8 <syscalls+0x208>
    800038ae:	00002097          	auipc	ra,0x2
    800038b2:	4d4080e7          	jalr	1236(ra) # 80005d82 <panic>
    panic("log_write outside of trans");
    800038b6:	00005517          	auipc	a0,0x5
    800038ba:	e1a50513          	addi	a0,a0,-486 # 800086d0 <syscalls+0x220>
    800038be:	00002097          	auipc	ra,0x2
    800038c2:	4c4080e7          	jalr	1220(ra) # 80005d82 <panic>
  log.lh.block[i] = b->blockno;
    800038c6:	00878713          	addi	a4,a5,8
    800038ca:	00271693          	slli	a3,a4,0x2
    800038ce:	00015717          	auipc	a4,0x15
    800038d2:	3b270713          	addi	a4,a4,946 # 80018c80 <log>
    800038d6:	9736                	add	a4,a4,a3
    800038d8:	44d4                	lw	a3,12(s1)
    800038da:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038dc:	faf608e3          	beq	a2,a5,8000388c <log_write+0x76>
  }
  release(&log.lock);
    800038e0:	00015517          	auipc	a0,0x15
    800038e4:	3a050513          	addi	a0,a0,928 # 80018c80 <log>
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	a98080e7          	jalr	-1384(ra) # 80006380 <release>
}
    800038f0:	60e2                	ld	ra,24(sp)
    800038f2:	6442                	ld	s0,16(sp)
    800038f4:	64a2                	ld	s1,8(sp)
    800038f6:	6902                	ld	s2,0(sp)
    800038f8:	6105                	addi	sp,sp,32
    800038fa:	8082                	ret

00000000800038fc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038fc:	1101                	addi	sp,sp,-32
    800038fe:	ec06                	sd	ra,24(sp)
    80003900:	e822                	sd	s0,16(sp)
    80003902:	e426                	sd	s1,8(sp)
    80003904:	e04a                	sd	s2,0(sp)
    80003906:	1000                	addi	s0,sp,32
    80003908:	84aa                	mv	s1,a0
    8000390a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000390c:	00005597          	auipc	a1,0x5
    80003910:	de458593          	addi	a1,a1,-540 # 800086f0 <syscalls+0x240>
    80003914:	0521                	addi	a0,a0,8
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	926080e7          	jalr	-1754(ra) # 8000623c <initlock>
  lk->name = name;
    8000391e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003922:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003926:	0204a423          	sw	zero,40(s1)
}
    8000392a:	60e2                	ld	ra,24(sp)
    8000392c:	6442                	ld	s0,16(sp)
    8000392e:	64a2                	ld	s1,8(sp)
    80003930:	6902                	ld	s2,0(sp)
    80003932:	6105                	addi	sp,sp,32
    80003934:	8082                	ret

0000000080003936 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003936:	1101                	addi	sp,sp,-32
    80003938:	ec06                	sd	ra,24(sp)
    8000393a:	e822                	sd	s0,16(sp)
    8000393c:	e426                	sd	s1,8(sp)
    8000393e:	e04a                	sd	s2,0(sp)
    80003940:	1000                	addi	s0,sp,32
    80003942:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003944:	00850913          	addi	s2,a0,8
    80003948:	854a                	mv	a0,s2
    8000394a:	00003097          	auipc	ra,0x3
    8000394e:	982080e7          	jalr	-1662(ra) # 800062cc <acquire>
  while (lk->locked) {
    80003952:	409c                	lw	a5,0(s1)
    80003954:	cb89                	beqz	a5,80003966 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003956:	85ca                	mv	a1,s2
    80003958:	8526                	mv	a0,s1
    8000395a:	ffffe097          	auipc	ra,0xffffe
    8000395e:	bd0080e7          	jalr	-1072(ra) # 8000152a <sleep>
  while (lk->locked) {
    80003962:	409c                	lw	a5,0(s1)
    80003964:	fbed                	bnez	a5,80003956 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003966:	4785                	li	a5,1
    80003968:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000396a:	ffffd097          	auipc	ra,0xffffd
    8000396e:	514080e7          	jalr	1300(ra) # 80000e7e <myproc>
    80003972:	591c                	lw	a5,48(a0)
    80003974:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003976:	854a                	mv	a0,s2
    80003978:	00003097          	auipc	ra,0x3
    8000397c:	a08080e7          	jalr	-1528(ra) # 80006380 <release>
}
    80003980:	60e2                	ld	ra,24(sp)
    80003982:	6442                	ld	s0,16(sp)
    80003984:	64a2                	ld	s1,8(sp)
    80003986:	6902                	ld	s2,0(sp)
    80003988:	6105                	addi	sp,sp,32
    8000398a:	8082                	ret

000000008000398c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000398c:	1101                	addi	sp,sp,-32
    8000398e:	ec06                	sd	ra,24(sp)
    80003990:	e822                	sd	s0,16(sp)
    80003992:	e426                	sd	s1,8(sp)
    80003994:	e04a                	sd	s2,0(sp)
    80003996:	1000                	addi	s0,sp,32
    80003998:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000399a:	00850913          	addi	s2,a0,8
    8000399e:	854a                	mv	a0,s2
    800039a0:	00003097          	auipc	ra,0x3
    800039a4:	92c080e7          	jalr	-1748(ra) # 800062cc <acquire>
  lk->locked = 0;
    800039a8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039ac:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039b0:	8526                	mv	a0,s1
    800039b2:	ffffe097          	auipc	ra,0xffffe
    800039b6:	bdc080e7          	jalr	-1060(ra) # 8000158e <wakeup>
  release(&lk->lk);
    800039ba:	854a                	mv	a0,s2
    800039bc:	00003097          	auipc	ra,0x3
    800039c0:	9c4080e7          	jalr	-1596(ra) # 80006380 <release>
}
    800039c4:	60e2                	ld	ra,24(sp)
    800039c6:	6442                	ld	s0,16(sp)
    800039c8:	64a2                	ld	s1,8(sp)
    800039ca:	6902                	ld	s2,0(sp)
    800039cc:	6105                	addi	sp,sp,32
    800039ce:	8082                	ret

00000000800039d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039d0:	7179                	addi	sp,sp,-48
    800039d2:	f406                	sd	ra,40(sp)
    800039d4:	f022                	sd	s0,32(sp)
    800039d6:	ec26                	sd	s1,24(sp)
    800039d8:	e84a                	sd	s2,16(sp)
    800039da:	e44e                	sd	s3,8(sp)
    800039dc:	1800                	addi	s0,sp,48
    800039de:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039e0:	00850913          	addi	s2,a0,8
    800039e4:	854a                	mv	a0,s2
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	8e6080e7          	jalr	-1818(ra) # 800062cc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ee:	409c                	lw	a5,0(s1)
    800039f0:	ef99                	bnez	a5,80003a0e <holdingsleep+0x3e>
    800039f2:	4481                	li	s1,0
  release(&lk->lk);
    800039f4:	854a                	mv	a0,s2
    800039f6:	00003097          	auipc	ra,0x3
    800039fa:	98a080e7          	jalr	-1654(ra) # 80006380 <release>
  return r;
}
    800039fe:	8526                	mv	a0,s1
    80003a00:	70a2                	ld	ra,40(sp)
    80003a02:	7402                	ld	s0,32(sp)
    80003a04:	64e2                	ld	s1,24(sp)
    80003a06:	6942                	ld	s2,16(sp)
    80003a08:	69a2                	ld	s3,8(sp)
    80003a0a:	6145                	addi	sp,sp,48
    80003a0c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a0e:	0284a983          	lw	s3,40(s1)
    80003a12:	ffffd097          	auipc	ra,0xffffd
    80003a16:	46c080e7          	jalr	1132(ra) # 80000e7e <myproc>
    80003a1a:	5904                	lw	s1,48(a0)
    80003a1c:	413484b3          	sub	s1,s1,s3
    80003a20:	0014b493          	seqz	s1,s1
    80003a24:	bfc1                	j	800039f4 <holdingsleep+0x24>

0000000080003a26 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a26:	1141                	addi	sp,sp,-16
    80003a28:	e406                	sd	ra,8(sp)
    80003a2a:	e022                	sd	s0,0(sp)
    80003a2c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a2e:	00005597          	auipc	a1,0x5
    80003a32:	cd258593          	addi	a1,a1,-814 # 80008700 <syscalls+0x250>
    80003a36:	00015517          	auipc	a0,0x15
    80003a3a:	39250513          	addi	a0,a0,914 # 80018dc8 <ftable>
    80003a3e:	00002097          	auipc	ra,0x2
    80003a42:	7fe080e7          	jalr	2046(ra) # 8000623c <initlock>
}
    80003a46:	60a2                	ld	ra,8(sp)
    80003a48:	6402                	ld	s0,0(sp)
    80003a4a:	0141                	addi	sp,sp,16
    80003a4c:	8082                	ret

0000000080003a4e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a4e:	1101                	addi	sp,sp,-32
    80003a50:	ec06                	sd	ra,24(sp)
    80003a52:	e822                	sd	s0,16(sp)
    80003a54:	e426                	sd	s1,8(sp)
    80003a56:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a58:	00015517          	auipc	a0,0x15
    80003a5c:	37050513          	addi	a0,a0,880 # 80018dc8 <ftable>
    80003a60:	00003097          	auipc	ra,0x3
    80003a64:	86c080e7          	jalr	-1940(ra) # 800062cc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a68:	00015497          	auipc	s1,0x15
    80003a6c:	37848493          	addi	s1,s1,888 # 80018de0 <ftable+0x18>
    80003a70:	00016717          	auipc	a4,0x16
    80003a74:	31070713          	addi	a4,a4,784 # 80019d80 <disk>
    if(f->ref == 0){
    80003a78:	40dc                	lw	a5,4(s1)
    80003a7a:	cf99                	beqz	a5,80003a98 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a7c:	02848493          	addi	s1,s1,40
    80003a80:	fee49ce3          	bne	s1,a4,80003a78 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a84:	00015517          	auipc	a0,0x15
    80003a88:	34450513          	addi	a0,a0,836 # 80018dc8 <ftable>
    80003a8c:	00003097          	auipc	ra,0x3
    80003a90:	8f4080e7          	jalr	-1804(ra) # 80006380 <release>
  return 0;
    80003a94:	4481                	li	s1,0
    80003a96:	a819                	j	80003aac <filealloc+0x5e>
      f->ref = 1;
    80003a98:	4785                	li	a5,1
    80003a9a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a9c:	00015517          	auipc	a0,0x15
    80003aa0:	32c50513          	addi	a0,a0,812 # 80018dc8 <ftable>
    80003aa4:	00003097          	auipc	ra,0x3
    80003aa8:	8dc080e7          	jalr	-1828(ra) # 80006380 <release>
}
    80003aac:	8526                	mv	a0,s1
    80003aae:	60e2                	ld	ra,24(sp)
    80003ab0:	6442                	ld	s0,16(sp)
    80003ab2:	64a2                	ld	s1,8(sp)
    80003ab4:	6105                	addi	sp,sp,32
    80003ab6:	8082                	ret

0000000080003ab8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003ab8:	1101                	addi	sp,sp,-32
    80003aba:	ec06                	sd	ra,24(sp)
    80003abc:	e822                	sd	s0,16(sp)
    80003abe:	e426                	sd	s1,8(sp)
    80003ac0:	1000                	addi	s0,sp,32
    80003ac2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ac4:	00015517          	auipc	a0,0x15
    80003ac8:	30450513          	addi	a0,a0,772 # 80018dc8 <ftable>
    80003acc:	00003097          	auipc	ra,0x3
    80003ad0:	800080e7          	jalr	-2048(ra) # 800062cc <acquire>
  if(f->ref < 1)
    80003ad4:	40dc                	lw	a5,4(s1)
    80003ad6:	02f05263          	blez	a5,80003afa <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003ada:	2785                	addiw	a5,a5,1
    80003adc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ade:	00015517          	auipc	a0,0x15
    80003ae2:	2ea50513          	addi	a0,a0,746 # 80018dc8 <ftable>
    80003ae6:	00003097          	auipc	ra,0x3
    80003aea:	89a080e7          	jalr	-1894(ra) # 80006380 <release>
  return f;
}
    80003aee:	8526                	mv	a0,s1
    80003af0:	60e2                	ld	ra,24(sp)
    80003af2:	6442                	ld	s0,16(sp)
    80003af4:	64a2                	ld	s1,8(sp)
    80003af6:	6105                	addi	sp,sp,32
    80003af8:	8082                	ret
    panic("filedup");
    80003afa:	00005517          	auipc	a0,0x5
    80003afe:	c0e50513          	addi	a0,a0,-1010 # 80008708 <syscalls+0x258>
    80003b02:	00002097          	auipc	ra,0x2
    80003b06:	280080e7          	jalr	640(ra) # 80005d82 <panic>

0000000080003b0a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b0a:	7139                	addi	sp,sp,-64
    80003b0c:	fc06                	sd	ra,56(sp)
    80003b0e:	f822                	sd	s0,48(sp)
    80003b10:	f426                	sd	s1,40(sp)
    80003b12:	f04a                	sd	s2,32(sp)
    80003b14:	ec4e                	sd	s3,24(sp)
    80003b16:	e852                	sd	s4,16(sp)
    80003b18:	e456                	sd	s5,8(sp)
    80003b1a:	0080                	addi	s0,sp,64
    80003b1c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b1e:	00015517          	auipc	a0,0x15
    80003b22:	2aa50513          	addi	a0,a0,682 # 80018dc8 <ftable>
    80003b26:	00002097          	auipc	ra,0x2
    80003b2a:	7a6080e7          	jalr	1958(ra) # 800062cc <acquire>
  if(f->ref < 1)
    80003b2e:	40dc                	lw	a5,4(s1)
    80003b30:	06f05163          	blez	a5,80003b92 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003b34:	37fd                	addiw	a5,a5,-1
    80003b36:	0007871b          	sext.w	a4,a5
    80003b3a:	c0dc                	sw	a5,4(s1)
    80003b3c:	06e04363          	bgtz	a4,80003ba2 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b40:	0004a903          	lw	s2,0(s1)
    80003b44:	0094ca83          	lbu	s5,9(s1)
    80003b48:	0104ba03          	ld	s4,16(s1)
    80003b4c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003b50:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b54:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b58:	00015517          	auipc	a0,0x15
    80003b5c:	27050513          	addi	a0,a0,624 # 80018dc8 <ftable>
    80003b60:	00003097          	auipc	ra,0x3
    80003b64:	820080e7          	jalr	-2016(ra) # 80006380 <release>

  if(ff.type == FD_PIPE){
    80003b68:	4785                	li	a5,1
    80003b6a:	04f90d63          	beq	s2,a5,80003bc4 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b6e:	3979                	addiw	s2,s2,-2
    80003b70:	4785                	li	a5,1
    80003b72:	0527e063          	bltu	a5,s2,80003bb2 <fileclose+0xa8>
    begin_op();
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	ac8080e7          	jalr	-1336(ra) # 8000363e <begin_op>
    iput(ff.ip);
    80003b7e:	854e                	mv	a0,s3
    80003b80:	fffff097          	auipc	ra,0xfffff
    80003b84:	2b6080e7          	jalr	694(ra) # 80002e36 <iput>
    end_op();
    80003b88:	00000097          	auipc	ra,0x0
    80003b8c:	b36080e7          	jalr	-1226(ra) # 800036be <end_op>
    80003b90:	a00d                	j	80003bb2 <fileclose+0xa8>
    panic("fileclose");
    80003b92:	00005517          	auipc	a0,0x5
    80003b96:	b7e50513          	addi	a0,a0,-1154 # 80008710 <syscalls+0x260>
    80003b9a:	00002097          	auipc	ra,0x2
    80003b9e:	1e8080e7          	jalr	488(ra) # 80005d82 <panic>
    release(&ftable.lock);
    80003ba2:	00015517          	auipc	a0,0x15
    80003ba6:	22650513          	addi	a0,a0,550 # 80018dc8 <ftable>
    80003baa:	00002097          	auipc	ra,0x2
    80003bae:	7d6080e7          	jalr	2006(ra) # 80006380 <release>
  }
}
    80003bb2:	70e2                	ld	ra,56(sp)
    80003bb4:	7442                	ld	s0,48(sp)
    80003bb6:	74a2                	ld	s1,40(sp)
    80003bb8:	7902                	ld	s2,32(sp)
    80003bba:	69e2                	ld	s3,24(sp)
    80003bbc:	6a42                	ld	s4,16(sp)
    80003bbe:	6aa2                	ld	s5,8(sp)
    80003bc0:	6121                	addi	sp,sp,64
    80003bc2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003bc4:	85d6                	mv	a1,s5
    80003bc6:	8552                	mv	a0,s4
    80003bc8:	00000097          	auipc	ra,0x0
    80003bcc:	34c080e7          	jalr	844(ra) # 80003f14 <pipeclose>
    80003bd0:	b7cd                	j	80003bb2 <fileclose+0xa8>

0000000080003bd2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bd2:	715d                	addi	sp,sp,-80
    80003bd4:	e486                	sd	ra,72(sp)
    80003bd6:	e0a2                	sd	s0,64(sp)
    80003bd8:	fc26                	sd	s1,56(sp)
    80003bda:	f84a                	sd	s2,48(sp)
    80003bdc:	f44e                	sd	s3,40(sp)
    80003bde:	0880                	addi	s0,sp,80
    80003be0:	84aa                	mv	s1,a0
    80003be2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003be4:	ffffd097          	auipc	ra,0xffffd
    80003be8:	29a080e7          	jalr	666(ra) # 80000e7e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bec:	409c                	lw	a5,0(s1)
    80003bee:	37f9                	addiw	a5,a5,-2
    80003bf0:	4705                	li	a4,1
    80003bf2:	04f76763          	bltu	a4,a5,80003c40 <filestat+0x6e>
    80003bf6:	892a                	mv	s2,a0
    ilock(f->ip);
    80003bf8:	6c88                	ld	a0,24(s1)
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	082080e7          	jalr	130(ra) # 80002c7c <ilock>
    stati(f->ip, &st);
    80003c02:	fb840593          	addi	a1,s0,-72
    80003c06:	6c88                	ld	a0,24(s1)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	2fe080e7          	jalr	766(ra) # 80002f06 <stati>
    iunlock(f->ip);
    80003c10:	6c88                	ld	a0,24(s1)
    80003c12:	fffff097          	auipc	ra,0xfffff
    80003c16:	12c080e7          	jalr	300(ra) # 80002d3e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c1a:	46e1                	li	a3,24
    80003c1c:	fb840613          	addi	a2,s0,-72
    80003c20:	85ce                	mv	a1,s3
    80003c22:	05093503          	ld	a0,80(s2)
    80003c26:	ffffd097          	auipc	ra,0xffffd
    80003c2a:	f16080e7          	jalr	-234(ra) # 80000b3c <copyout>
    80003c2e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003c32:	60a6                	ld	ra,72(sp)
    80003c34:	6406                	ld	s0,64(sp)
    80003c36:	74e2                	ld	s1,56(sp)
    80003c38:	7942                	ld	s2,48(sp)
    80003c3a:	79a2                	ld	s3,40(sp)
    80003c3c:	6161                	addi	sp,sp,80
    80003c3e:	8082                	ret
  return -1;
    80003c40:	557d                	li	a0,-1
    80003c42:	bfc5                	j	80003c32 <filestat+0x60>

0000000080003c44 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c44:	7179                	addi	sp,sp,-48
    80003c46:	f406                	sd	ra,40(sp)
    80003c48:	f022                	sd	s0,32(sp)
    80003c4a:	ec26                	sd	s1,24(sp)
    80003c4c:	e84a                	sd	s2,16(sp)
    80003c4e:	e44e                	sd	s3,8(sp)
    80003c50:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c52:	00854783          	lbu	a5,8(a0)
    80003c56:	c3d5                	beqz	a5,80003cfa <fileread+0xb6>
    80003c58:	84aa                	mv	s1,a0
    80003c5a:	89ae                	mv	s3,a1
    80003c5c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c5e:	411c                	lw	a5,0(a0)
    80003c60:	4705                	li	a4,1
    80003c62:	04e78963          	beq	a5,a4,80003cb4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c66:	470d                	li	a4,3
    80003c68:	04e78d63          	beq	a5,a4,80003cc2 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c6c:	4709                	li	a4,2
    80003c6e:	06e79e63          	bne	a5,a4,80003cea <fileread+0xa6>
    ilock(f->ip);
    80003c72:	6d08                	ld	a0,24(a0)
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	008080e7          	jalr	8(ra) # 80002c7c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c7c:	874a                	mv	a4,s2
    80003c7e:	5094                	lw	a3,32(s1)
    80003c80:	864e                	mv	a2,s3
    80003c82:	4585                	li	a1,1
    80003c84:	6c88                	ld	a0,24(s1)
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	2aa080e7          	jalr	682(ra) # 80002f30 <readi>
    80003c8e:	892a                	mv	s2,a0
    80003c90:	00a05563          	blez	a0,80003c9a <fileread+0x56>
      f->off += r;
    80003c94:	509c                	lw	a5,32(s1)
    80003c96:	9fa9                	addw	a5,a5,a0
    80003c98:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c9a:	6c88                	ld	a0,24(s1)
    80003c9c:	fffff097          	auipc	ra,0xfffff
    80003ca0:	0a2080e7          	jalr	162(ra) # 80002d3e <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003ca4:	854a                	mv	a0,s2
    80003ca6:	70a2                	ld	ra,40(sp)
    80003ca8:	7402                	ld	s0,32(sp)
    80003caa:	64e2                	ld	s1,24(sp)
    80003cac:	6942                	ld	s2,16(sp)
    80003cae:	69a2                	ld	s3,8(sp)
    80003cb0:	6145                	addi	sp,sp,48
    80003cb2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003cb4:	6908                	ld	a0,16(a0)
    80003cb6:	00000097          	auipc	ra,0x0
    80003cba:	3ce080e7          	jalr	974(ra) # 80004084 <piperead>
    80003cbe:	892a                	mv	s2,a0
    80003cc0:	b7d5                	j	80003ca4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cc2:	02451783          	lh	a5,36(a0)
    80003cc6:	03079693          	slli	a3,a5,0x30
    80003cca:	92c1                	srli	a3,a3,0x30
    80003ccc:	4725                	li	a4,9
    80003cce:	02d76863          	bltu	a4,a3,80003cfe <fileread+0xba>
    80003cd2:	0792                	slli	a5,a5,0x4
    80003cd4:	00015717          	auipc	a4,0x15
    80003cd8:	05470713          	addi	a4,a4,84 # 80018d28 <devsw>
    80003cdc:	97ba                	add	a5,a5,a4
    80003cde:	639c                	ld	a5,0(a5)
    80003ce0:	c38d                	beqz	a5,80003d02 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ce2:	4505                	li	a0,1
    80003ce4:	9782                	jalr	a5
    80003ce6:	892a                	mv	s2,a0
    80003ce8:	bf75                	j	80003ca4 <fileread+0x60>
    panic("fileread");
    80003cea:	00005517          	auipc	a0,0x5
    80003cee:	a3650513          	addi	a0,a0,-1482 # 80008720 <syscalls+0x270>
    80003cf2:	00002097          	auipc	ra,0x2
    80003cf6:	090080e7          	jalr	144(ra) # 80005d82 <panic>
    return -1;
    80003cfa:	597d                	li	s2,-1
    80003cfc:	b765                	j	80003ca4 <fileread+0x60>
      return -1;
    80003cfe:	597d                	li	s2,-1
    80003d00:	b755                	j	80003ca4 <fileread+0x60>
    80003d02:	597d                	li	s2,-1
    80003d04:	b745                	j	80003ca4 <fileread+0x60>

0000000080003d06 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003d06:	715d                	addi	sp,sp,-80
    80003d08:	e486                	sd	ra,72(sp)
    80003d0a:	e0a2                	sd	s0,64(sp)
    80003d0c:	fc26                	sd	s1,56(sp)
    80003d0e:	f84a                	sd	s2,48(sp)
    80003d10:	f44e                	sd	s3,40(sp)
    80003d12:	f052                	sd	s4,32(sp)
    80003d14:	ec56                	sd	s5,24(sp)
    80003d16:	e85a                	sd	s6,16(sp)
    80003d18:	e45e                	sd	s7,8(sp)
    80003d1a:	e062                	sd	s8,0(sp)
    80003d1c:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d1e:	00954783          	lbu	a5,9(a0)
    80003d22:	10078663          	beqz	a5,80003e2e <filewrite+0x128>
    80003d26:	892a                	mv	s2,a0
    80003d28:	8aae                	mv	s5,a1
    80003d2a:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d2c:	411c                	lw	a5,0(a0)
    80003d2e:	4705                	li	a4,1
    80003d30:	02e78263          	beq	a5,a4,80003d54 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d34:	470d                	li	a4,3
    80003d36:	02e78663          	beq	a5,a4,80003d62 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d3a:	4709                	li	a4,2
    80003d3c:	0ee79163          	bne	a5,a4,80003e1e <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d40:	0ac05d63          	blez	a2,80003dfa <filewrite+0xf4>
    int i = 0;
    80003d44:	4981                	li	s3,0
    80003d46:	6b05                	lui	s6,0x1
    80003d48:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d4c:	6b85                	lui	s7,0x1
    80003d4e:	c00b8b9b          	addiw	s7,s7,-1024
    80003d52:	a861                	j	80003dea <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d54:	6908                	ld	a0,16(a0)
    80003d56:	00000097          	auipc	ra,0x0
    80003d5a:	22e080e7          	jalr	558(ra) # 80003f84 <pipewrite>
    80003d5e:	8a2a                	mv	s4,a0
    80003d60:	a045                	j	80003e00 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d62:	02451783          	lh	a5,36(a0)
    80003d66:	03079693          	slli	a3,a5,0x30
    80003d6a:	92c1                	srli	a3,a3,0x30
    80003d6c:	4725                	li	a4,9
    80003d6e:	0cd76263          	bltu	a4,a3,80003e32 <filewrite+0x12c>
    80003d72:	0792                	slli	a5,a5,0x4
    80003d74:	00015717          	auipc	a4,0x15
    80003d78:	fb470713          	addi	a4,a4,-76 # 80018d28 <devsw>
    80003d7c:	97ba                	add	a5,a5,a4
    80003d7e:	679c                	ld	a5,8(a5)
    80003d80:	cbdd                	beqz	a5,80003e36 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d82:	4505                	li	a0,1
    80003d84:	9782                	jalr	a5
    80003d86:	8a2a                	mv	s4,a0
    80003d88:	a8a5                	j	80003e00 <filewrite+0xfa>
    80003d8a:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d8e:	00000097          	auipc	ra,0x0
    80003d92:	8b0080e7          	jalr	-1872(ra) # 8000363e <begin_op>
      ilock(f->ip);
    80003d96:	01893503          	ld	a0,24(s2)
    80003d9a:	fffff097          	auipc	ra,0xfffff
    80003d9e:	ee2080e7          	jalr	-286(ra) # 80002c7c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003da2:	8762                	mv	a4,s8
    80003da4:	02092683          	lw	a3,32(s2)
    80003da8:	01598633          	add	a2,s3,s5
    80003dac:	4585                	li	a1,1
    80003dae:	01893503          	ld	a0,24(s2)
    80003db2:	fffff097          	auipc	ra,0xfffff
    80003db6:	276080e7          	jalr	630(ra) # 80003028 <writei>
    80003dba:	84aa                	mv	s1,a0
    80003dbc:	00a05763          	blez	a0,80003dca <filewrite+0xc4>
        f->off += r;
    80003dc0:	02092783          	lw	a5,32(s2)
    80003dc4:	9fa9                	addw	a5,a5,a0
    80003dc6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003dca:	01893503          	ld	a0,24(s2)
    80003dce:	fffff097          	auipc	ra,0xfffff
    80003dd2:	f70080e7          	jalr	-144(ra) # 80002d3e <iunlock>
      end_op();
    80003dd6:	00000097          	auipc	ra,0x0
    80003dda:	8e8080e7          	jalr	-1816(ra) # 800036be <end_op>

      if(r != n1){
    80003dde:	009c1f63          	bne	s8,s1,80003dfc <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003de2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003de6:	0149db63          	bge	s3,s4,80003dfc <filewrite+0xf6>
      int n1 = n - i;
    80003dea:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003dee:	84be                	mv	s1,a5
    80003df0:	2781                	sext.w	a5,a5
    80003df2:	f8fb5ce3          	bge	s6,a5,80003d8a <filewrite+0x84>
    80003df6:	84de                	mv	s1,s7
    80003df8:	bf49                	j	80003d8a <filewrite+0x84>
    int i = 0;
    80003dfa:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003dfc:	013a1f63          	bne	s4,s3,80003e1a <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003e00:	8552                	mv	a0,s4
    80003e02:	60a6                	ld	ra,72(sp)
    80003e04:	6406                	ld	s0,64(sp)
    80003e06:	74e2                	ld	s1,56(sp)
    80003e08:	7942                	ld	s2,48(sp)
    80003e0a:	79a2                	ld	s3,40(sp)
    80003e0c:	7a02                	ld	s4,32(sp)
    80003e0e:	6ae2                	ld	s5,24(sp)
    80003e10:	6b42                	ld	s6,16(sp)
    80003e12:	6ba2                	ld	s7,8(sp)
    80003e14:	6c02                	ld	s8,0(sp)
    80003e16:	6161                	addi	sp,sp,80
    80003e18:	8082                	ret
    ret = (i == n ? n : -1);
    80003e1a:	5a7d                	li	s4,-1
    80003e1c:	b7d5                	j	80003e00 <filewrite+0xfa>
    panic("filewrite");
    80003e1e:	00005517          	auipc	a0,0x5
    80003e22:	91250513          	addi	a0,a0,-1774 # 80008730 <syscalls+0x280>
    80003e26:	00002097          	auipc	ra,0x2
    80003e2a:	f5c080e7          	jalr	-164(ra) # 80005d82 <panic>
    return -1;
    80003e2e:	5a7d                	li	s4,-1
    80003e30:	bfc1                	j	80003e00 <filewrite+0xfa>
      return -1;
    80003e32:	5a7d                	li	s4,-1
    80003e34:	b7f1                	j	80003e00 <filewrite+0xfa>
    80003e36:	5a7d                	li	s4,-1
    80003e38:	b7e1                	j	80003e00 <filewrite+0xfa>

0000000080003e3a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e3a:	7179                	addi	sp,sp,-48
    80003e3c:	f406                	sd	ra,40(sp)
    80003e3e:	f022                	sd	s0,32(sp)
    80003e40:	ec26                	sd	s1,24(sp)
    80003e42:	e84a                	sd	s2,16(sp)
    80003e44:	e44e                	sd	s3,8(sp)
    80003e46:	e052                	sd	s4,0(sp)
    80003e48:	1800                	addi	s0,sp,48
    80003e4a:	84aa                	mv	s1,a0
    80003e4c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e4e:	0005b023          	sd	zero,0(a1)
    80003e52:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e56:	00000097          	auipc	ra,0x0
    80003e5a:	bf8080e7          	jalr	-1032(ra) # 80003a4e <filealloc>
    80003e5e:	e088                	sd	a0,0(s1)
    80003e60:	c551                	beqz	a0,80003eec <pipealloc+0xb2>
    80003e62:	00000097          	auipc	ra,0x0
    80003e66:	bec080e7          	jalr	-1044(ra) # 80003a4e <filealloc>
    80003e6a:	00aa3023          	sd	a0,0(s4)
    80003e6e:	c92d                	beqz	a0,80003ee0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e70:	ffffc097          	auipc	ra,0xffffc
    80003e74:	2a8080e7          	jalr	680(ra) # 80000118 <kalloc>
    80003e78:	892a                	mv	s2,a0
    80003e7a:	c125                	beqz	a0,80003eda <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e7c:	4985                	li	s3,1
    80003e7e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e82:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e86:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e8a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e8e:	00004597          	auipc	a1,0x4
    80003e92:	55a58593          	addi	a1,a1,1370 # 800083e8 <states.1727+0x1a0>
    80003e96:	00002097          	auipc	ra,0x2
    80003e9a:	3a6080e7          	jalr	934(ra) # 8000623c <initlock>
  (*f0)->type = FD_PIPE;
    80003e9e:	609c                	ld	a5,0(s1)
    80003ea0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ea4:	609c                	ld	a5,0(s1)
    80003ea6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eaa:	609c                	ld	a5,0(s1)
    80003eac:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eb0:	609c                	ld	a5,0(s1)
    80003eb2:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eb6:	000a3783          	ld	a5,0(s4)
    80003eba:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ebe:	000a3783          	ld	a5,0(s4)
    80003ec2:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ec6:	000a3783          	ld	a5,0(s4)
    80003eca:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ece:	000a3783          	ld	a5,0(s4)
    80003ed2:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ed6:	4501                	li	a0,0
    80003ed8:	a025                	j	80003f00 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003eda:	6088                	ld	a0,0(s1)
    80003edc:	e501                	bnez	a0,80003ee4 <pipealloc+0xaa>
    80003ede:	a039                	j	80003eec <pipealloc+0xb2>
    80003ee0:	6088                	ld	a0,0(s1)
    80003ee2:	c51d                	beqz	a0,80003f10 <pipealloc+0xd6>
    fileclose(*f0);
    80003ee4:	00000097          	auipc	ra,0x0
    80003ee8:	c26080e7          	jalr	-986(ra) # 80003b0a <fileclose>
  if(*f1)
    80003eec:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ef0:	557d                	li	a0,-1
  if(*f1)
    80003ef2:	c799                	beqz	a5,80003f00 <pipealloc+0xc6>
    fileclose(*f1);
    80003ef4:	853e                	mv	a0,a5
    80003ef6:	00000097          	auipc	ra,0x0
    80003efa:	c14080e7          	jalr	-1004(ra) # 80003b0a <fileclose>
  return -1;
    80003efe:	557d                	li	a0,-1
}
    80003f00:	70a2                	ld	ra,40(sp)
    80003f02:	7402                	ld	s0,32(sp)
    80003f04:	64e2                	ld	s1,24(sp)
    80003f06:	6942                	ld	s2,16(sp)
    80003f08:	69a2                	ld	s3,8(sp)
    80003f0a:	6a02                	ld	s4,0(sp)
    80003f0c:	6145                	addi	sp,sp,48
    80003f0e:	8082                	ret
  return -1;
    80003f10:	557d                	li	a0,-1
    80003f12:	b7fd                	j	80003f00 <pipealloc+0xc6>

0000000080003f14 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f14:	1101                	addi	sp,sp,-32
    80003f16:	ec06                	sd	ra,24(sp)
    80003f18:	e822                	sd	s0,16(sp)
    80003f1a:	e426                	sd	s1,8(sp)
    80003f1c:	e04a                	sd	s2,0(sp)
    80003f1e:	1000                	addi	s0,sp,32
    80003f20:	84aa                	mv	s1,a0
    80003f22:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f24:	00002097          	auipc	ra,0x2
    80003f28:	3a8080e7          	jalr	936(ra) # 800062cc <acquire>
  if(writable){
    80003f2c:	02090d63          	beqz	s2,80003f66 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f30:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f34:	21848513          	addi	a0,s1,536
    80003f38:	ffffd097          	auipc	ra,0xffffd
    80003f3c:	656080e7          	jalr	1622(ra) # 8000158e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f40:	2204b783          	ld	a5,544(s1)
    80003f44:	eb95                	bnez	a5,80003f78 <pipeclose+0x64>
    release(&pi->lock);
    80003f46:	8526                	mv	a0,s1
    80003f48:	00002097          	auipc	ra,0x2
    80003f4c:	438080e7          	jalr	1080(ra) # 80006380 <release>
    kfree((char*)pi);
    80003f50:	8526                	mv	a0,s1
    80003f52:	ffffc097          	auipc	ra,0xffffc
    80003f56:	0ca080e7          	jalr	202(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f5a:	60e2                	ld	ra,24(sp)
    80003f5c:	6442                	ld	s0,16(sp)
    80003f5e:	64a2                	ld	s1,8(sp)
    80003f60:	6902                	ld	s2,0(sp)
    80003f62:	6105                	addi	sp,sp,32
    80003f64:	8082                	ret
    pi->readopen = 0;
    80003f66:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f6a:	21c48513          	addi	a0,s1,540
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	620080e7          	jalr	1568(ra) # 8000158e <wakeup>
    80003f76:	b7e9                	j	80003f40 <pipeclose+0x2c>
    release(&pi->lock);
    80003f78:	8526                	mv	a0,s1
    80003f7a:	00002097          	auipc	ra,0x2
    80003f7e:	406080e7          	jalr	1030(ra) # 80006380 <release>
}
    80003f82:	bfe1                	j	80003f5a <pipeclose+0x46>

0000000080003f84 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f84:	7159                	addi	sp,sp,-112
    80003f86:	f486                	sd	ra,104(sp)
    80003f88:	f0a2                	sd	s0,96(sp)
    80003f8a:	eca6                	sd	s1,88(sp)
    80003f8c:	e8ca                	sd	s2,80(sp)
    80003f8e:	e4ce                	sd	s3,72(sp)
    80003f90:	e0d2                	sd	s4,64(sp)
    80003f92:	fc56                	sd	s5,56(sp)
    80003f94:	f85a                	sd	s6,48(sp)
    80003f96:	f45e                	sd	s7,40(sp)
    80003f98:	f062                	sd	s8,32(sp)
    80003f9a:	ec66                	sd	s9,24(sp)
    80003f9c:	1880                	addi	s0,sp,112
    80003f9e:	84aa                	mv	s1,a0
    80003fa0:	8aae                	mv	s5,a1
    80003fa2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fa4:	ffffd097          	auipc	ra,0xffffd
    80003fa8:	eda080e7          	jalr	-294(ra) # 80000e7e <myproc>
    80003fac:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fae:	8526                	mv	a0,s1
    80003fb0:	00002097          	auipc	ra,0x2
    80003fb4:	31c080e7          	jalr	796(ra) # 800062cc <acquire>
  while(i < n){
    80003fb8:	0d405463          	blez	s4,80004080 <pipewrite+0xfc>
    80003fbc:	8ba6                	mv	s7,s1
  int i = 0;
    80003fbe:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fc2:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fc6:	21c48c13          	addi	s8,s1,540
    80003fca:	a08d                	j	8000402c <pipewrite+0xa8>
      release(&pi->lock);
    80003fcc:	8526                	mv	a0,s1
    80003fce:	00002097          	auipc	ra,0x2
    80003fd2:	3b2080e7          	jalr	946(ra) # 80006380 <release>
      return -1;
    80003fd6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fd8:	854a                	mv	a0,s2
    80003fda:	70a6                	ld	ra,104(sp)
    80003fdc:	7406                	ld	s0,96(sp)
    80003fde:	64e6                	ld	s1,88(sp)
    80003fe0:	6946                	ld	s2,80(sp)
    80003fe2:	69a6                	ld	s3,72(sp)
    80003fe4:	6a06                	ld	s4,64(sp)
    80003fe6:	7ae2                	ld	s5,56(sp)
    80003fe8:	7b42                	ld	s6,48(sp)
    80003fea:	7ba2                	ld	s7,40(sp)
    80003fec:	7c02                	ld	s8,32(sp)
    80003fee:	6ce2                	ld	s9,24(sp)
    80003ff0:	6165                	addi	sp,sp,112
    80003ff2:	8082                	ret
      wakeup(&pi->nread);
    80003ff4:	8566                	mv	a0,s9
    80003ff6:	ffffd097          	auipc	ra,0xffffd
    80003ffa:	598080e7          	jalr	1432(ra) # 8000158e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ffe:	85de                	mv	a1,s7
    80004000:	8562                	mv	a0,s8
    80004002:	ffffd097          	auipc	ra,0xffffd
    80004006:	528080e7          	jalr	1320(ra) # 8000152a <sleep>
    8000400a:	a839                	j	80004028 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000400c:	21c4a783          	lw	a5,540(s1)
    80004010:	0017871b          	addiw	a4,a5,1
    80004014:	20e4ae23          	sw	a4,540(s1)
    80004018:	1ff7f793          	andi	a5,a5,511
    8000401c:	97a6                	add	a5,a5,s1
    8000401e:	f9f44703          	lbu	a4,-97(s0)
    80004022:	00e78c23          	sb	a4,24(a5)
      i++;
    80004026:	2905                	addiw	s2,s2,1
  while(i < n){
    80004028:	05495063          	bge	s2,s4,80004068 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    8000402c:	2204a783          	lw	a5,544(s1)
    80004030:	dfd1                	beqz	a5,80003fcc <pipewrite+0x48>
    80004032:	854e                	mv	a0,s3
    80004034:	ffffd097          	auipc	ra,0xffffd
    80004038:	79e080e7          	jalr	1950(ra) # 800017d2 <killed>
    8000403c:	f941                	bnez	a0,80003fcc <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000403e:	2184a783          	lw	a5,536(s1)
    80004042:	21c4a703          	lw	a4,540(s1)
    80004046:	2007879b          	addiw	a5,a5,512
    8000404a:	faf705e3          	beq	a4,a5,80003ff4 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000404e:	4685                	li	a3,1
    80004050:	01590633          	add	a2,s2,s5
    80004054:	f9f40593          	addi	a1,s0,-97
    80004058:	0509b503          	ld	a0,80(s3)
    8000405c:	ffffd097          	auipc	ra,0xffffd
    80004060:	b6c080e7          	jalr	-1172(ra) # 80000bc8 <copyin>
    80004064:	fb6514e3          	bne	a0,s6,8000400c <pipewrite+0x88>
  wakeup(&pi->nread);
    80004068:	21848513          	addi	a0,s1,536
    8000406c:	ffffd097          	auipc	ra,0xffffd
    80004070:	522080e7          	jalr	1314(ra) # 8000158e <wakeup>
  release(&pi->lock);
    80004074:	8526                	mv	a0,s1
    80004076:	00002097          	auipc	ra,0x2
    8000407a:	30a080e7          	jalr	778(ra) # 80006380 <release>
  return i;
    8000407e:	bfa9                	j	80003fd8 <pipewrite+0x54>
  int i = 0;
    80004080:	4901                	li	s2,0
    80004082:	b7dd                	j	80004068 <pipewrite+0xe4>

0000000080004084 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004084:	715d                	addi	sp,sp,-80
    80004086:	e486                	sd	ra,72(sp)
    80004088:	e0a2                	sd	s0,64(sp)
    8000408a:	fc26                	sd	s1,56(sp)
    8000408c:	f84a                	sd	s2,48(sp)
    8000408e:	f44e                	sd	s3,40(sp)
    80004090:	f052                	sd	s4,32(sp)
    80004092:	ec56                	sd	s5,24(sp)
    80004094:	e85a                	sd	s6,16(sp)
    80004096:	0880                	addi	s0,sp,80
    80004098:	84aa                	mv	s1,a0
    8000409a:	892e                	mv	s2,a1
    8000409c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000409e:	ffffd097          	auipc	ra,0xffffd
    800040a2:	de0080e7          	jalr	-544(ra) # 80000e7e <myproc>
    800040a6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040a8:	8b26                	mv	s6,s1
    800040aa:	8526                	mv	a0,s1
    800040ac:	00002097          	auipc	ra,0x2
    800040b0:	220080e7          	jalr	544(ra) # 800062cc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b4:	2184a703          	lw	a4,536(s1)
    800040b8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040bc:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040c0:	02f71763          	bne	a4,a5,800040ee <piperead+0x6a>
    800040c4:	2244a783          	lw	a5,548(s1)
    800040c8:	c39d                	beqz	a5,800040ee <piperead+0x6a>
    if(killed(pr)){
    800040ca:	8552                	mv	a0,s4
    800040cc:	ffffd097          	auipc	ra,0xffffd
    800040d0:	706080e7          	jalr	1798(ra) # 800017d2 <killed>
    800040d4:	e941                	bnez	a0,80004164 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040d6:	85da                	mv	a1,s6
    800040d8:	854e                	mv	a0,s3
    800040da:	ffffd097          	auipc	ra,0xffffd
    800040de:	450080e7          	jalr	1104(ra) # 8000152a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040e2:	2184a703          	lw	a4,536(s1)
    800040e6:	21c4a783          	lw	a5,540(s1)
    800040ea:	fcf70de3          	beq	a4,a5,800040c4 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ee:	09505263          	blez	s5,80004172 <piperead+0xee>
    800040f2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f4:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040f6:	2184a783          	lw	a5,536(s1)
    800040fa:	21c4a703          	lw	a4,540(s1)
    800040fe:	02f70d63          	beq	a4,a5,80004138 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004102:	0017871b          	addiw	a4,a5,1
    80004106:	20e4ac23          	sw	a4,536(s1)
    8000410a:	1ff7f793          	andi	a5,a5,511
    8000410e:	97a6                	add	a5,a5,s1
    80004110:	0187c783          	lbu	a5,24(a5)
    80004114:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004118:	4685                	li	a3,1
    8000411a:	fbf40613          	addi	a2,s0,-65
    8000411e:	85ca                	mv	a1,s2
    80004120:	050a3503          	ld	a0,80(s4)
    80004124:	ffffd097          	auipc	ra,0xffffd
    80004128:	a18080e7          	jalr	-1512(ra) # 80000b3c <copyout>
    8000412c:	01650663          	beq	a0,s6,80004138 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004130:	2985                	addiw	s3,s3,1
    80004132:	0905                	addi	s2,s2,1
    80004134:	fd3a91e3          	bne	s5,s3,800040f6 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004138:	21c48513          	addi	a0,s1,540
    8000413c:	ffffd097          	auipc	ra,0xffffd
    80004140:	452080e7          	jalr	1106(ra) # 8000158e <wakeup>
  release(&pi->lock);
    80004144:	8526                	mv	a0,s1
    80004146:	00002097          	auipc	ra,0x2
    8000414a:	23a080e7          	jalr	570(ra) # 80006380 <release>
  return i;
}
    8000414e:	854e                	mv	a0,s3
    80004150:	60a6                	ld	ra,72(sp)
    80004152:	6406                	ld	s0,64(sp)
    80004154:	74e2                	ld	s1,56(sp)
    80004156:	7942                	ld	s2,48(sp)
    80004158:	79a2                	ld	s3,40(sp)
    8000415a:	7a02                	ld	s4,32(sp)
    8000415c:	6ae2                	ld	s5,24(sp)
    8000415e:	6b42                	ld	s6,16(sp)
    80004160:	6161                	addi	sp,sp,80
    80004162:	8082                	ret
      release(&pi->lock);
    80004164:	8526                	mv	a0,s1
    80004166:	00002097          	auipc	ra,0x2
    8000416a:	21a080e7          	jalr	538(ra) # 80006380 <release>
      return -1;
    8000416e:	59fd                	li	s3,-1
    80004170:	bff9                	j	8000414e <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004172:	4981                	li	s3,0
    80004174:	b7d1                	j	80004138 <piperead+0xb4>

0000000080004176 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004176:	1141                	addi	sp,sp,-16
    80004178:	e422                	sd	s0,8(sp)
    8000417a:	0800                	addi	s0,sp,16
    8000417c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000417e:	8905                	andi	a0,a0,1
    80004180:	c111                	beqz	a0,80004184 <flags2perm+0xe>
      perm = PTE_X;
    80004182:	4521                	li	a0,8
    if(flags & 0x2)
    80004184:	8b89                	andi	a5,a5,2
    80004186:	c399                	beqz	a5,8000418c <flags2perm+0x16>
      perm |= PTE_W;
    80004188:	00456513          	ori	a0,a0,4
    return perm;
}
    8000418c:	6422                	ld	s0,8(sp)
    8000418e:	0141                	addi	sp,sp,16
    80004190:	8082                	ret

0000000080004192 <exec>:

int
exec(char *path, char **argv)
{
    80004192:	df010113          	addi	sp,sp,-528
    80004196:	20113423          	sd	ra,520(sp)
    8000419a:	20813023          	sd	s0,512(sp)
    8000419e:	ffa6                	sd	s1,504(sp)
    800041a0:	fbca                	sd	s2,496(sp)
    800041a2:	f7ce                	sd	s3,488(sp)
    800041a4:	f3d2                	sd	s4,480(sp)
    800041a6:	efd6                	sd	s5,472(sp)
    800041a8:	ebda                	sd	s6,464(sp)
    800041aa:	e7de                	sd	s7,456(sp)
    800041ac:	e3e2                	sd	s8,448(sp)
    800041ae:	ff66                	sd	s9,440(sp)
    800041b0:	fb6a                	sd	s10,432(sp)
    800041b2:	f76e                	sd	s11,424(sp)
    800041b4:	0c00                	addi	s0,sp,528
    800041b6:	84aa                	mv	s1,a0
    800041b8:	dea43c23          	sd	a0,-520(s0)
    800041bc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041c0:	ffffd097          	auipc	ra,0xffffd
    800041c4:	cbe080e7          	jalr	-834(ra) # 80000e7e <myproc>
    800041c8:	892a                	mv	s2,a0

  begin_op();
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	474080e7          	jalr	1140(ra) # 8000363e <begin_op>

  if((ip = namei(path)) == 0){
    800041d2:	8526                	mv	a0,s1
    800041d4:	fffff097          	auipc	ra,0xfffff
    800041d8:	24e080e7          	jalr	590(ra) # 80003422 <namei>
    800041dc:	c92d                	beqz	a0,8000424e <exec+0xbc>
    800041de:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	a9c080e7          	jalr	-1380(ra) # 80002c7c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041e8:	04000713          	li	a4,64
    800041ec:	4681                	li	a3,0
    800041ee:	e5040613          	addi	a2,s0,-432
    800041f2:	4581                	li	a1,0
    800041f4:	8526                	mv	a0,s1
    800041f6:	fffff097          	auipc	ra,0xfffff
    800041fa:	d3a080e7          	jalr	-710(ra) # 80002f30 <readi>
    800041fe:	04000793          	li	a5,64
    80004202:	00f51a63          	bne	a0,a5,80004216 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004206:	e5042703          	lw	a4,-432(s0)
    8000420a:	464c47b7          	lui	a5,0x464c4
    8000420e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004212:	04f70463          	beq	a4,a5,8000425a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004216:	8526                	mv	a0,s1
    80004218:	fffff097          	auipc	ra,0xfffff
    8000421c:	cc6080e7          	jalr	-826(ra) # 80002ede <iunlockput>
    end_op();
    80004220:	fffff097          	auipc	ra,0xfffff
    80004224:	49e080e7          	jalr	1182(ra) # 800036be <end_op>
  }
  return -1;
    80004228:	557d                	li	a0,-1
}
    8000422a:	20813083          	ld	ra,520(sp)
    8000422e:	20013403          	ld	s0,512(sp)
    80004232:	74fe                	ld	s1,504(sp)
    80004234:	795e                	ld	s2,496(sp)
    80004236:	79be                	ld	s3,488(sp)
    80004238:	7a1e                	ld	s4,480(sp)
    8000423a:	6afe                	ld	s5,472(sp)
    8000423c:	6b5e                	ld	s6,464(sp)
    8000423e:	6bbe                	ld	s7,456(sp)
    80004240:	6c1e                	ld	s8,448(sp)
    80004242:	7cfa                	ld	s9,440(sp)
    80004244:	7d5a                	ld	s10,432(sp)
    80004246:	7dba                	ld	s11,424(sp)
    80004248:	21010113          	addi	sp,sp,528
    8000424c:	8082                	ret
    end_op();
    8000424e:	fffff097          	auipc	ra,0xfffff
    80004252:	470080e7          	jalr	1136(ra) # 800036be <end_op>
    return -1;
    80004256:	557d                	li	a0,-1
    80004258:	bfc9                	j	8000422a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000425a:	854a                	mv	a0,s2
    8000425c:	ffffd097          	auipc	ra,0xffffd
    80004260:	ce6080e7          	jalr	-794(ra) # 80000f42 <proc_pagetable>
    80004264:	8baa                	mv	s7,a0
    80004266:	d945                	beqz	a0,80004216 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004268:	e7042983          	lw	s3,-400(s0)
    8000426c:	e8845783          	lhu	a5,-376(s0)
    80004270:	c7ad                	beqz	a5,800042da <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004272:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004274:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004276:	6c85                	lui	s9,0x1
    80004278:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000427c:	def43823          	sd	a5,-528(s0)
    80004280:	ac0d                	j	800044b2 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004282:	00004517          	auipc	a0,0x4
    80004286:	4be50513          	addi	a0,a0,1214 # 80008740 <syscalls+0x290>
    8000428a:	00002097          	auipc	ra,0x2
    8000428e:	af8080e7          	jalr	-1288(ra) # 80005d82 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004292:	8756                	mv	a4,s5
    80004294:	012d86bb          	addw	a3,s11,s2
    80004298:	4581                	li	a1,0
    8000429a:	8526                	mv	a0,s1
    8000429c:	fffff097          	auipc	ra,0xfffff
    800042a0:	c94080e7          	jalr	-876(ra) # 80002f30 <readi>
    800042a4:	2501                	sext.w	a0,a0
    800042a6:	1aaa9a63          	bne	s5,a0,8000445a <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800042aa:	6785                	lui	a5,0x1
    800042ac:	0127893b          	addw	s2,a5,s2
    800042b0:	77fd                	lui	a5,0xfffff
    800042b2:	01478a3b          	addw	s4,a5,s4
    800042b6:	1f897563          	bgeu	s2,s8,800044a0 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800042ba:	02091593          	slli	a1,s2,0x20
    800042be:	9181                	srli	a1,a1,0x20
    800042c0:	95ea                	add	a1,a1,s10
    800042c2:	855e                	mv	a0,s7
    800042c4:	ffffc097          	auipc	ra,0xffffc
    800042c8:	26c080e7          	jalr	620(ra) # 80000530 <walkaddr>
    800042cc:	862a                	mv	a2,a0
    if(pa == 0)
    800042ce:	d955                	beqz	a0,80004282 <exec+0xf0>
      n = PGSIZE;
    800042d0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042d2:	fd9a70e3          	bgeu	s4,s9,80004292 <exec+0x100>
      n = sz - i;
    800042d6:	8ad2                	mv	s5,s4
    800042d8:	bf6d                	j	80004292 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042da:	4a01                	li	s4,0
  iunlockput(ip);
    800042dc:	8526                	mv	a0,s1
    800042de:	fffff097          	auipc	ra,0xfffff
    800042e2:	c00080e7          	jalr	-1024(ra) # 80002ede <iunlockput>
  end_op();
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	3d8080e7          	jalr	984(ra) # 800036be <end_op>
  p = myproc();
    800042ee:	ffffd097          	auipc	ra,0xffffd
    800042f2:	b90080e7          	jalr	-1136(ra) # 80000e7e <myproc>
    800042f6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042f8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042fc:	6785                	lui	a5,0x1
    800042fe:	17fd                	addi	a5,a5,-1
    80004300:	9a3e                	add	s4,s4,a5
    80004302:	757d                	lui	a0,0xfffff
    80004304:	00aa77b3          	and	a5,s4,a0
    80004308:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000430c:	4691                	li	a3,4
    8000430e:	6609                	lui	a2,0x2
    80004310:	963e                	add	a2,a2,a5
    80004312:	85be                	mv	a1,a5
    80004314:	855e                	mv	a0,s7
    80004316:	ffffc097          	auipc	ra,0xffffc
    8000431a:	5ce080e7          	jalr	1486(ra) # 800008e4 <uvmalloc>
    8000431e:	8b2a                	mv	s6,a0
  ip = 0;
    80004320:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004322:	12050c63          	beqz	a0,8000445a <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004326:	75f9                	lui	a1,0xffffe
    80004328:	95aa                	add	a1,a1,a0
    8000432a:	855e                	mv	a0,s7
    8000432c:	ffffc097          	auipc	ra,0xffffc
    80004330:	7de080e7          	jalr	2014(ra) # 80000b0a <uvmclear>
  stackbase = sp - PGSIZE;
    80004334:	7c7d                	lui	s8,0xfffff
    80004336:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004338:	e0043783          	ld	a5,-512(s0)
    8000433c:	6388                	ld	a0,0(a5)
    8000433e:	c535                	beqz	a0,800043aa <exec+0x218>
    80004340:	e9040993          	addi	s3,s0,-368
    80004344:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004348:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000434a:	ffffc097          	auipc	ra,0xffffc
    8000434e:	fd8080e7          	jalr	-40(ra) # 80000322 <strlen>
    80004352:	2505                	addiw	a0,a0,1
    80004354:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004358:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000435c:	13896663          	bltu	s2,s8,80004488 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004360:	e0043d83          	ld	s11,-512(s0)
    80004364:	000dba03          	ld	s4,0(s11)
    80004368:	8552                	mv	a0,s4
    8000436a:	ffffc097          	auipc	ra,0xffffc
    8000436e:	fb8080e7          	jalr	-72(ra) # 80000322 <strlen>
    80004372:	0015069b          	addiw	a3,a0,1
    80004376:	8652                	mv	a2,s4
    80004378:	85ca                	mv	a1,s2
    8000437a:	855e                	mv	a0,s7
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	7c0080e7          	jalr	1984(ra) # 80000b3c <copyout>
    80004384:	10054663          	bltz	a0,80004490 <exec+0x2fe>
    ustack[argc] = sp;
    80004388:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000438c:	0485                	addi	s1,s1,1
    8000438e:	008d8793          	addi	a5,s11,8
    80004392:	e0f43023          	sd	a5,-512(s0)
    80004396:	008db503          	ld	a0,8(s11)
    8000439a:	c911                	beqz	a0,800043ae <exec+0x21c>
    if(argc >= MAXARG)
    8000439c:	09a1                	addi	s3,s3,8
    8000439e:	fb3c96e3          	bne	s9,s3,8000434a <exec+0x1b8>
  sz = sz1;
    800043a2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a6:	4481                	li	s1,0
    800043a8:	a84d                	j	8000445a <exec+0x2c8>
  sp = sz;
    800043aa:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043ac:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ae:	00349793          	slli	a5,s1,0x3
    800043b2:	f9040713          	addi	a4,s0,-112
    800043b6:	97ba                	add	a5,a5,a4
    800043b8:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043bc:	00148693          	addi	a3,s1,1
    800043c0:	068e                	slli	a3,a3,0x3
    800043c2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043c6:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043ca:	01897663          	bgeu	s2,s8,800043d6 <exec+0x244>
  sz = sz1;
    800043ce:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d2:	4481                	li	s1,0
    800043d4:	a059                	j	8000445a <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043d6:	e9040613          	addi	a2,s0,-368
    800043da:	85ca                	mv	a1,s2
    800043dc:	855e                	mv	a0,s7
    800043de:	ffffc097          	auipc	ra,0xffffc
    800043e2:	75e080e7          	jalr	1886(ra) # 80000b3c <copyout>
    800043e6:	0a054963          	bltz	a0,80004498 <exec+0x306>
  p->trapframe->a1 = sp;
    800043ea:	058ab783          	ld	a5,88(s5)
    800043ee:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043f2:	df843783          	ld	a5,-520(s0)
    800043f6:	0007c703          	lbu	a4,0(a5)
    800043fa:	cf11                	beqz	a4,80004416 <exec+0x284>
    800043fc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043fe:	02f00693          	li	a3,47
    80004402:	a039                	j	80004410 <exec+0x27e>
      last = s+1;
    80004404:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004408:	0785                	addi	a5,a5,1
    8000440a:	fff7c703          	lbu	a4,-1(a5)
    8000440e:	c701                	beqz	a4,80004416 <exec+0x284>
    if(*s == '/')
    80004410:	fed71ce3          	bne	a4,a3,80004408 <exec+0x276>
    80004414:	bfc5                	j	80004404 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004416:	4641                	li	a2,16
    80004418:	df843583          	ld	a1,-520(s0)
    8000441c:	158a8513          	addi	a0,s5,344
    80004420:	ffffc097          	auipc	ra,0xffffc
    80004424:	ed0080e7          	jalr	-304(ra) # 800002f0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004428:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000442c:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004430:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004434:	058ab783          	ld	a5,88(s5)
    80004438:	e6843703          	ld	a4,-408(s0)
    8000443c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000443e:	058ab783          	ld	a5,88(s5)
    80004442:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004446:	85ea                	mv	a1,s10
    80004448:	ffffd097          	auipc	ra,0xffffd
    8000444c:	b96080e7          	jalr	-1130(ra) # 80000fde <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004450:	0004851b          	sext.w	a0,s1
    80004454:	bbd9                	j	8000422a <exec+0x98>
    80004456:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000445a:	e0843583          	ld	a1,-504(s0)
    8000445e:	855e                	mv	a0,s7
    80004460:	ffffd097          	auipc	ra,0xffffd
    80004464:	b7e080e7          	jalr	-1154(ra) # 80000fde <proc_freepagetable>
  if(ip){
    80004468:	da0497e3          	bnez	s1,80004216 <exec+0x84>
  return -1;
    8000446c:	557d                	li	a0,-1
    8000446e:	bb75                	j	8000422a <exec+0x98>
    80004470:	e1443423          	sd	s4,-504(s0)
    80004474:	b7dd                	j	8000445a <exec+0x2c8>
    80004476:	e1443423          	sd	s4,-504(s0)
    8000447a:	b7c5                	j	8000445a <exec+0x2c8>
    8000447c:	e1443423          	sd	s4,-504(s0)
    80004480:	bfe9                	j	8000445a <exec+0x2c8>
    80004482:	e1443423          	sd	s4,-504(s0)
    80004486:	bfd1                	j	8000445a <exec+0x2c8>
  sz = sz1;
    80004488:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000448c:	4481                	li	s1,0
    8000448e:	b7f1                	j	8000445a <exec+0x2c8>
  sz = sz1;
    80004490:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004494:	4481                	li	s1,0
    80004496:	b7d1                	j	8000445a <exec+0x2c8>
  sz = sz1;
    80004498:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000449c:	4481                	li	s1,0
    8000449e:	bf75                	j	8000445a <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044a0:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044a4:	2b05                	addiw	s6,s6,1
    800044a6:	0389899b          	addiw	s3,s3,56
    800044aa:	e8845783          	lhu	a5,-376(s0)
    800044ae:	e2fb57e3          	bge	s6,a5,800042dc <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044b2:	2981                	sext.w	s3,s3
    800044b4:	03800713          	li	a4,56
    800044b8:	86ce                	mv	a3,s3
    800044ba:	e1840613          	addi	a2,s0,-488
    800044be:	4581                	li	a1,0
    800044c0:	8526                	mv	a0,s1
    800044c2:	fffff097          	auipc	ra,0xfffff
    800044c6:	a6e080e7          	jalr	-1426(ra) # 80002f30 <readi>
    800044ca:	03800793          	li	a5,56
    800044ce:	f8f514e3          	bne	a0,a5,80004456 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800044d2:	e1842783          	lw	a5,-488(s0)
    800044d6:	4705                	li	a4,1
    800044d8:	fce796e3          	bne	a5,a4,800044a4 <exec+0x312>
    if(ph.memsz < ph.filesz)
    800044dc:	e4043903          	ld	s2,-448(s0)
    800044e0:	e3843783          	ld	a5,-456(s0)
    800044e4:	f8f966e3          	bltu	s2,a5,80004470 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044e8:	e2843783          	ld	a5,-472(s0)
    800044ec:	993e                	add	s2,s2,a5
    800044ee:	f8f964e3          	bltu	s2,a5,80004476 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044f2:	df043703          	ld	a4,-528(s0)
    800044f6:	8ff9                	and	a5,a5,a4
    800044f8:	f3d1                	bnez	a5,8000447c <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044fa:	e1c42503          	lw	a0,-484(s0)
    800044fe:	00000097          	auipc	ra,0x0
    80004502:	c78080e7          	jalr	-904(ra) # 80004176 <flags2perm>
    80004506:	86aa                	mv	a3,a0
    80004508:	864a                	mv	a2,s2
    8000450a:	85d2                	mv	a1,s4
    8000450c:	855e                	mv	a0,s7
    8000450e:	ffffc097          	auipc	ra,0xffffc
    80004512:	3d6080e7          	jalr	982(ra) # 800008e4 <uvmalloc>
    80004516:	e0a43423          	sd	a0,-504(s0)
    8000451a:	d525                	beqz	a0,80004482 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000451c:	e2843d03          	ld	s10,-472(s0)
    80004520:	e2042d83          	lw	s11,-480(s0)
    80004524:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004528:	f60c0ce3          	beqz	s8,800044a0 <exec+0x30e>
    8000452c:	8a62                	mv	s4,s8
    8000452e:	4901                	li	s2,0
    80004530:	b369                	j	800042ba <exec+0x128>

0000000080004532 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004532:	7179                	addi	sp,sp,-48
    80004534:	f406                	sd	ra,40(sp)
    80004536:	f022                	sd	s0,32(sp)
    80004538:	ec26                	sd	s1,24(sp)
    8000453a:	e84a                	sd	s2,16(sp)
    8000453c:	1800                	addi	s0,sp,48
    8000453e:	892e                	mv	s2,a1
    80004540:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004542:	fdc40593          	addi	a1,s0,-36
    80004546:	ffffe097          	auipc	ra,0xffffe
    8000454a:	aa4080e7          	jalr	-1372(ra) # 80001fea <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000454e:	fdc42703          	lw	a4,-36(s0)
    80004552:	47bd                	li	a5,15
    80004554:	02e7eb63          	bltu	a5,a4,8000458a <argfd+0x58>
    80004558:	ffffd097          	auipc	ra,0xffffd
    8000455c:	926080e7          	jalr	-1754(ra) # 80000e7e <myproc>
    80004560:	fdc42703          	lw	a4,-36(s0)
    80004564:	01a70793          	addi	a5,a4,26
    80004568:	078e                	slli	a5,a5,0x3
    8000456a:	953e                	add	a0,a0,a5
    8000456c:	611c                	ld	a5,0(a0)
    8000456e:	c385                	beqz	a5,8000458e <argfd+0x5c>
    return -1;
  if(pfd)
    80004570:	00090463          	beqz	s2,80004578 <argfd+0x46>
    *pfd = fd;
    80004574:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004578:	4501                	li	a0,0
  if(pf)
    8000457a:	c091                	beqz	s1,8000457e <argfd+0x4c>
    *pf = f;
    8000457c:	e09c                	sd	a5,0(s1)
}
    8000457e:	70a2                	ld	ra,40(sp)
    80004580:	7402                	ld	s0,32(sp)
    80004582:	64e2                	ld	s1,24(sp)
    80004584:	6942                	ld	s2,16(sp)
    80004586:	6145                	addi	sp,sp,48
    80004588:	8082                	ret
    return -1;
    8000458a:	557d                	li	a0,-1
    8000458c:	bfcd                	j	8000457e <argfd+0x4c>
    8000458e:	557d                	li	a0,-1
    80004590:	b7fd                	j	8000457e <argfd+0x4c>

0000000080004592 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004592:	1101                	addi	sp,sp,-32
    80004594:	ec06                	sd	ra,24(sp)
    80004596:	e822                	sd	s0,16(sp)
    80004598:	e426                	sd	s1,8(sp)
    8000459a:	1000                	addi	s0,sp,32
    8000459c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000459e:	ffffd097          	auipc	ra,0xffffd
    800045a2:	8e0080e7          	jalr	-1824(ra) # 80000e7e <myproc>
    800045a6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800045a8:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdcfd0>
    800045ac:	4501                	li	a0,0
    800045ae:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800045b0:	6398                	ld	a4,0(a5)
    800045b2:	cb19                	beqz	a4,800045c8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800045b4:	2505                	addiw	a0,a0,1
    800045b6:	07a1                	addi	a5,a5,8
    800045b8:	fed51ce3          	bne	a0,a3,800045b0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800045bc:	557d                	li	a0,-1
}
    800045be:	60e2                	ld	ra,24(sp)
    800045c0:	6442                	ld	s0,16(sp)
    800045c2:	64a2                	ld	s1,8(sp)
    800045c4:	6105                	addi	sp,sp,32
    800045c6:	8082                	ret
      p->ofile[fd] = f;
    800045c8:	01a50793          	addi	a5,a0,26
    800045cc:	078e                	slli	a5,a5,0x3
    800045ce:	963e                	add	a2,a2,a5
    800045d0:	e204                	sd	s1,0(a2)
      return fd;
    800045d2:	b7f5                	j	800045be <fdalloc+0x2c>

00000000800045d4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800045d4:	715d                	addi	sp,sp,-80
    800045d6:	e486                	sd	ra,72(sp)
    800045d8:	e0a2                	sd	s0,64(sp)
    800045da:	fc26                	sd	s1,56(sp)
    800045dc:	f84a                	sd	s2,48(sp)
    800045de:	f44e                	sd	s3,40(sp)
    800045e0:	f052                	sd	s4,32(sp)
    800045e2:	ec56                	sd	s5,24(sp)
    800045e4:	e85a                	sd	s6,16(sp)
    800045e6:	0880                	addi	s0,sp,80
    800045e8:	8b2e                	mv	s6,a1
    800045ea:	89b2                	mv	s3,a2
    800045ec:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800045ee:	fb040593          	addi	a1,s0,-80
    800045f2:	fffff097          	auipc	ra,0xfffff
    800045f6:	e4e080e7          	jalr	-434(ra) # 80003440 <nameiparent>
    800045fa:	84aa                	mv	s1,a0
    800045fc:	16050063          	beqz	a0,8000475c <create+0x188>
    return 0;

  ilock(dp);
    80004600:	ffffe097          	auipc	ra,0xffffe
    80004604:	67c080e7          	jalr	1660(ra) # 80002c7c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004608:	4601                	li	a2,0
    8000460a:	fb040593          	addi	a1,s0,-80
    8000460e:	8526                	mv	a0,s1
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	b50080e7          	jalr	-1200(ra) # 80003160 <dirlookup>
    80004618:	8aaa                	mv	s5,a0
    8000461a:	c931                	beqz	a0,8000466e <create+0x9a>
    iunlockput(dp);
    8000461c:	8526                	mv	a0,s1
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	8c0080e7          	jalr	-1856(ra) # 80002ede <iunlockput>
    ilock(ip);
    80004626:	8556                	mv	a0,s5
    80004628:	ffffe097          	auipc	ra,0xffffe
    8000462c:	654080e7          	jalr	1620(ra) # 80002c7c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004630:	000b059b          	sext.w	a1,s6
    80004634:	4789                	li	a5,2
    80004636:	02f59563          	bne	a1,a5,80004660 <create+0x8c>
    8000463a:	044ad783          	lhu	a5,68(s5)
    8000463e:	37f9                	addiw	a5,a5,-2
    80004640:	17c2                	slli	a5,a5,0x30
    80004642:	93c1                	srli	a5,a5,0x30
    80004644:	4705                	li	a4,1
    80004646:	00f76d63          	bltu	a4,a5,80004660 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000464a:	8556                	mv	a0,s5
    8000464c:	60a6                	ld	ra,72(sp)
    8000464e:	6406                	ld	s0,64(sp)
    80004650:	74e2                	ld	s1,56(sp)
    80004652:	7942                	ld	s2,48(sp)
    80004654:	79a2                	ld	s3,40(sp)
    80004656:	7a02                	ld	s4,32(sp)
    80004658:	6ae2                	ld	s5,24(sp)
    8000465a:	6b42                	ld	s6,16(sp)
    8000465c:	6161                	addi	sp,sp,80
    8000465e:	8082                	ret
    iunlockput(ip);
    80004660:	8556                	mv	a0,s5
    80004662:	fffff097          	auipc	ra,0xfffff
    80004666:	87c080e7          	jalr	-1924(ra) # 80002ede <iunlockput>
    return 0;
    8000466a:	4a81                	li	s5,0
    8000466c:	bff9                	j	8000464a <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000466e:	85da                	mv	a1,s6
    80004670:	4088                	lw	a0,0(s1)
    80004672:	ffffe097          	auipc	ra,0xffffe
    80004676:	46e080e7          	jalr	1134(ra) # 80002ae0 <ialloc>
    8000467a:	8a2a                	mv	s4,a0
    8000467c:	c921                	beqz	a0,800046cc <create+0xf8>
  ilock(ip);
    8000467e:	ffffe097          	auipc	ra,0xffffe
    80004682:	5fe080e7          	jalr	1534(ra) # 80002c7c <ilock>
  ip->major = major;
    80004686:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    8000468a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    8000468e:	4785                	li	a5,1
    80004690:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    80004694:	8552                	mv	a0,s4
    80004696:	ffffe097          	auipc	ra,0xffffe
    8000469a:	51c080e7          	jalr	1308(ra) # 80002bb2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000469e:	000b059b          	sext.w	a1,s6
    800046a2:	4785                	li	a5,1
    800046a4:	02f58b63          	beq	a1,a5,800046da <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800046a8:	004a2603          	lw	a2,4(s4)
    800046ac:	fb040593          	addi	a1,s0,-80
    800046b0:	8526                	mv	a0,s1
    800046b2:	fffff097          	auipc	ra,0xfffff
    800046b6:	cbe080e7          	jalr	-834(ra) # 80003370 <dirlink>
    800046ba:	06054f63          	bltz	a0,80004738 <create+0x164>
  iunlockput(dp);
    800046be:	8526                	mv	a0,s1
    800046c0:	fffff097          	auipc	ra,0xfffff
    800046c4:	81e080e7          	jalr	-2018(ra) # 80002ede <iunlockput>
  return ip;
    800046c8:	8ad2                	mv	s5,s4
    800046ca:	b741                	j	8000464a <create+0x76>
    iunlockput(dp);
    800046cc:	8526                	mv	a0,s1
    800046ce:	fffff097          	auipc	ra,0xfffff
    800046d2:	810080e7          	jalr	-2032(ra) # 80002ede <iunlockput>
    return 0;
    800046d6:	8ad2                	mv	s5,s4
    800046d8:	bf8d                	j	8000464a <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046da:	004a2603          	lw	a2,4(s4)
    800046de:	00004597          	auipc	a1,0x4
    800046e2:	08258593          	addi	a1,a1,130 # 80008760 <syscalls+0x2b0>
    800046e6:	8552                	mv	a0,s4
    800046e8:	fffff097          	auipc	ra,0xfffff
    800046ec:	c88080e7          	jalr	-888(ra) # 80003370 <dirlink>
    800046f0:	04054463          	bltz	a0,80004738 <create+0x164>
    800046f4:	40d0                	lw	a2,4(s1)
    800046f6:	00004597          	auipc	a1,0x4
    800046fa:	07258593          	addi	a1,a1,114 # 80008768 <syscalls+0x2b8>
    800046fe:	8552                	mv	a0,s4
    80004700:	fffff097          	auipc	ra,0xfffff
    80004704:	c70080e7          	jalr	-912(ra) # 80003370 <dirlink>
    80004708:	02054863          	bltz	a0,80004738 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    8000470c:	004a2603          	lw	a2,4(s4)
    80004710:	fb040593          	addi	a1,s0,-80
    80004714:	8526                	mv	a0,s1
    80004716:	fffff097          	auipc	ra,0xfffff
    8000471a:	c5a080e7          	jalr	-934(ra) # 80003370 <dirlink>
    8000471e:	00054d63          	bltz	a0,80004738 <create+0x164>
    dp->nlink++;  // for ".."
    80004722:	04a4d783          	lhu	a5,74(s1)
    80004726:	2785                	addiw	a5,a5,1
    80004728:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000472c:	8526                	mv	a0,s1
    8000472e:	ffffe097          	auipc	ra,0xffffe
    80004732:	484080e7          	jalr	1156(ra) # 80002bb2 <iupdate>
    80004736:	b761                	j	800046be <create+0xea>
  ip->nlink = 0;
    80004738:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000473c:	8552                	mv	a0,s4
    8000473e:	ffffe097          	auipc	ra,0xffffe
    80004742:	474080e7          	jalr	1140(ra) # 80002bb2 <iupdate>
  iunlockput(ip);
    80004746:	8552                	mv	a0,s4
    80004748:	ffffe097          	auipc	ra,0xffffe
    8000474c:	796080e7          	jalr	1942(ra) # 80002ede <iunlockput>
  iunlockput(dp);
    80004750:	8526                	mv	a0,s1
    80004752:	ffffe097          	auipc	ra,0xffffe
    80004756:	78c080e7          	jalr	1932(ra) # 80002ede <iunlockput>
  return 0;
    8000475a:	bdc5                	j	8000464a <create+0x76>
    return 0;
    8000475c:	8aaa                	mv	s5,a0
    8000475e:	b5f5                	j	8000464a <create+0x76>

0000000080004760 <sys_dup>:
{
    80004760:	7179                	addi	sp,sp,-48
    80004762:	f406                	sd	ra,40(sp)
    80004764:	f022                	sd	s0,32(sp)
    80004766:	ec26                	sd	s1,24(sp)
    80004768:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000476a:	fd840613          	addi	a2,s0,-40
    8000476e:	4581                	li	a1,0
    80004770:	4501                	li	a0,0
    80004772:	00000097          	auipc	ra,0x0
    80004776:	dc0080e7          	jalr	-576(ra) # 80004532 <argfd>
    return -1;
    8000477a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000477c:	02054363          	bltz	a0,800047a2 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    80004780:	fd843503          	ld	a0,-40(s0)
    80004784:	00000097          	auipc	ra,0x0
    80004788:	e0e080e7          	jalr	-498(ra) # 80004592 <fdalloc>
    8000478c:	84aa                	mv	s1,a0
    return -1;
    8000478e:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004790:	00054963          	bltz	a0,800047a2 <sys_dup+0x42>
  filedup(f);
    80004794:	fd843503          	ld	a0,-40(s0)
    80004798:	fffff097          	auipc	ra,0xfffff
    8000479c:	320080e7          	jalr	800(ra) # 80003ab8 <filedup>
  return fd;
    800047a0:	87a6                	mv	a5,s1
}
    800047a2:	853e                	mv	a0,a5
    800047a4:	70a2                	ld	ra,40(sp)
    800047a6:	7402                	ld	s0,32(sp)
    800047a8:	64e2                	ld	s1,24(sp)
    800047aa:	6145                	addi	sp,sp,48
    800047ac:	8082                	ret

00000000800047ae <sys_read>:
{
    800047ae:	7179                	addi	sp,sp,-48
    800047b0:	f406                	sd	ra,40(sp)
    800047b2:	f022                	sd	s0,32(sp)
    800047b4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800047b6:	fd840593          	addi	a1,s0,-40
    800047ba:	4505                	li	a0,1
    800047bc:	ffffe097          	auipc	ra,0xffffe
    800047c0:	84e080e7          	jalr	-1970(ra) # 8000200a <argaddr>
  argint(2, &n);
    800047c4:	fe440593          	addi	a1,s0,-28
    800047c8:	4509                	li	a0,2
    800047ca:	ffffe097          	auipc	ra,0xffffe
    800047ce:	820080e7          	jalr	-2016(ra) # 80001fea <argint>
  if(argfd(0, 0, &f) < 0)
    800047d2:	fe840613          	addi	a2,s0,-24
    800047d6:	4581                	li	a1,0
    800047d8:	4501                	li	a0,0
    800047da:	00000097          	auipc	ra,0x0
    800047de:	d58080e7          	jalr	-680(ra) # 80004532 <argfd>
    800047e2:	87aa                	mv	a5,a0
    return -1;
    800047e4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047e6:	0007cc63          	bltz	a5,800047fe <sys_read+0x50>
  return fileread(f, p, n);
    800047ea:	fe442603          	lw	a2,-28(s0)
    800047ee:	fd843583          	ld	a1,-40(s0)
    800047f2:	fe843503          	ld	a0,-24(s0)
    800047f6:	fffff097          	auipc	ra,0xfffff
    800047fa:	44e080e7          	jalr	1102(ra) # 80003c44 <fileread>
}
    800047fe:	70a2                	ld	ra,40(sp)
    80004800:	7402                	ld	s0,32(sp)
    80004802:	6145                	addi	sp,sp,48
    80004804:	8082                	ret

0000000080004806 <sys_write>:
{
    80004806:	7179                	addi	sp,sp,-48
    80004808:	f406                	sd	ra,40(sp)
    8000480a:	f022                	sd	s0,32(sp)
    8000480c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000480e:	fd840593          	addi	a1,s0,-40
    80004812:	4505                	li	a0,1
    80004814:	ffffd097          	auipc	ra,0xffffd
    80004818:	7f6080e7          	jalr	2038(ra) # 8000200a <argaddr>
  argint(2, &n);
    8000481c:	fe440593          	addi	a1,s0,-28
    80004820:	4509                	li	a0,2
    80004822:	ffffd097          	auipc	ra,0xffffd
    80004826:	7c8080e7          	jalr	1992(ra) # 80001fea <argint>
  if(argfd(0, 0, &f) < 0)
    8000482a:	fe840613          	addi	a2,s0,-24
    8000482e:	4581                	li	a1,0
    80004830:	4501                	li	a0,0
    80004832:	00000097          	auipc	ra,0x0
    80004836:	d00080e7          	jalr	-768(ra) # 80004532 <argfd>
    8000483a:	87aa                	mv	a5,a0
    return -1;
    8000483c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000483e:	0007cc63          	bltz	a5,80004856 <sys_write+0x50>
  return filewrite(f, p, n);
    80004842:	fe442603          	lw	a2,-28(s0)
    80004846:	fd843583          	ld	a1,-40(s0)
    8000484a:	fe843503          	ld	a0,-24(s0)
    8000484e:	fffff097          	auipc	ra,0xfffff
    80004852:	4b8080e7          	jalr	1208(ra) # 80003d06 <filewrite>
}
    80004856:	70a2                	ld	ra,40(sp)
    80004858:	7402                	ld	s0,32(sp)
    8000485a:	6145                	addi	sp,sp,48
    8000485c:	8082                	ret

000000008000485e <sys_close>:
{
    8000485e:	1101                	addi	sp,sp,-32
    80004860:	ec06                	sd	ra,24(sp)
    80004862:	e822                	sd	s0,16(sp)
    80004864:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004866:	fe040613          	addi	a2,s0,-32
    8000486a:	fec40593          	addi	a1,s0,-20
    8000486e:	4501                	li	a0,0
    80004870:	00000097          	auipc	ra,0x0
    80004874:	cc2080e7          	jalr	-830(ra) # 80004532 <argfd>
    return -1;
    80004878:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000487a:	02054463          	bltz	a0,800048a2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    8000487e:	ffffc097          	auipc	ra,0xffffc
    80004882:	600080e7          	jalr	1536(ra) # 80000e7e <myproc>
    80004886:	fec42783          	lw	a5,-20(s0)
    8000488a:	07e9                	addi	a5,a5,26
    8000488c:	078e                	slli	a5,a5,0x3
    8000488e:	97aa                	add	a5,a5,a0
    80004890:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    80004894:	fe043503          	ld	a0,-32(s0)
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	272080e7          	jalr	626(ra) # 80003b0a <fileclose>
  return 0;
    800048a0:	4781                	li	a5,0
}
    800048a2:	853e                	mv	a0,a5
    800048a4:	60e2                	ld	ra,24(sp)
    800048a6:	6442                	ld	s0,16(sp)
    800048a8:	6105                	addi	sp,sp,32
    800048aa:	8082                	ret

00000000800048ac <sys_fstat>:
{
    800048ac:	1101                	addi	sp,sp,-32
    800048ae:	ec06                	sd	ra,24(sp)
    800048b0:	e822                	sd	s0,16(sp)
    800048b2:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800048b4:	fe040593          	addi	a1,s0,-32
    800048b8:	4505                	li	a0,1
    800048ba:	ffffd097          	auipc	ra,0xffffd
    800048be:	750080e7          	jalr	1872(ra) # 8000200a <argaddr>
  if(argfd(0, 0, &f) < 0)
    800048c2:	fe840613          	addi	a2,s0,-24
    800048c6:	4581                	li	a1,0
    800048c8:	4501                	li	a0,0
    800048ca:	00000097          	auipc	ra,0x0
    800048ce:	c68080e7          	jalr	-920(ra) # 80004532 <argfd>
    800048d2:	87aa                	mv	a5,a0
    return -1;
    800048d4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048d6:	0007ca63          	bltz	a5,800048ea <sys_fstat+0x3e>
  return filestat(f, st);
    800048da:	fe043583          	ld	a1,-32(s0)
    800048de:	fe843503          	ld	a0,-24(s0)
    800048e2:	fffff097          	auipc	ra,0xfffff
    800048e6:	2f0080e7          	jalr	752(ra) # 80003bd2 <filestat>
}
    800048ea:	60e2                	ld	ra,24(sp)
    800048ec:	6442                	ld	s0,16(sp)
    800048ee:	6105                	addi	sp,sp,32
    800048f0:	8082                	ret

00000000800048f2 <sys_link>:
{
    800048f2:	7169                	addi	sp,sp,-304
    800048f4:	f606                	sd	ra,296(sp)
    800048f6:	f222                	sd	s0,288(sp)
    800048f8:	ee26                	sd	s1,280(sp)
    800048fa:	ea4a                	sd	s2,272(sp)
    800048fc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fe:	08000613          	li	a2,128
    80004902:	ed040593          	addi	a1,s0,-304
    80004906:	4501                	li	a0,0
    80004908:	ffffd097          	auipc	ra,0xffffd
    8000490c:	722080e7          	jalr	1826(ra) # 8000202a <argstr>
    return -1;
    80004910:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004912:	10054e63          	bltz	a0,80004a2e <sys_link+0x13c>
    80004916:	08000613          	li	a2,128
    8000491a:	f5040593          	addi	a1,s0,-176
    8000491e:	4505                	li	a0,1
    80004920:	ffffd097          	auipc	ra,0xffffd
    80004924:	70a080e7          	jalr	1802(ra) # 8000202a <argstr>
    return -1;
    80004928:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000492a:	10054263          	bltz	a0,80004a2e <sys_link+0x13c>
  begin_op();
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	d10080e7          	jalr	-752(ra) # 8000363e <begin_op>
  if((ip = namei(old)) == 0){
    80004936:	ed040513          	addi	a0,s0,-304
    8000493a:	fffff097          	auipc	ra,0xfffff
    8000493e:	ae8080e7          	jalr	-1304(ra) # 80003422 <namei>
    80004942:	84aa                	mv	s1,a0
    80004944:	c551                	beqz	a0,800049d0 <sys_link+0xde>
  ilock(ip);
    80004946:	ffffe097          	auipc	ra,0xffffe
    8000494a:	336080e7          	jalr	822(ra) # 80002c7c <ilock>
  if(ip->type == T_DIR){
    8000494e:	04449703          	lh	a4,68(s1)
    80004952:	4785                	li	a5,1
    80004954:	08f70463          	beq	a4,a5,800049dc <sys_link+0xea>
  ip->nlink++;
    80004958:	04a4d783          	lhu	a5,74(s1)
    8000495c:	2785                	addiw	a5,a5,1
    8000495e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004962:	8526                	mv	a0,s1
    80004964:	ffffe097          	auipc	ra,0xffffe
    80004968:	24e080e7          	jalr	590(ra) # 80002bb2 <iupdate>
  iunlock(ip);
    8000496c:	8526                	mv	a0,s1
    8000496e:	ffffe097          	auipc	ra,0xffffe
    80004972:	3d0080e7          	jalr	976(ra) # 80002d3e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004976:	fd040593          	addi	a1,s0,-48
    8000497a:	f5040513          	addi	a0,s0,-176
    8000497e:	fffff097          	auipc	ra,0xfffff
    80004982:	ac2080e7          	jalr	-1342(ra) # 80003440 <nameiparent>
    80004986:	892a                	mv	s2,a0
    80004988:	c935                	beqz	a0,800049fc <sys_link+0x10a>
  ilock(dp);
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	2f2080e7          	jalr	754(ra) # 80002c7c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004992:	00092703          	lw	a4,0(s2)
    80004996:	409c                	lw	a5,0(s1)
    80004998:	04f71d63          	bne	a4,a5,800049f2 <sys_link+0x100>
    8000499c:	40d0                	lw	a2,4(s1)
    8000499e:	fd040593          	addi	a1,s0,-48
    800049a2:	854a                	mv	a0,s2
    800049a4:	fffff097          	auipc	ra,0xfffff
    800049a8:	9cc080e7          	jalr	-1588(ra) # 80003370 <dirlink>
    800049ac:	04054363          	bltz	a0,800049f2 <sys_link+0x100>
  iunlockput(dp);
    800049b0:	854a                	mv	a0,s2
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	52c080e7          	jalr	1324(ra) # 80002ede <iunlockput>
  iput(ip);
    800049ba:	8526                	mv	a0,s1
    800049bc:	ffffe097          	auipc	ra,0xffffe
    800049c0:	47a080e7          	jalr	1146(ra) # 80002e36 <iput>
  end_op();
    800049c4:	fffff097          	auipc	ra,0xfffff
    800049c8:	cfa080e7          	jalr	-774(ra) # 800036be <end_op>
  return 0;
    800049cc:	4781                	li	a5,0
    800049ce:	a085                	j	80004a2e <sys_link+0x13c>
    end_op();
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	cee080e7          	jalr	-786(ra) # 800036be <end_op>
    return -1;
    800049d8:	57fd                	li	a5,-1
    800049da:	a891                	j	80004a2e <sys_link+0x13c>
    iunlockput(ip);
    800049dc:	8526                	mv	a0,s1
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	500080e7          	jalr	1280(ra) # 80002ede <iunlockput>
    end_op();
    800049e6:	fffff097          	auipc	ra,0xfffff
    800049ea:	cd8080e7          	jalr	-808(ra) # 800036be <end_op>
    return -1;
    800049ee:	57fd                	li	a5,-1
    800049f0:	a83d                	j	80004a2e <sys_link+0x13c>
    iunlockput(dp);
    800049f2:	854a                	mv	a0,s2
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	4ea080e7          	jalr	1258(ra) # 80002ede <iunlockput>
  ilock(ip);
    800049fc:	8526                	mv	a0,s1
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	27e080e7          	jalr	638(ra) # 80002c7c <ilock>
  ip->nlink--;
    80004a06:	04a4d783          	lhu	a5,74(s1)
    80004a0a:	37fd                	addiw	a5,a5,-1
    80004a0c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a10:	8526                	mv	a0,s1
    80004a12:	ffffe097          	auipc	ra,0xffffe
    80004a16:	1a0080e7          	jalr	416(ra) # 80002bb2 <iupdate>
  iunlockput(ip);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	4c2080e7          	jalr	1218(ra) # 80002ede <iunlockput>
  end_op();
    80004a24:	fffff097          	auipc	ra,0xfffff
    80004a28:	c9a080e7          	jalr	-870(ra) # 800036be <end_op>
  return -1;
    80004a2c:	57fd                	li	a5,-1
}
    80004a2e:	853e                	mv	a0,a5
    80004a30:	70b2                	ld	ra,296(sp)
    80004a32:	7412                	ld	s0,288(sp)
    80004a34:	64f2                	ld	s1,280(sp)
    80004a36:	6952                	ld	s2,272(sp)
    80004a38:	6155                	addi	sp,sp,304
    80004a3a:	8082                	ret

0000000080004a3c <sys_unlink>:
{
    80004a3c:	7151                	addi	sp,sp,-240
    80004a3e:	f586                	sd	ra,232(sp)
    80004a40:	f1a2                	sd	s0,224(sp)
    80004a42:	eda6                	sd	s1,216(sp)
    80004a44:	e9ca                	sd	s2,208(sp)
    80004a46:	e5ce                	sd	s3,200(sp)
    80004a48:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004a4a:	08000613          	li	a2,128
    80004a4e:	f3040593          	addi	a1,s0,-208
    80004a52:	4501                	li	a0,0
    80004a54:	ffffd097          	auipc	ra,0xffffd
    80004a58:	5d6080e7          	jalr	1494(ra) # 8000202a <argstr>
    80004a5c:	18054163          	bltz	a0,80004bde <sys_unlink+0x1a2>
  begin_op();
    80004a60:	fffff097          	auipc	ra,0xfffff
    80004a64:	bde080e7          	jalr	-1058(ra) # 8000363e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004a68:	fb040593          	addi	a1,s0,-80
    80004a6c:	f3040513          	addi	a0,s0,-208
    80004a70:	fffff097          	auipc	ra,0xfffff
    80004a74:	9d0080e7          	jalr	-1584(ra) # 80003440 <nameiparent>
    80004a78:	84aa                	mv	s1,a0
    80004a7a:	c979                	beqz	a0,80004b50 <sys_unlink+0x114>
  ilock(dp);
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	200080e7          	jalr	512(ra) # 80002c7c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a84:	00004597          	auipc	a1,0x4
    80004a88:	cdc58593          	addi	a1,a1,-804 # 80008760 <syscalls+0x2b0>
    80004a8c:	fb040513          	addi	a0,s0,-80
    80004a90:	ffffe097          	auipc	ra,0xffffe
    80004a94:	6b6080e7          	jalr	1718(ra) # 80003146 <namecmp>
    80004a98:	14050a63          	beqz	a0,80004bec <sys_unlink+0x1b0>
    80004a9c:	00004597          	auipc	a1,0x4
    80004aa0:	ccc58593          	addi	a1,a1,-820 # 80008768 <syscalls+0x2b8>
    80004aa4:	fb040513          	addi	a0,s0,-80
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	69e080e7          	jalr	1694(ra) # 80003146 <namecmp>
    80004ab0:	12050e63          	beqz	a0,80004bec <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004ab4:	f2c40613          	addi	a2,s0,-212
    80004ab8:	fb040593          	addi	a1,s0,-80
    80004abc:	8526                	mv	a0,s1
    80004abe:	ffffe097          	auipc	ra,0xffffe
    80004ac2:	6a2080e7          	jalr	1698(ra) # 80003160 <dirlookup>
    80004ac6:	892a                	mv	s2,a0
    80004ac8:	12050263          	beqz	a0,80004bec <sys_unlink+0x1b0>
  ilock(ip);
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	1b0080e7          	jalr	432(ra) # 80002c7c <ilock>
  if(ip->nlink < 1)
    80004ad4:	04a91783          	lh	a5,74(s2)
    80004ad8:	08f05263          	blez	a5,80004b5c <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004adc:	04491703          	lh	a4,68(s2)
    80004ae0:	4785                	li	a5,1
    80004ae2:	08f70563          	beq	a4,a5,80004b6c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004ae6:	4641                	li	a2,16
    80004ae8:	4581                	li	a1,0
    80004aea:	fc040513          	addi	a0,s0,-64
    80004aee:	ffffb097          	auipc	ra,0xffffb
    80004af2:	6b0080e7          	jalr	1712(ra) # 8000019e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af6:	4741                	li	a4,16
    80004af8:	f2c42683          	lw	a3,-212(s0)
    80004afc:	fc040613          	addi	a2,s0,-64
    80004b00:	4581                	li	a1,0
    80004b02:	8526                	mv	a0,s1
    80004b04:	ffffe097          	auipc	ra,0xffffe
    80004b08:	524080e7          	jalr	1316(ra) # 80003028 <writei>
    80004b0c:	47c1                	li	a5,16
    80004b0e:	0af51563          	bne	a0,a5,80004bb8 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004b12:	04491703          	lh	a4,68(s2)
    80004b16:	4785                	li	a5,1
    80004b18:	0af70863          	beq	a4,a5,80004bc8 <sys_unlink+0x18c>
  iunlockput(dp);
    80004b1c:	8526                	mv	a0,s1
    80004b1e:	ffffe097          	auipc	ra,0xffffe
    80004b22:	3c0080e7          	jalr	960(ra) # 80002ede <iunlockput>
  ip->nlink--;
    80004b26:	04a95783          	lhu	a5,74(s2)
    80004b2a:	37fd                	addiw	a5,a5,-1
    80004b2c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b30:	854a                	mv	a0,s2
    80004b32:	ffffe097          	auipc	ra,0xffffe
    80004b36:	080080e7          	jalr	128(ra) # 80002bb2 <iupdate>
  iunlockput(ip);
    80004b3a:	854a                	mv	a0,s2
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	3a2080e7          	jalr	930(ra) # 80002ede <iunlockput>
  end_op();
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	b7a080e7          	jalr	-1158(ra) # 800036be <end_op>
  return 0;
    80004b4c:	4501                	li	a0,0
    80004b4e:	a84d                	j	80004c00 <sys_unlink+0x1c4>
    end_op();
    80004b50:	fffff097          	auipc	ra,0xfffff
    80004b54:	b6e080e7          	jalr	-1170(ra) # 800036be <end_op>
    return -1;
    80004b58:	557d                	li	a0,-1
    80004b5a:	a05d                	j	80004c00 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004b5c:	00004517          	auipc	a0,0x4
    80004b60:	c1450513          	addi	a0,a0,-1004 # 80008770 <syscalls+0x2c0>
    80004b64:	00001097          	auipc	ra,0x1
    80004b68:	21e080e7          	jalr	542(ra) # 80005d82 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b6c:	04c92703          	lw	a4,76(s2)
    80004b70:	02000793          	li	a5,32
    80004b74:	f6e7f9e3          	bgeu	a5,a4,80004ae6 <sys_unlink+0xaa>
    80004b78:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7c:	4741                	li	a4,16
    80004b7e:	86ce                	mv	a3,s3
    80004b80:	f1840613          	addi	a2,s0,-232
    80004b84:	4581                	li	a1,0
    80004b86:	854a                	mv	a0,s2
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	3a8080e7          	jalr	936(ra) # 80002f30 <readi>
    80004b90:	47c1                	li	a5,16
    80004b92:	00f51b63          	bne	a0,a5,80004ba8 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b96:	f1845783          	lhu	a5,-232(s0)
    80004b9a:	e7a1                	bnez	a5,80004be2 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b9c:	29c1                	addiw	s3,s3,16
    80004b9e:	04c92783          	lw	a5,76(s2)
    80004ba2:	fcf9ede3          	bltu	s3,a5,80004b7c <sys_unlink+0x140>
    80004ba6:	b781                	j	80004ae6 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004ba8:	00004517          	auipc	a0,0x4
    80004bac:	be050513          	addi	a0,a0,-1056 # 80008788 <syscalls+0x2d8>
    80004bb0:	00001097          	auipc	ra,0x1
    80004bb4:	1d2080e7          	jalr	466(ra) # 80005d82 <panic>
    panic("unlink: writei");
    80004bb8:	00004517          	auipc	a0,0x4
    80004bbc:	be850513          	addi	a0,a0,-1048 # 800087a0 <syscalls+0x2f0>
    80004bc0:	00001097          	auipc	ra,0x1
    80004bc4:	1c2080e7          	jalr	450(ra) # 80005d82 <panic>
    dp->nlink--;
    80004bc8:	04a4d783          	lhu	a5,74(s1)
    80004bcc:	37fd                	addiw	a5,a5,-1
    80004bce:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bd2:	8526                	mv	a0,s1
    80004bd4:	ffffe097          	auipc	ra,0xffffe
    80004bd8:	fde080e7          	jalr	-34(ra) # 80002bb2 <iupdate>
    80004bdc:	b781                	j	80004b1c <sys_unlink+0xe0>
    return -1;
    80004bde:	557d                	li	a0,-1
    80004be0:	a005                	j	80004c00 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004be2:	854a                	mv	a0,s2
    80004be4:	ffffe097          	auipc	ra,0xffffe
    80004be8:	2fa080e7          	jalr	762(ra) # 80002ede <iunlockput>
  iunlockput(dp);
    80004bec:	8526                	mv	a0,s1
    80004bee:	ffffe097          	auipc	ra,0xffffe
    80004bf2:	2f0080e7          	jalr	752(ra) # 80002ede <iunlockput>
  end_op();
    80004bf6:	fffff097          	auipc	ra,0xfffff
    80004bfa:	ac8080e7          	jalr	-1336(ra) # 800036be <end_op>
  return -1;
    80004bfe:	557d                	li	a0,-1
}
    80004c00:	70ae                	ld	ra,232(sp)
    80004c02:	740e                	ld	s0,224(sp)
    80004c04:	64ee                	ld	s1,216(sp)
    80004c06:	694e                	ld	s2,208(sp)
    80004c08:	69ae                	ld	s3,200(sp)
    80004c0a:	616d                	addi	sp,sp,240
    80004c0c:	8082                	ret

0000000080004c0e <sys_open>:

uint64
sys_open(void)
{
    80004c0e:	7131                	addi	sp,sp,-192
    80004c10:	fd06                	sd	ra,184(sp)
    80004c12:	f922                	sd	s0,176(sp)
    80004c14:	f526                	sd	s1,168(sp)
    80004c16:	f14a                	sd	s2,160(sp)
    80004c18:	ed4e                	sd	s3,152(sp)
    80004c1a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004c1c:	f4c40593          	addi	a1,s0,-180
    80004c20:	4505                	li	a0,1
    80004c22:	ffffd097          	auipc	ra,0xffffd
    80004c26:	3c8080e7          	jalr	968(ra) # 80001fea <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c2a:	08000613          	li	a2,128
    80004c2e:	f5040593          	addi	a1,s0,-176
    80004c32:	4501                	li	a0,0
    80004c34:	ffffd097          	auipc	ra,0xffffd
    80004c38:	3f6080e7          	jalr	1014(ra) # 8000202a <argstr>
    80004c3c:	87aa                	mv	a5,a0
    return -1;
    80004c3e:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004c40:	0a07c963          	bltz	a5,80004cf2 <sys_open+0xe4>

  begin_op();
    80004c44:	fffff097          	auipc	ra,0xfffff
    80004c48:	9fa080e7          	jalr	-1542(ra) # 8000363e <begin_op>

  if(omode & O_CREATE){
    80004c4c:	f4c42783          	lw	a5,-180(s0)
    80004c50:	2007f793          	andi	a5,a5,512
    80004c54:	cfc5                	beqz	a5,80004d0c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004c56:	4681                	li	a3,0
    80004c58:	4601                	li	a2,0
    80004c5a:	4589                	li	a1,2
    80004c5c:	f5040513          	addi	a0,s0,-176
    80004c60:	00000097          	auipc	ra,0x0
    80004c64:	974080e7          	jalr	-1676(ra) # 800045d4 <create>
    80004c68:	84aa                	mv	s1,a0
    if(ip == 0){
    80004c6a:	c959                	beqz	a0,80004d00 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004c6c:	04449703          	lh	a4,68(s1)
    80004c70:	478d                	li	a5,3
    80004c72:	00f71763          	bne	a4,a5,80004c80 <sys_open+0x72>
    80004c76:	0464d703          	lhu	a4,70(s1)
    80004c7a:	47a5                	li	a5,9
    80004c7c:	0ce7ed63          	bltu	a5,a4,80004d56 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004c80:	fffff097          	auipc	ra,0xfffff
    80004c84:	dce080e7          	jalr	-562(ra) # 80003a4e <filealloc>
    80004c88:	89aa                	mv	s3,a0
    80004c8a:	10050363          	beqz	a0,80004d90 <sys_open+0x182>
    80004c8e:	00000097          	auipc	ra,0x0
    80004c92:	904080e7          	jalr	-1788(ra) # 80004592 <fdalloc>
    80004c96:	892a                	mv	s2,a0
    80004c98:	0e054763          	bltz	a0,80004d86 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c9c:	04449703          	lh	a4,68(s1)
    80004ca0:	478d                	li	a5,3
    80004ca2:	0cf70563          	beq	a4,a5,80004d6c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ca6:	4789                	li	a5,2
    80004ca8:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004cac:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004cb0:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004cb4:	f4c42783          	lw	a5,-180(s0)
    80004cb8:	0017c713          	xori	a4,a5,1
    80004cbc:	8b05                	andi	a4,a4,1
    80004cbe:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004cc2:	0037f713          	andi	a4,a5,3
    80004cc6:	00e03733          	snez	a4,a4
    80004cca:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004cce:	4007f793          	andi	a5,a5,1024
    80004cd2:	c791                	beqz	a5,80004cde <sys_open+0xd0>
    80004cd4:	04449703          	lh	a4,68(s1)
    80004cd8:	4789                	li	a5,2
    80004cda:	0af70063          	beq	a4,a5,80004d7a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004cde:	8526                	mv	a0,s1
    80004ce0:	ffffe097          	auipc	ra,0xffffe
    80004ce4:	05e080e7          	jalr	94(ra) # 80002d3e <iunlock>
  end_op();
    80004ce8:	fffff097          	auipc	ra,0xfffff
    80004cec:	9d6080e7          	jalr	-1578(ra) # 800036be <end_op>

  return fd;
    80004cf0:	854a                	mv	a0,s2
}
    80004cf2:	70ea                	ld	ra,184(sp)
    80004cf4:	744a                	ld	s0,176(sp)
    80004cf6:	74aa                	ld	s1,168(sp)
    80004cf8:	790a                	ld	s2,160(sp)
    80004cfa:	69ea                	ld	s3,152(sp)
    80004cfc:	6129                	addi	sp,sp,192
    80004cfe:	8082                	ret
      end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	9be080e7          	jalr	-1602(ra) # 800036be <end_op>
      return -1;
    80004d08:	557d                	li	a0,-1
    80004d0a:	b7e5                	j	80004cf2 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004d0c:	f5040513          	addi	a0,s0,-176
    80004d10:	ffffe097          	auipc	ra,0xffffe
    80004d14:	712080e7          	jalr	1810(ra) # 80003422 <namei>
    80004d18:	84aa                	mv	s1,a0
    80004d1a:	c905                	beqz	a0,80004d4a <sys_open+0x13c>
    ilock(ip);
    80004d1c:	ffffe097          	auipc	ra,0xffffe
    80004d20:	f60080e7          	jalr	-160(ra) # 80002c7c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004d24:	04449703          	lh	a4,68(s1)
    80004d28:	4785                	li	a5,1
    80004d2a:	f4f711e3          	bne	a4,a5,80004c6c <sys_open+0x5e>
    80004d2e:	f4c42783          	lw	a5,-180(s0)
    80004d32:	d7b9                	beqz	a5,80004c80 <sys_open+0x72>
      iunlockput(ip);
    80004d34:	8526                	mv	a0,s1
    80004d36:	ffffe097          	auipc	ra,0xffffe
    80004d3a:	1a8080e7          	jalr	424(ra) # 80002ede <iunlockput>
      end_op();
    80004d3e:	fffff097          	auipc	ra,0xfffff
    80004d42:	980080e7          	jalr	-1664(ra) # 800036be <end_op>
      return -1;
    80004d46:	557d                	li	a0,-1
    80004d48:	b76d                	j	80004cf2 <sys_open+0xe4>
      end_op();
    80004d4a:	fffff097          	auipc	ra,0xfffff
    80004d4e:	974080e7          	jalr	-1676(ra) # 800036be <end_op>
      return -1;
    80004d52:	557d                	li	a0,-1
    80004d54:	bf79                	j	80004cf2 <sys_open+0xe4>
    iunlockput(ip);
    80004d56:	8526                	mv	a0,s1
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	186080e7          	jalr	390(ra) # 80002ede <iunlockput>
    end_op();
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	95e080e7          	jalr	-1698(ra) # 800036be <end_op>
    return -1;
    80004d68:	557d                	li	a0,-1
    80004d6a:	b761                	j	80004cf2 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004d6c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004d70:	04649783          	lh	a5,70(s1)
    80004d74:	02f99223          	sh	a5,36(s3)
    80004d78:	bf25                	j	80004cb0 <sys_open+0xa2>
    itrunc(ip);
    80004d7a:	8526                	mv	a0,s1
    80004d7c:	ffffe097          	auipc	ra,0xffffe
    80004d80:	00e080e7          	jalr	14(ra) # 80002d8a <itrunc>
    80004d84:	bfa9                	j	80004cde <sys_open+0xd0>
      fileclose(f);
    80004d86:	854e                	mv	a0,s3
    80004d88:	fffff097          	auipc	ra,0xfffff
    80004d8c:	d82080e7          	jalr	-638(ra) # 80003b0a <fileclose>
    iunlockput(ip);
    80004d90:	8526                	mv	a0,s1
    80004d92:	ffffe097          	auipc	ra,0xffffe
    80004d96:	14c080e7          	jalr	332(ra) # 80002ede <iunlockput>
    end_op();
    80004d9a:	fffff097          	auipc	ra,0xfffff
    80004d9e:	924080e7          	jalr	-1756(ra) # 800036be <end_op>
    return -1;
    80004da2:	557d                	li	a0,-1
    80004da4:	b7b9                	j	80004cf2 <sys_open+0xe4>

0000000080004da6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004da6:	7175                	addi	sp,sp,-144
    80004da8:	e506                	sd	ra,136(sp)
    80004daa:	e122                	sd	s0,128(sp)
    80004dac:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004dae:	fffff097          	auipc	ra,0xfffff
    80004db2:	890080e7          	jalr	-1904(ra) # 8000363e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004db6:	08000613          	li	a2,128
    80004dba:	f7040593          	addi	a1,s0,-144
    80004dbe:	4501                	li	a0,0
    80004dc0:	ffffd097          	auipc	ra,0xffffd
    80004dc4:	26a080e7          	jalr	618(ra) # 8000202a <argstr>
    80004dc8:	02054963          	bltz	a0,80004dfa <sys_mkdir+0x54>
    80004dcc:	4681                	li	a3,0
    80004dce:	4601                	li	a2,0
    80004dd0:	4585                	li	a1,1
    80004dd2:	f7040513          	addi	a0,s0,-144
    80004dd6:	fffff097          	auipc	ra,0xfffff
    80004dda:	7fe080e7          	jalr	2046(ra) # 800045d4 <create>
    80004dde:	cd11                	beqz	a0,80004dfa <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004de0:	ffffe097          	auipc	ra,0xffffe
    80004de4:	0fe080e7          	jalr	254(ra) # 80002ede <iunlockput>
  end_op();
    80004de8:	fffff097          	auipc	ra,0xfffff
    80004dec:	8d6080e7          	jalr	-1834(ra) # 800036be <end_op>
  return 0;
    80004df0:	4501                	li	a0,0
}
    80004df2:	60aa                	ld	ra,136(sp)
    80004df4:	640a                	ld	s0,128(sp)
    80004df6:	6149                	addi	sp,sp,144
    80004df8:	8082                	ret
    end_op();
    80004dfa:	fffff097          	auipc	ra,0xfffff
    80004dfe:	8c4080e7          	jalr	-1852(ra) # 800036be <end_op>
    return -1;
    80004e02:	557d                	li	a0,-1
    80004e04:	b7fd                	j	80004df2 <sys_mkdir+0x4c>

0000000080004e06 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004e06:	7135                	addi	sp,sp,-160
    80004e08:	ed06                	sd	ra,152(sp)
    80004e0a:	e922                	sd	s0,144(sp)
    80004e0c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	830080e7          	jalr	-2000(ra) # 8000363e <begin_op>
  argint(1, &major);
    80004e16:	f6c40593          	addi	a1,s0,-148
    80004e1a:	4505                	li	a0,1
    80004e1c:	ffffd097          	auipc	ra,0xffffd
    80004e20:	1ce080e7          	jalr	462(ra) # 80001fea <argint>
  argint(2, &minor);
    80004e24:	f6840593          	addi	a1,s0,-152
    80004e28:	4509                	li	a0,2
    80004e2a:	ffffd097          	auipc	ra,0xffffd
    80004e2e:	1c0080e7          	jalr	448(ra) # 80001fea <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e32:	08000613          	li	a2,128
    80004e36:	f7040593          	addi	a1,s0,-144
    80004e3a:	4501                	li	a0,0
    80004e3c:	ffffd097          	auipc	ra,0xffffd
    80004e40:	1ee080e7          	jalr	494(ra) # 8000202a <argstr>
    80004e44:	02054b63          	bltz	a0,80004e7a <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004e48:	f6841683          	lh	a3,-152(s0)
    80004e4c:	f6c41603          	lh	a2,-148(s0)
    80004e50:	458d                	li	a1,3
    80004e52:	f7040513          	addi	a0,s0,-144
    80004e56:	fffff097          	auipc	ra,0xfffff
    80004e5a:	77e080e7          	jalr	1918(ra) # 800045d4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004e5e:	cd11                	beqz	a0,80004e7a <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	07e080e7          	jalr	126(ra) # 80002ede <iunlockput>
  end_op();
    80004e68:	fffff097          	auipc	ra,0xfffff
    80004e6c:	856080e7          	jalr	-1962(ra) # 800036be <end_op>
  return 0;
    80004e70:	4501                	li	a0,0
}
    80004e72:	60ea                	ld	ra,152(sp)
    80004e74:	644a                	ld	s0,144(sp)
    80004e76:	610d                	addi	sp,sp,160
    80004e78:	8082                	ret
    end_op();
    80004e7a:	fffff097          	auipc	ra,0xfffff
    80004e7e:	844080e7          	jalr	-1980(ra) # 800036be <end_op>
    return -1;
    80004e82:	557d                	li	a0,-1
    80004e84:	b7fd                	j	80004e72 <sys_mknod+0x6c>

0000000080004e86 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004e86:	7135                	addi	sp,sp,-160
    80004e88:	ed06                	sd	ra,152(sp)
    80004e8a:	e922                	sd	s0,144(sp)
    80004e8c:	e526                	sd	s1,136(sp)
    80004e8e:	e14a                	sd	s2,128(sp)
    80004e90:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e92:	ffffc097          	auipc	ra,0xffffc
    80004e96:	fec080e7          	jalr	-20(ra) # 80000e7e <myproc>
    80004e9a:	892a                	mv	s2,a0
  
  begin_op();
    80004e9c:	ffffe097          	auipc	ra,0xffffe
    80004ea0:	7a2080e7          	jalr	1954(ra) # 8000363e <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004ea4:	08000613          	li	a2,128
    80004ea8:	f6040593          	addi	a1,s0,-160
    80004eac:	4501                	li	a0,0
    80004eae:	ffffd097          	auipc	ra,0xffffd
    80004eb2:	17c080e7          	jalr	380(ra) # 8000202a <argstr>
    80004eb6:	04054b63          	bltz	a0,80004f0c <sys_chdir+0x86>
    80004eba:	f6040513          	addi	a0,s0,-160
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	564080e7          	jalr	1380(ra) # 80003422 <namei>
    80004ec6:	84aa                	mv	s1,a0
    80004ec8:	c131                	beqz	a0,80004f0c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004eca:	ffffe097          	auipc	ra,0xffffe
    80004ece:	db2080e7          	jalr	-590(ra) # 80002c7c <ilock>
  if(ip->type != T_DIR){
    80004ed2:	04449703          	lh	a4,68(s1)
    80004ed6:	4785                	li	a5,1
    80004ed8:	04f71063          	bne	a4,a5,80004f18 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004edc:	8526                	mv	a0,s1
    80004ede:	ffffe097          	auipc	ra,0xffffe
    80004ee2:	e60080e7          	jalr	-416(ra) # 80002d3e <iunlock>
  iput(p->cwd);
    80004ee6:	15093503          	ld	a0,336(s2)
    80004eea:	ffffe097          	auipc	ra,0xffffe
    80004eee:	f4c080e7          	jalr	-180(ra) # 80002e36 <iput>
  end_op();
    80004ef2:	ffffe097          	auipc	ra,0xffffe
    80004ef6:	7cc080e7          	jalr	1996(ra) # 800036be <end_op>
  p->cwd = ip;
    80004efa:	14993823          	sd	s1,336(s2)
  return 0;
    80004efe:	4501                	li	a0,0
}
    80004f00:	60ea                	ld	ra,152(sp)
    80004f02:	644a                	ld	s0,144(sp)
    80004f04:	64aa                	ld	s1,136(sp)
    80004f06:	690a                	ld	s2,128(sp)
    80004f08:	610d                	addi	sp,sp,160
    80004f0a:	8082                	ret
    end_op();
    80004f0c:	ffffe097          	auipc	ra,0xffffe
    80004f10:	7b2080e7          	jalr	1970(ra) # 800036be <end_op>
    return -1;
    80004f14:	557d                	li	a0,-1
    80004f16:	b7ed                	j	80004f00 <sys_chdir+0x7a>
    iunlockput(ip);
    80004f18:	8526                	mv	a0,s1
    80004f1a:	ffffe097          	auipc	ra,0xffffe
    80004f1e:	fc4080e7          	jalr	-60(ra) # 80002ede <iunlockput>
    end_op();
    80004f22:	ffffe097          	auipc	ra,0xffffe
    80004f26:	79c080e7          	jalr	1948(ra) # 800036be <end_op>
    return -1;
    80004f2a:	557d                	li	a0,-1
    80004f2c:	bfd1                	j	80004f00 <sys_chdir+0x7a>

0000000080004f2e <sys_exec>:

uint64
sys_exec(void)
{
    80004f2e:	7145                	addi	sp,sp,-464
    80004f30:	e786                	sd	ra,456(sp)
    80004f32:	e3a2                	sd	s0,448(sp)
    80004f34:	ff26                	sd	s1,440(sp)
    80004f36:	fb4a                	sd	s2,432(sp)
    80004f38:	f74e                	sd	s3,424(sp)
    80004f3a:	f352                	sd	s4,416(sp)
    80004f3c:	ef56                	sd	s5,408(sp)
    80004f3e:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004f40:	e3840593          	addi	a1,s0,-456
    80004f44:	4505                	li	a0,1
    80004f46:	ffffd097          	auipc	ra,0xffffd
    80004f4a:	0c4080e7          	jalr	196(ra) # 8000200a <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004f4e:	08000613          	li	a2,128
    80004f52:	f4040593          	addi	a1,s0,-192
    80004f56:	4501                	li	a0,0
    80004f58:	ffffd097          	auipc	ra,0xffffd
    80004f5c:	0d2080e7          	jalr	210(ra) # 8000202a <argstr>
    80004f60:	87aa                	mv	a5,a0
    return -1;
    80004f62:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004f64:	0c07c263          	bltz	a5,80005028 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004f68:	10000613          	li	a2,256
    80004f6c:	4581                	li	a1,0
    80004f6e:	e4040513          	addi	a0,s0,-448
    80004f72:	ffffb097          	auipc	ra,0xffffb
    80004f76:	22c080e7          	jalr	556(ra) # 8000019e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004f7a:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004f7e:	89a6                	mv	s3,s1
    80004f80:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004f82:	02000a13          	li	s4,32
    80004f86:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f8a:	00391513          	slli	a0,s2,0x3
    80004f8e:	e3040593          	addi	a1,s0,-464
    80004f92:	e3843783          	ld	a5,-456(s0)
    80004f96:	953e                	add	a0,a0,a5
    80004f98:	ffffd097          	auipc	ra,0xffffd
    80004f9c:	fb4080e7          	jalr	-76(ra) # 80001f4c <fetchaddr>
    80004fa0:	02054a63          	bltz	a0,80004fd4 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004fa4:	e3043783          	ld	a5,-464(s0)
    80004fa8:	c3b9                	beqz	a5,80004fee <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004faa:	ffffb097          	auipc	ra,0xffffb
    80004fae:	16e080e7          	jalr	366(ra) # 80000118 <kalloc>
    80004fb2:	85aa                	mv	a1,a0
    80004fb4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004fb8:	cd11                	beqz	a0,80004fd4 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004fba:	6605                	lui	a2,0x1
    80004fbc:	e3043503          	ld	a0,-464(s0)
    80004fc0:	ffffd097          	auipc	ra,0xffffd
    80004fc4:	fde080e7          	jalr	-34(ra) # 80001f9e <fetchstr>
    80004fc8:	00054663          	bltz	a0,80004fd4 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004fcc:	0905                	addi	s2,s2,1
    80004fce:	09a1                	addi	s3,s3,8
    80004fd0:	fb491be3          	bne	s2,s4,80004f86 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fd4:	10048913          	addi	s2,s1,256
    80004fd8:	6088                	ld	a0,0(s1)
    80004fda:	c531                	beqz	a0,80005026 <sys_exec+0xf8>
    kfree(argv[i]);
    80004fdc:	ffffb097          	auipc	ra,0xffffb
    80004fe0:	040080e7          	jalr	64(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004fe4:	04a1                	addi	s1,s1,8
    80004fe6:	ff2499e3          	bne	s1,s2,80004fd8 <sys_exec+0xaa>
  return -1;
    80004fea:	557d                	li	a0,-1
    80004fec:	a835                	j	80005028 <sys_exec+0xfa>
      argv[i] = 0;
    80004fee:	0a8e                	slli	s5,s5,0x3
    80004ff0:	fc040793          	addi	a5,s0,-64
    80004ff4:	9abe                	add	s5,s5,a5
    80004ff6:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004ffa:	e4040593          	addi	a1,s0,-448
    80004ffe:	f4040513          	addi	a0,s0,-192
    80005002:	fffff097          	auipc	ra,0xfffff
    80005006:	190080e7          	jalr	400(ra) # 80004192 <exec>
    8000500a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000500c:	10048993          	addi	s3,s1,256
    80005010:	6088                	ld	a0,0(s1)
    80005012:	c901                	beqz	a0,80005022 <sys_exec+0xf4>
    kfree(argv[i]);
    80005014:	ffffb097          	auipc	ra,0xffffb
    80005018:	008080e7          	jalr	8(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000501c:	04a1                	addi	s1,s1,8
    8000501e:	ff3499e3          	bne	s1,s3,80005010 <sys_exec+0xe2>
  return ret;
    80005022:	854a                	mv	a0,s2
    80005024:	a011                	j	80005028 <sys_exec+0xfa>
  return -1;
    80005026:	557d                	li	a0,-1
}
    80005028:	60be                	ld	ra,456(sp)
    8000502a:	641e                	ld	s0,448(sp)
    8000502c:	74fa                	ld	s1,440(sp)
    8000502e:	795a                	ld	s2,432(sp)
    80005030:	79ba                	ld	s3,424(sp)
    80005032:	7a1a                	ld	s4,416(sp)
    80005034:	6afa                	ld	s5,408(sp)
    80005036:	6179                	addi	sp,sp,464
    80005038:	8082                	ret

000000008000503a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000503a:	7139                	addi	sp,sp,-64
    8000503c:	fc06                	sd	ra,56(sp)
    8000503e:	f822                	sd	s0,48(sp)
    80005040:	f426                	sd	s1,40(sp)
    80005042:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005044:	ffffc097          	auipc	ra,0xffffc
    80005048:	e3a080e7          	jalr	-454(ra) # 80000e7e <myproc>
    8000504c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000504e:	fd840593          	addi	a1,s0,-40
    80005052:	4501                	li	a0,0
    80005054:	ffffd097          	auipc	ra,0xffffd
    80005058:	fb6080e7          	jalr	-74(ra) # 8000200a <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000505c:	fc840593          	addi	a1,s0,-56
    80005060:	fd040513          	addi	a0,s0,-48
    80005064:	fffff097          	auipc	ra,0xfffff
    80005068:	dd6080e7          	jalr	-554(ra) # 80003e3a <pipealloc>
    return -1;
    8000506c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000506e:	0c054463          	bltz	a0,80005136 <sys_pipe+0xfc>
  fd0 = -1;
    80005072:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005076:	fd043503          	ld	a0,-48(s0)
    8000507a:	fffff097          	auipc	ra,0xfffff
    8000507e:	518080e7          	jalr	1304(ra) # 80004592 <fdalloc>
    80005082:	fca42223          	sw	a0,-60(s0)
    80005086:	08054b63          	bltz	a0,8000511c <sys_pipe+0xe2>
    8000508a:	fc843503          	ld	a0,-56(s0)
    8000508e:	fffff097          	auipc	ra,0xfffff
    80005092:	504080e7          	jalr	1284(ra) # 80004592 <fdalloc>
    80005096:	fca42023          	sw	a0,-64(s0)
    8000509a:	06054863          	bltz	a0,8000510a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000509e:	4691                	li	a3,4
    800050a0:	fc440613          	addi	a2,s0,-60
    800050a4:	fd843583          	ld	a1,-40(s0)
    800050a8:	68a8                	ld	a0,80(s1)
    800050aa:	ffffc097          	auipc	ra,0xffffc
    800050ae:	a92080e7          	jalr	-1390(ra) # 80000b3c <copyout>
    800050b2:	02054063          	bltz	a0,800050d2 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800050b6:	4691                	li	a3,4
    800050b8:	fc040613          	addi	a2,s0,-64
    800050bc:	fd843583          	ld	a1,-40(s0)
    800050c0:	0591                	addi	a1,a1,4
    800050c2:	68a8                	ld	a0,80(s1)
    800050c4:	ffffc097          	auipc	ra,0xffffc
    800050c8:	a78080e7          	jalr	-1416(ra) # 80000b3c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800050cc:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800050ce:	06055463          	bgez	a0,80005136 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800050d2:	fc442783          	lw	a5,-60(s0)
    800050d6:	07e9                	addi	a5,a5,26
    800050d8:	078e                	slli	a5,a5,0x3
    800050da:	97a6                	add	a5,a5,s1
    800050dc:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800050e0:	fc042503          	lw	a0,-64(s0)
    800050e4:	0569                	addi	a0,a0,26
    800050e6:	050e                	slli	a0,a0,0x3
    800050e8:	94aa                	add	s1,s1,a0
    800050ea:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800050ee:	fd043503          	ld	a0,-48(s0)
    800050f2:	fffff097          	auipc	ra,0xfffff
    800050f6:	a18080e7          	jalr	-1512(ra) # 80003b0a <fileclose>
    fileclose(wf);
    800050fa:	fc843503          	ld	a0,-56(s0)
    800050fe:	fffff097          	auipc	ra,0xfffff
    80005102:	a0c080e7          	jalr	-1524(ra) # 80003b0a <fileclose>
    return -1;
    80005106:	57fd                	li	a5,-1
    80005108:	a03d                	j	80005136 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000510a:	fc442783          	lw	a5,-60(s0)
    8000510e:	0007c763          	bltz	a5,8000511c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005112:	07e9                	addi	a5,a5,26
    80005114:	078e                	slli	a5,a5,0x3
    80005116:	94be                	add	s1,s1,a5
    80005118:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000511c:	fd043503          	ld	a0,-48(s0)
    80005120:	fffff097          	auipc	ra,0xfffff
    80005124:	9ea080e7          	jalr	-1558(ra) # 80003b0a <fileclose>
    fileclose(wf);
    80005128:	fc843503          	ld	a0,-56(s0)
    8000512c:	fffff097          	auipc	ra,0xfffff
    80005130:	9de080e7          	jalr	-1570(ra) # 80003b0a <fileclose>
    return -1;
    80005134:	57fd                	li	a5,-1
}
    80005136:	853e                	mv	a0,a5
    80005138:	70e2                	ld	ra,56(sp)
    8000513a:	7442                	ld	s0,48(sp)
    8000513c:	74a2                	ld	s1,40(sp)
    8000513e:	6121                	addi	sp,sp,64
    80005140:	8082                	ret
	...

0000000080005150 <kernelvec>:
    80005150:	7111                	addi	sp,sp,-256
    80005152:	e006                	sd	ra,0(sp)
    80005154:	e40a                	sd	sp,8(sp)
    80005156:	e80e                	sd	gp,16(sp)
    80005158:	ec12                	sd	tp,24(sp)
    8000515a:	f016                	sd	t0,32(sp)
    8000515c:	f41a                	sd	t1,40(sp)
    8000515e:	f81e                	sd	t2,48(sp)
    80005160:	fc22                	sd	s0,56(sp)
    80005162:	e0a6                	sd	s1,64(sp)
    80005164:	e4aa                	sd	a0,72(sp)
    80005166:	e8ae                	sd	a1,80(sp)
    80005168:	ecb2                	sd	a2,88(sp)
    8000516a:	f0b6                	sd	a3,96(sp)
    8000516c:	f4ba                	sd	a4,104(sp)
    8000516e:	f8be                	sd	a5,112(sp)
    80005170:	fcc2                	sd	a6,120(sp)
    80005172:	e146                	sd	a7,128(sp)
    80005174:	e54a                	sd	s2,136(sp)
    80005176:	e94e                	sd	s3,144(sp)
    80005178:	ed52                	sd	s4,152(sp)
    8000517a:	f156                	sd	s5,160(sp)
    8000517c:	f55a                	sd	s6,168(sp)
    8000517e:	f95e                	sd	s7,176(sp)
    80005180:	fd62                	sd	s8,184(sp)
    80005182:	e1e6                	sd	s9,192(sp)
    80005184:	e5ea                	sd	s10,200(sp)
    80005186:	e9ee                	sd	s11,208(sp)
    80005188:	edf2                	sd	t3,216(sp)
    8000518a:	f1f6                	sd	t4,224(sp)
    8000518c:	f5fa                	sd	t5,232(sp)
    8000518e:	f9fe                	sd	t6,240(sp)
    80005190:	c89fc0ef          	jal	ra,80001e18 <kerneltrap>
    80005194:	6082                	ld	ra,0(sp)
    80005196:	6122                	ld	sp,8(sp)
    80005198:	61c2                	ld	gp,16(sp)
    8000519a:	7282                	ld	t0,32(sp)
    8000519c:	7322                	ld	t1,40(sp)
    8000519e:	73c2                	ld	t2,48(sp)
    800051a0:	7462                	ld	s0,56(sp)
    800051a2:	6486                	ld	s1,64(sp)
    800051a4:	6526                	ld	a0,72(sp)
    800051a6:	65c6                	ld	a1,80(sp)
    800051a8:	6666                	ld	a2,88(sp)
    800051aa:	7686                	ld	a3,96(sp)
    800051ac:	7726                	ld	a4,104(sp)
    800051ae:	77c6                	ld	a5,112(sp)
    800051b0:	7866                	ld	a6,120(sp)
    800051b2:	688a                	ld	a7,128(sp)
    800051b4:	692a                	ld	s2,136(sp)
    800051b6:	69ca                	ld	s3,144(sp)
    800051b8:	6a6a                	ld	s4,152(sp)
    800051ba:	7a8a                	ld	s5,160(sp)
    800051bc:	7b2a                	ld	s6,168(sp)
    800051be:	7bca                	ld	s7,176(sp)
    800051c0:	7c6a                	ld	s8,184(sp)
    800051c2:	6c8e                	ld	s9,192(sp)
    800051c4:	6d2e                	ld	s10,200(sp)
    800051c6:	6dce                	ld	s11,208(sp)
    800051c8:	6e6e                	ld	t3,216(sp)
    800051ca:	7e8e                	ld	t4,224(sp)
    800051cc:	7f2e                	ld	t5,232(sp)
    800051ce:	7fce                	ld	t6,240(sp)
    800051d0:	6111                	addi	sp,sp,256
    800051d2:	10200073          	sret
    800051d6:	00000013          	nop
    800051da:	00000013          	nop
    800051de:	0001                	nop

00000000800051e0 <timervec>:
    800051e0:	34051573          	csrrw	a0,mscratch,a0
    800051e4:	e10c                	sd	a1,0(a0)
    800051e6:	e510                	sd	a2,8(a0)
    800051e8:	e914                	sd	a3,16(a0)
    800051ea:	6d0c                	ld	a1,24(a0)
    800051ec:	7110                	ld	a2,32(a0)
    800051ee:	6194                	ld	a3,0(a1)
    800051f0:	96b2                	add	a3,a3,a2
    800051f2:	e194                	sd	a3,0(a1)
    800051f4:	4589                	li	a1,2
    800051f6:	14459073          	csrw	sip,a1
    800051fa:	6914                	ld	a3,16(a0)
    800051fc:	6510                	ld	a2,8(a0)
    800051fe:	610c                	ld	a1,0(a0)
    80005200:	34051573          	csrrw	a0,mscratch,a0
    80005204:	30200073          	mret
	...

000000008000520a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000520a:	1141                	addi	sp,sp,-16
    8000520c:	e422                	sd	s0,8(sp)
    8000520e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005210:	0c0007b7          	lui	a5,0xc000
    80005214:	4705                	li	a4,1
    80005216:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005218:	c3d8                	sw	a4,4(a5)
}
    8000521a:	6422                	ld	s0,8(sp)
    8000521c:	0141                	addi	sp,sp,16
    8000521e:	8082                	ret

0000000080005220 <plicinithart>:

void
plicinithart(void)
{
    80005220:	1141                	addi	sp,sp,-16
    80005222:	e406                	sd	ra,8(sp)
    80005224:	e022                	sd	s0,0(sp)
    80005226:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005228:	ffffc097          	auipc	ra,0xffffc
    8000522c:	c2a080e7          	jalr	-982(ra) # 80000e52 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005230:	0085171b          	slliw	a4,a0,0x8
    80005234:	0c0027b7          	lui	a5,0xc002
    80005238:	97ba                	add	a5,a5,a4
    8000523a:	40200713          	li	a4,1026
    8000523e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005242:	00d5151b          	slliw	a0,a0,0xd
    80005246:	0c2017b7          	lui	a5,0xc201
    8000524a:	953e                	add	a0,a0,a5
    8000524c:	00052023          	sw	zero,0(a0)
}
    80005250:	60a2                	ld	ra,8(sp)
    80005252:	6402                	ld	s0,0(sp)
    80005254:	0141                	addi	sp,sp,16
    80005256:	8082                	ret

0000000080005258 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005258:	1141                	addi	sp,sp,-16
    8000525a:	e406                	sd	ra,8(sp)
    8000525c:	e022                	sd	s0,0(sp)
    8000525e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005260:	ffffc097          	auipc	ra,0xffffc
    80005264:	bf2080e7          	jalr	-1038(ra) # 80000e52 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005268:	00d5179b          	slliw	a5,a0,0xd
    8000526c:	0c201537          	lui	a0,0xc201
    80005270:	953e                	add	a0,a0,a5
  return irq;
}
    80005272:	4148                	lw	a0,4(a0)
    80005274:	60a2                	ld	ra,8(sp)
    80005276:	6402                	ld	s0,0(sp)
    80005278:	0141                	addi	sp,sp,16
    8000527a:	8082                	ret

000000008000527c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000527c:	1101                	addi	sp,sp,-32
    8000527e:	ec06                	sd	ra,24(sp)
    80005280:	e822                	sd	s0,16(sp)
    80005282:	e426                	sd	s1,8(sp)
    80005284:	1000                	addi	s0,sp,32
    80005286:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	bca080e7          	jalr	-1078(ra) # 80000e52 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005290:	00d5151b          	slliw	a0,a0,0xd
    80005294:	0c2017b7          	lui	a5,0xc201
    80005298:	97aa                	add	a5,a5,a0
    8000529a:	c3c4                	sw	s1,4(a5)
}
    8000529c:	60e2                	ld	ra,24(sp)
    8000529e:	6442                	ld	s0,16(sp)
    800052a0:	64a2                	ld	s1,8(sp)
    800052a2:	6105                	addi	sp,sp,32
    800052a4:	8082                	ret

00000000800052a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800052a6:	1141                	addi	sp,sp,-16
    800052a8:	e406                	sd	ra,8(sp)
    800052aa:	e022                	sd	s0,0(sp)
    800052ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800052ae:	479d                	li	a5,7
    800052b0:	04a7cc63          	blt	a5,a0,80005308 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800052b4:	00015797          	auipc	a5,0x15
    800052b8:	acc78793          	addi	a5,a5,-1332 # 80019d80 <disk>
    800052bc:	97aa                	add	a5,a5,a0
    800052be:	0187c783          	lbu	a5,24(a5)
    800052c2:	ebb9                	bnez	a5,80005318 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800052c4:	00451613          	slli	a2,a0,0x4
    800052c8:	00015797          	auipc	a5,0x15
    800052cc:	ab878793          	addi	a5,a5,-1352 # 80019d80 <disk>
    800052d0:	6394                	ld	a3,0(a5)
    800052d2:	96b2                	add	a3,a3,a2
    800052d4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800052d8:	6398                	ld	a4,0(a5)
    800052da:	9732                	add	a4,a4,a2
    800052dc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800052e0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800052e4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800052e8:	953e                	add	a0,a0,a5
    800052ea:	4785                	li	a5,1
    800052ec:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800052f0:	00015517          	auipc	a0,0x15
    800052f4:	aa850513          	addi	a0,a0,-1368 # 80019d98 <disk+0x18>
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	296080e7          	jalr	662(ra) # 8000158e <wakeup>
}
    80005300:	60a2                	ld	ra,8(sp)
    80005302:	6402                	ld	s0,0(sp)
    80005304:	0141                	addi	sp,sp,16
    80005306:	8082                	ret
    panic("free_desc 1");
    80005308:	00003517          	auipc	a0,0x3
    8000530c:	4a850513          	addi	a0,a0,1192 # 800087b0 <syscalls+0x300>
    80005310:	00001097          	auipc	ra,0x1
    80005314:	a72080e7          	jalr	-1422(ra) # 80005d82 <panic>
    panic("free_desc 2");
    80005318:	00003517          	auipc	a0,0x3
    8000531c:	4a850513          	addi	a0,a0,1192 # 800087c0 <syscalls+0x310>
    80005320:	00001097          	auipc	ra,0x1
    80005324:	a62080e7          	jalr	-1438(ra) # 80005d82 <panic>

0000000080005328 <virtio_disk_init>:
{
    80005328:	1101                	addi	sp,sp,-32
    8000532a:	ec06                	sd	ra,24(sp)
    8000532c:	e822                	sd	s0,16(sp)
    8000532e:	e426                	sd	s1,8(sp)
    80005330:	e04a                	sd	s2,0(sp)
    80005332:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005334:	00003597          	auipc	a1,0x3
    80005338:	49c58593          	addi	a1,a1,1180 # 800087d0 <syscalls+0x320>
    8000533c:	00015517          	auipc	a0,0x15
    80005340:	b6c50513          	addi	a0,a0,-1172 # 80019ea8 <disk+0x128>
    80005344:	00001097          	auipc	ra,0x1
    80005348:	ef8080e7          	jalr	-264(ra) # 8000623c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000534c:	100017b7          	lui	a5,0x10001
    80005350:	4398                	lw	a4,0(a5)
    80005352:	2701                	sext.w	a4,a4
    80005354:	747277b7          	lui	a5,0x74727
    80005358:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000535c:	14f71e63          	bne	a4,a5,800054b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005360:	100017b7          	lui	a5,0x10001
    80005364:	43dc                	lw	a5,4(a5)
    80005366:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005368:	4709                	li	a4,2
    8000536a:	14e79763          	bne	a5,a4,800054b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000536e:	100017b7          	lui	a5,0x10001
    80005372:	479c                	lw	a5,8(a5)
    80005374:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005376:	14e79163          	bne	a5,a4,800054b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000537a:	100017b7          	lui	a5,0x10001
    8000537e:	47d8                	lw	a4,12(a5)
    80005380:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005382:	554d47b7          	lui	a5,0x554d4
    80005386:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000538a:	12f71763          	bne	a4,a5,800054b8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000538e:	100017b7          	lui	a5,0x10001
    80005392:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005396:	4705                	li	a4,1
    80005398:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000539a:	470d                	li	a4,3
    8000539c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000539e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800053a0:	c7ffe737          	lui	a4,0xc7ffe
    800053a4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc65f>
    800053a8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800053aa:	2701                	sext.w	a4,a4
    800053ac:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800053ae:	472d                	li	a4,11
    800053b0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800053b2:	0707a903          	lw	s2,112(a5)
    800053b6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800053b8:	00897793          	andi	a5,s2,8
    800053bc:	10078663          	beqz	a5,800054c8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800053c0:	100017b7          	lui	a5,0x10001
    800053c4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800053c8:	43fc                	lw	a5,68(a5)
    800053ca:	2781                	sext.w	a5,a5
    800053cc:	10079663          	bnez	a5,800054d8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800053d0:	100017b7          	lui	a5,0x10001
    800053d4:	5bdc                	lw	a5,52(a5)
    800053d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800053d8:	10078863          	beqz	a5,800054e8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800053dc:	471d                	li	a4,7
    800053de:	10f77d63          	bgeu	a4,a5,800054f8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800053e2:	ffffb097          	auipc	ra,0xffffb
    800053e6:	d36080e7          	jalr	-714(ra) # 80000118 <kalloc>
    800053ea:	00015497          	auipc	s1,0x15
    800053ee:	99648493          	addi	s1,s1,-1642 # 80019d80 <disk>
    800053f2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800053f4:	ffffb097          	auipc	ra,0xffffb
    800053f8:	d24080e7          	jalr	-732(ra) # 80000118 <kalloc>
    800053fc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800053fe:	ffffb097          	auipc	ra,0xffffb
    80005402:	d1a080e7          	jalr	-742(ra) # 80000118 <kalloc>
    80005406:	87aa                	mv	a5,a0
    80005408:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000540a:	6088                	ld	a0,0(s1)
    8000540c:	cd75                	beqz	a0,80005508 <virtio_disk_init+0x1e0>
    8000540e:	00015717          	auipc	a4,0x15
    80005412:	97a73703          	ld	a4,-1670(a4) # 80019d88 <disk+0x8>
    80005416:	cb6d                	beqz	a4,80005508 <virtio_disk_init+0x1e0>
    80005418:	cbe5                	beqz	a5,80005508 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000541a:	6605                	lui	a2,0x1
    8000541c:	4581                	li	a1,0
    8000541e:	ffffb097          	auipc	ra,0xffffb
    80005422:	d80080e7          	jalr	-640(ra) # 8000019e <memset>
  memset(disk.avail, 0, PGSIZE);
    80005426:	00015497          	auipc	s1,0x15
    8000542a:	95a48493          	addi	s1,s1,-1702 # 80019d80 <disk>
    8000542e:	6605                	lui	a2,0x1
    80005430:	4581                	li	a1,0
    80005432:	6488                	ld	a0,8(s1)
    80005434:	ffffb097          	auipc	ra,0xffffb
    80005438:	d6a080e7          	jalr	-662(ra) # 8000019e <memset>
  memset(disk.used, 0, PGSIZE);
    8000543c:	6605                	lui	a2,0x1
    8000543e:	4581                	li	a1,0
    80005440:	6888                	ld	a0,16(s1)
    80005442:	ffffb097          	auipc	ra,0xffffb
    80005446:	d5c080e7          	jalr	-676(ra) # 8000019e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000544a:	100017b7          	lui	a5,0x10001
    8000544e:	4721                	li	a4,8
    80005450:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005452:	4098                	lw	a4,0(s1)
    80005454:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005458:	40d8                	lw	a4,4(s1)
    8000545a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000545e:	6498                	ld	a4,8(s1)
    80005460:	0007069b          	sext.w	a3,a4
    80005464:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005468:	9701                	srai	a4,a4,0x20
    8000546a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000546e:	6898                	ld	a4,16(s1)
    80005470:	0007069b          	sext.w	a3,a4
    80005474:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005478:	9701                	srai	a4,a4,0x20
    8000547a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000547e:	4685                	li	a3,1
    80005480:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005482:	4705                	li	a4,1
    80005484:	00d48c23          	sb	a3,24(s1)
    80005488:	00e48ca3          	sb	a4,25(s1)
    8000548c:	00e48d23          	sb	a4,26(s1)
    80005490:	00e48da3          	sb	a4,27(s1)
    80005494:	00e48e23          	sb	a4,28(s1)
    80005498:	00e48ea3          	sb	a4,29(s1)
    8000549c:	00e48f23          	sb	a4,30(s1)
    800054a0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800054a4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800054a8:	0727a823          	sw	s2,112(a5)
}
    800054ac:	60e2                	ld	ra,24(sp)
    800054ae:	6442                	ld	s0,16(sp)
    800054b0:	64a2                	ld	s1,8(sp)
    800054b2:	6902                	ld	s2,0(sp)
    800054b4:	6105                	addi	sp,sp,32
    800054b6:	8082                	ret
    panic("could not find virtio disk");
    800054b8:	00003517          	auipc	a0,0x3
    800054bc:	32850513          	addi	a0,a0,808 # 800087e0 <syscalls+0x330>
    800054c0:	00001097          	auipc	ra,0x1
    800054c4:	8c2080e7          	jalr	-1854(ra) # 80005d82 <panic>
    panic("virtio disk FEATURES_OK unset");
    800054c8:	00003517          	auipc	a0,0x3
    800054cc:	33850513          	addi	a0,a0,824 # 80008800 <syscalls+0x350>
    800054d0:	00001097          	auipc	ra,0x1
    800054d4:	8b2080e7          	jalr	-1870(ra) # 80005d82 <panic>
    panic("virtio disk should not be ready");
    800054d8:	00003517          	auipc	a0,0x3
    800054dc:	34850513          	addi	a0,a0,840 # 80008820 <syscalls+0x370>
    800054e0:	00001097          	auipc	ra,0x1
    800054e4:	8a2080e7          	jalr	-1886(ra) # 80005d82 <panic>
    panic("virtio disk has no queue 0");
    800054e8:	00003517          	auipc	a0,0x3
    800054ec:	35850513          	addi	a0,a0,856 # 80008840 <syscalls+0x390>
    800054f0:	00001097          	auipc	ra,0x1
    800054f4:	892080e7          	jalr	-1902(ra) # 80005d82 <panic>
    panic("virtio disk max queue too short");
    800054f8:	00003517          	auipc	a0,0x3
    800054fc:	36850513          	addi	a0,a0,872 # 80008860 <syscalls+0x3b0>
    80005500:	00001097          	auipc	ra,0x1
    80005504:	882080e7          	jalr	-1918(ra) # 80005d82 <panic>
    panic("virtio disk kalloc");
    80005508:	00003517          	auipc	a0,0x3
    8000550c:	37850513          	addi	a0,a0,888 # 80008880 <syscalls+0x3d0>
    80005510:	00001097          	auipc	ra,0x1
    80005514:	872080e7          	jalr	-1934(ra) # 80005d82 <panic>

0000000080005518 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005518:	7159                	addi	sp,sp,-112
    8000551a:	f486                	sd	ra,104(sp)
    8000551c:	f0a2                	sd	s0,96(sp)
    8000551e:	eca6                	sd	s1,88(sp)
    80005520:	e8ca                	sd	s2,80(sp)
    80005522:	e4ce                	sd	s3,72(sp)
    80005524:	e0d2                	sd	s4,64(sp)
    80005526:	fc56                	sd	s5,56(sp)
    80005528:	f85a                	sd	s6,48(sp)
    8000552a:	f45e                	sd	s7,40(sp)
    8000552c:	f062                	sd	s8,32(sp)
    8000552e:	ec66                	sd	s9,24(sp)
    80005530:	e86a                	sd	s10,16(sp)
    80005532:	1880                	addi	s0,sp,112
    80005534:	892a                	mv	s2,a0
    80005536:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005538:	00c52c83          	lw	s9,12(a0)
    8000553c:	001c9c9b          	slliw	s9,s9,0x1
    80005540:	1c82                	slli	s9,s9,0x20
    80005542:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005546:	00015517          	auipc	a0,0x15
    8000554a:	96250513          	addi	a0,a0,-1694 # 80019ea8 <disk+0x128>
    8000554e:	00001097          	auipc	ra,0x1
    80005552:	d7e080e7          	jalr	-642(ra) # 800062cc <acquire>
  for(int i = 0; i < 3; i++){
    80005556:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005558:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000555a:	00015b17          	auipc	s6,0x15
    8000555e:	826b0b13          	addi	s6,s6,-2010 # 80019d80 <disk>
  for(int i = 0; i < 3; i++){
    80005562:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005564:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005566:	00015c17          	auipc	s8,0x15
    8000556a:	942c0c13          	addi	s8,s8,-1726 # 80019ea8 <disk+0x128>
    8000556e:	a8b5                	j	800055ea <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005570:	00fb06b3          	add	a3,s6,a5
    80005574:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005578:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000557a:	0207c563          	bltz	a5,800055a4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000557e:	2485                	addiw	s1,s1,1
    80005580:	0711                	addi	a4,a4,4
    80005582:	1f548a63          	beq	s1,s5,80005776 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005586:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005588:	00014697          	auipc	a3,0x14
    8000558c:	7f868693          	addi	a3,a3,2040 # 80019d80 <disk>
    80005590:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005592:	0186c583          	lbu	a1,24(a3)
    80005596:	fde9                	bnez	a1,80005570 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005598:	2785                	addiw	a5,a5,1
    8000559a:	0685                	addi	a3,a3,1
    8000559c:	ff779be3          	bne	a5,s7,80005592 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800055a0:	57fd                	li	a5,-1
    800055a2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800055a4:	02905a63          	blez	s1,800055d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800055a8:	f9042503          	lw	a0,-112(s0)
    800055ac:	00000097          	auipc	ra,0x0
    800055b0:	cfa080e7          	jalr	-774(ra) # 800052a6 <free_desc>
      for(int j = 0; j < i; j++)
    800055b4:	4785                	li	a5,1
    800055b6:	0297d163          	bge	a5,s1,800055d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800055ba:	f9442503          	lw	a0,-108(s0)
    800055be:	00000097          	auipc	ra,0x0
    800055c2:	ce8080e7          	jalr	-792(ra) # 800052a6 <free_desc>
      for(int j = 0; j < i; j++)
    800055c6:	4789                	li	a5,2
    800055c8:	0097d863          	bge	a5,s1,800055d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800055cc:	f9842503          	lw	a0,-104(s0)
    800055d0:	00000097          	auipc	ra,0x0
    800055d4:	cd6080e7          	jalr	-810(ra) # 800052a6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800055d8:	85e2                	mv	a1,s8
    800055da:	00014517          	auipc	a0,0x14
    800055de:	7be50513          	addi	a0,a0,1982 # 80019d98 <disk+0x18>
    800055e2:	ffffc097          	auipc	ra,0xffffc
    800055e6:	f48080e7          	jalr	-184(ra) # 8000152a <sleep>
  for(int i = 0; i < 3; i++){
    800055ea:	f9040713          	addi	a4,s0,-112
    800055ee:	84ce                	mv	s1,s3
    800055f0:	bf59                	j	80005586 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800055f2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800055f6:	00479693          	slli	a3,a5,0x4
    800055fa:	00014797          	auipc	a5,0x14
    800055fe:	78678793          	addi	a5,a5,1926 # 80019d80 <disk>
    80005602:	97b6                	add	a5,a5,a3
    80005604:	4685                	li	a3,1
    80005606:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005608:	00014597          	auipc	a1,0x14
    8000560c:	77858593          	addi	a1,a1,1912 # 80019d80 <disk>
    80005610:	00a60793          	addi	a5,a2,10
    80005614:	0792                	slli	a5,a5,0x4
    80005616:	97ae                	add	a5,a5,a1
    80005618:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000561c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005620:	f6070693          	addi	a3,a4,-160
    80005624:	619c                	ld	a5,0(a1)
    80005626:	97b6                	add	a5,a5,a3
    80005628:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000562a:	6188                	ld	a0,0(a1)
    8000562c:	96aa                	add	a3,a3,a0
    8000562e:	47c1                	li	a5,16
    80005630:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005632:	4785                	li	a5,1
    80005634:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005638:	f9442783          	lw	a5,-108(s0)
    8000563c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005640:	0792                	slli	a5,a5,0x4
    80005642:	953e                	add	a0,a0,a5
    80005644:	05890693          	addi	a3,s2,88
    80005648:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000564a:	6188                	ld	a0,0(a1)
    8000564c:	97aa                	add	a5,a5,a0
    8000564e:	40000693          	li	a3,1024
    80005652:	c794                	sw	a3,8(a5)
  if(write)
    80005654:	100d0d63          	beqz	s10,8000576e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005658:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000565c:	00c7d683          	lhu	a3,12(a5)
    80005660:	0016e693          	ori	a3,a3,1
    80005664:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005668:	f9842583          	lw	a1,-104(s0)
    8000566c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005670:	00014697          	auipc	a3,0x14
    80005674:	71068693          	addi	a3,a3,1808 # 80019d80 <disk>
    80005678:	00260793          	addi	a5,a2,2
    8000567c:	0792                	slli	a5,a5,0x4
    8000567e:	97b6                	add	a5,a5,a3
    80005680:	587d                	li	a6,-1
    80005682:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005686:	0592                	slli	a1,a1,0x4
    80005688:	952e                	add	a0,a0,a1
    8000568a:	f9070713          	addi	a4,a4,-112
    8000568e:	9736                	add	a4,a4,a3
    80005690:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005692:	6298                	ld	a4,0(a3)
    80005694:	972e                	add	a4,a4,a1
    80005696:	4585                	li	a1,1
    80005698:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000569a:	4509                	li	a0,2
    8000569c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800056a0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800056a4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800056a8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800056ac:	6698                	ld	a4,8(a3)
    800056ae:	00275783          	lhu	a5,2(a4)
    800056b2:	8b9d                	andi	a5,a5,7
    800056b4:	0786                	slli	a5,a5,0x1
    800056b6:	97ba                	add	a5,a5,a4
    800056b8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800056bc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800056c0:	6698                	ld	a4,8(a3)
    800056c2:	00275783          	lhu	a5,2(a4)
    800056c6:	2785                	addiw	a5,a5,1
    800056c8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800056cc:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800056d0:	100017b7          	lui	a5,0x10001
    800056d4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800056d8:	00492703          	lw	a4,4(s2)
    800056dc:	4785                	li	a5,1
    800056de:	02f71163          	bne	a4,a5,80005700 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800056e2:	00014997          	auipc	s3,0x14
    800056e6:	7c698993          	addi	s3,s3,1990 # 80019ea8 <disk+0x128>
  while(b->disk == 1) {
    800056ea:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800056ec:	85ce                	mv	a1,s3
    800056ee:	854a                	mv	a0,s2
    800056f0:	ffffc097          	auipc	ra,0xffffc
    800056f4:	e3a080e7          	jalr	-454(ra) # 8000152a <sleep>
  while(b->disk == 1) {
    800056f8:	00492783          	lw	a5,4(s2)
    800056fc:	fe9788e3          	beq	a5,s1,800056ec <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005700:	f9042903          	lw	s2,-112(s0)
    80005704:	00290793          	addi	a5,s2,2
    80005708:	00479713          	slli	a4,a5,0x4
    8000570c:	00014797          	auipc	a5,0x14
    80005710:	67478793          	addi	a5,a5,1652 # 80019d80 <disk>
    80005714:	97ba                	add	a5,a5,a4
    80005716:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000571a:	00014997          	auipc	s3,0x14
    8000571e:	66698993          	addi	s3,s3,1638 # 80019d80 <disk>
    80005722:	00491713          	slli	a4,s2,0x4
    80005726:	0009b783          	ld	a5,0(s3)
    8000572a:	97ba                	add	a5,a5,a4
    8000572c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005730:	854a                	mv	a0,s2
    80005732:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005736:	00000097          	auipc	ra,0x0
    8000573a:	b70080e7          	jalr	-1168(ra) # 800052a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000573e:	8885                	andi	s1,s1,1
    80005740:	f0ed                	bnez	s1,80005722 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005742:	00014517          	auipc	a0,0x14
    80005746:	76650513          	addi	a0,a0,1894 # 80019ea8 <disk+0x128>
    8000574a:	00001097          	auipc	ra,0x1
    8000574e:	c36080e7          	jalr	-970(ra) # 80006380 <release>
}
    80005752:	70a6                	ld	ra,104(sp)
    80005754:	7406                	ld	s0,96(sp)
    80005756:	64e6                	ld	s1,88(sp)
    80005758:	6946                	ld	s2,80(sp)
    8000575a:	69a6                	ld	s3,72(sp)
    8000575c:	6a06                	ld	s4,64(sp)
    8000575e:	7ae2                	ld	s5,56(sp)
    80005760:	7b42                	ld	s6,48(sp)
    80005762:	7ba2                	ld	s7,40(sp)
    80005764:	7c02                	ld	s8,32(sp)
    80005766:	6ce2                	ld	s9,24(sp)
    80005768:	6d42                	ld	s10,16(sp)
    8000576a:	6165                	addi	sp,sp,112
    8000576c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000576e:	4689                	li	a3,2
    80005770:	00d79623          	sh	a3,12(a5)
    80005774:	b5e5                	j	8000565c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005776:	f9042603          	lw	a2,-112(s0)
    8000577a:	00a60713          	addi	a4,a2,10
    8000577e:	0712                	slli	a4,a4,0x4
    80005780:	00014517          	auipc	a0,0x14
    80005784:	60850513          	addi	a0,a0,1544 # 80019d88 <disk+0x8>
    80005788:	953a                	add	a0,a0,a4
  if(write)
    8000578a:	e60d14e3          	bnez	s10,800055f2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000578e:	00a60793          	addi	a5,a2,10
    80005792:	00479693          	slli	a3,a5,0x4
    80005796:	00014797          	auipc	a5,0x14
    8000579a:	5ea78793          	addi	a5,a5,1514 # 80019d80 <disk>
    8000579e:	97b6                	add	a5,a5,a3
    800057a0:	0007a423          	sw	zero,8(a5)
    800057a4:	b595                	j	80005608 <virtio_disk_rw+0xf0>

00000000800057a6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800057a6:	1101                	addi	sp,sp,-32
    800057a8:	ec06                	sd	ra,24(sp)
    800057aa:	e822                	sd	s0,16(sp)
    800057ac:	e426                	sd	s1,8(sp)
    800057ae:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800057b0:	00014497          	auipc	s1,0x14
    800057b4:	5d048493          	addi	s1,s1,1488 # 80019d80 <disk>
    800057b8:	00014517          	auipc	a0,0x14
    800057bc:	6f050513          	addi	a0,a0,1776 # 80019ea8 <disk+0x128>
    800057c0:	00001097          	auipc	ra,0x1
    800057c4:	b0c080e7          	jalr	-1268(ra) # 800062cc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800057c8:	10001737          	lui	a4,0x10001
    800057cc:	533c                	lw	a5,96(a4)
    800057ce:	8b8d                	andi	a5,a5,3
    800057d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800057d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800057d6:	689c                	ld	a5,16(s1)
    800057d8:	0204d703          	lhu	a4,32(s1)
    800057dc:	0027d783          	lhu	a5,2(a5)
    800057e0:	04f70863          	beq	a4,a5,80005830 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800057e4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800057e8:	6898                	ld	a4,16(s1)
    800057ea:	0204d783          	lhu	a5,32(s1)
    800057ee:	8b9d                	andi	a5,a5,7
    800057f0:	078e                	slli	a5,a5,0x3
    800057f2:	97ba                	add	a5,a5,a4
    800057f4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800057f6:	00278713          	addi	a4,a5,2
    800057fa:	0712                	slli	a4,a4,0x4
    800057fc:	9726                	add	a4,a4,s1
    800057fe:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005802:	e721                	bnez	a4,8000584a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005804:	0789                	addi	a5,a5,2
    80005806:	0792                	slli	a5,a5,0x4
    80005808:	97a6                	add	a5,a5,s1
    8000580a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000580c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005810:	ffffc097          	auipc	ra,0xffffc
    80005814:	d7e080e7          	jalr	-642(ra) # 8000158e <wakeup>

    disk.used_idx += 1;
    80005818:	0204d783          	lhu	a5,32(s1)
    8000581c:	2785                	addiw	a5,a5,1
    8000581e:	17c2                	slli	a5,a5,0x30
    80005820:	93c1                	srli	a5,a5,0x30
    80005822:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005826:	6898                	ld	a4,16(s1)
    80005828:	00275703          	lhu	a4,2(a4)
    8000582c:	faf71ce3          	bne	a4,a5,800057e4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005830:	00014517          	auipc	a0,0x14
    80005834:	67850513          	addi	a0,a0,1656 # 80019ea8 <disk+0x128>
    80005838:	00001097          	auipc	ra,0x1
    8000583c:	b48080e7          	jalr	-1208(ra) # 80006380 <release>
}
    80005840:	60e2                	ld	ra,24(sp)
    80005842:	6442                	ld	s0,16(sp)
    80005844:	64a2                	ld	s1,8(sp)
    80005846:	6105                	addi	sp,sp,32
    80005848:	8082                	ret
      panic("virtio_disk_intr status");
    8000584a:	00003517          	auipc	a0,0x3
    8000584e:	04e50513          	addi	a0,a0,78 # 80008898 <syscalls+0x3e8>
    80005852:	00000097          	auipc	ra,0x0
    80005856:	530080e7          	jalr	1328(ra) # 80005d82 <panic>

000000008000585a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000585a:	1141                	addi	sp,sp,-16
    8000585c:	e422                	sd	s0,8(sp)
    8000585e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005860:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005864:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005868:	0037979b          	slliw	a5,a5,0x3
    8000586c:	02004737          	lui	a4,0x2004
    80005870:	97ba                	add	a5,a5,a4
    80005872:	0200c737          	lui	a4,0x200c
    80005876:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000587a:	000f4637          	lui	a2,0xf4
    8000587e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005882:	95b2                	add	a1,a1,a2
    80005884:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005886:	00269713          	slli	a4,a3,0x2
    8000588a:	9736                	add	a4,a4,a3
    8000588c:	00371693          	slli	a3,a4,0x3
    80005890:	00014717          	auipc	a4,0x14
    80005894:	63070713          	addi	a4,a4,1584 # 80019ec0 <timer_scratch>
    80005898:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000589a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000589c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000589e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800058a2:	00000797          	auipc	a5,0x0
    800058a6:	93e78793          	addi	a5,a5,-1730 # 800051e0 <timervec>
    800058aa:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058ae:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800058b2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058b6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800058ba:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800058be:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800058c2:	30479073          	csrw	mie,a5
}
    800058c6:	6422                	ld	s0,8(sp)
    800058c8:	0141                	addi	sp,sp,16
    800058ca:	8082                	ret

00000000800058cc <start>:
{
    800058cc:	1141                	addi	sp,sp,-16
    800058ce:	e406                	sd	ra,8(sp)
    800058d0:	e022                	sd	s0,0(sp)
    800058d2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800058d4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800058d8:	7779                	lui	a4,0xffffe
    800058da:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc6ff>
    800058de:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800058e0:	6705                	lui	a4,0x1
    800058e2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800058e6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800058e8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800058ec:	ffffb797          	auipc	a5,0xffffb
    800058f0:	a6078793          	addi	a5,a5,-1440 # 8000034c <main>
    800058f4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800058f8:	4781                	li	a5,0
    800058fa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800058fe:	67c1                	lui	a5,0x10
    80005900:	17fd                	addi	a5,a5,-1
    80005902:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005906:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000590a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000590e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005912:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005916:	57fd                	li	a5,-1
    80005918:	83a9                	srli	a5,a5,0xa
    8000591a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000591e:	47bd                	li	a5,15
    80005920:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005924:	00000097          	auipc	ra,0x0
    80005928:	f36080e7          	jalr	-202(ra) # 8000585a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000592c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005930:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005932:	823e                	mv	tp,a5
  asm volatile("mret");
    80005934:	30200073          	mret
}
    80005938:	60a2                	ld	ra,8(sp)
    8000593a:	6402                	ld	s0,0(sp)
    8000593c:	0141                	addi	sp,sp,16
    8000593e:	8082                	ret

0000000080005940 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005940:	715d                	addi	sp,sp,-80
    80005942:	e486                	sd	ra,72(sp)
    80005944:	e0a2                	sd	s0,64(sp)
    80005946:	fc26                	sd	s1,56(sp)
    80005948:	f84a                	sd	s2,48(sp)
    8000594a:	f44e                	sd	s3,40(sp)
    8000594c:	f052                	sd	s4,32(sp)
    8000594e:	ec56                	sd	s5,24(sp)
    80005950:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005952:	04c05663          	blez	a2,8000599e <consolewrite+0x5e>
    80005956:	8a2a                	mv	s4,a0
    80005958:	84ae                	mv	s1,a1
    8000595a:	89b2                	mv	s3,a2
    8000595c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000595e:	5afd                	li	s5,-1
    80005960:	4685                	li	a3,1
    80005962:	8626                	mv	a2,s1
    80005964:	85d2                	mv	a1,s4
    80005966:	fbf40513          	addi	a0,s0,-65
    8000596a:	ffffc097          	auipc	ra,0xffffc
    8000596e:	01e080e7          	jalr	30(ra) # 80001988 <either_copyin>
    80005972:	01550c63          	beq	a0,s5,8000598a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005976:	fbf44503          	lbu	a0,-65(s0)
    8000597a:	00000097          	auipc	ra,0x0
    8000597e:	794080e7          	jalr	1940(ra) # 8000610e <uartputc>
  for(i = 0; i < n; i++){
    80005982:	2905                	addiw	s2,s2,1
    80005984:	0485                	addi	s1,s1,1
    80005986:	fd299de3          	bne	s3,s2,80005960 <consolewrite+0x20>
  }

  return i;
}
    8000598a:	854a                	mv	a0,s2
    8000598c:	60a6                	ld	ra,72(sp)
    8000598e:	6406                	ld	s0,64(sp)
    80005990:	74e2                	ld	s1,56(sp)
    80005992:	7942                	ld	s2,48(sp)
    80005994:	79a2                	ld	s3,40(sp)
    80005996:	7a02                	ld	s4,32(sp)
    80005998:	6ae2                	ld	s5,24(sp)
    8000599a:	6161                	addi	sp,sp,80
    8000599c:	8082                	ret
  for(i = 0; i < n; i++){
    8000599e:	4901                	li	s2,0
    800059a0:	b7ed                	j	8000598a <consolewrite+0x4a>

00000000800059a2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800059a2:	7119                	addi	sp,sp,-128
    800059a4:	fc86                	sd	ra,120(sp)
    800059a6:	f8a2                	sd	s0,112(sp)
    800059a8:	f4a6                	sd	s1,104(sp)
    800059aa:	f0ca                	sd	s2,96(sp)
    800059ac:	ecce                	sd	s3,88(sp)
    800059ae:	e8d2                	sd	s4,80(sp)
    800059b0:	e4d6                	sd	s5,72(sp)
    800059b2:	e0da                	sd	s6,64(sp)
    800059b4:	fc5e                	sd	s7,56(sp)
    800059b6:	f862                	sd	s8,48(sp)
    800059b8:	f466                	sd	s9,40(sp)
    800059ba:	f06a                	sd	s10,32(sp)
    800059bc:	ec6e                	sd	s11,24(sp)
    800059be:	0100                	addi	s0,sp,128
    800059c0:	8b2a                	mv	s6,a0
    800059c2:	8aae                	mv	s5,a1
    800059c4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800059c6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    800059ca:	0001c517          	auipc	a0,0x1c
    800059ce:	63650513          	addi	a0,a0,1590 # 80022000 <cons>
    800059d2:	00001097          	auipc	ra,0x1
    800059d6:	8fa080e7          	jalr	-1798(ra) # 800062cc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800059da:	0001c497          	auipc	s1,0x1c
    800059de:	62648493          	addi	s1,s1,1574 # 80022000 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800059e2:	89a6                	mv	s3,s1
    800059e4:	0001c917          	auipc	s2,0x1c
    800059e8:	6b490913          	addi	s2,s2,1716 # 80022098 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    800059ec:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059ee:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800059f0:	4da9                	li	s11,10
  while(n > 0){
    800059f2:	07405b63          	blez	s4,80005a68 <consoleread+0xc6>
    while(cons.r == cons.w){
    800059f6:	0984a783          	lw	a5,152(s1)
    800059fa:	09c4a703          	lw	a4,156(s1)
    800059fe:	02f71763          	bne	a4,a5,80005a2c <consoleread+0x8a>
      if(killed(myproc())){
    80005a02:	ffffb097          	auipc	ra,0xffffb
    80005a06:	47c080e7          	jalr	1148(ra) # 80000e7e <myproc>
    80005a0a:	ffffc097          	auipc	ra,0xffffc
    80005a0e:	dc8080e7          	jalr	-568(ra) # 800017d2 <killed>
    80005a12:	e535                	bnez	a0,80005a7e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005a14:	85ce                	mv	a1,s3
    80005a16:	854a                	mv	a0,s2
    80005a18:	ffffc097          	auipc	ra,0xffffc
    80005a1c:	b12080e7          	jalr	-1262(ra) # 8000152a <sleep>
    while(cons.r == cons.w){
    80005a20:	0984a783          	lw	a5,152(s1)
    80005a24:	09c4a703          	lw	a4,156(s1)
    80005a28:	fcf70de3          	beq	a4,a5,80005a02 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005a2c:	0017871b          	addiw	a4,a5,1
    80005a30:	08e4ac23          	sw	a4,152(s1)
    80005a34:	07f7f713          	andi	a4,a5,127
    80005a38:	9726                	add	a4,a4,s1
    80005a3a:	01874703          	lbu	a4,24(a4)
    80005a3e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005a42:	079c0663          	beq	s8,s9,80005aae <consoleread+0x10c>
    cbuf = c;
    80005a46:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005a4a:	4685                	li	a3,1
    80005a4c:	f8f40613          	addi	a2,s0,-113
    80005a50:	85d6                	mv	a1,s5
    80005a52:	855a                	mv	a0,s6
    80005a54:	ffffc097          	auipc	ra,0xffffc
    80005a58:	ede080e7          	jalr	-290(ra) # 80001932 <either_copyout>
    80005a5c:	01a50663          	beq	a0,s10,80005a68 <consoleread+0xc6>
    dst++;
    80005a60:	0a85                	addi	s5,s5,1
    --n;
    80005a62:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005a64:	f9bc17e3          	bne	s8,s11,800059f2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005a68:	0001c517          	auipc	a0,0x1c
    80005a6c:	59850513          	addi	a0,a0,1432 # 80022000 <cons>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	910080e7          	jalr	-1776(ra) # 80006380 <release>

  return target - n;
    80005a78:	414b853b          	subw	a0,s7,s4
    80005a7c:	a811                	j	80005a90 <consoleread+0xee>
        release(&cons.lock);
    80005a7e:	0001c517          	auipc	a0,0x1c
    80005a82:	58250513          	addi	a0,a0,1410 # 80022000 <cons>
    80005a86:	00001097          	auipc	ra,0x1
    80005a8a:	8fa080e7          	jalr	-1798(ra) # 80006380 <release>
        return -1;
    80005a8e:	557d                	li	a0,-1
}
    80005a90:	70e6                	ld	ra,120(sp)
    80005a92:	7446                	ld	s0,112(sp)
    80005a94:	74a6                	ld	s1,104(sp)
    80005a96:	7906                	ld	s2,96(sp)
    80005a98:	69e6                	ld	s3,88(sp)
    80005a9a:	6a46                	ld	s4,80(sp)
    80005a9c:	6aa6                	ld	s5,72(sp)
    80005a9e:	6b06                	ld	s6,64(sp)
    80005aa0:	7be2                	ld	s7,56(sp)
    80005aa2:	7c42                	ld	s8,48(sp)
    80005aa4:	7ca2                	ld	s9,40(sp)
    80005aa6:	7d02                	ld	s10,32(sp)
    80005aa8:	6de2                	ld	s11,24(sp)
    80005aaa:	6109                	addi	sp,sp,128
    80005aac:	8082                	ret
      if(n < target){
    80005aae:	000a071b          	sext.w	a4,s4
    80005ab2:	fb777be3          	bgeu	a4,s7,80005a68 <consoleread+0xc6>
        cons.r--;
    80005ab6:	0001c717          	auipc	a4,0x1c
    80005aba:	5ef72123          	sw	a5,1506(a4) # 80022098 <cons+0x98>
    80005abe:	b76d                	j	80005a68 <consoleread+0xc6>

0000000080005ac0 <consputc>:
{
    80005ac0:	1141                	addi	sp,sp,-16
    80005ac2:	e406                	sd	ra,8(sp)
    80005ac4:	e022                	sd	s0,0(sp)
    80005ac6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005ac8:	10000793          	li	a5,256
    80005acc:	00f50a63          	beq	a0,a5,80005ae0 <consputc+0x20>
    uartputc_sync(c);
    80005ad0:	00000097          	auipc	ra,0x0
    80005ad4:	564080e7          	jalr	1380(ra) # 80006034 <uartputc_sync>
}
    80005ad8:	60a2                	ld	ra,8(sp)
    80005ada:	6402                	ld	s0,0(sp)
    80005adc:	0141                	addi	sp,sp,16
    80005ade:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ae0:	4521                	li	a0,8
    80005ae2:	00000097          	auipc	ra,0x0
    80005ae6:	552080e7          	jalr	1362(ra) # 80006034 <uartputc_sync>
    80005aea:	02000513          	li	a0,32
    80005aee:	00000097          	auipc	ra,0x0
    80005af2:	546080e7          	jalr	1350(ra) # 80006034 <uartputc_sync>
    80005af6:	4521                	li	a0,8
    80005af8:	00000097          	auipc	ra,0x0
    80005afc:	53c080e7          	jalr	1340(ra) # 80006034 <uartputc_sync>
    80005b00:	bfe1                	j	80005ad8 <consputc+0x18>

0000000080005b02 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005b02:	1101                	addi	sp,sp,-32
    80005b04:	ec06                	sd	ra,24(sp)
    80005b06:	e822                	sd	s0,16(sp)
    80005b08:	e426                	sd	s1,8(sp)
    80005b0a:	e04a                	sd	s2,0(sp)
    80005b0c:	1000                	addi	s0,sp,32
    80005b0e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005b10:	0001c517          	auipc	a0,0x1c
    80005b14:	4f050513          	addi	a0,a0,1264 # 80022000 <cons>
    80005b18:	00000097          	auipc	ra,0x0
    80005b1c:	7b4080e7          	jalr	1972(ra) # 800062cc <acquire>

  switch(c){
    80005b20:	47d5                	li	a5,21
    80005b22:	0af48663          	beq	s1,a5,80005bce <consoleintr+0xcc>
    80005b26:	0297ca63          	blt	a5,s1,80005b5a <consoleintr+0x58>
    80005b2a:	47a1                	li	a5,8
    80005b2c:	0ef48763          	beq	s1,a5,80005c1a <consoleintr+0x118>
    80005b30:	47c1                	li	a5,16
    80005b32:	10f49a63          	bne	s1,a5,80005c46 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005b36:	ffffc097          	auipc	ra,0xffffc
    80005b3a:	ea8080e7          	jalr	-344(ra) # 800019de <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005b3e:	0001c517          	auipc	a0,0x1c
    80005b42:	4c250513          	addi	a0,a0,1218 # 80022000 <cons>
    80005b46:	00001097          	auipc	ra,0x1
    80005b4a:	83a080e7          	jalr	-1990(ra) # 80006380 <release>
}
    80005b4e:	60e2                	ld	ra,24(sp)
    80005b50:	6442                	ld	s0,16(sp)
    80005b52:	64a2                	ld	s1,8(sp)
    80005b54:	6902                	ld	s2,0(sp)
    80005b56:	6105                	addi	sp,sp,32
    80005b58:	8082                	ret
  switch(c){
    80005b5a:	07f00793          	li	a5,127
    80005b5e:	0af48e63          	beq	s1,a5,80005c1a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b62:	0001c717          	auipc	a4,0x1c
    80005b66:	49e70713          	addi	a4,a4,1182 # 80022000 <cons>
    80005b6a:	0a072783          	lw	a5,160(a4)
    80005b6e:	09872703          	lw	a4,152(a4)
    80005b72:	9f99                	subw	a5,a5,a4
    80005b74:	07f00713          	li	a4,127
    80005b78:	fcf763e3          	bltu	a4,a5,80005b3e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005b7c:	47b5                	li	a5,13
    80005b7e:	0cf48763          	beq	s1,a5,80005c4c <consoleintr+0x14a>
      consputc(c);
    80005b82:	8526                	mv	a0,s1
    80005b84:	00000097          	auipc	ra,0x0
    80005b88:	f3c080e7          	jalr	-196(ra) # 80005ac0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b8c:	0001c797          	auipc	a5,0x1c
    80005b90:	47478793          	addi	a5,a5,1140 # 80022000 <cons>
    80005b94:	0a07a683          	lw	a3,160(a5)
    80005b98:	0016871b          	addiw	a4,a3,1
    80005b9c:	0007061b          	sext.w	a2,a4
    80005ba0:	0ae7a023          	sw	a4,160(a5)
    80005ba4:	07f6f693          	andi	a3,a3,127
    80005ba8:	97b6                	add	a5,a5,a3
    80005baa:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005bae:	47a9                	li	a5,10
    80005bb0:	0cf48563          	beq	s1,a5,80005c7a <consoleintr+0x178>
    80005bb4:	4791                	li	a5,4
    80005bb6:	0cf48263          	beq	s1,a5,80005c7a <consoleintr+0x178>
    80005bba:	0001c797          	auipc	a5,0x1c
    80005bbe:	4de7a783          	lw	a5,1246(a5) # 80022098 <cons+0x98>
    80005bc2:	9f1d                	subw	a4,a4,a5
    80005bc4:	08000793          	li	a5,128
    80005bc8:	f6f71be3          	bne	a4,a5,80005b3e <consoleintr+0x3c>
    80005bcc:	a07d                	j	80005c7a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005bce:	0001c717          	auipc	a4,0x1c
    80005bd2:	43270713          	addi	a4,a4,1074 # 80022000 <cons>
    80005bd6:	0a072783          	lw	a5,160(a4)
    80005bda:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bde:	0001c497          	auipc	s1,0x1c
    80005be2:	42248493          	addi	s1,s1,1058 # 80022000 <cons>
    while(cons.e != cons.w &&
    80005be6:	4929                	li	s2,10
    80005be8:	f4f70be3          	beq	a4,a5,80005b3e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005bec:	37fd                	addiw	a5,a5,-1
    80005bee:	07f7f713          	andi	a4,a5,127
    80005bf2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005bf4:	01874703          	lbu	a4,24(a4)
    80005bf8:	f52703e3          	beq	a4,s2,80005b3e <consoleintr+0x3c>
      cons.e--;
    80005bfc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005c00:	10000513          	li	a0,256
    80005c04:	00000097          	auipc	ra,0x0
    80005c08:	ebc080e7          	jalr	-324(ra) # 80005ac0 <consputc>
    while(cons.e != cons.w &&
    80005c0c:	0a04a783          	lw	a5,160(s1)
    80005c10:	09c4a703          	lw	a4,156(s1)
    80005c14:	fcf71ce3          	bne	a4,a5,80005bec <consoleintr+0xea>
    80005c18:	b71d                	j	80005b3e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005c1a:	0001c717          	auipc	a4,0x1c
    80005c1e:	3e670713          	addi	a4,a4,998 # 80022000 <cons>
    80005c22:	0a072783          	lw	a5,160(a4)
    80005c26:	09c72703          	lw	a4,156(a4)
    80005c2a:	f0f70ae3          	beq	a4,a5,80005b3e <consoleintr+0x3c>
      cons.e--;
    80005c2e:	37fd                	addiw	a5,a5,-1
    80005c30:	0001c717          	auipc	a4,0x1c
    80005c34:	46f72823          	sw	a5,1136(a4) # 800220a0 <cons+0xa0>
      consputc(BACKSPACE);
    80005c38:	10000513          	li	a0,256
    80005c3c:	00000097          	auipc	ra,0x0
    80005c40:	e84080e7          	jalr	-380(ra) # 80005ac0 <consputc>
    80005c44:	bded                	j	80005b3e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c46:	ee048ce3          	beqz	s1,80005b3e <consoleintr+0x3c>
    80005c4a:	bf21                	j	80005b62 <consoleintr+0x60>
      consputc(c);
    80005c4c:	4529                	li	a0,10
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	e72080e7          	jalr	-398(ra) # 80005ac0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c56:	0001c797          	auipc	a5,0x1c
    80005c5a:	3aa78793          	addi	a5,a5,938 # 80022000 <cons>
    80005c5e:	0a07a703          	lw	a4,160(a5)
    80005c62:	0017069b          	addiw	a3,a4,1
    80005c66:	0006861b          	sext.w	a2,a3
    80005c6a:	0ad7a023          	sw	a3,160(a5)
    80005c6e:	07f77713          	andi	a4,a4,127
    80005c72:	97ba                	add	a5,a5,a4
    80005c74:	4729                	li	a4,10
    80005c76:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005c7a:	0001c797          	auipc	a5,0x1c
    80005c7e:	42c7a123          	sw	a2,1058(a5) # 8002209c <cons+0x9c>
        wakeup(&cons.r);
    80005c82:	0001c517          	auipc	a0,0x1c
    80005c86:	41650513          	addi	a0,a0,1046 # 80022098 <cons+0x98>
    80005c8a:	ffffc097          	auipc	ra,0xffffc
    80005c8e:	904080e7          	jalr	-1788(ra) # 8000158e <wakeup>
    80005c92:	b575                	j	80005b3e <consoleintr+0x3c>

0000000080005c94 <consoleinit>:

void
consoleinit(void)
{
    80005c94:	1141                	addi	sp,sp,-16
    80005c96:	e406                	sd	ra,8(sp)
    80005c98:	e022                	sd	s0,0(sp)
    80005c9a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c9c:	00003597          	auipc	a1,0x3
    80005ca0:	c1458593          	addi	a1,a1,-1004 # 800088b0 <syscalls+0x400>
    80005ca4:	0001c517          	auipc	a0,0x1c
    80005ca8:	35c50513          	addi	a0,a0,860 # 80022000 <cons>
    80005cac:	00000097          	auipc	ra,0x0
    80005cb0:	590080e7          	jalr	1424(ra) # 8000623c <initlock>

  uartinit();
    80005cb4:	00000097          	auipc	ra,0x0
    80005cb8:	330080e7          	jalr	816(ra) # 80005fe4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005cbc:	00013797          	auipc	a5,0x13
    80005cc0:	06c78793          	addi	a5,a5,108 # 80018d28 <devsw>
    80005cc4:	00000717          	auipc	a4,0x0
    80005cc8:	cde70713          	addi	a4,a4,-802 # 800059a2 <consoleread>
    80005ccc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005cce:	00000717          	auipc	a4,0x0
    80005cd2:	c7270713          	addi	a4,a4,-910 # 80005940 <consolewrite>
    80005cd6:	ef98                	sd	a4,24(a5)
}
    80005cd8:	60a2                	ld	ra,8(sp)
    80005cda:	6402                	ld	s0,0(sp)
    80005cdc:	0141                	addi	sp,sp,16
    80005cde:	8082                	ret

0000000080005ce0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ce0:	7179                	addi	sp,sp,-48
    80005ce2:	f406                	sd	ra,40(sp)
    80005ce4:	f022                	sd	s0,32(sp)
    80005ce6:	ec26                	sd	s1,24(sp)
    80005ce8:	e84a                	sd	s2,16(sp)
    80005cea:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005cec:	c219                	beqz	a2,80005cf2 <printint+0x12>
    80005cee:	08054663          	bltz	a0,80005d7a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005cf2:	2501                	sext.w	a0,a0
    80005cf4:	4881                	li	a7,0
    80005cf6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005cfa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005cfc:	2581                	sext.w	a1,a1
    80005cfe:	00003617          	auipc	a2,0x3
    80005d02:	be260613          	addi	a2,a2,-1054 # 800088e0 <digits>
    80005d06:	883a                	mv	a6,a4
    80005d08:	2705                	addiw	a4,a4,1
    80005d0a:	02b577bb          	remuw	a5,a0,a1
    80005d0e:	1782                	slli	a5,a5,0x20
    80005d10:	9381                	srli	a5,a5,0x20
    80005d12:	97b2                	add	a5,a5,a2
    80005d14:	0007c783          	lbu	a5,0(a5)
    80005d18:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005d1c:	0005079b          	sext.w	a5,a0
    80005d20:	02b5553b          	divuw	a0,a0,a1
    80005d24:	0685                	addi	a3,a3,1
    80005d26:	feb7f0e3          	bgeu	a5,a1,80005d06 <printint+0x26>

  if(sign)
    80005d2a:	00088b63          	beqz	a7,80005d40 <printint+0x60>
    buf[i++] = '-';
    80005d2e:	fe040793          	addi	a5,s0,-32
    80005d32:	973e                	add	a4,a4,a5
    80005d34:	02d00793          	li	a5,45
    80005d38:	fef70823          	sb	a5,-16(a4)
    80005d3c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005d40:	02e05763          	blez	a4,80005d6e <printint+0x8e>
    80005d44:	fd040793          	addi	a5,s0,-48
    80005d48:	00e784b3          	add	s1,a5,a4
    80005d4c:	fff78913          	addi	s2,a5,-1
    80005d50:	993a                	add	s2,s2,a4
    80005d52:	377d                	addiw	a4,a4,-1
    80005d54:	1702                	slli	a4,a4,0x20
    80005d56:	9301                	srli	a4,a4,0x20
    80005d58:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005d5c:	fff4c503          	lbu	a0,-1(s1)
    80005d60:	00000097          	auipc	ra,0x0
    80005d64:	d60080e7          	jalr	-672(ra) # 80005ac0 <consputc>
  while(--i >= 0)
    80005d68:	14fd                	addi	s1,s1,-1
    80005d6a:	ff2499e3          	bne	s1,s2,80005d5c <printint+0x7c>
}
    80005d6e:	70a2                	ld	ra,40(sp)
    80005d70:	7402                	ld	s0,32(sp)
    80005d72:	64e2                	ld	s1,24(sp)
    80005d74:	6942                	ld	s2,16(sp)
    80005d76:	6145                	addi	sp,sp,48
    80005d78:	8082                	ret
    x = -xx;
    80005d7a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005d7e:	4885                	li	a7,1
    x = -xx;
    80005d80:	bf9d                	j	80005cf6 <printint+0x16>

0000000080005d82 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005d82:	1101                	addi	sp,sp,-32
    80005d84:	ec06                	sd	ra,24(sp)
    80005d86:	e822                	sd	s0,16(sp)
    80005d88:	e426                	sd	s1,8(sp)
    80005d8a:	1000                	addi	s0,sp,32
    80005d8c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005d8e:	0001c797          	auipc	a5,0x1c
    80005d92:	3207a923          	sw	zero,818(a5) # 800220c0 <pr+0x18>
  printf("panic: ");
    80005d96:	00003517          	auipc	a0,0x3
    80005d9a:	b2250513          	addi	a0,a0,-1246 # 800088b8 <syscalls+0x408>
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	02e080e7          	jalr	46(ra) # 80005dcc <printf>
  printf(s);
    80005da6:	8526                	mv	a0,s1
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	024080e7          	jalr	36(ra) # 80005dcc <printf>
  printf("\n");
    80005db0:	00002517          	auipc	a0,0x2
    80005db4:	29850513          	addi	a0,a0,664 # 80008048 <etext+0x48>
    80005db8:	00000097          	auipc	ra,0x0
    80005dbc:	014080e7          	jalr	20(ra) # 80005dcc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005dc0:	4785                	li	a5,1
    80005dc2:	00003717          	auipc	a4,0x3
    80005dc6:	caf72d23          	sw	a5,-838(a4) # 80008a7c <panicked>
  for(;;)
    80005dca:	a001                	j	80005dca <panic+0x48>

0000000080005dcc <printf>:
{
    80005dcc:	7131                	addi	sp,sp,-192
    80005dce:	fc86                	sd	ra,120(sp)
    80005dd0:	f8a2                	sd	s0,112(sp)
    80005dd2:	f4a6                	sd	s1,104(sp)
    80005dd4:	f0ca                	sd	s2,96(sp)
    80005dd6:	ecce                	sd	s3,88(sp)
    80005dd8:	e8d2                	sd	s4,80(sp)
    80005dda:	e4d6                	sd	s5,72(sp)
    80005ddc:	e0da                	sd	s6,64(sp)
    80005dde:	fc5e                	sd	s7,56(sp)
    80005de0:	f862                	sd	s8,48(sp)
    80005de2:	f466                	sd	s9,40(sp)
    80005de4:	f06a                	sd	s10,32(sp)
    80005de6:	ec6e                	sd	s11,24(sp)
    80005de8:	0100                	addi	s0,sp,128
    80005dea:	8a2a                	mv	s4,a0
    80005dec:	e40c                	sd	a1,8(s0)
    80005dee:	e810                	sd	a2,16(s0)
    80005df0:	ec14                	sd	a3,24(s0)
    80005df2:	f018                	sd	a4,32(s0)
    80005df4:	f41c                	sd	a5,40(s0)
    80005df6:	03043823          	sd	a6,48(s0)
    80005dfa:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005dfe:	0001cd97          	auipc	s11,0x1c
    80005e02:	2c2dad83          	lw	s11,706(s11) # 800220c0 <pr+0x18>
  if(locking)
    80005e06:	020d9b63          	bnez	s11,80005e3c <printf+0x70>
  if (fmt == 0)
    80005e0a:	040a0263          	beqz	s4,80005e4e <printf+0x82>
  va_start(ap, fmt);
    80005e0e:	00840793          	addi	a5,s0,8
    80005e12:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e16:	000a4503          	lbu	a0,0(s4)
    80005e1a:	16050263          	beqz	a0,80005f7e <printf+0x1b2>
    80005e1e:	4481                	li	s1,0
    if(c != '%'){
    80005e20:	02500a93          	li	s5,37
    switch(c){
    80005e24:	07000b13          	li	s6,112
  consputc('x');
    80005e28:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e2a:	00003b97          	auipc	s7,0x3
    80005e2e:	ab6b8b93          	addi	s7,s7,-1354 # 800088e0 <digits>
    switch(c){
    80005e32:	07300c93          	li	s9,115
    80005e36:	06400c13          	li	s8,100
    80005e3a:	a82d                	j	80005e74 <printf+0xa8>
    acquire(&pr.lock);
    80005e3c:	0001c517          	auipc	a0,0x1c
    80005e40:	26c50513          	addi	a0,a0,620 # 800220a8 <pr>
    80005e44:	00000097          	auipc	ra,0x0
    80005e48:	488080e7          	jalr	1160(ra) # 800062cc <acquire>
    80005e4c:	bf7d                	j	80005e0a <printf+0x3e>
    panic("null fmt");
    80005e4e:	00003517          	auipc	a0,0x3
    80005e52:	a7a50513          	addi	a0,a0,-1414 # 800088c8 <syscalls+0x418>
    80005e56:	00000097          	auipc	ra,0x0
    80005e5a:	f2c080e7          	jalr	-212(ra) # 80005d82 <panic>
      consputc(c);
    80005e5e:	00000097          	auipc	ra,0x0
    80005e62:	c62080e7          	jalr	-926(ra) # 80005ac0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005e66:	2485                	addiw	s1,s1,1
    80005e68:	009a07b3          	add	a5,s4,s1
    80005e6c:	0007c503          	lbu	a0,0(a5)
    80005e70:	10050763          	beqz	a0,80005f7e <printf+0x1b2>
    if(c != '%'){
    80005e74:	ff5515e3          	bne	a0,s5,80005e5e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005e78:	2485                	addiw	s1,s1,1
    80005e7a:	009a07b3          	add	a5,s4,s1
    80005e7e:	0007c783          	lbu	a5,0(a5)
    80005e82:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005e86:	cfe5                	beqz	a5,80005f7e <printf+0x1b2>
    switch(c){
    80005e88:	05678a63          	beq	a5,s6,80005edc <printf+0x110>
    80005e8c:	02fb7663          	bgeu	s6,a5,80005eb8 <printf+0xec>
    80005e90:	09978963          	beq	a5,s9,80005f22 <printf+0x156>
    80005e94:	07800713          	li	a4,120
    80005e98:	0ce79863          	bne	a5,a4,80005f68 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e9c:	f8843783          	ld	a5,-120(s0)
    80005ea0:	00878713          	addi	a4,a5,8
    80005ea4:	f8e43423          	sd	a4,-120(s0)
    80005ea8:	4605                	li	a2,1
    80005eaa:	85ea                	mv	a1,s10
    80005eac:	4388                	lw	a0,0(a5)
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	e32080e7          	jalr	-462(ra) # 80005ce0 <printint>
      break;
    80005eb6:	bf45                	j	80005e66 <printf+0x9a>
    switch(c){
    80005eb8:	0b578263          	beq	a5,s5,80005f5c <printf+0x190>
    80005ebc:	0b879663          	bne	a5,s8,80005f68 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005ec0:	f8843783          	ld	a5,-120(s0)
    80005ec4:	00878713          	addi	a4,a5,8
    80005ec8:	f8e43423          	sd	a4,-120(s0)
    80005ecc:	4605                	li	a2,1
    80005ece:	45a9                	li	a1,10
    80005ed0:	4388                	lw	a0,0(a5)
    80005ed2:	00000097          	auipc	ra,0x0
    80005ed6:	e0e080e7          	jalr	-498(ra) # 80005ce0 <printint>
      break;
    80005eda:	b771                	j	80005e66 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005edc:	f8843783          	ld	a5,-120(s0)
    80005ee0:	00878713          	addi	a4,a5,8
    80005ee4:	f8e43423          	sd	a4,-120(s0)
    80005ee8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005eec:	03000513          	li	a0,48
    80005ef0:	00000097          	auipc	ra,0x0
    80005ef4:	bd0080e7          	jalr	-1072(ra) # 80005ac0 <consputc>
  consputc('x');
    80005ef8:	07800513          	li	a0,120
    80005efc:	00000097          	auipc	ra,0x0
    80005f00:	bc4080e7          	jalr	-1084(ra) # 80005ac0 <consputc>
    80005f04:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f06:	03c9d793          	srli	a5,s3,0x3c
    80005f0a:	97de                	add	a5,a5,s7
    80005f0c:	0007c503          	lbu	a0,0(a5)
    80005f10:	00000097          	auipc	ra,0x0
    80005f14:	bb0080e7          	jalr	-1104(ra) # 80005ac0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005f18:	0992                	slli	s3,s3,0x4
    80005f1a:	397d                	addiw	s2,s2,-1
    80005f1c:	fe0915e3          	bnez	s2,80005f06 <printf+0x13a>
    80005f20:	b799                	j	80005e66 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005f22:	f8843783          	ld	a5,-120(s0)
    80005f26:	00878713          	addi	a4,a5,8
    80005f2a:	f8e43423          	sd	a4,-120(s0)
    80005f2e:	0007b903          	ld	s2,0(a5)
    80005f32:	00090e63          	beqz	s2,80005f4e <printf+0x182>
      for(; *s; s++)
    80005f36:	00094503          	lbu	a0,0(s2)
    80005f3a:	d515                	beqz	a0,80005e66 <printf+0x9a>
        consputc(*s);
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	b84080e7          	jalr	-1148(ra) # 80005ac0 <consputc>
      for(; *s; s++)
    80005f44:	0905                	addi	s2,s2,1
    80005f46:	00094503          	lbu	a0,0(s2)
    80005f4a:	f96d                	bnez	a0,80005f3c <printf+0x170>
    80005f4c:	bf29                	j	80005e66 <printf+0x9a>
        s = "(null)";
    80005f4e:	00003917          	auipc	s2,0x3
    80005f52:	97290913          	addi	s2,s2,-1678 # 800088c0 <syscalls+0x410>
      for(; *s; s++)
    80005f56:	02800513          	li	a0,40
    80005f5a:	b7cd                	j	80005f3c <printf+0x170>
      consputc('%');
    80005f5c:	8556                	mv	a0,s5
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	b62080e7          	jalr	-1182(ra) # 80005ac0 <consputc>
      break;
    80005f66:	b701                	j	80005e66 <printf+0x9a>
      consputc('%');
    80005f68:	8556                	mv	a0,s5
    80005f6a:	00000097          	auipc	ra,0x0
    80005f6e:	b56080e7          	jalr	-1194(ra) # 80005ac0 <consputc>
      consputc(c);
    80005f72:	854a                	mv	a0,s2
    80005f74:	00000097          	auipc	ra,0x0
    80005f78:	b4c080e7          	jalr	-1204(ra) # 80005ac0 <consputc>
      break;
    80005f7c:	b5ed                	j	80005e66 <printf+0x9a>
  if(locking)
    80005f7e:	020d9163          	bnez	s11,80005fa0 <printf+0x1d4>
}
    80005f82:	70e6                	ld	ra,120(sp)
    80005f84:	7446                	ld	s0,112(sp)
    80005f86:	74a6                	ld	s1,104(sp)
    80005f88:	7906                	ld	s2,96(sp)
    80005f8a:	69e6                	ld	s3,88(sp)
    80005f8c:	6a46                	ld	s4,80(sp)
    80005f8e:	6aa6                	ld	s5,72(sp)
    80005f90:	6b06                	ld	s6,64(sp)
    80005f92:	7be2                	ld	s7,56(sp)
    80005f94:	7c42                	ld	s8,48(sp)
    80005f96:	7ca2                	ld	s9,40(sp)
    80005f98:	7d02                	ld	s10,32(sp)
    80005f9a:	6de2                	ld	s11,24(sp)
    80005f9c:	6129                	addi	sp,sp,192
    80005f9e:	8082                	ret
    release(&pr.lock);
    80005fa0:	0001c517          	auipc	a0,0x1c
    80005fa4:	10850513          	addi	a0,a0,264 # 800220a8 <pr>
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	3d8080e7          	jalr	984(ra) # 80006380 <release>
}
    80005fb0:	bfc9                	j	80005f82 <printf+0x1b6>

0000000080005fb2 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005fb2:	1101                	addi	sp,sp,-32
    80005fb4:	ec06                	sd	ra,24(sp)
    80005fb6:	e822                	sd	s0,16(sp)
    80005fb8:	e426                	sd	s1,8(sp)
    80005fba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005fbc:	0001c497          	auipc	s1,0x1c
    80005fc0:	0ec48493          	addi	s1,s1,236 # 800220a8 <pr>
    80005fc4:	00003597          	auipc	a1,0x3
    80005fc8:	91458593          	addi	a1,a1,-1772 # 800088d8 <syscalls+0x428>
    80005fcc:	8526                	mv	a0,s1
    80005fce:	00000097          	auipc	ra,0x0
    80005fd2:	26e080e7          	jalr	622(ra) # 8000623c <initlock>
  pr.locking = 1;
    80005fd6:	4785                	li	a5,1
    80005fd8:	cc9c                	sw	a5,24(s1)
}
    80005fda:	60e2                	ld	ra,24(sp)
    80005fdc:	6442                	ld	s0,16(sp)
    80005fde:	64a2                	ld	s1,8(sp)
    80005fe0:	6105                	addi	sp,sp,32
    80005fe2:	8082                	ret

0000000080005fe4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005fe4:	1141                	addi	sp,sp,-16
    80005fe6:	e406                	sd	ra,8(sp)
    80005fe8:	e022                	sd	s0,0(sp)
    80005fea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005fec:	100007b7          	lui	a5,0x10000
    80005ff0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ff4:	f8000713          	li	a4,-128
    80005ff8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ffc:	470d                	li	a4,3
    80005ffe:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006002:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006006:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000600a:	469d                	li	a3,7
    8000600c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006010:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006014:	00003597          	auipc	a1,0x3
    80006018:	8e458593          	addi	a1,a1,-1820 # 800088f8 <digits+0x18>
    8000601c:	0001c517          	auipc	a0,0x1c
    80006020:	0ac50513          	addi	a0,a0,172 # 800220c8 <uart_tx_lock>
    80006024:	00000097          	auipc	ra,0x0
    80006028:	218080e7          	jalr	536(ra) # 8000623c <initlock>
}
    8000602c:	60a2                	ld	ra,8(sp)
    8000602e:	6402                	ld	s0,0(sp)
    80006030:	0141                	addi	sp,sp,16
    80006032:	8082                	ret

0000000080006034 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006034:	1101                	addi	sp,sp,-32
    80006036:	ec06                	sd	ra,24(sp)
    80006038:	e822                	sd	s0,16(sp)
    8000603a:	e426                	sd	s1,8(sp)
    8000603c:	1000                	addi	s0,sp,32
    8000603e:	84aa                	mv	s1,a0
  push_off();
    80006040:	00000097          	auipc	ra,0x0
    80006044:	240080e7          	jalr	576(ra) # 80006280 <push_off>

  if(panicked){
    80006048:	00003797          	auipc	a5,0x3
    8000604c:	a347a783          	lw	a5,-1484(a5) # 80008a7c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006050:	10000737          	lui	a4,0x10000
  if(panicked){
    80006054:	c391                	beqz	a5,80006058 <uartputc_sync+0x24>
    for(;;)
    80006056:	a001                	j	80006056 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006058:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000605c:	0ff7f793          	andi	a5,a5,255
    80006060:	0207f793          	andi	a5,a5,32
    80006064:	dbf5                	beqz	a5,80006058 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006066:	0ff4f793          	andi	a5,s1,255
    8000606a:	10000737          	lui	a4,0x10000
    8000606e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006072:	00000097          	auipc	ra,0x0
    80006076:	2ae080e7          	jalr	686(ra) # 80006320 <pop_off>
}
    8000607a:	60e2                	ld	ra,24(sp)
    8000607c:	6442                	ld	s0,16(sp)
    8000607e:	64a2                	ld	s1,8(sp)
    80006080:	6105                	addi	sp,sp,32
    80006082:	8082                	ret

0000000080006084 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006084:	00003717          	auipc	a4,0x3
    80006088:	9fc73703          	ld	a4,-1540(a4) # 80008a80 <uart_tx_r>
    8000608c:	00003797          	auipc	a5,0x3
    80006090:	9fc7b783          	ld	a5,-1540(a5) # 80008a88 <uart_tx_w>
    80006094:	06e78c63          	beq	a5,a4,8000610c <uartstart+0x88>
{
    80006098:	7139                	addi	sp,sp,-64
    8000609a:	fc06                	sd	ra,56(sp)
    8000609c:	f822                	sd	s0,48(sp)
    8000609e:	f426                	sd	s1,40(sp)
    800060a0:	f04a                	sd	s2,32(sp)
    800060a2:	ec4e                	sd	s3,24(sp)
    800060a4:	e852                	sd	s4,16(sp)
    800060a6:	e456                	sd	s5,8(sp)
    800060a8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060aa:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060ae:	0001ca17          	auipc	s4,0x1c
    800060b2:	01aa0a13          	addi	s4,s4,26 # 800220c8 <uart_tx_lock>
    uart_tx_r += 1;
    800060b6:	00003497          	auipc	s1,0x3
    800060ba:	9ca48493          	addi	s1,s1,-1590 # 80008a80 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800060be:	00003997          	auipc	s3,0x3
    800060c2:	9ca98993          	addi	s3,s3,-1590 # 80008a88 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800060c6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800060ca:	0ff7f793          	andi	a5,a5,255
    800060ce:	0207f793          	andi	a5,a5,32
    800060d2:	c785                	beqz	a5,800060fa <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800060d4:	01f77793          	andi	a5,a4,31
    800060d8:	97d2                	add	a5,a5,s4
    800060da:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800060de:	0705                	addi	a4,a4,1
    800060e0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800060e2:	8526                	mv	a0,s1
    800060e4:	ffffb097          	auipc	ra,0xffffb
    800060e8:	4aa080e7          	jalr	1194(ra) # 8000158e <wakeup>
    
    WriteReg(THR, c);
    800060ec:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800060f0:	6098                	ld	a4,0(s1)
    800060f2:	0009b783          	ld	a5,0(s3)
    800060f6:	fce798e3          	bne	a5,a4,800060c6 <uartstart+0x42>
  }
}
    800060fa:	70e2                	ld	ra,56(sp)
    800060fc:	7442                	ld	s0,48(sp)
    800060fe:	74a2                	ld	s1,40(sp)
    80006100:	7902                	ld	s2,32(sp)
    80006102:	69e2                	ld	s3,24(sp)
    80006104:	6a42                	ld	s4,16(sp)
    80006106:	6aa2                	ld	s5,8(sp)
    80006108:	6121                	addi	sp,sp,64
    8000610a:	8082                	ret
    8000610c:	8082                	ret

000000008000610e <uartputc>:
{
    8000610e:	7179                	addi	sp,sp,-48
    80006110:	f406                	sd	ra,40(sp)
    80006112:	f022                	sd	s0,32(sp)
    80006114:	ec26                	sd	s1,24(sp)
    80006116:	e84a                	sd	s2,16(sp)
    80006118:	e44e                	sd	s3,8(sp)
    8000611a:	e052                	sd	s4,0(sp)
    8000611c:	1800                	addi	s0,sp,48
    8000611e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006120:	0001c517          	auipc	a0,0x1c
    80006124:	fa850513          	addi	a0,a0,-88 # 800220c8 <uart_tx_lock>
    80006128:	00000097          	auipc	ra,0x0
    8000612c:	1a4080e7          	jalr	420(ra) # 800062cc <acquire>
  if(panicked){
    80006130:	00003797          	auipc	a5,0x3
    80006134:	94c7a783          	lw	a5,-1716(a5) # 80008a7c <panicked>
    80006138:	e7c9                	bnez	a5,800061c2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000613a:	00003797          	auipc	a5,0x3
    8000613e:	94e7b783          	ld	a5,-1714(a5) # 80008a88 <uart_tx_w>
    80006142:	00003717          	auipc	a4,0x3
    80006146:	93e73703          	ld	a4,-1730(a4) # 80008a80 <uart_tx_r>
    8000614a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000614e:	0001ca17          	auipc	s4,0x1c
    80006152:	f7aa0a13          	addi	s4,s4,-134 # 800220c8 <uart_tx_lock>
    80006156:	00003497          	auipc	s1,0x3
    8000615a:	92a48493          	addi	s1,s1,-1750 # 80008a80 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000615e:	00003917          	auipc	s2,0x3
    80006162:	92a90913          	addi	s2,s2,-1750 # 80008a88 <uart_tx_w>
    80006166:	00f71f63          	bne	a4,a5,80006184 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000616a:	85d2                	mv	a1,s4
    8000616c:	8526                	mv	a0,s1
    8000616e:	ffffb097          	auipc	ra,0xffffb
    80006172:	3bc080e7          	jalr	956(ra) # 8000152a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006176:	00093783          	ld	a5,0(s2)
    8000617a:	6098                	ld	a4,0(s1)
    8000617c:	02070713          	addi	a4,a4,32
    80006180:	fef705e3          	beq	a4,a5,8000616a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006184:	0001c497          	auipc	s1,0x1c
    80006188:	f4448493          	addi	s1,s1,-188 # 800220c8 <uart_tx_lock>
    8000618c:	01f7f713          	andi	a4,a5,31
    80006190:	9726                	add	a4,a4,s1
    80006192:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006196:	0785                	addi	a5,a5,1
    80006198:	00003717          	auipc	a4,0x3
    8000619c:	8ef73823          	sd	a5,-1808(a4) # 80008a88 <uart_tx_w>
  uartstart();
    800061a0:	00000097          	auipc	ra,0x0
    800061a4:	ee4080e7          	jalr	-284(ra) # 80006084 <uartstart>
  release(&uart_tx_lock);
    800061a8:	8526                	mv	a0,s1
    800061aa:	00000097          	auipc	ra,0x0
    800061ae:	1d6080e7          	jalr	470(ra) # 80006380 <release>
}
    800061b2:	70a2                	ld	ra,40(sp)
    800061b4:	7402                	ld	s0,32(sp)
    800061b6:	64e2                	ld	s1,24(sp)
    800061b8:	6942                	ld	s2,16(sp)
    800061ba:	69a2                	ld	s3,8(sp)
    800061bc:	6a02                	ld	s4,0(sp)
    800061be:	6145                	addi	sp,sp,48
    800061c0:	8082                	ret
    for(;;)
    800061c2:	a001                	j	800061c2 <uartputc+0xb4>

00000000800061c4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800061c4:	1141                	addi	sp,sp,-16
    800061c6:	e422                	sd	s0,8(sp)
    800061c8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800061ca:	100007b7          	lui	a5,0x10000
    800061ce:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800061d2:	8b85                	andi	a5,a5,1
    800061d4:	cb91                	beqz	a5,800061e8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800061d6:	100007b7          	lui	a5,0x10000
    800061da:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800061de:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800061e2:	6422                	ld	s0,8(sp)
    800061e4:	0141                	addi	sp,sp,16
    800061e6:	8082                	ret
    return -1;
    800061e8:	557d                	li	a0,-1
    800061ea:	bfe5                	j	800061e2 <uartgetc+0x1e>

00000000800061ec <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800061ec:	1101                	addi	sp,sp,-32
    800061ee:	ec06                	sd	ra,24(sp)
    800061f0:	e822                	sd	s0,16(sp)
    800061f2:	e426                	sd	s1,8(sp)
    800061f4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061f6:	54fd                	li	s1,-1
    int c = uartgetc();
    800061f8:	00000097          	auipc	ra,0x0
    800061fc:	fcc080e7          	jalr	-52(ra) # 800061c4 <uartgetc>
    if(c == -1)
    80006200:	00950763          	beq	a0,s1,8000620e <uartintr+0x22>
      break;
    consoleintr(c);
    80006204:	00000097          	auipc	ra,0x0
    80006208:	8fe080e7          	jalr	-1794(ra) # 80005b02 <consoleintr>
  while(1){
    8000620c:	b7f5                	j	800061f8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000620e:	0001c497          	auipc	s1,0x1c
    80006212:	eba48493          	addi	s1,s1,-326 # 800220c8 <uart_tx_lock>
    80006216:	8526                	mv	a0,s1
    80006218:	00000097          	auipc	ra,0x0
    8000621c:	0b4080e7          	jalr	180(ra) # 800062cc <acquire>
  uartstart();
    80006220:	00000097          	auipc	ra,0x0
    80006224:	e64080e7          	jalr	-412(ra) # 80006084 <uartstart>
  release(&uart_tx_lock);
    80006228:	8526                	mv	a0,s1
    8000622a:	00000097          	auipc	ra,0x0
    8000622e:	156080e7          	jalr	342(ra) # 80006380 <release>
}
    80006232:	60e2                	ld	ra,24(sp)
    80006234:	6442                	ld	s0,16(sp)
    80006236:	64a2                	ld	s1,8(sp)
    80006238:	6105                	addi	sp,sp,32
    8000623a:	8082                	ret

000000008000623c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000623c:	1141                	addi	sp,sp,-16
    8000623e:	e422                	sd	s0,8(sp)
    80006240:	0800                	addi	s0,sp,16
  lk->name = name;
    80006242:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006244:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006248:	00053823          	sd	zero,16(a0)
}
    8000624c:	6422                	ld	s0,8(sp)
    8000624e:	0141                	addi	sp,sp,16
    80006250:	8082                	ret

0000000080006252 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006252:	411c                	lw	a5,0(a0)
    80006254:	e399                	bnez	a5,8000625a <holding+0x8>
    80006256:	4501                	li	a0,0
  return r;
}
    80006258:	8082                	ret
{
    8000625a:	1101                	addi	sp,sp,-32
    8000625c:	ec06                	sd	ra,24(sp)
    8000625e:	e822                	sd	s0,16(sp)
    80006260:	e426                	sd	s1,8(sp)
    80006262:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006264:	6904                	ld	s1,16(a0)
    80006266:	ffffb097          	auipc	ra,0xffffb
    8000626a:	bfc080e7          	jalr	-1028(ra) # 80000e62 <mycpu>
    8000626e:	40a48533          	sub	a0,s1,a0
    80006272:	00153513          	seqz	a0,a0
}
    80006276:	60e2                	ld	ra,24(sp)
    80006278:	6442                	ld	s0,16(sp)
    8000627a:	64a2                	ld	s1,8(sp)
    8000627c:	6105                	addi	sp,sp,32
    8000627e:	8082                	ret

0000000080006280 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006280:	1101                	addi	sp,sp,-32
    80006282:	ec06                	sd	ra,24(sp)
    80006284:	e822                	sd	s0,16(sp)
    80006286:	e426                	sd	s1,8(sp)
    80006288:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000628a:	100024f3          	csrr	s1,sstatus
    8000628e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006292:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006294:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006298:	ffffb097          	auipc	ra,0xffffb
    8000629c:	bca080e7          	jalr	-1078(ra) # 80000e62 <mycpu>
    800062a0:	5d3c                	lw	a5,120(a0)
    800062a2:	cf89                	beqz	a5,800062bc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800062a4:	ffffb097          	auipc	ra,0xffffb
    800062a8:	bbe080e7          	jalr	-1090(ra) # 80000e62 <mycpu>
    800062ac:	5d3c                	lw	a5,120(a0)
    800062ae:	2785                	addiw	a5,a5,1
    800062b0:	dd3c                	sw	a5,120(a0)
}
    800062b2:	60e2                	ld	ra,24(sp)
    800062b4:	6442                	ld	s0,16(sp)
    800062b6:	64a2                	ld	s1,8(sp)
    800062b8:	6105                	addi	sp,sp,32
    800062ba:	8082                	ret
    mycpu()->intena = old;
    800062bc:	ffffb097          	auipc	ra,0xffffb
    800062c0:	ba6080e7          	jalr	-1114(ra) # 80000e62 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800062c4:	8085                	srli	s1,s1,0x1
    800062c6:	8885                	andi	s1,s1,1
    800062c8:	dd64                	sw	s1,124(a0)
    800062ca:	bfe9                	j	800062a4 <push_off+0x24>

00000000800062cc <acquire>:
{
    800062cc:	1101                	addi	sp,sp,-32
    800062ce:	ec06                	sd	ra,24(sp)
    800062d0:	e822                	sd	s0,16(sp)
    800062d2:	e426                	sd	s1,8(sp)
    800062d4:	1000                	addi	s0,sp,32
    800062d6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	fa8080e7          	jalr	-88(ra) # 80006280 <push_off>
  if(holding(lk))
    800062e0:	8526                	mv	a0,s1
    800062e2:	00000097          	auipc	ra,0x0
    800062e6:	f70080e7          	jalr	-144(ra) # 80006252 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062ea:	4705                	li	a4,1
  if(holding(lk))
    800062ec:	e115                	bnez	a0,80006310 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800062ee:	87ba                	mv	a5,a4
    800062f0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062f4:	2781                	sext.w	a5,a5
    800062f6:	ffe5                	bnez	a5,800062ee <acquire+0x22>
  __sync_synchronize();
    800062f8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062fc:	ffffb097          	auipc	ra,0xffffb
    80006300:	b66080e7          	jalr	-1178(ra) # 80000e62 <mycpu>
    80006304:	e888                	sd	a0,16(s1)
}
    80006306:	60e2                	ld	ra,24(sp)
    80006308:	6442                	ld	s0,16(sp)
    8000630a:	64a2                	ld	s1,8(sp)
    8000630c:	6105                	addi	sp,sp,32
    8000630e:	8082                	ret
    panic("acquire");
    80006310:	00002517          	auipc	a0,0x2
    80006314:	5f050513          	addi	a0,a0,1520 # 80008900 <digits+0x20>
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	a6a080e7          	jalr	-1430(ra) # 80005d82 <panic>

0000000080006320 <pop_off>:

void
pop_off(void)
{
    80006320:	1141                	addi	sp,sp,-16
    80006322:	e406                	sd	ra,8(sp)
    80006324:	e022                	sd	s0,0(sp)
    80006326:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006328:	ffffb097          	auipc	ra,0xffffb
    8000632c:	b3a080e7          	jalr	-1222(ra) # 80000e62 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006330:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006334:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006336:	e78d                	bnez	a5,80006360 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006338:	5d3c                	lw	a5,120(a0)
    8000633a:	02f05b63          	blez	a5,80006370 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000633e:	37fd                	addiw	a5,a5,-1
    80006340:	0007871b          	sext.w	a4,a5
    80006344:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006346:	eb09                	bnez	a4,80006358 <pop_off+0x38>
    80006348:	5d7c                	lw	a5,124(a0)
    8000634a:	c799                	beqz	a5,80006358 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000634c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006350:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006354:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006358:	60a2                	ld	ra,8(sp)
    8000635a:	6402                	ld	s0,0(sp)
    8000635c:	0141                	addi	sp,sp,16
    8000635e:	8082                	ret
    panic("pop_off - interruptible");
    80006360:	00002517          	auipc	a0,0x2
    80006364:	5a850513          	addi	a0,a0,1448 # 80008908 <digits+0x28>
    80006368:	00000097          	auipc	ra,0x0
    8000636c:	a1a080e7          	jalr	-1510(ra) # 80005d82 <panic>
    panic("pop_off");
    80006370:	00002517          	auipc	a0,0x2
    80006374:	5b050513          	addi	a0,a0,1456 # 80008920 <digits+0x40>
    80006378:	00000097          	auipc	ra,0x0
    8000637c:	a0a080e7          	jalr	-1526(ra) # 80005d82 <panic>

0000000080006380 <release>:
{
    80006380:	1101                	addi	sp,sp,-32
    80006382:	ec06                	sd	ra,24(sp)
    80006384:	e822                	sd	s0,16(sp)
    80006386:	e426                	sd	s1,8(sp)
    80006388:	1000                	addi	s0,sp,32
    8000638a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000638c:	00000097          	auipc	ra,0x0
    80006390:	ec6080e7          	jalr	-314(ra) # 80006252 <holding>
    80006394:	c115                	beqz	a0,800063b8 <release+0x38>
  lk->cpu = 0;
    80006396:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000639a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000639e:	0f50000f          	fence	iorw,ow
    800063a2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800063a6:	00000097          	auipc	ra,0x0
    800063aa:	f7a080e7          	jalr	-134(ra) # 80006320 <pop_off>
}
    800063ae:	60e2                	ld	ra,24(sp)
    800063b0:	6442                	ld	s0,16(sp)
    800063b2:	64a2                	ld	s1,8(sp)
    800063b4:	6105                	addi	sp,sp,32
    800063b6:	8082                	ret
    panic("release");
    800063b8:	00002517          	auipc	a0,0x2
    800063bc:	57050513          	addi	a0,a0,1392 # 80008928 <digits+0x48>
    800063c0:	00000097          	auipc	ra,0x0
    800063c4:	9c2080e7          	jalr	-1598(ra) # 80005d82 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
