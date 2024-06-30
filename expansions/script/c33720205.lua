--[[
花花变身·动物朋友 青龙
H-Anifriends Seiryu
Card Author: nemoma
Scripted by: XGlitchy30
]]
local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	--This card's name becomes "Anifriends Seiryu of the East" while on the field or in the GY.
	aux.EnableChangeCode(c,33700082,LOCATION_MZONE|LOCATION_GRAVE)
	--While your opponent has cards with the same name in their GY, this card, and cards linked to it, cannot be destroyed by battle or your opponent's card effects.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(s.incon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1x:SetValue(aux.indoval)
	c:RegisterEffect(e1x)
	local e1y=Effect.CreateEffect(c)
	e1y:SetType(EFFECT_TYPE_FIELD)
	e1y:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1y:SetRange(LOCATION_MZONE)
	e1y:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1y:SetTargetRange(LOCATION_MZONE|LOCATION_SZONE,LOCATION_MZONE|LOCATION_SZONE)
	e1y:SetCondition(s.incon)
	e1y:SetTarget(s.indtg)
	e1y:SetValue(1)
	c:RegisterEffect(e1y)
	local e1z=e1y:Clone()
	e1z:SetProperty(EFFECT_FLAG_SET_AVAILABLE|EFFECT_FLAG_IGNORE_IMMUNE)
	e1z:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1z:SetValue(aux.indoval)
	c:RegisterEffect(e1z)
	--During your Main Phase: You can reveal 5 monsters from your Deck, all with the same Type, Attribute, ATK or DEF, and if you do, your opponent randomly chooses 1 of them for you to add to your hand, or Special Summon.
	local e2=Effect.CreateEffect(c)
	e2:Desc(0,id)
	e2:SetCategory(CATEGORIES_SEARCH|CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:HOPT()
	e2:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e2)
	if not aux.H_Anifriends_flist then
		aux.H_Anifriends_flist={Card.GetRace,Card.GetAttribute,Card.GetTextAttack,Card.GetTextDefense}
	end
end

function s.lcheck(g)
	return not g:IsExists(aux.NOT(Card.IsLinkSetCard),1,nil,ARCHE_ANIFRIENDS)
		or g:GetClassCount(Card.GetLinkCode)==1
end

--E1
function s.incon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetGY(1-tp):CheckSubGroup(aux.sncheck,2,2)
end
function s.indtg(e,c)
	local g=e:GetHandler():GetGlitchyLinkedGroup()
	return g and g:IsContains(c)
end
function s.inval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end

--E2
function s.filter(c)
	return c:IsMonster() and c:IsAbleToHand()
end
function s.spfilter(c,e,tp)
	return c:IsMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.rescon(g)
	for _,f in ipairs(aux.H_Anifriends_flist) do
		if g:GetClassCount(f)==1 then
			return true
		end
	end
	return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(s.filter,tp,LOCATION_DECK,0,nil)
		if Duel.GetMZoneCount(tp)>0 then
			local sg=Duel.Group(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			g:Merge(sg)
		end
		return aux.SelectUnselectGroup(g,e,tp,5,5,s.rescon,0)
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(s.filter,tp,LOCATION_DECK,0,nil)
	if Duel.GetMZoneCount(tp)>0 then
		local sg=Duel.Group(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		g:Merge(sg)
	end
	if #g<=0 then return end
	local sg=aux.SelectUnselectGroup(g,e,tp,5,5,s.rescon,1,tp,HINTMSG_OPERATECARD,s.rescon)
	if #sg>0 then
		Duel.ConfirmCards(1-tp,sg)
		local rg=sg:RandomSelect(1-tp,1)
		Duel.ConfirmCards(tp,rg)
		local tc=rg:GetFirst()
		Duel.ToHandOrSpecialSummon(tc,e,tp)
	end
end