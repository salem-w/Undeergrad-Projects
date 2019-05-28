# dotbot_lab10.py

# version of dotbot_learn.py that records sensor settings for positive
# experiences inorder to generalize learned moves ...

# by Kerstin Voigt, Jan 2018; inspired by Nils Nilsson, Introduction to
# Artificial Intelligence: A New Synthesis

# a version of dotbot_forever.py that "learns" to make those move that will
# have dotbot circle a wall forever. 


from graphics import *
import random
import time
import copy


# global vars
WORLD_MAX_X = 500
WORLD_MAX_Y = 500
GRID = 20
WALL = {}
LMOVES = 1000
ENOUGH = 100

# a piece of wall (one square)

class Wall:
    def __init__(self):
        global WALL
        prompt = Text(Point(8*GRID, WORLD_MAX_Y - 2*GRID),\
                      "Click one square per click, twice for the last")
        prompt.draw(win)
        prompt_on = True

        click = win.getMouse()
        click1x = click.x - click.x % GRID
        click1y = click.y - click.y % GRID

        while True:
            if prompt_on:
                prompt_on = False
                prompt.undraw()

            WALL[(click1x,click1y)] = Rectangle(Point(click1x,click1y),\
                                                Point(click1x + GRID,\
                                                      click1y + GRID))
            WALL[(click1x,click1y)].setFill("black")
            WALL[(click1x,click1y)].draw(win)

            click = win.getMouse()
            click2x = click.x - click.x % GRID
            click2y = click.y - click.y % GRID

            if (click1x,click1y) == (click2x,click2y):
                break
    
            click1x = click2x
            click1y = click2y

    def draw(self):
        for loc in WALL.keys():
            WALL[loc].draw(win)

    def undraw(self):
        for loc in WALL.keys():
            WALL[loc].undraw()
            


