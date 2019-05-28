
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 2f 10 80       	mov    $0x80102f10,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 71 10 80       	push   $0x80107160
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 c5 43 00 00       	call   80104420 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 71 10 80       	push   $0x80107167
80100097:	50                   	push   %eax
80100098:	e8 73 42 00 00       	call   80104310 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 27 44 00 00       	call   80104510 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 c9 44 00 00       	call   80104630 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 41 00 00       	call   80104350 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 0d 20 00 00       	call   80102190 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 71 10 80       	push   $0x8010716e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 3d 42 00 00       	call   801043f0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 c7 1f 00 00       	jmp    80102190 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 71 10 80       	push   $0x8010717f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 fc 41 00 00       	call   801043f0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ac 41 00 00       	call   801043b0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 00 43 00 00       	call   80104510 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 cf 43 00 00       	jmp    80104630 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 71 10 80       	push   $0x80107186
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 7f 42 00 00       	call   80104510 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 b6 3b 00 00       	call   80103e80 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 b0 35 00 00       	call   80103890 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 3c 43 00 00       	call   80104630 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 de 42 00 00       	call   80104630 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 f2 23 00 00       	call   801027a0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 71 10 80       	push   $0x8010718d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 03 7c 10 80 	movl   $0x80107c03,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 40 00 00       	call   80104440 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 71 10 80       	push   $0x801071a1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 31 59 00 00       	call   80105d70 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 7f 58 00 00       	call   80105d70 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 73 58 00 00       	call   80105d70 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 67 58 00 00       	call   80105d70 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 17 42 00 00       	call   80104740 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 4a 41 00 00       	call   80104690 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 71 10 80       	push   $0x801071a5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 d0 71 10 80 	movzbl -0x7fef8e30(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 f0 3e 00 00       	call   80104510 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 e4 3f 00 00       	call   80104630 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 0c 3f 00 00       	call   80104630 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba b8 71 10 80       	mov    $0x801071b8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 1b 3d 00 00       	call   80104510 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 71 10 80       	push   $0x801071bf
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 e8 3c 00 00       	call   80104510 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 a3 3d 00 00       	call   80104630 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 25 37 00 00       	call   80104040 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 84 37 00 00       	jmp    80104120 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 c8 71 10 80       	push   $0x801071c8
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 4b 3a 00 00       	call   80104420 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 42 19 00 00       	call   80102340 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 6f 2e 00 00       	call   80103890 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 e4 21 00 00       	call   80102c10 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 0c 22 00 00       	call   80102c80 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 27 64 00 00       	call   80106ec0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 e5 61 00 00       	call   80106ce0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 f3 60 00 00       	call   80106c20 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 c9 62 00 00       	call   80106e40 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 e1 20 00 00       	call   80102c80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 31 61 00 00       	call   80106ce0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 7a 62 00 00       	call   80106e40 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 a8 20 00 00       	call   80102c80 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 71 10 80       	push   $0x801071e1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 55 63 00 00       	call   80106f60 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 72 3c 00 00       	call   801048b0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 5f 3c 00 00       	call   801048b0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 4e 64 00 00       	call   801070b0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 e4 63 00 00       	call   801070b0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 61 3b 00 00       	call   80104870 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 57 5d 00 00       	call   80106a90 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 ff 60 00 00       	call   80106e40 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 ed 71 10 80       	push   $0x801071ed
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 ab 36 00 00       	call   80104420 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 7a 37 00 00       	call   80104510 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 6a 38 00 00       	call   80104630 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 51 38 00 00       	call   80104630 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 0c 37 00 00       	call   80104510 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 0f 38 00 00       	call   80104630 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 f4 71 10 80       	push   $0x801071f4
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 ba 36 00 00       	call   80104510 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 af 37 00 00       	jmp    80104630 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 83 37 00 00       	call   80104630 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 ea 24 00 00       	call   801033c0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 2b 1d 00 00       	call   80102c10 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 81 1d 00 00       	jmp    80102c80 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 fc 71 10 80       	push   $0x801071fc
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 9e 25 00 00       	jmp    80103570 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 06 72 10 80       	push   $0x80107206
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 32 1c 00 00       	call   80102c80 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 95 1b 00 00       	call   80102c10 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 ce 1b 00 00       	call   80102c80 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 6e 23 00 00       	jmp    80103460 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 0f 72 10 80       	push   $0x8010720f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 15 72 10 80       	push   $0x80107215
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 1f 72 10 80       	push   $0x8010721f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 0e 1c 00 00       	call   80102de0 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 96 34 00 00       	call   80104690 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 de 1b 00 00       	call   80102de0 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 e0 09 11 80       	push   $0x801109e0
8010123a:	e8 d1 32 00 00       	call   80104510 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 e0 09 11 80       	push   $0x801109e0
8010129f:	e8 8c 33 00 00       	call   80104630 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 5e 33 00 00       	call   80104630 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 35 72 10 80       	push   $0x80107235
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 7d 1a 00 00       	call   80102de0 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 45 72 10 80       	push   $0x80107245
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 4a 33 00 00       	call   80104740 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 c0 09 11 80       	push   $0x801109c0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 71 19 00 00       	call   80102de0 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 58 72 10 80       	push   $0x80107258
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 6b 72 10 80       	push   $0x8010726b
801014a1:	68 e0 09 11 80       	push   $0x801109e0
801014a6:	e8 75 2f 00 00       	call   80104420 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 72 72 10 80       	push   $0x80107272
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 4c 2e 00 00       	call   80104310 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c0 09 11 80       	push   $0x801109c0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014e5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014eb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014f1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014f7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014fd:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101503:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101509:	68 d8 72 10 80       	push   $0x801072d8
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 ed 30 00 00       	call   80104690 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 2b 18 00 00       	call   80102de0 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 78 72 10 80       	push   $0x80107278
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 fa 30 00 00       	call   80104740 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 92 17 00 00       	call   80102de0 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 e0 09 11 80       	push   $0x801109e0
8010166f:	e8 9c 2e 00 00       	call   80104510 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010167f:	e8 ac 2f 00 00       	call   80104630 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 99 2c 00 00       	call   80104350 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 13 30 00 00       	call   80104740 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 90 72 10 80       	push   $0x80107290
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 8a 72 10 80       	push   $0x8010728a
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 68 2c 00 00       	call   801043f0 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 0c 2c 00 00       	jmp    801043b0 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 9f 72 10 80       	push   $0x8010729f
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 7b 2b 00 00       	call   80104350 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 c1 2b 00 00       	call   801043b0 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f6:	e8 15 2d 00 00       	call   80104510 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 1b 2e 00 00       	jmp    80104630 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 09 11 80       	push   $0x801109e0
80101820:	e8 eb 2c 00 00       	call   80104510 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010182f:	e8 fc 2d 00 00       	call   80104630 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 24 2d 00 00       	call   80104740 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 28 2c 00 00       	call   80104740 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 c0 12 00 00       	call   80102de0 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 fd 2b 00 00       	call   801047b0 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 9e 2b 00 00       	call   801047b0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 b9 72 10 80       	push   $0x801072b9
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 a7 72 10 80       	push   $0x801072a7
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 02 1c 00 00       	call   80103890 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 e0 09 11 80       	push   $0x801109e0
80101c99:	e8 72 28 00 00       	call   80104510 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca9:	e8 82 29 00 00       	call   80104630 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 36 2a 00 00       	call   80104740 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 a3 29 00 00       	call   80104740 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 7e 29 00 00       	call   80104810 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 c8 72 10 80       	push   $0x801072c8
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 ea 79 10 80       	push   $0x801079ea
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f30 <pfs>:

int
pfs()
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	83 ec 14             	sub    $0x14,%esp
	cprintf("sb: size  nblocks  ninodes nlog logstart inodestart bmap-start Inodes-per-block Bitmap-bits-per-block\n");
80101f36:	68 2c 73 10 80       	push   $0x8010732c
80101f3b:	e8 20 e7 ff ff       	call   80100660 <cprintf>
	cprintf("   %d\t    %d\t     %d     %d        %d \t %d \t  %d  \t %d  \t  %d\n", sb.size, sb.nblocks,
80101f40:	58                   	pop    %eax
80101f41:	5a                   	pop    %edx
80101f42:	68 00 10 00 00       	push   $0x1000
80101f47:	6a 08                	push   $0x8
80101f49:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101f4f:	ff 35 d4 09 11 80    	pushl  0x801109d4
80101f55:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101f5b:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101f61:	ff 35 c8 09 11 80    	pushl  0x801109c8
80101f67:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101f6d:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101f73:	68 94 73 10 80       	push   $0x80107394
80101f78:	e8 e3 e6 ff ff       	call   80100660 <cprintf>
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart, IPB,  BPB);

	return 0;
}
80101f7d:	31 c0                	xor    %eax,%eax
80101f7f:	c9                   	leave  
80101f80:	c3                   	ret    
80101f81:	66 90                	xchg   %ax,%ax
80101f83:	66 90                	xchg   %ax,%ax
80101f85:	66 90                	xchg   %ax,%ax
80101f87:	66 90                	xchg   %ax,%ax
80101f89:	66 90                	xchg   %ax,%ax
80101f8b:	66 90                	xchg   %ax,%ax
80101f8d:	66 90                	xchg   %ax,%ax
80101f8f:	90                   	nop

80101f90 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	57                   	push   %edi
80101f94:	56                   	push   %esi
80101f95:	53                   	push   %ebx
80101f96:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101f99:	85 c0                	test   %eax,%eax
80101f9b:	0f 84 b4 00 00 00    	je     80102055 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fa1:	8b 58 08             	mov    0x8(%eax),%ebx
80101fa4:	89 c6                	mov    %eax,%esi
80101fa6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101fac:	0f 87 96 00 00 00    	ja     80102048 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fb2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101fb7:	89 f6                	mov    %esi,%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101fc0:	89 ca                	mov    %ecx,%edx
80101fc2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fc3:	83 e0 c0             	and    $0xffffffc0,%eax
80101fc6:	3c 40                	cmp    $0x40,%al
80101fc8:	75 f6                	jne    80101fc0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fca:	31 ff                	xor    %edi,%edi
80101fcc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fd1:	89 f8                	mov    %edi,%eax
80101fd3:	ee                   	out    %al,(%dx)
80101fd4:	b8 01 00 00 00       	mov    $0x1,%eax
80101fd9:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101fde:	ee                   	out    %al,(%dx)
80101fdf:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101fe4:	89 d8                	mov    %ebx,%eax
80101fe6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fe7:	89 d8                	mov    %ebx,%eax
80101fe9:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101fee:	c1 f8 08             	sar    $0x8,%eax
80101ff1:	ee                   	out    %al,(%dx)
80101ff2:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101ff7:	89 f8                	mov    %edi,%eax
80101ff9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101ffa:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101ffe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102003:	c1 e0 04             	shl    $0x4,%eax
80102006:	83 e0 10             	and    $0x10,%eax
80102009:	83 c8 e0             	or     $0xffffffe0,%eax
8010200c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010200d:	f6 06 04             	testb  $0x4,(%esi)
80102010:	75 16                	jne    80102028 <idestart+0x98>
80102012:	b8 20 00 00 00       	mov    $0x20,%eax
80102017:	89 ca                	mov    %ecx,%edx
80102019:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010201a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010201d:	5b                   	pop    %ebx
8010201e:	5e                   	pop    %esi
8010201f:	5f                   	pop    %edi
80102020:	5d                   	pop    %ebp
80102021:	c3                   	ret    
80102022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102028:	b8 30 00 00 00       	mov    $0x30,%eax
8010202d:	89 ca                	mov    %ecx,%edx
8010202f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102030:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102035:	83 c6 5c             	add    $0x5c,%esi
80102038:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010203d:	fc                   	cld    
8010203e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102040:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102043:	5b                   	pop    %ebx
80102044:	5e                   	pop    %esi
80102045:	5f                   	pop    %edi
80102046:	5d                   	pop    %ebp
80102047:	c3                   	ret    
    panic("incorrect blockno");
80102048:	83 ec 0c             	sub    $0xc,%esp
8010204b:	68 dc 73 10 80       	push   $0x801073dc
80102050:	e8 3b e3 ff ff       	call   80100390 <panic>
    panic("idestart");
80102055:	83 ec 0c             	sub    $0xc,%esp
80102058:	68 d3 73 10 80       	push   $0x801073d3
8010205d:	e8 2e e3 ff ff       	call   80100390 <panic>
80102062:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102070 <ideinit>:
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102076:	68 ee 73 10 80       	push   $0x801073ee
8010207b:	68 80 a5 10 80       	push   $0x8010a580
80102080:	e8 9b 23 00 00       	call   80104420 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102085:	58                   	pop    %eax
80102086:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010208b:	5a                   	pop    %edx
8010208c:	83 e8 01             	sub    $0x1,%eax
8010208f:	50                   	push   %eax
80102090:	6a 0e                	push   $0xe
80102092:	e8 a9 02 00 00       	call   80102340 <ioapicenable>
80102097:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010209a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010209f:	90                   	nop
801020a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a1:	83 e0 c0             	and    $0xffffffc0,%eax
801020a4:	3c 40                	cmp    $0x40,%al
801020a6:	75 f8                	jne    801020a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020b2:	ee                   	out    %al,(%dx)
801020b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020bd:	eb 06                	jmp    801020c5 <ideinit+0x55>
801020bf:	90                   	nop
  for(i=0; i<1000; i++){
801020c0:	83 e9 01             	sub    $0x1,%ecx
801020c3:	74 0f                	je     801020d4 <ideinit+0x64>
801020c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020c6:	84 c0                	test   %al,%al
801020c8:	74 f6                	je     801020c0 <ideinit+0x50>
      havedisk1 = 1;
801020ca:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
801020d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020de:	ee                   	out    %al,(%dx)
}
801020df:	c9                   	leave  
801020e0:	c3                   	ret    
801020e1:	eb 0d                	jmp    801020f0 <ideintr>
801020e3:	90                   	nop
801020e4:	90                   	nop
801020e5:	90                   	nop
801020e6:	90                   	nop
801020e7:	90                   	nop
801020e8:	90                   	nop
801020e9:	90                   	nop
801020ea:	90                   	nop
801020eb:	90                   	nop
801020ec:	90                   	nop
801020ed:	90                   	nop
801020ee:	90                   	nop
801020ef:	90                   	nop

801020f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020f9:	68 80 a5 10 80       	push   $0x8010a580
801020fe:	e8 0d 24 00 00       	call   80104510 <acquire>

  if((b = idequeue) == 0){
80102103:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102109:	83 c4 10             	add    $0x10,%esp
8010210c:	85 db                	test   %ebx,%ebx
8010210e:	74 67                	je     80102177 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102110:	8b 43 58             	mov    0x58(%ebx),%eax
80102113:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102118:	8b 3b                	mov    (%ebx),%edi
8010211a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102120:	75 31                	jne    80102153 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102122:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102127:	89 f6                	mov    %esi,%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102130:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102131:	89 c6                	mov    %eax,%esi
80102133:	83 e6 c0             	and    $0xffffffc0,%esi
80102136:	89 f1                	mov    %esi,%ecx
80102138:	80 f9 40             	cmp    $0x40,%cl
8010213b:	75 f3                	jne    80102130 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010213d:	a8 21                	test   $0x21,%al
8010213f:	75 12                	jne    80102153 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102141:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102144:	b9 80 00 00 00       	mov    $0x80,%ecx
80102149:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010214e:	fc                   	cld    
8010214f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102151:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102153:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102156:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102159:	89 f9                	mov    %edi,%ecx
8010215b:	83 c9 02             	or     $0x2,%ecx
8010215e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102160:	53                   	push   %ebx
80102161:	e8 da 1e 00 00       	call   80104040 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102166:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010216b:	83 c4 10             	add    $0x10,%esp
8010216e:	85 c0                	test   %eax,%eax
80102170:	74 05                	je     80102177 <ideintr+0x87>
    idestart(idequeue);
80102172:	e8 19 fe ff ff       	call   80101f90 <idestart>
    release(&idelock);
80102177:	83 ec 0c             	sub    $0xc,%esp
8010217a:	68 80 a5 10 80       	push   $0x8010a580
8010217f:	e8 ac 24 00 00       	call   80104630 <release>

  release(&idelock);
}
80102184:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102187:	5b                   	pop    %ebx
80102188:	5e                   	pop    %esi
80102189:	5f                   	pop    %edi
8010218a:	5d                   	pop    %ebp
8010218b:	c3                   	ret    
8010218c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102190 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	53                   	push   %ebx
80102194:	83 ec 10             	sub    $0x10,%esp
80102197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010219a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010219d:	50                   	push   %eax
8010219e:	e8 4d 22 00 00       	call   801043f0 <holdingsleep>
801021a3:	83 c4 10             	add    $0x10,%esp
801021a6:	85 c0                	test   %eax,%eax
801021a8:	0f 84 c6 00 00 00    	je     80102274 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021ae:	8b 03                	mov    (%ebx),%eax
801021b0:	83 e0 06             	and    $0x6,%eax
801021b3:	83 f8 02             	cmp    $0x2,%eax
801021b6:	0f 84 ab 00 00 00    	je     80102267 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021bc:	8b 53 04             	mov    0x4(%ebx),%edx
801021bf:	85 d2                	test   %edx,%edx
801021c1:	74 0d                	je     801021d0 <iderw+0x40>
801021c3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801021c8:	85 c0                	test   %eax,%eax
801021ca:	0f 84 b1 00 00 00    	je     80102281 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801021d0:	83 ec 0c             	sub    $0xc,%esp
801021d3:	68 80 a5 10 80       	push   $0x8010a580
801021d8:	e8 33 23 00 00       	call   80104510 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021dd:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
801021e3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801021e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ed:	85 d2                	test   %edx,%edx
801021ef:	75 09                	jne    801021fa <iderw+0x6a>
801021f1:	eb 6d                	jmp    80102260 <iderw+0xd0>
801021f3:	90                   	nop
801021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021f8:	89 c2                	mov    %eax,%edx
801021fa:	8b 42 58             	mov    0x58(%edx),%eax
801021fd:	85 c0                	test   %eax,%eax
801021ff:	75 f7                	jne    801021f8 <iderw+0x68>
80102201:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102204:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102206:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010220c:	74 42                	je     80102250 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010220e:	8b 03                	mov    (%ebx),%eax
80102210:	83 e0 06             	and    $0x6,%eax
80102213:	83 f8 02             	cmp    $0x2,%eax
80102216:	74 23                	je     8010223b <iderw+0xab>
80102218:	90                   	nop
80102219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102220:	83 ec 08             	sub    $0x8,%esp
80102223:	68 80 a5 10 80       	push   $0x8010a580
80102228:	53                   	push   %ebx
80102229:	e8 52 1c 00 00       	call   80103e80 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010222e:	8b 03                	mov    (%ebx),%eax
80102230:	83 c4 10             	add    $0x10,%esp
80102233:	83 e0 06             	and    $0x6,%eax
80102236:	83 f8 02             	cmp    $0x2,%eax
80102239:	75 e5                	jne    80102220 <iderw+0x90>
  }


  release(&idelock);
8010223b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102242:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102245:	c9                   	leave  
  release(&idelock);
80102246:	e9 e5 23 00 00       	jmp    80104630 <release>
8010224b:	90                   	nop
8010224c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102250:	89 d8                	mov    %ebx,%eax
80102252:	e8 39 fd ff ff       	call   80101f90 <idestart>
80102257:	eb b5                	jmp    8010220e <iderw+0x7e>
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102260:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102265:	eb 9d                	jmp    80102204 <iderw+0x74>
    panic("iderw: nothing to do");
80102267:	83 ec 0c             	sub    $0xc,%esp
8010226a:	68 08 74 10 80       	push   $0x80107408
8010226f:	e8 1c e1 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102274:	83 ec 0c             	sub    $0xc,%esp
80102277:	68 f2 73 10 80       	push   $0x801073f2
8010227c:	e8 0f e1 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102281:	83 ec 0c             	sub    $0xc,%esp
80102284:	68 1d 74 10 80       	push   $0x8010741d
80102289:	e8 02 e1 ff ff       	call   80100390 <panic>
8010228e:	66 90                	xchg   %ax,%ax

80102290 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102290:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102291:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80102298:	00 c0 fe 
{
8010229b:	89 e5                	mov    %esp,%ebp
8010229d:	56                   	push   %esi
8010229e:	53                   	push   %ebx
  ioapic->reg = reg;
8010229f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022a6:	00 00 00 
  return ioapic->data;
801022a9:	a1 34 26 11 80       	mov    0x80112634,%eax
801022ae:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801022b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801022b7:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022bd:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022c4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801022c7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022ca:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801022cd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801022d0:	39 c2                	cmp    %eax,%edx
801022d2:	74 16                	je     801022ea <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 3c 74 10 80       	push   $0x8010743c
801022dc:	e8 7f e3 ff ff       	call   80100660 <cprintf>
801022e1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
801022e7:	83 c4 10             	add    $0x10,%esp
801022ea:	83 c3 21             	add    $0x21,%ebx
{
801022ed:	ba 10 00 00 00       	mov    $0x10,%edx
801022f2:	b8 20 00 00 00       	mov    $0x20,%eax
801022f7:	89 f6                	mov    %esi,%esi
801022f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102300:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102302:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102308:	89 c6                	mov    %eax,%esi
8010230a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102310:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102313:	89 71 10             	mov    %esi,0x10(%ecx)
80102316:	8d 72 01             	lea    0x1(%edx),%esi
80102319:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010231c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010231e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102320:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102326:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010232d:	75 d1                	jne    80102300 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010232f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102332:	5b                   	pop    %ebx
80102333:	5e                   	pop    %esi
80102334:	5d                   	pop    %ebp
80102335:	c3                   	ret    
80102336:	8d 76 00             	lea    0x0(%esi),%esi
80102339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102340 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102340:	55                   	push   %ebp
  ioapic->reg = reg;
80102341:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102347:	89 e5                	mov    %esp,%ebp
80102349:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010234c:	8d 50 20             	lea    0x20(%eax),%edx
8010234f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102353:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102355:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010235b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010235e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102361:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102364:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102366:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010236b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010236e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102371:	5d                   	pop    %ebp
80102372:	c3                   	ret    
80102373:	66 90                	xchg   %ax,%ax
80102375:	66 90                	xchg   %ax,%ax
80102377:	66 90                	xchg   %ax,%ax
80102379:	66 90                	xchg   %ax,%ax
8010237b:	66 90                	xchg   %ax,%ax
8010237d:	66 90                	xchg   %ax,%ax
8010237f:	90                   	nop

80102380 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	53                   	push   %ebx
80102384:	83 ec 04             	sub    $0x4,%esp
80102387:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010238a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102390:	75 70                	jne    80102402 <kfree+0x82>
80102392:	81 fb a8 5c 11 80    	cmp    $0x80115ca8,%ebx
80102398:	72 68                	jb     80102402 <kfree+0x82>
8010239a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023a0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023a5:	77 5b                	ja     80102402 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023a7:	83 ec 04             	sub    $0x4,%esp
801023aa:	68 00 10 00 00       	push   $0x1000
801023af:	6a 01                	push   $0x1
801023b1:	53                   	push   %ebx
801023b2:	e8 d9 22 00 00       	call   80104690 <memset>

  if(kmem.use_lock)
801023b7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801023bd:	83 c4 10             	add    $0x10,%esp
801023c0:	85 d2                	test   %edx,%edx
801023c2:	75 2c                	jne    801023f0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023c4:	a1 78 26 11 80       	mov    0x80112678,%eax
801023c9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023cb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
801023d0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801023d6:	85 c0                	test   %eax,%eax
801023d8:	75 06                	jne    801023e0 <kfree+0x60>
    release(&kmem.lock);
}
801023da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023dd:	c9                   	leave  
801023de:	c3                   	ret    
801023df:	90                   	nop
    release(&kmem.lock);
801023e0:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
801023e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023ea:	c9                   	leave  
    release(&kmem.lock);
801023eb:	e9 40 22 00 00       	jmp    80104630 <release>
    acquire(&kmem.lock);
801023f0:	83 ec 0c             	sub    $0xc,%esp
801023f3:	68 40 26 11 80       	push   $0x80112640
801023f8:	e8 13 21 00 00       	call   80104510 <acquire>
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	eb c2                	jmp    801023c4 <kfree+0x44>
    panic("kfree");
80102402:	83 ec 0c             	sub    $0xc,%esp
80102405:	68 6e 74 10 80       	push   $0x8010746e
8010240a:	e8 81 df ff ff       	call   80100390 <panic>
8010240f:	90                   	nop

80102410 <freerange>:
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102415:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102418:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010241b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102421:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102427:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242d:	39 de                	cmp    %ebx,%esi
8010242f:	72 23                	jb     80102454 <freerange+0x44>
80102431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102438:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010243e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102441:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102447:	50                   	push   %eax
80102448:	e8 33 ff ff ff       	call   80102380 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	39 f3                	cmp    %esi,%ebx
80102452:	76 e4                	jbe    80102438 <freerange+0x28>
}
80102454:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102457:	5b                   	pop    %ebx
80102458:	5e                   	pop    %esi
80102459:	5d                   	pop    %ebp
8010245a:	c3                   	ret    
8010245b:	90                   	nop
8010245c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102460 <kinit1>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102468:	83 ec 08             	sub    $0x8,%esp
8010246b:	68 74 74 10 80       	push   $0x80107474
80102470:	68 40 26 11 80       	push   $0x80112640
80102475:	e8 a6 1f 00 00       	call   80104420 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010247a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102480:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102487:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010248a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102490:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102496:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249c:	39 de                	cmp    %ebx,%esi
8010249e:	72 1c                	jb     801024bc <kinit1+0x5c>
    kfree(p);
801024a0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024a6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024af:	50                   	push   %eax
801024b0:	e8 cb fe ff ff       	call   80102380 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b5:	83 c4 10             	add    $0x10,%esp
801024b8:	39 de                	cmp    %ebx,%esi
801024ba:	73 e4                	jae    801024a0 <kinit1+0x40>
}
801024bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024bf:	5b                   	pop    %ebx
801024c0:	5e                   	pop    %esi
801024c1:	5d                   	pop    %ebp
801024c2:	c3                   	ret    
801024c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024d0 <kinit2>:
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	56                   	push   %esi
801024d4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801024d5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801024d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801024db:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024e1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ed:	39 de                	cmp    %ebx,%esi
801024ef:	72 23                	jb     80102514 <kinit2+0x44>
801024f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024f8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024fe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102501:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102507:	50                   	push   %eax
80102508:	e8 73 fe ff ff       	call   80102380 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010250d:	83 c4 10             	add    $0x10,%esp
80102510:	39 de                	cmp    %ebx,%esi
80102512:	73 e4                	jae    801024f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102514:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010251b:	00 00 00 
}
8010251e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102521:	5b                   	pop    %ebx
80102522:	5e                   	pop    %esi
80102523:	5d                   	pop    %ebp
80102524:	c3                   	ret    
80102525:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102530 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102530:	a1 74 26 11 80       	mov    0x80112674,%eax
80102535:	85 c0                	test   %eax,%eax
80102537:	75 1f                	jne    80102558 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102539:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010253e:	85 c0                	test   %eax,%eax
80102540:	74 0e                	je     80102550 <kalloc+0x20>
    kmem.freelist = r->next;
80102542:	8b 10                	mov    (%eax),%edx
80102544:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010254a:	c3                   	ret    
8010254b:	90                   	nop
8010254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102550:	f3 c3                	repz ret 
80102552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102558:	55                   	push   %ebp
80102559:	89 e5                	mov    %esp,%ebp
8010255b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010255e:	68 40 26 11 80       	push   $0x80112640
80102563:	e8 a8 1f 00 00       	call   80104510 <acquire>
  r = kmem.freelist;
80102568:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102576:	85 c0                	test   %eax,%eax
80102578:	74 08                	je     80102582 <kalloc+0x52>
    kmem.freelist = r->next;
8010257a:	8b 08                	mov    (%eax),%ecx
8010257c:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
80102582:	85 d2                	test   %edx,%edx
80102584:	74 16                	je     8010259c <kalloc+0x6c>
    release(&kmem.lock);
80102586:	83 ec 0c             	sub    $0xc,%esp
80102589:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010258c:	68 40 26 11 80       	push   $0x80112640
80102591:	e8 9a 20 00 00       	call   80104630 <release>
  return (char*)r;
80102596:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102599:	83 c4 10             	add    $0x10,%esp
}
8010259c:	c9                   	leave  
8010259d:	c3                   	ret    
8010259e:	66 90                	xchg   %ax,%ax

801025a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025a0:	ba 64 00 00 00       	mov    $0x64,%edx
801025a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801025a6:	a8 01                	test   $0x1,%al
801025a8:	0f 84 c2 00 00 00    	je     80102670 <kbdgetc+0xd0>
801025ae:	ba 60 00 00 00       	mov    $0x60,%edx
801025b3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025b4:	0f b6 d0             	movzbl %al,%edx
801025b7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801025bd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801025c3:	0f 84 7f 00 00 00    	je     80102648 <kbdgetc+0xa8>
{
801025c9:	55                   	push   %ebp
801025ca:	89 e5                	mov    %esp,%ebp
801025cc:	53                   	push   %ebx
801025cd:	89 cb                	mov    %ecx,%ebx
801025cf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025d2:	84 c0                	test   %al,%al
801025d4:	78 4a                	js     80102620 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801025d6:	85 db                	test   %ebx,%ebx
801025d8:	74 09                	je     801025e3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801025da:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801025dd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801025e0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801025e3:	0f b6 82 a0 75 10 80 	movzbl -0x7fef8a60(%edx),%eax
801025ea:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801025ec:	0f b6 82 a0 74 10 80 	movzbl -0x7fef8b60(%edx),%eax
801025f3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801025f5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801025f7:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801025fd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102600:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102603:	8b 04 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%eax
8010260a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010260e:	74 31                	je     80102641 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102610:	8d 50 9f             	lea    -0x61(%eax),%edx
80102613:	83 fa 19             	cmp    $0x19,%edx
80102616:	77 40                	ja     80102658 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102618:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010261b:	5b                   	pop    %ebx
8010261c:	5d                   	pop    %ebp
8010261d:	c3                   	ret    
8010261e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102620:	83 e0 7f             	and    $0x7f,%eax
80102623:	85 db                	test   %ebx,%ebx
80102625:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102628:	0f b6 82 a0 75 10 80 	movzbl -0x7fef8a60(%edx),%eax
8010262f:	83 c8 40             	or     $0x40,%eax
80102632:	0f b6 c0             	movzbl %al,%eax
80102635:	f7 d0                	not    %eax
80102637:	21 c1                	and    %eax,%ecx
    return 0;
80102639:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010263b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102641:	5b                   	pop    %ebx
80102642:	5d                   	pop    %ebp
80102643:	c3                   	ret    
80102644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102648:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010264b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010264d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102653:	c3                   	ret    
80102654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102658:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010265b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010265e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010265f:	83 f9 1a             	cmp    $0x1a,%ecx
80102662:	0f 42 c2             	cmovb  %edx,%eax
}
80102665:	5d                   	pop    %ebp
80102666:	c3                   	ret    
80102667:	89 f6                	mov    %esi,%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102675:	c3                   	ret    
80102676:	8d 76 00             	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <kbdintr>:

void
kbdintr(void)
{
80102680:	55                   	push   %ebp
80102681:	89 e5                	mov    %esp,%ebp
80102683:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102686:	68 a0 25 10 80       	push   $0x801025a0
8010268b:	e8 80 e1 ff ff       	call   80100810 <consoleintr>
}
80102690:	83 c4 10             	add    $0x10,%esp
80102693:	c9                   	leave  
80102694:	c3                   	ret    
80102695:	66 90                	xchg   %ax,%ax
80102697:	66 90                	xchg   %ax,%ax
80102699:	66 90                	xchg   %ax,%ax
8010269b:	66 90                	xchg   %ax,%ax
8010269d:	66 90                	xchg   %ax,%ax
8010269f:	90                   	nop

801026a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801026a5:	55                   	push   %ebp
801026a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026a8:	85 c0                	test   %eax,%eax
801026aa:	0f 84 c8 00 00 00    	je     80102778 <lapicinit+0xd8>
  lapic[index] = value;
801026b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026fe:	8b 50 30             	mov    0x30(%eax),%edx
80102701:	c1 ea 10             	shr    $0x10,%edx
80102704:	80 fa 03             	cmp    $0x3,%dl
80102707:	77 77                	ja     80102780 <lapicinit+0xe0>
  lapic[index] = value;
80102709:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102710:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102713:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102716:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102720:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102723:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102730:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102737:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102744:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102747:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102751:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102754:	8b 50 20             	mov    0x20(%eax),%edx
80102757:	89 f6                	mov    %esi,%esi
80102759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102760:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102766:	80 e6 10             	and    $0x10,%dh
80102769:	75 f5                	jne    80102760 <lapicinit+0xc0>
  lapic[index] = value;
8010276b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102772:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102775:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102778:	5d                   	pop    %ebp
80102779:	c3                   	ret    
8010277a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102780:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102787:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010278a:	8b 50 20             	mov    0x20(%eax),%edx
8010278d:	e9 77 ff ff ff       	jmp    80102709 <lapicinit+0x69>
80102792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801027a0:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
801027a6:	55                   	push   %ebp
801027a7:	31 c0                	xor    %eax,%eax
801027a9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027ab:	85 d2                	test   %edx,%edx
801027ad:	74 06                	je     801027b5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801027af:	8b 42 20             	mov    0x20(%edx),%eax
801027b2:	c1 e8 18             	shr    $0x18,%eax
}
801027b5:	5d                   	pop    %ebp
801027b6:	c3                   	ret    
801027b7:	89 f6                	mov    %esi,%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027c5:	55                   	push   %ebp
801027c6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027c8:	85 c0                	test   %eax,%eax
801027ca:	74 0d                	je     801027d9 <lapiceoi+0x19>
  lapic[index] = value;
801027cc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027d3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801027d9:	5d                   	pop    %ebp
801027da:	c3                   	ret    
801027db:	90                   	nop
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
}
801027e3:	5d                   	pop    %ebp
801027e4:	c3                   	ret    
801027e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f1:	b8 0f 00 00 00       	mov    $0xf,%eax
801027f6:	ba 70 00 00 00       	mov    $0x70,%edx
801027fb:	89 e5                	mov    %esp,%ebp
801027fd:	53                   	push   %ebx
801027fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102801:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102804:	ee                   	out    %al,(%dx)
80102805:	b8 0a 00 00 00       	mov    $0xa,%eax
8010280a:	ba 71 00 00 00       	mov    $0x71,%edx
8010280f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102810:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102812:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102815:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010281b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010281d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102820:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102823:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102825:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102828:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010282e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102833:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102839:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010283c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102843:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102846:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102849:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102850:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102853:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102856:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010285c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010285f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102865:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102868:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010286e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102871:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010287a:	5b                   	pop    %ebx
8010287b:	5d                   	pop    %ebp
8010287c:	c3                   	ret    
8010287d:	8d 76 00             	lea    0x0(%esi),%esi

80102880 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102880:	55                   	push   %ebp
80102881:	b8 0b 00 00 00       	mov    $0xb,%eax
80102886:	ba 70 00 00 00       	mov    $0x70,%edx
8010288b:	89 e5                	mov    %esp,%ebp
8010288d:	57                   	push   %edi
8010288e:	56                   	push   %esi
8010288f:	53                   	push   %ebx
80102890:	83 ec 4c             	sub    $0x4c,%esp
80102893:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102894:	ba 71 00 00 00       	mov    $0x71,%edx
80102899:	ec                   	in     (%dx),%al
8010289a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010289d:	bb 70 00 00 00       	mov    $0x70,%ebx
801028a2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801028a5:	8d 76 00             	lea    0x0(%esi),%esi
801028a8:	31 c0                	xor    %eax,%eax
801028aa:	89 da                	mov    %ebx,%edx
801028ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ad:	b9 71 00 00 00       	mov    $0x71,%ecx
801028b2:	89 ca                	mov    %ecx,%edx
801028b4:	ec                   	in     (%dx),%al
801028b5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b8:	89 da                	mov    %ebx,%edx
801028ba:	b8 02 00 00 00       	mov    $0x2,%eax
801028bf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c0:	89 ca                	mov    %ecx,%edx
801028c2:	ec                   	in     (%dx),%al
801028c3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c6:	89 da                	mov    %ebx,%edx
801028c8:	b8 04 00 00 00       	mov    $0x4,%eax
801028cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ce:	89 ca                	mov    %ecx,%edx
801028d0:	ec                   	in     (%dx),%al
801028d1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d4:	89 da                	mov    %ebx,%edx
801028d6:	b8 07 00 00 00       	mov    $0x7,%eax
801028db:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
801028df:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 da                	mov    %ebx,%edx
801028e4:	b8 08 00 00 00       	mov    $0x8,%eax
801028e9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ea:	89 ca                	mov    %ecx,%edx
801028ec:	ec                   	in     (%dx),%al
801028ed:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028ef:	89 da                	mov    %ebx,%edx
801028f1:	b8 09 00 00 00       	mov    $0x9,%eax
801028f6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028f7:	89 ca                	mov    %ecx,%edx
801028f9:	ec                   	in     (%dx),%al
801028fa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028fc:	89 da                	mov    %ebx,%edx
801028fe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102903:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102904:	89 ca                	mov    %ecx,%edx
80102906:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102907:	84 c0                	test   %al,%al
80102909:	78 9d                	js     801028a8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010290b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010290f:	89 fa                	mov    %edi,%edx
80102911:	0f b6 fa             	movzbl %dl,%edi
80102914:	89 f2                	mov    %esi,%edx
80102916:	0f b6 f2             	movzbl %dl,%esi
80102919:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010291c:	89 da                	mov    %ebx,%edx
8010291e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102921:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102924:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102928:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010292b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010292f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102932:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102936:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102939:	31 c0                	xor    %eax,%eax
8010293b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010293c:	89 ca                	mov    %ecx,%edx
8010293e:	ec                   	in     (%dx),%al
8010293f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102942:	89 da                	mov    %ebx,%edx
80102944:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102947:	b8 02 00 00 00       	mov    $0x2,%eax
8010294c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294d:	89 ca                	mov    %ecx,%edx
8010294f:	ec                   	in     (%dx),%al
80102950:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102953:	89 da                	mov    %ebx,%edx
80102955:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102958:	b8 04 00 00 00       	mov    $0x4,%eax
8010295d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295e:	89 ca                	mov    %ecx,%edx
80102960:	ec                   	in     (%dx),%al
80102961:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102964:	89 da                	mov    %ebx,%edx
80102966:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102969:	b8 07 00 00 00       	mov    $0x7,%eax
8010296e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296f:	89 ca                	mov    %ecx,%edx
80102971:	ec                   	in     (%dx),%al
80102972:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102975:	89 da                	mov    %ebx,%edx
80102977:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010297a:	b8 08 00 00 00       	mov    $0x8,%eax
8010297f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102980:	89 ca                	mov    %ecx,%edx
80102982:	ec                   	in     (%dx),%al
80102983:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102986:	89 da                	mov    %ebx,%edx
80102988:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010298b:	b8 09 00 00 00       	mov    $0x9,%eax
80102990:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102991:	89 ca                	mov    %ecx,%edx
80102993:	ec                   	in     (%dx),%al
80102994:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102997:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010299a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010299d:	8d 45 d0             	lea    -0x30(%ebp),%eax
801029a0:	6a 18                	push   $0x18
801029a2:	50                   	push   %eax
801029a3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029a6:	50                   	push   %eax
801029a7:	e8 34 1d 00 00       	call   801046e0 <memcmp>
801029ac:	83 c4 10             	add    $0x10,%esp
801029af:	85 c0                	test   %eax,%eax
801029b1:	0f 85 f1 fe ff ff    	jne    801028a8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801029b7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801029bb:	75 78                	jne    80102a35 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029bd:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029c0:	89 c2                	mov    %eax,%edx
801029c2:	83 e0 0f             	and    $0xf,%eax
801029c5:	c1 ea 04             	shr    $0x4,%edx
801029c8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029d1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029d4:	89 c2                	mov    %eax,%edx
801029d6:	83 e0 0f             	and    $0xf,%eax
801029d9:	c1 ea 04             	shr    $0x4,%edx
801029dc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029e2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029e5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e8:	89 c2                	mov    %eax,%edx
801029ea:	83 e0 0f             	and    $0xf,%eax
801029ed:	c1 ea 04             	shr    $0x4,%edx
801029f0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029f3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029f6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801029f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029fc:	89 c2                	mov    %eax,%edx
801029fe:	83 e0 0f             	and    $0xf,%eax
80102a01:	c1 ea 04             	shr    $0x4,%edx
80102a04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a10:	89 c2                	mov    %eax,%edx
80102a12:	83 e0 0f             	and    $0xf,%eax
80102a15:	c1 ea 04             	shr    $0x4,%edx
80102a18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a24:	89 c2                	mov    %eax,%edx
80102a26:	83 e0 0f             	and    $0xf,%eax
80102a29:	c1 ea 04             	shr    $0x4,%edx
80102a2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a32:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a35:	8b 75 08             	mov    0x8(%ebp),%esi
80102a38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a3b:	89 06                	mov    %eax,(%esi)
80102a3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a40:	89 46 04             	mov    %eax,0x4(%esi)
80102a43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a46:	89 46 08             	mov    %eax,0x8(%esi)
80102a49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a4c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a52:	89 46 10             	mov    %eax,0x10(%esi)
80102a55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a58:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a5b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a65:	5b                   	pop    %ebx
80102a66:	5e                   	pop    %esi
80102a67:	5f                   	pop    %edi
80102a68:	5d                   	pop    %ebp
80102a69:	c3                   	ret    
80102a6a:	66 90                	xchg   %ax,%ax
80102a6c:	66 90                	xchg   %ax,%ax
80102a6e:	66 90                	xchg   %ax,%ax

