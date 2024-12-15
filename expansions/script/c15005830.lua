local m=15005830
local cm=_G["c"..m]
cm.name="天翎渊的无忧劫"
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--set
	local e3=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m+1)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsSetCard(0x5f43) and c:IsAbleToGrave()
end
function cm.pubfilter(c)
	return c:IsSetCard(0x5f43) and not c:IsPublic()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		local res=Duel.SendtoGrave(sg,REASON_EFFECT)>0
		if res and Duel.IsExistingMatchingCard(cm.pubfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
			local pc=Duel.SelectMatchingCard(tp,cm.pubfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
			if pc then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetDescription(66)
				e1:SetCode(EFFECT_PUBLIC)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
				pc:RegisterEffect(e1)
			end
		end
	end
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5f43)
		and c:IsAbleToHand()
end
function cm.filter2(c)
	return c:IsSetCard(0x5f43) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetDescription(66)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			if #g>0 then
				Duel.SSet(tp,g:GetFirst())
				local oc=Duel.GetOperatedGroup():GetFirst()
				if oc:IsType(TYPE_TRAP) and oc:IsType(TYPE_CONTINUOUS) then
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetDescription(aux.Stringid(m,1))
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					oc:RegisterEffect(e2)
				end
			end
		end
	end
end