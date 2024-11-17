--[[
DAISUKE
DAISUKE
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--If the only monster you control is face-up: Gain LP equal to the ATK of that monster.
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(s.condition,nil,s.target,s.activate)
	c:RegisterEffect(e1)
	--[[During the End Phase of the turn this card was activated, if the only monster you control is 1 monster with the same name as the monster you controlled when this card was activated: Add this
	card from your GY to your hand.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(2,id)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE|PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:OPT()
	e2:SetFunctions(s.thcon,nil,s.thtg,s.thop)
	c:RegisterEffect(e2)
end
--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==1 and g:GetFirst():IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):GetFirst()
	if chk==0 then return tc:GetAttack()>0 end
	local fe=e:GetHandler():RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD_EXC_GRAVE|RESET_PHASE|PHASE_END,EFFECT_FLAG_OATH|EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	fe:SetLabel(tc:GetCode())
	Duel.SetTargetCard(tc)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,tc:GetAttack())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() then
		Duel.Recover(Duel.GetTargetPlayer(),tc:GetAttack(),REASON_EFFECT)
	end
end

--E2
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:HasFlagEffect(id) then return false end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	if not (#g==1 and tc:IsFaceup()) then return false end
	local eset={c:IsHasEffect(EFFECT_FLAG_EFFECT|id)}
	for _,ce in ipairs(eset) do
		if tc:IsCode(ce:GetLabel()) then
			return true
		end
	end
	return false
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end