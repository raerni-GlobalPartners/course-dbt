{%- macro select_distinct_sessions(table, event_type) -%} 

select distinct session_id
from {{ table }}
where event_type = '{{ event_type }}'

{% endmacro %}
