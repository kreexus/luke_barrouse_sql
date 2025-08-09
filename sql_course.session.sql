---- Practice Problem 7

SELECT *
FROM skills_dim;

SELECT *
FROM skills_job_dim;

SELECT *
FROM job_postings_fact;


---- my version. 
WITH remote_jobs AS (
SELECT job_id, job_location
FROM job_postings_fact
WHERE job_location = 'Anywhere')

SELECT
    sj.skill_id,
    s.skills as skill_name,
    COUNT (sj.job_id) as job_count
FROM skills_job_dim as sj
INNER JOIN remote_jobs as rj
ON sj.job_id = rj.job_id
LEFT JOIN skills_dim as s
ON sj.skill_id = s.skill_id

GROUP BY
    sj.skill_id,
    skill_name
ORDER BY
    job_count DESC
LIMIT 5;

---- alternative: 

-- Get the number of job postings per skill for remote jobs
WITH remote_job_skills AS (
  SELECT 
		skill_id, 
		COUNT(*) as skill_count
  FROM 
		skills_job_dim AS skills_to_job
	-- only get the relevant job postings
  INNER JOIN job_postings_fact AS job_postings ON job_postings.job_id = skills_to_job.job_id
  WHERE 
		job_postings.job_work_from_home = True
		-- If you only want to search for data analyst jobs (like Luke does in the video)
		--job_postings.job_title_short = 'Data Analyst'
  GROUP BY 
		skill_id
)

-- Return the skill id, name, and count of how many times its asked for
SELECT 
	skills.skill_id, 
	skills as skill_name, 
	skill_count
FROM remote_job_skills
-- Get the skill name
INNER JOIN skills_dim AS skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY 
	skill_count DESC
LIMIT 5;