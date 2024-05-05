--[[
亡命骗徒 『对子』
Desperado Trickster - "One Pair"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:Desc(0)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_DESTROY|CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetFunctions(nil,nil,s.target,s.operation)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
end
function s.rvfilter(c)
	return c:IsMonster() and c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:HasDefense() and not c:IsPublic()
end
function s.gcheck(g,e,tp)
	if g:GetClassCount(Card.GetDefense)~=#g then return false end
	local def1,def2=g:GetFirst():GetDefense(),g:GetNext():GetDefense()
	if def1>def2 then def1,def2=def2,def1 end
	return Duel.IsExists(true,s.spfilter,tp,LOCATION_GRAVE,0,1,g,e,tp,def1,def2)
end
function s.spfilter(c,e,tp,def1,def2)
	return c:IsMonster() and c:HasDefense() and c:IsDefenseAbove(def1) and c:IsDefenseBelow(def2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilter2(c,e,tp,def)
	return c:IsMonster() and c:HasDefense() and c:IsDefenseBelow(def-1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,true) end
	local g=Duel.Group(s.rvfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then
		return not Duel.PlayerHasFlagEffect(tp,id) and #g>1 and Duel.GetMZoneCount(tp)>0 and g:CheckSubGroup(s.gcheck,2,2,e,tp)
	end
	Duel.HintMessage(tp,HINTMSG_CONFIRM)
	local rg=g:SelectSubGroup(tp,s.gcheck,false,2,2,e,tp)
	if #rg==2 then
		Duel.ConfirmCards(1-tp,rg)
		local def1,def2=rg:GetFirst():GetDefense(),rg:GetNext():GetDefense()
		if def1>def2 then def1,def2=def2,def1 end
		local tg=Duel.Select(HINTMSG_SPSUMMON,true,tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,def1,def2)
		local c=e:GetHandler()
		local p,loc=c:GetResidence()
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,#tg,tp,LOCATION_GRAVE)
		Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE)
		Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,c,1,p,loc)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local b1=tc and tc:IsRelateToChain() and Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and not tc:IsHasEffect(EFFECT_NECRO_VALLEY)
	local b2=c:IsRelateToChain()
	local opt=aux.Option(tp,id,1,b1,b2)
	if not opt then return end
	if opt==0 then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.GetMZoneCount(1-tp,nil,1-tp)>0 then
			local def=tc:GetDefense()
			local sg=Duel.Group(aux.Necro(s.spfilter2),tp,0,LOCATION_GRAVE,nil,e,1-tp,def)
			if #sg>0 then
				Duel.HintMessage(1-tp,HINTMSG_SPSUMMON)
				local sg2=sg:Select(1-tp,1,1,nil)
				Duel.SpecialSummon(sg2,0,1-tp,1-tp,false,false,POS_FACEUP)
			end
		end
	else
		if Duel.Destroy(c,REASON_EFFECT)>0 then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
		end
	end
end