--三形金字塔的阿波菲斯
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(0xff)
	e5:SetOperation(s.effop)
	c:RegisterEffect(e5)
end
function s.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xe2)
end
function s.spfilter(c)
	return c:IsSetCard(0xe2)
		and (not c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup())
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(s.spfilter,1,nil) 
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetFlagEffect(id)==0  end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local ngboolean=false
		for i=1,ev do
			local rp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
			if rp==1-tp and Duel.IsChainDisablable(i) then ngboolean=true end
		end
		if ngboolean and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			local dg=Group.CreateGroup()
			for i=1,ev do
				local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
				local tc=te:GetHandler()
				local rp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
				if rp==1-tp and Duel.NegateEffect(i) and tc:IsRelateToEffect(te) then dg:AddCard(tc) end
			end
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
s.check={}
function s.efffilter(c)
	return c:IsType(TYPE_FIELD)
end
function s.gfilter(c,g)
	if not g then return true end
	return s.efffilter(c) and not g:IsContains(c)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	local c=e:GetHandler()
	if not fc or fc:IsFacedown() or not fc:IsSetCard(0xe2) then return false end
	if (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or c:IsDisabled()) and s.check[c] and #s.check[c]>0 then
		local exg=Group.CreateGroup()
		for tc,cid in pairs(s.check[c]) do
			if tc and cid then fc:ResetEffect(s.check[c][tc],RESET_COPY) end
		end
		s.check[c]={}
	end
	if (not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() or c:IsDisabled()) then return false end
	if not e:GetLabelObject() or e:GetLabelObject()~=fc then 
		s.check[c]={}
		e:SetLabelObject(fc) 
	end 
	s.check[c]=s.check[c] or {}
	local exg=Group.CreateGroup()
	for tc,cid in pairs(s.check[c]) do
		if tc and cid then exg:AddCard(tc) end
	end
	local g=Duel.GetMatchingGroup(s.efffilter,tp,LOCATION_GRAVE,0,nil)
	local dg=exg:Filter(s.gfilter,nil,g)
	for tc in aux.Next(dg) do
		fc:ResetEffect(s.check[c][tc],RESET_COPY)
		exg:RemoveCard(tc)
		s.check[c][tc]=nil
	end
	local cg=g:Filter(s.gfilter,nil,exg)
	for tc in aux.Next(cg) do
		local flag=true
		if #s.check[c]==0 then
			s.check[c][tc]=fc:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
		end
		for ac,cid in pairs(s.check[c]) do
			if tc==ac then
				flag=false
			end
		end
		if flag==true then
			s.check[c][tc]=fc:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000,1)
		end
	end
end