80102a70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a70:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a76:	85 c9                	test   %ecx,%ecx
80102a78:	0f 8e 8a 00 00 00    	jle    80102b08 <install_trans+0x98>
{
80102a7e:	55                   	push   %ebp
80102a7f:	89 e5                	mov    %esp,%ebp
80102a81:	57                   	push   %edi
80102a82:	56                   	push   %esi
80102a83:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102a84:	31 db                	xor    %ebx,%ebx
{
80102a86:	83 ec 0c             	sub    $0xc,%esp
80102a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a90:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a95:	83 ec 08             	sub    $0x8,%esp
80102a98:	01 d8                	add    %ebx,%eax
80102a9a:	83 c0 01             	add    $0x1,%eax
80102a9d:	50                   	push   %eax
80102a9e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102aa4:	e8 27 d6 ff ff       	call   801000d0 <bread>
80102aa9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102aab:	58                   	pop    %eax
80102aac:	5a                   	pop    %edx
80102aad:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ab4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102aba:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102abd:	e8 0e d6 ff ff       	call   801000d0 <bread>
80102ac2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ac4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ac7:	83 c4 0c             	add    $0xc,%esp
80102aca:	68 00 02 00 00       	push   $0x200
80102acf:	50                   	push   %eax
80102ad0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ad3:	50                   	push   %eax
80102ad4:	e8 67 1c 00 00       	call   80104740 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ad9:	89 34 24             	mov    %esi,(%esp)
80102adc:	e8 bf d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ae1:	89 3c 24             	mov    %edi,(%esp)
80102ae4:	e8 f7 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ae9:	89 34 24             	mov    %esi,(%esp)
80102aec:	e8 ef d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102af1:	83 c4 10             	add    $0x10,%esp
80102af4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102afa:	7f 94                	jg     80102a90 <install_trans+0x20>
  }
}
80102afc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aff:	5b                   	pop    %ebx
80102b00:	5e                   	pop    %esi
80102b01:	5f                   	pop    %edi
80102b02:	5d                   	pop    %ebp
80102b03:	c3                   	ret    
80102b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b08:	f3 c3                	repz ret 
80102b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	56                   	push   %esi
80102b14:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102b15:	83 ec 08             	sub    $0x8,%esp
80102b18:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102b1e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b24:	e8 a7 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b29:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b2f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b32:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b34:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b36:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b39:	7e 16                	jle    80102b51 <write_head+0x41>
80102b3b:	c1 e3 02             	shl    $0x2,%ebx
80102b3e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b40:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102b46:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b4a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b4d:	39 da                	cmp    %ebx,%edx
80102b4f:	75 ef                	jne    80102b40 <write_head+0x30>
  }
  bwrite(buf);
80102b51:	83 ec 0c             	sub    $0xc,%esp
80102b54:	56                   	push   %esi
80102b55:	e8 46 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b5a:	89 34 24             	mov    %esi,(%esp)
80102b5d:	e8 7e d6 ff ff       	call   801001e0 <brelse>
}
80102b62:	83 c4 10             	add    $0x10,%esp
80102b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b68:	5b                   	pop    %ebx
80102b69:	5e                   	pop    %esi
80102b6a:	5d                   	pop    %ebp
80102b6b:	c3                   	ret    
80102b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b70 <initlog>:
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
80102b73:	53                   	push   %ebx
80102b74:	83 ec 2c             	sub    $0x2c,%esp
80102b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102b7a:	68 a0 76 10 80       	push   $0x801076a0
80102b7f:	68 80 26 11 80       	push   $0x80112680
80102b84:	e8 97 18 00 00       	call   80104420 <initlock>
  readsb(dev, &sb);
80102b89:	58                   	pop    %eax
80102b8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b8d:	5a                   	pop    %edx
80102b8e:	50                   	push   %eax
80102b8f:	53                   	push   %ebx
80102b90:	e8 3b e8 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102b95:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102b98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102b9b:	59                   	pop    %ecx
  log.dev = dev;
80102b9c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102ba2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ba8:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102bad:	5a                   	pop    %edx
80102bae:	50                   	push   %eax
80102baf:	53                   	push   %ebx
80102bb0:	e8 1b d5 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102bb5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102bb8:	83 c4 10             	add    $0x10,%esp
80102bbb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102bbd:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102bc3:	7e 1c                	jle    80102be1 <initlog+0x71>
80102bc5:	c1 e3 02             	shl    $0x2,%ebx
80102bc8:	31 d2                	xor    %edx,%edx
80102bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102bd0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102bd4:	83 c2 04             	add    $0x4,%edx
80102bd7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102bdd:	39 d3                	cmp    %edx,%ebx
80102bdf:	75 ef                	jne    80102bd0 <initlog+0x60>
  brelse(buf);
80102be1:	83 ec 0c             	sub    $0xc,%esp
80102be4:	50                   	push   %eax
80102be5:	e8 f6 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bea:	e8 81 fe ff ff       	call   80102a70 <install_trans>
  log.lh.n = 0;
80102bef:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102bf6:	00 00 00 
  write_head(); // clear the log
80102bf9:	e8 12 ff ff ff       	call   80102b10 <write_head>
}
80102bfe:	83 c4 10             	add    $0x10,%esp
80102c01:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c04:	c9                   	leave  
80102c05:	c3                   	ret    
80102c06:	8d 76 00             	lea    0x0(%esi),%esi
80102c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c16:	68 80 26 11 80       	push   $0x80112680
80102c1b:	e8 f0 18 00 00       	call   80104510 <acquire>
80102c20:	83 c4 10             	add    $0x10,%esp
80102c23:	eb 18                	jmp    80102c3d <begin_op+0x2d>
80102c25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c28:	83 ec 08             	sub    $0x8,%esp
80102c2b:	68 80 26 11 80       	push   $0x80112680
80102c30:	68 80 26 11 80       	push   $0x80112680
80102c35:	e8 46 12 00 00       	call   80103e80 <sleep>
80102c3a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c3d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c42:	85 c0                	test   %eax,%eax
80102c44:	75 e2                	jne    80102c28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c46:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c4b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c51:	83 c0 01             	add    $0x1,%eax
80102c54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c5a:	83 fa 1e             	cmp    $0x1e,%edx
80102c5d:	7f c9                	jg     80102c28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c5f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102c62:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c67:	68 80 26 11 80       	push   $0x80112680
80102c6c:	e8 bf 19 00 00       	call   80104630 <release>
      break;
    }
  }
}
80102c71:	83 c4 10             	add    $0x10,%esp
80102c74:	c9                   	leave  
80102c75:	c3                   	ret    
80102c76:	8d 76 00             	lea    0x0(%esi),%esi
80102c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	57                   	push   %edi
80102c84:	56                   	push   %esi
80102c85:	53                   	push   %ebx
80102c86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c89:	68 80 26 11 80       	push   $0x80112680
80102c8e:	e8 7d 18 00 00       	call   80104510 <acquire>
  log.outstanding -= 1;
80102c93:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102c98:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102c9e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ca1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102ca4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102ca6:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102cac:	0f 85 1a 01 00 00    	jne    80102dcc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102cb2:	85 db                	test   %ebx,%ebx
80102cb4:	0f 85 ee 00 00 00    	jne    80102da8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cba:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102cbd:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102cc4:	00 00 00 
  release(&log.lock);
80102cc7:	68 80 26 11 80       	push   $0x80112680
80102ccc:	e8 5f 19 00 00       	call   80104630 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102cd1:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102cd7:	83 c4 10             	add    $0x10,%esp
80102cda:	85 c9                	test   %ecx,%ecx
80102cdc:	0f 8e 85 00 00 00    	jle    80102d67 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ce2:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ce7:	83 ec 08             	sub    $0x8,%esp
80102cea:	01 d8                	add    %ebx,%eax
80102cec:	83 c0 01             	add    $0x1,%eax
80102cef:	50                   	push   %eax
80102cf0:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102cf6:	e8 d5 d3 ff ff       	call   801000d0 <bread>
80102cfb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cfd:	58                   	pop    %eax
80102cfe:	5a                   	pop    %edx
80102cff:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102d06:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d0c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d0f:	e8 bc d3 ff ff       	call   801000d0 <bread>
80102d14:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d16:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d19:	83 c4 0c             	add    $0xc,%esp
80102d1c:	68 00 02 00 00       	push   $0x200
80102d21:	50                   	push   %eax
80102d22:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d25:	50                   	push   %eax
80102d26:	e8 15 1a 00 00       	call   80104740 <memmove>
    bwrite(to);  // write the log
80102d2b:	89 34 24             	mov    %esi,(%esp)
80102d2e:	e8 6d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d33:	89 3c 24             	mov    %edi,(%esp)
80102d36:	e8 a5 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d3b:	89 34 24             	mov    %esi,(%esp)
80102d3e:	e8 9d d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d43:	83 c4 10             	add    $0x10,%esp
80102d46:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d4c:	7c 94                	jl     80102ce2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d4e:	e8 bd fd ff ff       	call   80102b10 <write_head>
    install_trans(); // Now install writes to home locations
80102d53:	e8 18 fd ff ff       	call   80102a70 <install_trans>
    log.lh.n = 0;
80102d58:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d5f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d62:	e8 a9 fd ff ff       	call   80102b10 <write_head>
    acquire(&log.lock);
80102d67:	83 ec 0c             	sub    $0xc,%esp
80102d6a:	68 80 26 11 80       	push   $0x80112680
80102d6f:	e8 9c 17 00 00       	call   80104510 <acquire>
    wakeup(&log);
80102d74:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d7b:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d82:	00 00 00 
    wakeup(&log);
80102d85:	e8 b6 12 00 00       	call   80104040 <wakeup>
    release(&log.lock);
80102d8a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d91:	e8 9a 18 00 00       	call   80104630 <release>
80102d96:	83 c4 10             	add    $0x10,%esp
}
80102d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d9c:	5b                   	pop    %ebx
80102d9d:	5e                   	pop    %esi
80102d9e:	5f                   	pop    %edi
80102d9f:	5d                   	pop    %ebp
80102da0:	c3                   	ret    
80102da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102da8:	83 ec 0c             	sub    $0xc,%esp
80102dab:	68 80 26 11 80       	push   $0x80112680
80102db0:	e8 8b 12 00 00       	call   80104040 <wakeup>
  release(&log.lock);
80102db5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dbc:	e8 6f 18 00 00       	call   80104630 <release>
80102dc1:	83 c4 10             	add    $0x10,%esp
}
80102dc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dc7:	5b                   	pop    %ebx
80102dc8:	5e                   	pop    %esi
80102dc9:	5f                   	pop    %edi
80102dca:	5d                   	pop    %ebp
80102dcb:	c3                   	ret    
    panic("log.committing");
80102dcc:	83 ec 0c             	sub    $0xc,%esp
80102dcf:	68 a4 76 10 80       	push   $0x801076a4
80102dd4:	e8 b7 d5 ff ff       	call   80100390 <panic>
80102dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102de0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102de7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102ded:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102df0:	83 fa 1d             	cmp    $0x1d,%edx
80102df3:	0f 8f 9d 00 00 00    	jg     80102e96 <log_write+0xb6>
80102df9:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102dfe:	83 e8 01             	sub    $0x1,%eax
80102e01:	39 c2                	cmp    %eax,%edx
80102e03:	0f 8d 8d 00 00 00    	jge    80102e96 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e09:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e0e:	85 c0                	test   %eax,%eax
80102e10:	0f 8e 8d 00 00 00    	jle    80102ea3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e16:	83 ec 0c             	sub    $0xc,%esp
80102e19:	68 80 26 11 80       	push   $0x80112680
80102e1e:	e8 ed 16 00 00       	call   80104510 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e23:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e29:	83 c4 10             	add    $0x10,%esp
80102e2c:	83 f9 00             	cmp    $0x0,%ecx
80102e2f:	7e 57                	jle    80102e88 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e31:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e34:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e36:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102e3c:	75 0b                	jne    80102e49 <log_write+0x69>
80102e3e:	eb 38                	jmp    80102e78 <log_write+0x98>
80102e40:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102e47:	74 2f                	je     80102e78 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e49:	83 c0 01             	add    $0x1,%eax
80102e4c:	39 c1                	cmp    %eax,%ecx
80102e4e:	75 f0                	jne    80102e40 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e50:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e57:	83 c0 01             	add    $0x1,%eax
80102e5a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e5f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e62:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e6c:	c9                   	leave  
  release(&log.lock);
80102e6d:	e9 be 17 00 00       	jmp    80104630 <release>
80102e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102e78:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102e7f:	eb de                	jmp    80102e5f <log_write+0x7f>
80102e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e88:	8b 43 08             	mov    0x8(%ebx),%eax
80102e8b:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102e90:	75 cd                	jne    80102e5f <log_write+0x7f>
80102e92:	31 c0                	xor    %eax,%eax
80102e94:	eb c1                	jmp    80102e57 <log_write+0x77>
    panic("too big a transaction");
80102e96:	83 ec 0c             	sub    $0xc,%esp
80102e99:	68 b3 76 10 80       	push   $0x801076b3
80102e9e:	e8 ed d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102ea3:	83 ec 0c             	sub    $0xc,%esp
80102ea6:	68 c9 76 10 80       	push   $0x801076c9
80102eab:	e8 e0 d4 ff ff       	call   80100390 <panic>

80102eb0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	53                   	push   %ebx
80102eb4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102eb7:	e8 b4 09 00 00       	call   80103870 <cpuid>
80102ebc:	89 c3                	mov    %eax,%ebx
80102ebe:	e8 ad 09 00 00       	call   80103870 <cpuid>
80102ec3:	83 ec 04             	sub    $0x4,%esp
80102ec6:	53                   	push   %ebx
80102ec7:	50                   	push   %eax
80102ec8:	68 e4 76 10 80       	push   $0x801076e4
80102ecd:	e8 8e d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ed2:	e8 a9 2a 00 00       	call   80105980 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ed7:	e8 14 09 00 00       	call   801037f0 <mycpu>
80102edc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ede:	b8 01 00 00 00       	mov    $0x1,%eax
80102ee3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102eea:	e8 61 0c 00 00       	call   80103b50 <scheduler>
80102eef:	90                   	nop

80102ef0 <mpenter>:
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ef6:	e8 75 3b 00 00       	call   80106a70 <switchkvm>
  seginit();
80102efb:	e8 e0 3a 00 00       	call   801069e0 <seginit>
  lapicinit();
80102f00:	e8 9b f7 ff ff       	call   801026a0 <lapicinit>
  mpmain();
80102f05:	e8 a6 ff ff ff       	call   80102eb0 <mpmain>
80102f0a:	66 90                	xchg   %ax,%ax
80102f0c:	66 90                	xchg   %ax,%ax
80102f0e:	66 90                	xchg   %ax,%ax

80102f10 <main>:
{
80102f10:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f14:	83 e4 f0             	and    $0xfffffff0,%esp
80102f17:	ff 71 fc             	pushl  -0x4(%ecx)
80102f1a:	55                   	push   %ebp
80102f1b:	89 e5                	mov    %esp,%ebp
80102f1d:	53                   	push   %ebx
80102f1e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f1f:	83 ec 08             	sub    $0x8,%esp
80102f22:	68 00 00 40 80       	push   $0x80400000
80102f27:	68 a8 5c 11 80       	push   $0x80115ca8
80102f2c:	e8 2f f5 ff ff       	call   80102460 <kinit1>
  kvmalloc();      // kernel page table
80102f31:	e8 0a 40 00 00       	call   80106f40 <kvmalloc>
  mpinit();        // detect other processors
80102f36:	e8 75 01 00 00       	call   801030b0 <mpinit>
  lapicinit();     // interrupt controller
80102f3b:	e8 60 f7 ff ff       	call   801026a0 <lapicinit>
  seginit();       // segment descriptors
80102f40:	e8 9b 3a 00 00       	call   801069e0 <seginit>
  picinit();       // disable pic
80102f45:	e8 46 03 00 00       	call   80103290 <picinit>
  ioapicinit();    // another interrupt controller
80102f4a:	e8 41 f3 ff ff       	call   80102290 <ioapicinit>
  consoleinit();   // console hardware
80102f4f:	e8 6c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f54:	e8 57 2d 00 00       	call   80105cb0 <uartinit>
  pinit();         // process table
80102f59:	e8 72 08 00 00       	call   801037d0 <pinit>
  tvinit();        // trap vectors
80102f5e:	e8 9d 29 00 00       	call   80105900 <tvinit>
  binit();         // buffer cache
80102f63:	e8 d8 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f68:	e8 f3 dd ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102f6d:	e8 fe f0 ff ff       	call   80102070 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f72:	83 c4 0c             	add    $0xc,%esp
80102f75:	68 8a 00 00 00       	push   $0x8a
80102f7a:	68 8c a4 10 80       	push   $0x8010a48c
80102f7f:	68 00 70 00 80       	push   $0x80007000
80102f84:	e8 b7 17 00 00       	call   80104740 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f89:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f90:	00 00 00 
80102f93:	83 c4 10             	add    $0x10,%esp
80102f96:	05 80 27 11 80       	add    $0x80112780,%eax
80102f9b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102fa0:	76 71                	jbe    80103013 <main+0x103>
80102fa2:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102fa7:	89 f6                	mov    %esi,%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102fb0:	e8 3b 08 00 00       	call   801037f0 <mycpu>
80102fb5:	39 d8                	cmp    %ebx,%eax
80102fb7:	74 41                	je     80102ffa <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fb9:	e8 72 f5 ff ff       	call   80102530 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fbe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102fc3:	c7 05 f8 6f 00 80 f0 	movl   $0x80102ef0,0x80006ff8
80102fca:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fcd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fd4:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fd7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102fdc:	0f b6 03             	movzbl (%ebx),%eax
80102fdf:	83 ec 08             	sub    $0x8,%esp
80102fe2:	68 00 70 00 00       	push   $0x7000
80102fe7:	50                   	push   %eax
80102fe8:	e8 03 f8 ff ff       	call   801027f0 <lapicstartap>
80102fed:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ff0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ff6:	85 c0                	test   %eax,%eax
80102ff8:	74 f6                	je     80102ff0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102ffa:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103001:	00 00 00 
80103004:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010300a:	05 80 27 11 80       	add    $0x80112780,%eax
8010300f:	39 c3                	cmp    %eax,%ebx
80103011:	72 9d                	jb     80102fb0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103013:	83 ec 08             	sub    $0x8,%esp
80103016:	68 00 00 00 8e       	push   $0x8e000000
8010301b:	68 00 00 40 80       	push   $0x80400000
80103020:	e8 ab f4 ff ff       	call   801024d0 <kinit2>
  userinit();      // first user process
80103025:	e8 96 08 00 00       	call   801038c0 <userinit>
  mpmain();        // finish this processor's setup
8010302a:	e8 81 fe ff ff       	call   80102eb0 <mpmain>
8010302f:	90                   	nop

80103030 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103035:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010303b:	53                   	push   %ebx
  e = addr+len;
8010303c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010303f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103042:	39 de                	cmp    %ebx,%esi
80103044:	72 10                	jb     80103056 <mpsearch1+0x26>
80103046:	eb 50                	jmp    80103098 <mpsearch1+0x68>
80103048:	90                   	nop
80103049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103050:	39 fb                	cmp    %edi,%ebx
80103052:	89 fe                	mov    %edi,%esi
80103054:	76 42                	jbe    80103098 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103056:	83 ec 04             	sub    $0x4,%esp
80103059:	8d 7e 10             	lea    0x10(%esi),%edi
8010305c:	6a 04                	push   $0x4
8010305e:	68 f8 76 10 80       	push   $0x801076f8
80103063:	56                   	push   %esi
80103064:	e8 77 16 00 00       	call   801046e0 <memcmp>
80103069:	83 c4 10             	add    $0x10,%esp
8010306c:	85 c0                	test   %eax,%eax
8010306e:	75 e0                	jne    80103050 <mpsearch1+0x20>
80103070:	89 f1                	mov    %esi,%ecx
80103072:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103078:	0f b6 11             	movzbl (%ecx),%edx
8010307b:	83 c1 01             	add    $0x1,%ecx
8010307e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103080:	39 f9                	cmp    %edi,%ecx
80103082:	75 f4                	jne    80103078 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103084:	84 c0                	test   %al,%al
80103086:	75 c8                	jne    80103050 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103088:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010308b:	89 f0                	mov    %esi,%eax
8010308d:	5b                   	pop    %ebx
8010308e:	5e                   	pop    %esi
8010308f:	5f                   	pop    %edi
80103090:	5d                   	pop    %ebp
80103091:	c3                   	ret    
80103092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103098:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010309b:	31 f6                	xor    %esi,%esi
}
8010309d:	89 f0                	mov    %esi,%eax
8010309f:	5b                   	pop    %ebx
801030a0:	5e                   	pop    %esi
801030a1:	5f                   	pop    %edi
801030a2:	5d                   	pop    %ebp
801030a3:	c3                   	ret    
801030a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801030b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	57                   	push   %edi
801030b4:	56                   	push   %esi
801030b5:	53                   	push   %ebx
801030b6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030c7:	c1 e0 08             	shl    $0x8,%eax
801030ca:	09 d0                	or     %edx,%eax
801030cc:	c1 e0 04             	shl    $0x4,%eax
801030cf:	85 c0                	test   %eax,%eax
801030d1:	75 1b                	jne    801030ee <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801030d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030e1:	c1 e0 08             	shl    $0x8,%eax
801030e4:	09 d0                	or     %edx,%eax
801030e6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801030e9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801030ee:	ba 00 04 00 00       	mov    $0x400,%edx
801030f3:	e8 38 ff ff ff       	call   80103030 <mpsearch1>
801030f8:	85 c0                	test   %eax,%eax
801030fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801030fd:	0f 84 3d 01 00 00    	je     80103240 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103106:	8b 58 04             	mov    0x4(%eax),%ebx
80103109:	85 db                	test   %ebx,%ebx
8010310b:	0f 84 4f 01 00 00    	je     80103260 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103111:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103117:	83 ec 04             	sub    $0x4,%esp
8010311a:	6a 04                	push   $0x4
8010311c:	68 15 77 10 80       	push   $0x80107715
80103121:	56                   	push   %esi
80103122:	e8 b9 15 00 00       	call   801046e0 <memcmp>
80103127:	83 c4 10             	add    $0x10,%esp
8010312a:	85 c0                	test   %eax,%eax
8010312c:	0f 85 2e 01 00 00    	jne    80103260 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103132:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103139:	3c 01                	cmp    $0x1,%al
8010313b:	0f 95 c2             	setne  %dl
8010313e:	3c 04                	cmp    $0x4,%al
80103140:	0f 95 c0             	setne  %al
80103143:	20 c2                	and    %al,%dl
80103145:	0f 85 15 01 00 00    	jne    80103260 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010314b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103152:	66 85 ff             	test   %di,%di
80103155:	74 1a                	je     80103171 <mpinit+0xc1>
80103157:	89 f0                	mov    %esi,%eax
80103159:	01 f7                	add    %esi,%edi
  sum = 0;
8010315b:	31 d2                	xor    %edx,%edx
8010315d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103160:	0f b6 08             	movzbl (%eax),%ecx
80103163:	83 c0 01             	add    $0x1,%eax
80103166:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103168:	39 c7                	cmp    %eax,%edi
8010316a:	75 f4                	jne    80103160 <mpinit+0xb0>
8010316c:	84 d2                	test   %dl,%dl
8010316e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103171:	85 f6                	test   %esi,%esi
80103173:	0f 84 e7 00 00 00    	je     80103260 <mpinit+0x1b0>
80103179:	84 d2                	test   %dl,%dl
8010317b:	0f 85 df 00 00 00    	jne    80103260 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103181:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103187:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010318c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103193:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103199:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010319e:	01 d6                	add    %edx,%esi
801031a0:	39 c6                	cmp    %eax,%esi
801031a2:	76 23                	jbe    801031c7 <mpinit+0x117>
    switch(*p){
801031a4:	0f b6 10             	movzbl (%eax),%edx
801031a7:	80 fa 04             	cmp    $0x4,%dl
801031aa:	0f 87 ca 00 00 00    	ja     8010327a <mpinit+0x1ca>
801031b0:	ff 24 95 3c 77 10 80 	jmp    *-0x7fef88c4(,%edx,4)
801031b7:	89 f6                	mov    %esi,%esi
801031b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031c0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031c3:	39 c6                	cmp    %eax,%esi
801031c5:	77 dd                	ja     801031a4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801031c7:	85 db                	test   %ebx,%ebx
801031c9:	0f 84 9e 00 00 00    	je     8010326d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801031cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031d2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031d6:	74 15                	je     801031ed <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031d8:	b8 70 00 00 00       	mov    $0x70,%eax
801031dd:	ba 22 00 00 00       	mov    $0x22,%edx
801031e2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031e3:	ba 23 00 00 00       	mov    $0x23,%edx
801031e8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801031e9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ec:	ee                   	out    %al,(%dx)
  }
}
801031ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031f0:	5b                   	pop    %ebx
801031f1:	5e                   	pop    %esi
801031f2:	5f                   	pop    %edi
801031f3:	5d                   	pop    %ebp
801031f4:	c3                   	ret    
801031f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801031f8:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
801031fe:	83 f9 07             	cmp    $0x7,%ecx
80103201:	7f 19                	jg     8010321c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103203:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103207:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010320d:	83 c1 01             	add    $0x1,%ecx
80103210:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103216:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010321c:	83 c0 14             	add    $0x14,%eax
      continue;
8010321f:	e9 7c ff ff ff       	jmp    801031a0 <mpinit+0xf0>
80103224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103228:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010322c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010322f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103235:	e9 66 ff ff ff       	jmp    801031a0 <mpinit+0xf0>
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103240:	ba 00 00 01 00       	mov    $0x10000,%edx
80103245:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010324a:	e8 e1 fd ff ff       	call   80103030 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010324f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103251:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	0f 85 a9 fe ff ff    	jne    80103103 <mpinit+0x53>
8010325a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103260:	83 ec 0c             	sub    $0xc,%esp
80103263:	68 fd 76 10 80       	push   $0x801076fd
80103268:	e8 23 d1 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010326d:	83 ec 0c             	sub    $0xc,%esp
80103270:	68 1c 77 10 80       	push   $0x8010771c
80103275:	e8 16 d1 ff ff       	call   80100390 <panic>
      ismp = 0;
8010327a:	31 db                	xor    %ebx,%ebx
8010327c:	e9 26 ff ff ff       	jmp    801031a7 <mpinit+0xf7>
80103281:	66 90                	xchg   %ax,%ax
80103283:	66 90                	xchg   %ax,%ax
80103285:	66 90                	xchg   %ax,%ax
80103287:	66 90                	xchg   %ax,%ax
80103289:	66 90                	xchg   %ax,%ax
8010328b:	66 90                	xchg   %ax,%ax
8010328d:	66 90                	xchg   %ax,%ax
8010328f:	90                   	nop

80103290 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103290:	55                   	push   %ebp
80103291:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103296:	ba 21 00 00 00       	mov    $0x21,%edx
8010329b:	89 e5                	mov    %esp,%ebp
8010329d:	ee                   	out    %al,(%dx)
8010329e:	ba a1 00 00 00       	mov    $0xa1,%edx
801032a3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801032a4:	5d                   	pop    %ebp
801032a5:	c3                   	ret    
801032a6:	66 90                	xchg   %ax,%ax
801032a8:	66 90                	xchg   %ax,%ax
801032aa:	66 90                	xchg   %ax,%ax
801032ac:	66 90                	xchg   %ax,%ax
801032ae:	66 90                	xchg   %ax,%ax

801032b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	57                   	push   %edi
801032b4:	56                   	push   %esi
801032b5:	53                   	push   %ebx
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801032c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032cb:	e8 b0 da ff ff       	call   80100d80 <filealloc>
801032d0:	85 c0                	test   %eax,%eax
801032d2:	89 03                	mov    %eax,(%ebx)
801032d4:	74 22                	je     801032f8 <pipealloc+0x48>
801032d6:	e8 a5 da ff ff       	call   80100d80 <filealloc>
801032db:	85 c0                	test   %eax,%eax
801032dd:	89 06                	mov    %eax,(%esi)
801032df:	74 3f                	je     80103320 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032e1:	e8 4a f2 ff ff       	call   80102530 <kalloc>
801032e6:	85 c0                	test   %eax,%eax
801032e8:	89 c7                	mov    %eax,%edi
801032ea:	75 54                	jne    80103340 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032ec:	8b 03                	mov    (%ebx),%eax
801032ee:	85 c0                	test   %eax,%eax
801032f0:	75 34                	jne    80103326 <pipealloc+0x76>
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801032f8:	8b 06                	mov    (%esi),%eax
801032fa:	85 c0                	test   %eax,%eax
801032fc:	74 0c                	je     8010330a <pipealloc+0x5a>
    fileclose(*f1);
801032fe:	83 ec 0c             	sub    $0xc,%esp
80103301:	50                   	push   %eax
80103302:	e8 39 db ff ff       	call   80100e40 <fileclose>
80103307:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010330a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010330d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103312:	5b                   	pop    %ebx
80103313:	5e                   	pop    %esi
80103314:	5f                   	pop    %edi
80103315:	5d                   	pop    %ebp
80103316:	c3                   	ret    
80103317:	89 f6                	mov    %esi,%esi
80103319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103320:	8b 03                	mov    (%ebx),%eax
80103322:	85 c0                	test   %eax,%eax
80103324:	74 e4                	je     8010330a <pipealloc+0x5a>
    fileclose(*f0);
80103326:	83 ec 0c             	sub    $0xc,%esp
80103329:	50                   	push   %eax
8010332a:	e8 11 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010332f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103331:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103334:	85 c0                	test   %eax,%eax
80103336:	75 c6                	jne    801032fe <pipealloc+0x4e>
80103338:	eb d0                	jmp    8010330a <pipealloc+0x5a>
8010333a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103340:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103343:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010334a:	00 00 00 
  p->writeopen = 1;
8010334d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103354:	00 00 00 
  p->nwrite = 0;
80103357:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010335e:	00 00 00 
  p->nread = 0;
80103361:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103368:	00 00 00 
  initlock(&p->lock, "pipe");
8010336b:	68 50 77 10 80       	push   $0x80107750
80103370:	50                   	push   %eax
80103371:	e8 aa 10 00 00       	call   80104420 <initlock>
  (*f0)->type = FD_PIPE;
80103376:	8b 03                	mov    (%ebx),%eax
  return 0;
80103378:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010337b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103381:	8b 03                	mov    (%ebx),%eax
80103383:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103387:	8b 03                	mov    (%ebx),%eax
80103389:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010338d:	8b 03                	mov    (%ebx),%eax
8010338f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103392:	8b 06                	mov    (%esi),%eax
80103394:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010339a:	8b 06                	mov    (%esi),%eax
8010339c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033a0:	8b 06                	mov    (%esi),%eax
801033a2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033a6:	8b 06                	mov    (%esi),%eax
801033a8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801033ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033ae:	31 c0                	xor    %eax,%eax
}
801033b0:	5b                   	pop    %ebx
801033b1:	5e                   	pop    %esi
801033b2:	5f                   	pop    %edi
801033b3:	5d                   	pop    %ebp
801033b4:	c3                   	ret    
801033b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	56                   	push   %esi
801033c4:	53                   	push   %ebx
801033c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033cb:	83 ec 0c             	sub    $0xc,%esp
801033ce:	53                   	push   %ebx
801033cf:	e8 3c 11 00 00       	call   80104510 <acquire>
  if(writable){
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	85 f6                	test   %esi,%esi
801033d9:	74 45                	je     80103420 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033e1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801033e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033eb:	00 00 00 
    wakeup(&p->nread);
801033ee:	50                   	push   %eax
801033ef:	e8 4c 0c 00 00       	call   80104040 <wakeup>
801033f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033fd:	85 d2                	test   %edx,%edx
801033ff:	75 0a                	jne    8010340b <pipeclose+0x4b>
80103401:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103407:	85 c0                	test   %eax,%eax
80103409:	74 35                	je     80103440 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010340b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010340e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103411:	5b                   	pop    %ebx
80103412:	5e                   	pop    %esi
80103413:	5d                   	pop    %ebp
    release(&p->lock);
80103414:	e9 17 12 00 00       	jmp    80104630 <release>
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103420:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103426:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103429:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103430:	00 00 00 
    wakeup(&p->nwrite);
80103433:	50                   	push   %eax
80103434:	e8 07 0c 00 00       	call   80104040 <wakeup>
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	eb b9                	jmp    801033f7 <pipeclose+0x37>
8010343e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	53                   	push   %ebx
80103444:	e8 e7 11 00 00       	call   80104630 <release>
    kfree((char*)p);
80103449:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010344c:	83 c4 10             	add    $0x10,%esp
}
8010344f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103452:	5b                   	pop    %ebx
80103453:	5e                   	pop    %esi
80103454:	5d                   	pop    %ebp
    kfree((char*)p);
