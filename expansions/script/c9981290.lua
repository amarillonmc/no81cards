--骑士时刻-真王·逢魔形态
function c9981290.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xbca),5)
	c:EnableReviveLimit()
--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
  --immume
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c9981290.efilter)
	c:RegisterEffect(e4)
	--indes battle
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(c9981290.indes)
	c:RegisterEffect(e5)
 --atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981290,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9981290)
	e1:SetCondition(c9981290.atkcon)
	e1:SetCost(c9981290.atkcost)
	e1:SetOperation(c9981290.atkop)
	c:RegisterEffect(e1)
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981290,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCountLimit(1,23790300)
	e2:SetCondition(aux.bdcon)
	e2:SetTarget(c9981290.destg)
	e2:SetOperation(c9981290.desop)
	c:RegisterEffect(e2)
 --negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981290,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9981290.discon)
	e2:SetCost(c9981290.discost)
	e2:SetTarget(c9981290.distg)
	e2:SetOperation(c9981290.disop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981290.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981290.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981290,0))
end
function c9981290.chainlm(e,ep,tp)
	return tp==ep
end
function c9981290.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9981290.indes(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_EARTH+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_WIND)
end
function c9981290.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return Duel.IsChainNegatable(ev)
end
function c9981290.cfilter(c,g)
	return c:IsFaceup() and c:IsSetCard(0xbca)
		and g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c9981290.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9981290.cfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c9981290.cfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c9981290.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
 Duel.SetChainLimit(c9981290.chainlm)
end
function c9981290.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981290,0))
end
function c9981290.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and (ph~=PHASE_DAMAGE or not Duel.IsDamageCalculated())) or ph==PHASE_MAIN1+PHASE_MAIN2
end
function c9981290.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroup(aux.true,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,aux.true,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.Release(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetPreviousAttackOnField())
 Duel.SetChainLimit(c9981290.chainlm)
end
function c9981290.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		e1:SetValue(e:GetLabel())
		c:RegisterEffect(e1)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981290,0))
end
function c9981290.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE+LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_MZONE+LOCATION_HAND)
   Duel.SetChainLimit(c9981290.chainlm)
end
function c9981290.desop(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(Card.IsType,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil,TYPE_MONSTER)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.SendtoGrave(sg,REASON_RULE)~=0 and c:IsRelateToEffect(e) and c:IsChainAttackable() then
			Duel.ChainAttack()
		end
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981290,0))
end