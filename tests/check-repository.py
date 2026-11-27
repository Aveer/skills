"""Validate catalog, deployment policy, skill metadata and license/provenance coverage."""
from pathlib import Path
import json
import re
import sys

try:
    import yaml
except ImportError:
    sys.exit("Install PyYAML to validate skill frontmatter: python -m pip install PyYAML")

ROOT = Path(__file__).resolve().parents[1]
NAME = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
errors = []


def check(condition, message):
    if not condition:
        errors.append(message)


def names(value, label):
    if not isinstance(value, list) or not all(isinstance(x, str) and NAME.fullmatch(x) for x in value):
        errors.append(f"{label}: expected a list of valid skill names")
        return set()
    check(len(value) == len(set(value)), f"{label}: duplicate names")
    return set(value)


def validate_skill(directory):
    path = directory / "SKILL.md"
    if not path.is_file():
        errors.append(f"{directory.name}: missing SKILL.md")
        return
    content = path.read_text(encoding="utf-8-sig")
    match = re.match(r"\A---\s*\n(.*?)\n---\s*(?:\n|$)", content, flags=re.S)
    if not match:
        errors.append(f"{directory.name}: missing YAML frontmatter")
        return
    try:
        metadata = yaml.safe_load(match.group(1))
        check(isinstance(metadata, dict) and metadata.get("name") == directory.name,
              f"{directory.name}: name mismatch")
        description = metadata.get("description") if isinstance(metadata, dict) else None
        check(isinstance(description, str) and bool(description.strip()),
              f"{directory.name}: description missing")
    except yaml.YAMLError as exc:
        errors.append(f"{directory.name}: invalid YAML: {exc}")
    check((directory / "LICENSE").is_file(), f"{directory.name}: missing LICENSE")
    if directory.parent == ROOT / "skills":
        provenance = directory / "PROVENANCE.md"
        check(provenance.is_file(), f"{directory.name}: missing PROVENANCE.md")
        if provenance.is_file():
            text = provenance.read_text(encoding="utf-8")
            for field in ("License:", "Attribution:", "Source:"):
                check(field in text, f"{directory.name}: provenance missing {field}")


policy = json.loads((ROOT / "skills-policy.json").read_text(encoding="utf-8"))
check(policy.get("schemaVersion") == 1, "unsupported policy version")
agents = names(policy["profiles"]["agents"], "agents")
opencode = names(policy["profiles"]["opencode"], "opencode")
optional = names(policy["optional"], "optional")
retired = names(policy["retired"], "retired")
repo_only = names(policy["repoOnly"], "repoOnly")
nexus = names(policy["nexusCandidates"], "nexusCandidates")
active = opencode | optional
check(agents <= opencode, "agents must be a subset of opencode")
check(nexus <= agents, "Nexus candidates must be a subset of agents")
check(not (opencode & optional), "optional overlaps default profile")
check(not (active & retired or active & repo_only or retired & repo_only), "policy sets overlap")

directories = {p.name: p for p in (ROOT / "skills").iterdir() if p.is_dir()}
check(set(directories) == active,
      f"policy/skill roots differ: {sorted(set(directories) ^ active)}")
for directory in directories.values():
    validate_skill(directory)
    check(len(list(directory.rglob("SKILL.md"))) == 1,
          f"{directory.name}: nested independently discoverable SKILL.md")
for name in repo_only:
    validate_skill(ROOT / name)

readme = (ROOT / "README.md").read_text(encoding="utf-8")
rows = re.findall(r"^\| \[[^\]]+\]\(skills/([^/)]+)\) \|", readme, flags=re.M)
check(len(rows) == len(set(rows)) and set(rows) == active, "README catalog mismatch")
notices = (ROOT / "THIRD_PARTY_NOTICES.md").read_text(encoding="utf-8")
notice_rows = re.findall(r"^\| \x60([a-z0-9-]+)\x60 \|", notices, flags=re.M)
check(len(notice_rows) == len(set(notice_rows)) and set(notice_rows) == active,
      "provenance index mismatch")
check((ROOT / "LICENSE").is_file(), "missing scoped root LICENSE")
if errors:
    print("\n".join(f"FAIL: {e}" for e in errors))
    sys.exit(1)
print(f"PASS: {len(active)} retained skills, {len(agents)} shared, {len(opencode)} OpenCode, "
      f"{len(optional)} optional, {len(retired)} retired names; YAML, catalog and provenance coverage.")
