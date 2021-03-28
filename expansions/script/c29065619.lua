--恶役的巨人 贝利亚
function c29065619.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,29065619+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c29065619.spcon)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c29065619.thtg)
	e2:SetOperation(c29065619.thop)
	c:RegisterEffect(e2)
end
function c29065619.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (ct1==0 or ct1<ct2)
end
function c29065619.thfilter(c)
	return ((c:IsLevelBelow(9) and c:IsRace(RACE_FIEND))
		or (c:IsSetCard(0x46) and c:IsType(TYPE_SPELL))
		or aux.IsCodeListed(c,29065619)) and c:IsAbleToHand()
end
function c29065619.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil,REASON_EFFECT) and Duel.IsExistingMatchingCard(c29065619.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065619.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29065619.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
