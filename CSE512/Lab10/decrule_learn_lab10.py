# decrule_learn_lab10.py
# by KV, November 2014, after Nils Nilsson's GSCA decision rule learning
# algorithm

import random

#from dotbot_lab10_kv import *


DATATABLE = [{'id':1, 'app':1, 'rat': 0, 'inc': 0, 'bal':1, 'ok': 0},\
             {'id':2, 'app':0, 'rat': 0, 'inc': 1, 'bal':0, 'ok': 0},\
             {'id':3, 'app':1, 'rat': 1, 'inc': 0, 'bal':1, 'ok': 1},\
             {'id':4, 'app':0, 'rat': 1, 'inc': 1, 'bal':1, 'ok': 1},\
             {'id':5, 'app':0, 'rat': 1, 'inc': 1, 'bal':0, 'ok': 0},\
             {'id':6, 'app':1, 'rat': 1, 'inc': 1, 'bal':0, 'ok': 1},\
             {'id':7, 'app':1, 'rat': 1, 'inc': 1, 'bal':1, 'ok': 1},\
             {'id':8, 'app':1, 'rat': 0, 'inc': 1, 'bal':0, 'ok': 0},\
             {'id':9, 'app':1, 'rat': 1, 'inc': 0, 'bal':0, 'ok': 0}]

BOTTABLE = [{'id':1, 's1': 0, 's2': 0, 's3': 0,'s4': 0, 's5': 1, 's6': 1,'s7': 1, 's8': 0,'right': 1},\
            {'id':2, 's1': 0, 's2': 0, 's3': 0,'s4': 1, 's5': 1, 's6': 0,'s7': 0, 's8': 0,'right': 0},\
            {'id':3, 's1': 0, 's2': 0, 's3': 0,'s4': 0, 's5': 0, 's6': 0,'s7': 1, 's8': 1,'right': 0},\
            {'id':4, 's1': 0, 's2': 0, 's3': 0,'s4': 0, 's5': 1, 's6': 0,'s7': 0, 's8': 0,'right': 1},\
            {'id':5, 's1': 0, 's2': 0, 's3': 0,'s4': 0, 's5': 1, 's6': 1,'s7': 0, 's8': 0,'right': 1},\
            {'id':6, 's1': 0, 's2': 0, 's3': 1,'s4': 0, 's5': 0, 's6': 0,'s7': 0, 's8': 0,'right': 0},\
            {'id':7, 's1': 0, 's2': 0, 's3': 1,'s4': 1, 's5': 0, 's6': 0,'s7': 0, 's8': 0,'right': 0},\
            {'id':8, 's1': 1, 's2': 1, 's3': 0,'s4': 0, 's5': 0, 's6': 0,'s7': 0, 's8': 0,'right': 0},\
            {'id':9, 's1': 0, 's2': 1, 's3': 1,'s4': 0, 's5': 0, 's6': 1,'s7': 0, 's8': 0,'right': 0},\
            {'id':10, 's1': 0, 's2': 1, 's3': 1,'s4': 0, 's5': 0, 's6': 0,'s7': 0, 's8': 0,'right': 0}\
            {'id':11, 's1': 0, 's2': 0, 's3': 0,'s4': 0, 's5': 0, 's6': 0,'s7': 1, 's8': 0,'right': 0}\
            {'id':12, 's1': 1, 's2': 0, 's3': 0,'s4': 0, 's5': 0, 's6': 0,'s7': 0, 's8': 1,'right': 0}\
            {'id':13, 's1': 1, 's2': 0, 's3': 0,'s4': 0, 's5': 0, 's6': 0,'s7': 0, 's8': 0,'right': 0}\
            {'id':14, 's1': 1, 's2': 0, 's3': 0,'s4': 0, 's5': 0, 's6': 0,'s7': 1, 's8': 1,'right': 0}\
            {'id':15, 's1': 0, 's2': 0, 's3': 0,'s4': 0, 's5': 0, 's6': 1,'s7': 1, 's8': 0,'right': 1}\
            {'id':16, 's1': 0, 's2': 0, 's3': 1,'s4': 1, 's5': 1, 's6': 0,'s7': 0, 's8': 0,'right': 0}\
            {'id':17, 's1': 1, 's2': 1, 's3': 1,'s4': 0, 's5': 0, 's6': 0,'s7': 0, 's8': 0,'right-': 0}]

