--水晶雫
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.cfcon)
	e1:SetTarget(s.cftg)
	e1:SetOperation(s.cfop)
	c:RegisterEffect(e1)
end
function s.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.cftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,1,nil) or Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,1,nil) end
end
function s.cffilter(c)
	return c:IsLocation(LOCATION_HAND) or c:IsFacedown()
end
function s.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED)
	if g:GetCount()>0 then
		local cg=g:Filter(s.cffilter,nil)
		Duel.ConfirmCards(tp,cg)
		Duel.ShuffleHand(1-tp)
	end
end