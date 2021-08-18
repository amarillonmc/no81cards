--里克＆休比
function c60000125.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x36a0),aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()	
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000125,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,60000125)
	e1:SetTarget(c60000125.thtg)
	e1:SetOperation(c60000125.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10000125)
	e2:SetTarget(c60000125.lstg)
	e2:SetOperation(c60000125.lsop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c60000125.incon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c60000125.thfilter(c)
	return c:IsSetCard(0x36a0) and c:IsAbleToHand()
end
function c60000125.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000125.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,60000119)~=0 and e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60000125.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60000125.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60000125.lstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,60000125)>=3 and Duel.GetFlagEffect(tp,60000119)~=0 end 
end 
function c60000125.lsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local x=Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,60000125)
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp-x*1000)
end
function c60000125.incon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,60000119)~=0 
end





