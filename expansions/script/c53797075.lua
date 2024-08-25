local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local f1=Duel.SSet
		Duel.SSet=function(p,tg,tp,bool)
			local g=Group.__add(tg,tg)
			if bool~=false and g:IsExists(Card.IsHasEffect,1,nil,id) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e1:SetValue(s.efilter)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,0)
			end
			local res=f1(p,tg,tp,bool)
			Duel.Hint(HINT_CARD,0,id)
			return res
		end
	end
end
function s.efilter(e,te,c)
	local tp=e:GetHandlerPlayer()
	local tc=te:GetHandler()
	if tc:IsSetCard(0x89,0x4c) and tc:GetType()&TYPE_TRAP~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetLabel(c:GetOriginalCodeRule())
		e1:SetCondition(s.discon)
		e1:SetOperation(s.disop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	return false
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
