--[[
亡命骗徒 『老司机』
Desperado Trickster - "Ape Out, Horse In"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	Auxiliary.RegisterDesperadoChallengeEffect(c,id,CATEGORIES_TOKEN|CATEGORIES_ATKDEF,nil,s.target,s.operation,s.challenge)
end
function s.filter(c)
	return c:IsCode(ARCHE_DESPERADO_HEART) and c:IsCanChangeStats()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORIES_ATKDEF,nil,1,tp,LOCATION_MZONE,500)
	Duel.SetPossibleOperationInfo(0,CATEGORIES_ATKDEF,nil,1,tp,LOCATION_MZONE,1000)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDesperadoHeartCard(tp,Card.IsCanChangeStats,LOCATION_MZONE,0,1,1,nil,HINTMSG_FACEUP)
	if #g>0 then
		Duel.HintSelection(g)
		g:GetFirst():UpdateATKDEF(500,500,0,{e:GetHandler(),true})
	end
end
function s.rvfilter(c)
	return c:IsMonster() and c:IsAttackAbove(2000) and not c:IsPublic()
end
function s.challenge(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(s.rvfilter,tp,LOCATION_HAND,0,nil)
		if #g>=2 then
			Duel.HintMessage(tp,HINTMSG_CONFIRM)
			local rg=g:Select(tp,2,2,nil)
			if #rg>0 then
				Duel.ConfirmCards(1-tp,rg)
				return true
			end
		end
		return false
	end
	local g=Duel.GetDesperadoHeartCard(tp,Card.IsFaceup,LOCATION_MZONE,0,1,1,nil,HINTMSG_FACEUP)
	if #g>0 then
		Duel.HintSelection(g)
		local c=e:GetHandler()
		local tc=g:GetFirst()
		tc:UpdateATKDEF(1000,1000,0,{c,true})
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,3))
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
	end
end