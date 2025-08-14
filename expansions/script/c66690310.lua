--蒸汽朋克阶跃同频
local s,id,o=GetID()
function s.initial_effect(c)

	-- 可以从以下选择1个发动（这个卡名的以下效果1回合各能选择1次）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK|CATEGORY_SPECIAL_SUMMON|CATEGORY_FUSION_SUMMON|CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 可以从以下选择1个发动（这个卡名的以下效果1回合各能选择1次）
function s.filter0(c)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) 
		and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end

function s.filter1(c,e)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) 
		and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end

function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x666b) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end

function s.sfilter1(c,e,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0x666b) and c:IsType(TYPE_SYNCHRO) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.IsExistingMatchingCard(s.sfilter2,tp,LOCATION_GRAVE,0,1,nil,tp,lv)
end

function s.sfilter2(c,tp,lv)
	local rlv=lv-c:GetLevel()
	local rg=Duel.GetMatchingGroup(s.sfilter3,tp,LOCATION_GRAVE,0,c)
	return rlv>0 and c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
		and rg:CheckWithSumEqual(Card.GetLevel,rlv,1,63)
end

function s.sfilter3(c)
	return c:GetLevel()>0 and not c:IsType(TYPE_TUNER) and c:IsAbleToRemove()
end

function s.spfilter(c,e,tp)
	return c:IsFaceupEx() and c:IsSetCard(0x666b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666b) and not c:IsType(TYPE_TOKEN)
end

function s.xyzfilter(c,mg)
	return c:IsSetCard(0x666b) and c:IsXyzSummonable(mg)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local b1=(Duel.GetFlagEffect(tp,id)==0 or not e:IsCostChecked()) and
		(function()
			local chkf=tp
			local mg=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					local mg3=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
				end
			end
			return res
		end)()
	local b2=(Duel.GetFlagEffect(tp,id+1)==0 or not e:IsCostChecked()) and
		aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) and
		Duel.IsExistingMatchingCard(s.sfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b3=(Duel.GetFlagEffect(tp,id+2)==0 or not e:IsCostChecked()) and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1),1},
		{b2,aux.Stringid(id,2),2},
		{b3,aux.Stringid(id,3),3})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
		end
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
		end
	elseif op==3 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
		if e:IsCostChecked() then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(0)
			Duel.RegisterFlagEffect(tp,id+2,RESET_PHASE+PHASE_END,0,1)
		end
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter1),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
		local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
		local mg3=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
		end
		if #sg1>0 or (sg2 and #sg2>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (not sg2 or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
				tc:SetMaterial(mat)
				if mat:IsExists(Card.IsFacedown,1,nil) then
					Duel.ConfirmCards(1-tp,mat:Filter(Card.IsFacedown,nil))
				end
				if mat:Filter(s.cfilter,nil):GetCount()>0 then
					Duel.HintSelection(mat:Filter(s.cfilter,nil))
				end
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
	elseif op==2 then
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,s.sfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g1==0 then return end
		local lv=g1:GetFirst():GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g2=Duel.SelectMatchingCard(tp,s.sfilter2,tp,LOCATION_GRAVE,0,1,1,nil,tp,lv)
		if #g2==0 then return end
		local rlv=lv-g2:GetFirst():GetLevel()
		local rg=Duel.GetMatchingGroup(s.sfilter3,tp,LOCATION_GRAVE,0,g2:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g3=rg:SelectWithSumEqual(tp,Card.GetLevel,rlv,1,63)
		if not g3 then return end
		g2:Merge(g3)
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		local sc=g1:GetFirst()
		sc:SetMaterial(nil)
		Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	elseif op==3 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.AdjustAll()
			local mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,0,nil)
			if Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
				and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
				Duel.BreakEffect()
				Duel.XyzSummon(tp,xyz,mg,1,6)
			end
		end
	end
end

function s.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())
end
