--绝音魔女的错视之城
function c71200894.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)   
	c:RegisterEffect(e1)	 
	--xx 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_FZONE)  
	e1:SetCountLimit(1,71200894)
	e1:SetTarget(c71200894.xxtg)
	e1:SetOperation(c71200894.xxop)
	c:RegisterEffect(e1)  
	--to grave 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetRange(LOCATION_FZONE)  
	e2:SetCountLimit(1,71200895) 
	e2:SetCondition(c71200894.tgcon)
	e2:SetTarget(c71200894.tgtg)
	e2:SetOperation(c71200894.tgop)
	c:RegisterEffect(e2) 
end
function c71200894.thfil(c,e,tp,code)
	return not c:IsCode(code) and c:IsSetCard(0x895) and c:IsAbleToHand()
end
function c71200894.ctfil1(c,e,tp)
	return c:IsSetCard(0x895) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c71200894.thfil,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c71200894.spfil(c,e,tp,code)
	return not c:IsCode(code) and c:IsSetCard(0x895) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71200894.ctfil2(c,e,tp)
	return c:IsSetCard(0x895) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c71200894.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function c71200894.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local b1=Duel.IsExistingMatchingCard(c71200894.ctfil1,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c71200894.ctfil2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	if chk==0 then return b1 or b2 end 
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(71200894,1)},{b2,aux.Stringid(71200894,2)})
	e:SetCategory(CATEGORY_TOGRAVE)
	e:SetLabel(0)
	if op==1 then 
		e:SetLabel(1)
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH) 
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND) 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
	end
	if op==2 then  
		e:SetLabel(2)
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON) 
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)  
	end
end
function c71200894.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local op=e:GetLabel()
	local b1=Duel.IsExistingMatchingCard(c71200894.ctfil1,tp,LOCATION_HAND,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(c71200894.ctfil2,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	if op==1 and b1 then
		local tc=Duel.SelectMatchingCard(tp,c71200894.ctfil1,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst() 
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c71200894.thfil,tp,LOCATION_DECK,0,1,nil,e,tp,tc:GetCode()) then 
			local sg=Duel.SelectMatchingCard(tp,c71200894.thfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	end
	if op==2 and b2 then
		local tc=Duel.SelectMatchingCard(tp,c71200894.ctfil2,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst() 
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c71200894.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetCode()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
			local sg=Duel.SelectMatchingCard(tp,c71200894.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc:GetCode())
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end
end
function c71200894.tgckfil(c,tp) 
	return c:IsControler(tp) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsSetCard(0x895)  
end 
function c71200894.tgcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c71200894.tgckfil,1,nil,tp)  
end 
function c71200894.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chkc then return chkc:IsOnField() and chkc:IsAbleToGrave() end   
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c71200894.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) then 
		Duel.SendtoGrave(tc,REASON_EFFECT) 
	end 
end 



