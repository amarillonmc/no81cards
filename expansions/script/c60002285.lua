local cm,m,o=GetID()
cm.name = "雷维翁剑士·阿尔贝尔"
cm["次数"]={}
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	local e1=Effect.CreateEffect(c)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetType(TYPE_FIELD+TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMNON_SUCESS)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(100)
	e3:SetValue(500)
	e3:SetCondition(cm.atkcon)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetValue(2)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	c:RegisterEffect(e4)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not  cm.check then
		cm.check=true
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetRange(LOCATION_DECK+LOCATION_HAND)
		e1:SetType(TYPE_FIELD+TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(cm.con)
		e1:SetOperation(cm.op1)
		Duel.RegisterEffect(e1,tp)
	end
	e:Reset()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local turn=Duel.GetTurnCount()
	if not cm["次数"][turn] then cm["次数"][turn]=0 end
	return aux.IsCodeListed(rc,m) and rc:IsControler(tp) and Duel.IsExistingMatchingCard(cm.f,tp,LOCATION_HAND,0,1,nil) and cm["次数"][turn]<2
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g=Duel.SelectMatchingCard(tp,cm.f,tp,LOCATION_HAND,0,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local turn=Duel.GetTurnCount()
		Duel.Hint(HINT_CARD,tp,m)
		Duel.SetChainLimit(cm.chainlm)
		if not cm["次数"][turn] then cm["次数"][turn]=0 end
		cm["次数"][turn]=cm["次数"][turn]+1
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.f(c)
	return c:IsCode(m)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x624)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,LOCATION_MZONE,0,1,1,nil)
	if #g==0 then return false end
	if Duel.Destroy(g,REASON_EFFECT)==0 then return false end
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x624,1)
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(cm.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e1)
	end
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x624)>0
end