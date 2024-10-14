--海·晶·渌
local s,id,o=GetID()
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,3,s.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.matcheck)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetLabelObject(e1)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_AQUA+RACE_FISH+RACE_SEASERPENT)
end
function s.matcheck(e,c)
	local mg=c:GetMaterial()
	local att=0
	for tc in aux.Next(mg) do
		att=att|tc:GetAttribute()
	end
	e:SetLabel(att)
end
function s.tdfilter(c)
	return c:IsRace(RACE_AQUA+RACE_FISH+RACE_SEASERPENT) and c:IsAbleToGrave()
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local att=e:GetLabelObject():GetLabel()
	local g=eg:Filter(Card.IsAttribute,nil,att)
	local b1=g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) and Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) and Duel.IsPlayerCanDiscardDeck(tp,6)
	local b3=g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	if b1 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
	if b2 then
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,6)
	end
	if b3 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_ONFIELD)
	end
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabelObject():GetLabel()
	local g=eg:Filter(Card.IsAttribute,nil,att)
	if g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		local tdc=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tdc then
			Duel.SendtoGrave(tdc,REASON_EFFECT)
		end
	end
	if g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) then
		Duel.DiscardDeck(tp,6,REASON_EFFECT)
	end
	if g:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) then
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		if tc then
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end