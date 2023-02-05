--CiNo.107 超银河眼时空极龙
function c79029557.initial_effect(c)
	c:EnableCounterPermit(0x593)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,4,c79029557.ovfilter,aux.Stringid(79029557,0))
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029557,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79029557)
	e1:SetCondition(c79029557.thcon)
	e1:SetTarget(c79029557.thtg)
	e1:SetOperation(c79029557.thop)
	c:RegisterEffect(e1) 
	--time 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,19029557)  
	e2:SetCost(c79029557.ttcost) 
	e2:SetTarget(c79029557.tttg) 
	e2:SetOperation(c79029557.ttop)
	c:RegisterEffect(e2)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c79029557.splimit)
	c:RegisterEffect(e1)
end
c79029557.xyz_number=107
function c79029557.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x95) and se:GetHandler():IsType(TYPE_SPELL)
end
function c79029557.ovfilter(c)
	return c:IsFaceup() and c:IsCode(68396121) 
end
function c79029557.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79029557.thfilter(c)
	return c:IsSetCard(0x175,0x7b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c79029557.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029557.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029557.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c79029557.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c79029557.ttcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029557.ttfil(c,turn)
	return c:GetTurnID()==turn 
end
function c79029557.tttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c79029557.ttfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),Duel.GetTurnCount()) end 
	Duel.SetChainLimit(c79029557.chlimit)
end
function c79029557.chlimit(e,ep,tp)
	return tp==ep
end
function c79029557.ttop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029557.ttfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler(),Duel.GetTurnCount()) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,99,nil)
	local tc=sg:GetFirst() 
	while tc do 
	local loc=tc:GetPreviousLocation() 
	local p=tc:GetPreviousControler()
	if bit.band(loc,LOCATION_HAND)~=0 then 
	Duel.SendtoHand(tc,p,REASON_EFFECT+REASON_RULE)
	elseif bit.band(loc,LOCATION_DECK)~=0 then
	Duel.SendtoDeck(tc,p,2,REASON_EFFECT+REASON_RULE)
	elseif bit.band(loc,LOCATION_EXTRA)~=0 then
	if tc:IsPreviousPosition(POS_FACEUP) then 
	Duel.SendtoExtraP(tc,p,REASON_EFFECT+REASON_RULE)
	else
	Duel.SendtoDeck(tc,p,2,REASON_EFFECT+REASON_RULE) 
	end
	elseif bit.band(loc,LOCATION_GRAVE)~=0 then
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RULE)
	elseif bit.band(loc,LOCATION_REMOVED)~=0 then
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_RULE)
	else 
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_RULE)
	end
	tc=sg:GetNext()
	end
	if Duel.IsExistingMatchingCard(Card.IsCanBeBattleTarget,tp,0,LOCATION_MZONE,1,nil,c) and Duel.SelectYesNo(tp,aux.Stringid(79029557,1)) then 
	local bc=Duel.SelectMatchingCard(tp,Card.IsCanBeBattleTarget,tp,0,LOCATION_MZONE,1,1,nil,c):GetFirst()
	Duel.CalculateDamage(c,bc)
	end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1) 
	e1:SetLabel(sg:GetCount())
	e1:SetValue(c79029557.damval)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function c79029557.damval(e,re,val,r,rp,rc)
	return val-e:GetLabel()*1500
end




