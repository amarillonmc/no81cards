--宇宙军阀首领-巴克特利安
local m=13257235
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	--cannot special summon
	local e11=Effect.CreateEffect(c)
	e11:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SPSUMMON_CONDITION)
	e11:SetValue(aux.FALSE)
	c:RegisterEffect(e11)
	--summon with no tribute
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(m,3))
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_SUMMON_PROC)
	e12:SetCondition(cm.ntcon)
	c:RegisterEffect(e12)
	--inactivatable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_FZONE,0)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.econ)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	
end
function cm.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_HAND)>=3
end
function cm.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:IsActiveType(TYPE_SPELL) and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.econ(e)
	return e:GetHandler():GetControler():GetFieldCard(LOCATION_SZONE,5)~=nil
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
