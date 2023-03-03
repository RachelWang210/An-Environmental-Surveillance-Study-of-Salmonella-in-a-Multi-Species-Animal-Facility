install.packages("aod")
install.packages("ggplot2")
install.packages("lme4")
install.packages("Matrix")
install.packages("sjPlot")
install.packages("car")
install.packages('multcomp')

library(aod)
library(ggplot2)
library(Matrix)
library(lme4)
library(sjPlot)
library(car)
library(multcomp)

###improt data
setwd("D:/1WORK/Class/7250/MCMC/jags-exercises-master")
sam <- read.csv("Environmental Project Compiled Information.csv", stringsAsFactors = T)
View(sam)

###change salmonella into 0 and 1
sam$Salmonella_Positive<-ifelse(sam$Salmonella_Positive=='Yes', 1,0)



###fix effect logit regression
# Samlogit <- glm(Salmonella_Positive ~ Humidity + Temp + Season + Facility + Region +
#                   Species + Condition + Environment + Sample_Method, data = sam, family = "binomial")
# 
# Samlogit





###interprete
###model log(p/1-p)=B0+B1*Humidity+B2*Temp+B3*spring+B4*summer+B5*winter+B6*SD+B7*SE+B8*SW+B9*Rain+B10*Fecal
              #      +B11*Feed+B12*Surface+B13*water


##change ref level
sam$Sample_Method <- relevel(sam$Sample_Method, ref='Feed/Hay')#Feed/Hay is ref level
sam$Condition <- relevel(sam$Condition, ref='Rain')# Dry is ref level
sam$Species <- relevel(sam$Species, ref='Wildlife')#wildlife is the ref level

###since humidity and temparature are insignificant, we can remove from the model
SamlogitR2 <- glmer(Salmonella_Positive ~  Season + (1|Region) +
                      Species + Condition + Sample_Method, data = sam, family = binomial, nAGQ = 2)

summary(SamlogitR2)

### ANOVA
#car::Anova(SamlogitR2)

###sjPlot, showing odds ratio compare to reference level
sjplot <- sjt.glmer(SamlogitR2, group.pred = TRUE, p.numeric = TRUE,show.re.var = TRUE, exp.coef = TRUE)

sjplot

###get tukey level comparesion
##season
Samghlt.season <- glht(glmer(Salmonella_Positive ~ Season + Species + Condition + Sample_Method + (1|Region),
                      data = sam, family = binomial, nAGQ = 2) , linfct = mcp(Season = "Tukey"))
summary(Samghlt.season)

##Species
Samghlt.Species <- glht(glmer(Salmonella_Positive ~ Season + Species + Condition + Sample_Method + (1|Region),
                             data = sam, family = binomial, nAGQ = 2) , linfct = mcp(Species = "Tukey"))
summary(Samghlt.Species)

##Condition
Samghlt.Condition <- glht(glmer(Salmonella_Positive ~ Season + Species + Condition + Sample_Method + (1|Region),
                              data = sam, family = binomial, nAGQ = 2) , linfct = mcp(Condition = "Tukey"))
summary(Samghlt.Condition)

##Sample_Method
Samghlt.Method <- glht(glmer(Salmonella_Positive ~ Season + Species + Condition + Sample_Method + (1|Region),
                                data = sam, family = binomial, nAGQ = 2) , linfct = mcp(Sample_Method = "Tukey"))
summary(Samghlt.Method)
