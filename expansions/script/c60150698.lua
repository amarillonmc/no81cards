--天玲千夜融合
function c60150698.initial_effect(c)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60150698,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,60150698+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c60150698.target2)
	e3:SetOperation(c60150698.activate2)
	c:RegisterEffect(e3)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60150698,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c60150698.negcon)
	e2:SetCost(c60150698.negcost)
	e2:SetTarget(c60150698.tgtg)
	e2:SetOperation(c60150698.tgop)
	c:RegisterEffect(e2)
end
function c60150698.filter0(c,e,immchk)
	if immchk and c:IsImmuneToEffect(e) then return false end
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c60150698.filter1(c,e,tp,immchk)
	if immchk and c:IsImmuneToEffect(e) then return false end
	return c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and c:IsType(TYPE_MONSTER)
end
function c60150698.filterf(c,e,immchk)
	if immchk and c:IsImmuneToEffect(e) then return false end
	return c:IsAbleToDeck()
end
function c60150698.filter2(c,e,tp,m,f,chkf)
	return (c:IsSetCard(0x9b21) and c:IsType(TYPE_FUSION)) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c60150698.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c60150698.filterf,nil,e)
		local mgg=Duel.GetMatchingGroup(c60150698.filter1,tp,LOCATION_GRAVE,0,nil,e,tp)
		mg1:Merge(mgg)
		local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
		local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
		if ct1<ct2 then
			local sg=Duel.GetMatchingGroup(c60150698.filter0,tp,LOCATION_EXTRA,0,nil,e)
			mg1:Merge(sg)
			local res=Duel.IsExistingMatchingCard(c60150698.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					local mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					res=Duel.IsExistingMatchingCard(c60150698.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				end
			end
			return res
		else
			local res=Duel.IsExistingMatchingCard(c60150698.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
			if not res then
				local ce=Duel.GetChainMaterial(tp)
				if ce~=nil then
					local fgroup=ce:GetTarget()
					local mg2=fgroup(ce,e,tp)
					local mf=ce:GetValue()
					res=Duel.IsExistingMatchingCard(c60150698.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
				end
			end
			return res
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60150698.gfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsLocation(LOCATION_EXTRA)
end
function c60150698.gfilter2(c)
	return c:IsLocation(LOCATION_EXTRA)
end
function c60150698.activate2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c60150698.filterf,nil,e,true)
	local mgg=Duel.GetMatchingGroup(c60150698.filter1,tp,LOCATION_GRAVE,0,nil,e,tp,true)
	mg1:Merge(mgg)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if ct1<ct2 then
		local sg=Duel.GetMatchingGroup(c60150698.filter0,tp,LOCATION_EXTRA,0,nil,e,true)
		mg1:Merge(sg)
		local sg1=Duel.GetMatchingGroup(c60150698.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c60150698.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
				local g=mg1:Filter(c60150698.gfilter,nil)
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
				local g2=mg1:Filter(c60150698.gfilter2,nil)
				if g2:GetCount()>0 then
					local gtc2=g2:GetFirst()
					while gtc2 do
						mg1:RemoveCard(gtc2)
						gtc2=g2:GetNext()
					end
					Duel.SendtoGrave(g2,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				end
				Duel.SendtoDeck(mg1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
		local sg1=Duel.GetMatchingGroup(c60150698.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c60150698.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
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
				local g=mg1:Filter(c60150698.gfilter,nil)
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
				local g2=mg1:Filter(c60150698.gfilter2,nil)
				if g2:GetCount()>0 then
					local gtc2=g2:GetFirst()
					while gtc2 do
						mg1:RemoveCard(gtc2)
						gtc2=g2:GetNext()
					end
					Duel.SendtoGrave(g2,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				end
				Duel.SendtoDeck(mg1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
function c60150698.negcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)
end
function c60150698.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60150698.tgfilter(c)
	return c:IsSetCard(0x3b21) and c:IsType(TYPE_MONSTER)
end
function c60150698.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150698.tgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c60150698.tgfilter2(c)
	return c:IsType(TYPE_PENDULUM)
end
function c60150698.tgfilter3(c)
	return c:IsAbleToGrave()
end
function c60150698.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60150698.tgfilter,tp,LOCATION_DECK,0,nil)
	local g2=g:Filter(c60150698.tgfilter2,nil)
	local g3=g:Filter(c60150698.tgfilter3,nil)
	if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60150616,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150616,2))
		local sg=g2:Select(tp,1,1,nil)
		Duel.SendtoExtraP(sg,nil,REASON_EFFECT)
	elseif g3:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g3:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	else 
		return false
	end
end