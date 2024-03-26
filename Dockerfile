
FROM nvidia/cuda:11.7.1-cudnn8-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

# Install apt-getable dependencies
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        cmake \
        git \
        libeigen3-dev \
        libopencv-dev \
        libceres-dev \
        python3-dev \
        python3-numpy \
        python3-opencv \
        python3-pip \
        python3-pyproj \
        python3-scipy \
        python3-yaml \
        curl \
        ninja-build \
        libboost-all-dev \
        sudo \
        bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG TORCH_CUDA_ARCH_LIST="Maxwell;Maxwell+Tegra;Pascal;Volta;Turing" # Kepler support has been dropped in compute 3.x
ENV TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST}"

RUN pip3 install networkx 
RUN pip3 install packaging setuptools>=49.4.0
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu117

# ==================================================================================================
# Flash Attention version 1.0.9. Latest version to support Tesla GPU. For Ampere GPU, use the latest version.
# ==================================================================================================
RUN git clone https://github.com/Dao-AILab/flash-attention.git
RUN cd flash-attention && git checkout 6d48e14a6c2f551db96f0badc658a6279a929df3 && python3 setup.py install

# ==================================================================================================
# LightGlue. Optionally uses Flash Attention to speed up the process. Patched to work with pre-normalized feature coordinates
# ==================================================================================================
RUN git clone https://github.com/cvg/LightGlue.git
COPY ./lightglue.patch LightGlue/
RUN cd LightGlue && pip install  .

# ==================================================================================================
# pypopsift. GPU accelerated SIFT. needs libboost-all-dev
# ==================================================================================================
RUN git clone --recurse-submodules https://github.com/OpenDroneMap/pypopsift
RUN cd pypopsift && mkdir build && cd build && cmake .. -DPYBIND11_PYTHON_VERSION=3.8
RUN cd pypopsift/build && make -j8
RUN cd pypopsift && pip install -e .

# ==================================================================================================
# ALIKED Feature detector
# ==================================================================================================
RUN git clone --recurse-submodules https://github.com/Shiaoming/ALIKED.git
RUN cd ALIKED && pip install -r requirements.txt
RUN cd ALIKED/custom_ops && python3 setup.py build_ext --inplace && python3 setup.py install

RUN git clone --recursive https://github.com/inuex35/ind-bermuda-opensfm.git /source/OpenSfM && \
    cd /source/OpenSfM && \
    sed -i 's/\r$//' bin/* && \
    sed -i 's/\r$//' viewer/node_modules.sh && \
    pip3 install jupyterlab pyproj && \
    pip3 install cloudpickle==0.4.0 exifread==2.1.2 flask==2.3.2 fpdf2==2.4.6 joblib matplotlib networkx==2.5  numpy Pillow>=8.1.1 pytest==3.0.7 python-dateutil>=2.7 pyyaml scipy Sphinx==4.2.0 six xmltodict==0.10.2 wheel  opencv-python && \
    python3 setup.py build && \
    bash viewer/node_modules.sh
RUN pip3 install numpy scipy -U
ENV PYTHONPATH=/ALIKED:$PYTHONPATH

RUN useradd -ms /bin/bash ubuntu && \
    echo 'ubuntu:ubuntu' | chpasswd

RUN chown -R ubuntu:ubuntu /source/OpenSfM

WORKDIR /source/OpenSfM

USER ubuntu
RUN python3 setup.py build
RUN bash viewer/node_modules.sh
ENV PATH="${PATH}:/home/ubuntu/.local/bin"
ENV PYTHONPATH=/app/ALIKED:$PYTHONPATH