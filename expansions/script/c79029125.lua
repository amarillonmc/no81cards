--罗德岛·近卫干员-煌
function c79029125.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c79029125.sprcon)
	e1:SetOperation(c79029125.sprop)
	c:RegisterEffect(e1)
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(-10)
	c:RegisterEffect(e1) 
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_SYNCHRO+TYPE_EFFECT)
	c:RegisterEffect(e1) 
	--dark SynchroSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	e4:SetCondition(c79029125.dircon)
	c:RegisterEffect(e4)
	--actlimit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetValue(1)
	e5:SetCondition(c79029125.actcon)
	c:RegisterEffect(e5) 
end
function c79029125.dircon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
end
function c79029125.actcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0 and Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c79029125.cfilter2(c,e,tp,tc)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) 
end
function c79029125.cfilter1(c,e,tp)
	local g=Duel.GetMatchingGroup(c79029125.cfilter2,tp,LOCATION_MZONE,0,nil)
	local lv=c:GetLevel()
	return c:IsFaceup() and g:CheckWithSumEqual(Card.GetLevel,10+lv,3,3) and not c:IsType(TYPE_TUNER)
end
function c79029125.sprcon(e,c,tp)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79029125.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c79029125.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c79029125.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c79029125.cfilter2,tp,LOCATION_MZONE,0,nil)
	local lv=mc:GetLevel()
	local g2=g:SelectWithSumEqual(tp,Card.GetLevel,10+lv,3,3)
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_COST)~=0 then
	e:GetHandler():SetMaterial(g1)
	local a=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	Duel.SendtoGrave(a,REASON_EFFECT)
	Debug.Message("听见这链锯的轰鸣了吗？")
end
end
