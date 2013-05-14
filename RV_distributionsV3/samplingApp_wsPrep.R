n.default <- 500
#discrete r* wrapper functions
rbern <- function(n=n.default,bern.prob=0.5){ rbinom(n=n,size=1,prob=bern.prob) }
rbinom2 <- function(n=n.default,binom.size=10,binom.prob=0.5){ rbinom(n,size=binom.size,prob=binom.prob) }
drunif <- function(n=n.default,drunif.min=0,drunif.max=100,drunif.step=1){ sample(seq(drunif.min,drunif.max,by=drunif.step),size=n,rep=T) }
rgeom2 <- function(n=n.default,geom.prob=0.5){ rgeom(n,prob=geom.prob) }
rhyper2 <- function(n=n.default,hyper.M=10,hyper.N=20,hyper.K=10){ rhyper(nn=n,m=hyper.M,n=hyper.N-hyper.M,k=hyper.K) }
rnbinom2 <- function(n=n.default,nbin.size=10,nbin.prob=0.5){ rnbinom(n,size=nbin.size,prob=nbin.prob) }
rpois2 <- function(n=n.default,poi.lambda=10){ rpois(n,poi.lambda) }
# continuous r* wrapper functions
rbeta2 <- function(n=n.default,beta.shape1=2,beta.shape2=2){ rbeta(n,shape1=beta.shape1,shape2=beta.shape2) }
rcauchy2 <- function(n=n.default,cau.location=0,cau.scale=1){ rcauchy(n,location=cau.location,scale=cau.scale) }
rchisq2 <- function(n=n.default,chisq.df=1){ rchisq(n,df=chisq.df) }
rexp2 <- function(n=n.default,exp.rate=1){ rexp(n=n,rate=exp.rate) }
rf2 <- function(n=n.default,F.df1=1,F.df2=15){ rf(n,df1=F.df1,df2=F.df2) }
rgamma2 <- function(n=n.default,gam.shape=1,gam.rate=1){ rgamma(n,shape=gam.shape,rate=gam.rate) }
rlaplace2 <- function(n=n.default,lap.location=0,lap.scale=1){ rlaplace(n,location=lap.location,scale=lap.scale) }
rlogis2 <- function(n=n.default,logi.location=0,logi.scale=1){ rlogis(n,location=logi.location,scale=logi.scale) }
rpareto2 <- function(n=n.default,pareto.location=1,pareto.shape=3){ rpareto(n,location=pareto.location,shape=pareto.shape) }
rweibull2 <- function(n=n.default,weib.shape=1,weib.scale=1){ rweibull(n,shape=weib.shape,scale=weib.scale) }
rt2 <- function(n=n.default,t.df=15){ rt(n=n,df=t.df) }

# Continuous distribution plotmath expressions:
expr.beta <- expression(italic(paste(displaystyle(f(x)~"="~frac(Gamma(alpha+beta),Gamma(alpha)*Gamma(beta))*x^{alpha-1}*(1-x)^{beta-1})
					~~~~displaystyle(list(paste(0<=x) <=1, atop(paste(0<alpha) <infinity, paste(0<beta) <infinity)))
					)))

expr.cauchy <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,pi*sigma)~frac(1,1+bgroup("(",frac(x-theta,sigma),")")^2))
					~~~~displaystyle(list(paste(-infinity<x) <infinity, atop(paste(-infinity<theta) <infinity, sigma > 0)))
					)))

expr.chisq <- expression(italic(paste(frac(1,2^{frac(nu,2)}*Gamma~bgroup("(",frac(nu,2),")"))*x^{frac(nu,2)-1}*e^{-frac(x,2)}
					~~~~displaystyle(atop(paste(0<=x) <infinity, nu~"="~list(1,2,...)))
					)))

expr.exp <- expression(italic(paste(displaystyle(f(x)~"="~lambda*e^{-lambda*x})
					~~~~displaystyle(atop(paste(0<=x) <infinity,lambda>0))
					)))

expr.F <- expression(italic(paste(displaystyle(f(x)~"="~frac(Gamma~bgroup("(",frac(nu[1]+nu[2],2),")"),Gamma~bgroup("(",frac(nu[1],2),")")~Gamma~bgroup("(",frac(nu[2],2),")"))
					~bgroup("(",frac(nu[1],nu[2]),")")^{frac(nu[1],2)}~frac(x^{frac(nu[1],2)-1},bgroup("(",1+frac(d[1],d[2])*x,")")^{frac(d[1]+d[2],2)}))
					~~~~displaystyle(atop(paste(0<=x) <infinity,list(d[1],d[2])~"="~list(1,2,...)))
					)))

