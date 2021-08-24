# Graphical lasso regularizes FC matrices
library(glasso)
library(pracma)
setwd("path_to_ROI_timeseries")
rho_lasso <-  seq(0.02,0.2,by=0.02)
N_task <- 8
N_sub <- 25
N_lasso <- length(rho_lasso)
rho_best <- matrix(0,nrow=N_sub)
for (sub in 1 : N_sub){
  pa = paste0('S', sprintf("%02d", as.numeric(sub)),sep='', collapse='') 
  mat <- c()
  cnt <- 0
  task_id<- c()
  N_len <- matrix(0,N_task,1)
  file_name <- list.files(pattern = pa)
  for (task in 1 : length(file_name)){
    mat_tmp <- scan(file_name[task],quiet = TRUE)
    mat_tmp <- matrix(mat_tmp, ncol = 363, byrow = TRUE)
    tmp <- dim(mat_tmp)
    N_len[task] <- tmp[1]
    task_id <- rbind(task_id,matrix(task,N_len[task],1))
    cnt <- cnt + N_len[task]
    mat <- rbind(mat,mat_tmp)
  }
  N_all <- sum(N_len)
  S_all <- cov(mat) # sample covariance
  logl <- matrix(0, nrow = N_lasso, ncol = N_task) # negative log-likelihood likelihood
  for (j in 1 : length(rho_lasso)){
      for (task in 1 : N_task){
        mat_train <- which(task_id %in% task)
        S_train <- cov(mat[mat_train,])
        a <- glasso(S_train,rho_lasso[j])
        # 1/2*log(det(a$wi)) -1/2*sum(diag(S_all%*%a$wi)) - rho_lasso[j]*sum(sum(a$wi))
        logl[j,task] <- -log(det(a$wi))+sum(diag(S_all%*%a$wi)) # minimize the negative log-likelihood
        outname <- paste0("./cov/rho",rho_lasso[j],"_",file_name[task],sep='', collapse='') 
        write.table(a$w, file=outname, row.names=FALSE, col.names=FALSE)
        }
      }
  rho_best[sub] = rho_lasso[which.min(rowMeans(logl))] 
  sub
}
outname <- paste0("../best_rho.txt",sep='', collapse='') 
write.table(rho_best, file=outname, row.names=FALSE, col.names=FALSE)
