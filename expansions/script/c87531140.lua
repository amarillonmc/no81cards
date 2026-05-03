--死冥盛花
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--除外封锁
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(s.limitcon)
	e1:SetTarget(s.limittg)
	e1:SetOperation(s.limitop)
	c:RegisterEffect(e1)
	--除外代替
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(s.reptg)
	e2:SetValue(aux.TRUE)
	c:RegisterEffect(e2)		
end
function s.limitcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function s.limittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end 
function s.limitop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD_P)
	e1:SetCondition(s.tgcon)
	e1:SetOperation(s.tgop)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,2)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,0,2)
	else	
		e1:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,0,1)
	end 
	Duel.RegisterEffect(e1,tp)
	
	
	if re and re:GetHandler():IsSetCard(0x364b) and Duel.GetFlagEffect(tp,id+o)==0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,1)
		e2:SetCode(EFFECT_CANNOT_REMOVE)
		e2:SetTarget(s.rmlimit)
		if Duel.GetTurnPlayer()==tp then
			e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,2)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,0,2)
		else	
			e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
			Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN,0,1)
		end 
		Duel.RegisterEffect(e2,tp)	 
	end
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x364b) and c:GetFlagEffect(87531140)==0
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=eg:Filter(s.cfilter,nil)
	for tc in aux.Next(g) do tc:RegisterFlagEffect(87531140,RESET_EVENT+RESETS_STANDARD,0,1) end
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function s.rmlimit(e,c)
	local tp=e:GetHandlerPlayer()
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x364b) and c:IsControler(tp)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,2)
	local loc=c:GetDestination()
	local rt={c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)}
	for i,v in ipairs(rt) do
		if v:GetValue()==LOCATION_REMOVED then loc=LOCATION_REMOVED end
	end
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT) and loc==LOCATION_REMOVED
		and c:GetReasonPlayer()==1-tp and g:FilterCount(Card.IsAbleToGrave,nil)>=2 end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,2)) then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
