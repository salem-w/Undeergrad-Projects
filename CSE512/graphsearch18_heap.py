def ASTAR_SEARCH_FCT(start,target,GOAL_FCT,SUCCESSOR_FCT,EVAL_FCT,\
                    COMPACT_PRINT = None):

  if COMPACT_PRINT == None:
      def myprint (x): print x
      COMPACT_PRINT = myprint

  open = [[0,start,[start],0]]
  heapq.heapify(open)
  closed = []
  steps = 0
  while open != []:
    nxt = heapq.heappop(open)
    
    nxtnode = nxt[1]
    nxtpath = nxt[2]
    nxteval = nxt[0]
    nxtdpth = nxt[3]

    print "%d. Step: |open| = %d, depth = %d, eval = %d, f-cost = %d" %\
          (steps,len(open),nxtdpth,EVAL_FCT(nxtnode),nxteval)
    #COMPACT_PRINT(nxtnode)
    
    if GOAL_FCT(nxtnode,target): # nxtnode == goal:
      print "GOAL FOUND:"
      #print "Node: %s" % nxtnode
      print "Node:    ",
      COMPACT_PRINT(nxtnode)
      print "PathL:  %d" % len(nxtpath)
      print "Steps:  %d" % steps
      return nxt

    
    if nxt in closed:
      continue
    closed.append(nxt)  
    
    succ = SUCCESSOR_FCT(nxtnode) 
    random.shuffle(succ)
    
    for x in succ:
        xcost = EVAL_FCT(x,nxtnode,target)  
        newnode = [xcost+nxtdpth+1,x,addpath(nxtpath,x),nxtdpth+1]

        #check whether newnode[0] (or, x) is already on open or closed with
        #shorter path; if so, do not bother to put open;
        keeper = True
        for c in closed:
          if newnode[1] == c[1] and newnode[0] >= c[0]:
            keeper = False
            break
        if not keeper: 
          continue
        
        for op in open:
          if newnode[1] == op[1] and newnode[0] >= op[0]:
            keeper = False
            break

        if keeper:
            heapq.heappush(open, newnode)

    #open.sort(lambda x,y: CostCmp(x,y))  # NOTICE SORTING
    steps += 1
  return None
