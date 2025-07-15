# Nanopore-Cancer-Workflow

A Nextflow pipeline for cancer analysis using Oxford Nanopore sequencing data.

## Quick Start

1. Install Nextflow (>=22.10.1)
2. Install Docker or Singularity (optional)
3. Download the pipeline and test it on a minimal dataset

```bash
nextflow run /path/to/Nanopore-Cancer-Workflow -profile test,docker
