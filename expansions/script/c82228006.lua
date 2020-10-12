function c82228006.initial_effect(c)  
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2,2)
	--to hand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228006,0))  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,82228006)  
	e1:SetCondition(c82228006.thcon)  
	e1:SetCost(c82228006.thcost)  
	e1:SetTarget(c82228006.thtg)  
	e1:SetOperation(c82228006.thop)  
	c:RegisterEffect(e1)
	--destroy  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228006,1))  
	e2:SetCategory(CATEGORY_DESTROY)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_BATTLE_START)  
	e2:SetCondition(c82228006.descon)  
	e2:SetTarget(c82228006.destg)  
	e2:SetOperation(c82228006.desop)  
	c:RegisterEffect(e2) 
end

function c82228006.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  

function c82228006.costfilter(c)  
	return c:IsDiscardable()  
end  

function c82228006.thcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228006.costfilter,tp,LOCATION_HAND,0,1,nil) end  
	Duel.DiscardHand(tp,c82228006.costfilter,1,1,REASON_DISCARD+REASON_COST)  
end  

function c82228006.thfilter(c)  
	return c:IsSetCard(0x290) and not c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  

function c82228006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228006.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  

function c82228006.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228006.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  

function c82228006.descon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()  
	return bc and not bc:IsRace(RACE_INSECT)  
end  

function c82228006.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end  

function c82228006.desop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local bc=e:GetHandler():GetBattleTarget()  
	if bc:IsRelateToBattle() then  
		Duel.Destroy(c,REASON_EFFECT) 
		Duel.Destroy(bc,REASON_EFFECT)  
	end  
end  