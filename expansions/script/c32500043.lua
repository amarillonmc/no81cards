--反叛 王之谋略
--卡号：32500025
--反叛字段代码：0xa001
--反击陷阱

local s,id=GetID()
local SET_REBELLION=0xa001

function s.initial_effect(c)
	--对方从手卡发动陷阱卡的场合，这张卡也能从手卡发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)

	--①：自己场上有对应怪兽存在，对方从手卡把卡或卡的效果发动时，那个发动无效
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.negcon1)
	e1:SetTarget(s.negtg1)
	e1:SetOperation(s.negop1)
	c:RegisterEffect(e1)
end

--光・暗属性的战士族・魔法师族怪兽
function s.monfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER))
end

--获取连锁发动位置
function s.chainloc(ev)
	local te,tp,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return te,tp,loc
end

--对方从手卡发动陷阱卡的场合，这张卡也能从手卡发动
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetCurrentChain()
	if ct==0 then return false end

	local te,p,loc=s.chainloc(ct)
	if not te then return false end
	local tc=te:GetHandler()

	return p==1-tp
		and loc
		and (loc&LOCATION_HAND)~=0
		and te:IsActiveType(TYPE_TRAP)
		and tc:IsType(TYPE_TRAP)
end

--①：自己场上有对应怪兽存在，对方从手卡把卡或卡的效果发动时
function s.negcon1(e,tp,eg,ep,ev,re,r,rp)
	if rp~=1-tp then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	if not Duel.IsExistingMatchingCard(s.monfilter,tp,LOCATION_MZONE,0,1,nil) then return false end

	local te,p,loc=s.chainloc(ev)
	if not te or p~=1-tp or not loc then return false end

	return (loc&LOCATION_HAND)~=0
end

function s.negtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.negop1(e,tp,eg,ep,ev,re,r,rp)
	--那个发动无效
	Duel.NegateActivation(ev)

	--这个效果发动后，直到回合结束时自己不是光・暗属性的战士族・魔法师族怪兽不能特殊召唤
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

--自肃：不是光・暗属性的战士族・魔法师族怪兽不能特殊召唤
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
		and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)))
end