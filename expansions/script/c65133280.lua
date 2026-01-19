--幻叙工房 姬特
local s,id,o=GetID()
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
local MATCH_MODE=KOISHI_CHECK and Duel.GetRegistryValue("duel_mode")=="match"
function s.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	--equip and copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_END_PHASE)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.eop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		if not s.match_summons then s.match_summons={} end
		if MATCH_MODE and Duel.GetRegistryValue("Kitt_Summon")then
			s.load_match_data_string(Duel.GetRegistryValue("Kitt_Summon"))
		else
			--s.load_match_data_string("65711558")
		end
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end

function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local code=tc:GetOriginalCode()
		s.match_summons[code]=true
	end
	Duel.SetRegistryValue("Kitt_Summon",s.get_match_data_string())
end
function s.get_match_data_string()
	local codes={}
	for code,_ in pairs(s.match_summons) do
		table.insert(codes,tostring(code))
	end
	return table.concat(codes,",")
end
function s.load_match_data_string(str)
	if not str or str=="" then return end
	for code_str in string.gmatch(str, "[^,]+") do
		local code=tonumber(code_str)
		if code then
			s.match_summons[code]=true
		end
	end
end
function s.lcheck(g,lc,sumtype,tp)
	return g:GetClassCount(Card.GetRace)==#g
end
function s.eqfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden() 
		and (s.match_summons[c:GetCode()] or s.match_summons[c:GetOriginalCode()])
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK+LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToChain() then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK+LOCATION_EXTRA,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		Duel.MajesticCopy(c,tc)
		--Link Summon Lock
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		e2:SetTarget(s.splimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end

function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return (sumtype&SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function s.efilter(c)
	return c:GetFlagEffect(id)>0
end
function s.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetEquipGroup():Filter(s.efilter,nil)
	for tc in aux.Next(g) do
		Duel.MajesticCopy(c,tc)
	end
end