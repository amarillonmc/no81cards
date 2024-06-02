--[[
朦胧微波炉
Foggy Microwave
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Cannot be Tributed or used as a material for a Special Summon from the Extra Deck.]]
	aux.CannotBeTributeOrMaterial(c)
	--[[If a player would Normal or Special Summon a monster(s), OR if they activate a card or effect, OR if they declare an attack (Quick Effect): That player tosses a coin. If the result is Tails, negate that Summon, activation, or attack.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON|CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_QUICK_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(aux.NegateSummonCondition)
	e1:SetTarget(s.dstg)
	e1:SetOperation(s.dsop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:Desc(1,id)
	e3:SetCategory(CATEGORY_NEGATE|CATEGORY_COIN)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP|EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:Desc(2,id)
	e4:SetCategory(CATEGORY_COIN)
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(s.daop)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
	--If this card is destroyed, the turn player gains 2000 LP.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetOperation(s.recop)
	c:RegisterEffect(e5)
end
s.toss_coin=true

--E1
function s.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.dsop(e,tp,eg,ep,ev,re,r,rp)
	local coin=Duel.TossCoin(ep,1)
	if coin==COIN_TAILS then
		Duel.NegateSummon(eg)
	end
end

--E3
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:GetOwner():GetOriginalCode()~=id
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local coin=Duel.TossCoin(ep,1)
	if coin==COIN_TAILS then
		Duel.NegateActivation(ev)
	end
end

--E4
function s.daop(e,tp,eg,ep,ev,re,r,rp)
	local coin=Duel.TossCoin(ep,1)
	if coin==COIN_TAILS then
		Duel.NegateAttack()
	end
end

--E5
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Recover(Duel.GetTurnPlayer(),2000,REASON_EFFECT)
end