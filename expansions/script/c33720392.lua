--[[
为幸福而战
Fighting for Happiness
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	aux.AddEquipSpellEffect(c,true,true,Card.IsFaceup,nil)
	--[[Destroy this card if you have more LP than your opponent does.]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon)
	c:RegisterEffect(e1)
	--[[If the equipped monster inflicts battle damage to your opponent: At the end of this Battle Phase, draw 1 card for every 800 points of difference between your LP and your opponent's.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetFunctions(s.regcon,nil,s.regtg,s.regop)
	c:RegisterEffect(e2)
end
--E1
function s.sdcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end

--E2
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local cet=e:GetHandler():GetEquipTarget()
	return cet and ep==1-tp and eg:GetFirst()==cet
end
function s.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_BATTLE)
	e1:OPT()
	e1:SetOperation(s.drawop)
	e1:SetReset(RESET_PHASE|PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local val=math.floor(math.abs(Duel.GetLP(0)-Duel.GetLP(1))/800)
	if val>0 then
		Duel.Draw(tp,val,REASON_EFFECT)
	end
end