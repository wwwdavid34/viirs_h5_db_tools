-- FUNCTION: public._a_ask_tle_norad(text, text)

-- DROP FUNCTION public._a_ask_tle_norad(text, text);

CREATE OR REPLACE FUNCTION public._a_ask_tle_norad(
	input_epoch text,
	input_norad_id text)
    RETURNS TABLE(line_1 text, line_2 text, abs_diff interval) 
    LANGUAGE 'sql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
 
 SELECT sub.line_1, sub.line_2, (CASE WHEN (sub.diff < INTERVAL '0') THEN (-sub.diff) ELSE sub.diff END) AS abs_diff
  FROM (
    SELECT *, tle.epoch-input_epoch::date AS diff
    FROM tle WHERE tle.norad_id=input_norad_id
  ) sub
  ORDER BY abs_diff ASC LIMIT 1 $BODY$;

ALTER FUNCTION public._a_ask_tle_norad(text, text)
    OWNER TO rasteradmin;

GRANT EXECUTE ON FUNCTION public._a_ask_tle_norad(text, text) TO rasteradmin;

GRANT EXECUTE ON FUNCTION public._a_ask_tle_norad(text, text) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public._a_ask_tle_norad(text, text) TO fengchihsu;

