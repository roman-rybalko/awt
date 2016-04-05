<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="login">
	<xsl:choose>
		<xsl:when test="//message[@value='set_up_email']">
			<xsl:call-template name="redirect">
				<xsl:with-param name="url">?settings=1</xsl:with-param>
				<xsl:with-param name="timeout">5</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="//message[@value='login_ok']">
			<xsl:call-template name="redirect"/>
		</xsl:when>
		<xsl:otherwise>
			<div class="container">
				<div class="row">
					<div class="col-md-4 col-md-offset-4">
						<div class="panel panel-default panel-login">
							<div class="panel-heading">
								<h3 class="panel-title">Please Login</h3>
							</div>
							<div class="panel-body">
								<xsl:apply-templates select="//message"/>
								<form role="form" method="post">
									<fieldset>
										<div class="form-group">
											<label for="login-login">Login</label>
											<input id="login-login" class="form-control" placeholder="Login" name="user" type="text" autofocus="1"/>
										</div>
										<div class="form-group">
											<label for="login-password">Password</label>
											<input id="login-password" class="form-control" placeholder="Password" name="password" type="password" value=""/>
										</div>
										<input type="submit" name="login" value="Login" class="btn btn-success btn-block"/>
										<div>
											<a href="./?register=1">Create Account</a>
											|
											<a href="./?password_reset=1">Forgot Password</a>
											|
											<a href="./demo.php">Demo</a>
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
