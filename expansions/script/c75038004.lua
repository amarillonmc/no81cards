--强袭白龙
function c75038004.initial_effect(c)
	aux.AddCodeList(c,89631139) 
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75038004,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,75038004)
	e1:SetCost(c75038004.thcost)
	e1:SetTarget(c75038004.thtg)
	e1:SetOperation(c75038004.thop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--eff
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetCountLimit(1,75038005)
	e2:SetCondition(c75038004.effcon) 
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c75038004.efftg)
	e2:SetOperation(c75038004.effop)
	c:RegisterEffect(e2)
end
function c75038004.tctfil(c) 
	return c:IsAbleToGraveAsCost() and c:IsCode(89631139)   
end 
function c75038004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75038004.tctfil,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c75038004.tctfil,tp,LOCATION_DECK,0,1,1,nil) 
	Duel.SendtoGrave(g,REASON_COST) 
end
function c75038004.thfilter(c)
	return (c:IsCode(21082832) or (c:IsType(TYPE_RITUAL) and c:IsRace(RACE_DRAGON) and c:IsSetCard(0xcf))) and c:IsAbleToHand()
end
function c75038004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75038004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75038004.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75038004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)  
		if c:IsRelateToEffect(e) then 
			Duel.BreakEffect() 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE) 
			e1:SetCode(EFFECT_UPDATE_LEVEL) 
			e1:SetRange(LOCATION_MZONE) 
			e1:SetValue(4) 
			e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
			c:RegisterEffect(e1) 
		end 
	end
end
function c75038004.effcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c75038004.efffil(c) 
	return c:IsFaceup() and c:IsSetCard(0xcf) and c:IsType(TYPE_RITUAL)
end 
function c75038004.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c75038004.efffil(chkc) end 
	if chk==0 then return Duel.IsExistingTarget(c75038004.efffil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectTarget(tp,c75038004.efffil,tp,LOCATION_MZONE,0,1,1,nil)
end 
function c75038004.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		--search
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(75038004,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_BATTLE_DESTROYING) 
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCondition(aux.bdocon)
		e1:SetCost(c75038004.cost)
		e1:SetTarget(c75038004.target)
		e1:SetOperation(c75038004.operation) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end 
end 
function c75038004.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and not c:IsCode(e:GetHandler():GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c75038004.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c75038004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c75038004.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c75038004.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75038004.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end




 
