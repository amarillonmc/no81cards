function c82228527.initial_effect(c)  
	--link summon  
	aux.AddLinkProcedure(c,nil,2,2,c82228527.lcheck)  
	c:EnableReviveLimit()
	--destroy  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(82228527,0))  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,82228527)  
	e1:SetCondition(c82228527.descon)
	e1:SetTarget(c82228527.destg)  
	e1:SetOperation(c82228527.desop)  
	c:RegisterEffect(e1) 
	--summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82228527,1))  
	e2:SetCategory(CATEGORY_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCountLimit(1,82218527)
	e2:SetCost(c82228527.sumcost)  
	e2:SetTarget(c82228527.sumtg)  
	e2:SetOperation(c82228527.sumop)  
	c:RegisterEffect(e2)  
	if not c82228527.global_check then  
		c82228527.global_check=true  
		local ge1=Effect.CreateEffect(c)  
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)  
		ge1:SetLabel(82228527) 
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		ge1:SetOperation(aux.sumreg)  
		Duel.RegisterEffect(ge1,0)   
	end  
end   
 
function c82228527.lcheck(g,lc)  
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_FIRE)  
end  
function c82228527.descon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetFlagEffect(82228527)>0  
end  
function c82228527.tgfilter(c)  
	return c:GetMutualLinkedGroupCount()>0 
end  
function c82228527.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82228527.tgfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,nil,0,0)  
end  
function c82228527.desop(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetMatchingGroup(c82228527.tgfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	local ct=g:GetCount() 
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)  
	if g:GetCount()>0 and g2:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
		local sg=g2:Select(tp,1,ct,nil)  
		Duel.HintSelection(sg)  
		Duel.Destroy(sg,REASON_EFFECT)  
	end  
end  
function c82228527.sumfilter(c)  
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSummonable(true,nil)  
end  
function c82228527.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLPCost(tp,500) end  
	Duel.PayLPCost(tp,500)  
end  
function c82228527.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82228527.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end  
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)  
end  
function c82228527.sumop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)  
	local g=Duel.SelectMatchingCard(tp,c82228527.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.Summon(tp,tc,true,nil)  
	end   
end  