# Project Harmony.AI Quickstart - System Patterns

## System Architecture

### Core Architecture Pattern: Containerized Microservices Orchestration
- **Central Orchestration**: Docker Compose for defining and managing multi-container applications.
- **Independent Services**: Each Harmony.AI component runs as a separate Docker container.
- **Internal Networking**: Services communicate securely and efficiently within a private Docker network.
- **External Exposure**: Selected ports are mapped to the host for user interaction and external integrations.
- **Harmony Link as Primary Orchestrator (New)**: Harmony Link now takes on the role of orchestrating other AI services within this repository, providing a unified UI for their management.

### Key Components and Their Patterns

#### 1. Docker Compose (`docker-compose.yml`, `docker-compose.nvidia.yml`)
- **Pattern**: Orchestration as Code, Configuration as Code
- **Purpose**: Defines the multi-service application, including images, ports, volumes, and dependencies.
- **Design**: Declarative YAML files for reproducible deployments.
- **New Role**: The root `docker-compose.yml` is now used to launch `harmony-link` and `harmony-link-ui`. Individual service `docker-compose.yml` files are now templates located in `templates/` and managed by Harmony Link.

#### 2. Harmony Link Service
- **Pattern**: Agentic Runtime, Central Orchestrator
- **Purpose**: Manages AI character interactions, integrates with various AI backends and game engine plugins.
- **Integration**: Communicates with Text-Generation WebUI and Harmony Speech Engine.
- **New Capability**: Acts as a privileged Docker client to start, stop, and configure other services defined in this quickstart repository.

#### 3. Text-Generation WebUI Service
- **Pattern**: AI Inference Server, Web Interface
- **Purpose**: Provides a web-based interface for large language models and exposes an API for text generation.
- **Integration**: Consumed by Harmony Link for AI text outputs.
- **Management**: Now primarily managed and launched via Harmony Link's Integrations UI.

#### 4. Harmony Speech Engine Service
- **Pattern**: AI Inference Server, Speech Processing
- **Purpose**: Handles Text-to-Speech (TTS), Speech-to-Text (STT), and voice cloning.
- **Integration**: Consumed by Harmony Link for voice generation and transcription.
- **Management**: Now primarily managed and launched via Harmony Link's Integrations UI.

#### 5. Harmony Speech UI Service
- **Pattern**: Web Interface, Management UI
- **Purpose**: Provides a user interface for managing and configuring the Harmony Speech Engine.
- **Integration**: Communicates with the Harmony Speech Engine.

#### 6. Integration Templates (`templates/` directory) (New)
- **Pattern**: Reusable Configuration Templates
- **Purpose**: Provide default Docker Compose configurations for external AI services, categorized by device type (e.g., CPU, NVIDIA).
- **Design**: Standardized YAML files that can be loaded and customized by Harmony Link.
- **Enhancement**: `env_file` and `volumes` paths within these templates have been adjusted (e.g., `../../`) to correctly resolve relative to the `.automation` directory when deployed by Harmony Link.

#### 7. Automation Configurations (`.automation/` directory) (New)
- **Pattern**: User-Managed Persistent Configuration
- **Purpose**: Store user-modified Docker Compose configurations for integrations, allowing persistence across sessions.
- **Design**: Files are created and updated by Harmony Link's UI based on user input.

#### 8. Integrations Manifest (`integrations.json`) (New)
- **Pattern**: Service Discovery Manifest
- **Purpose**: Lists all discoverable external AI services within the quickstart repository, providing metadata for Harmony Link's UI.
- **Design**: A simple JSON file that Harmony Link reads to populate its Integrations tab.

## Key Technical Decisions

### 1. Docker-First Deployment
**Rationale**:
- **Portability**: Ensures consistent environments across different operating systems.
- **Isolation**: Prevents dependency conflicts and simplifies management.
- **Scalability**: Foundation for scaling individual services.
- **Ease of Distribution**: Pre-built images simplify user setup.

### 2. Docker Compose for Orchestration
**Rationale**:
- **Simplicity**: Easy to define and run multi-container applications with a single command.
- **Declarative**: YAML files provide a clear, version-controlled definition of the stack.
- **Local Development**: Ideal for setting up a complete local development and testing environment.
- **New Role**: Now also serves as the underlying technology for Harmony Link's integration management.

### 3. Separate CPU and GPU Compose Files
**Rationale**:
- **Hardware Optimization**: Allows users to select the appropriate setup for their system.
- **Resource Management**: Prevents unnecessary GPU resource allocation on CPU-only machines.
- **Clarity**: Clear distinction between deployment profiles.
- **New Role**: These are now primarily templates used by Harmony Link's UI.

