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

### Step 1: Build Base Image

The base image provides ROCm, Python, and build tools:

```bash
cd docker/base
docker build -f Dockerfile-ROCm-6_4_4-Python-3_12-WSL2 -t harmonyai/base-rocm:6_4_4-py3_12-wsl2:latest .
```

### Step 2: Build Application Images

Once the base image is built, build application images:

#### llama.cpp

```bash
cd docker/llamacpp
docker build -f Dockerfile-llamacpp-WSL2 -t harmonyai/llama-cpp-rocm-wsl2:latest .
```

## Image Structure

```
docker/
├── README.md                          # This file
├── base/                              # Base images
│   ├── Dockerfile-ROCm-6_4_4-Python-3_12-WSL2
│   └── README.md
└── llamacpp/                          # llama.cpp application
    ├── Dockerfile-llamacpp-WSL        # Builds on base image
    ├── entrypoint.sh
    └── README.md
```

## Running Containers

Harmony Link offers specific AMD-WSL integrations for our WSL based images.

Please use Harmony Link for linux from inside WSL or run Harmony Link in container mode in order 
for WSL mounts to properly resolve when using WSL integrations.
