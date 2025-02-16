local s, id = GetID()


function s.initial_effect(c)
	 
	
	-- 同调召唤条件：调整 + 调整以外的幻龙族怪兽1只以上
	c:EnableReviveLimit()	
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_WYRM),1)
	
	
	-- 效果①：支付1000LP破坏对方怪兽
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.descost)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	-- 效果②：墓地除外检索法宝魔法
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

--===== 效果①：支付LP破坏 =====--
function s.descost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.CheckLPCost(tp, 1000) end
	Duel.PayLPCost(tp, 1000)
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk == 0 then return Duel.IsExistingTarget(nil, tp, 0, LOCATION_MZONE, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
	local g = Duel.SelectTarget(tp, nil, tp, 0, LOCATION_MZONE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc, REASON_EFFECT)
	end
end

--===== 效果②：检索法宝魔法 =====--

function s.thfilter(c)
	return c:IsSetCard(0x957) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function s.thop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end