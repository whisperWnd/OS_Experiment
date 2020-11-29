#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_fifo.h>
#include <list.h>

/* [wikipedia]The simplest Page Replacement Algorithm(PRA) is a FIFO algorithm. The first-in, first-out
 * page replacement algorithm is a low-overhead algorithm that requires little book-keeping on
 * the part of the operating system. The idea is obvious from the name - the operating system
 * keeps track of all the pages in memory in a queue, with the most recent arrival at the back,
 * and the earliest arrival in front. When a page needs to be replaced, the page at the front
 * of the queue (the oldest page) is selected. While FIFO is cheap and intuitive, it performs
 * poorly in practical application. Thus, it is rarely used in its unmodified form. This
 * algorithm experiences Belady's anomaly.
 *
 * Details of FIFO PRA
 * (1) Prepare: In order to implement FIFO PRA, we should manage all swappable pages, so we can
 *              link these pages into pra_list_head according the time order. At first you should
 *              be familiar to the struct list in list.h. struct list is a simple doubly linked list
 *              implementation. You should know howto USE: list_init, list_add(list_add_after),
 *              list_add_before, list_del, list_next, list_prev. Another tricky method is to transform
 *              a general list struct to a special struct (such as struct page). You can find some MACRO:
 *              le2page (in memlayout.h), (in future labs: le2vma (in vmm.h), le2proc (in proc.h),etc.
 */

list_entry_t pra_list_head;
/*
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}

static int
_clock_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     //cprintf(" mm->sm_priv %x in clock_init_mm\n",mm->sm_priv);
     return 0;
}

static int
_lru_init_mm(struct mm_struct *mm)
{     
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     //cprintf(" mm->sm_priv %x in lru_init_mm\n",mm->sm_priv);
     return 0;
}

/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */

static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in, list_entry_t *curr)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_after(head, entry);
    return 0;
}

static int
_clock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in, list_entry_t *curr)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    if(curr == NULL)
    {
        list_add_after(head, entry);
    }
    else
    {
        list_add_after(curr, entry);
    }
    pte_t *ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);
    if(ptep != NULL)
    {
        //*ptep |= PTE_A;
    } 
    return 0;
}

static int
_lru_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in, list_entry_t *curr)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_after(head, entry);
    pte_t *ptep = get_pte(mm->pgdir, page->pra_vaddr, 0);
    if(ptep != NULL)
    {
        *ptep |= PTE_A;
    }
    
    return 0;
}

/*
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick, list_entry_t *curr)
{
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
         assert(head != NULL);
     assert(in_tick==0);
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  assign the value of *ptr_page to the addr of this page
     list_entry_t *tail = head->prev;//获取尾部的节点（最早被换入的页面）
     assert(head != tail);//检查头尾是否相连
     struct Page *p = le2page(tail, pra_page_link); 
     assert(p != NULL);
     list_del(tail);
     *ptr_page = p;//还原该页的虚拟地址
     return 0;
}

static int 
_clock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick, list_entry_t *curr)
{
    list_entry_t *head = (list_entry_t*) mm->sm_priv;
    assert(head != NULL);
    assert(in_tick==0);
    if(curr == NULL)
        curr = head->prev;
    //assert(curr != head);
    do{
        struct Page *p = le2page(curr, pra_page_link);
        assert(p != NULL);
        pte_t *ptep = get_pte(mm->pgdir, p->pra_vaddr, 0);
        if(curr == head)//skip the head node
        {
            curr = curr->prev;
            continue;
        }
        if(ptep < 0x1000)
        {
            cprintf("unvalid address!");
            break;
        }
        if(*ptep & PTE_A)
        {
            *ptep &= ~PTE_A;
            cprintf("PTE_A is set to 0\n");
        }
        else
        {
            if(*ptep & PTE_D)
            {
                *ptep &= ~PTE_D;
                cprintf("PTE_D is set to 0\n");
            }
            else
            {
                curr = curr->prev;
                list_del(curr->next);
                *ptr_page = p;
                return 0;  
            }   
        }
        curr = curr->prev; 
    }while(1);
    return -1;
}

static int
_lru_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick, list_entry_t *curr)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    assert(head != NULL);
    assert(in_tick==0);
    /* Select the victim */
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
    //(2)  assign the value of *ptr_page to the addr of this page
    curr = head->prev;
    while(curr != head){
        struct Page *p = le2page(curr, pra_page_link);
        assert(p != NULL);
        pte_t *ptep = get_pte(mm->pgdir, p->pra_vaddr, 0);
        if(ptep < 0x1000)
        {
            cprintf("unvalid address!");
            break;
        }
        else if(*ptep & PTE_A)
        {
	    assert(head != head->prev);
            *ptep &= ~PTE_A;
            list_entry_t *temp = curr;
            curr = curr->prev;
	    curr->next = temp->next;
            temp->next->prev = curr;
	    list_add_after(head, temp);
            cprintf("%d is moved to the top of the stack\n",temp);
        }
	   else
        {
	    //cprintf("If you saw this, it means the \"while\" do nothing\n");
	    curr = curr->prev;
    	   }
    }
    list_entry_t *tail = head->prev;//获取尾部的节点
    assert(head != tail);//检查头尾是否相连
    struct Page *pa = le2page(tail, pra_page_link); 
    assert(pa != NULL);
    list_del(tail);
    *ptr_page = pa;//还原该页的虚拟地址
    return 0;
}

