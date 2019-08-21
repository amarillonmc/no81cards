--可怜的非法投弃物·多多良小伞
local m=1141002
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Tatara=true
--
function c1141002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1141002,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c1141002.tg1)
	e1:SetOperation(c1141002.op1)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e3:SetOperation(c1141002.op3)
	c:RegisterEffect(e3)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1141002,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c1141002.cost2)
	e2:SetTarget(c1141002.tg2)
	e2:SetOperation(c1141002.op2)
	c:RegisterEffect(e2)
--
end
--
c1141002.muxu_ih_KTatara=1
--
function c1141002.tfilter1(c)
	return c.muxu_ih_KTatara and c:IsAbleToHand()
		and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c1141002.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1141002.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	if e:GetHandler():GetFlagEffect(1141002)~=0 then
		e:SetLabel(1)
		e:GetHandler():ResetFlagEffect(1141002)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
--
function c1141002.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c1141002.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if not tc:IsLocation(LOCATION_HAND) then return end
		if e:GetLabel()==1 and Duel.SelectYesNo(tp,aux.Stringid(1141002,2)) then return end
		Duel.BreakEffect()
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
	end
end
--
function c1141002.op3(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(1141002,0,0,0)
end
--
function c1141002.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--
function c1141002.allfilter2(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c1141002.ollfilter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c1141002.decfilter2(c,e)
	return not c:IsImmuneToEffect(e)
end
--
function c1141002.CheckRecursive2(c,mg,sg,exg,tp,fc,chkf)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()>=fc.muxu_mat_count then
		res=Duel.GetLocationCountFromEx(chkf,tp,sg,fc)>0 and fc:CheckFusionMaterial(sg,nil,chkf)
	else
		res=mg:IsExists(c1141002.CheckRecursive2,1,sg,mg,sg,exg,tp,fc,chkf)
	end
	sg:RemoveCard(c)
	return res
end
--
function c1141002.tfilter2(c,e,tp,mg,exg,f,chkf)
	mg:Merge(exg)
	local sg=Group.CreateGroup()
	return c:IsType(TYPE_FUSION) 
		and muxu.check_set_Tatara(c) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and mg:IsExists(c1141002.CheckRecursive2,1,sg,mg,sg,exg,tp,c,chkf)
end
function c1141002.mfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION)
		and muxu.check_set_Tatara(c) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
--
function c1141002.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp)
		mg=mg:Filter(c1141002.allfilter2,nil)
		mg=mg:Filter(c1141002.ollfilter2,nil,e)
		Duel.RegisterFlagEffect(1-tp,1141002,0,0,0)
		local exg=Duel.GetMatchingGroup(c1141002.decfilter2,tp,0,LOCATION_MZONE,mg,e)
		local res=Duel.IsExistingMatchingCard(c1141002.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,exg,nil,chkf)
		Duel.ResetFlagEffect(1-tp,1141002)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c1141002.mfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
--
function c1141002.op2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp)
	mg=mg:Filter(c1141002.allfilter2,nil)
	mg=mg:Filter(c1141002.ollfilter2,nil,e)
	Duel.RegisterFlagEffect(1-tp,1141002,0,0,0)
	local exg=Duel.GetMatchingGroup(c1141002.decfilter2,tp,0,LOCATION_MZONE,mg,e)
	local sg1=Duel.GetMatchingGroup(c1141002.tfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,exg,nil,chkf)
	Duel.ResetFlagEffect(1-tp,1141002)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		lg=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c1141002.tfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local lg=Group.CreateGroup()
			Duel.RegisterFlagEffect(1-tp,1141002,0,0,0)
			mg:Merge(exg)
			repeat
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local g=mg:FilterSelect(tp,c1141002.CheckRecursive2,1,1,lg,mg,lg,exg,tp,tc,chkf)
				lg:Merge(g)
			until lg:GetCount()>=tc.muxu_mat_count
			tc:SetMaterial(lg)
			Duel.ResetFlagEffect(1-tp,1141002)
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
