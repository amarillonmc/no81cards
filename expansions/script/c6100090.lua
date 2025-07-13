--微光小队-秋晴
local s, id = GetID()

function s.initial_effect(c)

	-- 效果①：自己场上怪兽表示形式变更时发动
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_POSITION + CATEGORY_SEARCH + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.poscon1)
	e1:SetTarget(s.postg1)
	e1:SetOperation(s.posop1)
	c:RegisterEffect(e1)
	
	-- 效果②：双方回合除外墓地自身变更表示形式
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id + 1)
	e2:SetCost(s.poscost)
	e2:SetTarget(s.postg2)
	e2:SetOperation(s.posop2)
	c:RegisterEffect(e2)
end

-- 效果①条件：自己场上怪兽表示形式变更
function s.filter(c,tp)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return c:IsControler(tp) and ((pp==0x1 and np==0x4) or (pp==0x4 and np==0x1))
end
function s.poscon1(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.filter, 1, nil, tp)
end

function s.thfilter(c)
	return c:IsSetCard(0x961c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end

-- 效果①目标：变更自身表示形式，检索魔法/陷阱
function s.postg1(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, e:GetHandler(), 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

-- 效果①操作
function s.posop1(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 变更自身表示形式
	if c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP) then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
	
	-- 检索微光小队魔法/陷阱
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil) 
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end

-- 效果②代价：除外自身
function s.poscost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(), POS_FACEUP, REASON_COST)
end

-- 效果②目标：选择场上1只怪兽
function s.postg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsCanChangePosition, tp, LOCATION_MZONE, LOCATION_MZONE, 1, nil) end
end

-- 效果②操作：变更表示形式
function s.posop2(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
	local g = Duel.SelectMatchingCard(tp, Card.IsCanChangePosition, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	if #g > 0 then
		Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end