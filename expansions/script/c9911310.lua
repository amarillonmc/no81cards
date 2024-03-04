--胧之渺翳 维斯塔魔
function c9911310.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911310,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_EQUIP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911310)
	e1:SetTarget(c9911310.sptg)
	e1:SetOperation(c9911310.spop)
	c:RegisterEffect(e1)
	--xyz spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,9911311)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c9911310.xyztg)
	e2:SetOperation(c9911310.xyzop)
	c:RegisterEffect(e2)
end
function c9911310.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911310.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9911310,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.BreakEffect()
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c9911310.filter(c,e,tp)
	return c:IsFaceup() and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsCanOverlay()
		and Duel.IsExistingMatchingCard(c9911310.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c9911310.spfilter(c,e,tp,pc)
	return c:IsSetCard(0xa958) and c:IsType(TYPE_XYZ) and c:GetOriginalAttribute()~=pc:GetAttribute()
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911310.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c9911310.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9911310.filter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c9911310.filter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9911310.xfilter1(c,att)
	return c:IsFaceup() and c:GetOriginalAttribute()==att
end
function c9911310.xfilter2(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function c9911310.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c9911310.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tg=Group.FromCards(tc)
		local g=Duel.GetMatchingGroup(c9911310.xfilter1,tp,0,LOCATION_MZONE,nil,tc:GetAttribute())
		tg:Merge(g)
		tg=tg:Filter(c9911310.xfilter2,nil,e)
		if #tg>0 then
			for tc2 in aux.Next(tg) do
				local og=tc2:GetOverlayGroup()
				if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
			end
			Duel.Overlay(sc,tg)
		end
	end
end
