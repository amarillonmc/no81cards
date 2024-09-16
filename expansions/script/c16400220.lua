--Emiya-无限之剑制
function c16400220.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16400220,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOHAND+CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(9,46647145)
	e1:SetTarget(c16400220.tg)
	e1:SetOperation(c16400220.op)
	c:RegisterEffect(e1)
end
function c16400220.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,16400220,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetFlagEffect(tp,16400220)==1 then
		Debug.Message("I am the bone of my sword")
	elseif Duel.GetFlagEffect(tp,16400220)==2 then
		Debug.Message("Steel is my body, and fire is my blood")
	elseif Duel.GetFlagEffect(tp,16400220)==3 then
		Debug.Message("I have created over a thousand blades")
	elseif Duel.GetFlagEffect(tp,16400220)==4 then
		Debug.Message("Unknown to Death")
	elseif Duel.GetFlagEffect(tp,16400220)==5 then
		Debug.Message("Nor known to Life")
	elseif Duel.GetFlagEffect(tp,16400220)==6 then
		Debug.Message("Have withstood pain to create many weapons")
	elseif Duel.GetFlagEffect(tp,16400220)==7 then
		Debug.Message("Yet, those hands will never hold anything")
	elseif Duel.GetFlagEffect(tp,16400220)==8 then
		Debug.Message("So as I pray")
	elseif Duel.GetFlagEffect(tp,16400220)==9 then
		Debug.Message("Unlimited Blade Works！")
	end
end
function c16400220.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,16400220)==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_FZONE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xce5))
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	elseif Duel.GetFlagEffect(tp,16400220)==2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_ATTACK_ALL)
		e2:SetRange(LOCATION_FZONE)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xce5))
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	elseif Duel.GetFlagEffect(tp,16400220)==3 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetRange(LOCATION_FZONE)
		e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xce5))
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetCondition(c16400220.con3)
		e3:SetValue(c16400220.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	elseif Duel.GetFlagEffect(tp,16400220)==4 then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetRange(LOCATION_FZONE)
		e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e4:SetCondition(c16400220.con4)
		e4:SetOperation(c16400220.op4)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
	elseif Duel.GetFlagEffect(tp,16400220)==5 then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e5:SetRange(LOCATION_FZONE)
		e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e5:SetTargetRange(LOCATION_MZONE,0)
		e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xce5))
		e5:SetValue(c16400220.tgval5)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e5)
	elseif Duel.GetFlagEffect(tp,16400220)==6 then
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e6:SetRange(LOCATION_FZONE)
		e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e6:SetTargetRange(LOCATION_MZONE,0)
		e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xce5))
		e6:SetValue(c16400220.tgval6)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e6)
	elseif Duel.GetFlagEffect(tp,16400220)==7 then
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_BE_BATTLE_TARGET)
		e7:SetRange(LOCATION_FZONE)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetOperation(c16400220.disop)
		c:RegisterEffect(e7)
		local e72=Effect.CreateEffect(c)
		e72:SetType(EFFECT_TYPE_FIELD)
		e72:SetCode(EFFECT_DISABLE)
		e72:SetRange(LOCATION_FZONE)
		e72:SetTargetRange(0,LOCATION_MZONE)
		e72:SetTarget(c16400220.distg)
		c:RegisterEffect(e72)
		local e73=e72:Clone()
		e73:SetCode(EFFECT_DISABLE_EFFECT)
		e73:SetValue(RESET_TURN_SET)
		c:RegisterEffect(e73)
	elseif Duel.GetFlagEffect(tp,16400220)==8 then
		local e8=Effect.CreateEffect(c)
		e8:SetType(EFFECT_TYPE_FIELD)
		e8:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e8:SetRange(LOCATION_FZONE)
		e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e8:SetTargetRange(LOCATION_ONFIELD,0)
		e8:SetTarget(c16400220.filter8)
		e8:SetValue(1)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e8)
	elseif Duel.GetFlagEffect(tp,16400220)==9 then
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e9:SetCode(EVENT_PHASE+PHASE_END)
		e9:SetCountLimit(1)
		e9:SetOperation(c16400220.desop)
		e9:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e9,tp)
	end
end
function c16400220.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c16400220.con3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c16400220.con4(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if not a:IsControler(tp) then
		a=Duel.GetAttackTarget()
	end
	return a and a:IsSetCard(0xce5)
end
function c16400220.thfilter(c)
	return c:IsSetCard(0xce5) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c16400220.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16400220.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c16400220.tgval5(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c16400220.tgval5(e,re,rp)
	return re:IsActiveType(TYPE_SPELL)
end
function c16400220.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.AdjustInstantly(e:GetHandler())
end
function c16400220.disfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xce5) and c:IsControler(tp)
end
function c16400220.distg(e,c)
	local fid=e:GetHandler():GetFieldID()
	for _,flag in ipairs({c:GetFlagEffectLabel(16400220)}) do
		if flag==fid then return true end
	end
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and bc and c16400220.disfilter(bc,e:GetHandlerPlayer()) then
		c:RegisterFlagEffect(16400220,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1,fid)
		return true
	end
	return false
end
function c16400220.filter8(c)
	return c:IsFaceup() and c:IsSetCard(0xce5) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c16400220.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,16400220)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end