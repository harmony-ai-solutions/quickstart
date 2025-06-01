# Project Harmony.AI Quickstart - Tech Context

## Technologies and Frameworks Used

### Core Technologies
- **Docker**: Containerization platform for all services.
- **Docker Compose**: Orchestration tool for defining and running multi-container Docker applications.

### Included Harmony.AI Components
- **Harmony Link**:
    - Docker Image: `harmonyai/harmony-link:latest`
    - Ports: `28080` (main), `28081` (management API)
    - Configuration: `harmony-link/config.json` mounted as a volume.
- **Text-Generation WebUI (Harmony AI fork)**:
    - Docker Images: `harmonyai/text-generation-webui-harmony-ai-cpu` (default), `harmonyai/text-generation-webui-harmony-ai-nvidia` (for GPU)
    - Ports: `7860` (UI), `5000` (API)
    - Configuration: `.env` file for ports, `CMD_FLAGS.txt` for startup flags, various volumes for models, characters, etc.
- **Harmony Speech Engine**:
    - Docker Images: `harmonyai/harmonyspeech-engine-cpu:latest` (default), `harmonyai/harmonyspeech-engine-nvidia:latest` (for GPU)
    - Ports: `12080` (API)
    - Configuration: `harmony-speech-engine/config.yml` or `config.nvidia.yml` mounted as a volume.
- **Harmony Speech UI**:
    - Docker Image: `harmonyai/harmonyspeech-ui:latest`
    - Ports: `8080` (UI)
    - Dependency: Depends on `harmonyspeech-engine`.

### Build and Deployment
- **Docker Hub**: All official Docker images are hosted on `hub.docker.com/u/harmonyai`.
- **Docker Compose Files**:
    - `docker-compose.yml`: Default for CPU-only deployments.
    - `docker-compose.nvidia.yml`: For NVIDIA GPU-accelerated deployments.
- **Volume Mounts**: Persistent storage for configurations, models, and cache data.

### Network Architecture
- **Internal Docker Network**: Services communicate using their service names (e.g., `harmonyspeech-engine`, `text-generation-webui-harmonyai`).
- **Port Mapping**: Specific ports are exposed to the host machine for external access (e.g., `28080`, `28081`, `7860`, `5000`, `12080`, `8080`).
- **Configuration Adjustment**: Harmony Link's internal configuration needs to be adjusted for Dockerized services (e.g., `http://localhost:12080` becomes `http://harmonyspeech-engine:12080`).

### Configuration Management
- **YAML**: Docker Compose files for service definition.
- **JSON**: Harmony Link configuration.
- **YAML**: Harmony Speech Engine configuration.
- **Text Files**: `CMD_FLAGS.txt` for Text-Generation WebUI.
- **Environment Variables**: `.env` files for dynamic configuration (e.g., `APP_RUNTIME_UID`, `HOST_PORT`).

### System Requirements
- **CPU**: 4+ cores (GPU support), 8+ cores (CPU-only).
- **RAM**: 200MB (Harmony Link), 500MB + model (Speech Engine), 500MB + model (Text-Generation WebUI).
- **Storage**: 20GB+ for Docker images and models.

### External Integrations (within the ecosystem)
- **Harmony Link to Text-Generation WebUI**: For AI text generation.
- **Harmony Link to Harmony Speech Engine**: For TTS and STT.
- **Harmony Speech UI to Harmony Speech Engine**: For managing speech models.

## Development Workflow
- **Clone Repository**: `git clone https://github.com/harmony-ai-solutions/quickstart`
- **Navigate**: `cd quickstart`
- **Launch**: `docker compose up` (CPU) or `docker compose -f docker-compose.nvidia.yml up` (NVIDIA)
- **Stop**: `docker compose down` or `docker compose -f docker-compose.nvidia.yml down`
- **Configuration**: Modify local config files before launching Docker Compose.
