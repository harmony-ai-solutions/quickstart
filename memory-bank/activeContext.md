# Project Harmony.AI Quickstart - Active Context

## Current Work Focus
**JUST COMPLETED**: Implemented GitHub Actions CI/CD workflows for automated Docker image deployment of AMD ROCm WSL2 images. Added two workflows for building and pushing the base ROCm image and llama.cpp ROCm image to Docker Hub, with flexible version tagging for releases and dev builds.

The Quickstart project now includes comprehensive CI/CD automation for WSL2-optimized Docker images alongside its six AI service integrations. This enables automated deployment of ROCm-based images for AMD GPU users on WSL2, complementing the existing integration management capabilities.

## Recent Changes

### ✅ GitHub Actions CI/CD for AMD ROCm WSL2 Images (Just Completed)
**Description**: Implemented automated build and deployment workflows for Docker images optimized for AMD GPUs on WSL2, enabling consistent releases to Docker Hub.

**Key Changes:**
- **Base ROCm Image Workflow** (`docker-release-base-rocm-wsl2.yml`):
  - Builds `harmonyai/base-rocm-wsl2` image from ROCm 6.4.4 + Python 3.12 base
  - Supports RDNA 1-4 GPU architectures (gfx1010 through gfx1201)
  - Tags: `6.4.4-py3.12-wsl2` for releases, `dev` for manual builds, always `latest`
  - Includes space optimization and build cache management for large ROCm installation
  
- **llama.cpp ROCm Image Workflow** (`docker-release-llamacpp-wsl.yml`):
  - Builds `harmonyai/llamacpp-rocm-wsl` image with HIP-enabled llama.cpp server
  - Built on top of base-rocm-wsl2 image
  - Same tagging strategy: `6.4.4-py3.12-wsl2` / `dev` / `latest`
  - Independent workflow allowing separate deployment cycles

- **Dockerfile Updates**:
  - Updated llama.cpp Dockerfile to reference correct base image: `harmonyai/base-rocm-wsl2:6.4.4-py3.12-wsl2`
  - Ensures reproducible builds with pinned base image version

- **Workflow Features**:
  - Triggered by git tag push (any tag) or manual workflow_dispatch
  - Version handling: git tags → `6.4.4-py3.12-wsl2`, manual → `dev` (customizable)
  - Build space maximization (removes dotnet, android, haskell to free ~20GB)
  - Docker data-root relocation to workspace for large image builds
  - Build cache redirection (pip, npm, ccache, cargo) for faster builds
  - Docker Buildx for advanced build features
  - Requires GitHub secrets: `DOCKER_HUB_USERNAME`, `DOCKER_HUB_PASSWORD`

**Files Created/Modified:**
- `.github/workflows/docker-release-base-rocm-wsl2.yml`: Base image build workflow
- `.github/workflows/docker-release-llamacpp-wsl.yml`: llama.cpp image build workflow  
- `docker/llamacpp/Dockerfile-llamacpp-WSL2`: Updated base image reference
- `memory-bank/activeContext.md`: Documented CI/CD implementation

**Impact:** Automated Docker image deployment enables consistent releases of AMD ROCm WSL2 images to Docker Hub, making it easier for users to access pre-built images without manual builds. The workflows follow the same optimization patterns as harmony-speech-engine, ensuring reliable builds of large ROCm-based images on GitHub Actions runners.


### ✅ llama.cpp OpenAI Compatible Server Integration (Just Completed)
**Description**: Added comprehensive llama.cpp integration with OpenAI-compatible API server support across all major hardware platforms (CPU, NVIDIA, AMD, Intel GPUs).

**Key Changes:**
- **Complete Hardware Support**: Created Docker Compose templates for all variants:
  - CPU: `ghcr.io/ggml-org/llama.cpp:server`
  - NVIDIA: `ghcr.io/ggml-org/llama.cpp:server-cuda`
  - AMD: `ghcr.io/ggml-org/llama.cpp:server-vulkan`
  - Intel: `ghcr.io/ggml-org/llama.cpp:server-intel`
- **Directory Structure**: Created `llama.cpp/` with `.env` configuration, `models/` and `cache/` directories
- **Environment Configuration**: Comprehensive `.env` file with default settings (2 threads, 8192 context), GPU offload controls, and extensible extra arguments
- **Template Architecture**: All templates include model validation, proper port binding, volume mounts, and Harmony Link network integration
- **Integration Manifest**: Updated `integrations.json` with llama.cpp entry supporting backend, countenance, movement, and RAG modules
- **Model Management**: Placeholder file in models directory with clear instructions for GGUF file placement

