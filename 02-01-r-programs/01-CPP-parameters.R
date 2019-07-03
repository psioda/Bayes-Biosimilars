
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


eqm.choice=c(0.1,0.6);

idx = 0;
for (pi0.choice in seq(0.33,0.90,by=0.01)) {
for (change     in seq(0.00,0.99,by=0.01)) {

pi1.choice = pi0.choice + (1-pi0.choice)*change;
x = calc_cpp( eqm=eqm.choice,pi0=pi0.choice,pi1=pi1.choice,
          max_scale=2,scale_increment=0.0001,scale_tol=0.0001,
          min_rho=0.0,max_rho=0.99,rho_increment=0.0001,rho_tol=0.0001) 
idx=idx+1;

x = matrix(c(pi0.choice,pi1.choice,x$cpp.sd,x$cpp.rho),1,5);
if (idx==1)  { y = x } else {y = rbind(y,x) }


}
}
colnames(y) <- c("pi0","pi1","sd1","sd2","rho");
setwd(paste(root,"02-02-r-output",sep="/"));
write.csv(file="cpp-hyperparameters-percent-reduction.csv",y,row.names=FALSE);



idx = 0;
for (pi0.choice in seq(0.33,0.90,by=0.01)) {
for (pi1.choice in seq(pi0.choice,0.99,by=0.01)) {

x = calc_cpp( eqm=eqm.choice,pi0=pi0.choice,pi1=pi1.choice,
          max_scale=2,scale_increment=0.0001,scale_tol=0.0001,
          min_rho=0.0,max_rho=0.99,rho_increment=0.00001,rho_tol=0.00001) 
idx=idx+1;

x = matrix(c(pi0.choice,pi1.choice,x$cpp.sd,x$cpp.rho),1,5);
if (idx==1)  { y = x } else {y = rbind(y,x) }


}
}

colnames(y) <- c("pi0","pi1","sd1","sd2","rho");
setwd(paste(root,"02-02-r-output",sep="/"));
write.csv(file="cpp-hyperparameters-absolute-reduction.csv",y,row.names=FALSE);


