--[[
汽水，毛豆与刨冰
By Ramune, Zunda & Shaved Ice
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[If all monsters you control are either 3 monsters with same Attribute but different Types, OR 3 monsters with same Type but different Attributes: Return all monsters you control to the hand, and if you returned at least 2, apply 1 of these effects, based on the Attribute/Type those monsters had on field.
	● Same Attribute but different Types: You gain 18000 LP.
	● Same Type but different Attributes: Draw 3 cards.
	Also, after that, unless this card was activated while Set on the field and was not Set this turn, skip to your opponent's next Draw Phase.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_RECOVER|CATEGORY_DRAW|CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(
		s.condition,
		nil,
		s.target,
		s.activate
	)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END,0,1)
	end
end


function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMonsters(tp)
	if not (#g==3 and not g:IsExists(Card.IsFacedown,1,nil)) then return false end
	local atct,rcct=g:GetClassCount(Card.GetAttribute),g:GetClassCount(Card.GetRace)
	return (atct==1 and rcct==3) or (atct==3 and rcct==1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMonsters(tp)
	local tg=g:Filter(Card.IsAbleToHand,nil)
	local atct,rcct=g:GetClassCount(Card.GetAttribute),g:GetClassCount(Card.GetRace)
	if chk==0 then
		return #tg>0 and ((atct==1 and rcct==#g) or Duel.IsPlayerCanDraw(tp,3))
	end
	local c=e:GetHandler()
	local param=(e:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsPreviousPosition(POS_FACEDOWN) and not c:HasFlagEffect(id)) and 1 or 0
	Duel.SetTargetParam(param)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
	Duel.SetConditionalOperationInfo(atct==1 and rcct==#g,0,CATEGORY_RECOVER,nil,0,tp,18000)
	Duel.SetConditionalOperationInfo(atct==#g and rcct==1,0,CATEGORY_DRAW,nil,0,tp,3)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMonsters(tp)
	local tg=g:Filter(Card.IsAbleToHand,nil)
	if #tg>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>1 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
		if #og>1 then
			local atct,rcct=og:GetClassCount(Card.GetPreviousAttributeOnField),og:GetClassCount(Card.GetPreviousRaceOnField)
			if atct==1 and rcct==#og then
				Duel.Recover(tp,18000,REASON_EFFECT)
			elseif atct==#og and rcct==1 then
				Duel.Draw(tp,3,REASON_EFFECT)
			end
		end
	end
	if Duel.GetTargetParam()~=1 then
		Duel.BreakEffect()
		local p=Duel.GetTurnPlayer()
		local max=p==1-tp and 2 or 1
		for i=1,max do
			Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE|PHASE_END,i)
			Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE|PHASE_END,i)
			Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE|PHASE_END,i)
			Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE|PHASE_END,i,1)
			Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE|PHASE_END,i)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE|PHASE_END,i)
			Duel.RegisterEffect(e1,p)
			p=1-p
		end
	end
end