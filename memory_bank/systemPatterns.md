# Project Harmony.AI Quickstart - System Patterns

## System Architecture

### Core Architecture Pattern: Containerized Microservices Orchestration
- **Central Orchestration**: Docker Compose for defining and managing multi-container applications.
- **Independent Services**: Each Harmony.AI component runs as a separate Docker container.
- **Internal Networking**: Services communicate securely and efficiently within a private Docker network.
- **External Exposure**: Selected ports are mapped to the host for user interaction and external integrations.

### Key Components and Their Patterns

#### 1. Docker Compose (`docker-compose.yml`, `docker-compose.nvidia.yml`)
- **Pattern**: Orchestration as Code, Configuration as Code
- **Purpose**: Defines the multi-service application, including images, ports, volumes, and dependencies.
- **Design**: Declarative YAML files for reproducible deployments.

#### 2. Harmony Link Service
- **Pattern**: Agentic Runtime, Central Orchestrator
- **Purpose**: Manages AI character interactions, integrates with various AI backends and game engine plugins.
- **Integration**: Communicates with Text-Generation WebUI and Harmony Speech Engine.

#### 3. Text-Generation WebUI Service
- **Pattern**: AI Inference Server, Web Interface
- **Purpose**: Provides a web-based interface for large language models and exposes an API for text generation.
- **Integration**: Consumed by Harmony Link for AI text outputs.

#### 4. Harmony Speech Engine Service
- **Pattern**: AI Inference Server, Speech Processing
- **Purpose**: Handles Text-to-Speech (TTS), Speech-to-Text (STT), and voice cloning.
- **Integration**: Consumed by Harmony Link for voice generation and transcription.

#### 5. Harmony Speech UI Service
- **Pattern**: Web Interface, Management UI
- **Purpose**: Provides a user interface for managing and configuring the Harmony Speech Engine.
- **Integration**: Communicates with the Harmony Speech Engine.

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

### 3. Separate CPU and GPU Compose Files
**Rationale**:
- **Hardware Optimization**: Allows users to select the appropriate setup for their system.
- **Resource Management**: Prevents unnecessary GPU resource allocation on CPU-only machines.
- **Clarity**: Clear distinction between deployment profiles.

### 4. Volume-Based Configuration and Data Persistence
**Rationale**:
- **Data Persistence**: Ensures models, caches, and configurations are not lost when containers are rebuilt or removed.
- **User Customization**: Allows users to easily modify configurations and add models without rebuilding Docker images.
- **Separation of Concerns**: Keeps application logic separate from user data.

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

### 4. Gateway Pattern (Implicit)
- Host machine ports act as gateways to internal Docker services.
- Provides controlled access to the services from outside the Docker network.

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

### Service Dependencies
- `harmonyspeech-ui` depends on `harmonyspeech-engine`.
- Harmony Link implicitly depends on `text-generation-webui-harmonyai` and `harmonyspeech-engine` for its core functionality, configured via its `config.json`.

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
