set hive.optimize.cte.suggester.class=org.apache.hadoop.hive.ql.optimizer.calcite.CommonTableExpressionPrintSuggester;
set hive.mapred.mode=nonstrict;
-- start query 1 in stream 0 using template query12.tpl and seed 345591136
explain cbo
select  i_item_desc 
      ,i_category 
      ,i_class 
      ,i_current_price
      ,sum(ws_ext_sales_price) as itemrevenue 
      ,sum(ws_ext_sales_price)*100/sum(sum(ws_ext_sales_price)) over
          (partition by i_class) as revenueratio
from	
	web_sales
    	,item 
    	,date_dim
where 
	ws_item_sk = i_item_sk 
  	and i_category in ('Jewelry', 'Sports', 'Books')
  	and ws_sold_date_sk = d_date_sk
	and d_date between cast('2001-01-12' as date) 
				and (cast('2001-01-12' as date) + 30 days)
group by 
	i_item_id
        ,i_item_desc 
        ,i_category
        ,i_class
        ,i_current_price
order by 
	i_category
        ,i_class
        ,i_item_id
        ,i_item_desc
        ,revenueratio
limit 100;

-- end query 1 in stream 0 using template query12.tpl
