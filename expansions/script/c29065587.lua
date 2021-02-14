--灰喉·回流
function c29065587.initial_effect(c)
	aux.AddCodeList(c,29065586)
	c:EnableCounterPermit(0x11ae)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SET_AVAIABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c29065587.lvtg)
	e1:SetValue(c29065587.lvval)
	c:RegisterEffect(e1)
	--code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(29065586)
	c:RegisterEffect(e2)	
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e3:SetCondition(c29065587.eatcon)
	e3:SetValue(2)
	c:RegisterEffect(e3)
	--atk 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c29065587.akcon)   
	e4:SetValue(c29065587.akval)
	c:RegisterEffect(e4)
	--activate limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c29065587.actcon)
	e5:SetValue(c29065587.actlimit)
	c:RegisterEffect(e5)
end
function c29065587.lvtg(e,c)
	return c:IsLevelAbove(1) and c:GetCounter(0x11ae)>0 and c:IsSetCard(0x87af)
end
function c29065587.lvval(e,c,rc)
	local lv=c:GetLevel()
	if rc==e:GetHandler() then return 8
	else return lv end
end
function c29065587.eatcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c29065587.akfil(c)
	return c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER)
end
function c29065587.akcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,29065586) 
end
function c29065587.akval(e,c,rc)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c29065587.akfil,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)
	return g:GetClassCount(Card.GetCode)*400
end
function c29065587.actcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,29065586) 
end
function c29065587.actlimit(e,re,tp)
	return (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or (re:GetHandler():IsType(TYPE_SPELL) or re:GetHandler():IsType(TYPE_TRAP))) and re:GetHandler():IsLocation(LOCATION_SZONE)
end
























