--过卷齿车 摇晃天秤
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check = true
		s.chain_count = {[0]=0, [1]=0} -- 记录整场决斗的总发动次数
		s.last_ss_snapshot = {[0]=0, [1]=0} -- 记录上一次特召发生时的总次数快照
		local ge1 = Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			s.chain_count[rp] = s.chain_count[rp] + 1
		end)
		Duel.RegisterEffect(ge1, 0)
		local ge0=ge1:Clone()
		ge0:SetCode(EVENT_CHAIN_NEGATED)
		ge0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if s.chain_count[rp] == 0 then
				s.last_ss_snapshot[rp] = s.last_ss_snapshot[rp] - 1
			else
				s.chain_count[rp] = s.chain_count[rp] - 1
			end
		end)
		Duel.RegisterEffect(ge0, 0)
		local ge2 = Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			if not s.first_spsummon then
				s.first_spsummon = true
			else
				Duel.RaiseEvent(eg, EVENT_CUSTOM + id, re, r, rp, 0, s.chain_count[0] - s.last_ss_snapshot[0])
				Duel.RaiseEvent(eg, EVENT_CUSTOM + id, re, r, rp, 1, s.chain_count[1] - s.last_ss_snapshot[1])
			end
			s.last_ss_snapshot[0] = s.chain_count[0]
			s.last_ss_snapshot[1] = s.chain_count[1]
		end)
		Duel.RegisterEffect(ge2, 0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DECKDES+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM + id)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1 = Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0
		local b2 = Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil)
		return (b1 or b2) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
			and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and ep ~= tp and ev > 0
	end
	Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id, ev + 2))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id, ev + 2))
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local ct, ct2 = 0, 0
	for i = 1, ev do
		local b1 = Duel.GetFieldGroupCount(tp, LOCATION_DECK, 0) > 0
		local b2 = Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_GRAVE,0,1,nil)
		if not b1 and not b2 then break end
		local op = 0
		if b1 and b2 then
			op = Duel.SelectOption(1-tp, aux.Stringid(id,1), aux.Stringid(id,2))
		elseif b1 then
			op = Duel.SelectOption(1-tp, aux.Stringid(id,1))
		else
			op = Duel.SelectOption(1-tp, aux.Stringid(id,2)) + 1
		end
		if op == 0 then
			if Duel.Destroy(Duel.GetDecktopGroup(tp, 1), REASON_EFFECT) > 0 and Duel.GetOperatedGroup():GetFirst():IsLocation(LOCATION_GRAVE) then
				ct = ct + 1
			end
		else
			Duel.Hint(HINT_SELECTMSG, 1-tp, HINTMSG_ATOHAND)
			local g = Duel.SelectMatchingCard(1-tp, Card.IsAbleToHand, tp, LOCATION_GRAVE, 0, 1, 1, nil)
			if #g > 0 then
				if Duel.SendtoHand(g, tp, REASON_EFFECT)>0 then
					ct2 = ct2 + 1
				end
				Duel.ConfirmCards(1-tp, g)
			end
		end
	end
	if ct2 >= ct then
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end