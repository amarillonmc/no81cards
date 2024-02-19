--[[
因·为·我·们·是·动物朋友！
BECAUSE. WE. ARE. ANIFRIENDS!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:Desc(0)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--If there are cards with the same name in your GY, send this card to the GY
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_SELF_TOGRAVE)
	e1:SetCondition(s.sdcon)
	--c:RegisterEffect(e1)
	--[[Each time an "Anifriends" monster you control destroys a monster by battle, you can apply the following effect.
	● Add from your Deck to your hand, 1 "Anifriends" monster with a different Type and a lower ATK than that "Anifriends" monster,
	but you cannot activate the effects of monsters with the same name as the added monster for the rest of this turn.
	If there are 7 or more "Anifriends" monsters in your GY, you can also apply the above effect immediately after an activated "Anifriends" monster effect resolves.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetLabelObject(e0)
	e2:SetCondition(s.thcon)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(s.regcon)
	e3:SetOperation(s.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVED)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.thcon2)
	e4:SetOperation(s.thop2)
	c:RegisterEffect(e4)
	aux.RegisterTriggeringArchetypeCheck(c,ARCHE_ANIFRIENDS)
end
--E1
function s.sdcon(e)
	local g=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_GRAVE,0)
	return #g>0 and not aux.dncheck(g)
end

--E2
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	for rc in aux.Next(eg) do
		if rc:IsRelateToBattle() then
			if rc:IsControler(tp) and rc:IsSetCard(ARCHE_ANIFRIENDS) then return true end
		else
			if rc:IsPreviousControler(tp) and rc:IsPreviousSetCard(ARCHE_ANIFRIENDS) then return true end
		end
	end
	return false
end
function s.cfilter(c,tp)
	if c:IsRelateToBattle() then
		return c:IsControler(tp) and c:IsSetCard(ARCHE_ANIFRIENDS)
	else
		return c:IsPreviousControler(tp) and c:IsPreviousSetCard(ARCHE_ANIFRIENDS)
	end
end
function s.thfilter(c,races,atks)
	if not (c:IsMonster() and c:IsSetCard(ARCHE_ANIFRIENDS)) then return false end
	for i=1,#races do
		if not c:IsRace(races[i]) and c:GetAttack()<atks[i] then
			return true
		end
	end
	return false
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local races,atks={},{}
	local g=eg:Filter(s.cfilter,nil,tp)
	for tc in aux.Next(g) do
		if tc:IsRelateToBattle() then
			table.insert(races,tc:GetRace())
			table.insert(atks,tc:GetAttack())
		else
			table.insert(races,tc:GetPreviousRaceOnField())
			table.insert(atks,tc:GetPreviousAttackOnField())
		end
	end
	if not Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,races,atks) or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,races,atks)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SearchAndCheck(tc,tp) then
		local codes={tc:GetCode()}
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(s.aclimit)
		e1:SetLabel(table.unpack(codes))
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.aclimit(e,re,tp)
	local codes={e:GetLabel()}
	return re:GetHandler():IsCode(table.unpack(codes))
end

--E3
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.MonsterFilter(Card.IsSetCard,ARCHE_ANIFRIENDS),tp,LOCATION_GRAVE,0,7,nil)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp or not re:IsActiveType(TYPE_MONSTER) or not aux.CheckArchetypeReasonEffect(s,re,ARCHE_ANIFRIENDS) then return end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT|(RESETS_STANDARD&(~RESET_TURN_SET))|RESET_CHAIN,0,1)
end

--E4
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==tp and re:IsActiveType(TYPE_MONSTER) and aux.CheckArchetypeReasonEffect(s,re,ARCHE_ANIFRIENDS) and c:HasFlagEffect(id)
end
function s.thfilter2(c,race,atk)
	return c:IsMonster() and c:IsSetCard(ARCHE_ANIFRIENDS) and not c:IsRace(race) and c:HasAttack() and c:GetAttack()<atk
end
function s.thop2(e,tp,eg,ep,ev,re,r,rp)
	local race,atk=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TRIGGERING_RACE,CHAININFO_TRIGGERING_ATTACK)
	if not Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil,race,atk) or not Duel.SelectYesNo(tp,aux.Stringid(id,1)) then return end
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil,race,atk)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SearchAndCheck(tc,tp) then
		local codes={tc:GetCode()}
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.aclimit)
		e1:SetLabel(codes)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end