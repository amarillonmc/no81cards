local m=15004555
local cm=_G["c"..m]
cm.name="破碎与坠落的净羽渊"
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--stats up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5f41))
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--SearchCard
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_RELEASE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,15004555)
	e5:SetCost(cm.srcost)
	e5:SetTarget(cm.srtg)
	e5:SetOperation(cm.srop)
	c:RegisterEffect(e5)
	if cm.counter==nil then
		cm.counter=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge3:SetCode(EVENT_RELEASE)
		ge3:SetOperation(cm.addcount)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_RELEASE) then
			local p=tc:GetReasonPlayer()
			Duel.RegisterFlagEffect(p,15004555,RESET_PHASE+PHASE_END,0,3,Duel.GetTurnCount(p))
		end
		tc=eg:GetNext()
	end
end
function cm.atkval(e,c)  
	local tp=c:GetControler()
	local x=0
	if Duel.GetFlagEffect(tp,15004555)~=0 then
		for _,i in ipairs{Duel.GetFlagEffectLabel(tp,15004555)} do
			if Duel.GetTurnCount(tp)==i+1 or (Duel.GetTurnCount(tp)==i and Duel.GetTurnPlayer()~=tp) then x=x+1 end
		end
	end
	return x*400
end
function cm.tdfilter(c,tp)
	return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode()) and c:IsSetCard(0x5f41) and not c:IsPublic()
end
function cm.srfilter(c,cod)
	return c:IsSetCard(0x5f41) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:GetCode()~=cod
end
function cm.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_HAND,0,1,nil,tp)
	end
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.ConfirmCards(1-tp,g)
	e:GetLabelObject():CreateEffectRelation(e)
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabelObject()
	if not rc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil,rc:GetCode())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if rc:IsReleasable() and rc:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.ConfirmCards(1-tp,rc)
			Duel.Release(rc,REASON_EFFECT)
		end
	end
end