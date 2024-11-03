--25时-#33CCBB Miku
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(2,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(2,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and c:IsDiscardable() end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.filter(c,tp,fc)
	return c:IsType(TYPE_FIELD) and not c:IsCode(fc:GetCode()) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if chk==0 then return fc and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp,fc) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,fc,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if not fc or Duel.SendtoGrave(fc,REASON_EFFECT)==0 then return end
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp,fc):GetFirst()
	if tc then		
		Duel.BreakEffect()
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=math.log(c:GetLocation(),2)
	return Duel.GetCurrentChain()>0 and Duel.GetFieldGroupCount(tp,LOCATION_FZONE,0)>0 and Duel.GetFlagEffect(tp,id+loc)==0
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and c:IsAbleToRemoveAsCost() end
	local loc=math.log(c:GetLocation(),2)
	Duel.RegisterFlagEffect(tp,id+loc,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_REMOVED) and c:GetReasonEffect()==e then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectOption(tp,1152,aux.Stringid(id,2))==0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		elseif Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
				local e1=Effect.CreateEffect(c)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
				c:RegisterEffect(e1)
			end
		end
	end
end