;;; STATE.scm — poly-observability-mcp
;; SPDX-License-Identifier: AGPL-3.0-or-later
;; SPDX-FileCopyrightText: 2025 Jonathan D.A. Jewell

(define metadata
  '((version . "1.0.0") (updated . "2025-12-17") (project . "poly-observability-mcp")))

(define current-position
  '((phase . "v0.2 - Security & Documentation")
    (overall-completion . 35)
    (components
      ((rsr-compliance ((status . "complete") (completion . 100)))
       (adapters ((status . "complete") (completion . 100)))
       (security ((status . "complete") (completion . 100)))
       (documentation ((status . "in-progress") (completion . 80)))
       (testing ((status . "pending") (completion . 0)))
       (deno-migration ((status . "in-progress") (completion . 90)))))))

(define blockers-and-issues
  '((critical ())
    (high-priority
      (("ReScript build still uses npx" . "deno.json tasks need native Deno build")))))

(define critical-next-actions
  '((immediate
      (("Add flake.nix for Nix fallback" . high)
       ("Migrate ReScript build to Deno" . high)))
    (this-week
      (("Add unit tests" . medium)
       ("Add integration tests" . medium)))
    (next-sprint
      (("OpenTelemetry adapter" . low)
       ("Alertmanager adapter" . low)))))

(define session-history
  '((snapshots
      ((date . "2025-12-15") (session . "initial") (notes . "SCM files added"))
      ((date . "2025-12-15") (session . "security-fixes")
       (notes . "OpenSSF Scorecard: SHA-pinned all actions, added SPDX headers, permissions, fixed CodeQL matrix, deleted empty security.yml"))
      ((date . "2025-12-17") (session . "scm-security-review")
       (notes . "Fixed SECURITY.md (was template), updated codemeta.json, fixed README npm->deno, created roadmap")))))

(define state-summary
  '((project . "poly-observability-mcp") (completion . 35) (blockers . 1) (updated . "2025-12-17")))
