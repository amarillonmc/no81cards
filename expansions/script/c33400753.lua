--七罪 诡秘融合
local m=33400753
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function cm.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsSetCard(0x341)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.ffilter(c,tp)
	return c:IsOnField() and c:IsControler(1-tp)
end
function cm.fcheck(tp,sg,fc)
	return sg:FilterCount(cm.ffilter,nil,tp)<=1
end
function cm.ckfilter(c)
	return c:GetCode()~=c:GetOriginalCode()
end
function cm.thfilter(c)
	return c:IsSetCard(0x3342) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(cm.filter0,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(mg2)
		Auxiliary.FCheckAdditional=cm.fcheck
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local ss=0
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp)
	local mg2=Duel.GetMatchingGroup(cm.filter1,tp,0,LOCATION_MZONE,nil,e)
	mg1:Merge(mg2)
	Auxiliary.FCheckAdditional=cm.fcheck
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			Auxiliary.FCheckAdditional=cm.fcheck
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			if mat1:Filter(cm.ckfilter,nil):GetCount()>0 then 
			ss=1
			end
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
		if ss==1 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,c) and Duel.SelectYesNo(tp,aux.Stringid(m,0))  then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g6=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,c)
			if Duel.SendtoGrave(g6,REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g7=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g7,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g7)  
			end
		end  
	end
end


function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and c:IsSetCard(0x3342) and not c:IsCode(m)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	 Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil) then return end 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,tg)
	Duel.SSet(tp,tg)
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_SZONE,0,nil)
	 Duel.ShuffleSetCard(sg)
	local tc=tg:GetFirst()
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 and   Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then 
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
		local ck=Duel.SelectMatchingCard(1-tp,Card.IsFacedown,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.ConfirmCards(tp,ck)
		Duel.ConfirmCards(1-tp,ck)
		local ckc=ck:GetFirst()
		if ckc:GetCode()==tc:GetCode() then 
		 Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		else Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)
		end
	end
end