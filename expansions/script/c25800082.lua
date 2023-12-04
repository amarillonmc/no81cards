--皇家方舟改
function c25800082.initial_effect(c)
		c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,25800033,aux.FilterBoolFunction(Card.IsFusionSetCard,0x6211),1,true,true)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c25800082.limval)
	c:RegisterEffect(e2)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25800082,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1,25800082)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c25800082.rmcon)
	e1:SetTarget(c25800082.rmtg)
	e1:SetOperation(c25800082.rmop)
	c:RegisterEffect(e1)
end
function c25800082.limval(e,re,rp)
	local rc=re:GetHandler()
	return  re:IsActiveType(TYPE_MONSTER)
		and rc:IsAttackBelow(1000)
end
-----
function c25800082.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa211) and c:IsLevelBelow(4) and c:IsControler(tp)
end
function c25800082.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c25800082.cfilter,1,nil,tp)
end
function c25800082.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c25800082.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
