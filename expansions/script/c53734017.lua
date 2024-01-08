local m=53734017
local cm=_G["c"..m]
cm.name="青缀流逝的盛夏"
cm.Snnm_Ef_Rst=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	SNNM.AozoraDisZoneGet(c)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return SNNM.DisMZone(tp)&0x1f>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local zone=SNNM.DisMZone(tp)
	if zone&0x1f>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
		local z=Duel.SelectField(tp,1,LOCATION_MZONE,0,(~zone)|0xe000e0)
		Duel.Hint(HINT_ZONE,tp,z)
		e:SetLabel(z)
		SNNM.ReleaseMZone(e,tp,z)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.rmop)
	Duel.RegisterEffect(e1,tp)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local ct=0
	for i=0,4 do if SNNM.DisMZone(tp)&(1<<i)>0 then ct=ct+1 end end
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil)
	if g:GetCount()==0 then return end
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retfilter(c)
	return c:GetFlagEffect(m)~=0
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.retfilter,nil)
	if sg:GetCount()>1 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,1))
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.ReturnToField(tc)
	else
		local tc=sg:GetFirst()
		while tc do
			Duel.ReturnToField(tc)
			tc=sg:GetNext()
		end
	end
end
function cm.thfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0x3536) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(m) and (c:IsAbleToHand() or c:IsLocation(LOCATION_REMOVED))
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,e:GetHandler())
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsLocation(LOCATION_GRAVE) then Duel.SendtoHand(tc,nil,REASON_EFFECT) elseif tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then Duel.SendtoHand(tc,nil,REASON_EFFECT) else Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN) end
end
