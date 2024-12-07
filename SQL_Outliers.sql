WITH Department_Stats AS
(
	SELECT 
		Department,
		STDEV(Salary) as Standard_Deviation,
		AVG(Salary) as Average
	FROM Employee_Salary
	WHERE Salary>=10000
	GROUP BY Department
),
Department_ZScores AS
(
	SELECT
		es.Department,
		dt.Standard_Deviation,
		dt.Average,
		(es.Salary - dt.Average)/dt.Standard_Deviation as zscore
	FROM Employee_Salary es
	JOIN Department_Stats dt ON es.Department = dt.Department
	WHERE Salary>=10000
)

Select 
	ds.Department,
	ROUND(ds.Standard_Deviation,2) as Salary_StandardDeviation,
	ROUND(ds.Average,2) as Salary_Average,
	ROUND((ds.Standard_Deviation/ds.Average)*100,2) as Coefficient_of_Variation,
	SUM(CASE WHEN (dz.zscore > 1.96 OR dz.zscore < -1.96) THEN 1 ELSE 0 END) as Outlier_Count
FROM Department_Stats ds
JOIN Department_ZScores dz on ds.Department = dz.Department
GROUP BY ds.Department, ds.Standard_Deviation, ds.Average
ORDER BY Outlier_Count DESC;