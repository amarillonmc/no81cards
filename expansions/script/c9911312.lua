--胧之渺翳 希尔达魔
function c9911312.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911312)
	e1:SetCost(c9911312.spcost)
	e1:SetTarget(c9911312.sptg)
	e1:SetOperation(c9911312.spop)
	c:RegisterEffect(e1)
	--xyz spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911312,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9911313)
	e2:SetCondition(c9911312.xyzcon)
	e2:SetTarget(c9911312.xyztg)
	e2:SetOperation(c9911312.xyzop)
	c:RegisterEffect(e2)
end
function c9911312.rfilter(c,tp)
	return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function c9911312.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=Group.CreateGroup()
	if #g>0 then tg=g:GetMinGroup(Card.GetAttack):Filter(c9911312.rfilter,nil,tp) end
	if chk==0 then return #tg>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=tg:Select(tp,1,1,nil)
	Duel.Release(rg,REASON_COST)
end
function c9911312.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9911312.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.IsPlayerCanDraw(1-tp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(9911312,0)) then
		Duel.BreakEffect()
		Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end
function c9911312.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c9911312.filter(c,e,tp)
	return c:IsSetCard(0xa958) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
		and Duel.IsExistingMatchingCard(c9911312.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c9911312.spfilter(c,e,tp,pc)
	return c:IsSetCard(0xa958) and c:IsType(TYPE_XYZ) and not c:IsAttribute(pc:GetAttribute())
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911312.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9911312.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9911312.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c9911312.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9911312.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c9911312.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=sg:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tg=Group.FromCards(tc)
		local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,0,LOCATION_HAND,nil)
		if #g>0 then
			g=g:RandomSelect(tp,1)
			tg:Merge(g)
		end
		Duel.Overlay(sc,tg)
	end
end
