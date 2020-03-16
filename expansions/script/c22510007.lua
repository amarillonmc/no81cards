--机械蝙蝠
function c22510007.initial_effect(c)
	aux.AddLinkProcedure(c,c22510007.matfilter,1,1)
	c:EnableReviveLimit()
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22510007,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,22510007)
	e4:SetCondition(c22510007.spcon)
	e4:SetTarget(c22510007.distg)
	e4:SetOperation(c22510007.disop)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22510007,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22511007)
	e1:SetCost(c22510007.eqcost)
	e1:SetTarget(c22510007.settg)
	e1:SetOperation(c22510007.setop)
	c:RegisterEffect(e1)
end
function c22510007.matfilter(c)
	return c:IsLinkSetCard(0xec0) and not c:IsLinkCode(22510007)
end
function c22510007.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==1
end
function c22510007.spfilter(c,e,tp,zone)
	return c:IsSetCard(0xec0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c22510007.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c22510007.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,zone) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c22510007.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp) 
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22510007.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		g:GetFirst():CompleteProcedure()
	end
end
function c22510007.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22510007.setfilter(c,tp)
	return c:IsCode(22510011) and c:GetActivateEffect():IsActivatable(tp)
end
function c22510007.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22510007.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c22510007.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c22510007.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
