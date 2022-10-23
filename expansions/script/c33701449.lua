--纯洁之魂 - 白野
local m=33701449
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,4,cm.lcheck)
	c:EnableReviveLimit()
	--Effect 1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e13:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e13:SetTargetRange(1,0)
	e13:SetTarget(cm.sumlimit)
	c:RegisterEffect(e13)
	--Effect 2  
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetCode(EFFECT_UPDATE_ATTACK)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e01:SetRange(LOCATION_MZONE)
	e01:SetValue(cm.atkval)
	c:RegisterEffect(e01)
	--Effect 3 
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(cm.tkcon)
	e7:SetValue(aux.imval1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e8:SetValue(aux.tgoval)
	c:RegisterEffect(e8)
	--Effect 4 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(cm.imcon)
	e1:SetValue(0)
	c:RegisterEffect(e1)
end
--link summon
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,2,nil,TYPE_TOKEN)
end
--Effect 1
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsType(TYPE_TOKEN)
end
--Effect 2
function cm.atkval(e,c)
	local g=e:GetHandler():GetLinkedGroup():FilterCount(Card.IsType,nil,TYPE_TOKEN)
	return g*2000
end
--Effect 3 
function cm.tkcon(e)
	return Duel.IsExistingMatchingCard(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,TYPE_TOKEN)
end
--Effect 4 
function cm.imcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==1
end 