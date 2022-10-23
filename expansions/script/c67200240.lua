--黄金树谷的门番 芙拉洛乌斯
function c67200240.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--connot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c67200240.sprcon)
	e2:SetOperation(c67200240.sprop)
	c:RegisterEffect(e2)
	--disable spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200240,1))
	e3:SetCategory(CATEGORY_DISABLE_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCondition(c67200240.condition)
	e3:SetTarget(c67200240.target)
	e3:SetOperation(c67200240.operation)
	c:RegisterEffect(e3)  
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON)
	c:RegisterEffect(e4) 
end
--
function c67200240.sprfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToDeckAsCost()
end
function c67200240.sprcon(e,c)
--
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if ct>3 then return false end
	if ct>0 and not Duel.IsExistingMatchingCard(c67200240.spfilter1,tp,LOCATION_SZONE+LOCATION_FZONE,0,ct,nil) then return false end
	return Duel.IsExistingMatchingCard(c67200240.spfilter1,tp,LOCATION_ONFIELD,0,3,nil)
end
function c67200240.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if ct<0 then ct=0 end
	local g=Group.CreateGroup()
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,c67200240.spfilter1,tp,LOCATION_MZONE,0,ct,ct,nil)
		g:Merge(sg)
	end
	if ct<3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,c67200240.spfilter1,tp,LOCATION_ONFIELD,0,3-ct,3-ct,g:GetFirst())
		g:Merge(sg)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
--
function c67200240.condition(e,tp,eg,ep,ev,re,r,rp)
	if #eg~=1 then return false end
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c67200240.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) and Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
end
function c67200240.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateSummon(eg)~=0 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,false) 
	end
end
