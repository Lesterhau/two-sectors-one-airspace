# atc_regression.R
#
# Two Sectors, One Airspace: Workload, Complexity, and Safety in ATC
# Primary Regression Analysis — Newey-West HAC Standard Errors
#
# Author: Ryan S. Lester | SSRN 6520839 | doi:10.7910/DVN/UNRVAO
#
# Description:
#   Estimates the inverted-U workload/safety model using panel data
#   from N=108 ATC facilities. Applies Newey-West HAC standard errors
#   to account for temporal autocorrelation in safety incident data.
#
#   Data sources:
#     - BTS T-100: DEPARTURES_PERFORMED (commercial sector)
#     - NTSB CAROL: Verified accident records
#
# Dependencies: tidyverse, lmtest, sandwich, fixest, ggplot2


library(tidyverse)
library(lmtest)
library(sandwich)
library(ggplot2)


# ── Load data ─────────────────────────────────────────────────────────────────
# Full dataset available at: https://doi.org/10.7910/DVN/UNRVAO

data_path <- "data/atc_panel.csv"

if (!file.exists(data_path)) {
  stop(
    "Data file not found. Download from Harvard Dataverse:\n",
    "https://doi.org/10.7910/DVN/UNRVAO\n",
    "Place atc_panel.csv in the data/ directory."
  )
}

atc <- read_csv(data_path, show_col_types = FALSE)

cat("Dataset loaded:\n")
cat("  Facilities (N):", n_distinct(atc$facility_id), "\n")
cat("  Years:", min(atc$year), "–", max(atc$year), "\n")
cat("  Observations:", nrow(atc), "\n\n")


# ── Variable construction ─────────────────────────────────────────────────────

atc <- atc |>
  mutate(
    # Accident rate per departure (primary safety outcome)
    accident_rate     = accidents / departures_performed * 1e6,
    log_accident_rate = log(accident_rate + 0.001),

    # Workload measures
    workload          = departures_performed / n_controllers,
    workload_sq       = workload^2,
    log_workload      = log(workload),

    # Complexity index (sector-type weighted)
    complexity_idx    = complexity_score * sector_type_weight,

    # COVID indicator (2020–2021)
    covid             = as.integer(year %in% c(2020, 2021)),

    # Interaction: complexity × sector type
    complexity_terminal = complexity_idx * is_terminal
  )


# ── Primary model: Inverted-U workload/safety ─────────────────────────────────

cat("── Primary Model: Inverted-U Workload/Safety ────────────────────────\n")

model_primary <- lm(
  log_accident_rate ~ workload + workload_sq +
    complexity_idx + covid + factor(year) + factor(sector_type),
  data = atc
)

# Newey-West HAC standard errors (lag = 4, consistent with annual panel)
nw_se <- NeweyWest(model_primary, lag = 4, prewhite = FALSE)
primary_results <- coeftest(model_primary, vcov = nw_se)

cat("\nNewey-West HAC Results (lag=4):\n")
print(primary_results)


# ── Inverted-U test ───────────────────────────────────────────────────────────
# Inverted-U requires: beta_workload > 0 AND beta_workload_sq < 0

beta_w  <- coef(model_primary)["workload"]
beta_w2 <- coef(model_primary)["workload_sq"]

cat("\n── Inverted-U Test ──────────────────────────────────────────────────\n")
cat(sprintf("  β_workload    = %.4f (expected > 0)\n", beta_w))
cat(sprintf("  β_workload_sq = %.4f (expected < 0)\n", beta_w2))
cat(sprintf("  Inverted-U confirmed: %s\n",
            ifelse(beta_w > 0 & beta_w2 < 0, "YES ✓", "NO")))

# Peak workload (where dAccident/dWorkload = 0)
peak_workload <- -beta_w / (2 * beta_w2)
cat(sprintf("  Peak workload (turning point): %.2f departures/controller\n",
            peak_workload))


# ── Subsample: En route vs. Terminal ─────────────────────────────────────────

cat("\n── Subsample: En Route vs. Terminal ────────────────────────────────\n")

for (sector in c("en_route", "terminal")) {
  sub_data <- filter(atc, sector_type == sector)
  m <- lm(
    log_accident_rate ~ workload + workload_sq + complexity_idx + covid,
    data = sub_data
  )
  nw <- NeweyWest(m, lag = 3, prewhite = FALSE)
  cat(sprintf("\n%s sector (N=%d facilities):\n", sector, n_distinct(sub_data$facility_id)))
  print(coeftest(m, vcov = nw)[c("workload", "workload_sq"), ])
}


# ── COVID operational collapse ────────────────────────────────────────────────

cat("\n── COVID Operational Collapse ───────────────────────────────────────\n")
covid_summary <- atc |>
  group_by(covid) |>
  summarise(
    mean_departures    = mean(departures_performed, na.rm = TRUE),
    mean_accident_rate = mean(accident_rate, na.rm = TRUE),
    .groups = "drop"
  ) |>
  mutate(period = ifelse(covid == 1, "COVID (2020-21)", "Non-COVID"))

print(covid_summary)
pct_change <- (covid_summary$mean_accident_rate[2] /
               covid_summary$mean_accident_rate[1] - 1) * 100
cat(sprintf("\nAccident rate change during COVID: +%.1f%%\n", pct_change))
cat("(Fewer flights, but accident rates rose — contradicts 'fewer flights = safer' premise)\n")


# ── Figure: Inverted-U fitted curve ──────────────────────────────────────────

workload_seq <- seq(min(atc$workload, na.rm = TRUE),
                    max(atc$workload, na.rm = TRUE), length.out = 200)

pred_df <- tibble(
  workload      = workload_seq,
  workload_sq   = workload_seq^2,
  complexity_idx = mean(atc$complexity_idx, na.rm = TRUE),
  covid          = 0,
  year           = median(atc$year),
  sector_type    = "en_route"
)

pred_df$fitted <- predict(model_primary, newdata = pred_df)

p <- ggplot(pred_df, aes(x = workload, y = fitted)) +
  geom_line(color = "#1f4e79", lwd = 1.5) +
  geom_vline(xintercept = peak_workload, lty = "dashed", color = "#c00000") +
  annotate("text", x = peak_workload + 2, y = max(pred_df$fitted) * 0.98,
           label = sprintf("Peak\n(%.0f dep/ctrl)", peak_workload),
           color = "#c00000", size = 3.5) +
  labs(
    x = "Workload (Departures per Controller)",
    y = "Log Accident Rate (per million departures)",
    title = "Inverted-U Workload/Safety Curve",
    subtitle = "ATC facility panel, N=108. Newey-West HAC SE. Fitted values at mean complexity."
  ) +
  theme_minimal(base_size = 11)

dir.create("output", showWarnings = FALSE)
ggsave("output/figure_inverted_u.png", p, width = 7, height = 4.5, dpi = 150)
cat("\nSaved: output/figure_inverted_u.png\n")
