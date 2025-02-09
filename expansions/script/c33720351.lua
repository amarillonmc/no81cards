--[[
昙花一现的动物女孩
Animal Girl's Fleeting Moment
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
Duel.LoadScript("glitchylib_vsnemo.lua")
function s.initial_effect(c)
	--This card's name becomes "Anifriends Ringtail" while on the field or in the GY.
	aux.EnableChangeCode(c,id+1,LOCATION_MZONE|LOCATION_GRAVE)
	--[[During the End Phase: You can banish this card; Special Summon 1 Warrior "Anifriends" monster from your Extra Deck, ignoring its Summoning conditions, and if you do, it cannot be destroyed by
	battle. You must have no cards in your GY to activate and resolve this effect.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE|PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:OPT()
	e1:SetFunctions(s.spcon,aux.bfgcost,s.sptg,s.spop)
	c:RegisterEffect(e1)
end
--E1
function s.spcon(e,tp)
	return Duel.GetGYCount(tp)==0
end
function s.spfilter(c,e,tp,exc)
	return c:IsSetCard(ARCHE_ANIFRIENDS) and c:IsRace(RACE_WARRIOR) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,exc,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local exc=e:IsCostChecked() and e:GetHandler() or nil
		return Duel.IsExists(false,s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,exc)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if not s.spcon(e,tp) then return end
	local tc=Duel.Select(HINTMSG_SPSUMMON,false,tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		tc:CannotBeDestroyedByBattle(1,nil,true,e:GetHandler())
	end	
end