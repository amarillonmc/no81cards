function c10111130.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111130,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10111130)
	e1:SetCost(c10111130.spcost)
	e1:SetTarget(c10111130.sptg)
	e1:SetOperation(c10111130.spop)
	c:RegisterEffect(e1)
    	--Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111130,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c10111130.thcost)
	e2:SetTarget(c10111130.thtg)
	e2:SetOperation(c10111130.thop)
	c:RegisterEffect(e2)
    	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10111130,2))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,101111300)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c10111130.atktg)
	e3:SetOperation(c10111130.atkop)
	c:RegisterEffect(e3)
    end
function c10111130.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xc008) and c:IsDiscardable()
end
function c10111130.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111130.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c10111130.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c10111130.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10111130.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10111130.thcfilter(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c10111130.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111130.thcfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10111130.thcfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10111130.thfilter(c)
	return aux.IsCodeOrListed(c,10111128) and not c:IsCode(10111130) and c:IsAbleToHand()
end
function c10111130.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111130.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10111130.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10111130.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10111130.tgfilter(c,e)
	return c:IsFaceup() and c:IsSetCard(0x8) and c:IsCanBeEffectTarget(e)
end
function c10111130.atkfilter(c)
	return c:GetAttack()>0 and c:GetBaseAttack()>0
end
function c10111130.tgcheck(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_FUSION) and g:IsExists(c10111130.atkfilter,1,nil)
end
function c10111130.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c10111130.tgfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return g:CheckSubGroup(c10111130.tgcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,c10111130.tgcheck,false,2,2)
	Duel.SetTargetCard(sg)
end
function c10111130.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if #g<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10111130,3))
	local g1=g:FilterSelect(tp,c10111130.atkfilter,1,1,nil)
	if #g1<1 then return end
	local tc1=g1:GetFirst()
	local tc2=(g-g1):GetFirst()
	if tc1:IsImmuneToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(-1000)
	tc1:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(tc1:GetBaseAttack())
	tc2:RegisterEffect(e2)
end