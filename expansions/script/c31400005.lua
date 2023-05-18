local m=31400005
local cm=_G["c"..m]
cm.name="寻找己名的命名者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,1,1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(0)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(cm.codecon)
	e3:SetOperation(cm.codeop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
	local c=e:GetHandler()
	local mc=c:GetMaterial():GetFirst()
	if c:IsSummonType(SUMMON_TYPE_LINK) and mc then
		local code=mc:GetCode()
		e:GetLabelObject():SetLabel(code)
		e:GetLabelObject():SetValue(code)
		Card.ReplaceEffect(mc,31400006,nil)
	end
end
function cm.con(e)
	return e:GetLabel()~=0 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.codecon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK 
end
function cm.codeop(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if code~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1)
	end
end