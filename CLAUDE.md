# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal academic website built with Quarto, rendered as a static site and hosted on GitHub Pages. The site contains blog posts, academic publications, presentations, CV, and recipes.

## Key Commands

### Building and Deployment
- `quarto render .` - Renders the entire site to the `docs/` directory
- `./deploy.sh` - Full deployment script that renders the site, commits docs, and pushes to main
- `Rscript -e "quarto::quarto_render('.')"` - Alternative R-based render command

### Development
- `quarto preview` - Start local development server with live reload
- `quarto render post/path/to/post.qmd` - Render a specific post
- `quarto render recipe/path/to/recipe.qmd` - Render a specific recipe

## Project Structure

### Content Organization
- `post/` - Blog posts (academic, health-related topics)
- `recipe/` - Recipe collection
- `articles/` - PDF copies of academic publications
- `presentations/` - PDF copies of presentations
- `docs/` - Generated site output (published to GitHub Pages)

### Configuration Files
- `_quarto.yml` - Main Quarto configuration
- `post/_metadata.yml` - Post-specific metadata (freeze: true, title-block-banner: true)
- `recipe/_metadata.yml` - Recipe-specific metadata
- `publications.bib` - Bibliography file for academic publications
- `project.Rproj` - R project settings

### Key Features
- Computational freeze enabled for posts (`freeze: true`) to avoid re-executing R code
- Uses Flatly theme with custom title block styling
- Integrated with GoatCounter analytics
- GitHub and Twitter/X social links in navbar

## Content Creation Workflow

### Blog Posts - Language Pattern
The blog follows a specific bilingual pattern:
- **English-only posts**: If the core post is written in English, it remains English-only
- **Norwegian posts with translations**: If the core post is written in Norwegian, it should have:
  - Original Norwegian version with `categories: ["Norsk", ...]`
  - English translation version with `categories: ["English", ...]`
  - Translation pairs use same date but different slug language (e.g., `2024-09-27-forebygg-covid-19-forebygg-sykefravaer/` vs `2024-09-27-prevent-covid-19-prevent-sick-leave/`)
  - English translations include disclaimer: "This is a translation of the original Norwegian op-ed, and discrepancies may exist."
  - Both versions typically share the same images

### New Blog Posts
1. Create new directory in `post/` with date-slug format: `YYYY-MM-DD-slug-title/`
2. Create `.qmd` file with same name as directory
3. Include required frontmatter (title, date, categories with language)
4. Posts are frozen by default - R code execution is cached
5. For Norwegian posts, create English translation with parallel directory structure and translation disclaimer

### New Recipes
1. Create new directory in `recipe/` with recipe name
2. Create `.qmd` file with same name as directory
3. Include any accompanying images in the same directory

### Deployment Process
- Site renders to `docs/` directory
- GitHub Pages serves from `docs/` folder on main branch
- The `deploy.sh` script handles the full build and deployment pipeline

## Technical Notes

### R Environment
- Uses R with Quarto for rendering
- RStudio project configured with spaces (2), UTF-8 encoding
- Package build type configured

### Git Workflow
- Main branch serves as both development and production
- `docs/` folder is committed and serves as GitHub Pages source
- Deploy script automatically commits docs changes

### Performance Considerations
- Computational freeze prevents expensive re-computation of R code
- Static site generation for fast loading
- PDF assets stored directly in repository for reliable access