# Spacelift + Terraform + Cloudflare demo

A small, safe, real Terraform config that manages **one TXT record** on the
`brettfullmer.com` Cloudflare zone, deployed through a **Spacelift Stack** with
an **OPA policy** that blocks destructive DNS deletes.

It's built to be walked through live: everything here only ever touches
`spacelift-demo.brettfullmer.com`, so a plan / apply / destroy can never affect
real traffic to the domain.

## What's in here

| File            | Purpose                                                                 |
| --------------- | ----------------------------------------------------------------------- |
| `main.tf`       | The one TXT record. Never references your live A / CNAME / MX records.  |
| `providers.tf`  | Cloudflare provider + version pin. Reads the API token from a variable. |
| `variables.tf`  | `cloudflare_api_token` (secret), `cloudflare_zone_id`, `record_name`.   |
| `outputs.tf`    | Record hostname + value, so you can verify the apply.                   |
| `policy.rego`   | Spacelift *Plan* policy: denies any run that would delete a DNS record. |

Secrets never enter git: `.gitignore` excludes `*.tfvars`, and the token is
passed as a Spacelift secret environment variable at runtime.

---

## Step 1 — Push to GitHub

This repo is already the demo. Push the current branch and open a repo on
GitHub (any name, e.g. `spacelift-cloudflare-demo`).

```bash
git add .
git commit -m "Spacelift + Cloudflare Terraform demo"
git push -u origin HEAD
```

Once it's up, tell me and we'll create the Stack in the Spacelift dashboard
together.

## Step 2 — Grab your Cloudflare Zone ID and API token

**Zone ID** — Cloudflare dashboard → select `brettfullmer.com` → **Overview**
→ scroll the right sidebar to the **API** box → copy **Zone ID**.

**API token** — Cloudflare dashboard → **My Profile** → **API Tokens** →
**Create Token** → use the **Edit zone DNS** template →

- Permissions: `Zone` · `DNS` · `Edit`
- Zone Resources: `Include` · `Specific zone` · `brettfullmer.com`

Copy the token now — Cloudflare only shows it once.

> Scope it to DNS edit on this one zone only. Least privilege makes it a
> perfectly safe token to demo with.

## Step 3 — Create the Spacelift Stack

In the Spacelift dashboard: **Stacks → Create stack**.

1. **Name** it (e.g. `cloudflare-dns-demo`).
2. **Source code** — connect the GitHub repo from Step 1; branch `main`
   (or this feature branch). Leave the project root as `/`.
3. **Backend** — **Terraform**. Let Spacelift manage state.
4. **Behavior** — leave defaults for the demo. (You can tick
   *"Ask for confirmation"* before apply so you can narrate the plan.)
5. **Create & continue.**

## Step 4 — Set the stack variables

On the stack → **Environment** → add:

| Name                          | Type                | Value                 |
| ----------------------------- | ------------------- | --------------------- |
| `TF_VAR_cloudflare_api_token` | environment, secret | *(the token)*         |
| `TF_VAR_cloudflare_zone_id`   | environment, plain  | *(the Zone ID)*       |

Marking the token **secret** means it's write-only and never printed in logs.
`TF_VAR_` is Terraform's standard prefix — it feeds these straight into the
`cloudflare_api_token` and `cloudflare_zone_id` variables.

## Step 5 — Attach the policy

**Policies → Create policy** →

- **Type**: `Plan`
- Paste the contents of `policy.rego`.
- **Create**, then **Attach** it to the `cloudflare-dns-demo` stack.

Now every run's plan is evaluated: a plan that would delete a DNS record is
denied before it can apply.

## Step 6 — Trigger a run

On the stack → **Trigger**. Watch the **plan** appear (one record to add),
the **policy** evaluate (green — it's an add, not a delete), then **Confirm**
to apply.

## Step 7 — Verify with dig

```bash
dig +short TXT spacelift-demo.brettfullmer.com
# => "Managed by Spacelift + Terraform - demo record"
```

## Step 8 (optional) — Show the guardrail working

Comment out the `cloudflare_record` block in `main.tf`, push, and trigger a
run. The plan now wants to **delete** the record — and the policy **blocks
it**. That's the exact governance story Spacelift sells, demonstrated live.
Revert the change to allow the delete when you actually want to tear it down.

---

### Notes

- Provider pinned to `cloudflare/cloudflare ~> 4.0`.
- Requires Terraform `>= 1.0`.
- `record_name` defaults to `spacelift-demo`; override it per-stack if you want
  a different subdomain.
