local m=31417008
local cm=_G["c"..m]
cm.name="圣域歌姬-小胡萝卜"
if not pcall(function() require("expansions/script/c31417000") end) then require("expansions/script/c31417000") end
function cm.initial_effect(c)
	Seine_Vocaloid.enable(c,8)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	e2:SetTarget(cm.target)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetValue(-400)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)>0 then return end
	e:SetLabel(Duel.AnnounceAttribute(e:GetHandlerPlayer(),1,0x7f))
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0,0)
end
function cm.target(e,c)
	if e:GetHandler():GetFlagEffect(m)==0 then return false end
	return c:IsAttribute(e:GetLabelObject():GetLabel())
end