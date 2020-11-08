local m=31420000
local cm=_G["c"..m]
cm.name="万感吟游者"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.TRUE,4,4,cm.lmfilter)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TRUE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetCondition(cm.con)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(cm.matcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetCondition(cm.actcon)
	e3:SetValue(cm.actlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_MUST_USE_MZONE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.sumtg)
	e4:SetTargetRange(0x1ff,0x1ff)
	e4:SetValue(cm.sumval)
	c:RegisterEffect(e4)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.lmfilter(g,lc)
	return g:GetClassCount(cm.getlvrklk,c)==1
end
function cm.getlvrklk(c)
	if c:IsLevelAbove(0) then return c:GetLevel() end
	if c:IsRankAbove(0) then return c:GetRank() end
	return c:GetLink()
end
function cm.matcheck(e,c)
	e:GetLabelObject():SetValue(c:GetMaterial():GetSum(cm.getlvrklk)/4)
end
function cm.actcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsType,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil,TYPE_XYZ)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.sumtg(e,c)
	return not c:IsType(TYPE_XYZ)
end
function cm.sumval(e,c,fp,rp,r)
	return 0x7f007f & ~e:GetHandler():GetLinkedZone()
end