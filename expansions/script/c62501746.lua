--蚀痕无命 归誓零械
function c62501746.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xea4),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,1,true)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(c62501746.splimit)
	c:RegisterEffect(e0)
	--spsummon
	local se0=Effect.CreateEffect(c)
	se0:SetType(EFFECT_TYPE_FIELD)
	se0:SetCode(EFFECT_SPSUMMON_PROC)
	se0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se0:SetRange(LOCATION_EXTRA)
	--se0:SetValue(SUMMON_TYPE_FUSION)
	se0:SetCondition(c62501746.sprcon)
	se0:SetTarget(c62501746.sprtg)
	se0:SetOperation(c62501746.sprop)
	c:RegisterEffect(se0)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(62501746,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,62501746)
	e1:SetCondition(c62501746.efcon)
	e1:SetTarget(c62501746.eftg)
	e1:SetOperation(c62501746.efop)
	c:RegisterEffect(e1)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,62501746+1)
	e4:SetTarget(c62501746.fstg)
	e4:SetOperation(c62501746.fsop)
	c:RegisterEffect(e4)
	c62501746.remove_event_effect=e4
end
function c62501746.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.fuslimit(e,se,sp,st)
end
function c62501746.matfilter(c)
	return c:IsFacedown() and c:IsAbleToDeckOrExtraAsCost() and c:IsCanBeFusionMaterial()
end
function c62501746.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetOwner()
	local mg=Duel.GetMatchingGroup(c62501746.matfilter,tp,LOCATION_REMOVED,0,nil)
	return #mg>=6 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c62501746.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c62501746.matfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=mg:SelectSubGroup(tp,aux.TRUE,true,6,6,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c62501746.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.SendtoDeck(mg,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
	mg:DeleteGroup()
end
function c62501746.efcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function c62501746.efilter(e)
	local ct=#c62501746.effect_list
	if e:GetCode()==EVENT_REMOVE and (e:GetType()&EFFECT_TYPE_SINGLE)==EFFECT_TYPE_SINGLE and e:IsActivated() then c62501746.effect_list[ct+1]=e end
	return false
end
function c62501746.cfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0xea4) and not c:IsCode(62501746) and (not c:IsOnField() or c:IsFaceup()) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)) then return false end
	local te=c.remove_event_effect
	if not te then return false end
	local check=e:IsCostChecked()
	e:SetCostCheck(false)
	local tg=te:GetTarget()
	local res=not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
	--[[c62501746.effect_list={}
	c:IsOriginalEffectProperty(c62501746.efilter)
	for _,te in ipairs(c62501746.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end]]
	e:SetCostCheck(check)
	return res
end
function c62501746.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() and Duel.IsExistingMatchingCard(c62501746.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	local g=Duel.GetMatchingGroup(c62501746.cfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_ONFIELD,0,nil,e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
	Duel.SetTargetCard(sg)
end
function c62501746.efop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc then return end
	--[[c62501746.effect_list={}
	tc:IsOriginalEffectProperty(c62501746.efilter)
	local e_list={}
	for _,te in ipairs(c62501746.effect_list) do
		local tg=te:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then table.insert(e_list,te) end--if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(c62501746.effect_list,i) end
	end
	if #e_list==0 then return end
	local te=e_list[1]
	if #e_list>1 then
		local des_list={}
		for _,te in ipairs(e_list) do table.insert(des_list,te:GetDescription()) end
		local op=Duel.SelectOption(tp,table.unpack(des_list))
		te=e_list[op+1]
	end
	c62501746.effect_list={}]]
	local te=tc.remove_event_effect
	--copy
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	e:SetProperty(EFFECT_FLAG_DELAY)--Original Property
end
function c62501746.filter0(c,tp,e)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove(tp,POS_FACEDOWN) and (not e or not c:IsImmuneToEffect(e))
end
function c62501746.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c62501746.fcheck(tp,sg,fc)
	if sg:FilterCount(Card.IsControler,nil,1-tp)>1 then return false end
	local g=sg:Filter(Card.IsControler,nil,tp)
	return g:GetClassCount(Card.GetLocation)==#g
end
function c62501746.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c62501746.filter0,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
		aux.FCheckAdditional=c62501746.fcheck
		local res=Duel.IsExistingMatchingCard(c62501746.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c62501746.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_ONFIELD)
end
function c62501746.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(c62501746.filter0,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,e)
	aux.FCheckAdditional=c62501746.fcheck
	local sg1=Duel.GetMatchingGroup(c62501746.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c62501746.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.ConfirmCards(1-tp,mat1)
			Duel.Remove(mat1,POS_FACEDOWN,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
end
