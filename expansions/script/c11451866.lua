--混沌摆
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_SUMMON+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.has_text_type=TYPE_DUAL
function cm.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.thfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsType(TYPE_PENDULUM) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local tc=Duel.GetFirstTarget()
		local sc=g:GetFirst()
		if tc:IsRelateToEffect(e) and sc:IsSummonable(true,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) and sc:IsSummonable(true,nil) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_SUMMON_SUCCESS)
				e1:SetCountLimit(1)
				e1:SetLabel(Duel.GetCurrentChain())
				e1:SetCondition(cm.rscon)
				e1:SetOperation(cm.rsop(sc))
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EVENT_SUMMON_NEGATED)
				Duel.RegisterEffect(e2,tp)
				e1:SetLabelObject(e2)
				e2:SetLabelObject(e1)
				Duel.Summon(tp,sc,true,nil)
			end
		end
	end
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==e:GetLabel()-1
end
function cm.rsop(sc)
	return function(e,tp,eg,ep,ev,re,r,rp)
				if sc==eg:GetFirst() and e:GetCode()==EVENT_SUMMON_SUCCESS and sc:IsSummonable(true,nil) then
					Duel.Summon(tp,sc,true,nil)
				end
				local te=e:GetLabelObject()
				if te and aux.GetValueType(te)=="Effect" then te:Reset() end
			end
end