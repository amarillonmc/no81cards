--[[
Fang Cell - 黑手怪
Fang Cell
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--Special Summon this card as an Effect Monster (Rock/DARK/Level 4/ATK 1600/DEF 2000). (This card is also still a Trap.)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--[[If there are cards with the same name in your GY, while there are no cards with the same name in your opponent's GY, this card gains these effects while it is in the Monster Zone:
	● Cannot be destroyed by battle by a monster whose ATK is lower than twice this card's ATK.
	● All damage you take is halved.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.effcon)
	e2:SetValue(s.indes)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetCondition(s.effcon)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
end
--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,1600,2000,4,RACE_ROCK,ATTRIBUTE_DARK)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPES_EFFECT_TRAP_MONSTER,1600,2000,4,RACE_ROCK,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT|TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end

--E2
function s.sgcheck(g)
	local c1,c2=g:GetFirst(),g:GetNext()
	return c1:IsCode(c2:GetCode())
end
function s.effcon(e)
	if not aux.ProcSummonedCond(e) then return false end
	local tp=e:GetHandlerPlayer()
	local sg,og=Duel.GetGY(tp),Duel.GetGY(1-tp)
	return sg:CheckSubGroup(s.sgcheck,2,2) and not og:CheckSubGroup(s.sgcheck,2,2)
end
function s.indes(e,c)
	return c:IsAttackBelow((e:GetHandler():GetAttack()*2)-1)
end

--E3
function s.val(e,re,dam,r,rp,rc)
	return math.floor(dam/2)
end