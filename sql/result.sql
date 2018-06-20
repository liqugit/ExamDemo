1.
1.1
---oracle
select msisdn from (
select msisdn,sum(pv) pv
from pagevisit a
join (select msisdn from user_info where sex='男') b
on a.msisdn=b.msisdn where record_day between '20171001' and '20171007'
group by msisdn
) s where pv > 100;


1.2
---oracle
select msisdn
  from (
select msisdn,
       max(decode(record_day,'20171001','1','0')) d1,
       max(decode(record_day,'20171002','1','0')) d2,
       max(decode(record_day,'20171003','1','0')) d3,
       max(decode(record_day,'20171004','1','0')) d4,
       max(decode(record_day,'20171005','1','0')) d5,
       max(decode(record_day,'20171006','1','0')) d6,
       max(decode(record_day,'20171007','1','0')) d7
  from pagevisit where record_day between '20171001' and '20171007' and pv > 0
group by msisdn
) t
where instr(d1 || d2 || d3 || d4 || d5 || d6 || d7,'111')>0;


2.
---oracle
select dept_name,name,salary
 from (
select a.dept_name,b.name,b.salary,dense_rank() over(partition by a.dept_name order by b.salary desc) rn
from department a
join employee b
on a.departmentid=b.departmentid
)  c where rn <= 3;


3.
---oracle
select request_at,
       case when uv = 0 then 0.00
         else round(canc_uv/uv,2)
       end
  from (select request_at,
               sum(case when upper(status) like 'CANCEL%' then 1
                     else 0
                   end) canc_uv,
               count(1) uv
          from trips a,
               (select user_id from users where upper(banned) = 'NO') b,
               (select user_id from users where upper(banned) = 'NO') c
         where a.cliend_id = b.user_id
           and a.driver_id = c.user_id
           and a.request_at between '2013-10-01' and '2013-10-03'
         group by request_at) s;



