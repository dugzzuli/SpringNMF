
$('.login').on('click', function() {
	var user = $("#user").val().trim();
	var pwd = $("#pwd").val().trim();
	if (user == 'root' && pwd == '1512') {

		$(window).attr('location','demo/');
	}
});