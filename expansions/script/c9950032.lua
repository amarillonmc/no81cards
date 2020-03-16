--星界琉璃
function c9950032.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_TOHAND)
	e1:SetCondition(c9950032.condition)
	e1:SetTarget(c9950032.target)
	e1:SetOperation(c9950032.activate)
	c:RegisterEffect(e1)
end
function c9950032.cfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att) and c:IsSetCard(0xba1)
end
function c9950032.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9950032.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c9950032.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_FIRE)
		and Duel.IsExistingMatchingCard(c9950032.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ATTRIBUTE_DARK)
end
function c9950032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=2
		or Duel.IsPlayerCanDraw(tp,2) end
end
function c9950032.activate(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		ops[off]=aux.Stringid(9950032,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=2 then
		ops[off]=aux.Stringid(9950032,2)
		opval[off-1]=3
		off=off+1
	end
	if Duel.IsPlayerCanDraw(tp,2) then
		ops[off]=aux.Stringid(9950032,3)
		opval[off-1]=4
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==2 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif opval[op]==3 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(1-tp,2)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	elseif opval[op]==4 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
