# Statistical Rethinking 2024
# Week 1 notes


# function to toss a globe covered p by water N times

sim_globe <- function(p=.7,
                      N=9) {
  sample(c("W","L"), 
         size=N,
         prob=c(p, 1-p), replace=T)
}

sim_globe()

replicate(sim_globe(p=.5,
                    N=9),
          n=10)

sim_globe(p=1, N=11)

sum(sim_globe(p=.5, N=1e4) == "W") / 1e4

# code the estimator ---- 

# fuction to compute posterior distribution

compute_posterior <- function(the_sample,
                              poss=c(0,.25,.5,.75,1) ) {
  W <- sum(the_sample=="W") # number of W observed
  L <- sum(the_sample=="L") # number of L observed
  ways <- sapply(poss, function(q) (q*4)^W * (1-q)*4^L)
  post <- ways/sum(ways)
  bars <- sapply(post, function(q) make_bar(q) )
  data.frame(poss, ways, post=round(post,3), bars)
}  

compute_posterior(sim_globe())



se <- (.25 * .75) / 11 %>%
  sqrt()
se

?dbinom
dbinom(25, 100, .67)

.25 + c(-1.96*se, 1.96*se)

post_samples <- data.frame(y=rbeta(1e4, 6+1, 3+1))

head(post_samples)
print(psych::describe(post_samples),
      digits=4)

ggplot(post_samples, aes(y)) +
  geom_vline(xintercept=mean(post_samples$y),
             color="darkgoldenrod",
             size=1) +
  geom_vline(xintercept=median(post_samples$y),
             color="maroon",
             size=1) +
  geom_density(color="blue",
               fill="dodgerblue2",
               size=1,
               alpha=.5) +
  scale_x_continuous(limits=c(0,1),
                     breaks=seq(0,1,.1),
                     labels=percent_format(accuracy=1)) + 
  theme(axis.text.y=element_blank()) + 
  labs(x="",
       y="")

# now simulate posterior predictive distribution 

post_samples <- rbeta(1e4, 6+1, 3+1)

dens(post_samples, lwd=4, col=2, xlab="proportion water", adj=.1)
curve(dbeta(x, 6+1, 3+1), add=T, lty=2, lwd=3)

pred_post <- sapply(post_samples, function(p) sum(sim_globe(p, 10)=="W"))

tab_post <- table(pred_post)

tab_post

ggplot(tab_post)

plot(tab_post)
for ( i in 0:10 ) lines(c(i,i),c(0,tab_post[i+1]),lwd=4,col=4)

# inference for a proportion - FREQUENTIST ---- 


# inference for a proportion - BAYES ---- 


p <- seq(.1,.9, .1)  
p  

prior <- c(rep(.06,4), .52, rep(.06,4))
prior

lik <- dbinom(4,20,p)
lik

