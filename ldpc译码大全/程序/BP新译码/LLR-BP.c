// ∂‘ ˝”ÚBPÀ„∑®

#include <stdio.h>
#include <math.h>
#include <float.h>
#include <limits.h>
#include <stdlib.h>

#define MAX_RANDOM     LONG_MAX   // Maximum value of random() 
#define NODES             16384   // Maximum of number of code/check nodes
#define J                    17   // Maximum number of checks per code bit
#define K                    17   // Maximum number of code bits per check

int max_size_M;
int max_size_N;

int n;                            // length
int k;                            // dimension
int nk;                           // redundancy
float  rate;                      // code rate

int M,N;                          // Size of parity-check matrix

// ---------------
// NODE STRUCTURES
// ---------------

struct parent_node {
    int size;
    int index[J];                     // indexes of children
    float pi1[J], pi0[J];             // messages "pi" to children
    };

struct child_node {
    int size;
    int index[K];                     // indexes of parents 
    float lambda1[K], lambda0[K];     // messages "lambda" to parents
    };

struct parent_node code_node[NODES];
struct child_node check_node[NODES];

double init_snr, final_snr, snr_increment;
double sim, num_sim, ber, amp;
long seed;
int error;
int data[NODES], codeword[NODES];
int data_int;
double snr, snr_rms;
float  transmited[NODES], received[NODES];
int hard[NODES], decoded[NODES];
int i,j, iter, max_iter;
char filename[40], name2[40];
FILE *fp, *fp2;

void initialize(void);
void awgn(void);
void encode(void);
void log_belprop(void);
double F(double x);

main(int argc, char *argv[])
{
  // Command line processing
  if (argc != 11)
    {
      printf("Usage: %s length(n) dimension(k) file_parity-check max_iter init_snr final_snr snr_inc num_sim output_file seed\n", 
                      argv[0]);
      exit(0);
    }

  sscanf(argv[1],"%d", &n);
  sscanf(argv[2],"%d", &k);
  sscanf(argv[3],"%s", filename);
  sscanf(argv[4],"%d", &max_iter);
  sscanf(argv[5],"%lf", &init_snr);
  sscanf(argv[6],"%lf", &final_snr);
  sscanf(argv[7],"%lf", &snr_increment);
  sscanf(argv[8],"%lf",&num_sim);
  sscanf(argv[9],"%s", name2);
  sscanf(argv[10],"%ld",&seed);

  nk = n-k;
  rate = (float) k / (float) n;

  printf("\nITERATIVE LOG-LIKELIHOOD DECODING OF LINEAR BLOCK CODES\n");
  printf("Log-likelihood version of Pearl's algorithm\n");
  printf("max_iter = %d\n", max_iter);
  printf("SNR from %lf to %lf in increments of %lf\n",
         init_snr, final_snr, snr_increment);
  printf("%.0f codewords transmitted per SNR\n", num_sim);
  printf("\nn=%d, k=%d, n-k=%d, and rate = %lf\n\n",n,k,nk,rate);

  if ((fp = fopen(filename,"r")) != NULL)
    {
      fscanf(fp, "%d %d", &N, &M);
      fscanf(fp, "%d %d", &max_size_N, &max_size_M);
      for (i=0; i<M; i++)
        fscanf(fp, "%d", &check_node[i].size);
      for (i=0; i<N; i++)
        fscanf(fp, "%d", &code_node[i].size);

      // Read index sets for check nodes
      for (i=0; i<M; i++)
      {
        for (j=0; j<check_node[i].size; j++)
          fscanf(fp, "%d", &check_node[i].index[j]);
      }

      // Read index sets for code nodes
      for (i=0; i<N; i++)
      {
        for (j=0; j<code_node[i].size; j++)
          fscanf(fp, "%d", &code_node[i].index[j]);
      }
    }
  else 
    { 
      printf("incorrect input file name ...\n"); 
      exit(0);
    }

  fclose(fp);

#ifdef PRINT_MATRIX
  printf("%d %d\n", N, M);
  printf("%d %d\n", max_size_N, max_size_M);
  for (i=0; i<M; i++)
    printf("%4d", check_node[i].size);
  printf("\n");
  for (i=0; i<N; i++)
    printf("%4d", code_node[i].size);
  printf("\n");
  for (i=0; i<M; i++)
  {
    for (j=0; j<check_node[i].size; j++)
      printf("%4d", check_node[i].index[j]);
    printf("\n");
  }
  for (i=0; i<N; i++)
  {
    for (j=0; j<code_node[i].size; j++)
      printf("%4d", code_node[i].index[j]);
    printf("\n");
  }
  printf("\n");
#endif

  fp2 = fopen(name2,"w");

  snr = init_snr;
  srandom(seed);

  // -------------------------------------------------------------------
  //                  S I M U L A T I O N   L O O P 
  // -------------------------------------------------------------------

  while ( snr < (final_snr+0.001) )
    {

      initialize();

      while (sim < num_sim)   //  <--- Fixed number of simulations
      // while (ber < 1000)      //  <-- Minimum number of errors
      { 

        // ----------        FOR CONVENIENCE, MAKE DATA EQUAL TO ZERO
        for (i=0; i<k; i++)
          data[i] = 0;

        // -----------       BPSK MAPPING: "0" --> +1,  "1" --> -1
        for (i=0; i<n; i++)
          transmited[i] = 1.0;

        // -----------       ADDITIVE WHITE GAUSSIAN NOISE CHANNEL
        awgn();

        // -----------       ITERATIVE DECODING BY BELIEF PROPAGATION
        log_belprop();

        // -----------       COUNT THE NUMBER OF BIT ERRORS
        for (i=0; i<n; i++)
          if (decoded[i]) ber++;

        sim+=1.0;

      }

    printf("%lf \t%8.0lf %8.0lf \t%13.8e\n", snr, ber, (n*sim), (ber/(sim*n))); 
    fflush(stdout);
    fprintf(fp2, "%lf %13.8e\n", snr, (ber/(sim*n)) );
    fflush(fp2);

    snr += snr_increment;

  }

  fclose(fp2);

}

