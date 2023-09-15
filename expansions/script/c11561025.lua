--绝冠·爱丽丝
function c11561025.initial_effect(c) 
	--att
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)  
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(ATTRIBUTE_DARK)  
	c:RegisterEffect(e0)   
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,11561025)
	e1:SetTarget(c11561025.sptg) 
	e1:SetOperation(c11561025.spop) 
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_BECOME_TARGET) 
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,11561025) 
	e1:SetCondition(c11561025.spcon)
	e1:SetTarget(c11561025.sptg) 
	e1:SetOperation(c11561025.spop) 
	c:RegisterEffect(e1) 
	--des rm 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_DRAW) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) 
	e2:SetCountLimit(1,21561025) 
	e2:SetTarget(c11561025.drmtg) 
	e2:SetOperation(c11561025.drmop) 
	c:RegisterEffect(e2)  
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_F) 
	e2:SetCode(EVENT_BECOME_TARGET) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,21561025) 
	e2:SetCondition(c11561025.drmcon)
	e2:SetTarget(c11561025.drmtg) 
	e2:SetOperation(c11561025.drmop) 
	c:RegisterEffect(e2) 
end
function c11561025.ckfil(c,tp) 
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end 
function c11561025.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(c11561025.ckfil,1,nil,tp)  
end 
function c11561025.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c11561025.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(800) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1) 
		if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)   
		end   
	end 
end 
function c11561025.drmcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsContains(e:GetHandler())
end 
function c11561025.drmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end 
function c11561025.drmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
		if tc:GetAttack()<c:GetAttack() and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
			 Duel.Draw(tp,1,REASON_EFFECT)
		else  
			if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) then 
				local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil) 
				if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
					Duel.BreakEffect() 
					Duel.Destroy(c,REASON_EFFECT) 
				end 
			end  
		end 
	end  
	--local e0=Effect.CreateEffect(e:GetHandler())
	--e0:SetType(EFFECT_TYPE_FIELD)
	--e0:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	--e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e0:SetTargetRange(0,1)
	--e0:SetValue(1)
	--e0:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e0,tp)
end 
	




