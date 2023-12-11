
library(igraph)


source("functions/visualize_top_nodes.R")
source("functions/create_modularity_df.R")



# Convert to igraph with vertex metadata
snapshot_voter_graph <- igraph::graph_from_data_frame(
  d = voter_snapshots[, c("voter", "space_id")],
  directed = TRUE,
  vertices = unique(data.frame(id = c(voter_snapshots$voter, voter_snapshots$space_id)))
)


output_file <- visualize_top_nodes(snapshot_voter_graph,
                                   num_top_nodes = 40,
                                   edge_legend_title = "Communities",
                                   node_legend_title = "Eigentrust Centrality")

ggsave(plot = output_file, filename = "top_100.png", width = 12, height = 8, dpi = 300)