80103455:	e9 26 ef ff ff       	jmp    80102380 <kfree>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103460 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 28             	sub    $0x28,%esp
80103469:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010346c:	53                   	push   %ebx
8010346d:	e8 9e 10 00 00       	call   80104510 <acquire>
  for(i = 0; i < n; i++){
80103472:	8b 45 10             	mov    0x10(%ebp),%eax
80103475:	83 c4 10             	add    $0x10,%esp
80103478:	85 c0                	test   %eax,%eax
8010347a:	0f 8e c9 00 00 00    	jle    80103549 <pipewrite+0xe9>
80103480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103483:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103489:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010348f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103492:	03 4d 10             	add    0x10(%ebp),%ecx
80103495:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103498:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010349e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801034a4:	39 d0                	cmp    %edx,%eax
801034a6:	75 71                	jne    80103519 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801034a8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034ae:	85 c0                	test   %eax,%eax
801034b0:	74 4e                	je     80103500 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034b2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801034b8:	eb 3a                	jmp    801034f4 <pipewrite+0x94>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	57                   	push   %edi
801034c4:	e8 77 0b 00 00       	call   80104040 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034c9:	5a                   	pop    %edx
801034ca:	59                   	pop    %ecx
801034cb:	53                   	push   %ebx
801034cc:	56                   	push   %esi
801034cd:	e8 ae 09 00 00       	call   80103e80 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034d8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034de:	83 c4 10             	add    $0x10,%esp
801034e1:	05 00 02 00 00       	add    $0x200,%eax
801034e6:	39 c2                	cmp    %eax,%edx
801034e8:	75 36                	jne    80103520 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801034ea:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034f0:	85 c0                	test   %eax,%eax
801034f2:	74 0c                	je     80103500 <pipewrite+0xa0>
801034f4:	e8 97 03 00 00       	call   80103890 <myproc>
801034f9:	8b 40 24             	mov    0x24(%eax),%eax
801034fc:	85 c0                	test   %eax,%eax
801034fe:	74 c0                	je     801034c0 <pipewrite+0x60>
        release(&p->lock);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	53                   	push   %ebx
80103504:	e8 27 11 00 00       	call   80104630 <release>
        return -1;
80103509:	83 c4 10             	add    $0x10,%esp
8010350c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103511:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103514:	5b                   	pop    %ebx
80103515:	5e                   	pop    %esi
80103516:	5f                   	pop    %edi
80103517:	5d                   	pop    %ebp
80103518:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103519:	89 c2                	mov    %eax,%edx
8010351b:	90                   	nop
8010351c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103520:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103523:	8d 42 01             	lea    0x1(%edx),%eax
80103526:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010352c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103532:	83 c6 01             	add    $0x1,%esi
80103535:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103539:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010353c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010353f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103543:	0f 85 4f ff ff ff    	jne    80103498 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103549:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010354f:	83 ec 0c             	sub    $0xc,%esp
80103552:	50                   	push   %eax
80103553:	e8 e8 0a 00 00       	call   80104040 <wakeup>
  release(&p->lock);
80103558:	89 1c 24             	mov    %ebx,(%esp)
8010355b:	e8 d0 10 00 00       	call   80104630 <release>
  return n;
80103560:	83 c4 10             	add    $0x10,%esp
80103563:	8b 45 10             	mov    0x10(%ebp),%eax
80103566:	eb a9                	jmp    80103511 <pipewrite+0xb1>
80103568:	90                   	nop
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103570 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	57                   	push   %edi
80103574:	56                   	push   %esi
80103575:	53                   	push   %ebx
80103576:	83 ec 18             	sub    $0x18,%esp
80103579:	8b 75 08             	mov    0x8(%ebp),%esi
8010357c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010357f:	56                   	push   %esi
80103580:	e8 8b 0f 00 00       	call   80104510 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103585:	83 c4 10             	add    $0x10,%esp
80103588:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010358e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103594:	75 6a                	jne    80103600 <piperead+0x90>
80103596:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010359c:	85 db                	test   %ebx,%ebx
8010359e:	0f 84 c4 00 00 00    	je     80103668 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035a4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035aa:	eb 2d                	jmp    801035d9 <piperead+0x69>
801035ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035b0:	83 ec 08             	sub    $0x8,%esp
801035b3:	56                   	push   %esi
801035b4:	53                   	push   %ebx
801035b5:	e8 c6 08 00 00       	call   80103e80 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035ba:	83 c4 10             	add    $0x10,%esp
801035bd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035c3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035c9:	75 35                	jne    80103600 <piperead+0x90>
801035cb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801035d1:	85 d2                	test   %edx,%edx
801035d3:	0f 84 8f 00 00 00    	je     80103668 <piperead+0xf8>
    if(myproc()->killed){
801035d9:	e8 b2 02 00 00       	call   80103890 <myproc>
801035de:	8b 48 24             	mov    0x24(%eax),%ecx
801035e1:	85 c9                	test   %ecx,%ecx
801035e3:	74 cb                	je     801035b0 <piperead+0x40>
      release(&p->lock);
801035e5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801035e8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801035ed:	56                   	push   %esi
801035ee:	e8 3d 10 00 00       	call   80104630 <release>
      return -1;
801035f3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035f9:	89 d8                	mov    %ebx,%eax
801035fb:	5b                   	pop    %ebx
801035fc:	5e                   	pop    %esi
801035fd:	5f                   	pop    %edi
801035fe:	5d                   	pop    %ebp
801035ff:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103600:	8b 45 10             	mov    0x10(%ebp),%eax
80103603:	85 c0                	test   %eax,%eax
80103605:	7e 61                	jle    80103668 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103607:	31 db                	xor    %ebx,%ebx
80103609:	eb 13                	jmp    8010361e <piperead+0xae>
8010360b:	90                   	nop
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103610:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103616:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010361c:	74 1f                	je     8010363d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010361e:	8d 41 01             	lea    0x1(%ecx),%eax
80103621:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103627:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010362d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103632:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103635:	83 c3 01             	add    $0x1,%ebx
80103638:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010363b:	75 d3                	jne    80103610 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010363d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103643:	83 ec 0c             	sub    $0xc,%esp
80103646:	50                   	push   %eax
80103647:	e8 f4 09 00 00       	call   80104040 <wakeup>
  release(&p->lock);
8010364c:	89 34 24             	mov    %esi,(%esp)
8010364f:	e8 dc 0f 00 00       	call   80104630 <release>
  return i;
80103654:	83 c4 10             	add    $0x10,%esp
}
80103657:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365a:	89 d8                	mov    %ebx,%eax
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103668:	31 db                	xor    %ebx,%ebx
8010366a:	eb d1                	jmp    8010363d <piperead+0xcd>
8010366c:	66 90                	xchg   %ax,%ax
8010366e:	66 90                	xchg   %ax,%ax

80103670 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103674:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
80103679:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010367c:	68 20 2d 11 80       	push   $0x80112d20
80103681:	e8 8a 0e 00 00       	call   80104510 <acquire>
80103686:	83 c4 10             	add    $0x10,%esp
80103689:	eb 17                	jmp    801036a2 <allocproc+0x32>
8010368b:	90                   	nop
8010368c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103690:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103696:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
8010369c:	0f 83 ae 00 00 00    	jae    80103750 <allocproc+0xe0>
    if(p->state == UNUSED)
801036a2:	8b 43 0c             	mov    0xc(%ebx),%eax
801036a5:	85 c0                	test   %eax,%eax
801036a7:	75 e7                	jne    80103690 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036a9:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  p->createTime = ticks;
  p->readyTime = 0;
  p->runTime= 0;
  p->sleepTime = 0;
  release(&ptable.lock);
801036ae:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801036b1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 10;
801036b8:	c7 83 8c 00 00 00 0a 	movl   $0xa,0x8c(%ebx)
801036bf:	00 00 00 
  p->readyTime = 0;
801036c2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801036c9:	00 00 00 
  p->runTime= 0;
801036cc:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
801036d3:	00 00 00 
  p->sleepTime = 0;
801036d6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801036dd:	00 00 00 
  p->pid = nextpid++;
801036e0:	8d 50 01             	lea    0x1(%eax),%edx
801036e3:	89 43 10             	mov    %eax,0x10(%ebx)
  p->createTime = ticks;
801036e6:	a1 a0 5c 11 80       	mov    0x80115ca0,%eax
  p->pid = nextpid++;
801036eb:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  p->createTime = ticks;
801036f1:	89 43 7c             	mov    %eax,0x7c(%ebx)
  release(&ptable.lock);
801036f4:	68 20 2d 11 80       	push   $0x80112d20
801036f9:	e8 32 0f 00 00       	call   80104630 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036fe:	e8 2d ee ff ff       	call   80102530 <kalloc>
80103703:	83 c4 10             	add    $0x10,%esp
80103706:	85 c0                	test   %eax,%eax
80103708:	89 43 08             	mov    %eax,0x8(%ebx)
8010370b:	74 5c                	je     80103769 <allocproc+0xf9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010370d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103713:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103716:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010371b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010371e:	c7 40 14 f1 58 10 80 	movl   $0x801058f1,0x14(%eax)
  p->context = (struct context*)sp;
80103725:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103728:	6a 14                	push   $0x14
8010372a:	6a 00                	push   $0x0
8010372c:	50                   	push   %eax
8010372d:	e8 5e 0f 00 00       	call   80104690 <memset>
  p->context->eip = (uint)forkret;
80103732:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103735:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103738:	c7 40 10 80 37 10 80 	movl   $0x80103780,0x10(%eax)
}
8010373f:	89 d8                	mov    %ebx,%eax
80103741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103744:	c9                   	leave  
80103745:	c3                   	ret    
80103746:	8d 76 00             	lea    0x0(%esi),%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&ptable.lock);
80103750:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103753:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103755:	68 20 2d 11 80       	push   $0x80112d20
8010375a:	e8 d1 0e 00 00       	call   80104630 <release>
}
8010375f:	89 d8                	mov    %ebx,%eax
  return 0;
80103761:	83 c4 10             	add    $0x10,%esp
}
80103764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103767:	c9                   	leave  
80103768:	c3                   	ret    
    p->state = UNUSED;
80103769:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103770:	31 db                	xor    %ebx,%ebx
80103772:	eb cb                	jmp    8010373f <allocproc+0xcf>
80103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103780 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103786:	68 20 2d 11 80       	push   $0x80112d20
8010378b:	e8 a0 0e 00 00       	call   80104630 <release>

  if (first) {
80103790:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	85 c0                	test   %eax,%eax
8010379a:	75 04                	jne    801037a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010379c:	c9                   	leave  
8010379d:	c3                   	ret    
8010379e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801037a0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801037a3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037aa:	00 00 00 
    iinit(ROOTDEV);
801037ad:	6a 01                	push   $0x1
801037af:	e8 dc dc ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
801037b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037bb:	e8 b0 f3 ff ff       	call   80102b70 <initlog>
801037c0:	83 c4 10             	add    $0x10,%esp
}
801037c3:	c9                   	leave  
801037c4:	c3                   	ret    
801037c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <pinit>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037d6:	68 55 77 10 80       	push   $0x80107755
801037db:	68 20 2d 11 80       	push   $0x80112d20
801037e0:	e8 3b 0c 00 00       	call   80104420 <initlock>
}
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	c9                   	leave  
801037e9:	c3                   	ret    
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037f0 <mycpu>:
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037f5:	9c                   	pushf  
801037f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037f7:	f6 c4 02             	test   $0x2,%ah
801037fa:	75 5e                	jne    8010385a <mycpu+0x6a>
  apicid = lapicid();
801037fc:	e8 9f ef ff ff       	call   801027a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103801:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103807:	85 f6                	test   %esi,%esi
80103809:	7e 42                	jle    8010384d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010380b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103812:	39 d0                	cmp    %edx,%eax
80103814:	74 30                	je     80103846 <mycpu+0x56>
80103816:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010381b:	31 d2                	xor    %edx,%edx
8010381d:	8d 76 00             	lea    0x0(%esi),%esi
80103820:	83 c2 01             	add    $0x1,%edx
80103823:	39 f2                	cmp    %esi,%edx
80103825:	74 26                	je     8010384d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103827:	0f b6 19             	movzbl (%ecx),%ebx
8010382a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103830:	39 c3                	cmp    %eax,%ebx
80103832:	75 ec                	jne    80103820 <mycpu+0x30>
80103834:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010383a:	05 80 27 11 80       	add    $0x80112780,%eax
}
8010383f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103842:	5b                   	pop    %ebx
80103843:	5e                   	pop    %esi
80103844:	5d                   	pop    %ebp
80103845:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103846:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010384b:	eb f2                	jmp    8010383f <mycpu+0x4f>
  panic("unknown apicid\n");
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	68 5c 77 10 80       	push   $0x8010775c
80103855:	e8 36 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010385a:	83 ec 0c             	sub    $0xc,%esp
8010385d:	68 84 78 10 80       	push   $0x80107884
80103862:	e8 29 cb ff ff       	call   80100390 <panic>
80103867:	89 f6                	mov    %esi,%esi
80103869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103870 <cpuid>:
cpuid() {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103876:	e8 75 ff ff ff       	call   801037f0 <mycpu>
8010387b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103880:	c9                   	leave  
  return mycpu()-cpus;
80103881:	c1 f8 04             	sar    $0x4,%eax
80103884:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010388a:	c3                   	ret    
8010388b:	90                   	nop
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103890 <myproc>:
myproc(void) {
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103897:	e8 34 0c 00 00       	call   801044d0 <pushcli>
  c = mycpu();
8010389c:	e8 4f ff ff ff       	call   801037f0 <mycpu>
  p = c->proc;
801038a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038a7:	e8 24 0d 00 00       	call   801045d0 <popcli>
}
801038ac:	83 c4 04             	add    $0x4,%esp
801038af:	89 d8                	mov    %ebx,%eax
801038b1:	5b                   	pop    %ebx
801038b2:	5d                   	pop    %ebp
801038b3:	c3                   	ret    
801038b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038c0 <userinit>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
801038c4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801038c7:	e8 a4 fd ff ff       	call   80103670 <allocproc>
801038cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801038ce:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801038d3:	e8 e8 35 00 00       	call   80106ec0 <setupkvm>
801038d8:	85 c0                	test   %eax,%eax
801038da:	89 43 04             	mov    %eax,0x4(%ebx)
801038dd:	0f 84 bd 00 00 00    	je     801039a0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038e3:	83 ec 04             	sub    $0x4,%esp
801038e6:	68 2c 00 00 00       	push   $0x2c
801038eb:	68 60 a4 10 80       	push   $0x8010a460
801038f0:	50                   	push   %eax
801038f1:	e8 aa 32 00 00       	call   80106ba0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038f6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038ff:	6a 4c                	push   $0x4c
80103901:	6a 00                	push   $0x0
80103903:	ff 73 18             	pushl  0x18(%ebx)
80103906:	e8 85 0d 00 00       	call   80104690 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010390b:	8b 43 18             	mov    0x18(%ebx),%eax
8010390e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103913:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103918:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010391b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010391f:	8b 43 18             	mov    0x18(%ebx),%eax
80103922:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103926:	8b 43 18             	mov    0x18(%ebx),%eax
80103929:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010392d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103931:	8b 43 18             	mov    0x18(%ebx),%eax
80103934:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103938:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010393c:	8b 43 18             	mov    0x18(%ebx),%eax
8010393f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103946:	8b 43 18             	mov    0x18(%ebx),%eax
80103949:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103950:	8b 43 18             	mov    0x18(%ebx),%eax
80103953:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010395a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010395d:	6a 10                	push   $0x10
8010395f:	68 85 77 10 80       	push   $0x80107785
80103964:	50                   	push   %eax
80103965:	e8 06 0f 00 00       	call   80104870 <safestrcpy>
  p->cwd = namei("/");
8010396a:	c7 04 24 8e 77 10 80 	movl   $0x8010778e,(%esp)
80103971:	e8 7a e5 ff ff       	call   80101ef0 <namei>
80103976:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103979:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103980:	e8 8b 0b 00 00       	call   80104510 <acquire>
  p->state = RUNNABLE;
80103985:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010398c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103993:	e8 98 0c 00 00       	call   80104630 <release>
}
80103998:	83 c4 10             	add    $0x10,%esp
8010399b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010399e:	c9                   	leave  
8010399f:	c3                   	ret    
    panic("userinit: out of memory?");
801039a0:	83 ec 0c             	sub    $0xc,%esp
801039a3:	68 6c 77 10 80       	push   $0x8010776c
801039a8:	e8 e3 c9 ff ff       	call   80100390 <panic>
801039ad:	8d 76 00             	lea    0x0(%esi),%esi

801039b0 <growproc>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
801039b5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801039b8:	e8 13 0b 00 00       	call   801044d0 <pushcli>
  c = mycpu();
801039bd:	e8 2e fe ff ff       	call   801037f0 <mycpu>
  p = c->proc;
801039c2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039c8:	e8 03 0c 00 00       	call   801045d0 <popcli>
  if(n > 0){
801039cd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801039d0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801039d2:	7f 1c                	jg     801039f0 <growproc+0x40>
  } else if(n < 0){
801039d4:	75 3a                	jne    80103a10 <growproc+0x60>
  switchuvm(curproc);
801039d6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801039d9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801039db:	53                   	push   %ebx
801039dc:	e8 af 30 00 00       	call   80106a90 <switchuvm>
  return 0;
801039e1:	83 c4 10             	add    $0x10,%esp
801039e4:	31 c0                	xor    %eax,%eax
}
801039e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039e9:	5b                   	pop    %ebx
801039ea:	5e                   	pop    %esi
801039eb:	5d                   	pop    %ebp
801039ec:	c3                   	ret    
801039ed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039f0:	83 ec 04             	sub    $0x4,%esp
801039f3:	01 c6                	add    %eax,%esi
801039f5:	56                   	push   %esi
801039f6:	50                   	push   %eax
801039f7:	ff 73 04             	pushl  0x4(%ebx)
801039fa:	e8 e1 32 00 00       	call   80106ce0 <allocuvm>
801039ff:	83 c4 10             	add    $0x10,%esp
80103a02:	85 c0                	test   %eax,%eax
80103a04:	75 d0                	jne    801039d6 <growproc+0x26>
      return -1;
80103a06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a0b:	eb d9                	jmp    801039e6 <growproc+0x36>
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a10:	83 ec 04             	sub    $0x4,%esp
80103a13:	01 c6                	add    %eax,%esi
80103a15:	56                   	push   %esi
80103a16:	50                   	push   %eax
80103a17:	ff 73 04             	pushl  0x4(%ebx)
80103a1a:	e8 f1 33 00 00       	call   80106e10 <deallocuvm>
80103a1f:	83 c4 10             	add    $0x10,%esp
80103a22:	85 c0                	test   %eax,%eax
80103a24:	75 b0                	jne    801039d6 <growproc+0x26>
80103a26:	eb de                	jmp    80103a06 <growproc+0x56>
80103a28:	90                   	nop
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a30 <fork>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	57                   	push   %edi
80103a34:	56                   	push   %esi
80103a35:	53                   	push   %ebx
80103a36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a39:	e8 92 0a 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103a3e:	e8 ad fd ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103a43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a49:	e8 82 0b 00 00       	call   801045d0 <popcli>
  if((np = allocproc()) == 0){
80103a4e:	e8 1d fc ff ff       	call   80103670 <allocproc>
80103a53:	85 c0                	test   %eax,%eax
80103a55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a58:	0f 84 b7 00 00 00    	je     80103b15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a5e:	83 ec 08             	sub    $0x8,%esp
80103a61:	ff 33                	pushl  (%ebx)
80103a63:	ff 73 04             	pushl  0x4(%ebx)
80103a66:	89 c7                	mov    %eax,%edi
80103a68:	e8 23 35 00 00       	call   80106f90 <copyuvm>
80103a6d:	83 c4 10             	add    $0x10,%esp
80103a70:	85 c0                	test   %eax,%eax
80103a72:	89 47 04             	mov    %eax,0x4(%edi)
80103a75:	0f 84 a1 00 00 00    	je     80103b1c <fork+0xec>
  np->sz = curproc->sz;
80103a7b:	8b 03                	mov    (%ebx),%eax
80103a7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a80:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103a82:	89 59 14             	mov    %ebx,0x14(%ecx)
80103a85:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103a87:	8b 79 18             	mov    0x18(%ecx),%edi
80103a8a:	8b 73 18             	mov    0x18(%ebx),%esi
80103a8d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a96:	8b 40 18             	mov    0x18(%eax),%eax
80103a99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103aa0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103aa4:	85 c0                	test   %eax,%eax
80103aa6:	74 13                	je     80103abb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103aa8:	83 ec 0c             	sub    $0xc,%esp
80103aab:	50                   	push   %eax
80103aac:	e8 3f d3 ff ff       	call   80100df0 <filedup>
80103ab1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ab4:	83 c4 10             	add    $0x10,%esp
80103ab7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103abb:	83 c6 01             	add    $0x1,%esi
80103abe:	83 fe 10             	cmp    $0x10,%esi
80103ac1:	75 dd                	jne    80103aa0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ac3:	83 ec 0c             	sub    $0xc,%esp
80103ac6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ac9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103acc:	e8 8f db ff ff       	call   80101660 <idup>
80103ad1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ad4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ad7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ada:	8d 47 6c             	lea    0x6c(%edi),%eax
80103add:	6a 10                	push   $0x10
80103adf:	53                   	push   %ebx
80103ae0:	50                   	push   %eax
80103ae1:	e8 8a 0d 00 00       	call   80104870 <safestrcpy>
  pid = np->pid;
80103ae6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ae9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103af0:	e8 1b 0a 00 00       	call   80104510 <acquire>
  np->state = RUNNABLE;
80103af5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103afc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b03:	e8 28 0b 00 00       	call   80104630 <release>
  return pid;
80103b08:	83 c4 10             	add    $0x10,%esp
}
80103b0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b0e:	89 d8                	mov    %ebx,%eax
80103b10:	5b                   	pop    %ebx
80103b11:	5e                   	pop    %esi
80103b12:	5f                   	pop    %edi
80103b13:	5d                   	pop    %ebp
80103b14:	c3                   	ret    
    return -1;
80103b15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b1a:	eb ef                	jmp    80103b0b <fork+0xdb>
    kfree(np->kstack);
80103b1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b1f:	83 ec 0c             	sub    $0xc,%esp
80103b22:	ff 73 08             	pushl  0x8(%ebx)
80103b25:	e8 56 e8 ff ff       	call   80102380 <kfree>
    np->kstack = 0;
80103b2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b31:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b38:	83 c4 10             	add    $0x10,%esp
80103b3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b40:	eb c9                	jmp    80103b0b <fork+0xdb>
80103b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b50 <scheduler>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
80103b55:	53                   	push   %ebx
80103b56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103b59:	e8 92 fc ff ff       	call   801037f0 <mycpu>
80103b5e:	8d 70 04             	lea    0x4(%eax),%esi
80103b61:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103b63:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b6a:	00 00 00 
  asm volatile("sti");
80103b6d:	fb                   	sti    
    acquire(&ptable.lock);
80103b6e:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b71:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
    acquire(&ptable.lock);
80103b76:	68 20 2d 11 80       	push   $0x80112d20
80103b7b:	e8 90 09 00 00       	call   80104510 <acquire>
80103b80:	83 c4 10             	add    $0x10,%esp
80103b83:	eb 15                	jmp    80103b9a <scheduler+0x4a>
80103b85:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b88:	81 c7 9c 00 00 00    	add    $0x9c,%edi
80103b8e:	81 ff 54 54 11 80    	cmp    $0x80115454,%edi
80103b94:	0f 83 88 00 00 00    	jae    80103c22 <scheduler+0xd2>
      if(p->state != RUNNABLE)
80103b9a:	83 7f 0c 03          	cmpl   $0x3,0xc(%edi)
80103b9e:	75 e8                	jne    80103b88 <scheduler+0x38>
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103ba0:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ba5:	8d 76 00             	lea    0x0(%esi),%esi
	      if(p1->state != RUNNABLE)
80103ba8:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103bac:	75 0f                	jne    80103bbd <scheduler+0x6d>
	      if(highP->priority > p1->priority) //larger value, lower priority
80103bae:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80103bb4:	39 97 8c 00 00 00    	cmp    %edx,0x8c(%edi)
80103bba:	0f 4f f8             	cmovg  %eax,%edi
      for(p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++){
80103bbd:	05 9c 00 00 00       	add    $0x9c,%eax
80103bc2:	3d 54 54 11 80       	cmp    $0x80115454,%eax
80103bc7:	72 df                	jb     80103ba8 <scheduler+0x58>
      switchuvm(p);
80103bc9:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103bcc:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103bd2:	57                   	push   %edi
80103bd3:	e8 b8 2e 00 00       	call   80106a90 <switchuvm>
      cprintf("Process %s with pid %d running\n",p->name,p->pid);
80103bd8:	8d 47 6c             	lea    0x6c(%edi),%eax
80103bdb:	83 c4 0c             	add    $0xc,%esp
      p->state = RUNNING;
80103bde:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      cprintf("Process %s with pid %d running\n",p->name,p->pid);
80103be5:	ff 77 10             	pushl  0x10(%edi)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103be8:	81 c7 9c 00 00 00    	add    $0x9c,%edi
      cprintf("Process %s with pid %d running\n",p->name,p->pid);
80103bee:	50                   	push   %eax
80103bef:	68 ac 78 10 80       	push   $0x801078ac
80103bf4:	e8 67 ca ff ff       	call   80100660 <cprintf>
      swtch(&(c->scheduler), p->context);
80103bf9:	58                   	pop    %eax
80103bfa:	5a                   	pop    %edx
80103bfb:	ff 77 80             	pushl  -0x80(%edi)
80103bfe:	56                   	push   %esi
80103bff:	e8 c7 0c 00 00       	call   801048cb <swtch>
      switchkvm();
80103c04:	e8 67 2e 00 00       	call   80106a70 <switchkvm>
      c->proc = 0;
80103c09:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c0c:	81 ff 54 54 11 80    	cmp    $0x80115454,%edi
      c->proc = 0;
80103c12:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103c19:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c1c:	0f 82 78 ff ff ff    	jb     80103b9a <scheduler+0x4a>
    release(&ptable.lock);
80103c22:	83 ec 0c             	sub    $0xc,%esp
80103c25:	68 20 2d 11 80       	push   $0x80112d20
80103c2a:	e8 01 0a 00 00       	call   80104630 <release>
  for(;;){
80103c2f:	83 c4 10             	add    $0x10,%esp
80103c32:	e9 36 ff ff ff       	jmp    80103b6d <scheduler+0x1d>
80103c37:	89 f6                	mov    %esi,%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c40 <sched>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
  pushcli();
80103c45:	e8 86 08 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103c4a:	e8 a1 fb ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103c4f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c55:	e8 76 09 00 00       	call   801045d0 <popcli>
  if(!holding(&ptable.lock))
80103c5a:	83 ec 0c             	sub    $0xc,%esp
80103c5d:	68 20 2d 11 80       	push   $0x80112d20
80103c62:	e8 29 08 00 00       	call   80104490 <holding>
80103c67:	83 c4 10             	add    $0x10,%esp
80103c6a:	85 c0                	test   %eax,%eax
80103c6c:	74 4f                	je     80103cbd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c6e:	e8 7d fb ff ff       	call   801037f0 <mycpu>
80103c73:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c7a:	75 68                	jne    80103ce4 <sched+0xa4>
  if(p->state == RUNNING)
80103c7c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c80:	74 55                	je     80103cd7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c82:	9c                   	pushf  
80103c83:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c84:	f6 c4 02             	test   $0x2,%ah
80103c87:	75 41                	jne    80103cca <sched+0x8a>
  intena = mycpu()->intena;
80103c89:	e8 62 fb ff ff       	call   801037f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c8e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c91:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c97:	e8 54 fb ff ff       	call   801037f0 <mycpu>
80103c9c:	83 ec 08             	sub    $0x8,%esp
80103c9f:	ff 70 04             	pushl  0x4(%eax)
80103ca2:	53                   	push   %ebx
80103ca3:	e8 23 0c 00 00       	call   801048cb <swtch>
  mycpu()->intena = intena;
80103ca8:	e8 43 fb ff ff       	call   801037f0 <mycpu>
}
80103cad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103cb0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103cb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cb9:	5b                   	pop    %ebx
80103cba:	5e                   	pop    %esi
80103cbb:	5d                   	pop    %ebp
80103cbc:	c3                   	ret    
    panic("sched ptable.lock");
80103cbd:	83 ec 0c             	sub    $0xc,%esp
80103cc0:	68 90 77 10 80       	push   $0x80107790
80103cc5:	e8 c6 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103cca:	83 ec 0c             	sub    $0xc,%esp
80103ccd:	68 bc 77 10 80       	push   $0x801077bc
80103cd2:	e8 b9 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103cd7:	83 ec 0c             	sub    $0xc,%esp
80103cda:	68 ae 77 10 80       	push   $0x801077ae
80103cdf:	e8 ac c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103ce4:	83 ec 0c             	sub    $0xc,%esp
80103ce7:	68 a2 77 10 80       	push   $0x801077a2
80103cec:	e8 9f c6 ff ff       	call   80100390 <panic>
80103cf1:	eb 0d                	jmp    80103d00 <exit>
80103cf3:	90                   	nop
80103cf4:	90                   	nop
80103cf5:	90                   	nop
80103cf6:	90                   	nop
80103cf7:	90                   	nop
80103cf8:	90                   	nop
80103cf9:	90                   	nop
80103cfa:	90                   	nop
80103cfb:	90                   	nop
80103cfc:	90                   	nop
80103cfd:	90                   	nop
80103cfe:	90                   	nop
80103cff:	90                   	nop

80103d00 <exit>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103d09:	e8 c2 07 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103d0e:	e8 dd fa ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103d13:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d19:	e8 b2 08 00 00       	call   801045d0 <popcli>
  if(curproc == initproc)
80103d1e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d24:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d27:	8d 7e 68             	lea    0x68(%esi),%edi
80103d2a:	0f 84 f1 00 00 00    	je     80103e21 <exit+0x121>
    if(curproc->ofile[fd]){
80103d30:	8b 03                	mov    (%ebx),%eax
80103d32:	85 c0                	test   %eax,%eax
80103d34:	74 12                	je     80103d48 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d36:	83 ec 0c             	sub    $0xc,%esp
80103d39:	50                   	push   %eax
80103d3a:	e8 01 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103d3f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d45:	83 c4 10             	add    $0x10,%esp
80103d48:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d4b:	39 fb                	cmp    %edi,%ebx
80103d4d:	75 e1                	jne    80103d30 <exit+0x30>
  begin_op();
80103d4f:	e8 bc ee ff ff       	call   80102c10 <begin_op>
  iput(curproc->cwd);
80103d54:	83 ec 0c             	sub    $0xc,%esp
80103d57:	ff 76 68             	pushl  0x68(%esi)
80103d5a:	e8 61 da ff ff       	call   801017c0 <iput>
  end_op();
80103d5f:	e8 1c ef ff ff       	call   80102c80 <end_op>
  curproc->cwd = 0;
80103d64:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d6b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d72:	e8 99 07 00 00       	call   80104510 <acquire>
  wakeup1(curproc->parent);
80103d77:	8b 56 14             	mov    0x14(%esi),%edx
80103d7a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d7d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d82:	eb 10                	jmp    80103d94 <exit+0x94>
80103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d88:	05 9c 00 00 00       	add    $0x9c,%eax
80103d8d:	3d 54 54 11 80       	cmp    $0x80115454,%eax
80103d92:	73 1e                	jae    80103db2 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103d94:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d98:	75 ee                	jne    80103d88 <exit+0x88>
80103d9a:	3b 50 20             	cmp    0x20(%eax),%edx
80103d9d:	75 e9                	jne    80103d88 <exit+0x88>
      p->state = RUNNABLE;
80103d9f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103da6:	05 9c 00 00 00       	add    $0x9c,%eax
80103dab:	3d 54 54 11 80       	cmp    $0x80115454,%eax
80103db0:	72 e2                	jb     80103d94 <exit+0x94>
      p->parent = initproc;
80103db2:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db8:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103dbd:	eb 0f                	jmp    80103dce <exit+0xce>
80103dbf:	90                   	nop
80103dc0:	81 c2 9c 00 00 00    	add    $0x9c,%edx
80103dc6:	81 fa 54 54 11 80    	cmp    $0x80115454,%edx
80103dcc:	73 3a                	jae    80103e08 <exit+0x108>
    if(p->parent == curproc){
80103dce:	39 72 14             	cmp    %esi,0x14(%edx)
80103dd1:	75 ed                	jne    80103dc0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103dd3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103dd7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103dda:	75 e4                	jne    80103dc0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ddc:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103de1:	eb 11                	jmp    80103df4 <exit+0xf4>
80103de3:	90                   	nop
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103de8:	05 9c 00 00 00       	add    $0x9c,%eax
80103ded:	3d 54 54 11 80       	cmp    $0x80115454,%eax
80103df2:	73 cc                	jae    80103dc0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103df4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103df8:	75 ee                	jne    80103de8 <exit+0xe8>
80103dfa:	3b 48 20             	cmp    0x20(%eax),%ecx
80103dfd:	75 e9                	jne    80103de8 <exit+0xe8>
      p->state = RUNNABLE;
80103dff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e06:	eb e0                	jmp    80103de8 <exit+0xe8>
  curproc->state = ZOMBIE;
80103e08:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103e0f:	e8 2c fe ff ff       	call   80103c40 <sched>
  panic("zombie exit");
80103e14:	83 ec 0c             	sub    $0xc,%esp
80103e17:	68 dd 77 10 80       	push   $0x801077dd
80103e1c:	e8 6f c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e21:	83 ec 0c             	sub    $0xc,%esp
80103e24:	68 d0 77 10 80       	push   $0x801077d0
80103e29:	e8 62 c5 ff ff       	call   80100390 <panic>
80103e2e:	66 90                	xchg   %ax,%ax

80103e30 <yield>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	53                   	push   %ebx
80103e34:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e37:	68 20 2d 11 80       	push   $0x80112d20
80103e3c:	e8 cf 06 00 00       	call   80104510 <acquire>
  pushcli();
80103e41:	e8 8a 06 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103e46:	e8 a5 f9 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103e4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e51:	e8 7a 07 00 00       	call   801045d0 <popcli>
  myproc()->state = RUNNABLE;
80103e56:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e5d:	e8 de fd ff ff       	call   80103c40 <sched>
  release(&ptable.lock);
80103e62:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e69:	e8 c2 07 00 00       	call   80104630 <release>
}
80103e6e:	83 c4 10             	add    $0x10,%esp
80103e71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e74:	c9                   	leave  
80103e75:	c3                   	ret    
80103e76:	8d 76 00             	lea    0x0(%esi),%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e80 <sleep>:
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
80103e83:	57                   	push   %edi
80103e84:	56                   	push   %esi
80103e85:	53                   	push   %ebx
80103e86:	83 ec 0c             	sub    $0xc,%esp
80103e89:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e8f:	e8 3c 06 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103e94:	e8 57 f9 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103e99:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e9f:	e8 2c 07 00 00       	call   801045d0 <popcli>
  if(p == 0)
80103ea4:	85 db                	test   %ebx,%ebx
80103ea6:	0f 84 87 00 00 00    	je     80103f33 <sleep+0xb3>
  if(lk == 0)
80103eac:	85 f6                	test   %esi,%esi
80103eae:	74 76                	je     80103f26 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103eb0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103eb6:	74 50                	je     80103f08 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103eb8:	83 ec 0c             	sub    $0xc,%esp
80103ebb:	68 20 2d 11 80       	push   $0x80112d20
80103ec0:	e8 4b 06 00 00       	call   80104510 <acquire>
    release(lk);
80103ec5:	89 34 24             	mov    %esi,(%esp)
80103ec8:	e8 63 07 00 00       	call   80104630 <release>
  p->chan = chan;
80103ecd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ed0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ed7:	e8 64 fd ff ff       	call   80103c40 <sched>
  p->chan = 0;
80103edc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ee3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eea:	e8 41 07 00 00       	call   80104630 <release>
    acquire(lk);
80103eef:	89 75 08             	mov    %esi,0x8(%ebp)
80103ef2:	83 c4 10             	add    $0x10,%esp
}
80103ef5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ef8:	5b                   	pop    %ebx
80103ef9:	5e                   	pop    %esi
80103efa:	5f                   	pop    %edi
80103efb:	5d                   	pop    %ebp
    acquire(lk);
80103efc:	e9 0f 06 00 00       	jmp    80104510 <acquire>
80103f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103f08:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103f0b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f12:	e8 29 fd ff ff       	call   80103c40 <sched>
  p->chan = 0;
80103f17:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f21:	5b                   	pop    %ebx
80103f22:	5e                   	pop    %esi
80103f23:	5f                   	pop    %edi
80103f24:	5d                   	pop    %ebp
80103f25:	c3                   	ret    
    panic("sleep without lk");
80103f26:	83 ec 0c             	sub    $0xc,%esp
80103f29:	68 ef 77 10 80       	push   $0x801077ef
80103f2e:	e8 5d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f33:	83 ec 0c             	sub    $0xc,%esp
80103f36:	68 e9 77 10 80       	push   $0x801077e9
80103f3b:	e8 50 c4 ff ff       	call   80100390 <panic>

80103f40 <wait>:
{
80103f40:	55                   	push   %ebp
80103f41:	89 e5                	mov    %esp,%ebp
80103f43:	56                   	push   %esi
80103f44:	53                   	push   %ebx
  pushcli();
80103f45:	e8 86 05 00 00       	call   801044d0 <pushcli>
  c = mycpu();
80103f4a:	e8 a1 f8 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103f4f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f55:	e8 76 06 00 00       	call   801045d0 <popcli>
  acquire(&ptable.lock);
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 20 2d 11 80       	push   $0x80112d20
80103f62:	e8 a9 05 00 00       	call   80104510 <acquire>
80103f67:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f6a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f6c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f71:	eb 13                	jmp    80103f86 <wait+0x46>
80103f73:	90                   	nop
80103f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f78:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80103f7e:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80103f84:	73 1e                	jae    80103fa4 <wait+0x64>
      if(p->parent != curproc)
80103f86:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f89:	75 ed                	jne    80103f78 <wait+0x38>
      if(p->state == ZOMBIE){
80103f8b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f8f:	74 37                	je     80103fc8 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f91:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
      havekids = 1;
80103f97:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f9c:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80103fa2:	72 e2                	jb     80103f86 <wait+0x46>
    if(!havekids || curproc->killed){
80103fa4:	85 c0                	test   %eax,%eax
80103fa6:	74 76                	je     8010401e <wait+0xde>
80103fa8:	8b 46 24             	mov    0x24(%esi),%eax
80103fab:	85 c0                	test   %eax,%eax
80103fad:	75 6f                	jne    8010401e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103faf:	83 ec 08             	sub    $0x8,%esp
80103fb2:	68 20 2d 11 80       	push   $0x80112d20
80103fb7:	56                   	push   %esi
80103fb8:	e8 c3 fe ff ff       	call   80103e80 <sleep>
    havekids = 0;
80103fbd:	83 c4 10             	add    $0x10,%esp
80103fc0:	eb a8                	jmp    80103f6a <wait+0x2a>
80103fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80103fc8:	83 ec 0c             	sub    $0xc,%esp
80103fcb:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103fce:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fd1:	e8 aa e3 ff ff       	call   80102380 <kfree>
        freevm(p->pgdir);
80103fd6:	5a                   	pop    %edx
80103fd7:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103fda:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fe1:	e8 5a 2e 00 00       	call   80106e40 <freevm>
        release(&ptable.lock);
80103fe6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103fed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103ff4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103ffb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fff:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104006:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010400d:	e8 1e 06 00 00       	call   80104630 <release>
        return pid;
80104012:	83 c4 10             	add    $0x10,%esp
}
80104015:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104018:	89 f0                	mov    %esi,%eax
8010401a:	5b                   	pop    %ebx
8010401b:	5e                   	pop    %esi
8010401c:	5d                   	pop    %ebp
8010401d:	c3                   	ret    
      release(&ptable.lock);
8010401e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104021:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104026:	68 20 2d 11 80       	push   $0x80112d20
8010402b:	e8 00 06 00 00       	call   80104630 <release>
      return -1;
80104030:	83 c4 10             	add    $0x10,%esp
80104033:	eb e0                	jmp    80104015 <wait+0xd5>
80104035:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104040 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010404a:	68 20 2d 11 80       	push   $0x80112d20
8010404f:	e8 bc 04 00 00       	call   80104510 <acquire>
80104054:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104057:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010405c:	eb 0e                	jmp    8010406c <wakeup+0x2c>
8010405e:	66 90                	xchg   %ax,%ax
80104060:	05 9c 00 00 00       	add    $0x9c,%eax
80104065:	3d 54 54 11 80       	cmp    $0x80115454,%eax
8010406a:	73 1e                	jae    8010408a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010406c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104070:	75 ee                	jne    80104060 <wakeup+0x20>
80104072:	3b 58 20             	cmp    0x20(%eax),%ebx
80104075:	75 e9                	jne    80104060 <wakeup+0x20>
      p->state = RUNNABLE;
80104077:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407e:	05 9c 00 00 00       	add    $0x9c,%eax
80104083:	3d 54 54 11 80       	cmp    $0x80115454,%eax
80104088:	72 e2                	jb     8010406c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010408a:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104091:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104094:	c9                   	leave  
  release(&ptable.lock);
80104095:	e9 96 05 00 00       	jmp    80104630 <release>
8010409a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	53                   	push   %ebx
801040a4:	83 ec 10             	sub    $0x10,%esp
801040a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801040aa:	68 20 2d 11 80       	push   $0x80112d20
801040af:	e8 5c 04 00 00       	call   80104510 <acquire>
801040b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040bc:	eb 0e                	jmp    801040cc <kill+0x2c>
801040be:	66 90                	xchg   %ax,%ax
801040c0:	05 9c 00 00 00       	add    $0x9c,%eax
801040c5:	3d 54 54 11 80       	cmp    $0x80115454,%eax
801040ca:	73 34                	jae    80104100 <kill+0x60>
    if(p->pid == pid){
801040cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801040cf:	75 ef                	jne    801040c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801040d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801040dc:	75 07                	jne    801040e5 <kill+0x45>
        p->state = RUNNABLE;
801040de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801040e5:	83 ec 0c             	sub    $0xc,%esp
801040e8:	68 20 2d 11 80       	push   $0x80112d20
801040ed:	e8 3e 05 00 00       	call   80104630 <release>
      return 0;
801040f2:	83 c4 10             	add    $0x10,%esp
801040f5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801040f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040fa:	c9                   	leave  
801040fb:	c3                   	ret    
801040fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104100:	83 ec 0c             	sub    $0xc,%esp
80104103:	68 20 2d 11 80       	push   $0x80112d20
80104108:	e8 23 05 00 00       	call   80104630 <release>
  return -1;
8010410d:	83 c4 10             	add    $0x10,%esp
80104110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104118:	c9                   	leave  
80104119:	c3                   	ret    
8010411a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104120 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	57                   	push   %edi
80104124:	56                   	push   %esi
80104125:	53                   	push   %ebx
80104126:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104129:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010412e:	83 ec 3c             	sub    $0x3c,%esp
80104131:	eb 27                	jmp    8010415a <procdump+0x3a>
80104133:	90                   	nop
80104134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	68 03 7c 10 80       	push   $0x80107c03
80104140:	e8 1b c5 ff ff       	call   80100660 <cprintf>
80104145:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104148:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
8010414e:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80104154:	0f 83 86 00 00 00    	jae    801041e0 <procdump+0xc0>
    if(p->state == UNUSED)
8010415a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010415d:	85 c0                	test   %eax,%eax
8010415f:	74 e7                	je     80104148 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104161:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104164:	ba 00 78 10 80       	mov    $0x80107800,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104169:	77 11                	ja     8010417c <procdump+0x5c>
8010416b:	8b 14 85 f0 78 10 80 	mov    -0x7fef8710(,%eax,4),%edx
      state = "???";
80104172:	b8 00 78 10 80       	mov    $0x80107800,%eax
80104177:	85 d2                	test   %edx,%edx
80104179:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010417c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010417f:	50                   	push   %eax
80104180:	52                   	push   %edx
80104181:	ff 73 10             	pushl  0x10(%ebx)
80104184:	68 04 78 10 80       	push   $0x80107804
80104189:	e8 d2 c4 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010418e:	83 c4 10             	add    $0x10,%esp
80104191:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104195:	75 a1                	jne    80104138 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104197:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010419a:	83 ec 08             	sub    $0x8,%esp
8010419d:	8d 7d c0             	lea    -0x40(%ebp),%edi
801041a0:	50                   	push   %eax
801041a1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801041a4:	8b 40 0c             	mov    0xc(%eax),%eax
801041a7:	83 c0 08             	add    $0x8,%eax
801041aa:	50                   	push   %eax
801041ab:	e8 90 02 00 00       	call   80104440 <getcallerpcs>
801041b0:	83 c4 10             	add    $0x10,%esp
801041b3:	90                   	nop
801041b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801041b8:	8b 17                	mov    (%edi),%edx
801041ba:	85 d2                	test   %edx,%edx
801041bc:	0f 84 76 ff ff ff    	je     80104138 <procdump+0x18>
        cprintf(" %p", pc[i]);
801041c2:	83 ec 08             	sub    $0x8,%esp
801041c5:	83 c7 04             	add    $0x4,%edi
801041c8:	52                   	push   %edx
801041c9:	68 a1 71 10 80       	push   $0x801071a1
801041ce:	e8 8d c4 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801041d3:	83 c4 10             	add    $0x10,%esp
801041d6:	39 fe                	cmp    %edi,%esi
801041d8:	75 de                	jne    801041b8 <procdump+0x98>
801041da:	e9 59 ff ff ff       	jmp    80104138 <procdump+0x18>
801041df:	90                   	nop
  }
}
801041e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041e3:	5b                   	pop    %ebx
801041e4:	5e                   	pop    %esi
801041e5:	5f                   	pop    %edi
801041e6:	5d                   	pop    %ebp
801041e7:	c3                   	ret    
801041e8:	90                   	nop
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <cps>:


// current process status
int 
cps()
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
801041f4:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
801041f7:	fb                   	sti    
	struct proc *p;
	// Enable interrupts on this processor
	sti();
	//Loop over process table looking for process with pid.
	acquire(&ptable.lock);
801041f8:	68 20 2d 11 80       	push   $0x80112d20
	cprintf("name\t pid \t state \t \t priority \n");
	for(p = ptable.proc; p < &ptable.proc[NPROC];p++){
801041fd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
	acquire(&ptable.lock);
80104202:	e8 09 03 00 00       	call   80104510 <acquire>
	cprintf("name\t pid \t state \t \t priority \n");
80104207:	c7 04 24 cc 78 10 80 	movl   $0x801078cc,(%esp)
8010420e:	e8 4d c4 ff ff       	call   80100660 <cprintf>
80104213:	83 c4 10             	add    $0x10,%esp
80104216:	eb 20                	jmp    80104238 <cps+0x48>
80104218:	90                   	nop
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		if(p->state == SLEEPING)
			cprintf("%s \t %d \t SLEEPING \t %d\n ", p->name, p->pid, p->priority);
		else if( p->state == RUNNING)
80104220:	83 f8 04             	cmp    $0x4,%eax
80104223:	74 5b                	je     80104280 <cps+0x90>
			cprintf("%s \t %d \t RUNNING \t %d\n ", p->name, p->pid, p->priority);
		else if(p->state == RUNNABLE)
80104225:	83 f8 03             	cmp    $0x3,%eax
80104228:	74 76                	je     801042a0 <cps+0xb0>
	for(p = ptable.proc; p < &ptable.proc[NPROC];p++){
8010422a:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
80104230:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80104236:	73 30                	jae    80104268 <cps+0x78>
		if(p->state == SLEEPING)
80104238:	8b 43 0c             	mov    0xc(%ebx),%eax
8010423b:	83 f8 02             	cmp    $0x2,%eax
8010423e:	75 e0                	jne    80104220 <cps+0x30>
			cprintf("%s \t %d \t SLEEPING \t %d\n ", p->name, p->pid, p->priority);
80104240:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104243:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104249:	ff 73 10             	pushl  0x10(%ebx)
	for(p = ptable.proc; p < &ptable.proc[NPROC];p++){
8010424c:	81 c3 9c 00 00 00    	add    $0x9c,%ebx
			cprintf("%s \t %d \t SLEEPING \t %d\n ", p->name, p->pid, p->priority);
80104252:	50                   	push   %eax
80104253:	68 0d 78 10 80       	push   $0x8010780d
80104258:	e8 03 c4 ff ff       	call   80100660 <cprintf>
8010425d:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC];p++){
80104260:	81 fb 54 54 11 80    	cmp    $0x80115454,%ebx
80104266:	72 d0                	jb     80104238 <cps+0x48>
			cprintf("%s \t %d \t RUNNABLE \t %d\n",p->name, p->pid, p->priority);
	}
	release(&ptable.lock);
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	68 20 2d 11 80       	push   $0x80112d20
80104270:	e8 bb 03 00 00       	call   80104630 <release>
	return 22;
}
80104275:	b8 16 00 00 00       	mov    $0x16,%eax
8010427a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010427d:	c9                   	leave  
8010427e:	c3                   	ret    
8010427f:	90                   	nop
			cprintf("%s \t %d \t RUNNING \t %d\n ", p->name, p->pid, p->priority);
80104280:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104283:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
80104289:	ff 73 10             	pushl  0x10(%ebx)
8010428c:	50                   	push   %eax
8010428d:	68 27 78 10 80       	push   $0x80107827
80104292:	e8 c9 c3 ff ff       	call   80100660 <cprintf>
80104297:	83 c4 10             	add    $0x10,%esp
8010429a:	eb 8e                	jmp    8010422a <cps+0x3a>
8010429c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			cprintf("%s \t %d \t RUNNABLE \t %d\n",p->name, p->pid, p->priority);
801042a0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801042a3:	ff b3 8c 00 00 00    	pushl  0x8c(%ebx)
801042a9:	ff 73 10             	pushl  0x10(%ebx)
801042ac:	50                   	push   %eax
801042ad:	68 40 78 10 80       	push   $0x80107840
801042b2:	e8 a9 c3 ff ff       	call   80100660 <cprintf>
801042b7:	83 c4 10             	add    $0x10,%esp
801042ba:	e9 6b ff ff ff       	jmp    8010422a <cps+0x3a>
801042bf:	90                   	nop

801042c0 <chpr>:


int
chpr( int pid, int priority )
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 10             	sub    $0x10,%esp
801042c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
   struct proc *p;

   acquire(&ptable.lock);
801042ca:	68 20 2d 11 80       	push   $0x80112d20
801042cf:	e8 3c 02 00 00       	call   80104510 <acquire>
801042d4:	83 c4 10             	add    $0x10,%esp
   for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d7:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801042dc:	eb 10                	jmp    801042ee <chpr+0x2e>
801042de:	66 90                	xchg   %ax,%ax
801042e0:	81 c2 9c 00 00 00    	add    $0x9c,%edx
801042e6:	81 fa 54 54 11 80    	cmp    $0x80115454,%edx
801042ec:	73 0e                	jae    801042fc <chpr+0x3c>
    if(p->pid == pid ) {
801042ee:	39 5a 10             	cmp    %ebx,0x10(%edx)
801042f1:	75 ed                	jne    801042e0 <chpr+0x20>
        p->priority = priority;
801042f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801042f6:	89 82 8c 00 00 00    	mov    %eax,0x8c(%edx)
        break;
    }
  }
  release(&ptable.lock);
801042fc:	83 ec 0c             	sub    $0xc,%esp
801042ff:	68 20 2d 11 80       	push   $0x80112d20
80104304:	e8 27 03 00 00       	call   80104630 <release>

  return pid;
}
80104309:	89 d8                	mov    %ebx,%eax
8010430b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010430e:	c9                   	leave  
8010430f:	c3                   	ret    

