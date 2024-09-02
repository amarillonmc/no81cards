--地狱边境猎兵
function c9911620.initial_effect(c)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,9911620)
	e1:SetCondition(c9911620.dscon)
	e1:SetTarget(c9911620.dstg)
	e1:SetOperation(c9911620.dsop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--place
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9911621)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c9911620.totg)
	e4:SetOperation(c9911620.toop)
	c:RegisterEffect(e4)
end
function c9911620.dscon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0
end
function c9911620.fselect(g,eg)
	if not g:IsExists(Card.IsType,1,nil,TYPE_TUNER) then return false end
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	if lv1>lv2 then lv1,lv2=lv2,lv1 end
	return lv2-lv1>1 and eg:IsExists(c9911620.dsfilter,1,nil,lv1,lv2)
end
function c9911620.dsfilter(c,lv1,lv2)
	return c:GetLevel()>lv1 and c:GetLevel()<lv2
end
function c9911620.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if chk==0 then return #g>1 and g:CheckSubGroup(c9911620.fselect,2,2,eg) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c9911620.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if #g<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911620,0))
	local g1=g:SelectSubGroup(tp,c9911620.fselect,false,2,2,eg)
	if not g1 or #g1~=2 then return end
	Duel.ConfirmCards(tp,g1)
	Duel.ConfirmCards(1-tp,g1)
	local lv1=g1:GetFirst():GetLevel()
	local lv2=g1:GetNext():GetLevel()
	if lv1>lv2 then lv1,lv2=lv2,lv1 end
	local g2=eg:Filter(c9911620.dsfilter,nil,lv1,lv2)
	Duel.NegateSummon(eg)
	if c:IsRelateToEffect(e) then g2:AddCard(c) end
	Duel.Destroy(g2,REASON_EFFECT)
	if g1:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then Duel.ShuffleHand(tp) end
end
function c9911620.tofilter(c,tp)
	return c:IsFaceupEx() and c:IsCode(9911614) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c9911620.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9911620.tofilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) end
end
function c9911620.toop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9911620.tofilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
