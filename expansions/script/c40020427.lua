--瞬耀-哈维萨·诺亚[U.C.0105]
local s,id=GetID()
s.named_with_FlashRadiance=1
function s.FlashRadiance(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FlashRadiance
end
s.named_with_Hathaway=1
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
	
	aux.EnableUnionAttribute(c,s.filter)


	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 2))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1, id)
	e3:SetCondition(s.e3con)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
end
s.has_text_type=TYPE_UNION
function s.filter(c)
	return s.XiGundam(c)
end

function s.e3con(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_SZONE)
end

function s.eqfilter(c)
	return s.XiGundam(c) and c:IsFaceup()
end

function s.e3tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	if chk == 0 then return Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
		and Duel.IsExistingTarget(s.eqfilter, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
	Duel.SelectTarget(tp, s.eqfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_EQUIP, e:GetHandler(), 1, 0, 0)
end

function s.e3op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Equip(tp, c, tc) then
			aux.SetUnionState(c)
		end
	end
end