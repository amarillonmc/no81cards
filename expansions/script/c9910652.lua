--光影捕捉者 弥界星烛号
function c9910652.initial_effect(c)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9910652.sprcon)
	e1:SetTarget(c9910652.sprtg)
	e1:SetOperation(c9910652.sprop)
	c:RegisterEffect(e1)
	--spsummon from ex
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,9910652)
	e2:SetTarget(c9910652.sptg)
	e2:SetOperation(c9910652.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,9910653)
	e4:SetCondition(c9910652.xmcon)
	e4:SetTarget(c9910652.xmtg)
	e4:SetOperation(c9910652.xmop)
	c:RegisterEffect(e4)
end
function c9910652.sprfilter(c)
	return (c:IsRace(RACE_MACHINE) or c:IsSetCard(0xa952)) and c:IsDiscardable()
end
function c9910652.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9910652.sprfilter,tp,LOCATION_HAND,0,1,c)
end
function c9910652.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c9910652.sprfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c9910652.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON+REASON_DISCARD)
end
function c9910652.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and Duel.IsExistingMatchingCard(c9910652.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function c9910652.spfilter2(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xa952) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function c9910652.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910652.spfilter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910652.spfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9910652.spfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910652.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910652.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c9910652.xmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c9910652.xmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910652.xmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910652.xmfilter,tp,LOCATION_MZONE,0,1,nil) and rc:IsCanOverlay(tp) end
	if rc:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,rc,1,0,0)
	end
end
function c9910652.xmop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or rc:IsImmuneToEffect(e) then return end
	if Duel.IsExistingMatchingCard(c9910652.xmfilter,tp,LOCATION_MZONE,0,1,nil) and rc:IsCanOverlay(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tg=Duel.SelectMatchingCard(tp,c9910652.xmfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(tg)
		if tg:GetFirst():IsImmuneToEffect(e) then return end
		local og=rc:GetOverlayGroup()
		if #og>0 then Duel.SendtoGrave(og,REASON_RULE) end
		rc:CancelToGrave()
		Duel.Overlay(tg:GetFirst(),Group.FromCards(rc))
	end
end
