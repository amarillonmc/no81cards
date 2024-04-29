--万物归终的使者
function c21474346.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c21474346.matfilter,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21474346,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,21474346)
	e1:SetTarget(c21474346.target)
	e1:SetOperation(c21474346.activate)
	c:RegisterEffect(e1)
end
function c21474346.matfilter(c)
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsRace(RACE_SPELLCASTER) and c:IsAttack(2100) and c:IsDefense(1500)
end

function c21474346.filter(c)
	return c:IsCode(21474347) and c:IsAbleToHand()
end
function c21474346.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21474346.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c21474346.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c21474346.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsLocation(LOCATION_HAND) then
			if Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) and Duel.GetFlagEffect(tp,c21474346)==0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(c21474346,2))
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetTargetRange(LOCATION_HAND,0)
				e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
				e1:SetValue(0x1)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_EXTRA_SET_COUNT)
				Duel.RegisterEffect(e2,tp)
				Duel.RegisterFlagEffect(tp,c21474346,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end