insert into tweet.users (userid, uname, nickname, bio)
     values (default, 'Theseus', 'Duke Theseus', 'Duke of Athens.');

insert into tweet.users (uname, bio)
     values ('Egeus', 'father to #Hermia.'),
            ('Lysander', 'in love with #Hermia.'),
            ('Demetrius', 'in love with #Hermia.'),
            ('Philostrate', 'master of the revels to Theseus.'),
            ('Peter Quince', 'a carpenter.'),
            ('Snug', 'a joiner.'),
            ('Nick Bottom', 'a weaver.'),
            ('Francis Flute', 'a bellows-mender.'),
            ('Tom Snout', 'a tinker.'),
            ('Robin Starveling', 'a tailor.'),
            ('Hippolyta', 'queen of the Amazons, betrothed to Theseus.'),
            ('Hermia', 'daughter to Egeus, in love with Lysander.'),
            ('Helena', 'in love with Demetrius.'),
            ('Oberon', 'king of the fairies.'),
            ('Titania', 'queen of the fairies.'),
            ('Puck', 'or Robin Goodfellow.'),
            ('Peaseblossom', 'Team #Fairies'),
            ('Cobweb', 'Team #Fairies'),
            ('Moth', 'Team #Fairies'),
            ('Mustardseed', 'Team #Fairies'),
            ('All', 'Everyone speaking at the same time'),
            ('Fairy', 'One of them #Fairies'),
            ('Prologue', 'a play within a play'),
            ('Wall', 'a play within a play'),
            ('Pyramus', 'a play within a play'),
            ('Thisbe', 'a play within a play'),
            ('Lion', 'a play within a play'),
            ('Moonshine', 'a play within a play');

insert into tweet.message  (messageid, userid, datetime, message, favs, rts, lang, url)
values (4, 1, Now(), 'test', 1, 0, 'pt-br', 'http://www.google.com');

listen "tweet.activity";

insert into tweet.activity(messageid, action)
     values (1, 'rt'),
            (2, 'rt'),
            (3, 'de-rt'),
            (4, 'fav');