# the dotbot robot ...   
class DotBot:
    def __init__(self,loc = Point(5*GRID,5*GRID), col="red", pwr = 100):
        self.location = loc
        self.previous = Point(-1,-1)
        self.color = col
        self.the_dotbot = Oval(self.location,\
                               Point(self.location.x + GRID, self.location.y + GRID))
        self.the_dotbot.setFill(self.color)
        self.power = pwr
        self.pos_experience = {}
        self.neg_experience = {}
        self.pos_exp_sensors = {}
        self.what_i_learned = {}
        self.training_data = {}
                               
    def __str__(self):
        return "%s dotbot at (%d,%d) with power %d" % (self.color,\
                                             self.location.x,\
                                             self.location.y,self.power)

    def update_dotbot(self):
        self.the_dotbot.move(self.location.x - self.the_dotbot.p1.x,\
                             self.location.y - self.the_dotbot.p1.y)
        
    def draw(self):
        self.update_dotbot()
        self.the_dotbot.draw(win)

    def undraw(self):
        self.the_dotbot.undraw()

    def s1(self):
        return WALL.has_key((self.location.x - GRID, self.location.y - GRID))
            
    def s2(self):
        return WALL.has_key((self.location.x, self.location.y - GRID))
            

    def s3(self):
        return WALL.has_key((self.location.x + GRID, self.location.y - GRID))

    def s4(self):
        return WALL.has_key((self.location.x + GRID, self.location.y))

    def s5(self):
        return WALL.has_key((self.location.x + GRID, self.location.y + GRID))

    def s6(self):
        return  WALL.has_key((self.location.x, self.location.y + GRID))

    def s7(self):
        return WALL.has_key((self.location.x - GRID, self.location.y + GRID))

    def s8(self):
        return WALL.has_key((self.location.x - GRID, self.location.y))

    def at_wall(self):
        return self.s1() or self.s2() or self.s3() or\
               self.s4() or self.s5() or self.s6() or\
               self.s7() or self.s8()

    def sensors_1to8(self):
        s1to8 = [self.s1(), self.s2(), self.s3(),\
                 self.s4(), self.s5(), self.s6(),\
                 self.s7(), self.s8()]
        s1to8 = tuple([1 if x == True else 0 for x in s1to8])
        return s1to8

    def move_learn(self):
        # get all 8 sensor readings
        sensors = self.sensors_1to8()
        (herex,herey) = (self.location.x,self.location.y)
        if (herex,herey) in self.pos_experience.keys() and\
           not Point(self.pos_experience[(herex,herey)][0],\
                     self.pos_experience[(herex,herey)][1]) == self.previous:
            # a good move from here is know from positive experience
            # make this move ... 
            (newx,newy) = self.pos_experience[(herex,herey)]
            self.previous = self.location
            self.location = Point(newx, newy)
            print "make move (%d,%d)->(%d,%d) from pos exp" % (herex,herey,newx,newy)
            self.undraw()
            self.draw()
        else:
            now_at_wall = self.at_wall() # yes or not; need for below
            # make any possible move that is not included in neg_experience
            rand1to4 = range(1,5)
            random.shuffle(rand1to4)
            for select in rand1to4:
                if select == 1:
                    res = self.learn_up()
                    if res != None:
                        print "learning ... moving up"
                        break
                elif select == 2:
                    res = self.learn_down()
                    if res != None:
                        print "learning ... moving down"
                        break
                elif select == 3:
                    res = self.learn_left()
                    if res != None:
                        print "learning ... moving left"
                        break
                else:
                    res = self.learn_right()
                    if res!= None:
                        print "learning ... moving right"
                        break
            
            # test suggested move res; is neg experience if (a) has has crossed
            # wall boundary or (b) bot was at wall and has moved away from it or
            # (c) moves back to the previous location;
            # location is now set to res, but it will be reset to previous
            # if this looks like a bad move

            if res == None:
                print "ALL MOVES TRIED FROM (%d,%d)" %\
                      (self.location.x,self.location.y)
                # neg experience locks progress; reset to unlock
                # quit this move
                self.neg_experience[(herex,herey)] = []
                return
                
            if (res.x,res.y) in WALL.keys() or\
               now_at_wall and not self.at_wall() or\
               (res.x,res.y) == (self.previous.x,self.previous.y):

                # ... color switch below is not working ...
                
                self.undraw()
                #self.color = "yellow"
                self.draw()   # draw in yellow at bad location
                
                time.sleep(0.15)
                self.location = Point(herex,herey) 
                self.undraw()
                #self.color = "red"
                self.draw()   # move back and draw in red at old location
                
                if (herex,herey) in self.neg_experience.keys():
                    self.neg_experience[(herex,herey)].append((res.x,res.y))
                else:
                    self.neg_experience[(herex,herey)]= [(res.x,res.y)]
                    
            elif self.at_wall() and\
                 not (res.x,res.y) == (self.previous.x,self.previous.y):
                # a potentially good move; mark this as a new pos experience
                # unless the reverse move is already listed;
                if (res.x,res.y) in self.pos_experience.keys()and\
                   self.pos_experience[(res.x,res.y)] == (herex,herey):
                    pass
                else:
                    self.pos_experience[(herex,herey)] = (res.x,res.y)
                    self.previous = Point(herex,herey)
                    self.undraw()
                    self.draw()
                    # also record pos experience with sensor readings
                    self.pos_exp_sensors[(herex,herey)] =\
                            [(res.x,res.y),sensors]
                            
            else:
                # nothing speaks against this move ... just make it
                self.previous = Point(herex,herey)
                self.undraw()
                self.draw()

    def move_up(self):
        newloc = Point(self.location.x, self.location.y - GRID)
        if self.location.y >= GRID:
            self.location = newloc
      
    def move_down(self):
        newloc = Point(self.location.x, self.location.y + GRID)
        if self.location.y <= WORLD_MAX_Y - GRID:
            self.location = newloc
            
    def move_left(self):
        newloc = Point(self.location.x - GRID, self.location.y)        
        if self.location.x >= GRID:
            self.location = newloc

    def move_right(self):
        newloc = Point(self.location.x + GRID, self.location.y)
        if self.location.x <= WORLD_MAX_X - GRID:
            self.location = newloc

    # used when robot will move into one of four
    # direction (where); meant to be chosen at random
    def go(self,where):
        if where == 1:
            self.move_up()
        elif where == 2:
            self.move_down()
        elif where == 3:
            self.move_left()
        elif where == 4:
            self.move_right()
        else:
            pass
        self.undraw()
        self.draw()
            
    def direction(self, fromxy,toxy):
        (x1,y1) = fromxy
        (x2,y2) = toxy
        if y1 == y2:
            if x2 > x1:
                return 'right'
            elif x2 < x1:
                return 'left'
            else:
                return 'stay'
        elif x1 == x2:
            if y2 < y1:
                return 'up'
            elif y2 > y1:
                return 'down'
            else:
                return 'stay'
        else:
            return 'illegal'
        
    def generalize_learned(self):
        for k in self.pos_exp_sensors.keys():
            s1to8 = self.pos_exp_sensors[k][1]
            (nextx,nexty) = self.pos_exp_sensors[k][0]
            direct = self.direction((k[0],k[1]),(nextx,nexty))
            if direct != 'stay' and direct != 'illegal' and\
               not s1to8 in self.what_i_learned.keys():
                self.what_i_learned[s1to8] = direct
        print "\nLearned:"
        for sens in self.what_i_learned.keys():
            print "%s --> %s" % (sens,self.what_i_learned[sens])
        print "\n"
        return

    # produce data table for inductive learning
    # based of contents of self.what_i_learned;
    #
    # COMPLETE IN LAB 10
    def make_datatable(self,ok):
        dtab = []
        for s1tos8 in self.what_i_learned.keys():
            direct = self.what_i_learned[s1tos8]

            nextrow = {}

            for i in range(len(s1tos8)):
                nextrow['s'+str(i+1)] = s1tos8[i]
                if s1tos8[i] == 1:
                    nextrow['nots'+str(i+1)] = s1tos8[i]
                else:
                    nextrow['nots'+str(i+1)] = s1tos8[i]

            if direct == ok:
                nextrow[ok] = 1

            else:
                nextrow[ok] = 0

            dtab.append(nextrow)
        return dtab

    def move_by_know(self):
        s1to8 = self.sensors_1to8()
        if s1to8 in self.what_i_learned.keys():
            direct = self.what_i_learned[s1to8]
            if direct == 'up':
                self.move_up()
            elif direct == 'down':
                self.move_down()
            elif direct == 'right':
                self.move_right()
            elif direct == 'left':
                self.move_left()
            elif direct == 'stay':
                pass
            else:
                print "*** ILLEGAL MOVE ***"
            self.undraw()
            self.draw()
        else:
            rnum = random.randint(1,4)
            self.go(rnum)
        return
    
    # True if the transition from the current location to a
    # suggested new location is already known as a bad
    # prior experience
    
    def had_bad_experience(self,newloc):
        (oldx,oldy) = (self.location.x,self.location.y)
        (newx,newy) = (newloc.x, newloc.y)
        if (oldx,oldy) in self.neg_experience.keys():
            return (newx,newy) in self.neg_experience[(oldx,oldy)]

    # moving and learning ... 

    def learn_up(self):
        newloc = Point(self.location.x, self.location.y - GRID)
        if self.location.y >= GRID and\
           not self.had_bad_experience(newloc):
            self.location = newloc
            return newloc
        else:
            return None

    def learn_down(self):
        newloc = Point(self.location.x, self.location.y + GRID)
        if self.location.y <= WORLD_MAX_Y - GRID and\
           not self.had_bad_experience(newloc):
            self.location = newloc
            return newloc
        else:
            return None
            
    def learn_left(self):
        newloc = Point(self.location.x - GRID, self.location.y)        
        if self.location.x >= GRID and\
           not self.had_bad_experience(newloc):
            self.location = newloc
            return newloc
        else:
            return None

    def learn_right(self):
        newloc = Point(self.location.x + GRID, self.location.y)
        if self.location.x <= WORLD_MAX_X - GRID and\
           not self.had_bad_experience(newloc):
            self.location = newloc
            return newloc
        else:
            return None