80104310 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
80104314:	83 ec 0c             	sub    $0xc,%esp
80104317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010431a:	68 08 79 10 80       	push   $0x80107908
8010431f:	8d 43 04             	lea    0x4(%ebx),%eax
80104322:	50                   	push   %eax
80104323:	e8 f8 00 00 00       	call   80104420 <initlock>
  lk->name = name;
80104328:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010432b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104331:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104334:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010433b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010433e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104341:	c9                   	leave  
80104342:	c3                   	ret    
80104343:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104350 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	56                   	push   %esi
80104354:	53                   	push   %ebx
80104355:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104358:	83 ec 0c             	sub    $0xc,%esp
8010435b:	8d 73 04             	lea    0x4(%ebx),%esi
8010435e:	56                   	push   %esi
8010435f:	e8 ac 01 00 00       	call   80104510 <acquire>
  while (lk->locked) {
80104364:	8b 13                	mov    (%ebx),%edx
80104366:	83 c4 10             	add    $0x10,%esp
80104369:	85 d2                	test   %edx,%edx
8010436b:	74 16                	je     80104383 <acquiresleep+0x33>
8010436d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104370:	83 ec 08             	sub    $0x8,%esp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
80104375:	e8 06 fb ff ff       	call   80103e80 <sleep>
  while (lk->locked) {
8010437a:	8b 03                	mov    (%ebx),%eax
8010437c:	83 c4 10             	add    $0x10,%esp
8010437f:	85 c0                	test   %eax,%eax
80104381:	75 ed                	jne    80104370 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104383:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104389:	e8 02 f5 ff ff       	call   80103890 <myproc>
8010438e:	8b 40 10             	mov    0x10(%eax),%eax
80104391:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104394:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104397:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010439a:	5b                   	pop    %ebx
8010439b:	5e                   	pop    %esi
8010439c:	5d                   	pop    %ebp
  release(&lk->lk);
8010439d:	e9 8e 02 00 00       	jmp    80104630 <release>
801043a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	56                   	push   %esi
801043b4:	53                   	push   %ebx
801043b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043b8:	83 ec 0c             	sub    $0xc,%esp
801043bb:	8d 73 04             	lea    0x4(%ebx),%esi
801043be:	56                   	push   %esi
801043bf:	e8 4c 01 00 00       	call   80104510 <acquire>
  lk->locked = 0;
801043c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043d1:	89 1c 24             	mov    %ebx,(%esp)
801043d4:	e8 67 fc ff ff       	call   80104040 <wakeup>
  release(&lk->lk);
801043d9:	89 75 08             	mov    %esi,0x8(%ebp)
801043dc:	83 c4 10             	add    $0x10,%esp
}
801043df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043e2:	5b                   	pop    %ebx
801043e3:	5e                   	pop    %esi
801043e4:	5d                   	pop    %ebp
  release(&lk->lk);
801043e5:	e9 46 02 00 00       	jmp    80104630 <release>
801043ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
801043f5:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
801043f8:	83 ec 0c             	sub    $0xc,%esp
801043fb:	8d 5e 04             	lea    0x4(%esi),%ebx
801043fe:	53                   	push   %ebx
801043ff:	e8 0c 01 00 00       	call   80104510 <acquire>
  r = lk->locked;
80104404:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104406:	89 1c 24             	mov    %ebx,(%esp)
80104409:	e8 22 02 00 00       	call   80104630 <release>
  return r;
}
8010440e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104411:	89 f0                	mov    %esi,%eax
80104413:	5b                   	pop    %ebx
80104414:	5e                   	pop    %esi
80104415:	5d                   	pop    %ebp
80104416:	c3                   	ret    
80104417:	66 90                	xchg   %ax,%ax
80104419:	66 90                	xchg   %ax,%ax
8010441b:	66 90                	xchg   %ax,%ax
8010441d:	66 90                	xchg   %ax,%ax
8010441f:	90                   	nop

80104420 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104426:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010442f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104432:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104439:	5d                   	pop    %ebp
8010443a:	c3                   	ret    
8010443b:	90                   	nop
8010443c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104440 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104440:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104441:	31 d2                	xor    %edx,%edx
{
80104443:	89 e5                	mov    %esp,%ebp
80104445:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104446:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104449:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010444c:	83 e8 08             	sub    $0x8,%eax
8010444f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104450:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104456:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010445c:	77 1a                	ja     80104478 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010445e:	8b 58 04             	mov    0x4(%eax),%ebx
80104461:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104464:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104467:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104469:	83 fa 0a             	cmp    $0xa,%edx
8010446c:	75 e2                	jne    80104450 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010446e:	5b                   	pop    %ebx
8010446f:	5d                   	pop    %ebp
80104470:	c3                   	ret    
80104471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104478:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010447b:	83 c1 28             	add    $0x28,%ecx
8010447e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104486:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104489:	39 c1                	cmp    %eax,%ecx
8010448b:	75 f3                	jne    80104480 <getcallerpcs+0x40>
}
8010448d:	5b                   	pop    %ebx
8010448e:	5d                   	pop    %ebp
8010448f:	c3                   	ret    

80104490 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	53                   	push   %ebx
80104494:	83 ec 04             	sub    $0x4,%esp
80104497:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
8010449a:	8b 02                	mov    (%edx),%eax
8010449c:	85 c0                	test   %eax,%eax
8010449e:	75 10                	jne    801044b0 <holding+0x20>
}
801044a0:	83 c4 04             	add    $0x4,%esp
801044a3:	31 c0                	xor    %eax,%eax
801044a5:	5b                   	pop    %ebx
801044a6:	5d                   	pop    %ebp
801044a7:	c3                   	ret    
801044a8:	90                   	nop
801044a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801044b0:	8b 5a 08             	mov    0x8(%edx),%ebx
801044b3:	e8 38 f3 ff ff       	call   801037f0 <mycpu>
801044b8:	39 c3                	cmp    %eax,%ebx
801044ba:	0f 94 c0             	sete   %al
}
801044bd:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
801044c0:	0f b6 c0             	movzbl %al,%eax
}
801044c3:	5b                   	pop    %ebx
801044c4:	5d                   	pop    %ebp
801044c5:	c3                   	ret    
801044c6:	8d 76 00             	lea    0x0(%esi),%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044d0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	53                   	push   %ebx
801044d4:	83 ec 04             	sub    $0x4,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044d7:	9c                   	pushf  
801044d8:	5b                   	pop    %ebx
  asm volatile("cli");
801044d9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044da:	e8 11 f3 ff ff       	call   801037f0 <mycpu>
801044df:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044e5:	85 c0                	test   %eax,%eax
801044e7:	75 11                	jne    801044fa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801044e9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044ef:	e8 fc f2 ff ff       	call   801037f0 <mycpu>
801044f4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801044fa:	e8 f1 f2 ff ff       	call   801037f0 <mycpu>
801044ff:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104506:	83 c4 04             	add    $0x4,%esp
80104509:	5b                   	pop    %ebx
8010450a:	5d                   	pop    %ebp
8010450b:	c3                   	ret    
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104510 <acquire>:
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104515:	e8 b6 ff ff ff       	call   801044d0 <pushcli>
  if(holding(lk))
8010451a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010451d:	8b 03                	mov    (%ebx),%eax
8010451f:	85 c0                	test   %eax,%eax
80104521:	0f 85 81 00 00 00    	jne    801045a8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104527:	ba 01 00 00 00       	mov    $0x1,%edx
8010452c:	eb 05                	jmp    80104533 <acquire+0x23>
8010452e:	66 90                	xchg   %ax,%ax
80104530:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104533:	89 d0                	mov    %edx,%eax
80104535:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104538:	85 c0                	test   %eax,%eax
8010453a:	75 f4                	jne    80104530 <acquire+0x20>
  __sync_synchronize();
8010453c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104541:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104544:	e8 a7 f2 ff ff       	call   801037f0 <mycpu>
  for(i = 0; i < 10; i++){
80104549:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010454b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010454e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104551:	89 e8                	mov    %ebp,%eax
80104553:	90                   	nop
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104558:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010455e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104564:	77 1a                	ja     80104580 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104566:	8b 58 04             	mov    0x4(%eax),%ebx
80104569:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010456c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010456f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104571:	83 fa 0a             	cmp    $0xa,%edx
80104574:	75 e2                	jne    80104558 <acquire+0x48>
}
80104576:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104579:	5b                   	pop    %ebx
8010457a:	5e                   	pop    %esi
8010457b:	5d                   	pop    %ebp
8010457c:	c3                   	ret    
8010457d:	8d 76 00             	lea    0x0(%esi),%esi
80104580:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104583:	83 c1 28             	add    $0x28,%ecx
80104586:	8d 76 00             	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104596:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104599:	39 c8                	cmp    %ecx,%eax
8010459b:	75 f3                	jne    80104590 <acquire+0x80>
}
8010459d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045a0:	5b                   	pop    %ebx
801045a1:	5e                   	pop    %esi
801045a2:	5d                   	pop    %ebp
801045a3:	c3                   	ret    
801045a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801045a8:	8b 73 08             	mov    0x8(%ebx),%esi
801045ab:	e8 40 f2 ff ff       	call   801037f0 <mycpu>
801045b0:	39 c6                	cmp    %eax,%esi
801045b2:	0f 85 6f ff ff ff    	jne    80104527 <acquire+0x17>
    panic("acquire");
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 13 79 10 80       	push   $0x80107913
801045c0:	e8 cb bd ff ff       	call   80100390 <panic>
801045c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <popcli>:

void
popcli(void)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801045d6:	9c                   	pushf  
801045d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801045d8:	f6 c4 02             	test   $0x2,%ah
801045db:	75 35                	jne    80104612 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801045dd:	e8 0e f2 ff ff       	call   801037f0 <mycpu>
801045e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045e9:	78 34                	js     8010461f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045eb:	e8 00 f2 ff ff       	call   801037f0 <mycpu>
801045f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045f6:	85 d2                	test   %edx,%edx
801045f8:	74 06                	je     80104600 <popcli+0x30>
    sti();
}
801045fa:	c9                   	leave  
801045fb:	c3                   	ret    
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104600:	e8 eb f1 ff ff       	call   801037f0 <mycpu>
80104605:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010460b:	85 c0                	test   %eax,%eax
8010460d:	74 eb                	je     801045fa <popcli+0x2a>
  asm volatile("sti");
8010460f:	fb                   	sti    
}
80104610:	c9                   	leave  
80104611:	c3                   	ret    
    panic("popcli - interruptible");
80104612:	83 ec 0c             	sub    $0xc,%esp
80104615:	68 1b 79 10 80       	push   $0x8010791b
8010461a:	e8 71 bd ff ff       	call   80100390 <panic>
    panic("popcli");
8010461f:	83 ec 0c             	sub    $0xc,%esp
80104622:	68 32 79 10 80       	push   $0x80107932
80104627:	e8 64 bd ff ff       	call   80100390 <panic>
8010462c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104630 <release>:
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104638:	8b 03                	mov    (%ebx),%eax
8010463a:	85 c0                	test   %eax,%eax
8010463c:	74 0c                	je     8010464a <release+0x1a>
8010463e:	8b 73 08             	mov    0x8(%ebx),%esi
80104641:	e8 aa f1 ff ff       	call   801037f0 <mycpu>
80104646:	39 c6                	cmp    %eax,%esi
80104648:	74 16                	je     80104660 <release+0x30>
    panic("release");
8010464a:	83 ec 0c             	sub    $0xc,%esp
8010464d:	68 39 79 10 80       	push   $0x80107939
80104652:	e8 39 bd ff ff       	call   80100390 <panic>
80104657:	89 f6                	mov    %esi,%esi
80104659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104660:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104667:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
8010466e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104673:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104679:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010467c:	5b                   	pop    %ebx
8010467d:	5e                   	pop    %esi
8010467e:	5d                   	pop    %ebp
  popcli();
8010467f:	e9 4c ff ff ff       	jmp    801045d0 <popcli>
80104684:	66 90                	xchg   %ax,%ax
80104686:	66 90                	xchg   %ax,%ax
80104688:	66 90                	xchg   %ax,%ax
8010468a:	66 90                	xchg   %ax,%ax
8010468c:	66 90                	xchg   %ax,%ax
8010468e:	66 90                	xchg   %ax,%ax

80104690 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	53                   	push   %ebx
80104695:	8b 55 08             	mov    0x8(%ebp),%edx
80104698:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010469b:	f6 c2 03             	test   $0x3,%dl
8010469e:	75 05                	jne    801046a5 <memset+0x15>
801046a0:	f6 c1 03             	test   $0x3,%cl
801046a3:	74 13                	je     801046b8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801046a5:	89 d7                	mov    %edx,%edi
801046a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801046aa:	fc                   	cld    
801046ab:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801046ad:	5b                   	pop    %ebx
801046ae:	89 d0                	mov    %edx,%eax
801046b0:	5f                   	pop    %edi
801046b1:	5d                   	pop    %ebp
801046b2:	c3                   	ret    
801046b3:	90                   	nop
801046b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801046b8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046bc:	c1 e9 02             	shr    $0x2,%ecx
801046bf:	89 f8                	mov    %edi,%eax
801046c1:	89 fb                	mov    %edi,%ebx
801046c3:	c1 e0 18             	shl    $0x18,%eax
801046c6:	c1 e3 10             	shl    $0x10,%ebx
801046c9:	09 d8                	or     %ebx,%eax
801046cb:	09 f8                	or     %edi,%eax
801046cd:	c1 e7 08             	shl    $0x8,%edi
801046d0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801046d2:	89 d7                	mov    %edx,%edi
801046d4:	fc                   	cld    
801046d5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801046d7:	5b                   	pop    %ebx
801046d8:	89 d0                	mov    %edx,%eax
801046da:	5f                   	pop    %edi
801046db:	5d                   	pop    %ebp
801046dc:	c3                   	ret    
801046dd:	8d 76 00             	lea    0x0(%esi),%esi

801046e0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	56                   	push   %esi
801046e5:	53                   	push   %ebx
801046e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801046e9:	8b 75 08             	mov    0x8(%ebp),%esi
801046ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801046ef:	85 db                	test   %ebx,%ebx
801046f1:	74 29                	je     8010471c <memcmp+0x3c>
    if(*s1 != *s2)
801046f3:	0f b6 16             	movzbl (%esi),%edx
801046f6:	0f b6 0f             	movzbl (%edi),%ecx
801046f9:	38 d1                	cmp    %dl,%cl
801046fb:	75 2b                	jne    80104728 <memcmp+0x48>
801046fd:	b8 01 00 00 00       	mov    $0x1,%eax
80104702:	eb 14                	jmp    80104718 <memcmp+0x38>
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104708:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010470c:	83 c0 01             	add    $0x1,%eax
8010470f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104714:	38 ca                	cmp    %cl,%dl
80104716:	75 10                	jne    80104728 <memcmp+0x48>
  while(n-- > 0){
80104718:	39 d8                	cmp    %ebx,%eax
8010471a:	75 ec                	jne    80104708 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010471c:	5b                   	pop    %ebx
  return 0;
8010471d:	31 c0                	xor    %eax,%eax
}
8010471f:	5e                   	pop    %esi
80104720:	5f                   	pop    %edi
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    
80104723:	90                   	nop
80104724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104728:	0f b6 c2             	movzbl %dl,%eax
}
8010472b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010472c:	29 c8                	sub    %ecx,%eax
}
8010472e:	5e                   	pop    %esi
8010472f:	5f                   	pop    %edi
80104730:	5d                   	pop    %ebp
80104731:	c3                   	ret    
80104732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104740 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	56                   	push   %esi
80104744:	53                   	push   %ebx
80104745:	8b 45 08             	mov    0x8(%ebp),%eax
80104748:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010474b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010474e:	39 c3                	cmp    %eax,%ebx
80104750:	73 26                	jae    80104778 <memmove+0x38>
80104752:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104755:	39 c8                	cmp    %ecx,%eax
80104757:	73 1f                	jae    80104778 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104759:	85 f6                	test   %esi,%esi
8010475b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010475e:	74 0f                	je     8010476f <memmove+0x2f>
      *--d = *--s;
80104760:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104764:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104767:	83 ea 01             	sub    $0x1,%edx
8010476a:	83 fa ff             	cmp    $0xffffffff,%edx
8010476d:	75 f1                	jne    80104760 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010476f:	5b                   	pop    %ebx
80104770:	5e                   	pop    %esi
80104771:	5d                   	pop    %ebp
80104772:	c3                   	ret    
80104773:	90                   	nop
80104774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104778:	31 d2                	xor    %edx,%edx
8010477a:	85 f6                	test   %esi,%esi
8010477c:	74 f1                	je     8010476f <memmove+0x2f>
8010477e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104780:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104784:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104787:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010478a:	39 d6                	cmp    %edx,%esi
8010478c:	75 f2                	jne    80104780 <memmove+0x40>
}
8010478e:	5b                   	pop    %ebx
8010478f:	5e                   	pop    %esi
80104790:	5d                   	pop    %ebp
80104791:	c3                   	ret    
80104792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047a0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801047a3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801047a4:	eb 9a                	jmp    80104740 <memmove>
801047a6:	8d 76 00             	lea    0x0(%esi),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	57                   	push   %edi
801047b4:	56                   	push   %esi
801047b5:	8b 7d 10             	mov    0x10(%ebp),%edi
801047b8:	53                   	push   %ebx
801047b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801047bf:	85 ff                	test   %edi,%edi
801047c1:	74 2f                	je     801047f2 <strncmp+0x42>
801047c3:	0f b6 01             	movzbl (%ecx),%eax
801047c6:	0f b6 1e             	movzbl (%esi),%ebx
801047c9:	84 c0                	test   %al,%al
801047cb:	74 37                	je     80104804 <strncmp+0x54>
801047cd:	38 c3                	cmp    %al,%bl
801047cf:	75 33                	jne    80104804 <strncmp+0x54>
801047d1:	01 f7                	add    %esi,%edi
801047d3:	eb 13                	jmp    801047e8 <strncmp+0x38>
801047d5:	8d 76 00             	lea    0x0(%esi),%esi
801047d8:	0f b6 01             	movzbl (%ecx),%eax
801047db:	84 c0                	test   %al,%al
801047dd:	74 21                	je     80104800 <strncmp+0x50>
801047df:	0f b6 1a             	movzbl (%edx),%ebx
801047e2:	89 d6                	mov    %edx,%esi
801047e4:	38 d8                	cmp    %bl,%al
801047e6:	75 1c                	jne    80104804 <strncmp+0x54>
    n--, p++, q++;
801047e8:	8d 56 01             	lea    0x1(%esi),%edx
801047eb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801047ee:	39 fa                	cmp    %edi,%edx
801047f0:	75 e6                	jne    801047d8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801047f2:	5b                   	pop    %ebx
    return 0;
801047f3:	31 c0                	xor    %eax,%eax
}
801047f5:	5e                   	pop    %esi
801047f6:	5f                   	pop    %edi
801047f7:	5d                   	pop    %ebp
801047f8:	c3                   	ret    
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104800:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104804:	29 d8                	sub    %ebx,%eax
}
80104806:	5b                   	pop    %ebx
80104807:	5e                   	pop    %esi
80104808:	5f                   	pop    %edi
80104809:	5d                   	pop    %ebp
8010480a:	c3                   	ret    
8010480b:	90                   	nop
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104810 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
80104815:	8b 45 08             	mov    0x8(%ebp),%eax
80104818:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010481b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010481e:	89 c2                	mov    %eax,%edx
80104820:	eb 19                	jmp    8010483b <strncpy+0x2b>
80104822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104828:	83 c3 01             	add    $0x1,%ebx
8010482b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010482f:	83 c2 01             	add    $0x1,%edx
80104832:	84 c9                	test   %cl,%cl
80104834:	88 4a ff             	mov    %cl,-0x1(%edx)
80104837:	74 09                	je     80104842 <strncpy+0x32>
80104839:	89 f1                	mov    %esi,%ecx
8010483b:	85 c9                	test   %ecx,%ecx
8010483d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104840:	7f e6                	jg     80104828 <strncpy+0x18>
    ;
  while(n-- > 0)
80104842:	31 c9                	xor    %ecx,%ecx
80104844:	85 f6                	test   %esi,%esi
80104846:	7e 17                	jle    8010485f <strncpy+0x4f>
80104848:	90                   	nop
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104850:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104854:	89 f3                	mov    %esi,%ebx
80104856:	83 c1 01             	add    $0x1,%ecx
80104859:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010485b:	85 db                	test   %ebx,%ebx
8010485d:	7f f1                	jg     80104850 <strncpy+0x40>
  return os;
}
8010485f:	5b                   	pop    %ebx
80104860:	5e                   	pop    %esi
80104861:	5d                   	pop    %ebp
80104862:	c3                   	ret    
80104863:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104878:	8b 45 08             	mov    0x8(%ebp),%eax
8010487b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010487e:	85 c9                	test   %ecx,%ecx
80104880:	7e 26                	jle    801048a8 <safestrcpy+0x38>
80104882:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104886:	89 c1                	mov    %eax,%ecx
80104888:	eb 17                	jmp    801048a1 <safestrcpy+0x31>
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104890:	83 c2 01             	add    $0x1,%edx
80104893:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104897:	83 c1 01             	add    $0x1,%ecx
8010489a:	84 db                	test   %bl,%bl
8010489c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010489f:	74 04                	je     801048a5 <safestrcpy+0x35>
801048a1:	39 f2                	cmp    %esi,%edx
801048a3:	75 eb                	jne    80104890 <safestrcpy+0x20>
    ;
  *s = 0;
801048a5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801048a8:	5b                   	pop    %ebx
801048a9:	5e                   	pop    %esi
801048aa:	5d                   	pop    %ebp
801048ab:	c3                   	ret    
801048ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048b0 <strlen>:

int
strlen(const char *s)
{
801048b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048b1:	31 c0                	xor    %eax,%eax
{
801048b3:	89 e5                	mov    %esp,%ebp
801048b5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048b8:	80 3a 00             	cmpb   $0x0,(%edx)
801048bb:	74 0c                	je     801048c9 <strlen+0x19>
801048bd:	8d 76 00             	lea    0x0(%esi),%esi
801048c0:	83 c0 01             	add    $0x1,%eax
801048c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048c7:	75 f7                	jne    801048c0 <strlen+0x10>
    ;
  return n;
}
801048c9:	5d                   	pop    %ebp
801048ca:	c3                   	ret    

801048cb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801048d3:	55                   	push   %ebp
  pushl %ebx
801048d4:	53                   	push   %ebx
  pushl %esi
801048d5:	56                   	push   %esi
  pushl %edi
801048d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801048d9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801048db:	5f                   	pop    %edi
  popl %esi
801048dc:	5e                   	pop    %esi
  popl %ebx
801048dd:	5b                   	pop    %ebx
  popl %ebp
801048de:	5d                   	pop    %ebp
  ret
801048df:	c3                   	ret    

801048e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 04             	sub    $0x4,%esp
801048e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801048ea:	e8 a1 ef ff ff       	call   80103890 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ef:	8b 00                	mov    (%eax),%eax
801048f1:	39 d8                	cmp    %ebx,%eax
801048f3:	76 1b                	jbe    80104910 <fetchint+0x30>
801048f5:	8d 53 04             	lea    0x4(%ebx),%edx
801048f8:	39 d0                	cmp    %edx,%eax
801048fa:	72 14                	jb     80104910 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801048fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ff:	8b 13                	mov    (%ebx),%edx
80104901:	89 10                	mov    %edx,(%eax)
  return 0;
80104903:	31 c0                	xor    %eax,%eax
}
80104905:	83 c4 04             	add    $0x4,%esp
80104908:	5b                   	pop    %ebx
80104909:	5d                   	pop    %ebp
8010490a:	c3                   	ret    
8010490b:	90                   	nop
8010490c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104915:	eb ee                	jmp    80104905 <fetchint+0x25>
80104917:	89 f6                	mov    %esi,%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	53                   	push   %ebx
80104924:	83 ec 04             	sub    $0x4,%esp
80104927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010492a:	e8 61 ef ff ff       	call   80103890 <myproc>

  if(addr >= curproc->sz)
8010492f:	39 18                	cmp    %ebx,(%eax)
80104931:	76 29                	jbe    8010495c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104936:	89 da                	mov    %ebx,%edx
80104938:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010493a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010493c:	39 c3                	cmp    %eax,%ebx
8010493e:	73 1c                	jae    8010495c <fetchstr+0x3c>
    if(*s == 0)
80104940:	80 3b 00             	cmpb   $0x0,(%ebx)
80104943:	75 10                	jne    80104955 <fetchstr+0x35>
80104945:	eb 39                	jmp    80104980 <fetchstr+0x60>
80104947:	89 f6                	mov    %esi,%esi
80104949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104950:	80 3a 00             	cmpb   $0x0,(%edx)
80104953:	74 1b                	je     80104970 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104955:	83 c2 01             	add    $0x1,%edx
80104958:	39 d0                	cmp    %edx,%eax
8010495a:	77 f4                	ja     80104950 <fetchstr+0x30>
    return -1;
8010495c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104961:	83 c4 04             	add    $0x4,%esp
80104964:	5b                   	pop    %ebx
80104965:	5d                   	pop    %ebp
80104966:	c3                   	ret    
80104967:	89 f6                	mov    %esi,%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104970:	83 c4 04             	add    $0x4,%esp
80104973:	89 d0                	mov    %edx,%eax
80104975:	29 d8                	sub    %ebx,%eax
80104977:	5b                   	pop    %ebx
80104978:	5d                   	pop    %ebp
80104979:	c3                   	ret    
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104980:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104982:	eb dd                	jmp    80104961 <fetchstr+0x41>
80104984:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010498a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104990 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104995:	e8 f6 ee ff ff       	call   80103890 <myproc>
8010499a:	8b 40 18             	mov    0x18(%eax),%eax
8010499d:	8b 55 08             	mov    0x8(%ebp),%edx
801049a0:	8b 40 44             	mov    0x44(%eax),%eax
801049a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049a6:	e8 e5 ee ff ff       	call   80103890 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049ab:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049ad:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049b0:	39 c6                	cmp    %eax,%esi
801049b2:	73 1c                	jae    801049d0 <argint+0x40>
801049b4:	8d 53 08             	lea    0x8(%ebx),%edx
801049b7:	39 d0                	cmp    %edx,%eax
801049b9:	72 15                	jb     801049d0 <argint+0x40>
  *ip = *(int*)(addr);
801049bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801049be:	8b 53 04             	mov    0x4(%ebx),%edx
801049c1:	89 10                	mov    %edx,(%eax)
  return 0;
801049c3:	31 c0                	xor    %eax,%eax
}
801049c5:	5b                   	pop    %ebx
801049c6:	5e                   	pop    %esi
801049c7:	5d                   	pop    %ebp
801049c8:	c3                   	ret    
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801049d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049d5:	eb ee                	jmp    801049c5 <argint+0x35>
801049d7:	89 f6                	mov    %esi,%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	83 ec 10             	sub    $0x10,%esp
801049e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801049eb:	e8 a0 ee ff ff       	call   80103890 <myproc>
801049f0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801049f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049f5:	83 ec 08             	sub    $0x8,%esp
801049f8:	50                   	push   %eax
801049f9:	ff 75 08             	pushl  0x8(%ebp)
801049fc:	e8 8f ff ff ff       	call   80104990 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a01:	83 c4 10             	add    $0x10,%esp
80104a04:	85 c0                	test   %eax,%eax
80104a06:	78 28                	js     80104a30 <argptr+0x50>
80104a08:	85 db                	test   %ebx,%ebx
80104a0a:	78 24                	js     80104a30 <argptr+0x50>
80104a0c:	8b 16                	mov    (%esi),%edx
80104a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a11:	39 c2                	cmp    %eax,%edx
80104a13:	76 1b                	jbe    80104a30 <argptr+0x50>
80104a15:	01 c3                	add    %eax,%ebx
80104a17:	39 da                	cmp    %ebx,%edx
80104a19:	72 15                	jb     80104a30 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a1e:	89 02                	mov    %eax,(%edx)
  return 0;
80104a20:	31 c0                	xor    %eax,%eax
}
80104a22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a25:	5b                   	pop    %ebx
80104a26:	5e                   	pop    %esi
80104a27:	5d                   	pop    %ebp
80104a28:	c3                   	ret    
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a35:	eb eb                	jmp    80104a22 <argptr+0x42>
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a49:	50                   	push   %eax
80104a4a:	ff 75 08             	pushl  0x8(%ebp)
80104a4d:	e8 3e ff ff ff       	call   80104990 <argint>
80104a52:	83 c4 10             	add    $0x10,%esp
80104a55:	85 c0                	test   %eax,%eax
80104a57:	78 17                	js     80104a70 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a59:	83 ec 08             	sub    $0x8,%esp
80104a5c:	ff 75 0c             	pushl  0xc(%ebp)
80104a5f:	ff 75 f4             	pushl  -0xc(%ebp)
80104a62:	e8 b9 fe ff ff       	call   80104920 <fetchstr>
80104a67:	83 c4 10             	add    $0x10,%esp
}
80104a6a:	c9                   	leave  
80104a6b:	c3                   	ret    
80104a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a75:	c9                   	leave  
80104a76:	c3                   	ret    
80104a77:	89 f6                	mov    %esi,%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <syscall>:
[SYS_pfs]     sys_pfs,
};

