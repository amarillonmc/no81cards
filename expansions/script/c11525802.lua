--异响鸣的共声
function c11525802.initial_effect(c)
	c:EnableCounterPermit(0x6a,LOCATION_SZONE)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,11525802+EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(c11525802.target)
	e0:SetOperation(c11525802.activate)
	c:RegisterEffect(e0)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabel(1)
	e1:SetCondition(c11525802.cpcon)
	e1:SetOperation(c11525802.cpop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_RECOVER)
	e2:SetLabel(2)
	c:RegisterEffect(e2)
	--counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c11525802.ctcon)
	e3:SetOperation(c11525802.ctop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_RECOVER)
	c:RegisterEffect(e4)
	--atk up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetValue(c11525802.val)
	c:RegisterEffect(e5)
end
function c11525802.val(e,c)
	return Duel.GetCounter(0,1,0,0x6a)*100
end
function c11525802.filter(c,ft)
	return c:IsSetCard(0x1a3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
		and (ft==nil or ft>0 or c:IsType(TYPE_FIELD))
end
function c11525802.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ft=ft-1 end
		return Duel.IsExistingMatchingCard(c11525802.filter,tp,LOCATION_DECK,0,1,nil,ft)
	end
end
function c11525802.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c11525802.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then Duel.SSet(tp,tc) end
end
function c11525802.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=nil
	if re then rc=re:GetHandler() end
	return ep==tp and bit.band(r,REASON_EFFECT)~=0 and rc and rc:IsSetCard(0x1a3) and not rc:IsCode(11525802)
end
function c11525802.cpfilter(c,check)
	return c:IsSetCard(0x1a3) and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and c:IsFaceupEx() and c:CheckActivateEffect(false,true,false)~=nil and ((check==1 and not c:IsHasEffect(11525802)) or (check==2 and not c:IsHasEffect(11525803)))
end
function c11525802.cpop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c11525802.cpfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e:GetLabel()) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(11525802,0)) then return end
	Duel.Hint(HINT_CARD,0,11525802)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c11525802.cpfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e:GetLabel()):GetFirst()
	Duel.HintSelection(Group.FromCards(tc))
	if e:GetLabel()==1 then
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(11525802)
		e1:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,code))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif e:GetLabel()==2 then
		local code=tc:GetCode()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(11525803)
		e1:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,code))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	if te then
		local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp,e:GetLabel()) end
	end
end
function c11525802.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r==REASON_EFFECT
end
function c11525802.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x6a,1)
end
