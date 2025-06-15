--[[
快乐呼唤！
Happily Called!
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--[[During the End Phase of the turn this card is activated, if you have Summoned monsters with the same name 3 or more times this turn, take 1 monster from your Deck with the same Attribute/Type OR ATK/DEF as those monsters, and either add that monster to your hand, or Special Summon it. (If you have Summoned multiple monsters with the same name 3 or more times this turn, choose one of them for this effect's resolution.)]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetFunctions(
		nil,
		nil,
		s.target,
		s.activate
	)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		s.StatsTable={{},{}}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.regop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.GlobalEffect()
		ge4:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_TURN_END)
		ge4:OPT()
		ge4:SetOperation(s.resetop)
		Duel.RegisterEffect(ge4,0)
	end
end

local FLAG_WAS_IN_SAME_SUMMON   = id
local FLAG_VALID_CODE   		= id+100

function s.regfilter(c,p)
	return c:IsFaceup() and c:IsSummonPlayer(p)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local tp=p+1
		local g=eg:Filter(s.regfilter,nil,p)
		for tc in aux.Next(g) do
			local codes={tc:GetCode()}
			for _,code in ipairs(codes) do
				if not s.StatsTable[tp][code] then s.StatsTable[tp][code]={0,0,{},{},0,0} end
				local attr,race,atk,def=tc:GetAttribute(),tc:GetRace(),tc:GetAttack(),tc:GetDefense()
				s.StatsTable[tp][code][1] = s.StatsTable[tp][code][1]|attr
				s.StatsTable[tp][code][2] = s.StatsTable[tp][code][2]|race
				table.insert(s.StatsTable[tp][code][3],atk)
				table.insert(s.StatsTable[tp][code][4],def)
				if not Duel.PlayerHasFlagEffectLabel(p,FLAG_WAS_IN_SAME_SUMMON,code) then
					s.StatsTable[tp][code][5] = s.StatsTable[tp][code][5]+1
					if s.StatsTable[tp][code][5]>=3 then
						Duel.RegisterFlagEffect(p,FLAG_VALID_CODE,RESET_PHASE|PHASE_END,0,1,code)
					end
					Duel.RegisterFlagEffect(p,FLAG_WAS_IN_SAME_SUMMON,RESET_PHASE|PHASE_END,0,1,code)
				end
			end
		end
		Duel.ResetFlagEffect(p,FLAG_WAS_IN_SAME_SUMMON)
	end
end
function s.resetop(e,tp,eg,ep,ev,re,r,rp)
	aux.ClearTableRecursive(s.StatsTable)
end

--E1
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:OPT()
	e1:SetCondition(s.efcon)
	e1:SetOperation(s.efop)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.efcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.PlayerHasFlagEffect(tp,FLAG_VALID_CODE)
end
function s.filter(c,e,tp,ft,codes)
	if not (c:IsMonster() and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))) then return false end
	for _,code in ipairs(codes) do
		local tab=s.StatsTable[tp+1][code]
		if tab then
			local attr,race,atk,def=c:GetAttribute(),c:GetRace(),c:GetAttack(),c:GetDefense()
			if (tab[1]&attr>0 and tab[2]&race>0) or (aux.FindInTable(tab[3],atk) and aux.FindInTable(tab[4],def)) then
				return true
			end
		end
	end
	return false
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local ft=Duel.GetMZoneCount(tp)
	local tc=Duel.Select(HINTMSG_OPERATECARD,false,tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft,{Duel.GetFlagEffectLabel(tp,FLAG_VALID_CODE)}):GetFirst()
	if tc then
		Duel.ToHandOrSpecialSummon(tc,e,tp)
	else
		Duel.SelectOption(tp,aux.Stringid(id,2))
	end
end