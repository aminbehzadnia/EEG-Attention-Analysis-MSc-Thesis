# EEG Brain Signal Analysis During Sustained Attention (MSc Thesis)

My **MSc thesis in Electronic Engineering**: an EEG study analysing how brain activity changes during a sustained-attention task, and how those changes relate to attentional performance. The work combines primary EEG data collection, a full signal-processing pipeline, and statistical analysis.

> MSc Electronic Engineering — Islamic Azad University, Bojnourd Branch.
> Title: *Brain Signal Analysis During Sustained Attention*. Author: Amin Behzadnia.
> Supervisor: Dr. Majid Ghoshuni · Advisor: Dr. Soghra Akbari Chermahini.

📄 A full English summary of the thesis is in [`Thesis-Summary.md`](Thesis-Summary.md).

## Overview

Sustained attention — the ability to keep focus on a continuous, repetitive task — is central to everyday functioning and to diagnosing conditions such as ADHD. This thesis records the EEG of healthy participants while they perform a sustained-attention task and examines how the power of different brainwave bands changes, and how those changes correlate with how well each person performs.

- **Participants:** 20 healthy, right-handed university students (final sample), recorded at rest with eyes closed, eyes open, and during the attention task.
- **Task:** Conjunctive Continuous Performance Task (CCPT) — a validated measure of sustained attention.
- **Acquisition:** EEG cap following the international 10–20 system, 19 active channels.
- **Grouping:** participants were split (median split on reaction-time variance) into stronger- and weaker-attention groups for comparison.

## Signal-Processing & Analysis Pipeline

- Re-referencing each channel to the average of both ears.
- Band-pass filtering with elliptic filters (high-pass 0.5 Hz, low-pass 70 Hz).
- Artefact removal (blink and movement artefacts beyond threshold excluded).
- Absolute and relative power spectra computed with **Welch's method** (Hanning window, 2 s, 50% overlap) across five bands — delta, theta, alpha, beta, gamma — at the **Pz, Cz, and Fz** electrodes.
- Statistical testing in **SPSS**: paired-sample *t*-tests and Pearson correlation (significance at p < 0.05).

## Key Findings

- **Alpha power** decreased significantly during the task (and from eyes-closed to eyes-open) in participants with good attention performance (p < 0.001 at Pz) — but not in weaker performers.
- Higher relative alpha and delta power during the task correlated with greater reaction-time variance, i.e. weaker sustained attention.
- **Beta power** tended to rise with better performance (higher alertness and faster responses).
- Overall, lower alpha/delta and higher beta/theta activity were associated with stronger sustained-attention performance — consistent with prior literature.

## Tools & Methods

| Area | Tools / methods |
|------|-----------------|
| Acquisition | EEG cap, 10–20 system, CCPT paradigm |
| Signal processing | MATLAB (elliptic filtering, Welch power spectral density, artefact rejection) |
| Statistics | SPSS (paired *t*-test, Pearson correlation) |
| Bands analysed | Delta, Theta, Alpha, Beta, Gamma |

## Code

The MATLAB pipeline used in the thesis is in [`code/`](code/):

- **Data import & conversion** — `EEG_Reading2.m`, `txt2mat_A.m` (read raw recordings via BioSig into `.mat`).
- **Event extraction** — `Ext_Stim.m`, `Ext_Stim_A.m` (extract stimulus/response events per modality).
- **Filtering** — `Filtering3.m` (elliptic high-pass / low-pass and 50 Hz notch filtering, fs = 250 Hz).
- **Preprocessing pipeline** — `Prep_P1_A.m` … `Prep_P4_A.m` (staged epoching and artefact handling).
- **Processing** — `Proc_P1_A.m`, `Proc_P2_A.m`.
- **ERP components** — `N200compute.m`, `P200compute.m` (compute N200 / P200 event-related potentials).
- **Grand averaging & plotting** — `grandav.m`, `Grandplot.m`.
- **Channel montage** — `Standard-10-20-Cap19.locs` (19-channel 10–20 electrode locations).

## Repository Structure

```
EEG-Attention-Analysis-MSc-Thesis/
├── README.md
├── Thesis-Summary.md                            # Full English summary (abstract)
└── code/                                         # MATLAB EEG/ERP processing pipeline
    ├── EEG_Reading2.m, txt2mat_A.m
    ├── Ext_Stim.m, Ext_Stim_A.m
    ├── Filtering3.m
    ├── Prep_P1_A.m … Prep_P4_A.m
    ├── Proc_P1_A.m, Proc_P2_A.m
    ├── N200compute.m, P200compute.m
    ├── grandav.m, Grandplot.m
    └── Standard-10-20-Cap19.locs
```

> The MATLAB scripts rely on the [EEGLAB](https://eeglab.org/) / BioSig toolboxes for EEG import and processing.

## Related Work

This thesis is the foundation for my later, data-analytics-focused project on EEG eye-state classification, where I apply machine learning to similar EEG signals. See my **[EEG-Classification-ML](https://github.com/aminbehzadnia/EEG-Classification-ML)** repository.

## Notes

This is original academic work submitted as my MSc (Electronic Engineering) thesis, shared here as part of my research and data analytics portfolio.
