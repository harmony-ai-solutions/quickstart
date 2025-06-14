# Project Harmony.AI Quickstart - Project Brief

## Project Overview
The Project Harmony.AI Quickstart repository provides configurations and templates for rapidly setting up and running external Harmony.AI modules locally using Docker. It now serves as the primary source for Harmony Link to discover, configure, and manage services like Harmony Speech Engine and a specialized Text-Generation WebUI, offering a simplified, containerized approach.

## Core Purpose
- To provide a streamlined setup for the Harmony.AI ecosystem, with Harmony Link as the central management UI.
- To simplify the deployment and configuration of interconnected AI services through a unified interface.
- To enable quick experimentation and development with Harmony.AI technologies by providing ready-to-use Docker Compose templates.

## High-Level Goals
1. **Ease of Use**: Minimize setup complexity for new users by centralizing management in Harmony Link.
2. **Comprehensive Environment**: Provide all essential Harmony.AI components as discoverable and manageable services.
3. **Resource Flexibility**: Offer Docker Compose templates for both CPU-only and GPU (NVIDIA) environments, configurable via Harmony Link.
4. **Consistent Experience**: Ensure reliable and reproducible deployments managed directly from the Harmony Link UI.
5. **Accelerated Development**: Provide a ready-to-use platform for building on Harmony.AI, with integrated control over external services.

## Key Innovation
The Quickstart project's innovation now extends to its role as a managed ecosystem. It abstracts away the complexities of individual service installations and inter-service communication by providing structured templates and a manifest (`integrations.json`) that Harmony Link uses to orchestrate and control the entire AI character interaction environment with minimal user effort.

## Target Users
- New users and developers evaluating Harmony.AI.
- Content creators and researchers needing a quick setup for AI characters.
- Developers building plugins or integrations with Harmony.AI.
- Anyone seeking a self-contained, locally managed AI character ecosystem.

## Core Requirements
- Docker Desktop or Docker installation.
- Sufficient system resources (CPU, RAM, Storage) as per component requirements.
- Harmony Link application (standalone or containerized) for managing the quickstart services.
