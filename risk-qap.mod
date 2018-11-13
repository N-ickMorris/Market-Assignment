# ---- proposed model ----

# this model determines the how to assign countries to markets such that within each market, the countries have similar GNIpc and differing risk levels

# ---- define set(s) ----

set Markets;  # set of markets
set Countries;  # set of countries

# ---- define parameter(s) ----

param risk{Countries};  # the risk of a country reducing their budget for vaccines
param GNIpc{Countries}; # the gross national income per capita of a country 
param penalty{Countries, Countries} default 1;  # a penalty multiplier for putting two countries (that shouldn't be grouped together) in the same market 
param size default 1;  # the minimum number of countries required to build a market

# ---- define variable(s) ----

var x{Markets, Countries} binary;  # a country is/isn't assigned to a market

# ---- define model formulation ----

minimize RATIO: sum{i in Markets, j in Countries, k in Countries}(x[i,j] * x[i,k] * penalty[j,k] * (((GNIpc[j] - GNIpc[k])^2) / (1 + (risk[j] - risk[k])^2)));  # group countries with similar GINI but differing risk levels
s.t. BUILD{i in Markets}: sum{j in Countries}(x[i,j]) >= size;  # ensure each market is build with at least "size" many countries
s.t. ASSIGN{j in Countries}: sum{i in Markets}(x[i,j]) = 1;  # ensure each country is assigned to a market

