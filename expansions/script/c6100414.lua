--溯归夜月魔女
local s,id,o=GetID()
function s.initial_effect(c)
	--hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.hand_tg)
	e1:SetOperation(s.hand_op)
	c:RegisterEffect(e1)

	--field
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.field_tg)
	e2:SetOperation(s.field_op)
	c:RegisterEffect(e2)
end

function s.get_available_races_hand(c)
	local my_race = c:GetRace()
	return RACE_ALL & (~my_race)
end

function s.get_available_races_field(c, tp)
	local my_race = c:GetRace()
	local g = Duel.GetMatchingGroup(Card.IsAbleToHand, tp, LOCATION_GRAVE, 0, nil)
	local avail_race = 0
	for tc in aux.Next(g) do
		avail_race = avail_race | tc:GetRace()
	end
	return avail_race & (~my_race)
end

function s.hand_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return not c:IsPublic() and s.get_available_races_hand(c) ~= 0 end
	
	local avail = s.get_available_races_hand(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc = Duel.AnnounceRace(tp, 1, avail)
	e:SetLabel(rc)
end

function s.hand_op(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local rc = e:GetLabel()
	
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(rc)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
	
	s.register_next_summon(c, tp, rc)
end

function s.field_tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return s.get_available_races_field(c, tp) ~= 0 end
	
	local avail = s.get_available_races_field(c, tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc = Duel.AnnounceRace(tp, 1, avail)
	e:SetLabel(rc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end

function s.field_op(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local rc = e:GetLabel()
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g = Duel.SelectMatchingCard(tp, function(tc) return tc:IsRace(rc) and tc:IsAbleToHand() end, tp, LOCATION_GRAVE, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
	
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(rc)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	
	s.register_next_summon(c, tp, rc)
end

function s.register_next_summon(c, tp, rc)
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	local e3 = e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	
	local function op(e,tp_ev,eg,ep,ev,re,r,rp)
		local g = Duel.GetMatchingGroup(function(tc) return tc:IsRace(rc) end, tp, LOCATION_HAND+LOCATION_MZONE, 0, nil)
		
		if #g > 0 then
			Duel.Hint(HINT_CARD, 0, id)
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
			local sg = g:Select(tp, 1, 1, nil)
			Duel.Destroy(sg, REASON_EFFECT)
		end
		
		e1:Reset()
		e2:Reset()
		e3:Reset()
	end
	
	e1:SetOperation(op)
	e2:SetOperation(op)
	e3:SetOperation(op)
	
	Duel.RegisterEffect(e1, tp)
	Duel.RegisterEffect(e2, tp)
	Duel.RegisterEffect(e3, tp)
end