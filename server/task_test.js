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
					$('input[name="task_id"]').val(data.task_id);
					$('#data').html('');
					data.task_actions.forEach(function(action, i){
						$('#data').append('scrn' + action.action_id + ': <input type="file" name="scrn' + action.action_id + '"/><input type="checkbox" value="failed" data-fail data-id="' + action.action_id + '"/>failed<br/>');
					});
					$('[data-fail]').on('change', function(){
						if (this.checked) {
							$('#status option[value="succeeded"]').prop('selected', false);
							$('#status option[value="failed"]').prop('selected', true);
							$('#update input[name="failed_action_id"]').val($(this).attr('data-id'));
						} else {
							$('#status option[value="failed"]').prop('selected', false);
							$('#status option[value="succeeded"]').prop('selected', true);
							$('#update input[name="failed_action_id"]').val('');
						}
					});
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
	$('#update input[type="submit"]').on('click', function(event){
		$('#update input').filter(function(){return !$(this).val();}).remove();
	});
});