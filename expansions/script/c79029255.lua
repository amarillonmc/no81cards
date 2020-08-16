--阿米娅·忒斯特收藏-见习联结者
function c79029255.initial_effect(c)
	--fusion 
	aux.AddFusionProcFunRep2(c,c79029255.ffilter,2,2,true)
	c:EnableReviveLimit()  
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE+LOCATION_EXTRA)
	e1:SetValue(79029037)
	c:RegisterEffect(e1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1901))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	c:RegisterEffect(e2)   
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c79029255.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e4)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029255.negcon)
	e1:SetCost(c79029255.negcost)
	e1:SetTarget(c79029255.negtg)
	e1:SetOperation(c79029255.negop)
	c:RegisterEffect(e1)
end
function c79029255.ffilter(c)
	return c:IsSetCard(0xa900) and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c79029255.val(e,c)
	return c:GetMaterial():GetCount()*800
end
function c79029255.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c79029255.cfilter(c,rtype,e)
	return c:IsType(rtype) and c:IsAbleToRemoveAsCost() and e:GetHandler():GetMaterial():IsContains(c) 
end
function c79029255.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rtype=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029255.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,rtype,e) end
	local g=Duel.SelectMatchingCard(tp,c79029255.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,rtype,e)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c79029255.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c79029255.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		g=e:GetHandler():GetMaterial()
		g:Merge(eg)
		e:GetHandler():SetMaterial(g)
	Debug.Message("我知道你在想什么。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029255,0))
	end
end









