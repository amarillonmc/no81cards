--忘川·裁断
local s,id,o=GetID()
function s.initial_effect(c)
	--①：无效手卡发动的效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--②：手卡发动许可
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.earthfilter(c)
	-- 场上需表侧表示才算属性，墓地无所谓
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	-- 对方从手卡发动 & 可以被无效 & 自己场上/墓地有地属性怪兽
	return rp==1-tp and re:GetActivateLocation()==LOCATION_HAND and Duel.IsChainDisablable(ev)
		and Duel.IsExistingMatchingCard(s.earthfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

-- === 效果② ===
function s.normalfilter(c)
	-- 通常怪兽 (场上需表侧)
	return c:IsType(TYPE_NORMAL) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

function s.handcon(e)
	-- 自己的场上(怪兽区)·墓地有通常怪兽
	return Duel.IsExistingMatchingCard(s.normalfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end