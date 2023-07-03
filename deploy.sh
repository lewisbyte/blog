#!/bin/bash

git add -A;
git commit -m 'update';
git push origin main;
hexo clean;
hexo generate;
hexo deploy;