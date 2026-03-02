--雪域生灵 狼王梦
local s,id,o=GetID()
function s.initial_effect(c)
	--Enable Revive Limit
	c:EnableReviveLimit()
	--Link Summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),2,99)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Delayed Send
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.dstg)
	e2:SetOperation(s.dsop)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5226) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	local atype=re:GetActiveType()
	local mask=0
	if (atype&TYPE_MONSTER)~=0 then mask=mask+1 end
	if (atype&TYPE_SPELL)~=0 then mask=mask+2 end
	if (atype&TYPE_TRAP)~=0 then mask=mask+4 end
	local flag=Duel.GetFlagEffectLabel(tp,id) or 0
	if chk==0 then return (flag&mask)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	e:SetLabel(mask)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToChain() then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	local mask=e:GetLabel()
	local flag=Duel.GetFlagEffectLabel(tp,id) or 0
	if flag==0 then
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1,mask)
	else
		Duel.SetFlagEffectLabel(tp,id,flag|mask)
	end
end
function s.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	--Declare 0-7
	local ac=Duel.AnnounceLevel(tp,0,7)
	Duel.SetTargetParam(ac)
end
function s.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if not tc or not tc:IsRelateToChain() then return end
	if ac==0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,0)
		s.apply_resolution(e,tp,tc,0)
	else
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetLabel(ac,ac)
		e1:SetLabelObject(tc)
		e1:SetOperation(s.countop)
		Duel.RegisterEffect(e1,tp)
		c:CreateEffectRelation(e1)
	end
end
function s.countop(e,tp,eg,ep,ev,re,r,rp)
	local cur,orig=e:GetLabel()
	local tc=e:GetLabelObject()
	cur=cur-1
	e:SetLabel(cur,orig)
	if cur==0 then
		s.apply_resolution(e,tp,tc,orig)
		e:Reset()
	end
end
function s.apply_resolution(e,tp,tc,ac)
	local c=e:GetOwner()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_CARD,0,id)
	if tc and tc:GetFlagEffect(id)>0 then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
	--1+
	if ac>=1 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		for ec in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ac*300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			ec:RegisterEffect(e1)
		end
	end
	--3+
	if ac>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
		if #g>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=g:Select(tp,1,1,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
	--5+
	if ac>=5 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.LinkSummon(tp,tc,nil)
		end
	end
	--7
	if ac==7 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if #g>0 then
			local sg=g:RandomSelect(tp,3)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
