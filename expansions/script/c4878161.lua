local m=4878161
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.condition)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(2,m)
	e2:SetCondition(cm.pencon)
	e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(cm.distg)
	c:RegisterEffect(e3)
end
function cm.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsType(TYPE_PENDULUM) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.cfilter1(c)
	return c:GetOriginalType()&TYPE_PENDULUM~=0 and c:GetOriginalType()&TYPE_NORMAL~=0
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function cm.scfilter(c,check)
	return (c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x48e) and c:IsType(TYPE_RITUAL))
		or (check and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_RITUAL))
end
function cm.checkfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsFaceup()
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then local check=Duel.IsExistingMatchingCard(cm.checkfilter,tp,LOCATION_MZONE,0,1,nil) return Duel.IsExistingMatchingCard(cm.scfilter,tp,LOCATION_DECK,0,1,nil,check) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=Duel.IsExistingMatchingCard(cm.checkfilter,tp,LOCATION_MZONE,0,1,nil)
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.scfilter,tp,LOCATION_DECK,0,1,1,nil,check)
	local tc=g:GetFirst()
	if tc and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LSCALE)
		e1:SetValue(tc:GetLeftScale())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_RSCALE)
		e2:SetValue(tc:GetRightScale())
		c:RegisterEffect(e2)
	end
end
function cm.cfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end