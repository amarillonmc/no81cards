--剧团喉舌
function c79029171.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029171,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029171)
	e1:SetCost(c79029171.thcost)
	e1:SetTarget(c79029171.thtg)
	e1:SetOperation(c79029171.thop)
	c:RegisterEffect(e1)  
	--control 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29029171)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c79029171.cttg)   
	e3:SetOperation(c79029171.ctop)
	c:RegisterEffect(e3)   
	Duel.AddCustomActivityCounter(79029171,ACTIVITY_SPSUMMON,c79029171.counterfilter)
end
function c79029171.counterfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsLevel(10) 
end
function c79029171.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c79029171.thfil(c)
	return c:IsRace(RACE_FIEND) and c:IsLevel(10) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c79029171.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029171.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c79029171.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c79029171.thfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	if tc:IsCode(79029169,79029170) then 
	Duel.Hint(24,0,aux.Stringid(79029169,1))
	Duel.Hint(24,0,aux.Stringid(79029169,2))
	Duel.Hint(24,0,aux.Stringid(79029169,3))
	if tc:IsCode(79029169) then 
	Duel.Hint(24,0,aux.Stringid(79029169,4)) 
	elseif tc:IsCode(79029170) then 
	Duel.Hint(24,0,aux.Stringid(79029171,4)) 
	end
	Duel.Hint(24,0,aux.Stringid(79029169,5))
	Duel.Hint(24,0,aux.Stringid(79029169,6))
	end
	end
end
function c79029171.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==tp end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
	--
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029171.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c79029171.splimit(e,c)
	return not (c:IsRace(RACE_FIEND) and c:IsLevel(10))
end
function c79029171.ctfil(c,atk)
	return c:IsControlerCanBeChanged() and c:IsAttackBelow(atk)
end
function c79029171.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT) 
	if Duel.IsExistingMatchingCard(c79029171.ctfil,tp,0,LOCATION_MZONE,1,nil,d) and Duel.SelectYesNo(tp,aux.Stringid(79029171,0)) then 
	local tc=Duel.SelectMatchingCard(tp,c79029171.ctfil,tp,0,LOCATION_MZONE,1,1,nil,d)
	Duel.GetControl(tc,tp)
	end
end







