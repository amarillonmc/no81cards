--吞式者的爆发
local m=14000321
local cm=_G["c"..m]
cm.named_with_Aotual=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
cm.fit_monster={14000324,14000325,14000326}
function cm.AOTU(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Aotual
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and cm.AOTU(c) and c:IsReleasable()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		local rc=g:GetFirst()
		if Duel.Release(rc,REASON_EFFECT)~=0 then
			if not rc:IsCode(14000324,14000325,14000326) then return end
			Duel.BreakEffect()
			if rc:IsCode(14000324) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
				if g:GetCount()>0 then
					Duel.HintSelection(g)
					Duel.Destroy(g,REASON_EFFECT)
				end
				if tc:IsRelateToEffect(e) and tc:IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
					Duel.SendtoGrave(tc,REASON_EFFECT)
				end
			end
			if rc:IsCode(14000325) and rc and rc:IsAbleToHand() and rc:IsFaceup() then
				Duel.HintSelection(g)
				Duel.SendtoHand(rc,nil,REASON_EFFECT)
				if tc:IsRelateToEffect(e) and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
				end
			end
			if rc:IsCode(14000326) and rc and rc:IsFaceup() and rc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				rc:CompleteProcedure()
				if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsAbleToChangeControler() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0  and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
					Duel.Equip(tp,tc,rc,false)
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(cm.eqlimit)
					e1:SetLabelObject(rc)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end