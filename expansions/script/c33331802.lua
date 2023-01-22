--虚景创形 秩序原理
function c33331802.initial_effect(c)
	--token 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,33331802) 
	e1:SetCost(c33331802.tkcost) 
	e1:SetTarget(c33331802.tktg) 
	e1:SetOperation(c33331802.tkop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33331802.spcon) 
	e2:SetTarget(c33331802.sptg) 
	e2:SetOperation(c33331802.spop) 
	c:RegisterEffect(e2) 
	--xx 
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,13331802) 
	e3:SetCondition(c33331802.xxcon1)
	e3:SetTarget(c33331802.xxtg) 
	e3:SetOperation(c33331802.xxop) 
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c33331802.xxcon2) 
	c:RegisterEffect(e4)
end
function c33331802.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end 
function c33331802.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c33331802.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,33331808)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c33331802.sckfil(c,tp) 
	return c:IsType(TYPE_TOKEN) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp  
end 
function c33331802.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c33331802.sckfil,1,nil,tp) 
end 
function c33331802.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c33331802.spop(e,tp,eg,ep,ev,re,r,rp) 
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
function c33331802.xckfil(c) 
	return c:IsFaceup() and c:IsCode(33331810)  
end 
function c33331802.xxcon1(e,tp,eg,ep,ev,re,r,rp) 
	return not Duel.IsExistingMatchingCard(c33331802.xckfil,tp,LOCATION_FZONE,0,1,nil)  
end 
function c33331802.xxcon2(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c33331802.xckfil,tp,LOCATION_FZONE,0,1,nil)  
end 
function c33331802.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsSummonLocation(LOCATION_GRAVE) end 
end 
function c33331802.xxop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetTargetRange(0xff,0xff) 
	e1:SetTarget(function(e,c) 
	return not c:IsOnField() end)
	e1:SetValue(1) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetValue(function(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION end)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp) 
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp) 
end 




