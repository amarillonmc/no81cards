--「圣战」纹章士-“圣战骑士”
function c75000067.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,c75000067.lcheck)
	c:EnableReviveLimit()
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000067,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,75000067)
	e1:SetCondition(c75000067.seqcon)
	e1:SetTarget(c75000067.seqtg)
	e1:SetOperation(c75000067.seqop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000067,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,75000067+1)
	e2:SetTarget(c75000067.destg)
	e2:SetOperation(c75000067.desop)
	c:RegisterEffect(e2)
end
function c75000067.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function c75000067.seqcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
end
function c75000067.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function c75000067.disfilter(c,p)
	return c:IsControler(p) and aux.NegateAnyFilter(c)
end
function c75000067.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	local seq=math.log(fd,2)
	local pseq=c:GetSequence()
	Duel.MoveSequence(c,seq)
	if c:GetSequence()==seq then
		local g=c:GetColumnGroup():Filter(c75000067.disfilter,nil,1-tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(75000067,2)) then
			Duel.BreakEffect()
			for tc in aux.Next(g) do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(44401030,0))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e3)
				end
			end
		end
	end
end
function c75000067.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chck:IsControler(1-tp) and chkc:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsStatus,tp,0,LOCATION_MZONE,1,nil,STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsStatus,tp,0,LOCATION_MZONE,1,1,nil,STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c75000067.chkfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function c75000067.spfilter(c,e,tp)
	return (c:IsSetCard(0x3751,0x6752) or c:IsCode(75000001)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and aux.NecroValleyFilter()(c)
end
function c75000067.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
		and Duel.IsExistingMatchingCard(c75000067.chkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c75000067.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(75000067,3)) then
		--spsummon
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c75000067.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if sc then Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) end
	end
end
