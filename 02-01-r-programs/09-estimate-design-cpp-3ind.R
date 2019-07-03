
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

setwd(paste(root,"02-02-r-output",sep="/"));
sp         = read.csv(file="simulation-design-inputs-3ind.csv");

num.per.node = 4;
start = 1 + (node.idx-1)*num.per.node;
stop  = min(node.idx*num.per.node,nrow(sp));

sp    = sp[start:stop,];
nsp   = nrow(sp);


dType      = c(0,1,0);
nSIM       = 10000;
nMC        = 20000;
nBI        = 200;


 read.sp = function(f="XX")
 {
   samp.prior = read.csv(file=f); ns = nrow(samp.prior); 
   samp.prior = cbind(rep(0.81,ns),unlist(samp.prior$gamma1),rep(0.00,ns),unlist(samp.prior$gamma2),rep(1.4,ns),rep(0.65,ns),unlist(samp.prior$gamma3));
   return(samp.prior);
 }


for (s in (1:nsp)) {

 sps        = sp[s,];
 npg        = c(sps$n1,sps$n2,sps$n3);
 sd         = c(sps$sd1,sps$sd2,sps$sd3);
 rho        = sps$rho;
 eqm        = c(sps$eqm1,sps$eqm2,sps$eqm3);

 if (sps$sp1==1 & sps$sp2==1) { samp.prior = matrix(c(0.81, 0.00,  0.00, 0.00,1.4,  0.65, 0.00),1,7); }
 if (sps$sp1==1 & sps$sp2==2) { samp.prior = matrix(c(0.81, 0.00,  0.00,-0.60,1.4,  0.65, 0.00),1,7); }
 if (sps$sp1==1 & sps$sp2==3) { samp.prior = matrix(c(0.81,-0.10,  0.00, 0.00,1.4,  0.65, 0.00),1,7); }
 if (sps$sp1==1 & sps$sp2==4) { samp.prior = matrix(c(0.81, 0.00,  0.00, 0.00,1.4,  0.65,-0.10),1,7); }
 if (sps$sp1==1 & sps$sp2==5) { samp.prior = matrix(c(0.81,-0.10,  0.00,-0.60,1.4,  0.65, 0.00),1,7); }
 if (sps$sp1==1 & sps$sp2==6) { samp.prior = matrix(c(0.81,-0.10,  0.00, 0.00,1.4,  0.65,-0.10),1,7); }
 if (sps$sp1==1 & sps$sp2==7) { samp.prior = matrix(c(0.81, 0.00,  0.00,-0.60,1.4,  0.65,-0.10),1,7); }
 if (sps$sp1==1 & sps$sp2==8) { samp.prior = matrix(c(0.81,-0.10,  0.00,-0.60,1.4,  0.65,-0.10),1,7); }

 if (sps$sp1==2 & sps$sp2==1) { samp.prior = read.sp(f="sp.3ind.bar.nar.bar.csv") }
 if (sps$sp1==2 & sps$sp2==2) { samp.prior = read.sp(f="sp.3ind.ba.na.bnp.csv")   }
 if (sps$sp1==2 & sps$sp2==3) { samp.prior = read.sp(f="sp.3ind.ba.nnp.ba.csv")   }
 if (sps$sp1==2 & sps$sp2==4) { samp.prior = read.sp(f="sp.3ind.bnp.na.ba.csv")   }
 if (sps$sp1==2 & sps$sp2==5) { samp.prior = read.sp(f="sp.3ind.ba.nnp.bnp.csv")  }
 if (sps$sp1==2 & sps$sp2==6) { samp.prior = read.sp(f="sp.3ind.bnp.na.bnp.csv")  }
 if (sps$sp1==2 & sps$sp2==7) { samp.prior = read.sp(f="sp.3ind.bnp.nnp.ba.csv")  }

 x=data.frame(estCPPDesign(dType,samp.prior,npg,sd,rho,eqm,nSIM,nMC,nBI));
   colnames(x)<-c("alpha1","gamma1","alpha2","gamma2","sigma2","alpha3","gamma3","pp1","pp2","pp3","rr1","rr2","rr3","pp12","rr12");

 z=data.frame(rbind(colMeans(samp.prior))); 
   colnames(z)<-c("sp.alpha1","sp.gamma1","sp.alpha2","sp.gamma2","sp.sigma2","sp.alpha3","sp.gamma3");

 w=rbind(c(unlist(sp[s,]),unlist(x),unlist(z))); 
   rownames(w)<-NULL

 if (s==1) { y = w } else { y = rbind(y,w) } 
}
name = paste("./estimate-design-cpp-3ind-",formatC(node.idx, width = 4, format = "d", flag = "0"),".csv",sep="")
write.csv(y,file=name ,row.names=F)

