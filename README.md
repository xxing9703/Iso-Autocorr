# Autocorr
 Autocorr automatically determines the type of corrections needed according to your input file (from Elmaven output).  It also supports mixed cases where you have more than one type of correction within one file (e.g., 13C15N correction for metabolite A,  2D correction for metabolite B) 

Supported type of corrections: single tracer or dual tracers (with high resolution), including: 13C, 15N, 2D, 18O  (pick any one or two from the above)

for single tracer, Autocorr will call function isocorr_A(distin,n,ab_A,im_A) 

for double tracer, Autocorr will call function isocorr_AB(distin,n,m,ab_A,ab_B,im_A,im_B)
  
Limitations: Only works for fully-resolved cases. (i.e., El-maven can retrieve and export isotope labeled intensities with the correct annoation.)

# usage
In matlab,simply run one of the followings:
1. Auocorr
2. Autocorr(filename)
3. Autocorr(filename, impurity)
   
impurity is a numerical array with the default value of [0.01, 0.01, 0.01, 0.01] for 13C, 15N, 2D, 18O (must be in the correct ordering, leave it 0 if not relavent)
If suscessful, you will see 'done' and an output file "filename_cor.xlsx" will be generated. 
