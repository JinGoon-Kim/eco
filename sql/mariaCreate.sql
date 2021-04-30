-- disconnect key
alter table member drop primary key cascade;
alter table admin drop primary key cascade;
alter table artist drop primary key cascade;
alter table album drop primary key cascade;
alter table bundle_master drop primary key cascade;
alter table music drop primary key cascade;
alter table theme drop primary key cascade;
alter table chart drop primary key cascade;
alter table genre drop primary key cascade;
alter table qna drop primary key cascade;
alter table adminqna drop primary key cascade;

-- drop table
drop table notice purge;
drop table qreply purge;
drop table qna purge;
drop table music_ban purge;
drop table music_like purge;
drop table album_like purge;
drop table artist_like purge;
drop table music_reply purge;
drop table music purge;
drop table album purge;
drop table artist purge;
drop table theme purge;
drop table chart purge;
drop table genre purge;
drop table bundle_master purge;
drop table bundle_detail purge;
drop table admin purge;
drop table member purge;
drop table adminqna purge;

-- drop sequence
call DropSequence('member_seq');
call DropSequence('admin_seq');
call DropSequence('music_seq');
call DropSequence('theme_seq');
call DropSequence('chart_seq');
call DropSequence('genre_seq');
call DropSequence('music_reply_seq');
call DropSequence('album_seq');
call DropSequence('artist_seq');
call DropSequence('qna_seq');
call DropSequence('notice_seq');
call DropSequence('qreply_seq');
call DropSequence('bundle_master_seq');
call DropSequence('bundle_detail_seq');
call DropSequence('adminqna_seq');

-- create sequence
call CreateSequence('member_seq', 1, 1);
call CreateSequence('admin_seq', 1, 1);
call CreateSequence('music_seq', 1, 1);
call CreateSequence('theme_seq', 1, 1);
call CreateSequence('chart_seq', 1, 1);
call CreateSequence('genre_seq', 1, 1);
call CreateSequence('music_reply_seq', 1, 1);
call CreateSequence('album_seq', 1, 1);
call CreateSequence('artist_seq', 1, 1);
call CreateSequence('qna_seq', 1, 1);
call CreateSequence('notice_seq', 1, 1);
call CreateSequence('qreply_seq', 1, 1);
call CreateSequence('bundle_master_seq', 1, 1);
call CreateSequence('bundle_detail_seq', 1, 1);
call CreateSequence('adminqna_seq', 1, 1);

-- create table
create table member(
	useq int primary key,
	id varchar(50) unique not null,
	pw varchar(20) not null,
	name varchar(30) not null,
	phone varchar(13) unique not null,
	gender varchar(1) not null,
	membership varchar(1) default 'N' not null, -- SQLINES DEMO *** Y, N 
	sdate datetime default sysdate(),	-- 이용권 시작일
 	edate datetime default sysdate(), -- 이용권 만료일
	indate datetime default sysdate()
);

create table admin(
	aseq smallint primary key,
	id varchar(20) not null,
	pw varchar(20) not null
);

-- SQLINES DEMO *** 추가시 테마/태그를 추가하여 번들제작시 효율적으로 관리하기 위함
create table theme(
	tseq int primary key,
	title varchar(100) unique not null,
	img varchar(100)
);

--  SQLINES DEMO *** 급상승 중 해외 소셜 차트 ...
create table chart(
	cseq int primary key,
	title varchar(100) unique not null,
	img varchar(100)
);

-- SQLINES DEMO *** 해외 팝 국내 댄스/일렉 국내 알앤비 국내 힙합 트로트 해외 알앤비 해외 힙합 ost/bgm 키즈 국내 인디 클래식 뉴에이지 국내 팝/어쿠스틱 해외 일렉트로닉 ccm 시원한 감성적인 슬픈 기쁜 댄스 발라드 ...
create table genre(
	gseq int primary key,
	title varchar(100) unique not null,
	img varchar(100)
);

