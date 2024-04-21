--动物朋友 月读神使
local m=33703001
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.recona)
	e1:SetTarget(cm.retga)
	e1:SetOperation(cm.reopa)
	c:RegisterEffect(e1)
	--Effect 2  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.reconb)
	e4:SetTarget(cm.retgb)
	e4:SetOperation(cm.reopb)
	c:RegisterEffect(e4)
end
--
function cm.sf(c) 
	return c:IsSetCard(0x442)
end 
function cm.stf(c) 
	return cm.sf(c) 
end 
--Effect 1
function cm.nck(tp) 
	local ckg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	return ckg:GetClassCount(Card.GetCode)==#ckg
end 
function cm.recona(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.retga(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(cm.stf,nil)
	local val=g:GetSum(Card.GetAttack)
	if chk==0 then return cm.nck(tp) and val>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function cm.reopa(e,tp,eg,ep,ev,re,r,rp)
	if not cm.nck(tp) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(cm.stf,nil)
	local val=g:GetSum(Card.GetAttack)
	if val==0 then return false end
	Duel.Recover(tp,val,REASON_EFFECT)
end
--Effect 2
function cm.reconb(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler()
	local b1=ec:IsPreviousLocation(LOCATION_MZONE)
	local b2=ec:IsSummonType(SUMMON_TYPE_SYNCHRO)
	return b1 and b2
end  
function cm.retgb(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(cm.stf,nil)
	local val=g:GetSum(Card.GetDefense)
	if chk==0 then return cm.nck(tp) and val>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function cm.reopb(e,tp,eg,ep,ev,re,r,rp)
	if not cm.nck(tp) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(cm.stf,nil)
	local val=g:GetSum(Card.GetDefense)
	if val==0 then return false end
	Duel.Recover(tp,val,REASON_EFFECT)
end