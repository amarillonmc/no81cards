--编外混合体 地
local m=30005510
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(cm.sprcon)
	e1:SetTarget(cm.sprtg)
	e1:SetOperation(cm.sprop)
	c:RegisterEffect(e1)
	--Effect 1
	local e02=Effect.CreateEffect(c)   
	e02:SetDescription(aux.Stringid(30005508,0))
	e02:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e02:SetCountLimit(1)
	e02:SetTarget(cm.fstg)
	e02:SetOperation(cm.fsop)
	c:RegisterEffect(e02)   
	--Effect 2  
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e4:SetValue(cm.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e5:SetValue(cm.effectfilter)
	c:RegisterEffect(e5)
	--Effect 3 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(cm.effcon)
	e3:SetOperation(cm.effop)
	c:RegisterEffect(e3)
end
--spsummon rule
function cm.cff(c)
	return c:IsFaceup() and (c:IsType(TYPE_FUSION) or c:IsSetCard(0x927))
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	return Duel.IsExistingMatchingCard(cm.cff,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and rg:CheckSubGroup(aux.mzctcheckrel,1,1,tp,REASON_SPSUMMON)
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheckrel,true,1,1,tp,REASON_SPSUMMON)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
--Effect 1
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		if e:GetHandler():IsOriginalCodeRule(30005510) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
			local e4=Effect.CreateEffect(tc)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CANNOT_INACTIVATE)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetRange(LOCATION_HAND+LOCATION_MZONE)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			e4:SetValue(cm.effectfilter)
			tc:RegisterEffect(e4,true)
			local e5=Effect.CreateEffect(tc)
			e5:SetType(EFFECT_TYPE_FIELD)
			e5:SetCode(EFFECT_CANNOT_DISEFFECT)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetRange(LOCATION_HAND+LOCATION_MZONE)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			e5:SetValue(cm.effectfilter)
			tc:RegisterEffect(e5,true)
			if not tc:IsType(TYPE_EFFECT) then
				local e2=Effect.CreateEffect(tc)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_ADD_TYPE)
				e2:SetValue(TYPE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2,true)
			end
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
		end
	end
end
--Effect 2
function cm.effectfilter(e,ct)
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	local tc=te:GetHandler()
	local ec=e:GetHandler()
	return tc==ec 
end
--Effect 3 
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_FUSION)~=0 
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e4=Effect.CreateEffect(rc)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetValue(cm.effectfilter)
	rc:RegisterEffect(e4,true)
	local e5=Effect.CreateEffect(rc)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e5:SetValue(cm.effectfilter)
	rc:RegisterEffect(e5,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end 
