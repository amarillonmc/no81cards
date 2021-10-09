--罗马·尼禄维纳斯形态
function c9950756.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xcba8),5,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9950756.hspcon)
	e2:SetOperation(c9950756.hspop)
	c:RegisterEffect(e2)
--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c9950756.efilter)
	c:RegisterEffect(e2)
 --atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c9950756.adval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
--atkdown
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(9950756,1))
	e8:SetCategory(CATEGORY_TOGRAVE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c9950756.atkcon)
	e8:SetTarget(c9950756.atktg)
	e8:SetOperation(c9950756.atkop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e9)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950756.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950756.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950756,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950756,1))
end
function c9950756.hspfilter(c,tp,sc)
	return not c:IsSummonableCard() and c:IsFusionSetCard(0xcba8) and c:IsLevel(10) and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c9950756.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c9950756.hspfilter,1,nil,c:GetControler(),c)
end
function c9950756.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,c9950756.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function c9950756.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9950756.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,LOCATION_HAND)*1000
end
function c9950756.atkfilter(c,e,tp)
	return c:IsControler(tp) and c:IsFaceup() and (not e or c:IsRelateToEffect(e))
end
function c9950756.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9950756.atkfilter,1,nil,nil,1-tp)
end
function c9950756.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c9950756.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c9950756.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(-2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if preatk~=0 and (tc:IsAttack(0) or tc:IsDefense(0)) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.SendtoGrave(dg,REASON_EFFECT)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950756,2))
end