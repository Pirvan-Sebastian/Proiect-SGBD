

SET SERVEROUTPUT ON;

-- 0) Clean previous results for MONACO_2026 (safe rerun)
BEGIN
  DELETE FROM f1_race_results
   WHERE race_id = (SELECT race_id FROM f1_races WHERE gp_code = 'MONACO_2026');
  DBMS_OUTPUT.PUT_LINE('Old results deleted for MONACO_2026: ' || SQL%ROWCOUNT);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Race MONACO_2026 not found (seed data missing).');
END;
/
COMMIT;

-- 1) Adaugare Rezultate Cursa
BEGIN
  pkg_f1.pr_add_result('MONACO_2026','VER','FINISH',1,'Y'); -- +1 fastest lap
  pkg_f1.pr_add_result('MONACO_2026','LEC','FINISH',2,'N');
  pkg_f1.pr_add_result('MONACO_2026','NOR','FINISH',3,'N');
  pkg_f1.pr_add_result('MONACO_2026','HAM','FINISH',4,'N');
  pkg_f1.pr_add_result('MONACO_2026','SAI','FINISH',5,'N');
  pkg_f1.pr_add_result('MONACO_2026','RUS','FINISH',6,'N');

  pkg_f1.pr_add_result('MONACO_2026','PER','DNF',NULL,'N');
  pkg_f1.pr_add_result('MONACO_2026','PIA','DNF',NULL,'N');

  DBMS_OUTPUT.PUT_LINE('Results inserted for MONACO_2026.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Insert error: ' || SQLERRM);
    RAISE;
END;
/
COMMIT;

-- 2) Recalculare puncte
BEGIN
  pkg_f1.pr_recalc_race_points('MONACO_2026');
  DBMS_OUTPUT.PUT_LINE('Points recalculated for MONACO_2026.');
END;
/
COMMIT;

-- 3) Show race classification (with points)
COLUMN gp_code FORMAT A12
COLUMN driver FORMAT A25
COLUMN team_code FORMAT A6
COLUMN status FORMAT A8

SELECT r.gp_code,
       d.driver_code || ' - ' || d.first_name || ' ' || d.last_name AS driver,
       t.team_code,
       rr.status,
       rr.position,
       rr.fastest_lap,
       rr.points
  FROM f1_race_results rr
  JOIN f1_races r    ON r.race_id = rr.race_id
  JOIN f1_drivers d  ON d.driver_id = rr.driver_id
  JOIN f1_teams t    ON t.team_id = d.team_id
 WHERE r.gp_code = 'MONACO_2026'
 ORDER BY CASE WHEN rr.position IS NULL THEN 999 ELSE rr.position END;

-- 4) Season standings (drivers)
COLUMN season_year FORMAT 9999
COLUMN pts FORMAT 999

SELECT s.season_year,
       d.driver_code,
       d.first_name || ' ' || d.last_name AS driver,
       SUM(rr.points) AS pts
  FROM f1_seasons s
  JOIN f1_races r        ON r.season_id = s.season_id
  JOIN f1_race_results rr ON rr.race_id = r.race_id
  JOIN f1_drivers d      ON d.driver_id = rr.driver_id
 WHERE s.season_year = 2026
 GROUP BY s.season_year, d.driver_code, d.first_name, d.last_name
 ORDER BY pts DESC, d.driver_code ASC;

-- 5) Season standings (constructors)
SELECT s.season_year,
       t.team_code,
       t.name AS team,
       SUM(rr.points) AS pts
  FROM f1_seasons s
  JOIN f1_races r         ON r.season_id = s.season_id
  JOIN f1_race_results rr  ON rr.race_id = r.race_id
  JOIN f1_drivers d       ON d.driver_id = rr.driver_id
  JOIN f1_teams t         ON t.team_id = d.team_id
 WHERE s.season_year = 2026
 GROUP BY s.season_year, t.team_code, t.name
 ORDER BY pts DESC, t.team_code ASC;

-- 6) Set champions in f1_seasons (T1 tie-break)
BEGIN
  pkg_f1.pr_set_season_champions(2026);
  DBMS_OUTPUT.PUT_LINE('Champions set for season 2026.');
END;
/
COMMIT;

-- 7) Display season champions (IDs + readable names)
SELECT s.season_year,
       s.champion_driver_id,
       (SELECT d.driver_code || ' - ' || d.first_name || ' ' || d.last_name
          FROM f1_drivers d
         WHERE d.driver_id = s.champion_driver_id) AS champion_driver,
       s.champion_team_id,
       (SELECT t.team_code || ' - ' || t.name
          FROM f1_teams t
         WHERE t.team_id = s.champion_team_id) AS champion_team
  FROM f1_seasons s
 WHERE s.season_year = 2026;

-- 8) Negative test (optional): try to set a second fastest lap = Y in same race
-- Should fail with -20100 from trg_f1_one_fastest_lap
-- Uncomment to test trigger behavior
/*
BEGIN
  UPDATE f1_race_results
     SET fastest_lap = 'Y'
   WHERE race_id = (SELECT race_id FROM f1_races WHERE gp_code='MONACO_2026')
     AND driver_id = (SELECT driver_id FROM f1_drivers WHERE driver_code='LEC');
END;
/
*/