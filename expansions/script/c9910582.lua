--混合咖啡·多彩调制
function c9910582.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,c9910582.lcheck)
	c:EnableReviveLimit()
	--active limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c9910582.accon1)
	e1:SetValue(c9910582.aclimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(1,1)
	e2:SetCondition(c9910582.accon2)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2)
	e3:SetCondition(c9910582.discon)
	e3:SetCost(c9910582.discost)
	e3:SetTarget(c9910582.distg)
	e3:SetOperation(c9910582.disop)
	c:RegisterEffect(e3)
end
function c9910582.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc951)
end
function c9910582.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsLocation(LOCATION_MZONE)
		and not rc:IsSummonableCard()
end
function c9910582.accon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9910582)==0
end
function c9910582.accon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9910582)~=0
end
function c9910582.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainDisablable(ev)
end
function c9910582.costfilter(c)
	return c:IsType(TYPE_FLIP) and c:IsDiscardable()
end
function c9910582.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910582.costfilter,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c9910582.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	if tc:IsSetCard(0xc951) and c:GetFlagEffect(9910582)==0 then
		c:RegisterFlagEffect(9910582,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910582,0))
	end
end
function c9910582.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c9910582.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
