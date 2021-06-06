local m=31402000
local cm=_G["c"..m]
cm.name="时计塔的独奏者-万感吟游之青音"
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
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_FIELD)
	e3_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3_1:SetRange(LOCATION_MZONE)
	e3_1:SetTargetRange(1,0)
	e3_1:SetCondition(cm.actcon)
	e3_1:SetValue(cm.actlimit)
	e3_1:SetLabel(0)
	c:RegisterEffect(e3_1)
	local e3_2=e3_1:Clone()
	e3_2:SetTargetRange(0,1)
	e3_2:SetLabel(1)
	c:RegisterEffect(e3_2)
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
	return not Duel.IsExistingMatchingCard(Card.IsType,bit.bxor(e:GetLabel(),e:GetHandlerPlayer()),LOCATION_MZONE,0,1,nil,TYPE_XYZ)
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