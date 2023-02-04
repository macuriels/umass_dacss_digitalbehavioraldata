library(gtrendsR)
library(ggplot2)
library(prophet)
library(highcharter)

# GET GOOGLE TREND DATA
res <- gtrends(c("ukraine"), geo = c("US","CA","GB","AU"))
#VISUALIZE THE TREND
plot(res)

#CREATE A DATAFRAME OF GOOGLE TREND DATA
trends <- res$interest_over_time

trends$hits <- if (typeof(trends$hits) == "character") {
  as.numeric(gsub("<", "", trends$hits))
} else {
  trends$hits
}

#TRY INTERACTIVE PLOT
trends$date <- as.Date(trends$date)
title <- paste0("trend", Sys.Date())
highchart() %>%
  hc_add_series(trends,"line", hcaes(x = date, y = hits,group=geo)) %>%
  hc_xAxis(type = "datetime")

### TRY FORECASTING
forcase <- trends[trends$geo=="US",c("date","hits")]
colnames(forcase) <-c("ds","y")

m <- prophet(forcase)

future <- make_future_dataframe(m, periods = 365)
forecast <- predict(m, future)
plot(m, forecast)

prophet_plot_components(m, forecast)
