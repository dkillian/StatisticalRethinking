# Statistical rethinking
# Second edition
# Chapter 2 Small worlds and large worlds
# notes

d <- tibble(toss=c("w","l","w","w","w","l","w","l","w"))
d

d <- d %>% 
  mutate(n_trials  = 1:9,
         n_success = cumsum(toss == "w"))

d

sequence_length <- 50

e <- d %>% 
  expand(nesting(n_trials, toss, n_success), 
         p_water = seq(from = 0, to = 1, length.out = sequence_length)) %>% 
  group_by(p_water) %>% 
  mutate(lagged_n_trials  = lag(n_trials, k = 1),
         lagged_n_success = lag(n_success, k = 1)) %>% 
  ungroup() %>% 
  mutate(prior_pre      = ifelse(n_trials == 1, .5,
                                 dbinom(x    = lagged_n_success, 
                                        size = lagged_n_trials, 
                                        prob = p_water)),
         likelihood = dbinom(x    = n_success, 
                             size = n_trials, 
                             prob = p_water),
         strip      = paste(n_success, n_trials, sep="/")) %>% 
  # the next three lines allow us to normalize the prior and the likelihood, 
  # putting them both in a probability metric 
  group_by(n_trials) %>% 
  mutate(prior      = prior_pre / sum(prior_pre),
         likelihood = likelihood / sum(likelihood)) 

e   


ggplot(e, aes(x = p_water)) +
  geom_line(aes(y = prior, linetype="prior")) +
  geom_line(aes(y = likelihood, linetype="posterior")) +
  scale_x_continuous(breaks = c(0, .5, 1),
                     labels=c("0","0.5","1")) +
  scale_y_continuous(breaks = NULL) +
  facet_wrap(~strip, scales = "free_y") +
  scale_linetype_manual(values=c("prior" = 2,
                                 "posterior" = 1),
                        guide=guide_legend(reverse=T)) + 
  theme(legend.title=element_blank()) +
  labs(title="Bayesian updating for cumulative successes / trials",
       x="proportion water",
       y="plausibility",
       caption="The posterior of one graph becomes the prior of the next graph") 

ggsave("2nd edition/viz/Chapter 2/Figure 2.5.png",
       type="cairo",
       device="png",
       height=4,
       width=7)





p_grid <- seq( from=0 , to=1 , length.out=20 )

# define prior
prior <- rep( 1 , 20 )

# compute likelihood at each value in grid
likelihood <- dbinom( 6 , size=9 , prob=p_grid )

# compute product of likelihood and prior
unstd.posterior <- likelihood * prior

# standardize the posterior, so it sums to 1
posterior <- unstd.posterior / sum(unstd.posterior)

## R code 2.4
plot( p_grid , posterior , type="b" ,
      xlab="probability of water" , ylab="posterior probability" )
mtext( "20 points" )


ggplot(data.frame(x=p_grid, y=posterior), aes(x,y)) + 
  stat_smooth(color="darkblue", se=F, span=.2)  +
  geom_point(color="darkblue", size=2) + 
  geom_vline(xintercept=6/9, color="darkgoldenrod3", size=1, alpha=.4) +
  labs(title="Uniform prior") +
  nobord

ggsave("2nd edition/viz/Chapter 2/Figure 2.7b.png",
       type="cairo",
       device="png",
       height=4,
       width=7)


## R code 2.5
prior <- ifelse( p_grid < 0.5 , 0 , 1 )

# compute likelihood at each value in grid
likelihood <- dbinom( 6 , size=9 , prob=p_grid )

# compute product of likelihood and prior
unstd.posterior <- likelihood * prior

# standardize the posterior, so it sums to 1
posterior <- unstd.posterior / sum(unstd.posterior)

ggplot(data.frame(x=p_grid, y=posterior), aes(x,y)) + 
  stat_smooth(color="darkblue", se=F, span=.2)  +
  geom_point(color="darkblue", size=2) + 
  geom_vline(xintercept=6/9, color="darkgoldenrod3", size=1, alpha=.4) +
  labs(title="Kinked prior (0 if < .5, otherwise 1)") +
  nobord

ggsave("2nd edition/viz/Chapter 2/Figure 2.7b kinked.png",
       type="cairo",
       device="png",
       height=4,
       width=7)



prior <- exp( -5*abs( p_grid - 0.5 ) )

# compute likelihood at each value in grid
likelihood <- dbinom( 6 , size=9 , prob=p_grid )

# compute product of likelihood and prior
unstd.posterior <- likelihood * prior

# standardize the posterior, so it sums to 1
posterior <- unstd.posterior / sum(unstd.posterior)

ggplot(data.frame(x=p_grid, y=posterior), aes(x,y)) + 
  stat_smooth(color="darkblue", se=F, span=.2)  +
  geom_point(color="darkblue", size=2) + 
  geom_vline(xintercept=6/9, color="darkgoldenrod3", size=1, alpha=.4) +
  labs(title="Exponential prior") +
  nobord

ggsave("2nd edition/viz/Chapter 2/Figure 2.7b exponential.png",
       type="cairo",
       device="png",
       height=4,
       width=7)



W <- 6
L <- 3
curve( dbeta( x , W+1 , L+1 ) , from=0 , to=1 )
# quadratic approximation
curve( dnorm( x , 0.67 , 0.16 ) , lty=2 , add=TRUE )

a <- ggplot(data.frame(x=c(0,1)), aes(x)) + 
  stat_function(fun=dnorm,
                args = list(mean=.67,
                            sd=.16),
                aes(color="exact"), size=1) +
  stat_function(fun=dbeta,
                args=list(shape1=W+1,
                          shape2=L+1),
                size=1, aes(color="quadratic"), alpha=.6) +
  nobord +
    scale_color_manual(values=c("quadratic" = "maroon",
                                "exact" = "darkblue")) +
  theme(legend.title=element_blank()) +
  labs(title="n=9")

a

ggsave("2nd edition/viz/Chapter 2/Figure 2.8a n=9.png",
       type="cairo",
       device="png",
       height=4,
       width=7)



W <- 12
L <- 6

b <- ggplot(data.frame(x=c(0,1)), aes(x)) + 
  stat_function(fun=dnorm,
                args = list(mean=.67,
                            sd=.16),
                aes(color="exact"), size=1) +
  stat_function(fun=dbeta,
                args=list(shape1=W+1,
                          shape2=L+1),
                size=1, aes(color="quadratic"), alpha=.6) +
  nobord +
  scale_color_manual(values=c("quadratic" = "maroon",
                              "exact" = "darkblue")) +
  theme(legend.title=element_blank()) +
  labs(title="n=18")

b

ggsave("2nd edition/viz/Chapter 2/Figure 2.8b n=18.png",
       type="cairo",
       device="png",
       height=4,
       width=7)


W <- 24
L <- 12

d <- ggplot(data.frame(x=c(0,1)), aes(x)) + 
  stat_function(fun=dnorm,
                args = list(mean=.67,
                            sd=.16),
                aes(color="exact"), size=1) +
  stat_function(fun=dbeta,
                args=list(shape1=W+1,
                          shape2=L+1),
                size=1, aes(color="quadratic"), alpha=.6) +
  nobord +
  scale_color_manual(values=c("quadratic" = "maroon",
                              "exact" = "darkblue")) +
  theme(legend.title=element_blank()) +
  labs(title="n=36")

d

ggsave("2nd edition/viz/Chapter 2/Figure 2.8c n=36.png",
       type="cairo",
       device="png",
       height=4,
       width=7)



  
