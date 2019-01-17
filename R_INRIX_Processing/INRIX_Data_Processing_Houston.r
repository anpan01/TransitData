#load packages
library("dplyr")
library("lubridate")
library("rgdal")

#
#
#
#
##INRIX
 
#group entries by segment
colnames(INRIXSelection_IJ) <- c("YEAR","DAY_OF_WEEK", "HOUR", "XDSEGID", "REFSPD", "SPEED", "TSPEED", "TREFSPD", "PCTILE5", "PCTILE20", "PCTILE50", "TPCTILE5", "TPCTILE20", "TPCTILE50")
INRIX <- group_by(INRIXSelection_IJ, XDSEGID)
#filter out the peak hours
INRIX_filter <- subset(INRIX, HOUR %in% INRIX_PKHR$EPOCH)

#filter to the work week only
INRIX_filter2 <- subset(INRIX_filter, DAY_OF_WEEK %in% days$DAY_NUM)

#grab reference speed info
INRIX_refspd <-  dplyr::distinct(
        INRIX_filter2, XDSEGID, .keep_all= TRUE)

#take the avg peak speed for each segment
INRIX_peak2<- merge(INRIX_filter2, INRIX_PKHR, by.x = "HOUR", by.y = "EPOCH", all.x = TRUE)
INRIX_peak2 <-  INRIX_peak2 %>%
        group_by(XDSEGID, PHR) %>%
        summarise(Peak_Avg_Speeds=mean(SPEED, na.rm=TRUE),count_peak = n())

# #merge for the reference speeds for each
INRIX_pn <- merge(INRIX_peak2, INRIX_refspd, by.x="XDSEGID", by.y="XDSEGID", all.x = TRUE)

#calculate the TTI
INRIX_pn2 <- mutate(INRIX_pn, TTI =Peak_Avg_Speeds/as.numeric(REFSPD))

#after joining to the shapefile select the columns we want
INRIX_pn3 <- select(INRIX_pn2, "XDSEGID", "PHR", "Peak_Avg_Speeds", "count_peak", "REFSPD" ,"TTI")

#DELAY for a weekday (all hours)
INRIX_filter2.5 <- subset(INRIX, DAY_OF_WEEK %in% days$DAY_NUM)
INRIX_l <- merge(INRIX_filter2.5, INRIX_LNGTH, by.x="XDSEGID", by.y="XDSegID", all.y = TRUE)
INRIX_l2 <- mutate(INRIX_l, Delay = (((REFSPD*60)/Miles)-((SPEED*60)/Miles)))

#convert negative values to 0 before taking the average
INRIX_l2$Delay[INRIX_l2$Delay<0] <- 0 

#avg the delay for each tmc
INRIX_lsum <- INRIX_l2 %>%
  group_by(XDSEGID) %>%
  summarise(AvgDelay=mean(Delay, na.rm=TRUE), Length = mean(Miles))

#Separate Peak Hours 7 - 8 am, 8-9 am, 5- 6 pm, 6 -7 pm
INRIX_PH1 <- filter(INRIX_pn3, PHR == 1)
INRIX_PH2 <- filter(INRIX_pn3, PHR == 2)
INRIX_PH3 <- filter(INRIX_pn3, PHR == 3)
INRIX_PH4 <- filter(INRIX_pn3, PHR == 4)


#join each table with the delay information
INRIX_join <-merge(INRIX_PH1, INRIX_lsum)
INRIX_join2 <-merge(INRIX_PH2, INRIX_lsum)
INRIX_join3 <-merge(INRIX_PH3, INRIX_lsum)
INRIX_join4 <-merge(INRIX_PH4, INRIX_lsum)

#export the 4 versions
write.csv(INRIX_join, "INRIX_PH1.csv")
write.csv(INRIX_join2, "INRIX_PH2.csv")
write.csv(INRIX_join3, "INRIX_PH3.csv")
write.csv(INRIX_join4, "INRIX_PH4.csv")
