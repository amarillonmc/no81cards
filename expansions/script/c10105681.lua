function c10105681.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa008),2,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
    	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105681,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(c10105681.atcon)
	e3:SetOperation(c10105681.atop)
	c:RegisterEffect(e3)
    	--attack down
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetDescription(aux.Stringid(10105681,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c10105681.cost)
	e4:SetOperation(c10105681.operation)
	c:RegisterEffect(e4)
    end
function c10105681.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc then return false end
	local seq=bc:GetPreviousSequence()
	e:SetLabel(seq)
	return Duel.GetAttacker()==c and aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and seq<5 and c:IsChainAttackable(0)
end
function c10105681.atop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChainAttack()
	local seq=e:GetLabel()
	local val=aux.SequenceToGlobal(1-tp,LOCATION_MZONE,seq)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(val)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c10105681.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(100)
end
function c10105681.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100,true)
		and Duel.IsExistingMatchingCard(c10105681.filter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c10105681.filter,tp,0,LOCATION_MZONE,e:GetHandler())
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,2000)/100)
	local t={}
	for i=1,m do
		t[i]=i*100
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac,true)
	e:SetLabel(ac)
	e:GetHandler():RegisterFlagEffect(10105681,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c10105681.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10105681.filter,tp,0,LOCATION_MZONE,aux.ExceptThisCard(e))
	local tc=g:GetFirst()
	local val=e:GetLabel()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
        local e2=e1:Clone()
    	e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end