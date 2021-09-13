--AKS-飞蹄的讯使
function c82568049.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c82568049.mfilter,1)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82568049,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,82568049)
	e1:SetCondition(c82568049.thcon1)
	e1:SetTarget(c82568049.thtg1)
	e1:SetOperation(c82568049.thop1)
	c:RegisterEffect(e1)
	--AddCounter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,82568149)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c82568049.cttg)
	e2:SetOperation(c82568049.ctop)
	c:RegisterEffect(e2)
end
function c82568049.mfilter(c)
	return c:IsLevelAbove(4) and c:IsLinkSetCard(0x825)
end
function c82568049.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c82568049.thfilter1(c)
	return (c:IsSetCard(0x825) or c:IsSetCard(0x828)) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c82568049.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568049.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82568049.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82568049.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c82568049.tkfilter(c)
	return c:IsFaceup()
end
function c82568049.Exfilter(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c82568049.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x5825,2)  and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c82568049.tkfilter,tp,LOCATION_MZONE,0,1,nil) 
	and Duel.IsExistingMatchingCard(c82568049.Exfilter,tp,LOCATION_MZONE,0,1,nil) end
	local ex=Duel.GetMatchingGroupCount(c82568049.Exfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568049.tkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if ex>3 then ex=3
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,ex)
   
end
function c82568049.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ex=Duel.GetMatchingGroupCount(c82568049.Exfilter,tp,LOCATION_MZONE,0,nil)
	if ex>3 then ex=3
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) 
  then  tc:AddCounter(0x5825,ex)
	
	end
end