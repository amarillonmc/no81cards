--生命的奔流
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION+CATEGORY_DRAW+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.filter(c)
	return c:IsCode(60001505) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.cfil(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x624,1) and c:IsType(TYPE_MONSTER)
end
function cm.mfil(c)
	return c:IsFaceup() and c:IsSetCard(0x5622) and c:IsLevelAbove(5)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		local a1,a2,a3=0
		local b1,b2,b3=Duel.IsPlayerCanDraw(tp),Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil),Duel.IsExistingMatchingCard(cm.cfil,tp,LOCATION_MZONE,0,1,nil)
		if (b1 or b2 or b3) and Duel.IsExistingMatchingCard(cm.mfil,tp,LOCATION_MZONE,0,1,nil) then
			if b1 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then a1=1 end
			if b2 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then a2=1 end
			if b3 and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then a3=1 end
		elseif (b1 or b2 or b3) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(m,1)},
				{b2,aux.Stringid(m,2)},
				{b3,aux.Stringid(m,3)})
			if op==1 then a1=1
			elseif op==2 then a2=1
			elseif op==3 then a3=1 end
		end
		if a1==1 and b1 then Duel.Draw(tp,1,REASON_EFFECT) end
		if a2==1 and b2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
			if g then Duel.Remove(g,POS_FACEUP,REASON_EFFECT) end
		end
		if a3==1 and b3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=Duel.SelectMatchingCard(tp,cm.cfil,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
			tc:AddCounter(0x624,1)
			Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		end
	end
end
