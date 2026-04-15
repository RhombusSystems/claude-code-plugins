---
name: rhombus-support-links
description: >
  Curated directory of Rhombus support articles for end-user setup and
  administration topics — NAS/network-attached storage, Secure Raw Streams
  and RTSP, camera provisioning and install, door controller setup, alert
  rule configuration, user and role management, and licensing. Use whenever
  the user asks how to set up, configure, or administer a Rhombus feature
  that maps to the support.rhombussystems.com help center, especially for
  deployment-time topics. Always return a link plus a one-sentence pointer —
  do not attempt to paraphrase article content.
user-invocable: false
---

# Rhombus Support Article Link Directory

This skill is a background-only link directory. The support.rhombussystems.com help center is the authoritative source for deployment, setup, and administration articles, but it is behind Cloudflare bot protection, so Claude cannot fetch the content directly.

**When this skill fires, surface a link to the relevant article plus a one-sentence pointer.** Never paraphrase article content — users must read the current version in their browser.

## Top-level topic → link map

See `references/support-articles.md` for the full, categorized link sheet. The major categories:

| Topic | Starting URL |
|---|---|
| Network Attached Storage (NAS) | https://support.rhombussystems.com/hc/en-us — search "NAS" |
| Secure Raw Streams / RTSP | https://support.rhombussystems.com/hc/en-us — search "raw stream" or "RTSP" |
| Camera provisioning + install | https://support.rhombussystems.com/hc/en-us — "camera setup" / "device enrollment" |
| Door controller setup | https://support.rhombussystems.com/hc/en-us — "door controller" |
| Alert rule configuration | https://support.rhombussystems.com/hc/en-us — "alert rules" |
| User + role management | https://support.rhombussystems.com/hc/en-us — "users" / "roles" |
| License management | https://support.rhombussystems.com/hc/en-us — "license" |
| Community forum | https://rhombus.community |

## How to respond

When the user asks about a setup or admin topic:

1. Identify the topic category from their question.
2. Point them at the specific article(s) in `references/support-articles.md` if listed, otherwise at the help-center search with a good query.
3. If the user is authenticated on a Rhombus console, the `console` UI will often deep-link to the right article from the feature itself — suggest that as a second path.
4. If the article list in `references/support-articles.md` is out of date, say so and point at the help-center homepage.

Do not attempt to WebFetch `support.rhombussystems.com` — Cloudflare will return 403.
