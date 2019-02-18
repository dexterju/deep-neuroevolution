#!/bin/bash
#ry of this explicit setting of CUDA_VISIBLE_DEVICES. Say you are
# running one task and asked for gres=gpu:1 then setting this variable will mean
# all your processes will want to run GPU 0 - disaster!! Setting this variable
# only makes sense in specific cases that I have described above where you are
# using gres=gpu:8 and I have spawned 8 tasks. So I need to divvy up the GPUs
# between the tasks. Think THRICE before you set this!!
export CUDA_VISIBLE_DEVICES=$SLURM_LOCALID

# Debug output
echo $SLURMD_NODENAME $SLURM_JOB_ID $CUDA_VISIBLE_DEVICES

# Your CUDA enabled program here
. env/bin/activate
pip install -r requirements.txt
# Start local redis server
redis-server redis_config/redis_master.conf &
redis-server redis_config/redis_local_mirror.conf & 
# Start exp
#!/bin/sh
NAME=exp_`date "+%m_%d_%H_%M_%S"`
ALGO="es"
EXP_FILE="configurations/frostbite_es.json"
LOG_FILE="log"
LOG_FILE+=$NAME
python -m es_distributed.main master --master_socket_path /tmp/es_redis_master.sock --algo $ALGO --exp_file $EXP_FILE --log_dir $LOG_FILE &
python -m es_distributed.main workers --master_host localhost --relay_socket_path /tmp/es_redis_relay.sock --algo $ALGO --num_workers 40 