create table artist (
	atseq int primary key,
	name varchar(30) not null,
	groupyn varchar(1) not null, -- SQLINES DEMO *** 로
	gender varchar(1) not null, -- SQLINES DEMO *** 성, a: 혼성
	gseq int references genre(gseq),
	img varchar2(300),
	description varchar2(1000)
);

create table album (
	abseq int primary key,
	atseq int references artist(atseq),
	title varchar2(100) not null,
	img varchar2(500),
	content varchar2(4000),
	abtype varchar2(20), -- SQLINES DEMO *** ��글, ost, 디지털싱글
	gseq number(5) references genre(gseq),
	pdate date not null -- SQLINES DEMO *** 필수
);

create table music(
	mseq int primary key,
	abseq int references album(abseq),
	atseq number(5) references artist(atseq),
	theme varchar2(1000), -- SQLINES DEMO *** 수) 구분자: |
	chart varchar2(100), 					-- SQLINES DEMO *** �분자: |
	gseq number(5) references genre(gseq), 	-- 장르(단일)
	title varchar2(300) not null,
	content varchar2(4000), 				-- 가사
	titleyn varchar2(1), 					-- SQLINES DEMO *** 일반
	musicby varchar2(500),					-- 작곡
	lyricsby varchar2(500),					-- 작사
	producingby varchar2(500),				-- 편곡
	src varchar2(200) 						-- 음악 재생경로
);

-- SQLINES DEMO *** 유저의 리스트
create table bundle_master (
	bmseq int primary key,
	useq int not null, -- SQLINES DEMO *** � 추가한 리스트, 유저시퀀스: 유저의 개인 리스트
	title varchar(300),
	useyn varchar(1) default 'Y', -- SQLINES DEMO *** 이트내의 리스트일 경우에만 핸들링)
	cdate datetime default sysdate()
);

-- SQLINES DEMO *** 유저의 리스트에 들어갈 곡
create table bundle_detail(
	bdseq int primary key,
	bmseq int references bundle_master(bmseq),
	mseq number(5) references music(mseq)
);

create table music_like(
	useq int references member(useq),
	mseq number(5) references music(mseq),
	cdate date default sysdate(),
	constraint music_like_pk primary key (useq, mseq) -- SQLINES DEMO *** r.useq와 music.mseq를 조합한 복합키)
);

create table album_like(
	useq int references member(useq),
	abseq number(5) references album(abseq),
	cdate date default sysdate(),
	constraint album_like_pk primary key (useq, abseq) -- SQLINES DEMO *** r.useq와 album.abseq를 조합한 복합키)
);

create table artist_like(
	useq int references member(useq),
	atseq number(5) references artist(atseq),
	cdate date default sysdate(),
	constraint artist_like_pk primary key (useq, atseq) -- SQLINES DEMO *** r.useq와 artist.atseq를 조합한 복합키)
);

create table music_reply(
	rseq int primary key,
	mseq int references music(mseq),
	useq number(5) references member(useq),
	content varchar2(1000) not null,
	wdate date default  sysdate()
);

create table music_ban(
	useq int references member(useq),
	mseq number(5) references music(mseq),
	cdate date default sysdate(),
	constraint music_ban_pk primary key (useq, mseq) -- SQLINES DEMO *** r.useq와 music.mseq를 조합한 복합키)
);

create table qna (
	qseq int primary key,
	useq int references member(useq),
	title varchar2(200) not null,
	content varchar2(3000),
	qna_date date default  sysdate()
);

create table qreply (
	qrseq int primary key,
	qseq int references qna(qseq),
	aseq number(5) references admin(aseq),
	useq number(5) references member(useq),
	content varchar2(3000),
	qreply_date date default  sysdate()
);

create table notice (
	nseq int primary key,
	title varchar(200) not null,
	content varchar(3000),
	notice_date datetime default  sysdate()
);

create table adminqna (
	adqseq int primary key,
	title varchar(200) not null,
	content varchar(1000),
	adqna_date datetime default  sysdate()
);

