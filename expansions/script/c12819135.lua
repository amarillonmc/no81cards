-- 恋爱头脑战-四条真妃
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12819165)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--specialsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x3a73) and c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_THUNDER) 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if #g==0 then return end
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			if tc:IsCode(12819165) and tc:IsType(TYPE_XYZ) then
				local og=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_DECK,0,nil)
				if #og>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
					Duel.Overlay(tc,og:Select(tp,1,1,nil))
				end
			end
		end
	end
end
function s.ovfilter(c)
	return c:IsSetCard(0x3a73) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end