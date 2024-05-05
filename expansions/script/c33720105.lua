--[[
亡命骗徒 『老司机』
Desperado Trickster - "The Sheriff"
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_DESPERADO_TRICKSTER_LOADED then
	GLITCHYLIB_DESPERADO_TRICKSTER_LOADED=true
	Duel.LoadScript("glitchylib_archetypes.lua")
end
function s.initial_effect(c)
	Auxiliary.RegisterDesperadoChallengeEffect(c,id,CATEGORY_SPECIAL_SUMMON|CATEGORY_GRAVE_SPSUMMON|CATEGORY_DECKDES,EFFECT_FLAG_DELAY,s.target,s.operation,s.challenge,true)
	--Once per turn, if a "Desperado Trickster" monster(s) is Special Summoned (except during the Damage Step): You can target 1 card on the field, destroy it.
	local MZChk=aux.AddThisCardInMZoneAlreadyCheck(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:OPT()
	e2:SetLabelObject(MZChk)
	e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and not c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.rvfilter(c)
	return c:IsSetCard(ARCHE_DESPERADO_TRICKSTER) and c:IsMonster()
end
function s.challenge(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.Group(s.rvfilter,tp,LOCATION_DECK,0,nil)
		if #g>=18 then
			Duel.HintMessage(tp,HINTMSG_CONFIRM)
			local rg=g:Select(tp,18,18,nil)
			if #rg>0 then
				Duel.ConfirmCards(1-tp,rg)
				return true
			end
		end
		return false
	end
	local ft=Duel.GetMZoneCountForMultipleSpSummon(tp)
	if ft<=0 then return end
	local g=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.Necro(s.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,math.min(2,ft),nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--E2
function s.descfilter(c)
	return c:IsFaceup() and c:IsSetCard(ARCHE_DESPERADO_TRICKSTER)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(aux.AlreadyInRangeFilter(e,s.descfilter),1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetCardOperationInfo(g,CATEGORY_DESTROY)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end