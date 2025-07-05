# Project Harmony.AI Quickstart - Tech Context

## Technologies and Frameworks Used

### Core Technologies
- **Docker**: Containerization platform for all services.
- **Docker Compose**: Orchestration tool for defining and running multi-container Docker applications. Used by Harmony Link to manage external services.

### Included Harmony.AI Components
- **Harmony Link**:
    - Docker Image: `harmonyai/harmony-link:latest`
    - Ports: `28080` (main), `28081` (management API)
    - Configuration: `harmony-link/config.json` mounted as a volume.
    - **Role**: Acts as the primary orchestrator for other AI services in this repository via its new Integrations UI.
    - **Containerized Orchestration**: The `harmony-link` service in `docker-compose.yml` is configured with Docker socket mounting (`/var/run/docker.sock`) and the `HARMONY_LINK_CONTAINER_MODE` environment variable set to `true`, enabling it to manage other Docker containers even when Harmony Link itself is running inside a container.
- **Text-Generation WebUI (Harmony AI fork)**:
    - Docker Images: `harmonyai/text-generation-webui-harmony-ai-cpu` (default), `harmonyai/text-generation-webui-harmony-ai-nvidia` (for GPU)
    - Ports: `7860` (UI), `5000` (API)
    - Configuration: `.env` file for ports, `CMD_FLAGS.txt` for startup flags, various volumes for models, characters, etc.
    - **Management**: Primarily managed and launched via Harmony Link's Integrations UI.
- **Harmony Speech Engine**:
    - Docker Images: `harmonyai/harmonyspeech-engine-cpu:latest` (default), `harmonyai/harmonyspeech-engine-nvidia:latest` (for GPU)
    - Ports: `12080` (API)
    - Configuration: `harmony-speech-engine/config.yml` or `config.nvidia.yml` mounted as a volume.
    - **Management**: Primarily managed and launched via Harmony Link's Integrations UI.
- **Harmony Speech UI**:
    - Docker Image: `harmonyai/harmonyspeech-ui:latest`
    - Ports: `8080` (UI)
    - Dependency: Depends on `harmonyspeech-engine`.

### Build and Deployment
- **Docker Hub**: All official Docker images are hosted on `hub.docker.com/u/harmonyai`.
- **Docker Compose Files**:
    - `docker-compose.yml`: Used to launch `harmony-link` and `harmony-link-ui`, and configured to support Harmony Link's containerized orchestration capabilities.
    - `docker-compose.nvidia.yml`: No longer directly used for launching all services; individual service templates are now in `templates/`.
- **Volume Mounts**: Persistent storage for configurations, models, and cache data.

### Network Architecture
- **Internal Docker Network**: Services communicate using their service names (e.g., `harmonyspeech-engine`, `text-generation-webui-harmonyai`).
- **Shared Network (`harmony-link-network`)**: A dedicated Docker bridge network that all Harmony Link components and integrated services join. This ensures seamless inter-service communication and proper container discovery.
- **Port Mapping**: Specific ports are exposed to the host machine for external access (e.g., `28080`, `28081`, `7860`, `5000`, `12080`, `8080`).
- **Configuration Adjustment**: Harmony Link's internal configuration needs to be adjusted for Dockerized services (e.g., `http://localhost:12080` becomes `http://harmonyspeech-engine:12080`).

### Configuration Management
- **YAML**: Docker Compose files for service definition.
- **JSON**: Harmony Link configuration.
- **YAML**: Harmony Speech Engine configuration.
- **Text Files**: `CMD_FLAGS.txt` for Text-Generation WebUI.
- **Environment Variables**: `.env` files for dynamic configuration (e.g., `APP_RUNTIME_UID`, `HOST_PORT`).
- **New**: `.automation/` directory for Harmony Link to store user-customized Docker Compose configurations.
- **New**: `templates/` directory containing default Docker Compose YAML templates for integrations.
- **New**: `integrations.json` manifest file for integration discovery by Harmony Link.
- **New**: Direct editing and Git-based reversion of integration-specific config files (e.g., `CMD_FLAGS.txt`, `config.yml`) via Harmony Link UI.
- **Git Ignore for Nested Repos**: The `.gitignore` file is configured to ignore nested `.git` repositories that may be downloaded as part of AI models, preventing Git conflicts.

### System Requirements
- **CPU**: 4+ cores (GPU support), 8+ cores (CPU-only).
- **RAM**: 200MB (Harmony Link), 500MB + model (Speech Engine), 500MB + model (Text-Generation WebUI).
- **Storage**: 20GB+ for Docker images and models.

### External Integrations (within the ecosystem)
- **Harmony Link to Text-Generation WebUI**: For AI text generation.
- **Harmony Link to Harmony Speech Engine**: For TTS and STT.
- **Harmony Speech UI to Harmony Speech Engine**: For managing speech models.

### Integration Management by Harmony Link (New Workflow)
- **Quickstart Repository Path**: Harmony Link's UI now requires the path to this quickstart repository to discover and manage integrations.
- **UI-driven Configuration (Docker Compose)**: Users can configure Docker Compose files for individual services (e.g., Text-Generation WebUI, Harmony Speech Engine) directly through the Harmony Link UI. These configurations are saved in the `.automation/` directory.
- **UI-driven Configuration (Additional Files)**: Users can now directly edit integration-specific configuration files (e.g., `CMD_FLAGS.txt`, `config.yml`) through the Harmony Link UI, with support for device-specific files and a "Revert to Default" option using Git.
- **UI-driven Control**: Start, stop, and restart external AI service containers directly from the Harmony Link UI.
- **Centralized Orchestration**: Harmony Link acts as a privileged Docker client, capable of executing `docker compose` commands for the services defined in this repository, even when Harmony Link itself is containerized.
- **Corrected Template Paths**: `env_file` and `volumes` paths in integration templates (e.g., `text-generation-webui`, `harmony-speech-engine`) have been adjusted from `../` to `../../` to correctly resolve when deployed via Harmony Link's `.automation` directory.
- **Docker Compose Labels**: All integration services in the templates now include `com.docker.compose.project` and `com.docker.compose.service` labels for accurate container discovery and grouping by Harmony Link.

## Development Workflow
- **Clone Repository**: `git clone https://github.com/harmony-ai-solutions/quickstart`
- **Navigate**: `cd quickstart`
- **Launch Harmony Link**: `docker compose up -d harmony-link harmony-link-ui` (or run standalone Harmony Link binary).
- **Manage Integrations via Harmony Link UI**: Use the new "Integrations" tab in the Harmony Link UI to set the quickstart repo path, discover services, configure their Docker Compose files, and control their lifecycle (start/stop/restart). You can also now edit additional config files directly from the UI.
- **Stop Harmony Link**: `docker compose down harmony-link harmony-link-ui`
- **Configuration**: Modify configurations via the Harmony Link UI, which will update files in the `.automation/` directory or directly in the integration's directory.
