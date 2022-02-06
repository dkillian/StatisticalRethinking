# Statistical Rethinking
# 2nd edition
# chimpanzees dataset


# general description -----------------------------------------------------

data(chimpanzees)

d <- chimpanzees
rm(chimpanzees)

?chimpanzees
names(d)
head(d)

map(d, frq)

frq(d$actor) # 7 monkeys in the trial
frq(d$recipient) # monkey on other side of the table, or no monkey
frq(d$condition) # partner monkey present or absent (treatment)
frq(d$block) # each monkey's set of partners or no partner
frq(d$trial) # sequence of trials for each chimp
frq(d$prosoc_left) # same as condition?
sum(d$condition == d$prosoc_left) # no condition and prosoc_left are different
frq(d$chose_prosoc) # chimp choice
frq(d$pulled_left) # among pulls, which left

# My own analysis would be a simple linear model
# in which chose_prosoc is the outcome and chose_prosoc is the outcome

l1 <- lm(chose_prosoc ~ condition, d)
summary(l1)
# monkeys are not prosocial

l2 <- lm(chose_prosoc ~ condition + pulled_left,
         d)
summary(l2)

l3 <- lm(chose_prosoc ~ condition + pulled_left + block,
         d)
summary(l3)

# still no treatment effect, but block appears to have some effect that needs to be understood

# how does McElreath handle this analysis? 

# "The conventional thing to do here is use these dummy variables to build a linear interaction model. 
# We aren't going to do that, for the reasoin discussed back in Chapter 5.
# Using dummy variables makes it hard to construct sensible priors. Take an index approach instead. 

## R code 11.2
d$treatment <- 1 + d$prosoc_left + 2*d$condition

frq(d$treatment)

table(d$condition, d$prosoc_left)

# 1 = prosocial condition on right side, no partner monkey
# 2 = 

## R code 11.3
xtabs( ~ treatment + prosoc_left + condition , d )

## R code 11.4
m11.1 <- quap(
  alist(
    pulled_left ~ dbinom( 1 , p ) ,
    logit(p) <- a ,
    a ~ dnorm( 0 , 10 )
  ) , data=d )

# this is just a model for how often each actor pulled left

## R code 11.5
set.seed(1999)
prior <- extract.prior( m11.1 , n=1e4 )

## R code 11.6
p <- inv_logit( prior$a )
dens( p , adj=0.1 )

## R code 11.7
m11.2 <- quap(
  alist(
    pulled_left ~ dbinom( 1 , p ) ,
    logit(p) <- a + b[treatment] ,
    a ~ dnorm( 0 , 1.5 ),
    b[treatment] ~ dnorm( 0 , 10 )
  ) , data=d )
set.seed(1999)
prior <- extract.prior( m11.2 , n=1e4 )
p <- sapply( 1:4 , function(k) inv_logit( prior$a + prior$b[,k] ) )

## R code 11.8
dens( abs( p[,1] - p[,2] ) , adj=0.1 )

## R code 11.9
m11.3 <- quap(
  alist(
    pulled_left ~ dbinom( 1 , p ) ,
    logit(p) <- a + b[treatment] ,
    a ~ dnorm( 0 , 1.5 ),
    b[treatment] ~ dnorm( 0 , 0.5 )
  ) , data=d )
set.seed(1999)
prior <- extract.prior( m11.3 , n=1e4 )
p <- sapply( 1:4 , function(k) inv_logit( prior$a + prior$b[,k] ) )
mean( abs( p[,1] - p[,2] ) )

## R code 11.10
# trimmed data list
dat_list <- list(
  pulled_left = d$pulled_left,
  actor = d$actor,
  treatment = as.integer(d$treatment) )

## R code 11.11
m11.4 <- ulam(
  alist(
    pulled_left ~ dbinom( 1 , p ) ,
    logit(p) <- a[actor] + b[treatment] ,
    a[actor] ~ dnorm( 0 , 1.5 ),
    b[treatment] ~ dnorm( 0 , 0.5 )
  ) , data=dat_list , chains=4 , log_lik=TRUE )
precis( m11.4 , depth=2 )

## R code 11.12
post <- extract.samples(m11.4)
p_left <- inv_logit( post$a )
plot( precis( as.data.frame(p_left) ) , xlim=c(0,1) )

## R code 11.13
labs <- c("R/N","L/N","R/P","L/P")
plot( precis( m11.4 , depth=2 , pars="b" ) , labels=labs )

## R code 11.14
diffs <- list(
  db13 = post$b[,1] - post$b[,3],
  db24 = post$b[,2] - post$b[,4] )
