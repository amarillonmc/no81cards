--巧壳将 艾菲莉娅
function c67200556.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	c:SetSPSummonOnce(67200556)
	aux.AddLinkProcedure(c,c67200556.mfilter,1,1)   
	--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200556,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,67200556)
	e3:SetTarget(c67200556.mvtg)
	e3:SetOperation(c67200556.mvop)
	c:RegisterEffect(e3)   
end
function c67200556.mfilter(c)
	return c:IsLinkSetCard(0x676) and c:IsLinkType(TYPE_PENDULUM)
end
function c67200556.mvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x676) and c:IsType(TYPE_LINK)
end
function c67200556.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x676) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c67200556.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200556.mvfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c67200556.mvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200556,3))
	local g=Duel.SelectMatchingCard(tp,c67200556.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(g:GetFirst(),nseq)
	end
	local zone=aux.GetMultiLinkedZone(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0 and Duel.IsExistingMatchingCard(c67200556.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,zone) and Duel.SelectYesNo(tp,aux.Stringid(67200556,2)) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local gg=Duel.SelectMatchingCard(tp,c67200556.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
		if gg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(gg,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
