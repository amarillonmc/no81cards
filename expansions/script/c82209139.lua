--融合之扉
local m=82209139
local cm=c82209139
function cm.initial_effect(c)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--spsummon limit  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e2:SetTargetRange(1,0)  
	e2:SetTarget(cm.sumlimit)  
	c:RegisterEffect(e2) 
	--fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(cm.fuscost)
	e3:SetTarget(cm.fustg)
	e3:SetOperation(cm.fusop)
	c:RegisterEffect(e3)
end

function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)  
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end  

function cm.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_ATTACK)==0 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end  
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_ATTACK)  
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)  
end  
function cm.filter1(c)  
	return c:IsType(TYPE_MONSTER) and c:IsFacedown() and c:IsCanBeFusionMaterial()
end  
function cm.filter2(c,e,tp,m,f,chkf)  
	return c:IsType(TYPE_FUSION) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)  
end  
function cm.fustg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_REMOVED,0,nil)  
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
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)  
end  
function cm.fusop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=tp  
	local mg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_REMOVED,0,nil)  
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
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION+REASON_RETURN)  
			Duel.BreakEffect()  
			if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
				local e2=Effect.CreateEffect(e:GetHandler())  
				e2:SetDescription(aux.Stringid(m,1))
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
				e2:SetCode(EVENT_PHASE+PHASE_END)  
				e2:SetCountLimit(1)  
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
				e2:SetLabelObject(tc)  
				e2:SetCondition(cm.descon)  
				e2:SetOperation(cm.desop)  
				Duel.RegisterEffect(e2,tp)   
			end
		else  
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
	end  
end  
function cm.descon(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetLabelObject()  
	if tc:GetFlagEffect(m)~=0 then  
		return true  
	else  
		e:Reset()  
		return false  
	end  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=e:GetLabelObject()  
	Duel.Destroy(tc,REASON_EFFECT)  
end  