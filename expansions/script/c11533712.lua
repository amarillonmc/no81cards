--莱莎的秘术
function c11533712.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCost(c11533712.accost) 
	e1:SetTarget(c11533712.actg) 
	e1:SetOperation(c11533712.acop)
	c:RegisterEffect(e1) 
end  
function c11533712.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c11533712.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)   
end 
function c11533712.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,e:GetHandler()) 
	if chk==0 then return not Duel.CheckPhaseActivity() and g:GetCount()==g:FilterCount(Card.IsAbleToRemoveAsCost,nil) and g:GetCount()>=3 and Duel.IsExistingMatchingCard(c11533712.thfil,tp,LOCATION_DECK,0,1,nil) end  
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c11533712.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11533712.thfil,tp,LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)		 
	end 
end 





