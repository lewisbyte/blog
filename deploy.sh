#!/bin/bash
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<git add -A>>>>>>>>>>>>>>>>>>>>>>>>>>>'
git add -A;
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<git commit>>>>>>>>>>>>>>>>>>>>>>>>>>>'"
git commit -m 'update';
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<git pull>>>>>>>>>>>>>>>>>>>>>>>>>>>'
git pull;
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<git push origin main>>>>>>>>>>>>>>>>>>>>>>>>>>>'
git push origin main;
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<hexo clean>>>>>>>>>>>>>>>>>>>>>>>>>>>'
hexo clean;
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<hexo generate>>>>>>>>>>>>>>>>>>>>>>>>>>>'
hexo generate;
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<hexo deploy>>>>>>>>>>>>>>>>>>>>>>>>>>>'
hexo deploy;