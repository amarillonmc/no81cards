local m=53736015
local cm=_G["c"..m]
cm.name="暗从基点"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(cm.pctg)
	e2:SetOperation(cm.pcop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(cm.chcon)
	e3:SetOperation(cm.chop)
	c:RegisterEffect(e3)
end
function cm.pctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if #eg~=1 then return false end
	local tc=eg:GetFirst()
	if chk==0 then return tc:IsControler(tp) and tc:IsType(TYPE_PENDULUM) and not tc:IsForbidden() and not tc:IsPublic() and tc:IsLocation(LOCATION_HAND) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
	Duel.SetTargetCard(eg)
end
function cm.pcop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsRelateToEffect(e) or not tc:IsType(TYPE_PENDULUM) then return end
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function cm.spfilter(c,e,tp,code)
	return c:IsSetCard(0x5538) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.cefilter(c,ct,re)
	return Duel.CheckChainTarget(ct,c) and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(re)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return e:GetHandler():GetFlagEffect(m)==0 and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and (tc:IsFaceup() or not tc:IsLocation(LOCATION_REMOVED)) and tc:IsAttribute(ATTRIBUTE_DARK) and tc:IsType(TYPE_PENDULUM) and tc:IsControler(tp) and tc:IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,tc:GetCode()) and Duel.GetMZoneCount(tp,tc)>0 and Duel.IsExistingMatchingCard(cm.cefilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,tc,ev,re)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		local tc=e:GetLabelObject()
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tg=Duel.SelectMatchingCard(tp,cm.cefilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,1,1,tc,ev,re)
		Duel.ChangeTargetCard(ev,tg)
		local code=tc:GetCode()
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
