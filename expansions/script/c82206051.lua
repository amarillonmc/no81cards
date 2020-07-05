local m=82206051
local cm=_G["c"..m]
cm.name="植占师31-能量"
function cm.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCondition(cm.rtcon)  
	e1:SetTarget(cm.rttg)  
	e1:SetOperation(cm.rtop)  
	c:RegisterEffect(e1)  
	--atk  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCondition(cm.atkcon)  
	e2:SetValue(2000)  
	c:RegisterEffect(e2)  
	--tohand  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_TO_GRAVE) 
	e3:SetCountLimit(1,m)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3) 
end  
function cm.rtcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)  
end  
function cm.rttg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)  
end  
function cm.rtop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)  
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.HintSelection(g)  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
	end  
end  
function cm.atkfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d)  
end  
function cm.atkcon(e)  
	return Duel.GetMatchingGroupCount(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,e:GetHandler())>=1 
end  
function cm.thfilter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x129d) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  