--[[
晦空士 ～沉醉之默视～
Sepialife - Attention From Incognito
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--You cannot Pendulum Summon monsters. This effect cannot be negated.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CAN_FORBIDDEN)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.psplimit)
	c:RegisterEffect(e1)
	--[[At the start of your Main Phase 1, if there is another "Sepialife" card in your other Pendulum Zone: You can Special Summon, from your Deck, up to 3 "Sepialife" monsters with different names, each with a Level between (exclusive) the Pendulum Scales of the cards in your Pendulum Zones, then it becomes the End Phase of this turn.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetFunctions(
		s.spcon,
		nil,
		s.sptg,
		s.spop
	)
	c:RegisterEffect(e2)
	--[[During your Battle Phase, if you have not activated the effect of a non-"Sepialife" card this turn (Quick Effect): You can place this card from your hand to your Spell/Trap Zone as a Continuous Spell, and if you do, it becomes the End Phase.]]
	local e3=Effect.CreateEffect(c)
	e3:Desc(1,id)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetRelevantBattleTimings()
	e3:SetFunctions(
		s.cscon,
		nil,
		s.cstg,
		s.csop
	)
	c:RegisterEffect(e3)
	--[[While this card is a Continuous Spell, it gains this effect.
	● Each time your opponent activates a card effect or declares an attack, they must reveal 1 card in their hand and keep it revealed until the end of your next turn. If they do not, that effect or attack is negated.]]
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetFunctions(
		s.negcon,
		nil,
		nil,
		s.negop
	)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetFunctions(
		s.negcon,
		nil,
		nil,
		s.negop
	)
	c:RegisterEffect(e5)
	aux.RegisterTriggeringArchetypeCheck(c,ARCHE_SEPIALIFE)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.CheckArchetypeReasonEffect(s,re,ARCHE_SEPIALIFE) then
		Duel.RegisterFlagEffect(ep,id,RESET_PHASE|PHASE_END,0,1)
	end
end

--P1
function s.psplimit(e,c,tp,sumtp,sumpos)
	return sumtp&SUMMON_TYPE_PENDULUM==SUMMON_TYPE_PENDULUM
end

--P2
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase(tp,1) and not Duel.CheckPhaseActivity() and Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,ARCHE_SEPIALIFE),tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function s.spfilter(c,e,tp,min,max)
	if not (c:IsSetCard(ARCHE_SEPIALIFE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:HasLevel()) then return false end
	local lv=c:GetLevel()
	return lv>min and lv<max
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local lz,rz=Duel.GetFieldCard(tp,LOCATION_PZONE,0),Duel.GetFieldCard(tp,LOCATION_PZONE,1)
		if not lz or not rz then return false end
		local lsc,rsc=lz:GetLeftScale(),rz:GetRightScale()
		return math.abs(lsc-rsc)>1 and Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,math.min(lsc,rsc),math.max(lsc,rsc))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local lz,rz=Duel.GetFieldCard(tp,LOCATION_PZONE,0),Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not lz or not rz then return end
	local ft=Duel.GetMZoneCountForMultipleSpSummon(tp)
	if ft<=0 then return end
	local lsc,rsc=lz:GetLeftScale(),rz:GetRightScale()
	local g=Duel.Group(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp,math.min(lsc,rsc),math.max(lsc,rsc))
	if #g==0 then return end
	local tg=xgl.SelectUnselectGroup(g,e,tp,1,math.min(3,ft),xgl.dncheck,1,tp,HINTMSG_SPSUMMON)
	if #tg>0 and Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		local p=Duel.GetTurnPlayer()
		Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
		Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,p)
	end
end

--E3
function s.cscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase(tp) and not Duel.PlayerHasFlagEffect(tp,id)
end
function s.cstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:HasFlagEffect(id) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp,LOCATION_SZONE)
	end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.csop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.PlaceAsContinuousCard(c,tp,tp,c,TYPE_SPELL)>0 then
		Duel.BreakEffect()
		local p=Duel.GetTurnPlayer()
		Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
		Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
		Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,p)
	end
end

--E5
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsSpell(TYPE_CONTINUOUS) then return false end
	local event=e:GetCode()
	if event==EVENT_CHAINING then
		return rp==1-tp
	else
		return Duel.GetAttacker():IsControler(1-tp)
	end
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.PlayerHasFlagEffect(tp,id+100) then return end
	Duel.Hint(HINT_CARD,tp,id)
	local g=Duel.Group(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
	if #g==0 or not Duel.SelectYesNo(1-tp,aux.Stringid(id,2)) then
		Duel.RegisterFlagEffect(tp,id+100,RESET_CHAIN,0,1)
		local event=e:GetCode()
		if event==EVENT_CHAINING then
			if Duel.IsChainDisablable(ev) then Duel.NegateEffect(ev) end
		else
			Duel.NegateAttack()
		end
	else
		local tc=g:Select(1-tp,1,1,nil):GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESETS_STANDARD_PHASE_END,Duel.GetNextPhaseCount(nil,tp))
		tc:RegisterEffect(e1)
	end
end