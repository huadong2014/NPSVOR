Nonparallel Support Vector Ordinal Regression
====
Huadong Wang, Yong Shi, Lingfeng Niu and Yingjie Tian

Datasets
------- 
All the datasets in [1] are used for experiment. these datasets are available at  http://www.uco.es/grupos/ayrna/orreview. Other datasets are from http://www.gatsby.ucl.ac.uk/~chuwei/ordinalregression.html.

Compared methods
------- 
To test the performance of NPSVOR, we compare it with all the SVM-based ordinal regression models reported in the survey[1]. The used baselines are:<br\>  
* SVC1V1: Standard SVC with One Vs One [2],<br\>  
* SVC1VA: Standard SVC with One Vs All [2],<br\>  
* SVR: Support Vector Regression [2],<br\>  
* CSSVC: Cost-Sensitive Support Vector Classifier[3],<br\>  
* SVMOP: Support Vector Machines with Ordered Partitions[4],<br\>  
* SVOREX: SVM for Ordinal Regression with Explicit Constraints[5],<br\>  
* SVORIM: SVM for Ordinal Regression with Implicit Constraints[5], <br\>  
* REDSVM:  The reduction from cost-sensitive ordinal ranking applied to weighted binary classification framework to SVM[6].<br\>  
* OPBE: Ordinal Projection Based Ensemble[7]. <br\>  

Get the codes:
------- 
* Comparisons are carried out on the common Matlab framework which can be downloaded from [http://www.uco.es/grupos/ayrna/orreview](http://www.uco.es/grupos/ayrna/orreview). <br> 
* We used the freely available LIBSVM for SVC1V1, SVC1VA, SVR[https://www.csie.ntu.edu.tw/~cjlin/libsvm/](https://www.csie.ntu.edu.tw/~cjlin/libsvm/)<br> 
* CSSVC{libsvm-weights-3.12):[https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/weights/]* * (https://www.csie.ntu.edu.tw/~cjlin/libsvmtools/weights/). <br> 
* SVOREX and SVORIM: [http:/ /www.gatsby.ucl.ac.uk/?chuwei/svor.htm](http:/ /www.gatsby.ucl.ac.uk/?chuwei/svor.htm). <br> 
* REDSVM: [http://www.work.caltech.edu/~htlin/program/libsvm/](http:/ /www.gatsby.ucl.ac.uk/?chuwei/svor.htm).

References:
------- 
[1] P. A. Gutiérrez, M. Pérez-Ortiz, J. Sánchez-Monedero, F. Fernández-Navarro, and C. Hervás-Martınez, “Ordinal regression methods: survey and experimental study,” IEEE Transactions on Knowledge and Data Engineering, vol. 28, no. 1, pp. 127–146, 2016.<br>  
[2] C.-W. Hsu and C.-J. Lin, “A comparison of methods for multiclass support vector machines,” Neural Networks, IEEE Transactions on,vol. 13, no. 2, pp. 415–425, 2002.<br>  
[3] A. J. Smola and B. Schölkopf, “A tutorial on support vector regression,” Statistics and computing, vol. 14, no. 3, pp. 199–222, 2004.<br>  
[4] W. Waegeman and L. Boullart, “An ensemble of weighted support vector machines for ordinal regression,” International Journal of Computer Systems Science and Engineering, vol. 3, no. 1, pp. 47–51, 2009.<br>  
[5] W. Chu and S. S. Keerthi, “Support vector ordinal regression,” Neural computation, vol. 19, no. 3, pp. 792–815, 2007.<br>  
[6] H.-T. Lin and L. Li, “Reduction from cost-sensitive ordinal ranking to weighted binary classification,” Neural Computation, vol. 24, no. 5, pp. 1329–1367, 2012.<br>  
[7] M. Pérez-Ortiz, P. A. Gutiérrez, and C. Hervás-Martı́nez, “Projection-based ensemble learning for ordinal regression,” Cybernetics, IEEE Transactions on, vol. 44, no. 5, pp. 681–694, 2014.
