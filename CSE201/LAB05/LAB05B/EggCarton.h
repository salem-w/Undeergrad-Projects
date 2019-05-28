 /************************************************************************************
 * CSE201 W16: SALEM      -- LAB 05: Part B
 * 004893625
 * LAB 05 -- Exercise : EggCarton.h
 * 
 * This is the EggCarton class, it has a constructor and three public methods
 * and two private data fields.
 **********************************************************************************
 */

#ifndef EGGCARTON_H
#define EGGCARTON_H
class EggCarton
{
public:
	EggCarton(int brownEggs, int whiteEggs);
	int getTotalEggs();
	bool addBrownEggs(int n);
	bool addWhiteEggs(int n);

private:
	int brownEggs;
	int whiteEggs;
	
};
#endif