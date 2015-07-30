function updateData() {
	$('textarea[name="test_actions"]').val(JSON.stringify(test_actions));
}
$(function(){
	$('#get').on('submit', function(event){
		event.stopPropagation();
		event.preventDefault();
		$('#error').html('');
		$('#msg').html('');
		$.post($('#get').attr('action'), $('#get').serialize(), function(data, status){
			if (data)
				if (data.fail)
					$('#error').html('fail:' + data.fail);
				else if (data.empty)
					$('#msg').html('empty');
				else {
					test_actions = data.test_actions; // glabal
					$('input[name="task_id"]').val(data.task_id);
					$('#data').html('');
					data.test_actions.forEach(function(action, i){
						$('#data').append('scrn' + action.test_action_id + ': <input type="file" name="scrn' + action.test_action_id + '" data-empty/><input type="checkbox" value="failed" data-fail data-idx="' + i + '"/>failed<br/>');
					});
					$('[data-empty]').on('change', function(){
						$(this).removeAttr('data-empty');
					});
					$('[data-fail]').on('change', function(){
						if (this.checked) {
							$('#status option[value="succeeded"]').prop('selected', false);
							$('#status option[value="failed"]').prop('selected', true);
							test_actions[$(this).attr('data-idx')].failed = "test fail";
						} else {
							$('#status option[value="failed"]').prop('selected', false);
							$('#status option[value="succeeded"]').prop('selected', true);
							delete test_actions[$(this).attr('data-idx')].failed;
						}
						updateData();
					});
					updateData();
				}
			else
				$('#error').html('xhr failed');
		});
	});
	$('#start').on('submit', function(event){
		event.stopPropagation();
		event.preventDefault();
		$('#error').html('');
		$('#msg').html('');
		$.post($('#start').attr('action'), $('#start').serialize(), function(data, status){
			if (data)
				if (data.fail)
					$('#error').html(data.fail);
				else
					$('#msg').html(data.ok);
			else
				$('#error').html('xhr failed');
		});
	});
	$('#update').on('click', function(event){
		$('[data-empty]').remove();
	});
});