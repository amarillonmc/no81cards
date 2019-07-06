--动物朋友盒
function c33700059.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2095764,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,33700059)
	e1:SetCondition(c33700059.condition)
	e1:SetTarget(c33700059.sptg)
	e1:SetOperation(c33700059.spop)
	c:RegisterEffect(e1)
end
function c33700059.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c33700059.filter1(c,e,tp)
	return c:IsSetCard(0x442)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700059.filter2(c,g)
	return g:IsExists(c33700059.filter3,1,c,c:GetCode())
end
function c33700059.filter3(c,code)
	return c:GetCode()~=code
end
function c33700059.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetMZoneCount(tp)<2 then return false end
		local g=Duel.GetMatchingGroup(c33700059.filter1,tp,LOCATION_DECK,0,nil,e,tp)
		return g:IsExists(c33700059.filter2,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c33700059.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetMZoneCount(tp)<2 then return end
	local g=Duel.GetMatchingGroup(c33700059.filter1,tp,LOCATION_DECK,0,nil,e,tp)
	local dg=g:Filter(c33700059.filter2,nil,g)
	if dg:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		dg:Remove(Card.IsCode,nil,tc1:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc2=dg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		 if Duel.GetTurnPlayer()==tp then
		tc1:RegisterFlagEffect(33700059,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		tc2:RegisterFlagEffect(33700059,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		else
		tc1:RegisterFlagEffect(33700059,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		tc2:RegisterFlagEffect(33700059,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc2:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		sg:AddCard(tc2)
		sg:KeepAlive()
		local de=Effect.CreateEffect(e:GetHandler())
		de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		de:SetCode(EVENT_PHASE+PHASE_END)
		de:SetCountLimit(1)
		de:SetLabelObject(sg)
		de:SetCondition(c33700059.descon)
		de:SetOperation(c33700059.desop)
		 if Duel.GetTurnPlayer()==tp then
			de:SetLabel(Duel.GetTurnCount()+2)
		else
			de:SetLabel(Duel.GetTurnCount()+1)
		end
		Duel.RegisterEffect(de,tp)
end
end
function c33700059.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c33700059.desfilter,1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	  return e:GetHandler():GetFlagEffect(33700059)>0 and Duel.GetTurnCount()==e:GetLabel()
end
function c33700059.desfilter(c)
	return c:GetFlagEffect(33700059)>0
end
function c33700059.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c33700059.desfilter,nil)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
