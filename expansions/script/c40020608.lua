--天魔王 六魔神 -气之型-
local s, id = GetID()
s.named_with_ForceFighter=1
function s.DrivenForce(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_DrivenForce
end

function s.ForceFighter(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ForceFighter
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020585)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,6,2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.pzcon)
	e1:SetCost(s.pzcost)
	e1:SetTarget(s.pztg)
	e1:SetOperation(s.pzop)
	c:RegisterEffect(e1)


	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	c:RegisterEffect(e2)

	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end

function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end

function s.pzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.pzfilter(c,tp)
	if c:IsCode(40020585) then return not c:IsForbidden() end
	local has_yamato = Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,nil,40020585)
	if has_yamato then
		return (s.DrivenForce(c) or s.ForceFighter(c)) 
			and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
	end
	
	return false
end

function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1 = Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if chk==0 then return b1 
		and Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) 
	end
end

function s.pzop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.pzfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end


function s.damcon(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(Card.IsFaceup, tp, LOCATION_MZONE, 0, nil)
	if g:GetClassCount(Card.GetAttribute) < 2 then return false end
	
	local tc = eg:GetFirst()

	local a = Duel.GetAttacker()
	if not a then return false end
	if a:IsControler(1-tp) then a = Duel.GetAttackTarget() end
	return a and (s.ForceFighter(a) or s.MachForce(a)) and ep ~= tp
end

function s.damop(e, tp, eg, ep, ev, re, r, rp)
	Duel.ChangeBattleDamage(ep, Duel.GetBattleDamage(ep) * 2)
end

function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
	local a = Duel.GetAttacker()
	return a and a:IsControler(tp) and (s.ForceFighter(a) or s.MachForce(a))
end

function s.atkop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	local a = Duel.GetAttacker()
	local g = Duel.GetMatchingGroup(Card.IsAbleToDeck, 1-tp, LOCATION_MZONE, 0, nil)
	
	local selected = false
	if g:GetCount() > 0 then
		if Duel.SelectYesNo(1-tp, aux.Stringid(id, 1)) then
			Duel.Hint(HINT_SELECTMSG, 1-tp, HINTMSG_TODECK)
			local sg = g:Select(1-tp, 1, 1, nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg, nil, SEQ_DECKSHUFFLE, REASON_RULE)
			selected = true
		end
	end
	
	if not selected then
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		a:RegisterEffect(e1)
		
		Duel.ChangeAttackTarget(nil)
	end
end