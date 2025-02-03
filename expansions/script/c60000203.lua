--飞鹊剪枝
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000196)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.confil(c)
	return c:IsCode(60000202) and c:IsFaceup()
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confil,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:GetCode()==60000202 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if #g~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetCount()>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(1-tp,sg)
				if Duel.IsPlayerCanDraw(tp,1) then Duel.Draw(tp,1,REASON_EFFECT) end
				if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
			end
		end
	else
		local op=aux.SelectFromOptions(1-tp,{true,aux.Stringid(m,1)},{true,aux.Stringid(m,2)})
		if op==1 then
			if Duel.IsPlayerCanDraw(1-tp,1) then Duel.Draw(1-tp,1,REASON_EFFECT) end
			if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
		elseif op==2 then
			if Duel.IsPlayerCanDraw(tp,1) then Duel.Draw(tp,1,REASON_EFFECT) end
			local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
			if #g~=0 then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
				local sg=g:Select(1-tp,1,1,nil)
				if sg:GetCount()>0 then Duel.Destroy(sg,REASON_EFFECT) end
			end
		end
	end
end
function cm.filter(c)
	return (c:IsCode(60000201) or c:IsCode(60000196)) and c:IsAbleToHand()
end

