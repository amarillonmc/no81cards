--钢铁律命“太阳”伦萨
function c60001147.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c60001147.mfilter,c60001147.xyzcheck,3,3) 
	--ds and sp 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY) 
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,60001147)
	e0:SetCondition(c60001147.dscon) 
	e0:SetOperation(c60001147.dsop) 
	c:RegisterEffect(e0)	
	--to deck 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c60001147.tdcon1) 
	e1:SetTarget(c60001147.tdtg1) 
	e1:SetOperation(c60001147.tdop) 
	c:RegisterEffect(e1) 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c60001147.tdcon2) 
	e2:SetTarget(c60001147.tdtg2) 
	e2:SetOperation(c60001147.tdop) 
	c:RegisterEffect(e2) 
	--atk indes 
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60001147.aicon1) 
	e3:SetTarget(c60001147.aitg) 
	e3:SetOperation(c60001147.aiop) 
	c:RegisterEffect(e3)  
	local e4=e3:Clone() 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e4:SetCondition(c60001147.aicon2) 
	c:RegisterEffect(e4)
end
function c60001147.mfilter(c) 
	return c:GetBaseAttack()~=c:GetAttack() 
end
function c60001147.xyzcheck(g)
	return true 
end 
function c60001147.dscon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetLP(tp)<=4000 and Duel.GetTurnPlayer()==tp and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
end 
function c60001147.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.SelectYesNo(tp,aux.Stringid(60001147,0)) then 
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	c:RegisterFlagEffect(60001147,RESET_EVENT+0xff0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(60001147,2))
	Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) 
	end 
end 
function c60001147.tdcon1(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(60001147)==0 and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)   
end  
function c60001147.tdfil(c) 
	return c:IsAbleToDeck()   
end 
function c60001147.tdtg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c60001147.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end 
	local g=Duel.GetMatchingGroup(c60001147.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
end  
function c60001147.tdcon2(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(60001147)~=0 and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) 
end  
function c60001147.tdtg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	local g=Duel.GetMatchingGroup(c60001147.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)  
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0) 
end 
function c60001147.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c60001147.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)  
	if g:GetCount()>0 then 
	local x=Duel.SendtoDeck(g,nil,2,REASON_EFFECT) 
	local xg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,c) 
	if xg:GetCount()<=0 then return end  
	local tc=xg:GetFirst() 
	while tc do 
	--
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(x*100) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EFFECT_UPDATE_DEFENSE) 
	tc:RegisterEffect(e2)
	tc=xg:GetNext() 
	end  
	end 
end 
function c60001147.ckfil(c,e,tp) 
	return c~=e:GetHandler()  
end 
function c60001147.aicon1(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(60001147)==0 and eg:IsExists(c60001147.ckfil,1,nil,e,tp)  
end  
function c60001147.aicon2(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():GetFlagEffect(60001147)~=0 and eg:IsExists(c60001147.ckfil,1,nil,e,tp)  
end  
function c60001147.aitg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end  
	Duel.SetChainLimit(aux.FALSE)
end 
function c60001147.aiop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=eg:Filter(c60001147.ckfil,nil,e,tp) 
	local tc=g:GetFirst() 
	while tc do 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(1000) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1)   
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c60001147.efilter)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetOwnerPlayer(tp)
	tc:RegisterEffect(e2)
	tc=g:GetNext() 
	end 
	if c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(60001147,1)) then 
	c:RemoveOverlayCard(tp,1,1,REASON_EFFECT) 
	Duel.Draw(tp,1,REASON_EFFECT) 
	end 
end 
function c60001147.efilter(e,re)
	return e:GetHandler()~=re:GetOwner()
end






