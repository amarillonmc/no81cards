--韶光的祈福 希尔维娅
function c9910463.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c9910463.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c9910463.matval)
	c:RegisterEffect(e1)
	--recover & todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,9910463)
	e2:SetCondition(c9910463.regcon)
	e2:SetOperation(c9910463.regop)
	c:RegisterEffect(e2)
end
function c9910463.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c9910463.exmfilter(c,tp)
	return c:IsControler(tp) and c:GetCounter(0x1950)>0
end
function c9910463.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(c9910463.exmfilter,1,nil,1-tp)
end
function c9910463.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c9910463.tgfilter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x9950) and c:IsAbleToGrave()
end
function c9910463.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910463.tgfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local lp=Duel.GetLP(tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabel(lp)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910463.rccon)
		e1:SetOperation(c9910463.rcop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910463.rccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)~=e:GetLabel()
end
function c9910463.rcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910463)
	if Duel.GetLP(tp)<e:GetLabel() then
		local s1=e:GetLabel()-Duel.GetLP(tp)
		if Duel.IsPlayerAffectedByEffect(tp,9910467) then s1=2*s1 end
		local s2=Duel.Recover(tp,s1,REASON_EFFECT)
		local d=math.floor(s2/2000)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
		if d<=0 then return end
		if d>g:GetCount() then d=g:GetCount() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,d,d,nil)
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	else
		Duel.SetLP(tp,e:GetLabel())
	end
end
