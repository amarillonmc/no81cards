--人理之诗 彗星跑法
function c22026370.initial_effect(c)
	aux.AddCodeList(c,22025820,22025040)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22026370)
	e1:SetTarget(c22026370.target)
	e1:SetOperation(c22026370.activate)
	c:RegisterEffect(e1)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22026370.aegcon)
	e3:SetOperation(c22026370.aegop)
	c:RegisterEffect(e3)
end
function c22026370.filter(c)
	return c:IsCode(22025040) and c:IsAbleToHand()
end
function c22026370.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22026370.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22026370.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xff1)
end
function c22026370.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22026370.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local g=Duel.GetMatchingGroup(c22026370.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	local ct=Duel.GetCurrentChain()
	if ct<2 or #g<1 then return end
	local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if tep==tp and te:GetHandler():IsCode(22025820) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(22026370,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22026360.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xff1) and c:IsFaceup()
end
function c22026370.aegcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==tp and re:GetHandler():IsCode(22025820) and Duel.GetFlagEffect(tp,22026370)==0 and c:IsAbleToRemove()
		 and Duel.IsExistingMatchingCard(c22026370.afilter,tp,LOCATION_MZONE,0,1,c)
end
function c22026370.aegop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(22026370,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c22026370.afilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(22026370,3))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(tc)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.Hint(HINT_CARD,0,22026370)
		local sg=Duel.GetMatchingGroup(c22026370.filter,tp,0,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,22026370,RESET_PHASE+PHASE_END,0,1)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(22026370,2))
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e3:SetReset(RESET_PHASE+PHASE_END)
		e3:SetTargetRange(1,0)
		Duel.RegisterEffect(e3,tp)
		end
	end
end
