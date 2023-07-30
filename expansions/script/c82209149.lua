--日光蝶
local m=82209149
local cm=c82209149
function cm.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.thcon1)
	e1:SetCost(aux.bfgcost)  
	e1:SetTarget(cm.thtg)  
	e1:SetOperation(cm.thop)  
	c:RegisterEffect(e1)  
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCondition(cm.thcon2)
	c:RegisterEffect(e2)
	--tohand
	--to hand(self)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1,m+10000)
	e3:SetCondition(cm.thcon3)
	e3:SetTarget(cm.thtg3)
	e3:SetOperation(cm.thop3)
	c:RegisterEffect(e3) 
end
function cm.cfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_XYZ) and c:IsFaceup()
end
function cm.thcon1(e,tp,eg,ep,ev,re,r,rp)  
	return not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thcon2(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.thfilter(c)  
	return c:IsSetCard(0x6a) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function cm.thfilter3(c)
	return c:IsType(TYPE_XYZ) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.thcon3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.thfilter3,1,nil)
end
function cm.thtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
