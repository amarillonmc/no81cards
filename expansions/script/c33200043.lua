--秘奥义!慈悲度魂落
function c33200043.initial_effect(c)
	if not c33200043.global_check then
		c33200043.global_check=true
		--destroy replace
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EFFECT_DESTROY_REPLACE)
		ge1:SetTarget(c33200043.reptg)
		ge1:SetValue(c33200043.repval)
		Duel.RegisterEffect(ge1,0)
	end
end

--e1
function c33200043.repfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
		and c:IsOnField() and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c33200043.repfilter1(c,reg)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and reg:IsContains(c)
		and c:IsOnField() and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c33200043.repfilter2(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
		and c:IsOnField() and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c33200043.cfilter(c)
	return c:IsFacedown() and c:IsOriginalCodeRule(33200043) and not c:IsForbidden()
end
function c33200043.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rep1=Duel.IsExistingMatchingCard(c33200043.cfilter,tp,LOCATION_SZONE,0,1,nil)
	local rep2=Duel.IsExistingMatchingCard(c33200043.cfilter,1-tp,LOCATION_SZONE,0,1,nil)
	local op=0
	local reg=Group.CreateGroup()
	if chk==0 then return (rep1 or rep2) and eg:IsExists(c33200043.repfilter,1,nil) end
	if rep1 and eg:IsExists(c33200043.repfilter2,1,nil,tp) then
		if Duel.SelectOption(tp,aux.Stringid(33200043,0),aux.Stringid(33200043,1))==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
			local sg=Duel.SelectMatchingCard(tp,c33200043.cfilter,tp,LOCATION_SZONE,0,1,1,nil)
			local tc=sg:GetFirst()
			if Duel.ChangePosition(tc,POS_FACEUP) then  
				Duel.Hint(HINT_CARD,tp,33200043)
				local rg=eg:Filter(c33200043.repfilter2,nil,tp)
				reg:Merge(rg)
				local e0=Effect.CreateEffect(tc)
				e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e0:SetCode(EVENT_PHASE+PHASE_END)
				e0:SetRange(LOCATION_SZONE)
				e0:SetTarget(c33200043.sptg)
				e0:SetOperation(c33200043.spop)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e0) 
				op=1
			end 
		end
	end
	if rep2 and eg:IsExists(c33200043.repfilter2,1,nil,1-tp) then
		if Duel.SelectOption(1-tp,aux.Stringid(33200043,0),aux.Stringid(33200043,1))==0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SELF)
			local sg=Duel.SelectMatchingCard(1-tp,c33200043.cfilter,1-tp,LOCATION_SZONE,0,1,1,nil)
			local tc=sg:GetFirst()
			if Duel.ChangePosition(tc,POS_FACEUP) then
				Duel.Hint(HINT_CARD,tp,33200043)	
				local rg=eg:Filter(c33200043.repfilter2,nil,1-tp)
				reg:Merge(rg)
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetRange(LOCATION_SZONE)
				e1:SetTarget(c33200043.sptg)
				e1:SetOperation(c33200043.spop)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1) 
				op=1
			end
		end
	end
	e:SetLabelObject(reg)
	if op==1 then 
		return true 
	else return false end
end
function c33200043.repval(e,c)
	local reg=e:GetLabelObject()
	return c33200043.repfilter1(c,reg)
end
function c33200043.spfilter(c,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200043.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sp=e:GetHandlerPlayer()
	if chk==0 then return Duel.IsExistingMatchingCard(c33200043.spfilter,sp,LOCATION_HAND,0,1,nil,e,sp) end
end
function c33200043.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sp=e:GetHandlerPlayer()
	local ft=Duel.GetLocationCount(sp,LOCATION_MZONE)
	if Duel.SendtoGrave(c,REASON_EFFECT) and ft>0 then
		Duel.Hint(HINT_CARD,tp,33200043)
		Duel.Hint(HINT_SELECTMSG,sp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(sp,c33200043.spfilter,sp,LOCATION_HAND,0,1,1,nil,e,sp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,sp,sp,false,false,POS_FACEUP)
		end
	end
end
