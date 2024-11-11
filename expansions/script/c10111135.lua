function c10111135.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111135,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10111135)
	e1:SetCost(c10111135.tgcost)
	e1:SetTarget(c10111135.tgtg)
	e1:SetOperation(c10111135.tgop)
	c:RegisterEffect(e1)
    	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111135,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101111350)
	e2:SetCondition(c10111135.spcon)
	e2:SetCost(c10111135.descost)
	e2:SetTarget(c10111135.sptg)
	e2:SetOperation(c10111135.spop)
	c:RegisterEffect(e2)
end
function c10111135.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c10111135.tgfilter(c)
	return aux.IsCodeOrListed(c,10111128) and c:IsType(TYPE_MONSTER) and not c:IsCode(10111135) and c:IsAbleToGrave()
end
function c10111135.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111135.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c10111135.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10111135.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c10111135.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x9008) and not c:IsCode(10111135)
end
function c10111135.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10111135.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c10111135.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10111135.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10111135.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
        Duel.Draw(tp,1,REASON_EFFECT)
end