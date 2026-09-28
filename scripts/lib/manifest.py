#!/usr/bin/env python3
import json
import sys
import os

MANIFEST_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "packages.json")

def load_manifest():
    if not os.path.exists(MANIFEST_PATH):
        sys.stderr.write(f"Error: manifest file not found at {MANIFEST_PATH}\n")
        sys.exit(1)
    with open(MANIFEST_PATH, "r") as f:
        return json.load(f)

def main():
    if len(sys.argv) < 2:
        sys.exit(1)
    
    cmd = sys.argv[1]
    data = load_manifest()
    packages = data.get("packages", {})

    if cmd == "list-packages":
        print(" ".join(packages.keys()))

    elif cmd == "get-category":
        if len(sys.argv) < 3:
            sys.exit(1)
        pkg = sys.argv[2]
        print(packages.get(pkg, {}).get("category", ""))

    elif cmd == "get-deps":
        target_pkgs = sys.argv[2:] if len(sys.argv) > 2 else list(packages.keys())
        deps = []
        for pkg in target_pkgs:
            for dep in packages.get(pkg, {}).get("deps", []):
                if dep not in deps:
                    deps.append(dep)
        print(" ".join(deps))

    elif cmd == "get-conflicts":
        if len(sys.argv) < 3:
            sys.exit(1)
        pkg = sys.argv[2]
        print(" ".join(packages.get(pkg, {}).get("conflicts", [])))

    elif cmd == "get-hook":
        if len(sys.argv) < 3:
            sys.exit(1)
        pkg = sys.argv[2]
        print(packages.get(pkg, {}).get("hook", ""))

    else:
        sys.exit(1)

if __name__ == "__main__":
    main()
