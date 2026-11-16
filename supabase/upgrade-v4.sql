-- Spot Duel V4 upgrade: run once AFTER schema.sql, upgrade-v2.sql, upgrade-v3.sql.
-- Creates a private 120-question bank. Old matches should be abandoned after migration.
-- Only the authenticated RPCs below access answers; never grant SELECT on this table.
create table if not exists public.duel_v4_puzzles (
  id integer primary key check(id between 1 and 120),
  category text not null,
  question text not null,
  question_ar text not null,
  explanation text not null,
  options jsonb not null,
  correct_choice integer not null check(correct_choice between 1 and 4)
);
alter table public.duel_v4_puzzles enable row level security;
revoke all on public.duel_v4_puzzles from public,anon,authenticated;
insert into public.duel_v4_puzzles (id,category,question,question_ar,explanation,options,correct_choice) values
(1,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["water-6", "water-2", "juice-3", "water-4"]',3),
(2,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["water-2", "water-5", "soda-5", "water-1"]',3),
(3,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["water-5", "water-6", "juice-5", "water-4"]',3),
(4,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["water-6", "water-2", "water-1", "soda-5"]',4),
(5,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["juice-2", "water-4", "water-6", "water-1"]',1),
(6,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["soda-4", "water-4", "water-1", "water-2"]',1),
(7,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["water-5", "water-6", "juice-4", "water-2"]',3),
(8,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["water-6", "soda-4", "water-4", "water-2"]',2),
(9,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["water-3", "water-5", "water-2", "juice-3"]',4),
(10,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["soda-5", "water-6", "water-1", "water-4"]',1),
(11,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["juice-4", "water-2", "water-4", "water-5"]',1),
(12,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["soda-1", "water-2", "water-1", "water-4"]',1),
(13,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["juice-3", "water-6", "water-2", "water-3"]',1),
(14,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["water-4", "water-3", "soda-4", "water-5"]',3),
(15,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["juice-1", "water-5", "water-6", "water-1"]',1),
(16,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["water-4", "water-5", "soda-5", "water-1"]',3),
(17,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["water-4", "water-6", "juice-5", "water-2"]',3),
(18,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["water-1", "water-3", "soda-6", "water-6"]',3),
(19,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the juice category.','["water-1", "juice-2", "water-2", "water-4"]',2),
(20,'water','Which one is NOT drinking water?','Chkon machi ma2 lchrob?','The odd product is not water. It belongs to the soda category.','["water-5", "soda-6", "water-4", "water-2"]',2),
(21,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["cream-3", "shampoo-5", "shampoo-1", "shampoo-4"]',1),
(22,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-4", "cream-1", "shampoo-3", "shampoo-6"]',2),
(23,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-1", "shampoo-6", "cream-1", "shampoo-3"]',3),
(24,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-6", "shampoo-5", "cream-6", "shampoo-4"]',3),
(25,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-2", "shampoo-4", "cream-2", "shampoo-3"]',3),
(26,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["cream-4", "shampoo-3", "shampoo-2", "shampoo-4"]',1),
(27,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-3", "shampoo-5", "shampoo-2", "cream-1"]',4),
(28,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-3", "shampoo-5", "shampoo-2", "cream-1"]',4),
(29,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-1", "cream-3", "shampoo-6", "shampoo-2"]',2),
(30,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-3", "cream-3", "shampoo-5", "shampoo-4"]',2),
(31,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-1", "shampoo-3", "cream-2", "shampoo-2"]',3),
(32,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["cream-1", "shampoo-3", "shampoo-1", "shampoo-4"]',1),
(33,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-2", "shampoo-4", "shampoo-3", "cream-4"]',4),
(34,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-3", "shampoo-2", "shampoo-1", "cream-3"]',4),
(35,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-6", "shampoo-5", "cream-6", "shampoo-4"]',3),
(36,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-5", "cream-2", "shampoo-2", "shampoo-1"]',2),
(37,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["cream-1", "shampoo-3", "shampoo-6", "shampoo-4"]',1),
(38,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-1", "shampoo-2", "cream-3", "shampoo-5"]',3),
(39,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["cream-3", "shampoo-5", "shampoo-4", "shampoo-3"]',1),
(40,'shampoo','Which one is NOT shampoo?','Chkon machi shampoo?','The odd product is not shampoo; shampoo is used to wash hair. It belongs to the cream category.','["shampoo-2", "shampoo-1", "cream-4", "shampoo-6"]',3),
(41,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-3", "cream-4", "shampoo-4", "cream-6"]',3),
(42,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-6", "shampoo-4", "cream-4", "cream-3"]',2),
(43,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-6", "cream-4", "cream-5", "shampoo-1"]',4),
(44,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-2", "cream-3", "shampoo-1", "cream-1"]',3),
(45,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-3", "cream-4", "cream-2", "shampoo-3"]',4),
(46,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["shampoo-5", "cream-1", "cream-3", "cream-6"]',1),
(47,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-1", "shampoo-5", "cream-5", "cream-2"]',2),
(48,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["shampoo-4", "cream-3", "cream-4", "cream-2"]',1),
(49,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["shampoo-6", "cream-2", "cream-1", "cream-4"]',1),
(50,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-6", "cream-1", "cream-3", "shampoo-4"]',4),
(51,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-4", "shampoo-4", "cream-1", "cream-2"]',2),
(52,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-4", "cream-6", "shampoo-6", "cream-1"]',3),
(53,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-2", "shampoo-4", "cream-3", "cream-6"]',2),
(54,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["shampoo-6", "cream-5", "cream-2", "cream-6"]',1),
(55,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-4", "cream-5", "shampoo-2", "cream-3"]',3),
(56,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-4", "cream-3", "shampoo-4", "cream-5"]',3),
(57,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-6", "cream-4", "shampoo-6", "cream-3"]',3),
(58,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-5", "shampoo-3", "cream-2", "cream-3"]',2),
(59,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-5", "cream-4", "shampoo-1", "cream-3"]',3),
(60,'cream','Which one is NOT skin cream?','Chkon machi crème dyal lbechra?','The odd product is not a skincare cream. It belongs to the shampoo category.','["cream-5", "cream-2", "shampoo-5", "cream-3"]',3),
(61,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["chocolate-6", "juice-4", "chocolate-1", "chocolate-5"]',2),
(62,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["chocolate-5", "chocolate-1", "chocolate-4", "soda-2"]',4),
(63,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["chocolate-5", "chocolate-1", "juice-3", "chocolate-6"]',3),
(64,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["chocolate-3", "chocolate-2", "chocolate-1", "soda-3"]',4),
(65,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["chocolate-2", "chocolate-6", "chocolate-5", "juice-1"]',4),
(66,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["chocolate-1", "chocolate-5", "soda-5", "chocolate-6"]',3),
(67,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["chocolate-1", "chocolate-6", "chocolate-5", "juice-5"]',4),
(68,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["chocolate-1", "chocolate-3", "soda-4", "chocolate-5"]',3),
(69,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["chocolate-5", "juice-4", "chocolate-6", "chocolate-2"]',2),
(70,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["chocolate-6", "chocolate-1", "soda-5", "chocolate-4"]',3),
(71,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["chocolate-6", "chocolate-3", "chocolate-5", "juice-5"]',4),
(72,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["chocolate-6", "chocolate-3", "soda-6", "chocolate-1"]',3),
(73,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["chocolate-1", "chocolate-2", "chocolate-6", "juice-1"]',4),
(74,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["chocolate-2", "chocolate-4", "soda-4", "chocolate-6"]',3),
(75,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["chocolate-1", "chocolate-6", "chocolate-2", "juice-3"]',4),
(76,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["soda-1", "chocolate-5", "chocolate-4", "chocolate-6"]',1),
(77,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["chocolate-6", "chocolate-2", "chocolate-3", "juice-5"]',4),
(78,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["soda-1", "chocolate-2", "chocolate-5", "chocolate-6"]',1),
(79,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the juice category.','["juice-3", "chocolate-2", "chocolate-3", "chocolate-4"]',1),
(80,'chocolate','Which one is NOT a chocolate bar?','Chkon machi chocolat?','The odd product is not a chocolate bar. It belongs to the soda category.','["chocolate-5", "soda-3", "chocolate-3", "chocolate-1"]',2),
(81,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["soda-6", "soda-1", "soda-5", "juice-1"]',4),
(82,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["soda-1", "soda-2", "water-3", "soda-3"]',3),
(83,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["soda-1", "juice-2", "soda-2", "soda-4"]',2),
(84,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["soda-5", "water-6", "soda-3", "soda-1"]',2),
(85,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["juice-3", "soda-4", "soda-1", "soda-2"]',1),
(86,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["soda-1", "soda-2", "water-4", "soda-4"]',3),
(87,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["soda-1", "soda-4", "juice-6", "soda-2"]',3),
(88,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["soda-6", "soda-3", "soda-2", "water-2"]',4),
(89,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["juice-2", "soda-6", "soda-2", "soda-3"]',1),
(90,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["soda-2", "water-5", "soda-6", "soda-1"]',2),
(91,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["juice-5", "soda-6", "soda-2", "soda-3"]',1),
(92,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["soda-6", "water-4", "soda-3", "soda-2"]',2),
(93,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["soda-5", "juice-3", "soda-1", "soda-6"]',2),
(94,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["soda-1", "soda-3", "soda-2", "water-6"]',4),
(95,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["soda-1", "soda-6", "soda-5", "juice-2"]',4),
(96,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["soda-2", "soda-6", "water-4", "soda-4"]',3),
(97,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["juice-2", "soda-6", "soda-1", "soda-4"]',1),
(98,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["water-6", "soda-4", "soda-6", "soda-5"]',1),
(99,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the juice category.','["soda-2", "soda-5", "juice-5", "soda-4"]',3),
(100,'soda','Which one is NOT a soft drink?','Chkon machi soda?','The odd product is not a carbonated soft drink. It belongs to the water category.','["water-6", "soda-1", "soda-5", "soda-3"]',1),
(101,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["soda-6", "juice-5", "juice-3", "juice-1"]',1),
(102,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["water-2", "juice-4", "juice-2", "juice-3"]',1),
(103,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["juice-4", "juice-3", "juice-5", "soda-3"]',4),
(104,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["juice-1", "juice-3", "water-4", "juice-6"]',3),
(105,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["juice-5", "juice-2", "soda-6", "juice-4"]',3),
(106,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["juice-1", "water-2", "juice-5", "juice-2"]',2),
(107,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["soda-4", "juice-1", "juice-2", "juice-4"]',1),
(108,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["juice-4", "juice-6", "water-4", "juice-3"]',3),
(109,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["juice-4", "juice-2", "juice-6", "soda-5"]',4),
(110,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["juice-5", "water-4", "juice-4", "juice-2"]',2),
(111,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["juice-4", "juice-2", "soda-6", "juice-3"]',3),
(112,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["water-1", "juice-1", "juice-4", "juice-5"]',1),
(113,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["juice-4", "juice-2", "juice-6", "soda-5"]',4),
(114,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["water-1", "juice-6", "juice-5", "juice-4"]',1),
(115,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["juice-5", "soda-4", "juice-2", "juice-6"]',2),
(116,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["juice-3", "water-1", "juice-6", "juice-1"]',2),
(117,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["juice-5", "soda-1", "juice-3", "juice-2"]',2),
(118,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["juice-3", "juice-2", "juice-4", "water-6"]',4),
(119,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the soda category.','["soda-5", "juice-3", "juice-5", "juice-6"]',1),
(120,'juice','Which one is NOT fruit juice?','Chkon machi jus?','The odd product is not fruit juice. It belongs to the water category.','["water-3", "juice-4", "juice-6", "juice-1"]',1)
on conflict (id) do update set category=excluded.category,question=excluded.question,question_ar=excluded.question_ar,explanation=excluded.explanation,options=excluded.options,correct_choice=excluded.correct_choice;

-- V3 attempt table has FK to rounds 1..10: remove that FK so round count can become 20.
alter table public.duel_odd_attempts drop constraint if exists duel_odd_attempts_round_no_fkey;
alter table public.duel_odd_attempts drop constraint if exists duel_odd_attempts_round_no_check;
alter table public.duel_odd_attempts drop constraint if exists duel_v4_round_limit;
alter table public.duel_odd_attempts add constraint duel_v4_round_limit check(round_no between 1 and 20);

create or replace function public.duel_state(p_code text)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; v_round integer; q public.duel_v4_puzzles%rowtype; v_id integer;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select * into v from public.duel_rooms where code=upper(trim(p_code));
 if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then raise exception 'Room not found or access denied'; end if;
 select count(*) into v_round from public.duel_odd_attempts where room_id=v.id and player_id=auth.uid();
 v_id := (((abs(hashtext(v.code)::bigint) % 120)::integer + v_round*37) % 120)+1;
 if v_round < 20 then select * into q from public.duel_v4_puzzles where id=v_id; end if;
 return jsonb_build_object(
   'code',v.code,'is_host',v.host_id=auth.uid(),
   'host_name',v.host_name,'guest_name',v.guest_name,
   'host_ready',v.host_ready,'guest_ready',v.guest_ready,
   'host_score',v.host_score,'guest_score',v.guest_score,
   'host_finished_at',v.host_finished_at,'guest_finished_at',v.guest_finished_at,
   'started_at',v.started_at,'ends_at',v.ends_at,'my_round',v_round,
   'question',case when v_round<20 then q.question else null end,
   'question_ar',case when v_round<20 then q.question_ar else null end,
   'options',case when v_round<20 then q.options else null end,
   'category',case when v_round<20 then q.category else null end
 );
end $$;

create or replace function public.duel_choose(p_code text,p_round integer,p_choice integer)
returns jsonb language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; v_expected int; q public.duel_v4_puzzles%rowtype; v_correct boolean; v_count int; v_score int; v_id int;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 if p_round not between 1 and 20 or p_choice not between 1 and 4 then raise exception 'Invalid choice'; end if;
 select * into v from public.duel_rooms where code=upper(trim(p_code)) for update;
 if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then raise exception 'Not a room member'; end if;
 if v.started_at is null or now()<v.started_at or now()>=v.ends_at then return jsonb_build_object('result','not_active'); end if;
 if (auth.uid()=v.host_id and v.host_finished_at is not null) or
    (auth.uid()=v.guest_id and v.guest_finished_at is not null) then
    return jsonb_build_object('result','complete');
 end if;
 select count(*)+1 into v_expected from public.duel_odd_attempts where room_id=v.id and player_id=auth.uid();
 if p_round<>v_expected then raise exception 'Round out of order or already answered'; end if;
 v_id := (((abs(hashtext(v.code)::bigint) % 120)::integer + (p_round-1)*37) % 120)+1;
 select * into q from public.duel_v4_puzzles where id=v_id;
 if not found then raise exception 'Question bank not installed'; end if;
 v_correct := p_choice=q.correct_choice;
 insert into public.duel_odd_attempts(room_id,player_id,round_no,chosen,correct)
 values(v.id,auth.uid(),p_round,p_choice,v_correct);
 select count(*),count(*) filter(where correct) into v_count,v_score
 from public.duel_odd_attempts where room_id=v.id and player_id=auth.uid();
 update public.duel_rooms set
 host_score=case when host_id=auth.uid() then v_score else host_score end,
 guest_score=case when guest_id=auth.uid() then v_score else guest_score end,
 host_finished_at=case when host_id=auth.uid() and v_count=20 then now() else host_finished_at end,
 guest_finished_at=case when guest_id=auth.uid() and v_count=20 then now() else guest_finished_at end
 where id=v.id;
 return jsonb_build_object('result','answered','correct',v_correct,'answered',v_count,'score',v_score,
 'correct_choice',q.correct_choice,'explanation',q.explanation);
end $$;

create or replace function public.duel_ready(p_code text)
returns void language plpgsql security definer set search_path = '' as $$
declare v public.duel_rooms%rowtype; h boolean; g boolean;
begin
 if auth.uid() is null then raise exception 'Authentication required'; end if;
 select * into v from public.duel_rooms where code=upper(trim(p_code)) for update;
 if not found or (auth.uid()<>v.host_id and auth.uid() is distinct from v.guest_id) then raise exception 'Not a room member'; end if;
 if v.guest_id is null then raise exception 'Wait for your opponent'; end if;
 if v.started_at is not null then return; end if;
 h:=v.host_ready or v.host_id=auth.uid(); g:=v.guest_ready or v.guest_id=auth.uid();
 update public.duel_rooms set host_ready=h,guest_ready=g,
 started_at=case when h and g then now()+interval '3 seconds' else null end,
 ends_at=case when h and g then now()+interval '303 seconds' else null end
 where id=v.id;
end $$;
revoke all on function public.duel_state(text) from public,anon;
revoke all on function public.duel_choose(text,integer,integer) from public,anon;
grant execute on function public.duel_state(text) to authenticated;
grant execute on function public.duel_choose(text,integer,integer) to authenticated;
