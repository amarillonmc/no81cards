fpjdiy={}
zhc_lhq_xw='统御群星的至高至上之神||于星云辉灿之处割裂昏晓，以无匹的伟力制裁邪恶！||群星的君王！龙辉巧-仙王流星=CEP！光临！！'
zhc_lhq_xw_1='暗淡的星，再次开始闪烁'
zhc_lhq_xw_2='无数的光辉合而为一，现在，我们可吞噬万物'
zhc_lhq_tx='隐匿于星辰晦暗之处，且以光明为饵||行绝命之构陷藏于，螯针之中的猛毒！||龙仪巧-天蝎流星=SCO！光临！！'
zhc_lhq_lh='以猎弓射落煌煌大日，栖身于星云璀璨之地||以流星击坠来犯之敌！||龙仪巧-猎户流星=QRI！光临！'
zhc_lhq_by='着无暇之毫庇护良善||以星之荣光救赎灾厄，化作永恒闪耀的新星！||龙仪巧-白羊流星=ARI！光临！！'
zhc_lhq_mj='足踏暗夜的仁君||以光明之锋芒划破黑暗，将希望播撒至宇宙的尽头！||龙仪巧-摩羯流星=CAP！光临！！'
zhc_lhq_ss='承群星之荣冕者||以智慧之光染尽黑暗，将永恒的深邃化作璀璨的星光！||龙仪巧-射手流星=SAG！光临！！'
zhc_lhq_cn='幽深黑暗中潜形的冥后||待回归广袤星空之时，此处必然群星闪耀！||龙仪巧-处女流星=AIR！光临！！'
zhc_lhq_tc='端居于星辰正位之处||将群星的正义贯彻执行，以光明制衡黑暗！||龙仪巧-天秤流星=LIB！光临！！'
zhc_lhq_tq='于希望聚集的天穹之上奏响正义的凯歌||琴音所至邪恶无所遁形，以圣乐击破所有污秽！||龙仪巧-天琴流星=LYR！光临！！'
zhc_lhq_sp='宇宙中如梦似幻的伟岸身姿||于黑暗之中散发希望之光！||龙仪巧-水瓶流星=AOU！光临！！'
zhc_lhq_zs='霸揽星图的无双霸者||以无穷的伟力击退邪恶，应群星的誓约战至黑暗散却！||龙仪巧-狮子流星=LEO！光临！！'
zhc_lhq_sz='星空中身形飘渺的双子星||为迷途之人指明前路！||龙仪巧-双子流星=GEM！光临！！'
zhc_lhq_xy='执掌星图的无上存在||以雄姿威慑邪恶，此刻正是群星闪耀之时！||龙仪巧-仙英流星=PER！光临！！'
zhc_lhq_jn='追随光明之后的使者||为世界带来新生的黎明，为邪恶送上终结的丧钟！||龙仪巧-金牛流星=TAU！光临！！'
zhc_lhq_jx='以巨螯牵制混沌，以伟躯散播光明||光明与希望的支配者在此显现！||龙仪巧-巨蟹流星=CAN！光临！！'
zhc_lhq_sy='于无尽的星图间穿梭跳跃，群星的观测者||以全知全视之眼洞悉黑暗所在，以光影斑斓之翼引导光明！||龙仪巧-双鱼流星=PIS！光临！！'
zhc_lhq_xx='跨越千年时光的两道光芒于此交辉||以永恒闪耀的极北之光制裁邪恶！||龙仪巧-小熊流星=URS——光临！！'
zhc_lhq_fh='自堙灭之处降诞的流星||割断星空的明晦，将无尽星图浇作烈火吧！||龙仪巧-凤凰流星=PHO——光临！！'
zhc_lhq_cw='拨动星迹的远航之帆||开赴广袤宇宙之外的无限混沌，将光明染尽黑暗吧！||龙仪巧-船尾流星=PUP——光临！！'
zhc_lhq_ql='如利刃般以光芒闪爆黑暗||栖身于群星闪耀之所的至仁，让光明洒遍大地！||龙仪巧-麒麟流星=MON——光临！！'
zhc_lhq_dp='持星辉之力守护此方||屹立于星图之上的至古存在，不朽无败，||龙仪巧-盾牌流星=SCU——光临！！'
zhc_lhq_fm='于常暗崩灭处诞临||以光翼制裁黑暗，将星辉遍洒银河！||龙仪巧-飞马流星=PEG——光临！！'
zhc_lhq_jy='统御极天与邃渊的巨兽||其息仿若星云，其辉仿若恒星！||龙仪巧-鲸鱼流星=CET——光临！！'
zhc_lhq_wx='以力制胜，征服诸天的无上霸者||以星辰崩摧之伟力摇撼宇宙！||龙仪巧-武仙流星=HER——光临！！'
zhc_lhq_wx_2='「这恐怕是乳海」'
zhc_lhq_wy='恒星之主的使徒||散布欺瞒一切都谎言，为万物染上悲剧的色彩吧！||龙仪巧-乌鸦流星=COR——光临！！'

--
--召唤词函数，传入card和文本，用 | 换行
function fpjdiy.Zhc(c,text)
	local e99=Effect.CreateEffect(c)
	e99:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e99:SetCode(EVENT_SPSUMMON_SUCCESS)
	e99:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e99:SetCondition(fpjdiy.skipcon)
	e99:SetOperation(fpjdiy.skipop(text))
	c:RegisterEffect(e99)
	return e99
end
function fpjdiy.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return fpjdiy.isNormalSpecialSummoned(e:GetHandler())
end
function fpjdiy.skipop(text)
	return function(e,tp,eg,ep,ev,re,r,rp)
			return fpjdiy.printLines(text)
		--if not c:IsRelateToEffect(e) then return end
		--if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then func(e,tp) end
	end
end
--检测是否为正规特招出场
function fpjdiy.isNormalSpecialSummoned(card)
	local summonType = card:GetSummonType()
	local cardType = card:GetType()
	if summonType == SUMMON_TYPE_NORMAL and bit.band(cardType, TYPE_MONSTER) ~= 0 then
		return true
	elseif summonType == SUMMON_TYPE_RITUAL and bit.band(cardType, TYPE_RITUAL) ~= 0 then
		return true
	elseif summonType == SUMMON_TYPE_FUSION and bit.band(cardType, TYPE_FUSION) ~= 0 then
		return true
	elseif summonType == SUMMON_TYPE_SYNCHRO and bit.band(cardType, TYPE_SYNCHRO) ~= 0 then
		return true
	elseif summonType == SUMMON_TYPE_XYZ and bit.band(cardType, TYPE_XYZ) ~= 0 then
		return true
	elseif summonType == SUMMON_TYPE_LINK and bit.band(cardType, TYPE_LINK) ~= 0 then
		return true
	elseif card:IsCode(11612634) then
		return true
	else
		return false
	end
end
--检测是否为正规特招出场
function fpjdiy.splitString(inputString, separator)
	local result = {}
	local i = 1
	for str in string.gmatch(inputString, "([^" .. separator .. "]+)") do
		result[i] = str
		i = i + 1
	end
	return result
end

function fpjdiy.printLines(inputString)
	local lines = fpjdiy.splitString(inputString, "||")
	for i, line in ipairs(lines) do
		Debug.Message(line)
	end
end

