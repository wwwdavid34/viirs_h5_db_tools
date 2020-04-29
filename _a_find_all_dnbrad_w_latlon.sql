-- FUNCTION: public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer)

-- DROP FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer);

CREATE OR REPLACE FUNCTION public._a_find_all_dnbrad_w_latlon(
	lat numeric,
	lon numeric,
	range integer)
    RETURNS TABLE(gid bigint, gname text, line integer, sample integer, rad double precision) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
  begin
  return query
  select
    t1.gid,t2.out_gname,t2.out_line,t2.out_sample,t2.rad
  from
    (select * from _a_find_granule_w_latlon(lat,lon)) t1,
    lateral(select * from _a_find_dnbrad_w_latlongid(lat,lon,t1.gid,range)) t2;
end;
$BODY$;

ALTER FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer)
    OWNER TO rasteradmin;

GRANT EXECUTE ON FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer) TO rasteradmin;

GRANT EXECUTE ON FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer) TO PUBLIC;

GRANT EXECUTE ON FUNCTION public._a_find_all_dnbrad_w_latlon(numeric, numeric, integer) TO fengchihsu;

