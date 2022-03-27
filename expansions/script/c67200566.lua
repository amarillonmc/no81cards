--巧壳将 诺亚斯
function c67200566.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(67200566)
	aux.AddLinkProcedure(c,c67200566.mfilter,1,1)   
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200566,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,67200566)
	e3:SetTarget(c67200566.mvtg)
	e3:SetOperation(c67200566.mvop)
	c:RegisterEffect(e3)   
end
function c67200566.mfilter(c)
	return c:IsLinkSetCard(0x676)
end
function c67200566.mvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x676) and c:IsType(TYPE_LINK)
end
function c67200566.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x676) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c67200566.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200566.mvfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c67200566.mvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200566,3))
	local g=Duel.SelectMatchingCard(tp,c67200566.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(g:GetFirst(),nseq)
	end
	local zone=aux.GetMultiLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsExistingMatchingCard(c67200566.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) and Duel.SelectYesNo(tp,aux.Stringid(67200566,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local gg=Duel.SelectMatchingCard(tp,c67200566.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
		if gg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(gg,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end

