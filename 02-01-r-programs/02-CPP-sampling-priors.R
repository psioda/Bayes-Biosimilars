
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

parms        = read.csv(file="cpp-hyperparameters-percent-reduction.csv"); head(parms);
piChange     = round((parms$pi1-parms$pi0)/(1-parms$pi0)*100)
parms$change = piChange;

idx = ( parms$pi0     == 0.33 | parms$pi0     == 0.50 | parms$pi0     == 0.67 | parms$pi0    == 0.75 ) & 
      ( parms$change  == 0    | parms$change  == 25   | parms$change  == 50    );

parms.sp  = parms[ (parms$pi0 == 0.75) & (parms$change == 50) , ]
parms.cpp = parms[idx,]

write.csv(parms.cpp,file="sp.settings.csv",row.names=F);


 sd     = unlist(c(parms.sp$sd1,parms.sp$sd2));
 rho    = parms.sp$rho;
 
 set.seed(1);


 ## CPP truncated to restricted alternative space -- 2,AA;
 lower.lim  = c(-0.05,-0.30);
 upper.lim  = c( 0.05, 0.30);
 sp.bar.nar = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp.bar.nar) <- c("gamma1","gamma2");
    write.csv(sp.bar.nar,file="sp.bar.nar.csv",row.names=F);

 ## CPP -- Binary alternative - Normal component condioned on inferiority boundary value -- 2,AN;
 lower.lim  = c(-0.10,-0.60);
 upper.lim  = c( 0.10,-0.60);
 sp.ba.nnp  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp.ba.nnp) <- c("gamma1","gamma2");
    write.csv(sp.ba.nnp,file="sp.ba.nnp.csv",row.names=F);

 ## CPP -- Normal alternative - Binary component condioned on inferiority boundary value -- 2,NA;
 lower.lim  = c(-0.10,-0.60);
 upper.lim  = c(-0.10, 0.60);
 sp.bnp.na  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp.bnp.na) <- c("gamma1","gamma2");
    write.csv(sp.bnp.na,file="sp.bnp.na.csv",row.names=F);




 ## sample from CPP distribution (plot);
 lower.lim = c(-20,-20);
 upper.lim = c( 20, 20); 
 sp.all    = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp.all) <- c("gamma1","gamma2");
    write.csv(sp.all,file="sp.all.csv",row.names=F);

 ## CPP truncated to alternative space (plot);
 lower.lim = c(-0.10,-0.60);
 upper.lim = c( 0.10, 0.60); 
 sp.ba.na  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp.ba.na) <- c("gamma1","gamma2");
    write.csv(sp.ba.na,file="sp.ba.na.csv",row.names=F);

 ## CPP -- Normal component condioned on inferiority (plot);
 lower.lim = c(-20, -20);
 upper.lim = c( 20,-0.60);
 sp.b.nn   = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp.b.nn) <- c("gamma1","gamma2");
    write.csv(sp.b.nn,file="sp.b.nn.csv",row.names=F);

 ## CPP -- Normal component condioned on alternative (plot);
 lower.lim = c(-20,-0.60);
 upper.lim = c( 20, 0.60);
 sp.b.na   = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp.b.na) <- c("gamma1","gamma2");
    write.csv(sp.b.na,file="sp.b.na.csv",row.names=F);

 ## CPP -- Normal component condioned on inferiority boundary (plot);
 lower.lim = c(-20,-0.60);
 upper.lim = c( 20,-0.60);
 sp.b.nnp  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp.b.nnp) <- c("gamma1","gamma2");
    write.csv(sp.b.nnp,file="sp.b.nnp.csv",row.names=F);

 ## CPP -- Normal component condioned on perfect equivalence (plot);
 lower.lim = c(-20,0.0);
 upper.lim = c( 20,0.0);
 sp.b.nap  = sampleCPP(sd,rho,lower.lim,upper.lim,nMC=500000,nBI=200); colnames(sp.b.nap) <- c("gamma1","gamma2");
    write.csv(sp.b.nap,file="sp.b.nap.csv",row.names=F);