### 4. Volume-Based Configuration and Data Persistence
**Rationale**:
- **Data Persistence**: Ensures models, caches, and configurations are not lost when containers are rebuilt or removed.
- **User Customization**: Allows users to easily modify configurations and add models without rebuilding Docker images.
- **Separation of Concerns**: Keeps application logic separate from user data.

### 5. Harmony Link as Central Orchestration Hub (New)
**Rationale**:
- **Unified User Experience**: Provides a single UI for managing both Harmony Link's internal settings and external AI services.
- **Simplified Deployment**: Automates the process of launching and configuring external services, reducing manual CLI interaction.
- **Privileged Control**: Harmony Link's ability to access the Docker daemon allows it to manage the lifecycle of other containers directly.

## Design Patterns in Use (at the orchestration level)

### 1. Microservices Architecture
- Each component (Harmony Link, Speech Engine, WebUI) is an independent, deployable service.
- Promotes modularity, scalability, and technology diversity.

### 2. Configuration as Code
- Docker Compose YAML files define the entire application stack.
- Ensures reproducibility and version control of the deployment environment.

### 3. Service Discovery (Implicit)
- Docker's internal DNS allows services to communicate using their defined service names (e.g., `harmonyspeech-engine`).
- Simplifies inter-service communication without manual IP configuration.
- **Enhancement**: Docker Compose labels (`com.docker.compose.project`, `com.docker.compose.service`) are now explicitly used for more robust container discovery by Harmony Link.

### 4. Gateway Pattern (Implicit)
- Host machine ports act as gateways to internal Docker services.
- Provides controlled access to the services from outside the Docker network.

### 5. Template Method Pattern (New)
- **Purpose**: Define the skeleton of an operation (e.g., Docker Compose setup) in a base template, allowing specific steps (e.g., device-specific configurations) to be overridden by concrete templates.
- **Application**: `templates/` directory provides base Docker Compose files that can be customized.

### 6. Registry Pattern (New)
- **Purpose**: Centralized mechanism for discovering available integrations.
- **Application**: `integrations.json` acts as a registry for Harmony Link to discover services.

### 7. Shared Network Pattern (New)
- **Purpose**: Ensure all Harmony Link components and integrated services can communicate seamlessly.
- **Application**: A dedicated Docker bridge network named `harmony-link-network` is defined in the root `docker-compose.yml` and used by all integration templates. Harmony Link also ensures this network exists when starting integrations in standalone mode.

## Component Relationships (within Docker Compose)

### Data Flow Architecture
```mermaid
graph TD
    User -->|Access UI| HarmonyLinkUI[Harmony Link UI (Host:28080)]
    User -->|Access UI| TextGenWebUI[Text-Generation WebUI (Host:7860)]
    User -->|Access UI| SpeechUI[Harmony Speech UI (Host:8080)]

    HarmonyLinkUI -->|API Calls| HarmonyLink[Harmony Link Container]
    TextGenWebUI -->|API Calls| TextGenWebUIAPI[Text-Generation WebUI API (Container:5000)]
    SpeechUI -->|API Calls| SpeechEngine[Harmony Speech Engine Container]

    HarmonyLink -->|Text Generation Request| TextGenWebUIAPI
    HarmonyLink -->|Speech Request| SpeechEngine
    SpeechEngine -->|Speech Data| HarmonyLink
```

### Integration Orchestration Flow (New)
```mermaid
graph TD
    A[Harmony Link UI] --> B(Management API);
    B --> C[Integration Manager (in Harmony Link)];
    C --> D{Docker Daemon};
    D -- Start/Stop/Status --> E[External AI Service Container];
    C -- Read/Write --> F[Quickstart Repo (.automation/ & templates/)];
```

### Service Dependencies
- `harmonyspeech-ui` depends on `harmonyspeech-engine`.
- Harmony Link implicitly depends on `text-generation-webui` and `harmonyspeech-engine` for its core functionality, configured via its `config.json`.

## Error Handling Patterns (at the deployment level)

### 1. Container Restart Policies
- Docker Compose can be configured to automatically restart services on failure, enhancing resilience.

### 2. Health Checks (Implicit)
- While not explicitly defined in the provided `docker-compose.yml`, Docker Compose supports health checks to ensure services are truly ready before dependent services start.

### 3. Logging Aggregation (Manual)
- Logs from individual containers can be viewed using `docker compose logs`, allowing for centralized debugging.

## Performance Patterns (at the deployment level)

### 1. Resource Allocation
- Docker Compose allows defining CPU and memory limits for containers to manage resource consumption.

### 2. GPU Passthrough
- `docker-compose.nvidia.yml` demonstrates how to pass through NVIDIA GPUs to containers for accelerated inference.

### 3. Image Caching
- Docker caches downloaded images, speeding up subsequent deployments.
