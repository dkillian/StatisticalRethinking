a <- rnorm(100, 178, 20) # prior
a

b <- rnorm(100, 155, 5) # data
b

blik <- dnorm(b, 178, 20) # likelihood
blik
describe(blik)

bpost <- a * blik
bpost_st <- bpost / sum(bpost)
bpost_st
sum(bpost_st)
plot(bpost_st)

s <- runif(100, 0,50)
s

dat <- data.frame(a,s)

dat$p <- rnorm(100, dat$a, dat$s)

head(dat)

dat$lik <- dnorm(dat$p, dat$a, dat$s) # is this right? 

dat$alik <- dnorm(dat$a, 178,20)
dat$slik <- dunif(dat$s, 0, 50)
dat$plik <- 

plot(dat$p, dat$lik)
plot(dat$lik, type="l")
