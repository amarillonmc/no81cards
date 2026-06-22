--『高速机动』空想
function c9911764.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,c9911764.mfilter,nil,2,99)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c9911764.immtg)
	e1:SetValue(c9911764.immval)
	e1:SetLabel(0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetLabel(2)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetLabel(3)
	c:RegisterEffect(e4)
	local e4=e1:Clone()
	e4:SetLabel(4)
	c:RegisterEffect(e4)
	--move
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c9911764.mvcon)
	e5:SetCost(c9911764.mvcost)
	e5:SetTarget(c9911764.mvtg)
	e5:SetOperation(c9911764.mvop)
	c:RegisterEffect(e5)
	if not c9911764.global_check then
		c9911764.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(c9911764.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911764.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_MZONE) and tc:IsPreviousLocation(LOCATION_MZONE)
			and (tc:GetPreviousSequence()~=tc:GetSequence() or tc:GetPreviousControler()~=tc:GetControler()) then
			local seq=aux.MZoneSequence(tc:GetSequence())
			if tc:GetFlagEffect(9911764)==0 then
				tc:RegisterFlagEffect(9911764,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,seq,aux.Stringid(9911764,6))
			else
				tc:SetFlagEffectLabel(9911764,seq)
			end
		end
		tc=eg:GetNext()
	end
end
function c9911764.mfilter(c,xyzc)
	return c:IsXyzLevel(xyzc,3) or c:IsXyzLevel(xyzc,4) or c:IsXyzLevel(xyzc,5)
end
function c9911764.immtg(e,c)
	return c:GetFlagEffect(9911764)~=0 and aux.MZoneSequence(c:GetSequence())==e:GetLabel()
end
function c9911764.immval(e,re)
	if re:IsActivated() and e:GetHandlerPlayer()~=re:GetOwnerPlayer() then
		local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION) or 0
		local seq=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_SEQUENCE) or -1
		return LOCATION_ONFIELD&loc~=0 and seq~=4-e:GetLabel()
	end
	return false
end
function c9911764.mvcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end
function c9911764.mvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local opt1=e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	local opt2=Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return opt1 or opt2 end
	local result=0
	if opt1 and not opt2 then result=0 end
	if opt2 and not opt1 then result=1 end
	if opt1 and opt2 then result=Duel.SelectOption(tp,aux.Stringid(9911764,0),aux.Stringid(9911764,1)) end
	if result==0 then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	else
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	end
end
function c9911764.chfilter(c)
	return c:GetSequence()<5
end
function c9911764.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
	local b2=c:GetSequence()<5 and Duel.IsExistingMatchingCard(c9911764.chfilter,tp,LOCATION_MZONE,0,1,c)
	local b3=c:IsAbleToRemove()
	if chk==0 then return b1 or b2 or b3 end
	e:SetCategory(0)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(9911764,2)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9911764,3)
		opval[off]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(9911764,4)
		opval[off]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==2 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	else
		e:SetCategory(0)
	end
end
function c9911764.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then
		if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp)
			or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		local seq=math.log(fd,2)
		Duel.MoveSequence(c,seq)
	elseif sel==1 then
		if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or c:GetSequence()>=5 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911764,5))
		local tc=Duel.SelectMatchingCard(tp,c9911764.chfilter,tp,LOCATION_MZONE,0,1,1,c):GetFirst()
		if tc then
			Duel.HintSelection(Group.FromCards(c,tc))
			Duel.SwapSequence(c,tc)
		end
	elseif sel==2 then
		if c:IsRelateToEffect(e) and Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)~=0 and not c:IsReason(REASON_REDIRECT) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(c)
			e1:SetCountLimit(1)
			e1:SetOperation(c9911764.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c9911764.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
