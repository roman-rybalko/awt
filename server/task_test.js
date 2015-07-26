function updateDescr() {
	$('#descr').val(JSON.stringify(testdata));
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
					$('#error').html(data.fail);
				else {
					testdata = data; // glabal
					$('input[name="task_id"]').val(data.task_id);
					$('#data').html('descr: <input type="file" name="descr"/><br/>');
					data.test_actions.forEach(function(action, i){
						$('#data').append('scrn' + i + ': <input type="file" name="scrn' + action.test_action_id + '" data-scrn data-idx="' + i + '"/><input type="checkbox" value="failed" data-fail data-idx="' + i + '"/>failed<br/>');
					});
					$('[data-scrn]').on('change', function(){
						testdata.test_actions[$(this).attr('data-idx')].scrn_filename = $(this).val();
						updateDescr();
					});
					$('[data-fail').on('change', function(){
						if (this.checked) {
							$('#status option[value="succeeded"]').prop('selected', false);
							$('#status option[value="failed"]').prop('selected', true);
							testdata.test_actions[$(this).attr('data-idx')].failed = "test fail";
						} else {
							$('#status option[value="failed"]').prop('selected', false);
							$('#status option[value="succeeded"]').prop('selected', true);
							delete testdata.test_actions[$(this).attr('data-idx')].failed;
						}
						updateDescr();
					});
					updateDescr();
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
});