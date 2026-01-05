--瞬耀-英勇号
local s,id=GetID()
s.named_with_FlashRadiance=1


function s.Hathaway(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Hathaway
end
function s.XiGundam(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_XiGundam
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND + CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1, id + EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)


	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 1))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1, id)
	e4:SetTarget(s.e3tg)
	e4:SetOperation(s.e3op)
	c:RegisterEffect(e4)
end


function s.thfilter(c, expand)
	if c:IsCode(40020396) and c:IsAbleToHand() then return true end
	if expand and aux.IsCodeListed(c, 40020396) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() then return true end
	return false
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 0, tp, LOCATION_DECK)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	
	local expand = Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsCode(40020396) end, tp, LOCATION_MZONE, 0, 1, nil)
	
	local g = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil, expand)
	
	if g:GetCount() > 0 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local sg = g:Select(tp, 1, 1, nil)
		Duel.SendtoHand(sg, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, sg)
	end
end

function s.disop(e, tp, eg, ep, ev, re, r, rp)
	if ep == tp then return end
	local rc = re:GetHandler()
	if rc:IsLocation(LOCATION_ONFIELD) and rc:IsFacedown() then
		Duel.NegateEffect(ev)
	end
end

function s.eqfilter(c, tc, tp)
	return s.Hathaway(c) and c:IsType(TYPE_UNION) 
	   and c:CheckUnionTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end

function s.e3tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.XiGundam(chkc) and chkc:IsFaceup() end
	if chk == 0 then
		if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return false end
		return Duel.IsExistingTarget(function(tc) 
			return s.XiGundam(tc) and tc:IsFaceup() 
			   and Duel.IsExistingMatchingCard(s.eqfilter, tp, LOCATION_DECK, 0, 1, nil, tc, tp)
		end, tp, LOCATION_MZONE, 0, 1, nil)
	end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	local tc = Duel.SelectTarget(tp, function(tc) 
			return s.XiGundam(tc) and tc:IsFaceup() 
			   and Duel.IsExistingMatchingCard(s.eqfilter, tp, LOCATION_DECK, 0, 1, nil, tc, tp)
		end, tp, LOCATION_MZONE, 0, 1, nil)
	
	Duel.SetOperationInfo(0, CATEGORY_EQUIP, nil, 1, tp, LOCATION_DECK)
end

function s.e3op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	local tc = Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
		local g = Duel.SelectMatchingCard(tp, s.eqfilter, tp, LOCATION_DECK, 0, 1, 1, nil, tc, tp)
		local ec = g:GetFirst()
		if ec then
			if Duel.Equip(tp, ec, tc) then
				aux.SetUnionState(ec)
			end
		end
	end
end
