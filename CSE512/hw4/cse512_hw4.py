# cse512_hw4.py
# KV, Mar 2018, code for hw4

import copy
import itertools  # just to try it out; used once, see below
import random

CLS = [['notP', 'notQ', 'R'],  ['P', 'R'], ['Q', 'R'], ['notR']]

# set up to prove that H2CO3 by contradicting notH2CO3
CHEM = [['notCO2', 'notH2O','H2CO3'], ['notC', 'notO2', 'CO2'],\
        ['notMgO', 'notH2', 'Mg'], ['notMgO', 'notH2','H2O'],
        ['MgO'], ['H2'], ['O2'], ['C'], ['notH2CO3']]

#for sos
CHEMgiven = [['notCO2', 'notH2O','H2CO3'], ['notC', 'notO2', 'CO2'],\
        ['notMgO', 'notH2', 'Mg'], ['notMgO', 'notH2','H2O'],
        ['MgO'], ['H2'], ['O2'], ['C']]

CHEMsos = [['notH2CO3']]

LOG1 = [['l2','l1'],['notl4','l3'],['notl5','l1'],['notl5','l4'],\
        ['l6','notl2'],['notl7','notl6'],['l7'],['l2']]


LOG1given = [['l2','l1'],['notl4','l3'],['notl5','l1'],['notl5','l4'],\
        ['l6','notl2'],['notl7','notl6']]

LOG1sos = [['l7'],['l2']]

PROB3 = [['P','Q','R'],['notQ','notP'],['notR','notP'],['P','notS','notR'],\
         ['R','notS','notP'],['notQ','notT'],['S','notT'],['notX','notT'],['notP'],['T'],['notX']]

PROB3given = [['P','Q','R'],['notQ','notP'],['notR','notP'],['P','notS','notR'],\
         ['R','notS','notP'],['notQ','notT'],['S','notT'],['notX','notT']]

PROB3sos = [['notP'],['T'],['notX']]
            
             

def is_neg(x):
  if len(x) >= 4 and x[:3] == 'not':
    return True
  return False

def complements(x,y):
  if is_neg(x) and not is_neg(y):
    if x[3:] == y:
      return (x,y)
    else:
      return  None
  elif not is_neg(x) and is_neg(y):
    if x == y[3:]:
      return (x,y)
    else:
      return None
  else:
    return None

# does lst1 contain variable that has complement in lst1
def have_complements(lst1, lst2):
  for x in lst1:
    for y in lst2:
      comps = complements(x,y)
      if comps != None:
        return comps
  return None
        
def contains_comps(lst):
  if len(lst) <= 1:
    return False
  pairs = itertools.combinations(lst,2)
  for (x,y) in pairs:
    if complements(x,y):
      return True
  return False

def is_same(lst1, lst2):
  if len(lst1) != len(lst2):
    return False
  return len(set(lst1).intersection(set(lst2))) == len(lst1)

# true if lst contains a member that is_same as x
def member(x, lst):
  for y in lst:
    if is_same(x,y):
      return True
  return False


# call this function to APPLY RESOLUTION
# without or with "unit preference stragegy)
# call with resolve(...,True) for unit pref;

def resolve (cls, unitpref = None):
  thecls = copy.deepcopy(cls)
  random.shuffle(thecls)
  steps = 1
  n = len(cls)
  while True:
    oldn = n
    if unitpref:
      thecls.sort(key=len) # NEW FOR LAB9: UNIT PREFERENCE 
    #thecls.sort(lambda x,y: ByLength(x,y)
    
    for i in range(len(thecls)-1):
      res_found = False
      for j in range(i,len(thecls)):
        c1 = thecls[i][:] # copy
        c2 = thecls[j][:] # copy
        #print "TRYING %s and %s" % (c1,c2)

        comps = have_complements(c1,c2)
    
        if comps == None:
          continue

        # c1 and c2 are complements
        # combine c1 and c2 into c3 minus x and cx
        (x,cx) = comps
        c3 = c1
        for y in c2:
          if not y in c3:
            c3.append(y)

        #print "c3 before removal of comps: %s" % c3
        c3.remove(x)
        c3.remove(cx)
        #print "c3 after removal of comps: %s" % c3

        if c3 == []:
          print "%d. %s with %s ==> []" % (steps,thecls[i],thecls[j])
          return  'UNSATISFIABLE -- CONTRADICTION'

        if contains_comps(c3):
          #print "c3 contains complements -- ignore"
          continue
        
        if member(c3,thecls):
          #print "c3 already exists in thecls -- ignore"
          #print "thecls: %s" % thecls
          continue
        
        thecls.append(c3)
        print "%d. %s with %s ==> %s" % (steps,thecls[i],thecls[j],c3) 
        n += 1
        steps += 1
        res_found = True
        break # from inner for-loop
      if res_found:
        break # from outer for-loop
      
    if n == oldn:
      return 'SATISFIABLE -- NO CONTRADICTION'
    
# resolution with "set of support" strategy; 
# givencls: clauses from the given set of premises
# negtarget: clauses from the NEGATED target (target = to prove)

LIMIT = 10000

def resolve_sos(givencls, negtarget, unitpref = None):
  thecls = copy.deepcopy(givencls)
  random.shuffle(thecls)
  thesos = copy.deepcopy(negtarget)
  random.shuffle(thesos)
  steps = 1
  tries = 0
  while tries <= LIMIT:
    if unitpref:
      thecls.sort(key = len)
      thesos.sort(key = len)
    else:
      random.shuffle(thecls)
      random.shuffle(thesos)
      
    for pick1 in thesos:
      res_found = False
      for pick2 in thesos+thecls:
        c1 = pick1[:] # copy
        c2 = pick2[:] # copy

        #print "TRYING %s and %s" % (c1,c2)

        comps = have_complements(c1,c2)
    
        if comps == None:
          continue

        # c1 and c2 are complements
        # combine c1 and c2 into c3 minus x and cx
        (x,cx) = comps
        c3 = c1
        for y in c2:
          if not y in c3:
            c3.append(y)

        #print "c3 before removal of comps: %s" % c3
        c3.remove(x)
        c3.remove(cx)
        #print "c3 after removal of comps: %s" % c3

        tries += 1
        
        if c3 == []:
          print "%d. %s with %s ==> []" % (steps,pick1,pick2)
          return  'UNSATISFIABLE -- CONTRADICTION'

        if contains_comps(c3):
          #print "c3 contains complements -- ignore"
          continue
        
        if member(c3,thesos):
          #print "c3 already exists in thecls -- ignore"
          #print "thecls: %s" % thecls
          continue
        
        thesos.append(c3)
        print "%d. %s with %s ==> %s" % (steps,pick1,pick2,c3) 
        steps += 1
        res_found = True
        break # from inner for-loop
      if res_found:
        break # from outer for-loop
      
  return 'SATISFIABLE -- NO CONTRADICTION'
    

  

  







    
  
  










  
  
    
  
    
    
