--戏法开幕
local s,id,o=GetID()
function s.initial_effect(c)
	-- 激活卡片 (效果①)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(43420000,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_SSET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,43420000)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.operation1)
	c:RegisterEffect(e1)
	-- 墓地效果 (效果②)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43420000,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,43420000+1)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end

----------------------------------------------------------------
-- ① 效果的函数实现
----------------------------------------------------------------

-- 丢弃手牌过滤：任意手牌皆可丢弃
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

-- 卡组盖放过滤：必须是通常陷阱卡
function s.setfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSSetable()
end

function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end

function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

----------------------------------------------------------------
-- ② 效果的函数实现
----------------------------------------------------------------

function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	-- 给玩家注册一个在手卡发动陷阱卡的效果
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCountLimit(1)
	e1:SetTarget(s.acttg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.acttg(e,c)
	return c:IsType(TYPE_TRAP)
end