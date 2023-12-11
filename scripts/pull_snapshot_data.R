#' This query identifies Snapshot activity and NFT projects minted for specific
#' set of ~2,000 addresses for talentDAO's reputation score purposes.

# get your own API Key for free at: https://sdk.flipsidecrypto.xyz/shroomdk
api_key <- readLines("data/api_key.txt")

library(shroomDK)


voter_index_query <-
  c("
SELECT
voter,
space_id
FROM
external.snapshot.ez_snapshot
WHERE
external.snapshot.ez_snapshot.space_id = 'banklessvault.eth'
  ")

voter_index <- shroomDK::auto_paginate_query(voter_index_query, api_key = api_key)
alist <- (paste0(tolower(unique(voter_index$voter)), collapse = "','"))


#Snapshot activity
# set to 2023-01-28 end time to replicate existing network article from talentdao newsletter
snapshot_query <-
  c("
SELECT
voter,
proposal_id,
proposal_title,
voting_power,
space_id
FROM
external.snapshot.ez_snapshot
WHERE
external.snapshot.ez_snapshot.voter IN ('ADDRESSLIST')
  ")
# swap parameters
snapshot_query <- gsub('ADDRESSLIST', replacement = alist, x = snapshot_query)
voter_snapshots <- shroomDK::auto_paginate_query(snapshot_query, api_key = api_key)


write.csv(voter_snapshots, file = "bdao_voter_activity_12_10_23.csv", row.names = FALSE)