def cyclic_list (lst):
    if len(lst) <= 1:
        return False
    elif len(lst) == 2 and lst[0] == lst[1]:
        return True
    else:
        target = lst[-1]
        #print "target is %s at index %d" % (target, len(lst)-1)
        i = -2
        repeat_at = None
        while True:
            if i < -len(lst):
                break
            if lst[i] == target:
                repeat_at = i
                #print "repeat of target %s at index %d" % (lst[i], i)
                break
            i -= 1
        if repeat_at == None:
            return False

        if 2*repeat_at + 1 < -len(lst):
            return False
        
        if lst[2*repeat_at + 1] == target:
            #print "2nd repeat of target %s at index %d" %\
            #(lst[2*repeat_at + 1], 2*repeat_at + 1)
            i1 = 2*repeat_at + 2
            i2 = repeat_at + 1
            while i2 < -1:
                if lst[i1] != lst[i2]:
                    return False
                i2 += 1
                i1 += 1
            return True

      
# this could be a main function but doesn't have to be ...
# these lines will be executed as part of loading this file ...

win = GraphWin("Dotbot World", WORLD_MAX_X, WORLD_MAX_Y)

for i in range(GRID,WORLD_MAX_Y,GRID):
    hline = Line(Point(0,i),Point(WORLD_MAX_X,i))
    hline.draw(win)
    vline = Line(Point(i,0),Point(i,WORLD_MAX_Y))
    vline.draw(win)

