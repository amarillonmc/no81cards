--佩涅罗佩
local s,id=GetID()
s.named_with_Penelope=1
function s.Penelope(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Penelope
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)

	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_COUNTER + CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(s.e2con_atk)
	e2:SetCost(s.e2cost)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetCondition(s.e2con_def)
	e3:SetCost(s.e2cost)
	e3:SetTarget(s.e2tg)
	e3:SetOperation(s.e2op)
	c:RegisterEffect(e3)


	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(s.e3con)
	c:RegisterEffect(e4)
	local e5 = Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0, 1)
	e5:SetCondition(s.e3con)
	c:RegisterEffect(e5)
end

function s.e1con(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetAttacker():IsControler(1-tp)
end

function s.xi_filter(c)
	return c:IsCode(40020396) and c:IsFaceup()
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xi_filter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.xi_filter, tp, LOCATION_MZONE, 0, 1, nil)
		and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0
		and e:GetHandler():IsCanBeSpecialSummoned(e, 0, tp, false, false) end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_FACEUP)
	Duel.SelectTarget(tp, s.xi_filter, tp, LOCATION_MZONE, 0, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_COUNTER, nil, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, e:GetHandler(), 1, 0, 0)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	local c = e:GetHandler()
	
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct = 1
		if Duel.IsExistingMatchingCard(Card.IsSummonLocation, tp, 0, LOCATION_MZONE, 1, nil, LOCATION_EXTRA) then
			ct = 2
		end
		
		if tc:AddCounter(0x1f1e, ct) then
			for i = 1, ct do
				Duel.RegisterFlagEffect(tp, 40020396, 0, 0, 1)
			end
			
			if c:IsRelateToEffect(e) and Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) > 0 then
				local at = Duel.GetAttacker()
				if at:IsAttackable() and not at:IsImmuneToEffect(e) then
					if Duel.ChangeAttackTarget(c) then
						local e_ind = Effect.CreateEffect(c)
						e_ind:SetType(EFFECT_TYPE_SINGLE)
						e_ind:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
						e_ind:SetValue(1)
						e_ind:SetReset(RESET_PHASE + PHASE_DAMAGE)
						c:RegisterEffect(e_ind)
						
						Duel.CalculateDamage(at, c)
					end
				end
			end
		end
	end
end

function s.e2con_atk(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetAttacker() == e:GetHandler()
end

function s.e2con_def(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetAttackTarget() == e:GetHandler()
end

function s.e2cost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsCanRemoveCounter(tp, 1, 0, 0x1f1e, 3, REASON_COST) end
	Duel.RemoveCounter(tp, 1, 0, 0x1f1e, 3, REASON_COST)
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsCanTurnSet, tp, 0, LOCATION_MZONE, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_POSITION, nil, 1, 0, 0)
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(Card.IsCanTurnSet, tp, 0, LOCATION_MZONE, nil)
	if g:GetCount() > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
		local sg = g:Select(tp, 1, 1, nil)
		Duel.HintSelection(sg)
		Duel.ChangePosition(sg, POS_FACEDOWN_DEFENSE)
	end
end

function s.e3con(e)
	local tp = e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND)
end
