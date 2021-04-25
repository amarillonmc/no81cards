--赤月礼赞·SEEKER
local m=33701433
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,33701424)
	--change code
	aux.EnableChangeCode(c,33701424,LOCATION_GRAVE)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9449)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.Hint(HINT_CARD,0,m)
		if Duel.Damage(tp,tc:GetAttack()+tc:GetDefense(),REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local fid=e:GetHandler():GetFieldID()
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabel(fid)
			e1:SetLabelObject(tc)
			e1:SetCondition(cm.retcon)
			e1:SetOperation(cm.retop)
			Duel.RegisterEffect(e1,tp)
			local e11=Effect.CreateEffect(c)
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e11:SetRange(LOCATION_MZONE)
			e11:SetCode(EFFECT_UNRELEASABLE_SUM)
			e11:SetValue(1)
			tc:RegisterEffect(e11)
			local e12=e11:Clone()
			e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e12)
			local e13=Effect.CreateEffect(c)
			e13:SetType(EFFECT_TYPE_SINGLE)
			e13:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			e13:SetValue(1)
			e13:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e13)
			local e14=e13:Clone()
			e14:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			tc:RegisterEffect(e14)
			local e15=e13:Clone()
			e15:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e15)
			local e16=e13:Clone()
			e16:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e16)
		end
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
