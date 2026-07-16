package spacelift

# Spacelift "Plan" policy.
#
# Blocks any run whose plan would DELETE a DNS record. Deleting (or
# force-replacing) production DNS is the classic governance failure that
# guardrails exist to prevent — a bad plan can take a domain offline in
# seconds. Creating new records and updating existing ones in place are
# both allowed; only deletes are stopped.
#
# Attach this as a "Plan" policy in Spacelift and point it at the stack.
# It reads the plan JSON that Spacelift exposes at
# input.terraform.resource_changes.

import future.keywords.in

deny[msg] {
    some change in input.terraform.resource_changes
    change.type == "cloudflare_record"
    "delete" in change.change.actions
    msg := sprintf(
        "Blocked: this run would DELETE DNS record '%s'. DNS deletions require manual review.",
        [change.address],
    )
}
