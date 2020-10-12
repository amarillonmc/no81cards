function c82221051.initial_effect(c)  
	aux.EnablePendulumAttribute(c)  
	--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(c82221051.psplimit)  
	c:RegisterEffect(e1) 
	--Search  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221051,0))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCode(EVENT_DESTROYED)  
	e3:SetTarget(c82221051.thtg)  
	e3:SetOperation(c82221051.thop)  
	c:RegisterEffect(e3)  
	local e2=e3:Clone()
	e2:SetCode(EVENT_REMOVE) 
	c:RegisterEffect(e2) 
end  

function c82221051.psplimit(e,c,tp,sumtp,sumpos)  
	return not c:IsRace(RACE_DRAGON) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end  
function c82221051.thfilter(c)  
	return c:IsSetCard(0xf2) and not c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end  
function c82221051.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221051.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82221051.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221051.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end