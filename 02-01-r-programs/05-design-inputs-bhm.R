
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
sp = data.frame(rbind(c(0.00,100,0.01,0.01))); colnames(sp)<-c("gamma0","tau0","alpha0","beta0");


sp$eqm1    = 0.10;
sp$eqm2    = 0.60;
sp$trad.n1 = 328;
sp$trad.n2 = 119;

nsp     = nrow(sp);

set.seed(1258);

idx = 1;
for (s in (1:nsp))                 {
for (p1 in (1:2))                  {
for (p2 in (1:4))                  { 
for (i1 in seq(0.50,1.05,by=0.05)) {
for (i2 in seq(0.50,1.05,by=0.05)) {

   if (i1==i2 | i2==1)  {
   if (p1!=2 | p2 != 4) {
     n1 = ceiling(sp$trad.n1[s]*i1);
     n2 = ceiling(sp$trad.n2[s]*i2);

     x = unlist(c(sp[s,],p1,p2,i1,i2,n1,n2,round(runif(1,1,2^20))));
     colnames(x) <- NULL
   
     if (idx==1) { y = x;          } 
     else        { y = rbind(y,x); }
     idx = idx+1;
   }}  
}
}
}
}
}

rownames(y) <- NULL
colnames(y) <- c("gamma0","tau0","alpha0","beta0","eqm1","eqm2","trad.n1","trad.n2","sp1","sp2","iFrac1","iFrac2","n1","n2","seed");
write.csv(y,file="bhm-simulation-design-inputs.csv",row.names=F);