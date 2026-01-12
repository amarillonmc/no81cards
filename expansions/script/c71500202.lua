--命运预见『战车』
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)	
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetType(EFFECT_TYPE_QUICK_F)
		e2:SetCode(EVENT_CHAINING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTarget(s.battletg)
		e2:SetOperation(s.battleop)
		tc:RegisterEffect(e2)
		--Granted Effect 2: Immune
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(id,1))
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(s.efilter)
		tc:RegisterEffect(e3)
	end
end
function s.eftg(e,c)
	return c:IsType(TYPE_MONSTER)
end
function s.battletg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(s.chainlm)
end
function s.chainlm(e,rp,tp)
	return false
end
function s.ffilter(c)
	return c:IsFaceup()
end
function s.damval(e,re,val,r,rp,rc)
	return val*2
end
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.ffilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if #g>0 then
		local tc=g:RandomSelect(tp,1):GetFirst()
		if tc and c:IsRelateToChain() and c:IsFaceup() and tc:IsFaceup() then
			--Double Damage
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,1)
			e1:SetValue(DOUBLE_DAMAGE)
			e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
			Duel.RegisterEffect(e1,tp)
			Duel.CalculateDamage(c,tc)
		end
	end
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()==e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end