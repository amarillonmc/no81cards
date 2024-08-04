--[[
渴求败退！
Longing - Defeated!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	aux.CheckAlreadyRegisteredEffects()
	aux.EnabledRegisteredEffectMods[EFFECT_NO_RECOVER]=true
	--[[Tribute 1 monster; until the end of your next turn, your opponent cannot gain LP, also, if you gain LP, inflict that amount of damage to your opponent
	(but the maximum total damage you can inflict to your opponent with this effect is equal to the ATK of the Tributed monster.)]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetFunctions(nil,aux.DummyCost,s.target,s.operation)
	c:RegisterEffect(e1)
	--During your opponent's turn, if they gained 3000 or more LP this turn, you can activate this card from your hand.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_RECOVER)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

local FLAG_LP_GAINED_BY_OPPONENT	=	id
local FLAG_IMMEDIATE_CHECK			=	id+100
local FLAG_ALREADY_INFLICTED_DAMAGE	=	id+200

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.PlayerHasFlagEffect(ep,FLAG_LP_GAINED_BY_OPPONENT) then
		Duel.RegisterFlagEffect(ep,FLAG_LP_GAINED_BY_OPPONENT,RESET_PHASE|PHASE_END,0,1)
	end
	Duel.UpdateFlagEffectLabel(ep,FLAG_LP_GAINED_BY_OPPONENT,ev)
end

--E1
function s.relfilter(c,tp)
	return Duel.IsExists(false,s.rmfilter,tp,0,LOCATION_MZONE,1,c,c:GetAttack()-1)
end
function s.rmfilter(c,atk)
	return (c:IsFaceup() or (c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:IsMonster())) and c:IsDefenseBelow(atk) and c:IsAbleToRemove()
end
function s.rmfilter2(c,atk)
	return (c:IsFaceup() or (c:IsLocation(LOCATION_HAND) and c:IsMonster())) and c:IsDefenseBelow(atk) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not e:IsCostChecked() then return false end
		return Duel.CheckReleaseGroup(tp,nil,1,nil)
	end
	local rg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	local atk=rg:GetFirst():GetAttack()
	if Duel.Release(rg,REASON_COST)>0 then
		Duel.SetTargetParam(atk)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rct=Duel.GetNextPhaseCount(nil,tp)
	local e1=Effect.CreateEffect(c)
	e1:Desc(2,id)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET|EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_NO_RECOVER)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE|PHASE_END|RESET_SELF_TURN,rct)
	Duel.RegisterEffect(e1,tp)
	local atk=Duel.GetTargetParam()
	if atk and atk>0 then
		Duel.RegisterFlagEffect(tp,FLAG_ALREADY_INFLICTED_DAMAGE,RESET_PHASE|PHASE_END|RESET_SELF_TURN,0,rct)
		aux.RegisterMaxxCEffect(c,FLAG_IMMEDIATE_CHECK,tp,0,EVENT_RECOVER,s.damcon,s.damopOUT,s.damopIN,s.flaglabel,{RESET_PHASE|RESET_SELF_TURN,rct},nil,atk)
	end
end
function s.flaglabel(e,tp,eg,ep,ev,re,r,rp)
	return ev
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetFlagEffectLabel(tp,FLAG_ALREADY_INFLICTED_DAMAGE)<e:GetLabel()
end
function s.damopOUT(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local atk=e:GetLabel()
	local pastdam=Duel.GetFlagEffectLabel(tp,FLAG_ALREADY_INFLICTED_DAMAGE)
	local dam=math.min(ep,atk-pastdam)
	local ct=Duel.Damage(1-tp,dam,REASON_EFFECT)
	if ct>0 then
		Duel.UpdateFlagEffectLabel(tp,FLAG_ALREADY_INFLICTED_DAMAGE,ct)
	end
end
function s.damopIN(e,tp,eg,ep,ev,re,r,rp,n)
	Duel.Hint(HINT_CARD,tp,id)
	local total=0
	local atk=e:GetLabel()
	local pastdam=Duel.GetFlagEffectLabel(tp,FLAG_ALREADY_INFLICTED_DAMAGE)
	local labelset={Duel.GetFlagEffectLabel(tp,FLAG_IMMEDIATE_CHECK)}
	for _,lab in ipairs(labelset) do
		total=total+lab
		if total>=atk-pastdam then
			total=atk-pastdam
			break
		end
	end
	local ct=Duel.Damage(1-tp,total,REASON_EFFECT)
	if ct>0 then
		Duel.UpdateFlagEffectLabel(tp,FLAG_ALREADY_INFLICTED_DAMAGE,ct)
	end
end

--E2
function s.handcon(e)
	local p=1-e:GetHandlerPlayer()
	return Duel.PlayerHasFlagEffect(p,FLAG_LP_GAINED_BY_OPPONENT) and Duel.GetFlagEffectLabel(p,FLAG_LP_GAINED_BY_OPPONENT)>=3000
end
