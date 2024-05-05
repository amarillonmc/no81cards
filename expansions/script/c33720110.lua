--[[
亡命骗徒 『珍惜时光』
Desperado Trickster - "Carpe Diem"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	aux.RegisterDesperadoGeasGenerationEffect(c,id,EFFECT_FLAG_DELAY,nil,nil,s.e1,s.e2,s.e3)
end

function s.e1(c)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(id,2))
	e:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e:SetProperty(EFFECT_FLAG_DELAY)
	e:SetCode(EVENT_TO_GRAVE)
	e:SetCondition(s.spcon_nochain)
	e:SetOperation(s.spop_nochain)
	return e,true
end
function s.e2(c)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_TO_GRAVE)
	e:SetCondition(s.regcon)
	e:SetOperation(s.regop)
	return e,true
end
function s.e3(c)
	local e=Effect.CreateEffect(c)
	e:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_CHAIN_SOLVED)
	e:SetCondition(s.spcon_chain)
	e:SetOperation(s.spop_chain)
	return e,true
end

function s.filter(c,p)
	return c:IsControler(p) and c:IsMonster()
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcon_nochain(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	return p==tp and eg:IsExists(s.filter,1,nil,1-p) and not Duel.IsChainSolving()
end
function s.spop_nochain(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.Group(aux.Necro(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.HintMessage(tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	return p==tp and eg:IsExists(s.filter,1,nil,1-p) and Duel.IsChainSolving()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id+100,RESET_CHAIN,0,1)
end
function s.spcon_chain(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id+100)>0
end
function s.spop_chain(e,tp,eg,ep,ev,re,r,rp)
	local n=Duel.GetFlagEffect(tp,id+100)
	Duel.ResetFlagEffect(tp,id+100)
	local ft=Duel.GetMZoneCountForMultipleSpSummon(tp)
	local g=Duel.Group(aux.Necro(s.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.HintMessage(tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,math.min(n,ft),nil)
		if #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end