# @echo off
# python gen_md_from_src.py

git pull

env\Scripts\activate.bat
python gen_md_from_src.py

git add .
read -p "input commit message: " msg
git commit -m "$msg"
git push

mkdocs build
mkdocs gh-deploy --clean

read -p "===== git push ok, Type enter to exit. ===== " msg00