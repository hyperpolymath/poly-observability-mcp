;;; ==================================================
;;; STATE.scm — AI Conversation Checkpoint File
;;; ==================================================
;;;
;;; SPDX-License-Identifier: MIT
;;; Copyright (c) 2025 Jonathan D.A. Jewell
;;;
;;; STATEFUL CONTEXT TRACKING ENGINE
;;; Version: 2.0
;;;
;;; Project: RSR-template-repo
;;;
;;; CRITICAL: Download this file at end of each session!
;;; At start of next conversation, upload it.
;;;
;;; ==================================================

(define state
  '((metadata
      (format-version . "2.0")
      (schema-version . "2025-12-08")
      (created-at . "2025-12-08T00:00:00Z")
      (last-updated . "2025-12-08T00:00:00Z")
      (generator . "Claude/STATE-system"))

    ;;; ==================================================
    ;;; CURRENT POSITION
    ;;; ==================================================
    ;;;
    ;;; The repository is in an embryonic state - it exists as a
    ;;; GitHub template with standard community files but no
    ;;; functional code or defined purpose.
    ;;;
    ;;; Assets present:
    ;;; - README.md (title only: "rsr-template-repo")
    ;;; - LICENSE (MIT License)
    ;;; - CODE_OF_CONDUCT.md (Contributor Covenant v2.0)
    ;;; - SECURITY.md (placeholder template)
    ;;; - .github/workflows/codeql.yml (security scanning)
    ;;; - .github/workflows/jekyll.yml (GitHub Pages)
    ;;; - .github/ISSUE_TEMPLATE/ (bug, feature, custom)
    ;;; - .github/dependabot.yml (dependency updates)
    ;;;
    ;;; What is missing:
    ;;; - Project definition / purpose
    ;;; - Source code
    ;;; - Build configuration
    ;;; - Documentation
    ;;; - Tests
    ;;;

    (focus
      (current-project . "RSR-template-repo")
      (current-phase . "pre-inception")
      (deadline . #f)
      (blocking-projects . ()))

    (projects
      ((name . "RSR-template-repo")
       (status . "blocked")
       (completion . 5)
       (category . "unknown")
       (phase . "pre-inception")
       (dependencies . ())
       (blockers . ("Project purpose undefined"
                    "RSR acronym meaning unknown"
                    "No technical requirements specified"
                    "Target language/framework not selected"
                    "No user stories or use cases"))
       (next . ("Define project scope"
                "Clarify RSR acronym meaning"
                "Select technology stack"
                "Create architecture document"
                "Implement core functionality"))
       (chat-reference . #f)
       (notes . "Template repo with GitHub infrastructure but no code")))

    ;;; ==================================================
    ;;; ROUTE TO MVP v1
    ;;; ==================================================
    ;;;
    ;;; BLOCKED: Cannot define MVP without knowing project purpose.
    ;;;
    ;;; Once project scope is defined, typical MVP route would be:
    ;;;
    ;;; Phase 1: Foundation (completion 0-20%)
    ;;;   - Define project scope and requirements
    ;;;   - Select technology stack
    ;;;   - Set up development environment
    ;;;   - Create project structure
    ;;;
    ;;; Phase 2: Core Implementation (completion 20-60%)
    ;;;   - Implement core data models
    ;;;   - Build primary functionality
    ;;;   - Create basic API/interface
    ;;;
    ;;; Phase 3: Integration (completion 60-80%)
    ;;;   - Connect components
    ;;;   - Add error handling
    ;;;   - Implement basic tests
    ;;;
    ;;; Phase 4: MVP Polish (completion 80-100%)
    ;;;   - Documentation
    ;;;   - CI/CD pipeline
    ;;;   - Basic user documentation
    ;;;   - Release preparation
    ;;;

    (mvp-route
      ((phase . "foundation")
       (target-completion . 20)
       (tasks . ("Define project scope"
                 "Document RSR meaning and purpose"
                 "Select programming language"
                 "Set up build system"
                 "Create project structure")))
      ((phase . "core-implementation")
       (target-completion . 60)
       (tasks . ("BLOCKED - requires phase 1 completion")))
      ((phase . "integration")
       (target-completion . 80)
       (tasks . ("BLOCKED - requires phase 2 completion")))
      ((phase . "mvp-polish")
       (target-completion . 100)
       (tasks . ("BLOCKED - requires phase 3 completion"))))

    ;;; ==================================================
    ;;; ISSUES / BLOCKERS
    ;;; ==================================================

    (issues
      ((id . "ISS-001")
       (severity . "critical")
       (title . "Project purpose undefined")
       (description . "Cannot proceed with development without knowing what RSR-template-repo is meant to accomplish")
       (status . "open"))

      ((id . "ISS-002")
       (severity . "critical")
       (title . "RSR acronym undefined")
       (description . "The meaning of 'RSR' is not documented anywhere in the repository")
       (status . "open"))

      ((id . "ISS-003")
       (severity . "high")
       (title . "No technical specifications")
       (description . "No requirements, architecture documents, or technical specifications exist")
       (status . "open"))

      ((id . "ISS-004")
       (severity . "medium")
       (title . "SECURITY.md is placeholder")
       (description . "Security policy contains template text with version numbers (5.1.x, 4.0.x) that don't correspond to any actual releases")
       (status . "open"))

      ((id . "ISS-005")
       (severity . "low")
       (title . "README.md is minimal")
       (description . "README contains only the repository name, no description or documentation")
       (status . "open")))

    ;;; ==================================================
    ;;; QUESTIONS FOR USER
    ;;; ==================================================

    (questions
      ((id . "Q-001")
       (priority . "critical")
       (question . "What does 'RSR' stand for?")
       (context . "The acronym appears in the repository name but is not defined anywhere"))

      ((id . "Q-002")
       (priority . "critical")
       (question . "What is the intended purpose of this project?")
       (context . "Is this a library, application, framework, tool, or something else?"))

      ((id . "Q-003")
       (priority . "critical")
       (question . "What problem does this project solve?")
       (context . "Understanding the problem space is essential for defining MVP scope"))

      ((id . "Q-004")
       (priority . "high")
       (question . "What programming language(s) should be used?")
       (context . "No source files exist yet; technology stack needs to be decided"))

      ((id . "Q-005")
       (priority . "high")
       (question . "Who is the target audience/user?")
       (context . "Developers? End users? Enterprise? Open source community?"))

      ((id . "Q-006")
       (priority . "high")
       (question . "What are the core features for MVP v1?")
       (context . "Need to define minimum viable scope to create roadmap"))

      ((id . "Q-007")
       (priority . "medium")
       (question . "Are there any existing similar projects to reference?")
       (context . "Understanding prior art helps avoid reinventing wheels"))

      ((id . "Q-008")
       (priority . "medium")
       (question . "What deployment model is intended?")
       (context . "CLI tool? Web service? Library? Desktop app? All of the above?"))

      ((id . "Q-009")
       (priority . "low")
       (question . "Should the Jekyll/GitHub Pages workflow be kept?")
       (context . "Currently configured but may not be needed depending on project type")))

    ;;; ==================================================
    ;;; LONG TERM ROADMAP
    ;;; ==================================================
    ;;;
    ;;; SPECULATIVE - Requires project definition to finalize
    ;;;
    ;;; The roadmap below is a generic template that should be
    ;;; customized once the project scope is clarified.
    ;;;

    (roadmap
      ((milestone . "v0.1.0-alpha")
       (phase . "Foundation")
       (status . "blocked")
       (goals . ("Project definition complete"
                 "Technology stack selected"
                 "Basic project structure"
                 "Development environment documented"
                 "Initial CI/CD pipeline")))

      ((milestone . "v0.5.0-beta")
       (phase . "Core MVP")
       (status . "future")
       (goals . ("Core functionality implemented"
                 "Basic documentation"
                 "Unit test coverage"
                 "Integration tests")))

      ((milestone . "v1.0.0")
       (phase . "MVP Release")
       (status . "future")
       (goals . ("Feature-complete MVP"
                 "Comprehensive documentation"
                 "Performance optimization"
                 "Security audit"
                 "Public release")))

      ((milestone . "v1.x")
       (phase . "Post-MVP Iteration")
       (status . "future")
       (goals . ("User feedback integration"
                 "Bug fixes"
                 "Performance improvements"
                 "Community building")))

      ((milestone . "v2.0.0")
       (phase . "Major Evolution")
       (status . "future")
       (goals . ("Major feature expansion"
                 "Architecture improvements"
                 "Broader platform support"
                 "Ecosystem development"))))

    ;;; ==================================================
    ;;; CRITICAL NEXT ACTIONS
    ;;; ==================================================

    (critical-next
      ("ANSWER: What does RSR stand for and what is this project?"
       "DEFINE: Project scope, requirements, and MVP features"
       "SELECT: Programming language and technology stack"
       "CREATE: Architecture document and project structure"
       "IMPLEMENT: First functional prototype"))

    ;;; ==================================================
    ;;; SESSION TRACKING
    ;;; ==================================================

    (session
      (conversation-id . "claude/create-state-scm-015kzLztnGAyS4gwVaXG1R5F")
      (started-at . "2025-12-08T00:00:00Z")
      (messages-used . 1)
      (messages-remaining . 99)
      (token-limit-reached . #f))

    (history
      (snapshots
        ((timestamp . "2025-12-08T00:00:00Z")
         (event . "STATE.scm created")
         (projects
           ((name . "RSR-template-repo")
            (completion . 5)
            (status . "blocked"))))))

    (files-created-this-session
      ("STATE.scm"))

    (files-modified-this-session
      ())

    (context-notes . "Repository is a blank template. Critical blocker: project purpose and scope undefined. All development blocked until user provides project definition.")))

;;; ==================================================
;;; END STATE.scm
;;; ==================================================
