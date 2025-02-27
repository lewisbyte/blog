hexo.extend.filter.register('theme_inject', function(injects) {
	injects.head.raw('adsense', '<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-3420592895669054" crossorigin="anonymous"></script>');
});