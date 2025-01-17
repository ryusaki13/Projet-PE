## Performance Environnementale des Entreprises


# Objectif du projet :

On dispose des données sur des variables économiques, financières et de gouvernance relatives aux entreprises de l'EuroStoxx 600. Ce projet vise à étudier les déterminants de la performance environnementale des entreprises de EUROSTOXX 600. On cherche à savoir pourquoi une entreprise donné est plus performante qu'une autre sur le plan environnementale. En se basant sur la norme ESG (Environnement, Social, Gouvernance), qui évalue l'impact des entreprises de manière globale, en prenant en compte trois dimensions principales : l'environnement, les aspects sociaux et la gouvernance.

# Méthodes et outils :

Nous allons mettre en place un modèle de régression linéaire multiple entre la variable Environment Pillar Score (EPS) qui mesure de la performance environnementale de l'entreprise et les variables économiques, commerciales, financières et de gouvernances.

le travail en sera repartie en trois grandes parties :

-   L'analyse descriptive pour comprendre notre jeu de données et les relations entre les variables

-   Une Analyse en Composante Principale(ACP) : Les variables financières étant nombreuses (9) on a un problème de choix, on ne peut les utliser elles toutes dans notre modèle de régression car elles peuvent être corrélées donc entrainer des biais d'endogénéité.\
    L'ACP aide à condenser l'information en un plus petit nombre de facteurs, afin déviter une redondance d'informations et faciliter ainsi l'analyse. En réduisant le nombre de variables sans perte significative d'information, l'ACP fournit une représentation plus simple et plus interprétable des données financière de notre étude.

-   La régression linéaire : connaitre quels sont les variable qui expliquent demanière significative la performance environnementale des entreprises.


## A Propos de la base de données

On dispose des données sur des variables économiques, financières et de gouvernance relatives aux entreprises de l'EuroStoxx 600 Ci-joint la liste et la description des variables de notre Dataset.

A. Identifiants et caractéristiques :

-   Identifier (RIC) : Identifiant RIC de l'entreprise\
-   Company Name : Nom de l'entreprise\
-   ISIN : code ISIN de l'entreprise\
-   COUNTRY OF DOMICIL : Code du pays de l'entreprise

B. Variables environnementales :

-   Environment Pillar Score : Mesure de la performance environnementale de l'entreprise.\
-   Carbon Intensity per Energy Produced : Mesure relative aux émissions de CO2.

C. Variables économiques et commerciales

-   EMPLOYEES (EMP) : Nombre d'employés par entreprise.
-   OPERATING PROFIT MARGIN (MARGIN) : Profit opérationnel de l'entreprise\
-   NET SALES OR REVENUES (SALES) : Les revenus commerciaux nets.

D. Variables financières

-   Market Cap (MCAP): capitalisation boursière de l'entreprise\
-   RETURN ON INVESTED CAPITAL (RCAP) : le rendement du capital investi\
-   Plusieurs Variables PRIX : 1-day Price, PCT Change, 5-day Price, PCT Change, 4-week Price PCT Change, 13-week Price, PCT Change, 6-week Price, PCT Change, Price PCT Change, 2-week Price, PCT Change, Price 52 Week High

E. Variables de gouvernance

-   CSR Sustainability Committee (CSR) : la mise en place d'un comité de soutenabilité CSR ou pas (Y si oui et N sinon)
-   Value - Board Structure/Independent Board Members (Board) : le pourcentage des members indépendants dans le board
