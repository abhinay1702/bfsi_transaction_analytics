{% macro process_batch_control(job_name) %}

{% set ctl_db = target.database %}
{% set ctl_schema = 'CONTROL' %}

{% set sql %}
    select
        last_success_lwm as lwm,
        current_timestamp as hwm,
        uuid_string() as process_id
    from {{ ctl_db }}.{{ ctl_schema }}.batch_control
    where job_name = '{{ job_name }}'
{% endset %}

{% set results = run_query(sql) %}

{% if execute %}
    {% set lwm = results.columns[0].values()[0] %}
    {% set hwm = results.columns[1].values()[0] %}
    {% set process_id = results.columns[2].values()[0] %}
{% endif %}

{{ return([lwm, hwm, process_id]) }}

{% endmacro %}
