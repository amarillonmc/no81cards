--黄金螺旋-增长“2”
local s,id=GetID()
function s.sprule(c)
    aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()

    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(s.linklimit)
	c:RegisterEffect(e0)
end
function s.lcheck(g)
	return g:IsExists(Card.IsCode,1,nil,47380000) or g:IsExists(Card.IsCode,1,nil,47380001)
end
function s.linklimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xcc13)
end
function s.linksummon(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.mgfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsFaceupEx() and not c:IsImmuneToEffect(e)
	and ((c:IsAbleToGrave() and c:IsLocation(LOCATION_MZONE)) or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToDeck()))
end
function s.mgfilter1(c,e)
	return c:IsCode(47380002) and s.mgfilter(c,e)
end
function s.lfilter(c,e,tp)
	return c:IsCode(47380003) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function s.fselect(g,tp)
	return g:IsExists(Card.IsLinkCode,1,nil,47380002) and Duel.GetLocationCountFromEx(tp,tp,g)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(s.mgfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	local mg2=Duel.GetMatchingGroup(s.mgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	mg:Merge(mg2)
	if chk==0 then return Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	and mg:CheckSubGroup(s.fselect,2,2,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.mgfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	local mg2=Duel.GetMatchingGroup(s.mgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,e)
	mg:Merge(mg2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local g=mg:SelectSubGroup(tp,s.fselect,false,2,2,tp)
	if #g<=0 or not Duel.IsExistingMatchingCard(s.lfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) then return end

	local mg3=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local gg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local count=0
	if #mg3>0 then count=count+Duel.SendtoGrave(mg3,REASON_EFFECT) end
	if #gg>0 then count=count+Duel.SendtoDeck(gg,nil,SEQ_DECKTOP,REASON_EFFECT) end
	if count>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,s.lfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #tg>0 then
			local tc=tg:GetFirst()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)>0 then
				tc:CompleteProcedure()
			end
		end
	end
end
function s.tohand(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,id-1000)
	e1:SetCondition(s.thcon)
    e1:SetCost(aux.bfgcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL and e:GetHandler():IsReason(REASON_EFFECT)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function s.thfilter(c)
	return c:IsSetCard(0xcc13) and c:IsAbleToHand()
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		if g:IsExists(s.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,s.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
	end
end
function s.initial_effect(c)
	s.sprule(c)
    s.linksummon(c)
    s.tohand(c)
end
