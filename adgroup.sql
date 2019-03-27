SELECT
  a.ExternalCustomerId,
  a.CampaignId,
  UrlCustomParameters,
  a.AdGroupId,
#  a.CriterionId,
  c.CustomerDescriptiveName,
  e.CampaignName,
  b.AdGroupName,
#  d.DisplayName,
  a.date,
  a.device,
  Impressions,
  Clicks,
  Conversions,
  ConversionValue,
  cost/100000 as Cost
FROM
  (SELECT 
  AdGroupId,
  ExternalCustomerId,
#  CriterionId,
  CampaignId,
  date,
  device,
  AdNetworkType1,
  AdNetworkType2,
  cost,
  Impressions,
  Clicks,
  Conversions,
  ConversionValue
  FROM 
  `BQPROJECTNAME.TABLENAME.p_PlacementBasicStats_XXXXXXXXXX` 
  WHERE _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 365 DAY)
)
  AS a
LEFT JOIN
  (SELECT
  AdGroupId,
  AdGroupName,
  UrlCustomParameters
  FROM `BQPROJECTNAME.TABLENAME.p_AdGroup_XXXXXXXXXX` 
  WHERE _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 365 DAY)
  )
  AS b
  
ON
  a.AdGroupId = b.AdGroupId 
LEFT JOIN
  (SELECT
  CustomerDescriptiveName,
  ExternalCustomerId
  FROM `BQPROJECTNAME.TABLENAME.p_Customer_XXXXXXXXXX`
  WHERE _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 365 DAY)
  )
  AS c
ON
  a.ExternalCustomerId = c.ExternalCustomerId
LEFT JOIN
#  (SELECT 
#  DisplayName,
#  CriterionId
#  FROM `BQPROJECTNAME.TABLENAME.p_Placement_XXXXXXXXXX` 
#  WHERE _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 365 DAY) 
#)
#  AS d
#ON
#  a.CriterionId = d.CriterionId
#  
#  LEFT JOIN
  (SELECT
  CampaignId,
  CampaignName
  FROM `BQPROJECTNAME.TABLENAME.p_Campaign_XXXXXXXXXX` 
  WHERE _PARTITIONTIME >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 365 DAY)
  )
  AS e
ON
a.CampaignId = e.CampaignId

WHERE Cost > 0
## WHERE a.CriterionID IS NOT NULL
