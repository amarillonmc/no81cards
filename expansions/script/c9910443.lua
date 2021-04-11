--踏沙铁车 艾布拉姆斯
function c9910443.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2,c9910443.ovfilter,aux.Stringid(9910443,0),2,c9910443.xyzop)
	c:EnableReviveLimit()
	--attack limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c9910443.atkcon)
	e2:SetValue(2500)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910443.descon)
	e3:SetCost(c9910443.descost)
	e3:SetTarget(c9910443.destg)
	e3:SetOperation(c9910443.desop)
	c:RegisterEffect(e3)
end
function c9910443.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ)
end
function c9910443.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9910443)==0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.RegisterFlagEffect(tp,9910443,RESET_PHASE+PHASE_END,0,1)
end
function c9910443.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9910443.descon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c9910443.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToRemoveAsCost()
end
function c9910443.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Group.CreateGroup()
	local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local g2=e:GetHandler():GetOverlayGroup()
	if g1:GetCount()>0 then g:Merge(g1) end
	if g2:GetCount()>0 then g:Merge(g2) end
	if chk==0 then return g:IsExists(c9910443.cfilter,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:FilterSelect(tp,c9910443.cfilter,2,2,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c9910443.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c9910443.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0 then
		Duel.NegateActivation(ev)
	end
end
