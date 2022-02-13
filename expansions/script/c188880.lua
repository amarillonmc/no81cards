local m=188880
local cm=_G["c"..m]
cm.name="星魅的撕裂之镰-莫科"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.hspcon)
	e1:SetValue(cm.hspval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(cm.mvcon)
	e2:SetOperation(cm.mvop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(-500)
	e3:SetCondition(function(e)return e:GetHandler():GetSequence()==2 end)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetValue(1000)
	e4:SetCondition(function(e)return e:GetHandler():GetSequence()==0 or e:GetHandler():GetSequence()==4 end)
	c:RegisterEffect(e4)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp)) end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function cm.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	local lg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(lg) do zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp)) end
	return 0,zone
end
function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return (e:GetHandler():GetSequence()==0 or e:GetHandler():GetSequence()==4) and Duel.GetAttacker()==e:GetHandler() and e:GetHandler():IsRelateToBattle()
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or (c:IsControler(tp) and c:GetSequence()==2) or (c:IsControler(1-tp) and not c:IsControlerCanBeChanged()) then return end
	if Duel.CheckLocation(tp,LOCATION_MZONE,2) then
		if c:IsControler(tp) then Duel.MoveSequence(c,2) else
			if c:IsControlerCanBeChanged() then Duel.GetControl(c,tp,0,0,1<<2) else Duel.SendtoGrave(c,REASON_EFFECT) end
		end
	else Duel.SendtoGrave(c,REASON_EFFECT) end
end
