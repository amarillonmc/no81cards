--枯荣
local m=13000748
local cm=_G["c"..m]
function c13000748.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syncon)
	e0:SetTarget(cm.syntg)
	e0:SetOperation(cm.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_LEAVE_FIELD) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e1:SetCondition(function(e) 
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) end)
	e1:SetTarget(cm.psettg) 
	e1:SetOperation(cm.psetop) 
	c:RegisterEffect(e1)	 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_GRAVE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_LEAVE_DECK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(cm.spcon2)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
cm.flyznum=0
function cm.psettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end 
end 
function cm.psetop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end 
	
	 if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
	local b1=Duel.IsExistingMatchingCard(cm.psfilter,tp,LOCATION_EXTRA,0,1,nil)
	local b2=true
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,2)},{b2,aux.Stringid(m,3)})
	if op==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.psfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end

if op==2 then
local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE+PHASE_DRAW)
		e3:SetCountLimit(1)
		e3:SetCondition(cm.stcon)
		e3:SetOperation(cm.stop)
		e3:SetLabel(Duel.GetTurnCount())
	  
	if Duel.GetCurrentPhase()==PHASE_DRAW then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_DRAW,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
	end
	   
Duel.RegisterEffect(e3,tp)
end
end
end
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function cm.psfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter2,1,nil,tp) 
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,tp)
end
function cm.filter2(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsType(TYPE_MONSTER)
end
function cm.filter(c,tp)
	return c:IsPreviousControler(tp) and c:IsType(TYPE_MONSTER)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	e2:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e2)
	end
	if c:IsLocation(LOCATION_MZONE) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) then
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local aa=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Destroy(aa,REASON_RULE)
	end
end
end
function cm.atkval(e,c)
	return cm.flyznum*2000
end
function cm.synfilter(c)
	return c:IsCanBeSynchroMaterial() and (c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_PZONE) or c:IsLocation(LOCATION_HAND))
end
function cm.syncon(e,c,smat)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(cm.synfilter,c:GetControler(),LOCATION_PZONE+LOCATION_MZONE+LOCATION_HAND,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		return Duel.CheckTunerMaterial(c,smat,nil,aux.NonTuner(nil),2,99,mg) end
	return Duel.CheckSynchroMaterial(c,nil,aux.NonTuner(nil),2,99,smat,mg)
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat)
	local g=nil
	local mg=Duel.GetMatchingGroup(cm.synfilter,c:GetControler(),LOCATION_PZONE+LOCATION_MZONE+LOCATION_HAND,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,nil,aux.NonTuner(nil),2,99,mg)
	else
		g=Duel.SelectSynchroMaterial(c:GetControler(),c,nil,aux.NonTuner(nil),2,99,smat,mg)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end