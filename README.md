# Iso-Autocorr 
Iso-Autocorr (simply called Autocorr below) integrates isocorr, isocorr13C15N, isocorrAB, and fully automates the natual isotope corrections. The main features are:
1.  It automatically determines the type of natual isotope corrections needed according to your input file (from Elmaven output), without the need of user's input.
2.  It supports both single and double tracer corrections, including: 13C, 15N, 2D, 18O, 13C15N, 13C2D, 13C18O, 15N2D, 15N18O, 2D18O.
    <br> * for single tracer, Autocorr calls function isocorr_A(distin,n,ab_A,im_A)
    <br> * for double tracer, Autocorr calls function isocorr_AB(distin,n,m,ab_A,ab_B,im_A,im_B)
4.  It also supports mixed cases where you have more than one type of correction within one file (e.g., 13C15N correction for metabolite A,  2D correction for metabolite B).
5.  It allows multi-file inputs and can do all the corrections in batch mode.
6.  Sanity check of your input data, shows logs and warning messages of suspicious misreading data. for example:
> 55/63: 13C -- Glucose -- successful \
> 56/63: 13C&15N -- tyrosine -- warning: line279, ppm error larger than expected:5.11 \
> 57/63: 13C&15N -- Phosphorylcholine -- warning: line284, ppm error larger than expected:6.98 \
> 58/63: 13C&15N -- Phosphoserine -- successful 


# Input file & Important Note
Autocorr is limited to use only for high-res fully-resolved case, where the exatracted data table from El-maven is the true abundance of the annotated isotope label species. It does not apply to low-res cases where peak overlappings are common and significant. Although it does sanity checks and generates warning messages, Autocorr is not responsible for identifying and correcting any abundance misreadings due to spectral contaminations, overlapping or missing peaks, incorrect settings in Elmaven (i.e, ppm window), misannotations etc.... 
 
For example, it won't work in the following cases (usually will show large ppmDiff error):
 
-- Elmaven pulls out 18O signal but it is indeed the mixture of 18O and 13C2.  (no matter if 13C is one of the tracers) \
-- Elmaven pulls out 2D signal but it is indeed the mixture of 2D and 13C.  (no matter if 13C is one of the tracers) \
-- Elmaven reads unexpected 13C15N-label-6-2 signal, likely due to contaminations from an unknown peak at similar m/z


# Usage
In matlab,simply run Autocorr.m (or type Autocorr in command window). Once prompt, select the csv file(s) you want to correct: The default tracer purity is 99% for all.  In cases you need to change this, you can manually pass a parameter: 'impurity'. impurity is a numerical array with the default value of [0.01, 0.01, 0.01, 0.01] for 13C, 15N, 2D, 18O (must be in the correct ordering, leave it 0 if not relavent) \
* for example: Autocorr([0.02, 0.05, 0, 0]) will specifies 13C impurity to be 2% and 15N to be 5%.

# Output
If suscessful, you will see 'done' at the end of each file correction, and an output file "filename_cor.xlsx" will be generated. 

# Examples
See example input files along with the corrected ones in folder: \
--example 1: 13C only \
--example 2: 13C15N \
--example 3: 13C15N (long list) \
--example 4: 2D18O \
--example 5: 13C2D \
--example 6: mixed 13C15N and 2D

