--星忆梦转
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.stellar_memories) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71404000,0)
		yume.import_flag=false
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Can be activated from the hand during the opponent's turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e2)
	yume.stellar_memories.GlobalCheck(c)
end
function s.costfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,71404000,tp)==0
		and Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	yume.stellar_memories.RegCostLimit(e,tp)
end
function s.linkcostfilter(c,e,tp)
	return c:IsFaceup() and c:GetOriginalType()&(TYPE_LINK+TYPE_MONSTER)~=0 and c:IsAbleToRemove(tp)
		and Duel.GetMZoneCount(tp,c,tp)>0
		and Duel.IsExistingMatchingCard(s.ritualfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function s.ritualfilter(c,e,tp)
	return c:GetOriginalType()&(TYPE_RITUAL+TYPE_MONSTER)==TYPE_RITUAL+TYPE_MONSTER
		and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WATER)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function s.ritualcostfilter(c,e,tp)
	return c:IsFaceup() and c:GetOriginalType()&(TYPE_RITUAL+TYPE_MONSTER)~=0 and c:IsAbleToRemove(tp)
		and Duel.IsExistingMatchingCard(s.linkfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function s.linkfilter(c,e,tp,mc)
	return c:GetOriginalType()&(TYPE_LINK+TYPE_MONSTER)==TYPE_LINK+TYPE_MONSTER
		and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_WATER)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function s.checkop1(e,tp)
	return Duel.IsExistingMatchingCard(s.linkcostfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
end
function s.checkop2(e,tp)
	return Duel.IsExistingMatchingCard(s.ritualcostfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.checkop1(e,tp) or s.checkop2(e,tp) end
	-- local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil,tp)
	-- if #g>0 then
	-- 	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,tp,LOCATION_GRAVE)
	-- 	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,LOCATION_GRAVE)
	-- end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
	-- Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil,tp)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
	end
	local b1=s.checkop1(e,tp)
	local b2=s.checkop2(e,tp)
	if b1 or b2 then
		local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1)},
			{b2,aux.Stringid(id,2)})
		if op==1 then
			s.ritualop(e,tp)
		elseif op==2 then
			s.linkop(e,tp)
		end
	end
	s.regredirect(e,tp)
	if c:IsRelateToChain() then
		c:CancelToGrave()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function s.ritualop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.linkcostfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.ritualfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if not sc then return end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	if Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)>0 then
		sc:CompleteProcedure()
	end
end
function s.linkop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.ritualcostfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.linkfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=sg:GetFirst()
	if not sc then return end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	if Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)>0 then
		sc:CompleteProcedure()
	end
end
function s.redirtg(e,c)
	return c:GetOwner()==e:GetLabel()
end
function s.regredirect(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(s.redirtg)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetLabel(tp)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
