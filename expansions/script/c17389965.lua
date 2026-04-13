local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and re:GetHandler():IsSetCard(0x5f51) and e:GetHandler():GetFlagEffect(FLAG_ID_CHAINING)>0 then
		local g=Group.CreateGroup()
		local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
		local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
		if tc1 then g:AddCard(tc1) end
		if tc2 then g:AddCard(tc2) end	
		if #g>0 then
			Duel.Hint(HINT_CARD,0,id)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end