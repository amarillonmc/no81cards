--[[
晦空士 ～守望的白愿～
Sepialife - Waiting On White
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[During your Standby Phase: You can banish this card from your hand or GY, and if you do, your opponent chooses 1 of these effects for you to apply.
	● Gain LP equal to the total number of cards in both player's hand x 400.
	● Draw 2 cards, and if you do, it becomes the End Phase.
	If your opponent has a revealed "Sepialife" card(s) in their hand, apply these effects based on the number of those cards.
	● 1+: You choose the effect to apply instead.
	● 4+: You apply both effects.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_RECOVER|CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e1:OPT()
	e1:SetFunctions(aux.TurnPlayerCond(0),nil,s.target,s.operation)
	c:RegisterEffect(e1)
end
--E1
function s.filter(c)
	return c:IsPublic() and c:IsSetCard(ARCHE_SEPIALIFE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetHand()
	if g:IsContains(c) then
		g:RemoveCard(c)
	end
	if chk==0 then
		if not c:IsAbleToRemove() then return false end
		return #g>0 or Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetCardOperationInfo(c,CATEGORY_REMOVE)
	local check=Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_HAND,nil)>=4
	Duel.SetConditionalOperationInfo(check,0,CATEGORY_RECOVER,nil,0,tp,#g*400)
	Duel.SetConditionalOperationInfo(check,0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)>0 then
		local handct=Duel.GetHandCount()
		local b1=handct>0
		local b2=Duel.IsPlayerCanDraw(tp,2)
		local ct=Duel.GetMatchingGroupCount(s.filter,tp,0,LOCATION_HAND,nil)
		local p=ct>=1 and tp or 1-tp
		local opt=ct>=4 and 3 or aux.Option(p,nil,nil,{b1,STRING_RECOVER},{b2,STRING_DRAW})+1
		local brk=false
		if opt&1==1 and Duel.Recover(tp,handct*400,REASON_EFFECT)>0 then
			brk=true
		end
		if opt&2==2 then
			if brk then Duel.BreakEffect() end
			if Duel.Draw(tp,2,REASON_EFFECT)>0 and Duel.GetCurrentPhase()~=PHASE_END then
				local turnp=Duel.GetTurnPlayer()
				Duel.BreakEffect()
				Duel.SkipPhase(turnp,PHASE_DRAW,RESET_PHASE|PHASE_END,1)
				Duel.SkipPhase(turnp,PHASE_STANDBY,RESET_PHASE|PHASE_END,1)
				Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE|PHASE_END,1)
				Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE|PHASE_END,1,1)
				Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE|PHASE_END,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetTargetRange(1,0)
				e1:SetReset(RESET_PHASE|PHASE_END)
				Duel.RegisterEffect(e1,turnp)
			end
		end
	end
end