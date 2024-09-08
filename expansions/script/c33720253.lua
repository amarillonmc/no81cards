--[[
绝·无心械姬 迅刃
Neo GearGal Mecha Blade
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[If only your opponent controls a monster, you can Special Summon this card (from your hand).]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--[[If this card is in a Monster Zone, or if it is treated as a Continuous Spell: You can Special Summon 1 Machine Xyz Monster from your GY, and if you do, destroy this card.]]
	local e2=Effect.CreateEffect(c)
	e2:Desc(1,id)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE|LOCATION_SZONE)
	e2:HOPT(true)
	e2:SetFunctions(s.spcon,nil,s.sptg,s.spop)
	c:RegisterEffect(e2)
	--[[If this face-up card is destroyed in a Monster Zone, you can place it face-up in your Spell & Trap Card Zone as a Continuous Spell Card, instead of sending it to the GY.]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(s.repcon)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
end
--E1
function s.spcon(e,c)
	if c==nil then return true end
	local p=c:GetControler()
	return Duel.GetFieldGroupCount(p,LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(p,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(p,LOCATION_MZONE)>0
end

--E2
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(LOCATION_SZONE) or c:IsSpell(TYPE_CONTINUOUS)
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetMZoneCount(tp)>0 and Duel.IsExists(false,s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetCardOperationInfo(e:GetHandler(),CATEGORY_DESTROY)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.Necro(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local c=e:GetHandler()
		if c:IsRelateToChain() then
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end

--E3
function s.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_FACEDOWN)
	e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
end