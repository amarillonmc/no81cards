function c82224016.initial_effect(c)  
	--search  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82224016,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SUMMON_SUCCESS)   
	e1:SetTarget(c82224016.thtg1)  
	e1:SetOperation(c82224016.thop1)  
	c:RegisterEffect(e1)  
	--damage  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82224016,1))   
	e2:SetType(EFFECT_TYPE_QUICK_O)  
	e2:SetCategory(CATEGORY_DAMAGE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetCountLimit(1,82224016) 
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCost(c82224016.damcost) 
	e2:SetTarget(c82224016.damtg)  
	e2:SetOperation(c82224016.damop)  
	c:RegisterEffect(e2)  
end  
 
function c82224016.thfilter(c)  
	return c:GetDefense()==200 and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  
function c82224016.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82224016.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82224016.thop1(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82224016.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82224016.costfilter(c)  
	return c:GetDefense()==200 and c:IsType(TYPE_MONSTER) 
end  
function c82224016.damcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,c82224016.costfilter,1,nil) end  
	local g=Duel.SelectReleaseGroup(tp,c82224016.costfilter,1,1,nil)  
	Duel.Release(g,REASON_COST)  
end  
function c82224016.damtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)	
end  
function c82224016.damop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Damage(tp,1000,REASON_EFFECT,true) 
	Duel.Damage(1-tp,1000,REASON_EFFECT,true) 
	Duel.RDComplete() 
end  