--[[
纯洁败退！
Purity - Defeated!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Tribute 1 monster; send all non-Token monsters your opponent controls to the GY, and if you do, destroy all Tokens they control, and if you do that,
	inflict damage to your opponent equal to the number of Tokens destroyed this way x the ATK of the Tributed monster.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_DAMAGE|CATEGORY_TOGRAVE|CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetFunctions(nil,aux.DummyCost,s.target,s.operation)
	c:RegisterEffect(e1)
	--During your opponent's turn, if they Special Summoned 2 or more Tokens this turn, you can activate this card from your hand.
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_TOKEN)
	for tc in aux.Next(g) do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE|PHASE_END,0,1)
	end
end

--E1
function s.relfilter(c,tp)
	return Duel.IsExists(false,s.ntkfilter,tp,0,LOCATION_MZONE,1,c,c,tp)
end
function s.ntkfilter(c,rel,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToGrave() and (not tp or Duel.IsExists(false,Card.IsType,tp,0,LOCATION_MZONE,1,Group.FromCards(rel,c),TYPE_TOKEN))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:IsCostChecked() and Duel.CheckReleaseGroup(tp,s.relfilter,1,nil,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,s.relfilter,1,1,nil,tp)
	local atk=rg:GetFirst():GetAttack()
	if Duel.Release(rg,REASON_COST)>0 then
		Duel.SetTargetParam(atk)
	end
	local ntkg=Duel.Group(s.ntkfilter,tp,0,LOCATION_MZONE,nil)
	local tkg=Duel.Group(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_TOKEN)
	Duel.SetCardOperationInfo(ntkg,CATEGORY_TOGRAVE)
	Duel.SetCardOperationInfo(tkg,CATEGORY_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,#tkg*atk)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ntkg=Duel.Group(s.ntkfilter,tp,0,LOCATION_MZONE,nil)
	if #ntkg>0 and Duel.SendtoGrave(ntkg,REASON_EFFECT)>0 and ntkg:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) then
		local tkg=Duel.Group(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_TOKEN)
		if #tkg>0 and Duel.Destroy(tkg,REASON_EFFECT)>0 then
			local atk=Duel.GetTargetParam()
			if not atk or atk<=0 then return end
			local ct=Duel.GetGroupOperatedByThisEffect(e):GetCount()
			if ct>0 then
				Duel.Damage(1-tp,ct*atk,REASON_EFFECT)
			end
		end
	end
end

--E2
function s.handcon(e)
	return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),id)>=2
end
