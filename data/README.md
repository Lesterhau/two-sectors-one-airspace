# Data

All datasets for this paper are publicly archived on **Harvard Dataverse**.

**DOI:** [10.7910/DVN/UNRVAO](https://doi.org/10.7910/DVN/UNRVAO)

Reproducibility bundle: **38/38 verification checks PASS**

---

## Contents

| File | Description | Source |
|---|---|---|
| `atc_panel.csv` | Panel dataset, N=108 ATC facilities | BTS T-100 + NTSB CAROL |
| `bts_departures.csv` | DEPARTURES_PERFORMED by facility and year | BTS T-100 Domestic Segment |
| `ntsb_accidents.csv` | Verified accident records by facility and year | NTSB CAROL Query System |
| `facility_metadata.csv` | Facility type, sector classification, controller counts | FAA |

## Data Sources

**BTS T-100:** Bureau of Transportation Statistics, T-100 Domestic Segment. Variable: `DEPARTURES_PERFORMED`. Scheduled vs. actual departures — this paper uses actual departures performed.

**NTSB CAROL:** National Transportation Safety Board, Accident/Incident Data System query. All accident records verified for provenance.

## Replication

```r
install.packages(c("tidyverse", "lmtest", "sandwich", "ggplot2"))
source("code/atc_regression.R")
```

See [REPLICATION.md](../replication/REPLICATION.md) for the full 38-step verification log.

## License

CC BY 4.0 — [creativecommons.org/licenses/by/4.0](https://creativecommons.org/licenses/by/4.0/)

**Citation:**
> Lester, Ryan S. 2026. "Replication Data for: Two Sectors, One Airspace." Harvard Dataverse. https://doi.org/10.7910/DVN/UNRVAO
