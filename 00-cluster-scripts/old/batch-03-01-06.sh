#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -t 36:00:00
#SBATCH --mem 4000
#SBATCH --output=./../00-cluster-out/03-01-06-%a.out
#SBATCH --error=./../00-cluster-err/03-01-06-%a.err
#SBATCH --array=1-679

## add SAS
module add sas/9.4


## run SAS command
sas -work /pine/appscr/saswork -noterminal ./../03-01-sas-programs/06-Estimate-Design-Properties.sas -log "./../00-cluster-logs/03-01-06-$SLURM_ARRAY_TASK_ID.log" -sysparm "$SLURM_ARRAY_TASK_ID"