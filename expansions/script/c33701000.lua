--残星倩影 读人心
if not pcall(function() require("expansions/script/c33700990") end) then require("script/c33700990") end
local m=33701000
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2)
	local e1=rsef.FV_CANNOT_BE_TARGET(c,"battle",nil,cm.cfilter,{LOCATION_MZONE,LOCATION_MZONE },cm.con)
	local e3=rsef.FV_CANNOT_BE_TARGET(c,"effect",nil,cm.cfilter,{LOCATION_MZONE,LOCATION_MZONE },cm.con)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	e3:SetLabelObject(e2)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mat=c:GetMaterial()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and #mat>0 and mat:IsExists(Card.IsSetCard,1,nil,0x144d)
end
function cm.regop(e,tp)
	if cm.regcon(e,tp,eg,ep,ev,re,r,rp) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end 
end
function cm.con(e)
	return e:GetLabelObject():GetLabel()==1
end
function cm.cfilter(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x144d)
end