--圆环之理  鹿目圆香
function c1000613.initial_effect(c)
	c:SetUniqueOnField(1,1,1000607)
	c:SetUniqueOnField(1,1,1000614)
	c:SetUniqueOnField(1,1,1000613)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,1000611,aux.FilterBoolFunction(Card.IsSetCard,0xc204),4,true,true)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c1000613.con)
	e1:SetValue(c1000613.efilter)
	c:RegisterEffect(e1)
	--atk/def down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c1000613.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--atk/def up
	local e4=e2:Clone()
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc204))
	e4:SetValue(c1000613.val2)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xc204))
	e5:SetValue(c1000613.val2)
	c:RegisterEffect(e5)
	--level/rank down
	local e6=e2:Clone()
	e6:SetCode(EFFECT_UPDATE_LEVEL)
	e6:SetValue(c1000613.val3)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_UPDATE_RANK)
	e7:SetValue(c1000613.val3)
	c:RegisterEffect(e7)
	--spsummon condition
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(c1000613.splimit)
	c:RegisterEffect(e9)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1000613,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c1000613.condition)
	e1:SetTarget(c1000613.target)
	e1:SetOperation(c1000613.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c1000613.splimit(e,se,sp,st)
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then 
		return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	end
	return true
end
function c1000613.con(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c1000613.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c1000613.filter9(c,e,tp)
	return c:IsSetCard(0xc204) and c:IsControler(tp) and not c:IsType(TYPE_PENDULUM) 
end
function c1000613.val(e,c)
   local g=Duel.GetMatchingGroup(c1000613.filter9,LOCATION_REMOVED,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct*-300
end
function c1000613.val2(e,c)
   local g=Duel.GetMatchingGroup(c1000613.filter9,LOCATION_GRAVE,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return ct*300
end
function c1000613.val3(e,c)
   local g=Duel.GetMatchingGroup(c1000613.filter9,LOCATION_REMOVED,0,nil,e,tp)
	local ct=g:GetClassCount(Card.GetCode)
	return -ct
end
function c1000613.cfilter(c)
	return c:IsFaceup() and (c:GetAttack()==0 or c:GetDefense()==0)
end
function c1000613.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1000613.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function c1000613.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c1000613.cfilter,nil)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c1000613.filter(c,e)
	return c:IsFaceup() and (c:GetAttack()==0 or c:GetDefense()==0) and c:IsRelateToEffect(e)
end
function c1000613.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c1000613.filter,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end