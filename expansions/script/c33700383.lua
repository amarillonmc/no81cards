--调阶魔法 - 羽化换骨
local m=33700383
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.spfilter1(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and Duel.IsExistingTarget(cm.spfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e,tp,c:GetLevel()) and not c:IsImmuneToEffect(e)
end
function cm.spfilter3(c,e,tp,lv)
	return c:IsFaceup() and c:IsLevel(lv) and Duel.IsExistingMatchingCard(cm.spfilter4,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv) and not c:IsImmuneToEffect(e)
end
function cm.spfilter2(c,e,tp)
	local lv=0
	if c:IsLevelAbove(1) then lv=c:GetLevel() end
	if c:IsRankAbove(1) then lv=c:GetRank() end
	return c:IsSetCard(0x445) and c:IsFaceup() and lv>0 and Duel.GetLocationCountFromEx(tp)>0 and Duel.IsExistingMatchingCard(cm.spfilter4,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv) and not c:IsImmuneToEffect(e)
end
function cm.spfilter4(c,e,tp,lv)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x445) and c:IsRankBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		if e:GetLabel()==0 then return false 
		else
			return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.spfilter2(chkc,e,tp)
		end
	end
	local b1=Duel.IsExistingTarget(cm.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g1=Duel.SelectTarget(tp,cm.spfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectTarget(tp,cm.spfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1,e,tp,g1:GetFirst():GetLevel())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,cm.spfilter2,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=aux.ExceptThisCard(e)
	if e:GetLabel()==0 then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if #g~=2 or g:GetClassCount(Card.GetLevel)~=1 or Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g:GetFirst():GetLevel())
		if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if c then c:CancelToGrave(true) g:AddCard(c) end
			Duel.Overlay(sg:GetFirst(),g)
		end
	else
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) or Duel.GetLocationCountFromEx(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cm.spfilter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetLevel())
		if #sg>0 and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local g=Group.FromCards(tc)
			if c then c:CancelToGrave(true) g:AddCard(c) end
			Duel.Overlay(sg:GetFirst(),g)
		end  
	end
end
