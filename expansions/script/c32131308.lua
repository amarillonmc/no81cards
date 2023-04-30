--逐火十三英桀 千劫
function c32131308.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_DESTROYED) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)  
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,32131308) 
	e1:SetCondition(c32131308.hspcon) 
	e1:SetTarget(c32131308.hsptg) 
	e1:SetOperation(c32131308.hspop) 
	c:RegisterEffect(e1)  
	--cal 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,23131308) 
	e2:SetTarget(c32131308.caltg) 
	e2:SetOperation(c32131308.calop) 
	c:RegisterEffect(e2)  
	c32131308.sp_effect=e2 
end
c32131308.SetCard_HR_flame13=true 
function c32131308.cfilter(c) 
	return c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:IsPreviousLocation(LOCATION_ONFIELD)  
end 
function c32131308.hspcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32131308.cfilter,1,nil)
end
function c32131308.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32131308.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end 
function c32131308.caltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end 
function c32131308.calop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then 
	--damage val
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e5:SetValue(1) 
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e5)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e8:SetValue(1) 
	e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e8)
	Duel.CalculateDamage(c,tc) 
	end 
end 










