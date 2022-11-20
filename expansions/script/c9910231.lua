--逆袭之斗兽 鸢泽美咲
function c9910231.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_LINK),2,99,c9910231.lcheck)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,9910231)
	e1:SetCost(c9910231.spcost)
	e1:SetTarget(c9910231.sptg)
	e1:SetOperation(c9910231.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(9910231,ACTIVITY_CHAIN,c9910231.chainfilter1)
	Duel.AddCustomActivityCounter(9910227,ACTIVITY_CHAIN,c9910231.chainfilter2)
end
function c9910231.chainfilter1(re,tp,cid)
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (re:GetHandler():IsSetCard(0x955) and re:IsActiveType(TYPE_SPELL) and bit.band(loc,LOCATION_SZONE)~=0)
end
function c9910231.chainfilter2(re,tp,cid)
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (re:GetHandler():IsSetCard(0x955) and re:IsActiveType(TYPE_SPELL) and bit.band(loc,LOCATION_GRAVE)~=0)
end
function c9910231.lcheck(g)
	return g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_BOTTOM)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_TOP)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_LEFT)
		and g:IsExists(Card.IsLinkMarker,1,nil,LINK_MARKER_RIGHT)
end
function c9910231.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9910231.filter(c,e,tp)
	return c9910231.spfilter(c,e,tp) and c:IsCanBeEffectTarget(e)
end
function c9910231.spfilter(c,e,tp)
	return c:IsSetCard(0x955) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910231.fselect(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_ONFIELD)<2 and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<2
end
function c9910231.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910231.spfilter(chkc,e,tp) end
	local c=e:GetHandler()
	local ft=Duel.GetMZoneCount(tp,c)
	local ct=Duel.GetMatchingGroupCount(c9910231.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	local rt=0
	local loc=0
	if Duel.GetCustomActivityCount(9910231,tp,ACTIVITY_CHAIN)~=0 then loc=loc+LOCATION_ONFIELD end
	if Duel.GetCustomActivityCount(9910227,tp,ACTIVITY_CHAIN)~=0 then loc=loc+LOCATION_GRAVE end
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,0,loc,nil)
	if chk==0 then
		if ct==0 then return false end
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return c:IsAbleToRemoveAsCost() and ft>0
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		if ct>1 and ft>1 and #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(9910231,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg=rg:SelectSubGroup(tp,c9910231.fselect,false,1,math.min(ct,ft)-1)
			sg:AddCard(c)
			rt=Duel.Remove(sg,POS_FACEUP,REASON_COST)
		else
			rt=Duel.Remove(c,POS_FACEUP,REASON_COST)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910231.spfilter,tp,LOCATION_GRAVE,0,rt,rt,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c9910231.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
