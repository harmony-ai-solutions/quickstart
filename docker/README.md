# Docker Images for AMD GPU on WSL2

This directory contains Docker images for running AI workloads on AMD GPUs in WSL2.

## Prerequisites Setup

### 1. Install WSL2

Install WSL2 on Windows:

```powershell
# Run in PowerShell as Administrator
wsl --install
```

Verify installation:

```bash
wsl --version
```

### 2. Install AMD GPU Drivers in WSL2

Inside your WSL2 Ubuntu distribution:

```bash
# Download and install AMDGPU installer
wget https://repo.radeon.com/amdgpu-install/6.4.4/ubuntu/noble/amdgpu-install_6.4.60404-1_all.deb
sudo apt install ./amdgpu-install_6.4.60404-1_all.deb

# Install ROCm for WSL (no kernel modules needed)
sudo amdgpu-install -y --usecase=wsl,rocm --no-dkms

# Verify GPU detection
rocm-smi
```

### 3. Install Docker in WSL2

```bash
# Remove old Docker packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index and install Docker
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group
sudo usermod -aG docker $USER

# Restart shell or run
newgrp docker
```

## Building Images

### Step 1: Build Base ROCm Image

The base ROCm image provides ROCm 6.4.4, Python 3.12, and build tools:

```bash
cd docker/base
docker build -f Dockerfile-ROCm-6_4_4-Python-3_12-WSL2 -t harmonyai/base-rocm-wsl2:6.4.4-py3.12-wsl2 .
```

### Step 2: (Optional) Build PyTorch Base Images

You can build PyTorch-enabled base images with specific versions. These include PyTorch, TorchVision, TorchAudio, and Triton:

#### PyTorch 2.6.0

```bash
cd docker/base
docker build -f Dockerfile-PyTorch-2_6_0-ROCm-6_4_4-WSL2 -t harmonyai/base-pytorch-rocm-wsl2:2.6.0-rocm6.4.4 .
```

**Included versions:**
- PyTorch: 2.6.0
- TorchVision: 0.21.0
- TorchAudio: 2.6.0
- Triton: 3.2.0

#### PyTorch 2.7.1

```bash
cd docker/base
docker build -f Dockerfile-PyTorch-2_7_1-ROCm-6_4_4-WSL2 -t harmonyai/base-pytorch-rocm-wsl2:2.7.1-rocm6.4.4 .
```

**Included versions:**
- PyTorch: 2.7.1
- TorchVision: 0.22.1
- TorchAudio: 2.7.1
- Triton: 3.3.1

#### PyTorch 2.8.0

```bash
cd docker/base
docker build -f Dockerfile-PyTorch-2_8_0-ROCm-6_4_4-WSL2 -t harmonyai/base-pytorch-rocm-wsl2:2.8.0-rocm6.4.4 .
```

**Included versions:**
- PyTorch: 2.8.0
- TorchVision: 0.23.0
- TorchAudio: 2.8.0
- Triton: 3.4.0

### Step 3: Build Application Images

Once the base image is built, build application images:

#### llama.cpp

```bash
cd docker/llamacpp
docker build -f Dockerfile-llamacpp-WSL2 -t harmonyai/llamacpp-rocm-wsl2:latest .
```

## Image Structure

```
docker/
├── README.md                                        # This file
├── base/                                            # Base images
│   ├── Dockerfile-ROCm-6_4_4-Python-3_12-WSL2      # Base ROCm + Python
│   ├── Dockerfile-PyTorch-2_6_0-ROCm-6_4_4-WSL2    # PyTorch 2.6.0 variant
│   ├── Dockerfile-PyTorch-2_7_1-ROCm-6_4_4-WSL2    # PyTorch 2.7.1 variant
│   ├── Dockerfile-PyTorch-2_8_0-ROCm-6_4_4-WSL2    # PyTorch 2.8.0 variant
│   └── README.md
└── llamacpp/                                        # llama.cpp application
    ├── Dockerfile-llamacpp-WSL2                     # Builds on base image
    ├── entrypoint.sh
    └── README.md
```

## PyTorch Image Details

The PyTorch base images are built on top of the base ROCm WSL2 image and include:
- Pre-installed PyTorch with ROCm 6.4.4 support
- TorchVision, TorchAudio, and Triton libraries
- Optimized for AMD RDNA 1-4 discrete GPUs (gfx1010-gfx1201)
- Automatic verification of PyTorch installation during build

These images are suitable for:
- Deep learning workloads requiring PyTorch
- Custom applications needing PyTorch as a base layer
- Development and testing of PyTorch-based AI models

## Running Containers

Harmony Link offers specific AMD-WSL integrations for our WSL based images.

Please use Harmony Link for linux from inside WSL or run Harmony Link in container mode in order 
for WSL mounts to properly resolve when using WSL integrations.
