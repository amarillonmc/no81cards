--[[
亡命骗徒 『老司机』
Desperado Trickster - "The Ferry"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	Auxiliary.RegisterDesperadoChallengeEffect(c,id,CATEGORY_DRAW,EFFECT_FLAG_DELAY,s.target,s.operation,s.challenge)
end
function s.thfilter(c)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsMonster() and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function s.rvfilter(c)
	return c:IsType(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP) and not c:IsPublic()
end
function s.typcheck(g)
	return g:GetClassCount(s.typcount)==#g
end
function s.typcount(c)
	return c:GetType()&(TYPE_MONSTER|TYPE_SPELL|TYPE_TRAP)
end
function s.challenge(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local hand=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if #hand<3 then return false end
		local g=hand:Filter(s.rvfilter,nil)
		if g:CheckSubGroup(s.typcheck,3,3) then
			Duel.HintMessage(tp,HINTMSG_CONFIRM)
			local rg=g:SelectSubGroup(tp,s.typcheck,false,3,3)
			if #rg>0 then
				Duel.ConfirmCards(1-tp,rg)
				return true
			end
		end
		return false
	end
	Duel.Draw(tp,2,REASON_EFFECT)
end