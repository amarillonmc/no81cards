local m=15005922
local cm=_G["c"..m]
cm.name="龙芯残机-驱动苍壁"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),8,3,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.econ)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsRank(8) and c:IsRace(RACE_MACHINE) and not c:IsCode(15005922)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.cfilter2(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():GetOverlayCount()==0
end
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function cm.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9f43) and c:IsControler(tp)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.b1filter(c,mc,e,tp)
	return c:IsSetCard(0x9f43) and c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (mc:IsType(TYPE_XYZ) and c:IsCanOverlay()))
end
function cm.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function cm.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9f43) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.filter3(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.fcheck(ec)
	return  function(tp,sg,fc)
				return sg:FilterCount(Card.IsControler,nil,1-tp)<=ec:GetOverlayCount() and ec:CheckRemoveOverlayCard(tp,sg:FilterCount(Card.IsControler,nil,1-tp),REASON_EFFECT)
			end
end
function cm.gcheck(tp,ec)
	return  function(sg)
				return sg:FilterCount(Card.IsControler,nil,1-tp)<=ec:GetOverlayCount() and ec:CheckRemoveOverlayCard(tp,sg:FilterCount(Card.IsControler,nil,1-tp),REASON_EFFECT)
			end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(cm.b1filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e:GetHandler(),e,tp)
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cm.filter0,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		aux.FCheckAdditional=cm.fcheck(c)
		aux.GCheckAdditional=cm.gcheck(tp,c)
		local b2=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not b2 then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				b2=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return b1 or b2
	end
	local b1=Duel.IsExistingMatchingCard(cm.b1filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e:GetHandler(),e,tp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	local mg2=Duel.GetMatchingGroup(cm.filter0,tp,0,LOCATION_MZONE,nil)
	mg1:Merge(mg2)
	aux.FCheckAdditional=cm.fcheck(c)
	aux.GCheckAdditional=cm.gcheck(tp,c)
	local b2=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	if not b2 then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			b2=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,sel+1))
	if sel==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	local c=e:GetHandler()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.b1filter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e:GetHandler(),e,tp)
		local tc=g:GetFirst()
		if tc then
			if c:IsType(TYPE_XYZ) and tc:IsCanOverlay() and (not (tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))==1) then
				Duel.Overlay(c,Group.FromCards(tc))
			else
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter3,nil,e)
		local mg2=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_MZONE,nil,e)
		mg1:Merge(mg2)
		local exmat=true
		if exmat then
			aux.FCheckAdditional=cm.fcheck(c)
			aux.GCheckAdditional=cm.gcheck(tp,c)
		end
		local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		local mg3=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
		end
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if not tc then return end
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if exmat then
				aux.FCheckAdditional=cm.fcheck(c)
				aux.GCheckAdditional=cm.gcheck(tp,c)
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			local mato=mat1:Filter(Card.IsControler,nil,1-tp)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			if #mato~=0 then
				Duel.BreakEffect()
				c:RemoveOverlayCard(tp,#mato,#mato,REASON_EFFECT)
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end