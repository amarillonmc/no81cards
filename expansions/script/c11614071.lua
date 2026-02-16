--雪域生灵的追猎
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Swap Link
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Immunity
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(s.immtg)
	e2:SetValue(s.immval)
	c:RegisterEffect(e2)
end
function s.tgfilter(c,e,tp)
	return c:IsSetCard(0x5226) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsAbleToExtra()
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetLink(),c:GetCode())
end
function s.spfilter(c,e,tp,lnk,code)
	return c:IsRace(RACE_BEAST+RACE_WINDBEAST) and c:IsType(TYPE_LINK) and c:GetLink()==lnk and not c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToChain() then return end
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLink(),tc:GetCode())
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.immtg(e,c)
	return c:GetFlagEffect(11614056)>0
end
function s.immval(e,re)
	return re:GetOwnerPlayer()==1-e:GetHandlerPlayer()
end
