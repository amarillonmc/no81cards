--佚落之狼 沃登
function c22348458.initial_effect(c)
	aux.EnableDualAttribute(c)
	--code
	aux.EnableChangeCode(c,69247929,LOCATION_MZONE,aux.IsDualState)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348458,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348458.discon)
	e1:SetTarget(c22348458.distg)
	e1:SetOperation(c22348458.disop)
	c:RegisterEffect(e1)
	
end
function c22348458.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and e:GetHandler():IsDualState()
end
function c22348458.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
	if re:GetActivateLocation()==LOCATION_GRAVE then
		e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_GRAVE_ACTION)
	end
end
function c22348458.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
