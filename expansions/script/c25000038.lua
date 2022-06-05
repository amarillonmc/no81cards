--空我龙 升华究极
function c25000038.initial_effect(c)
	 c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c25000038.spcon)
	e2:SetOperation(c25000038.spop)
	c:RegisterEffect(e2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c25000038.actlimit)
	c:RegisterEffect(e2) 
	--remove 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,25000038)
	e3:SetCost(c25000038.rmcost)
	e3:SetTarget(c25000038.rmtg)
	e3:SetOperation(c25000038.rmop)
	c:RegisterEffect(e3)  
end
function c25000038.rfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:GetSummonLocation()==LOCATION_EXTRA and (c:IsControler(tp) or c:IsFaceup())
end
function c25000038.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c25000038.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(c25000038.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-3 and rg:GetCount()>2 and (ft>0 or rg:IsExists(c25000038.mzfilter,ct,nil,tp))
end
function c25000038.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(c25000038.rfilter,nil,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,3,3,nil)
	elseif ft>-2 then
		local ct=-ft+1
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c25000038.mzfilter,ct,ct,nil,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,3-ct,3-ct,g)
		g:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c25000038.mzfilter,3,3,nil,tp)
	end
	Duel.Release(g,REASON_COST)
end
function c25000038.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c25000038.rlfil(c)
	return 
end
function c25000038.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000038.rlfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c25000038.rlfil,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil) 
	Duel.Release(g,REASON_COST)
end
function c25000038.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil,POS_FACEDOWN) end 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil,POS_FACEDOWN)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),1-tp,LOCATION_MZONE)
end
function c25000038.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil,POS_FACEDOWN) 
	if g:GetCount()>0 then 
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end











