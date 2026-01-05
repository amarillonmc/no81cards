--瞬耀-梅萨F01型
local s,id=GetID()
s.named_with_FlashRadiance=1
function s.FlashRadiance(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FlashRadiance
end
function s.XiGundam(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_XiGundam
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOHAND + CATEGORY_DECKDES + CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function s.spfilter(c, e, tp)
	return s.FlashRadiance(c) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc, e, tp) end
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_MZONE) >= 2
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false)
		and Duel.IsExistingTarget(s.spfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectTarget(tp, s.spfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, g + e:GetHandler(), 2, 0, 0)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) 
	   and Duel.GetLocationCount(tp, LOCATION_MZONE) >= 2 
	   and c:IsCanBeSpecialSummoned(e, 0, tp, false, false) 
	   and tc:IsCanBeSpecialSummoned(e, 0, tp, false, false) then
		
		Duel.SpecialSummonStep(c, 0, tp, tp, false, false, POS_FACEUP)
		Duel.SpecialSummonStep(tc, 0, tp, tp, false, false, POS_FACEUP)
		Duel.SpecialSummonComplete()
		
		if tc:IsCode(40020396) and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
			tc:AddCounter(0x1f1e, 1)
		end
	end
end

function s.xi_check(c)

	return c:IsFaceup() and s.XiGundam(c)  and c:GetCounter(0x1f1e) >= 5
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsPlayerCanDiscardDeck(tp, 1) end
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	local count = 1
	if Duel.IsExistingMatchingCard(s.xi_check, tp, LOCATION_MZONE, 0, 1, nil) then
		count = 3
	end
	
	if Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) < count then return end
	
	Duel.ConfirmDecktop(tp, count)
	local g = Duel.GetDecktopGroup(tp, count)
	
	if g:GetCount() > 0 then
		Duel.DisableShuffleCheck()
		
		local thfilter = function(c) 
			return aux.IsCodeListed(c, 40020396) and c:IsAbleToHand() 
		end
		
		if g:IsExists(thfilter, 1, nil) and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sg = g:FilterSelect(tp, thfilter, 1, 1, nil)
			Duel.SendtoHand(sg, nil, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, sg)
			g:Sub(sg)
		end
		Duel.SendtoGrave(g, REASON_EFFECT + REASON_REVEAL)
	end
end
