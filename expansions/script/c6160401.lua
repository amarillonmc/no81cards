--
function c6160401.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x616),1,1)  
	c:EnableReviveLimit()
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_POSITION)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCountLimit(1,6160401)   
	e1:SetTarget(c6160401.target)  
	e1:SetOperation(c6160401.activate)  
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(6160401,1))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_BE_MATERIAL)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,6160401) 
	e2:SetCondition(c6160401.tdcon) 
	e2:SetTarget(c6160401.thtg)  
	e2:SetOperation(c6160401.thop)  
	c:RegisterEffect(e2)  
end
function c6160401.filter(c)  
	return c:IsFaceup() and  c:IsCanTurnSet() 
end  
function c6160401.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c6160401.filter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c6160401.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local g=Duel.SelectTarget(tp,c6160401.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)  
end  
function c6160401.activate(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then  
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)  
	end  
end
function c6160401.tdcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and r==REASON_LINK and c:IsLocation(LOCATION_GRAVE)  
end  
function c6160401.thfilter(c)  
	return c:IsSetCard(0x616) and c:IsAbleToHand()  
end  
function c6160401.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6160401.thfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c6160401.thfilter,tp,LOCATION_GRAVE,0,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectTarget(tp,c6160401.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function c6160401.thop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.SendtoHand(tc,nil,REASON_EFFECT)  
	end 
end   