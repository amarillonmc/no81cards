local m=82206029
local cm=_G["c"..m]
cm.name="植占师9-雪花"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c) 
	--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	c:RegisterEffect(e1)
	--destroy  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_DESTROY)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetCountLimit(1)  
	e3:SetTarget(cm.destg)  
	e3:SetOperation(cm.desop)  
	c:RegisterEffect(e3) 
	--search  
	local e4=Effect.CreateEffect(c)  
	e4:SetDescription(aux.Stringid(m,1))  
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_SUMMON_SUCCESS)  
	e4:SetProperty(EFFECT_FLAG_DELAY)  
	e4:SetCountLimit(1,m)  
	e4:SetTarget(cm.thtg)  
	e4:SetOperation(cm.thop)  
	c:RegisterEffect(e4)  
	local e5=e4:Clone()  
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)  
	c:RegisterEffect(e5)
	--recover
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,2))  
	e2:SetCategory(CATEGORY_RECOVER)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(cm.reccon)  
	e2:SetTarget(cm.rectg)  
	e2:SetOperation(cm.recop)  
	c:RegisterEffect(e2)   
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)  
	if c:IsRace(RACE_PLANT) then return false end  
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end
function cm.desfilter(c)  
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cm.desfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0) 
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x29d) and not c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
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
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(800)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)   
end  
function cm.recop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Recover(p,d,REASON_EFFECT) 
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)  
end