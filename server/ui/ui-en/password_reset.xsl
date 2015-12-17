<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="password_reset">
	<div class="container">
		<div class="row">
			<div class="col-md-4 col-md-offset-4">
				<div class="panel panel-default panel-login">
					<div class="panel-heading">
						<h3 class="panel-title">Password Reset</h3>
					</div>
					<div class="panel-body">
						<xsl:apply-templates select="//message"/>
						<form role="form" method="post">
							<fieldset>
								<div class="form-group">
									<input class="form-control" placeholder="Login" name="user"
										type="text" autofocus="1"/>
								</div>
								<div class="form-group">
									<input class="form-control" placeholder="New Password" name="password1"
										type="password" value=""/>
								</div>
								<div class="form-group">
									<input class="form-control" placeholder="New Password (confirm)"
										name="password2" type="password" value=""/>
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
									<input class="form-control" placeholder="Captcha"
										name="captcha" type="text" value=""/>
								</div>
								<input type="submit" name="reset" value="Reset"
									class="btn btn-lg btn-success btn-block"/>
								<div class="form-group">
									<a href="./">Login</a>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</xsl:template>
</xsl:stylesheet>