void
syscall(void)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104a87:	e8 04 ee ff ff       	call   80103890 <myproc>
80104a8c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104a8e:	8b 40 18             	mov    0x18(%eax),%eax
80104a91:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104a94:	8d 50 ff             	lea    -0x1(%eax),%edx
80104a97:	83 fa 17             	cmp    $0x17,%edx
80104a9a:	77 1c                	ja     80104ab8 <syscall+0x38>
80104a9c:	8b 14 85 60 79 10 80 	mov    -0x7fef86a0(,%eax,4),%edx
80104aa3:	85 d2                	test   %edx,%edx
80104aa5:	74 11                	je     80104ab8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104aa7:	ff d2                	call   *%edx
80104aa9:	8b 53 18             	mov    0x18(%ebx),%edx
80104aac:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104aaf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ab2:	c9                   	leave  
80104ab3:	c3                   	ret    
80104ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ab8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ab9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104abc:	50                   	push   %eax
80104abd:	ff 73 10             	pushl  0x10(%ebx)
80104ac0:	68 41 79 10 80       	push   $0x80107941
80104ac5:	e8 96 bb ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104aca:	8b 43 18             	mov    0x18(%ebx),%eax
80104acd:	83 c4 10             	add    $0x10,%esp
80104ad0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ad7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ada:	c9                   	leave  
80104adb:	c3                   	ret    
80104adc:	66 90                	xchg   %ax,%ax
80104ade:	66 90                	xchg   %ax,%ax

80104ae0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ae6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104ae9:	83 ec 44             	sub    $0x44,%esp
80104aec:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104aef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104af2:	56                   	push   %esi
80104af3:	50                   	push   %eax
{
80104af4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104af7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104afa:	e8 11 d4 ff ff       	call   80101f10 <nameiparent>
80104aff:	83 c4 10             	add    $0x10,%esp
80104b02:	85 c0                	test   %eax,%eax
80104b04:	0f 84 46 01 00 00    	je     80104c50 <create+0x170>
    return 0;
  ilock(dp);
80104b0a:	83 ec 0c             	sub    $0xc,%esp
80104b0d:	89 c3                	mov    %eax,%ebx
80104b0f:	50                   	push   %eax
80104b10:	e8 7b cb ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104b15:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b18:	83 c4 0c             	add    $0xc,%esp
80104b1b:	50                   	push   %eax
80104b1c:	56                   	push   %esi
80104b1d:	53                   	push   %ebx
80104b1e:	e8 9d d0 ff ff       	call   80101bc0 <dirlookup>
80104b23:	83 c4 10             	add    $0x10,%esp
80104b26:	85 c0                	test   %eax,%eax
80104b28:	89 c7                	mov    %eax,%edi
80104b2a:	74 34                	je     80104b60 <create+0x80>
    iunlockput(dp);
80104b2c:	83 ec 0c             	sub    $0xc,%esp
80104b2f:	53                   	push   %ebx
80104b30:	e8 eb cd ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104b35:	89 3c 24             	mov    %edi,(%esp)
80104b38:	e8 53 cb ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b3d:	83 c4 10             	add    $0x10,%esp
80104b40:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104b45:	0f 85 95 00 00 00    	jne    80104be0 <create+0x100>
80104b4b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104b50:	0f 85 8a 00 00 00    	jne    80104be0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b59:	89 f8                	mov    %edi,%eax
80104b5b:	5b                   	pop    %ebx
80104b5c:	5e                   	pop    %esi
80104b5d:	5f                   	pop    %edi
80104b5e:	5d                   	pop    %ebp
80104b5f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104b60:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104b64:	83 ec 08             	sub    $0x8,%esp
80104b67:	50                   	push   %eax
80104b68:	ff 33                	pushl  (%ebx)
80104b6a:	e8 b1 c9 ff ff       	call   80101520 <ialloc>
80104b6f:	83 c4 10             	add    $0x10,%esp
80104b72:	85 c0                	test   %eax,%eax
80104b74:	89 c7                	mov    %eax,%edi
80104b76:	0f 84 e8 00 00 00    	je     80104c64 <create+0x184>
  ilock(ip);
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	50                   	push   %eax
80104b80:	e8 0b cb ff ff       	call   80101690 <ilock>
  ip->major = major;
80104b85:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104b89:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104b8d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104b91:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104b95:	b8 01 00 00 00       	mov    $0x1,%eax
80104b9a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104b9e:	89 3c 24             	mov    %edi,(%esp)
80104ba1:	e8 3a ca ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ba6:	83 c4 10             	add    $0x10,%esp
80104ba9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104bae:	74 50                	je     80104c00 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104bb0:	83 ec 04             	sub    $0x4,%esp
80104bb3:	ff 77 04             	pushl  0x4(%edi)
80104bb6:	56                   	push   %esi
80104bb7:	53                   	push   %ebx
80104bb8:	e8 73 d2 ff ff       	call   80101e30 <dirlink>
80104bbd:	83 c4 10             	add    $0x10,%esp
80104bc0:	85 c0                	test   %eax,%eax
80104bc2:	0f 88 8f 00 00 00    	js     80104c57 <create+0x177>
  iunlockput(dp);
80104bc8:	83 ec 0c             	sub    $0xc,%esp
80104bcb:	53                   	push   %ebx
80104bcc:	e8 4f cd ff ff       	call   80101920 <iunlockput>
  return ip;
80104bd1:	83 c4 10             	add    $0x10,%esp
}
80104bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bd7:	89 f8                	mov    %edi,%eax
80104bd9:	5b                   	pop    %ebx
80104bda:	5e                   	pop    %esi
80104bdb:	5f                   	pop    %edi
80104bdc:	5d                   	pop    %ebp
80104bdd:	c3                   	ret    
80104bde:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104be0:	83 ec 0c             	sub    $0xc,%esp
80104be3:	57                   	push   %edi
    return 0;
80104be4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104be6:	e8 35 cd ff ff       	call   80101920 <iunlockput>
    return 0;
80104beb:	83 c4 10             	add    $0x10,%esp
}
80104bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bf1:	89 f8                	mov    %edi,%eax
80104bf3:	5b                   	pop    %ebx
80104bf4:	5e                   	pop    %esi
80104bf5:	5f                   	pop    %edi
80104bf6:	5d                   	pop    %ebp
80104bf7:	c3                   	ret    
80104bf8:	90                   	nop
80104bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104c00:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c05:	83 ec 0c             	sub    $0xc,%esp
80104c08:	53                   	push   %ebx
80104c09:	e8 d2 c9 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c0e:	83 c4 0c             	add    $0xc,%esp
80104c11:	ff 77 04             	pushl  0x4(%edi)
80104c14:	68 e0 79 10 80       	push   $0x801079e0
80104c19:	57                   	push   %edi
80104c1a:	e8 11 d2 ff ff       	call   80101e30 <dirlink>
80104c1f:	83 c4 10             	add    $0x10,%esp
80104c22:	85 c0                	test   %eax,%eax
80104c24:	78 1c                	js     80104c42 <create+0x162>
80104c26:	83 ec 04             	sub    $0x4,%esp
80104c29:	ff 73 04             	pushl  0x4(%ebx)
80104c2c:	68 df 79 10 80       	push   $0x801079df
80104c31:	57                   	push   %edi
80104c32:	e8 f9 d1 ff ff       	call   80101e30 <dirlink>
80104c37:	83 c4 10             	add    $0x10,%esp
80104c3a:	85 c0                	test   %eax,%eax
80104c3c:	0f 89 6e ff ff ff    	jns    80104bb0 <create+0xd0>
      panic("create dots");
80104c42:	83 ec 0c             	sub    $0xc,%esp
80104c45:	68 d3 79 10 80       	push   $0x801079d3
80104c4a:	e8 41 b7 ff ff       	call   80100390 <panic>
80104c4f:	90                   	nop
    return 0;
80104c50:	31 ff                	xor    %edi,%edi
80104c52:	e9 ff fe ff ff       	jmp    80104b56 <create+0x76>
    panic("create: dirlink");
80104c57:	83 ec 0c             	sub    $0xc,%esp
80104c5a:	68 e2 79 10 80       	push   $0x801079e2
80104c5f:	e8 2c b7 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104c64:	83 ec 0c             	sub    $0xc,%esp
80104c67:	68 c4 79 10 80       	push   $0x801079c4
80104c6c:	e8 1f b7 ff ff       	call   80100390 <panic>
80104c71:	eb 0d                	jmp    80104c80 <argfd.constprop.0>
80104c73:	90                   	nop
80104c74:	90                   	nop
80104c75:	90                   	nop
80104c76:	90                   	nop
80104c77:	90                   	nop
80104c78:	90                   	nop
80104c79:	90                   	nop
80104c7a:	90                   	nop
80104c7b:	90                   	nop
80104c7c:	90                   	nop
80104c7d:	90                   	nop
80104c7e:	90                   	nop
80104c7f:	90                   	nop

80104c80 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
80104c85:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104c87:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104c8a:	89 d6                	mov    %edx,%esi
80104c8c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104c8f:	50                   	push   %eax
80104c90:	6a 00                	push   $0x0
80104c92:	e8 f9 fc ff ff       	call   80104990 <argint>
80104c97:	83 c4 10             	add    $0x10,%esp
80104c9a:	85 c0                	test   %eax,%eax
80104c9c:	78 2a                	js     80104cc8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104c9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ca2:	77 24                	ja     80104cc8 <argfd.constprop.0+0x48>
80104ca4:	e8 e7 eb ff ff       	call   80103890 <myproc>
80104ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	74 14                	je     80104cc8 <argfd.constprop.0+0x48>
  if(pfd)
80104cb4:	85 db                	test   %ebx,%ebx
80104cb6:	74 02                	je     80104cba <argfd.constprop.0+0x3a>
    *pfd = fd;
80104cb8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104cba:	89 06                	mov    %eax,(%esi)
  return 0;
80104cbc:	31 c0                	xor    %eax,%eax
}
80104cbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc1:	5b                   	pop    %ebx
80104cc2:	5e                   	pop    %esi
80104cc3:	5d                   	pop    %ebp
80104cc4:	c3                   	ret    
80104cc5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104cc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ccd:	eb ef                	jmp    80104cbe <argfd.constprop.0+0x3e>
80104ccf:	90                   	nop

