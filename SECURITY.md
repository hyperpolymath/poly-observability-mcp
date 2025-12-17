# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability in poly-observability-mcp, please report it responsibly:

### Contact

- **Email:** security@hyperpolymath.org
- **GPG Key:** https://hyperpolymath.org/gpg/security.asc
- **Preferred Languages:** English, Dutch

### What to Include

When reporting a vulnerability, please provide:

1. Description of the vulnerability
2. Steps to reproduce
3. Potential impact assessment
4. Any suggested fixes (optional)

### Response Timeline

- **Initial Response:** Within 48 hours
- **Status Update:** Within 7 days
- **Resolution Target:** Within 30 days for critical issues

### What to Expect

- We will acknowledge your report within 48 hours
- We will investigate and provide a status update within 7 days
- If accepted, we will work on a fix and coordinate disclosure
- If declined, we will explain our reasoning
- Credit will be given to reporters (unless anonymity is requested)

### Scope

This security policy covers:

- The poly-observability-mcp MCP server
- All adapter implementations (Prometheus, Grafana, Loki, Jaeger)
- Configuration and deployment files
- CI/CD workflows

### Out of Scope

- Security issues in upstream dependencies (report to respective projects)
- Security of the observability backends themselves (Prometheus, Grafana, Loki, Jaeger)
- Issues in third-party integrations

## Security Best Practices

When deploying poly-observability-mcp:

1. **Environment Variables:** Store API keys and credentials in environment variables, never in code
2. **Network Security:** Use TLS/HTTPS when connecting to observability backends in production
3. **Access Control:** Limit MCP server access to authorized clients only
4. **API Keys:** Use read-only API keys where possible (especially for Grafana)
5. **Container Security:** Run containers as non-root user (default in provided Containerfile)

## Security Features

- No hardcoded credentials
- Environment-based configuration
- Non-root container execution
- SHA-pinned GitHub Actions
- Automated security scanning (TruffleHog, CodeQL)
- RFC 9116 compliant security.txt
