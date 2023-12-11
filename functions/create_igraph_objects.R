library(igraph)


# Convert to igraph with vertex metadata
snapshot_voter_graph <- igraph::graph_from_data_frame(
  d = voter_snapshots[, c("voter", "space_id")],
  directed = TRUE,
  vertices = unique(data.frame(id = c(voter_snapshots$voter, voter_snapshots$space_id)))
)