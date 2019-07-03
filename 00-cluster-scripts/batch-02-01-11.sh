#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 36:00:00
#SBATCH --mem 4000
#SBATCH --output=./../00-cluster-out/02-01-11-%a.out
#SBATCH --error=./../00-cluster-err/02-01-11-%a.err
#SBATCH --array=1-255

## add R module
module add r/3.3.1

## run R command
R CMD BATCH "--no-save --args $SLURM_ARRAY_TASK_ID" ./../02-01-r-programs/11-estimate-design-bhm-3ind.R ./../00-cluster-logs/02-01-11-$SLURM_ARRAY_TASK_ID.Rout