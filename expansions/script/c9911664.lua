--岭偶腐构体·孽生
function c9911664.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,9911664+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9911664.condition)
	e1:SetTarget(c9911664.target)
	e1:SetOperation(c9911664.activate)
	c:RegisterEffect(e1)
	if not c9911664.global_check then
		c9911664.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c9911664.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911664.flagfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER)
end
function c9911664.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9911664.flagfilter,nil)
	if #g==0 then return end
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(9911664,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911664,2))
	end
	if g:IsExists(Card.IsControler,1,nil,0) and Duel.GetFlagEffect(0,9911654)==0 then
		Duel.RegisterFlagEffect(0,9911654,RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9911654,2))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
	end
	if g:IsExists(Card.IsControler,1,nil,1) and Duel.GetFlagEffect(1,9911654)==0 then
		Duel.RegisterFlagEffect(1,9911654,RESET_PHASE+PHASE_END,0,1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetDescription(aux.Stringid(9911654,2))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e2:SetTargetRange(1,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,1)
	end
end
function c9911664.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c9911664.thtgfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9911664.spfilter(c,e,tp)
	return c:GetFlagEffect(9911664)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911664.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9911664.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9911664.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local rc=re:GetHandler()
	if rc and rc:IsRelateToEffect(re) and rc:IsCanBeSpecialSummoned(e,0,tp,false,false) then g:AddCard(rc) end
	local b1=Duel.IsExistingMatchingCard(c9911664.thtgfilter,tp,LOCATION_DECK,0,3,nil)
	local b2=Duel.GetFlagEffect(tp,9911654)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and #g>0
		and Duel.IsExistingMatchingCard(c9911664.setfilter,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
end
function c9911664.activate(e,tp,eg,ep,ev,re,r,rp)
	local chk
	local g=Duel.GetMatchingGroup(c9911664.thtgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		local tg=sg:RandomSelect(1-tp,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=tg:Select(tp,1,1,nil):GetFirst()
		if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			tc:SetStatus(STATUS_TO_HAND_WITHOUT_CONFIRM,true)
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
		chk=true
	end
	if Duel.GetFlagEffect(tp,9911654)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g1=Duel.SelectMatchingCard(tp,c9911664.setfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if #g1==0 then return end
	if chk then Duel.BreakEffect() end
	Duel.HintSelection(g1)
	if Duel.ChangePosition(g1,POS_FACEDOWN_DEFENSE)==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9911664.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	local rc=re:GetHandler()
	if rc and rc:IsRelateToEffect(re) and rc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not aux.NecroValleyNegateCheck(rc) then g2:AddCard(rc) end
	if #g2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g2:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
