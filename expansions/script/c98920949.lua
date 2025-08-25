--极神圣帝王 奥丁
-- 极神圣帝王 奥丁
local s, id = GetID()

function s.initial_effect(c)
	-- Synchro summon procedure
	aux.AddSynchroProcedure(c, aux.FilterBoolFunction(Card.IsSetCard, 0x42),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO), 1)
	c:EnableReviveLimit()
	
	-- Effect 1: Continuous effect
	--synchro summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.regcon)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.matcheck)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e1)	
	--attribute
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4b))
	e6:SetValue(ATTRIBUTE_DIVINE)
	e6:SetCondition(s.atcon)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x4b))
	e7:SetValue(c98920949.efilter)
	e7:SetCondition(s.atcon)
	e7:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e7)	
	-- Effect 2: Add "极星" monsters to hand
	local e3 = Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK + CATEGORY_TOHAND + CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1, id)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	-- Effect 3: Special Summon when destroyed
	local e4 = Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

-- Filter for "极神" monsters
function s.godfilter(c)
	return c:IsSetCard(0x4b) and c:IsFaceup()
end
function s.matcheck(e,c)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x4b) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.filter(c)
	return  c:IsSetCard(0x4b)
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98920949,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(98920949,4))
end
function s.atcon(e)
	return e:GetHandler():GetFlagEffect(98920949)>0
end
-- Condition for Effect 1: Check if synchro material included "极神" monster
function c98920949.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
		and re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and not re:GetHandler():IsAttribute(ATTRIBUTE_DIVINE)
end
-- Effect 1: Immune to non-DIVINE monster effects
function s.efilter(e, te)
	return te:GetHandler():GetAttribute() ~= ATTRIBUTE_DIVINE and te:IsActiveType(TYPE_MONSTER)
end

-- Effect 2: Target selection
function s.tdfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED)) and c:IsSetCard(0x42) and c:IsAbleToDeck()
end
function s.thfilter(c, race)
	return c:IsSetCard(0x42) and c:IsType(TYPE_MONSTER) and (not race or c:GetRace() ~= race) and c:IsAbleToHand()
end
function s.thtg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chkc then return false end
	if chk == 0 then
		local g = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_GRAVE + LOCATION_REMOVED, 0, nil)
		return #g > 0 and Duel.IsExistingMatchingCard(s.thfilter, tp, LOCATION_DECK, 0, 1, nil)
	end
	Duel.Hint(HINT_OPSELECTED, 1 - tp, e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
	Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_GRAVE + LOCATION_REMOVED)
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

-- Effect 2: Operation
function s.thop(e, tp, eg, ep, ev, re, r, rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g == 0 then return end
	local ct = Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
	if ct > 0 then
		local added = {}
		local race_list = {}
		local tg = Duel.GetMatchingGroup(s.thfilter, tp, LOCATION_DECK, 0, nil)
		for i = 1, ct do
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
			local sc = tg:SelectSubGroup(tp, function(sg) 
				for rc in aux.Next(sg) do
					if race_list[rc:GetRace()] then return false end
				end
				return true
			end, false, 1, 1):GetFirst()
			if sc then
				race_list[sc:GetRace()] = true
				Duel.SendtoHand(sc, nil, REASON_EFFECT)
				Duel.ConfirmCards(1 - tp, sc)
				table.insert(added, sc)
			else
				break
			end
		end
	end
end

-- Effect 3: Condition
function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return rp ~= tp and e:GetHandler():IsPreviousControler(tp)
end

-- Effect 3: Target selection
function s.spfilter(c, e, tp)
	return c:IsSetCard(0x4b) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SYNCHRO, tp, true, true)
		and c:IsLocation(LOCATION_EXTRA) or (c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_EXTRA + LOCATION_GRAVE, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA + LOCATION_GRAVE)
end

-- Effect 3: Operation
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sc = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter), tp, LOCATION_EXTRA + LOCATION_GRAVE, 0, 1, 1, nil, e, tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc, SUMMON_TYPE_SYNCHRO, tp, tp, true, true, POS_FACEUP)
		sc:CompleteProcedure()
	end
end
