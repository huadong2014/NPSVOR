Comparisons are carried out on the common Matlab framework which can be downloaded from \url{ http://www.uco.es/grupos/ayrna/orreview}. We have used the implementation from the freely available Libsvm for SVC1V1, SVC1VA, SVR\footnote{SVC1V1, SVC1VA and SVR(libsvm-3.21): \url{https://www.csie.ntu.edu.tw/~cjlin/libsvm/}} and CSSVC\footnote{CSSVC(libsvm-weights-3.12):\url{https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/weights/}}. Codes used for  SVOREX and SVORIM are downloaded from \url{ http:/ /www.gatsby.ucl.ac.uk/?chuwei/svor.htm }.  REDSVM is downloaded from \url{ http://www.work.caltech.edu/~htlin/program/libsvm/}. For all the other methods that will be
used for comparison, the default stopping criteria in the corresponding packages are used.

All the datasets in [1] are used for experiment. these datasets are available at  http://www.uco.es/grupos/ayrna/orreview. Other datasets are from http://www.gatsby.ucl.ac.uk/~chuwei/ordinalregression.html.

Compared methods: To test the performance of NPSVOR, we compare it with all the SVM-based ordinal regression models reported in the survey[1]. The used baselines are:
SVC1V1: Standard SVC with One Vs One [2],
SVC1VA: Standard SVC with One Vs All [2],
SVR: Support Vector Regression [2],
CSSVC: Cost-Sensitive Support Vector Classifier[3],
SVMOP: Support Vector Machines with Ordered Partitions[4]
SVOREX: SVM for Ordinal Regression with Explicit Constraints[5]
SVORIM: SVM for Ordinal Regression with Implicit Constraints[5], 
REDSVM:  The reduction from cost-sensitive ordinal ranking applied to weighted binary classification framework to SVM[6].
OPBE: Ordinal Projection Based Ensemble[7]. 

[1] P. A. Gutiérrez, M. Pérez-Ortiz, J. Sánchez-Monedero, F. Fernández-Navarro, and C. Hervás-Martınez, “Ordinal regression methods: survey and experimental study,” IEEE Transactions on Knowledge and Data
Engineering, vol. 28, no. 1, pp. 127–146, 2016.
[2] C.-W. Hsu and C.-J. Lin, “A comparison of methods for multiclass support vector machines,” Neural Networks, IEEE Transactions on,vol. 13, no. 2, pp. 415–425, 2002.
[3] A. J. Smola and B. Schölkopf, “A tutorial on support vector regression,” Statistics and computing, vol. 14, no. 3, pp. 199–222, 2004.
[4] W. Waegeman and L. Boullart, “An ensemble of weighted support vector machines for ordinal regression,” International Journal of Computer Systems Science and Engineering, vol. 3, no. 1, pp. 47–51, 2009.
[5] W. Chu and S. S. Keerthi, “Support vector ordinal regression,” Neural computation, vol. 19, no. 3, pp. 792–815, 2007.
[6] H.-T. Lin and L. Li, “Reduction from cost-sensitive ordinal ranking to weighted binary classification,” Neural Computation, vol. 24, no. 5, pp. 1329–1367, 2012.
[7] M. Pérez-Ortiz, P. A. Gutiérrez, and C. Hervás-Martı́nez, “Projection-based ensemble learning for ordinal regression,” Cybernetics, IEEE Transactions on, vol. 44, no. 5, pp. 681–694, 2014.