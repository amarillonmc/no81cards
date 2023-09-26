--影灵衣的轮转天
function c11533704.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,11533704)
	e1:SetCondition(c11533704.condition)
	e1:SetTarget(c11533704.target)
	e1:SetOperation(c11533704.activate)
	c:RegisterEffect(e1)	
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCondition(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 end) 
	e2:SetTarget(c11533704.thtg) 
	e2:SetOperation(c11533704.thop) 
	c:RegisterEffect(e2) 
end
function c11533704.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb4) and c:IsType(TYPE_RITUAL)
end
function c11533704.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c11533704.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==1-tp 
end
function c11533704.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0) 
end 
function c11533704.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and c:IsSetCard(0xb4)  
end 
function c11533704.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c11533704.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11533704,0)) then
		Duel.Release(re:GetHandler(),REASON_EFFECT) 
		local sc=Duel.SelectMatchingCard(tp,c11533704.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst() 
		Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)   
		sc:CompleteProcedure() 
	end
end
function c11533704.ctfil(c,e,tp) 
	return c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c11533704.thfil,tp,LOCATION_DECK,0,1,c) 
end 
function c11533704.thfil(c) 
	return c:IsAbleToHand() and c:IsSetCard(0xb4) and c:IsType(TYPE_MONSTER)
end 
function c11533704.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c11533704.ctfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end 
	local rg=Duel.SelectMatchingCard(tp,c11533704.ctfil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)  
	rg:AddCard(e:GetHandler())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c11533704.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c11533704.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then  
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)  
	end 
end 






