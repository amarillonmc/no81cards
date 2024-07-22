--卫星闪灵·极光
function c11579813.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,function(c,xyzc) return c:IsRank(2) or c:IsXyzLevel(xyzc,2) end,nil,2,99)
	--negate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING) 
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11579813.discon)
	e1:SetCost(c11579813.cost)
	e1:SetTarget(c11579813.distg)
	e1:SetOperation(c11579813.disop)
	c:RegisterEffect(e1)
	--disable spsummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c11579813.dscon)
	e1:SetCost(c11579813.cost)
	e1:SetTarget(c11579813.dstg)
	e1:SetOperation(c11579813.dsop)
	c:RegisterEffect(e1)   
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON) 
	c:RegisterEffect(e2)  
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	e1:SetCondition(function(e) 
	return e:GetHandler():GetOverlayGroup():IsExists(function(c) return not c:IsSummonableCard() end,1,nil) end)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.indoval)
	e2:SetCondition(function(e) 
	return e:GetHandler():GetOverlayGroup():IsExists(function(c) return not c:IsSummonableCard() end,1,nil) end)
	c:RegisterEffect(e2)
end
function c11579813.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(function(c) return c:IsFaceup() and c:IsRank(2) end,tp,LOCATION_MZONE,0,nil) 
	local og=Group.CreateGroup() 
	local tc=g:GetFirst() 
	while tc do 
	og:Merge(tc:GetOverlayGroup())
	tc=g:GetNext() 
	end 
	local tog=og:Filter(Card.IsAbleToGraveAsCost,nil)
	if chk==0 then return tog:GetCount()>=2 end
	local sg=tog:Select(tp,2,2,nil) 
	Duel.SendtoGrave(sg,REASON_COST) 
end
function c11579813.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function c11579813.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c11579813.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c11579813.dscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c11579813.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c11579813.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end


