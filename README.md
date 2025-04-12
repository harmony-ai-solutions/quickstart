# Project Harmony.AI - Quickstart
This repo contains scripts and configurations for quickly setting up Harmony AI modules for running locally.

It provides as simplistic approach using docker compose files and docker images which are being provided via hub.
The default configuration consists of:
- [Harmony Link](https://github.com/harmony-ai-solutions/harmony-link), our agentic runtime.
- [Our Text-Generation Web-UI fork](https://github.com/harmony-ai-solutions/text-generation-webui-harmony-ai), 
a slightly modified version of [Oobabooga's great repository](https://github.com/oobabooga/text-generation-webui).
- [Harmony Speech Engine](https://github.com/harmony-ai-solutions/harmony-speech-engine), our custom inference engine
for AI voice generation, voice cloning and Speech transcription.

All docker Images and revision can be found at [Docker-Hub](https://hub.docker.com/u/harmonyai).

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

### 3. Check configuration
The default `docker-compose.yml` file will download and start all services we offer, using the CPU-only profile.
Check if you need all of them or just a specific one, and comment out the ones you don't need.

#### Harmony Speech Engine
While most speech engine provided models have reasonable performance on CPU, running them via GPU if possible
improves performance significantly. Please make sure your machine has enough RAM / VRAM availiable. Otherwise, make a
backup of the default files, and remove the models you don't want to use.

Relevant config files:
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

#### Harmony Link
Dockerized Harmony Link currently can't expose its configuration UI via Web URL. If you want to use the UI to modify your setup
in a more convenient way, you can always run the standalone version (availiable [via our website](https://project-harmony.ai/technology/)) and
copy the `config.json` file into the `harmony-link` folder. Make sure to change network routes for usage inside the docker image accordingly,
so they will work inside the container as well:
```
http://localhost:12080 => http://harmonyspeech-engine:12080
```

Relevant config files:
```
harmony-link/config.json 
```

#### Text-Generation-Web-UI
The API is found via `http://localhost:5000`. To Access the API from inside the harmony-link docker container, use this
URL instead: `http://text-generation-webui-harmonyai:5000`

Make sure to access `http://localhost:7860` after launch and configure the model to be used. 
Alternatively, you can also download a model into the models folder below text-generation-webui-harmonyai, and comment
out the flag `--model` in the file `CMD_FLAGS.txt` to load the model on startup. Make sure to download a model which
is compatible with your system, e.g. GGUF model for CPU vs. GPTQ / EXL2 model for GPU, and that you have sufficient
RAM / VRAM to load the model and inference cache.

### 4. Launch the services using docker compose
From the shell which is pointed at the repo's folder back in Step 2, start and stop the services via docker compose.
Make sure Docker Desktop or your docker service is running. 

For CPU-Only:
```
docker compose up
docker compose down
```
For Nvidia:
```
docker compose -f docker-compose.nvidia.yml up
docker compose -f docker-compose.nvidia.yml down
```

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

![Harmony.AI Discord Server](docs/images/patreon32.png) [Harmony.AI Patreon](https://patreon.com/harmony_ai)

#### If you want to use our software commercially or discuss a business or development partnership:

Contact us directly via: [contact@project-harmony.ai](mailto:contact@project-harmony.ai)