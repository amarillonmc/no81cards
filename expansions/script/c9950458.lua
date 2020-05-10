--真祖·奥西里斯
function c9950458.initial_effect(c)
	aux.AddCodeList(c,10000020)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,10000020,aux.FilterBoolFunction(Card.IsRace,RACE_DIVINE),1,true,true)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9950458.efilter)
	c:RegisterEffect(e2)
 --atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c9950458.adval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
   --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950458,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9950458.destg)
	e1:SetOperation(c9950458.desop)
	c:RegisterEffect(e1)
--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(9950458,1))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c9950458.atkcon)
	e8:SetTarget(c9950458.atktg)
	e8:SetOperation(c9950458.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
   --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950458.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950458.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950458,0))
end 
function c9950458.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9950458.adval(e,c)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)*1000
end
function c9950458.desfilter(c)
	return c:IsFaceup() and c:IsAttackBelow(4000) or c:IsDefenseBelow(4000)
end
function c9950458.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c9950458.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c9950458.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9950458.desfilter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
function c9950458.atkfilter(c,e,tp)
	return c:IsControler(tp) and c:IsFaceup() and (not e or c:IsRelateToEffect(e))
end
function c9950458.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9950458.atkfilter,1,nil,nil,1-tp)
end
function c9950458.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c9950458.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9950458.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-4000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-4000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and (tc:IsAttack(0) or tc:IsDefense(0)) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.SendtoGrave(dg,REASON_EFFECT)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950458,1))
end