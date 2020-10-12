function c82221047.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c82221047.reg)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82221047,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c82221047.descon)
	e2:SetTarget(c82221047.destg)
	e2:SetOperation(c82221047.desop)
	c:RegisterEffect(e2)
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCondition(c82221047.descon)
	e3:SetValue(aux.indoval)  
	c:RegisterEffect(e3) 
	--pierce  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_SINGLE)  
	e4:SetCode(EFFECT_PIERCE)  
	c:RegisterEffect(e4)  
	--pendulum  
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(82221047,1))  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e5:SetCode(EVENT_DESTROYED)  
	e5:SetProperty(EFFECT_FLAG_DELAY)  
	e5:SetCondition(c82221047.pencon)  
	e5:SetTarget(c82221047.pentg)  
	e5:SetOperation(c82221047.penop)  
	c:RegisterEffect(e5)  
end
function c82221047.reg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(82221047,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c82221047.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(82221047)~=0
end
function c82221047.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c82221047.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c82221047.desfilter,tp,0,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c82221047.desfilter,tp,0,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c82221047.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c82221047.pencon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()  
end  
function c82221047.pentg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end  
end  
function c82221047.penop(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)  
	end  
end  