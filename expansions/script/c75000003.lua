--救世神龙 传承琉迩
function c75000003.initial_effect(c)
	aux.AddCodeList(c,75000001)
	c:SetUniqueOnField(1,0,75000003)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFunRep(c,75000001,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3751),1,63,true,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--gain effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c75000003.valcheck)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c75000003.regcon)
	e2:SetOperation(c75000003.regop)
	e2:SetLabelObject(e1) 
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000003,5))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1,75000003+EFFECT_COUNT_CODE_DUEL)
	e3:SetTarget(c75000003.fstg)
	e3:SetOperation(c75000003.fsop)
	c:RegisterEffect(e3)
end
c75000003.material_setcode=0x3751
function c75000003.valcheck(e,c)
	local val=c:GetMaterialCount()
	e:SetLabel(val)
end
function c75000003.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabelObject():GetLabel()~=0
end
function c75000003.regop(e,tp,eg,ep,ev,re,r,rp)
	local vt=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if vt>=2 then
		--to hand
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(75000003,3))
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetTarget(c75000003.settg)
		e1:SetOperation(c75000003.setop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75000003,0))
	end
	if vt>=3 then
		--attack twice
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75000003,1))
	end
	if vt>=4 then
		--spsummon
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(75000003,4))
		e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCountLimit(1)
		e3:SetCondition(c75000003.spcon)
		e3:SetTarget(c75000003.sptg)
		e3:SetOperation(c75000003.spop)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(75000003,2))
	end
end
function c75000003.setfilter(c)
	return c:IsSetCard(0x3751) and c:IsSSetable()
end
function c75000003.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000003.setfilter,tp,LOCATION_DECK+0x10,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c75000003.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75000003.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not sc or Duel.SSet(tp,sc)==0 then return end
end
function c75000003.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c75000003.spfilter(c,e,tp)
	return c:IsSetCard(0x3751) and not c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0 or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c75000003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000003.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE)
end
function c75000003.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c75000003.spfilter),tp,LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if sc then
		Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c75000003.filter0(c)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function c75000003.filter1(c,e)
	return (c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function c75000003.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,75000001) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c75000003.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(c75000003.filter0,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local res=Duel.IsExistingMatchingCard(c75000003.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c75000003.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c75000003.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c75000003.filter1),tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c75000003.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c75000003.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat)
			if mat:IsExists(Card.IsFacedown,1,nil) then
				local cg=mat:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(1-tp,cg)
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
end
