--舞台欢唱新星
function c9910609.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,c9910609.lcheck)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910609)
	e1:SetCondition(c9910609.spcon)
	e1:SetTarget(c9910609.sptg)
	e1:SetOperation(c9910609.spop)
	c:RegisterEffect(e1)
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910610)
	e2:SetCondition(c9910609.lkcon)
	e2:SetTarget(c9910609.lktg)
	e2:SetOperation(c9910609.lkop)
	c:RegisterEffect(e2)
end
function c9910609.lcheck(g,lc)
	if #g<2 then return false end
	local c1=g:GetFirst()
	local c2=g:GetNext()
	return c1:GetLinkAttribute()&c2:GetLinkAttribute()>0 or c1:GetLinkRace()&c2:GetLinkRace()>0
end
function c9910609.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	if p==1-tp then seq=seq+16 end
	return re:IsActiveType(TYPE_MONSTER) and bit.band(loc,LOCATION_MZONE)~=0 and bit.extract(c:GetLinkedZone(),seq)~=0 and Duel.IsChainNegatable(ev)
end
function c9910609.filter(c,att,race,e,tp,zone)
	return (c:IsAttribute(att) or c:IsRace(race)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c9910609.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local att,race=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE,CHAININFO_TRIGGERING_RACE)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp)
		and c9910609.filter(chkc,att,race,e,tp,zone) end
	if chk==0 then return Duel.IsExistingTarget(c9910609.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,att,race,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910609.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,att,race,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9910609.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and zone&0x1f~=0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP,zone) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
end
function c9910609.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c9910609.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsLinkState,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910609.lkop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsLinkState,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=tg:GetFirst()
	if tc then
		Duel.LinkSummon(tp,tc,mg)
	end
end
