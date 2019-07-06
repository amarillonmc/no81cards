--Hyper Dimension Idol, Hoshino Yumemi
--AlphaKretin
--For Nemoma
local s = c33700428
local id = 33700428
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c, aux.FilterBoolFunctionEx(Card.IsType, TYPE_TOKEN), 4, 4)
	--battle indestructable
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--direct
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--count damage
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(0)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_TURN_END)
	e4:SetLabelObject(e3)
	e4:SetCondition(s.resetop)
	c:RegisterEffect(e4)
	--skip
	local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CHAIN_UNIQUE)
	e5:SetLabelObject(e3)
	e5:SetCondition(s.skipcon)
	e5:SetOperation(s.skipop)
	c:RegisterEffect(e5)
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
	if ep == tp and (r & REASON_BATTLE == REASON_BATTLE or (r & REASON_EFFECT == REASON_EFFECT and rp == 1 - tp)) then
		e:SetLabel(e:GetLabel() + ev)
	end
end

function s.resetop(e, tp, eg, ep, ev, re, r, rp)
	e:GetLabelObject():SetLabel(0)
	return false
end

function s.skipcon(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() ~= tp and e:GetLabelObject():GetLabel() >= 3000
end

function s.skipop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(3000)
	e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END + RESET_SELF_TURN)
	c:RegisterEffect(e1)
	Duel.SkipPhase(1 - tp, PHASE_MAIN1, RESET_PHASE + PHASE_END, 1)
	Duel.SkipPhase(1 - tp, PHASE_BATTLE, RESET_PHASE + PHASE_END, 1)
	Duel.SkipPhase(1 - tp, PHASE_MAIN2, RESET_PHASE + PHASE_END, 1)
	Duel.SkipPhase(1 - tp, PHASE_END, RESET_PHASE + PHASE_END, 1)
	Duel.SkipPhase(tp, PHASE_DRAW, RESET_PHASE + PHASE_END, 2)
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE + PHASE_END)
	e2:SetCondition(s.drcon)
	e2:SetOperation(s.drop)
	Duel.RegisterEffect(e2, tp)
end

function s.drcon(e, tp, eg, ep, ev, re, r, rp)
	return tp == Duel.GetTurnPlayer()
end

function s.drop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Draw(tp, 1, REASON_EFFECT)
	e:Reset()
end
