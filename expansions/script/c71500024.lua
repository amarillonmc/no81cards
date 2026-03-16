--梦之书之主
function c71400024.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c71400024.mfilter,c71400024.xyzcheck,2,2)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c71400024.con1)
	c:RegisterEffect(e1)
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetCost(c71400024.cost)
	e2:SetOperation(c71400024.op)
	c:RegisterEffect(e2)
	--[[spsummon cost
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCost(c71400024.spcost)
	c:RegisterEffect(e3)
	--]]
end
function c71400024.spcost(e,c,tp)
	return yume.YumeCheck(c)
end
function c71400024.mfilter(c,xyzc)
	local function f(c) return c:IsFaceup() and c:IsSetCard(0x3714) end
	return c:IsXyzType(TYPE_XYZ) and c:GetRank()==4 and Duel.IsExistingMatchingCard(f,xyzc:GetControler(),LOCATION_FZONE,0,1,nil)
end
function c71400024.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)==1 and g:GetFirst():GetRank()==4
end
function c71400024.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3715)
end
function c71400024.con1(e)
	return Duel.IsExistingMatchingCard(c71400024.filter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c71400024.cost(e,c,tp)
	return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST)
end
function c71400024.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end