--青空魔术师 仓科明日香
function c9910225.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,99,c9910225.lcheck)
	c:EnableReviveLimit()
	--atkup & multi
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9910225.atkcon)
	e1:SetOperation(c9910225.atkop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE+CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910225.discon)
	e2:SetTarget(c9910225.distg)
	e2:SetOperation(c9910225.disop)
	c:RegisterEffect(e2)
end
function c9910225.lcheck(g)
	return g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_BOTTOM)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_BOTTOM_LEFT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_BOTTOM_RIGHT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP)
end
function c9910225.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910225.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local atk=0
	local tc=g:GetFirst()
	while tc do
		local lk=tc:GetLink()
		atk=atk+lk
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk*250)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(c:GetMaterialCount()-1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e2)
end
function c9910225.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9910225.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9910225.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsControlerCanBeChanged()
end
function c9910225.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	local rc=re:GetHandler()
	local b1=rc:IsRelateToEffect(re) and not rc:IsLocation(LOCATION_REMOVED) and rc:IsAbleToRemove()
	local b2=Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_CONTROL)>0
		and Duel.IsExistingMatchingCard(c9910225.ctfilter,tp,0,LOCATION_MZONE,1,nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(9910225,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910225,1)
		opval[off-1]=2
		off=off+1
	end
	ops[off]=aux.Stringid(9910225,2)
	opval[off-1]=3
	off=off+1
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		Duel.BreakEffect()
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
	elseif opval[op]==2 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local sg=Duel.SelectMatchingCard(tp,c9910225.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(sg)
		Duel.GetControl(sg,tp)
	end
end
