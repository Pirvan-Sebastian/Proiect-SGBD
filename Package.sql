CREATE OR REPLACE PACKAGE pkg_f1 AS
  e_invalid_position EXCEPTION;
  e_fastest_lap_rule EXCEPTION;

  FUNCTION fn_points_for_position(p_position NUMBER) RETURN NUMBER;

  FUNCTION fn_driver_season_points(
    p_season_year  NUMBER,
    p_driver_code  VARCHAR2
  ) RETURN NUMBER;

  FUNCTION fn_team_season_points(
    p_season_year NUMBER,
    p_team_code   VARCHAR2
  ) RETURN NUMBER;

  PROCEDURE pr_recalc_race_points(p_gp_code VARCHAR2);

  PROCEDURE pr_set_season_champions(p_season_year NUMBER);

  PROCEDURE pr_add_result(
    p_gp_code      VARCHAR2,
    p_driver_code  VARCHAR2,
    p_status       VARCHAR2,
    p_position     NUMBER DEFAULT NULL,
    p_fastest_lap  CHAR   DEFAULT 'N'
  );
END pkg_f1;
/

