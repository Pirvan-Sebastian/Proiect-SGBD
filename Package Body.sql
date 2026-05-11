CREATE OR REPLACE PACKAGE BODY pkg_f1 AS
  FUNCTION fn_points_for_position(p_position NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN CASE p_position
      WHEN 1  THEN 25
      WHEN 2  THEN 18
      WHEN 3  THEN 15
      WHEN 4  THEN 12
      WHEN 5  THEN 10
      WHEN 6  THEN 8
      WHEN 7  THEN 6
      WHEN 8  THEN 4
      WHEN 9  THEN 2
      WHEN 10 THEN 1
      ELSE 0
    END;
  END fn_points_for_position;


  FUNCTION fn_driver_season_points(
    p_season_year  NUMBER,
    p_driver_code  VARCHAR2
  ) RETURN NUMBER IS
    v_points NUMBER;
  BEGIN
    SELECT NVL(SUM(rr.points), 0)
      INTO v_points
      FROM f1_race_results rr
      JOIN f1_races r   ON r.race_id = rr.race_id
      JOIN f1_seasons s ON s.season_id = r.season_id
      JOIN f1_drivers d ON d.driver_id = rr.driver_id
     WHERE s.season_year = p_season_year
       AND d.driver_code = p_driver_code;

    RETURN v_points;
  END fn_driver_season_points;
  FUNCTION fn_team_season_points(p_season_year NUMBER, p_team_code VARCHAR2) RETURN NUMBER IS
    v_points NUMBER;
  BEGIN
    SELECT NVL(SUM(rr.points), 0)
      INTO v_points
      FROM f1_race_results rr
      JOIN f1_races r   ON r.race_id = rr.race_id
      JOIN f1_seasons s ON s.season_id = r.season_id
      JOIN f1_drivers d ON d.driver_id = rr.driver_id
      JOIN f1_teams t   ON t.team_id = d.team_id
     WHERE s.season_year = p_season_year
       AND t.team_code   = p_team_code;

    RETURN v_points;
  END fn_team_season_points;
  PROCEDURE pr_add_result(p_gp_code VARCHAR2, p_driver_code VARCHAR2, p_status VARCHAR2, p_position NUMBER DEFAULT NULL, p_fastest_lap CHAR DEFAULT 'N') IS
    v_race_id f1_races.race_id%TYPE;
    v_driver_id f1_drivers.driver_id%TYPE;
  BEGIN
    SELECT race_id INTO v_race_id FROM f1_races WHERE gp_code = p_gp_code;
    SELECT driver_id INTO v_driver_id FROM f1_drivers WHERE driver_code = p_driver_code;

    IF p_status = 'FINISH' THEN
      IF p_position IS NULL OR p_position < 1 THEN
        RAISE e_invalid_position;
      END IF;
    ELSE
      IF p_position IS NOT NULL THEN
        RAISE e_invalid_position;
      END IF;
    END IF;

    IF p_fastest_lap NOT IN ('Y','N') THEN
      RAISE e_fastest_lap_rule;
    END IF;
    INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
    VALUES (v_race_id, v_driver_id, p_status, p_position, 0, NVL(p_fastest_lap,'N'));

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Race gp_code or driver_code not found.');
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20002, 'Duplicate result: this driver already has a result for this race.');
    WHEN e_invalid_position THEN
      RAISE_APPLICATION_ERROR(-20010, 'Invalid position for given status (FINISH needs position; DNF/DSQ must have NULL).');
    WHEN e_fastest_lap_rule THEN
      RAISE_APPLICATION_ERROR(-20011, 'Invalid fastest_lap value (must be Y or N).');
  END pr_add_result;
  PROCEDURE pr_recalc_race_points(p_gp_code VARCHAR2) IS
    v_race_id f1_races.race_id%TYPE;

    CURSOR c_res(p_race_id NUMBER) IS
      SELECT result_id, status, position, fastest_lap
        FROM f1_race_results
       WHERE race_id = p_race_id
       FOR UPDATE OF points;

    v_base_points NUMBER;
  BEGIN
    SELECT race_id INTO v_race_id FROM f1_races WHERE gp_code = p_gp_code;

    FOR rec IN c_res(v_race_id) LOOP
      IF rec.status = 'FINISH' THEN
        v_base_points := fn_points_for_position(rec.position);
        IF rec.fastest_lap = 'Y' THEN
          IF rec.position BETWEEN 1 AND 10 THEN v_base_points := v_base_points + 1; ELSE RAISE e_fastest_lap_rule; END IF;
        END IF;
        UPDATE f1_race_results SET points = v_base_points WHERE CURRENT OF c_res;
      ELSE
        UPDATE f1_race_results SET points = 0 WHERE CURRENT OF c_res;
      END IF;
    END LOOP;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20003, 'Race not found for gp_code=' || p_gp_code);
    WHEN e_fastest_lap_rule THEN
      RAISE_APPLICATION_ERROR(-20012, 'Fastest lap is only allowed for a FINISH result in top 10.');
  END pr_recalc_race_points;
  PROCEDURE pr_set_season_champions(p_season_year NUMBER) IS
    v_driver_id NUMBER;
    v_team_id NUMBER;
  BEGIN
    SELECT driver_id
      INTO v_driver_id
      FROM (
        SELECT d.driver_id, SUM(rr.points) pts
          FROM f1_drivers d
          JOIN f1_race_results rr ON rr.driver_id = d.driver_id
          JOIN f1_races r         ON r.race_id = rr.race_id
          JOIN f1_seasons s       ON s.season_id = r.season_id
         WHERE s.season_year = p_season_year
         GROUP BY d.driver_id
         ORDER BY pts DESC, d.driver_id ASC
      )
     WHERE ROWNUM = 1;
    SELECT team_id
      INTO v_team_id
      FROM (
        SELECT t.team_id, SUM(rr.points) pts
          FROM f1_teams t
          JOIN f1_drivers d      ON d.team_id = t.team_id
          JOIN f1_race_results rr ON rr.driver_id = d.driver_id
          JOIN f1_races r         ON r.race_id = rr.race_id
          JOIN f1_seasons s       ON s.season_id = r.season_id
         WHERE s.season_year = p_season_year
         GROUP BY t.team_id
         ORDER BY pts DESC, t.team_id ASC
      )
     WHERE ROWNUM = 1;

    UPDATE f1_seasons
       SET champion_driver_id = v_driver_id,
           champion_team_id   = v_team_id
     WHERE season_year = p_season_year;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20004, 'Season not found: ' || p_season_year);
    END IF;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20005, 'No race results found for season ' || p_season_year);
  END pr_set_season_champions;

END pkg_f1;
/
SHOW ERRORS