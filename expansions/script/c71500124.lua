--一人的远行
function c71500124.initial_effect(c)
	aux.AddSetNameMonsterList(c,0x78f1) 
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,71500124)  
	e1:SetTarget(c71500124.target)
	e1:SetOperation(c71500124.activate)
	c:RegisterEffect(e1)
	--sort decktop
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11500124) 
	e2:SetCost(c71500124.thcost)
	e2:SetTarget(c71500124.thtg)
	e2:SetOperation(c71500124.thop)
	c:RegisterEffect(e2)
end 
function c71500124.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then 
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	else 
		e:SetProperty(0) 
	end 
end
function c71500124.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1) 
	e1:SetCondition(c71500124.xtdcon) 
	e1:SetOperation(c71500124.xtdop) 
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
end 
function c71500124.xtdcon(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return g:GetCount()>0 
end 
function c71500124.xspfil(c,e,tp) 
	return c:IsLevel(1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end 
function c71500124.xtdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
		Duel.Hint(HINT_CARD,0,71500124) 
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
		if Duel.IsExistingMatchingCard(c71500124.xspfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(71500124,0)) then 
			Duel.BreakEffect() 
			local sc=Duel.SelectMatchingCard(tp,c71500124.xspfil,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_COUNTER_PERMIT|0x78f1) 
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetRange(LOCATION_MZONE)  
			sc:RegisterEffect(e1) 
			sc:AddCounter(0x78f1,5)  
		end 
	end 
end 
function c71500124.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c71500124.sthfil(c) 
	return c:IsAbleToHand() and aux.IsSetNameMonsterListed(c,0x78f1) 
end 
function c71500124.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71500124.sthfil,tp,LOCATION_DECK,0,2,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0) 
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0 then 
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	else 
		e:SetProperty(0) 
	end 
end
function c71500124.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local sg=Duel.SelectMatchingCard(tp,c71500124.sthfil,tp,LOCATION_DECK,0,2,2,nil) 
	if sg:GetCount()>0 then 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg) 
		if c:IsRelateToEffect(e) then 
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT) 
		end 
	end 
end 




