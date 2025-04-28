--芳青之梦 樱灼华
function c21113920.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+0x200)
	e0:SetCondition(c21113920.discon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,21113920)
	e1:SetCost(c21113920.cost)
	e1:SetTarget(c21113920.tg)
	e1:SetOperation(c21113920.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,21113921)
	e2:SetCondition(c21113920.con2)
	e2:SetTarget(c21113920.tg2)
	e2:SetOperation(c21113920.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(21113920,ACTIVITY_SPSUMMON,c21113920.counter)	
end
function c21113920.counter(c)
	return c:IsSetCard(0xc914)
end
function c21113920.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()~=2
end
function c21113920.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(21113920,tp,ACTIVITY_SPSUMMON)==0 and c:IsDiscardable() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTarget(c21113920.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetCountLimit(1)
	e2:SetOperation(c21113920.op0)
	Duel.RegisterEffect(e2,tp)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c21113920.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xc914)
end
function c21113920.op0_q(c,seq)
	return c:GetSequence()==seq
end
function c21113920.op0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,21113920)==0 and Duel.SelectYesNo(tp,aux.Stringid(21113920,0)) then
		local dis = 0
		local zone = (0|((0x60<<16)+2^13+2^29))
		for i = 1,5 do
			local v=Duel.SelectField(tp,1,0,12,zone)
			local s=math.log(v>>16,2)
			local tg=Duel.GetMatchingGroup(c21113920.op0_q,tp,0,12,nil,s)
			if #tg>0 then Duel.SendtoGrave(tg,REASON_RULE) end
			dis = dis | v
			zone = zone | v
		end
		Duel.Hint(HINT_ZONE,tp,dis)
		if tp==1 then
			dis=((dis&0xffff)<<16)|((dis>>16)&0xffff)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetValue(dis)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.ResetFlagEffect(tp,21113920)
	e:Reset()
end
function c21113920.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,12,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,#g,1,0,0)
end
function c21113920.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,21113920,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,12,nil)
	if #g>0 then
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_RULE)
	end
end
function c21113920.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c21113920.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if Duel.GetTurnPlayer()==tp then
	e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+0x200)	
	end
	if c:IsLocation(LOCATION_GRAVE) then
	e:SetCategory(e:GetCategory()+CATEGORY_GRAVE_SPSUMMON)
	end
end
function c21113920.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 and Duel.SelectYesNo(tp,aux.Stringid(21113920,1)) then
	Duel.BreakEffect()
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_HAND)
		c:RegisterEffect(e1,true)	
		end
	end
end