--Destiny Cut
--AlphaKretin
--For Nemoma
local card = c33700405
local code = 33700405
function card.initial_effect(c)
	--activate
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE + CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(card.target)
	e1:SetOperation(card.activate)
	c:RegisterEffect(e1)
end

function card.target(e, tp, eg, ep, ev, re, r, rp, chk)
	local hg = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	if chk == 0 then
		return #hg > 0 and #hg == #hg:Filter(Card.IsAbleToRemove,nil,tp) and Duel.IsPlayerCanDraw(tp, 5)  
	end
	Duel.SetOperationInfo(0, CATEGORY_REMOVE, hg, hg:GetCount(), tp, LOCATION_HAND)
end

function card.activate(e, tp, eg, ep, ev, re, r, rp, chk)
	local hg = Duel.GetFieldGroup(tp, LOCATION_HAND, 0)
	if #hg > 0 and Duel.Remove(hg, POS_FACEDOWN, REASON_EFFECT) == #hg and Duel.Draw(tp, 5, REASON_EFFECT) == 5 then
		Duel.Hint(HINT_SELECTMSG, tp, aux.Stringid(code, 0)) --Select a phase to skip
		local opt = Duel.SelectOption(tp, 20, 24, 22) --Draw Phase, Battle Phase, Main Phase, from strings.conf
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(1,0)
		if opt == 0 then
			e1:SetCode(EFFECT_SKIP_DP)
		elseif opt == 1 then
			e1:SetCode(EFFECT_SKIP_BP)
		else --if opt == 2 is the only other option
			e1:SetCode(EFFECT_SKIP_M1)
			local e2 = e1:Clone()
			e2:SetCode(EFFECT_SKIP_M2)
			Duel.RegisterEffect(e2, tp)
		end
		Duel.RegisterEffect(e1, tp)
	end
	if Duel.GetFieldGroupCount(tp, LOCATION_MZONE + LOCATION_SZONE, 0) > 1 then --1 card is itself
		--become EP
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end