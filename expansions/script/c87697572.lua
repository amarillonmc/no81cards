--圣像骑士的暮曲
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x116) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.linksumfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x116) and c:IsLinkSummonable(nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	local res=false
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetDescription(aux.Stringid(id,3))
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_IMMUNE_EFFECT)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e0:SetRange(LOCATION_MZONE)
		e0:SetValue(s.immval)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		tc:RegisterEffect(e3,true)
		res=true
	end
	Duel.SpecialSummonComplete()
	Duel.AdjustAll()
	local linkg=Duel.GetMatchingGroup(s.syncsumfilter,tp,LOCATION_EXTRA,0,nil)
	if #linkg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=Duel.SelectMatchingCard(tp,s.linksumfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local le0=Effect.CreateEffect(e:GetHandler())
		le0:SetDescription(aux.Stringid(id,3))
		le0:SetType(EFFECT_TYPE_SINGLE)
		le0:SetCode(EFFECT_IMMUNE_EFFECT)
		le0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		le0:SetRange(LOCATION_MZONE)
		le0:SetValue(s.immval)
		le0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		sg1:GetFirst():RegisterEffect(le0,true)
		local le1=Effect.CreateEffect(e:GetHandler())
		le1:SetType(EFFECT_TYPE_SINGLE)
		le1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		le1:SetValue(1)
		le1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		sg1:GetFirst():RegisterEffect(le1,true)
		local le2=le1:Clone()
		le2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		sg1:GetFirst():RegisterEffect(le2,true)
		local le3=le1:Clone()
		le3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		sg1:GetFirst():RegisterEffect(le3,true)
		Duel.LinkSummon(tp,sg1:GetFirst(),nil)
	end
end
function s.immval(e,re)
	return e:GetHandler()~=re:GetOwner()
end
function s.thfilter(c)
	return c:IsCode(id,96434581) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
