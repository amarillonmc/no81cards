--URBEX-探路者
function c65010504.initial_effect(c)
	 --spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65010504)
	e1:SetCost(c65010504.cost)
	e1:SetTarget(c65010504.tg)
	e1:SetOperation(c65010504.op)
	c:RegisterEffect(e1)
	--tog
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65010505)
	e2:SetTarget(c65010504.wdtg)
	e2:SetOperation(c65010504.wdop)
	c:RegisterEffect(e2)
end
c65010504.setname="URBEX"
function c65010504.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==3
	 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function c65010504.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)>=3 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function c65010504.bjfil(c,sg)
	local typ=0
	if c:IsType(TYPE_FUSION) then typ=1 end
	if c:IsType(TYPE_SYNCHRO) then typ=2 end
	if c:IsType(TYPE_XYZ) then typ=3 end
	if c:IsType(TYPE_LINK) then typ=4 end
	return sg:IsExists(c65010504.xtfil,1,c,typ)
end
function c65010504.xtfil(c,ntyp)
	local typ=0
	if c:IsType(TYPE_FUSION) then typ=1 end
	if c:IsType(TYPE_SYNCHRO) then typ=2 end
	if c:IsType(TYPE_XYZ) then typ=3 end
	if c:IsType(TYPE_LINK) then typ=4 end
	return typ==ntyp
end
function c65010504.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)<3 then return end
	local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	local sg=g:RandomSelect(tp,3)
	Duel.ConfirmCards(tp,sg)
	if sg:IsExists(c65010504.bjfil,1,nil,sg) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end

function c65010504.wdfil(c)
	return c:IsFacedown() and c:IsAbleToGrave()
end
function c65010504.wdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65010504.wdfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
end
function c65010504.wdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65010504.wdfil,tp,LOCATION_REMOVED,0,nil)
	local tg=g:RandomSelect(tp,1)
	local tc=tg:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)~=0 and tc.setname=="URBEX" and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(65010504,0)) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end