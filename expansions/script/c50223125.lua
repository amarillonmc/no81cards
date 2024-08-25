--恶之数码兽 恶魔兽
function c50223125.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c50223125.ffilter1,c50223125.ffilter2,true)
	--indesbybattle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetCondition(c50223125.con1)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	e2:SetCondition(c50223125.con2)
	c:RegisterEffect(e2)
	--indesbyeffect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	e3:SetCondition(c50223125.con3)
	c:RegisterEffect(e3)
	--cannot remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetValue(1)
	e4:SetCondition(c50223125.con4)
	c:RegisterEffect(e4)
end
function c50223125.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
end
function c50223125.ffilter2(c)
	return c:IsAttribute(ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH+ATTRIBUTE_WIND)
end
function c50223125.valfilter1(c)
	return c:IsFusionAttribute(ATTRIBUTE_WATER)
end
function c50223125.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return mg:IsExists(c50223125.valfilter1,1,nil)
end
function c50223125.valfilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_FIRE)
end
function c50223125.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return mg:IsExists(c50223125.valfilter2,1,nil)
end
function c50223125.valfilter3(c)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH)
end
function c50223125.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return mg:IsExists(c50223125.valfilter3,1,nil)
end
function c50223125.valfilter4(c)
	return c:IsFusionAttribute(ATTRIBUTE_WIND)
end
function c50223125.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return mg:IsExists(c50223125.valfilter4,1,nil)
end