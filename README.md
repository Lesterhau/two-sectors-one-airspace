# Two Sectors, One Airspace: Workload, Complexity, and Safety in Air Traffic Control

[![Journal](https://img.shields.io/badge/Journal-Air_Transport_Management-blue?style=flat-square)](https://www.journals.elsevier.com/journal-of-air-transport-management)
[![DOI](https://img.shields.io/badge/DOI-10.7910%2FDVN%2FUNRVAO-C90016?style=flat-square)](https://doi.org/10.7910/DVN/UNRVAO)
[![Reproducibility](https://img.shields.io/badge/Reproducibility-38%2F38_PASS-brightgreen?style=flat-square)]()
[![ORCID](https://img.shields.io/badge/ORCID-0009--0002--7840--5676-A6CE39?style=flat-square&logo=orcid)](https://orcid.org/0009-0002-7840-5676)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey?style=flat-square)](https://creativecommons.org/licenses/by/4.0/)

**Author:** Ryan S. Lester, RL Perspectives, LLC · University of Houston

**Status:** Under review — *Journal of Air Transport Management*

---

## Abstract

Air traffic control (ATC) operates across two fundamentally different sectors — en route and terminal — with distinct workload profiles, complexity drivers, and safety risk distributions. This paper develops an inverted-U workload/safety model and tests it empirically using a panel dataset of N=108 ATC facilities, employing Newey-West heteroskedasticity- and autocorrelation-consistent (HAC) regression to account for temporal dependence in safety incident data.

Key findings: workload exhibits a non-linear relationship with safety outcomes consistent with the inverted-U hypothesis; complexity moderates this relationship asymmetrically across sector types; and the safety implications of understaffing differ meaningfully between en route and terminal sectors — a distinction largely absent from existing regulatory frameworks.

---

## Data & Reproducibility

All data is publicly archived on **Harvard Dataverse**:

**DOI:** [10.7910/DVN/UNRVAO](https://doi.org/10.7910/DVN/UNRVAO)

The reproducibility bundle has been independently verified: **38/38 checks PASS**.

---

## Methods

| Component | Approach |
|---|---|
| Identification strategy | Panel regression, N=108 ATC facilities |
| Standard errors | Newey-West HAC (heteroskedasticity + autocorrelation consistent) |
| Primary model | Inverted-U workload/safety curve |
| Robustness | GMM specification; subsample by sector type |
| Software | R (`lmtest`, `sandwich`, `ggplot2`) |

---

## Repository Structure

```
two-sectors-one-airspace/
├── paper/
│   └── two_sectors_one_airspace.pdf       # Submitted manuscript
├── data/
│   └── README_dataverse.md                # Dataverse bundle documentation
├── code/
│   ├── analysis/
│   │   ├── main_regression.R              # Primary Newey-West models
│   │   ├── robustness_checks.R            # GMM and subsample analysis
│   │   └── figures.R                      # All paper figures
│   └── replication/
│       ├── REPLICATION.md                 # Step-by-step replication guide
│       └── verification_log.txt           # 38/38 PASS verification log
└── supplementary/
    └── appendix.pdf
```

---

## Public Rollout

This paper has been shared publicly across:
- [Substack (RLPerspectives.com)](https://rlperspectives.com)
- LinkedIn · X (Twitter) · Medium · Reddit
- NATCA and PASS community outreach

---

## Backup Venues

If *Journal of Air Transport Management* declines: **Accident Analysis & Prevention** · **Journal of Safety Research**

---

## Citation

```bibtex
@article{lester2026atc,
  author  = {Lester, Ryan S.},
  title   = {Two Sectors, One Airspace: Workload, Complexity, and Safety 
             in Air Traffic Control},
  journal = {Journal of Air Transport Management},
  year    = {2026},
  note    = {Under review},
  doi     = {10.7910/DVN/UNRVAO}
}
```

---

## Contact

**Ryan S. Lester** · rslester@cougarnet.uh.edu · [ORCID](https://orcid.org/0009-0002-7840-5676) · [RL Perspectives](https://rlperspectives.com)
