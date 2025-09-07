--堕福的绝响 白夜回廊
local s,id,o=GetID()
function s.initial_effect(c)

	-- 6阶「堕福」超量怪兽×2
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,s.mfilter,nil,2,2)
	
	-- 这张卡用以上记的卡为超量素材的超量召唤才能特殊召唤
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	
	-- 这张卡只要在场上·墓地存在，这张卡的属性也当作「光」使用
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	
	-- 有光·暗属性的「堕福」怪兽全部在作为超量素材中的这张卡攻击力·守备力上升自己墓地的光·暗属性怪兽数量×500，不受对方怪兽的效果影响
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	e2:SetCondition(s.effcon)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.effcon)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
	-- 持有超量素材的这张卡在同1次的战斗阶段中可以作出最多有那个数量的攻击
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetCondition(s.racon)
	e5:SetValue(s.raval)
	c:RegisterEffect(e5)
end

-- 6阶「堕福」超量怪兽×2
function s.mfilter(c)
	return c:IsSetCard(0x666c) and c:IsRank(6)
end

-- 有光·暗属性的「堕福」怪兽全部在作为超量素材中的这张卡攻击力·守备力上升自己墓地的光·暗属性怪兽数量×500，不受对方怪兽的效果影响
function s.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER)
end

function s.val(e,c)
	return Duel.GetMatchingGroupCount(s.cfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)*500
end

function s.attfilter(c)
	return c:IsSetCard(0x666c) and c:IsType(TYPE_MONSTER)
end

function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	local att=0
	for tc in aux.Next(g) do
		if s.attfilter(tc) then
			att=att|tc:GetAttribute()
		end
	end
	local gattr=ATTRIBUTE_LIGHT|ATTRIBUTE_DARK
	return att&gattr==gattr
end

function s.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

-- 持有超量素材的这张卡在同1次的战斗阶段中可以作出最多有那个数量的攻击
function s.racon(e)
	return e:GetHandler():GetOverlayCount()>1
end

function s.raval(e,c)
	return e:GetHandler():GetOverlayCount()-1
end