void log_belprop()
{
//
// Iterative decoding by belief propagation in code's Bayesian network
// Based on Pearl's book and MacKay's paper
// Using the logarithms of the probabilities
//

int i,j,l,iter;
int m,aux;
float alpha;
float delt;
int sign;
float llrp1[NODES];                       // Prior probabilities (channel)
float q0[NODES], q1[NODES];               // Pseudo-posterior probabilities

  // -------------------
  // ***** STEP 0 *****
  // INITIALIZATION STEP
  // -------------------

  // Prior log-likelihood ratios (channel metrics)

  for (i=0;i<N;i++)
    {
    // LOOK-UP TABLE (LUT)
    llrp1[i] = received[i]*snr_rms;
    }

  // For every (m,l) such that there is a link between parents and
  // children, qm0[i][j] and qm1[i][j] are initialized to pl[j].
  // Notation: pi (Pearl) = q (MacKay)

  for (i=0; i<N; i++)                         // run over code nodes
    {

#ifdef DEBUG
printf("received = %10.7lf\n", received[i]);
#endif

    for (j=0; j<code_node[i].size; j++)       // run over check nodes
      {

      code_node[i].pi1[j] = llrp1[i];

#ifdef DEBUG
printf("i,j,  pi1 = %d,%d   %10.7lf\n", i,j,
code_node[i].pi1[j]);
#endif

      }
    }

  iter = 0;                  // Counter of iterations

  do {

  // ---------------------------------------
  //         ***** STEP 1 *****
  // HORIZONTAL STEP = BOTTOM-UP PROPAGATION
  // ---------------------------------------
  //
  // MacKay:
  // Run through the checks m and compute, for each n in N(m) the
  // probabilitiy of a check symbol when code symbol is 0 (or 1)
  // given that the other code symbols have distribution qm0, qm1
  //
  // Pearl:
  // Node x_m computes new "lambda" messages to be sent to its parents
  // u_1, u_2, ..., u_K

  for (i=0; i<M; i++)
    for (j=0; j<check_node[i].size; j++)
      {
      delt = 0.0;
      sign = 0;                           // Keep track of sign of delt

      for (l=0; l<check_node[i].size; l++)
        {
        aux = check_node[i].index[l];

        if (aux != check_node[i].index[j])
          {
          // --------------------------------------------------------
          //  Compute the index "m" of the message from parent node
          // --------------------------------------------------------
          m = 0;
          while (  ( (code_node[aux-1].index[m]-1) != i )
                          && ( m < code_node[aux-1].size)  ) m++;

          if (code_node[aux-1].pi1[m] < 0.0) sign ^= 1;
          delt += F(fabs(code_node[aux-1].pi1[m]));

#ifdef DEBUG
printf("pi1, delt =  %lf, %lf \n", code_node[aux-1].pi1[m],delt);
#endif

          }
        }
      if (sign == 0)
        check_node[i].lambda1[j] = F(delt);
      else
	check_node[i].lambda1[j] = -F(delt);

      // Normalization
      if (check_node[i].lambda1[j] < -30.0)
        check_node[i].lambda1[j] = -30.0;

#ifdef DEBUG
printf("i,j, lambda1 = %d,%d  %10.7lf\n",i,j,check_node[i].lambda1[j]);
#endif

      }


  // ------------------------------------
  //         ***** STEP 2 *****
  // VERTICAL STEP = TOP-DOWN PROPAGATION
  // ------------------------------------
  //
  // MacKay:
  // Take the computed values of rm0, rm1 and update the values of
  // the probabilities qm0, qm1
  //
  // Pearl:
  // Each node u_l computes new "pi" messages to be send to its
  // children x_1, x_2, ..., x_J

  for (i=0; i<N; i++)
    for (j=0; j<code_node[i].size; j++)
      {

      code_node[i].pi1[j] = 0.0;

      for (l=0; l<code_node[i].size; l++)
        {
        aux = code_node[i].index[l]-1; 

        if ( aux != (code_node[i].index[j]-1) )
          {

          // Compute index "m" of message from children
          m = 0;
          while (  ( (check_node[aux].index[m]-1) != i )
                         && ( m < check_node[aux].size )  ) m++;

          code_node[i].pi1[j] += check_node[aux].lambda1[m];
          }
        }

      code_node[i].pi1[j] += llrp1[i];

#ifdef DEBUG
printf("---->  i,j,  pi1 = %d,%d    %10.7lf\n", i,j,code_node[i].pi1[j]);
#endif

      if (code_node[i].pi1[j] < -30.0)
        code_node[i].pi1[j] = -30.0;

      }

  // DECODING:
  // MacKay: At this step we also compute the (unconditional) pseudo-
  // posterior probalilities "q0, q1" to make tentative decisions

  for (i=0; i<N; i++)
    {
    q1[i] = 0.0;

    for (j=0; j<code_node[i].size; j++)
      {
      aux = code_node[i].index[j]-1; 

      // Compute index "m" of message from children
      m = 0;
      while (  ( (check_node[aux].index[m]-1) != i )
                     && ( m < check_node[aux].size )  ) m++;

      q1[i] += check_node[aux].lambda1[m];

      }

    q1[i] += llrp1[i];

#ifdef DEBUG
printf("iter = %d, q1 = %10.7lf\n", iter, q1[i]);
#endif

    if (q1[i] < 0.0) 
      decoded[i] = 1;
    else 
      decoded[i] = 0;

    }


  // Increment the number of iterations, and check if maximum reached

  iter++;

  } while (iter < max_iter);

}



