# The name of this view in Looker is "Product Sheets"
view: product_sheets {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `orders.product_sheets`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Custom Grouping" in Explore.

  dimension: custom_grouping {
    type: string
    sql: ${TABLE}.custom_grouping ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  measure: count {
    type: count
    drill_fields: [product_name, products.item_name, products.id]
  }
}
