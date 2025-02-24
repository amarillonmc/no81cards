--跨越天域的神鸟
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,55500000)
	c:SetUniqueOnField(1,0,s.uqfilter,LOCATION_MZONE)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMING_ATTACK+TIMING_END_PHASE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.uqfilter(c)
	return aux.IsCodeListed(c,55500000)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function s.setfilter(c)
	return c:IsCode(55500000) and c:IsSSetable() and not c:IsForbidden() and c:CheckUniqueOnField(c:GetControler())
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 or (not (Duel.GetLocationCount(tp,LOCATION_SZONE)>0)) then return end
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local te=tc:GetActivateEffect()
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x189c,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x189c,3,REASON_COST)
end
function s.upfilter(c)
	return aux.IsCodeListed(c,55500000) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(s.upfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetMatchingGroup(s.upfilter,e:GetOwnerPlayer(),LOCATION_DECK,0,nil)
		if g:GetCount()>0 then 
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=Duel.SelectMatchingCard(tp,s.upfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
			if Duel.SSet(tp,tc,tp,true)>0 then
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(id,2))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
				if tc:IsType(TYPE_TRAP) then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(id,2))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end

