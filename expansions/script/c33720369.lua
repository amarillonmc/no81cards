--[[
水晶魔法大妖精 米莉茉
Minimu, The Crystal Sorcery
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[(Quick Effect): You can send this card from your hand or field to the GY; your opponent can choose to take 4000 damage to negate this effect, otherwise, for the rest of this turn, each time
	the total number of cards in your opponent's hand, GY and field changes, you immediately gain LP equal to the difference x 1000.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DAMAGE|CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND|LOCATION_MZONE)
	e1:HOPT()
	e1:SetHintTiming(0,RELEVANT_TIMINGS|TIMING_DRAW_PHASE)
	e1:SetFunctions(nil,aux.ToGraveSelfCost,s.target,s.operation)
	c:RegisterEffect(e1)
end

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
	Duel.SetPossibleOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NO_EFFECT_DAMAGE) and Duel.SelectYesNo(1-tp,aux.Stringid(id,1)) then
		Duel.Damage(1-tp,4000,REASON_EFFECT)
		Duel.NegateEffect(0)
		return
	end
	local c=e:GetHandler()
	aux.RegisterMaxxCEffect(c,id,tp,0,EVENT_ADJUST,s.rccon,s.rcopOUT,s.rcopIN,s.flaglabel,RESET_PHASE|PHASE_END,nil,Duel.GetFieldGroupCount(tp,0,LOCATION_HAND|LOCATION_ONFIELD|LOCATION_GRAVE))
end
function s.rccon(e,tp,eg,ep,ev,re,r,rp)
	local ct_old=e:GetLabel()
	local ct_new=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND|LOCATION_ONFIELD|LOCATION_GRAVE)
	local res=ct_old~=ct_new
	e:SetLabel(ct_new,math.abs(ct_old-ct_new))
	return res
end
function s.flaglabel(e,tp,eg,ep,ev,re,r,rp)
	return e:GetSpecificLabel(2)
end
function s.rcopOUT(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Recover(tp,e:GetSpecificLabel(2)*1000,REASON_EFFECT)
end
function s.rcopIN(e,tp,eg,ep,ev,re,r,rp,n)
	Duel.Hint(HINT_CARD,tp,id)
	local labels={Duel.GetFlagEffectLabel(tp,id)}
	local ct=0
	for i=1,#labels do
		ct=ct+labels[i]
	end
	Duel.Recover(tp,ct*1000,REASON_EFFECT)
end