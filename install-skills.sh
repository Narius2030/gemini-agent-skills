# Symlink (edits in this repo take effect immediately)
mkdir -p ~/.gemini/config/skills
for d in */; do
  ln -sfn "$PWD/${d%/}" ~/.gemini/config/skills/"${d%/}"
done
