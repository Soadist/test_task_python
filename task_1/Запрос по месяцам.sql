SELECT
	DATE_FORMAT(t1.`date`, '%m.%Y') AS Месяц,
    (SELECT COUNT(*) FROM `task_1`.`history` as t2 WHERE t2.`date` < t1.`date` AND operation = 'insert' AND object_type = 'address') - 
    (SELECT COUNT(*) FROM `task_1`.`history` as t2 WHERE t2.`date` < t1.`date` AND operation = 'delete' AND object_type = 'address') as 'Кол-во адресов'
FROM `task_1`.`history` AS t1
WHERE
	operation = 'insert' AND object_type = 'address' AND
    t1.`date` BETWEEN DATE_SUB(CURDATE(), INTERVAL 24 MONTH) AND CURDATE()
GROUP BY MONTH(t1.`date`), YEAR(t1.`date`)
ORDER BY
t1.`date` ASC
