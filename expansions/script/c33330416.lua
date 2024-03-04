--懊悔
function c33330416.initial_effect(c)
	aux.AddLinkProcedure(c,c33330416.mat,1,1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330416,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FLIP)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,33330416)
	e1:SetCondition(c33330416.spcon)
	e1:SetTarget(c33330416.sptg)
	e1:SetOperation(c33330416.spop)
	c:RegisterEffect(e1)
end
function c33330416.mat(c)
	return c:IsLinkSetCard(0x6552) and not c:IsLinkType(TYPE_LINK)
end
function c33330416.cfilter(c,tp)
	return c:IsSetCard(0x6552) and c:IsControler(tp)
end
function c33330416.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33330416.cfilter,1,nil,tp)
end
function c33330416.spfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c)>0
end
function c33330416.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33330416.spfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33330416.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33330416.spfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE)
		and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.AdjustAll()
		local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(33330416,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
		end
	end
end