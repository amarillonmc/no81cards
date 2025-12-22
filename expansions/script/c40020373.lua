--CB 刹那·F·清英[ELS变革者]
local s,id=GetID()
s.ui_hint_effect = s.ui_hint_effect or {}
local CORE_ID = 40020353 
local ArmedIntervention = CORE_ID	  
local ArmedIntervention_UI = CORE_ID + 10000
--CB
s.named_with_CelestialBeing=1
function s.CelestialBeing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CelestialBeing
end
function s.Exia(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Exia
end
function s.initial_effect(c)
	aux.EnableUnionAttribute(c,s.filter)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true  
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetCondition(s.ui_update_con)
		ge1:SetOperation(s.ui_update_op)
		Duel.RegisterEffect(ge1,0)
	end
end
s.has_text_type=TYPE_UNION
function s.filter(c)
	return (c:IsRace(RACE_MACHINE) and s.CelestialBeing(c) and c:IsLevelAbove(6)) or s.Exia(c)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
			local owner=e:GetHandler():GetOwner()
			Duel.RegisterFlagEffect(owner,ArmedIntervention,0,0,0)
			Duel.RegisterFlagEffect(owner,ArmedIntervention,0,0,0)
		end
	end
end
function s.ui_update_con(e,tp,eg,ep,ev,re,r,rp)
	local c0 = Duel.GetFlagEffect(0, ArmedIntervention)
	local c1 = Duel.GetFlagEffect(1, ArmedIntervention)
	local old_val = e:GetLabel()
	local old_c0 = old_val & 0xFFFF
	local old_c1 = (old_val >> 16) & 0xFFFF
	
	return c0 ~= old_c0 or c1 ~= old_c1
end
function s.ui_update_op(e,tp,eg,ep,ev,re,r,rp)
	local c0 = Duel.GetFlagEffect(0, ArmedIntervention)
	local c1 = Duel.GetFlagEffect(1, ArmedIntervention)
	e:SetLabel((c1 << 16) | c0)
	s.update_player_ui(0, c0)
	s.update_player_ui(1, c1)
end
function s.update_player_ui(p, count)
	local old=s.ui_hint_effect[p]
	if old then
		old:Reset()
		s.ui_hint_effect[p]=nil
	end
	if count==0 then return end
	local str_index
	if count>=10 then
		str_index=13 
	else
		str_index=2+count 
	end
	local e=Effect.GlobalEffect()
	e:SetType(EFFECT_TYPE_FIELD)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e:SetCode(ArmedIntervention_UI)
	e:SetTargetRange(1,0)
	e:SetDescription(aux.Stringid(CORE_ID, str_index))
	Duel.RegisterEffect(e, p)
	s.ui_hint_effect[p]=e
end