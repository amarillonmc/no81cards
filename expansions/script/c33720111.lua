--[[
亡命骗徒 『故人何在』
Desperado Trickster - "Ubi Sunt"
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
	e:SetCode(EVENT_BATTLE_DESTROYED)
	e:SetCondition(s.damcon)
	e:SetOperation(s.damop)
	return e
end

function s.filter(c,p)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousDefenseOnField()>0
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter,1,nil)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil)
	local dam={0,0}
	for p=tp,1-tp,1-2*tp do
		local dg=g:Filter(Card.IsReasonPlayer,nil,p)
		if #dg>0 then
			dam[p+1]=dg:GetSum(Card.GetPreviousDefenseOnField)
		end
	end
	Duel.Hint(HINT_CARD,tp,id)
	local p=Duel.GetTurnPlayer()
	if dam[p+1]>0 then
		Duel.Damage(p,dam[p+1],REASON_EFFECT,true)
	end
	if dam[2-p]>0 then
		Duel.Damage(1-p,dam[2-p],REASON_EFFECT,true)
	end
	Duel.RDComplete()
end
