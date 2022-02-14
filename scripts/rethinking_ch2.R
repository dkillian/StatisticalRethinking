# Statistical Rethinking
# Chapter 2 notes

Can we replicate the action of the quadratic approximation through simulation? Let's try. 

```{r}

out <- data.frame(id=1:10000) %>%
  mutate(prior = runif(1e4, 0,1), #Pr(p)
         param = runif(1e4, 0,1), #p
         #obs = rbinom(1e4,9, param),
         lik = dbinom(6, 9, param),
         unstd.post = lik*prior,
         posterior = unstd.post/sum(unstd.post),
         model_post = unlist(globe.samp))

head(out)
str(out)

```

```{r}

ggplot(out, aes()) + 
#  geom_density(aes(posterior)) +
  #geom_density(aes(posterior)) +
  geom_density(aes(x=model_post))
  
  geom_point() + 
  geom_line() + 

```

I could not simulate it. 