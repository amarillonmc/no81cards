local m=189134
local cm=_G["c"..m]
cm.name="轮盘重工"
function cm.initial_effect(c)
	aux.AddCodeList(c,189131)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(189133,4))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1150)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
	--stats up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(cm.deffilter))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.dbtg)
	e3:SetOperation(cm.dbop)
	c:RegisterEffect(e3)
end
function cm.handcon(e)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),189133)~=0
end
function cm.hfilter(c)
	return not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.hfilter,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local ct=1
		if Duel.IsPlayerAffectedByEffect(tp,189137) and Duel.GetFlagEffect(tp,189137)==0 and g:GetCount()>=2 and Duel.SelectYesNo(tp,aux.Stringid(189137,2)) then
			ct=2
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+189138,e,REASON_EFFECT,tp,1-tp,ev)
			Duel.RegisterFlagEffect(tp,189137,RESET_PHASE+PHASE_END,0,1)
		end
		local ag=g:RandomSelect(tp,ct)
		local ac=ag:GetFirst()
		while ac do
			ac:RegisterFlagEffect(189133,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			ac:RegisterEffect(e1)
			ac=ag:GetNext()
		end
		Duel.ConfirmCards(tp,ag)
	end
end
function cm.deffilter(c)
	return aux.IsCodeListed(c,189131)
end
function cm.dhfilter(c,rtype)
	return c:IsPublic() and c:IsType(rtype)
end
function cm.dbfilter(c,tp)
	local rtype=bit.band(c:GetType(),0x7)
	return Duel.IsExistingMatchingCard(cm.dhfilter,tp,0,LOCATION_HAND,1,nil,rtype) and c:IsFaceup()
end
function cm.dbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.dbfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.dbfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.dbfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.dbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end