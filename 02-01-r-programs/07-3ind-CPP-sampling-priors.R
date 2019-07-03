
options(echo=TRUE) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)
node.idx = as.numeric(args[1]);

if (.Platform$OS.type == "windows") { node.idx = 1 }


if (.Platform$OS.type == "windows") {
           root = "C:/Users/psioda/Documents/Research Papers Temp/bayesDesignSimilars/github";
 } else {  root = "/proj/psiodalab/projects/bayesDesignSimilars/github";
 } 

setwd(paste(root,"02-00-r-source",sep="/"));

source("utility.rcpp");
source("sample-cpp.rcpp");

setwd(paste(root,"02-02-r-output",sep="/"));

##########################################################################################

eqm1    = 0.10;
eqm2    = 0.60;
eqm3    = 0.10;

trad.n1 = 328;
trad.n2 = 119;
trad.n3 = 477;



eqm.choice=c(eqm1,eqm2,eqm3);

idx = 0;
for (pi0.choice in c(0.33,0.50,0.67,0.75)) {
for (change     in c(0,25,50))             {

pi1.choice = pi0.choice + (1-pi0.choice)*change/100;
x = calc_cpp( eqm=eqm.choice,pi0=pi0.choice,pi1=pi1.choice,
              max_scale=2,scale_increment=0.0001,scale_tol=0.0001,
              min_rho=0.0,max_rho=0.99,rho_increment=0.0001,rho_tol=0.0001) 
idx=idx+1;

x = matrix(c(pi0.choice,pi1.choice,x$cpp.sd,x$cpp.rho,change,eqm.choice),1,10);
if (idx==1)  { y = x } else {y = rbind(y,x) }


}
}
colnames(y) <- c("pi0","pi1","sd1","sd2","sd3","rho","change","eqm1","eqm2","eqm3");

parms=data.frame(y); 

idx = ( parms$pi0     == 0.33 | parms$pi0     == 0.50 | parms$pi0     == 0.67 | parms$pi0    == 0.75 ) & 
      ( parms$change  == 0    | parms$change  == 25   | parms$change  == 50    );

parms.sp  = parms[ (parms$pi0 == 0.75) & (parms$change == 50) , ]
parms.cpp = parms[idx,]

write.csv(parms.cpp,file="sp.3ind.settings.csv",row.names=F);

############################################################################################







 sd     = unlist(c(parms.sp$sd1,parms.sp$sd2,parms.sp$sd3));
 rho    = parms.sp$rho;
 
 set.seed(1);


 ####### zero null hypotheses true ##########################################################################;
 ## 2,AAA;

 lower.lim  = c(-0.1,-0.6,-0.1);
 upper.lim  = c( 0.1, 0.6, 0.1);
 sp = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp) <- c("gamma1","gamma2","gamma3");
    write.csv(sp,file="sp.3ind.ba.na.ba.csv",row.names=F);


 lower.lim  = c(-0.05,-0.30,-0.05);
 upper.lim  = c( 0.05, 0.30, 0.05);
 sp = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp) <- c("gamma1","gamma2","gamma3");
    write.csv(sp,file="sp.3ind.bar.nar.bar.csv",row.names=F);

 ####### one null hypothesis true  ##########################################################################;
 ## 2,ANA;
 lower.lim  = c(-0.10,-0.60,-0.10);
 upper.lim  = c( 0.10,-0.60, 0.10);
 sp  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp) <- c("gamma1","gamma2","gamma3");
    write.csv(sp,file="sp.3ind.ba.nnp.ba.csv",row.names=F);

 ## 2,NAA;
 lower.lim  = c(-0.10,-0.60,-0.10);
 upper.lim  = c(-0.10, 0.60, 0.10);
 sp  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp) <- c("gamma1","gamma2","gamma3");
    write.csv(sp,file="sp.3ind.bnp.na.ba.csv",row.names=F);

 ## 2,AAN;
 lower.lim  = c(-0.10,-0.60,-0.10);
 upper.lim  = c( 0.10, 0.60,-0.10);
 sp  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp) <- c("gamma1","gamma2","gamma3");
    write.csv(sp,file="sp.3ind.ba.na.bnp.csv",row.names=F);

 #### two null hypotheses true ###############################################################################;
 ## 2,ANN;
 lower.lim  = c(-0.10,-0.60,-0.10);
 upper.lim  = c( 0.10,-0.60,-0.10);
 sp  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp) <- c("gamma1","gamma2","gamma3");
    write.csv(sp,file="sp.3ind.ba.nnp.bnp.csv",row.names=F);

 ## 2,NNA;
 lower.lim  = c(-0.10,-0.60,-0.10);
 upper.lim  = c(-0.10,-0.60, 0.10);
 sp  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp) <- c("gamma1","gamma2","gamma3");
    write.csv(sp,file="sp.3ind.bnp.nnp.ba.csv",row.names=F);

 ## 2,NAN;
 lower.lim  = c(-0.10,-0.60,-0.10);
 upper.lim  = c(-0.10, 0.60,-0.10);
 sp  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp) <- c("gamma1","gamma2","gamma3");
    write.csv(sp,file="sp.3ind.bnp.na.bnp.csv",row.names=F);




