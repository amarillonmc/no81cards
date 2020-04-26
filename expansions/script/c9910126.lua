--战车道整备仓库
function c9910126.initial_effect(c)
	--link summon
	c:SetSPSummonOnce(9910126)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_XYZ),1,1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910126,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetTarget(c9910126.sptg)
	e1:SetOperation(c9910126.spop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c9910126.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x952)
end
function c9910126.filter2(c,e,tp)
	return c:IsSetCard(0x952) and c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910126.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9910126.filter1,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingTarget(c9910126.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910126,1))
	Duel.SelectTarget(tp,c9910126.filter1,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910126,2))
	local g=Duel.SelectTarget(tp,c9910126.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9910126.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tg=Group.CreateGroup()
	local tc1=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):GetFirst()
	local tc2=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetFirst()
	if tc2 and tc2:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)~=1 then return end
		if c:IsRelateToEffect(e) then
			tg:AddCard(c)
		end
		if tc1 and tc1:IsFaceup() and tc1:IsSetCard(0x952) and not tc1:IsImmuneToEffect(e) then
			local og=tc1:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			tg:AddCard(tc1)
		end
		if tg:GetCount()>0 then
			Duel.Overlay(tc2,tg)
		end
	end
end
