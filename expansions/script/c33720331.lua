--[[数字的奴隶
Burden of Numbers
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id,o=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[Activate by paying half your LP. If a player(s) controls a monster with exactly 1337 ATK/DEF, or has exactly 1337 LP when this card resolves: Send all cards their opponent(s) controls and all
	cards in their opponent(s)'s hand and Extra Deck to the GY.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(aux.PayHalfLPCost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--[[If a player controls a monster with the highest Level/Rank/Link Rating on the field, and their monster attacks a monster, send that attacked monster to the GY before damage calculation.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetRange(LOCATION_FZONE)
	e2:SetFunctions(s.tgcon,nil,nil,s.tgop)
	c:RegisterEffect(e2)
	--[[If a player controls a monster with the highest ATK on the field, their opponent cannot activate cards or effects when that player Summons a monster(s).]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(s.limop)
	c:RegisterEffect(e3)
	e3:SpecialSummonEventClone(c)
	e3:FlipSummonEventClone(c)
	local e3x=Effect.CreateEffect(c)
	e3x:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3x:SetRange(LOCATION_FZONE)
	e3x:SetCode(EVENT_CHAIN_END)
	e3x:SetOperation(s.limop2)
	c:RegisterEffect(e3x)
	--[[If a player controls a monster with the highest DEF, cards they control cannot be destroyed by their opponent.]]
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.indcon(0))
	e4:SetValue(s.indval(1))
	c:RegisterEffect(e4)
	local e4x=e4:Clone()
	e4x:SetTargetRange(0,LOCATION_ONFIELD)
	e4x:SetCondition(s.indcon(1))
	e4x:SetValue(s.indval(0))
	c:RegisterEffect(e4x)
	--During the Standby Phase, the player with more LP draws 1 card, then they can pay half their LP, and if they do, they Set this card.
	local e5=Effect.CreateEffect(c)
	e5:Desc(2,id)
	e5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F|EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e5:SetRange(LOCATION_FZONE)
	e5:OPT()
	e5:SetCondition(s.drawcon)
	e5:SetTarget(s.drawtg)
	e5:SetOperation(s.drawop)
	c:RegisterEffect(e5)
end
--E1
function s.filter(c)
	return c:IsFaceup() and c:IsStats(1337,1337)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Group.CreateGroup()
	for p=0,1 do
		if Duel.GetLP(p)==1337 or Duel.IsExists(false,s.filter,p,LOCATION_MZONE,0,1,nil) then
			local g1=Duel.Group(Card.IsAbleToGrave,p,0,LOCATION_ONFIELD|LOCATION_HAND|LOCATION_EXTRA,nil)
			g:Merge(g1)
		end
	end
	if #g>0 then
		Duel.SetCardOperationInfo(g,LOCATION_ONFIELD|LOCATION_HAND|LOCATION_EXTRA)
	else
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,nil,1,PLAYER_ALL,LOCATION_ONFIELD|LOCATION_HAND|LOCATION_EXTRA)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	for p=0,1 do
		if Duel.GetLP(p)==1337 or Duel.IsExists(false,s.filter,p,LOCATION_MZONE,0,1,nil) then
			local g1=Duel.Group(Card.IsAbleToGrave,p,0,LOCATION_ONFIELD|LOCATION_HAND|LOCATION_EXTRA,nil)
			g:Merge(g1)
		end
	end
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--E2
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local a,b=Duel.GetAttacker(),Duel.GetAttackTarget()
	if not a or not b or not a:IsRelateToBattle() or not b:IsRelateToBattle() then return false end
	local g=Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local mg=g:GetMaxGroup(Card.GetRatingAuto)
	return mg:IsExists(Card.IsControler,1,nil,a:GetControler())
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local b=Duel.GetAttackTarget()
	if b and b:IsRelateToBattle() then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.SendtoGrave(b,REASON_EFFECT)
	end
end

--E3
function s.nsfilter(c,mg,p)
	return c:GetSummonPlayer()==p and mg:IsExists(Card.IsControler,1,nil,p)
end
function s.limop(e,tp,eg,ep,ev,re,r,rp)
	local ch=Duel.GetCurrentChain()
	if ch>1 then return end
	local g=Duel.Group(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local mg=g:GetMaxGroup(Card.GetAttack)
	if #mg>0 then
		local c=e:GetHandler()
		local p
		if eg:IsExists(s.nsfilter,1,nil,mg,tp) and eg:IsExists(s.nsfilter,1,nil,mg,1-tp) then
			p=0
		elseif eg:IsExists(s.nsfilter,1,nil,mg,tp) then
			p=1
		elseif eg:IsExists(s.nsfilter,1,nil,mg,1-tp) then
			p=2
		end
		
		if ch==0 then
			Duel.SetChainLimitTillChainEnd(s.chlim(p))
		elseif ch==1 then
			c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,1,p)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAINING)
			e1:SetOperation(s.resetop)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EVENT_BREAK_EFFECT)
			e2:SetReset(RESET_CHAIN)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	e:Reset()
end
function s.limop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(id)~=0 then
		Duel.SetChainLimitTillChainEnd(s.chlim(c:GetFlagEffectLabel(id)))
	end
	c:ResetFlagEffect(id)
end
function s.chlim(p)
	if p==0 then
		return aux.FALSE
	elseif p==1 then
		return	function(e,_rp,_tp)
					return _tp==_rp
				end
	elseif p==2 then
		return	function(e,_rp,_tp)
					return 1-_tp==_rp
				end
	end
end

--E4
function s.indcon(p)
	return	function(e)
				local g=Duel.Group(Card.IsFaceup,0,LOCATION_MZONE,LOCATION_MZONE,nil)
				local mg=g:GetMaxGroup(Card.GetDefense)
				return mg:IsExists(Card.IsControler,1,nil,math.abs(p-e:GetHandlerPlayer()))
			end
end
function s.indval(p)
	return	function(e,re,r,rp)
				return rp==math.abs(p-e:GetHandlerPlayer())
			end
end

--E5
function s.drawcon(e,tp,eg,ep,ev,re,r,rp)
	local lp1,lp2=Duel.GetLP(tp),Duel.GetLP(1-tp)
	return lp1>lp2
end
function s.drawtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabel(tp)
		return true
	end
	Duel.SetTargetParam(e:GetLabel())
end
function s.drawop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTargetParam()
	Duel.Hint(HINT_CARD,p,id)
	if Duel.Draw(p,1,REASON_EFFECT)>0 then
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsSSetable(true) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) and Duel.SelectYesNo(p,aux.Stringid(id,3)) then
			Duel.BreakEffect()
			Duel.PayLPCost(p,math.floor(Duel.GetLP(p)/2))
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,p,p,0)
		end
	end
end