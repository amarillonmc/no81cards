--[[
至高的朱鹮
Ibis Trismegistus
Ibis Trismegisto
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[When a monster effect is activated, or when a monster declares an attack: Send from your Deck and/or Extra Deck to the GY, 1 each of the following cards
	(Normal, Effect, Fusion, Synchro, Xyz, Link and Ritual Monster); negate that effect or attack, and if you do, banish that monster face-down, and if you do that,
	skip your opponent's next Battle Phase. You must have less than 777 LP, or less than 17 cards in your Deck and Extra Deck combined, to activate and resolve this effect.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_DISABLE|CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:Desc(1)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(s.condition2)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
	--[[During your opponent's End Phase, if a Set Normal Spell(s) you controlled was destroyed and sent to the GY this turn:
	You can banish this card from your GY; add 1 of those Normal Spells from your GY to your hand, OR add 1 "Monster Reborn" from your Deck to your hand. ]]
	local e3=Effect.CreateEffect(c)
	e3:Desc(2)
	e3:SetCategory(CATEGORIES_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(TIMING_END_PHASE)
	e3:SetCondition(s.thcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.types(c,type)
	local typ=c:GetType()&(TYPE_NORMAL|TYPE_FUSION|TYPE_RITUAL|TYPE_SYNCHRO|TYPE_XYZ|TYPE_PENDULUM|TYPE_LINK)
	if typ~=0 then
		return typ&type==type
	elseif c:IsType(TYPE_EFFECT) then
		return type==TYPE_EFFECT
	else
		return false
	end
end
s.hnchecks=aux.CreateChecks(s.types,{TYPE_NORMAL,TYPE_EFFECT,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK,TYPE_RITUAL})

function s.regfilter(c,p)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(p) and c:IsPreviousPosition(POS_FACEDOWN) and c:GetPreviousTypeOnField()==TYPE_SPELL and c:IsReason(REASON_DESTROY)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local g=eg:Filter(s.regfilter,nil,p)
		if #g>0 then
			Duel.RegisterFlagEffect(p,id,RESET_PHASE|PHASE_END,0,1)
		end
		for tc in aux.Next(g) do
			tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1,p)
		end
	end
end

--E1
function s.actrescon(tp)
	return Duel.GetLP(tp)<777 or Duel.GetFieldGroupCount(tp,LOCATION_DECK|LOCATION_EXTRA,0)<17
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return s.actrescon(tp) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsDisabled() and Duel.IsChainDisablable(ev)
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_DECK|LOCATION_EXTRA,0,nil)
	if chk==0 then return mg:CheckSubGroupEach(s.hnchecks,aux.TRUE) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=mg:SelectSubGroupEach(tp,s.hnchecks,false,aux.TRUE)
	Duel.SendtoGrave(sg,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	local relation=rc:IsRelateToChain(ev)
	if chk==0 then return not rc:IsDisabled() and (rc:IsAbleToRemove(tp,POS_FACEDOWN) or (not relation and Duel.IsPlayerCanRemove(tp))) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if relation then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,rc:GetPreviousLocation())
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if not s.actrescon(tp) then return end
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToChain(ev) and Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		if Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(s.skipcon)
			e1:SetReset(RESET_PHASE|PHASE_BATTLE|RESET_OPPO_TURN,2)
		else
			e1:SetReset(RESET_PHASE|PHASE_BATTLE|RESET_OPPO_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function s.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end

--E2
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return s.actrescon(tp)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=Duel.GetAttacker()
	if chk==0 then return rc:IsAbleToRemove(tp,POS_FACEDOWN) end
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rc,1,rc:GetControler(),rc:GetLocation())
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not s.actrescon(tp) then return end
	local rc=Duel.GetAttacker()
	if rc:IsRelateToChain() and not rc:IsStatus(STATUS_ATTACK_CANCELED) and Duel.NegateAttack() and Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		if Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(s.skipcon)
			e1:SetReset(RESET_PHASE|PHASE_BATTLE|RESET_OPPO_TURN,2)
		else
			e1:SetReset(RESET_PHASE|PHASE_BATTLE|RESET_OPPO_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end

--E3
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsEndPhase(1-tp) and Duel.PlayerHasFlagEffect(tp,id)
end
function s.thfilter(c,tp)
	if not c:IsAbleToHand() then return false end
	return (c:IsNormalSpell() and c:HasFlagEffectLabel(id,tp)) or (c:IsLocation(LOCATION_DECK) and c:IsCode(CARD_MONSTER_REBORN))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,tp)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end