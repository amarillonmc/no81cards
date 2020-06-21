--水泵衍生物
function c79029211.initial_effect(c)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c79029211.tdcon)
	e1:SetOperation(c79029211.tdop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c79029211.sdcon)
	c:RegisterEffect(e2)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)	
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
end
function c79029211.tdfil(c,zone)
	return zone:IsContains(c)
end
function c79029211.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(79029210)
end
function c79029211.tdop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetColumnGroup()
	if not Duel.IsExistingMatchingCard(c79029211.tdfil,tp,0,LOCATION_ONFIELD,1,nil,zone) then return end
	if Duel.SelectEffectYesNo(tp,e:GetHandler()) then
	local g=Duel.GetMatchingGroup(c79029211.tdfil,tp,0,LOCATION_ONFIELD,nil,zone)   
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Debug.Message("发射！")
end
end
function c79029211.sdfilter(c)
	return c:IsCode(79029210)
end
function c79029211.sdcon(e)
	return not Duel.IsExistingMatchingCard(c79029211.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end








