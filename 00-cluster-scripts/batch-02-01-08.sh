#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 24:00:00
#SBATCH --mem 5000
#SBATCH --output=./../00-cluster-out/02-01-08-%a.out
#SBATCH --error=./../00-cluster-err/02-01-08-%a.err
#SBATCH --array=1-1

## add R module
module add r/3.3.1

## run R command
R CMD BATCH "--no-save --args $SLURM_ARRAY_TASK_ID" ./../02-01-r-programs/08-design-inputs-3ind.R ./../00-cluster-logs/02-01-08-$SLURM_ARRAY_TASK_ID.Rout