--刹那的永恒
function c60150607.initial_effect(c)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60150607,0))
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCountLimit(1,60150607+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c60150607.target2)
	e3:SetOperation(c60150607.activate2)
	c:RegisterEffect(e3)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150607,1))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,60150607+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60150607.target)
	e1:SetOperation(c60150607.activate)
	c:RegisterEffect(e1)
end
function c60150607.splimit(e,c)
	return not c:IsSetCard(0x3b21)
end
function c60150607.spfilter2(c,e)
	return (c:IsSetCard(0x3b21) and c:IsType(TYPE_FUSION)) and c:IsAbleToExtra() and c:IsFaceup()
end
function c60150607.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and chkc:IsAbleToExtra() end
	if chk==0 then return Duel.IsExistingTarget(c60150607.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c60150607.spfilter2,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150607,1))
end
function c60150607.spfilter(c,e,tp)
	return c:IsSetCard(0x3b21) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60150607.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)>0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local g=Duel.GetMatchingGroup(c60150607.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150607,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c60150607.filter0(c,e,immchk)
	if immchk and c:IsImmuneToEffect(e) then return false end
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c60150607.filter1(c,e,tp,immchk)
	if immchk and c:IsImmuneToEffect(e) then return false end
	return c:IsAbleToGrave() or (c:IsType(TYPE_PENDULUM) and c:IsAbleToDeck())
end
function c60150607.filter2(c,e,tp,m,f,chkf)
	return (c:IsSetCard(0x3b21) and c:IsType(TYPE_FUSION)) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c60150607.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c60150602.filter1,nil,e,tp)
		local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
		local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
		if ct1<ct2 then
			local sg=Duel.GetMatchingGroup(c60150607.filter0,tp,LOCATION_EXTRA,0,nil,e)
			mg1:Merge(sg)
			local res=Duel.IsExistingMatchingCard(c60150607.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					local mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					res=Duel.IsExistingMatchingCard(c60150607.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				end
			end
			return res
		else
			local res=Duel.IsExistingMatchingCard(c60150607.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					local mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					res=Duel.IsExistingMatchingCard(c60150607.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				end
			end
			return res
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150607,0))
end
function c60150607.gfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsLocation(LOCATION_EXTRA)
end
function c60150607.gfilter2(c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c60150607.activate2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c60150602.filter1,nil,e,tp,true)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if ct1<ct2 then
		local sg=Duel.GetMatchingGroup(c60150607.filter0,tp,LOCATION_EXTRA,0,nil,e,true)
		mg1:Merge(sg)
		local sg1=Duel.GetMatchingGroup(c60150607.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c60150607.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mg1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mg1)
				local mtc=mg1:GetFirst()
				while mtc do
						if not mtc:IsFaceup() or mtc:IsLocation(LOCATION_EXTRA) then Duel.ConfirmCards(1-tp,mtc) end
						mtc=mg1:GetNext()
					end
				local g=mg1:Filter(c60150607.gfilter,nil)
				if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150602,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150602,1))
					local sg=g:Select(tp,1,g:GetCount(),nil)
					local gtc=sg:GetFirst()
					while gtc do
						mg1:RemoveCard(gtc)
						gtc=sg:GetNext()
					end
					Duel.SendtoExtraP(sg,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				end
				local g2=mg1:Filter(c60150607.gfilter2,nil)
				if g2:GetCount()>0 then
					local gtc=g2:GetFirst()
					while gtc do
						mg1:RemoveCard(gtc)
						gtc=g2:GetNext()
					end
					Duel.SendtoDeck(g2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				end
				Duel.SendtoGrave(mg1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	else
		local sg1=Duel.GetMatchingGroup(c60150607.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c60150607.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mg1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mg1)
				local mtc=mg1:GetFirst()
				while mtc do
						if not mtc:IsFaceup() or mtc:IsLocation(LOCATION_EXTRA) then Duel.ConfirmCards(1-tp,mtc) end
						mtc=mg1:GetNext()
					end
				local g=mg1:Filter(c60150607.gfilter,nil)
				if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150602,0)) then
					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150602,1))
					local sg=g:Select(tp,1,g:GetCount(),nil)
					local gtc=sg:GetFirst()
					while gtc do
						mg1:RemoveCard(gtc)
						gtc=sg:GetNext()
					end
					Duel.SendtoExtraP(sg,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				end
				local g2=mg1:Filter(c60150607.gfilter2,nil)
				if g2:GetCount()>0 then
					local gtc=g2:GetFirst()
					while gtc do
						mg1:RemoveCard(gtc)
						gtc=g2:GetNext()
					end
					Duel.SendtoDeck(g2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				end
				Duel.SendtoGrave(mg1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	end
end