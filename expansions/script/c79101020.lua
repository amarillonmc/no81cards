--迷途罪械 被否决者 R.S.H.L
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--can only control 1
	c:SetUniqueOnField(1,0,id)
	
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_RELEASE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.negcon)
	e4:SetTarget(s.negtg)
	e4:SetOperation(s.negop)
	c:RegisterEffect(e4)
	
	--destroy all
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(s.descost)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
end

function s.limitcon(e)
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,id),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function s.limit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(id)
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and Duel.IsChainNegatable(ev)
end

function s.negfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsReleasable()
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local exres=Duel.GetFlagEffect(tp,id)*2
	if chk==0 then return Duel.IsExistingMatchingCard(s.negfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,exres+1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,exres+1,tp,LOCATION_HAND+LOCATION_MZONE)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local exres=Duel.GetFlagEffect(tp,id)*2
	if not Duel.IsExistingMatchingCard(s.negfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,exres+1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.negfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,exres+1,nil)
	if #g>0 and Duel.Release(g,REASON_EFFECT)>0 then
		Duel.NegateActivation(ev)
		Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
	end
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
