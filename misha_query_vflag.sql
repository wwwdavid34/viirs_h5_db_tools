with 
lat as (values(45)),
lon as (values(-140)),
rng as (values(0)),
start_date as (values('2020-04-25'::timestamp without time zone)),
end_date as (values('2020-04-27'::timestamp without time zone)),
dnb as (
	select distinct 
		t1.*,t2.out_dflag dflag, t3.out_mflag mflag, t2.out_dflag+t3.out_mflag vflag
	from _a_find_all_dnbrad_w_latlon(
		(select * from lat), (select * from lon), (select * from rng),
		(select * from start_date), (select * from end_date)) t1,
	lateral (
		select * from _a_find_dflag_w_latlongid(
		(select * from lat), (select * from lon), 
		t1.gid,
		(select * from rng))
	) t2,
	lateral(
		select * from _a_find_mflag_w_latlongid(
		(select * from lat), (select * from lon), 
		t1.gid,
		(select * from rng))
	) t3
	
)
