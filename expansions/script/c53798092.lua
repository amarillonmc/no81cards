--User's Card
local s,id,o=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	
	--Effect 1: Trigger on Opponent Summon (Droll & Lock Bird style trigger)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.discon)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	
	--Global check for Effect 1
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
	
	--Effect 2: Grave Act Limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.actcon)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(Card.IsSummonPlayer,1,nil,0) then v=v+1 end
	if eg:IsExists(Card.IsSummonPlayer,1,nil,1) then v=v+2 end
	if v==0 then return end
	-- v=1(p0), v=2(p1), v=3(both)
	-- Map to player label like Droll: 0, 1, or PLAYER_ALL
	local label = 0
	if v==1 then label=0
	elseif v==2 then label=1
	else label=PLAYER_ALL end
	Duel.RaiseEvent(eg,EVENT_CUSTOM+id,re,r,rp,ep,label)
end

function s.discon(e,tp,eg,ep,ev,re,r,rp)
	-- Check if opponent summoned (Droll style check)
	if not (ev==1-tp or ev==PLAYER_ALL) then return false end
	
	-- Check Water and Wind in GY (Fuh-Rin-Ka-Zan style)
	local b1=Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_WATER)
	local b2=Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_WIND)
	return b1 and b2
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- Warning Point style targetting
	local g=eg:Filter(Card.IsSummonPlayer,nil,1-tp):Filter(Card.IsFaceup,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end

function s.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	-- Warning Point style operation
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		if not c:IsDisabled() then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e4:SetValue(1)
		tc:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e5:SetValue(s.fuslimit)
		tc:RegisterEffect(e5)
		local e6=e4:Clone()
		e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e6)
		local e7=e4:Clone()
		e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		tc:RegisterEffect(e7)
		tc=g:GetNext()
	end
end

function s.negated_filter(c)
	-- Iris Swordsoul style check
	return c:IsFaceup() and c:IsDisabled() and c:IsType(TYPE_EFFECT)
end

function s.actcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.negated_filter,tp,0,LOCATION_MZONE,1,nil)
end

function s.aclimit(e,re,tp)
	-- Georgias style limit
	return re:GetActivateLocation()==LOCATION_GRAVE and re:IsActiveType(TYPE_MONSTER)
end