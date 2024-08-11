--奥法集装士『燃灯火』
function c60010104.initial_effect(c)
	--disable and destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(c60010104.discon)
	e1:SetOperation(c60010104.disop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c60010104.condition)
	e2:SetTarget(aux.nbtg)
	e2:SetOperation(c60010104.activate)
	c:RegisterEffect(e2)   
	if not c60010104.global_check1 then
		c60010104.global_check1=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c60010104.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	if not c60010104.global_check then
		c60010104.global_check=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(c60010104.spcheckop)
		Duel.RegisterEffect(ge2,0)
	end  
end
function c60010104.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x632)
end
function c60010104.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c60010104.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c60010104.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_REMOVED) and not tc:IsReason(REASON_REDIRECT) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(c60010104.aclimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c60010104.aclimit(e,re,tp)
	local c=re:GetHandler()
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
--
function c60010104.spcheckop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if tc:IsSummonPlayer(0) and tc:IsSummonType(SUMMON_TYPE_RITUAL) and tc:IsSetCard(0x632) then p1=true else p2=true end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,60010104,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,60010104,RESET_PHASE+PHASE_END,0,1) end
end
function c60010104.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,60010102,RESET_PHASE+PHASE_END,0,1)
end
--
function c60010104.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,60010104)~=0 and Duel.GetFlagEffect(tp,60010102)~=0
end
function c60010104.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cc=Duel.GetCurrentChain()
	if Duel.IsExistingMatchingCard(c60010104.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60010104,0)) then
		local gg=Duel.GetFieldGroup(c60010104.thfilter,tp,LOCATION_GRAVE,0,nil)
		if gg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,c60010104.thfilter,tp,LOCATION_GRAVE,0,1,cc,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)   
		end
	end
	Duel.SendtoGrave(c,REASON_EFFECT)
end