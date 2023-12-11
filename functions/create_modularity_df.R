# Install and load the required packages if not already installed
if (!requireNamespace("igraph", quietly = TRUE)) {
  install.packages("igraph")
}
if (!requireNamespace("tidygraph", quietly = TRUE)) {
  install.packages("tidygraph")
}
if (!requireNamespace("ggraph", quietly = TRUE)) {
  install.packages("ggraph")
}

# Load the packages
library(igraph)
library(tidygraph)
library(ggraph)

# Function to calculate modularity scores for each community
calculate_modularity <- function(graph) {
  # Perform community detection using Louvain algorithm
  communities <- cluster_louvain(as.undirected(graph))
  
  # Extract numeric community memberships
  numeric_memberships <- as.numeric(membership(communities))
  
  # Initialize a vector to store modularity scores
  modularity_scores <- numeric(length = max(numeric_memberships))
  
  # Calculate modularity scores for each community
  for (community in 1:max(numeric_memberships)) {
    subgraph <- induced_subgraph(graph, which(numeric_memberships == community))
    subgraph_memberships <- numeric_memberships[which(numeric_memberships == community)]
    modularity_scores[community] <- modularity(subgraph, subgraph_memberships)
  }
  
  # Create a data frame with modularity scores and corresponding snapshot_ids
  result_df <- data.frame(
    community = rep(1:max(numeric_memberships), each = length(V(graph))),
    snapshot_id = rep(V(graph)$name, times = max(numeric_memberships)),
    modularity_score = rep(modularity_scores, each = length(V(graph)))
  )
  
  return(result_df)
}
