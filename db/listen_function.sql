begin;

  create schema if not exists tweet;

  create schema if not exists tweet;

create table tweet.users
 (
   userid     bigserial primary key,
   uname      text not null,
   nickname   text,
   bio        text,
   picture    text,

   unique(uname)
 );

create table tweet.follower
 (
   follower   bigint not null references tweet.users(userid),
   following  bigint not null references tweet.users(userid),

   primary key(follower, following)
 );

create table tweet.message
 (
   messageid  bigserial primary key,
   userid     bigint not null references tweet.users(userid),
   datetime   timestamptz not null default now(),
   message    text not null,
   favs       bigint,
   rts        bigint,
   location   point,
   lang       text,
   url        text
 );

 
  
  create schema if not exists twcache;

  create type tweet.action_t
      as enum('rt', 'fav', 'de-rt', 'de-fav');

  create table tweet.activity
  (
    id          bigserial primary key,
    messageid   bigint not null references tweet.message(messageid),
    datetime    timestamptz not null default now(),
    action      tweet.action_t not null,

    unique(messageid, datetime, action)
  );


create table tweet.counters as
  select   count(*) filter(where action = 'rt')
         - count(*) filter(where action = 'de-rt')
         as rts,
           count(*) filter(where action = 'fav')
         - count(*) filter(where action = 'de-fav')
         as favs
    from tweet.activity
         join tweet.message using(messageid);

create view tweet.message_with_counters
      as
  select messageid,
         message.userid,
         message.datetime,
         message.message,
           count(*) filter(where action = 'rt')
         - count(*) filter(where action = 'de-rt')
         as rts,
           count(*) filter(where action = 'fav')
         - count(*) filter(where action = 'de-fav')
         as favs,
         message.location,
         message.lang,
         message.url
    from tweet.activity
         join tweet.message using(messageid)
group by message.messageid, activity.messageid;

create materialized view twcache.message
    as select messageid, userid, datetime, message,
              rts, favs,
              location, lang, url
         from tweet.message_with_counters;

create unique index on twcache.message(messageid);


create or replace function twcache.tg_notify_counters ()
 returns trigger
 AS
'
declare
  channel text := TG_ARGV[0];
begin
  PERFORM (
     with payload(messageid, rts, favs) as
     (
       select NEW.messageid,
              coalesce(
                 case NEW.action
                   when "rt"    then  1
                   when "de-rt" then -1
                  end,
                 0
              ) as rts,
              coalesce(
                case NEW.action
                  when "fav"    then  1
                  when "de-fav" then -1
                 end,
                0
              ) as favs
     )
     select pg_notify(channel, row_to_json(payload)::text)
       from payload
  );
  RETURN NULL;
end;
'
LANGUAGE plpgsql;

CREATE TRIGGER notify_counters
         AFTER INSERT
            ON tweet.activity
      FOR EACH ROW
       EXECUTE PROCEDURE twcache.tg_notify_counters('tweet.activity');

commit;