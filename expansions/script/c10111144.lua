function c10111144.initial_effect(c)
	aux.AddCodeList(c,10111128)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x8),2,2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111144,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,10111144)
	e1:SetCondition(c10111144.condition)
	e1:SetTarget(c10111144.thtg)
	e1:SetOperation(c10111144.thop)
	c:RegisterEffect(e1)
	--special summon itself
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10111144,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,101111440)
	e2:SetCondition(c10111144.spcon)
	e2:SetCost(c10111144.cost)
	e2:SetTarget(c10111144.target)
	e2:SetOperation(c10111144.activate)
	c:RegisterEffect(e2)
end
c10111144.fusion_effect=true
function c10111144.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10111144.thfilter(c)
	return aux.IsCodeOrListed(c,10111128) and not c:IsCode(10111144) and c:IsAbleToHand()
end
function c10111144.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111144.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c10111144.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c10111144.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10111144.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and r==REASON_FUSION
end
function c10111144.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10111144.filter1(c,e,tp)
	return c:IsSetCard(0x9008) and c:IsType(TYPE_MONSTER)  and Duel.IsExistingMatchingCard(c10111144.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalCode(),c)
end
function c10111144.filter2(c,e,tp,att,mc)
	return c:IsSetCard(0x9008) and c:IsLevelBelow(8) and c:IsType(TYPE_FUSION)  and c:GetOriginalCode()~=att and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false) and c:CheckFusionMaterial()
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c10111144.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) and Duel.CheckReleaseGroup(tp,c10111144.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c10111144.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetOriginalCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10111144.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	local att=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10111144.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,att,nil)
	local tc=g:GetFirst()
	if tc then
		tc:SetMaterial(nil)
		if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
		end
	end
end