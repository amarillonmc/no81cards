--妮娜・厄里斯
--卡号：32500015
--反叛字段代码：0xa001
--链接怪兽

local s,id=GetID()
local SET_REBELLION=0xa001

function s.initial_effect(c)
	--连接召唤：光・暗属性的战士族・魔法师族怪兽×4
	aux.AddLinkProcedure(c,s.matfilter,4,4)
	c:EnableReviveLimit()

	--①：对方把卡的效果发动时，那个效果无效
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.negcon1)
	e1:SetTarget(s.negtg1)
	e1:SetOperation(s.negop1)
	c:RegisterEffect(e1)

	--②：对方把卡的效果发动时，那张卡破坏
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.descon2)
	e2:SetTarget(s.destg2)
	e2:SetOperation(s.desop2)
	c:RegisterEffect(e2)
end

--连接素材：光・暗属性的战士族・魔法师族怪兽
function s.matfilter(c,lc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK,lc,sumtype,tp)
		and (c:IsRace(RACE_WARRIOR,lc,sumtype,tp) or c:IsRace(RACE_SPELLCASTER,lc,sumtype,tp))
end

--①：对方把卡的效果发动时
function s.negcon1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end

function s.negtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.negop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

--②：对方把卡的效果发动时
function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==1-tp
		and rc
		and rc:IsOnField()
		and rc:IsDestructable()
end

function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then
		return rc
			and rc:IsOnField()
			and rc:IsDestructable()
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
end

function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc and rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end