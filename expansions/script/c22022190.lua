--人理之诗 遮那王流离谭
function c22022190.initial_effect(c)
	aux.AddCodeList(c,22022180)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22022190+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22022190.cost)
	e1:SetTarget(c22022190.target)
	e1:SetOperation(c22022190.activate)
	c:RegisterEffect(e1)
end
c22022190.toss_dice=true
function c22022190.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.SelectOption(tp,aux.Stringid(22022190,0))
end
function c22022190.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c22022190.activate(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.TossDice(tp,1)
	if d==1 then
		Duel.SelectOption(tp,aux.Stringid(22022190,1))
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if g:GetCount()==0 then return end
		Duel.ConfirmCards(tp,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.ShuffleHand(1-tp)
	elseif d==2 then
		Duel.SelectOption(tp,aux.Stringid(22022190,2))
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	elseif d==3 then
		Duel.SelectOption(tp,aux.Stringid(22022190,3))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetValue(1)
		Duel.RegisterEffect(e2,tp)
	elseif d==4 then
		Duel.SelectOption(tp,aux.Stringid(22022190,4))
		local dam=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)*800
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	elseif d==5 then
		Duel.SelectOption(tp,aux.Stringid(22022190,5))
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Destroy(g,REASON_EFFECT)
	elseif d==6 then
		local g=Duel.GetMatchingGroup(c22022190.filter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0  and Duel.SelectYesNo(tp,aux.Stringid(22022190,7)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SelectOption(tp,aux.Stringid(22022190,6))
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c22022190.filter(c,e,tp)
	return c:IsCode(22022180) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end