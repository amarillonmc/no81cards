local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.spcon)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,3,nil,POS_FACEDOWN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_EXTRA,0,3,3,nil,POS_FACEDOWN)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function s.filter(c)
	return c:IsCode(70155677) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.thfilter(c)
	return c:IsRace(RACE_BEAST) and c:IsLevel(10) and c:IsAbleToHand()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3)) elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(id,2)) else op=Duel.SelectOption(tp,aux.Stringid(id,3))+1 end
	e:SetLabel(op)
	if op==0 then e:SetCategory(CATEGORY_TOEXTRA) elseif op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc then
			local op=0
			if (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then op=Duel.SelectOption(tp,aux.Stringid(id,4),aux.Stringid(id,5)) else op=1 end
			if op==0 then Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			else Duel.SendtoExtraP(tc,nil,REASON_EFFECT) end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost(POS_FACEDOWN) end
	Duel.Remove(e:GetHandler(),POS_FACEDOWN,REASON_COST)
end
function s.spfilter(c,tp,exc,check)
	if not c:IsSetCard(0x191) then return false end
	local f1=Duel.GetLocationCount
	local f2=Duel.GetLocationCountFromEx
	if exc:IsLocation(LOCATION_MZONE) and not check then
		if not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp,c)>0 then
			Duel.GetLocationCount=function(p,loc,...)
				local ct1=f1(p,loc,...)
				if p==tp and loc==LOCATION_MZONE then return ct1+1 else return ct1 end
			end
		end
		if c:IsLocation(LOCATION_EXTRA) and f2(tp,tp,exc,c)>0 then
			Duel.GetLocationCountFromEx=function(p,...)
				local ct2=f2(p,...)
				if p==tp then return ct2+1 else return ct2 end
			end
		end
	end
	local res=c:IsSpecialSummonable()
	Duel.GetLocationCount=f1
	Duel.GetLocationCountFromEx=f2
	return res
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Group.__add(Duel.GetMatchingGroup(nil,0,0xfb,0xfb,nil),Duel.GetOverlayGroup(tp,1,1)):Filter(s.spfilter,e:GetHandler(),tp,e:GetHandler())
	if chk==0 then return #sg>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0xfb)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Group.__add(Duel.GetMatchingGroup(nil,0,0xfb,0xfb,nil),Duel.GetOverlayGroup(tp,1,1)):FilterSelect(tp,s.spfilter,1,1,nil,tp,e:GetHandler(),true):GetFirst()
	if tc then Duel.SpecialSummonRule(tp,tc) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
