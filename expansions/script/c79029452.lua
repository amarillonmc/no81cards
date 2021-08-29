--彩虹小队·重装干员-闪击
function c79029452.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)	
	--end turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,79029452)
	e2:SetCondition(c79029452.ovcon)
	e2:SetOperation(c79029452.ovop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(4)
	e3:SetCondition(c79029452.discon)
	e3:SetOperation(c79029452.disop)
	c:RegisterEffect(e3)
end
c79029452.named_with_RainbowOperator=true 
function c79029452.ovcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and c:IsPreviousPosition(LOCATION_ONFIELD)
end
function c79029452.ovop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我是不是又要再救你们一次了？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029452,5))
	Duel.SkipPhase(1-tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029452.disfil(c)
	return aux.disfilter1(c)
end
function c79029452.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029452.disfil,tp,0,LOCATION_ONFIELD,1,nil) and (re:GetHandler():IsSetCard(0xb90d) or re:GetHandler():IsSetCard(0xc90e))
end
function c79029452.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then 
	tc=Duel.SelectMatchingCard(tp,c79029452.disfil,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2) 
	if c:GetFlagEffect(79029452)==0 then 
	c:RegisterFlagEffect(79029452,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(79029452,0))
	else
	flag=c:GetFlagEffectLabel(79029452)+1
	c:SetFlagEffectLabel(79029452,flag) 
	end
	flag=c:GetFlagEffectLabel(79029452)
	e:GetHandler():SetHint(CHINT_NUMBER,flag)
	if flag==1 then 
	Debug.Message("笑一个！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029452,1))
	elseif flag==2 then 
	Debug.Message("蹦！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029452,2))
	elseif flag==3 then 
	Debug.Message("惊喜！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029452,3))
	elseif flag==4 then 
	Debug.Message("喜欢吗！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029452,4))
	end
	end
end






