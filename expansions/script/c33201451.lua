--天狱囚龙 法夫纳
local s,id,o=GetID()
Duel.LoadScript("c33201450.lua")
function s.initial_effect(c)
	c:SetSPSummonOnce(33201451)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,VHisc_HDST.nck,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,LOCATION_MZONE,Duel.Release,REASON_COST+REASON_MATERIAL)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function s.disfilter(c)
	return VHisc_HDST.nck(c)
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.Hint(24,0,aux.Stringid(id,0))
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end

function s.efilter(e,re)
	return VHisc_HDST.nck(re:GetHandler()) and re:GetHandlerPlayer()~=e:GetHandlerPlayer()
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetBaseAttack()
	if bc:GetBaseAttack()<bc:GetBaseDefense() then dam=bc:GetBaseDefense() end
	if dam>0 then
		Duel.Hint(24,0,aux.Stringid(id,1))
		Duel.Hint(HINT_CARD,tp,33201451)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end