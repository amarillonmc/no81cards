--[[
做成面包！
Breaded!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[Activate only during a turn in which your opponent has activated an effect that targeted you, or a card(s) you controlled, in your GY and/or in your banishment.
	Place 1 card your opponent controls face-up in their Spell & Trap Zone as a Continuous Spell, also replace its effect with the following one.
	● You can Tribute this card; gain 1200 LP.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetFunctions(s.condition,nil,s.target,s.activate)
	c:RegisterEffect(e1)
	--[[If a Continuous Spell that was placed by this card's effect leaves the field, destroy this card.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.descon)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.regop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS|EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetOperation(s.regop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.regop1(e,tp,eg,ep,ev,re,r,rp)
	local flags=re:GetProperty()
	local IsTargetsPlayer, IsTargetsCards = flags&EFFECT_FLAG_PLAYER_TARGET, flags&EFFECT_FLAG_CARD_TARGET
	if IsTargetsPlayer==0 and IsTargetsCards==0 then return end
	local tp,tg=Duel.GetChainInfo(Duel.GetCurrentChain(),CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_CARDS)
	if (IsTargetsPlayer>0 and tp and tp==1-rp) or (IsTargetsCards>0 and tg and tg:IsExists(s.checkfilter,1,nil,1-rp)) then
		Duel.RegisterFlagEffect(rp,id,RESET_CHAIN,0,1,ev)
	end
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	local chain_ct={Duel.GetFlagEffectLabel(rp,id)}
	for i=1,#chain_ct do
		if chain_ct[i]==ev then
			Duel.RegisterFlagEffect(rp,id+100,RESET_PHASE+PHASE_END,0,1)
			return
		end
	end
end
function s.checkfilter(c,p)
	return c:IsControler(p) and c:IsLocation(LOCATION_ONFIELD|LOCATION_GRAVE|LOCATION_REMOVED)
end

--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.PlayerHasFlagEffect(1-tp,id+100)
end
function s.pcfilter(c,p)
	return c:IsCanBePlacedOnField(p)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)>0 and Duel.IsExists(false,s.pcfilter,tp,0,LOCATION_MZONE|LOCATION_FZONE,1,nil,1-tp)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE,tp)<=0 then return end
	local tc=Duel.Select(HINTMSG_OPERATECARD,false,tp,s.pcfilter,tp,0,LOCATION_MZONE|LOCATION_FZONE,1,1,nil,1-tp):GetFirst()
	if tc then
		Duel.HintSelection(Group.FromCards(tc))
		local c=e:GetHandler()
		if Duel.PlaceAsContinuousCard(tc,tp,1-tp,c,TYPE_SPELL,aux.Stringid(id,1))>0 then
			tc:ReplaceEffect(CARD_CYBER_HARPIE_LADY,RESET_EVENT|RESETS_STANDARD)
			local e1=Effect.CreateEffect(tc)
			e1:Desc(2,id)
			e1:SetCategory(CATEGORY_RECOVER)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e1:SetRange(LOCATION_SZONE)
			e1:SetFunctions(nil,aux.TributeSelfCost,s.lptg,s.lpop)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if c:IsRelateToChain() then
				c:SetCardTarget(tc)
			end
		end	
	end
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

--E2
function s.dfilter(c,sg)
	return sg:IsContains(c)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCardTargetCount()==0 then return false end
	return c:GetCardTarget():IsExists(s.dfilter,1,nil,eg)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end