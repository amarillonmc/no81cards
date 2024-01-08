local m=15005078
local cm=_G["c"..m]
cm.name="最终幻想 末世终迹"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15005078)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--fusion
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(cm.sp1con)
	e2:SetCost(cm.sp1cost)
	e2:SetTarget(cm.sp1tg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--fusion (opponent)
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e8:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e8:SetCondition(cm.sp2con)
	e8:SetCost(cm.sp2cost)
	e8:SetTarget(cm.sp2tg)
	e8:SetOperation(cm.spop)
	c:RegisterEffect(e8)
end
function cm.sfilter(c)
	return c:IsFaceup() and c:IsCode(15005077)
end
function cm.sp1con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(cm.sfilter,p,LOCATION_ONFIELD,0,1,nil) and tp~=p
end
function cm.rmfilter(c)
	return c:IsSetCard(0xcf3e) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and c:IsAbleToRemoveAsCost()
end
function cm.sp1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return rg:GetCount()>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	rc=rg:FilterSelect(tp,cm.rmfilter,1,1,nil):GetFirst()
	if not rc:IsLocation(LOCATION_GRAVE) then Duel.ConfirmCards(1-tp,rc) end
	Duel.Remove(rc,POS_FACEDOWN,REASON_COST)
end
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p=c:GetControler()
	local rg=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	local g=Duel.GetDecktopGroup(p,3)
	if chk==0 then return rg:GetCount()>0 or g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	local op=0
	local b1=rg:GetCount()>0
	local b2=g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(m,1))
	else op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		rc=rg:FilterSelect(tp,cm.rmfilter,1,1,nil):GetFirst()
		if not rc:IsLocation(LOCATION_GRAVE) then Duel.ConfirmCards(1-tp,rc) end
		Duel.Remove(rc,POS_FACEDOWN,REASON_COST)
	else
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
function cm.filter0(c)
	return (c:IsFacedown() or c:IsLocation(LOCATION_GRAVE)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.filter1(c,e)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFacedown()) and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e) and c:IsAbleToDeck()
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xcf3e) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.sp1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			local ag=mat1:Filter(Card.IsFacedown,nil)
			if #ag~=0 then Duel.ConfirmCards(1-tp,ag) end
			Duel.SendtoDeck(mat1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
	end
end