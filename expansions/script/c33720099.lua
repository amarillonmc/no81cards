--[[
Hunter Cell - 猎手怪
Hunter Cell
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--Special Summon this card as an Effect Monster (Rock/DARK/Level 5/ATK 1800/DEF 2200).(This card is also still a Trap.)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--[[If there are cards with the same name in your GY, while there are no cards with the same name in your opponent's GY, this card gains this effect:
	● Before damage calculation, if this card battles a monster, send that monster to the GY. Your opponent can take damage equal to that monster's ATK to end that battle instead. If a monster is sent to GY by this effect, skip your opponent's next Battle Phase, and if it was an "Anifriends" monster while on the field, this card gains that monster's original effects.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetCondition(s.ddcon)
	e2:SetTarget(aux.RelationTarget)
	e2:SetOperation(s.ddop)
	c:RegisterEffect(e2)
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,1800,2200,5,RACE_ROCK,ATTRIBUTE_DARK)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,1800,2200,5,RACE_ROCK,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT|TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end

--E2
function s.sgcheck(g)
	local c1,c2=g:GetFirst(),g:GetNext()
	return c1:IsCode(c2:GetCode())
end
function s.effcon(e,tp)
	if not aux.ProcSummonedCond(e) then return false end
	local sg,og=Duel.GetGY(tp),Duel.GetGY(1-tp)
	return sg:CheckSubGroup(s.sgcheck,2,2) and not og:CheckSubGroup(s.sgcheck,2,2)
end
function s.ddcon(e,tp,eg,ep,ev,re,r,rp)
	if not s.effcon(e,tp) then return false end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsRelateToBattle()
end
function s.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToEffect(e) and c:IsRelateToBattle() and bc:IsRelateToBattle() then
		Duel.Hint(HINT_CARD,tp,id)
		if bc:IsFaceup() and bc:IsAttackAbove(1) and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
			Duel.Damage(1-tp,bc:GetAttack(),REASON_EFFECT)
			local a=Duel.GetAttacker()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EFFECT_ATTACK_DISABLED)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE)
			a:RegisterEffect(e1,true)
			a:SetStatus(STATUS_ATTACK_CANCELED,true)
		else
			local check=bc:IsFaceup() and bc:IsSetCard(ARCHE_ANIFRIENDS)
			if Duel.SendtoGrave(bc,REASON_EFFECT)>0 and bc:IsInGY() and aux.BecauseOfThisEffect(e)(bc) then
				local e1=Effect.CreateEffect(c)
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
				if check and bc:IsOriginalType(TYPE_EFFECT) then
					c:CopyEffect(bc:GetOriginalCode(),RESET_EVENT|RESETS_STANDARD)
				end
			end
		end
	end
end
function s.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end