--LUKA Pink`s
function c60151401.initial_effect(c)
    --sp
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(60151401,0))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,60151401)
    e1:SetCost(c60151401.spcost)
    e1:SetTarget(c60151401.sptg)
    e1:SetOperation(c60151401.spop)
    c:RegisterEffect(e1)
	--to deck
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(60151401,1))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c60151401.spcon2)
    e2:SetCost(c60151401.spcost2)
    e2:SetTarget(c60151401.sptg2)
    e2:SetOperation(c60151401.spop2)
    c:RegisterEffect(e2)
	--sp success
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(60151401,2))
    e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,6011401)
    e3:SetCost(c60151401.spcost)
    e3:SetTarget(c60151401.sptg3)
    e3:SetOperation(c60151401.spop3)
    c:RegisterEffect(e3)
end
function c60151401.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFlagEffect(tp,6011401)==0 end
	Duel.RegisterFlagEffect(tp,6011401,RESET_CHAIN,0,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151401.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c60151401.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
        local tc=Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
    end
end
function c60151401.tfilter(c,tp)
    return c:IsLocation(LOCATION_ONFIELD)
end
function c60151401.spcon2(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(c60151401.tfilter,1,nil,tp)
end
function c60151401.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and e:GetHandler():IsFaceup() 
		and e:GetHandler():IsAbleToDeck() 
		and Duel.GetFlagEffect(tp,60151401)==0 
		and Duel.GetFlagEffect(tp,6011401)==0 end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
	Duel.RegisterFlagEffect(tp,60151401,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,6011401,RESET_CHAIN,0,1)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c60151401.filter(c,e,tp)
    return c:IsSetCard(0x3b28) and not c:IsCode(60151401) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151401.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60151401.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c60151401.spop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c60151401.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c60151401.filter2(c)
    return c:IsSetCard(0x3b28) and not c:IsCode(60151401) and c:IsAbleToHand()
end
function c60151401.sptg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToDeck() and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingMatchingCard(c60151401.filter2,tp,LOCATION_DECK,0,1,nil) 
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g1=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60151401.spop3(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c60151401.filter2,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        if Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
			local tc=Duel.GetFirstTarget()
			if tc and tc:IsRelateToEffect(e) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		end
    end
end