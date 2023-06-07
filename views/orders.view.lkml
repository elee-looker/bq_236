# The name of this view in Looker is "Orders"
view: orders {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `orders.orders`
    ;;
  drill_fields: [id]
  # This primary key is the unique key for this table in the underlying database.
  # You need to define a primary key in a view in order to join to other views.

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Campaign" in Explore.

  dimension: campaign {
    type: string
    sql: ${TABLE}.campaign ;;
  }
filter: test {
  default_value: "2017-Q1"
  type: string
  suggest_dimension: created_date
}
  # Dates and timestamps can be represented in Looker using a dimension group of type: time.
  # Looker converts dates and timestamps to the specified timeframes within the dimension group.

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: CASE WHEN {% condition test %} LIKE 'Q1%' {% endcondition %} THEN PARSE_DATE('%Y-%m-%d', CONCAT(SUBSTR(${test}, 4, 4), '-01-01'))
    WHEN {% condition test %} LIKE 'Q2%' {% endcondition %} THEN PARSE_DATE('%Y-%m-%d', CONCAT(SUBSTR(${test}, 4, 4), '-04-01'))
    WHEN {% condition test %} LIKE 'Q3%' {% endcondition %} THEN PARSE_DATE('%Y-%m-%d', CONCAT(SUBSTR(${test}, 4, 4), '-07-01'))
    WHEN {% condition test %} LIKE 'Q4%' {% endcondition %} THEN PARSE_DATE('%Y-%m-%d', CONCAT(SUBSTR(${test}, 4, 4), '-10-01'))
    ELSE NULL
    END ;;
    datatype: date
  }

  dimension_group: created_at {
    type: time
    description: "for linna test"
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.created_at_date ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count_distinct
    drill_fields: [id, users.last_name, users.id, users.first_name, order_items.count]
    sql: WHEN CURRENT_DATE() > DATE_TRUNC(${created_date}, QUARTER) + INTERVAL 3 MONTH
ELSE 0
END ;;
  }
}
