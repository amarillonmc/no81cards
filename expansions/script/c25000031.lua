--爆裂推进者
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,80280737)
	aux.AddLinkProcedure(c,s.mfilter,2,2)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetTarget(s.mattg)
	e0:SetValue(s.matval)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o*10000)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return aux.IsCodeListed(c,80280737)
end
function s.mattg(e,c)
	return c:IsSetCard(0x104f)
end
function s.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,true
end
function s.costfilter(c)
	return c:IsCode(80280737) and c:IsAbleToGraveAsCost()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.thfilter(c)
	return aux.IsCodeListed(c,80280737) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function s.costfilter2(c)
	return (c:IsCode(80280737) or aux.IsCodeListed(c,80280737))
		and c:IsAbleToDeckAsCost()
end
function s.gfilter(c,g)
	return aux.IsCodeListed(c,80280737) and g:FilterCount(Card.IsCode,c,80280737)
end
function s.gcheck(g,tp)
	return g:GetCount()==2 and g:FilterCount(s.gfilter,nil,g)
			or g:GetCount()==1 and g:FilterCount(s.costfilter2,nil)==1
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.costfilter2,tp,LOCATION_GRAVE,0,e:GetHandler())
	if chk==0 then return g:CheckSubGroup(s.gcheck,1,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,s.gcheck,false,1,2,tp)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end