80104cd0 <sys_dup>:
{
80104cd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104cd1:	31 c0                	xor    %eax,%eax
{
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	56                   	push   %esi
80104cd6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104cd7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104cda:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104cdd:	e8 9e ff ff ff       	call   80104c80 <argfd.constprop.0>
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	78 42                	js     80104d28 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104ce6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ce9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104ceb:	e8 a0 eb ff ff       	call   80103890 <myproc>
80104cf0:	eb 0e                	jmp    80104d00 <sys_dup+0x30>
80104cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104cf8:	83 c3 01             	add    $0x1,%ebx
80104cfb:	83 fb 10             	cmp    $0x10,%ebx
80104cfe:	74 28                	je     80104d28 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104d00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d04:	85 d2                	test   %edx,%edx
80104d06:	75 f0                	jne    80104cf8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104d08:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d0c:	83 ec 0c             	sub    $0xc,%esp
80104d0f:	ff 75 f4             	pushl  -0xc(%ebp)
80104d12:	e8 d9 c0 ff ff       	call   80100df0 <filedup>
  return fd;
80104d17:	83 c4 10             	add    $0x10,%esp
}
80104d1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d1d:	89 d8                	mov    %ebx,%eax
80104d1f:	5b                   	pop    %ebx
80104d20:	5e                   	pop    %esi
80104d21:	5d                   	pop    %ebp
80104d22:	c3                   	ret    
80104d23:	90                   	nop
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d28:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d2b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d30:	89 d8                	mov    %ebx,%eax
80104d32:	5b                   	pop    %ebx
80104d33:	5e                   	pop    %esi
80104d34:	5d                   	pop    %ebp
80104d35:	c3                   	ret    
80104d36:	8d 76 00             	lea    0x0(%esi),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <sys_read>:
{
80104d40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d41:	31 c0                	xor    %eax,%eax
{
80104d43:	89 e5                	mov    %esp,%ebp
80104d45:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d4b:	e8 30 ff ff ff       	call   80104c80 <argfd.constprop.0>
80104d50:	85 c0                	test   %eax,%eax
80104d52:	78 4c                	js     80104da0 <sys_read+0x60>
80104d54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d57:	83 ec 08             	sub    $0x8,%esp
80104d5a:	50                   	push   %eax
80104d5b:	6a 02                	push   $0x2
80104d5d:	e8 2e fc ff ff       	call   80104990 <argint>
80104d62:	83 c4 10             	add    $0x10,%esp
80104d65:	85 c0                	test   %eax,%eax
80104d67:	78 37                	js     80104da0 <sys_read+0x60>
80104d69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d6c:	83 ec 04             	sub    $0x4,%esp
80104d6f:	ff 75 f0             	pushl  -0x10(%ebp)
80104d72:	50                   	push   %eax
80104d73:	6a 01                	push   $0x1
80104d75:	e8 66 fc ff ff       	call   801049e0 <argptr>
80104d7a:	83 c4 10             	add    $0x10,%esp
80104d7d:	85 c0                	test   %eax,%eax
80104d7f:	78 1f                	js     80104da0 <sys_read+0x60>
  return fileread(f, p, n);
80104d81:	83 ec 04             	sub    $0x4,%esp
80104d84:	ff 75 f0             	pushl  -0x10(%ebp)
80104d87:	ff 75 f4             	pushl  -0xc(%ebp)
80104d8a:	ff 75 ec             	pushl  -0x14(%ebp)
80104d8d:	e8 ce c1 ff ff       	call   80100f60 <fileread>
80104d92:	83 c4 10             	add    $0x10,%esp
}
80104d95:	c9                   	leave  
80104d96:	c3                   	ret    
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104da5:	c9                   	leave  
80104da6:	c3                   	ret    
80104da7:	89 f6                	mov    %esi,%esi
80104da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104db0 <sys_write>:
{
80104db0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104db1:	31 c0                	xor    %eax,%eax
{
80104db3:	89 e5                	mov    %esp,%ebp
80104db5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104db8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104dbb:	e8 c0 fe ff ff       	call   80104c80 <argfd.constprop.0>
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	78 4c                	js     80104e10 <sys_write+0x60>
80104dc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dc7:	83 ec 08             	sub    $0x8,%esp
80104dca:	50                   	push   %eax
80104dcb:	6a 02                	push   $0x2
80104dcd:	e8 be fb ff ff       	call   80104990 <argint>
80104dd2:	83 c4 10             	add    $0x10,%esp
80104dd5:	85 c0                	test   %eax,%eax
80104dd7:	78 37                	js     80104e10 <sys_write+0x60>
80104dd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ddc:	83 ec 04             	sub    $0x4,%esp
80104ddf:	ff 75 f0             	pushl  -0x10(%ebp)
80104de2:	50                   	push   %eax
80104de3:	6a 01                	push   $0x1
80104de5:	e8 f6 fb ff ff       	call   801049e0 <argptr>
80104dea:	83 c4 10             	add    $0x10,%esp
80104ded:	85 c0                	test   %eax,%eax
80104def:	78 1f                	js     80104e10 <sys_write+0x60>
  return filewrite(f, p, n);
80104df1:	83 ec 04             	sub    $0x4,%esp
80104df4:	ff 75 f0             	pushl  -0x10(%ebp)
80104df7:	ff 75 f4             	pushl  -0xc(%ebp)
80104dfa:	ff 75 ec             	pushl  -0x14(%ebp)
80104dfd:	e8 ee c1 ff ff       	call   80100ff0 <filewrite>
80104e02:	83 c4 10             	add    $0x10,%esp
}
80104e05:	c9                   	leave  
80104e06:	c3                   	ret    
80104e07:	89 f6                	mov    %esi,%esi
80104e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e15:	c9                   	leave  
80104e16:	c3                   	ret    
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <sys_close>:
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e26:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e2c:	e8 4f fe ff ff       	call   80104c80 <argfd.constprop.0>
80104e31:	85 c0                	test   %eax,%eax
80104e33:	78 2b                	js     80104e60 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e35:	e8 56 ea ff ff       	call   80103890 <myproc>
80104e3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e3d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e40:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e47:	00 
  fileclose(f);
80104e48:	ff 75 f4             	pushl  -0xc(%ebp)
80104e4b:	e8 f0 bf ff ff       	call   80100e40 <fileclose>
  return 0;
80104e50:	83 c4 10             	add    $0x10,%esp
80104e53:	31 c0                	xor    %eax,%eax
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e65:	c9                   	leave  
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e70 <sys_fstat>:
{
80104e70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e71:	31 c0                	xor    %eax,%eax
{
80104e73:	89 e5                	mov    %esp,%ebp
80104e75:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104e78:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104e7b:	e8 00 fe ff ff       	call   80104c80 <argfd.constprop.0>
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 2c                	js     80104eb0 <sys_fstat+0x40>
80104e84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e87:	83 ec 04             	sub    $0x4,%esp
80104e8a:	6a 14                	push   $0x14
80104e8c:	50                   	push   %eax
80104e8d:	6a 01                	push   $0x1
80104e8f:	e8 4c fb ff ff       	call   801049e0 <argptr>
80104e94:	83 c4 10             	add    $0x10,%esp
80104e97:	85 c0                	test   %eax,%eax
80104e99:	78 15                	js     80104eb0 <sys_fstat+0x40>
  return filestat(f, st);
80104e9b:	83 ec 08             	sub    $0x8,%esp
80104e9e:	ff 75 f4             	pushl  -0xc(%ebp)
80104ea1:	ff 75 f0             	pushl  -0x10(%ebp)
80104ea4:	e8 67 c0 ff ff       	call   80100f10 <filestat>
80104ea9:	83 c4 10             	add    $0x10,%esp
}
80104eac:	c9                   	leave  
80104ead:	c3                   	ret    
80104eae:	66 90                	xchg   %ax,%ax
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <sys_link>:
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ec6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104ec9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ecc:	50                   	push   %eax
80104ecd:	6a 00                	push   $0x0
80104ecf:	e8 6c fb ff ff       	call   80104a40 <argstr>
80104ed4:	83 c4 10             	add    $0x10,%esp
80104ed7:	85 c0                	test   %eax,%eax
80104ed9:	0f 88 fb 00 00 00    	js     80104fda <sys_link+0x11a>
80104edf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ee2:	83 ec 08             	sub    $0x8,%esp
80104ee5:	50                   	push   %eax
80104ee6:	6a 01                	push   $0x1
80104ee8:	e8 53 fb ff ff       	call   80104a40 <argstr>
80104eed:	83 c4 10             	add    $0x10,%esp
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	0f 88 e2 00 00 00    	js     80104fda <sys_link+0x11a>
  begin_op();
80104ef8:	e8 13 dd ff ff       	call   80102c10 <begin_op>
  if((ip = namei(old)) == 0){
80104efd:	83 ec 0c             	sub    $0xc,%esp
80104f00:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f03:	e8 e8 cf ff ff       	call   80101ef0 <namei>
80104f08:	83 c4 10             	add    $0x10,%esp
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	89 c3                	mov    %eax,%ebx
80104f0f:	0f 84 ea 00 00 00    	je     80104fff <sys_link+0x13f>
  ilock(ip);
80104f15:	83 ec 0c             	sub    $0xc,%esp
80104f18:	50                   	push   %eax
80104f19:	e8 72 c7 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
80104f1e:	83 c4 10             	add    $0x10,%esp
80104f21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f26:	0f 84 bb 00 00 00    	je     80104fe7 <sys_link+0x127>
  ip->nlink++;
80104f2c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f31:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104f34:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f37:	53                   	push   %ebx
80104f38:	e8 a3 c6 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104f3d:	89 1c 24             	mov    %ebx,(%esp)
80104f40:	e8 2b c8 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f45:	58                   	pop    %eax
80104f46:	5a                   	pop    %edx
80104f47:	57                   	push   %edi
80104f48:	ff 75 d0             	pushl  -0x30(%ebp)
80104f4b:	e8 c0 cf ff ff       	call   80101f10 <nameiparent>
80104f50:	83 c4 10             	add    $0x10,%esp
80104f53:	85 c0                	test   %eax,%eax
80104f55:	89 c6                	mov    %eax,%esi
80104f57:	74 5b                	je     80104fb4 <sys_link+0xf4>
  ilock(dp);
80104f59:	83 ec 0c             	sub    $0xc,%esp
80104f5c:	50                   	push   %eax
80104f5d:	e8 2e c7 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f62:	83 c4 10             	add    $0x10,%esp
80104f65:	8b 03                	mov    (%ebx),%eax
80104f67:	39 06                	cmp    %eax,(%esi)
80104f69:	75 3d                	jne    80104fa8 <sys_link+0xe8>
80104f6b:	83 ec 04             	sub    $0x4,%esp
80104f6e:	ff 73 04             	pushl  0x4(%ebx)
80104f71:	57                   	push   %edi
80104f72:	56                   	push   %esi
80104f73:	e8 b8 ce ff ff       	call   80101e30 <dirlink>
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	85 c0                	test   %eax,%eax
80104f7d:	78 29                	js     80104fa8 <sys_link+0xe8>
  iunlockput(dp);
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	56                   	push   %esi
80104f83:	e8 98 c9 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104f88:	89 1c 24             	mov    %ebx,(%esp)
80104f8b:	e8 30 c8 ff ff       	call   801017c0 <iput>
  end_op();
80104f90:	e8 eb dc ff ff       	call   80102c80 <end_op>
  return 0;
80104f95:	83 c4 10             	add    $0x10,%esp
80104f98:	31 c0                	xor    %eax,%eax
}
80104f9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f9d:	5b                   	pop    %ebx
80104f9e:	5e                   	pop    %esi
80104f9f:	5f                   	pop    %edi
80104fa0:	5d                   	pop    %ebp
80104fa1:	c3                   	ret    
80104fa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	56                   	push   %esi
80104fac:	e8 6f c9 ff ff       	call   80101920 <iunlockput>
    goto bad;
80104fb1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fb4:	83 ec 0c             	sub    $0xc,%esp
80104fb7:	53                   	push   %ebx
80104fb8:	e8 d3 c6 ff ff       	call   80101690 <ilock>
  ip->nlink--;
80104fbd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fc2:	89 1c 24             	mov    %ebx,(%esp)
80104fc5:	e8 16 c6 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104fca:	89 1c 24             	mov    %ebx,(%esp)
80104fcd:	e8 4e c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104fd2:	e8 a9 dc ff ff       	call   80102c80 <end_op>
  return -1;
80104fd7:	83 c4 10             	add    $0x10,%esp
}
80104fda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104fdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fe2:	5b                   	pop    %ebx
80104fe3:	5e                   	pop    %esi
80104fe4:	5f                   	pop    %edi
80104fe5:	5d                   	pop    %ebp
80104fe6:	c3                   	ret    
    iunlockput(ip);
80104fe7:	83 ec 0c             	sub    $0xc,%esp
80104fea:	53                   	push   %ebx
80104feb:	e8 30 c9 ff ff       	call   80101920 <iunlockput>
    end_op();
80104ff0:	e8 8b dc ff ff       	call   80102c80 <end_op>
    return -1;
80104ff5:	83 c4 10             	add    $0x10,%esp
80104ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffd:	eb 9b                	jmp    80104f9a <sys_link+0xda>
    end_op();
80104fff:	e8 7c dc ff ff       	call   80102c80 <end_op>
    return -1;
80105004:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105009:	eb 8f                	jmp    80104f9a <sys_link+0xda>
8010500b:	90                   	nop
8010500c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105010 <sys_unlink>:
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
80105015:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80105016:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105019:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010501c:	50                   	push   %eax
8010501d:	6a 00                	push   $0x0
8010501f:	e8 1c fa ff ff       	call   80104a40 <argstr>
80105024:	83 c4 10             	add    $0x10,%esp
80105027:	85 c0                	test   %eax,%eax
80105029:	0f 88 77 01 00 00    	js     801051a6 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010502f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105032:	e8 d9 db ff ff       	call   80102c10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105037:	83 ec 08             	sub    $0x8,%esp
8010503a:	53                   	push   %ebx
8010503b:	ff 75 c0             	pushl  -0x40(%ebp)
8010503e:	e8 cd ce ff ff       	call   80101f10 <nameiparent>
80105043:	83 c4 10             	add    $0x10,%esp
80105046:	85 c0                	test   %eax,%eax
80105048:	89 c6                	mov    %eax,%esi
8010504a:	0f 84 60 01 00 00    	je     801051b0 <sys_unlink+0x1a0>
  ilock(dp);
80105050:	83 ec 0c             	sub    $0xc,%esp
80105053:	50                   	push   %eax
80105054:	e8 37 c6 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105059:	58                   	pop    %eax
8010505a:	5a                   	pop    %edx
8010505b:	68 e0 79 10 80       	push   $0x801079e0
80105060:	53                   	push   %ebx
80105061:	e8 3a cb ff ff       	call   80101ba0 <namecmp>
80105066:	83 c4 10             	add    $0x10,%esp
80105069:	85 c0                	test   %eax,%eax
8010506b:	0f 84 03 01 00 00    	je     80105174 <sys_unlink+0x164>
80105071:	83 ec 08             	sub    $0x8,%esp
80105074:	68 df 79 10 80       	push   $0x801079df
80105079:	53                   	push   %ebx
8010507a:	e8 21 cb ff ff       	call   80101ba0 <namecmp>
8010507f:	83 c4 10             	add    $0x10,%esp
80105082:	85 c0                	test   %eax,%eax
80105084:	0f 84 ea 00 00 00    	je     80105174 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010508a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010508d:	83 ec 04             	sub    $0x4,%esp
80105090:	50                   	push   %eax
80105091:	53                   	push   %ebx
80105092:	56                   	push   %esi
80105093:	e8 28 cb ff ff       	call   80101bc0 <dirlookup>
80105098:	83 c4 10             	add    $0x10,%esp
8010509b:	85 c0                	test   %eax,%eax
8010509d:	89 c3                	mov    %eax,%ebx
8010509f:	0f 84 cf 00 00 00    	je     80105174 <sys_unlink+0x164>
  ilock(ip);
801050a5:	83 ec 0c             	sub    $0xc,%esp
801050a8:	50                   	push   %eax
801050a9:	e8 e2 c5 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
801050ae:	83 c4 10             	add    $0x10,%esp
801050b1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050b6:	0f 8e 10 01 00 00    	jle    801051cc <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050bc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050c1:	74 6d                	je     80105130 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050c3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801050c6:	83 ec 04             	sub    $0x4,%esp
801050c9:	6a 10                	push   $0x10
801050cb:	6a 00                	push   $0x0
801050cd:	50                   	push   %eax
801050ce:	e8 bd f5 ff ff       	call   80104690 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050d3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801050d6:	6a 10                	push   $0x10
801050d8:	ff 75 c4             	pushl  -0x3c(%ebp)
801050db:	50                   	push   %eax
801050dc:	56                   	push   %esi
801050dd:	e8 8e c9 ff ff       	call   80101a70 <writei>
801050e2:	83 c4 20             	add    $0x20,%esp
801050e5:	83 f8 10             	cmp    $0x10,%eax
801050e8:	0f 85 eb 00 00 00    	jne    801051d9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801050ee:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050f3:	0f 84 97 00 00 00    	je     80105190 <sys_unlink+0x180>
  iunlockput(dp);
801050f9:	83 ec 0c             	sub    $0xc,%esp
801050fc:	56                   	push   %esi
801050fd:	e8 1e c8 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105102:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105107:	89 1c 24             	mov    %ebx,(%esp)
8010510a:	e8 d1 c4 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010510f:	89 1c 24             	mov    %ebx,(%esp)
80105112:	e8 09 c8 ff ff       	call   80101920 <iunlockput>
  end_op();
80105117:	e8 64 db ff ff       	call   80102c80 <end_op>
  return 0;
8010511c:	83 c4 10             	add    $0x10,%esp
8010511f:	31 c0                	xor    %eax,%eax
}
80105121:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105124:	5b                   	pop    %ebx
80105125:	5e                   	pop    %esi
80105126:	5f                   	pop    %edi
80105127:	5d                   	pop    %ebp
80105128:	c3                   	ret    
80105129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105130:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105134:	76 8d                	jbe    801050c3 <sys_unlink+0xb3>
80105136:	bf 20 00 00 00       	mov    $0x20,%edi
8010513b:	eb 0f                	jmp    8010514c <sys_unlink+0x13c>
8010513d:	8d 76 00             	lea    0x0(%esi),%esi
80105140:	83 c7 10             	add    $0x10,%edi
80105143:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105146:	0f 83 77 ff ff ff    	jae    801050c3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010514c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010514f:	6a 10                	push   $0x10
80105151:	57                   	push   %edi
80105152:	50                   	push   %eax
80105153:	53                   	push   %ebx
80105154:	e8 17 c8 ff ff       	call   80101970 <readi>
80105159:	83 c4 10             	add    $0x10,%esp
8010515c:	83 f8 10             	cmp    $0x10,%eax
8010515f:	75 5e                	jne    801051bf <sys_unlink+0x1af>
    if(de.inum != 0)
80105161:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105166:	74 d8                	je     80105140 <sys_unlink+0x130>
    iunlockput(ip);
80105168:	83 ec 0c             	sub    $0xc,%esp
8010516b:	53                   	push   %ebx
8010516c:	e8 af c7 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105171:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105174:	83 ec 0c             	sub    $0xc,%esp
80105177:	56                   	push   %esi
80105178:	e8 a3 c7 ff ff       	call   80101920 <iunlockput>
  end_op();
8010517d:	e8 fe da ff ff       	call   80102c80 <end_op>
  return -1;
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010518a:	eb 95                	jmp    80105121 <sys_unlink+0x111>
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105190:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105195:	83 ec 0c             	sub    $0xc,%esp
80105198:	56                   	push   %esi
80105199:	e8 42 c4 ff ff       	call   801015e0 <iupdate>
8010519e:	83 c4 10             	add    $0x10,%esp
801051a1:	e9 53 ff ff ff       	jmp    801050f9 <sys_unlink+0xe9>
    return -1;
801051a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ab:	e9 71 ff ff ff       	jmp    80105121 <sys_unlink+0x111>
    end_op();
801051b0:	e8 cb da ff ff       	call   80102c80 <end_op>
    return -1;
801051b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051ba:	e9 62 ff ff ff       	jmp    80105121 <sys_unlink+0x111>
      panic("isdirempty: readi");
801051bf:	83 ec 0c             	sub    $0xc,%esp
801051c2:	68 04 7a 10 80       	push   $0x80107a04
801051c7:	e8 c4 b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801051cc:	83 ec 0c             	sub    $0xc,%esp
801051cf:	68 f2 79 10 80       	push   $0x801079f2
801051d4:	e8 b7 b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801051d9:	83 ec 0c             	sub    $0xc,%esp
801051dc:	68 16 7a 10 80       	push   $0x80107a16
801051e1:	e8 aa b1 ff ff       	call   80100390 <panic>
801051e6:	8d 76 00             	lea    0x0(%esi),%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051f0 <sys_open>:

int
sys_open(void)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	57                   	push   %edi
801051f4:	56                   	push   %esi
801051f5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051f6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801051f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801051fc:	50                   	push   %eax
801051fd:	6a 00                	push   $0x0
801051ff:	e8 3c f8 ff ff       	call   80104a40 <argstr>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	0f 88 1d 01 00 00    	js     8010532c <sys_open+0x13c>
8010520f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105212:	83 ec 08             	sub    $0x8,%esp
80105215:	50                   	push   %eax
80105216:	6a 01                	push   $0x1
80105218:	e8 73 f7 ff ff       	call   80104990 <argint>
8010521d:	83 c4 10             	add    $0x10,%esp
80105220:	85 c0                	test   %eax,%eax
80105222:	0f 88 04 01 00 00    	js     8010532c <sys_open+0x13c>
    return -1;

  begin_op();
80105228:	e8 e3 d9 ff ff       	call   80102c10 <begin_op>

  if(omode & O_CREATE){
8010522d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105231:	0f 85 a9 00 00 00    	jne    801052e0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105237:	83 ec 0c             	sub    $0xc,%esp
8010523a:	ff 75 e0             	pushl  -0x20(%ebp)
8010523d:	e8 ae cc ff ff       	call   80101ef0 <namei>
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	85 c0                	test   %eax,%eax
80105247:	89 c6                	mov    %eax,%esi
80105249:	0f 84 b2 00 00 00    	je     80105301 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010524f:	83 ec 0c             	sub    $0xc,%esp
80105252:	50                   	push   %eax
80105253:	e8 38 c4 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105260:	0f 84 aa 00 00 00    	je     80105310 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105266:	e8 15 bb ff ff       	call   80100d80 <filealloc>
8010526b:	85 c0                	test   %eax,%eax
8010526d:	89 c7                	mov    %eax,%edi
8010526f:	0f 84 a6 00 00 00    	je     8010531b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105275:	e8 16 e6 ff ff       	call   80103890 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010527a:	31 db                	xor    %ebx,%ebx
8010527c:	eb 0e                	jmp    8010528c <sys_open+0x9c>
8010527e:	66 90                	xchg   %ax,%ax
80105280:	83 c3 01             	add    $0x1,%ebx
80105283:	83 fb 10             	cmp    $0x10,%ebx
80105286:	0f 84 ac 00 00 00    	je     80105338 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010528c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105290:	85 d2                	test   %edx,%edx
80105292:	75 ec                	jne    80105280 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105294:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105297:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010529b:	56                   	push   %esi
8010529c:	e8 cf c4 ff ff       	call   80101770 <iunlock>
  end_op();
801052a1:	e8 da d9 ff ff       	call   80102c80 <end_op>

  f->type = FD_INODE;
801052a6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801052ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052af:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801052b2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
801052b5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801052bc:	89 d0                	mov    %edx,%eax
801052be:	f7 d0                	not    %eax
801052c0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052c3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801052c6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801052c9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801052cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052d0:	89 d8                	mov    %ebx,%eax
801052d2:	5b                   	pop    %ebx
801052d3:	5e                   	pop    %esi
801052d4:	5f                   	pop    %edi
801052d5:	5d                   	pop    %ebp
801052d6:	c3                   	ret    
801052d7:	89 f6                	mov    %esi,%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052e6:	31 c9                	xor    %ecx,%ecx
801052e8:	6a 00                	push   $0x0
801052ea:	ba 02 00 00 00       	mov    $0x2,%edx
801052ef:	e8 ec f7 ff ff       	call   80104ae0 <create>
    if(ip == 0){
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801052f9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052fb:	0f 85 65 ff ff ff    	jne    80105266 <sys_open+0x76>
      end_op();
80105301:	e8 7a d9 ff ff       	call   80102c80 <end_op>
      return -1;
80105306:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010530b:	eb c0                	jmp    801052cd <sys_open+0xdd>
8010530d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105310:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105313:	85 c9                	test   %ecx,%ecx
80105315:	0f 84 4b ff ff ff    	je     80105266 <sys_open+0x76>
    iunlockput(ip);
8010531b:	83 ec 0c             	sub    $0xc,%esp
8010531e:	56                   	push   %esi
8010531f:	e8 fc c5 ff ff       	call   80101920 <iunlockput>
    end_op();
80105324:	e8 57 d9 ff ff       	call   80102c80 <end_op>
    return -1;
80105329:	83 c4 10             	add    $0x10,%esp
8010532c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105331:	eb 9a                	jmp    801052cd <sys_open+0xdd>
80105333:	90                   	nop
80105334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105338:	83 ec 0c             	sub    $0xc,%esp
8010533b:	57                   	push   %edi
8010533c:	e8 ff ba ff ff       	call   80100e40 <fileclose>
80105341:	83 c4 10             	add    $0x10,%esp
80105344:	eb d5                	jmp    8010531b <sys_open+0x12b>
80105346:	8d 76 00             	lea    0x0(%esi),%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <sys_mkdir>:

int
sys_mkdir(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105356:	e8 b5 d8 ff ff       	call   80102c10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010535b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010535e:	83 ec 08             	sub    $0x8,%esp
80105361:	50                   	push   %eax
80105362:	6a 00                	push   $0x0
80105364:	e8 d7 f6 ff ff       	call   80104a40 <argstr>
80105369:	83 c4 10             	add    $0x10,%esp
8010536c:	85 c0                	test   %eax,%eax
8010536e:	78 30                	js     801053a0 <sys_mkdir+0x50>
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105376:	31 c9                	xor    %ecx,%ecx
80105378:	6a 00                	push   $0x0
8010537a:	ba 01 00 00 00       	mov    $0x1,%edx
8010537f:	e8 5c f7 ff ff       	call   80104ae0 <create>
80105384:	83 c4 10             	add    $0x10,%esp
80105387:	85 c0                	test   %eax,%eax
80105389:	74 15                	je     801053a0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010538b:	83 ec 0c             	sub    $0xc,%esp
8010538e:	50                   	push   %eax
8010538f:	e8 8c c5 ff ff       	call   80101920 <iunlockput>
  end_op();
80105394:	e8 e7 d8 ff ff       	call   80102c80 <end_op>
  return 0;
80105399:	83 c4 10             	add    $0x10,%esp
8010539c:	31 c0                	xor    %eax,%eax
}
8010539e:	c9                   	leave  
8010539f:	c3                   	ret    
    end_op();
801053a0:	e8 db d8 ff ff       	call   80102c80 <end_op>
    return -1;
801053a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053aa:	c9                   	leave  
801053ab:	c3                   	ret    
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053b0 <sys_mknod>:

int
sys_mknod(void)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053b6:	e8 55 d8 ff ff       	call   80102c10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053be:	83 ec 08             	sub    $0x8,%esp
801053c1:	50                   	push   %eax
801053c2:	6a 00                	push   $0x0
801053c4:	e8 77 f6 ff ff       	call   80104a40 <argstr>
801053c9:	83 c4 10             	add    $0x10,%esp
801053cc:	85 c0                	test   %eax,%eax
801053ce:	78 60                	js     80105430 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801053d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d3:	83 ec 08             	sub    $0x8,%esp
801053d6:	50                   	push   %eax
801053d7:	6a 01                	push   $0x1
801053d9:	e8 b2 f5 ff ff       	call   80104990 <argint>
  if((argstr(0, &path)) < 0 ||
801053de:	83 c4 10             	add    $0x10,%esp
801053e1:	85 c0                	test   %eax,%eax
801053e3:	78 4b                	js     80105430 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801053e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053e8:	83 ec 08             	sub    $0x8,%esp
801053eb:	50                   	push   %eax
801053ec:	6a 02                	push   $0x2
801053ee:	e8 9d f5 ff ff       	call   80104990 <argint>
     argint(1, &major) < 0 ||
801053f3:	83 c4 10             	add    $0x10,%esp
801053f6:	85 c0                	test   %eax,%eax
801053f8:	78 36                	js     80105430 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801053fa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801053fe:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105401:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105405:	ba 03 00 00 00       	mov    $0x3,%edx
8010540a:	50                   	push   %eax
8010540b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010540e:	e8 cd f6 ff ff       	call   80104ae0 <create>
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	74 16                	je     80105430 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010541a:	83 ec 0c             	sub    $0xc,%esp
8010541d:	50                   	push   %eax
8010541e:	e8 fd c4 ff ff       	call   80101920 <iunlockput>
  end_op();
80105423:	e8 58 d8 ff ff       	call   80102c80 <end_op>
  return 0;
80105428:	83 c4 10             	add    $0x10,%esp
8010542b:	31 c0                	xor    %eax,%eax
}
8010542d:	c9                   	leave  
8010542e:	c3                   	ret    
8010542f:	90                   	nop
    end_op();
80105430:	e8 4b d8 ff ff       	call   80102c80 <end_op>
    return -1;
80105435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010543a:	c9                   	leave  
8010543b:	c3                   	ret    
8010543c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105440 <sys_chdir>:

int
sys_chdir(void)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
80105443:	56                   	push   %esi
80105444:	53                   	push   %ebx
80105445:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105448:	e8 43 e4 ff ff       	call   80103890 <myproc>
8010544d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010544f:	e8 bc d7 ff ff       	call   80102c10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105454:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105457:	83 ec 08             	sub    $0x8,%esp
8010545a:	50                   	push   %eax
8010545b:	6a 00                	push   $0x0
8010545d:	e8 de f5 ff ff       	call   80104a40 <argstr>
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	85 c0                	test   %eax,%eax
80105467:	78 77                	js     801054e0 <sys_chdir+0xa0>
80105469:	83 ec 0c             	sub    $0xc,%esp
8010546c:	ff 75 f4             	pushl  -0xc(%ebp)
8010546f:	e8 7c ca ff ff       	call   80101ef0 <namei>
80105474:	83 c4 10             	add    $0x10,%esp
80105477:	85 c0                	test   %eax,%eax
80105479:	89 c3                	mov    %eax,%ebx
8010547b:	74 63                	je     801054e0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010547d:	83 ec 0c             	sub    $0xc,%esp
80105480:	50                   	push   %eax
80105481:	e8 0a c2 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010548e:	75 30                	jne    801054c0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105490:	83 ec 0c             	sub    $0xc,%esp
80105493:	53                   	push   %ebx
80105494:	e8 d7 c2 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105499:	58                   	pop    %eax
8010549a:	ff 76 68             	pushl  0x68(%esi)
8010549d:	e8 1e c3 ff ff       	call   801017c0 <iput>
  end_op();
801054a2:	e8 d9 d7 ff ff       	call   80102c80 <end_op>
  curproc->cwd = ip;
801054a7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054aa:	83 c4 10             	add    $0x10,%esp
801054ad:	31 c0                	xor    %eax,%eax
}
801054af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054b2:	5b                   	pop    %ebx
801054b3:	5e                   	pop    %esi
801054b4:	5d                   	pop    %ebp
801054b5:	c3                   	ret    
801054b6:	8d 76 00             	lea    0x0(%esi),%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	53                   	push   %ebx
801054c4:	e8 57 c4 ff ff       	call   80101920 <iunlockput>
    end_op();
801054c9:	e8 b2 d7 ff ff       	call   80102c80 <end_op>
    return -1;
801054ce:	83 c4 10             	add    $0x10,%esp
801054d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054d6:	eb d7                	jmp    801054af <sys_chdir+0x6f>
801054d8:	90                   	nop
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801054e0:	e8 9b d7 ff ff       	call   80102c80 <end_op>
    return -1;
801054e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054ea:	eb c3                	jmp    801054af <sys_chdir+0x6f>
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_exec>:

int
sys_exec(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	57                   	push   %edi
801054f4:	56                   	push   %esi
801054f5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801054f6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801054fc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105502:	50                   	push   %eax
80105503:	6a 00                	push   $0x0
80105505:	e8 36 f5 ff ff       	call   80104a40 <argstr>
8010550a:	83 c4 10             	add    $0x10,%esp
8010550d:	85 c0                	test   %eax,%eax
8010550f:	0f 88 87 00 00 00    	js     8010559c <sys_exec+0xac>
80105515:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010551b:	83 ec 08             	sub    $0x8,%esp
8010551e:	50                   	push   %eax
8010551f:	6a 01                	push   $0x1
80105521:	e8 6a f4 ff ff       	call   80104990 <argint>
80105526:	83 c4 10             	add    $0x10,%esp
80105529:	85 c0                	test   %eax,%eax
8010552b:	78 6f                	js     8010559c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010552d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105533:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105536:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105538:	68 80 00 00 00       	push   $0x80
8010553d:	6a 00                	push   $0x0
8010553f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105545:	50                   	push   %eax
80105546:	e8 45 f1 ff ff       	call   80104690 <memset>
8010554b:	83 c4 10             	add    $0x10,%esp
8010554e:	eb 2c                	jmp    8010557c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105550:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105556:	85 c0                	test   %eax,%eax
80105558:	74 56                	je     801055b0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010555a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105560:	83 ec 08             	sub    $0x8,%esp
80105563:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105566:	52                   	push   %edx
80105567:	50                   	push   %eax
80105568:	e8 b3 f3 ff ff       	call   80104920 <fetchstr>
8010556d:	83 c4 10             	add    $0x10,%esp
80105570:	85 c0                	test   %eax,%eax
80105572:	78 28                	js     8010559c <sys_exec+0xac>
  for(i=0;; i++){
80105574:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105577:	83 fb 20             	cmp    $0x20,%ebx
8010557a:	74 20                	je     8010559c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010557c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105582:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105589:	83 ec 08             	sub    $0x8,%esp
8010558c:	57                   	push   %edi
8010558d:	01 f0                	add    %esi,%eax
8010558f:	50                   	push   %eax
80105590:	e8 4b f3 ff ff       	call   801048e0 <fetchint>
80105595:	83 c4 10             	add    $0x10,%esp
80105598:	85 c0                	test   %eax,%eax
8010559a:	79 b4                	jns    80105550 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010559c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010559f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055a4:	5b                   	pop    %ebx
801055a5:	5e                   	pop    %esi
801055a6:	5f                   	pop    %edi
801055a7:	5d                   	pop    %ebp
801055a8:	c3                   	ret    
801055a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801055b0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801055b6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801055b9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055c0:	00 00 00 00 
  return exec(path, argv);
801055c4:	50                   	push   %eax
801055c5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801055cb:	e8 40 b4 ff ff       	call   80100a10 <exec>
801055d0:	83 c4 10             	add    $0x10,%esp
}
801055d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055d6:	5b                   	pop    %ebx
801055d7:	5e                   	pop    %esi
801055d8:	5f                   	pop    %edi
801055d9:	5d                   	pop    %ebp
801055da:	c3                   	ret    
801055db:	90                   	nop
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055e0 <sys_pipe>:

int
sys_pipe(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	57                   	push   %edi
801055e4:	56                   	push   %esi
801055e5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055e6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801055e9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801055ec:	6a 08                	push   $0x8
801055ee:	50                   	push   %eax
801055ef:	6a 00                	push   $0x0
801055f1:	e8 ea f3 ff ff       	call   801049e0 <argptr>
801055f6:	83 c4 10             	add    $0x10,%esp
801055f9:	85 c0                	test   %eax,%eax
801055fb:	0f 88 ae 00 00 00    	js     801056af <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105601:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105604:	83 ec 08             	sub    $0x8,%esp
80105607:	50                   	push   %eax
80105608:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010560b:	50                   	push   %eax
8010560c:	e8 9f dc ff ff       	call   801032b0 <pipealloc>
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	85 c0                	test   %eax,%eax
80105616:	0f 88 93 00 00 00    	js     801056af <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010561c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010561f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105621:	e8 6a e2 ff ff       	call   80103890 <myproc>
80105626:	eb 10                	jmp    80105638 <sys_pipe+0x58>
80105628:	90                   	nop
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105630:	83 c3 01             	add    $0x1,%ebx
80105633:	83 fb 10             	cmp    $0x10,%ebx
80105636:	74 60                	je     80105698 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105638:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010563c:	85 f6                	test   %esi,%esi
8010563e:	75 f0                	jne    80105630 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105640:	8d 73 08             	lea    0x8(%ebx),%esi
80105643:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105647:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010564a:	e8 41 e2 ff ff       	call   80103890 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010564f:	31 d2                	xor    %edx,%edx
80105651:	eb 0d                	jmp    80105660 <sys_pipe+0x80>
80105653:	90                   	nop
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105658:	83 c2 01             	add    $0x1,%edx
8010565b:	83 fa 10             	cmp    $0x10,%edx
8010565e:	74 28                	je     80105688 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105660:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105664:	85 c9                	test   %ecx,%ecx
80105666:	75 f0                	jne    80105658 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105668:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010566c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010566f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105671:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105674:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105677:	31 c0                	xor    %eax,%eax
}
80105679:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010567c:	5b                   	pop    %ebx
8010567d:	5e                   	pop    %esi
8010567e:	5f                   	pop    %edi
8010567f:	5d                   	pop    %ebp
80105680:	c3                   	ret    
80105681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105688:	e8 03 e2 ff ff       	call   80103890 <myproc>
8010568d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105694:	00 
80105695:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105698:	83 ec 0c             	sub    $0xc,%esp
8010569b:	ff 75 e0             	pushl  -0x20(%ebp)
8010569e:	e8 9d b7 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
801056a3:	58                   	pop    %eax
801056a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801056a7:	e8 94 b7 ff ff       	call   80100e40 <fileclose>
    return -1;
801056ac:	83 c4 10             	add    $0x10,%esp
801056af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b4:	eb c3                	jmp    80105679 <sys_pipe+0x99>
801056b6:	66 90                	xchg   %ax,%ax
801056b8:	66 90                	xchg   %ax,%ax
801056ba:	66 90                	xchg   %ax,%ax
801056bc:	66 90                	xchg   %ax,%ax
801056be:	66 90                	xchg   %ax,%ax

801056c0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801056c3:	5d                   	pop    %ebp
  return fork();
801056c4:	e9 67 e3 ff ff       	jmp    80103a30 <fork>
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_exit>:

int
sys_exit(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	83 ec 08             	sub    $0x8,%esp
  exit();
801056d6:	e8 25 e6 ff ff       	call   80103d00 <exit>
  return 0;  // not reached
}
801056db:	31 c0                	xor    %eax,%eax
801056dd:	c9                   	leave  
801056de:	c3                   	ret    
801056df:	90                   	nop

801056e0 <sys_wait>:

int
sys_wait(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801056e3:	5d                   	pop    %ebp
  return wait();
801056e4:	e9 57 e8 ff ff       	jmp    80103f40 <wait>
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801056f0 <sys_kill>:

int
sys_kill(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801056f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f9:	50                   	push   %eax
801056fa:	6a 00                	push   $0x0
801056fc:	e8 8f f2 ff ff       	call   80104990 <argint>
80105701:	83 c4 10             	add    $0x10,%esp
80105704:	85 c0                	test   %eax,%eax
80105706:	78 18                	js     80105720 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105708:	83 ec 0c             	sub    $0xc,%esp
8010570b:	ff 75 f4             	pushl  -0xc(%ebp)
8010570e:	e8 8d e9 ff ff       	call   801040a0 <kill>
80105713:	83 c4 10             	add    $0x10,%esp
}
80105716:	c9                   	leave  
80105717:	c3                   	ret    
80105718:	90                   	nop
80105719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105725:	c9                   	leave  
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_getpid>:

int
sys_getpid(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105736:	e8 55 e1 ff ff       	call   80103890 <myproc>
8010573b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010573e:	c9                   	leave  
8010573f:	c3                   	ret    

80105740 <sys_sbrk>:

int
sys_sbrk(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105744:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105747:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010574a:	50                   	push   %eax
8010574b:	6a 00                	push   $0x0
8010574d:	e8 3e f2 ff ff       	call   80104990 <argint>
80105752:	83 c4 10             	add    $0x10,%esp
80105755:	85 c0                	test   %eax,%eax
80105757:	78 27                	js     80105780 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105759:	e8 32 e1 ff ff       	call   80103890 <myproc>
  if(growproc(n) < 0)
8010575e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105761:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105763:	ff 75 f4             	pushl  -0xc(%ebp)
80105766:	e8 45 e2 ff ff       	call   801039b0 <growproc>
8010576b:	83 c4 10             	add    $0x10,%esp
8010576e:	85 c0                	test   %eax,%eax
80105770:	78 0e                	js     80105780 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105772:	89 d8                	mov    %ebx,%eax
80105774:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105777:	c9                   	leave  
80105778:	c3                   	ret    
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105780:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105785:	eb eb                	jmp    80105772 <sys_sbrk+0x32>
80105787:	89 f6                	mov    %esi,%esi
80105789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105790 <sys_sleep>:

int
sys_sleep(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105794:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105797:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010579a:	50                   	push   %eax
8010579b:	6a 00                	push   $0x0
8010579d:	e8 ee f1 ff ff       	call   80104990 <argint>
801057a2:	83 c4 10             	add    $0x10,%esp
801057a5:	85 c0                	test   %eax,%eax
801057a7:	0f 88 8a 00 00 00    	js     80105837 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801057ad:	83 ec 0c             	sub    $0xc,%esp
801057b0:	68 60 54 11 80       	push   $0x80115460
801057b5:	e8 56 ed ff ff       	call   80104510 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801057ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057bd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801057c0:	8b 1d a0 5c 11 80    	mov    0x80115ca0,%ebx
  while(ticks - ticks0 < n){
801057c6:	85 d2                	test   %edx,%edx
801057c8:	75 27                	jne    801057f1 <sys_sleep+0x61>
801057ca:	eb 54                	jmp    80105820 <sys_sleep+0x90>
801057cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801057d0:	83 ec 08             	sub    $0x8,%esp
801057d3:	68 60 54 11 80       	push   $0x80115460
801057d8:	68 a0 5c 11 80       	push   $0x80115ca0
801057dd:	e8 9e e6 ff ff       	call   80103e80 <sleep>
  while(ticks - ticks0 < n){
801057e2:	a1 a0 5c 11 80       	mov    0x80115ca0,%eax
801057e7:	83 c4 10             	add    $0x10,%esp
801057ea:	29 d8                	sub    %ebx,%eax
801057ec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801057ef:	73 2f                	jae    80105820 <sys_sleep+0x90>
    if(myproc()->killed){
801057f1:	e8 9a e0 ff ff       	call   80103890 <myproc>
801057f6:	8b 40 24             	mov    0x24(%eax),%eax
801057f9:	85 c0                	test   %eax,%eax
801057fb:	74 d3                	je     801057d0 <sys_sleep+0x40>
      release(&tickslock);
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	68 60 54 11 80       	push   $0x80115460
80105805:	e8 26 ee ff ff       	call   80104630 <release>
      return -1;
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105815:	c9                   	leave  
80105816:	c3                   	ret    
80105817:	89 f6                	mov    %esi,%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105820:	83 ec 0c             	sub    $0xc,%esp
80105823:	68 60 54 11 80       	push   $0x80115460
80105828:	e8 03 ee ff ff       	call   80104630 <release>
  return 0;
8010582d:	83 c4 10             	add    $0x10,%esp
80105830:	31 c0                	xor    %eax,%eax
}
80105832:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105835:	c9                   	leave  
80105836:	c3                   	ret    
    return -1;
80105837:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583c:	eb f4                	jmp    80105832 <sys_sleep+0xa2>
8010583e:	66 90                	xchg   %ax,%ax

80105840 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	53                   	push   %ebx
80105844:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105847:	68 60 54 11 80       	push   $0x80115460
8010584c:	e8 bf ec ff ff       	call   80104510 <acquire>
  xticks = ticks;
80105851:	8b 1d a0 5c 11 80    	mov    0x80115ca0,%ebx
  release(&tickslock);
80105857:	c7 04 24 60 54 11 80 	movl   $0x80115460,(%esp)
8010585e:	e8 cd ed ff ff       	call   80104630 <release>
  return xticks;
}
80105863:	89 d8                	mov    %ebx,%eax
80105865:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105868:	c9                   	leave  
80105869:	c3                   	ret    
8010586a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105870 <sys_cps>:

int
sys_cps(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
	return cps();
}
80105873:	5d                   	pop    %ebp
	return cps();
80105874:	e9 77 e9 ff ff       	jmp    801041f0 <cps>
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105880 <sys_chpr>:

int
sys_chpr(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 20             	sub    $0x20,%esp
	int pid, pr;
	if(argint(0, &pid) < 0)
80105886:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105889:	50                   	push   %eax
8010588a:	6a 00                	push   $0x0
8010588c:	e8 ff f0 ff ff       	call   80104990 <argint>
80105891:	83 c4 10             	add    $0x10,%esp
80105894:	85 c0                	test   %eax,%eax
80105896:	78 28                	js     801058c0 <sys_chpr+0x40>
	   return -1;
	if(argint(1, &pr) < 0)
80105898:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010589b:	83 ec 08             	sub    $0x8,%esp
8010589e:	50                   	push   %eax
8010589f:	6a 01                	push   $0x1
801058a1:	e8 ea f0 ff ff       	call   80104990 <argint>
801058a6:	83 c4 10             	add    $0x10,%esp
801058a9:	85 c0                	test   %eax,%eax
801058ab:	78 13                	js     801058c0 <sys_chpr+0x40>
	   return -1;

	return chpr(pid, pr);
801058ad:	83 ec 08             	sub    $0x8,%esp
801058b0:	ff 75 f4             	pushl  -0xc(%ebp)
801058b3:	ff 75 f0             	pushl  -0x10(%ebp)
801058b6:	e8 05 ea ff ff       	call   801042c0 <chpr>
801058bb:	83 c4 10             	add    $0x10,%esp
}
801058be:	c9                   	leave  
801058bf:	c3                   	ret    
	   return -1;
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058c5:	c9                   	leave  
801058c6:	c3                   	ret    
801058c7:	89 f6                	mov    %esi,%esi
801058c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058d0 <sys_pfs>:

int
sys_pfs(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
	return pfs();
}
801058d3:	5d                   	pop    %ebp
	return pfs();
801058d4:	e9 57 c6 ff ff       	jmp    80101f30 <pfs>

801058d9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801058d9:	1e                   	push   %ds
  pushl %es
801058da:	06                   	push   %es
  pushl %fs
801058db:	0f a0                	push   %fs
  pushl %gs
801058dd:	0f a8                	push   %gs
  pushal
801058df:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801058e0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801058e4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801058e6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801058e8:	54                   	push   %esp
  call trap
801058e9:	e8 c2 00 00 00       	call   801059b0 <trap>
  addl $4, %esp
801058ee:	83 c4 04             	add    $0x4,%esp

801058f1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801058f1:	61                   	popa   
  popl %gs
801058f2:	0f a9                	pop    %gs
  popl %fs
801058f4:	0f a1                	pop    %fs
  popl %es
801058f6:	07                   	pop    %es
  popl %ds
801058f7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801058f8:	83 c4 08             	add    $0x8,%esp
  iret
801058fb:	cf                   	iret   
801058fc:	66 90                	xchg   %ax,%ax
801058fe:	66 90                	xchg   %ax,%ax

80105900 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105900:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105901:	31 c0                	xor    %eax,%eax
{
80105903:	89 e5                	mov    %esp,%ebp
80105905:	83 ec 08             	sub    $0x8,%esp
80105908:	90                   	nop
80105909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105910:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105917:	c7 04 c5 a2 54 11 80 	movl   $0x8e000008,-0x7feeab5e(,%eax,8)
8010591e:	08 00 00 8e 
80105922:	66 89 14 c5 a0 54 11 	mov    %dx,-0x7feeab60(,%eax,8)
80105929:	80 
8010592a:	c1 ea 10             	shr    $0x10,%edx
8010592d:	66 89 14 c5 a6 54 11 	mov    %dx,-0x7feeab5a(,%eax,8)
80105934:	80 
  for(i = 0; i < 256; i++)
80105935:	83 c0 01             	add    $0x1,%eax
80105938:	3d 00 01 00 00       	cmp    $0x100,%eax
8010593d:	75 d1                	jne    80105910 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010593f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105944:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105947:	c7 05 a2 56 11 80 08 	movl   $0xef000008,0x801156a2
8010594e:	00 00 ef 
  initlock(&tickslock, "time");
80105951:	68 25 7a 10 80       	push   $0x80107a25
80105956:	68 60 54 11 80       	push   $0x80115460
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010595b:	66 a3 a0 56 11 80    	mov    %ax,0x801156a0
80105961:	c1 e8 10             	shr    $0x10,%eax
80105964:	66 a3 a6 56 11 80    	mov    %ax,0x801156a6
  initlock(&tickslock, "time");
8010596a:	e8 b1 ea ff ff       	call   80104420 <initlock>
}
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	c9                   	leave  
80105973:	c3                   	ret    
80105974:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010597a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105980 <idtinit>:

void
idtinit(void)
{
80105980:	55                   	push   %ebp
  pd[0] = size-1;
80105981:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105986:	89 e5                	mov    %esp,%ebp
80105988:	83 ec 10             	sub    $0x10,%esp
8010598b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010598f:	b8 a0 54 11 80       	mov    $0x801154a0,%eax
80105994:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105998:	c1 e8 10             	shr    $0x10,%eax
8010599b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010599f:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059a2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059a5:	c9                   	leave  
801059a6:	c3                   	ret    
801059a7:	89 f6                	mov    %esi,%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059b0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
801059b5:	53                   	push   %ebx
801059b6:	83 ec 1c             	sub    $0x1c,%esp
801059b9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801059bc:	8b 47 30             	mov    0x30(%edi),%eax
801059bf:	83 f8 40             	cmp    $0x40,%eax
801059c2:	0f 84 f0 00 00 00    	je     80105ab8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801059c8:	83 e8 20             	sub    $0x20,%eax
801059cb:	83 f8 1f             	cmp    $0x1f,%eax
801059ce:	77 10                	ja     801059e0 <trap+0x30>
801059d0:	ff 24 85 cc 7a 10 80 	jmp    *-0x7fef8534(,%eax,4)
801059d7:	89 f6                	mov    %esi,%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801059e0:	e8 ab de ff ff       	call   80103890 <myproc>
801059e5:	85 c0                	test   %eax,%eax
801059e7:	8b 5f 38             	mov    0x38(%edi),%ebx
801059ea:	0f 84 14 02 00 00    	je     80105c04 <trap+0x254>
801059f0:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801059f4:	0f 84 0a 02 00 00    	je     80105c04 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801059fa:	0f 20 d1             	mov    %cr2,%ecx
801059fd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a00:	e8 6b de ff ff       	call   80103870 <cpuid>
80105a05:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105a08:	8b 47 34             	mov    0x34(%edi),%eax
80105a0b:	8b 77 30             	mov    0x30(%edi),%esi
80105a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105a11:	e8 7a de ff ff       	call   80103890 <myproc>
80105a16:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105a19:	e8 72 de ff ff       	call   80103890 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a1e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105a21:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a24:	51                   	push   %ecx
80105a25:	53                   	push   %ebx
80105a26:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105a27:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a2a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a2d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105a2e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105a31:	52                   	push   %edx
80105a32:	ff 70 10             	pushl  0x10(%eax)
80105a35:	68 88 7a 10 80       	push   $0x80107a88
80105a3a:	e8 21 ac ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105a3f:	83 c4 20             	add    $0x20,%esp
80105a42:	e8 49 de ff ff       	call   80103890 <myproc>
80105a47:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a4e:	e8 3d de ff ff       	call   80103890 <myproc>
80105a53:	85 c0                	test   %eax,%eax
80105a55:	74 1d                	je     80105a74 <trap+0xc4>
80105a57:	e8 34 de ff ff       	call   80103890 <myproc>
80105a5c:	8b 50 24             	mov    0x24(%eax),%edx
80105a5f:	85 d2                	test   %edx,%edx
80105a61:	74 11                	je     80105a74 <trap+0xc4>
80105a63:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105a67:	83 e0 03             	and    $0x3,%eax
80105a6a:	66 83 f8 03          	cmp    $0x3,%ax
80105a6e:	0f 84 4c 01 00 00    	je     80105bc0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a74:	e8 17 de ff ff       	call   80103890 <myproc>
80105a79:	85 c0                	test   %eax,%eax
80105a7b:	74 0b                	je     80105a88 <trap+0xd8>
80105a7d:	e8 0e de ff ff       	call   80103890 <myproc>
80105a82:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a86:	74 68                	je     80105af0 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a88:	e8 03 de ff ff       	call   80103890 <myproc>
80105a8d:	85 c0                	test   %eax,%eax
80105a8f:	74 19                	je     80105aaa <trap+0xfa>
80105a91:	e8 fa dd ff ff       	call   80103890 <myproc>
80105a96:	8b 40 24             	mov    0x24(%eax),%eax
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	74 0d                	je     80105aaa <trap+0xfa>
80105a9d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105aa1:	83 e0 03             	and    $0x3,%eax
80105aa4:	66 83 f8 03          	cmp    $0x3,%ax
80105aa8:	74 37                	je     80105ae1 <trap+0x131>
    exit();
}
80105aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aad:	5b                   	pop    %ebx
80105aae:	5e                   	pop    %esi
80105aaf:	5f                   	pop    %edi
80105ab0:	5d                   	pop    %ebp
80105ab1:	c3                   	ret    
80105ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105ab8:	e8 d3 dd ff ff       	call   80103890 <myproc>
80105abd:	8b 58 24             	mov    0x24(%eax),%ebx
80105ac0:	85 db                	test   %ebx,%ebx
80105ac2:	0f 85 e8 00 00 00    	jne    80105bb0 <trap+0x200>
    myproc()->tf = tf;
80105ac8:	e8 c3 dd ff ff       	call   80103890 <myproc>
80105acd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105ad0:	e8 ab ef ff ff       	call   80104a80 <syscall>
    if(myproc()->killed)
80105ad5:	e8 b6 dd ff ff       	call   80103890 <myproc>
80105ada:	8b 48 24             	mov    0x24(%eax),%ecx
80105add:	85 c9                	test   %ecx,%ecx
80105adf:	74 c9                	je     80105aaa <trap+0xfa>
}
80105ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ae4:	5b                   	pop    %ebx
80105ae5:	5e                   	pop    %esi
80105ae6:	5f                   	pop    %edi
80105ae7:	5d                   	pop    %ebp
      exit();
80105ae8:	e9 13 e2 ff ff       	jmp    80103d00 <exit>
80105aed:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105af0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105af4:	75 92                	jne    80105a88 <trap+0xd8>
    yield();
80105af6:	e8 35 e3 ff ff       	call   80103e30 <yield>
80105afb:	eb 8b                	jmp    80105a88 <trap+0xd8>
80105afd:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105b00:	e8 6b dd ff ff       	call   80103870 <cpuid>
80105b05:	85 c0                	test   %eax,%eax
80105b07:	0f 84 c3 00 00 00    	je     80105bd0 <trap+0x220>
    lapiceoi();
80105b0d:	e8 ae cc ff ff       	call   801027c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b12:	e8 79 dd ff ff       	call   80103890 <myproc>
80105b17:	85 c0                	test   %eax,%eax
80105b19:	0f 85 38 ff ff ff    	jne    80105a57 <trap+0xa7>
80105b1f:	e9 50 ff ff ff       	jmp    80105a74 <trap+0xc4>
80105b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105b28:	e8 53 cb ff ff       	call   80102680 <kbdintr>
    lapiceoi();
80105b2d:	e8 8e cc ff ff       	call   801027c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b32:	e8 59 dd ff ff       	call   80103890 <myproc>
80105b37:	85 c0                	test   %eax,%eax
80105b39:	0f 85 18 ff ff ff    	jne    80105a57 <trap+0xa7>
80105b3f:	e9 30 ff ff ff       	jmp    80105a74 <trap+0xc4>
80105b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105b48:	e8 53 02 00 00       	call   80105da0 <uartintr>
    lapiceoi();
80105b4d:	e8 6e cc ff ff       	call   801027c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b52:	e8 39 dd ff ff       	call   80103890 <myproc>
80105b57:	85 c0                	test   %eax,%eax
80105b59:	0f 85 f8 fe ff ff    	jne    80105a57 <trap+0xa7>
80105b5f:	e9 10 ff ff ff       	jmp    80105a74 <trap+0xc4>
80105b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b68:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105b6c:	8b 77 38             	mov    0x38(%edi),%esi
80105b6f:	e8 fc dc ff ff       	call   80103870 <cpuid>
80105b74:	56                   	push   %esi
80105b75:	53                   	push   %ebx
80105b76:	50                   	push   %eax
80105b77:	68 30 7a 10 80       	push   $0x80107a30
80105b7c:	e8 df aa ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105b81:	e8 3a cc ff ff       	call   801027c0 <lapiceoi>
    break;
80105b86:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b89:	e8 02 dd ff ff       	call   80103890 <myproc>
80105b8e:	85 c0                	test   %eax,%eax
80105b90:	0f 85 c1 fe ff ff    	jne    80105a57 <trap+0xa7>
80105b96:	e9 d9 fe ff ff       	jmp    80105a74 <trap+0xc4>
80105b9b:	90                   	nop
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105ba0:	e8 4b c5 ff ff       	call   801020f0 <ideintr>
80105ba5:	e9 63 ff ff ff       	jmp    80105b0d <trap+0x15d>
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105bb0:	e8 4b e1 ff ff       	call   80103d00 <exit>
80105bb5:	e9 0e ff ff ff       	jmp    80105ac8 <trap+0x118>
80105bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105bc0:	e8 3b e1 ff ff       	call   80103d00 <exit>
80105bc5:	e9 aa fe ff ff       	jmp    80105a74 <trap+0xc4>
80105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105bd0:	83 ec 0c             	sub    $0xc,%esp
80105bd3:	68 60 54 11 80       	push   $0x80115460
80105bd8:	e8 33 e9 ff ff       	call   80104510 <acquire>
      wakeup(&ticks);
80105bdd:	c7 04 24 a0 5c 11 80 	movl   $0x80115ca0,(%esp)
      ticks++;
80105be4:	83 05 a0 5c 11 80 01 	addl   $0x1,0x80115ca0
      wakeup(&ticks);
80105beb:	e8 50 e4 ff ff       	call   80104040 <wakeup>
      release(&tickslock);
80105bf0:	c7 04 24 60 54 11 80 	movl   $0x80115460,(%esp)
80105bf7:	e8 34 ea ff ff       	call   80104630 <release>
80105bfc:	83 c4 10             	add    $0x10,%esp
80105bff:	e9 09 ff ff ff       	jmp    80105b0d <trap+0x15d>
80105c04:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c07:	e8 64 dc ff ff       	call   80103870 <cpuid>
80105c0c:	83 ec 0c             	sub    $0xc,%esp
80105c0f:	56                   	push   %esi
80105c10:	53                   	push   %ebx
80105c11:	50                   	push   %eax
80105c12:	ff 77 30             	pushl  0x30(%edi)
80105c15:	68 54 7a 10 80       	push   $0x80107a54
80105c1a:	e8 41 aa ff ff       	call   80100660 <cprintf>
      panic("trap");
80105c1f:	83 c4 14             	add    $0x14,%esp
80105c22:	68 2a 7a 10 80       	push   $0x80107a2a
80105c27:	e8 64 a7 ff ff       	call   80100390 <panic>
80105c2c:	66 90                	xchg   %ax,%ax
80105c2e:	66 90                	xchg   %ax,%ax

80105c30 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c30:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105c35:	55                   	push   %ebp
80105c36:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105c38:	85 c0                	test   %eax,%eax
80105c3a:	74 1c                	je     80105c58 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c3c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c41:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c42:	a8 01                	test   $0x1,%al
80105c44:	74 12                	je     80105c58 <uartgetc+0x28>
80105c46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c4b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c4c:	0f b6 c0             	movzbl %al,%eax
}
80105c4f:	5d                   	pop    %ebp
80105c50:	c3                   	ret    
80105c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c5d:	5d                   	pop    %ebp
80105c5e:	c3                   	ret    
80105c5f:	90                   	nop

80105c60 <uartputc.part.0>:
uartputc(int c)
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
80105c66:	89 c7                	mov    %eax,%edi
80105c68:	bb 80 00 00 00       	mov    $0x80,%ebx
80105c6d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105c72:	83 ec 0c             	sub    $0xc,%esp
80105c75:	eb 1b                	jmp    80105c92 <uartputc.part.0+0x32>
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	6a 0a                	push   $0xa
80105c85:	e8 56 cb ff ff       	call   801027e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105c8a:	83 c4 10             	add    $0x10,%esp
80105c8d:	83 eb 01             	sub    $0x1,%ebx
80105c90:	74 07                	je     80105c99 <uartputc.part.0+0x39>
80105c92:	89 f2                	mov    %esi,%edx
80105c94:	ec                   	in     (%dx),%al
80105c95:	a8 20                	test   $0x20,%al
80105c97:	74 e7                	je     80105c80 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105c99:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c9e:	89 f8                	mov    %edi,%eax
80105ca0:	ee                   	out    %al,(%dx)
}
80105ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca4:	5b                   	pop    %ebx
80105ca5:	5e                   	pop    %esi
80105ca6:	5f                   	pop    %edi
80105ca7:	5d                   	pop    %ebp
80105ca8:	c3                   	ret    
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105cb0 <uartinit>:
{
80105cb0:	55                   	push   %ebp
80105cb1:	31 c9                	xor    %ecx,%ecx
80105cb3:	89 c8                	mov    %ecx,%eax
80105cb5:	89 e5                	mov    %esp,%ebp
80105cb7:	57                   	push   %edi
80105cb8:	56                   	push   %esi
80105cb9:	53                   	push   %ebx
80105cba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105cbf:	89 da                	mov    %ebx,%edx
80105cc1:	83 ec 0c             	sub    $0xc,%esp
80105cc4:	ee                   	out    %al,(%dx)
80105cc5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105cca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105ccf:	89 fa                	mov    %edi,%edx
80105cd1:	ee                   	out    %al,(%dx)
80105cd2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cd7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105cdc:	ee                   	out    %al,(%dx)
80105cdd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105ce2:	89 c8                	mov    %ecx,%eax
80105ce4:	89 f2                	mov    %esi,%edx
80105ce6:	ee                   	out    %al,(%dx)
80105ce7:	b8 03 00 00 00       	mov    $0x3,%eax
80105cec:	89 fa                	mov    %edi,%edx
80105cee:	ee                   	out    %al,(%dx)
80105cef:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105cf4:	89 c8                	mov    %ecx,%eax
80105cf6:	ee                   	out    %al,(%dx)
80105cf7:	b8 01 00 00 00       	mov    $0x1,%eax
80105cfc:	89 f2                	mov    %esi,%edx
80105cfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d04:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105d05:	3c ff                	cmp    $0xff,%al
80105d07:	74 5a                	je     80105d63 <uartinit+0xb3>
  uart = 1;
80105d09:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105d10:	00 00 00 
80105d13:	89 da                	mov    %ebx,%edx
80105d15:	ec                   	in     (%dx),%al
80105d16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d1b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d1c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105d1f:	bb 4c 7b 10 80       	mov    $0x80107b4c,%ebx
  ioapicenable(IRQ_COM1, 0);
80105d24:	6a 00                	push   $0x0
80105d26:	6a 04                	push   $0x4
80105d28:	e8 13 c6 ff ff       	call   80102340 <ioapicenable>
80105d2d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105d30:	b8 78 00 00 00       	mov    $0x78,%eax
80105d35:	eb 13                	jmp    80105d4a <uartinit+0x9a>
80105d37:	89 f6                	mov    %esi,%esi
80105d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d40:	83 c3 01             	add    $0x1,%ebx
80105d43:	0f be 03             	movsbl (%ebx),%eax
80105d46:	84 c0                	test   %al,%al
80105d48:	74 19                	je     80105d63 <uartinit+0xb3>
  if(!uart)
80105d4a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105d50:	85 d2                	test   %edx,%edx
80105d52:	74 ec                	je     80105d40 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105d54:	83 c3 01             	add    $0x1,%ebx
80105d57:	e8 04 ff ff ff       	call   80105c60 <uartputc.part.0>
80105d5c:	0f be 03             	movsbl (%ebx),%eax
80105d5f:	84 c0                	test   %al,%al
80105d61:	75 e7                	jne    80105d4a <uartinit+0x9a>
}
80105d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d66:	5b                   	pop    %ebx
80105d67:	5e                   	pop    %esi
80105d68:	5f                   	pop    %edi
80105d69:	5d                   	pop    %ebp
80105d6a:	c3                   	ret    
80105d6b:	90                   	nop
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <uartputc>:
  if(!uart)
80105d70:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105d76:	55                   	push   %ebp
80105d77:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105d79:	85 d2                	test   %edx,%edx
{
80105d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105d7e:	74 10                	je     80105d90 <uartputc+0x20>
}
80105d80:	5d                   	pop    %ebp
80105d81:	e9 da fe ff ff       	jmp    80105c60 <uartputc.part.0>
80105d86:	8d 76 00             	lea    0x0(%esi),%esi
80105d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105d90:	5d                   	pop    %ebp
80105d91:	c3                   	ret    
80105d92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <uartintr>:

void
uartintr(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105da6:	68 30 5c 10 80       	push   $0x80105c30
80105dab:	e8 60 aa ff ff       	call   80100810 <consoleintr>
}
80105db0:	83 c4 10             	add    $0x10,%esp
80105db3:	c9                   	leave  
80105db4:	c3                   	ret    

80105db5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $0
80105db7:	6a 00                	push   $0x0
  jmp alltraps
80105db9:	e9 1b fb ff ff       	jmp    801058d9 <alltraps>

80105dbe <vector1>:
.globl vector1
vector1:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $1
80105dc0:	6a 01                	push   $0x1
  jmp alltraps
80105dc2:	e9 12 fb ff ff       	jmp    801058d9 <alltraps>

80105dc7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $2
80105dc9:	6a 02                	push   $0x2
  jmp alltraps
80105dcb:	e9 09 fb ff ff       	jmp    801058d9 <alltraps>

80105dd0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $3
80105dd2:	6a 03                	push   $0x3
  jmp alltraps
80105dd4:	e9 00 fb ff ff       	jmp    801058d9 <alltraps>

80105dd9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $4
80105ddb:	6a 04                	push   $0x4
  jmp alltraps
80105ddd:	e9 f7 fa ff ff       	jmp    801058d9 <alltraps>

80105de2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $5
80105de4:	6a 05                	push   $0x5
  jmp alltraps
80105de6:	e9 ee fa ff ff       	jmp    801058d9 <alltraps>

80105deb <vector6>:
.globl vector6
vector6:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $6
80105ded:	6a 06                	push   $0x6
  jmp alltraps
80105def:	e9 e5 fa ff ff       	jmp    801058d9 <alltraps>

80105df4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $7
80105df6:	6a 07                	push   $0x7
  jmp alltraps
80105df8:	e9 dc fa ff ff       	jmp    801058d9 <alltraps>

80105dfd <vector8>:
.globl vector8
vector8:
  pushl $8
80105dfd:	6a 08                	push   $0x8
  jmp alltraps
80105dff:	e9 d5 fa ff ff       	jmp    801058d9 <alltraps>

80105e04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $9
80105e06:	6a 09                	push   $0x9
  jmp alltraps
80105e08:	e9 cc fa ff ff       	jmp    801058d9 <alltraps>

80105e0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e0d:	6a 0a                	push   $0xa
  jmp alltraps
80105e0f:	e9 c5 fa ff ff       	jmp    801058d9 <alltraps>

80105e14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e14:	6a 0b                	push   $0xb
  jmp alltraps
80105e16:	e9 be fa ff ff       	jmp    801058d9 <alltraps>

80105e1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e1b:	6a 0c                	push   $0xc
  jmp alltraps
80105e1d:	e9 b7 fa ff ff       	jmp    801058d9 <alltraps>

80105e22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e22:	6a 0d                	push   $0xd
  jmp alltraps
80105e24:	e9 b0 fa ff ff       	jmp    801058d9 <alltraps>

80105e29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e29:	6a 0e                	push   $0xe
  jmp alltraps
80105e2b:	e9 a9 fa ff ff       	jmp    801058d9 <alltraps>

80105e30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $15
80105e32:	6a 0f                	push   $0xf
  jmp alltraps
80105e34:	e9 a0 fa ff ff       	jmp    801058d9 <alltraps>

80105e39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $16
80105e3b:	6a 10                	push   $0x10
  jmp alltraps
80105e3d:	e9 97 fa ff ff       	jmp    801058d9 <alltraps>

80105e42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e42:	6a 11                	push   $0x11
  jmp alltraps
80105e44:	e9 90 fa ff ff       	jmp    801058d9 <alltraps>

80105e49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $18
80105e4b:	6a 12                	push   $0x12
  jmp alltraps
80105e4d:	e9 87 fa ff ff       	jmp    801058d9 <alltraps>

80105e52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $19
80105e54:	6a 13                	push   $0x13
  jmp alltraps
80105e56:	e9 7e fa ff ff       	jmp    801058d9 <alltraps>

80105e5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $20
80105e5d:	6a 14                	push   $0x14
  jmp alltraps
80105e5f:	e9 75 fa ff ff       	jmp    801058d9 <alltraps>

80105e64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $21
80105e66:	6a 15                	push   $0x15
  jmp alltraps
80105e68:	e9 6c fa ff ff       	jmp    801058d9 <alltraps>

80105e6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $22
80105e6f:	6a 16                	push   $0x16
  jmp alltraps
80105e71:	e9 63 fa ff ff       	jmp    801058d9 <alltraps>

80105e76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $23
80105e78:	6a 17                	push   $0x17
  jmp alltraps
80105e7a:	e9 5a fa ff ff       	jmp    801058d9 <alltraps>

80105e7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $24
80105e81:	6a 18                	push   $0x18
  jmp alltraps
80105e83:	e9 51 fa ff ff       	jmp    801058d9 <alltraps>

80105e88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $25
80105e8a:	6a 19                	push   $0x19
  jmp alltraps
80105e8c:	e9 48 fa ff ff       	jmp    801058d9 <alltraps>

80105e91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $26
80105e93:	6a 1a                	push   $0x1a
  jmp alltraps
80105e95:	e9 3f fa ff ff       	jmp    801058d9 <alltraps>

80105e9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $27
80105e9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105e9e:	e9 36 fa ff ff       	jmp    801058d9 <alltraps>

80105ea3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $28
80105ea5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ea7:	e9 2d fa ff ff       	jmp    801058d9 <alltraps>

80105eac <vector29>:
.globl vector29
vector29:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $29
80105eae:	6a 1d                	push   $0x1d
  jmp alltraps
80105eb0:	e9 24 fa ff ff       	jmp    801058d9 <alltraps>

80105eb5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $30
80105eb7:	6a 1e                	push   $0x1e
  jmp alltraps
80105eb9:	e9 1b fa ff ff       	jmp    801058d9 <alltraps>

80105ebe <vector31>:
.globl vector31
vector31:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $31
80105ec0:	6a 1f                	push   $0x1f
  jmp alltraps
80105ec2:	e9 12 fa ff ff       	jmp    801058d9 <alltraps>

80105ec7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $32
80105ec9:	6a 20                	push   $0x20
  jmp alltraps
80105ecb:	e9 09 fa ff ff       	jmp    801058d9 <alltraps>

80105ed0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $33
80105ed2:	6a 21                	push   $0x21
  jmp alltraps
80105ed4:	e9 00 fa ff ff       	jmp    801058d9 <alltraps>

80105ed9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $34
80105edb:	6a 22                	push   $0x22
  jmp alltraps
80105edd:	e9 f7 f9 ff ff       	jmp    801058d9 <alltraps>

80105ee2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $35
80105ee4:	6a 23                	push   $0x23
  jmp alltraps
80105ee6:	e9 ee f9 ff ff       	jmp    801058d9 <alltraps>

80105eeb <vector36>:
.globl vector36
vector36:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $36
80105eed:	6a 24                	push   $0x24
  jmp alltraps
80105eef:	e9 e5 f9 ff ff       	jmp    801058d9 <alltraps>

80105ef4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $37
80105ef6:	6a 25                	push   $0x25
  jmp alltraps
80105ef8:	e9 dc f9 ff ff       	jmp    801058d9 <alltraps>

80105efd <vector38>:
.globl vector38
vector38:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $38
80105eff:	6a 26                	push   $0x26
  jmp alltraps
80105f01:	e9 d3 f9 ff ff       	jmp    801058d9 <alltraps>

80105f06 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $39
80105f08:	6a 27                	push   $0x27
  jmp alltraps
80105f0a:	e9 ca f9 ff ff       	jmp    801058d9 <alltraps>

80105f0f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $40
80105f11:	6a 28                	push   $0x28
  jmp alltraps
80105f13:	e9 c1 f9 ff ff       	jmp    801058d9 <alltraps>

80105f18 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $41
80105f1a:	6a 29                	push   $0x29
  jmp alltraps
80105f1c:	e9 b8 f9 ff ff       	jmp    801058d9 <alltraps>

80105f21 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $42
80105f23:	6a 2a                	push   $0x2a
  jmp alltraps
80105f25:	e9 af f9 ff ff       	jmp    801058d9 <alltraps>

80105f2a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $43
80105f2c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f2e:	e9 a6 f9 ff ff       	jmp    801058d9 <alltraps>

80105f33 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $44
80105f35:	6a 2c                	push   $0x2c
  jmp alltraps
80105f37:	e9 9d f9 ff ff       	jmp    801058d9 <alltraps>

80105f3c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $45
80105f3e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f40:	e9 94 f9 ff ff       	jmp    801058d9 <alltraps>

80105f45 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $46
80105f47:	6a 2e                	push   $0x2e
  jmp alltraps
80105f49:	e9 8b f9 ff ff       	jmp    801058d9 <alltraps>

80105f4e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $47
80105f50:	6a 2f                	push   $0x2f
  jmp alltraps
80105f52:	e9 82 f9 ff ff       	jmp    801058d9 <alltraps>

80105f57 <vector48>:
.globl vector48
vector48:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $48
80105f59:	6a 30                	push   $0x30
  jmp alltraps
80105f5b:	e9 79 f9 ff ff       	jmp    801058d9 <alltraps>

80105f60 <vector49>:
.globl vector49
vector49:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $49
80105f62:	6a 31                	push   $0x31
  jmp alltraps
80105f64:	e9 70 f9 ff ff       	jmp    801058d9 <alltraps>

80105f69 <vector50>:
.globl vector50
vector50:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $50
80105f6b:	6a 32                	push   $0x32
  jmp alltraps
80105f6d:	e9 67 f9 ff ff       	jmp    801058d9 <alltraps>

80105f72 <vector51>:
.globl vector51
vector51:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $51
80105f74:	6a 33                	push   $0x33
  jmp alltraps
80105f76:	e9 5e f9 ff ff       	jmp    801058d9 <alltraps>

80105f7b <vector52>:
.globl vector52
vector52:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $52
80105f7d:	6a 34                	push   $0x34
  jmp alltraps
80105f7f:	e9 55 f9 ff ff       	jmp    801058d9 <alltraps>

80105f84 <vector53>:
.globl vector53
vector53:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $53
80105f86:	6a 35                	push   $0x35
  jmp alltraps
80105f88:	e9 4c f9 ff ff       	jmp    801058d9 <alltraps>

80105f8d <vector54>:
.globl vector54
vector54:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $54
80105f8f:	6a 36                	push   $0x36
  jmp alltraps
80105f91:	e9 43 f9 ff ff       	jmp    801058d9 <alltraps>

80105f96 <vector55>:
.globl vector55
vector55:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $55
80105f98:	6a 37                	push   $0x37
  jmp alltraps
80105f9a:	e9 3a f9 ff ff       	jmp    801058d9 <alltraps>

80105f9f <vector56>:
.globl vector56
vector56:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $56
80105fa1:	6a 38                	push   $0x38
  jmp alltraps
80105fa3:	e9 31 f9 ff ff       	jmp    801058d9 <alltraps>

80105fa8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $57
80105faa:	6a 39                	push   $0x39
  jmp alltraps
80105fac:	e9 28 f9 ff ff       	jmp    801058d9 <alltraps>

80105fb1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $58
80105fb3:	6a 3a                	push   $0x3a
  jmp alltraps
80105fb5:	e9 1f f9 ff ff       	jmp    801058d9 <alltraps>

80105fba <vector59>:
.globl vector59
vector59:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $59
80105fbc:	6a 3b                	push   $0x3b
  jmp alltraps
80105fbe:	e9 16 f9 ff ff       	jmp    801058d9 <alltraps>

80105fc3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $60
80105fc5:	6a 3c                	push   $0x3c
  jmp alltraps
80105fc7:	e9 0d f9 ff ff       	jmp    801058d9 <alltraps>

80105fcc <vector61>:
.globl vector61
vector61:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $61
80105fce:	6a 3d                	push   $0x3d
  jmp alltraps
80105fd0:	e9 04 f9 ff ff       	jmp    801058d9 <alltraps>

80105fd5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $62
80105fd7:	6a 3e                	push   $0x3e
  jmp alltraps
80105fd9:	e9 fb f8 ff ff       	jmp    801058d9 <alltraps>

80105fde <vector63>:
.globl vector63
vector63:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $63
80105fe0:	6a 3f                	push   $0x3f
  jmp alltraps
80105fe2:	e9 f2 f8 ff ff       	jmp    801058d9 <alltraps>

80105fe7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $64
80105fe9:	6a 40                	push   $0x40
  jmp alltraps
80105feb:	e9 e9 f8 ff ff       	jmp    801058d9 <alltraps>

80105ff0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $65
80105ff2:	6a 41                	push   $0x41
  jmp alltraps
80105ff4:	e9 e0 f8 ff ff       	jmp    801058d9 <alltraps>

80105ff9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $66
80105ffb:	6a 42                	push   $0x42
  jmp alltraps
80105ffd:	e9 d7 f8 ff ff       	jmp    801058d9 <alltraps>

80106002 <vector67>:
.globl vector67
vector67:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $67
80106004:	6a 43                	push   $0x43
  jmp alltraps
80106006:	e9 ce f8 ff ff       	jmp    801058d9 <alltraps>

8010600b <vector68>:
.globl vector68
vector68:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $68
8010600d:	6a 44                	push   $0x44
  jmp alltraps
8010600f:	e9 c5 f8 ff ff       	jmp    801058d9 <alltraps>

80106014 <vector69>:
.globl vector69
vector69:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $69
80106016:	6a 45                	push   $0x45
  jmp alltraps
80106018:	e9 bc f8 ff ff       	jmp    801058d9 <alltraps>

8010601d <vector70>:
.globl vector70
vector70:
  pushl $0
8010601d:	6a 00                	push   $0x0
  pushl $70
8010601f:	6a 46                	push   $0x46
  jmp alltraps
80106021:	e9 b3 f8 ff ff       	jmp    801058d9 <alltraps>

80106026 <vector71>:
.globl vector71
vector71:
  pushl $0
80106026:	6a 00                	push   $0x0
  pushl $71
80106028:	6a 47                	push   $0x47
  jmp alltraps
8010602a:	e9 aa f8 ff ff       	jmp    801058d9 <alltraps>

8010602f <vector72>:
.globl vector72
vector72:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $72
80106031:	6a 48                	push   $0x48
  jmp alltraps
80106033:	e9 a1 f8 ff ff       	jmp    801058d9 <alltraps>

80106038 <vector73>:
.globl vector73
vector73:
  pushl $0
80106038:	6a 00                	push   $0x0
  pushl $73
8010603a:	6a 49                	push   $0x49
  jmp alltraps
8010603c:	e9 98 f8 ff ff       	jmp    801058d9 <alltraps>

80106041 <vector74>:
.globl vector74
vector74:
  pushl $0
80106041:	6a 00                	push   $0x0
  pushl $74
80106043:	6a 4a                	push   $0x4a
  jmp alltraps
80106045:	e9 8f f8 ff ff       	jmp    801058d9 <alltraps>

8010604a <vector75>:
.globl vector75
vector75:
  pushl $0
8010604a:	6a 00                	push   $0x0
  pushl $75
8010604c:	6a 4b                	push   $0x4b
  jmp alltraps
8010604e:	e9 86 f8 ff ff       	jmp    801058d9 <alltraps>

80106053 <vector76>:
.globl vector76
vector76:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $76
80106055:	6a 4c                	push   $0x4c
  jmp alltraps
80106057:	e9 7d f8 ff ff       	jmp    801058d9 <alltraps>

8010605c <vector77>:
.globl vector77
vector77:
  pushl $0
8010605c:	6a 00                	push   $0x0
  pushl $77
8010605e:	6a 4d                	push   $0x4d
  jmp alltraps
80106060:	e9 74 f8 ff ff       	jmp    801058d9 <alltraps>

80106065 <vector78>:
.globl vector78
vector78:
  pushl $0
80106065:	6a 00                	push   $0x0
  pushl $78
80106067:	6a 4e                	push   $0x4e
  jmp alltraps
80106069:	e9 6b f8 ff ff       	jmp    801058d9 <alltraps>

8010606e <vector79>:
.globl vector79
vector79:
  pushl $0
8010606e:	6a 00                	push   $0x0
  pushl $79
80106070:	6a 4f                	push   $0x4f
  jmp alltraps
80106072:	e9 62 f8 ff ff       	jmp    801058d9 <alltraps>

80106077 <vector80>:
.globl vector80
vector80:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $80
80106079:	6a 50                	push   $0x50
  jmp alltraps
8010607b:	e9 59 f8 ff ff       	jmp    801058d9 <alltraps>

80106080 <vector81>:
.globl vector81
vector81:
  pushl $0
80106080:	6a 00                	push   $0x0
  pushl $81
80106082:	6a 51                	push   $0x51
  jmp alltraps
80106084:	e9 50 f8 ff ff       	jmp    801058d9 <alltraps>

80106089 <vector82>:
.globl vector82
vector82:
  pushl $0
80106089:	6a 00                	push   $0x0
  pushl $82
8010608b:	6a 52                	push   $0x52
  jmp alltraps
8010608d:	e9 47 f8 ff ff       	jmp    801058d9 <alltraps>

80106092 <vector83>:
.globl vector83
vector83:
  pushl $0
80106092:	6a 00                	push   $0x0
  pushl $83
80106094:	6a 53                	push   $0x53
  jmp alltraps
80106096:	e9 3e f8 ff ff       	jmp    801058d9 <alltraps>

8010609b <vector84>:
.globl vector84
vector84:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $84
8010609d:	6a 54                	push   $0x54
  jmp alltraps
8010609f:	e9 35 f8 ff ff       	jmp    801058d9 <alltraps>

801060a4 <vector85>:
.globl vector85
vector85:
  pushl $0
801060a4:	6a 00                	push   $0x0
  pushl $85
801060a6:	6a 55                	push   $0x55
  jmp alltraps
801060a8:	e9 2c f8 ff ff       	jmp    801058d9 <alltraps>

801060ad <vector86>:
.globl vector86
vector86:
  pushl $0
801060ad:	6a 00                	push   $0x0
  pushl $86
801060af:	6a 56                	push   $0x56
  jmp alltraps
801060b1:	e9 23 f8 ff ff       	jmp    801058d9 <alltraps>

801060b6 <vector87>:
.globl vector87
vector87:
  pushl $0
801060b6:	6a 00                	push   $0x0
  pushl $87
801060b8:	6a 57                	push   $0x57
  jmp alltraps
801060ba:	e9 1a f8 ff ff       	jmp    801058d9 <alltraps>

801060bf <vector88>:
.globl vector88
vector88:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $88
801060c1:	6a 58                	push   $0x58
  jmp alltraps
801060c3:	e9 11 f8 ff ff       	jmp    801058d9 <alltraps>

801060c8 <vector89>:
.globl vector89
vector89:
  pushl $0
801060c8:	6a 00                	push   $0x0
  pushl $89
801060ca:	6a 59                	push   $0x59
  jmp alltraps
801060cc:	e9 08 f8 ff ff       	jmp    801058d9 <alltraps>

801060d1 <vector90>:
.globl vector90
vector90:
  pushl $0
801060d1:	6a 00                	push   $0x0
  pushl $90
801060d3:	6a 5a                	push   $0x5a
  jmp alltraps
801060d5:	e9 ff f7 ff ff       	jmp    801058d9 <alltraps>

801060da <vector91>:
.globl vector91
vector91:
  pushl $0
801060da:	6a 00                	push   $0x0
  pushl $91
801060dc:	6a 5b                	push   $0x5b
  jmp alltraps
801060de:	e9 f6 f7 ff ff       	jmp    801058d9 <alltraps>

801060e3 <vector92>:
.globl vector92
vector92:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $92
801060e5:	6a 5c                	push   $0x5c
  jmp alltraps
801060e7:	e9 ed f7 ff ff       	jmp    801058d9 <alltraps>

801060ec <vector93>:
.globl vector93
vector93:
  pushl $0
801060ec:	6a 00                	push   $0x0
  pushl $93
801060ee:	6a 5d                	push   $0x5d
  jmp alltraps
801060f0:	e9 e4 f7 ff ff       	jmp    801058d9 <alltraps>

801060f5 <vector94>:
.globl vector94
vector94:
  pushl $0
801060f5:	6a 00                	push   $0x0
  pushl $94
801060f7:	6a 5e                	push   $0x5e
  jmp alltraps
801060f9:	e9 db f7 ff ff       	jmp    801058d9 <alltraps>

801060fe <vector95>:
.globl vector95
vector95:
  pushl $0
801060fe:	6a 00                	push   $0x0
  pushl $95
80106100:	6a 5f                	push   $0x5f
  jmp alltraps
80106102:	e9 d2 f7 ff ff       	jmp    801058d9 <alltraps>

80106107 <vector96>:
.globl vector96
vector96:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $96
80106109:	6a 60                	push   $0x60
  jmp alltraps
8010610b:	e9 c9 f7 ff ff       	jmp    801058d9 <alltraps>

80106110 <vector97>:
.globl vector97
vector97:
  pushl $0
80106110:	6a 00                	push   $0x0
  pushl $97
80106112:	6a 61                	push   $0x61
  jmp alltraps
80106114:	e9 c0 f7 ff ff       	jmp    801058d9 <alltraps>

80106119 <vector98>:
.globl vector98
vector98:
  pushl $0
80106119:	6a 00                	push   $0x0
  pushl $98
8010611b:	6a 62                	push   $0x62
  jmp alltraps
8010611d:	e9 b7 f7 ff ff       	jmp    801058d9 <alltraps>

80106122 <vector99>:
.globl vector99
vector99:
  pushl $0
80106122:	6a 00                	push   $0x0
  pushl $99
80106124:	6a 63                	push   $0x63
  jmp alltraps
80106126:	e9 ae f7 ff ff       	jmp    801058d9 <alltraps>

8010612b <vector100>:
.globl vector100
vector100:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $100
8010612d:	6a 64                	push   $0x64
  jmp alltraps
8010612f:	e9 a5 f7 ff ff       	jmp    801058d9 <alltraps>

80106134 <vector101>:
.globl vector101
vector101:
  pushl $0
80106134:	6a 00                	push   $0x0
  pushl $101
80106136:	6a 65                	push   $0x65
  jmp alltraps
80106138:	e9 9c f7 ff ff       	jmp    801058d9 <alltraps>

8010613d <vector102>:
.globl vector102
vector102:
  pushl $0
8010613d:	6a 00                	push   $0x0
  pushl $102
8010613f:	6a 66                	push   $0x66
  jmp alltraps
80106141:	e9 93 f7 ff ff       	jmp    801058d9 <alltraps>

80106146 <vector103>:
.globl vector103
vector103:
  pushl $0
80106146:	6a 00                	push   $0x0
  pushl $103
80106148:	6a 67                	push   $0x67
  jmp alltraps
8010614a:	e9 8a f7 ff ff       	jmp    801058d9 <alltraps>

8010614f <vector104>:
.globl vector104
vector104:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $104
80106151:	6a 68                	push   $0x68
  jmp alltraps
80106153:	e9 81 f7 ff ff       	jmp    801058d9 <alltraps>

80106158 <vector105>:
.globl vector105
vector105:
  pushl $0
80106158:	6a 00                	push   $0x0
  pushl $105
8010615a:	6a 69                	push   $0x69
  jmp alltraps
8010615c:	e9 78 f7 ff ff       	jmp    801058d9 <alltraps>

80106161 <vector106>:
.globl vector106
vector106:
  pushl $0
80106161:	6a 00                	push   $0x0
  pushl $106
80106163:	6a 6a                	push   $0x6a
  jmp alltraps
80106165:	e9 6f f7 ff ff       	jmp    801058d9 <alltraps>

8010616a <vector107>:
.globl vector107
vector107:
  pushl $0
8010616a:	6a 00                	push   $0x0
  pushl $107
8010616c:	6a 6b                	push   $0x6b
  jmp alltraps
8010616e:	e9 66 f7 ff ff       	jmp    801058d9 <alltraps>

80106173 <vector108>:
.globl vector108
vector108:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $108
80106175:	6a 6c                	push   $0x6c
  jmp alltraps
80106177:	e9 5d f7 ff ff       	jmp    801058d9 <alltraps>

8010617c <vector109>:
.globl vector109
vector109:
  pushl $0
8010617c:	6a 00                	push   $0x0
  pushl $109
8010617e:	6a 6d                	push   $0x6d
  jmp alltraps
80106180:	e9 54 f7 ff ff       	jmp    801058d9 <alltraps>

80106185 <vector110>:
.globl vector110
vector110:
  pushl $0
80106185:	6a 00                	push   $0x0
  pushl $110
80106187:	6a 6e                	push   $0x6e
  jmp alltraps
80106189:	e9 4b f7 ff ff       	jmp    801058d9 <alltraps>

8010618e <vector111>:
.globl vector111
vector111:
  pushl $0
8010618e:	6a 00                	push   $0x0
  pushl $111
80106190:	6a 6f                	push   $0x6f
  jmp alltraps
80106192:	e9 42 f7 ff ff       	jmp    801058d9 <alltraps>

80106197 <vector112>:
.globl vector112
vector112:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $112
80106199:	6a 70                	push   $0x70
  jmp alltraps
8010619b:	e9 39 f7 ff ff       	jmp    801058d9 <alltraps>

801061a0 <vector113>:
.globl vector113
vector113:
  pushl $0
801061a0:	6a 00                	push   $0x0
  pushl $113
801061a2:	6a 71                	push   $0x71
  jmp alltraps
801061a4:	e9 30 f7 ff ff       	jmp    801058d9 <alltraps>

801061a9 <vector114>:
.globl vector114
vector114:
  pushl $0
801061a9:	6a 00                	push   $0x0
  pushl $114
801061ab:	6a 72                	push   $0x72
  jmp alltraps
801061ad:	e9 27 f7 ff ff       	jmp    801058d9 <alltraps>

801061b2 <vector115>:
.globl vector115
vector115:
  pushl $0
801061b2:	6a 00                	push   $0x0
  pushl $115
801061b4:	6a 73                	push   $0x73
  jmp alltraps
801061b6:	e9 1e f7 ff ff       	jmp    801058d9 <alltraps>

801061bb <vector116>:
.globl vector116
vector116:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $116
801061bd:	6a 74                	push   $0x74
  jmp alltraps
801061bf:	e9 15 f7 ff ff       	jmp    801058d9 <alltraps>

801061c4 <vector117>:
.globl vector117
vector117:
  pushl $0
801061c4:	6a 00                	push   $0x0
  pushl $117
801061c6:	6a 75                	push   $0x75
  jmp alltraps
801061c8:	e9 0c f7 ff ff       	jmp    801058d9 <alltraps>

801061cd <vector118>:
.globl vector118
vector118:
  pushl $0
801061cd:	6a 00                	push   $0x0
  pushl $118
801061cf:	6a 76                	push   $0x76
  jmp alltraps
801061d1:	e9 03 f7 ff ff       	jmp    801058d9 <alltraps>

801061d6 <vector119>:
.globl vector119
vector119:
  pushl $0
801061d6:	6a 00                	push   $0x0
  pushl $119
801061d8:	6a 77                	push   $0x77
  jmp alltraps
801061da:	e9 fa f6 ff ff       	jmp    801058d9 <alltraps>

801061df <vector120>:
.globl vector120
vector120:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $120
801061e1:	6a 78                	push   $0x78
  jmp alltraps
801061e3:	e9 f1 f6 ff ff       	jmp    801058d9 <alltraps>

801061e8 <vector121>:
.globl vector121
vector121:
  pushl $0
801061e8:	6a 00                	push   $0x0
  pushl $121
801061ea:	6a 79                	push   $0x79
  jmp alltraps
801061ec:	e9 e8 f6 ff ff       	jmp    801058d9 <alltraps>

801061f1 <vector122>:
.globl vector122
vector122:
  pushl $0
801061f1:	6a 00                	push   $0x0
  pushl $122
801061f3:	6a 7a                	push   $0x7a
  jmp alltraps
801061f5:	e9 df f6 ff ff       	jmp    801058d9 <alltraps>

801061fa <vector123>:
.globl vector123
vector123:
  pushl $0
801061fa:	6a 00                	push   $0x0
  pushl $123
801061fc:	6a 7b                	push   $0x7b
  jmp alltraps
801061fe:	e9 d6 f6 ff ff       	jmp    801058d9 <alltraps>

80106203 <vector124>:
.globl vector124
vector124:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $124
80106205:	6a 7c                	push   $0x7c
  jmp alltraps
80106207:	e9 cd f6 ff ff       	jmp    801058d9 <alltraps>

8010620c <vector125>:
.globl vector125
vector125:
  pushl $0
8010620c:	6a 00                	push   $0x0
  pushl $125
8010620e:	6a 7d                	push   $0x7d
  jmp alltraps
80106210:	e9 c4 f6 ff ff       	jmp    801058d9 <alltraps>

80106215 <vector126>:
.globl vector126
vector126:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $126
80106217:	6a 7e                	push   $0x7e
  jmp alltraps
80106219:	e9 bb f6 ff ff       	jmp    801058d9 <alltraps>

8010621e <vector127>:
.globl vector127
vector127:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $127
80106220:	6a 7f                	push   $0x7f
  jmp alltraps
80106222:	e9 b2 f6 ff ff       	jmp    801058d9 <alltraps>

80106227 <vector128>:
.globl vector128
vector128:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $128
80106229:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010622e:	e9 a6 f6 ff ff       	jmp    801058d9 <alltraps>

80106233 <vector129>:
.globl vector129
vector129:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $129
80106235:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010623a:	e9 9a f6 ff ff       	jmp    801058d9 <alltraps>

8010623f <vector130>:
.globl vector130
vector130:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $130
80106241:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106246:	e9 8e f6 ff ff       	jmp    801058d9 <alltraps>

8010624b <vector131>:
.globl vector131
vector131:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $131
8010624d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106252:	e9 82 f6 ff ff       	jmp    801058d9 <alltraps>

80106257 <vector132>:
.globl vector132
vector132:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $132
80106259:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010625e:	e9 76 f6 ff ff       	jmp    801058d9 <alltraps>

80106263 <vector133>:
.globl vector133
vector133:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $133
80106265:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010626a:	e9 6a f6 ff ff       	jmp    801058d9 <alltraps>

8010626f <vector134>:
.globl vector134
vector134:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $134
80106271:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106276:	e9 5e f6 ff ff       	jmp    801058d9 <alltraps>

8010627b <vector135>:
.globl vector135
vector135:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $135
8010627d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106282:	e9 52 f6 ff ff       	jmp    801058d9 <alltraps>

80106287 <vector136>:
.globl vector136
vector136:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $136
80106289:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010628e:	e9 46 f6 ff ff       	jmp    801058d9 <alltraps>

80106293 <vector137>:
.globl vector137
vector137:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $137
80106295:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010629a:	e9 3a f6 ff ff       	jmp    801058d9 <alltraps>

8010629f <vector138>:
.globl vector138
vector138:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $138
801062a1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062a6:	e9 2e f6 ff ff       	jmp    801058d9 <alltraps>

801062ab <vector139>:
.globl vector139
vector139:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $139
801062ad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801062b2:	e9 22 f6 ff ff       	jmp    801058d9 <alltraps>

801062b7 <vector140>:
.globl vector140
vector140:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $140
801062b9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801062be:	e9 16 f6 ff ff       	jmp    801058d9 <alltraps>

801062c3 <vector141>:
.globl vector141
vector141:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $141
801062c5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801062ca:	e9 0a f6 ff ff       	jmp    801058d9 <alltraps>

801062cf <vector142>:
.globl vector142
vector142:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $142
801062d1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801062d6:	e9 fe f5 ff ff       	jmp    801058d9 <alltraps>

801062db <vector143>:
.globl vector143
vector143:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $143
801062dd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801062e2:	e9 f2 f5 ff ff       	jmp    801058d9 <alltraps>

801062e7 <vector144>:
.globl vector144
vector144:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $144
801062e9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801062ee:	e9 e6 f5 ff ff       	jmp    801058d9 <alltraps>

801062f3 <vector145>:
.globl vector145
vector145:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $145
801062f5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801062fa:	e9 da f5 ff ff       	jmp    801058d9 <alltraps>

801062ff <vector146>:
.globl vector146
vector146:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $146
80106301:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106306:	e9 ce f5 ff ff       	jmp    801058d9 <alltraps>

8010630b <vector147>:
.globl vector147
vector147:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $147
8010630d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106312:	e9 c2 f5 ff ff       	jmp    801058d9 <alltraps>

80106317 <vector148>:
.globl vector148
vector148:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $148
80106319:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010631e:	e9 b6 f5 ff ff       	jmp    801058d9 <alltraps>

80106323 <vector149>:
.globl vector149
vector149:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $149
80106325:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010632a:	e9 aa f5 ff ff       	jmp    801058d9 <alltraps>

8010632f <vector150>:
.globl vector150
vector150:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $150
80106331:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106336:	e9 9e f5 ff ff       	jmp    801058d9 <alltraps>

8010633b <vector151>:
.globl vector151
vector151:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $151
8010633d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106342:	e9 92 f5 ff ff       	jmp    801058d9 <alltraps>

80106347 <vector152>:
.globl vector152
vector152:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $152
80106349:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010634e:	e9 86 f5 ff ff       	jmp    801058d9 <alltraps>

80106353 <vector153>:
.globl vector153
vector153:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $153
80106355:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010635a:	e9 7a f5 ff ff       	jmp    801058d9 <alltraps>

8010635f <vector154>:
.globl vector154
vector154:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $154
80106361:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106366:	e9 6e f5 ff ff       	jmp    801058d9 <alltraps>

8010636b <vector155>:
.globl vector155
vector155:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $155
8010636d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106372:	e9 62 f5 ff ff       	jmp    801058d9 <alltraps>

80106377 <vector156>:
.globl vector156
vector156:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $156
80106379:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010637e:	e9 56 f5 ff ff       	jmp    801058d9 <alltraps>

80106383 <vector157>:
.globl vector157
vector157:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $157
80106385:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010638a:	e9 4a f5 ff ff       	jmp    801058d9 <alltraps>

8010638f <vector158>:
.globl vector158
vector158:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $158
80106391:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106396:	e9 3e f5 ff ff       	jmp    801058d9 <alltraps>

8010639b <vector159>:
.globl vector159
vector159:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $159
8010639d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063a2:	e9 32 f5 ff ff       	jmp    801058d9 <alltraps>

801063a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $160
801063a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063ae:	e9 26 f5 ff ff       	jmp    801058d9 <alltraps>

801063b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $161
801063b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801063ba:	e9 1a f5 ff ff       	jmp    801058d9 <alltraps>

801063bf <vector162>:
.globl vector162
vector162:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $162
801063c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801063c6:	e9 0e f5 ff ff       	jmp    801058d9 <alltraps>

801063cb <vector163>:
.globl vector163
vector163:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $163
801063cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801063d2:	e9 02 f5 ff ff       	jmp    801058d9 <alltraps>

801063d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $164
801063d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801063de:	e9 f6 f4 ff ff       	jmp    801058d9 <alltraps>

801063e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $165
801063e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801063ea:	e9 ea f4 ff ff       	jmp    801058d9 <alltraps>

801063ef <vector166>:
.globl vector166
vector166:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $166
801063f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801063f6:	e9 de f4 ff ff       	jmp    801058d9 <alltraps>

801063fb <vector167>:
.globl vector167
vector167:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $167
801063fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106402:	e9 d2 f4 ff ff       	jmp    801058d9 <alltraps>

80106407 <vector168>:
.globl vector168
vector168:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $168
80106409:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010640e:	e9 c6 f4 ff ff       	jmp    801058d9 <alltraps>

80106413 <vector169>:
.globl vector169
vector169:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $169
80106415:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010641a:	e9 ba f4 ff ff       	jmp    801058d9 <alltraps>

8010641f <vector170>:
.globl vector170
vector170:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $170
80106421:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106426:	e9 ae f4 ff ff       	jmp    801058d9 <alltraps>

8010642b <vector171>:
.globl vector171
vector171:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $171
8010642d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106432:	e9 a2 f4 ff ff       	jmp    801058d9 <alltraps>

80106437 <vector172>:
.globl vector172
vector172:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $172
80106439:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010643e:	e9 96 f4 ff ff       	jmp    801058d9 <alltraps>

80106443 <vector173>:
.globl vector173
vector173:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $173
80106445:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010644a:	e9 8a f4 ff ff       	jmp    801058d9 <alltraps>

8010644f <vector174>:
.globl vector174
vector174:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $174
80106451:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106456:	e9 7e f4 ff ff       	jmp    801058d9 <alltraps>

8010645b <vector175>:
.globl vector175
vector175:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $175
8010645d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106462:	e9 72 f4 ff ff       	jmp    801058d9 <alltraps>

80106467 <vector176>:
.globl vector176
vector176:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $176
80106469:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010646e:	e9 66 f4 ff ff       	jmp    801058d9 <alltraps>

80106473 <vector177>:
.globl vector177
vector177:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $177
80106475:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010647a:	e9 5a f4 ff ff       	jmp    801058d9 <alltraps>

8010647f <vector178>:
.globl vector178
vector178:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $178
80106481:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106486:	e9 4e f4 ff ff       	jmp    801058d9 <alltraps>

8010648b <vector179>:
.globl vector179
vector179:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $179
8010648d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106492:	e9 42 f4 ff ff       	jmp    801058d9 <alltraps>

80106497 <vector180>:
.globl vector180
vector180:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $180
80106499:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010649e:	e9 36 f4 ff ff       	jmp    801058d9 <alltraps>

801064a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $181
801064a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064aa:	e9 2a f4 ff ff       	jmp    801058d9 <alltraps>

801064af <vector182>:
.globl vector182
vector182:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $182
801064b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801064b6:	e9 1e f4 ff ff       	jmp    801058d9 <alltraps>

801064bb <vector183>:
.globl vector183
vector183:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $183
801064bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801064c2:	e9 12 f4 ff ff       	jmp    801058d9 <alltraps>

801064c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $184
801064c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801064ce:	e9 06 f4 ff ff       	jmp    801058d9 <alltraps>

801064d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $185
801064d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801064da:	e9 fa f3 ff ff       	jmp    801058d9 <alltraps>

801064df <vector186>:
.globl vector186
vector186:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $186
801064e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801064e6:	e9 ee f3 ff ff       	jmp    801058d9 <alltraps>

801064eb <vector187>:
.globl vector187
vector187:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $187
801064ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801064f2:	e9 e2 f3 ff ff       	jmp    801058d9 <alltraps>

801064f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $188
801064f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801064fe:	e9 d6 f3 ff ff       	jmp    801058d9 <alltraps>

80106503 <vector189>:
.globl vector189
vector189:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $189
80106505:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010650a:	e9 ca f3 ff ff       	jmp    801058d9 <alltraps>

8010650f <vector190>:
.globl vector190
vector190:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $190
80106511:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106516:	e9 be f3 ff ff       	jmp    801058d9 <alltraps>

8010651b <vector191>:
.globl vector191
vector191:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $191
8010651d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106522:	e9 b2 f3 ff ff       	jmp    801058d9 <alltraps>

80106527 <vector192>:
.globl vector192
vector192:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $192
80106529:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010652e:	e9 a6 f3 ff ff       	jmp    801058d9 <alltraps>

80106533 <vector193>:
.globl vector193
vector193:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $193
80106535:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010653a:	e9 9a f3 ff ff       	jmp    801058d9 <alltraps>

8010653f <vector194>:
.globl vector194
vector194:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $194
80106541:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106546:	e9 8e f3 ff ff       	jmp    801058d9 <alltraps>

8010654b <vector195>:
.globl vector195
vector195:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $195
8010654d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106552:	e9 82 f3 ff ff       	jmp    801058d9 <alltraps>

80106557 <vector196>:
.globl vector196
vector196:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $196
80106559:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010655e:	e9 76 f3 ff ff       	jmp    801058d9 <alltraps>

80106563 <vector197>:
.globl vector197
vector197:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $197
80106565:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010656a:	e9 6a f3 ff ff       	jmp    801058d9 <alltraps>

8010656f <vector198>:
.globl vector198
vector198:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $198
80106571:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106576:	e9 5e f3 ff ff       	jmp    801058d9 <alltraps>

8010657b <vector199>:
.globl vector199
vector199:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $199
8010657d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106582:	e9 52 f3 ff ff       	jmp    801058d9 <alltraps>

80106587 <vector200>:
.globl vector200
vector200:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $200
80106589:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010658e:	e9 46 f3 ff ff       	jmp    801058d9 <alltraps>

80106593 <vector201>:
.globl vector201
vector201:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $201
80106595:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010659a:	e9 3a f3 ff ff       	jmp    801058d9 <alltraps>

8010659f <vector202>:
.globl vector202
vector202:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $202
801065a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065a6:	e9 2e f3 ff ff       	jmp    801058d9 <alltraps>

801065ab <vector203>:
.globl vector203
vector203:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $203
801065ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801065b2:	e9 22 f3 ff ff       	jmp    801058d9 <alltraps>

801065b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $204
801065b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801065be:	e9 16 f3 ff ff       	jmp    801058d9 <alltraps>

801065c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $205
801065c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801065ca:	e9 0a f3 ff ff       	jmp    801058d9 <alltraps>

801065cf <vector206>:
.globl vector206
vector206:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $206
801065d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801065d6:	e9 fe f2 ff ff       	jmp    801058d9 <alltraps>

801065db <vector207>:
.globl vector207
vector207:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $207
801065dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801065e2:	e9 f2 f2 ff ff       	jmp    801058d9 <alltraps>

801065e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $208
801065e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801065ee:	e9 e6 f2 ff ff       	jmp    801058d9 <alltraps>

801065f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $209
801065f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801065fa:	e9 da f2 ff ff       	jmp    801058d9 <alltraps>

801065ff <vector210>:
.globl vector210
vector210:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $210
80106601:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106606:	e9 ce f2 ff ff       	jmp    801058d9 <alltraps>

8010660b <vector211>:
.globl vector211
vector211:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $211
8010660d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106612:	e9 c2 f2 ff ff       	jmp    801058d9 <alltraps>

80106617 <vector212>:
.globl vector212
vector212:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $212
80106619:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010661e:	e9 b6 f2 ff ff       	jmp    801058d9 <alltraps>

80106623 <vector213>:
.globl vector213
vector213:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $213
80106625:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010662a:	e9 aa f2 ff ff       	jmp    801058d9 <alltraps>

8010662f <vector214>:
.globl vector214
vector214:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $214
80106631:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106636:	e9 9e f2 ff ff       	jmp    801058d9 <alltraps>

8010663b <vector215>:
.globl vector215
vector215:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $215
8010663d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106642:	e9 92 f2 ff ff       	jmp    801058d9 <alltraps>

80106647 <vector216>:
.globl vector216
vector216:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $216
80106649:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010664e:	e9 86 f2 ff ff       	jmp    801058d9 <alltraps>

80106653 <vector217>:
.globl vector217
vector217:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $217
80106655:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010665a:	e9 7a f2 ff ff       	jmp    801058d9 <alltraps>

8010665f <vector218>:
.globl vector218
vector218:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $218
80106661:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106666:	e9 6e f2 ff ff       	jmp    801058d9 <alltraps>

8010666b <vector219>:
.globl vector219
vector219:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $219
8010666d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106672:	e9 62 f2 ff ff       	jmp    801058d9 <alltraps>

80106677 <vector220>:
.globl vector220
vector220:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $220
80106679:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010667e:	e9 56 f2 ff ff       	jmp    801058d9 <alltraps>

80106683 <vector221>:
.globl vector221
vector221:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $221
80106685:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010668a:	e9 4a f2 ff ff       	jmp    801058d9 <alltraps>

8010668f <vector222>:
.globl vector222
vector222:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $222
80106691:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106696:	e9 3e f2 ff ff       	jmp    801058d9 <alltraps>

8010669b <vector223>:
.globl vector223
vector223:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $223
8010669d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066a2:	e9 32 f2 ff ff       	jmp    801058d9 <alltraps>

801066a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $224
801066a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066ae:	e9 26 f2 ff ff       	jmp    801058d9 <alltraps>

801066b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $225
801066b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801066ba:	e9 1a f2 ff ff       	jmp    801058d9 <alltraps>

801066bf <vector226>:
.globl vector226
vector226:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $226
801066c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801066c6:	e9 0e f2 ff ff       	jmp    801058d9 <alltraps>

801066cb <vector227>:
.globl vector227
vector227:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $227
801066cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801066d2:	e9 02 f2 ff ff       	jmp    801058d9 <alltraps>

801066d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $228
801066d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801066de:	e9 f6 f1 ff ff       	jmp    801058d9 <alltraps>

801066e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $229
801066e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801066ea:	e9 ea f1 ff ff       	jmp    801058d9 <alltraps>

801066ef <vector230>:
.globl vector230
vector230:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $230
801066f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801066f6:	e9 de f1 ff ff       	jmp    801058d9 <alltraps>

801066fb <vector231>:
.globl vector231
vector231:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $231
801066fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106702:	e9 d2 f1 ff ff       	jmp    801058d9 <alltraps>

80106707 <vector232>:
.globl vector232
vector232:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $232
80106709:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010670e:	e9 c6 f1 ff ff       	jmp    801058d9 <alltraps>

80106713 <vector233>:
.globl vector233
vector233:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $233
80106715:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010671a:	e9 ba f1 ff ff       	jmp    801058d9 <alltraps>

8010671f <vector234>:
.globl vector234
vector234:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $234
80106721:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106726:	e9 ae f1 ff ff       	jmp    801058d9 <alltraps>

8010672b <vector235>:
.globl vector235
vector235:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $235
8010672d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106732:	e9 a2 f1 ff ff       	jmp    801058d9 <alltraps>

80106737 <vector236>:
.globl vector236
vector236:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $236
80106739:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010673e:	e9 96 f1 ff ff       	jmp    801058d9 <alltraps>

80106743 <vector237>:
.globl vector237
vector237:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $237
80106745:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010674a:	e9 8a f1 ff ff       	jmp    801058d9 <alltraps>

8010674f <vector238>:
.globl vector238
vector238:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $238
80106751:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106756:	e9 7e f1 ff ff       	jmp    801058d9 <alltraps>

8010675b <vector239>:
.globl vector239
vector239:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $239
8010675d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106762:	e9 72 f1 ff ff       	jmp    801058d9 <alltraps>

80106767 <vector240>:
.globl vector240
vector240:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $240
80106769:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010676e:	e9 66 f1 ff ff       	jmp    801058d9 <alltraps>

80106773 <vector241>:
.globl vector241
vector241:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $241
80106775:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010677a:	e9 5a f1 ff ff       	jmp    801058d9 <alltraps>

8010677f <vector242>:
.globl vector242
vector242:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $242
80106781:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106786:	e9 4e f1 ff ff       	jmp    801058d9 <alltraps>

8010678b <vector243>:
.globl vector243
vector243:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $243
8010678d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106792:	e9 42 f1 ff ff       	jmp    801058d9 <alltraps>

80106797 <vector244>:
.globl vector244
vector244:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $244
80106799:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010679e:	e9 36 f1 ff ff       	jmp    801058d9 <alltraps>

801067a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $245
801067a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067aa:	e9 2a f1 ff ff       	jmp    801058d9 <alltraps>

801067af <vector246>:
.globl vector246
vector246:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $246
801067b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801067b6:	e9 1e f1 ff ff       	jmp    801058d9 <alltraps>

801067bb <vector247>:
.globl vector247
vector247:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $247
801067bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801067c2:	e9 12 f1 ff ff       	jmp    801058d9 <alltraps>

801067c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $248
801067c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801067ce:	e9 06 f1 ff ff       	jmp    801058d9 <alltraps>

801067d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $249
801067d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801067da:	e9 fa f0 ff ff       	jmp    801058d9 <alltraps>

801067df <vector250>:
.globl vector250
vector250:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $250
801067e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801067e6:	e9 ee f0 ff ff       	jmp    801058d9 <alltraps>

801067eb <vector251>:
.globl vector251
vector251:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $251
801067ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801067f2:	e9 e2 f0 ff ff       	jmp    801058d9 <alltraps>

801067f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $252
801067f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801067fe:	e9 d6 f0 ff ff       	jmp    801058d9 <alltraps>

80106803 <vector253>:
.globl vector253
vector253:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $253
80106805:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010680a:	e9 ca f0 ff ff       	jmp    801058d9 <alltraps>

8010680f <vector254>:
.globl vector254
vector254:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $254
80106811:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106816:	e9 be f0 ff ff       	jmp    801058d9 <alltraps>

8010681b <vector255>:
.globl vector255
vector255:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $255
8010681d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106822:	e9 b2 f0 ff ff       	jmp    801058d9 <alltraps>
80106827:	66 90                	xchg   %ax,%ax
80106829:	66 90                	xchg   %ax,%ax
8010682b:	66 90                	xchg   %ax,%ax
8010682d:	66 90                	xchg   %ax,%ax
8010682f:	90                   	nop

80106830 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	57                   	push   %edi
80106834:	56                   	push   %esi
80106835:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106836:	89 d3                	mov    %edx,%ebx
{
80106838:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010683a:	c1 eb 16             	shr    $0x16,%ebx
8010683d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106840:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106843:	8b 06                	mov    (%esi),%eax
80106845:	a8 01                	test   $0x1,%al
80106847:	74 27                	je     80106870 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106849:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010684e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106854:	c1 ef 0a             	shr    $0xa,%edi
}
80106857:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010685a:	89 fa                	mov    %edi,%edx
8010685c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106862:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106865:	5b                   	pop    %ebx
80106866:	5e                   	pop    %esi
80106867:	5f                   	pop    %edi
80106868:	5d                   	pop    %ebp
80106869:	c3                   	ret    
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106870:	85 c9                	test   %ecx,%ecx
80106872:	74 2c                	je     801068a0 <walkpgdir+0x70>
80106874:	e8 b7 bc ff ff       	call   80102530 <kalloc>
80106879:	85 c0                	test   %eax,%eax
8010687b:	89 c3                	mov    %eax,%ebx
8010687d:	74 21                	je     801068a0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010687f:	83 ec 04             	sub    $0x4,%esp
80106882:	68 00 10 00 00       	push   $0x1000
80106887:	6a 00                	push   $0x0
80106889:	50                   	push   %eax
8010688a:	e8 01 de ff ff       	call   80104690 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010688f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106895:	83 c4 10             	add    $0x10,%esp
80106898:	83 c8 07             	or     $0x7,%eax
8010689b:	89 06                	mov    %eax,(%esi)
8010689d:	eb b5                	jmp    80106854 <walkpgdir+0x24>
8010689f:	90                   	nop
}
801068a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801068a3:	31 c0                	xor    %eax,%eax
}
801068a5:	5b                   	pop    %ebx
801068a6:	5e                   	pop    %esi
801068a7:	5f                   	pop    %edi
801068a8:	5d                   	pop    %ebp
801068a9:	c3                   	ret    
801068aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801068b0:	55                   	push   %ebp
801068b1:	89 e5                	mov    %esp,%ebp
801068b3:	57                   	push   %edi
801068b4:	56                   	push   %esi
801068b5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801068b6:	89 d3                	mov    %edx,%ebx
801068b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801068be:	83 ec 1c             	sub    $0x1c,%esp
801068c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801068c4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801068c8:	8b 7d 08             	mov    0x8(%ebp),%edi
801068cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801068d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801068d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801068d6:	29 df                	sub    %ebx,%edi
801068d8:	83 c8 01             	or     $0x1,%eax
801068db:	89 45 dc             	mov    %eax,-0x24(%ebp)
801068de:	eb 15                	jmp    801068f5 <mappages+0x45>
    if(*pte & PTE_P)
801068e0:	f6 00 01             	testb  $0x1,(%eax)
801068e3:	75 45                	jne    8010692a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801068e5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801068e8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801068eb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801068ed:	74 31                	je     80106920 <mappages+0x70>
      break;
    a += PGSIZE;
801068ef:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068f8:	b9 01 00 00 00       	mov    $0x1,%ecx
801068fd:	89 da                	mov    %ebx,%edx
801068ff:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106902:	e8 29 ff ff ff       	call   80106830 <walkpgdir>
80106907:	85 c0                	test   %eax,%eax
80106909:	75 d5                	jne    801068e0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010690b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010690e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106913:	5b                   	pop    %ebx
80106914:	5e                   	pop    %esi
80106915:	5f                   	pop    %edi
80106916:	5d                   	pop    %ebp
80106917:	c3                   	ret    
80106918:	90                   	nop
80106919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106920:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106923:	31 c0                	xor    %eax,%eax
}
80106925:	5b                   	pop    %ebx
80106926:	5e                   	pop    %esi
80106927:	5f                   	pop    %edi
80106928:	5d                   	pop    %ebp
80106929:	c3                   	ret    
      panic("remap");
8010692a:	83 ec 0c             	sub    $0xc,%esp
8010692d:	68 54 7b 10 80       	push   $0x80107b54
80106932:	e8 59 9a ff ff       	call   80100390 <panic>
80106937:	89 f6                	mov    %esi,%esi
80106939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106940 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106946:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010694c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010694e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106954:	83 ec 1c             	sub    $0x1c,%esp
80106957:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010695a:	39 d3                	cmp    %edx,%ebx
8010695c:	73 66                	jae    801069c4 <deallocuvm.part.0+0x84>
8010695e:	89 d6                	mov    %edx,%esi
80106960:	eb 3d                	jmp    8010699f <deallocuvm.part.0+0x5f>
80106962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106968:	8b 10                	mov    (%eax),%edx
8010696a:	f6 c2 01             	test   $0x1,%dl
8010696d:	74 26                	je     80106995 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010696f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106975:	74 58                	je     801069cf <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106977:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010697a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106980:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106983:	52                   	push   %edx
80106984:	e8 f7 b9 ff ff       	call   80102380 <kfree>
      *pte = 0;
80106989:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010698c:	83 c4 10             	add    $0x10,%esp
8010698f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106995:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010699b:	39 f3                	cmp    %esi,%ebx
8010699d:	73 25                	jae    801069c4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010699f:	31 c9                	xor    %ecx,%ecx
801069a1:	89 da                	mov    %ebx,%edx
801069a3:	89 f8                	mov    %edi,%eax
801069a5:	e8 86 fe ff ff       	call   80106830 <walkpgdir>
    if(!pte)
801069aa:	85 c0                	test   %eax,%eax
801069ac:	75 ba                	jne    80106968 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069ae:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801069b4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801069ba:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069c0:	39 f3                	cmp    %esi,%ebx
801069c2:	72 db                	jb     8010699f <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
801069c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801069c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069ca:	5b                   	pop    %ebx
801069cb:	5e                   	pop    %esi
801069cc:	5f                   	pop    %edi
801069cd:	5d                   	pop    %ebp
801069ce:	c3                   	ret    
        panic("kfree");
801069cf:	83 ec 0c             	sub    $0xc,%esp
801069d2:	68 6e 74 10 80       	push   $0x8010746e
801069d7:	e8 b4 99 ff ff       	call   80100390 <panic>
801069dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069e0 <seginit>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801069e6:	e8 85 ce ff ff       	call   80103870 <cpuid>
801069eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801069f1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801069f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069fa:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106a01:	ff 00 00 
80106a04:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106a0b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a0e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106a15:	ff 00 00 
80106a18:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106a1f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a22:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106a29:	ff 00 00 
80106a2c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106a33:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a36:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106a3d:	ff 00 00 
80106a40:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106a47:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a4a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106a4f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106a53:	c1 e8 10             	shr    $0x10,%eax
80106a56:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106a5a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a5d:	0f 01 10             	lgdtl  (%eax)
}
80106a60:	c9                   	leave  
80106a61:	c3                   	ret    
80106a62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a70 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a70:	a1 a4 5c 11 80       	mov    0x80115ca4,%eax
{
80106a75:	55                   	push   %ebp
80106a76:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106a78:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a7d:	0f 22 d8             	mov    %eax,%cr3
}
80106a80:	5d                   	pop    %ebp
80106a81:	c3                   	ret    
80106a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a90 <switchuvm>:
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	56                   	push   %esi
80106a95:	53                   	push   %ebx
80106a96:	83 ec 1c             	sub    $0x1c,%esp
80106a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106a9c:	85 db                	test   %ebx,%ebx
80106a9e:	0f 84 cb 00 00 00    	je     80106b6f <switchuvm+0xdf>
  if(p->kstack == 0)
80106aa4:	8b 43 08             	mov    0x8(%ebx),%eax
80106aa7:	85 c0                	test   %eax,%eax
80106aa9:	0f 84 da 00 00 00    	je     80106b89 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106aaf:	8b 43 04             	mov    0x4(%ebx),%eax
80106ab2:	85 c0                	test   %eax,%eax
80106ab4:	0f 84 c2 00 00 00    	je     80106b7c <switchuvm+0xec>
  pushcli();
80106aba:	e8 11 da ff ff       	call   801044d0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106abf:	e8 2c cd ff ff       	call   801037f0 <mycpu>
80106ac4:	89 c6                	mov    %eax,%esi
80106ac6:	e8 25 cd ff ff       	call   801037f0 <mycpu>
80106acb:	89 c7                	mov    %eax,%edi
80106acd:	e8 1e cd ff ff       	call   801037f0 <mycpu>
80106ad2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ad5:	83 c7 08             	add    $0x8,%edi
80106ad8:	e8 13 cd ff ff       	call   801037f0 <mycpu>
80106add:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106ae0:	83 c0 08             	add    $0x8,%eax
80106ae3:	ba 67 00 00 00       	mov    $0x67,%edx
80106ae8:	c1 e8 18             	shr    $0x18,%eax
80106aeb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106af2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106af9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106aff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b04:	83 c1 08             	add    $0x8,%ecx
80106b07:	c1 e9 10             	shr    $0x10,%ecx
80106b0a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106b10:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b15:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b1c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106b21:	e8 ca cc ff ff       	call   801037f0 <mycpu>
80106b26:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b2d:	e8 be cc ff ff       	call   801037f0 <mycpu>
80106b32:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b36:	8b 73 08             	mov    0x8(%ebx),%esi
80106b39:	e8 b2 cc ff ff       	call   801037f0 <mycpu>
80106b3e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106b44:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b47:	e8 a4 cc ff ff       	call   801037f0 <mycpu>
80106b4c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b50:	b8 28 00 00 00       	mov    $0x28,%eax
80106b55:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b58:	8b 43 04             	mov    0x4(%ebx),%eax
80106b5b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b60:	0f 22 d8             	mov    %eax,%cr3
}
80106b63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b66:	5b                   	pop    %ebx
80106b67:	5e                   	pop    %esi
80106b68:	5f                   	pop    %edi
80106b69:	5d                   	pop    %ebp
  popcli();
80106b6a:	e9 61 da ff ff       	jmp    801045d0 <popcli>
    panic("switchuvm: no process");
80106b6f:	83 ec 0c             	sub    $0xc,%esp
80106b72:	68 5a 7b 10 80       	push   $0x80107b5a
80106b77:	e8 14 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106b7c:	83 ec 0c             	sub    $0xc,%esp
80106b7f:	68 85 7b 10 80       	push   $0x80107b85
80106b84:	e8 07 98 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106b89:	83 ec 0c             	sub    $0xc,%esp
80106b8c:	68 70 7b 10 80       	push   $0x80107b70
80106b91:	e8 fa 97 ff ff       	call   80100390 <panic>
80106b96:	8d 76 00             	lea    0x0(%esi),%esi
80106b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ba0 <inituvm>:
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
80106ba6:	83 ec 1c             	sub    $0x1c,%esp
80106ba9:	8b 75 10             	mov    0x10(%ebp),%esi
80106bac:	8b 45 08             	mov    0x8(%ebp),%eax
80106baf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106bb2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106bb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106bbb:	77 49                	ja     80106c06 <inituvm+0x66>
  mem = kalloc();
80106bbd:	e8 6e b9 ff ff       	call   80102530 <kalloc>
  memset(mem, 0, PGSIZE);
80106bc2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106bc5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106bc7:	68 00 10 00 00       	push   $0x1000
80106bcc:	6a 00                	push   $0x0
80106bce:	50                   	push   %eax
80106bcf:	e8 bc da ff ff       	call   80104690 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106bd4:	58                   	pop    %eax
80106bd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bdb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106be0:	5a                   	pop    %edx
80106be1:	6a 06                	push   $0x6
80106be3:	50                   	push   %eax
80106be4:	31 d2                	xor    %edx,%edx
80106be6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106be9:	e8 c2 fc ff ff       	call   801068b0 <mappages>
  memmove(mem, init, sz);
80106bee:	89 75 10             	mov    %esi,0x10(%ebp)
80106bf1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106bf4:	83 c4 10             	add    $0x10,%esp
80106bf7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bfd:	5b                   	pop    %ebx
80106bfe:	5e                   	pop    %esi
80106bff:	5f                   	pop    %edi
80106c00:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c01:	e9 3a db ff ff       	jmp    80104740 <memmove>
    panic("inituvm: more than a page");
80106c06:	83 ec 0c             	sub    $0xc,%esp
80106c09:	68 99 7b 10 80       	push   $0x80107b99
80106c0e:	e8 7d 97 ff ff       	call   80100390 <panic>
80106c13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c20 <loaduvm>:
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106c29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106c30:	0f 85 91 00 00 00    	jne    80106cc7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106c36:	8b 75 18             	mov    0x18(%ebp),%esi
80106c39:	31 db                	xor    %ebx,%ebx
80106c3b:	85 f6                	test   %esi,%esi
80106c3d:	75 1a                	jne    80106c59 <loaduvm+0x39>
80106c3f:	eb 6f                	jmp    80106cb0 <loaduvm+0x90>
80106c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106c54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106c57:	76 57                	jbe    80106cb0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c59:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5f:	31 c9                	xor    %ecx,%ecx
80106c61:	01 da                	add    %ebx,%edx
80106c63:	e8 c8 fb ff ff       	call   80106830 <walkpgdir>
80106c68:	85 c0                	test   %eax,%eax
80106c6a:	74 4e                	je     80106cba <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106c6c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106c71:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106c76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106c7b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c81:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c84:	01 d9                	add    %ebx,%ecx
80106c86:	05 00 00 00 80       	add    $0x80000000,%eax
80106c8b:	57                   	push   %edi
80106c8c:	51                   	push   %ecx
80106c8d:	50                   	push   %eax
80106c8e:	ff 75 10             	pushl  0x10(%ebp)
80106c91:	e8 da ac ff ff       	call   80101970 <readi>
80106c96:	83 c4 10             	add    $0x10,%esp
80106c99:	39 f8                	cmp    %edi,%eax
80106c9b:	74 ab                	je     80106c48 <loaduvm+0x28>
}
80106c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ca5:	5b                   	pop    %ebx
80106ca6:	5e                   	pop    %esi
80106ca7:	5f                   	pop    %edi
80106ca8:	5d                   	pop    %ebp
80106ca9:	c3                   	ret    
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cb3:	31 c0                	xor    %eax,%eax
}
80106cb5:	5b                   	pop    %ebx
80106cb6:	5e                   	pop    %esi
80106cb7:	5f                   	pop    %edi
80106cb8:	5d                   	pop    %ebp
80106cb9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106cba:	83 ec 0c             	sub    $0xc,%esp
80106cbd:	68 b3 7b 10 80       	push   $0x80107bb3
80106cc2:	e8 c9 96 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106cc7:	83 ec 0c             	sub    $0xc,%esp
80106cca:	68 54 7c 10 80       	push   $0x80107c54
80106ccf:	e8 bc 96 ff ff       	call   80100390 <panic>
80106cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ce0 <allocuvm>:
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106ce9:	8b 7d 10             	mov    0x10(%ebp),%edi
80106cec:	85 ff                	test   %edi,%edi
80106cee:	0f 88 8e 00 00 00    	js     80106d82 <allocuvm+0xa2>
  if(newsz < oldsz)
