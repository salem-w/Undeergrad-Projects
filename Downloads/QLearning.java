package com.thierrymasson.qlearner;
/**
 * <p>Title: Q - Learner</p>
 * <p>Description: Applet de démonstration de Q-Learning</p>
 * <p>Copyright: Copyright (c) 2002 Thierry MASSON</p>
 * <p>Company: </p>
 * @author Thierry MASSON
 * @version 1.0
 */

public class QLearning implements Runnable{

  boolean DEBUG=false;
  int iter_trace=500000;

  static final int A_N=0;
  static final int A_E=1;
  static final int A_S=2;
  static final int A_O=3;

  long currentIter=-1;
  long iterMax=100000;
  double exploration=0.7;
  double amortissement =0.9;
  double recompense=500.0;
  double penalite= 100.0;
  double apprentissage=0.1;
  double QValues [][][];
  int map[][];
  int resMap[][];
  double Q_S=0;
  // Directions possibles
  int Actions=4;
  int hits=0;
  boolean d_apprent=false;
  double apprent_step=0.0;

  public QLearning(int Qsize)
  {
    initQValues(Qsize);
  }
  //-Constructeur --------------------------------------------------------------

  public QLearning(long itMax, double explore, double amort,
                   double recomp, double penal, double apprent,
                   int Qsize, int[][] mapDefine,boolean d_apprent)
  {
    this.iterMax=itMax;
    this.exploration=explore;
    this.amortissement=amort;
    this.recompense=recomp;
    this.penalite=penal;
    this.apprentissage=apprent;
    this.Q_S=Qsize;
    this.map=mapDefine;
    initQValues(Qsize);
    this.d_apprent=d_apprent;
    if(this.d_apprent)
    {
      apprent_step=this.apprentissage/this.iterMax;
    }
  }//fin constructeur

  private void initQValues(int Qsize)
  {
    QValues=new double[Qsize][Qsize][Actions];
    // init des qvalues
    for(int i=0;i<Qsize;i++)
    {
      for(int j=0;j<Qsize;j++)
      {
        for(int a=0;a<Actions;a++)
        {
          QValues[i][j][a]=0.0;
        }
      }
    }
    //--------------------------------
  }

  // Sortie des résultats ...

  public int[][] giveResMap()
  {
    for(int i=0;i<this.Q_S;i++)
    {
      for(int j=0;j<this.Q_S;j++)
      {
        this.map[i][j]+=(100+100*this.giveBestAction(i,j));
      }
    }
    return map;
  }

  //Donne l'action optimale pour un état donné
  //i.e. celle qui présente la plus grande Q-Value.

  private int giveBestAction(int StateI,int StateJ)
  {
    int theBest=-1;
    double theBestVal=-100000.0;
    for(int i=0;i<this.Actions;i++)
    {
      if(QValues[StateI][StateJ][i]>theBestVal)
      {
      theBestVal=QValues[StateI][StateJ][i];
      theBest=i;
      }
    }
    return theBest;
  }

  private double giveBestQValue(int StateI, int StateJ)
  {
    double theBest=-1000000.0;
    for(int i=0;i<this.Actions;i++)
    {
      if(QValues[StateI][StateJ][i]>theBest) theBest=QValues[StateI][StateJ][i];
    }
    return theBest;
  }

  //Donne le prochain état en fonction de l'état courant
  // et de l'action choisie ...
  // Simule les déplacements du robot !

  private int[] giveNextState(int StateI, int StateJ, int action)
  {
    int result[]=new int[2];
    switch (action)
    {
      case A_N:
        if (StateI==0)
        {
          result[0]=StateI;
          result[1]=StateJ;
        }
        else
        {
          result[0]=StateI-1;
          result[1]=StateJ;
        }
        break;
      case A_E:
        if(StateJ==Q_S-1)
        {
          result[0]=StateI;
          result[1]=StateJ;
        }
        else
        {
          result[0]=StateI;
          result[1]=StateJ+1;
        }
        break;
      case A_S:
        if(StateI==Q_S-1)
        {
          result[0]=StateI;
          result[1]=StateJ;
        }
        else
        {
          result[0]=StateI+1;
          result[1]=StateJ;
        }
        break;
      case A_O:
        if(StateJ==0)
        {
          result[0]=StateI;
          result[1]=StateJ;
        }
        else
        {
          result[0]=StateI;
          result[1]=StateJ-1;
        }
        break;
    }
    return result;
  }

  private double recompenser(int StateI,int StateJ, int action)
  {
    //valeur par défaut;
    double result=0.0;
    int nextState[]=this.giveNextState(StateI,StateJ,action);
    int location = map[nextState[0]][nextState[1]];
    switch(location)
    {
      case 0:break;
      case 1:result=this.penalite;break;
      case 2:result=this.recompense;break;
    }
    return result;
  }


  // Exploration semi-uniforme
  // Tirage entre comportement glouton (contrôle) et
  // comportement aléatoire (exploration).

  private int choisirAction (int StateI, int StateJ)
  {
    int actionChoisie;
    double rval = java.lang.Math.random();
    if(rval<this.exploration)
    {
      actionChoisie=java.lang.Math.round((float)java.lang.Math.random()*(this.Actions-1));
    }
    else
    {
      actionChoisie=giveBestAction(StateI,StateJ);
    }
    return actionChoisie;
  }

  //Choix aléatoire d'une position de départ ...
  private int[] departAleatoire()
  {
    int result[] = new int[2];
    result[0]=java.lang.Math.round((float)(java.lang.Math.random()*(Q_S-1)));
    result[1]=java.lang.Math.round((float)(java.lang.Math.random()*(Q_S-1)));
    return result;
  }


  // MAJ des Q-Values
  // Le coeur de l'apprentissage !!!
  private void majQValue(int StateI, int StateJ, int act)
  {
    double oldValue=QValues[StateI][StateJ][act];
    double rec=this.recompenser(StateI,StateJ,act);
    int nextState[]=this.giveNextState(StateI,StateJ,act);
    double Qstar=this.giveBestQValue(nextState[0],nextState[1]);
    //
    QValues[StateI][StateJ][act]=(1.0-this.apprentissage)*oldValue+this.apprentissage*(rec+(this.amortissement*Qstar));
  }

  //Processus itératif d'apprentissage non supervisé par renforcement
  // La pièce maitresse !!!
 // public void apprendre()
  public void run()
  {
    int CurrState[]=this.departAleatoire();
    for (long iter=0;iter<this.iterMax;iter++)
    {
      this.currentIter=iter;
      //Trace des iterations ...
      if((DEBUG) && (iter % iter_trace)==0) System.err.println("Iteration ="+iter);

      int currAct=this.choisirAction(CurrState[0],CurrState[1]);
      this.majQValue(CurrState[0],CurrState[1],currAct);
      int nextState[]=this.giveNextState(CurrState[0],CurrState[1],currAct);
      switch(map[nextState[0]][nextState[1]])
      {
        case 0:CurrState=nextState;break;
        case 1:CurrState=nextState;break;
        case 2:CurrState=this.departAleatoire();hits++;break;
      }
      //décroître taux d'apprentissage
      if(this.d_apprent) this.apprentissage -=this.apprent_step;
    }//fin boucle apprentissage
    if(DEBUG)
    {
      System.err.println("Total hits ="+this.hits);
    }
  }

  public int getTargetHits()
  {return this.hits;}

  public long getCurrentIter()
  {return this.currentIter;}

  public long getIterMax()
  {return this.iterMax;}
}