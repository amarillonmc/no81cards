--厄运信天翁
function c11561019.initial_effect(c)
	--xx
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_TO_GRAVE)  
	e1:SetOperation(c11561019.xxop) 
	c:RegisterEffect(e1) 
end 
function c11561019.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK) 
	if g:GetCount()>=2 then  
		Duel.Hint(HINT_CARD,0,11561019) 
		local sg=g:RandomSelect(tp,2) 
		local tc=sg:GetFirst() 
		local a=0  
		local tkc=Duel.CreateToken(tp,11561020)
		while tc do  
		tc:SetCardData(CARDDATA_CODE,tkc:GetOriginalCode()) 
		tc:SetCardData(CARDDATA_TYPE,tkc:GetOriginalType()) 
		tc:SetCardData(CARDDATA_ATTRIBUTE,tkc:GetOriginalAttribute()) 
		tc:SetCardData(CARDDATA_RACE,tkc:GetOriginalRace()) 
		tc:SetCardData(CARDDATA_ATTACK,tkc:GetTextAttack()) 
		tc:SetCardData(CARDDATA_DEFENSE,tkc:GetTextDefense()) 
		tc:SetCardData(CARDDATA_LEVEL,tkc:GetOriginalLevel())	  
		tc:ReplaceEffect(11561020,0,1) 
		a=a+1 
		tc=sg:GetNext() 
		end	
	end  
end 





