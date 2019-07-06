--动物朋友 河狸&土拨鼠
function c33700072.initial_effect(c)
	  --tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3841833,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33700072.cost)
	e1:SetTarget(c33700072.target)
	e1:SetOperation(c33700072.operation)
	c:RegisterEffect(e1)
 --deck check
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4779823,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	e2:SetCondition(c33700072.rmcon)
	e2:SetCountLimit(1,33700072)
	e2:SetTarget(c33700072.tg)
	e2:SetOperation(c33700072.op)
	c:RegisterEffect(e2)
end
function c33700072.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c33700072.thfilter(c)
	return c:IsSetCard(0x442) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(33700072)
end
function c33700072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33700072.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33700072.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33700072.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(c33700072.aclimit)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c33700072.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	return  re:GetHandler():IsCode(tc:GetCode()) and not re:GetHandler():IsImmuneToEffect(e)
end
function c33700072.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c33700072.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(Card.IsAbleToRemove,nil)>0
		return result
	end
end
function c33700072.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if g:GetCount()>0 then
	 if g:GetClassCount(Card.GetCode)==g:GetCount() and g then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:FilterSelect(tp,Card.IsType,1,1,nil,TYPE_MONSTER)
		if sg:GetCount()>0 and sg:GetFirst():IsAbleToRemove() then
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
			sg:GetFirst():RegisterFlagEffect(33700072,RESET_EVENT+RESET_TOGRAVE+RESET_TOHAND+RESET_TODECK+RESET_TOFIELD,0,1)
			Duel.ShuffleHand(tp)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(tp)
   end
end
	 Duel.BreakEffect()
	 local ft=Duel.GetMZoneCount(tp)
	if ft>0 and Duel.IsExistingMatchingCard(c33700072.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) and e:GetHandler():IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(33700072,0)) then
	 Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	 if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end 
   local cg=Duel.SelectMatchingCard(tp,c33700072.spfilter,tp,LOCATION_REMOVED,0,1,ft,nil,e,tp)
   local tc=cg:GetFirst()
   while tc do
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	  tc=cg:GetNext()
end
end
end
end
function c33700072.spfilter(c,e,tp)
	return c:GetFlagEffect(33700072)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end