double F(double x)
{
  double interm;
  if (x == 0.0) return(1.0e+30);
  if (fabs(x) > 30.0)
    interm = 0.0;
  else
    interm = log ( (exp(x)+1.0)/(exp(x)-1.0) );
  return(interm);
}



void encode()
//
// Systematic encoding 
//
{
//int i,j;
//for (j=0; j<n; j++)
//  {
//    if (j<k)                     // information position
//      codeword[j] = data[j];
//    else                         // redundant position
//      {
//        codeword[j] = 0;
//        for (i=0; i<k; i++)
//          // codeword[j] ^= ( data[i] * H[j-k][i] ) & 0x01;
//          codeword[j] ^= ( data[i] * H[(j-k+i)%n] ) & 0x01;
//      }
//  }
}


void awgn()
//
// AWGN generation
// 
{
  double u1,u2,s,noise,randmum;
  int i;
  for (i=0; i<n; i++)
    {
      do {
            randmum = (double)(random())/MAX_RANDOM;
            u1 = randmum*2.0 - 1.0;
            randmum = (double)(random())/MAX_RANDOM;
            u2 = randmum*2.0 - 1.0;
            s = u1*u1 + u2*u2;
            } while( s >= 1);
      noise = u1 * sqrt( (-2.0*log(s))/s );
      received[i] = transmited[i] + noise/amp;
#ifdef NO_NOISE
      received[i] = transmited[i];
#endif
    }
}


void initialize()
{
  amp = sqrt(2.0*rate*pow(10.0,(snr/10.0)));
  ber = 0.0;
  sim = 0.0;
  snr_rms = 2.0*sqrt(2.0*rate*(pow(10.0,(snr/10.0))));     // 2/sigma^2
}


