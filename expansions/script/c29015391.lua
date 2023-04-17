--方舟骑士辉光相映
local cm,m,o=GetID()
cm.named_with_Arknight=1
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
cm.kinkuaoi_Lightakm=true
--e1
function cm.tgf1(c,e,tp,code)
	if not (c:IsSetCard(0x87af) and c:IsAttribute(ATTRIBUTE_LIGHT)) then return false end
	if code then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code) end
	if not Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,c:GetCode()) then return false end
	local seq=c:GetSequence()
	if seq>5 then return false end
	return (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) or (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tgf1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SelectTarget(tp,cm.tgf1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local seq=tc:GetSequence()
	if not ((seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) or (seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	tc=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,tc:GetCode()):GetFirst()
	if not tc then return end
	local seq1=(seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1)) and 2^(seq+1) or 0
	seq=(seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1)) and 2^(seq-1) or 0
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,seq1+seq)
end