static int
_fifo_check_swap(void) {
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==4);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==5);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==6);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==7);
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==8);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==9);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==10);
    cprintf("write Virt Page a in fifo_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==11);
    return 0;
}

static int
_clock_check_swap(void) {
    cprintf("write Virt Page c in clock_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in clock_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("write Virt Page d in clock_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==4);
    cprintf("write Virt Page b in clock_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);
    cprintf("write Virt Page e in clock_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
    cprintf("write Virt Page b in clock_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==5);
    cprintf("write Virt Page a in clock_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==6);
    cprintf("write Virt Page b in clock_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==7);
    cprintf("write Virt Page c in clock_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==8);
    cprintf("write Virt Page d in clock_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==9);
    cprintf("write Virt Page e in clock_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==10);
    cprintf("write Virt Page a in clock_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==11);
    return 0;
}

static int
_lru_check_swap(void) {
    cprintf("read Virt Page c in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x3000);
    assert(pgfault_num==4);
    cprintf("read Virt Page a in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x1000);
    assert(pgfault_num==4);
    cprintf("read Virt Page d in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x4000);
    assert(pgfault_num==4);
    cprintf("read Virt Page b in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x2000);
    assert(pgfault_num==4);
    cprintf("read Virt Page e in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x5000);
    assert(pgfault_num==5);
    cprintf("read Virt Page b in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x2000);
    assert(pgfault_num==5);
    cprintf("read Virt Page a in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x1000);
    assert(pgfault_num==6);
    cprintf("read Virt Page b in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x2000);
    assert(pgfault_num==6);
    cprintf("read Virt Page c in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x3000);
    assert(pgfault_num==7);
    cprintf("read Virt Page d in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x4000);
    assert(pgfault_num==8);
    cprintf("read Virt Page e in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x5000);
    assert(pgfault_num==8);
    cprintf("read Virt Page a in lru_check_swap\n");
    cprintf("%x\n",*(unsigned char *)0x1000);
    assert(pgfault_num==8);
    return 0;
}

static int
_fifo_init(void)
{
    return 0;
}

static int
_clock_init(void)
{
    return 0;
}

static int
_lru_init(void)
{
    return 0;
}

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_clock_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_lru_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }

static int
_clock_tick_event(struct mm_struct *mm)
{ return 0; }

static int
_lru_tick_event(struct mm_struct *mm)
{ return 0; }

struct swap_manager swap_manager_fifo =
{
     .name            = "fifo swap manager",
     .init            = &_fifo_init,
     .init_mm         = &_fifo_init_mm,
     .tick_event      = &_fifo_tick_event,
     .map_swappable   = &_fifo_map_swappable,
     .set_unswappable = &_fifo_set_unswappable,
     .swap_out_victim = &_fifo_swap_out_victim,
     .check_swap      = &_fifo_check_swap,
     .curr            = NULL,
};

struct swap_manager swap_manager_clock =
{
     .name            = "extended clock swap manager",
     .init            = &_clock_init,
     .init_mm         = &_clock_init_mm,
     .tick_event      = &_clock_tick_event,
     .map_swappable   = &_clock_map_swappable,
     .set_unswappable = &_clock_set_unswappable,
     .swap_out_victim = &_clock_swap_out_victim,
     .check_swap      = &_clock_check_swap,
     .curr            = NULL,
};

struct swap_manager swap_manager_lru =
{
     .name            = "extended lru swap manager",
     .init            = &_lru_init,
     .init_mm         = &_lru_init_mm,
     .tick_event      = &_lru_tick_event,
     .map_swappable   = &_lru_map_swappable,
     .set_unswappable = &_lru_set_unswappable,
     .swap_out_victim = &_lru_swap_out_victim,
     .check_swap      = &_lru_check_swap,
     .curr            = NULL,
};
