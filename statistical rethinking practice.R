p <- seq(0,1,length.out=1000)
prior <- rep(1,1000)
likelihood <- dbinom(6, 9, p)
posterior <- likelihood * prior
p2 <- posterior / sum(posterior)

plot(seq)


mu <- dnorm(178,.1)
?dnorm
  
  curve( dnorm( x , 178 , 20 ) , from=100 , to=250 ) # prior comes from author being 178 cm 
