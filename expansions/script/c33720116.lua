--[[
亡命骗徒 『意指群星』
Desperado Trickster - "Ad Astra"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	aux.RegisterDesperadoGeasGenerationEffect(c,id,EFFECT_FLAG_DELAY,nil,nil,s.e1)
end

function s.e1(c)
	local e=Effect.CreateEffect(c)
	e:SetDescription(aux.Stringid(id,2))
	e:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e:SetCode(EVENT_BATTLE_CONFIRM)
	e:SetCondition(s.reccon)
	e:SetOperation(s.recop)
	return e
end

function s.filter(c)
	return c:IsFaceup() and c:IsAttackAbove(c:GetBaseAttack()+1)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetBattleGroup()
	return g:IsExists(s.filter,1,nil)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetBattleGroup():Filter(s.filter,nil)
	local rec={0,0}
	for p=tp,1-tp,1-2*tp do
		local dg=g:Filter(Card.IsControler,nil,p)
		if #dg>0 then
			rec[2-p]=dg:GetSum(s.getdiff)
		end
	end
	Duel.Hint(HINT_CARD,tp,id)
	local p=Duel.GetTurnPlayer()
	if rec[p+1]>0 then
		Duel.Recover(p,rec[p+1],REASON_EFFECT,true)
	end
	if rec[2-p]>0 then
		Duel.Recover(1-p,rec[2-p],REASON_EFFECT,true)
	end
	Duel.RDComplete()
end
function s.getdiff(c)
	return math.abs(c:GetAttack()-c:GetBaseAttack())
end