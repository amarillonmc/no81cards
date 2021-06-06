local m=31409208
local cm=_G["c"..m]
cm.name="苍燧烽律令 苍炎玫瑰"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cm.con)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,31409201)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.fieldfilter(c)
	return c:IsSetCard(0x5310) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.gravefilter(c)
	return c:IsSetCard(0x5310) and c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP) and not c:IsForbidden()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fieldfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.fieldfilter,tp,LOCATION_SZONE,0,nil)
	local num=g:GetCount()
	if num>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if num>Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD) then
			num=Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)
		end
		if num>0 and Duel.IsExistingMatchingCard(cm.gravefilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local g2=Duel.SelectMatchingCard(tp,cm.gravefilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,num,nil)
			local tc=g2:GetFirst()
			while tc do			 
				local m=_G["c"..tc:GetCode()]
				local te=m.act
				local op=te:GetOperation()
				if op and tc:IsLocation(LOCATION_GRAVE) then
					te:SetLabel(1)
					local etg=Group.CreateGroup()
					etg:AddCard(tc)
					op(te,tp,etg,ep,ev,re,r,rp)
				end
				tc=g2:GetNext()
			end
		end
	end
end