--瞬耀-加乌曼·诺比尔
local s,id=GetID()
s.named_with_FlashRadiance=1
function s.FlashRadiance(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FlashRadiance
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)
	
	aux.EnableUnionAttribute(c,s.filter)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY + EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1, id)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)	
end
function s.filter(c)
	return c:IsRace(RACE_MACHINE)
end

function s.cfilter(c, tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_MACHINE) 
	   and aux.IsCodeListed(c, 40020396)
end

function s.eqtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return eg:IsContains(chkc) and s.cfilter(chkc, tp) end

	local g = eg:Filter(s.cfilter, nil, tp)
	if chk == 0 then return g:GetCount() > 0 and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)

	local tc = g:Select(tp, 1, 1, nil):GetFirst()
	Duel.SetTargetCard(tc)
	
	Duel.SetOperationInfo(0, CATEGORY_EQUIP, e:GetHandler(), 1, 0, 0)
end

function s.eqop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Equip(tp, c, tc) then

			aux.SetUnionState(c)
		end
	end
end