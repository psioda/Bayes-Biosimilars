
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
sp         = read.csv(file="sp.3ind.settings.csv");

sp$trad.n1 = 328;
sp$trad.n2 = 119;
sp$trad.n3 = 477;


nsp     = nrow(sp);

set.seed(1267);

idx = 1;
for (s in (1:nsp))                 {
for (p1 in (1:2))                  {
for (p2 in (1:8))                  { 
for (i1 in seq(0.30,1.10,by=0.05)) {

   if (p1!=2 | p2 != 8) 
   {
     n1 = ceiling(sp$trad.n1[s]*i1);
     n2 = ceiling(sp$trad.n2[s]*i1);
     n3 = ceiling(sp$trad.n3[s]*i1);

     x = unlist(c(sp[s,],p1,p2,i1,n1,n2,n3,round(runif(1,1,2^20))));
     colnames(x) <- NULL
   
     if (idx==1) { y = x;          } 
     else        { y = rbind(y,x); }
     idx = idx+1;
   }
}
}
}
}


rownames(y) <- NULL
colnames(y) <- c("pi0","pi1","sd1","sd2","sd3","rho","change","eqm1","eqm2","eqm3",
                 "trad.n1","trad.n2","trad.n3","sp1","sp2","iFrac","n1","n2","n3","seed");
head(y);
tail(y);
write.csv(y,file="simulation-design-inputs-3ind.csv",row.names=F);