--蚀痕无命 米耶赛菈
function c62501716.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62501716,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,62501716)
	e1:SetCondition(c62501716.spcon)
	e1:SetCost(c62501716.spcost)
	e1:SetTarget(c62501716.sptg)
	e1:SetOperation(c62501716.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,62501716+1)
	e2:SetTarget(c62501716.rmtg)
	e2:SetOperation(c62501716.rmop)
	c:RegisterEffect(e2)
	c62501716.remove_event_effect=e2
end
function c62501716.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function c62501716.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	Duel.DisableShuffleCheck()
	Duel.ConfirmDecktop(tp,3)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	g:KeepAlive()
	e:SetLabelObject(g)
end
function c62501716.efilter(e)
	local ct=#c62501716.effect_list
	if e:GetCode()==EVENT_REMOVE and (e:GetType()&EFFECT_TYPE_SINGLE)==EFFECT_TYPE_SINGLE and e:IsActivated() then c62501716.effect_list[ct+1]=e end
	return false
end
function c62501716.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c62501716.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not c:IsSetCard(0xea4) then return false end
	c62501716.effect_list={}
	c:IsOriginalEffectProperty(c62501716.efilter)
	for _,te in ipairs(c62501716.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end
	return false
end
function c62501716.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if not c:IsRelateToChain() or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then g:DeleteGroup() return end
	if g and g:IsExists(c62501716.cfilter,1,nil,e,tp,eg,ep,ev,re,r,rp) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=g:FilterSelect(tp,c62501716.cfilter,1,1,nil,e,tp,eg,ep,ev,re,r,rp):GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		c62501716.effect_list={}
		tc:IsOriginalEffectProperty(c62501716.efilter)
		local e_list={}
		for _,te in ipairs(c62501716.effect_list) do
			local tg=te:GetTarget()
			if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c62501716.effect_list,i) end
		end
		local te=e_list[1]
		if #e_list>1 then
			local des_list={}
			for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
			local op=Duel.SelectOption(tp,table.unpack(des_list))
			te=e_list[op+1]
		end
		c62501716.effect_list={}
		--copy
		e:SetProperty(te:GetProperty())
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		e:SetProperty(EFFECT_FLAG_DELAY)--Original Property
	end
	g:DeleteGroup()
end
function c62501716.rmfilter(c,tp)
	return c:IsSetCard(0xea4) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function c62501716.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c62501716.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c62501716.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c62501716.rmfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tp)
	if rg:GetCount()==0 or Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)==0 then return end
	if c62501716.fstg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(62501716,3)) then
		Duel.BreakEffect()
		c62501716.fsop(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c62501716.filter0(c)
	return c:IsSetCard(0xea4) and c:IsFacedown() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c62501716.filter1(c,e)
	return c:IsSetCard(0xea4) and c:IsFacedown() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c62501716.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c62501716.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c62501716.filter0,tp,LOCATION_REMOVED,0,nil)
		local res=Duel.IsExistingMatchingCard(c62501716.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c62501716.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
end
function c62501716.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c62501716.filter1,tp,LOCATION_REMOVED,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c62501716.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c62501716.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat)
			Duel.ConfirmCards(1-tp,mat)
			Duel.SendtoDeck(mat,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
