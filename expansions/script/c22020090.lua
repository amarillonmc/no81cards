--大魔术师 梅林
function c22020090.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22020090.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020090,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22020090)
	e2:SetTarget(c22020090.target)
	e2:SetOperation(c22020090.operation)
	c:RegisterEffect(e2)
end
function c22020090.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22020090.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c22020090.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c22020090.filter1(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and not c:IsType(TYPE_TUNER) and c:IsSetCard(0xff1) and c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c22020090.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv+clv)
end
function c22020090.filter2(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsSetCard(0xff9) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22020090.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c22020090.filter1(chkc,e,tp,e:GetHandler():GetLevel()) end
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingTarget(c22020090.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c22020090.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetLevel())
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c22020090.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local lv=c:GetLevel()+tc:GetLevel()
	local g=Group.FromCards(c,tc)
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c22020090.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
		if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			sg:GetFirst():CompleteProcedure()
		end
	end
end