--虚景创形 节律原理
function c33331806.initial_effect(c)
	--token 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,33331806) 
	e1:SetCost(c33331806.tkcost) 
	e1:SetTarget(c33331806.tktg) 
	e1:SetOperation(c33331806.tkop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33331806.spcon) 
	e2:SetTarget(c33331806.sptg) 
	e2:SetOperation(c33331806.spop) 
	c:RegisterEffect(e2) 
	--xx 
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,13331806) 
	e3:SetCondition(c33331806.xxcon1)
	e3:SetTarget(c33331806.xxtg) 
	e3:SetOperation(c33331806.xxop) 
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c33331806.xxcon2) 
	c:RegisterEffect(e4)	
end
function c33331806.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end 
function c33331806.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c33331806.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,33331808)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c33331806.sckfil(c,tp) 
	return c:IsType(TYPE_TOKEN) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp  
end 
function c33331806.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c33331806.sckfil,1,nil,tp) 
end 
function c33331806.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c33331806.spop(e,tp,eg,ep,ev,re,r,rp) 
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
function c33331806.xckfil(c) 
	return c:IsFaceup() and c:IsCode(33331810)  
end 
function c33331806.xxcon1(e,tp,eg,ep,ev,re,r,rp) 
	return not Duel.IsExistingMatchingCard(c33331806.xckfil,tp,LOCATION_FZONE,0,1,nil)  
end 
function c33331806.xxcon2(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c33331806.xckfil,tp,LOCATION_FZONE,0,1,nil)  
end 
function c33331806.atkfil(c) 
	return c:IsFaceup()  
end 
function c33331806.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsSummonLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c33331806.atkfil,tp,0,LOCATION_MZONE,1,nil) end 
end 
function c33331806.xxop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33331806.atkfil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetValue(-800)  
		e1:SetRange(LOCATION_MZONE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		tc:RegisterEffect(e1) 
		tc=g:GetNext() 
		end 
	end  
end 









