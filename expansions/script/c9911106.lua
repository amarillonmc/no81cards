--蒙昧神迹-凝滞的脉动
function c9911106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(TIMING_BATTLE_PHASE,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_PHASE)
	e1:SetTarget(c9911106.target)
	e1:SetOperation(c9911106.activate)
	c:RegisterEffect(e1)
end
function c9911106.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_NORMAL)
end
function c9911106.posfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and c:IsCanTurnSet()
end
function c9911106.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local sc=Duel.GetMatchingGroupCount(c9911106.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9911106.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911106.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c9911106.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,sc+1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c9911106.sumfilter(c)
	return c:IsSetCard(0xa954) and c:IsSummonable(true,nil,1)
end
function c9911106.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
		local og=Duel.GetOperatedGroup()
		local tc=og:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e1)
			tc=og:GetNext()
		end
		if Duel.IsExistingMatchingCard(c9911106.sumfilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9911106,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c9911106.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
			Duel.Summon(tp,sg:GetFirst(),true,nil,1)
		end
	end
end
