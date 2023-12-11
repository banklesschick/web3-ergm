library(igraph)
library(ggraph)
library(viridis)



visualize_top_nodes <- function(graph, num_top_nodes, edge_legend_title = "Edge Weight", node_legend_title = "Node Size") {
  # Calculate eigen centrality scores
  eigen_centrality_scores <- eigen_centrality(graph)$vector
  
  # Select the top nodes based on eigen centrality
  top_nodes <-
    names(sort(eigen_centrality_scores, decreasing = TRUE)[1:num_top_nodes])
  
  # Perform community detection using fast greedy algorithm
  communities <- fastgreedy.community(as.undirected(graph))
  
  # Filter the graph to include only the top nodes
  subgraph <- induced_subgraph(graph, top_nodes)
  
  # Create a mapping between original node names and indices in subgraph
  node_mapping <- match(V(subgraph)$name, V(graph)$name)
  
  # Set modern color palette
  colors <- viridis::viridis(length(unique(communities$membership)), option = "A")  # Use discrete option
  
  # Visualize the subgraph with nodes colored by community, sized by eigen trust, and edges with varying width
  set.seed(42)  # Set a seed for reproducibility
  ggraph(subgraph, layout = "fr") +
    geom_edge_link(
      aes(width = E(subgraph)$weight),
      alpha = 0.6,
      edge_colour = "gray20"  # Edge color
    ) +
    geom_node_point(
      aes(color = as.factor(communities$membership[node_mapping]), size = eigen_centrality_scores[node_mapping]),
      alpha = 0.7
    ) +
    scale_color_discrete(name = "Community") +  # Use discrete color palette with a custom legend title
    scale_size_continuous(name = node_legend_title, range = c(2, 10)) +  # Adjust the size range as needed
    scale_edge_width_continuous(name = edge_legend_title, range = c(0.1, 1)) +  # Adjust the line width range
    theme_void() +
    theme(
      plot.background = element_rect(fill = "#f0f0f0"),  # Light gray background
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      axis.text = element_blank(),
      axis.title = element_blank(),
      axis.ticks = element_blank()
    )
}

