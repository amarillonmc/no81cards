--离子炮狼
function c12057829.initial_effect(c)
	--nontuner
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(0xff)
	e0:SetCode(EFFECT_NONTUNER)
	e0:SetValue(c12057829.tnval)
	c:RegisterEffect(e0)   
	--to hand 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_CHAINING) 
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,12057829) 
	e1:SetTarget(c12057829.xthtg) 
	e1:SetOperation(c12057829.xthop) 
	c:RegisterEffect(e1)  
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057829,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22057829) 
	e2:SetCost(c12057829.thcost)
	e2:SetTarget(c12057829.thtg)
	e2:SetOperation(c12057829.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c12057829.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler())
end 
function c12057829.ctfil(c) 
	return c:IsAbleToRemoveAsCost() 
end 
function c12057829.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c12057829.ctfil,tp,LOCATION_HAND,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c12057829.ctfil,tp,LOCATION_HAND,0,1,1,nil) 
	Duel.Remove(g,POS_FACEUP,REASON_COST) 
end 
function c12057829.thfilter(c)
	return (c:IsAttack(2800) or c:IsDefense(2800)) and c:IsAbleToHand()
end
function c12057829.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057829.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12057829.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12057829.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c12057829.xthfil(c) 
	return c:IsAttackBelow(2000) and c:IsAbleToHand() 
end 
function c12057829.xthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp==1-tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsExistingMatchingCard(c12057829.xthfil,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_MZONE)
end
function c12057829.xthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c12057829.xthfil,tp,0,LOCATION_MZONE,nil) 
	if c:IsRelateToEffect(e) and g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	dg:AddCard(c) 
	Duel.SendtoHand(dg,nil,REASON_EFFECT)
	end 
end 







