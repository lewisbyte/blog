hexo.extend.filter.register('theme_inject', function(injects) {
	injects.head.raw('adsense', '<script defer src="https://umami-tawny-ten.vercel.app/script.js" data-website-id="2d67bc92-a495-40e4-8494-c7953d135107"></script>');
});