80106cf4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cf7:	0f 82 93 00 00 00    	jb     80106d90 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d00:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d06:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106d0c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d0f:	0f 86 7e 00 00 00    	jbe    80106d93 <allocuvm+0xb3>
80106d15:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106d18:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d1b:	eb 42                	jmp    80106d5f <allocuvm+0x7f>
80106d1d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106d20:	83 ec 04             	sub    $0x4,%esp
80106d23:	68 00 10 00 00       	push   $0x1000
80106d28:	6a 00                	push   $0x0
80106d2a:	50                   	push   %eax
80106d2b:	e8 60 d9 ff ff       	call   80104690 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d30:	58                   	pop    %eax
80106d31:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d37:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d3c:	5a                   	pop    %edx
80106d3d:	6a 06                	push   $0x6
80106d3f:	50                   	push   %eax
80106d40:	89 da                	mov    %ebx,%edx
80106d42:	89 f8                	mov    %edi,%eax
80106d44:	e8 67 fb ff ff       	call   801068b0 <mappages>
80106d49:	83 c4 10             	add    $0x10,%esp
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	78 50                	js     80106da0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106d50:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d56:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106d59:	0f 86 81 00 00 00    	jbe    80106de0 <allocuvm+0x100>
    mem = kalloc();
80106d5f:	e8 cc b7 ff ff       	call   80102530 <kalloc>
    if(mem == 0){
80106d64:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106d66:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106d68:	75 b6                	jne    80106d20 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106d6a:	83 ec 0c             	sub    $0xc,%esp
80106d6d:	68 d1 7b 10 80       	push   $0x80107bd1
80106d72:	e8 e9 98 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106d77:	83 c4 10             	add    $0x10,%esp
80106d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d7d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106d80:	77 6e                	ja     80106df0 <allocuvm+0x110>
}
80106d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106d85:	31 ff                	xor    %edi,%edi
}
80106d87:	89 f8                	mov    %edi,%eax
80106d89:	5b                   	pop    %ebx
80106d8a:	5e                   	pop    %esi
80106d8b:	5f                   	pop    %edi
80106d8c:	5d                   	pop    %ebp
80106d8d:	c3                   	ret    
80106d8e:	66 90                	xchg   %ax,%ax
    return oldsz;
