--Crackling World
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--End Phase effect: turn player applies 1 of 2 options
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.ephtg)
	e1:SetOperation(s.ephop)
	c:RegisterEffect(e1)
	--global check: track which monsters battled this turn
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_CONFIRM)
		ge1:SetOperation(s.battleop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(id,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function s.ephfilter1(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:GetFlagEffect(id)>0
end
function s.ephfilter2(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function s.ephtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local turnp=Duel.GetTurnPlayer()
	local b1=Duel.IsExistingMatchingCard(s.ephfilter1,turnp,LOCATION_MZONE,0,1,nil,turnp)
	local b2=Duel.IsExistingMatchingCard(s.ephfilter2,turnp,LOCATION_MZONE,0,1,nil,turnp)
	if chk==0 then return b1 or b2 end
	local ops={}
	local opvals={}
	if b1 then
		table.insert(ops,aux.Stringid(id,1))
		table.insert(opvals,1)
	end
	if b2 then
		table.insert(ops,aux.Stringid(id,2))
		table.insert(opvals,2)
	end
	local op=Duel.SelectOption(turnp,table.unpack(ops))
	e:SetLabel(opvals[op+1])
	if opvals[op+1]==1 then
		e:SetCategory(CATEGORY_DESTROY)
		local g=Duel.GetMatchingGroup(s.ephfilter1,turnp,LOCATION_MZONE,0,nil,turnp)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		local g=Duel.GetMatchingGroup(s.ephfilter2,turnp,LOCATION_MZONE,0,nil,turnp)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	end
end
function s.ephop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local op=e:GetLabel()
	if op==1 then
		--Destroy all monsters that battled, grant effect destruction protection
		local g=Duel.GetMatchingGroup(s.ephfilter1,turnp,LOCATION_MZONE,0,nil,turnp)
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(s.indestg)
			e1:SetOwnerPlayer(turnp)
			e1:SetValue(1)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,turnp)
		end
	elseif op==2 then
		--Send all monsters to GY, grant battle destruction protection
		local g=Duel.GetMatchingGroup(s.ephfilter2,turnp,LOCATION_MZONE,0,nil,turnp)
		local ct=Duel.SendtoGrave(g,REASON_EFFECT)
		if ct>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetTarget(s.indestg)
			e1:SetOwnerPlayer(turnp)
			e1:SetValue(1)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,turnp)
		end
	end
end
function s.indestg(e,c)
	return c:IsControler(e:GetOwnerPlayer())
end
