--君主事件簿 双貌塔
function c77000135.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--td an sp 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE) 
	e1:SetCountLimit(1,77000135) 
	e1:SetTarget(c77000135.tdsptg) 
	e1:SetOperation(c77000135.tdspop) 
	c:RegisterEffect(e1) 
	--cannot remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(function(e,c,tp,r)
	return c:IsControler(tp) and c:IsOnField() and c:IsSetCard(0x5ee0) end)
	c:RegisterEffect(e2)
end 
function c77000135.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x5ee0) 
end 
function c77000135.tdfil(c,tp) 
	return Duel.GetMZoneCount(tp,c)>0 and c:IsFaceup() and c:IsSetCard(0x5ee0) and c:IsAbleToDeck()   
end 
function c77000135.tdsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(c77000135.tdfil,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c77000135.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():IsAbleToDeck() end 
	local g=Duel.SelectTarget(tp,c77000135.tdfil,tp,LOCATION_MZONE,0,1,1,nil,tp) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end  
function c77000135.tdspop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c77000135.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) then 
		local sg=Duel.SelectMatchingCard(tp,c77000135.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then  
			Duel.BreakEffect() 
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT) 
		end 
	end 
end 











