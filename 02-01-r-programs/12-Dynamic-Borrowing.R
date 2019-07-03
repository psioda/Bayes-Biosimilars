
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
source("fit-cpp.rcpp");
source("fit-bhm.rcpp");
setwd(paste(root,"02-02-r-output",sep="/"));
sp = read.csv(file="simulation-design-inputs.csv");
sp[(sp$iFrac1==1 & sp$change==0),]


n=328;
dat1 = c(n,n*0.81,0,n,n*0.81,0);
dat2 = c(n,n*0.81,0,n,n*0.71,0);
dat3 = c(n,n*0.81,0,n,n*0.91,0);

nMC  = 1000000;
nBI  = 1000;
rho0 = 0.5;
phi0 = 3;

gamma0    = 0;
tau0      = 100;
alpha0    = 0.01;
beta0     = 0.01;

s=seq(10,nMC,by=10) ; length(s);

postRho   =  matrix(0,100000,4);
postSigma =  matrix(0,100000,4);

for (p in (1:4))
{
  J        = 2^p;
  dst      = rep(0,J);
  dat      = matrix(c(rep(dat1,J/2),rep(dat2,J/2)),ncol=6,byrow=T);


  sd       = rep(0.14823,J);
  dynamic  = fitCPPRandom(dst,dat,sd,rho0,phi0,nMC,nBI); 
  postRho[,p] = dynamic[s,ncol(dynamic)];

  dynamic       = fitBHM(dst,dat,gamma0,tau0,alpha0,beta0,nMC,nBI);
  postSigma[,p] = dynamic[s,ncol(dynamic)];
}
write.csv(postRho,file="Rho-Borrowing-Properties.csv");
write.csv(postSigma ,file="Sigma-Borrowing-Properties.csv");


postRho   =  matrix(0,100000,4);
postSigma =  matrix(0,100000,4);

for (p in (1:4))
{
  J        = 2^p;
  dst      = rep(0,J);
  dat      = matrix(c(rep(dat3,J/2),rep(dat2,J/2)),ncol=6,byrow=T);


  sd       = rep(0.14823,J);
  dynamic  = fitCPPRandom(dst,dat,sd,rho0,phi0,nMC,nBI); 
  postRho[,p] = dynamic[s,ncol(dynamic)];

  dynamic       = fitBHM(dst,dat,gamma0,tau0,alpha0,beta0,nMC,nBI);
  postSigma[,p] = dynamic[s,ncol(dynamic)];
}
write.csv(postRho,file="Rho-Borrowing-Properties2.csv");
write.csv(postSigma ,file="Sigma-Borrowing-Properties2.csv");


par(mfrow=c(4,1));
for (p in (1:4)) { hist(postSigma [which(postSigma[,p]<2),p],xlim=c(0,1)) }
