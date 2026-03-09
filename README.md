# GitHub Actions Workflow Templates

This repository contains reusable GitHub Actions workflow templates for CI/CD pipelines.

## Project Structure

```
workflow-templates/          # Workflow template definitions
.github/workflows/           # Active workflow implementations
Makefile                     # Build and tagging automation
```

## Workflow Templates

- `js-ci-defaults` - Default CI configuration for JavaScript projects
- `js-react-to-s3-deploy` - Deploy React applications to AWS S3
- `js-update-browserlist` - Automatically update browserlist configurations
- `npm-monorepo-publishing` - Publishing workflows for npm monorepos
- `sonar-qube` - SonarQube code quality analysis integration

## Makefile Commands

### Format Files

```bash
make format
```

Formats all markdown (`.md`), YAML (`.yml`), and JSON (`.json`) files in the repository using Prettier.

### Create a Tag

```bash
make tag <workflow-name>/<version>
```

Creates a semantic version tag for a workflow and automatically updates the major version tag.

**Example:**

```bash
make tag common-ci-js/v1.0.7
```

This will:

1. Validate that `.github/workflows/common-ci-js.yml` exists
2. Create a tag `common-ci-js/v1.0.7`
3. Force update the major version tag `common-ci-js/v1` to point to the same commit

### Push Tags

```bash
make push-tags
```

Syncs all local tags with the remote repository.

**Behavior:**

- **New tags** (exist locally but not remotely) → pushed normally with `git push origin <tag>`
- **Outdated tags** (exist both locally and remotely but point to different commits) → force pushed with `git push -f origin <tag>`
- **Synchronized tags** (identical on local and remote) → skipped

This is useful when you've updated major version tags (like `common-ci-js/v1`) locally and need to push those changes along with any new patch version tags.

**Example:**

```bash
make tag common-ci-js/v1.0.7
make push-tags
```

This creates and pushes both `common-ci-js/v1.0.7` and updates `common-ci-js/v1` to the same commit.
