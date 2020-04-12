local m=82221015
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --synchro summon  
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),1,99) 
	c:EnableReviveLimit()  
	--remove  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetTargetRange(0xfe,0xff)  
	e1:SetValue(LOCATION_REMOVED)  
	e1:SetTarget(cm.rmtg)  
	c:RegisterEffect(e1)
	--negate  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCode(EVENT_CHAINING)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCondition(cm.discon)  
	e2:SetCost(cm.discost)  
	e2:SetTarget(cm.distg)  
	e2:SetOperation(cm.disop)  
	c:RegisterEffect(e2)  
	--to hand  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)  
	--to field  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,2))  
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e4:SetCode(EVENT_TO_HAND) 
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e4:SetCondition(cm.tfcon)
	e4:SetTarget(cm.tftg)  
	e4:SetOperation(cm.tfop)  
	c:RegisterEffect(e4) 
end
function cm.rmtg(e,c)  
	return c:GetOwner()~=e:GetHandlerPlayer()  
end  
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end  
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)  
end  
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsReleasable() end  
	Duel.Release(e:GetHandler(),REASON_COST)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then  
		Duel.Destroy(eg,REASON_EFFECT)  
	end  
end  
function cm.filter(c)  
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.cfilter(c)  
	return c:IsPreviousLocation(LOCATION_DECK)  
end  
function cm.tfcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(cm.cfilter,1,nil) and Duel.GetFlagEffect(tp,m)==0
end  
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
	end
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) and Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP,true)~=0 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)  
	end
end