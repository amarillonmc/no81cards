--The One
function c79034049.initial_effect(c)
   --
   local e1=Effect.CreateEffect(c)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetCountLimit(1,79034049)
   e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e1:SetRange(LOCATION_HAND)
   e1:SetCost(c79034049.spcost)
   e1:SetTarget(c79034049.sptg)
   e1:SetOperation(c79034049.spop)
   c:RegisterEffect(e1) 
end
function c79034049.cofil(c)
	return not c:IsCode(79034049) and c:IsAbleToGraveAsCost()
end
function c79034049.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79034049.cofil,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79034049.cofil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79034049.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,1-tp,true,false,POS_FACEUP_ATTACK) end
end
function c79034049.sfil(c,e,tp)
	return c:IsSetCard(0xa007)
end
function c79034049.fcheck(c,g)
	return g:IsExists(Card.IsOriginalCodeRule,1,c,c:GetOriginalCodeRule())
end
function c79034049.fselect(g)
	return not g:IsExists(c79034049.fcheck,1,nil,g)
end
function c79034049.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,1-tp,true,false,POS_FACEUP_ATTACK) then
	local g=Duel.GetMatchingGroup(c79034049.sfil,tp,LOCATION_DECK,0,2,2,nil,e,tp)
	if g:CheckSubGroup(c79034049.fselect,2,2) and Duel.SelectYesNo(tp,aux.Stringid(79034049,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,c79034049.fselect,false,2,2,e,tp)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c79034049.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
end 
function c79034049.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end
