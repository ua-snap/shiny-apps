<script>
    $('#genPlotButton').ajaxStart(function() { alert('disaBLING') }).ajaxStop(function() { $(this).prop('disabled', false)});
</script>