--BUILD(“三世坏”,2)
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89490273)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.ovfilter(c,e)
	return c:IsSetCard(0xc3d) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function s.xyzfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(s.ovfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e)
end
function s.xspfilter(c,e,tp)
	return c:GetOwner()==tp and c:IsSetCard(0xc3d) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.xyzfilter2(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(s.xspfilter,1,nil,e,tp)
end
function s.bfilter(c)
	return c:IsFaceup() and (c:IsCode(89490273) or c:IsType(TYPE_XYZ) and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,89490273))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.xyzfilter2(chkc,e,tp) end
	local b1=Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	local b2=Duel.GetMZoneCount(tp)>0 and Duel.IsExistingTarget(s.xyzfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local b3=Duel.IsExistingMatchingCard(s.bfilter,tp,LOCATION_ONFIELD,0,1,nil) and b1 and b2
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,0)},{b2,1118},{b3,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		if e:IsCostChecked() then
			e:SetCategory(0)
			e:SetProperty(0)
		end
	else
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,s.xyzfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op&1==1 then
		local sg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,nil,e,tp)
		if sg:GetCount()>0 then
			local dc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local xg=Duel.SelectMatchingCard(tp,s.ovfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e)
			Duel.Overlay(dc,xg)
		end
	end
	if op&2==2 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToChain() then
			local sg=tc:GetOverlayGroup():Filter(s.xspfilter,nil,e,tp)
			if #sg>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local dg=sg:Select(tp,1,1,nil)
				Duel.SpecialSummon(dg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
