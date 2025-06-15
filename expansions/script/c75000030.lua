--起源的绊炎 英雄王马尔斯
function c75000030.initial_effect(c)
	aux.AddCodeList(c,75000001)
	-- 特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000030,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,75000030)
    e1:SetCost(c75000030.cost1)
	e1:SetTarget(c75000030.tg1)
	e1:SetOperation(c75000030.op1)
	c:RegisterEffect(e1)
    -- 抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000030,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCountLimit(1,75000031)
    e2:SetCost(c75000030.cost2)
	e2:SetTarget(c75000030.tg2)
	e2:SetOperation(c75000030.op2)
	c:RegisterEffect(e2)
end
-- 1
function c75000030.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c75000030.filter1(c,e,tp)
	return c:IsCode(75000001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE+POS_FACEUP_DEFENSE)
end
function c75000030.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c75000030.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c75000030.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c75000030.filter1),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local pos=POS_FACEDOWN_DEFENSE
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then
			pos=Duel.SelectPosition(tp,sg:GetFirst(),POS_FACEDOWN_DEFENSE+POS_FACEUP_DEFENSE)
		end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,pos)
		if pos==POS_FACEDOWN_DEFENSE then
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
-- 2
function c75000030.filter2(c)
	return c:IsSetCard(0x3751) and c:IsAbleToGraveAsCost()
end
function c75000030.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000030.filter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75000030.filter2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c75000030.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and e:GetHandler():IsAbleToDeck() end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(2)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c75000030.op2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
        Duel.BreakEffect()
        Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end
