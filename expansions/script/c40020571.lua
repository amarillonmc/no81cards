--爆苍岚机兽 奇琴泽法
local s, id = GetID()
s.named_with_RoaringAzure=1
function s.RoaringAzure(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_RoaringAzure
end

function s.initial_effect(c)

	aux.AddSynchroProcedure(c,s.sfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.descon_trigger)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.lockcon)
	e2:SetValue(s.lockval)
	c:RegisterEffect(e2)
end

function s.sfilter(c)
	return s.RoaringAzure(c)
end

function s.descon_trigger(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_ATTACK) end
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_ATTACK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsPosition,tp,0,LOCATION_MZONE,nil,POS_ATTACK)
	if Duel.Destroy(g,REASON_EFFECT)>0 then

		local pg=Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_PZONE,0,nil)
		if pg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=pg:Select(tp,1,1,nil)
			if Duel.Destroy(sg,REASON_EFFECT)>0 then

				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
				e1:SetTargetRange(1,0)
				e1:SetOperation(s.dmgop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
				
			end
		end
	end
end

function s.pfilter(c)
	return c:IsCode(40020569)
end

function s.dmgop(e,tp,eg,ep,ev,re,r,rp)

	local a=Duel.GetAttacker()
	if a and a:IsControler(tp) and s.RoaringAzure(a) and ep~=tp then
		Duel.ChangeBattleDamage(ep,ev*2)
	end
end

function s.huracan_filter(c)
	return c:IsFaceup() and c:IsCode(40020569)
end

function s.lockcon(e)
	local tp=e:GetHandlerPlayer()

	local b1=Duel.IsExistingMatchingCard(s.huracan_filter,tp,LOCATION_PZONE,0,1,nil)
	
	local b2=Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,0,1,nil,POS_DEFENSE)
	
	return b1 and b2
end

function s.lockval(e,re,tp)

	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
