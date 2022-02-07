# prep

smallBase <- c("arm", "BMA", "brms", "corrplot", "dummies","DescTools", "estimatr","extrafont", "forestplot", "janitor", "memisc","reshape2", "rethinking",
               "tidyr","broom", "haven", "HH","Hmisc","lubridate","knitr", "margins", "magrittr", "plotrix",
               "scales","survey", "srvyr", "foreign","car", "ICC", "openxlsx", "ggrepel", "readr",
               "readxl","labelled", "texreg", "janitor", "sysfonts", "sjmisc",
               "psych","dplyr", "tidyverse", "tidybayes", "viridis", "here", "ggridges", "ggthemes", "DT",
               "workflowr", "pointblank", "cmdstanr")


lapply(smallBase, library, character.only=T)

font_add_google("Open Sans", "sans-serif")
#?font_add_google

options(digits=3, scipen=6)

base <- theme_bw() +  theme(panel.grid.minor.x=element_blank(),
                              panel.grid.minor.y=element_blank(),
                              plot.title=element_text(face="bold",size=16, hjust=.5, family = "Gill Sans Mt"),
                              plot.subtitle = element_text(size=16, family="Gill Sans Mt"),
                              plot.caption=element_text(size=12, family="Gill Sans Mt"),
                              axis.title=element_text(size=16, family="Gill Sans Mt"),
                              axis.text=element_text(size=14, family="Gill Sans Mt"),
                              legend.text=element_text(size=14, family="Gill Sans Mt"),
                              strip.text=element_text(size=14, family="Gill Sans Mt"),
                              panel.border=element_blank(),
                              axis.ticks=element_blank())

theme_set(base)

faceted <- theme_bw() +
  theme(panel.grid.minor.x=element_blank(),
        panel.grid.minor.y=element_blank(),
        plot.title=element_text(face="bold",size=16, hjust=.5, family = "Gill Sans Mt"),
        plot.subtitle = element_text(size=16, family="Gill Sans Mt"),
        plot.caption=element_text(size=12, family="Gill Sans Mt"),
        axis.title=element_text(size=16, family="Gill Sans Mt"),
        axis.text=element_text(size=14, family="Gill Sans Mt"),
        legend.text=element_text(size=14, family="Gill Sans Mt"),
        strip.text=element_text(size=14, family="Gill Sans Mt"))
