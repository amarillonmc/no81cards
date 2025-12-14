--回路斗士
local m=87498943
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2,2)
	--SPecial Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.chcon)
	e3:SetTarget(cm.chtg)
	e3:SetOperation(cm.chop)
	c:RegisterEffect(e3)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetMutualLinkedGroupCount()>0
end
function cm.get_zone(c,seq,self_linked_zone,tc)
	local zone=self_linked_zone
	local ok_zone=0
	if seq<4 and c:IsLinkMarker(LINK_MARKER_LEFT) and tc:IsLinkMarker(LINK_MARKER_RIGHT) then ok_zone=bit.bor(ok_zone,2^(seq+1)) end
	if seq>0 and seq<5 and c:IsLinkMarker(LINK_MARKER_RIGHT) and tc:IsLinkMarker(LINK_MARKER_LEFT) then ok_zone=bit.bor(ok_zone,2^(seq-1)) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) and tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then ok_zone=bit.bor(ok_zone,2^2) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP) and tc:IsLinkMarker(LINK_MARKER_BOTTOM) then ok_zone=bit.bor(ok_zone,2^1) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) and tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then ok_zone=bit.bor(ok_zone,2^0) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_LEFT) and tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then ok_zone=bit.bor(ok_zone,2^4) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP) and tc:IsLinkMarker(LINK_MARKER_BOTTOM) then ok_zone=bit.bor(ok_zone,2^3) end
	if seq==5 and c:IsLinkMarker(LINK_MARKER_TOP_RIGHT) and tc:IsLinkMarker(LINK_MARKER_BOTTOM_RIGHT) then ok_zone=bit.bor(ok_zone,2^2) end
	return zone&ok_zone
end
function cm.filter2(c,e,tp,seq,self_linked_zone,tc)
	local zone=cm.get_zone(c,seq,self_linked_zone,tc)
	return zone~=0 and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local self_linked_zone=c:GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter2(chkc,e,tp,seq,self_linked_zone,c) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,seq,self_linked_zone,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,seq,self_linked_zone,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local self_linked_zone=c:GetLinkedZone()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and tc:IsRelateToEffect(e) then
		local zone=cm.get_zone(tc,c:GetSequence(),self_linked_zone,c)
		if zone~=0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end