local s,id=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE) 
	e1:SetCountLimit(1)
	e1:SetTarget(s.protg)
	e1:SetOperation(s.protop)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end

function s.desfilter(c)
	return c:IsSetCard(0x5f51)
end

function s.protg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
end

function s.protop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	if #g>0 then
		local tc=g:GetFirst()
		if tc:IsFacedown() or tc:IsLocation(LOCATION_HAND) then Duel.ConfirmCards(1-tp,tc) end
		if Duel.Destroy(tc,REASON_EFFECT)>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetTargetRange(LOCATION_ONFIELD,0) 
			e1:SetTarget(s.immtg) 
			e1:SetValue(s.efilter) 
			e1:SetReset(RESET_PHASE+PHASE_END,2) 
			Duel.RegisterEffect(e1,tp)
		end
	end
end

function s.immtg(e,c)
	return c:IsSetCard(0x5f51)
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() 
		and not te:IsHasCategory(CATEGORY_DESTROY)
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