--圣树修正者 暗星
function c67200958.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x67a),1,99)
	--tohand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200958,0))
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetCountLimit(1,67200959)  
	e0:SetTarget(c67200958.target)
	e0:SetOperation(c67200958.activate)
	c:RegisterEffect(e0)   
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c67200958.val)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c67200958.valcheck)
	c:RegisterEffect(e2)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200958,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,67200958)
	e3:SetCondition(c67200958.stcon)
	e3:SetTarget(c67200958.sttg)
	e3:SetOperation(c67200958.stop)
	c:RegisterEffect(e3)	
end
function c67200958.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67a) and c:IsType(TYPE_PENDULUM)
end
function c67200958.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
		and chkc:IsFaceup() and chkc:IsSetCard(0x67a) end
	if chk==0 then return Duel.IsExistingTarget(c67200958.tgfilter,tp,LOCATION_MZONE,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c67200958.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
end
function c67200958.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then 
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c67200958.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x67a) and c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end
--
function c67200958.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a)
end
function c67200958.val(e,c)
	return Duel.GetMatchingGroupCount(c67200958.atkfilter,c:GetControler(),LOCATION_EXTRA,0,nil)*200
end
function c67200958.valcheck(e,c)
	local ct=c:GetMaterialCount()
	if ct>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE-RESET_TOFIELD)
		e1:SetValue(ct-1)
		c:RegisterEffect(e1)
	end
end
--
function c67200958.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c67200958.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and not e:GetHandler():IsForbidden() end
end
function c67200958.stop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and e:GetHandler():IsRelateToEffect(e) then 
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end