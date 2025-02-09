--[[
动物朋友 白蛇
Anifriends Byakuda
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")

local FLAG_BYAKUDA_RECORDED_NAMES	= id
local FLAG_DELAYED_EVENT			= id+100
local FLAG_SIMULT_CHECK				= id+200
local FLAG_SIMULT_EXCLUDE			= id+300

local PFLAG_BYAKUDA_SUMMON_COUNT 	= id
local PFLAG_BYAKUDA_TEMPORARY_NAMES	= id+100

function s.initial_effect(c)
	c:EnableReviveLimit()
	--1 Tuner + 1 non-Tuner monster
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	--[[If this card is Synchro Summoned, and this is the first time the original "Anifriends Byakuda" is Synchro Summoned in this Duel: Record the name of the non-Tuner monster on all "Anifriends
	Byakuda" you own for the rest of this Duel.]]
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetLabel(0)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(id,0)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetLabelObject(e0)
	e1:SetFunctions(s.reccon,nil,s.rectg,s.recop)
	c:RegisterEffect(e1)
	local hint=Effect.CreateEffect(c)
	hint:SetDescription(id,1)
	hint:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
	hint:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	hint:SetCode(EVENT_MOVE)
	hint:SetFunctions(s.hintcon,nil,nil,s.hintop)
	c:RegisterEffect(hint)
	--[[You cannot Summon monsters, except monsters whose name is recorded on this card, also send to the GY all other cards you control, except cards whose name recorded on this card.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(s.hasRecordedNamesCond)
	e2:SetTarget(s.sumlimit)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e2a)
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e2b)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.hasRecordedNamesCond)
	e3:SetOperation(s.adjustop)
	c:RegisterEffect(e3)
	--This card, and cards on the field whose name is recorded on this card, are unaffected by card effects, except their own.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(s.imtg)
	e4:SetValue(s.imval)
	c:RegisterEffect(e4)
	--[[If this card is in your GY, and a monster(s) whose name is recorded on this card is sent to the GY: Special Summon this card, and if you do, Special Summon that monster(s).]]
	aux.RegisterMergedDelayedEventGlitchy(c,id,EVENT_TO_GRAVE,s.cfilter,FLAG_DELAYED_EVENT,LOCATION_GRAVE,nil,LOCATION_GRAVE,nil,FLAG_SIMULT_CHECK,true)
	local e5=Effect.CreateEffect(c)
	e5:Desc(1,id)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_CUSTOM+id)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetFunctions(nil,nil,s.sptg,s.spop)
	c:RegisterEffect(e5)
	if not s.global_check then
		s.global_check=true
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge:SetOperation(s.regop)
		Duel.RegisterEffect(ge,0)
		for p=0,1 do
			local hint2=Effect.CreateEffect(c)
			hint2:Desc(2,id)
			hint2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
			hint2:SetCode(EVENT_FREE_CHAIN)
			hint2:SetCountLimit(10)
			hint2:SetCondition(s.hasRecordedNamesCond)
			hint2:SetOperation(s.hintop2)
			Duel.RegisterEffect(hint2,p)
		end
	end
end
function s.regfilter(c)
	return c:IsFaceup() and c:IsSynchroSummoned() and c:IsOriginalCode(id)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(s.regfilter,1,nil) then
		Duel.RegisterFlagEffect(0,PFLAG_BYAKUDA_SUMMON_COUNT,0,0,1)
	end
end

function s.hintop2(e,tp,eg,ep,ev,re,r,rp)
	local G=Group.CreateGroup()
	local g=Duel.Group(Card.HasFlagEffect,tp,LOCATION_ALL,LOCATION_ALL,nil,FLAG_BYAKUDA_RECORDED_NAMES)+Duel.GetXyzMaterialGroup(tp,1,1,nil,Card.HasFlagEffect,FLAG_BYAKUDA_RECORDED_NAMES)
	for tc in aux.Next(g) do
		local fe=tc:GetFlagEffectWithSpecificLabel(FLAG_BYAKUDA_RECORDED_NAMES)
		local codes={fe:GetLabel()}
		for _,code in ipairs(codes) do
			local temp=Duel.CreateToken(tp,code)
			G:AddCard(temp)
		end
	end
	if #G>0 then
		G:Select(tp,0,#G,nil)
	end
	Duel.Exile(G,REASON_RULE)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end

--E0
function s.valcheck(e,c)
	local g=c:GetMaterial():Filter(aux.NOT(Card.IsSynchroType),nil,TYPE_TUNER)
	if #g>0 then
		local alreadyInsertedCodes={}
		local groupCodes={}
		for tc in aux.Next(g) do
			for _,code in ipairs({tc:GetCode()}) do
				if not alreadyInsertedCodes[code] then
					alreadyInsertedCodes[code]=true
					table.insert(groupCodes,code)
				end
			end
		end
		e:SetLabel(table.unpack(groupCodes))
	else
		e:SetLabel(0)
	end
end

--E1
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSynchroSummoned() and Duel.GetFlagEffect(0,PFLAG_BYAKUDA_SUMMON_COUNT)==0
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ch=Duel.GetCurrentChain()
	local codes={e:GetLabelObject():GetLabel()}
	local fe=Duel.RegisterFlagEffect(tp,PFLAG_BYAKUDA_TEMPORARY_NAMES,RESET_CHAIN,0,1)
	fe:SetLabel(ch,table.unpack(codes))
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(Card.IsCode,tp,LOCATION_ALL,0,nil,id)+Duel.GetXyzMaterialGroup(tp,1,0,nil,Card.IsCode,id)
	if #g==0 then return end
	local fe=Duel.GetFlagEffectWithSpecificLabel(tp,PFLAG_BYAKUDA_TEMPORARY_NAMES,Duel.GetCurrentChain())
	if not fe then return end
	local codes={fe:GetLabel()}
	table.remove(codes,1)
	for tc in aux.Next(g) do
		local recflag=tc:RegisterFlagEffect(FLAG_BYAKUDA_RECORDED_NAMES,0,0,1)
		recflag:SetLabel(table.unpack(codes))
		if tc:IsFaceup() and tc:IsOnField() then
			tc:SetHint(CHINT_CARD,codes[1])
		end
	end
end

--HINT
function s.hintcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsOnField() and not c:IsPreviousLocation(LOCATION_ONFIELD) and c:HasFlagEffect(FLAG_BYAKUDA_RECORDED_NAMES)
end
function s.hintop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fe=c:GetFlagEffectWithSpecificLabel(FLAG_BYAKUDA_RECORDED_NAMES)
	local code=fe:GetLabel()
	c:SetHint(CHINT_CARD,code)
end

--E2
function s.hasRecordedNamesCond(e)
	return e:GetHandler():HasFlagEffect(FLAG_BYAKUDA_RECORDED_NAMES)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	local fe=e:GetHandler():GetFlagEffectWithSpecificLabel(FLAG_BYAKUDA_RECORDED_NAMES)
	return not c:IsCode(fe:GetLabel())
end

--E3
function s.recfilter(c,...)
	return c:IsFacedown() or not c:IsCode(...)
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local c=e:GetHandler()
	local fe=c:GetFlagEffectWithSpecificLabel(FLAG_BYAKUDA_RECORDED_NAMES)
	local g=Duel.GetMatchingGroup(s.recfilter,tp,LOCATION_ONFIELD,0,c,fe:GetLabel())
	local readjust=false
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE,tp)
		readjust=true
	end
	if readjust then Duel.Readjust() end
end

--E4
function s.imtg(e,c)
	local h=e:GetHandler()
	if c==h then return true end
	local fe=h:GetFlagEffectWithSpecificLabel(FLAG_BYAKUDA_RECORDED_NAMES)
	return fe and c:IsCode(fe:GetLabel())
end
function s.imval(e,te,c)
	local tec=te:GetOwner()
	return tec~=c and tec~=e:GetHandler()
end

--E5
function s.cfilter(c,e)
	if not c:IsMonster() then return false end
	local fe=e:GetHandler():GetFlagEffectWithSpecificLabel(FLAG_BYAKUDA_RECORDED_NAMES)
	return fe and c:IsCode(fe:GetLabel())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local sg=aux.SelectSimultaneousEventGroup(eg,tp,FLAG_SIMULT_CHECK,1,e,FLAG_SIMULT_EXCLUDE)
	if sg then
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg+c,#sg+1,tp,LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,LOCATION_GRAVE)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	local c=e:GetHandler()
	local g=Duel.GetTargetCards()
	if c:IsRelateToChain() and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) and g and #g>0 then
		local ft=Duel.GetMZoneCount(tp)
		if ft>0 then
			if #g>ft then
				Duel.HintMessage(tp,HINTMSG_SPSUMMON)
				g=g:Select(tp,ft,ft,nil)
			end
			for tc in aux.Next(g) do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
	Duel.SpecialSummonComplete()
end