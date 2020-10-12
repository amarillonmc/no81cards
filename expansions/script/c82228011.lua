function c82228011.initial_effect(c)  
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_INSECT),2)
	--destroy  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1) 
	e1:SetTarget(c82228011.destg)  
	e1:SetOperation(c82228011.desop)  
	c:RegisterEffect(e1)  
	--to grave  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
	e2:SetCode(EVENT_TO_GRAVE)   
	e2:SetOperation(c82228011.regop)  
	c:RegisterEffect(e2)  
end  
 
function c82228011.desfilter(c)  
	return c:IsType(TYPE_MONSTER)  
end  
function c82228011.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c82228011.desfilter(chkc) end  
	if chk==0 then return Duel.IsExistingTarget(c82228011.desfilter,tp,0,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,c82228011.desfilter,tp,0,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function c82228011.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		Duel.Destroy(tc,REASON_EFFECT)  
	end  
end  
 
function c82228011.regop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228011,1))  
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_PHASE+PHASE_END)  
	e1:SetRange(LOCATION_GRAVE)  
	e1:SetCountLimit(1,82228011)  
	e1:SetTarget(c82228011.thtg)  
	e1:SetOperation(c82228011.thop)  
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
	c:RegisterEffect(e1)  
end  

function c82228011.filter(c)  
	return c:IsRace(RACE_INSECT) and c:IsAbleToHand()  
end  

function c82228011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228011.filter,tp,LOCATION_DECK,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)  
end  

function c82228011.thop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)  
	local g=Duel.SelectMatchingCard(tp,c82228011.filter,tp,LOCATION_DECK,0,1,1,nil)  
	if g:GetCount()>0 then  
		Duel.SendtoHand(g,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-tp,g)  
	end  
end  