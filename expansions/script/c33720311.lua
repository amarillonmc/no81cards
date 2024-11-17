--[[绝体绝命810！←超现实的曙光！
BranD-810! Surreal Dawn!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[When this card is activated: Banish X "BranD-810!" cards from your Deck (X is equal to the number of "BranD-810!" cards destroyed this turn up
	until this point +1), and if you do, during each Standby Phase, you can add 1 of the cards banished this way to your hand (This effect applies even if
	this card is no longer on the field.)]]
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE|CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(
		nil,
		nil,
		s.target,
		s.activate
	)
	c:RegisterEffect(e1)
	--[[If this card is sent from the field to the GY: You can Set a "BranD-810!" Field Spell, except "BranD-810! Mint Tears of Relief!" from your Deck
	in your Field Zone, but it cannot be activated this turn.]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetFunctions(s.setcon,nil,s.settg,s.setop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

local FLAG_BANISHED_BY_EFFECT = id
local PFLAG_COUNT_DESTROYED_CARDS = id

function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsSetCard,nil,ARCHE_BRAND_810)
	if ct>0 then
		if not Duel.PlayerHasFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS) then
			Duel.RegisterFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS,RESET_PHASE|PHASE_END,0,1,0)
		end
		Duel.UpdateFlagEffectLabel(0,PFLAG_COUNT_DESTROYED_CARDS,ct)
	end
end

--E1
function s.rmfilter(c)
	return c:IsSetCard(ARCHE_BRAND_810) and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.PlayerHasFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS) and Duel.GetFlagEffectLabel(0,PFLAG_COUNT_DESTROYED_CARDS)+1 or 1
	if chk==0 then
		return Duel.IsExists(false,s.rmfilter,tp,LOCATION_DECK,0,ct,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,ct,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.PlayerHasFlagEffect(0,PFLAG_COUNT_DESTROYED_CARDS) and Duel.GetFlagEffectLabel(0,PFLAG_COUNT_DESTROYED_CARDS)+1 or 1
	local g=Duel.Select(HINTMSG_REMOVE,false,tp,s.rmfilter,tp,LOCATION_DECK,0,ct,ct,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetGroupOperatedByThisEffect(e):Filter(Card.IsLocation,nil,LOCATION_REMOVED):Filter(Card.IsFaceup,nil)
		if #og==0 then return end
		local fid=e:GetFieldID()
		for tc in aux.Next(og) do
			tc:RegisterFlagEffect(FLAG_BANISHED_BY_EFFECT,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,fid,aux.Stringid(id,2))
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
		e1:OPT()
		e1:SetLabel(fid)
		e1:SetCondition(s.thcon)
		e1:SetOperation(s.thop)
		Duel.RegisterEffect(e1,tp)
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	if not Duel.IsExists(false,Card.HasFlagEffectLabel,tp,LOCATION_REMOVED,0,1,nil,FLAG_BANISHED_BY_EFFECT,fid) then
		e:Reset()
		return false
	end
	return true
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local fid=e:GetLabel()
	if not Duel.IsExists(false,s.thfilter,tp,LOCATION_REMOVED,0,1,nil,fid) or not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then return end
	Duel.Hint(HINT_CARD,tp,id)
	local g=Duel.Select(HINTMSG_ATOHAND,false,tp,s.thfilter,tp,LOCATION_REMOVED,0,1,1,nil,fid)
	if #g>0 then
		Duel.Search(g)
	end
end
function s.thfilter(c,fid)
	return c:HasFlagEffectLabel(FLAG_BANISHED_BY_EFFECT,fid) and c:IsAbleToHand()
end

--E2
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.setfilter(c)
	return c:IsSpell(TYPE_FIELD) and c:IsSetCard(ARCHE_BRAND_810) and not c:IsCode(id) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc and Duel.SSet(tp,sc,tp,false)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,5))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		sc:RegisterEffect(e1)
	end
end