{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "750004e7",
   "metadata": {
    "papermill": {
     "duration": 0.006911,
     "end_time": "2023-06-09T09:42:23.174220",
     "exception": false,
     "start_time": "2023-06-09T09:42:23.167309",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "![Woman doing yoga](https://burst.shopifycdn.com/photos/high-lunge-yoga.jpg?width=4460&height=4460&exif=1&iptc=1)\n",
    "\n",
    "# **The business task**\n",
    "Bellabeat is a company that produces health-related smart devices for women. The Chief Creative Officer wants to find opportunities for growth by better understanding how consumers use their smart devices. I have been tasked with identifying insightful trends in consumers' smart device usage data, which will be used to improve Bellabeat's marketing strategy.\n",
    "\n",
    "# **The data**\n",
    "This analysis uses the [Fitbit Fitness Tracker Data](https://www.kaggle.com/datasets/arashnic/fitbit) (CC0: Public Domain) provided by Möbius on Kaggle. It originates from a survey distributed by Amazon Mechanical Turk in 2016. Thirty three Fitbit users provided personal fitness tracker data, including metrics like physical activity levels, sleeping patterns and heart rates.\n",
    "\n",
    "Ideally, we would want to use data collected directly from users of Bellabeat products. However, assuming such data is unavailable and that Fitbit users share similar health habits with Bellabeat customers, we use the Fitbit data as a proxy.\n",
    "\n",
    "# **Data cleaning**\n",
    "I start by loading `tidyverse`, a very common package for data analysis in R. The `vtable` package is used for creating summary tables during analysis."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "dd1d461b",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:23.189898Z",
     "iopub.status.busy": "2023-06-09T09:42:23.188019Z",
     "iopub.status.idle": "2023-06-09T09:42:24.576752Z",
     "shell.execute_reply": "2023-06-09T09:42:24.575273Z"
    },
    "papermill": {
     "duration": 1.398945,
     "end_time": "2023-06-09T09:42:24.579088",
     "exception": false,
     "start_time": "2023-06-09T09:42:23.180143",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "── \u001b[1mAttaching core tidyverse packages\u001b[22m ──────────────────────── tidyverse 2.0.0 ──\n",
      "\u001b[32m✔\u001b[39m \u001b[34mdplyr    \u001b[39m 1.1.2     \u001b[32m✔\u001b[39m \u001b[34mreadr    \u001b[39m 2.1.4\n",
      "\u001b[32m✔\u001b[39m \u001b[34mforcats  \u001b[39m 1.0.0     \u001b[32m✔\u001b[39m \u001b[34mstringr  \u001b[39m 1.5.0\n",
      "\u001b[32m✔\u001b[39m \u001b[34mggplot2  \u001b[39m 3.4.2     \u001b[32m✔\u001b[39m \u001b[34mtibble   \u001b[39m 3.2.1\n",
      "\u001b[32m✔\u001b[39m \u001b[34mlubridate\u001b[39m 1.9.2     \u001b[32m✔\u001b[39m \u001b[34mtidyr    \u001b[39m 1.3.0\n",
      "\u001b[32m✔\u001b[39m \u001b[34mpurrr    \u001b[39m 1.0.1     \n",
      "── \u001b[1mConflicts\u001b[22m ────────────────────────────────────────── tidyverse_conflicts() ──\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mfilter()\u001b[39m masks \u001b[34mstats\u001b[39m::filter()\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mlag()\u001b[39m    masks \u001b[34mstats\u001b[39m::lag()\n",
      "\u001b[36mℹ\u001b[39m Use the conflicted package (\u001b[3m\u001b[34m<http://conflicted.r-lib.org/>\u001b[39m\u001b[23m) to force all conflicts to become errors\n",
      "Loading required package: kableExtra\n",
      "\n",
      "\n",
      "Attaching package: ‘kableExtra’\n",
      "\n",
      "\n",
      "The following object is masked from ‘package:dplyr’:\n",
      "\n",
      "    group_rows\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse, warn.conflicts = FALSE)\n",
    "library(vtable)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "e54a17df",
   "metadata": {
    "papermill": {
     "duration": 0.006098,
     "end_time": "2023-06-09T09:42:24.593139",
     "exception": false,
     "start_time": "2023-06-09T09:42:24.587041",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## Importing the data\n",
    "Now I import the data tables. I chose to work with the daily data since it is less cluttered and will provide sufficient information to discover high-level trends. The exception is the heart rates table, containing per-second records."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "27401262",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:24.632114Z",
     "iopub.status.busy": "2023-06-09T09:42:24.607570Z",
     "iopub.status.idle": "2023-06-09T09:42:31.264774Z",
     "shell.execute_reply": "2023-06-09T09:42:31.263321Z"
    },
    "papermill": {
     "duration": 6.668006,
     "end_time": "2023-06-09T09:42:31.267567",
     "exception": false,
     "start_time": "2023-06-09T09:42:24.599561",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "activity = read.csv('/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/dailyActivity_merged.csv')\n",
    "sleep = read.csv('/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/sleepDay_merged.csv')\n",
    "weight = read.csv('/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/weightLogInfo_merged.csv')\n",
    "heart_rate = read.csv('/kaggle/input/fitbit/Fitabase Data 4.12.16-5.12.16/heartrate_seconds_merged.csv')"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "a9de9a84",
   "metadata": {
    "papermill": {
     "duration": 0.005929,
     "end_time": "2023-06-09T09:42:31.279783",
     "exception": false,
     "start_time": "2023-06-09T09:42:31.273854",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## Exploring the data\n",
    "Glancing over each table's first few rows helps to get a feel for the data."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "7cfe58b8",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:31.295222Z",
     "iopub.status.busy": "2023-06-09T09:42:31.293948Z",
     "iopub.status.idle": "2023-06-09T09:42:31.325396Z",
     "shell.execute_reply": "2023-06-09T09:42:31.323353Z"
    },
    "papermill": {
     "duration": 0.042337,
     "end_time": "2023-06-09T09:42:31.328351",
     "exception": false,
     "start_time": "2023-06-09T09:42:31.286014",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 4 × 15</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>Id</th><th scope=col>ActivityDate</th><th scope=col>TotalSteps</th><th scope=col>TotalDistance</th><th scope=col>TrackerDistance</th><th scope=col>LoggedActivitiesDistance</th><th scope=col>VeryActiveDistance</th><th scope=col>ModeratelyActiveDistance</th><th scope=col>LightActiveDistance</th><th scope=col>SedentaryActiveDistance</th><th scope=col>VeryActiveMinutes</th><th scope=col>FairlyActiveMinutes</th><th scope=col>LightlyActiveMinutes</th><th scope=col>SedentaryMinutes</th><th scope=col>Calories</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>1503960366</td><td>4/12/2016</td><td>13162</td><td>8.50</td><td>8.50</td><td>0</td><td>1.88</td><td>0.55</td><td>6.06</td><td>0</td><td>25</td><td>13</td><td>328</td><td> 728</td><td>1985</td></tr>\n",
       "\t<tr><th scope=row>2</th><td>1503960366</td><td>4/13/2016</td><td>10735</td><td>6.97</td><td>6.97</td><td>0</td><td>1.57</td><td>0.69</td><td>4.71</td><td>0</td><td>21</td><td>19</td><td>217</td><td> 776</td><td>1797</td></tr>\n",
       "\t<tr><th scope=row>3</th><td>1503960366</td><td>4/14/2016</td><td>10460</td><td>6.74</td><td>6.74</td><td>0</td><td>2.44</td><td>0.40</td><td>3.91</td><td>0</td><td>30</td><td>11</td><td>181</td><td>1218</td><td>1776</td></tr>\n",
       "\t<tr><th scope=row>4</th><td>1503960366</td><td>4/15/2016</td><td> 9762</td><td>6.28</td><td>6.28</td><td>0</td><td>2.14</td><td>1.26</td><td>2.83</td><td>0</td><td>29</td><td>34</td><td>209</td><td> 726</td><td>1745</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 4 × 15\n",
       "\\begin{tabular}{r|lllllllllllllll}\n",
       "  & Id & ActivityDate & TotalSteps & TotalDistance & TrackerDistance & LoggedActivitiesDistance & VeryActiveDistance & ModeratelyActiveDistance & LightActiveDistance & SedentaryActiveDistance & VeryActiveMinutes & FairlyActiveMinutes & LightlyActiveMinutes & SedentaryMinutes & Calories\\\\\n",
       "  & <dbl> & <chr> & <int> & <dbl> & <dbl> & <dbl> & <dbl> & <dbl> & <dbl> & <dbl> & <int> & <int> & <int> & <int> & <int>\\\\\n",
       "\\hline\n",
       "\t1 & 1503960366 & 4/12/2016 & 13162 & 8.50 & 8.50 & 0 & 1.88 & 0.55 & 6.06 & 0 & 25 & 13 & 328 &  728 & 1985\\\\\n",
       "\t2 & 1503960366 & 4/13/2016 & 10735 & 6.97 & 6.97 & 0 & 1.57 & 0.69 & 4.71 & 0 & 21 & 19 & 217 &  776 & 1797\\\\\n",
       "\t3 & 1503960366 & 4/14/2016 & 10460 & 6.74 & 6.74 & 0 & 2.44 & 0.40 & 3.91 & 0 & 30 & 11 & 181 & 1218 & 1776\\\\\n",
       "\t4 & 1503960366 & 4/15/2016 &  9762 & 6.28 & 6.28 & 0 & 2.14 & 1.26 & 2.83 & 0 & 29 & 34 & 209 &  726 & 1745\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 4 × 15\n",
       "\n",
       "| <!--/--> | Id &lt;dbl&gt; | ActivityDate &lt;chr&gt; | TotalSteps &lt;int&gt; | TotalDistance &lt;dbl&gt; | TrackerDistance &lt;dbl&gt; | LoggedActivitiesDistance &lt;dbl&gt; | VeryActiveDistance &lt;dbl&gt; | ModeratelyActiveDistance &lt;dbl&gt; | LightActiveDistance &lt;dbl&gt; | SedentaryActiveDistance &lt;dbl&gt; | VeryActiveMinutes &lt;int&gt; | FairlyActiveMinutes &lt;int&gt; | LightlyActiveMinutes &lt;int&gt; | SedentaryMinutes &lt;int&gt; | Calories &lt;int&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 1 | 1503960366 | 4/12/2016 | 13162 | 8.50 | 8.50 | 0 | 1.88 | 0.55 | 6.06 | 0 | 25 | 13 | 328 |  728 | 1985 |\n",
       "| 2 | 1503960366 | 4/13/2016 | 10735 | 6.97 | 6.97 | 0 | 1.57 | 0.69 | 4.71 | 0 | 21 | 19 | 217 |  776 | 1797 |\n",
       "| 3 | 1503960366 | 4/14/2016 | 10460 | 6.74 | 6.74 | 0 | 2.44 | 0.40 | 3.91 | 0 | 30 | 11 | 181 | 1218 | 1776 |\n",
       "| 4 | 1503960366 | 4/15/2016 |  9762 | 6.28 | 6.28 | 0 | 2.14 | 1.26 | 2.83 | 0 | 29 | 34 | 209 |  726 | 1745 |\n",
       "\n"
      ],
      "text/plain": [
       "  Id         ActivityDate TotalSteps TotalDistance TrackerDistance\n",
       "1 1503960366 4/12/2016    13162      8.50          8.50           \n",
       "2 1503960366 4/13/2016    10735      6.97          6.97           \n",
       "3 1503960366 4/14/2016    10460      6.74          6.74           \n",
       "4 1503960366 4/15/2016     9762      6.28          6.28           \n",
       "  LoggedActivitiesDistance VeryActiveDistance ModeratelyActiveDistance\n",
       "1 0                        1.88               0.55                    \n",
       "2 0                        1.57               0.69                    \n",
       "3 0                        2.44               0.40                    \n",
       "4 0                        2.14               1.26                    \n",
       "  LightActiveDistance SedentaryActiveDistance VeryActiveMinutes\n",
       "1 6.06                0                       25               \n",
       "2 4.71                0                       21               \n",
       "3 3.91                0                       30               \n",
       "4 2.83                0                       29               \n",
       "  FairlyActiveMinutes LightlyActiveMinutes SedentaryMinutes Calories\n",
       "1 13                  328                   728             1985    \n",
       "2 19                  217                   776             1797    \n",
       "3 11                  181                  1218             1776    \n",
       "4 34                  209                   726             1745    "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "head(activity, n = 4L)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "c0813592",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:31.345513Z",
     "iopub.status.busy": "2023-06-09T09:42:31.344179Z",
     "iopub.status.idle": "2023-06-09T09:42:31.364006Z",
     "shell.execute_reply": "2023-06-09T09:42:31.362704Z"
    },
    "papermill": {
     "duration": 0.030359,
     "end_time": "2023-06-09T09:42:31.366028",
     "exception": false,
     "start_time": "2023-06-09T09:42:31.335669",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 4 × 5</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>Id</th><th scope=col>SleepDay</th><th scope=col>TotalSleepRecords</th><th scope=col>TotalMinutesAsleep</th><th scope=col>TotalTimeInBed</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>1503960366</td><td>4/12/2016 12:00:00 AM</td><td>1</td><td>327</td><td>346</td></tr>\n",
       "\t<tr><th scope=row>2</th><td>1503960366</td><td>4/13/2016 12:00:00 AM</td><td>2</td><td>384</td><td>407</td></tr>\n",
       "\t<tr><th scope=row>3</th><td>1503960366</td><td>4/15/2016 12:00:00 AM</td><td>1</td><td>412</td><td>442</td></tr>\n",
       "\t<tr><th scope=row>4</th><td>1503960366</td><td>4/16/2016 12:00:00 AM</td><td>2</td><td>340</td><td>367</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 4 × 5\n",
       "\\begin{tabular}{r|lllll}\n",
       "  & Id & SleepDay & TotalSleepRecords & TotalMinutesAsleep & TotalTimeInBed\\\\\n",
       "  & <dbl> & <chr> & <int> & <int> & <int>\\\\\n",
       "\\hline\n",
       "\t1 & 1503960366 & 4/12/2016 12:00:00 AM & 1 & 327 & 346\\\\\n",
       "\t2 & 1503960366 & 4/13/2016 12:00:00 AM & 2 & 384 & 407\\\\\n",
       "\t3 & 1503960366 & 4/15/2016 12:00:00 AM & 1 & 412 & 442\\\\\n",
       "\t4 & 1503960366 & 4/16/2016 12:00:00 AM & 2 & 340 & 367\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 4 × 5\n",
       "\n",
       "| <!--/--> | Id &lt;dbl&gt; | SleepDay &lt;chr&gt; | TotalSleepRecords &lt;int&gt; | TotalMinutesAsleep &lt;int&gt; | TotalTimeInBed &lt;int&gt; |\n",
       "|---|---|---|---|---|---|\n",
       "| 1 | 1503960366 | 4/12/2016 12:00:00 AM | 1 | 327 | 346 |\n",
       "| 2 | 1503960366 | 4/13/2016 12:00:00 AM | 2 | 384 | 407 |\n",
       "| 3 | 1503960366 | 4/15/2016 12:00:00 AM | 1 | 412 | 442 |\n",
       "| 4 | 1503960366 | 4/16/2016 12:00:00 AM | 2 | 340 | 367 |\n",
       "\n"
      ],
      "text/plain": [
       "  Id         SleepDay              TotalSleepRecords TotalMinutesAsleep\n",
       "1 1503960366 4/12/2016 12:00:00 AM 1                 327               \n",
       "2 1503960366 4/13/2016 12:00:00 AM 2                 384               \n",
       "3 1503960366 4/15/2016 12:00:00 AM 1                 412               \n",
       "4 1503960366 4/16/2016 12:00:00 AM 2                 340               \n",
       "  TotalTimeInBed\n",
       "1 346           \n",
       "2 407           \n",
       "3 442           \n",
       "4 367           "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "head(sleep, n = 4L)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "6771e6cc",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:31.383005Z",
     "iopub.status.busy": "2023-06-09T09:42:31.381681Z",
     "iopub.status.idle": "2023-06-09T09:42:31.404846Z",
     "shell.execute_reply": "2023-06-09T09:42:31.403395Z"
    },
    "papermill": {
     "duration": 0.034021,
     "end_time": "2023-06-09T09:42:31.407291",
     "exception": false,
     "start_time": "2023-06-09T09:42:31.373270",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 4 × 8</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>Id</th><th scope=col>Date</th><th scope=col>WeightKg</th><th scope=col>WeightPounds</th><th scope=col>Fat</th><th scope=col>BMI</th><th scope=col>IsManualReport</th><th scope=col>LogId</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;dbl&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>1503960366</td><td>5/2/2016 11:59:59 PM </td><td> 52.6</td><td>115.9631</td><td>22</td><td>22.65</td><td>True </td><td>1.462234e+12</td></tr>\n",
       "\t<tr><th scope=row>2</th><td>1503960366</td><td>5/3/2016 11:59:59 PM </td><td> 52.6</td><td>115.9631</td><td>NA</td><td>22.65</td><td>True </td><td>1.462320e+12</td></tr>\n",
       "\t<tr><th scope=row>3</th><td>1927972279</td><td>4/13/2016 1:08:52 AM </td><td>133.5</td><td>294.3171</td><td>NA</td><td>47.54</td><td>False</td><td>1.460510e+12</td></tr>\n",
       "\t<tr><th scope=row>4</th><td>2873212765</td><td>4/21/2016 11:59:59 PM</td><td> 56.7</td><td>125.0021</td><td>NA</td><td>21.45</td><td>True </td><td>1.461283e+12</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 4 × 8\n",
       "\\begin{tabular}{r|llllllll}\n",
       "  & Id & Date & WeightKg & WeightPounds & Fat & BMI & IsManualReport & LogId\\\\\n",
       "  & <dbl> & <chr> & <dbl> & <dbl> & <int> & <dbl> & <chr> & <dbl>\\\\\n",
       "\\hline\n",
       "\t1 & 1503960366 & 5/2/2016 11:59:59 PM  &  52.6 & 115.9631 & 22 & 22.65 & True  & 1.462234e+12\\\\\n",
       "\t2 & 1503960366 & 5/3/2016 11:59:59 PM  &  52.6 & 115.9631 & NA & 22.65 & True  & 1.462320e+12\\\\\n",
       "\t3 & 1927972279 & 4/13/2016 1:08:52 AM  & 133.5 & 294.3171 & NA & 47.54 & False & 1.460510e+12\\\\\n",
       "\t4 & 2873212765 & 4/21/2016 11:59:59 PM &  56.7 & 125.0021 & NA & 21.45 & True  & 1.461283e+12\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 4 × 8\n",
       "\n",
       "| <!--/--> | Id &lt;dbl&gt; | Date &lt;chr&gt; | WeightKg &lt;dbl&gt; | WeightPounds &lt;dbl&gt; | Fat &lt;int&gt; | BMI &lt;dbl&gt; | IsManualReport &lt;chr&gt; | LogId &lt;dbl&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|\n",
       "| 1 | 1503960366 | 5/2/2016 11:59:59 PM  |  52.6 | 115.9631 | 22 | 22.65 | True  | 1.462234e+12 |\n",
       "| 2 | 1503960366 | 5/3/2016 11:59:59 PM  |  52.6 | 115.9631 | NA | 22.65 | True  | 1.462320e+12 |\n",
       "| 3 | 1927972279 | 4/13/2016 1:08:52 AM  | 133.5 | 294.3171 | NA | 47.54 | False | 1.460510e+12 |\n",
       "| 4 | 2873212765 | 4/21/2016 11:59:59 PM |  56.7 | 125.0021 | NA | 21.45 | True  | 1.461283e+12 |\n",
       "\n"
      ],
      "text/plain": [
       "  Id         Date                  WeightKg WeightPounds Fat BMI  \n",
       "1 1503960366 5/2/2016 11:59:59 PM   52.6    115.9631     22  22.65\n",
       "2 1503960366 5/3/2016 11:59:59 PM   52.6    115.9631     NA  22.65\n",
       "3 1927972279 4/13/2016 1:08:52 AM  133.5    294.3171     NA  47.54\n",
       "4 2873212765 4/21/2016 11:59:59 PM  56.7    125.0021     NA  21.45\n",
       "  IsManualReport LogId       \n",
       "1 True           1.462234e+12\n",
       "2 True           1.462320e+12\n",
       "3 False          1.460510e+12\n",
       "4 True           1.461283e+12"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "head(weight, n = 4L)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "561fb298",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:31.424742Z",
     "iopub.status.busy": "2023-06-09T09:42:31.423466Z",
     "iopub.status.idle": "2023-06-09T09:42:31.444670Z",
     "shell.execute_reply": "2023-06-09T09:42:31.443179Z"
    },
    "papermill": {
     "duration": 0.032791,
     "end_time": "2023-06-09T09:42:31.447299",
     "exception": false,
     "start_time": "2023-06-09T09:42:31.414508",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 4 × 3</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>Id</th><th scope=col>Time</th><th scope=col>Value</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>2022484408</td><td>4/12/2016 7:21:00 AM</td><td> 97</td></tr>\n",
       "\t<tr><th scope=row>2</th><td>2022484408</td><td>4/12/2016 7:21:05 AM</td><td>102</td></tr>\n",
       "\t<tr><th scope=row>3</th><td>2022484408</td><td>4/12/2016 7:21:10 AM</td><td>105</td></tr>\n",
       "\t<tr><th scope=row>4</th><td>2022484408</td><td>4/12/2016 7:21:20 AM</td><td>103</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 4 × 3\n",
       "\\begin{tabular}{r|lll}\n",
       "  & Id & Time & Value\\\\\n",
       "  & <dbl> & <chr> & <int>\\\\\n",
       "\\hline\n",
       "\t1 & 2022484408 & 4/12/2016 7:21:00 AM &  97\\\\\n",
       "\t2 & 2022484408 & 4/12/2016 7:21:05 AM & 102\\\\\n",
       "\t3 & 2022484408 & 4/12/2016 7:21:10 AM & 105\\\\\n",
       "\t4 & 2022484408 & 4/12/2016 7:21:20 AM & 103\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 4 × 3\n",
       "\n",
       "| <!--/--> | Id &lt;dbl&gt; | Time &lt;chr&gt; | Value &lt;int&gt; |\n",
       "|---|---|---|---|\n",
       "| 1 | 2022484408 | 4/12/2016 7:21:00 AM |  97 |\n",
       "| 2 | 2022484408 | 4/12/2016 7:21:05 AM | 102 |\n",
       "| 3 | 2022484408 | 4/12/2016 7:21:10 AM | 105 |\n",
       "| 4 | 2022484408 | 4/12/2016 7:21:20 AM | 103 |\n",
       "\n"
      ],
      "text/plain": [
       "  Id         Time                 Value\n",
       "1 2022484408 4/12/2016 7:21:00 AM  97  \n",
       "2 2022484408 4/12/2016 7:21:05 AM 102  \n",
       "3 2022484408 4/12/2016 7:21:10 AM 105  \n",
       "4 2022484408 4/12/2016 7:21:20 AM 103  "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "head(heart_rate, n = 4L)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "3e3e4ac1",
   "metadata": {
    "papermill": {
     "duration": 0.007724,
     "end_time": "2023-06-09T09:42:31.462267",
     "exception": false,
     "start_time": "2023-06-09T09:42:31.454543",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## Correcting data types\n",
    "I immediately see some issues I would like to address. Each table's `Id` column contains numerical values, while the date and time columns have character strings, so I convert them to more appropriate data types. I also convert the binary variable `IsManualReport` in the `weight` table from a string type to logical."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "0dc6e8b8",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:31.480188Z",
     "iopub.status.busy": "2023-06-09T09:42:31.478589Z",
     "iopub.status.idle": "2023-06-09T09:42:34.303744Z",
     "shell.execute_reply": "2023-06-09T09:42:34.302231Z"
    },
    "papermill": {
     "duration": 2.836952,
     "end_time": "2023-06-09T09:42:34.306519",
     "exception": false,
     "start_time": "2023-06-09T09:42:31.469567",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "activity$Id = as.character(activity$Id)\n",
    "sleep$Id = as.character(sleep$Id)\n",
    "weight$Id = as.character(weight$Id)\n",
    "weight$LogId = as.character(weight$LogId)\n",
    "heart_rate$Id = as.character(heart_rate$Id)\n",
    "weight$IsManualReport = as.logical(weight$IsManualReport)\n",
    "\n",
    "activity$Date = as.Date(activity$ActivityDate, \"%m/%d/%Y\")\n",
    "activity = activity[, !names(activity) %in% \"ActivityDate\"]\n",
    "sleep$Date = as.Date(sleep$SleepDay, \"%m/%d/%Y\")\n",
    "sleep = sleep[, !names(sleep) %in% \"SleepDay\"]\n",
    "weight$Date = as.Date(weight$Date, \"%m/%d/%Y\")\n",
    "heart_rate$Time = as.POSIXct(heart_rate$Time, format = \"%m/%d/%Y %I:%M:%S %p\")"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2c209449",
   "metadata": {
    "papermill": {
     "duration": 0.007072,
     "end_time": "2023-06-09T09:42:34.320714",
     "exception": false,
     "start_time": "2023-06-09T09:42:34.313642",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## Simplifying the heart rate data\n",
    "The high resolution of per-second heart rate data is unnecessary and clutters the table. By taking each user's hourly average per day, the number of rows reduces from nearly 2.5 million to a manageable 6,013. After the transformation, the `heart_rate` table is cleaner and more usable for analysis."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "cf150b56",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:34.339190Z",
     "iopub.status.busy": "2023-06-09T09:42:34.337826Z",
     "iopub.status.idle": "2023-06-09T09:42:38.457765Z",
     "shell.execute_reply": "2023-06-09T09:42:38.456524Z"
    },
    "papermill": {
     "duration": 4.130738,
     "end_time": "2023-06-09T09:42:38.459510",
     "exception": false,
     "start_time": "2023-06-09T09:42:34.328772",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\u001b[1m\u001b[22m`summarise()` has grouped output by 'Id', 'Date'. You can override using the\n",
      "`.groups` argument.\n"
     ]
    },
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A grouped_df: 6 × 4</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>Id</th><th scope=col>Date</th><th scope=col>Hour</th><th scope=col>Average_value</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;date&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>2022484408</td><td>2016-04-12</td><td> 7</td><td> 83</td></tr>\n",
       "\t<tr><td>2022484408</td><td>2016-04-12</td><td> 8</td><td> 69</td></tr>\n",
       "\t<tr><td>2022484408</td><td>2016-04-12</td><td> 9</td><td> 66</td></tr>\n",
       "\t<tr><td>2022484408</td><td>2016-04-12</td><td>10</td><td>107</td></tr>\n",
       "\t<tr><td>2022484408</td><td>2016-04-12</td><td>11</td><td> 68</td></tr>\n",
       "\t<tr><td>2022484408</td><td>2016-04-12</td><td>12</td><td> 66</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A grouped\\_df: 6 × 4\n",
       "\\begin{tabular}{llll}\n",
       " Id & Date & Hour & Average\\_value\\\\\n",
       " <chr> & <date> & <int> & <int>\\\\\n",
       "\\hline\n",
       "\t 2022484408 & 2016-04-12 &  7 &  83\\\\\n",
       "\t 2022484408 & 2016-04-12 &  8 &  69\\\\\n",
       "\t 2022484408 & 2016-04-12 &  9 &  66\\\\\n",
       "\t 2022484408 & 2016-04-12 & 10 & 107\\\\\n",
       "\t 2022484408 & 2016-04-12 & 11 &  68\\\\\n",
       "\t 2022484408 & 2016-04-12 & 12 &  66\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A grouped_df: 6 × 4\n",
       "\n",
       "| Id &lt;chr&gt; | Date &lt;date&gt; | Hour &lt;int&gt; | Average_value &lt;int&gt; |\n",
       "|---|---|---|---|\n",
       "| 2022484408 | 2016-04-12 |  7 |  83 |\n",
       "| 2022484408 | 2016-04-12 |  8 |  69 |\n",
       "| 2022484408 | 2016-04-12 |  9 |  66 |\n",
       "| 2022484408 | 2016-04-12 | 10 | 107 |\n",
       "| 2022484408 | 2016-04-12 | 11 |  68 |\n",
       "| 2022484408 | 2016-04-12 | 12 |  66 |\n",
       "\n"
      ],
      "text/plain": [
       "  Id         Date       Hour Average_value\n",
       "1 2022484408 2016-04-12  7    83          \n",
       "2 2022484408 2016-04-12  8    69          \n",
       "3 2022484408 2016-04-12  9    66          \n",
       "4 2022484408 2016-04-12 10   107          \n",
       "5 2022484408 2016-04-12 11    68          \n",
       "6 2022484408 2016-04-12 12    66          "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "heart_rate$Date = as.Date(heart_rate$Time, \"%m/%d/%Y\")\n",
    "heart_rate$Hour = as.integer(format(heart_rate$Time, format = \"%H\"))\n",
    "heart_rate = heart_rate[, !names(heart_rate) %in% \"Time\"]\n",
    "heart_rate = heart_rate %>% group_by(Id, Date, Hour) %>% summarise(Average_value = as.integer(round(mean(Value))))\n",
    "head(heart_rate)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "8010c03d",
   "metadata": {
    "papermill": {
     "duration": 0.007013,
     "end_time": "2023-06-09T09:42:38.474095",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.467082",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "## Comparing the number of users across tables\n",
    "Counting the unique records in each table's `Id` column will tell us how many users provided data for each category."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "f910724e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:38.491623Z",
     "iopub.status.busy": "2023-06-09T09:42:38.490348Z",
     "iopub.status.idle": "2023-06-09T09:42:38.519294Z",
     "shell.execute_reply": "2023-06-09T09:42:38.517975Z"
    },
    "papermill": {
     "duration": 0.040464,
     "end_time": "2023-06-09T09:42:38.521606",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.481142",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "33"
      ],
      "text/latex": [
       "33"
      ],
      "text/markdown": [
       "33"
      ],
      "text/plain": [
       "[1] 33"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "24"
      ],
      "text/latex": [
       "24"
      ],
      "text/markdown": [
       "24"
      ],
      "text/plain": [
       "[1] 24"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "14"
      ],
      "text/latex": [
       "14"
      ],
      "text/markdown": [
       "14"
      ],
      "text/plain": [
       "[1] 14"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/html": [
       "8"
      ],
      "text/latex": [
       "8"
      ],
      "text/markdown": [
       "8"
      ],
      "text/plain": [
       "[1] 8"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "n_distinct(activity$Id)     # Activity\n",
    "n_distinct(sleep$Id)        # Sleep\n",
    "n_distinct(heart_rate$Id)   # Heart rate\n",
    "n_distinct(weight$Id)       # Weight"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "842e226f",
   "metadata": {
    "papermill": {
     "duration": 0.007885,
     "end_time": "2023-06-09T09:42:38.537660",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.529775",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "All 33 respondents provided activity data, 24 provided sleep data, 14 provided heart rate data and only eight provided weight data. The heart rate and weight data's small sample sizes do not render them useless but make generalising unreliable. As a result, I will focus the analysis on the activity and sleep data.\n",
    "\n",
    "## Removing missing values\n",
    "Consider a summary of the `Activity` table below."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "ec69f13a",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:38.556311Z",
     "iopub.status.busy": "2023-06-09T09:42:38.554887Z",
     "iopub.status.idle": "2023-06-09T09:42:38.686550Z",
     "shell.execute_reply": "2023-06-09T09:42:38.685097Z"
    },
    "papermill": {
     "duration": 0.143206,
     "end_time": "2023-06-09T09:42:38.688490",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.545284",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 6 × 8</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>Variable</th><th scope=col>N</th><th scope=col>Mean</th><th scope=col>Std. Dev.</th><th scope=col>Min</th><th scope=col>Pctl. 25</th><th scope=col>Pctl. 75</th><th scope=col>Max</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>TotalSteps          </td><td>940</td><td>7638</td><td>5087</td><td>0</td><td>3790</td><td>10727</td><td>36019</td></tr>\n",
       "\t<tr><td>VeryActiveMinutes   </td><td>940</td><td>21  </td><td>33  </td><td>0</td><td>0   </td><td>32   </td><td>210  </td></tr>\n",
       "\t<tr><td>FairlyActiveMinutes </td><td>940</td><td>14  </td><td>20  </td><td>0</td><td>0   </td><td>19   </td><td>143  </td></tr>\n",
       "\t<tr><td>LightlyActiveMinutes</td><td>940</td><td>193 </td><td>109 </td><td>0</td><td>127 </td><td>264  </td><td>518  </td></tr>\n",
       "\t<tr><td>SedentaryMinutes    </td><td>940</td><td>991 </td><td>301 </td><td>0</td><td>730 </td><td>1230 </td><td>1440 </td></tr>\n",
       "\t<tr><td>Calories            </td><td>940</td><td>2304</td><td>718 </td><td>0</td><td>1828</td><td>2793 </td><td>4900 </td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 6 × 8\n",
       "\\begin{tabular}{llllllll}\n",
       " Variable & N & Mean & Std. Dev. & Min & Pctl. 25 & Pctl. 75 & Max\\\\\n",
       " <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr>\\\\\n",
       "\\hline\n",
       "\t TotalSteps           & 940 & 7638 & 5087 & 0 & 3790 & 10727 & 36019\\\\\n",
       "\t VeryActiveMinutes    & 940 & 21   & 33   & 0 & 0    & 32    & 210  \\\\\n",
       "\t FairlyActiveMinutes  & 940 & 14   & 20   & 0 & 0    & 19    & 143  \\\\\n",
       "\t LightlyActiveMinutes & 940 & 193  & 109  & 0 & 127  & 264   & 518  \\\\\n",
       "\t SedentaryMinutes     & 940 & 991  & 301  & 0 & 730  & 1230  & 1440 \\\\\n",
       "\t Calories             & 940 & 2304 & 718  & 0 & 1828 & 2793  & 4900 \\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 6 × 8\n",
       "\n",
       "| Variable &lt;chr&gt; | N &lt;chr&gt; | Mean &lt;chr&gt; | Std. Dev. &lt;chr&gt; | Min &lt;chr&gt; | Pctl. 25 &lt;chr&gt; | Pctl. 75 &lt;chr&gt; | Max &lt;chr&gt; |\n",
       "|---|---|---|---|---|---|---|---|\n",
       "| TotalSteps           | 940 | 7638 | 5087 | 0 | 3790 | 10727 | 36019 |\n",
       "| VeryActiveMinutes    | 940 | 21   | 33   | 0 | 0    | 32    | 210   |\n",
       "| FairlyActiveMinutes  | 940 | 14   | 20   | 0 | 0    | 19    | 143   |\n",
       "| LightlyActiveMinutes | 940 | 193  | 109  | 0 | 127  | 264   | 518   |\n",
       "| SedentaryMinutes     | 940 | 991  | 301  | 0 | 730  | 1230  | 1440  |\n",
       "| Calories             | 940 | 2304 | 718  | 0 | 1828 | 2793  | 4900  |\n",
       "\n"
      ],
      "text/plain": [
       "  Variable             N   Mean Std. Dev. Min Pctl. 25 Pctl. 75 Max  \n",
       "1 TotalSteps           940 7638 5087      0   3790     10727    36019\n",
       "2 VeryActiveMinutes    940 21   33        0   0        32       210  \n",
       "3 FairlyActiveMinutes  940 14   20        0   0        19       143  \n",
       "4 LightlyActiveMinutes 940 193  109       0   127      264      518  \n",
       "5 SedentaryMinutes     940 991  301       0   730      1230     1440 \n",
       "6 Calories             940 2304 718       0   1828     2793     4900 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "sumtable(activity, vars = c(\"TotalSteps\", \"VeryActiveMinutes\", \"FairlyActiveMinutes\", \"LightlyActiveMinutes\", \"SedentaryMinutes\", \"Calories\"), out = \"return\")"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "04dd384c",
   "metadata": {
    "papermill": {
     "duration": 0.008033,
     "end_time": "2023-06-09T09:42:38.704753",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.696720",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "At least one row has a daily calorie count of zero. However, [experts](https://www.goodto.com/wellbeing/diets-exercise/what-is-calorie-how-many-lose-weigt-425557#:~:text=How%20many%20calories%20do%20I%20burn%20without%20exercise%3F,estimated%2075%20calories%20per%20hour.) believe most humans burn a minimum of 1,800 calories daily without physical activity. So for records with a calorie count less than that, users were most likely not wearing their smart devices, or at least not for most of the day. Let us count how many records like this exist."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "b80850e7",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:38.723867Z",
     "iopub.status.busy": "2023-06-09T09:42:38.722462Z",
     "iopub.status.idle": "2023-06-09T09:42:38.753969Z",
     "shell.execute_reply": "2023-06-09T09:42:38.752427Z"
    },
    "papermill": {
     "duration": 0.043974,
     "end_time": "2023-06-09T09:42:38.756655",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.712681",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>n</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>220</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " n\\\\\n",
       " <int>\\\\\n",
       "\\hline\n",
       "\t 220\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| n &lt;int&gt; |\n",
       "|---|\n",
       "| 220 |\n",
       "\n"
      ],
      "text/plain": [
       "  n  \n",
       "1 220"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "activity %>%\n",
    "  filter(Calories < 1800) %>%\n",
    "  count()"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "fe2f7379",
   "metadata": {
    "papermill": {
     "duration": 0.008179,
     "end_time": "2023-06-09T09:42:38.773172",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.764993",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "To exclude incomplete data from the analysis, I remove the records with a calorie count of less than 1,800."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "id": "ecbd9fd4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:38.793353Z",
     "iopub.status.busy": "2023-06-09T09:42:38.791738Z",
     "iopub.status.idle": "2023-06-09T09:42:38.806655Z",
     "shell.execute_reply": "2023-06-09T09:42:38.804828Z"
    },
    "papermill": {
     "duration": 0.027627,
     "end_time": "2023-06-09T09:42:38.808894",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.781267",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "activity = activity[activity$Calories >= 1800, ]"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "1bb65cf2",
   "metadata": {
    "papermill": {
     "duration": 0.008176,
     "end_time": "2023-06-09T09:42:38.825351",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.817175",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Similarly, at least one row has a `TotalSteps` value of zero. It is also probably due to users not wearing their devices that day. Let us see how many records contain no steps."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "id": "abec61e6",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:38.845140Z",
     "iopub.status.busy": "2023-06-09T09:42:38.843585Z",
     "iopub.status.idle": "2023-06-09T09:42:38.884713Z",
     "shell.execute_reply": "2023-06-09T09:42:38.883517Z"
    },
    "papermill": {
     "duration": 0.053203,
     "end_time": "2023-06-09T09:42:38.886548",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.833345",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 1 × 1</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>n</th></tr>\n",
       "\t<tr><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>43</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 1 × 1\n",
       "\\begin{tabular}{l}\n",
       " n\\\\\n",
       " <int>\\\\\n",
       "\\hline\n",
       "\t 43\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 1 × 1\n",
       "\n",
       "| n &lt;int&gt; |\n",
       "|---|\n",
       "| 43 |\n",
       "\n"
      ],
      "text/plain": [
       "  n \n",
       "1 43"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "activity %>%\n",
    "  filter(TotalSteps == 0) %>%\n",
    "  count()"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "a34f43b7",
   "metadata": {
    "papermill": {
     "duration": 0.008264,
     "end_time": "2023-06-09T09:42:38.903086",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.894822",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "To clean up the data set, I remove records with zero steps."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "id": "090170c5",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:38.922414Z",
     "iopub.status.busy": "2023-06-09T09:42:38.921064Z",
     "iopub.status.idle": "2023-06-09T09:42:38.932118Z",
     "shell.execute_reply": "2023-06-09T09:42:38.930756Z"
    },
    "papermill": {
     "duration": 0.023025,
     "end_time": "2023-06-09T09:42:38.934185",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.911160",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "activity = activity[activity$TotalSteps != 0, ]"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2fb95c69",
   "metadata": {
    "papermill": {
     "duration": 0.0083,
     "end_time": "2023-06-09T09:42:38.951073",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.942773",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# **Analysis**\n",
    "Now that the data has been cleaned, the analysis can begin.\n",
    "\n",
    "## Summary statistics\n",
    "Let's inspect the updated `activity` table by viewing its summary statistics."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 15,
   "id": "6a39353d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:38.971162Z",
     "iopub.status.busy": "2023-06-09T09:42:38.969808Z",
     "iopub.status.idle": "2023-06-09T09:42:39.013650Z",
     "shell.execute_reply": "2023-06-09T09:42:39.011559Z"
    },
    "papermill": {
     "duration": 0.056332,
     "end_time": "2023-06-09T09:42:39.015852",
     "exception": false,
     "start_time": "2023-06-09T09:42:38.959520",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 6 × 8</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>Variable</th><th scope=col>N</th><th scope=col>Mean</th><th scope=col>Std. Dev.</th><th scope=col>Min</th><th scope=col>Pctl. 25</th><th scope=col>Pctl. 75</th><th scope=col>Max</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>TotalSteps          </td><td>677</td><td>9152</td><td>4657</td><td>9   </td><td>6047</td><td>11728</td><td>36019</td></tr>\n",
       "\t<tr><td>VeryActiveMinutes   </td><td>677</td><td>28  </td><td>36  </td><td>0   </td><td>0   </td><td>45   </td><td>210  </td></tr>\n",
       "\t<tr><td>FairlyActiveMinutes </td><td>677</td><td>15  </td><td>18  </td><td>0   </td><td>0   </td><td>23   </td><td>125  </td></tr>\n",
       "\t<tr><td>LightlyActiveMinutes</td><td>677</td><td>224 </td><td>96  </td><td>0   </td><td>158 </td><td>288  </td><td>518  </td></tr>\n",
       "\t<tr><td>SedentaryMinutes    </td><td>677</td><td>966 </td><td>254 </td><td>413 </td><td>734 </td><td>1170 </td><td>1440 </td></tr>\n",
       "\t<tr><td>Calories            </td><td>677</td><td>2591</td><td>606 </td><td>1801</td><td>2070</td><td>2950 </td><td>4900 </td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 6 × 8\n",
       "\\begin{tabular}{llllllll}\n",
       " Variable & N & Mean & Std. Dev. & Min & Pctl. 25 & Pctl. 75 & Max\\\\\n",
       " <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr>\\\\\n",
       "\\hline\n",
       "\t TotalSteps           & 677 & 9152 & 4657 & 9    & 6047 & 11728 & 36019\\\\\n",
       "\t VeryActiveMinutes    & 677 & 28   & 36   & 0    & 0    & 45    & 210  \\\\\n",
       "\t FairlyActiveMinutes  & 677 & 15   & 18   & 0    & 0    & 23    & 125  \\\\\n",
       "\t LightlyActiveMinutes & 677 & 224  & 96   & 0    & 158  & 288   & 518  \\\\\n",
       "\t SedentaryMinutes     & 677 & 966  & 254  & 413  & 734  & 1170  & 1440 \\\\\n",
       "\t Calories             & 677 & 2591 & 606  & 1801 & 2070 & 2950  & 4900 \\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 6 × 8\n",
       "\n",
       "| Variable &lt;chr&gt; | N &lt;chr&gt; | Mean &lt;chr&gt; | Std. Dev. &lt;chr&gt; | Min &lt;chr&gt; | Pctl. 25 &lt;chr&gt; | Pctl. 75 &lt;chr&gt; | Max &lt;chr&gt; |\n",
       "|---|---|---|---|---|---|---|---|\n",
       "| TotalSteps           | 677 | 9152 | 4657 | 9    | 6047 | 11728 | 36019 |\n",
       "| VeryActiveMinutes    | 677 | 28   | 36   | 0    | 0    | 45    | 210   |\n",
       "| FairlyActiveMinutes  | 677 | 15   | 18   | 0    | 0    | 23    | 125   |\n",
       "| LightlyActiveMinutes | 677 | 224  | 96   | 0    | 158  | 288   | 518   |\n",
       "| SedentaryMinutes     | 677 | 966  | 254  | 413  | 734  | 1170  | 1440  |\n",
       "| Calories             | 677 | 2591 | 606  | 1801 | 2070 | 2950  | 4900  |\n",
       "\n"
      ],
      "text/plain": [
       "  Variable             N   Mean Std. Dev. Min  Pctl. 25 Pctl. 75 Max  \n",
       "1 TotalSteps           677 9152 4657      9    6047     11728    36019\n",
       "2 VeryActiveMinutes    677 28   36        0    0        45       210  \n",
       "3 FairlyActiveMinutes  677 15   18        0    0        23       125  \n",
       "4 LightlyActiveMinutes 677 224  96        0    158      288      518  \n",
       "5 SedentaryMinutes     677 966  254       413  734      1170     1440 \n",
       "6 Calories             677 2591 606       1801 2070     2950     4900 "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "sumtable(activity, vars = c(\"TotalSteps\", \"VeryActiveMinutes\", \"FairlyActiveMinutes\", \"LightlyActiveMinutes\", \"SedentaryMinutes\", \"Calories\"), out = \"return\")"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "7eb42237",
   "metadata": {
    "papermill": {
     "duration": 0.008681,
     "end_time": "2023-06-09T09:42:39.033431",
     "exception": false,
     "start_time": "2023-06-09T09:42:39.024750",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "[Various medical sources](https://www.healthline.com/health/how-many-steps-a-day) consider 10,000 steps a healthy daily minimum, so the sample mean being less than that might be something to address. Furthermore, the average daily sedentary time is 16 hours (966 minutes), while [medical professionals](https://www.healthywa.wa.gov.au/Articles/S_T/Sedentary-behaviour#:~:text=Even%20if%20you%20are%20doing,is%20bad%20for%20your%20health.&text=There%20is%20evidence%20that%20spending,being%20overweight%20or%20obese) suggest it shouldn't exceed 7-10 hours.\n",
    "\n",
    "**Perhaps Bellabeat could create or update products to facilitate an increase in daily steps and a decrease in time spent sedentarily.**\n",
    "\n",
    "Let's view a summary table of the sleep data as well."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "id": "0c664a43",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:39.053970Z",
     "iopub.status.busy": "2023-06-09T09:42:39.052571Z",
     "iopub.status.idle": "2023-06-09T09:42:39.082319Z",
     "shell.execute_reply": "2023-06-09T09:42:39.081115Z"
    },
    "papermill": {
     "duration": 0.042308,
     "end_time": "2023-06-09T09:42:39.084192",
     "exception": false,
     "start_time": "2023-06-09T09:42:39.041884",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 3 × 8</caption>\n",
       "<thead>\n",
       "\t<tr><th scope=col>Variable</th><th scope=col>N</th><th scope=col>Mean</th><th scope=col>Std. Dev.</th><th scope=col>Min</th><th scope=col>Pctl. 25</th><th scope=col>Pctl. 75</th><th scope=col>Max</th></tr>\n",
       "\t<tr><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;chr&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><td>TotalMinutesAsleep</td><td>413</td><td>419</td><td>118 </td><td>58</td><td>361</td><td>490</td><td>796</td></tr>\n",
       "\t<tr><td>TotalTimeInBed    </td><td>413</td><td>459</td><td>127 </td><td>61</td><td>403</td><td>526</td><td>961</td></tr>\n",
       "\t<tr><td>TotalSleepRecords </td><td>413</td><td>1.1</td><td>0.35</td><td>1 </td><td>1  </td><td>1  </td><td>3  </td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 3 × 8\n",
       "\\begin{tabular}{llllllll}\n",
       " Variable & N & Mean & Std. Dev. & Min & Pctl. 25 & Pctl. 75 & Max\\\\\n",
       " <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr> & <chr>\\\\\n",
       "\\hline\n",
       "\t TotalMinutesAsleep & 413 & 419 & 118  & 58 & 361 & 490 & 796\\\\\n",
       "\t TotalTimeInBed     & 413 & 459 & 127  & 61 & 403 & 526 & 961\\\\\n",
       "\t TotalSleepRecords  & 413 & 1.1 & 0.35 & 1  & 1   & 1   & 3  \\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 3 × 8\n",
       "\n",
       "| Variable &lt;chr&gt; | N &lt;chr&gt; | Mean &lt;chr&gt; | Std. Dev. &lt;chr&gt; | Min &lt;chr&gt; | Pctl. 25 &lt;chr&gt; | Pctl. 75 &lt;chr&gt; | Max &lt;chr&gt; |\n",
       "|---|---|---|---|---|---|---|---|\n",
       "| TotalMinutesAsleep | 413 | 419 | 118  | 58 | 361 | 490 | 796 |\n",
       "| TotalTimeInBed     | 413 | 459 | 127  | 61 | 403 | 526 | 961 |\n",
       "| TotalSleepRecords  | 413 | 1.1 | 0.35 | 1  | 1   | 1   | 3   |\n",
       "\n"
      ],
      "text/plain": [
       "  Variable           N   Mean Std. Dev. Min Pctl. 25 Pctl. 75 Max\n",
       "1 TotalMinutesAsleep 413 419  118       58  361      490      796\n",
       "2 TotalTimeInBed     413 459  127       61  403      526      961\n",
       "3 TotalSleepRecords  413 1.1  0.35      1   1        1        3  "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "sumtable(sleep, vars = c(\"TotalMinutesAsleep\", \"TotalTimeInBed\", \"TotalSleepRecords\"), out = \"return\")"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "2b6d68ee",
   "metadata": {
    "papermill": {
     "duration": 0.008279,
     "end_time": "2023-06-09T09:42:39.101005",
     "exception": false,
     "start_time": "2023-06-09T09:42:39.092726",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Luckily, the `sleep` table is free of zero values. The average time spent sleeping is just below seven hours (419 minutes), while [medical professionals](https://www.cdc.gov/sleep/about_sleep/how_much_sleep.html) recommend more than seven hours. \n",
    "\n",
    "**There might be an opportunity for Bellabeat to focus development on helping users increase sleeping hours.**\n",
    "\n",
    "## Merging activity and sleep data\n",
    "To easily compare activity and sleep data, I merged these two tables into a new one called `activity_sleep`. The first few rows appear below to give an idea of the joined table."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "id": "1a7eec5e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:39.120912Z",
     "iopub.status.busy": "2023-06-09T09:42:39.119561Z",
     "iopub.status.idle": "2023-06-09T09:42:39.151667Z",
     "shell.execute_reply": "2023-06-09T09:42:39.150301Z"
    },
    "papermill": {
     "duration": 0.044511,
     "end_time": "2023-06-09T09:42:39.153836",
     "exception": false,
     "start_time": "2023-06-09T09:42:39.109325",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "text/html": [
       "<table class=\"dataframe\">\n",
       "<caption>A data.frame: 4 × 18</caption>\n",
       "<thead>\n",
       "\t<tr><th></th><th scope=col>Id</th><th scope=col>Date</th><th scope=col>TotalSteps</th><th scope=col>TotalDistance</th><th scope=col>TrackerDistance</th><th scope=col>LoggedActivitiesDistance</th><th scope=col>VeryActiveDistance</th><th scope=col>ModeratelyActiveDistance</th><th scope=col>LightActiveDistance</th><th scope=col>SedentaryActiveDistance</th><th scope=col>VeryActiveMinutes</th><th scope=col>FairlyActiveMinutes</th><th scope=col>LightlyActiveMinutes</th><th scope=col>SedentaryMinutes</th><th scope=col>Calories</th><th scope=col>TotalSleepRecords</th><th scope=col>TotalMinutesAsleep</th><th scope=col>TotalTimeInBed</th></tr>\n",
       "\t<tr><th></th><th scope=col>&lt;chr&gt;</th><th scope=col>&lt;date&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;dbl&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th><th scope=col>&lt;int&gt;</th></tr>\n",
       "</thead>\n",
       "<tbody>\n",
       "\t<tr><th scope=row>1</th><td>1503960366</td><td>2016-04-12</td><td>13162</td><td>8.50</td><td>8.50</td><td>0</td><td>1.88</td><td>0.55</td><td>6.06</td><td>0</td><td>25</td><td>13</td><td>328</td><td>728</td><td>1985</td><td>1</td><td>327</td><td>346</td></tr>\n",
       "\t<tr><th scope=row>2</th><td>1503960366</td><td>2016-04-16</td><td>12669</td><td>8.16</td><td>8.16</td><td>0</td><td>2.71</td><td>0.41</td><td>5.04</td><td>0</td><td>36</td><td>10</td><td>221</td><td>773</td><td>1863</td><td>2</td><td>340</td><td>367</td></tr>\n",
       "\t<tr><th scope=row>3</th><td>1503960366</td><td>2016-04-19</td><td>15506</td><td>9.88</td><td>9.88</td><td>0</td><td>3.53</td><td>1.32</td><td>5.03</td><td>0</td><td>50</td><td>31</td><td>264</td><td>775</td><td>2035</td><td>1</td><td>304</td><td>320</td></tr>\n",
       "\t<tr><th scope=row>4</th><td>1503960366</td><td>2016-04-23</td><td>14371</td><td>9.04</td><td>9.04</td><td>0</td><td>2.81</td><td>0.87</td><td>5.36</td><td>0</td><td>41</td><td>21</td><td>262</td><td>732</td><td>1949</td><td>1</td><td>361</td><td>384</td></tr>\n",
       "</tbody>\n",
       "</table>\n"
      ],
      "text/latex": [
       "A data.frame: 4 × 18\n",
       "\\begin{tabular}{r|llllllllllllllllll}\n",
       "  & Id & Date & TotalSteps & TotalDistance & TrackerDistance & LoggedActivitiesDistance & VeryActiveDistance & ModeratelyActiveDistance & LightActiveDistance & SedentaryActiveDistance & VeryActiveMinutes & FairlyActiveMinutes & LightlyActiveMinutes & SedentaryMinutes & Calories & TotalSleepRecords & TotalMinutesAsleep & TotalTimeInBed\\\\\n",
       "  & <chr> & <date> & <int> & <dbl> & <dbl> & <dbl> & <dbl> & <dbl> & <dbl> & <dbl> & <int> & <int> & <int> & <int> & <int> & <int> & <int> & <int>\\\\\n",
       "\\hline\n",
       "\t1 & 1503960366 & 2016-04-12 & 13162 & 8.50 & 8.50 & 0 & 1.88 & 0.55 & 6.06 & 0 & 25 & 13 & 328 & 728 & 1985 & 1 & 327 & 346\\\\\n",
       "\t2 & 1503960366 & 2016-04-16 & 12669 & 8.16 & 8.16 & 0 & 2.71 & 0.41 & 5.04 & 0 & 36 & 10 & 221 & 773 & 1863 & 2 & 340 & 367\\\\\n",
       "\t3 & 1503960366 & 2016-04-19 & 15506 & 9.88 & 9.88 & 0 & 3.53 & 1.32 & 5.03 & 0 & 50 & 31 & 264 & 775 & 2035 & 1 & 304 & 320\\\\\n",
       "\t4 & 1503960366 & 2016-04-23 & 14371 & 9.04 & 9.04 & 0 & 2.81 & 0.87 & 5.36 & 0 & 41 & 21 & 262 & 732 & 1949 & 1 & 361 & 384\\\\\n",
       "\\end{tabular}\n"
      ],
      "text/markdown": [
       "\n",
       "A data.frame: 4 × 18\n",
       "\n",
       "| <!--/--> | Id &lt;chr&gt; | Date &lt;date&gt; | TotalSteps &lt;int&gt; | TotalDistance &lt;dbl&gt; | TrackerDistance &lt;dbl&gt; | LoggedActivitiesDistance &lt;dbl&gt; | VeryActiveDistance &lt;dbl&gt; | ModeratelyActiveDistance &lt;dbl&gt; | LightActiveDistance &lt;dbl&gt; | SedentaryActiveDistance &lt;dbl&gt; | VeryActiveMinutes &lt;int&gt; | FairlyActiveMinutes &lt;int&gt; | LightlyActiveMinutes &lt;int&gt; | SedentaryMinutes &lt;int&gt; | Calories &lt;int&gt; | TotalSleepRecords &lt;int&gt; | TotalMinutesAsleep &lt;int&gt; | TotalTimeInBed &lt;int&gt; |\n",
       "|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|\n",
       "| 1 | 1503960366 | 2016-04-12 | 13162 | 8.50 | 8.50 | 0 | 1.88 | 0.55 | 6.06 | 0 | 25 | 13 | 328 | 728 | 1985 | 1 | 327 | 346 |\n",
       "| 2 | 1503960366 | 2016-04-16 | 12669 | 8.16 | 8.16 | 0 | 2.71 | 0.41 | 5.04 | 0 | 36 | 10 | 221 | 773 | 1863 | 2 | 340 | 367 |\n",
       "| 3 | 1503960366 | 2016-04-19 | 15506 | 9.88 | 9.88 | 0 | 3.53 | 1.32 | 5.03 | 0 | 50 | 31 | 264 | 775 | 2035 | 1 | 304 | 320 |\n",
       "| 4 | 1503960366 | 2016-04-23 | 14371 | 9.04 | 9.04 | 0 | 2.81 | 0.87 | 5.36 | 0 | 41 | 21 | 262 | 732 | 1949 | 1 | 361 | 384 |\n",
       "\n"
      ],
      "text/plain": [
       "  Id         Date       TotalSteps TotalDistance TrackerDistance\n",
       "1 1503960366 2016-04-12 13162      8.50          8.50           \n",
       "2 1503960366 2016-04-16 12669      8.16          8.16           \n",
       "3 1503960366 2016-04-19 15506      9.88          9.88           \n",
       "4 1503960366 2016-04-23 14371      9.04          9.04           \n",
       "  LoggedActivitiesDistance VeryActiveDistance ModeratelyActiveDistance\n",
       "1 0                        1.88               0.55                    \n",
       "2 0                        2.71               0.41                    \n",
       "3 0                        3.53               1.32                    \n",
       "4 0                        2.81               0.87                    \n",
       "  LightActiveDistance SedentaryActiveDistance VeryActiveMinutes\n",
       "1 6.06                0                       25               \n",
       "2 5.04                0                       36               \n",
       "3 5.03                0                       50               \n",
       "4 5.36                0                       41               \n",
       "  FairlyActiveMinutes LightlyActiveMinutes SedentaryMinutes Calories\n",
       "1 13                  328                  728              1985    \n",
       "2 10                  221                  773              1863    \n",
       "3 31                  264                  775              2035    \n",
       "4 21                  262                  732              1949    \n",
       "  TotalSleepRecords TotalMinutesAsleep TotalTimeInBed\n",
       "1 1                 327                346           \n",
       "2 2                 340                367           \n",
       "3 1                 304                320           \n",
       "4 1                 361                384           "
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    }
   ],
   "source": [
    "activity_sleep = merge(activity, sleep, by = c(\"Id\", \"Date\"))\n",
    "head(activity_sleep, n = 4L)"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "06e906e0",
   "metadata": {
    "papermill": {
     "duration": 0.008805,
     "end_time": "2023-06-09T09:42:39.171516",
     "exception": false,
     "start_time": "2023-06-09T09:42:39.162711",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# **Visualisations**\n",
    "To explore the relationships between different variables, let's create some graphs.\n",
    "\n",
    "## Sedentary time vs Sleeping hours\n",
    "My intuition is that activity levels have an impact on sleep. One would expect higher activity levels (i.e. less sedentary time) to correlate with better sleep. The graph below illustrates the relationship between sedentary hours and sleeping hours."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 18,
   "id": "a89f57ab",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:39.192874Z",
     "iopub.status.busy": "2023-06-09T09:42:39.191602Z",
     "iopub.status.idle": "2023-06-09T09:42:40.493162Z",
     "shell.execute_reply": "2023-06-09T09:42:40.491683Z"
    },
    "papermill": {
     "duration": 1.315011,
     "end_time": "2023-06-09T09:42:40.495891",
     "exception": false,
     "start_time": "2023-06-09T09:42:39.180880",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "ggplot(activity_sleep, mapping = aes(x = SedentaryMinutes / 60, y = TotalMinutesAsleep / 60)) + \n",
    "  geom_point() +\n",
    "  geom_smooth(method = \"loess\", formula = \"y ~ x\") +\n",
    "  labs(x = \"Sedentary Hours\", y = \"Hours asleep\") +\n",
    "  scale_x_continuous(breaks = seq(0, 24, by = 2)) +\n",
    "  scale_y_continuous(breaks = seq(0, 24, by = 2))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "c4b1948e",
   "metadata": {
    "papermill": {
     "duration": 0.009827,
     "end_time": "2023-06-09T09:42:40.516170",
     "exception": false,
     "start_time": "2023-06-09T09:42:40.506343",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "As seen above, the data supports my hunch. The graph suggests that sleeping hours decrease as sedentary time increases. On average, those that spend more than 12 hours sedentarily sleep less than the recommended 7 hours.\n",
    "\n",
    "**Bellabeat can use this information to promote a product that helps lower sedentary time and increase sleeping hours.**\n",
    "\n",
    "## Total steps vs Sedentary time\n",
    "Since the previous graph showed the importance of reducing sedentary hours, let's see if increasing one's steps can help achieve that."
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 19,
   "id": "c026e172",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2023-06-09T09:42:40.539214Z",
     "iopub.status.busy": "2023-06-09T09:42:40.537845Z",
     "iopub.status.idle": "2023-06-09T09:42:40.860767Z",
     "shell.execute_reply": "2023-06-09T09:42:40.859304Z"
    },
    "papermill": {
     "duration": 0.337369,
     "end_time": "2023-06-09T09:42:40.863359",
     "exception": false,
     "start_time": "2023-06-09T09:42:40.525990",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "data": {
      "image/png": "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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "ggplot(activity_sleep, mapping = aes(x = TotalSteps, y = SedentaryMinutes / 60)) +\n",
    " geom_point() +\n",
    " geom_smooth(method = \"loess\", formula = \"y ~ x\") +\n",
    " labs(x = \"Total Steps\", y = \"Sedentary Hours\") +\n",
    " scale_x_continuous(breaks = seq(0, 30000, by = 2500)) +\n",
    " scale_y_continuous(breaks = seq(0, 24, by = 2))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "52f1e01e",
   "metadata": {
    "papermill": {
     "duration": 0.0114,
     "end_time": "2023-06-09T09:42:40.886291",
     "exception": false,
     "start_time": "2023-06-09T09:42:40.874891",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Indeed, a higher step count correlates with fewer sedentary hours. Although the relationship is intuitive, the graph's trendline reveals something interesting: On average, users with more than the recommended 10,000 steps limit their sedentary time to about 12 hours, which was also the cutoff for achieving good sleep in the previous graph.\n",
    "\n",
    "**Bellabeat can thus use total step targets to decrease sedentary time and increase sleeping hours.**\n",
    "\n",
    "# Key findings\n",
    "Let's recap the key findings of the analysis. Firstly, the **issues** uncovered are the following:\n",
    "1. The average daily steps is about 1,000 (10%) below the healthy minimum.\n",
    "2. Average sedentary time is about 4-6 hours above the healthy average.\n",
    "3. Average sleeping hours are slightly below the healthy minimum.\n",
    "\n",
    "The possible **solutions** suggested by the data include:\n",
    "1. Sleeping hours can be increased by decreasing sedentary time.\n",
    "2. Sedentary time can be decreased by increasing total steps.\n",
    "3. Thus, sleeping hours can be increased by increasing total steps.\n",
    "\n",
    "# Recommendations\n",
    "The findings listed above create an opportunity for Bellabeat to tailor products for supplying solutions. Here are some recommendations for future marketing strategies.\n",
    "\n",
    "1. In its marketing, Bellabeat should inform users of the health benefits of reaching 10,000 steps, limiting sedentary time and getting enough sleep. Similarly, they should communicate the health risks of not doing so. It should serve as users' primary motivation for using new features and products Bellabeat introduce.\n",
    "\n",
    "2. The Bellabeat app should remind and motivate users to achieve 10,000 steps. Intervalic notifications throughout the day should inform users whether they are on track to reaching their steps goal. Accountability can be increased by connecting friends on the app and making friends' progress visible to one another. Daily competitions on the app rewarding those with the most steps could help improve motivation.\n",
    "\n",
    "3. Similarly, the app should warn users if sedentary time becomes too much. Periodic updates on how much sedentary time the user has left can improve planning and increase activity. Daily competitions rewarding users with the least time spent sedentarily can improve the feature's effectiveness.\n",
    "\n",
    "4. Since getting enough sleep is crucial to being healthy and fit, Bellabeat should focus on helping users do so. The app reminding users when it's bedtime is one option. Another is to give weekly updates on sleeping hours. It will guide users to better understand their sleeping habits and to see how they can improve. Bellabeat could also focus on developing new products to improve the quality and quantity of sleep.\n",
    "\n",
    "**That's it for this case study! Thank you for taking the time to look at my work. Happy analysing!**"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.0.5"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 21.146656,
   "end_time": "2023-06-09T09:42:41.018986",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2023-06-09T09:42:19.872330",
   "version": "2.4.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
