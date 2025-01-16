rm(list = ls())
getwd()
setwd("C:/Master USPN/Cours M1 Big Data/Projets Portfolio/Dataset")

library(readxl)
library(lmtest)
library(ggplot2)
library(sandwich)
library(data.table)

variables_EuroStoxx600 = read_excel('variables_EuroStoxx600.xlsx')
euro_stock = variables_EuroStoxx600
View(euro_stock)
str(euro_stock)
dim(euro_stock)
names(euro_stock)



# rennomer les variable d'interet avec des nom plus court pour une meilleure manipulation et un code lisible.

stock_data = copy(euro_stock)
colnames(stock_data) = c(
  "nombre", 
  "identifiant",
  "nom_entreprise",
  "mcap",
  "price1",
  "price2",
  "price3",
  "price4",
  "price5",
  "price6",
  "price7",
  "price8",
  "price9",
  "volume_10d",
  "volume_3m",
  "code_ISIN",
  "pays",
  "emp",
  "marge",
  "profit",
  "sales",
  "eps",
  "csr",
  "rcap",
  "value_board",
  "board",
  "co2_emis"
)
str(stock_data)


for(i in c(18:22,24:27)){
  stock_data[[i]]= as.numeric(stock_data[[i]])
}

stock_data[[23]] = factor(stock_data[[23]])
levels(stock_data[[23]])
levels(stock_data[[23]])[1]= "Csr_No"
levels(stock_data[[23]])[c(2:3)]= "Csr_Yes"

str(stock_data)


library(VIM)
sum(is.na(stock_data))
aggr(stock_data, col=c('green','red'), numbers=TRUE, sortVars=TRUE, 
     labels=names(stock_data), cex.axis=.7, gap=3, ylab=c("Histogram des valeurs manquantes","Pattern"))

filtre = subset(stock_data, 
                stock_data$eps != "NA" & 
                  stock_data$value_board != "NA" &
                  stock_data$rcap != "NA" & 
                  stock_data$emp != 0 &  # pas logique qu'une entreprise n'est aucun employé
                  stock_data$marge != "NA" &
                  stock_data$profit != "NA" &
                  stock_data$sales != "NA" &
                  stock_data$price7 != "NA"&
                  stock_data$price5 != "NA")

lignes_perdues = nrow(stock_data) - nrow(filtre) # en faisant le filtrage on perd 49 lignes


csr_eps = aggregate(filtre$eps, by = list(filtre$csr), FUN = mean, na.rm = T)
names(csr_eps)[1] = "Comite_de_Soutenabilite"
names(csr_eps)[2] = "Score_EPS_Moyen"


# pour l'nanlyse graphique et descriptive en fonction des pays
# nous allons supprimer les ligne dont le pays n'est donne et qui ont NA comme valeur 
# Analyse par pays
capi =aggregate(filtre$mcap, by = list(filtre$pays), FUN = sum, na.rm = T)
str(capi)
names(capi)[2] = "capitalisation"
names(capi)[1] = "Pays"

part = round(capi[,2]/sum(sum(filtre$mcap)), 2)*100
sum(part)
capi["Part"] = part


ggplot(data= capi, aes(y = reorder(Pays, -capitalisation), x = capitalisation , color = Pays)) + 
  geom_bar(stat = "identity") + 
  coord_flip()+
  labs(title = 'Capitalisation boursiere par pays', y = "", x = '')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# performance environnementale par pays
perf = aggregate(filtre$eps, by = list(filtre$pays), FUN = mean, na.rm = T)
names(perf)[1] = "Pays"
names(perf)[2] ="Score_EPS_Moyen_Par_Pays"

ggplot(data = perf, 
       aes (x = Score_EPS_Moyen_Par_Pays, y= reorder(Pays, Score_EPS_Moyen_Par_Pays), color = Pays))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = 'Performance environnementale moyenne par Pays', y = "", x = 'Score EPS moyen')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# EPS vs CSR
ggplot(data = filtre, aes(x = 1:nrow(filtre), y = as.numeric(eps), color = csr)) + 
  geom_boxplot()+
  labs(title = 'Boxplot de la performance environnementale par CSR',y = 'Score EPS', x ="" )


library(VIM)
library(ggplot2)
library(corrplot)
library(readtext)
library(devtools)
library(factoextra)
library(FactoMineR)
library(dplyr)

data_acp = filtre[, c(5:13)]

colnames(data_acp) = c(
  "one_day_price",
  "five_day_price",
  "four_week_price",
  "thirteen_week_price",
  "twentySix_week_price",
  "YTD_price",
  "fiftyTwo_week_price_PCT",
  "fiftyTwo_week_low_price",
  "fiftyTwo_week_high_price"
)

matrice_corre = cor(data_acp, use = "complete.obs")
corrplot(matrice_corre, method = "color", type = "upper",order = "hclust",
         tl.col = "black", 
         tl.srt = 45,
         addCoef.col = "black", 
         cl.cex = 1.2, 
         addCoefasPercent = TRUE, 
         number.cex = 0.8)


acp_res = PCA(data_acp, scale.unit = T, graph = F,axes = c(1,2))
print(acp_res)

fviz_eig(acp_res, addlabels = TRUE)

# Cercle de correlation
fviz_pca_var(acp_res,axes = c(1,2), col.var = "cos2", repel = T,
             gradient.cols = c("green","orange","red"),
             title = "Cercle de correlation des variables")

# variables determinantes des axes principaux
variables= get_pca_var(acp_res)
corrplot(variables$cor, is.corr=FALSE)

fviz_contrib(acp_res, choice = "var", axes = 1, top = 3)
fviz_contrib(acp_res, choice = "var", axes = 2, top = 3)

# contribution par cosinus carre
fviz_cos2(acp_res, choice = "var", axes = 1, top = 3)
fviz_cos2(acp_res, choice = "var", axes = 2, top = 3)
fviz_cos2(acp_res, choice = "var", axes = 3, top = 3)

# contribution des individus a la formation des axes principaux
fviz_pca_ind(acp_res,axes = c(1,2), col.ind = 'cos2') +
  scale_color_gradient2(low = "orange", mid = "white", high ="black", midpoint = 0.5)+
  theme_minimal()

facteur_prix_f1 = acp_res$ind$coord[, 1]
facteur_prix_f2 = acp_res$ind$coord[, 2]
facteur_prix_f3 = facteur_prix_f2

filtre["prix_F1"] = facteur_prix_f1
filtre["prix_F2"] = facteur_prix_f2
filtre["prix_F3"] = facteur_prix_f3


# Modele de regression lineaire
mod = lm(data = filtre, eps ~ emp+sales+csr+prix_F1)

plot(mod)

# vivualisation des residus
hist(resid(mod),prob=TRUE,col = "cornflowerblue",main = "Fonction de densite estimee",xlab = "Residus estime",ylab = "Densitee")
lines(density(resid(mod), na.rm = "TRUE"),col="orange")

#tests de validite du modele
library(normtest)
library(lmtest)
library(tseries)

jb.norm.test(mod$residuals)
ks.test(mod$residuals, "pnorm")
jarque.bera.test(mod$residuals)
dwtest(mod)
Box.test(mod$residuals, lag = 1)
shapiro.test(mod$residuals)
summary(mod)
