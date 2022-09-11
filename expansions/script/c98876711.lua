--芦苇之寻芳精
function c98876711.initial_effect(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,98876711+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c98876711.hspcon)
	e1:SetOperation(c98876711.hspop)
	c:RegisterEffect(e1) 
	--to hand 
	local e2=Effect.CreateEffect(c)   
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,18876711)  
	e2:SetCost(c98876711.thcost)
	e2:SetTarget(c98876711.thtg) 
	e2:SetOperation(c98876711.thop) 
	c:RegisterEffect(e2)  
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c98876711.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c98876711.spfilter(c,ft)
	return c:IsAbleToDeckAsCost() and c:IsSetCard(0x988) and c:IsType(TYPE_MONSTER)
end
function c98876711.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and Duel.IsExistingMatchingCard(c98876711.spfilter,tp,LOCATION_GRAVE,0,2,c,ft)
end
function c98876711.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c98876711.spfilter,tp,LOCATION_GRAVE,0,2,2,c,ft)
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end 
function c98876711.tctfil(c) 
	return c:IsReleasable() and c:IsType(TYPE_MONSTER)
end 
function c98876711.thcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c98876711.tctfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE) 
	local g=Duel.SelectMatchingCard(tp,c98876711.tctfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil) 
	Duel.Release(g,REASON_COST) 
end   
function c98876711.thfil(c) 
	return c:IsAbleToHand() and c:IsCode(95286165,32441317,78610936)	
end 
function c98876711.thgck(g) 
	return g:GetClassCount(Card.GetCode)==g:GetCount()   
end  
function c98876711.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c98876711.thfil,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(c98876711.thgck,1,3) end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c98876711.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c98876711.thfil,tp,LOCATION_GRAVE,0,nil) 
	if g:CheckSubGroup(c98876711.thgck,1,3) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND) 
	local sg=g:SelectSubGroup(tp,c98876711.thgck,false,1,3) 
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg)
	end 
end 
function c98876711.indtg(e,c)
	return c:IsRace(RACE_PLANT) and c~=e:GetHandler()
end








