--H-Anifriends Yatagarasu
function c33741100.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--code
	aux.EnableChangeCode(c,33700104,LOCATION_GRAVE)
	--must attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e2:SetValue(c33741100.atklimit)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c33741100.atkcon)
	e4:SetCost(c33741100.atkcost)
	e4:SetOperation(c33741100.atkop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetCondition(c33741100.condition)
	e5:SetOperation(c33741100.operation)
	c:RegisterEffect(e5)
end
function c33741100.atklimit(e,c)
	return c==e:GetHandler()
end
function c33741100.cfilter(c)
	return c:IsLocation(LOCATION_EXTRA) or not c:IsPublic()
end
function c33741100.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33741100.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	return #g>0 and Duel.GetCurrentPhase()==PHASE_DAMAGE and not Duel.IsDamageCalculated()
end
function c33741100.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(33741100)==0 end
	e:GetHandler():RegisterFlagEffect(33741100,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c33741100.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c33741100.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,#g)
	Duel.ConfirmCards(1-tp,sg)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(#sg*500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c33741100.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c33741100.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTurnPlayer()==tp and 2 or 3
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(0,LOCATION_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END,ct)
	Duel.RegisterEffect(e1,tp)
	--
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REVERSE_DECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetReset(RESET_PHASE+PHASE_END,ct)
	Duel.RegisterEffect(e2,tp)
	--destroy
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(c33741100.reptg)
	e3:SetValue(c33741100.repval)
	e3:SetLabel(33741100)
	e3:SetReset(RESET_PHASE+PHASE_END,ct)
	Duel.RegisterEffect(e3,tp)
end
function c33741100.repfilter(c)
	return c:GetDestination()==LOCATION_HAND and c:IsLocation(LOCATION_DECK)
end
function c33741100.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c33741100.repfilter,nil)
	local tc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if chk==0 then return rp~=tp and #g>0 and (not re or re:GetLabel()==33741100) end-- and tc:IsAbleToHand() and bit.band(r,REASON_DRAW)==0
	if true then
		Duel.RegisterFlagEffect(tp,33741100,RESET_CHAIN,0,1)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,tc)
	return true
	else return false end
end
function c33741100.repval(e,c)
	local res=Duel.GetFlagEffect(e:GetHandlerPlayer(),33741100)~=0
	Duel.ResetFlagEffect(e:GetHandlerPlayer(),33741100)
	return res
end
