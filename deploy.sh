#!/bin/bash
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890>>>>>>>>>>>>>>>>>>>>>>>>>>>'
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<git add -A>>>>>>>>>>>>>>>>>>>>>>>>>>>'
git add -A;
echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<git commit>>>>>>>>>>>>>>>>>>>>>>>>>>>'"
git commit -m 'update';
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<git pull origin main --rebase>>>>>>>>>>>>>>>>>>>>>>>>>>>'
git pull origin main --rebase;
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<git push origin main>>>>>>>>>>>>>>>>>>>>>>>>>>>'
git push origin main;
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<hexo clean>>>>>>>>>>>>>>>>>>>>>>>>>>>'
hexo clean;
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<hexo generate>>>>>>>>>>>>>>>>>>>>>>>>>>>'
hexo generate;
echo '<<<<<<<<<<<<<<<<<<<<<<<<<<<hexo deploy>>>>>>>>>>>>>>>>>>>>>>>>>>>'
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
hexo deploy;