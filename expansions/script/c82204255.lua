local m=82204255
local cm=_G["c"..m]
cm.name="小红帽「修女」"
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,2,2)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetValue(cm.matval)
	c:RegisterEffect(e0)
	--atkup  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetCode(EFFECT_UPDATE_ATTACK)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(cm.val)  
	c:RegisterEffect(e1)  
	--indes  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(cm.indtg)  
	e2:SetValue(1)  
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
end
cm.SetCard_01_RedHat=true 
function cm.matfilter(c)
	return c.SetCard_01_RedHat and (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS)))
end
function cm.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true, true
end
function cm.val(e,c)  
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,e:GetHandler())*500  
end  
function cm.atkfilter(c)  
	return c:IsFaceup() and c.SetCard_01_RedHat
end  
function cm.indtg(e,c)  
	return c.SetCard_01_RedHat and c:GetMutualLinkedGroupCount()>0  
end  