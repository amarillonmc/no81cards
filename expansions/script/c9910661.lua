--太白遮光镜 黯界星斑号
function c9910661.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910661)
	e1:SetCondition(c9910661.spcon)
	e1:SetTarget(c9910661.sptg)
	e1:SetOperation(c9910661.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910662)
	e2:SetCondition(c9910661.drcon)
	e2:SetTarget(c9910661.drtg)
	e2:SetOperation(c9910661.drop)
	c:RegisterEffect(e2)
end
function c9910661.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>2
end
function c9910661.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910661.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9910661.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910661.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	if Duel.CheckRemoveOverlayCard(tp,1,0,2,REASON_EFFECT) and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(9910661,0)) and Duel.RemoveOverlayCard(tp,1,0,2,2,REASON_EFFECT) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9910661.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c9910661.matfilter1(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0 and not (e and c:IsImmuneToEffect(e))
end
function c9910661.matfilter2(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function c9910661.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):Filter(Card.IsCanOverlay,nil)
	if chk==0 then return #g>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2
		and Duel.IsExistingMatchingCard(c9910661.matfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,3)
end
function c9910661.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):Filter(c9910661.matfilter2,nil,e)
	local ct=g:GetCount()
	if ct>3 then ct=3 end
	if ct>0 and Duel.IsExistingMatchingCard(c9910661.matfilter1,tp,LOCATION_MZONE,0,1,nil,e) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
		local sg=g:Select(1-tp,ct,ct,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(1-tp,c9910661.matfilter1,tp,LOCATION_MZONE,0,1,1,nil,e):GetFirst()
		Duel.Overlay(tc,sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCategory(CATEGORY_DRAW)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c9910661.drop2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910661.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910661)
	Duel.Draw(1-tp,3,REASON_EFFECT)
end
