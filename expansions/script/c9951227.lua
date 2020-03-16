--贝利亚融合兽·玛伽兽化贝利亚
function c9951227.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,9951233,c9951227.ffilter,3,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToDeckOrExtraAsCost,LOCATION_GRAVE,0,aux.tdcfop(c))
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
   --act limit
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(9951227,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c9951227.limcon)
	e5:SetTarget(c9951227.limtg)
	e5:SetOperation(c9951227.limop)
	c:RegisterEffect(e5)
 --immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c9951227.efilter)
	c:RegisterEffect(e3)
   --atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c9951227.atkup)
	c:RegisterEffect(e3)
 --variable effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951227,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c9951227.cost)
	e3:SetTarget(c9951227.target)
	e3:SetOperation(c9951227.operation)
	c:RegisterEffect(e3)
  --halve LP
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9951227,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9951227.hvcon)
	e3:SetOperation(c9951227.hvop)
	c:RegisterEffect(e3)
 --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951227.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951227.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951227,0))
end
function c9951227.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x6bd2) and (not sg or not sg:Filter(Card.IsFusionSetCard,nil,0x6bd2):IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function c9951227.limcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function c9951227.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c9951227.chainlm)
end
function c9951227.chainlm(e,rp,tp)
	return tp==rp
end
function c9951227.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c9951227.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9951227.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9951227.atkup(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,0x6bd2)*1000
end
function c9951227.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9951227.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9951227.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6bd2)
end
function c9951227.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local gc=Duel.GetMatchingGroup(c9951227.filter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,c)
		local b2=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,c)
		local b3=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,c) 
			and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD,1,c)
		local b4=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,c) 
			and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,c)
		local b5=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,c) 
			and not Duel.IsExistingMatchingCard(aux.NOT(Card.IsAbleToDeck),tp,0,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,1,c)
		return (gc==1 and b1) or (gc==2 and b2) or (gc==3 and b3) or (gc==4 and b4)or (gc>4 and b5)
	end
	if gc<3 then
		 e:SetCategory(CATEGORY_DESTROY)
		local loc=LOCATION_MZONE
		if gc==2 then loc=LOCATION_ONFIELD end
		local g=Duel.GetMatchingGroup(nil,tp,0,loc,c)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	else if gc>=3 or gc<=4 then
		e:SetCategory(CATEGORY_REMOVE)
		local loc=LOCATION_ONFIELD 
		if gc==4 then loc=LOCATION_ONFIELD+LOCATION_GRAVE end
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,loc,c)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	else if gc>4 then
		e:SetCategory(CATEGORY_TODECK)
		local loc=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED 
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,loc,c)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g*400)
	end
	end
	end
end
function c9951227.operation(e,tp,eg,ep,ev,re,r,rp)
	local gc=Duel.GetMatchingGroup(c9951227.filter,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
	if gc<3 then
		local loc=LOCATION_MZONE
		if gc==2 then loc=LOCATION_ONFIELD end
		local g=Duel.GetMatchingGroup(nil,tp,0,loc,aux.ExceptThisCard(e))
		Duel.Destroy(g,REASON_EFFECT)
	else if gc>=3 or gc<=4 then
		local loc=LOCATION_ONFIELD
		if gc==4 then loc=LOCATION_ONFIELD+LOCATION_GRAVE end
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,loc,aux.ExceptThisCard(e))
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	else if gc>4 then
	   local loc=LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,loc,aux.ExceptThisCard(e))
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.Damage(1-tp,g*400,REASON_EFFECT)
	end
	end
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951227,0))
end
function c9951227.hvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9951227.hvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,math.ceil(Duel.GetLP(1-tp)/2))
end