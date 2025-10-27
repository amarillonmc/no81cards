local m=15000632
local cm=_G["c"..m]
cm.name="幻智的黑翼·淬羽赫默"
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.adcon)
	e2:SetTarget(cm.adtg)
	e2:SetOperation(cm.adop)
	c:RegisterEffect(e2)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local res=(Duel.GetLP(tp)>2000)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsAbleToDeck,e:GetHandler())
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) and ((not res) or #g>0)
	end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	if res then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsAbleToDeck,nil)
		if e:GetCategory()&CATEGORY_TODECK~=0 and #g>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local rg=g:Select(tp,1,1,nil)
			if rg:GetCount()>0 then
				Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)
			end
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(4)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(cm.synlimit)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetValue(cm.fsynlimit)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		c:RegisterEffect(e3)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		c:RegisterEffect(e4)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		c:RegisterEffect(e5)
	end
end
function cm.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xf36)
end
function cm.fsynlimit(e,c,sumtype)
	if not c then return false end
	return sumtype==SUMMON_TYPE_FUSION and not c:IsSetCard(0xf36)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function cm.adfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf36) and c:IsSummonLocation(LOCATION_EXTRA)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.adfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.adfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLP(tp)~=Duel.GetLP(1-tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.adfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end