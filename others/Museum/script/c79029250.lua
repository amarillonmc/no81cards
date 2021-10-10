--摄影车衍生物
function c79029250.initial_effect(c)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029250,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c79029250.discon)
	e2:SetTarget(c79029250.distg)
	e2:SetOperation(c79029250.disop)
	c:RegisterEffect(e2)   
end
function c79029250.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and e:GetHandler():GetColumnGroup():IsContains(re:GetHandler())
end
function c79029250.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79029250.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Debug.Message("“曝光——”")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029250,0))
end
