--卡西米尔·重装干员-瑕光
function c79029344.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c79029344.mfilter,c79029344.xyzcheck,2,2)	
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c79029344.cost)
	e1:SetTarget(c79029344.tg)
	e1:SetOperation(c79029344.op)
	c:RegisterEffect(e1)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c79029344.atkcon)
	e3:SetTarget(c79029344.atktg)
	e3:SetValue(c79029344.atkval)
	c:RegisterEffect(e3)
	--double damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c79029344.damcon)
	e4:SetOperation(c79029344.damop)
	c:RegisterEffect(e4)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c79029344.efilter)
	e1:SetCondition(c79029344.imcon)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029344.imcon)
	e3:SetValue(c79029344.val)
	c:RegisterEffect(e3)
end
function c79029344.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_LINK) and c:IsLink(4)
end
function c79029344.xyzcheck(g)
	return g:GetClassCount(Card.GetLink)==1
end
function c79029344.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029344.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
end
function c79029344.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xa900)
end
function c79029344.op(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("光！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029344,2))
	local c=e:GetHandler()
	local xg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=xg:GetFirst()
	while tc do
	tc:RegisterFlagEffect(79029344,RESET_EVENT+RESETS_STANDARD,0,1,0,0)
	--  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetDescription(aux.Stringid(79029344,0))
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c79029344.efilter)
	tc:RegisterEffect(e1)
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	tc:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	tc:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	tc:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	tc:RegisterEffect(e8)
	local e9=e5:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	tc:RegisterEffect(e9)
	local e9=e5:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	tc:RegisterEffect(e9)
	--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	tc=xg:GetNext()
	end
	if Duel.IsExistingMatchingCard(c79029344.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(79029344,1)) then
	Debug.Message("不用担心！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029344,4))
	local tc=Duel.SelectMatchingCard(tp,c79029344.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	local x=tc:GetAttack()+tc:GetDefense()
	Duel.Recover(tp,x,REASON_EFFECT)
	end
end
function c79029344.efilter(e,te)
	return te:GetOwner():GetCode()~=79029344
end
function c79029344.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL 
end
function c79029344.atktg(e,c)
	return c:IsSetCard(0xa907) and c:GetBattleTarget():GetFlagEffect(79029344)~=0
end
function c79029344.atkval(e,c)
	return c:GetAttack()*2
end
function c79029344.damtg(e,c)
	return c:IsSetCard(0xa907) and c:GetBattleTarget():GetFlagEffect(79029344)~=0
end
function c79029344.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029344.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():IsExtraLinkState()
end
function c79029344.val(e,c)
	return c:GetBaseAttack()*2
end
function c79029344.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local b=Duel.GetAttackTarget()
	local g=Group.FromCards(a,b)
	return ep~=tp and g:Filter(Card.IsControler,nil,tp):GetFirst():GetBattleTarget():GetFlagEffect(79029344)~=0 and g:Filter(Card.IsControler,nil,tp):GetFirst():IsSetCard(0xa907)
end
function c79029344.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
	Debug.Message("忏悔吧！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029344,3))
end












