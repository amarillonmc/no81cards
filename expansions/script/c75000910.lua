--邪龙恶召
function c75000910.initial_effect(c)
	aux.AddCodeList(c,75000901)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000910,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c75000910.target)
	e1:SetOperation(c75000910.activate)
	c:RegisterEffect(e1) 
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000910,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_LEAVE_DECK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,75000910)
	e3:SetCondition(c75000910.thcon)
	e3:SetTarget(c75000910.thtg)
	e3:SetOperation(c75000910.thop)
	c:RegisterEffect(e3)   
end
c75000910.fusion_effect=true
function c75000910.filter(c,e,tp,mg)
	local ct=c:GetLevel()
	return c:IsType(TYPE_FUSION) and aux.IsCodeListed(c,75000901) and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and mg:CheckSubGroup(c75000910.gcheck,1,ct,tp,c,ct)
end
function c75000910.gcheck(g,tp,fc,lv)
	return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0
		and g:FilterCount(Card.IsAbleToGrave,nil)==g:GetCount() and g:GetSum(Card.GetLevel)==lv
end
function c75000910.tyfilter(c)
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_MONSTER and c:IsLevelAbove(0)
end
function c75000910.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c75000910.tyfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(c75000910.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c75000910.activate(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	local mg=Duel.GetMatchingGroup(c75000910.tyfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75000910.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		local ct=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=mg:SelectSubGroup(tp,c75000910.gcheck,false,1,ct,tp,tc,ct)
		local cg=sg:Filter(Card.IsFacedown,nil)
		Duel.ConfirmCards(1-tp,cg)
		if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)~=0 then
			tc:SetMaterial(nil)
			Duel.BreakEffect()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
				tc:CompleteProcedure()
			end
		end
	end
end
--
function c75000910.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA)
end
function c75000910.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() or c:IsSSetable() end
end
function c75000910.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then
		if c:IsAbleToHand() and (not c:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		else
			Duel.SSet(tp,c)
		end
	end
end

