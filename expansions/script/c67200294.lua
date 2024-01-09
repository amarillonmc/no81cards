--封缄的征伐预备
function c67200294.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,67200294+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c67200294.cost)
	e1:SetTarget(c67200294.target)
	e1:SetOperation(c67200294.activate)
	c:RegisterEffect(e1)	
end
function c67200294.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,Card.IsSetCard,1,nil,0x674) end
	local sg=Duel.SelectReleaseGroup(REASON_COST,tp,Card.IsSetCard,1,1,nil,0x674)
	Duel.Release(sg,REASON_COST)
end
function c67200294.thfilter(c)
	return c:IsSetCard(0x674) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c67200294.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200294.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c67200294.filter(c,atk)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x674) and c:IsAttackBelow(atk)
end
function c67200294.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c67200294.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g)~=0 and tc:IsLocation(LOCATION_HAND) then
		local atk=tc:GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200294,2))
		local hg=Duel.SelectMatchingCard(tp,c67200294.filter,tp,LOCATION_DECK,0,1,1,nil,atk)
		local hc=hg:GetFirst()
		if hc then
			Duel.BreakEffect()
			Duel.SendtoExtraP(hc,tp,REASON_EFFECT)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c67200294.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c67200294.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x674) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
