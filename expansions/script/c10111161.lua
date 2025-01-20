function c10111161.initial_effect(c)
	aux.AddCodeList(c,3055018)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,10111161+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10111161.sprcon)
	c:RegisterEffect(e1)
	 --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111161,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,101111610)
	e2:SetCondition(c10111161.accon)
	e2:SetCost(c10111161.cost)
	e2:SetTarget(c10111161.actg)
	e2:SetOperation(c10111161.acop)
	c:RegisterEffect(e2)
end
function c10111161.sprfilter(c)
	return c:IsFaceup() and c:IsCode(3055018)
end
function c10111161.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10111161.sprfilter,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c10111161.accon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
		and not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil)
end
function c10111161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c10111161.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,3055018) end
end
function c10111161.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.GetFirstMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,nil,3055018)
	if tc then
		local te=tc:GetActivateEffect()
		if te:IsActivatable(tp,true,true) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			if  Duel.SelectYesNo(tp,aux.Stringid(10111161,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
            end
        	local e1=Effect.CreateEffect(e:GetHandler())
        	e1:SetType(EFFECT_TYPE_FIELD)
        	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
         	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        	e1:SetTargetRange(1,0)
          	e1:SetTarget(c10111161.splimit)
        	e1:SetReset(RESET_PHASE+PHASE_END)
         	Duel.RegisterEffect(e1,tp)
		end
	end
end
function c10111161.splimit(e,c)
	return not c:IsRace(RACE_PYRO) and c:IsLocation(LOCATION_EXTRA)
end