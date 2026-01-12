{% macro batch_success(job_name) %}

    update {{ target.database }}.CONTROL.BATCH_CONTROL
    set
        last_success_lwm = (
            select coalesce(max(last_updated_ts), last_success_lwm)
            from {{ this }}
        ),
        last_success_hwm = current_timestamp,
        status = 'SUCCESS',
        updated_ts = current_timestamp
    where job_name = '{{ job_name }}';

{% endmacro %}
