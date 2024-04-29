function c10105694.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x1a1),2,true)
	c:EnableReviveLimit()
    	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10105694,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10105694)
	e1:SetCondition(c10105694.negcon)
	e1:SetTarget(c10105694.negtg)
	e1:SetOperation(c10105694.negop)
	c:RegisterEffect(e1)
    	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10105694,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,101056940)
	e2:SetCondition(c10105694.descon)
	e2:SetTarget(c10105694.destg)
	e2:SetOperation(c10105694.desop)
	c:RegisterEffect(e2)
    end
function c10105694.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10105694.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1a1) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c10105694.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105694.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE+LOCATION_HAND)
end
function c10105694.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c10105694.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,e:GetHandler())
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c10105694.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousLocation()&LOCATION_MZONE==LOCATION_MZONE and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function c10105694.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1900)
end
function c10105694.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.Damage(1-tp,1900,REASON_EFFECT)
	end
end