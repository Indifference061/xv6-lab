// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
}; //链表

struct kmem{
  struct spinlock lock;
  struct run *freelist;
} ;

//设置CPU个kmem
struct kmem kmems[NCPU];

void
kinit()
{
  push_off();
  int cpuID=cpuid();//获取cpuid进行对应初始化
  pop_off();

  printf("cpuID:%d \n",cpuID);
  for (int i = 0; i <NCPU; i++)//初始化NCPU个kmems
  {
    initlock(&kmems[i].lock, "kmem");

  }  
  freerange(end, (void*)PHYSTOP);
  printf("end cpuID:%d\n",cpuID);
}

void ListInsert(int cpuid, struct run* cur)//列表头插入
{
  if(cur)
  {
    cur->next=kmems[cpuid].freelist;
    kmems[cpuid].freelist=cur;
  }
  else{
    panic("Can't insert a NULL run");
  }
}

struct run* ListDelete(int cpuid)//列表头删除
{
  struct run* drun;
  drun=kmems[cpuid].freelist;
  if(drun)
  {
    kmems[cpuid].freelist=drun->next;
  }
  return drun;
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);//初始化freelist，为每个kmems的freelist增添一个头块
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)//调用cpuid()获得对应的cpuid，将被释放的块pa插入相应的freelist,以便后续使用
{
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;
  int cpuID;
  push_off();
  cpuID=cpuid();
  pop_off();

  acquire(&kmems[cpuID].lock); //请求获得进程锁，实现链表的插入
  r->next = kmems[cpuID].freelist;//在链表头插入内存块
  kmems[cpuID].freelist = r;
  release(&kmems[cpuID].lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)//使用空块用于存储，如果对应cpuid的链表有空块，则直接用，若没有，则偷其他链表的空快
{
  struct run *r;

  push_off();
  int cpuID=cpuid();
  pop_off();

  
  acquire(&kmems[cpuID].lock);
  r = kmems[cpuID].freelist;
  if(r)
    kmems[cpuID].freelist = r->next;
  else{
      for(int i=0;i<NCPU;i++)
      {
        if(i!=cpuID&&kmems[i].freelist)//若有空块，就偷一个并连接到cpuid的freelist
        {
          acquire(&kmems[i].lock);
          r=kmems[i].freelist;
          
          if(r)
          {
            kmems[i].freelist=r->next;
            release(&kmems[i].lock);
            break;
          }
          release(&kmems[i].lock);
          
        }
      }
      
  }
  
  release(&kmems[cpuID].lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}