mywall = Wall()


plunkbot = Text(Point(8*GRID, WORLD_MAX_Y-2*GRID), "Click square to place your DotBot")
plunkbot.draw(win)
click = win.getMouse()
plunkx1 = click.x - click.x % GRID
plunky1 = click.y - click.y % GRID
print "click to place at %d,%d" % (plunkx1, plunky1)
plunkbot.undraw()
mybot = DotBot(Point(plunkx1,plunky1))
mybot.draw()

start = Text(Point(8*GRID, WORLD_MAX_Y-2*GRID), "Click to start the action -- twice to stop")
start.draw(win)

click = win.getMouse()
clickx1 = click.x - click.x % GRID
clicky1 = click.y - click.y % GRID
print "click at %d,%d" % (clickx1, clicky1)
start.undraw()


# LEARNING: dot bot makes up to LMOVES many moves following prior
# positive experience, avoiding negative experience, and making
# a random move otherwise which is followed by evaluation (classified
# and recorded as positive or negative experience;

# LMOVES global; ASK global; every ASK many moves, interact with user to
# determine if sufficient learning has happened; if so stop learning;

count = 0
HAS_LEARNED = False
history = [(mybot.location.x,mybot.location.y)]
for m in range(LMOVES):
    time.sleep(0.15)
    print "%d. move_learn ..." % (m+1)
    mybot.move_learn()
    history.append((mybot.location.x,mybot.location.y))
    count += 1
    if count % ENOUGH == 0:
        if cyclic_list(history):
        
            #learned = Text(Point(8*GRID, WORLD_MAX_Y-2*GRID),\
            #              "Dotbot has learned!!")
            #learned.draw(win)
            
            time.sleep(0.15)
            #text.undraw()
            mybot.generalize_learned()
            
            HAS_LEARNED = True
            break
        
            
    else:
        pass
text = Text(Point(8*GRID, WORLD_MAX_Y-2*GRID),\
                "Click twice to quit")
text.draw(win)
win.getMouse()
win.getMouse()
win.close()

#DTAB = mybot.make_datatable('right')

'''
if HAS_LEARNED:
    for rounds in range(4):
        # demonstrate learning by applying new knowledge to circle
        # a different wall;
        #learned.undraw()
        #another = Text(Point(8*GRID, WORLD_MAX_Y-2*GRID),\
        #            "Build another wall, place dotbot and start")
        #another.draw(win)
        mywall2 = Wall()
        #another.undraw()

        plunkbot = Text(Point(8*GRID, WORLD_MAX_Y-2*GRID),\
                        "Click square to place your DotBot")
        plunkbot.draw(win)

        click = win.getMouse()
        plunkbot.undraw()
        plunkx1 = click.x - click.x % GRID
        plunky1 = click.y - click.y % GRID

        mybot.location = Point(plunkx1,plunky1)
        mybot.undraw()
        mybot.draw()

        start = Text(Point(8*GRID, WORLD_MAX_Y-2*GRID), "Click to start the action -- twice to stop")
        start.draw(win)
        click = win.getMouse()
        clickx1 = click.x - click.x % GRID
        clicky1 = click.y - click.y % GRID
        start.undraw()

        i = 0
        while i < 100:
            mybot.move_by_know()
            time.sleep(0.2)
            i +=1

    text = Text(Point(8*GRID, WORLD_MAX_Y-2*GRID),\
                "Click twice to quit")
    text.draw(win)
    win.getMouse()
    win.getMouse()
    win.close()
else:
    # after LMOVES many moves and not enough learning
    text = Text(Point(8*GRID, WORLD_MAX_Y-2*GRID),\
                "Click twice to quit")
    text.draw(win)
    win.getMouse()
    win.getMouse()
    win.close()
'''
            


        
                
            
        
    

    
            
