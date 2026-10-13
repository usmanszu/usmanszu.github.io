#!/usr/bin/env bash
set -euo pipefail

# Run from a clean checkout of academic-pages-setup:
# bash scripts/install-academic-pages.sh
ROOT="$(git rev-parse --show-toplevel)"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

git clone --depth 1 https://github.com/academicpages/academicpages.github.io.git "$WORK/template"
# Keep this repository's existing GitHub workflows and Git history.
rsync -a --exclude='.git' --exclude='.github' --exclude='README.md' "$WORK/template/" "$ROOT/"

python3 - "$ROOT/_config.yml" <<'PY'
import sys
from pathlib import Path
p=Path(sys.argv[1]); t=p.read_text()
changes={
'title                    : "Your Name / Site Title"':'title                    : "Muhammad Usman"',
'name                     : &name "Your Name"':'name                     : &name "Muhammad Usman"',
'description              : &description "Your Name\'s academic portfolio"':'description              : &description "Academic profile of Muhammad Usman"',
'url                      : https://academicpages.github.io':'url                      : https://usmanszu.github.io',
'repository               : "academicpages/academicpages.github.io"':'repository               : "usmanszu/usmanszu.github.io"',
'  name             : "Your Sidebar Name"':'  name             : "Muhammad Usman"',
'  bio              : "Short biography for the left-hand sidebar"':'  bio              : "Ph.D. researcher in self-supervised 3D skeleton action recognition and geometric deep learning."',
'  location         : "Earth"':'  location         : "Shenzhen, China"',
'  employer         : "Red Brick University"':'  employer         : "Shenzhen University"',
'  email            : "none@example.org"':'  email            :',
'  googlescholar    : "https://scholar.google.com/citations?user=PS_CX0AAAAAJ"':'  googlescholar    :',
'  orcid            : "https://orcid.org/yourorcidurl"':'  orcid            :',
'  pubmed           : "https://www.ncbi.nlm.nih.gov/pubmed/?term=john+snow"':'  pubmed           :',
'  github           : "academicpages"':'  github           : "usmanszu"',
'  bluesky          : "bsky.app"':'  bluesky          :',
}
for old,new in changes.items():
    if old not in t:
        print("WARNING: expected template setting not found:",old)
    else: t=t.replace(old,new,1)
p.write_text(t)
PY

cat > "$ROOT/_pages/about.md" <<'EOF'
---
permalink: /
title: "About"
author_profile: true
redirect_from:
  - /about/
  - /about.html
---

# Muhammad Usman

I am a Ph.D. researcher in Information and Communication Engineering at Shenzhen University. My research focuses on self-supervised representation learning for 3D skeleton-based human action recognition.

## Research Interests

- Self-supervised and contrastive learning for 3D human motion
- Geometric algebra and geometry-aware graph neural networks
- Spatiotemporal Transformers and graph representation learning
- Knowledge distillation and efficient action recognition
- Human-motion understanding and multimodal learning

## Publications and CV

Publication details and a downloadable CV will be added after verification.

## Contact

GitHub: [usmanszu](https://github.com/usmanszu)
EOF

echo "Academic Pages files installed and personalized in $ROOT"
echo "Review git status and _config.yml before committing."
