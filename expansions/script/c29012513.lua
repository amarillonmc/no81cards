--方舟骑士共赴黎明
c29012513.named_with_Arknight=1
function c29012513.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29012513+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29012513.target)
	e1:SetOperation(c29012513.activate)
	c:RegisterEffect(e1)
end
c29012513.kinkuaoi_Lightakm=true
function c29012513.filter(c,ft,e,tp)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c29012513.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(c29012513.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,ft,e,tp)
	end
end
function c29012513.spfilter(c,e,tp,tid)
	return c:GetTurnID()==tid and bit.band(c:GetReason(),REASON_DESTROY)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29012513.activate(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local res=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c29012513.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,ft,e,tp)
	if g:GetCount()>0 then
		local th=g:GetFirst():IsAbleToHand()
		local sp=ft>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,1190,1152)
		elseif th then op=0
		else op=1 end
		if op==0 then
			res=Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			res=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
			if res>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c29012513.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,tid) and Duel.SelectYesNo(tp,aux.Stringid(16958382,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g2=Duel.SelectMatchingCard(tp,c29012513.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,tid)
			local tc=g2:GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			end
	end
end