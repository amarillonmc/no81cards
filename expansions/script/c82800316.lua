--红☆魔☆馆 幼月降临
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,82800331)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return (c:IsSetCard(0x868) and c:IsType(TYPE_MONSTER) or c:IsCode(82800331)) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.filter1(c,e)
	return c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsSetCard(0x868) and c:IsType(TYPE_FUSION) and c:IsLevelAbove(8) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.fcffilter(c)
	return c:GetFlagEffect(id)>0 and c:IsLocation(LOCATION_DECK)
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(s.fcffilter,nil)<=1
end
function s.gcheck(sg)
	return sg:FilterCount(s.fcffilter,nil)<=1
end
function s.exfilter1(c,e)
	if c:GetCounter(0x1868)==0 then return end
	local e1=nil
	local e2=nil
	if c:IsType(TYPE_SPELL+TYPE_TRAP) then
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_MONSTER+TYPE_EFFECT)
		c:RegisterEffect(e1,true)
	end
	--fusion substitute
	e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	c:RegisterEffect(e2,true)
	local res=c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e) 
	if e1 then e1:Reset() end
	if e2 then e2:Reset() end
	return res
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
		local exg=Duel.GetMatchingGroup(s.exfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil,e)
		if exg:GetCount()>0 then
			local e5=nil
			local e6=nil
			for exc in aux.Next(exg) do
				if exc:IsType(TYPE_SPELL+TYPE_TRAP) then 
					e5=Effect.CreateEffect(e:GetHandler())
					e5:SetType(EFFECT_TYPE_SINGLE)
					e5:SetCode(EFFECT_CHANGE_TYPE)
					e5:SetValue(TYPE_MONSTER+TYPE_EFFECT)
					e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
					exc:RegisterEffect(e5,true)
				end
				--fusion substitute
				e6=Effect.CreateEffect(e:GetHandler())
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetCode(EFFECT_FUSION_SUBSTITUTE)
				e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				exc:RegisterEffect(e6,true)
			end
			mg1:Merge(exg)
			aux.FCheckAdditional=s.fcheck
			aux.GCheckAdditional=s.gcheck
			exmat=true
		end
		local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		end
		if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(82738008,0)) then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc:CompleteProcedure()
		end
		if e5 then e5:Reset() end
		if e6 then e5:Reset() end
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
end
function s.splimit(e,c)
	return not c:IsSetCard(0x868) 
end