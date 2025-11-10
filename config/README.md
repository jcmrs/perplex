# Configuration Directory

**Purpose:** Central location for all project configuration and settings.

## Principles

- **Configurability Cornerstone:** All behavioral settings live here
- **Version Controlled:** All configs tracked in git
- **Self-Documenting:** Each config file includes inline documentation
- **Environment Aware:** Separate configs for different contexts

## Structure

- `project.yml` - Core project metadata and settings
- `development.yml` - Development environment configuration
- `ai-agent.yml` - AI agent operational parameters
- `*.example.yml` - Template configurations for new setups

## For AI Agents

Read configs at session start to understand operational parameters and project state.

## For Humans

Modify these files to change project behavior without touching code.
