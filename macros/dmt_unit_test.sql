{% test unit_test(model, input_mapping, expected_output, depends_on, name, description, compare_columns, env) %}
    {%- if not env or target.name == env -%}
        {% set test_sql = dbt_datamocktool.get_unit_test_sql(model, input_mapping, depends_on) %}
        {% do return(dbt_utils.test_equality(expected_output, compare_model=test_sql, compare_columns=compare_columns)) %}
    {%- else -%}
        {% do log('Unit test for model ' ~ name ~ ' configured not to run in ' ~ target.name ~ ' environment -> Skipping.', info=True) %}
        {{ config(fail_calc = "sum(validation_errors)") }}
        select 0 as validation_errors
    {%- endif -%}
{% endtest %}

{% test assert_mock_eq(model, input_mapping, expected_output) %}
    {% do return(test_unit_test(model, input_mapping, expected_output)) %}
{% endtest %}
