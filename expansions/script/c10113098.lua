--糖果小魔女
function c10113098.initial_effect(c)
	c:SetSPSummonOnce(10113098)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),2,false)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c10113098.spcon)
	e1:SetOperation(c10113098.spop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113098,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c10113098.sptg2)
	e2:SetOperation(c10113098.spop2)
	c:RegisterEffect(e2)
end
function c10113098.spfilter(c,e,tp)
	return c:GetRank()==4 and e:GetHandler():IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c10113098.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c10113098.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10113098.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c10113098.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 or not aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL) then return end
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not tc:IsRelateToEffect(e) then return end
	tc:SetMaterial(Group.FromCards(c))
	Duel.Overlay(tc,Group.FromCards(c))
	if Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
	   tc:CompleteProcedure()
	   local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	   if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10113098,1)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		  local mg=g:Select(tp,1,1,nil)
		  Duel.Overlay(tc,mg)
	   end
	end
end
function c10113098.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_COST)
end
function c10113098.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_COST)
end
