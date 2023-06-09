library(tidyverse, warn.conflicts = FALSE)
library(vtable)

activity = read.csv('/Users/luka/Documents/Case Studies/bellabeat-case-study/Data/dailyActivity_merged.csv') #nolint
heart_rate = read.csv('/Users/luka/Documents/Case Studies/bellabeat-case-study/Data/heartrate_seconds_merged.csv') #nolint
sleep = read.csv('/Users/luka/Documents/Case Studies/bellabeat-case-study/Data/sleepDay_merged.csv') #nolint
weight = read.csv('/Users/luka/Documents/Case Studies/bellabeat-case-study/Data/weightLogInfo_merged.csv') # nolint

head(activity, n = 4L)
head(sleep, n = 4L)
head(weight, n = 4L)
head(heart_rate, n = 4L)

activity$Id <- as.character(activity$Id)
sleep$Id <- as.character(sleep$Id)
weight$Id <- as.character(weight$Id)
weight$LogId <- as.character(weight$LogId)
heart_rate$Id <- as.character(heart_rate$Id)
weight$IsManualReport <- as.logical(weight$IsManualReport)

activity$Date <- as.Date(activity$ActivityDate, "%m/%d/%Y")
activity <- activity[, !names(activity) %in% "ActivityDate"]
sleep$Date <- as.Date(sleep$SleepDay, "%m/%d/%Y")
sleep <- sleep[, !names(sleep) %in% "SleepDay"]
weight$Date <- as.Date(weight$Date, "%m/%d/%Y")
heart_rate$Time <- as.POSIXct(heart_rate$Time, format = "%m/%d/%Y %I:%M:%S %p",
                                tz = Sys.timezone())

heart_rate$Date <- as.Date(heart_rate$Time, "%m/%d/%Y")
heart_rate$Hour <- as.integer(format(heart_rate$Time, format = "%H"))
heart_rate <- heart_rate[, !names(heart_rate) %in% "Time"]
heart_rate <- heart_rate %>%
                group_by(Id, Date, Hour) %>%
                summarise(Average_value = as.integer(round(mean(Value))))
head(heart_rate)

n_distinct(activity$Id)     # Activity
n_distinct(sleep$Id)        # Sleep
n_distinct(heart_rate$Id)   # Heart rate
n_distinct(weight$Id)       # Weight

sumtable(activity, vars = c("TotalSteps", "VeryActiveMinutes",
                            "FairlyActiveMinutes", "LightlyActiveMinutes",
                            "SedentaryMinutes", "Calories"), out = "return")

activity %>%
  filter(Calories < 1800) %>%
  count()
activity <- activity[activity$Calories >= 1800, ]

activity %>%
  filter(TotalSteps == 0) %>%
  count()

activity <- activity[activity$TotalSteps != 0, ]

sumtable(activity, vars = c("TotalSteps", "VeryActiveMinutes",
                            "FairlyActiveMinutes", "LightlyActiveMinutes",
                            "SedentaryMinutes", "Calories"), out = "return")

sumtable(sleep, vars = c("TotalMinutesAsleep", "TotalTimeInBed",
                          "TotalSleepRecords"), out = "return")

activity_sleep <- merge(activity, sleep, by = c("Id", "Date"))

ggplot(activity_sleep, mapping = aes(x = SedentaryMinutes / 60,
        y = TotalMinutesAsleep / 60)) +
  geom_point() +
  geom_smooth(method = "loess", formula = "y ~ x") +
  labs(x = "Sedentary Hours", y = "Hours Asleep") +
  scale_x_continuous(breaks = seq(0, 24, by = 2)) +
  scale_y_continuous(breaks = seq(0, 24, by = 2))

ggplot(activity_sleep, mapping = aes(x = TotalSteps,
                                      y = SedentaryMinutes / 60)) +
 geom_point() +
 geom_smooth(method = "loess", formula = "y ~ x") +
 labs(x = "Total Steps", y = "Sedentary Hours") +
 scale_x_continuous(breaks = seq(0, 30000, by = 2500)) +
 scale_y_continuous(breaks = seq(0, 24, by = 2))