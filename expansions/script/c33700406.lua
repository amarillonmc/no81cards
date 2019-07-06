--Seyanaa
--AlphaKretin
--For Nemoma
local card = c33700406
local code = 33700406
function card.initial_effect(c)
	--battle indestructable
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--control
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(code, 0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(card.ctlcon)
	e2:SetTarget(card.ctltg)
	e2:SetOperation(card.ctlop)
	c:RegisterEffect(e2)
	--lose ATK
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE, 0)
	e3:SetValue(card.atkval)
	c:RegisterEffect(e3)
	--cannot NS
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1, 0)
	e4:SetCondition(card.nscon)
	c:RegisterEffect(e4)
	local e5 = e4:Clone()
	e5:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(e5)
	--cannot SS
	local e6 = Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(card.sscon)
	e6:SetTargetRange(1, 0)
	c:RegisterEffect(e6)
	--negate
	local e7 = Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_ONFIELD, 0)
	e7:SetCondition(card.negcon)
	e7:SetTarget(card.negtg)
	e7:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e7)
end
--helper function
function card.mcount(tp)
	return Duel.GetFieldGroupCount(tp, LOCATION_MZONE, 0) - 1
end

--control
function card.ctlcon(e, tp, eg, ep, ev, re, r, rp)
	return card.mcount(tp) == 0
end
function card.ctltg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then
		return e:GetHandler():IsControlerCanBeChanged()
	end
	Duel.SetOperationInfo(0, CATEGORY_CONTROL, e:GetHandler(), 1, 0, 0)
end
function card.ctlop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
		local zone = Duel.SelectDisableField(tp, 1, 0, LOCATION_MZONE, 0) >> 16
		if Duel.GetControl(c, 1 - tp, 0, 0, zone) then
			local e1 = Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE + PHASE_END)
			e1:SetTargetRange(1, 0)
			Duel.RegisterEffect(e1, tp)
		end
	end
end

--lose ATK
function card.atkval(e, c)
	if card.mcount(e:GetHandlerPlayer()) > 0 then
		return -800
	else
		return 0
	end
end

--cannot NS
function card.nscon(e)
	return card.mcount(e:GetHandlerPlayer()) > 2
end

--cannot SS
function card.sscon(e)
	return card.mcount(e:GetHandlerPlayer()) > 3
end

--negate
function card.negcon(e)
	return card.mcount(e:GetHandlerPlayer()) > 4
end
function card.negtg(e, c)
	return c:IsFaceup() and c ~= e:GetHandler()
end
