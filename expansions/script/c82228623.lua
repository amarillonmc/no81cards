local m=82228623
local cm=_G["c"..m]
cm.name="孑影之神树"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)
	c:RegisterEffect(e1)  
	--destroy replace  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_DESTROY_REPLACE)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetTarget(cm.reptg)  
	e2:SetValue(cm.repval)  
	c:RegisterEffect(e2)
	--disable  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetRange(LOCATION_SZONE)  
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)  
	e3:SetTarget(cm.distg)  
	e3:SetCode(EFFECT_DISABLE)  
	c:RegisterEffect(e3)  
end
function cm.filter(c)  
	return c:IsFaceup() and c:IsSetCard(0x3299)  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then  
		Duel.SetChainLimit(cm.climit)  
	end  
end
function cm.climit(e,lp,tp)  
	return not (e:IsActiveType(TYPE_MONSTER) and e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsPosition(POS_DEFENSE)) 
end  
function cm.repfilter(c,tp)  
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsSetCard(0x3299) and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)  
end  
function cm.repfilter2(c)
	return c:IsSetCard(0x3299) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)  
		and Duel.IsExistingMatchingCard(cm.repfilter2,tp,LOCATION_GRAVE,0,1,nil) end  
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
		local g=Duel.SelectMatchingCard(tp,cm.repfilter2,tp,LOCATION_GRAVE,0,1,1,nil)  
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)  
		return true  
	end  
	return false  
end  
function cm.repval(e,c)  
	return cm.repfilter(c,e:GetHandlerPlayer())  
end  
function cm.distg(e,c)  
	return c:IsPosition(POS_DEFENSE)
end  