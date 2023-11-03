// ∏≈¬ ”ÚBPÀ„∑®

#include <stdio.h>
#include <math.h>
#include <float.h>
#include <limits.h>
#include <stdlib.h>

#define MAX_RANDOM     LONG_MAX   // Maximum value of random() 
#define NODES               275   // Maximum of number of code/check nodes
#define J                    17   // Maximum number of checks per code bit
#define K                    17   // Maximum number of code bits per check

int max_size_M;
int max_size_N;
int size_M[NODES];                // Size of row index sets
int size_N[NODES];                // Size of column index sets
int set_M[NODES][J];              // Column sets for code nodes
int set_N[NODES][K];              // Row sets for check nodes

int n;                            // length
int k;                            // dimension
int nk;                           // redundancy
float  rate;                      // code rate

int M,N;                          // Size of parity-check matrix

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
void belprop(void);

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

  printf("\nITERATIVE PROBABILISTIC DECODING OF LINEAR BLOCK CODES\n");
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
        fscanf(fp, "%d", &size_N[i]);
      for (i=0; i<N; i++)
        fscanf(fp, "%d", &size_M[i]);
      for (i=0; i<M; i++)
      {
        for (j=0; j<size_N[i]; j++)
          fscanf(fp, "%d", &set_N[i][j]);
      }
      for (i=0; i<N; i++)
      {
        for (j=0; j<size_M[i]; j++)
          fscanf(fp, "%d", &set_M[i][j]);
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
    printf("%4d", size_N[i]);
  printf("\n");
  for (i=0; i<N; i++)
    printf("%4d", size_M[i]);
  printf("\n");
  for (i=0; i<M; i++)
  {
    for (j=0; j<size_N[i]; j++)
      printf("%4d", set_N[i][j]);
    printf("\n");
  }
  for (i=0; i<N; i++)
  {
    for (j=0; j<size_M[i]; j++)
      printf("%4d", set_M[i][j]);
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
        belprop();

        // -----------       COUNT THE NUMBER OF BIT ERRORS
        // for (i=0; i<k; i++)
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

void belprop()
{
//
// Iterative decoding by belief propagation in code's Bayesian network
// Based on Pearl's book and MacKay's paper
//

int i,j,l,iter;
float  p1[NODES];
float  qm0[NODES][NODES], qm1[NODES][NODES];
float  rm0[NODES][NODES], rm1[NODES][NODES];
float  delta_r[NODES][NODES];
float  alpha;
float  q0[NODES], q1[NODES];

  // -------------------
  // INITIALIZATION STEP
  // -------------------

  // Prior probabilities

  for (i=0;i<N;i++)
    {
    // p1[i] = 1.0 / ( 1.0 + exp(fabs(received[i])*snr_rms) );
    // p1[i] = 1.0 - exp(-snr_rms*fabs(received[i])) /
    //                           (1.0+exp(-snr_rms*fabs(received[i])));
    p1[i] = 1.0 / ( 1.0 + exp(received[i]*snr_rms) );
    }

  // For every (m,l) such that there is a link between parents and
  // children, qm0[i][j] and qm1[i][j] are initialized to pl[j].
  // Notation: pi (Pearl) = q (MacKay)

  for (i=0; i<M; i++)
    for (j=0; j<size_N[i]; j++)
      {
      qm0[i][j] = 0.0;
      qm1[i][j] = 0.0;
      }

  for (i=0; i<N; i++)                         // run over code nodes
    for (j=0; j<size_M[i]; j++)               // run over children nodes
      {
      qm0[set_M[i][j]-1][i] = (1.0 - p1[i]);
      qm1[set_M[i][j]-1][i] = p1[i];
      }

  iter = 0;                  // Counter of iterations

  do {

  // ---------------------------------------
  // HORIZONTAL STEP = BOTTOM-UP PROPAGATION
  // ---------------------------------------

  // MacKay:
  // Run through the checks m and compute, for each n in N(m) the
  // probabilitiy of a check symbol when code symbol is 0 (or 1)
  // given that the other code symbols have distribution qm0, qm1
  //
  // Pearl:
  // Node x_m computes new "lambda" messages to be sent to its parents
  // u_1, u_2, ..., u_K

  for (i=0; i<M; i++)
    for (j=0; j<size_N[i]; j++)
      {

      delta_r[i][set_N[i][j]-1] = 1.0;

      for (l=0; l<size_N[i]; l++)
        {
        if (set_N[i][l] != set_N[i][j])

        delta_r[i][set_N[i][j]-1] *= ( qm0[i][set_N[i][l]-1] - 
                                                qm1[i][set_N[i][l]-1] );
        }

      rm0[i][set_N[i][j]-1] = 0.5 * ( 1.0 + delta_r[i][set_N[i][j]-1] );
      rm1[i][set_N[i][j]-1] = 0.5 * ( 1.0 - delta_r[i][set_N[i][j]-1] );

      // Mind normalization

      if (rm0[i][set_N[i][j]-1]==0.0)
        {
        rm0[i][set_N[i][j]-1] = 1.0e-10;
        rm1[i][set_N[i][j]-1] = 1.0-1.0e-10;
        }

      }

  // ------------------------------------
  // VERTICAL STEP = TOP-DOWN PROPAGATION
  // ------------------------------------

  // MacKay:
  // Take the computed values of rm0, rm1 and update the values of
  // the probabilities qm0, qm1
  //
  // Pearl:
  // Each node x_l computes new "pi" messages to be send to its
  // children x_1, x_2, ..., x_J

  for (i=0; i<N; i++)
    for (j=0; j<size_M[i]; j++)
      {

      qm0[set_M[i][j]-1][i] = 1.0;
      qm1[set_M[i][j]-1][i] = 1.0;

      for (l=0; l<size_M[i]; l++)
        if (set_M[i][l] != set_M[i][j])
          {
          qm0[set_M[i][j]-1][i] *= rm0[set_M[i][l]-1][i];
          qm1[set_M[i][j]-1][i] *= rm1[set_M[i][l]-1][i];

          }

      qm0[set_M[i][j]-1][i] *= (1.0 - p1[i]);
      qm1[set_M[i][j]-1][i] *= p1[i];

      alpha = 1.0 / (qm0[set_M[i][j]-1][i]+qm1[set_M[i][j]-1][i]);

      qm0[set_M[i][j]-1][i] *= alpha;
      qm1[set_M[i][j]-1][i] *= alpha;

      if (qm0[set_M[i][j]-1][i] == 0.0)
        { qm0[set_M[i][j]-1][i]=1.0e-10; qm1[set_M[i][j]-1][i]=1.0-1.0e-10; }

      }

  // MacKay: At this step we also compute the (unconditional) pseudo-
  // posterior probalilities "q0, q1" to make tentative decisions

  for (i=0; i<N; i++)
    {

    q0[i] = 1.0;
    q1[i] = 1.0;

    for (j=0; j<size_M[i]; j++)
      {
      q0[i] *= rm0[set_M[i][j]-1][i];
      q1[i] *= rm1[set_M[i][j]-1][i];
      }

    q0[i] *= (1.0 - p1[i]);
    q1[i] *= p1[i];

    alpha = 1.0 / (q0[i]+q1[i]);

    q0[i] *= alpha;
    q1[i] *= alpha;

    if (q1[i] > 0.5) 
      decoded[i] = 1;
    else 
      decoded[i] = 0;

    }

  // Increment the number of iterations, and check if maximum reached

  iter++;

  } while (iter < max_iter);

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
  // snr_rms = 2.0*rate*(pow(10.0,(snr/10.0)));     // SNR per bit
  //   snr_rms = 2.0*(pow(10.0,(snr/10.0)));     // SNR per symbol
  snr_rms = 2.0*sqrt(2.0*rate*(pow(10.0,(snr/10.0))));     // SNR per bit
}


