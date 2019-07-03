#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 48:00:00
#SBATCH --mem 24000
#SBATCH --output=./../00-cluster-out/03-01-03-%a.out
#SBATCH --error=./../00-cluster-err/03-01-03-%a.err
#SBATCH --array=1-1

## add SAS
module add sas/9.4


## run SAS command
sas -work /pine/appscr/saswork  -noterminal ./../03-01-sas-programs/03-Sampling-Priors.sas -log "./../00-cluster-logs/03-01-03-$SLURM_ARRAY_TASK_ID.log" -sysparm "$SLURM_ARRAY_TASK_ID"