**Files Modified:**
- `integrations.json`: Added llama.cpp integration metadata
- `llama.cpp/.env`: Environment configuration template
- `llama.cpp/models/place-your-models-here.txt`: Model placement instructions
- `templates/llama.cpp/docker-compose.cpu.yml`: CPU template
- `templates/llama.cpp/docker-compose.nvidia.yml`: NVIDIA GPU template
- `templates/llama.cpp/docker-compose.amd.yml`: AMD GPU template
- `templates/llama.cpp/docker-compose.intel.yml`: Intel GPU template

**Impact:** Expanded ecosystem to 6 AI services with native GGUF model support, providing users with high-performance local LLM inference across all major hardware platforms while maintaining Harmony Link's unified management interface.

### ✅ Port Binding Optimizations & New Aphrodite Integration (Just Completed)
**Description**: Added Aphrodite-Engine integration and standardized IPv4-only binding control across all integrations, resolving dual-stack service discovery issues.

**Key Changes:**
- **Aphrodite Integration**: Added LLM inference engine with hobbyist focus, supporting quantization methods and optimizations
- **BIND_IP Implementation**: Added `BIND_IP=0.0.0.0` to all .env files for IPv4-only port binding
- **Template Updates**: Used `${BIND_IP:-0.0.0.0}:${HOST_PORT}` format in all docker-compose files, relative env_file references
- **Architecture Support**: Enabled AMD GPU template for Ollama, comprehensive driver configurations across integrations
- **Configuration Management**: Updated integrations.json with .env requirements, maintained template consistency

**Files Modified:** All integration .env files, docker-compose templates, integrations.json, and aphrodite-specific directories.

**Impact:** Eliminated IPv4/IPv6 dual-stack binding conflicts, expanded ecosystem to 5 AI services (LocalAI, Ollama, Textgen WebUI, Harmony Speech, Aphrodite), ensured cross-hardware compatibility.

### ✅ LocalAI and Ollama Integration Support (Previously Completed)
**Description**: Added comprehensive support for two major AI service frameworks, significantly expanding the ecosystem's capabilities and providing users with more deployment options.

**Key Changes:**
- **LocalAI Integration**:
  - Added full LocalAI support as a drop-in framework for local AI services
  - Supports LLMs, Neural Encoders, TTS & STT pipelines with OpenAI-compatible API
  - Created `localai/` directory structure with `.env` configuration and placeholder directories
  - Added Docker Compose templates for CPU and NVIDIA GPU configurations
  - Configured compatibility with backend, countenance, movement, RAG, TTS, and STT modules
  - Project website reference: https://localai.io/

- **Ollama Integration**:
  - Added full Ollama support as another drop-in framework for local AI services
  - Focuses on LLMs and Neural Encoders with OpenAI-compatible API
  - Created `ollama/` directory structure with separate subdirectories for ollama service and web UI
  - Added Docker Compose templates for CPU, NVIDIA GPU, and AMD GPU configurations
  - Configured compatibility with backend, countenance, movement, and RAG modules
  - Project website reference: https://ollama.com/

- **Integration Manifest Enhancement**:
  - Updated `integrations.json` to include both LocalAI and Ollama with complete metadata
  - Added `projectWebsite` field to all integrations for better documentation
  - Defined comprehensive `compatibleProviders` matrices for each service
  - Enhanced service descriptions and display names

- **Template Infrastructure**:
  - Created `templates/localai/` with `docker-compose.cpu.yml` and `docker-compose.nvidia.yml`
  - Created `templates/ollama/` with `docker-compose.cpu.yml`, `docker-compose.nvidia.yml`, and `docker-compose.amd.yml`
  - All templates follow the established pattern for Harmony Link orchestration
  - Proper network configuration for `harmony-link-network` integration

**Files Modified:**
- `integrations.json`: Added LocalAI and Ollama entries with full metadata
- `.gitignore`: Updated to handle new service directories
- `harmony-link/config.json`: Updated for new integration support
- Created `localai/.env`, `ollama/.env` with configuration templates
- Created comprehensive template directory structure for both services

