--[[
明耀之风
Wind of Advancement
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableCounterPermit(COUNTER_LORE,0xff)
	Duel.EnableGlobalFlag(GLOBALFLAG_SELF_TOGRAVE)
	--If this card has no Lore Counters on it, send it to the GY.
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_SELF_TOGRAVE)
	e0:SetCondition(s.sdcon)
	c:RegisterEffect(e0)
	--[[Cannot be activated if you control more monsters than your opponent does. When this card is activated: Return all monsters you control to the hand, and if you do,
	place a number of Lore Counters on this card, equal to the number of monsters you returned.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TOHAND|CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(s.actcon,nil,s.acttg,s.actop)
	c:RegisterEffect(e1)
	--[[During your End Phase, if you did not inflict damage to your opponent this turn, place 1 Lore Counter on this card.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:OPT()
	e2:SetCondition(s.epcon)
	e2:SetTarget(aux.RelationTarget)
	e2:SetOperation(s.epop)
	c:RegisterEffect(e2)
	--[[During your Battle Step: You can remove 1 Lore Counter from this card, then target 1 face-up monster you control that did not declare an attack this turn;
	inflict damage to your opponent equal to that monster's ATK, and if you do, it cannot attack this turn. (You can only target each monster you control with this effect once per turn.)]]
	local e3=Effect.CreateEffect(c)
	e3:Desc(1,id)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetFunctions(
		s.damcon,
		s.damcost,
		s.damtg,
		s.damop
	)
	c:RegisterEffect(e3)
	--If you control 5 or more monsters with different names: You can banish this card from your GY; draw 2 cards. 
	local e4=Effect.CreateEffect(c)
	e4:Desc(2,id)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetFunctions(s.condition,aux.bfgcost,s.target,s.operation)
	c:RegisterEffect(e4)
	if not s.global_check then
		s.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_DAMAGE)
		ge:SetOperation(s.regcon)
		Duel.RegisterEffect(ge,0)
	end
end

local FLAG_INFLICTED_DAMAGE_TO_OPPONENT = id
local FLAG_ALREADY_TARGETED_THIS_TURN	= id+100

function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==1-rp then
		Duel.RegisterFlagEffect(rp,FLAG_INFLICTED_DAMAGE_TO_OPPONENT,RESET_PHASE|PHASE_END,0,1)
	end
end

--E0
function s.sdcon(e)
	local c=e:GetHandler()
	local event,eg,ep,ev,re,r,rp=Duel.CheckEvent(EVENT_CHAIN_SOLVING,true)
	if event and re and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()==c then
		return false
	end
	return not c:HasCounter(COUNTER_LORE)
end

--E1
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.Group(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		return #g>0 and c:IsCanAddCounter(COUNTER_LORE,1,false,LOCATION_SZONE)
	end
	Duel.SetCardOperationInfo(g,CATEGORY_TOHAND)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,c,1,tp,ct)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
	if ct>0 then
		local c=e:GetHandler()
		if c:IsRelateToChain() and c:IsFaceup() and c:IsCanAddCounter(COUNTER_LORE,ct) then
			c:AddCounter(COUNTER_LORE,ct)
		end
	end
end

--E2
function s.epcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and not Duel.PlayerHasFlagEffect(tp,FLAG_INFLICTED_DAMAGE_TO_OPPONENT)
end
function s.epop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsCanAddCounter(COUNTER_LORE,1) then
		Duel.Hint(HINT_CARD,tp,id)
		c:AddCounter(COUNTER_LORE,1)
	end
end

--E3
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and Duel.GetCurrentChain()==0 and Duel.GetAttacker()==nil
end
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,COUNTER_LORE,1,REASON_COST) end
	c:RemoveCounter(tp,COUNTER_LORE,1,REASON_COST)
	if not c:HasCounter(COUNTER_LORE) then
		c:ReleaseEffectRelation(e)
	end
end
function s.damfilter(c)
	return not c:HasFlagEffect(FLAG_ALREADY_TARGETED_THIS_TURN) and c:IsFaceup() and c:IsAttackAbove(1) and c:GetAttackAnnouncedCount()==0
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.damfilter(chkc) end
	if chk==0 then
		return Duel.IsExists(true,s.damfilter,tp,LOCATION_MZONE,0,1,nil)
	end
	local tc=Duel.Select(HINTMSG_FACEUP,true,tp,s.damfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	tc:RegisterFlagEffect(FLAG_ALREADY_TARGETED_THIS_TURN,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetAttack())
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() then
		local atk=tc:GetAttack()
		if atk>0 and Duel.Damage(Duel.GetTargetPlayer(),atk,REASON_EFFECT)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:Desc(3,id)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end

--E4
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(Card.IsFaceup,nil)
	return g:CheckSubGroup(aux.dncheck,5,#g)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end