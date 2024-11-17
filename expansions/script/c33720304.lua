--[[欲出博士→绝体绝命810！
Yokuderu, Prof. of BranD-810!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--If an attack is declared involving a "BranD-810!" monster you control, negate that attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.nacon)
	e1:SetOperation(s.naop)
	c:RegisterEffect(e1)
	--[[If an attack is negated by this card's effect: Activate this effect; at the end of your next Battle Phase, inflict damage to your opponent equal
	to the original ATK of the monster that attacked. (This effect applies even if this card and/or the attacker are no longer on the field.)]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_DISABLED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetFunctions(s.applycon,nil,s.applytg,s.applyop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_PHASE|PHASE_BATTLE_START)
		ge:OPT()
		ge:SetOperation(s.regop)
		Duel.RegisterEffect(ge,0)
	end
end

local PFLAG_REGISTERED_BP_EFFECT = id
local PFLAG_BP_COUNTER = id+100

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	if not Duel.PlayerHasFlagEffect(p,PFLAG_BP_COUNTER) then
		Duel.RegisterFlagEffect(p,PFLAG_BP_COUNTER,0,0,0,0)
	end
	Duel.UpdateFlagEffectLabel(p,PFLAG_BP_COUNTER,1)
end

--E1
function s.nacon(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetBattleMonster(tp)
	return bc:IsFaceup() and bc:IsSetCard(ARCHE_BRAND_810)
end
function s.naop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	Duel.NegateAttack()
end

--E2
function s.applycon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler()==e:GetHandler()
end
function s.applytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local val=eg:GetFirst():GetBaseAttack()
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,val)
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local val=Duel.GetTargetParam()
	local bpct=Duel.PlayerHasFlagEffect(tp,PFLAG_BP_COUNTER) and Duel.GetFlagEffectLabel(tp,PFLAG_BP_COUNTER) or 0
	local rct=Duel.GetNextBattlePhaseCount(tp) 
	local c=e:GetHandler()
	local fe=Duel.GetFlagEffectWithSpecificLabel(tp,PFLAG_REGISTERED_BP_EFFECT,bpct+1)
	if not fe then
		fe=Effect.CreateEffect(c)
		fe:SetType(EFFECT_TYPE_FIELD)
		fe:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		fe:SetCode(EFFECT_FLAG_EFFECT|PFLAG_REGISTERED_BP_EFFECT)
		fe:SetTargetRange(1,0)
		fe:SetLabel(bpct+1,val)
		fe:SetReset(RESET_PHASE|PHASE_BATTLE|RESET_SELF_TURN,rct)
		Duel.RegisterEffect(fe,tp)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,2))
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE|PHASE_BATTLE)
		e1:SetLabel(bpct+1)
		e1:SetCountLimit(999)
		e1:SetFunctions(s.damcon,nil,nil,s.damop)
		e1:SetReset(RESET_PHASE|PHASE_BATTLE|RESET_SELF_TURN,rct)
		Duel.RegisterEffect(e1,tp)
	else
		fe:SetSpecificLabel(val,0)
	end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local c=e:GetHandler()
	local bpct=Duel.PlayerHasFlagEffect(tp,PFLAG_BP_COUNTER) and Duel.GetFlagEffectLabel(tp,PFLAG_BP_COUNTER) or 0
	local bpgoal=e:GetLabel()
	if bpct~=bpgoal then return false end
	local fe=Duel.GetFlagEffectWithSpecificLabel(tp,PFLAG_REGISTERED_BP_EFFECT,bpct)
	local labels={fe:GetLabel()}
	if #labels<2 then
		e:Reset()
		return false
	end
	return true
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	local bpct=Duel.PlayerHasFlagEffect(tp,PFLAG_BP_COUNTER) and Duel.GetFlagEffectLabel(tp,PFLAG_BP_COUNTER) or 0
	local fe=Duel.GetFlagEffectWithSpecificLabel(tp,PFLAG_REGISTERED_BP_EFFECT,bpct)
	local labels={fe:GetLabel()}
	local vals={fe:GetLabel()}
	table.remove(vals,1)
	local val
	if #vals==1 then
		val=vals[1]
	else
		Duel.HintMessage(tp,aux.Stringid(id,3))
		val=Duel.AnnounceNumber(tp,table.unpack(vals))
	end
	for i,label in ipairs(labels) do
		if label==val then
			table.remove(labels,i)
			break
		end
	end
	fe:SetLabel(table.unpack(labels))
	Duel.Damage(1-tp,val,REASON_EFFECT)
end