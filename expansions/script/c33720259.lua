--[[
滴血的同调
Bloody Synchro
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--[[If there is exactly 1 Tuner among face-up monsters you control: You can Tribute it, then reveal 1 Synchro Monster in your Extra Deck and pay LP equal to the difference between
	the Level of that Synchro monster and the Level the Tributed Tuner had on the field x 2000; Special Summon that Synchro Monster from your Extra Deck. (This is treated as a Synchro Summon.)]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRelevantTimings()
	e1:SetFunctions(s.condition,aux.DummyCost,s.target,s.activate)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.Group(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:FilterCount(Card.IsType,nil,TYPE_TUNER)==1
end
function s.relfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and c:HasLevel() and Duel.IsExists(false,s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,c:GetLevel())
end
function s.spfilter(c,e,tp,tuner,tlv)
	return c:IsType(TYPE_SYNCHRO) and c:HasLevel() and Duel.GetLocationCountFromEx(tp,tp,tuner,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.CheckLPCost(tp,math.abs(c:GetLevel()-tlv)*2000)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:IsCostChecked() and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) and Duel.CheckReleaseGroup(tp,s.relfilter,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,s.relfilter,1,1,nil,e,tp)
	local tlv=rg:GetFirst():GetLevel()
	Duel.Release(rg,REASON_COST)
	local sync=Duel.Select(HINTMSG_SPSUMMON,false,tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil,tlv):GetFirst()
	Duel.ConfirmCards(1-tp,sync)
	Duel.PayLPCost(tp,math.abs(sync:GetLevel()-tlv)*2000)
	Duel.SetTargetCard(sync)
	Duel.SetCardOperationInfo(sync,CATEGORY_SPECIAL_SUMMON)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	local sync=Duel.GetFirstTarget()
	if sync:IsRelateToChain() and sync:IsType(TYPE_SYNCHRO) then
		sync:SetMaterial(nil)
		if Duel.SpecialSummon(sync,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			sync:CompleteProcedure()
		end
	end
end