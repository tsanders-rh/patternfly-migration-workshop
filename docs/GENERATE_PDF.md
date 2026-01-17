# How to Generate PDF Quick Reference

Since the workshop materials are ready, here are multiple ways to generate the PDF:

## Method 1: Print from Browser (Easiest)

1. Open `docs/QUICK_REFERENCE.html` in your browser:
   ```bash
   open docs/QUICK_REFERENCE.html
   # or on Windows: start docs/QUICK_REFERENCE.html
   # or on Linux: xdg-open docs/QUICK_REFERENCE.html
   ```

2. Print to PDF (Cmd/Ctrl + P):
   - Destination: "Save as PDF"
   - Layout: Portrait
   - Margins: Default or Minimum
   - Save as: `QUICK_REFERENCE.pdf`

## Method 2: Use Pandoc with LaTeX (Best Quality)

If you have LaTeX installed:

```bash
pandoc docs/QUICK_REFERENCE_PRINT.md \
  -o docs/QUICK_REFERENCE.pdf \
  --pdf-engine=pdflatex \
  -V geometry:margin=0.75in \
  -V fontsize=10pt
```

Install LaTeX on macOS:
```bash
brew install --cask mactex-no-gui
```

## Method 3: GitHub Actions (Automated)

The repository can auto-generate PDFs on push. See `.github/workflows/` for setup.

## Method 4: Online Converter

1. Go to https://www.markdowntopdf.com/
2. Upload `docs/QUICK_REFERENCE_PRINT.md`
3. Download the PDF

## Recommended for Workshop

Use **Method 1** (browser print) - it works everywhere and produces clean PDFs suitable for printing.
