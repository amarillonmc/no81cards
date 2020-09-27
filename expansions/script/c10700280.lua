--银河眼光波镜像龙
function c10700280.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c10700280.mfilter,c10700280.xyzcheck,2,2)
	--cannot be target  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetTarget(c10700280.target)
	e1:SetTargetRange(LOCATION_ONFIELD,0)  
	e1:SetValue(aux.tgoval)  
	c:RegisterEffect(e1)
	--activate limit  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(0,1)  
	e2:SetCondition(c10700280.actcon)  
	e2:SetValue(1)  
	c:RegisterEffect(e2)
	--SearchCard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700280,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10700280)
	e3:SetCost(c10700280.thcost)
	e3:SetTarget(c10700280.thtg)
	e3:SetOperation(c10700280.thop)
	c:RegisterEffect(e3)
end
function c10700280.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_MONSTER)
end
function c10700280.xyzcheck(g)
	return g:GetClassCount(Card.GetCode)==1
end
function c10700280.target(e,c)  
	return c:IsSetCard(0x107b) 
end 
function c10700280.actcon(e)  
	local ph=Duel.GetCurrentPhase()  
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE  
end 
function c10700280.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end 
function c10700280.filter1(c)
	return (c:IsSetCard(0x55) or c:IsSetCard(0x107b)) and c:IsAbleToHand()
end
function c10700280.filter2(c)
	return (c:IsSetCard(0xe5) or c:IsSetCard(0x107b)) and c:IsAbleToHand()
end
function c10700280.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10700280.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c10700280.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10700280.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c10700280.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c10700280.filter2,tp,LOCATION_DECK,0,1,1,nil)
	local g=g1+g2
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetTarget(c10700280.splimit)
	Duel.RegisterEffect(e4,tp)
end
function c10700280.splimit(e,c)
	return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end