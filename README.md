# Project Harmony.AI - Quickstart
This repo contains configurations and templates for quickly setting up external Harmony AI modules for running locally, primarily orchestrated by Harmony Link.

It provides a simplistic approach using Docker Compose files and Docker images which are being provided via Docker Hub.
The default configuration consists of:
- [Harmony Link](https://github.com/harmony-ai-solutions/harmony-link), our agentic runtime.
- [Our Text-Generation Web-UI fork](https://github.com/harmony-ai-solutions/text-generation-webui-harmony-ai), 
a slightly modified version of [Oobabooga's great repository](https://github.com/oobabooga/text-generation-webui).
- [Harmony Speech Engine](https://github.com/harmony-ai-solutions/harmony-speech-engine), our custom inference engine
for AI voice generation, voice cloning and Speech transcription.

All Docker Images and revisions can be found at [Docker-Hub](https://hub.docker.com/u/harmonyai).

For supporting with setup, we created a tutorial video available on YouTube:

[![Add Human-like AI Characters to ANY Game - BETA Tech Demo #1 - Project Harmony AI](https://img.youtube.com/vi/1YX3H_WcYuY/0.jpg)](https://www.youtube.com/watch?v=1YX3H_WcYuY)

---
## Recommended System Requirements
#### CPU requirements:
- With GPU Support: CPU with 4 or more Cores of 3 Ghz or more (e.g. Intel i5, AMD Ryzen 5)
- Without GPU Support / CPU Only: CPU with 8 or more Cores of 4 Ghz or more (e.g. Intel i7, AMD Ryzen 7)

#### RAM requirements
- Harmony-Link: 200 MB RAM
- Harmony Speech Engine: 500 MB RAM + Model requirements (see table below)
- Text Generation Web UI: 500 MB RAM + Model requirements (check Huggingface model pages of the model you're using)

#### Storage Requirements:
- 20 GB of Disk space for Docker Images
- Additional Space as required by models.

(50 GB in total or more should be sufficient for most use cases)

## Getting Started

### 1. Download & Install Docker Desktop or Docker
```
https://www.docker.com/get-started/
```

### 2. Clone this repository using Git & enter the folder via shell
```
git clone https://github.com/harmony-ai-solutions/quickstart
cd quickstart
```

### 3. Initial Setup with Harmony Link
The `docker-compose.yml` file in this repository is now primarily used to launch Harmony Link and its UI. Harmony Link's UI will then allow you to discover, configure, and manage other AI services (like Text Generation WebUI and Harmony Speech Engine) directly.

To get started:

#### Launch Harmony Link and its UI
From the shell which is pointed at the repo's folder back in Step 2, launch Harmony Link:
```
docker compose up -d harmony-link harmony-link-ui
```
This will start Harmony Link and its UI in detached mode.
Alternatively, launch the standalone binary.

#### Configure Integrations via Harmony Link UI
1.  **Launch Harmony Link Application**: Launch the `harmony-link` and `harmony-link-ui` containers or the Harmony Link desktop application.
2.  **Navigate to "Integrations" Tab**: In the Harmony Link UI, go to the newly added "Integrations" tab.
3.  **Set Quickstart Repository Path**: You will be prompted to set the path to this quickstart repository (e.g., `D:/projects/quickstart` on Windows, or `/path/to/quickstart` on Linux/macOS). This path is crucial for Harmony Link to discover available integrations and their templates.
4.  **Discover and Manage Integrations**: Once the path is set, Harmony Link will discover the `integrations.json` file and list available AI services (e.g., Text Generation WebUI, Harmony Speech Engine).
5.  **Configure and Control**: For each integration, you can:
    *   **Configure**: Click the "Configure" button to open a YAML editor. Here, you can view the default Docker Compose template (e.g., `docker-compose.cpu.yml` or `docker-compose.nvidia.yml` from the `templates/` directory) or customize it. Your custom configurations will be saved in the `.automation/` directory within this quickstart repo.
    *   **Start/Stop/Restart**: Use the control buttons to manage the lifecycle of the individual AI service containers. Harmony Link will orchestrate these services using their respective Docker Compose files.
    *   **Shared Network**: All services managed by Harmony Link will join the `harmony-link-network` for seamless communication. This network will be automatically created if it doesn't exist.

#### Harmony Speech Engine & Text-Generation-Web-UI
These services are now managed through the Harmony Link UI. You can configure their specific settings (e.g., models, ports) by editing their Docker Compose files via the "Integrations" tab. The template files for these services are located in the `templates/` directory, and any custom configurations you save will be stored in the `.automation/` directory.

**Relevant config files (now templates):**
- `templates/harmony-speech-engine/docker-compose.cpu.yml`
- `templates/harmony-speech-engine/docker-compose.nvidia.yml`
- `templates/text-generation-webui-harmonyai/docker-compose.cpu.yml`
- `templates/text-generation-webui-harmonyai/docker-compose.nvidia.yml`

Relevant config files for Harmony Speech Engine:
```
harmony-speech-engine/config.yml
harmony-speech-engine/config.nvidia.yml 
```

The following table should help with evaluating the requirements:

| Model Toolchain   | Type | Embedding requires Whisper | CPU only Performance | Voice Quality | Storage & RAM / VRAM required |
|-------------------|------|----------------------------|----------------------|---------------|-------------------------------|
| Harmony Speech V1 | TTS  | No                         | Very Good            | Good          | ~1GB                          |
| OpenVoice V1      | TTS  | Yes                        | Good                 | Very Good     | ~512GB per language           |
| OpenVoice V2      | TTS  | Yes                        | Good                 | Very Good     | ~512GB per language           |
| Faster-Whisper    | STT  | N / A                      | Medium               | N / A         | ~1-6GB (depending on model)   |

For more details on configuring the models in detail, please check out the 
[Harmony Speech Engine Model Documentation](https://github.com/harmony-ai-solutions/harmony-speech-engine/blob/main/docs/models.md).

If you have questions, or run into issues, please feel free to reach out via Discord; Server link shared below.


---

## About Project Harmony.AI
![Project Harmony.AI](docs/images/Harmony-Main-Banner-200px.png)
### Our goal: Elevating Human <-to-> AI Interaction beyond known boundaries.
Project Harmony.AI emerged from the idea to allow for a seamless living together between AI-driven characters and humans.
Since it became obvious that a lot of technologies required for achieving this goal are not existing or still very experimental,
the long term vision of Project Harmony is to establish the full set of technologies which help minimizing biological and
technological barriers in Human <-to-> AI Interaction.

### Our principles: Fair use and accessibility
We want to counter today's tendencies of AI development centralization at the hands of big
corporations. We're pushing towards maximum transparency in our own development efforts, and aim for our software to be
accessible and usable in the most democratic ways possible.

Therefore, for all our current and future software offerings, we'll perform a constant and well-educated evaluation whether
we can safely open source them in parts or even completely, as long as this appears to be non-harmful towards achieving
the project's main goal.

### How to reach out to us

[Official Website of Project Harmony.AI](https://project-harmony.ai/)

#### If you want to collaborate or support this Project financially:

Feel free to join our Discord Server and / or subscribe to our Patreon - Even $1 helps us drive this project forward.

![Harmony.AI Discord Server](docs/images/discord32.png) [Harmony.AI Discord Server](https://discord.gg/f6RQyhNPX8)

![Harmony.AI Patreon](docs/images/patreon32.png) [Harmony.AI Patreon](https://patreon.com/harmony_ai)

#### If you want to use our software commercially or discuss a business or development partnership:

Contact us directly via: [contact@project-harmony.ai](mailto:contact@project-harmony.ai)
