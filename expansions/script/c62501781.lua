--蚀痕无命 洛芙蕾雅
function c62501781.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK)
	e0:SetCountLimit(1,62501781+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c62501781.sprcon)
	e0:SetTarget(c62501781.sprtg)
	e0:SetOperation(c62501781.sprop)
	c:RegisterEffect(e0)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501781,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62501781)
	e2:SetTarget(c62501781.sptg)
	e2:SetOperation(c62501781.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501781+1)
	e4:SetTarget(c62501781.rmtg)
	e4:SetOperation(c62501781.rmop)
	c:RegisterEffect(e4)
	c62501781.remove_event_effect=e4
end
function c62501781.rfilter(c)
	return c:IsSetCard(0xea4) and not c:IsCode(62501781) and c:IsFaceupEx() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function c62501781.gcheck(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and g:FilterCount(Card.IsControler,nil,tp)==2
end
function c62501781.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local g=Duel.GetMatchingGroup(c62501781.rfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct=c:IsLocation(LOCATION_HAND) and 3 or 2
	if c:IsLocation(LOCATION_HAND) then
		g:Merge(Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,POS_FACEDOWN))
	end
	return g:CheckSubGroup(c62501781.gcheck,2,ct,tp)
end
function c62501781.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c62501781.rfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct=c:IsLocation(LOCATION_HAND) and 3 or 2
	if c:IsLocation(LOCATION_HAND) then
		g:Merge(Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil,POS_FACEDOWN))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,c62501781.gcheck,true,2,ct,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c62501781.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	Duel.Remove(mg,POS_FACEDOWN,REASON_SPSUMMON)
	mg:DeleteGroup()
end
function c62501781.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xea4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c)) and (c:IsFacedown() or not c:IsLocation(LOCATION_REMOVED))
end
function c62501781.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c62501781.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,0)
	end--Duel.IsPlayerAffectedByEffect(tp,59822133)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c62501781.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	--local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or Duel.GetMZoneCount(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c62501781.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp,1):GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501781,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c62501781.sfilter(c,e,tp)
	return c:IsSetCard(0xea4) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsType(TYPE_FUSION) and (c:IsFacedown() or not c:IsLocation(LOCATION_REMOVED)) and (Duel.GetMZoneCount(tp)>0 and not c:IsLocation(LOCATION_EXTRA) or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c62501781.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501781.sfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp) and g:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)==#g end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED)
end
function c62501781.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetDecktopGroup(tp,3)
	if not rg or #rg==0 or Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	if Duel.GetMZoneCount(tp)>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c62501781.sfilter,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
	end
end
