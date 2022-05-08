--爱情随那波纹扩散
function c60001172.initial_effect(c)
	aux.AddCodeList(c,60001179)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c60001172.fscon)
	e1:SetTarget(c60001172.fstg)
	e1:SetOperation(c60001172.fsop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001172,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001172)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c60001172.hstg)
	e2:SetOperation(c60001172.hsop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_REMOVED)
	c:RegisterEffect(e3)

	if not c60001172.global_check then
		c60001172.global_check=true
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_SSET)
		e4:SetCondition(c60001172.setcon)
		e4:SetOperation(c60001172.setop)
		Duel.RegisterEffect(e4,0)
	end
end
function c60001172.setter(c)
	return c:IsCode(60001172) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c60001172.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001172.setter,1,nil)
end
function c60001172.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:Filter(c60001172.setter,nil):GetFirst()
	while tc do
		tc:RegisterFlagEffect(60001168,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c60001172.fscon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c60001172.cwter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c60001172.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001172.cwter,tp,0,LOCATION_MZONE,nil)
end
function c60001172.fsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60001172.splimit)
	Duel.RegisterEffect(e1,1-tp)
	local g=Duel.GetMatchingGroup(c60001172.cwter,tp,0,LOCATION_MZONE,nil)
	if c:GetFlagEffect(60001168)>0 and c:IsLocation(LOCATION_SZONE) and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60001172,2)) then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c60001172.splimit(e,c)
	return c:IsLocation(LOCATION_DECK)
end
function c60001172.filter2(c)
	return aux.IsCodeListed(c,60001179) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60001172.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c60001172.filter2,tp,LOCATION_HAND,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c60001172.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60001172.filter2,tp,LOCATION_HAND,0,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tc=g:FilterSelect(tp,c60001172.filter2,1,1,nil):GetFirst()
			if tc and Duel.SSet(tp,tc)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end