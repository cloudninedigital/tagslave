# gtm-pixel-slave

This repository serves as a knowledge base for Claude to set up and manage tags in (server-side) GTM containers.

## Structure

| Folder | Purpose |
|---|---|
| `conventions/` | Naming rules, folder structure, versioning guidelines |
| `data-layer/` | Master datalayer schema and event definitions |
| `platforms/` | Platform-specific tag configs (Meta, GA4, TikTok, etc.) |
| `server-side/` | sGTM container setup and reusable tag templates |
| `auditing/` | Audit checklists and known issues |
| `snippets/` | Reusable JS variables, HTML tags, consent logic |

## How Claude should use these files

1. Start with `conventions/` to understand naming and structure rules
2. Check `data-layer/` to understand available variables before creating tags
3. Use `platforms/` for platform-specific configuration details
4. Reference `server-side/` for sGTM-specific setup
5. Use `snippets/` for reusable code patterns
