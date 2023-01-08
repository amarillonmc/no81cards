local m=15004450
local cm=_G["c"..m]
cm.name="终诞唤核士·阿波菲亚"
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(cm.distg)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	c:RegisterEffect(e2)
	--self destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,15004450)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCountLimit(1,15004451+EFFECT_COUNT_CODE_OATH)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(cm.sspcon)
	c:RegisterEffect(e4)
	--fusion
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,15004452)
	e5:SetTarget(cm.fstg)
	e5:SetOperation(cm.fsop)
	c:RegisterEffect(e5)
end
function cm.distg(e,c)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsSetCard(0xf40) and c:IsType(TYPE_MONSTER)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x3f40) and not c:IsCode(15004450) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and ((c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) or (c:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp,nil)>0))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA+LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.sspcon(e,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if c==nil then return true end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
	local pc=0
	local x=0
	local y=0
	local lpc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local rpc=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if lpc==nil or rpc==nil then pc=pc+1 end
	local olpc=Duel.GetFieldCard(1-tp,LOCATION_PZONE,0)
	local orpc=Duel.GetFieldCard(1-tp,LOCATION_PZONE,1)
	if olpc==nil or orpc==nil or orpc:GetFieldID()~=olpc:GetFlagEffectLabel(31531170) then pc=pc+1 end
	if pc==2 then return false end
	if lpc and rpc then x=1 end
	if orpc and olpc and orpc:GetFieldID()==olpc:GetFlagEffectLabel(31531170) then y=1 end
	local res=0
	if x==1 then
		local lscale=lpc:GetLeftScale()
		local rscale=rpc:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		if aux.PConditionFilter(c,e,tp,lscale,rscale,eset) then res=res+1 end
	end
	if y==1 then
		local lscale=olpc:GetLeftScale()
		local rscale=orpc:GetRightScale()
		if lscale>rscale then lscale,rscale=rscale,lscale end
		if aux.PConditionFilter(c,e,tp,lscale,rscale,eset) then res=res+1 end
	end
	return Duel.GetLocationCountFromEx(c:GetControler(),c:GetControler(),nil,c)>0
		and c:IsFaceup() and res>=1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) --and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
end
function cm.fmfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) --and c:IsAbleToExtra()
end
function cm.filter0(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function cm.filter1(c,e)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf,sc)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,sc,chkf) and c:IsAttribute(ATTRIBUTE_WIND)
end
function cm.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(cm.fmfilter,nil)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,e:GetHandler())
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf,e:GetHandler())
			end
		end
		return res and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,e:GetHandler())
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,e:GetHandler())
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,e:GetHandler(),chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoExtraP(mat1,nil,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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