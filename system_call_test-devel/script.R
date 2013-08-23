sinkDir <- if(dirname(getwd())=="/home/uafsnap/shiny-apps") "../tmpAppFiles" else if(dirname(getwd())=="/var/www/shiny-server/shiny-apps") "/tmp"
sink(file=file.path(sinkDir,"system_call_test_results.txt"))
getwd()
x <- runif(1000,0,10)
y <- 0.5*x + rnorm(1000,2,2)
lm1 <- lm(y~x)
summary(lm1)
sink()
