--极神雷皇 托尔
local s, id = GetID()

function s.initial_effect(c)
	-- Synchro summon procedure
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c, aux.FilterBoolFunction(Card.IsSetCard, 0x42), aux.NonTuner(Card.IsSynchroType, TYPE_SYNCHRO), 1)
	
	-- Effect 1: Destroy opponent's monsters when synchro summoned with "极神" material
	local e1 = Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.descon)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	
	-- Effect 2: Banish "极星" cards to set "极星宝" Spell/Traps
	local e2 = Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1, id)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	
	-- Effect 3: Special Summon when destroyed
	local e3 = Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

-- Effect 1: Check if synchro material included "极神" monster
function s.descon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetHandler():GetMaterial():IsExists(Card.IsSetCard, 1, nil, 0x4b)
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_MZONE, nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_MZONE, nil)
	if #g > 0 then
		Duel.Destroy(g, REASON_EFFECT)
	end
end

-- Effect 2: Set "极星宝" cards
function s.rmfilter(c)
	return c:IsSetCard(0x42) and c:IsAbleToRemove()
end

function s.setfilter(c)
	return c:IsSetCard(0x5042) and c:IsSSetable()
end

function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920947.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c98920947.setfilter,tp,LOCATION_DECK,0,1,nil) end
	local dg=Duel.GetMatchingGroup(c98920947.setfilter,tp,LOCATION_DECK,0,nil)
	local ct=math.min(2,dg:GetClassCount(Card.GetCode))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c98920947.rmfilter,tp,LOCATION_GRAVE,0,1,ct,e:GetHandler())
	local rc=Duel.Remove(rg,POS_FACEUP,REASON_COST)
	e:SetLabel(rc)
end

function s.setop(e, tp, eg, ep, ev, re, r, rp)
	local ct=e:GetLabel()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	if ft>=ct then ft=ct end
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
		if sg:GetCount()>0 then
			Duel.SSet(tp,sg)
		end
	end
end

-- Effect 3: Special Summon when destroyed
function s.spfilter(c, e, tp)
	return c:IsSetCard(0x4b) and c:IsLevel(10) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SYNCHRO, tp, true, true)
		and c:IsLocation(LOCATION_EXTRA) or (c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp, LOCATION_MZONE) > 0)
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
	return rp ~= tp and e:GetHandler():IsPreviousControler(tp)
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_EXTRA + LOCATION_GRAVE, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_EXTRA + LOCATION_GRAVE)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local sc = Duel.SelectMatchingCard(tp, aux.NecroValleyFilter(s.spfilter), tp, LOCATION_EXTRA + LOCATION_GRAVE, 0, 1, 1, nil, e, tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc, SUMMON_TYPE_SYNCHRO, tp, tp, true, true, POS_FACEUP)
		sc:CompleteProcedure()
	end
end

