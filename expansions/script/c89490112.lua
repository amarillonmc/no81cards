--帝王爆击弹
local s,id,o=GetID()
function s.initial_effect(c)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e5:SetCondition(s.condition)
	e5:SetCost(s.cost)
	e5:SetTarget(s.rtg)
	e5:SetOperation(s.rop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(id,ACTIVITY_ATTACK,s.counterfilter)
end
function s.counterfilter(c)
	return not c:IsCode(89490097)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(89490097)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_ATTACK)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,89490097))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,ep,tp)
	return tp==ep
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,3,nil)
		local n=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		if n>0 then
			Duel.Damage(1-tp,n*1500,REASON_EFFECT)
		end
	end
end
