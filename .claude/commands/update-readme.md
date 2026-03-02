Update the project README.md to reflect the current state of the codebase.

## Instructions

1. **Explore the codebase** to detect changes since the last README update:
   - Read `pubspec.yaml` for package/version changes
   - Scan `lib/features/` for new, removed, or renamed features
   - Scan `lib/core/` for new core modules
   - Check `lib/l10n/` for added/removed locales

2. **Compare** findings against the current `README.md` content.

3. **If nothing meaningful changed**, tell me and stop — do NOT rewrite the file for no reason.

4. **If updates are needed**, edit `README.md` with surgical edits (use Edit, not Write) to keep the same concise structure:
   - One-liner description
   - Features (bullet list)
   - Tech Stack (table)
   - Architecture (3-layer diagram)
   - Project Structure (simplified tree)
   - Getting Started (3 commands)

5. **Rules**:
   - Keep it short — no badges, screenshots, licence, or contributing section
   - Only add a feature when it has real implementation (not just a placeholder page)
   - Match the existing tone and formatting exactly
   - Do not add sections that don't already exist
