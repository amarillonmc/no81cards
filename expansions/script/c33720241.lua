--[[
花花变身·动物朋友 ～My Pace Chaser～
H-Anifriends - My Pace Chaser
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--This card's name becomes "Anifriends Raccoon & Fennec" while on the field or in the GY.
	aux.EnableChangeCode(c,33700073,LOCATION_MZONE|LOCATION_GRAVE)
	--[[You can discard this card; banish 2 "Anifriends" monsters with different names from your Deck, and if you do, add the cards you banished with this effect to your hand
	during your opponent's next Standby Phase.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetFunctions(nil,aux.DiscardSelfCost,s.target,s.operation)
	c:RegisterEffect(e1)
	--[[If 4 or more cards with different names have been destroyed by your opponent's cards (either by battle or card effect) this turn:
	You can Special Summon this card from your hand or GY, and if you do, all monsters your opponent currently controls lose 800 ATK/DEF for each card with a different name
	that was destroyed this turn.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(2,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORIES_ATKDEF)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e2:SetFunctions(s.spcon,nil,s.sptg,s.spop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_DESTROY)
		ge:SetOperation(s.regop)
		Duel.RegisterEffect(ge,0)
	end
end

local FLAG_TRACK_DIFFERENT_NAMES	   = id

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsReason(REASON_BATTLE|REASON_EFFECT) then
			local code=tc:GetCode()
			local p=tc:GetReasonPlayer()
			if not Duel.PlayerHasFlagEffect(p,FLAG_TRACK_DIFFERENT_NAMES) then
				local fe=Effect.GlobalEffect()
				fe:SetType(EFFECT_TYPE_FIELD)
				fe:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_PLAYER_TARGET)
				fe:SetCode(EFFECT_FLAG_EFFECT|FLAG_TRACK_DIFFERENT_NAMES)
				fe:SetTargetRange(1,0)
				fe:SetLabel(code)
				fe:SetReset(RESET_PHASE|PHASE_END)
				Duel.RegisterEffect(fe,p)
			else
				local fe=Duel.IsPlayerAffectedByEffect(p,EFFECT_FLAG_EFFECT|FLAG_TRACK_DIFFERENT_NAMES)
				local labels={fe:GetLabel()}
				if not aux.FindInTable(labels,code) then
					fe:SetSpecificLabel(code,#labels+1)
				end
			end
		end
	end
end

--E1
function s.rmfilter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(s.rmfilter,tp,LOCATION_DECK,0,nil)
		return g:CheckSubGroup(aux.dncheck,2,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.rmfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if #rg==2 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og==0 then return end
		local chk=Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()<PHASE_STANDBY and 1 or 0
		local rct=Duel.GetNextPhaseCount(PHASE_STANDBY,1-tp)
		local eid=e:GetFieldID()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY|RESET_OPPO_TURN,EFFECT_FLAG_CLIENT_HINT,rct,eid,aux.Stringid(id,1))
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:Desc(3,id)
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
		e1:OPT()
		e1:SetLabel(chk,Duel.GetTurnCount(),eid)
		e1:SetLabelObject(og)
		e1:SetCondition(s.thcon)
		e1:SetOperation(s.thop)
		e1:SetReset(RESET_PHASE|PHASE_STANDBY|RESET_OPPO_TURN,rct)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=1-tp then return false end
	local turncount=Duel.GetTurnCount()
	local chk,tct,eid=e:GetLabel()
	local g=e:GetLabelObject()
	if not g or g:FilterCount(Card.HasFlagEffectLabel,nil,id,eid)==0 then
		if g then
			g:DeleteGroup()
		end
		e:Reset()
		return false
	end
	return (chk==1 and turncount==tct) or (chk==0 and turncount>tct)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local _,_,eid=e:GetLabel()
	local g=e:GetLabelObject()
	if not g then return end
	local tg=g:Filter(Card.HasFlagEffectLabel,nil,id,eid)
	if #tg>0 then
		Duel.Search(tg)
	end
end

--E2
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local fe=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_FLAG_EFFECT|FLAG_TRACK_DIFFERENT_NAMES)
	if not fe then return false end
	local labels={fe:GetLabel()}
	return #labels>=4
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetCardOperationInfo(c,CATEGORY_SPECIAL_SUMMON)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local fe=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_FLAG_EFFECT|FLAG_TRACK_DIFFERENT_NAMES)
	local labels={fe:GetLabel()}
	local ct=#labels
	Duel.SetCustomOperationInfo(0,CATEGORIES_ATKDEF,g,#g,0,0,-800*ct)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local fe=Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_FLAG_EFFECT|FLAG_TRACK_DIFFERENT_NAMES)
		local labels={fe:GetLabel()}
		local val=#labels*-800
		for tc in aux.Next(g) do
			tc:UpdateATKDEF(val,val,true,{c,true})
		end
	end
end