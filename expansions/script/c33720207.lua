--[[
花花变身·动物朋友 白虎
H-Anifriends Byakko
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1,1)
	c:EnableReviveLimit()
	--alternative summon procedure
	local e0=Effect.CreateEffect(c)
	e0:Desc(0,id)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	--This card's name becomes "Anifriends Byakko of the West" while on the field or in the GY.
	aux.EnableChangeCode(c,33700085,LOCATION_MZONE|LOCATION_GRAVE)
	--If there are no cards with the same name in your hand, or if they all have the same name (Quick Effect): You can reveal your entire hand; excavate that number of cards from the top of your Deck, then add 1 excavated card to your hand, and if you added a monster, you can Special Summon it, also place the rest on top of the Deck in any order.
	local e1=Effect.CreateEffect(c)
	e1:Desc(1,id)
	e1:SetCategory(CATEGORIES_SEARCH|CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:HOPT()
	e1:SetRelevantTimings()
	e1:SetFunctions(s.condition,aux.DummyCost,s.target,s.operation)
	c:RegisterEffect(e1)
end
function s.spresfilter(c)
	return c:IsSetCard(ARCHE_ANIFRIENDS) and c:HasLevel()
end
function s.spres(g,tp,r)
	return aux.mzctcheckrel(g,tp,r) and g:GetClassCount(Card.GetLevel)==1
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(s.spresfilter,nil)
	return g:CheckSubGroup(s.spres,2,2,tp,REASON_SPSUMMON)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON):Filter(s.spresfilter,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,s.spres,true,2,2,tp,REASON_SPSUMMON)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Duel.Release(sg,REASON_SPSUMMON)
	sg:DeleteGroup()
end

--E1
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetHand(tp)
	if #g<=0 then return false end
	local ct=g:GetClassCount(Card.GetCode)
	return ct==1 or ct==#g
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetHand(tp)
	local ct=#g
	if chk==0 then
		return e:IsCostChecked() and ct~=0 and not g:IsExists(Card.IsPublic,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.IsPlayerCanExcavateAndSearch(tp,ct)
	end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	Duel.SetTargetParam(ct)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetTargetParam()
	if not ct then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	if #g>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc:IsAbleToHand() then
			Duel.BreakEffect()
			if Duel.SearchAndCheck(tc,tp) and Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		ct=ct-1
	end
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
	end
end