'''
DATATABlE = DTAB
ATTRIBS = DTAB[0].keys()
ATTRIBS.remove('right')
DEC =  'right'
'''

ATTRIBS = ['app', 'rat', 'inc', 'bal']

BOTATTRIBS = ['s1','s2', 's3', 's4', 's5','s6', 's7', 's8'] 

DEC = 'ok'

              
def learn_rules():
    dtab = DATATABLE
    rules = []
    while pos_left(dtab):
        #print_table(dtab)
        nextrule = learn_next_rule(dtab)
        if nextrule == None:
            print "No (further) rules can be extracted\n\n"
            break
        elif nextrule in rules:
            pass
        else:
            rules.append(nextrule)
            dtab = reduce_table(dtab, nextrule)
            print 'New rule: %s\n' % nextrule
    report_rules(rules)
    return rules

def print_table(dtab):
    for x in dtab:
        print x
    print "\n"
    return

def rule_ratio(rule,dtab):
    numpos = num_covers_pos(dtab,rule)
    numcov = num_covers(dtab,rule)
    if numcov == 0:
        print "%s: %d/%d = #" % (rule,numpos,numcov)
        return  -1  # mind div by 0
    print "%s: %d/%d = %f\n" % (rule, numpos, numcov, float(numpos)/numcov)
    return float(numpos)/numcov
    
def learn_next_rule(dtab):
    attrs = ATTRIBS[:]
    rule = []
    while covers_neg(dtab,rule):
        if attrs == []:
            break
        testrules = candidate_rules(rule,attrs)

        #for x in testrules:
        #    print x
        #print "\n"
        
        random.shuffle(testrules)
        testratios = map(lambda r: (rule_ratio(r,dtab) ,r),\
                     testrules)
        best = max(testratios)[1]
        rule = best
        attrs.remove(best[-1])
        
    if attrs == [] and covers_neg(dtab,rule):
        #rule.append('other') # dummy completion of rules
        return None
    else:
        return rule

def covers_neg(dtab, rule):
    if rule == []:
        return True
    k = 0
    for inst in dtab:
        if covers_instance(inst, rule) and inst[DEC] == 0:
            return True
    return False
        
def covers_instance(inst, rule):
    for attr in rule:
        if attr == 'other':
            continue
        elif inst[attr] == 0:
            return False
    return True
        
def candidate_rules(rule, attrs):
    cands = []
    for a in attrs:
        newr = rule[:]
        newr.append(a)
        cands.append(newr)
    return cands

def num_covers(dtab, rule):
    if rule == []:
        return len(dtab)
    k = 0
    for inst in dtab:
        if covers_instance(inst, rule):
            k += 1
    return k

def num_covers_pos(dtab, rule):
    if rule == []:
        k = 0
        for inst in dtab:
            if inst[DEC] == 1:
                k += 1
        return k
    k = 0
    for inst in dtab:
        if covers_instance(inst,rule) and inst[DEC] == 1:
            k += 1
    return k
                            
def pos_left(dtab):
    for inst in dtab:
        if inst[DEC] == 1:
            return True
    return False

def reduce_table(dtab,rule):
    dtab1 = []
    for inst in dtab:
        if not covers_instance(inst,rule):
            dtab1.append(inst)
    return dtab1
    
def report_rules(rules):
    if rules == []:
        print "No rules were learned.\n"
        return
    rno = 1
    print "The rules learned are:\n"
    for r in rules:
        lhs = ''
        for i in range(len(r)):
            if i == len(r)-1:
                lhs += r[i] 
            else:
                lhs += r[i] + ' & '
        print '%d. ' % rno,
        print lhs + ' ==> ' + DEC
        rno += 1
    print '\n\n'
    return



# top level call; learns from most recent DATATABLE
'''
DATATABLE = DTAB
ATTRIBS = DTAB[0].keys()
ATTRIBS.remove('right')
DEC = 'right'
'''
learn_rules()








             
