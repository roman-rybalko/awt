module.exports = {
	server_url: 'http://www/awt/server/task.php',
	server_token: 'EtZGlOGWMGtEOptUcaQN98KTnPrXpvXgpY1orOue04',
	task_type: 'gc',
	node_id: 'test1',
	selenium_browser: 'chrome',
	selenium_server: 'http://localhost:4410/wd/hub',
	selenium_port: 4410,
	selenium_timeout: 10000,  // msec
	selenium_fullscreen: false,
	batch_count: 1,  // a starving bug somewhere prevents efficient parallel run
	batch_timeout: 5000,  // msec
	xdisplay: 10,
	xauth: "/tmp/xauth10",
	xscrsize: "1920x1080x24"
};