
DELETE FROM f1_race_results
 WHERE race_id IN (
   SELECT race_id
   FROM f1_races
   WHERE season_id IN (SELECT season_id FROM f1_seasons WHERE season_year = 2026)
 );

DELETE FROM f1_races
 WHERE season_id IN (SELECT season_id FROM f1_seasons WHERE season_year = 2026);

DELETE FROM f1_drivers
 WHERE driver_code IN ('VER','PER','LEC','SAI','HAM','RUS','NOR','PIA');

DELETE FROM f1_teams
 WHERE team_code IN ('RBR','FER','MER','MCL');

DELETE FROM f1_seasons
 WHERE season_year = 2026;

COMMIT;

INSERT INTO f1_seasons(season_year, champion_driver_id, champion_team_id)
VALUES (2026, NULL, NULL);

INSERT INTO f1_teams(team_code, name, country, engine) VALUES ('RBR', 'Red Bull Racing', 'Austria', 'Honda');
INSERT INTO f1_teams(team_code, name, country, engine) VALUES ('FER', 'Ferrari', 'Italy', 'Ferrari');
INSERT INTO f1_teams(team_code, name, country, engine) VALUES ('MER', 'Mercedes', 'Germany', 'Mercedes');
INSERT INTO f1_teams(team_code, name, country, engine) VALUES ('MCL', 'McLaren', 'United Kingdom', 'Mercedes');

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('VER', (SELECT team_id FROM f1_teams WHERE team_code='RBR'), 'Max', 'Verstappen', 'Netherlands', DATE '1997-09-30');

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('PER', (SELECT team_id FROM f1_teams WHERE team_code='RBR'), 'Sergio', 'Perez', 'Mexico', DATE '1990-01-26');

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('LEC', (SELECT team_id FROM f1_teams WHERE team_code='FER'), 'Charles', 'Leclerc', 'Monaco', DATE '1997-10-16');

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('SAI', (SELECT team_id FROM f1_teams WHERE team_code='FER'), 'Carlos', 'Sainz', 'Spain', DATE '1994-09-01');

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('HAM', (SELECT team_id FROM f1_teams WHERE team_code='MER'), 'Lewis', 'Hamilton', 'United Kingdom', DATE '1985-01-07');

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('RUS', (SELECT team_id FROM f1_teams WHERE team_code='MER'), 'George', 'Russell', 'United Kingdom', DATE '1998-02-15');

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('NOR', (SELECT team_id FROM f1_teams WHERE team_code='MCL'), 'Lando', 'Norris', 'United Kingdom', DATE '1999-11-13');

INSERT INTO f1_drivers(driver_code, team_id, first_name, last_name, country, birth_date)
VALUES ('PIA', (SELECT team_id FROM f1_teams WHERE team_code='MCL'), 'Oscar', 'Piastri', 'Australia', DATE '2001-04-06');

INSERT INTO f1_races(season_id, gp_code, gp_name, race_date, country, city)
VALUES ((SELECT season_id FROM f1_seasons WHERE season_year = 2026),
        'BAHRAIN_2026', 'Bahrain GP', DATE '2026-03-08', 'Bahrain', 'Sakhir');

INSERT INTO f1_races(season_id, gp_code, gp_name, race_date, country, city)
VALUES ((SELECT season_id FROM f1_seasons WHERE season_year = 2026),
        'EMILIA_2026', 'Emilia Romagna GP', DATE '2026-05-17', 'Italy', 'Imola');

INSERT INTO f1_races(season_id, gp_code, gp_name, race_date, country, city)
VALUES ((SELECT season_id FROM f1_seasons WHERE season_year = 2026),
        'MONACO_2026', 'Monaco GP', DATE '2026-05-24', 'Monaco', 'Monte Carlo');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='BAHRAIN_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='VER'),
        'FINISH', 1, 25, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='BAHRAIN_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='LEC'),
        'FINISH', 2, 18, 'Y'); -- fastest lap

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='BAHRAIN_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='NOR'),
        'FINISH', 3, 15, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='BAHRAIN_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='HAM'),
        'FINISH', 4, 12, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='BAHRAIN_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='PER'),
        'DNF', NULL, 0, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='BAHRAIN_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='PIA'),
        'DNF', NULL, 0, 'N');


INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='EMILIA_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='NOR'),
        'FINISH', 1, 25, 'Y'); -- fastest lap

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='EMILIA_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='VER'),
        'FINISH', 2, 18, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='EMILIA_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='SAI'),
        'FINISH', 3, 15, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='EMILIA_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='RUS'),
        'FINISH', 4, 12, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='EMILIA_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='HAM'),
        'DSQ', NULL, 0, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='EMILIA_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='PER'),
        'DNF', NULL, 0, 'N');

-- MONACO_2026
INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='MONACO_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='LEC'),
        'FINISH', 1, 25, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='MONACO_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='VER'),
        'FINISH', 2, 18, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='MONACO_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='HAM'),
        'FINISH', 3, 15, 'Y'); -- fastest lap

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='MONACO_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='NOR'),
        'FINISH', 4, 12, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='MONACO_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='PIA'),
        'FINISH', 5, 10, 'N');

INSERT INTO f1_race_results(race_id, driver_id, status, position, points, fastest_lap)
VALUES ((SELECT race_id FROM f1_races WHERE gp_code='MONACO_2026'),
        (SELECT driver_id FROM f1_drivers WHERE driver_code='PER'),
        'DNF', NULL, 0, 'N');

COMMIT;

SELECT COUNT(*) AS seasons FROM f1_seasons;
SELECT COUNT(*) AS teams   FROM f1_teams;
SELECT COUNT(*) AS drivers FROM f1_drivers;
SELECT COUNT(*) AS races   FROM f1_races;
SELECT COUNT(*) AS results FROM f1_race_results;