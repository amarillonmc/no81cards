--虚景创形 循环原理
function c33331801.initial_effect(c)
	--token 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,33331801) 
	e1:SetCost(c33331801.tkcost) 
	e1:SetTarget(c33331801.tktg) 
	e1:SetOperation(c33331801.tkop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_LEAVE_FIELD) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33331801.spcon) 
	e2:SetTarget(c33331801.sptg) 
	e2:SetOperation(c33331801.spop) 
	c:RegisterEffect(e2) 
	--xx 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_ANNOUNCE) 
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,13331801) 
	e3:SetCondition(c33331801.ancon1)
	e3:SetTarget(c33331801.antg) 
	e3:SetOperation(c33331801.anop) 
	c:RegisterEffect(e3) 
	local e4=e3:Clone() 
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN)  
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e4:SetCondition(c33331801.ancon2) 
	c:RegisterEffect(e4)
end
function c33331801.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end  
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end 
function c33331801.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function c33331801.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,33331808,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_WYRM,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,33331808)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP) 
	end
end
function c33331801.sckfil(c,tp) 
	return c:IsType(TYPE_TOKEN) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp  
end 
function c33331801.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c33331801.sckfil,1,nil,tp) 
end 
function c33331801.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c33331801.spop(e,tp,eg,ep,ev,re,r,rp) 
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
function c33331801.ackfil(c) 
	return c:IsFaceup() and c:IsCode(33331810)  
end 
function c33331801.ancon1(e,tp,eg,ep,ev,re,r,rp) 
	return not Duel.IsExistingMatchingCard(c33331801.ackfil,tp,LOCATION_FZONE,0,1,nil)  
end 
function c33331801.ancon2(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c33331801.ackfil,tp,LOCATION_FZONE,0,1,nil)  
end 
function c33331801.antg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsSummonLocation(LOCATION_GRAVE) end 
	local flag=Duel.GetFlagEffectLabel(tp,33331801) 
	local anatt=0 
	if flag==nil then 
	anatt=ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH+ATTRIBUTE_WIND  
	end 
	if flag==1 then 
	anatt=anatt+ATTRIBUTE_WATER 
	end 
	if flag==2 then 
	anatt=anatt+ATTRIBUTE_FIRE 
	end 
	if flag==3 then 
	anatt=anatt+ATTRIBUTE_EARTH 
	end 
	if flag==4 then 
	anatt=anatt+ATTRIBUTE_WIND   
	end 
	local att=Duel.AnnounceAttribute(tp,1,anatt) 
	e:SetLabel(att) 
end 
function c33331801.anop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local att=e:GetLabel() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD) 
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE) 
	e1:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE) 
	e1:SetValue(att)  
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
	if att==ATTRIBUTE_WATER then 
	Duel.RegisterFlagEffect(tp,33331801,RESET_PHASE+PHASE_END,0,2,1)
	end 
	if att==ATTRIBUTE_FIRE then 
	Duel.RegisterFlagEffect(tp,33331801,RESET_PHASE+PHASE_END,0,2,2)
	end 
	if att==ATTRIBUTE_EARTH then 
	Duel.RegisterFlagEffect(tp,33331801,RESET_PHASE+PHASE_END,0,2,3)
	end 
	if att==ATTRIBUTE_WIND then 
	Duel.RegisterFlagEffect(tp,33331801,RESET_PHASE+PHASE_END,0,2,4)
	end 
end 













