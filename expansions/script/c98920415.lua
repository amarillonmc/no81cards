--星辉士 星圣春三角骑士
function c98920415.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c98920415.matfilter,2,3) 
--apply the effect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(c98920415.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920415,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920415.effcon)
	e1:SetTarget(c98920415.efftg)
	e1:SetOperation(c98920415.effop)
	c:RegisterEffect(e1)
	e0:SetLabelObject(e1)
 --spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920415,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,98920415)
	e4:SetTarget(c98920415.sptg1)
	e4:SetOperation(c98920415.spop1)
	c:RegisterEffect(e4)
end
function c98920415.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsLinkCode(98920415)
end
function c98920415.valcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=0
	if c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x9c)>0 then flag=flag|1 end
	if c:GetMaterial():FilterCount(Card.IsSetCard,nil,0x53)>0 then flag=flag|2 end
	e:GetLabelObject():SetLabel(flag)
end
function c98920415.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c98920415.thfilter(c)
	return c:IsSetCard(0x70) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c98920415.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local chk1=e:GetLabel()&1>0
	local chk2=e:GetLabel()&2>0
	if chk==0 then return chk1 and Duel.IsPlayerCanDraw(tp,1)
		or chk2 and Duel.IsExistingMatchingCard(c98920415.thfilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetCategory(0)
	if chk1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
	if chk2 then
		e:SetCategory(e:GetCategory()|(CATEGORY_SPECIAL_SUMMON))
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	end
end
function c98920415.spfilter(c,e,tp)
	return c:IsSetCard(0x9c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c98920415.spfilter1(c,e,tp)
	return c:IsSetCard(0x53) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c98920415.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chk1=e:GetLabel()&1>0
	local chk2=e:GetLabel()&2>0
	if chk1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(98920415,2)) and Duel.IsExistingMatchingCard(c98920415.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920415.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	if chk2 and Duel.SelectYesNo(tp,aux.Stringid(98920415,3)) and Duel.IsExistingMatchingCard(c98920415.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c98920415.spfilter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920415.filter(c,e,tp)
	return c:IsSetCard(0x109c,0x53) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920415.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920415.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.IsExistingMatchingCard(Card.IsAttribute,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920415.matfilter(c,e)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function c98920415.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920415.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local tc=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920415.matfilter),tp,LOCATION_GRAVE,0,1,1,tc,e)
		if sg:GetCount()>0 then
			Duel.Overlay(tc,sg)
	   end
	end
end