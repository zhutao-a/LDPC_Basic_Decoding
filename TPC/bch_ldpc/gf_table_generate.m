function  gf_table=gf_table_generate()%����gf(2^8)�Ĳ��ұ�,��ԭ����ʽΪp(x)=x^8+x^4+x^3+x^2+1
gf_table=zeros(256,8);%�ʹ�����ǰ���ߴ����ں�
gf_table(1 ,:) =  [1,0,0,0,0,0,0,0];%a^0
gf_table(2 ,:) =  [0,1,0,0,0,0,0,0];%a^1
gf_table(3 ,:) =  [0,0,1,0,0,0,0,0];%a^2
gf_table(4 ,:) =  [0,0,0,1,0,0,0,0];%a^3
gf_table(5 ,:) =  [0,0,0,0,1,0,0,0];%a^4
gf_table(6 ,:) =  [0,0,0,0,0,1,0,0];%a^5
gf_table(7 ,:) =  [0,0,0,0,0,0,1,0];%a^6
gf_table(8 ,:) =  [0,0,0,0,0,0,0,1];%a^7
gf_table(9 ,:) =  [1,0,1,1,1,0,0,0];%a^8=a^4+a^3+a^2+1
gf_table(10 ,:) = [0,1,0,1,1,1,0,0];%a^9=a^5+a^4+a^3+a
gf_table(11 ,:) = [0,0,1,0,1,1,1,0];
gf_table(12 ,:) = [0,0,0,1,0,1,1,1];
gf_table(13 ,:) = [1,0,1,1,0,0,1,1];
gf_table(14 ,:) = [1,1,1,0,0,0,0,1];
gf_table(15 ,:) = [1,1,0,0,1,0,0,0];
gf_table(16 ,:) = [0,1,1,0,0,1,0,0];
gf_table(17 ,:) = [0,0,1,1,0,0,1,0];
gf_table(18 ,:) = [0,0,0,1,1,0,0,1];
gf_table(19 ,:) = [1,0,1,1,0,1,0,0];
gf_table(20 ,:) = [0,1,0,1,1,0,1,0];
gf_table(21 ,:) = [0,0,1,0,1,1,0,1];
gf_table(22 ,:) = [1,0,1,0,1,1,1,0];
gf_table(23 ,:) = [0,1,0,1,0,1,1,1];
gf_table(24 ,:) = [1,0,0,1,0,0,1,1];
gf_table(25 ,:) = [1,1,1,1,0,0,0,1];
gf_table(26 ,:) = [1,1,0,0,0,0,0,0];
gf_table(27 ,:) = [0,1,1,0,0,0,0,0];
gf_table(28 ,:) = [0,0,1,1,0,0,0,0];
gf_table(29 ,:) = [0,0,0,1,1,0,0,0];
gf_table(30 ,:) = [0,0,0,0,1,1,0,0];
gf_table(31 ,:) = [0,0,0,0,0,1,1,0];
gf_table(32 ,:) = [0,0,0,0,0,0,1,1];
gf_table(33 ,:) = [1,0,1,1,1,0,0,1];
gf_table(34 ,:) = [1,1,1,0,0,1,0,0];
gf_table(35 ,:) = [0,1,1,1,0,0,1,0];
gf_table(36 ,:) = [0,0,1,1,1,0,0,1];
gf_table(37 ,:) = [1,0,1,0,0,1,0,0];
gf_table(38 ,:) = [0,1,0,1,0,0,1,0];
gf_table(39 ,:) = [0,0,1,0,1,0,0,1];
gf_table(40 ,:) = [1,0,1,0,1,1,0,0];
gf_table(41 ,:) = [0,1,0,1,0,1,1,0];
gf_table(42 ,:) = [0,0,1,0,1,0,1,1];
gf_table(43 ,:) = [1,0,1,0,1,1,0,1];
gf_table(44 ,:) = [1,1,1,0,1,1,1,0];
gf_table(45 ,:) = [0,1,1,1,0,1,1,1];
gf_table(46 ,:) = [1,0,0,0,0,0,1,1];
gf_table(47 ,:) = [1,1,1,1,1,0,0,1];
gf_table(48 ,:) = [1,1,0,0,0,1,0,0];
gf_table(49 ,:) = [0,1,1,0,0,0,1,0];
gf_table(50 ,:) = [0,0,1,1,0,0,0,1];
gf_table(51 ,:) = [1,0,1,0,0,0,0,0];
gf_table(52 ,:) = [0,1,0,1,0,0,0,0];
gf_table(53 ,:) = [0,0,1,0,1,0,0,0];
gf_table(54 ,:) = [0,0,0,1,0,1,0,0];
gf_table(55 ,:) = [0,0,0,0,1,0,1,0];
gf_table(56 ,:) = [0,0,0,0,0,1,0,1];
gf_table(57 ,:) = [1,0,1,1,1,0,1,0];
gf_table(58 ,:) = [0,1,0,1,1,1,0,1];
gf_table(59 ,:) = [1,0,0,1,0,1,1,0];
gf_table(60 ,:) = [0,1,0,0,1,0,1,1];
gf_table(61 ,:) = [1,0,0,1,1,1,0,1];
gf_table(62 ,:) = [1,1,1,1,0,1,1,0];
gf_table(63 ,:) = [0,1,1,1,1,0,1,1];
gf_table(64 ,:) = [1,0,0,0,0,1,0,1];
gf_table(65 ,:) = [1,1,1,1,1,0,1,0];
gf_table(66 ,:) = [0,1,1,1,1,1,0,1];
gf_table(67 ,:) = [1,0,0,0,0,1,1,0];
gf_table(68 ,:) = [0,1,0,0,0,0,1,1];
gf_table(69 ,:) = [1,0,0,1,1,0,0,1];
gf_table(70 ,:) = [1,1,1,1,0,1,0,0];
gf_table(71 ,:) = [0,1,1,1,1,0,1,0];
gf_table(72 ,:) = [0,0,1,1,1,1,0,1];
gf_table(73 ,:) = [1,0,1,0,0,1,1,0];
gf_table(74 ,:) = [0,1,0,1,0,0,1,1];
gf_table(75 ,:) = [1,0,0,1,0,0,0,1];
gf_table(76 ,:) = [1,1,1,1,0,0,0,0];
gf_table(77 ,:) = [0,1,1,1,1,0,0,0];
gf_table(78 ,:) = [0,0,1,1,1,1,0,0];
gf_table(79 ,:) = [0,0,0,1,1,1,1,0];
gf_table(80 ,:) = [0,0,0,0,1,1,1,1];
gf_table(81 ,:) = [1,0,1,1,1,1,1,1];
gf_table(82 ,:) = [1,1,1,0,0,1,1,1];
gf_table(83 ,:) = [1,1,0,0,1,0,1,1];
gf_table(84 ,:) = [1,1,0,1,1,1,0,1];
gf_table(85 ,:) = [1,1,0,1,0,1,1,0];
gf_table(86 ,:) = [0,1,1,0,1,0,1,1];
gf_table(87 ,:) = [1,0,0,0,1,1,0,1];
gf_table(88 ,:) = [1,1,1,1,1,1,1,0];
gf_table(89 ,:) = [0,1,1,1,1,1,1,1];
gf_table(90 ,:) = [1,0,0,0,0,1,1,1];
gf_table(91 ,:) = [1,1,1,1,1,0,1,1];
gf_table(92 ,:) = [1,1,0,0,0,1,0,1];
gf_table(93 ,:) = [1,1,0,1,1,0,1,0];
gf_table(94 ,:) = [0,1,1,0,1,1,0,1];
gf_table(95 ,:) = [1,0,0,0,1,1,1,0];
gf_table(96 ,:) = [0,1,0,0,0,1,1,1];
gf_table(97 ,:) = [1,0,0,1,1,0,1,1];
gf_table(98 ,:) = [1,1,1,1,0,1,0,1];
gf_table(99 ,:) = [1,1,0,0,0,0,1,0];
gf_table(100,:) = [0,1,1,0,0,0,0,1];
gf_table(101,:) = [1,0,0,0,1,0,0,0];
gf_table(102,:) = [0,1,0,0,0,1,0,0];
gf_table(103,:) = [0,0,1,0,0,0,1,0];
gf_table(104,:) = [0,0,0,1,0,0,0,1];
gf_table(105,:) = [1,0,1,1,0,0,0,0];
gf_table(106,:) = [0,1,0,1,1,0,0,0];
gf_table(107,:) = [0,0,1,0,1,1,0,0];
gf_table(108,:) = [0,0,0,1,0,1,1,0];
gf_table(109,:) = [0,0,0,0,1,0,1,1];
gf_table(110,:) = [1,0,1,1,1,1,0,1];
gf_table(111,:) = [1,1,1,0,0,1,1,0];
gf_table(112,:) = [0,1,1,1,0,0,1,1];
gf_table(113,:) = [1,0,0,0,0,0,0,1];
gf_table(114,:) = [1,1,1,1,1,0,0,0];
gf_table(115,:) = [0,1,1,1,1,1,0,0];
gf_table(116,:) = [0,0,1,1,1,1,1,0];
gf_table(117,:) = [0,0,0,1,1,1,1,1];
gf_table(118,:) = [1,0,1,1,0,1,1,1];
gf_table(119,:) = [1,1,1,0,0,0,1,1];
gf_table(120,:) = [1,1,0,0,1,0,0,1];
gf_table(121,:) = [1,1,0,1,1,1,0,0];
gf_table(122,:) = [0,1,1,0,1,1,1,0];
gf_table(123,:) = [0,0,1,1,0,1,1,1];
gf_table(124,:) = [1,0,1,0,0,0,1,1];
gf_table(125,:) = [1,1,1,0,1,0,0,1];
gf_table(126,:) = [1,1,0,0,1,1,0,0];
gf_table(127,:) = [0,1,1,0,0,1,1,0];
gf_table(128,:) = [0,0,1,1,0,0,1,1];
gf_table(129,:) = [1,0,1,0,0,0,0,1];
gf_table(130,:) = [1,1,1,0,1,0,0,0];
gf_table(131,:) = [0,1,1,1,0,1,0,0];
gf_table(132,:) = [0,0,1,1,1,0,1,0];
gf_table(133,:) = [0,0,0,1,1,1,0,1];
gf_table(134,:) = [1,0,1,1,0,1,1,0];
gf_table(135,:) = [0,1,0,1,1,0,1,1];
gf_table(136,:) = [1,0,0,1,0,1,0,1];
gf_table(137,:) = [1,1,1,1,0,0,1,0];
gf_table(138,:) = [0,1,1,1,1,0,0,1];
gf_table(139,:) = [1,0,0,0,0,1,0,0];
gf_table(140,:) = [0,1,0,0,0,0,1,0];
gf_table(141,:) = [0,0,1,0,0,0,0,1];
gf_table(142,:) = [1,0,1,0,1,0,0,0];
gf_table(143,:) = [0,1,0,1,0,1,0,0];
gf_table(144,:) = [0,0,1,0,1,0,1,0];
gf_table(145,:) = [0,0,0,1,0,1,0,1];
gf_table(146,:) = [1,0,1,1,0,0,1,0];
gf_table(147,:) = [0,1,0,1,1,0,0,1];
gf_table(148,:) = [1,0,0,1,0,1,0,0];
gf_table(149,:) = [0,1,0,0,1,0,1,0];
gf_table(150,:) = [0,0,1,0,0,1,0,1];
gf_table(151,:) = [1,0,1,0,1,0,1,0];
gf_table(152,:) = [0,1,0,1,0,1,0,1];
gf_table(153,:) = [1,0,0,1,0,0,1,0];
gf_table(154,:) = [0,1,0,0,1,0,0,1];
gf_table(155,:) = [1,0,0,1,1,1,0,0];
gf_table(156,:) = [0,1,0,0,1,1,1,0];
gf_table(157,:) = [0,0,1,0,0,1,1,1];
gf_table(158,:) = [1,0,1,0,1,0,1,1];
gf_table(159,:) = [1,1,1,0,1,1,0,1];
gf_table(160,:) = [1,1,0,0,1,1,1,0];
gf_table(161,:) = [0,1,1,0,0,1,1,1];
gf_table(162,:) = [1,0,0,0,1,0,1,1];
gf_table(163,:) = [1,1,1,1,1,1,0,1];
gf_table(164,:) = [1,1,0,0,0,1,1,0];
gf_table(165,:) = [0,1,1,0,0,0,1,1];
gf_table(166,:) = [1,0,0,0,1,0,0,1];
gf_table(167,:) = [1,1,1,1,1,1,0,0];
gf_table(168,:) = [0,1,1,1,1,1,1,0];
gf_table(169,:) = [0,0,1,1,1,1,1,1];
gf_table(170,:) = [1,0,1,0,0,1,1,1];
gf_table(171,:) = [1,1,1,0,1,0,1,1];
gf_table(172,:) = [1,1,0,0,1,1,0,1];
gf_table(173,:) = [1,1,0,1,1,1,1,0];
gf_table(174,:) = [0,1,1,0,1,1,1,1];
gf_table(175,:) = [1,0,0,0,1,1,1,1];
gf_table(176,:) = [1,1,1,1,1,1,1,1];
gf_table(177,:) = [1,1,0,0,0,1,1,1];
gf_table(178,:) = [1,1,0,1,1,0,1,1];
gf_table(179,:) = [1,1,0,1,0,1,0,1];
gf_table(180,:) = [1,1,0,1,0,0,1,0];
gf_table(181,:) = [0,1,1,0,1,0,0,1];
gf_table(182,:) = [1,0,0,0,1,1,0,0];
gf_table(183,:) = [0,1,0,0,0,1,1,0];
gf_table(184,:) = [0,0,1,0,0,0,1,1];
gf_table(185,:) = [1,0,1,0,1,0,0,1];
gf_table(186,:) = [1,1,1,0,1,1,0,0];
gf_table(187,:) = [0,1,1,1,0,1,1,0];
gf_table(188,:) = [0,0,1,1,1,0,1,1];
gf_table(189,:) = [1,0,1,0,0,1,0,1];
gf_table(190,:) = [1,1,1,0,1,0,1,0];
gf_table(191,:) = [0,1,1,1,0,1,0,1];
gf_table(192,:) = [1,0,0,0,0,0,1,0];
gf_table(193,:) = [0,1,0,0,0,0,0,1];
gf_table(194,:) = [1,0,0,1,1,0,0,0];
gf_table(195,:) = [0,1,0,0,1,1,0,0];
gf_table(196,:) = [0,0,1,0,0,1,1,0];
gf_table(197,:) = [0,0,0,1,0,0,1,1];
gf_table(198,:) = [1,0,1,1,0,0,0,1];
gf_table(199,:) = [1,1,1,0,0,0,0,0];
gf_table(200,:) = [0,1,1,1,0,0,0,0];
gf_table(201,:) = [0,0,1,1,1,0,0,0];
gf_table(202,:) = [0,0,0,1,1,1,0,0];
gf_table(203,:) = [0,0,0,0,1,1,1,0];
gf_table(204,:) = [0,0,0,0,0,1,1,1];
gf_table(205,:) = [1,0,1,1,1,0,1,1];
gf_table(206,:) = [1,1,1,0,0,1,0,1];
gf_table(207,:) = [1,1,0,0,1,0,1,0];
gf_table(208,:) = [0,1,1,0,0,1,0,1];
gf_table(209,:) = [1,0,0,0,1,0,1,0];
gf_table(210,:) = [0,1,0,0,0,1,0,1];
gf_table(211,:) = [1,0,0,1,1,0,1,0];
gf_table(212,:) = [0,1,0,0,1,1,0,1];
gf_table(213,:) = [1,0,0,1,1,1,1,0];
gf_table(214,:) = [0,1,0,0,1,1,1,1];
gf_table(215,:) = [1,0,0,1,1,1,1,1];
gf_table(216,:) = [1,1,1,1,0,1,1,1];
gf_table(217,:) = [1,1,0,0,0,0,1,1];
gf_table(218,:) = [1,1,0,1,1,0,0,1];
gf_table(219,:) = [1,1,0,1,0,1,0,0];
gf_table(220,:) = [0,1,1,0,1,0,1,0];
gf_table(221,:) = [0,0,1,1,0,1,0,1];
gf_table(222,:) = [1,0,1,0,0,0,1,0];
gf_table(223,:) = [0,1,0,1,0,0,0,1];
gf_table(224,:) = [1,0,0,1,0,0,0,0];
gf_table(225,:) = [0,1,0,0,1,0,0,0];
gf_table(226,:) = [0,0,1,0,0,1,0,0];
gf_table(227,:) = [0,0,0,1,0,0,1,0];
gf_table(228,:) = [0,0,0,0,1,0,0,1];
gf_table(229,:) = [1,0,1,1,1,1,0,0];
gf_table(230,:) = [0,1,0,1,1,1,1,0];
gf_table(231,:) = [0,0,1,0,1,1,1,1];
gf_table(232,:) = [1,0,1,0,1,1,1,1];
gf_table(233,:) = [1,1,1,0,1,1,1,1];
gf_table(234,:) = [1,1,0,0,1,1,1,1];
gf_table(235,:) = [1,1,0,1,1,1,1,1];
gf_table(236,:) = [1,1,0,1,0,1,1,1];
gf_table(237,:) = [1,1,0,1,0,0,1,1];
gf_table(238,:) = [1,1,0,1,0,0,0,1];
gf_table(239,:) = [1,1,0,1,0,0,0,0];
gf_table(240,:) = [0,1,1,0,1,0,0,0];
gf_table(241,:) = [0,0,1,1,0,1,0,0];
gf_table(242,:) = [0,0,0,1,1,0,1,0];
gf_table(243,:) = [0,0,0,0,1,1,0,1];
gf_table(244,:) = [1,0,1,1,1,1,1,0];
gf_table(245,:) = [0,1,0,1,1,1,1,1];
gf_table(246,:) = [1,0,0,1,0,1,1,1];
gf_table(247,:) = [1,1,1,1,0,0,1,1];
gf_table(248,:) = [1,1,0,0,0,0,0,1];
gf_table(249,:) = [1,1,0,1,1,0,0,0];
gf_table(250,:) = [0,1,1,0,1,1,0,0];
gf_table(251,:) = [0,0,1,1,0,1,1,0];
gf_table(252,:) = [0,0,0,1,1,0,1,1];
gf_table(253,:) = [1,0,1,1,0,1,0,1];
gf_table(254,:) = [1,1,1,0,0,0,1,0];
gf_table(255,:) = [0,1,1,1,0,0,0,1];

end