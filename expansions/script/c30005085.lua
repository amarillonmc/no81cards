--深暗的叛逆 克努尔
local m=30005085
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
end
--link summon
function cm.matfilter(c)
	return c:IsLinkType(TYPE_PENDULUM) and  c:IsLevelAbove(7)
end
function cm.repfilter(c,tp)
	return c:GetOwner()==tp and c:GetDestination()==LOCATION_GRAVE and not c:IsLocation(LOCATION_EXTRA) and c:GetOriginalType()&TYPE_PENDULUM~=0
end
function cm.repfilter2(c,tp)
	return c:GetOwner()==tp  and c:GetOriginalType()&TYPE_PENDULUM~=0
end
function cm.Xyzcheck(c,tp)
	local rg=c:GetOverlayGroup()
	return rg:GetCount()>0 and rg:IsExists(cm.repfilter2,1,nil,tp)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) or eg:IsExists(cm.Xyzcheck,1,nil,tp) end
	local g=eg:Filter(cm.repfilter,nil,tp)
	for tc in aux.Next(eg) do
		local rg=tc:GetOverlayGroup()
		for rc in aux.Next(rg) do
			if rc:GetOwner()==tp  and rc:GetOriginalType()&TYPE_PENDULUM~=0 then
				Duel.SendtoExtraP(rc,rp,r)
			end
		end
	end
	Duel.SendtoExtraP(g,rp,r)
	return false
end
function cm.repval(e,c)
	return true
end