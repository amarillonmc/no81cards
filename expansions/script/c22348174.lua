--线 偶 大 师
local m=22348174
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,22348157)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348174,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,22348174)
	e1:SetCondition(c22348174.stcon)
	e1:SetTarget(c22348174.sttg)
	e1:SetOperation(c22348174.stop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41546,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22348174.destg)
	e2:SetOperation(c22348174.desop)
	c:RegisterEffect(e2)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(c22348174.reptg)
	e3:SetValue(c22348174.repval)
	c:RegisterEffect(e3)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e3:SetLabelObject(g)
	
end
function c22348174.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c22348174.tsfilter(c)
	return c:IsCode(22348157) and not c:IsForbidden()
end
function c22348174.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348174.tsfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 end
end
function c22348174.stop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348174.tsfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,2,2,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c22348174.desfilter(c)
	return c:IsCode(22348157)
end
function c22348174.thfilter(c)
	return aux.IsCodeListed(c,22348157) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22348174.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c22348174.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22348174.desfilter,tp,LOCATION_ONFIELD,0,1,nil) 
	and Duel.IsExistingMatchingCard(c22348174.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22348174.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348174.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c22348174.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local ttc=g:GetFirst()
		if ttc then
			Duel.SendtoHand(ttc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,ttc)
		end
	end
end
function c22348174.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetDestination()==LOCATION_GRAVE and c:GetLeaveFieldDest()==0 and c:IsReason(REASON_DESTROY)
		and c:GetOwner()==tp and c:IsCode(22348157) and c:IsType(TYPE_MONSTER)
end
function c22348174.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c22348174.repfilter,e:GetHandler(),tp)
		return count>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=count
	end
	if Duel.SelectYesNo(tp,aux.Stringid(22348174,2)) then
		local container=e:GetLabelObject()
		container:Clear()
		local g=eg:Filter(c22348174.repfilter,e:GetHandler(),tp)
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		container:Merge(g)
		return true
	end
	return false
end
function c22348174.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end


