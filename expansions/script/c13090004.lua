--白驹过江
local m=13090004
local cm=_G["c"..m]
function c13090004.initial_effect(c)
aux.EnablePendulumAttribute(c)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.sccon)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
c13090004.star_knight_spsummon_effect=e2
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTarget(cm.desreptg)
	e1:SetValue(cm.desrepval)
	e1:SetOperation(cm.desrepop)
	c:RegisterEffect(e1)
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and (c:IsLocation(LOCATION_EXTRA) or c:IsLocation(LOCATION_SZONE)) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE) end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and c:IsAbleToGrave() end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe08)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,tp,LOCATION_EXTRA,0,nil)*-200
end
function cm.penfilter(c)
	return c:IsCode(13090003)
end
function cm.sccon(e,tp)
	local c=e:GetHandler()
	return (Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0xe08) end,tp,LOCATION_PZONE,0,1,c) or not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,c)) and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_PENDULUM) then
		Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	else 
	Duel.SendtoExtraP(e:GetHandler(),nil,REASON_EFFECT)
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	 local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
	end






