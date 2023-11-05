--辣 稽
local m=13131382
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(13131382)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c13131382.matfilter,1,1)
	--change name
	aux.EnableChangeCode(c,13131370,LOCATION_MZONE+LOCATION_GRAVE)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,13131382)
	e1:SetCost(c13131382.spcost)
	e1:SetTarget(c13131382.sptg)
	e1:SetOperation(c13131382.spop)
	c:RegisterEffect(e1)
	
end
function c13131382.matfilter(c)
	return c:IsLinkSetCard(0x3b00)
end
function c13131382.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c13131374.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c13131374.splimit(e,c)
	return not c:IsSetCard(0x3b00)
end
function c13131382.spfilter(c,e,tp)
	return c:IsSetCard(0x3b00) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13131382.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c13131382.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13131382.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c13131382.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
