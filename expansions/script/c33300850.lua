local s, id = GetID()
function s.initial_effect(c)
	-- 场地发动
	c:EnableCounterPermit(0x569)
	
	-- ①: 发动时检索
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	-- ②
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	-- ③
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE + PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end
-- 检索
function s.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(0x569) and c:IsAbleToHand()
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
	if #g > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg = g:Select(tp, 1, 1, nil)
		Duel.SendtoHand(sg, nil, REASON_EFFECT)
		Duel.ConfirmCards(1 - tp, sg)
	end
end
-- 永续
function s.desfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetAttack() == 0 and c:GetAttack() ~= c:GetBaseAttack() and c:GetOwner()==tp
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsFaceup() then return end
	local g = Duel.GetMatchingGroup(s.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil,tp)
	local g1 = Duel.GetMatchingGroup(s.desfilter, tp, LOCATION_MZONE, LOCATION_MZONE, nil,1-tp)
	if #g > 0 then
		local destroy_count = #g
		Duel.Destroy(g, REASON_EFFECT)
		Duel.Damage(tp, destroy_count * 600, REASON_EFFECT)
	end
	if #g1 > 0 then
		local destroy_count2 = #g1
		Duel.Destroy(g1, REASON_EFFECT)
		Duel.Damage(1 - tp, destroy_count2 * 600, REASON_EFFECT)
	end
end
-- 回合结束伤害效果
function s.damtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, PLAYER_ALL, 600)
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Damage(tp, 600, REASON_EFFECT)
	Duel.Damage(1 - tp, 600, REASON_EFFECT)
end