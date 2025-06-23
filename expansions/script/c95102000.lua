--馄饨剩汤 主厨
function c95102000.initial_effect(c)
	-- 连接素材要求
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c95102000.matfilter,1)
    -- 效果外抗性
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UNRELEASABLE_SUM)
    e1:SetRange(LOCATION_MZONE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(95102001,2))
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e2:SetDescription(aux.Stringid(95102001,2))
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetDescription(aux.Stringid(95102001,3))
    e3:SetValue(c95102000.lim)
    c:RegisterEffect(e3)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e4:SetDescription(aux.Stringid(95102001,4))
    c:RegisterEffect(e4)
    local e5=e1:Clone()
    e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e5:SetDescription(aux.Stringid(95102001,5))
    c:RegisterEffect(e5)
    local e6=e1:Clone()
    e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e6:SetDescription(aux.Stringid(95102001,6))
    c:RegisterEffect(e6)
    -- 卡组盖放
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(95102000,0))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,95102000)
	e7:SetCost(c95102000.cost1)
	e7:SetTarget(c95102000.tg1)
	e7:SetOperation(c95102000.op1)
	c:RegisterEffect(e7)
    --[[-- 限制攻击对象
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,LOCATION_MZONE)
	e8:SetCondition(c95102000.con2)
	e8:SetValue(c95102000.val2)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e9:SetValue(1)
	c:RegisterEffect(e9)]]
end
-- 连接素材
function c95102000.matfilter(c)
	return c:IsLevel(1) and c:IsSetCard(0xbbc)
end
-- 效果外抗性
function c95102000.lim(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
-- 1
function c95102000.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c95102000.filter11(c,code)
	return c:IsCode(code) and (c:IsFaceup() or not c:IsOnField())
end
function c95102000.filter1(c,tp)
	return c:IsSetCard(0xbbc) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
	and not Duel.IsExistingMatchingCard(c95102000.filter11,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c95102000.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c95102000.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(95102000,0))
end
function c95102000.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c95102000.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
--[[-- 2
function c95102000.filter2(c)
	return c:IsSetCard(0xbbc) and c:IsFaceup()
end
function c95102000.con2(e)
	return Duel.IsExistingMatchingCard(c95102000.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c95102000.val2(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	return not tg:IsContains(c) or c:IsFacedown()
end]]
