--胧之渺翳 塞德娜卿
function c9911322.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c9911322.mfilter,nil,2,99)
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9911322)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c9911322.xmcost)
	e2:SetTarget(c9911322.xmtg)
	e2:SetOperation(c9911322.xmop)
	c:RegisterEffect(e2)
end
function c9911322.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,7) or (c:IsRace(RACE_FIEND) and c:IsType(TYPE_XYZ))
end
function c9911322.xmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c9911322.xmfilter1(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not (e and c:IsImmuneToEffect(e))
end
function c9911322.xmfilter2(c,e)
	return c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function c9911322.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911322.xmfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9911322.xmfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c9911322.xmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	while Duel.IsExistingMatchingCard(c9911322.xmfilter1,tp,LOCATION_MZONE,0,1,g1,e)
		and Duel.IsExistingMatchingCard(c9911322.xmfilter2,tp,0,LOCATION_ONFIELD,1,g2,e) do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911322,0))
		local tc1=Duel.SelectMatchingCard(tp,c9911322.xmfilter1,tp,LOCATION_MZONE,0,1,1,g1,e):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc2=Duel.SelectMatchingCard(tp,c9911322.xmfilter2,tp,0,LOCATION_ONFIELD,1,1,g2,e):GetFirst()
		Duel.HintSelection(Group.FromCards(tc1,tc2))
		local og=tc2:GetOverlayGroup()
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
		tc2:CancelToGrave()
		Duel.Overlay(tc1,tc2)
		g1:AddCard(tc1)
		g2:AddCard(tc2)
	end
end
