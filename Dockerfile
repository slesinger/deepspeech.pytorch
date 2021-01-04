FROM pytorch/pytorch:1.5.1-cuda10.1-cudnn7-devel
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
EXPOSE 8888
EXPOSE 10456


WORKDIR /workspace/

# install basics
RUN apt-get update -y
RUN apt-get install -y git curl ca-certificates bzip2 cmake tree htop bmon iotop sox libsox-dev libsox-fmt-all vim

# install warp-CTC
ENV CUDA_HOME=/usr/local/cuda
RUN git clone https://github.com/SeanNaren/warp-ctc.git
RUN cd warp-ctc; mkdir build; cd build; cmake ..; make
RUN cd warp-ctc; cd pytorch_binding; python setup.py install

# install ctcdecode
RUN git clone --recursive https://github.com/parlance/ctcdecode.git
RUN cd ctcdecode; pip install .

# install apex
RUN git clone --recursive https://github.com/NVIDIA/apex.git
RUN cd apex; pip install .

# install deepspeech.pytorch
ADD . /workspace/deepspeech.pytorch
RUN cd deepspeech.pytorch; pip install -r requirements.txt && pip install -e .

# launch jupyter
WORKDIR /workspace/deepspeech.pytorch
#RUN mkdir data; mkdir notebooks;
#CMD jupyter-notebook --ip="*" --no-browser --allow-root
CMD /workspace/deepspeech.pytorch/server.sh
