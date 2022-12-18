--D.H.P.K.-塔莉亚
function c12899015.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,c12899015.matfilter,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),1,63,true,true)
	--limtcon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetCondition(c12899015.limitcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e2)
	--attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c12899015.atkval)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12899015,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,12899015)
	e4:SetCondition(c12899015.tgcon)
	e4:SetTarget(c12899015.tgtg)
	e4:SetOperation(c12899015.tgop)
	c:RegisterEffect(e4)
end
function c12899015.matfilter(c)
	return c:IsFusionSetCard(0xda71) and c:IsFusionType(TYPE_EFFECT)
end
function c12899015.ndcfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x5a71)
end
function c12899015.limitcon(e)
	return Duel.IsExistingMatchingCard(c12899015.ndcfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c12899015.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(ct*1000)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c12899015.atkval(e,c)
	local ct=c:GetMaterialCount()
	return ct*1000
end
function c12899015.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetActiveType()==TYPE_TRAP
		and Duel.IsExistingMatchingCard(c12899015.filter,tp,LOCATION_DECK,0,1,nil,eg:GetFirst())
end
function c12899015.filter(c,mc)
	return c:IsCode(mc:GetCode()) and c:IsAbleToGrave()
end
function c12899015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c12899015.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12899015.filter,tp,LOCATION_DECK,0,1,1,nil,tc)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		tc:CancelToGrave()
		Duel.ChangePosition(tc,POS_FACEDOWN)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end


