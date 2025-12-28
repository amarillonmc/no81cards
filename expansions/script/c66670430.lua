--苍途所许的唯一
local s,id,o=GetID()
function s.initial_effect(c)
	
	-- 自己场上有「苍途」仪式怪兽存在的场合才能发动，双方直到自身场上的怪兽变成1只为止必须送去墓地
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
	-- 自己的额外卡组没有卡存在的场合，这张卡在盖放的回合也能发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.actcon)
	c:RegisterEffect(e2)	
end

-- 自己场上有「苍途」仪式怪兽存在的场合才能发动，双方直到自身场上的怪兽变成1只为止必须送去墓地
function s.cfilter(c)
	return c:IsSetCard(0x666d) and c:IsType(TYPE_RITUAL) and c:IsFaceup()
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local b1=#g1>1
	local b2=#g2>1
	if chk==0 then return b1 or b2 end
	local g3=g1+g2
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g3,1,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if #g1>1 then
		local ct=#g1-1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g1:Select(tp,ct,ct,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
	if #g2>1 then
		local ct=#g2-1
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g2:Select(1-tp,ct,ct,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end

-- 自己的额外卡组没有卡存在的场合，这张卡在盖放的回合也能发动
function s.actcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_EXTRA,0)==0
end
