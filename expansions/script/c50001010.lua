--星空闪耀 星联
function c50001010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e1:SetCountLimit(1,50001010+EFFECT_COUNT_CODE_OATH)   
	e1:SetTarget(c50001010.actg) 
	e1:SetOperation(c50001010.acop) 
	c:RegisterEffect(e1)  
end
c50001010.SetCard_WK_StarS=true   
function c50001010.acfil(c,e,tp) 
	if c:GetOwner()==1-tp then 
		return c:IsFaceup() 
	else 
		return c:IsLevelAbove(2) and c:IsFaceup() and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and (c:IsSetCard(0xb8e) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0x99a))) end,tp,LOCATION_DECK,0,1,nil) 
	end 
end 
function c50001010.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c50001010.acfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end 
	local tc=Duel.SelectTarget(tp,c50001010.acfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp):GetFirst() 
	if tc:GetOwner()==tp then 
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else 
		e:SetCategory(0)
	end   
end 
function c50001010.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then 
		local lv=1 
		if tc:GetOwner()==tp then lv=-1 end 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(lv)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e1) 
		if tc:GetOwner()==1-tp then 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
			tc:RegisterEffect(e1) 
			local e1=Effect.CreateEffect(c) 
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE) 
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(1)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
			tc:RegisterEffect(e1) 
		elseif tc:GetOwner()==tp and Duel.IsExistingMatchingCard(function(c) return c:IsAbleToHand() and (c:IsSetCard(0xb8e) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0x99a))) end,tp,LOCATION_DECK,0,1,nil) then  
			local sg=Duel.SelectMatchingCard(tp,function(c) return c:IsAbleToHand() and (c:IsSetCard(0xb8e) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0x99a))) end,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(sg,tp,REASON_EFFECT) 
			Duel.ConfirmCards(1-tp,sg) 
		end 
	end 
end 








