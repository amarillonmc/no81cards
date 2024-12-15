--[[
动物朋友 春之真·青龙
Anifriends Blue Dragon of Spring
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	--1 Tuner + 1 non-Tuner monster
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	--Cannot be Special Summoned, unless 3 or more monsters with different names were destroyed in the previous turn.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_COST)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e1:SetCost(s.spcost)
	c:RegisterEffect(e1)
	--[[Once per turn, at the start of the Battle Phase: Special Summon up to 2 monsters with different names from either player's GYs, but shuffle them into their owner's Decks at the end of that
	Battle Phase. If this card was Synchro Summoned using an "Anifriends" monster(s) as material, you can add those monsters to your hand instead.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(id,0)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE|PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:OPT()
	e3:SetLabelObject(e2)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		s.DestroyedGroup=Group.CreateGroup()
		s.DestroyedGroup:KeepAlive()
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:OPT()
		ge2:SetOperation(s.regop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.regfilter(c)
	return (c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)) or c:IsMonster()
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.regfilter,nil)
	if #g>0 then
		for c in aux.Next(g) do
			local code
			if c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) then
				code=c:GetPreviousCodeOnField()
			else
				code=c:GetCode()
			end
			c:RegisterFlagEffect(id,RESET_PHASE|PHASE_END,0,2,code)
		end
		s.DestroyedGroup:Merge(g)
	end
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	if s.DestroyedGroup:GetClassCount(Card.GetFlagEffectLabel,id)>=3 then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE|PHASE_END,0,1)
	end
	for c in aux.Next(s.DestroyedGroup) do
		c:ResetFlagEffect(id)
	end
	s.DestroyedGroup:Clear()
end

--E1
function s.spcost(e,c,tp,st)
	return Duel.PlayerHasFlagEffect(0,id)
end

--E2
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(aux.MonsterFilter(Card.IsSetCard,ARCHE_ANIFRIENDS),1,nil) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end

--E3
function s.filter(c,e,tp)
	return c:IsMonster() and (c:IsAbleToHand(tp) or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function s.thfilter(c,tp)
	return c:IsMonster() and c:IsAbleToHand(tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local lab=e:GetLabelObject():GetLabel()
	Duel.SetTargetParam(lab)
	if lab==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_TOHAND|CATEGORY_GRAVE_ACTION)
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE)
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,PLAYER_ALL,LOCATION_GRAVE)
	end
end
function s.gcheck(altcon)
	return	function(g,e,tp,mg,c)
				if not aux.dncheckbrk(g,e,tp,mg,c) then
					return false,true
				end
				local res=Duel.GetMZoneCount(tp)>=#g and (#g==1 or not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
					and not g:IsExists(aux.NOT(Card.IsCanBeSpecialSummoned),1,nil,e,0,tp,false,false)
				if not res and altcon then
					res=not g:IsExists(aux.NOT(Card.IsAbleToHand),1,nil,tp)
				end
				return res, not res
			end
end
function s.breakcon(altcon)
	return	function(g,e,tp,mg)
					return #g==1 and not altcon and (Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetMZoneCount(tp)==1)
				end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local altcon=Duel.GetTargetParam()==1
	local g=Duel.Group(aux.Necro(s.filter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if #g==0 then return end
	local tg=aux.SelectUnselectGroup(g,e,tp,1,2,s.gcheck(altcon),1,tp,HINTMSG_OPERATECARD,nil,s.breakcon(altcon))
	if #tg>0 then
		local b1=Duel.GetMZoneCount(tp)>=#tg and (#tg==1 or not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
			and not tg:IsExists(aux.NOT(Card.IsCanBeSpecialSummoned),1,nil,e,0,tp,false,false)
		local b2=altcon and not tg:IsExists(aux.NOT(Card.IsAbleToHand),1,nil,tp)
		if not b1 and not b2 then return end
		local opt=aux.Option(tp,id,1,b1,b2)
		if opt==0 then
			local fid=e:GetFieldID()
			for tc in aux.Next(tg) do
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
					tc:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE,0,1,fid)
				end
			end
			if Duel.SpecialSummonComplete()>0 then
				tg:KeepAlive()
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE|PHASE_BATTLE)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetLabel(fid)
				e2:SetLabelObject(tg)
				e2:SetCondition(s.retcon)
				e2:SetOperation(s.retop)
				Duel.RegisterEffect(e2,tp)
			end
		elseif opt==1 then
			Duel.SendtoHand(tg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	if not tg or not tg:IsExists(Card.HasFlagEffectLabel,1,nil,id+100,e:GetLabel()) then
		if tg then
			tg:DeleteGroup()
		end
		e:Reset()
		return false
	else
		return true
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end