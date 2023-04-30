--真神 天空龙
local m=91020010
local cm=c91020010
function c91020010.initial_effect(c)
--normal summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(cm.ttcon)
	e1:SetOperation(cm.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(cm.setcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
--atk/def   
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.con1)
	e6:SetValue(cm.adval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
--immune
 local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(cm.immval)
	c:RegisterEffect(e4)
--atk/def down
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)  
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m*2)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetTarget(cm.tg1)
	e5:SetOperation(cm.op1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetCategory(CATEGORY_ATKCHANGE)  
	e7:SetRange(LOCATION_MZONE) 
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetCountLimit(1,m*3)
	e7:SetCondition(cm.con7)
	e7:SetTarget(cm.tg1)
	e7:SetOperation(cm.op1)
	c:RegisterEffect(e7)
end
--normal summon
function cm.ttcon(e,c,tp)
	if c==nil then return true end
	return c:IsSummonableCard() and Duel.IsPlayerCanSummon(tp) and Duel.CheckTribute(c,3)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function cm.setcon(e,c,minc)
	if not c then return true end
	return false
end
--atk/def
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) 
end
function cm.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND+LOCATION_ONFIELD,0)*1000
end
--immune
function cm.immval(e,te)
return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and (te:GetOwner():GetAttack()<=e:GetHandler():GetAttack() or ((te:GetOwner():GetDefense()<=e:GetHandler():GetDefense() and not te:GetOwner():IsType(TYPE_LINK)) or (te:GetOwner():GetAttack()<=e:GetHandler():GetAttack() and te:GetOwner():IsType(TYPE_LINK))))
end
--Destroy

function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	 Duel.SetChainLimit(aux.FALSE)
end

function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local dg=Group.CreateGroup()
	while tc do
		local preatk=tc:GetAttack()
		local predef=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-2000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(-2000)
		tc:RegisterEffect(e2)
		if (preatk~=0 and tc:IsAttack(0)) or (tc:IsDefense(0) and predef~=0) then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
--e7
function cm.con7(e,tp,eg,ep,ev,re,r,rp)
return Duel.IsPlayerAffectedByEffect(tp,91000002)
end
