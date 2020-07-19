--急速的兵法 其疾如风！
function c10700021.initial_effect(c)
	--Activate1 spell/trap tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700021,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10700021.sptg)
	e1:SetOperation(c10700021.spact)
	c:RegisterEffect(e1)
	--Activate search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700021,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c10700021.sertg)
	e2:SetOperation(c10700021.seract)
	c:RegisterEffect(e2)
	--Activate1 tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700021,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10700021.tftg)
	e1:SetOperation(c10700021.tfact)
	c:RegisterEffect(e1)
end
function c10700021.setfilter(c)
	return c:IsCode(1781310) and c:IsSSetable()
end
function c10700021.spfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c10700021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c10700021.spfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700021.spfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10700021.spfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10700021.spact(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if dg:GetCount()>0 and Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_WIND)>=3 and Duel.SelectYesNo(tp,aux.Stringid(10700021,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,dg,HINTMSG_TODECK)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			Duel.BreakEffect()
			local b1=Duel.IsPlayerCanDraw(tp,1)
			local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(c10700021.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			if not b1 and not b2 then return end
			if not Duel.SelectYesNo(tp,aux.Stringid(10700021,4)) then return end
			if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(10700021,5))) then
			Duel.Draw(tp,1,REASON_EFFECT)
			else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local ag=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10700021.setfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
				if ag and Duel.SSet(tp,ag)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ag:RegisterEffect(e1)
				local e2=e1:Clone()
				ag:RegisterEffect(e2)
				end
			end
		end
	end
end
function c10700021.serfilter(c)
	return c:IsCode(1781310) and c:IsAbleToHand()
end
function c10700021.sertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700021.serfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10700021.seract(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c10700021.serfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	  if tc:GetCount()>0 and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_WIND)>=3 and Duel.SelectYesNo(tp,aux.Stringid(10700021,3)) then 
		local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,dg,HINTMSG_TODECK)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			Duel.BreakEffect()
			local b1=Duel.IsPlayerCanDraw(tp,1)
			local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(c10700021.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			if not b1 and not b2 then return end
			if not Duel.SelectYesNo(tp,aux.Stringid(10700021,4)) then return end
			if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(10700021,5))) then
			Duel.Draw(tp,1,REASON_EFFECT)
			else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local ag=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10700021.setfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
				if ag and Duel.SSet(tp,ag)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ag:RegisterEffect(e1)
				local e2=e1:Clone()
				ag:RegisterEffect(e2)
				end
			end
	   end
end
function c10700021.tffilter(c)
	return c:IsAbleToHand()
end
function c10700021.tftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c10700021.tffilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10700021.tffilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c10700021.tffilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c10700021.tfact(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
		if dg:GetCount()>0 and Duel.GetMatchingGroupCount(Card.IsAttribute,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ATTRIBUTE_WIND)>=3 and Duel.SelectYesNo(tp,aux.Stringid(10700021,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,dg,HINTMSG_TODECK)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			Duel.BreakEffect()
			local b1=Duel.IsPlayerCanDraw(tp,1)
			local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(c10700021.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
			if not b1 and not b2 then return end
			if not Duel.SelectYesNo(tp,aux.Stringid(10700021,4)) then return end
			if b1 and (not b2 or not Duel.SelectYesNo(tp,aux.Stringid(10700021,5))) then
			Duel.Draw(tp,1,REASON_EFFECT)
			else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local ag=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10700021.setfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
				if ag and Duel.SSet(tp,ag)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ag:RegisterEffect(e1)
				local e2=e1:Clone()
				ag:RegisterEffect(e2)
				end
			end
		end
	end
end