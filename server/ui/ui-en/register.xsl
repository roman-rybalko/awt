<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="register">
	<xsl:choose>
		<xsl:when test="//message[@value='register_ok']">
			<xsl:call-template name="redirect">
				<xsl:with-param name="url">?settings=1</xsl:with-param>
				<xsl:with-param name="timeout">5</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<div class="container">
				<div class="row">
					<div class="col-md-4 col-md-offset-4">
						<div class="panel panel-default panel-login">
							<div class="panel-heading">
								<h3 class="panel-title">Create Account</h3>
							</div>
							<div class="panel-body">
								<xsl:apply-templates select="//message"/>
								<form role="form" method="post">
									<fieldset>
										<div class="form-group">
											<label for="register-login">Login</label>
											<input id="register-login" class="form-control" placeholder="Login" name="user" type="text" autofocus="1"/>
										</div>
										<div class="form-group">
											<label for="register-password1">Password</label>
											<input id="register-password1" class="form-control" placeholder="Password" name="password1" type="password" value=""/>
										</div>
										<div class="form-group">
											<label for="register-password2">Password (confirm)</label>
											<input id="register-password2" class="form-control" placeholder="Password (confirm)" name="password2" type="password" value=""/>
										</div>
										<div class="form-group">
											<a href="#">
												<xsl:attribute name="onclick">
													$('#captcha').attr('src','./captcha.php?id=' + Math.random());
													return false;
												</xsl:attribute>
												<img src="./captcha.php" alt="Captcha" id="captcha"/>
												Change
											</a>
										</div>
										<div class="form-group">
											<label for="register-captcha">Captcha</label>
											<input id="register-captcha" class="form-control" placeholder="Captcha" name="captcha" type="text" value=""/>
										</div>
										<input type="submit" name="register" value="Register" class="btn btn-success btn-block"/>
										<div>
											<a href="./">Login</a>
										</div>
									</fieldset>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
