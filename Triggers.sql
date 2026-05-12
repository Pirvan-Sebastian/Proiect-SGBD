CREATE OR REPLACE TRIGGER trg_f1_validate_fastest_lap
BEFORE INSERT OR UPDATE OF fastest_lap, status ON f1_race_results
FOR EACH ROW
BEGIN
  IF :NEW.fastest_lap IS NULL THEN
    :NEW.fastest_lap := 'N';
  END IF;
  IF :NEW.fastest_lap NOT IN ('Y', 'N') THEN
    RAISE_APPLICATION_ERROR(-20120, 'fastest_lap must be Y or N.');
  END IF;
  IF :NEW.status <> 'FINISH' THEN
    :NEW.fastest_lap := 'N';
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
begin
dbms_output.put_line('Pirvan Sebastian');
end;
/