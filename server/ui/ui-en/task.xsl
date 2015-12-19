<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="task">
	<xsl:call-template name="menu"/>
</xsl:template>

<xsl:template match="task" mode="menu">
	<link href="ui-en/css/photoswipe.min.css" rel="stylesheet" type="text/css"/>
	<link href="ui-en/css/photoswipe-default-skin/default-skin.min.css" rel="stylesheet" type="text/css"/>
	<script src="ui-en/js/photoswipe.min.js" type="text/javascript"></script>
	<script src="ui-en/js/photoswipe-ui-default.min.js" type="text/javascript"></script>
	<xsl:call-template name="js_task_types"/>
	<div class="container-fluid">
		<div class="row">
			<div class="col-lg-12">
				<h1 class="page-header">Task</h1>
				<xsl:apply-templates select="//message"/>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-info">
					<div class="panel-body">
						<div class="row">
							<div class="col-lg-2">
								<b>Test</b>:
								<a href="./?test={@test_id}">
									<xsl:value-of select="@test_name"/>
								</a>
							</div>
							<div class="col-lg-2">
								<b>Type</b>:
								<span class="task-type">
									<xsl:value-of select="@type"/>
								</span>
							</div>
							<div class="col-lg-2">
								<b>Status</b>:
								<span>
									<xsl:if test="@status = 'succeeded'">
										<xsl:attribute name="class">
											text-success
										</xsl:attribute>
									</xsl:if>
									<xsl:if test="@status = 'failed'">
										<xsl:attribute name="class">
											text-failure
										</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="@status"/>
								</span>
							</div>
							<div class="col-lg-2">
								<b>Debug</b>:
								<span>
									<xsl:choose>
										<xsl:when test="@debug">
											<xsl:attribute name="class">
												text-success
											</xsl:attribute>
											on
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="class">
												text-failure
											</xsl:attribute>
											off
										</xsl:otherwise>
									</xsl:choose>
								</span>
							</div>
							<div class="col-lg-3">
								<b>Time</b>:
								<span class="time-unix2human">
									<xsl:value-of select="@time"/>
								</span>
							</div>
							<div class="col-lg-1">
								<button type="button" class="btn btn-xs btn-success" data-toggle="modal" data-target="#modal-test-restart">
									<i class="fa fa-play"></i>
									Restart
								</button>
							</div>
							<xsl:call-template name="modal_new_task">
								<xsl:with-param name="modal_id">modal-test-restart</xsl:with-param>
								<xsl:with-param name="test_name"><xsl:value-of select="@test_name"/></xsl:with-param>
								<xsl:with-param name="test_id"><xsl:value-of select="@test_id"/></xsl:with-param>
							</xsl:call-template>
						</div>
					</div>
				</div>
				<div class="alert alert-info alert-dismissable">
					<button type="button" class="close" data-dismiss="alert" aria-hidden="true" data-dismiss-state="task-scrn-open">&#215;</button>
					<b>Tip:</b>
					You may open screenshot in another browser tab.
				</div>
			</div>
		</div>
		<xsl:for-each select="action">
			<xsl:sort select="@id" data-type="number" order="ascending"/>
			<div class="row">
				<div class="col-lg-12">
					<div>
						<xsl:choose>
							<xsl:when test="@succeeded">
								<xsl:attribute name="class">
									alert alert-success
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="@failed">
								<xsl:attribute name="class">
									alert alert-danger
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">
									alert alert-warning
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
						<div class="row">
							<div class="col-lg-8">
								<div class="row">
									<xsl:apply-templates select="." mode="html"/>
								</div>
							</div>
							<div class="col-lg-2">
								<xsl:if test="@failed">
									<b class="text-failure">Failure</b>:
									<span class="text-failure">
										<xsl:value-of select="@failed"/>
									</span>
								</xsl:if>
							</div>
							<div class="col-lg-2">
								<xsl:if test="@scrn">
									<a href="results/{@scrn}" class="task-scrn">
										<img src="results/{@scrn}" class="img-thumbnail img-responsive">
											<xsl:attribute name="alt">
												<xsl:if test="@succeeded">
													succeeded:
												</xsl:if>
												<xsl:if test="@failed">
													failed:
												</xsl:if>
												<xsl:apply-templates select="." mode="text"/>
												<xsl:if test="@failed">
													, <xsl:value-of select="@failed"/>
												</xsl:if>
											</xsl:attribute>
										</img>
									</a>
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:for-each>
	</div>
	<!-- Root element of PhotoSwipe. Must have class pswp. -->
	<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">
	    <!-- Background of PhotoSwipe. 
	         It's a separate element as animating opacity is faster than rgba(). -->
	    <div class="pswp__bg"></div>
	    <!-- Slides wrapper with overflow:hidden. -->
	    <div class="pswp__scroll-wrap">
	        <!-- Container that holds slides. 
	            PhotoSwipe keeps only 3 of them in the DOM to save memory.
	            Don't modify these 3 pswp__item elements, data is added later on. -->
	        <div class="pswp__container">
	            <div class="pswp__item"></div>
	            <div class="pswp__item"></div>
	            <div class="pswp__item"></div>
	        </div>
	        <!-- Default (PhotoSwipeUI_Default) interface on top of sliding area. Can be changed. -->
	        <div class="pswp__ui pswp__ui--hidden">
	            <div class="pswp__top-bar">
	                <!--  Controls are self-explanatory. Order can be changed. -->
	                <div class="pswp__counter"></div>
	                <button class="pswp__button pswp__button--close" title="Close (Esc)"></button>
	                <button class="pswp__button pswp__button--share" title="Share"></button>
	                <button class="pswp__button pswp__button--fs" title="Toggle fullscreen"></button>
	                <button class="pswp__button pswp__button--zoom" title="Zoom in/out"></button>
	                <!-- Preloader demo http://codepen.io/dimsemenov/pen/yyBWoR -->
	                <!-- element will get class pswp__preloader- (leave space here to prevent "xml malformed" error) -active when preloader is running -->
	                <div class="pswp__preloader">
	                    <div class="pswp__preloader__icn">
	                      <div class="pswp__preloader__cut">
	                        <div class="pswp__preloader__donut"></div>
	                      </div>
	                    </div>
	                </div>
	            </div>
	            <div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
	                <div class="pswp__share-tooltip"></div> 
	            </div>
	            <button class="pswp__button pswp__button--arrow--left" title="Previous (arrow left)">
	            </button>
	            <button class="pswp__button pswp__button--arrow--right" title="Next (arrow right)">
	            </button>
	            <div class="pswp__caption">
	                <div class="pswp__caption__center"></div>
	            </div>
	        </div>
	    </div>
	</div>	
</xsl:template>

</xsl:stylesheet>
