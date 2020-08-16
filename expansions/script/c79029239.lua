--企鹅物流·术士干员-莫斯提马·荒时之锁
function c79029239.initial_effect(c)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--time
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79029239)
	e1:SetCost(c79029239.ticost)
	e1:SetTarget(c79029239.titg)
	e1:SetOperation(c79029239.tiop)
	c:RegisterEffect(e1)  
end
function c79029239.ticost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end
function c79029239.titg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()~=tp end
end
function c79029239.tiop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED)
	e0:SetReset(RESET_PHASE+PHASE_END)
	e0:SetCode(EVENT_CHAINING)
	e0:SetOperation(c79029239.tiop2)
	c:RegisterEffect(e0) 
	Debug.Message("来了。")   
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029239,0))
end
function c79029239.tiop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:GetHandler():GetControler()==tp then return end
	if e:GetHandler():GetFlagEffect(79029239)==9 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	tc=g:GetNext()
	end
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN1 then
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_BATTLE then
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end  
	Debug.Message("差不多该结束了吧？")   
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029239,1))
	e:Reset()
	else
	e:GetHandler():RegisterFlagEffect(79029239,RESET_PHASE+PHASE_END,0,1)
	end 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1+EFFECT_COUNT_CODE_DUEL)
	e2:SetTarget(c79029239.sptg)
	e2:SetOperation(c79029239.spop)
	c:RegisterEffect(e2) 
end
function c79029239.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,0)
end
function c79029239.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(79029239,3)) then
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,e:GetHandler())
	if Duel.GetTurnPlayer()==1-tp then
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN1 then
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_BATTLE then
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end  
	else
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN1 then
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_BATTLE then
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end  
	end 
	else  
	end
	Debug.Message("天气不错。")   
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029239,2))
end