-- 테이블설명 
alter table member comment '사용자';
alter table admin comment '관리자';
alter table theme comment '테마/태그';
alter table chart comment '차트';
alter table genre comment '장르';
alter table artist comment '아티스트';
alter table album comment '앨범';
alter table music comment '곡';
alter table bundle_master comment '리스트 마스터';
alter table bundle_detail comment '리스트 상세';
alter table music_like comment '곡 좋아요';
alter table album_like comment '앨범 좋아요';
alter table artist_like comment '아티스트 좋아요';
alter table music_reply comment '곡 댓글';
alter table music_ban comment '곡 차단';
alter table qna comment '질문';
alter table qreply comment '답변';
alter table notice comment '공지사항';

-- 뷰 정의

create or replace view music_view -- 뮤직
as
select
    m.mseq
    , m.title
    , m.content
    , m.theme
    , m.chart
    , m.gseq
    , m.titleyn
    , m.src
    , m.musicby
    , m.lyricsby
    , m.producingby
    , ab.abseq
    , ab.title as abtitle
    , ab.img as abimg
    , ab.content as abcontent
    , ab.pdate as pdate
    , ab.abtype
    , ab.gseq as abgseq
    , at.atseq
    , at.name
    , at.groupyn
    , at.gender
    , at.gseq as atgseq
    , at.img as atimg
    , at.description
    , g.title as gtitle
	, mpopular.rank -- SQLINES DEMO *** 아요 수 > 음악시퀀스)
    , mpopular.likecount -- 좋아요 수
from music m
    left join album ab
        on m.abseq = ab.abseq
    left join artist at
        on at.atseq = m.atseq and at.atseq = ab.atseq
    left join genre g
        on g.gseq = at.gseq
    left join (
        select
            m.mseq -- 음악시퀀스
            , rank() over (
                order by
                    ifnull(musiclike.likecount, 0) desc -- SQLINES DEMO *** ��재 우선순위 : 좋아요 수 내림차순(likecount없으면 0으로 변경 후 순위측정)
                    , m.mseq desc                   -- SQLINES DEMO *** ��째 우선순위 : 음악시퀀스 내림차순
                ) as rank -- 순위
            , ifnull(musiclike.likecount, 0) as likecount -- SQLINES DEMO *** 으면 0)
        from music m
            left join (
                select mseq, count(*) as likecount from music_like group by mseq
            ) musiclike on musiclike.mseq = m.mseq
    ) mpopular -- SQLINES DEMO *** �� (좋아요 수 > 음악시퀀스)
        on mpopular.mseq = m.mseq;

create or replace view album_view -- 앨범
as
select 
    ab.abseq
    , ab.title
    , ab.img
    , ab.content
    , ab.pdate
	, ab.abtype
	, ab.gseq
    , abg.title as abgenre
    , at.atseq
    , at.name
    , at.groupyn
    , at.gender
    , at.gseq as atgseq
    , at.img as atimg
    , at.description
	, atg.title as atgenre
    , abpopular.rank -- SQLINES DEMO *** 아요 수 > 발매일 최신순 > 앨범시퀀스)
    , abpopular.likecount -- 좋아요 수
	, ifnull(mucountbyalbum.mucount, 0) as mucount -- 음악수
from album ab
    left join artist at
    	on at.atseq = ab.atseq
    left join genre abg
        on abg.gseq = ab.gseq
	left join genre atg
		on atg.gseq = at.gseq
    left join (
        select
            ab.abseq
            , rank() over (
                order by
                    ifnull(albumlike.likecount, 0) desc -- SQLINES DEMO *** ��째 좋아요수
                    , ab.pdate desc -- SQLINES DEMO *** ��째 발매일최신순(null일 경우 순위 겹침)
                    , ab.abseq desc -- SQLINES DEMO *** ��째 앨범시퀀스
                ) as rank
            , ifnull(albumlike.likecount, 0) as likecount
        from album ab
            left join (
                select abseq, count(*) as likecount from album_like group by abseq
            ) albumlike -- SQLINES DEMO *** �� 수
                on albumlike.abseq = ab.abseq
    ) abpopular -- SQLINES DEMO *** ��(좋아요수 > 발매일 > 앨범시퀀스)
        on abpopular.abseq = ab.abseq
	left join (
		select count(*) as mucount, abseq from music group by abseq
	) mucountbyalbum -- 앨범별 곡수
		on mucountbyalbum.abseq = ab.abseq;

