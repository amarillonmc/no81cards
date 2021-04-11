--外道侵袭
if not pcall(function() require("expansions/script/c114500") end) then require("script/c114500") end
local m,cm = rscf.DefineCard(114516)
function cm.initial_effect(c)
	local e1 = rsef.A(c)
	local e2 = rsef.QO(c,nil,"pos",{1,m},"pos,tg",nil,LOCATION_SZONE,rscon.phmp,nil,rsop.target({cm.posfilter,"pos",LOCATION_MZONE},{cm.tgfilter,"tg",LOCATION_DECK}),cm.psop)
	local e3 = rsef.QO(c,EVENT_SPSUMMON,"sp",{1,m},"sp,fus",nil,LOCATION_SZONE,cm.fuscon,nil,cm.fustg,cm.fusop)
	local e4 = rsef.QO(c,nil,"sp",{1,m},"sp",nil,LOCATION_GRAVE,nil,aux.bfgcost,rsop.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
end
function cm.posfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.tgfilter(c)
	return c:IsSetCard(0xca4) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.psop(e,tp)
	local g,tc = rsop.SelectSolve("pos",tp,cm.posfilter,tp,LOCATION_MZONE,0,1,1,nil,{})
	if not tc then return end
	local pos = Duel.SelectPosition(tp,tc,POS_FACEUP)
	if Duel.ChangePosition(tc,pos) > 0 then
		rsop.SelectOC(nil,true)
		rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	end
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xca4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0
end
function cm.spop(e,tp)
	local ft = Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft < 1 then return end
	if ft > 1 and rscon.bsdcheck(tp) then ft = 1 end
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,math.min(ft,2),nil,{0,tp,tp,false,false,POS_FACEDOWN_DEFENSE},e,tp)
end
function cm.fuscon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0 and rscon.phmp(e,tp)
end
function cm.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e) and c:IsAbleToDeck()
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xca4) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.filter3(c,e)
	return not c:IsImmuneToEffect(e) and c:IsAbleToDeck() and c:IsLocation(LOCATION_HAND)
end
function cm.filter4(c)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToDeck()
end
function cm.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1 = Duel.GetFusionMaterial(tp):Filter(cm.filter4,nil)
		local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
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
function cm.fusop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1 = Duel.GetFusionMaterial(tp):Filter(cm.filter3,nil,e)
	local mg2=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_GRAVE,0,nil,e)
	mg1:Merge(mg2)
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
			local mat2 = mat1:Filter(Card.IsFacedown,nil)
			if #mat2 > 0 then
				Duel.ConfirmCards(1-tp,mat2)
			end
			Duel.SendtoDeck(mat1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
	end
end