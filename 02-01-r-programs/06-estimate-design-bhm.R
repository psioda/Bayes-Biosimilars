
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
source("fit-bhm.rcpp");

setwd(paste(root,"02-02-r-output",sep="/"));
sp  = read.csv(file="bhm-simulation-design-inputs.csv");



num.per.node = 1;
start = 1 + (node.idx-1)*num.per.node;
stop  = min(node.idx*num.per.node,nrow(sp));

sp    = sp[start:stop,];
nsp   = nrow(sp);


dType      = c(0,1);
nSIM       = 20000;
nMC        = 25000;
nBI        = 150;



for (s in (1:nsp)) {

 sps        = sp[s,];
 npg        = c(sps$n1,sps$n2);
 gamma0     = sps$gamma0;
 tau0       = sps$tau0;
 alpha0     = sps$alpha0;
 beta0      = sps$gamma0;
 eqm        = c(sps$eqm1,sps$eqm2);

 if (sps$sp1==1 & sps$sp2==1) { samp.prior = matrix(c(0.81, 0.00,  0.00, 0.00,1.4),1,5); }
 if (sps$sp1==1 & sps$sp2==2) { samp.prior = matrix(c(0.81, 0.00,  0.00,-0.60,1.4),1,5); }
 if (sps$sp1==1 & sps$sp2==3) { samp.prior = matrix(c(0.81,-0.10,  0.00, 0.00,1.4),1,5); }
 if (sps$sp1==1 & sps$sp2==4) { samp.prior = matrix(c(0.81,-0.10,  0.00,-0.60,1.4),1,5); }
 
 if (sps$sp1==2 & sps$sp2==1) { 
   samp.prior = read.csv(file="sp.bar.nar.csv"); ns = nrow(samp.prior); 
   samp.prior = cbind(rep(0.81,ns),unlist(samp.prior$gamma1),rep(0.00,ns),unlist(samp.prior$gamma2),rep(1.4,ns));
   ## plot(samp.prior[,2],samp.prior[,4]);
 }
 if (sps$sp1==2 & sps$sp2==2) { 
   samp.prior = read.csv(file="sp.ba.nnp.csv"); ns = nrow(samp.prior); 
   samp.prior = cbind(rep(0.81,ns),unlist(samp.prior$gamma1),rep(0.00,ns),unlist(samp.prior$gamma2),rep(1.4,ns));
   ## plot(samp.prior[,2],samp.prior[,4]); hist(samp.prior[,2]);
 }
 if (sps$sp1==2 & sps$sp2==3) {    
   samp.prior = read.csv(file="sp.bnp.na.csv"); ns = nrow(samp.prior);
   samp.prior = cbind(rep(0.81,ns),unlist(samp.prior$gamma1),rep(0.00,ns),unlist(samp.prior$gamma2),rep(1.4,ns));
   ## plot(samp.prior[,2],samp.prior[,4]); hist(samp.prior[,4]);
 }

 x=data.frame(estBHMDesign(dType,samp.prior,npg,eqm,gamma0,tau0,alpha0,beta0,nSIM,nMC,nBI));
   colnames(x)<-c("alpha1","gamma1","alpha2","gamma2","sigma2","gamma","tau","pp1","pp2","rr1","rr2","pp12","rr12");
 z=data.frame(rbind(colMeans(samp.prior))); 
   colnames(z)<-c("sp.alpha1","sp.gamma1","sp.alpha2","sp.gamma2","sp.sigma2");
 w=rbind(c(unlist(sp[s,]),unlist(x),unlist(z))); 
   rownames(w)<-NULL

 if (s==1) { y = w } else { y = rbind(y,w) } 
}
name = paste("./estimate-design-bhm-",formatC(node.idx, width = 4, format = "d", flag = "0"),".csv",sep="")
write.csv(y,file=name ,row.names=F)

