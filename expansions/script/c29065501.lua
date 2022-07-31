--方舟骑士-凯尔希
c29065501.named_with_Arknight=1
function c29065501.initial_effect(c)
	aux.AddCodeList(c,29065500,29065501)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon P 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION) 
	e4:SetRange(LOCATION_PZONE)  
	e4:SetCountLimit(1,29065502) 
	e4:SetCondition(c29065501.pspcon)
	e4:SetTarget(c29065501.psptg) 
	e4:SetOperation(c29065501.pspop) 
	c:RegisterEffect(e4)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065501,0))
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,29065501)
	e2:SetTarget(c29065501.thtg)
	e2:SetOperation(c29065501.thop)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	c29065501.summon_effect=e2
end
function c29065501.pcfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and not c:IsCode(29065501) and not c:IsForbidden()
end
function c29065501.pspcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler()) 
end   
function c29065501.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler()) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetTargetCard(sc) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0) 
end 
function c29065501.pspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	if Duel.IsExistingMatchingCard(c29065501.pcfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(29065501,0)) then 
	local sg=Duel.SelectMatchingCard(tp,c29065501.pcfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp) 
	Duel.MoveToField(sg:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	end 
	end 
	end 
end 
function c29065501.xthfilter(c)
	return aux.IsCodeListed(c,29065500) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c29065501.xthfilter1(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function c29065501.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065500) then
			return Duel.IsExistingMatchingCard(c29065501.xthfilter,tp,LOCATION_DECK,0,1,nil) end
		return Duel.IsExistingMatchingCard(c29065501.xthfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29065501.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,29065500) then
		g=Duel.SelectMatchingCard(tp,c29065501.xthfilter,tp,LOCATION_DECK,0,1,1,nil)
	else g=Duel.SelectMatchingCard(tp,c29065501.xthfilter1,tp,LOCATION_DECK,0,1,1,nil) end
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end