plot( precis(diffs) )

## R code 11.15
pl <- by( d$pulled_left , list( d$actor , d$treatment ) , mean )
pl[1,]

## R code 11.16
plot( NULL , xlim=c(1,28) , ylim=c(0,1) , xlab="" ,
      ylab="proportion left lever" , xaxt="n" , yaxt="n" )
axis( 2 , at=c(0,0.5,1) , labels=c(0,0.5,1) )
abline( h=0.5 , lty=2 )
for ( j in 1:7 ) abline( v=(j-1)*4+4.5 , lwd=0.5 )
for ( j in 1:7 ) text( (j-1)*4+2.5 , 1.1 , concat("actor ",j) , xpd=TRUE )
for ( j in (1:7)[-2] ) {
  lines( (j-1)*4+c(1,3) , pl[j,c(1,3)] , lwd=2 , col=rangi2 )
  lines( (j-1)*4+c(2,4) , pl[j,c(2,4)] , lwd=2 , col=rangi2 )
}
points( 1:28 , t(pl) , pch=16 , col="white" , cex=1.7 )
points( 1:28 , t(pl) , pch=c(1,1,16,16) , col=rangi2 , lwd=2 )
yoff <- 0.01
text( 1 , pl[1,1]-yoff , "R/N" , pos=1 , cex=0.8 )
text( 2 , pl[1,2]+yoff , "L/N" , pos=3 , cex=0.8 )
text( 3 , pl[1,3]-yoff , "R/P" , pos=1 , cex=0.8 )
text( 4 , pl[1,4]+yoff , "L/P" , pos=3 , cex=0.8 )
mtext( "observed proportions\n" )

## R code 11.17
dat <- list( actor=rep(1:7,each=4) , treatment=rep(1:4,times=7) )
p_post <- link( m11.4 , data=dat )
p_mu <- apply( p_post , 2 , mean )
p_ci <- apply( p_post , 2 , PI )

## R code 11.18
d$side <- d$prosoc_left + 1 # right 1, left 2
d$cond <- d$condition + 1 # no partner 1, partner 2

## R code 11.19
dat_list2 <- list(
  pulled_left = d$pulled_left,
  actor = d$actor,
  side = d$side,
  cond = d$cond )
m11.5 <- ulam(
  alist(
    pulled_left ~ dbinom( 1 , p ) ,
    logit(p) <- a[actor] + bs[side] + bc[cond] ,
    a[actor] ~ dnorm( 0 , 1.5 ),
    bs[side] ~ dnorm( 0 , 0.5 ),
    bc[cond] ~ dnorm( 0 , 0.5 )
  ) , data=dat_list2 , chains=4 , log_lik=TRUE )

## R code 11.20
compare( m11.5 , m11.4 , func=PSIS )

## R code 11.21
post <- extract.samples( m11.4 , clean=FALSE )
str(post)

## R code 11.22
m11.4_stan_code <- stancode(m11.4)
m11.4_stan <- stan( model_code=m11.4_stan_code , data=dat_list , chains=4 )
compare( m11.4_stan , m11.4 )

## R code 11.23
post <- extract.samples(m11.4)
mean( exp(post$b[,4]-post$b[,2]) )

## R code 11.24
data(chimpanzees)
d <- chimpanzees
d$treatment <- 1 + d$prosoc_left + 2*d$condition
d$side <- d$prosoc_left + 1 # right 1, left 2
d$cond <- d$condition + 1 # no partner 1, partner 2
d_aggregated <- aggregate(
  d$pulled_left ,
  list( treatment=d$treatment , actor=d$actor ,
        side=d$side , cond=d$cond ) ,
  sum )
colnames(d_aggregated)[5] <- "left_pulls"

## R code 11.25
dat <- with( d_aggregated , list(
  left_pulls = left_pulls,
  treatment = treatment,
  actor = actor,
  side = side,
  cond = cond ) )

m11.6 <- ulam(
  alist(
    left_pulls ~ dbinom( 18 , p ) ,
    logit(p) <- a[actor] + b[treatment] ,
    a[actor] ~ dnorm( 0 , 1.5 ) ,
    b[treatment] ~ dnorm( 0 , 0.5 )
  ) , data=dat , chains=4 , log_lik=TRUE )

## R code 11.26
compare( m11.6 , m11.4 , func=PSIS )

## R code 11.27
# deviance of aggregated 6-in-9
-2*dbinom(6,9,0.2,log=TRUE)
# deviance of dis-aggregated
-2*sum(dbern(c(1,1,1,1,1,1,0,0,0),0.2,log=TRUE))


