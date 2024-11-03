function c10111133.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xf008),aux.FilterBoolFunction(Card.IsFusionSetCard,0x8),true) 
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10111133.splimit)
	c:RegisterEffect(e0)
    	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111133,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10111133)
	e1:SetCondition(c10111133.thcon1)
	e1:SetTarget(c10111133.target)
	e1:SetOperation(c10111133.operation)
	c:RegisterEffect(e1)
    	--revive
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111133,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101111330)
	e2:SetCondition(c10111133.spcon)
	e2:SetTarget(c10111133.distg)
	e2:SetOperation(c10111133.disop)
	c:RegisterEffect(e2)
end
function c10111133.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsCode(10111128)
end
function c10111133.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c10111133.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function c10111133.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(ep,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
end
function c10111133.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf008) and not c:IsCode(10111133)
end
function c10111133.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c10111133.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c10111133.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10111133.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c10111133.cfilter(c)
	return c:IsFaceup() and aux.NegateEffectMonsterFilter(c)
end
function c10111133.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c10111133.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10111133.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,c10111133.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c10111133.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) then 
    if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then
    if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
       	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	    tc:RegisterEffect(e1)
	    local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
	    e2:SetValue(RESET_TURN_SET)
	    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	    tc:RegisterEffect(e2) end end
    end
        Duel.Draw(tp,1,REASON_EFFECT)
end