80106d90:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d96:	89 f8                	mov    %edi,%eax
80106d98:	5b                   	pop    %ebx
80106d99:	5e                   	pop    %esi
80106d9a:	5f                   	pop    %edi
80106d9b:	5d                   	pop    %ebp
80106d9c:	c3                   	ret    
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106da0:	83 ec 0c             	sub    $0xc,%esp
80106da3:	68 e9 7b 10 80       	push   $0x80107be9
80106da8:	e8 b3 98 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106dad:	83 c4 10             	add    $0x10,%esp
80106db0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106db3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106db6:	76 0d                	jbe    80106dc5 <allocuvm+0xe5>
80106db8:	89 c1                	mov    %eax,%ecx
80106dba:	8b 55 10             	mov    0x10(%ebp),%edx
80106dbd:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc0:	e8 7b fb ff ff       	call   80106940 <deallocuvm.part.0>
      kfree(mem);
80106dc5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106dc8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106dca:	56                   	push   %esi
80106dcb:	e8 b0 b5 ff ff       	call   80102380 <kfree>
      return 0;
80106dd0:	83 c4 10             	add    $0x10,%esp
}
80106dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dd6:	89 f8                	mov    %edi,%eax
80106dd8:	5b                   	pop    %ebx
80106dd9:	5e                   	pop    %esi
80106dda:	5f                   	pop    %edi
80106ddb:	5d                   	pop    %ebp
80106ddc:	c3                   	ret    
80106ddd:	8d 76 00             	lea    0x0(%esi),%esi
80106de0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106de3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de6:	5b                   	pop    %ebx
80106de7:	89 f8                	mov    %edi,%eax
80106de9:	5e                   	pop    %esi
80106dea:	5f                   	pop    %edi
80106deb:	5d                   	pop    %ebp
80106dec:	c3                   	ret    
80106ded:	8d 76 00             	lea    0x0(%esi),%esi
80106df0:	89 c1                	mov    %eax,%ecx
80106df2:	8b 55 10             	mov    0x10(%ebp),%edx
80106df5:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106df8:	31 ff                	xor    %edi,%edi
80106dfa:	e8 41 fb ff ff       	call   80106940 <deallocuvm.part.0>
80106dff:	eb 92                	jmp    80106d93 <allocuvm+0xb3>
80106e01:	eb 0d                	jmp    80106e10 <deallocuvm>
80106e03:	90                   	nop
80106e04:	90                   	nop
80106e05:	90                   	nop
80106e06:	90                   	nop
80106e07:	90                   	nop
80106e08:	90                   	nop
80106e09:	90                   	nop
80106e0a:	90                   	nop
80106e0b:	90                   	nop
80106e0c:	90                   	nop
80106e0d:	90                   	nop
80106e0e:	90                   	nop
80106e0f:	90                   	nop

80106e10 <deallocuvm>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e1c:	39 d1                	cmp    %edx,%ecx
80106e1e:	73 10                	jae    80106e30 <deallocuvm+0x20>
}
80106e20:	5d                   	pop    %ebp
80106e21:	e9 1a fb ff ff       	jmp    80106940 <deallocuvm.part.0>
80106e26:	8d 76 00             	lea    0x0(%esi),%esi
80106e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e30:	89 d0                	mov    %edx,%eax
80106e32:	5d                   	pop    %ebp
80106e33:	c3                   	ret    
80106e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 0c             	sub    $0xc,%esp
80106e49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e4c:	85 f6                	test   %esi,%esi
80106e4e:	74 59                	je     80106ea9 <freevm+0x69>
80106e50:	31 c9                	xor    %ecx,%ecx
80106e52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e57:	89 f0                	mov    %esi,%eax
80106e59:	e8 e2 fa ff ff       	call   80106940 <deallocuvm.part.0>
80106e5e:	89 f3                	mov    %esi,%ebx
80106e60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e66:	eb 0f                	jmp    80106e77 <freevm+0x37>
80106e68:	90                   	nop
80106e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e70:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e73:	39 fb                	cmp    %edi,%ebx
80106e75:	74 23                	je     80106e9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e77:	8b 03                	mov    (%ebx),%eax
80106e79:	a8 01                	test   $0x1,%al
80106e7b:	74 f3                	je     80106e70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106e82:	83 ec 0c             	sub    $0xc,%esp
80106e85:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106e88:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106e8d:	50                   	push   %eax
80106e8e:	e8 ed b4 ff ff       	call   80102380 <kfree>
80106e93:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106e96:	39 fb                	cmp    %edi,%ebx
80106e98:	75 dd                	jne    80106e77 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106e9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ea0:	5b                   	pop    %ebx
80106ea1:	5e                   	pop    %esi
80106ea2:	5f                   	pop    %edi
80106ea3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106ea4:	e9 d7 b4 ff ff       	jmp    80102380 <kfree>
    panic("freevm: no pgdir");
80106ea9:	83 ec 0c             	sub    $0xc,%esp
80106eac:	68 05 7c 10 80       	push   $0x80107c05
80106eb1:	e8 da 94 ff ff       	call   80100390 <panic>
80106eb6:	8d 76 00             	lea    0x0(%esi),%esi
80106eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ec0 <setupkvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	56                   	push   %esi
80106ec4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ec5:	e8 66 b6 ff ff       	call   80102530 <kalloc>
80106eca:	85 c0                	test   %eax,%eax
80106ecc:	89 c6                	mov    %eax,%esi
80106ece:	74 42                	je     80106f12 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106ed0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106ed3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106ed8:	68 00 10 00 00       	push   $0x1000
80106edd:	6a 00                	push   $0x0
80106edf:	50                   	push   %eax
80106ee0:	e8 ab d7 ff ff       	call   80104690 <memset>
80106ee5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106ee8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106eeb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106eee:	83 ec 08             	sub    $0x8,%esp
80106ef1:	8b 13                	mov    (%ebx),%edx
80106ef3:	ff 73 0c             	pushl  0xc(%ebx)
80106ef6:	50                   	push   %eax
80106ef7:	29 c1                	sub    %eax,%ecx
80106ef9:	89 f0                	mov    %esi,%eax
80106efb:	e8 b0 f9 ff ff       	call   801068b0 <mappages>
80106f00:	83 c4 10             	add    $0x10,%esp
80106f03:	85 c0                	test   %eax,%eax
80106f05:	78 19                	js     80106f20 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f07:	83 c3 10             	add    $0x10,%ebx
80106f0a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f10:	75 d6                	jne    80106ee8 <setupkvm+0x28>
}
80106f12:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f15:	89 f0                	mov    %esi,%eax
80106f17:	5b                   	pop    %ebx
80106f18:	5e                   	pop    %esi
80106f19:	5d                   	pop    %ebp
80106f1a:	c3                   	ret    
80106f1b:	90                   	nop
80106f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106f20:	83 ec 0c             	sub    $0xc,%esp
80106f23:	56                   	push   %esi
      return 0;
80106f24:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106f26:	e8 15 ff ff ff       	call   80106e40 <freevm>
      return 0;
80106f2b:	83 c4 10             	add    $0x10,%esp
}
80106f2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f31:	89 f0                	mov    %esi,%eax
80106f33:	5b                   	pop    %ebx
80106f34:	5e                   	pop    %esi
80106f35:	5d                   	pop    %ebp
80106f36:	c3                   	ret    
80106f37:	89 f6                	mov    %esi,%esi
80106f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f40 <kvmalloc>:
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f46:	e8 75 ff ff ff       	call   80106ec0 <setupkvm>
80106f4b:	a3 a4 5c 11 80       	mov    %eax,0x80115ca4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f50:	05 00 00 00 80       	add    $0x80000000,%eax
80106f55:	0f 22 d8             	mov    %eax,%cr3
}
80106f58:	c9                   	leave  
80106f59:	c3                   	ret    
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106f60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f61:	31 c9                	xor    %ecx,%ecx
{
80106f63:	89 e5                	mov    %esp,%ebp
80106f65:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f6e:	e8 bd f8 ff ff       	call   80106830 <walkpgdir>
  if(pte == 0)
80106f73:	85 c0                	test   %eax,%eax
80106f75:	74 05                	je     80106f7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106f77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106f7a:	c9                   	leave  
80106f7b:	c3                   	ret    
    panic("clearpteu");
80106f7c:	83 ec 0c             	sub    $0xc,%esp
80106f7f:	68 16 7c 10 80       	push   $0x80107c16
80106f84:	e8 07 94 ff ff       	call   80100390 <panic>
80106f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106f99:	e8 22 ff ff ff       	call   80106ec0 <setupkvm>
80106f9e:	85 c0                	test   %eax,%eax
80106fa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fa3:	0f 84 a0 00 00 00    	je     80107049 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fac:	85 c9                	test   %ecx,%ecx
80106fae:	0f 84 95 00 00 00    	je     80107049 <copyuvm+0xb9>
80106fb4:	31 f6                	xor    %esi,%esi
80106fb6:	eb 4e                	jmp    80107006 <copyuvm+0x76>
80106fb8:	90                   	nop
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106fc0:	83 ec 04             	sub    $0x4,%esp
80106fc3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fcc:	68 00 10 00 00       	push   $0x1000
80106fd1:	57                   	push   %edi
80106fd2:	50                   	push   %eax
80106fd3:	e8 68 d7 ff ff       	call   80104740 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106fd8:	58                   	pop    %eax
80106fd9:	5a                   	pop    %edx
80106fda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106fdd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106fe0:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fe5:	53                   	push   %ebx
80106fe6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106fec:	52                   	push   %edx
80106fed:	89 f2                	mov    %esi,%edx
80106fef:	e8 bc f8 ff ff       	call   801068b0 <mappages>
80106ff4:	83 c4 10             	add    $0x10,%esp
80106ff7:	85 c0                	test   %eax,%eax
80106ff9:	78 39                	js     80107034 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80106ffb:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107001:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107004:	76 43                	jbe    80107049 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107006:	8b 45 08             	mov    0x8(%ebp),%eax
80107009:	31 c9                	xor    %ecx,%ecx
8010700b:	89 f2                	mov    %esi,%edx
8010700d:	e8 1e f8 ff ff       	call   80106830 <walkpgdir>
80107012:	85 c0                	test   %eax,%eax
80107014:	74 3e                	je     80107054 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107016:	8b 18                	mov    (%eax),%ebx
80107018:	f6 c3 01             	test   $0x1,%bl
8010701b:	74 44                	je     80107061 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010701d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010701f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107025:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010702b:	e8 00 b5 ff ff       	call   80102530 <kalloc>
80107030:	85 c0                	test   %eax,%eax
80107032:	75 8c                	jne    80106fc0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107034:	83 ec 0c             	sub    $0xc,%esp
80107037:	ff 75 e0             	pushl  -0x20(%ebp)
8010703a:	e8 01 fe ff ff       	call   80106e40 <freevm>
  return 0;
8010703f:	83 c4 10             	add    $0x10,%esp
80107042:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107049:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010704c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010704f:	5b                   	pop    %ebx
80107050:	5e                   	pop    %esi
80107051:	5f                   	pop    %edi
80107052:	5d                   	pop    %ebp
80107053:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107054:	83 ec 0c             	sub    $0xc,%esp
80107057:	68 20 7c 10 80       	push   $0x80107c20
8010705c:	e8 2f 93 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107061:	83 ec 0c             	sub    $0xc,%esp
80107064:	68 3a 7c 10 80       	push   $0x80107c3a
80107069:	e8 22 93 ff ff       	call   80100390 <panic>
8010706e:	66 90                	xchg   %ax,%ax

80107070 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107070:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107071:	31 c9                	xor    %ecx,%ecx
{
80107073:	89 e5                	mov    %esp,%ebp
80107075:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107078:	8b 55 0c             	mov    0xc(%ebp),%edx
8010707b:	8b 45 08             	mov    0x8(%ebp),%eax
8010707e:	e8 ad f7 ff ff       	call   80106830 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107083:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107085:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107086:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107088:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010708d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107090:	05 00 00 00 80       	add    $0x80000000,%eax
80107095:	83 fa 05             	cmp    $0x5,%edx
80107098:	ba 00 00 00 00       	mov    $0x0,%edx
8010709d:	0f 45 c2             	cmovne %edx,%eax
}
801070a0:	c3                   	ret    
801070a1:	eb 0d                	jmp    801070b0 <copyout>
801070a3:	90                   	nop
801070a4:	90                   	nop
801070a5:	90                   	nop
801070a6:	90                   	nop
801070a7:	90                   	nop
801070a8:	90                   	nop
801070a9:	90                   	nop
801070aa:	90                   	nop
801070ab:	90                   	nop
801070ac:	90                   	nop
801070ad:	90                   	nop
801070ae:	90                   	nop
801070af:	90                   	nop

801070b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
801070b6:	83 ec 1c             	sub    $0x1c,%esp
801070b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801070bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801070bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070c2:	85 db                	test   %ebx,%ebx
801070c4:	75 40                	jne    80107106 <copyout+0x56>
801070c6:	eb 70                	jmp    80107138 <copyout+0x88>
801070c8:	90                   	nop
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801070d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070d3:	89 f1                	mov    %esi,%ecx
801070d5:	29 d1                	sub    %edx,%ecx
801070d7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801070dd:	39 d9                	cmp    %ebx,%ecx
801070df:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801070e2:	29 f2                	sub    %esi,%edx
801070e4:	83 ec 04             	sub    $0x4,%esp
801070e7:	01 d0                	add    %edx,%eax
801070e9:	51                   	push   %ecx
801070ea:	57                   	push   %edi
801070eb:	50                   	push   %eax
801070ec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801070ef:	e8 4c d6 ff ff       	call   80104740 <memmove>
    len -= n;
    buf += n;
801070f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801070f7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801070fa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107100:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107102:	29 cb                	sub    %ecx,%ebx
80107104:	74 32                	je     80107138 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107106:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107108:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010710b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010710e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107114:	56                   	push   %esi
80107115:	ff 75 08             	pushl  0x8(%ebp)
80107118:	e8 53 ff ff ff       	call   80107070 <uva2ka>
    if(pa0 == 0)
8010711d:	83 c4 10             	add    $0x10,%esp
80107120:	85 c0                	test   %eax,%eax
80107122:	75 ac                	jne    801070d0 <copyout+0x20>
  }
  return 0;
}
80107124:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107127:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010712c:	5b                   	pop    %ebx
8010712d:	5e                   	pop    %esi
8010712e:	5f                   	pop    %edi
8010712f:	5d                   	pop    %ebp
80107130:	c3                   	ret    
80107131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107138:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010713b:	31 c0                	xor    %eax,%eax
}
8010713d:	5b                   	pop    %ebx
8010713e:	5e                   	pop    %esi
8010713f:	5f                   	pop    %edi
80107140:	5d                   	pop    %ebp
80107141:	c3                   	ret    
