--电子化忍者
local m=11451699
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCondition(cm.stcon)
	e2:SetTarget(cm.sttg)
	e2:SetOperation(cm.stop)
	c:RegisterEffect(e2)
end
_FCheckMix=aux.FCheckMix
function cm.FCheckMix(c,mg,sg,fc,sub,fun1,fun2,...)
	if fun2 then
		sg:AddCard(c)
		local res=false
		if fun1(c,fc,false,mg,sg) then
			res=mg:IsExists(cm.FCheckMix,1,sg,mg,sg,fc,sub,fun2,...)
		elseif sub and fun1(c,fc,true,mg,sg) and not c:IsLocation(LOCATION_DECK) then
			res=mg:IsExists(cm.FCheckMix,1,sg,mg,sg,fc,false,fun2,...)
		elseif sub and fun1(c,fc,true,mg,sg) and c:IsLocation(LOCATION_DECK) then
			res=mg:IsExists(cm.FCheckMix2,1,sg,mg,sg,fc,sub,fun2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		return fun1(c,fc,sub,mg,sg)
	end
end
function cm.FCheckMix2(c,mg,sg,fc,sub,fun1,fun2,...)
	if fun2 then
		sg:AddCard(c)
		local res=false
		if fun1(c,fc,false,mg,sg) then
			res=mg:IsExists(cm.FCheckMix2,1,sg,mg,sg,fc,sub,fun2,...)
		elseif sub and fun1(c,fc,true,mg,sg) and c:IsLocation(LOCATION_DECK) then
			res=mg:IsExists(cm.FCheckMix2,1,sg,mg,sg,fc,sub,fun2,...)
		end
		sg:RemoveCard(c)
		return res
	else
		return fun1(c,fc,false,mg,sg) or (sub and fun1(c,fc,true,mg,sg) and c:IsLocation(LOCATION_DECK))
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(c,REASON_COST)
end
function cm.mfilter1(c,e)
	return c:IsLocation(LOCATION_HAND) and not c:IsImmuneToEffect(e)
end
function cm.mfilter3(c)
	return c:IsRace(RACE_WARRIOR) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function cm.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x93) and c:IsRace(RACE_WARRIOR) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp)
		local mg1=mg:Filter(Card.IsLocation,nil,LOCATION_HAND)
		local res=Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if res then return true end
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		aux.FCheckAdditional=cm.fcheck
		aux.FCheckMix=cm.FCheckMix
		local mg2=Duel.GetMatchingGroup(cm.mfilter3,tp,LOCATION_DECK,0,nil)
		mg1:Merge(mg2)
		local eset={}
		for tc in aux.Next(mg2) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
			tc:RegisterEffect(e1)
			table.insert(eset,e1)
		end
		res=Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.FCheckMix=_FCheckMix
		for _,te in pairs(eset) do
			te:Reset()
		end
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg4=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg4,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg=Duel.GetFusionMaterial(tp)
	local mg1=mg:Filter(cm.mfilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
	local mg2=Duel.GetMatchingGroup(cm.mfilter3,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local mg4=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg4=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg4,mf,chkf)
	end
	aux.FCheckAdditional=cm.fcheck
	aux.FCheckMix=cm.FCheckMix
	local mg2=Duel.GetMatchingGroup(cm.mfilter3,tp,LOCATION_DECK,0,nil)
	mg1:Merge(mg2)
	local eset={}
	for tc in aux.Next(mg2) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_FUSION_SUBSTITUTE)
		tc:RegisterEffect(e1)
		table.insert(eset,e1)
	end
	local sg2=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	sg1:Merge(sg2)
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat2)
			Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			aux.FCheckAdditional=nil
			aux.FCheckMix=_FCheckMix
			for _,te in pairs(eset) do
				te:Reset()
			end
			local mat=Duel.SelectFusionMaterial(tp,tc,mg4,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
	aux.FCheckMix=_FCheckMix
	for _,te in pairs(eset) do
		te:Reset()
	end
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and tp==c:GetOwner()
end
function cm.filter(c)
	return c:IsSetCard(0x61) and c:IsFaceup()
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local b1=c:IsLocation(LOCATION_MZONE) and c:IsDestructable()
	local b2=c:IsLocation(LOCATION_GRAVE) and (s1 or s2)
	if chk==0 then return (b1 or b2) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	local opt=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if opt then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	elseif b1 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_GRAVE)
	end
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	local s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
	local b1=c:IsLocation(LOCATION_MZONE) and c:IsDestructable()
	local b2=c:IsLocation(LOCATION_GRAVE) and (s1 or s2)
	local opt=Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if b1 and Duel.Destroy(c,REASON_EFFECT)>0 and opt then
		s1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		s2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		b2=c:IsLocation(LOCATION_GRAVE) and (s1 or s2)
		if b2 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			local op=0
			if s1 and s2 then
				op=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))
			elseif s1 then
				op=Duel.SelectOption(tp,aux.Stringid(m,4))
			elseif s2 then
				op=Duel.SelectOption(tp,aux.Stringid(m,5))+1
			else return end
			if op==0 then
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
			end
		end
	elseif b2 then
		local op=0
		if s1 and s2 then
			op=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))
		elseif s1 then
			op=Duel.SelectOption(tp,aux.Stringid(m,4))
		elseif s2 then
			op=Duel.SelectOption(tp,aux.Stringid(m,5))+1
		else return end
		if op==0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP)
		end
		b1=c:IsLocation(LOCATION_MZONE) and c:IsDestructable()
		if b1 and opt and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Destroy(c,REASON_EFFECT)
		end
	end
end