create or replace view artist_view -- 아티스트
as
select 
    at.atseq
	, at.name
	, at.groupyn
	, at.gender
	, at.gseq
	, at.img
	, at.description
	, g.title as atgenre
    , atpopular.rank -- SQLINES DEMO *** 아요 수 > 아티스트 시퀀스)
    , atpopular.likecount -- 좋아요 수
	, ifnull(abcountbyartist.abcount, 0) as abcount -- 앨범수
	, ifnull(mucountbyartist.mucount, 0) as mucount -- 음악수
from artist at
	left join genre g
		on g.gseq = at.gseq
    left join (
        select
            at.atseq
            , rank() over(
                order by
                    ifnull(artistlike.likecount, 0) desc -- SQLINES DEMO *** ��째 좋아요수
                    , at.atseq desc -- SQLINES DEMO *** � 순서
            ) as rank
            , ifnull(artistlike.likecount, 0) as likecount
        from artist at
            left join (
                select atseq, count(*) as likecount from artist_like group by atseq
            ) artistlike -- SQLINES DEMO *** ��요 수
                on artistlike.atseq = at.atseq
    ) atpopular -- SQLINES DEMO *** ��순위(좋아요 수 > 아티스트 시퀀스)
        on atpopular.atseq = at.atseq
	left join (
		select count(*) as abcount, atseq from album group by atseq
	) abcountbyartist -- SQLINES DEMO *** ��범수
		on abcountbyartist.atseq = at.atseq
	left join (
		select count(*) as mucount, atseq from music group by atseq
	) mucountbyartist -- SQLINES DEMO *** ��수
		on mucountbyartist.atseq = at.atseq;

create or replace view likemusic_view
as
select 
    m.mseq
    , m.title
    , m.gseq
    , ab.abseq
    , ab.img as abimg
    , ab.title as abtitle
    , at.atseq
    , at.name
    , ml.useq
    , ml.cdate
from music m, music_like ml, album ab, artist at
where m.mseq = ml.mseq and ab.abseq = m.abseq and at.atseq = ab.atseq;

-- SQLINES LICENSE FOR EVALUATION USE ONLY
select * from likemusic_view;

create or replace view likeartist_view
as
select 
    at.atseq
	, at.name
	, at.groupyn
	, at.gender
	, at.gseq
	, g.title as atgenre
	, at.img
	, al.useq
	, al.cdate
	from artist at, artist_like al, genre g
	where al.atseq = at.atseq and g.gseq = at.gseq;

-- SQLINES LICENSE FOR EVALUATION USE ONLY
select * from likeartist_view;

create or replace view likealbum_view
as
select 
    ab.abseq
    , ab.atseq
    , ab.title
    , ab.img
	, ab.pdate
	, ab.abtype
	, at.name
	, g.title as abgenre
	, at.gseq
	, abl.useq
	, abl.cdate
	from album ab, album_like abl, artist at, genre g
	where abl.abseq = ab.abseq and ab.atseq = at.atseq and g.gseq = ab.gseq;

create or replace view qna_view as
select 
    q.qseq
    , q.useq
	, q.title
	, q.content as qnacontent
	, q.qna_date
	, qr.qrseq
	, qr.content as replycontent
	, qr.qreply_date
	from qna q left join qreply qr on q.useq = qr.useq and q.qseq = qr.qseq;
-- SQLINES LICENSE FOR EVALUATION USE ONLY
select * from qna_view;

create or replace view bundle_view
as
select 
	bm.*
	, (select count(*) from bundle_detail where bmseq = bm.bmseq) as mucount
from bundle_master bm
where bm.useq = 0;