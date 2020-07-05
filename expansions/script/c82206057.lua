local m=82206057
local cm=_G["c"..m]
cm.name="植占阵-幻世"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_RECOVER) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(cm.rectg)
	e1:SetOperation(cm.activate)  
	c:RegisterEffect(e1)
	--special summon  
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1,82216057)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(800)  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,400)  
end  
function cm.activate(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Recover(p,d,REASON_EFFECT)  
end
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x129d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then  
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1) 
			local e2=Effect.CreateEffect(e:GetHandler())  
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
			e2:SetCode(EVENT_PHASE+PHASE_END)  
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
			e2:SetLabelObject(tc)  
			e2:SetCondition(cm.descon)  
			e2:SetOperation(cm.desop)  
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
			e2:SetCountLimit(1)  
			Duel.RegisterEffect(e2,tp)  
			Duel.SpecialSummonComplete() 
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
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)  
end  