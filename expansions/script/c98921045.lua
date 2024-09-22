--第三类接触
function c98921045.initial_effect(c)
	aux.AddCodeList(c,64382839)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98921045+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c98921045.target)
	e1:SetOperation(c98921045.activate)
	c:RegisterEffect(e1)	
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c98921045.reptg)
	e2:SetValue(c98921045.repval)
	e2:SetOperation(c98921045.repop)
	c:RegisterEffect(e2)
end
function c98921045.tgfilter(c)
	return c:IsCode(64382839) and c:IsAbleToGrave()
end
function c98921045.setfilter(c)
	return aux.IsCodeListed(c,64382839) and not c:IsCode(98921045) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c98921045.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local b=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,64382839)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921045.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) or (b and (Duel.IsExistingMatchingCard(c98921045.setfilter,tp,LOCATION_DECK,0,1,nil) or Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil))) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function c98921045.activate(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetOwner()
	local c=e:GetHandler()
	local b=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,64382839)
	local g0=Duel.IsExistingMatchingCard(c98921045.tgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	local g1=Duel.IsExistingMatchingCard(c98921045.setfilter,tp,LOCATION_DECK,0,1,nil)
	local g2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil)
	local off=1
	local ops={}
	local opval={}
	if g0 then
		ops[off]=aux.Stringid(98921045,0)
		opval[off-1]=0
		off=off+1
	end
	if b and g1 then
		ops[off]=aux.Stringid(98921045,1)
		opval[off-1]=1
		off=off+1
	end
	if b and g2 then
		ops[off]=aux.Stringid(98921045,2)
		opval[off-1]=2
		off=off+1
	end
	local op=0
	if #ops>1 then
		op=Duel.SelectOption(tp,table.unpack(ops))
	end
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c98921045.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
			if tc:IsType(TYPE_QUICKPLAY) then
			   local e1=Effect.CreateEffect(c)
			   e1:SetDescription(aux.Stringid(58019984,2))
			   e1:SetType(EFFECT_TYPE_SINGLE)
			   e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			   e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			   tc:RegisterEffect(e1)
			end
			if tc:IsType(TYPE_TRAP) then
			   local e1=Effect.CreateEffect(c)
			   e1:SetDescription(aux.Stringid(58019984,2))
			   e1:SetType(EFFECT_TYPE_SINGLE)
			   e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			   e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			   tc:RegisterEffect(e1)
			end
		end
	end
	if opval[op]==2 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	   local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil,tp)
		local rc=tg:GetFirst()
		if Duel.Remove(rc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			rc:RegisterFlagEffect(98921045,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(rc)
			e1:SetCountLimit(1)
			e1:SetCondition(c98921045.retcon)
			e1:SetOperation(c98921045.retop)
			Duel.RegisterEffect(e1,tp)
		end	
	end
	if opval[op]==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c98921045.tgfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then 
		   Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function c98921045.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(98921045)~=0
end
function c98921045.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c98921045.repfilter(c,tp)
	return c:IsFaceup() and c:IsCode(64382840)
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c98921045.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c98921045.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c98921045.repval(e,c)
	return c98921045.repfilter(c,e:GetHandlerPlayer())
end
function c98921045.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end