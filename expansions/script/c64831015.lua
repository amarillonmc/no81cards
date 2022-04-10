--终末旅者装备 应急救护包
function c64831015.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64831015+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c64831015.target)
	e1:SetOperation(c64831015.activate)
	c:RegisterEffect(e1)
end
function c64831015.filter(c,e,tp)
	return c:IsSetCard(0x5410) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c64831015.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c64831015.filter(chkc,e,tp) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c64831015.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c64831015.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c64831015.mvfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c64831015.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c64831015.mvfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1 and Duel.SelectYesNo(tp,aux.Stringid(64831015,0)) then
			local g=Duel.SelectMatchingCard(tp,c64831015.mvfil,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.HintSelection(g)
			local gc=g:GetFirst()
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(gc,nseq)
		end
	end
end
