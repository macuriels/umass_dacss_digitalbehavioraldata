# install necessary packages
library(igraph)
library(visNetwork)
library(scales)
library(DT)
library(readr)

# get and set working directory if needed
getwd()
setwd("/Users/mcurielinteros.ai/Documents/UMass/umass_dacss_digitalbehavioraldata")

# read in files
elonmusk = read_graph("Network_#elonmusk_rq.gml",format = c("gml"))
ukraine = read_graph("RTNetwork_#ukraine.gml",format = c("gml"))

# density
edge_density(elonmusk, loops = FALSE) 
edge_density(ukraine, loops = FALSE) 

# centralization
centr_degree(elonmusk, mode = c("in"), loops = TRUE,normalized = TRUE)$centralization
centr_degree(ukraine, mode = c("in"), loops = TRUE,normalized = TRUE)$centralization

# modularity or fragmentation
modularity(cluster_walktrap(elonmusk))
modularity(cluster_walktrap(ukraine))

# influencers
V(elonmusk)$indegree <- degree(elonmusk, mode = "in")
V(elonmusk)$outdegree <- degree(elonmusk, mode = "out")
V(elonmusk)$bt <- betweenness(elonmusk, directed=T, weights=NA)
nodelist1 <- vertex_attr(elonmusk)
nodelist1 <- as.data.frame(nodelist1)
datatable(nodelist1, options = list(pageLength = 10)) 

# network

## set node size by betweenness centrality scores
V(elonmusk)$size <- betweenness(elonmusk, directed=T, weights=NA)/1000

## set color by subgroup id (cluster_walktrap clusters)
wc <- cluster_walktrap(elonmusk)
V(elonmusk)$color <- membership(wc)

kcore <- coreness(elonmusk, mode="all") 
threecore <- induced_subgraph(elonmusk, kcore>=3)

visIgraph(threecore,idToLabel = TRUE,layout = "layout_nicely") %>%
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE) 
