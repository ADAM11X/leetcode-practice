WITH email_count as (
    SELECT 
    email,
    COUNT(email) OVER(PARTITION BY email ORDER BY id ASC ) AS dup_num
    FROM Person 

)

DELETE FROM email_count 
WHERE dup_num > 1
