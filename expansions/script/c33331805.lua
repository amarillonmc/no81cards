--虚景创形 性别原理
function c33331805.initial_effect(c)
	--token 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,33331805) 
	e1:SetCost(c33331805.tkcost) 
	e1:SetTarget(c33331805.tktg) 
	e1:SetOperation(c33331805.tkop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33331805.spcon) 
	e2:SetTarget(c33331805.sptg) 
	e2:SetOperation(c33331805.spop) 
	c:RegisterEffect(e2) 
	--xx 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_ATKCHANGE) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,13331805) 
	e3:SetCondition(c33331805.xxcon1)
	e3:SetTarget(c33331805.xxtg) 
	e3:SetOperation(c33331805.xxop) 
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c33331805.xxcon2) 
	c:RegisterEffect(e4)	
end
function c33331805.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end 
function c33331805.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c33331805.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,33331808)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c33331805.sckfil(c,tp) 
	return c:IsType(TYPE_TOKEN) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp  
end 
function c33331805.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c33331805.sckfil,1,nil,tp) 
end 
function c33331805.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c33331805.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)   
	end 
end 
function c33331805.xckfil(c) 
	return c:IsFaceup() and c:IsCode(33331810)  
end 
function c33331805.xxcon1(e,tp,eg,ep,ev,re,r,rp) 
	return not Duel.IsExistingMatchingCard(c33331805.xckfil,tp,LOCATION_FZONE,0,1,nil)  
end 
function c33331805.xxcon2(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c33331805.xckfil,tp,LOCATION_FZONE,0,1,nil)  
end  
function c33331805.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsSummonLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end 
end 
function c33331805.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	if g:GetCount()>=2 then 
		local sg=g:Select(tp,2,2,nil)
		local tc1=sg:GetFirst() 
		local tc2=sg:GetNext() 
		local atk1=tc1:GetAttack() 
		local att1=tc1:GetAttribute() 
		local rc1=tc1:GetRace() 
		local atk2=tc2:GetAttack() 
		local att2=tc2:GetAttribute() 
		local rc2=tc2:GetRace() 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(atk2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc1:RegisterEffect(e1) 
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE) 
		e2:SetValue(att2) 
		tc1:RegisterEffect(e2) 
		local e3=e1:Clone() 
		e3:SetCode(EFFECT_CHANGE_RACE) 
		e3:SetValue(rc2) 
		tc1:RegisterEffect(e3)  
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(atk1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc2:RegisterEffect(e1) 
		local e2=e1:Clone() 
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE) 
		e2:SetValue(att1) 
		tc2:RegisterEffect(e2) 
		local e3=e1:Clone() 
		e3:SetCode(EFFECT_CHANGE_RACE) 
		e3:SetValue(rc1) 
		tc2:RegisterEffect(e3) 
	end 
end 











