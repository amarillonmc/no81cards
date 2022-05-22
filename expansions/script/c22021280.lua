--人理之基 隐藏不贞的头盔
function c22021280.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22021280+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22021280.target)
	e1:SetOperation(c22021280.activate)
	c:RegisterEffect(e1)
end
function c22021280.ddfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff9)
end
function c22021280.sfilter(c,e,tp)
	return c:IsCode(22021260) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c22021280.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22021280.ddfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22021280.ddfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c22021280.ddfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22021280.activate(e,tp,eg,ep,ev,re,r,rp)
	local g,p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.GetControl(g,1-tp)>0 then
	   local sc=Duel.GetFirstMatchingCard(c22021280.sfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	   if sc and Duel.SelectYesNo(tp,aux.Stringid(22021280,0)) then
		  Duel.BreakEffect()
		  Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(22021280,1))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetValue(c22021280.evalue)
			sc:RegisterEffect(e1)
	   end
	end
end
function c22021280.evalue(e,re,rp)
	return re:IsActiveType(TYPE_SPELL) and re:IsActiveType(TYPE_EQUIP)
end