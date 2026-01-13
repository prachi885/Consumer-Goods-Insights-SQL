/*10. Get the Top 3 products in each division that have a high
total_sold_quantity in the fiscal_year 2021? The final output contains these
fields,
division
product_code
product
total_sold_quantity
rank_order*/ 

SELECT
    division,
    product_code,
    product,
    total_sold_quantity,
    rank_order
FROM (
    SELECT
        p.division,
        fs.product_code,
        p.product,
        SUM(fs.sold_quantity) AS total_sold_quantity,
        RANK() OVER (
            PARTITION BY p.division
            ORDER BY SUM(fs.sold_quantity) DESC
        ) AS rank_order
    FROM dim_product p
    JOIN fact_sales_monthly fs
        ON p.product_code = fs.product_code
    WHERE fs.fiscal_year = 2021
    GROUP BY p.division, fs.product_code, p.product
) t
WHERE rank_order <= 3
ORDER BY division, rank_order;