**Impact**:
- **Expanded Ecosystem**: Users now have access to six major AI service integrations (Text-Generation WebUI, Harmony Speech Engine, LocalAI, Ollama, Aphrodite, llama.cpp)
- **Broader Hardware Support**: Ollama templates include AMD GPU support in addition to CPU and NVIDIA options
- **Enhanced Flexibility**: LocalAI provides comprehensive AI pipeline support including TTS/STT capabilities
- **Improved Documentation**: Project website references help users understand each integration's capabilities
- **Consistent Architecture**: All new integrations follow established patterns for seamless Harmony Link management

### ✅ Template Adaptation for Instance Handling (Previously Completed)
**Description**: Enhanced all Docker Compose templates to work seamlessly with Harmony Link's new instance-based management system, improving template compatibility and configuration management.

**Key Changes:**
- **Template Compatibility Enhancement**:
  - Adapted all existing templates (Text-Generation WebUI, Harmony Speech Engine) for new instance handling
  - Updated template path resolution and configuration management
  - Improved template metadata and structure consistency

- **Project Website Integration**:
  - Added `projectWebsite` field to all integrations in `integrations.json`
  - Provides users with direct links to project documentation and source repositories
  - Enhances discoverability and support for each integration

**Files Modified:**
- `integrations.json`: Added project website references to existing integrations
- `templates/harmony-speech-engine/`: Updated Docker Compose templates for instance compatibility
- `templates/text-generation-webui/`: Updated Docker Compose templates for instance compatibility

**Impact**: 
- **Improved Instance Management**: Templates work seamlessly with Harmony Link's instance-based deployment system
- **Better User Experience**: Project website links provide immediate access to documentation and support
- **Enhanced Maintainability**: Consistent template structure across all integrations

### ✅ Previous Integration Foundation (Previously Completed)
- **Structure Refinement**: Introduced `.automation/` and `templates/` directories for better organization of Docker Compose configurations.
- **Integrations Manifest (`integrations.json`)**: Created to enable Harmony Link to discover and manage services within this repository.
- **Docker Compose Centralization**: Simplified the root `docker-compose.yml` to primarily orchestrate Harmony Link itself, with other services now managed via Harmony Link's UI.
- **Harmony Link as Orchestrator**: Configured Harmony Link to act as a privileged Docker client, capable of managing other containers in this repository, even when Harmony Link itself is containerized.
- **Template Path Resolution**: Adjusted `env_file` and `volumes` paths in integration templates for correct resolution when deployed by Harmony Link.
- **Docker Compose Labels**: Added labels to integration services for accurate container discovery by Harmony Link.
- **Git Repository Management**: Updated `.gitignore` to prevent conflicts with nested Git repositories.

## Next Steps
- **Monitor Compatibility**: Continuously ensure compatibility with new Harmony Link features and updates across all five integrations.
- **Template Optimization**: Consider optimizing Docker Compose templates based on user feedback and performance metrics.
- **Documentation Enhancement**: Explore opportunities to improve setup documentation for the expanded integration ecosystem.
- **Hardware Support Expansion**: Investigate additional hardware acceleration options for the growing service ecosystem.

## Active Decisions and Considerations
- **Comprehensive Integration Ecosystem**: The project now supports six major AI service types, providing users with extensive deployment flexibility while maintaining consistent management through Harmony Link.
- **Hardware Compatibility Focus**: Ensuring broad hardware support (CPU, NVIDIA GPU, AMD GPU) across all integrations to maximize accessibility.
- **Template Consistency**: Maintaining consistent Docker Compose template patterns across all integrations for predictable behavior and easier maintenance.
- **Maintaining the Quickstart project as a user-friendly and reliable deployment solution for the expanded Harmony.AI ecosystem.
- **Ensuring that integration with Harmony Link remains seamless and robust across all supported services.

## Learnings and Project Insights
- **Ecosystem Expansion Benefits**: Adding LocalAI and Ollama significantly increases deployment options while maintaining the same management paradigm through Harmony Link.
- **Template Standardization Value**: Consistent template structure across integrations simplifies both development and user experience.
- **Hardware Diversity Importance**: Supporting multiple GPU vendors (NVIDIA, AMD) and CPU-only deployments ensures broad accessibility.
- **The shift to Harmony Link as the central orchestration hub has successfully scaled to support a larger ecosystem of AI services.
- **The modularization of Docker Compose configurations into `templates/` and `.automation/` continues to enhance maintainability and flexibility as the ecosystem grows.
- **Project website references in integration metadata significantly improve user experience by providing immediate access to relevant documentation.
