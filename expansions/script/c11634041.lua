local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_FIRE),3)
	local e_name=Effect.CreateEffect(c)
	e_name:SetDescription(aux.Stringid(id,0))
	e_name:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e_name:SetType(EFFECT_TYPE_IGNITION)
	e_name:SetRange(LOCATION_MZONE)
	e_name:SetCountLimit(1,id)
	e_name:SetCost(s.cost)
	e_name:SetOperation(s.operation)
	c:RegisterEffect(e_name)
	local e_reg=Effect.CreateEffect(c)
	e_reg:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e_reg:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e_reg:SetCode(EVENT_SPSUMMON_SUCCESS)
	e_reg:SetCondition(s.matcon)
	e_reg:SetOperation(s.matop)
	c:RegisterEffect(e_reg)
	local e_mtchk=Effect.CreateEffect(c)
	e_mtchk:SetType(EFFECT_TYPE_SINGLE)
	e_mtchk:SetCode(EFFECT_MATERIAL_CHECK)
	e_mtchk:SetValue(s.valcheck)
	e_mtchk:SetLabelObject(e_reg)
	c:RegisterEffect(e_mtchk)
	local e_cgatt=Effect.CreateEffect(c)
	e_cgatt:SetType(EFFECT_TYPE_FIELD)
	e_cgatt:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e_cgatt:SetRange(LOCATION_MZONE)
	e_cgatt:SetTargetRange(0,LOCATION_MZONE)
	e_cgatt:SetValue(ATTRIBUTE_FIRE)
	e_cgatt:SetCondition(function(e)return e:GetHandler():GetFlagEffect(id)>0 end)
	c:RegisterEffect(e_cgatt)
	local e_exmat_1=Effect.CreateEffect(c)
	e_exmat_1:SetDescription(aux.Stringid(id,5))
	e_exmat_1:SetType(EFFECT_TYPE_FIELD)
	e_exmat_1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e_exmat_1:SetCode(EFFECT_SPSUMMON_PROC)
	e_exmat_1:SetRange(LOCATION_EXTRA)
	e_exmat_1:SetLabelObject(c)
	e_exmat_1:SetCondition(s.linkcon)
	e_exmat_1:SetOperation(s.linkop)
	e_exmat_1:SetValue(SUMMON_TYPE_LINK)
	local e_exmat_2=Effect.CreateEffect(c)
	e_exmat_2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e_exmat_2:SetRange(LOCATION_MZONE)
	e_exmat_2:SetTargetRange(LOCATION_EXTRA,0)
	e_exmat_2:SetTarget(s.mattg)
	e_exmat_2:SetLabelObject(e_exmat_1)
	c:RegisterEffect(e_exmat_2)
end
function s.cfilter1(c)
	return c:IsSetCard(0x119) and not c:IsPublic()
end
function s.cfilter2(c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and c:IsAbleToExtraAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_EXTRA,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,1)},{b2,aux.Stringid(id,2)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_EXTRA,0,1,1,nil)
		e:SetLabel(g:GetFirst():GetCode())
		Duel.ConfirmCards(1-tp,g)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		e:SetLabel(g:GetFirst():GetCode())
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	end
end
function s.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function s.spf(c,mg,e,tp,m,f,chkf)
	return c:IsSetCard(0x119) and (c:IsSynchroSummonable(nil,mg) or c:IsXyzSummonable(mg) or c:IsLinkSummonable(mg) or (c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)))
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local cc=Duel.SelectMatchingCard(tp,function(c,code)return c:IsFaceup() and not c:IsCode(code)end,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if not cc or cc:IsImmuneToEffect(e) then return end
	Duel.HintSelection(Group.FromCards(cc))
	local change_code=Effect.CreateEffect(c)
	change_code:SetType(EFFECT_TYPE_SINGLE)
	change_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	change_code:SetReset(RESET_EVENT+RESETS_STANDARD)
	change_code:SetCode(EFFECT_CHANGE_CODE)
	change_code:SetValue(code)
	cc:RegisterEffect(change_code)
	if c:GetFlagEffect(id)==0 then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	local mg2=Duel.GetMatchingGroup(s.filter1,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	local lg=c:GetLinkedGroup():Filter(function(c,e,tp)return c:IsControler(tp) or not c:IsImmuneToEffect(e)end,nil,e,tp)
	mg1=Group.__band(mg1,lg)
	local sg1=Duel.GetMatchingGroup(s.spf,tp,LOCATION_EXTRA,0,nil,lg,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg1=Duel.GetMatchingGroup(s.spf,tp,LOCATION_EXTRA,0,nil,lg,e,tp,mg3,mf,chkf)
	end
	if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.BreakEffect()
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		if tc:IsType(TYPE_FUSION) then
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		elseif tc:IsType(TYPE_SYNCHRO) then
			Duel.SynchroSummon(tp,tc,nil,lg)
		elseif tc:IsType(TYPE_XYZ) then
			Duel.XyzSummon(tp,tc,lg)
		elseif tc:IsType(TYPE_LINK) then
			Duel.LinkSummon(tp,tc,lg)
		end
	end
end
function s.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function s.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,id) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function s.lmfilter(c,lc,tp,og,lmat,lg)
	if c:IsControler(1-tp) and not lg:IsContains(c) then return false end
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsLinkCode(lc:GetCode()) and Duel.GetLocationCountFromEx(tp,tp,c,lc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_LMATERIAL) and (not og or og:IsContains(c)) and (not lmat or lmat==c)
end
function s.linkcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.lmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c,tp,og,lmat,e:GetLabelObject():GetLinkedGroup())
end
function s.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local mg=Duel.SelectMatchingCard(tp,s.lmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,c,tp,og,lmat,e:GetLabelObject():GetLinkedGroup())
	c:SetMaterial(mg)
	Duel.SendtoGrave(mg,REASON_MATERIAL+REASON_LINK)
end
function s.mattg(e,c)
	return c:IsSetCard(0x119) and c:IsType(TYPE_LINK)
end
