--[[
启明败退！
Lodestar - Defeated!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Tribute 1 monster; your opponent reveals their hand, also banish all monsters they control and in their hand with a DEF lower than the Tributed monster's ATK,
	also, until the end of your opponent's next turn, your opponent cannot activate cards or effects in response to the activation of your card effects,
	also if they would add a card(s) from their Deck or GY to their hand, they add that many cards from the top of your Deck to their hand, instead.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetFunctions(nil,aux.DummyCost,s.target,s.operation)
	c:RegisterEffect(e1)
	--During your opponent's turn, if they inflicted 2000 or more damage to you this turn, you can activate this card from your hand.
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
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		
		local _Draw = Duel.Draw
		
		function Duel.Draw(p,val,r)
			if Duel.PlayerHasFlagEffect(p,id+100) then
				local g=Duel.GetDecktopGroup(1-p,val):Filter(aux.excthfilter,nil,p)
				if #g==val then
					Duel.DisableShuffleCheck()
					Duel.SendtoHand(g,p,REASON_EFFECT)
					return 0
				end
			end
			return _Draw(p,val,r)
		end
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if rp==1-ep then
		if not Duel.PlayerHasFlagEffect(rp,id) then
			Duel.RegisterFlagEffect(rp,id,RESET_PHASE|PHASE_END,0,1)
		end
		Duel.UpdateFlagEffectLabel(rp,id,ev)
	end
end

--E1
function s.relfilter(c,tp)
	return Duel.IsExists(false,s.rmfilter,tp,0,LOCATION_MZONE,1,c,c:GetAttack()-1)
end
function s.rmfilter(c,atk)
	return (c:IsFaceup() or (c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:IsMonster())) and c:IsDefenseBelow(atk) and c:IsAbleToRemove()
end
function s.rmfilter2(c,atk)
	return (c:IsFaceup() or (c:IsLocation(LOCATION_HAND) and c:IsMonster())) and c:IsDefenseBelow(atk) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local hand=Duel.GetHand(1-tp)
	local f=not hand:IsExists(aux.NOT(Card.IsPublic),1,nil) and s.relfilter or nil
	if chk==0 then
		if not e:IsCostChecked() then return false end
		return Duel.IsPlayerCanRemove(tp) and Duel.CheckReleaseGroup(tp,f,1,nil,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,f,1,1,nil,tp)
	local atk=rg:GetFirst():GetAttack()
	if Duel.Release(rg,REASON_COST)>0 then
		Duel.SetTargetParam(atk)
	end
	local g=Duel.Group(s.rmfilter,tp,0,LOCATION_MZONE|LOCATION_HAND,nil,atk-1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,LOCATION_MZONE|LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local hand=Duel.GetHand(1-tp)
	if #hand>0 then Duel.ConfirmCards(tp,hand) end
	local atk=Duel.GetTargetParam()
	if atk and atk>0 then
		local g=Duel.Group(s.rmfilter2,tp,0,LOCATION_MZONE|LOCATION_HAND,nil,atk-1)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	local c=e:GetHandler()
	local rct=Duel.GetNextPhaseCount(nil,1-tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(s.chainop)
	e1:SetReset(RESET_PHASE|PHASE_END|RESET_OPPO_TURN,rct)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:Desc(2,id)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	e2:SetReset(RESET_PHASE|PHASE_END|RESET_OPPO_TURN,rct)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterHint(1-tp,id+100,PHASE_END|RESET_SELF_TURN,rct,id,3)
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		Duel.SetChainLimit(function(eff,efp,trp)
			return trp==efp
		end)
	end
end

function s.repfilter(c,p)
	return c:IsControler(p) and c:IsLocation(LOCATION_DECK|LOCATION_GRAVE) and c:GetDestination()==LOCATION_HAND and c:IsAbleToHand()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:FilterCount(s.repfilter,nil,1-tp)
	local g=Duel.GetDecktopGroup(tp,ct):Filter(aux.excthfilter,nil,1-tp)
	if chk==0 then return ct>0 and #g==ct end
	local ct=eg:FilterCount(s.repfilter,nil,1-tp)
	e:SetLabel(ct)
	return true
end
function s.repval(e,c)
	return s.repfilter(c,1-e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetDecktopGroup(tp,ct):Filter(aux.excthfilter,nil,1-tp)
	if #g==ct then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
	end
end

--E2
function s.handcon(e)
	local p=1-e:GetHandlerPlayer()
	return Duel.PlayerHasFlagEffect(p,id) and Duel.GetFlagEffectLabel(p,id)>=2000
end
