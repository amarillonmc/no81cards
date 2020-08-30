local m=82224053
local cm=_G["c"..m]
cm.name="灵兽的荒临"
function cm.initial_effect(c)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)  
end
function cm.filter0(c)  
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() 
end  
function cm.filter1(c,e)  
	return not c:IsImmuneToEffect(e) and c:IsLocation(LOCATION_HAND) and c:IsAbleToRemove()
end  
function cm.filter2(c,e,tp,m,f,chkf)  
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x40b5) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:CheckFusionMaterial(m,nil,chkf)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)  
		local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,0,nil)  
		mg1:Merge(mg2)   
		local res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local chkf=tp  
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)  
	local mg2=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_DECK,0,nil)  
	mg1:Merge(mg2)   
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)   
	if sg1:GetCount()>0 then  
		local sg=sg1:Clone()  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local tg=sg:Select(tp,1,1,nil)  
		local tc=tg:GetFirst()  
		if sg1:IsContains(tc) then  
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)  
			tc:SetMaterial(mat1)  
			Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)  
			Duel.BreakEffect()  
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)	
		end   
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_CANNOT_ATTACK)  
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
		e1:SetReset(RESET_EVENT+0x1fe0000)  
		tc:RegisterEffect(e1,true)  
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)  
		tc:CompleteProcedure()  
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,0))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e2:SetCode(EVENT_PHASE+PHASE_END)  
		e2:SetCountLimit(1)  
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
		e2:SetLabelObject(tc)  
		e2:SetCondition(cm.descon)  
		e2:SetOperation(cm.desop)  
		Duel.RegisterEffect(e2,tp)  
	end  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetTargetRange(1,0)  
	e3:SetTarget(cm.splimit)  
	e3:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e3,tp)  
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
function cm.splimit(e,c)  
	return not c:IsSetCard(0xb5)  
end  