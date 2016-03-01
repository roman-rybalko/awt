<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="user">
<html lang="en">
	<head>
		<meta charset="utf-8"/>
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<meta name="viewport" content="width=device-width, initial-scale=1"/>
		<title>Advanced Web Testing</title>
		<meta name="description" content="Advanced Web Testing, Web Automation, Web Monitoring"/>
	</head>
	<body>
		<script type="text/javascript">
			/* <![CDATA[ */
			if (navigator && navigator.userAgent.match(/MSIE\s*[23456789]/)) (function() {
				try {
					var showed = document.cookie.match(/msie_support_alert/);
					if (!showed) {
						var d = new Date();
					    d.setTime(d.getTime() + 24*60*60*1000);
					    document.cookie = 'msie_support_alert=1; expires=' + d.toUTCString();
					}
				} catch (e) {}
				if (!showed) {
					alert('Internet Explorer is not fully supported. Please, consider to upgrade to Google Chrome, Opera, Firefox or Safari.');
				}
			})();
			/* ]]> */
		</script>
		<script src="ui-en/js/jquery.min.js" type="text/javascript"></script>
		<script src="ui-en/js/error.js" type="text/javascript"></script>
		<script src="ui-en/js/jquery.cookie.min.js" type="text/javascript"></script>
		<script src="ui-en/js/jquery.storageapi.min.js" type="text/javascript"></script>
		<script src="ui-en/js/storage.js" type="text/javascript"></script>

		<img src="ui-en/img/loader.gif" id="loader" style="position: fixed; z-index: 7777777;"/>
		<script  type="text/javascript">
			/* <![CDATA[ */
			var loader;
			error_handler(function() {
				var loader_width = window.innerWidth/10;
				var loader_height = window.innerHeight/10;
				if (loader_width < loader_height)
					loader_height = loader_width;
				else
					loader_height = loader_width;
				loader = $('#loader');
				loader.css('width', loader_width + 'px');
				loader.css('height', loader_height + 'px');
				loader.css('left', (window.innerWidth/2 - loader_width/2) + 'px');
				loader.css('top', (window.innerHeight/2 - loader_height/2) + 'px');
			})();
			/* ]]> */
		</script>

		<!--[if lt IE 9]>
			<script src="ui-en/js/html5shiv.min.js" type="text/javascript"></script>
			<script src="ui-en/js/respond.min.js" type="text/javascript"></script>
		<![endif] -->

		<link href="ui-en/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
		<script src="ui-en/js/bootstrap.min.js" type="text/javascript"></script>

		<link href="ui-en/css/font-awesome.min.css" rel="stylesheet" type="text/css"/>

		<script type="text/javascript">
			var awt_login = "<xsl:value-of select="@login"/>";
		</script>

		<xsl:apply-templates select="*[not(self::message)]"/>

		<link href="ui-en/css/awt.css" rel="stylesheet" type="text/css"/>
		<script src="ui-en/js/awt.js" type="text/javascript"></script>

		<!-- Yandex.Metrika counter -->
		<script type="text/javascript">
			error_handler(function() {
				(function (d, w, c) { (w[c] = w[c] || []).push(function() { try { w.yaCounter35773240 = new Ya.Metrika({ id:35773240, clickmap:true, trackLinks:true, accurateTrackBounce:true, webvisor:true, trackHash:true }); } catch(e) { } }); var n = d.getElementsByTagName("script")[0], s = d.createElement("script"), f = function () { n.parentNode.insertBefore(s, n); }; s.type = "text/javascript"; s.async = true; s.src = "https://mc.yandex.ru/metrika/watch.js"; if (w.opera == "[object Opera]") { d.addEventListener("DOMContentLoaded", f, false); } else { f(); } })(document, window, "yandex_metrika_callbacks");
			})();
		</script>
		<!-- /Yandex.Metrika counter -->

		<script type="text/javascript">
			error_handler(function() {
		  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
		  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
		  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
		  ga('create', 'UA-71272598-1', 'auto');
		  ga('send', 'pageview');
			})();
		</script>

		<script  type="text/javascript">
			/* <![CDATA[ */
			$(window).load(error_handler(function() {
				$(error_handler(function() {
					loader.hide();
				}));
			}));
			/* ]]> */
		</script>

	</body>
</html>
</xsl:template>

</xsl:stylesheet>
