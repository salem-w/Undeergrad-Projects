def solve_send():
	for s in xrange(0, 10):
		for e in xrange(0, 10):
		    for n in xrange(0, 10):
		        for d in xrange(0, 10):
	                    for m in xrange(0, 10):
							for o in xrange(0, 10):
			            		for r in xrange(0, 10):
		                        	for y in xrange(0, 10):
	                                    if distinct(s, e, n, d, m, o, r, y):
					        				send = s*10^3 + e*10^2 + n*10 + d
					        				more = m*10^3 + o*10^2 + r*10 + e
					        				money = m*10^4 + o*10^3 + n*10^2 + e*10 + y
											if send + more == money:
						    					print(send, more, money)

						    
def distinct(*args):
	return len(set(args)) == len(args)
