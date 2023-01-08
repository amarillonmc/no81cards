local m=53716014
local cm=_G["c"..m]
cm.name="断灭之际"
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(cm.condtion)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(0x20004)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_RELEASE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(cm.discon)
	e5:SetTarget(cm.distg)
	e5:SetOperation(cm.disop)
	c:RegisterEffect(e5)
end
function cm.condtion(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return not e:GetHandler():IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	if Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then
		local te=c:GetActivateEffect()
		local tep=c:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(c,4179255,te,0,tp,tp,Duel.GetCurrentChain())	
	end
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==1-tp and rc:IsOnField()
end
function cm.filter(c,g)
	return c:IsFaceup() and bit.band(c:GetType(),0x20004)==0x20004 and not g:IsContains(c)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local cg=rc:GetColumnGroup()
	cg:AddCard(rc)
	if chkc then return cm.filter(chkc,cg) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,0,1,c,cg) and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,0,1,1,c,cg)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function cm.filter2(c)
	return c:IsType(TYPE_TRAP) and c:IsSetCard(0x353b) and c:IsSSetable()
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFirstTarget()
	local b1=((tc:IsLocation(LOCATION_MZONE) and ((bit.band(tc:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)~=0 and (not tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsCanTurnSet()) or (tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsSSetable() and tc:IsCanTurnSet())) or (bit.band(tc:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)==0 and tc:IsCanTurnSet()))) or (tc:IsLocation(LOCATION_SZONE) and tc:IsSSetable(true))) and not (tc:IsType(TYPE_PENDULUM) and tc:IsLocation(LOCATION_PZONE))
	local b2=tc:IsReleasableByEffect() and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,nil)
	if Duel.Recover(tp,d,REASON_EFFECT)~=0 and (b1 or b2) and tc:IsRelateToEffect(e) then
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(m,2)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(m,3)
			opval[off]=1
			off=off+1
		end
		ops[off]=aux.Stringid(53718007,2)
		opval[off]=2
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		if opval[op]==0 then
			tc:CancelToGrave()
			Duel.ChangePosition(tc,POS_FACEDOWN)
			local loc=0
			if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE
			elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then loc=LOCATION_SZONE end
			if tc:GetOriginalType()&TYPE_MONSTER==0 and tc:IsLocation(LOCATION_MZONE) then Duel.MoveToField(tc,tp,tp,loc,POS_FACEDOWN,false) end
			if tc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
		elseif opval[op]==1 then
			if Duel.Release(tc,REASON_EFFECT)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
				local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE,0,1,1,nil)
				Duel.SSet(tp,g)
			end
		end
	end
end
