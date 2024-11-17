--[[
动物朋友 招财猫
Anifriends Maneki-Neko
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	c:EnableReviveLimit()
	--1 Tuner + 1 non-Tuner monster
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	--[[If this card is Synchro Summoned: You can pay 3000 LP X times, or discard X cards (you can only pay each cost once per Duel), then target 1 "Anifriends" monster you control; add, from your
	Deck to your hand, X "Anifriends" monster(s) matching at least 2 of these criteria with that target.
	● Same Attribute
	● Same Type
	● Lower or equal ATK
	● Higher or equal DEF. ]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetFunctions(aux.SynchroSummonedCond,aux.DummyCost,s.thtg,s.thop)
	c:RegisterEffect(e1)
end

local PFLAG_PAID_LP = id
local PFLAG_DISCARDED_CARDS = id+100
--E1
function s.thfilter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsAbleToHand()
end
function s.filter(c,g,ct)
	return c:IsFaceup() and c:IsSetCard(ARCHE_ANIFRIENDS) and g:IsExists(s.matchfilter,ct,nil,c:GetAttribute(),c:GetRace(),c:GetAttack(),c:GetDefense())
end
function s.matchfilter(c,attr,race,atk,def)
	local ct=0
	if c:IsAttribute(attr) then ct=ct+1 end
	if c:IsRace(race) then
		ct=ct+1
		if ct==2 then
			return true
		end
	end
	if c:IsAttackBelow(atk) then
		ct=ct+1
		if ct==2 then
			return true
		end
	end
	if c:IsDefenseAbove(def) then
		ct=ct+1
		if ct==2 then
			return true
		end
	end
	return false
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=not Duel.PlayerHasFlagEffect(tp,PFLAG_PAID_LP) and Duel.CheckLPCost(tp,3000)
	local b2=not Duel.PlayerHasFlagEffect(tp,PFLAG_DISCARDED_CARDS) and Duel.IsExists(false,Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	local g=Duel.Group(s.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		return #g>0 and e:IsCostChecked() and (b1 or b2) and Duel.IsExists(true,s.filter,tp,LOCATION_MZONE,0,1,nil,g,1)
	end
	local X=0
	local nums={1}
	local opt=aux.Option(tp,id,1,b1,b2)
	if opt==0 then
		for i=2,#g do
			if Duel.CheckLPCost(tp,3000*i) and Duel.IsExists(true,s.filter,tp,LOCATION_MZONE,0,1,nil,g,i) then
				table.insert(nums,i)
			else
				break
			end
		end
		X=Duel.AnnounceNumber(tp,table.unpack(nums))
		Duel.PayLPCost(tp,X*3000)
		Duel.RegisterFlagEffect(tp,PFLAG_PAID_LP,0,0,0)
	elseif opt==1 then
		local dg=Duel.Group(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
		for i=2,#dg do
			if Duel.IsExists(true,s.filter,tp,LOCATION_MZONE,0,1,nil,g,i) then
				table.insert(nums,i)
			else
				break
			end
		end
		X=Duel.AnnounceNumber(tp,table.unpack(nums))
		Duel.DiscardHand(tp,Card.IsDiscardable,X,X,REASON_COST|REASON_DISCARD,nil)
		Duel.RegisterFlagEffect(tp,PFLAG_DISCARDED_CARDS,0,0,0)
	end
	Duel.SetTargetParam(X)
	Duel.Select(HINTMSG_TARGET,true,tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,g,X)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() and tc:IsFaceup() and tc:IsSetCard(ARCHE_ANIFRIENDS) and tc:IsControler(tp) then
		local X=Duel.GetTargetParam()
		local g=Duel.Group(s.thfilter,tp,LOCATION_DECK,0,nil)
		local attr,race,atk,def=tc:GetAttribute(),tc:GetRace(),tc:GetAttack(),tc:GetDefense()
		if not g:IsExists(s.matchfilter,X,nil,attr,race,atk,def) then return end
		Duel.HintMessage(tp,HINTMSG_ATOHAND)
		local tg=g:FilterSelect(tp,s.matchfilter,X,X,nil,attr,race,atk,def)
		if #tg>0 then
			Duel.Search(tg)
		end
	end
end