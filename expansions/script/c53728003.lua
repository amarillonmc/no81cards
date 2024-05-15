local m=53728003
local cm=_G["c"..m]
cm.name="征啼鸟 猎人"
function cm.initial_effect(c)
	local f1=aux.UnionEquipTarget
	local f2=aux.UnionUnequipTarget
	aux.UnionEquipTarget=cm.UnionEquipTarget
	aux.UnionUnequipTarget=cm.UnionUnequipTarget
	aux.EnableUnionAttribute(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE))
	aux.UnionEquipTarget=f1
	aux.UnionUnequipTarget=f2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_EQUIP)
	e3:SetRange(0xff)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end
function cm.UnionEquipTarget(equip_filter)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				local c=e:GetHandler()
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and equip_filter(chkc,tp) end
				if chk==0 then return c:GetFlagEffect(FLAG_ID_UNION)<2 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
					and Duel.IsExistingTarget(equip_filter,tp,LOCATION_MZONE,0,1,c,tp) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local g=Duel.SelectTarget(tp,equip_filter,tp,LOCATION_MZONE,0,1,1,c,tp)
				Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
				c:RegisterFlagEffect(FLAG_ID_UNION,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
			end
end
function cm.UnionUnequipTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(FLAG_ID_UNION)<2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:GetEquipTarget() and c:IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(FLAG_ID_UNION,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not cm.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)<2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP) end
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if e:GetHandler():GetEquipTarget()==nil then return false end
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():GetEquipTarget():IsRace(RACE_MACHINE) and eg:IsContains(e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
