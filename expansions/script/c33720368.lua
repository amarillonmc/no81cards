--[[
里技吸猫
Inner Nekotize
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[Reveal 1 Beast monster in your Deck or Extra Deck; during the End Phase of this turn, gain LP equal to its combined ATK/DEF.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:HOPT(true)
	e1:SetFunctions(nil,aux.DummyCost,s.target,s.activate)
	c:RegisterEffect(e1)
end
--E1
function s.filter(c)
	return c:IsRace(RACE_BEAST) and c:GetTotalStats()>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:IsCostChecked() and Duel.IsExists(false,s.filter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,nil)
	end
	local tc=Duel.Select(HINTMSG_CONFIRM,false,tp,s.filter,tp,LOCATION_DECK|LOCATION_EXTRA,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	e:SetLabel(tc:GetTotalStats())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local v=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:Desc(1,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetLabel(v)
	e1:OPT()
	e1:SetOperation(s.lpop)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,e:GetLabel(),REASON_EFFECT)
end