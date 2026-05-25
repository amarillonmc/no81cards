-- 波摇花·夕夜
--Duel.LoadScript("c.lua")
-- 波摇花·夕夜
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 添加波摇花系列的卡名记述，方便其他卡识别
	aux.AddCodeList(c,60012027)
	-- 注册进化指示物的许可
	c:EnableCounterPermit(0x624)
	
	-- ①：召唤/特殊召唤成功的效果，1回合1次
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.act1_target)
	e1:SetOperation(cm.act1_activate)
	c:RegisterEffect(e1)
	local e1_2=e1:Clone()
	e1_2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1_2)
	
	-- ②：自己/对方回合，放置指示物+检索的效果，1回合1次
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.act2_target)
	e2:SetOperation(cm.act2_activate)
	c:RegisterEffect(e2)
	
	-- ③的子效果1：1个以上指示物时，特殊召唤7星以上怪兽的效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.act3_con1)
	e3:SetTarget(cm.act3_target)
	e3:SetOperation(cm.act3_activate)
	c:RegisterEffect(e3)
	
	-- ③的子效果2：3个以上指示物时，所有怪兽等级变为7
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.act3_con2)
	e4:SetValue(7)
	c:RegisterEffect(e4)
end

-- 2星以下可以放置进化指示物的怪兽的过滤
function cm.spfilter1(c,e,tp)
	return c:IsLevelBelow(2) and c:IsCanHaveCounter(0x624) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- ①的目标函数
function cm.act1_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

-- ①的效果执行
function cm.act1_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	-- 特殊召唤2星以下的怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	-- 之后询问是否丢弃手卡放置进化指示物
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) 
		and c:IsCanHaveCounter(0x624) 
		and Duel.IsCanAddCounter(tp,0x624,1,c) then
		if Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_DISCARD+REASON_EFFECT,nil)
			c:AddCounter(0x624,1)
			Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		end
	end
end

-- 7星以上怪兽的过滤
function cm.filter2(c)
	return c:IsLevelAbove(7) and c:IsAbleToDeck()
end

-- 检索的波摇花卡的过滤
function cm.filter2_th(c)
	return (c:GetCode()==60012028 or c:GetCode()==60012029) and c:IsAbleToHand()
end

-- ②的目标函数
function cm.act2_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(cm.filter2_th,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			and e:GetHandler():IsCanHaveCounter(0x624)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

-- ②的效果执行
function cm.act2_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 选择任意数量的7星以上的手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_HAND,0,1,99,nil)
	if #g==0 then return end
	local ct=#g
	-- 给对方观看这些卡
	Duel.ConfirmCards(1-tp,g)
	-- 放置相同数量的进化指示物
	if c:IsCanHaveCounter(0x624) then
		c:AddCounter(0x624,ct)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
	end
	-- 把观看的卡洗回卡组
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	-- 检索波摇花的卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter2_th),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

-- 1个以上指示物的条件
function cm.act3_con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetCounter(0x624)>=1
end

-- 7星以上怪兽的过滤
function cm.filter3(c,e,tp)
	return c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- ③的目标函数
function cm.act3_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

-- ③的效果执行
function cm.act3_activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

-- 3个以上指示物的条件
function cm.act3_con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetCounter(0x624)>=3
end
