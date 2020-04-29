-- FUNCTION: public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer, timestamp without time zone, timestamp without time zone)

-- DROP FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer, timestamp without time zone, timestamp without time zone);

CREATE OR REPLACE FUNCTION public._a_find_all_dnbrad_w_latlon(
	lat numeric,
	lon numeric,
	range integer,
	start_date timestamp without time zone,
	end_date timestamp without time zone)
    RETURNS TABLE(gid bigint, gname text, line integer, sample integer, rad double precision) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
    BEGIN
      RETURN QUERY
        SELECT
          t1.gid, t2.out_gname, t2.out_line, t2.out_sample, t2.rad
        FROM
          (select * from _a_find_granule_w_latlon(lat,lon,start_date,end_date)) t1,
          LATERAL(select * from _a_find_dnbrad_w_latlongid(lat,lon,t1.gid,range)) t2;
    END;
  $BODY$;

ALTER FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer, timestamp without time zone, timestamp without time zone)
    OWNER TO rasteradmin;

GRANT EXECUTE ON FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer, timestamp without time zone, timestamp without time zone) TO rasteradmin;

GRANT EXECUTE ON FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer, timestamp without time zone, timestamp without time zone) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer, timestamp without time zone, timestamp without time zone) TO fengchihsu;

