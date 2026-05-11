CREATE OR REPLACE TRIGGER trg_f1_one_fastest_lap BEFORE INSERT OR UPDATE OF fastest_lap, race_id ON f1_race_results FOR EACH ROW
DECLARE v_cnt NUMBER;
BEGIN
  IF :NEW.fastest_lap = 'Y' THEN
    SELECT COUNT(*) INTO v_cnt FROM f1_race_results WHERE race_id = :NEW.race_id AND fastest_lap = 'Y' AND (:NEW.result_id IS NULL OR result_id <> :NEW.result_id);
    IF v_cnt > 0 THEN RAISE_APPLICATION_ERROR(-20100, 'Only one fastest lap (Y) is allowed per race.'); END IF;
  END IF;
END;
/
CREATE OR REPLACE TRIGGER trg_f1_validate_status_position BEFORE INSERT OR UPDATE OF status, position, points ON f1_race_results FOR EACH ROW
BEGIN
  IF :NEW.status = 'FINISH' THEN
    IF :NEW.position IS NULL OR :NEW.position < 1 THEN
      RAISE_APPLICATION_ERROR(-20110, 'FINISH requires a valid position (>=1).');
    END IF;
  ELSE
    IF :NEW.position IS NOT NULL THEN
      RAISE_APPLICATION_ERROR(-20111, 'DNF/DSQ must have NULL position.');
    END IF;
    :NEW.points := 0;
  END IF;
END;
/