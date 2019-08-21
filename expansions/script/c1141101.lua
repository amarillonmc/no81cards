--虹符『飞跃彩虹』
local m=1141101
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1141101.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c1141101.tg1)
	e1:SetOperation(c1141101.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c1141101.tg2)
	e2:SetOperation(c1141101.op2)
	c:RegisterEffect(e2)
--
end
--
c1141101.muxu_ih_KTatara=1
--
function c1141101.tfilter1(c)
	return c:IsType(TYPE_FLIP) and c:IsType(TYPE_MONSTER)
		and not c:IsPublic()
end
function c1141101.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1141101.tfilter1,tp,LOCATION_HAND,0,1,nil) end
end
function c1141101.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local sg=Duel.SelectMatchingCard(tp,c1141101.tfilter1,tp,LOCATION_HAND,0,1,1,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_PUBLIC)
		e1_1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1_1)
		local e1_2=Effect.CreateEffect(c)
		e1_2:SetType(EFFECT_TYPE_SINGLE)
		e1_2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1_2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
		e1_2:SetRange(LOCATION_HAND)
		e1_2:SetValue(function(e,c,mg) return true end)
		e1_2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1_2)
	end
end
--
function c1141101.allfilter2(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c1141101.ollfilter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c1141101.decfilter2(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
--
function c1141101.CheckRecursive2(c,mg,sg,exg,tp,fc,chkf)
	local b1=Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_MZONE,1,nil)
	local b2=sg:GetCount()>0 and sg:IsExists((function(c) return (c:IsFacedown() and c:IsLocation(LOCATION_MZONE)) end),1,nil)
	if exg and exg:IsContains(c) and not (b1 and b2) then return false end
	sg:AddCard(c)
	local res=false
	if sg:GetCount()>=fc.muxu_mat_count then
		res=Duel.GetLocationCountFromEx(chkf,tp,sg,fc)>0 and fc:CheckFusionMaterial(sg,nil,chkf)
	else
		res=mg:IsExists(c1141101.CheckRecursive2,1,sg,mg,sg,exg,tp,fc,chkf)
	end
	sg:RemoveCard(c)
	return res
end
--
function c1141101.tfilter2(c,e,tp,mg,exg,f,chkf)
	mg:Merge(exg)
	local sg=Group.CreateGroup()
	return c:IsType(TYPE_FUSION) 
		and muxu.check_set_Tatara(c) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and mg:IsExists(c1141101.CheckRecursive2,1,sg,mg,sg,exg,tp,c,chkf)
end
function c1141101.mfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION)
		and muxu.check_set_Tatara(c) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
--
function c1141101.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp)
		mg=mg:Filter(c1141101.allfilter2,nil)
		mg=mg:Filter(c1141101.ollfilter2,nil,e)
		local exg=Duel.GetMatchingGroup(c1141101.decfilter2,tp,LOCATION_DECK,0,mg,e)
		local res=Duel.IsExistingMatchingCard(c1141101.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,exg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c1141101.mfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--
function c1141101.op2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp)
	mg=mg:Filter(c1141101.allfilter2,nil)
	mg=mg:Filter(c1141101.ollfilter2,nil,e)
	local exg=Duel.GetMatchingGroup(c1141101.decfilter2,tp,LOCATION_DECK,0,mg,e)
	local sg1=Duel.GetMatchingGroup(c1141101.tfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,exg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		lg=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c1141101.tfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local lg=Group.CreateGroup()
			mg:Merge(exg)
			repeat
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local g=mg:FilterSelect(tp,c1141101.CheckRecursive2,1,1,lg,mg,lg,exg,tp,tc,chkf)
				lg:Merge(g)
			until lg:GetCount()==tc.muxu_mat_count
			tc:SetMaterial(lg)
			local qg=lg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
			qg=qg:Filter(Card.IsFacedown,nil)
			Duel.ConfirmCards(1-tp,qg)
			Duel.SendtoGrave(lg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
--
