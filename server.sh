#!/bin/bash

echo "Model  \$MODEL: $MODEL"
echo "LM binary \$LM: $LM"

python server.py host=0.0.0.0 port=10456 model.use_half=false model.cuda=false model.model_path=$MODEL lm.decoder_type=beam lm.lm_path=$LM
