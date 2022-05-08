function c82224004.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetTarget(c82224004.target)  
	e1:SetOperation(c82224004.operation)  
	c:RegisterEffect(e1) 
	--atkup  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_EQUIP)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)  
	e2:SetValue(444)  
	c:RegisterEffect(e2)
end 
function c82224004.spfilter(c,e,tp)  
	return c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function c82224004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c82224004.spfilter(chkc,e,tp) end  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingTarget(c82224004.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectTarget(tp,c82224004.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)  
end  
function c82224004.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tc=Duel.GetFirstTarget()  
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)  
		and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then  
		Duel.Equip(tp,c,tc)  
		--Add Equip limit  
		local e1=Effect.CreateEffect(tc)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_EQUIP_LIMIT)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetReset(RESET_EVENT+0x1fe0000)  
		e1:SetValue(c82224004.eqlimit)  
		c:RegisterEffect(e1)  
		Duel.SpecialSummonComplete()  
	end  
end
function c82224004.eqlimit(e,c)  
	return e:GetOwner()==c  
end  