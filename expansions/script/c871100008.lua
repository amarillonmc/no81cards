--翡翠幼龙
function c871100008.initial_effect(c)
	---special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c871100008.spcon)
	e1:SetOperation(c871100008.spop)
	c:RegisterEffect(e1)
end
function c871100008.spfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsDiscardable()
end
function c871100008.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c871100008.spfilter,tp,LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	return g:CheckWithSumGreater(Card.GetLevel,2)
end
function c871100008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c871100008.spfilter,c:GetControler(),LOCATION_HAND,0,nil)
	if not c:IsAbleToGraveAsCost() or Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY) then
		g:RemoveCard(c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local sg=g:SelectWithSumGreater(tp,Card.GetLevel,2)
	Duel.SendtoGrave(sg,REASON_COST+REASON_DISCARD)
end
