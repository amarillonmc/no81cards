local m=15000409
local cm=_G["c"..m]
cm.name="孤寂幻影缄默城"
function cm.initial_effect(c)
	c:EnableCounterPermit(0xf3a)
	c:SetCounterLimit(0xf3a,5)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--COUNTER
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e1:SetRange(LOCATION_FZONE)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP) 
	e1:SetOperation(cm.counter)  
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf3a))
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(cm.desreptg)
	e3:SetValue(cm.desrepval)
	e3:SetOperation(cm.desrepop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCost(cm.thcost)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0xf3a,ct,true)
	end
end
function cm.atkval(e,c)
	return e:GetHandler():GetCounter(0xf3a)*200
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0xf3a) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) and c:IsCanRemoveCounter(tp,0xf3a,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	local tp=e:GetHandler():GetControler()
	return cm.repfilter(c,tp)
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	e:GetHandler():RemoveCounter(tp,0xf3a,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,m)
end
function cm.thfilter(c,tp)
	return c:IsSetCard(0xf3a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local tp=e:GetHandler():GetControler() 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsCanRemoveCounter(tp,0xf3a,2,REASON_COST) end  
	e:GetHandler():RemoveCounter(tp,0xf3a,2,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end