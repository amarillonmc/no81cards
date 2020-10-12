function c82221049.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,c82221049.mfilter,1,1)  
	c:EnableReviveLimit()  
	--tohand  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82221049,0))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,82221049)  
	e1:SetCondition(c82221049.thcon)  
	e1:SetTarget(c82221049.thtg)  
	e1:SetOperation(c82221049.thop)  
	c:RegisterEffect(e1)  
	--destroy replace  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EFFECT_DESTROY_REPLACE)  
	e2:SetRange(LOCATION_GRAVE)   
	e2:SetTarget(c82221049.reptg)  
	e2:SetValue(c82221049.repval)  
	e2:SetOperation(c82221049.repop)  
	c:RegisterEffect(e2)  
end  
function c82221049.mfilter(c)  
	return c:IsLinkSetCard(0x99) and not c:IsLinkRace(RACE_CYBERSE)  
end  
function c82221049.thcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function c82221049.thfilter(c)  
	return c:IsCode(27813661) and c:IsAbleToHand()  
end  
function c82221049.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221049.thfilter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  
function c82221049.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82221049.thfilter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  
function c82221049.repfilter(c,tp)  
	return c:IsFaceup() and c:IsSetCard(0x99)  
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)  
end  
function c82221049.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c82221049.repfilter,1,nil,tp) end  
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)  
end  
function c82221049.repval(e,c)  
	return c82221049.repfilter(c,e:GetHandlerPlayer())  
end  
function c82221049.repop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)  
end  