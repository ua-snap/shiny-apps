comArgs <- commandArgs(T)
if(length(comArgs>0)){
    arg.mat <- do.call("rbind",strsplit(comArgs,"="))
    options(warn=-1); arg.char <- which(is.na(as.numeric(arg.mat[,2]))); options(warn=0)
    if(length(arg.char>0)) arg.mat[arg.char,2] <- paste("'",arg.mat[arg.char,2],"'",sep="")
    eval(parse(text=apply(arg.mat,1,paste,collapse="=")))
}

dir.create(sinkDir <- "testing", showWarnings=F)
#sinkDir <- if(dirname(getwd())=="/home/uafsnap/shiny-apps") "../tmpAppFiles" else if(dirname(getwd())=="/var/www/shiny-server/shiny-apps") "/tmp"
sink(file=file.path("~",sinkDir,"system_call_test_results.txt"))
getwd()
x <- runif(1000,0,10)
y <- 0.5*x + rnorm(1000,2,2)
lm1 <- lm(y~x)
summary(lm1)
print(comArgs)
sink()