expr.gam <- expression(italic(paste(displaystyle(f(x)~"="~frac(beta^alpha,Gamma(alpha))*x^{alpha-1}*e^{-beta*x})
					~~~~displaystyle(list(paste(0<x) <infinity, atop(paste(0<alpha) <infinity, paste(0<beta) <infinity)))
					)))

expr.lap <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,2*sigma)~e^{-frac(abs(x-mu),sigma)})
					~~~~displaystyle(list(paste(-infinity<x) <infinity, atop(paste(-infinity<mu) <infinity, sigma > 0)))
					)))

expr.logi <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,beta)~frac(e^{-frac(x-mu,beta)},bgroup("[",1+e^{-frac(x-mu,beta)},"]")^2))
					~~~~displaystyle(list(paste(-infinity<x) <infinity, atop(paste(-infinity<mu) <infinity, beta > 0)))
					)))

expr.lognorm <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,x*sigma*sqrt(2*pi))~e^{-frac((log(x)-mu)^2,2*sigma^2)})
					~~~~displaystyle(list(paste(0<x) <infinity, atop(paste(-infinity<log(mu)) <infinity, paste(0<sigma^scriptscriptstyle("2")) <infinity)))
					)))

expr.norm <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,sqrt(2*pi*sigma^scriptscriptstyle("2")))~e^{frac(-1,2*sigma^{scriptscriptstyle("2")})*(x-mu)^scriptscriptstyle("2")})
					~~~~displaystyle(list(paste(-infinity<x) <infinity, atop(paste(-infinity<mu) <infinity, paste(0<sigma^scriptscriptstyle("2")) <infinity)))
					)))

expr.pareto <- expression(italic(paste(displaystyle(f(x)~"="~frac(beta*alpha^beta,x^{beta+1}))
					~~~~displaystyle(atop(paste(alpha<x) <infinity, list(alpha,beta) > 0))
					)))

expr.t <- expression(italic(paste(displaystyle(f(x)~"="~frac(Gamma~bgroup("(",frac(nu+1,2),")"),sqrt(nu*pi)~Gamma~bgroup("(",frac(nu,2),")"))~bgroup("(",1+frac(x^2,nu),")")^{-frac(nu+1,2)})
					~~~~displaystyle(atop(paste(-infinity<x) <infinity, nu > 0))
					)))

expr.unif <- expression(italic(paste(displaystyle(f(x)~"="~frac(1,b-a)
					~~~~displaystyle(paste(-infinity<paste(a<=paste(x<=b))) <infinity))
					)))

expr.weib <- expression(italic(paste(displaystyle(f(x)~"="~frac(k,lambda)~bgroup("(",frac(x,lambda),")")^{k-1}*e^(-x/lambda)^k)
					~~~~displaystyle(atop(paste(0<=x) <infinity, list(k,lambda) > 0))
					)))

# Discrete distribution plotmath expressions:
expr.bern <- expression(italic(paste(displaystyle(P(X~"="~x)~"="~p^x*(1-p)^{1-x})
					~~~~displaystyle(atop(x~"="~list(0,1), paste(0<=p)<=1))
					)))

expr.bin <- expression(italic(paste(displaystyle(P(X~"="~x)~"="~bgroup("(",atop(n,x),")")~p^x*(1-p)^{n-x})
					~~~~displaystyle(atop(x~"="~list(0,1,...,n), paste(0<=p)<=1))
					)))

expr.dunif <- expression(italic(paste(displaystyle(P(X~"="~x)~"="~frac(1,N))
					~~~~displaystyle(x~"="~list(1,2,...,N))
					)))

expr.geom <- expression(italic(paste(displaystyle(P(X~"="~x)~"="~p*(1-p)^x)
					~~~~displaystyle(atop(x~"="~list(1,2,...), paste(0<=p)<=1))
					)))

expr.hgeom <- expression(italic(paste(displaystyle(P(X~"="~x)~"="~frac(bgroup("(",atop(M,x),")")~bgroup("(",atop(N-M,K-x),")"),bgroup("(",atop(N,K),")")))
					~~~~displaystyle(list(x~"="~list(0,1,...,K), atop(paste(M-(N-K)<=x)<=M, list(N,M,K)>=0)))
					)))

expr.nbin <- expression(italic(paste(displaystyle(P(X~"="~x)~"="~frac(Gamma(x+n),Gamma(n)*x*"!")~p^r*(1-p)^x)
					~~~~displaystyle(atop(x~"="~list(0,1,...), paste(0<=p)<=1))
					)))

expr.poi <- expression(italic(paste(displaystyle(P(X~"="~x)~"="~frac(e^{-lambda}*lambda^x,x*"!"))
					~~~~displaystyle(atop(x~"="~list(0,1,...), paste(0<=lambda)<infinity))
					)))
