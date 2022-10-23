--战圣女 瓦尔基里
function c87490010.initial_effect(c)  
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,c87490010.lcheck)
	c:EnableReviveLimit()
	--recover 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetCountLimit(1,87490010) 
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end) 
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk) 
	local mg=e:GetHandler():GetMaterial()
	if chk==0 then return mg:GetSum(Card.GetAttack)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,1,tp,mg:GetSum(Card.GetAttack))  
	end) 
	e1:SetOperation(c87490010.lkop)
	c:RegisterEffect(e1) 
end 
function c87490010.lcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_SPELLCASTER)
end 
function c87490010.lkop(e,tp,eg,ep,ev,re,r,rp) 
	local mg=e:GetHandler():GetMaterial()
	local x=Duel.Recover(tp,mg:GetSum(Card.GetAttack),REASON_EFFECT)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and x>0 then 
	c:SetHint(CHINT_NUMBER,x) 
	if x>=3000 then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(x) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_RECOVER) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCondition(c87490010.rccon) 
	e1:SetOperation(c87490010.rcop)  
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1) 
	end  
	if x>=4000 then 
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DESTROY_REPLACE) 
	e1:SetCountLimit(1,17490010) 
	e1:SetTarget(c87490010.reptg)
	c:RegisterEffect(e1)	
	end   
	if x>=5000 then 
	--
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1) 
	e1:SetTarget(c87490010.sptg)   
	e1:SetOperation(c87490010.spop) 
	c:RegisterEffect(e1) 
	end 
	if x>=6000 then 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c87490010.discon)
	e1:SetOperation(c87490010.disop) 
	c:RegisterEffect(e1)   
	end 
	end 
end 
function c87490010.rccon(e,tp,eg,ep,ev,re,r,rp) 
	return ep==tp 
end  
function c87490010.rcop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	Duel.Hint(HINT_CARD,0,87490010) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE)  
	e1:SetValue(ev) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1)
end 
function c87490010.spfil(c,e,tp) 
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)   
end 
function c87490010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	local zone=e:GetHandler():GetLinkedZone() 
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)  
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c87490010.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end 
	local g=Duel.SelectTarget(tp,c87490010.spfil,tp,LOCATION_GRAVE,0,1,ct,nil,e,tp) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0) 
end 
function c87490010.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local zone=e:GetHandler():GetLinkedZone() 
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)  
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	if sg:GetCount()>=2 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end 
	if sg:GetCount()>0 and sg:GetCount()<=ct then  
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)  
	local tc=sg:GetFirst() 
	while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2) 
	tc=sg:GetNext() 
	end 
	end 
end  
function c87490010.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and Duel.GetLP(tp)>2000 end
	if Duel.SelectEffectYesNo(tp,c,96) then
	Duel.SetLP(tp,Duel.GetLP(tp)-2000) 
	if Duel.GetTurnPlayer()==1-tp and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(87490010,1)) then 
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil) 
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)  
	end 
		return true
	else return false end
end
function c87490010.discon(e,tp,eg,ep,ev,re,r,rp) 
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler()~=e:GetHandler() 
end
function c87490010.disop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_CARD,0,87490010)
	Duel.NegateEffect(ev)
end









