---
name: skill-name
description: >
  What this skill does and when Claude should use it. Be specific — include
  the kinds of requests, phrasing, and contexts that should trigger it. Err
  on the side of being explicit; Claude tends to undertrigger skills with
  vague descriptions. For example, instead of "Summarize documents", write
  "Summarize documents, reports, or meeting notes into key points and action
  items. Use this skill whenever the user asks to summarize, recap, or
  condense any kind of document, even if they don't say 'summarize'."

# --- Optional frontmatter fields ---
#
# argument-hint: "[input]"
#   Shown in autocomplete to indicate expected arguments.
#   Example: "[filename]" or "[issue-number] [format]"
#
# disable-model-invocation: true
#   Prevents Claude from triggering this skill automatically.
#   Use for action-oriented skills with side effects: deploy, commit,
#   send-message, post-to-slack, etc. You control when they run.
#
# allowed-tools: Read, Grep, Glob
#   Restricts which tools Claude can use without asking permission
#   when this skill is active. Omit to allow all tools.
#
# context: fork
#   Runs the skill in an isolated subagent. Use for tasks that should
#   not have access to your conversation history, or that you want to
#   run independently. Pair with `agent: Explore` for read-only research.
#
# user-invocable: false
#   Hides the skill from the / menu. Use for background knowledge that
#   Claude should apply automatically but that isn't a user-facing command.
---

# Skill Name

(Instructions for Claude go here.)

<!-- Tips:
  - Keep SKILL.md under 500 lines. Move large reference material to
    separate files (e.g. references/api.md) and link to them here.
  - Use imperative form: "Do X" not "You should do X".
  - Explain the *why* behind instructions — Claude responds better to
    reasoning than rigid rules.
  - If the skill takes arguments, reference them with $ARGUMENTS or $0, $1.
  - See docs/contributing.md for the full contribution workflow.
-->
