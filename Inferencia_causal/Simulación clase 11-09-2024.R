library(tidyverse)
library(AER)
library(broom)
library(faux)
library(ivdesc)

N=10000
income_aut=100

df<-rnorm_multi(
  n=N,
  mu=c(0,0,0),
  sd=c(3,4,5),
  r=c(1,0.7,0.6,
      0.7,1,0.8,
      0.6,0.8,1),
  varnames=c("D0i","D1i","hab"),
  empirical= FALSE) %>% 
  mutate(
    D0i=ifelse(D0i<0,0,1), #D0 y D1 deben ser binaria
    D1i=ifelse(D1i<0,0,1),
    D1i_D0i=D1i-D0i, #Efecto causal de una beca asignada aleatoriamente
    pop=case_when(
      D1i==1 & D0i==1 ~ "alw_taker",
      D1i==0 & D0i==0 ~ "nev_taker",
      D1i==1 & D0i==0 ~ "complier",
      D1i==0 & D0i==1 ~ "defier"),
    zi=runif(N,0.1), #var instrumental binaria 
    zi=ifelse(zi<0.5,0,1), #Instrumento binario 
    Di=D0i+(D1i-D0i)*zi, #variable de tratamiento
    effect=case_when(
      pop=="alw_taker" ~ rnorm(1,1,1), #efecto causal de la ed superior en el ingreso 
      pop=="nev_taker" ~ rnorm(1,2,1), #efecto heterogeneo (difiere para todos los individuos)
      pop=="complier" ~ rnorm(1,3,1), #distribución de los efecto varia por grupos
      pop=="defier" ~ rnorm(1,0,1)
      ),
    v=rnorm(N,0,1),
    u=1.5*hab+v,
    income=100+ effect*Di+u
    )

late=df %>% 
  group_by(pop) %>% 
  summarise(late=mean(effect,na.rm = T))


### SE hacen graficas para verificar el comportamiento de las variables Del intrumento

df_iv<- df %>% 
  filter(pop!= "defier") %>% 
  select(Di,income,zi)


n_sample<-5000

reg<-list()
iv_reg<-list()
weak_iv<- list()
fs_reg<-list()
ss_reg<-list()
red_reg<-list()

for(i in (1:500)){

  df_sample<- df_iv[sample(nrow(df_iv),n_sample),]
  
  reg[[i]]<- lm(income~Di, data=df_sample) %>%
    tidy(conf.int=TRUE) %>% 
    filter(term="Di") %>% 
    select(~term)
  
  s<- ivreg(income~Di | zi, data=df_sample)
  
  iv_reg[[i]]<- s %>% 
    tidy(conf.int=TRUE) %>% 
    filter(term=="Di") %>% 
    select(~term)
  
  weak_iv[[i]]<- summary(s,diagnostics=TRUE)[["diagnostics"]]["Weak instruments",
                                                              "p-value"]
  
  fs<-lm(Di~zi, data=df_sample)
  
  fs_reg<- lm(Di~zi, data=df_sample) %>% 
    tidy(conf.int=TRUE) %>% 
    filter(term =="zi") %>% 
    select(~term)
  data_ss<- df_sample %>% 
    mutate(fs_pred=predict(fs))
  
  ss_reg[[i]]<- lm (income~fs_pred, data=data_ss) %>% 
    tidy(conf.int=TRUE) %>% 
    filter(term =="fs_pred") %>% 
    select(~term)
  
  red_reg[[i]]<-lm(income~zi, data=df_sample) %>% 
    tidy(conf.int=TRUE) %>% 
    filter(term =="zi") %>% 
    select(~term)
  }

#El estimador se debe acercar al late de los complier

