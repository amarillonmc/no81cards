--觉醒于渊异之龙皇
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000455)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.con0)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(cm.con1)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.cos2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.cos3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
--e0
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(m,0))
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.val1(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
--e2
function cm.cos2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
end
function cm.tgf2(c)
	return c:IsType(TYPE_EFFECT) and c:IsRace(RACE_DRAGON) and c:GetType()&0x81==0x81
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tgf2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tgf2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	Duel.SelectTarget(tp,cm.tgf2,tp,LOCATION_GRAVE,0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		local ba=tc:GetBaseAttack()
		local bd=tc:GetBaseDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetLabelObject(e1)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(ba)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetLabelObject(e2)
		e3:SetCode(EFFECT_SET_BASE_DEFENSE)
		e3:SetValue(bd)
		c:RegisterEffect(e3)
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(1162)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetCountLimit(1)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e4:SetLabel(cid)
		e4:SetLabelObject(e3)
		e4:SetOperation(cm.op2_op4)
		c:RegisterEffect(e4)
	end
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
end
function cm.op2_op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return end
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	local e3=e:GetLabelObject()
	local e2=e3:GetLabelObject()
	local e1=e2:GetLabelObject()
	e1:Reset()
	e2:Reset()
	e3:Reset()
	e:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
--e3
function cm.cosf3(c,g)
	return c:IsPublic() and c:IsLocation(LOCATION_HAND) and g:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function cm.cos3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsAbleToHand,nil)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,cm.cosf3,1,nil,g) end
	g=Duel.SelectReleaseGroupEx(tp,cm.cosf3,1,1,nil,g)
	Duel.Release(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetLabel()
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_DEFENSE)==0 or not c then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	c=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Filter(Card.IsAbleToHand,nil):FilterSelect(tp,Card.IsCode,1,1,nil,c):GetFirst()
	if not c then return end
	Duel.BreakEffect()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,c)
end