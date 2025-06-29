--不可思议之国的爱丽丝
function c95101111.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xbbe),2,true)
	--to hand/grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(95101111,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,95101111)
	e1:SetCondition(c95101111.thgcon)
	e1:SetTarget(c95101111.thgtg)
	e1:SetOperation(c95101111.thgop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95101111,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,95101111+1)
	e2:SetCondition(c95101111.tgcon)
	e2:SetTarget(c95101111.tgtg)
	e2:SetOperation(c95101111.tgop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,95101111+2)
	e3:SetTarget(c95101111.thtg)
	e3:SetOperation(c95101111.thop)
	c:RegisterEffect(e3)
end
function c95101111.thgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c95101111.cfilter(c)
	return c:IsSetCard(0xbbe) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsAbleToGrave()
end
function c95101111.thgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101111.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,LOCATION_DECK)
end
function c95101111.thgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c95101111.cfilter,tp,LOCATION_DECK,0,3,3,nil)
	if g:GetCount()==3 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tc=g:Select(1-tp,1,1,nil):GetFirst()
		if tc:IsAbleToHand() and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		   Duel.ConfirmCards(1-tp,tc)  
		   g:RemoveCard(tc)
		end
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c95101111.chkfilter(c)
	return c:IsSetCard(0xbbe) and c:IsFaceup() and c:IsSummonLocation(LOCATION_HAND)
end
function c95101111.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c95101111.chkfilter,1,nil)
end
function c95101111.tgfilter(c)
	return c:IsCode(95101001) and c:IsAbleToGrave()
end
function c95101111.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101111.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c95101111.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95101111.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c95101111.thfilter(c)
	return c:IsSetCard(0xbbd) and not c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c95101111.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c95101111.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c95101111.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c95101111.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
