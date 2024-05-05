--银河眼时空龙甲
local m=22348412
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnableUnionAttribute(c,c22348412.filter)
	--link summon
	aux.AddLinkProcedure(c,c22348412.matfilter,1)
	c:EnableReviveLimit()
	--cannot be link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cant attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(2000)
	e3:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e3)
		--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(62753201,0))
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c22348412.rcon)
	e4:SetOperation(c22348412.rop)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetTarget(c22348412.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	
end
function c22348412.matfilter(c)
	return c:IsLinkRace(RACE_DRAGON) and (c:IsLevel(8) or c:IsRank(8))
end
function c22348412.filter(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ)
end
function c22348412.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c and c:IsSetCard(0x307b)
end
function c22348412.rmfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAbleToRemoveAsCost()
end
function c22348412.rcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return bit.band(r,REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and e:GetHandler():IsAbleToGraveAsCost() and ep==e:GetOwnerPlayer() and Duel.IsExistingMatchingCard(c22348412.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end
function c22348412.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c22348412.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	return Duel.Remove(g,POS_FACEUP,REASON_COST)
end

