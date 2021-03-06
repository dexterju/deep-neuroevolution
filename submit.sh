#!/bin/bash
### Section1: SBATCH directives to specify job configuration

## job name
#SBATCH --job-name=sample
## filename for job standard output (stdout)
## %j is the job id, %u is the user id
#SBATCH --output=/checkpoint/%u/jobs/sample-%j.out
## filename for job standard error output (stderr)
#SBATCH --error=/checkpoint/%u/jobs/sample-%j.err

## partition name
#SBATCH --partition=uninterrupted
## number of nodes
#SBATCH --nodes=1

## number of tasks per node
#SBATCH --ntasks-per-node=1

#SBATCH --cpus-per-task=40
#SBATCH --gres=gpu:1

#SBATCH --time=48:00:00

### Section 2: Setting environment variables for the job
### Remember that all the module command does is set environment
### variables for the software you need to. Here I am assuming I
### going to run something with python.
### You can also set additional environment variables here and
### SLURM will capture all of them for each task
# Start clean
module purge

# Load what we need
module load anaconda3


### Section 3:
### Run your job. Note that we are not passing any additional
### arguments to srun since we have already specificed the job
### configuration with SBATCH directives
### This is going to run ntasks-per-node x nodes tasks with each
### task seeing all the GPUs on each node. However I am using
### the wrapper.sh example I showed before so that each task only
### sees one GPU
srun --label wrapper.sh
