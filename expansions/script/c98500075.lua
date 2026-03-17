--三幻魔的起源
local m=98500075
local cm=_G["c"..m]
cm.name="lingyu！"
function cm.initial_effect(c)
	aux.AddCodeList(c,6007213,32491822,69890967)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate2)
	Duel.RegisterEffect(e2,tp)
end
function cm.filter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (c:IsCode(6007213,32491822,69890967) or (c:IsSetCard(0x144) and c:IsType(TYPE_FUSION)))
end
function cm.filter2(c)
	return c:IsCode(16317140) and c:IsAbleToHand()
end
function cm.filter3(c)
	return c:IsCode(54828837) and c:IsAbleToHand()
end
function cm.filter4(c)
	return c:IsCode(28651380) and c:IsAbleToHand()
end
function cm.filter5(c)
	return c:IsCode(13301895) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter,1,nil) end
	local g=eg:Filter(cm.filter,nil)
	Duel.SetTargetCard(eg)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			tc:CompleteProcedure()
			if tc:IsCode(6007213) and Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			elseif tc:IsCode(32491822) and Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then  
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			elseif tc:IsCode(69890967) and Duel.GetFlagEffect(tp,m)==0 and Duel.IsExistingMatchingCard(cm.filter4,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then  
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,cm.filter4,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			elseif tc:IsSetCard(0x144) and Duel.GetFlagEffect(tp,m)==0 and c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(cm.filter5,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,7))  then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,cm.filter5,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			end
			tc=g:GetNext()
		end
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.thfilter(c,e,tp)
	return c:IsAttack(0) and c:IsDefense(0) and c:IsRace(RACE_FIEND) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP))
end
function cm.thfilter2(c,e,tp)
	return c:IsCode(80312545) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil) or Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_REMOVED,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_DECK,0,1,nil)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,2)},
		{b2,aux.Stringid(m,3)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			local b1=tc:IsAbleToHand()
			local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			local op=aux.SelectFromOptions(tp,{b1,1190},{b2,1152})
			if op==1 then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
			if op==2 then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
