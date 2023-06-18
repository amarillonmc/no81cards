--热血星龙 盖金迦
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000205)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),8,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local ew=Effect.CreateEffect(c)
	ew:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ew:SetCode(EVENT_SPSUMMON_SUCCESS)
	ew:SetCondition(cm.conw)
	c:RegisterEffect(ew)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(20000205)>0 and aux.bdocon(e,tp,eg,ep,ev,re,r,rp)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
end
function cm.op1con(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_BP_TWICE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
			e2:SetLabel(Duel.GetTurnCount())
			e2:SetCondition(cm.op1con)
			e2:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e2:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e2,tp)
	end
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function cm.tg2f2(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c) and c:IsSetCard(0x6fd2)
end
function cm.tg2f1(c,tp)
	if not c:IsCode(20000205) then return false end
	return c:IsAbleToHand() or (Duel.IsExistingMatchingCard(cm.tg2f2,tp,LOCATION_MZONE,0,1,nil,c) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tg2f1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tg2f1),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if not tc then return end
	local g=Duel.GetMatchingGroup(cm.tg2f2,tp,LOCATION_MZONE,0,nil,tc)
	local res=#g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	if c:IsAbleToHand() and (not res or Duel.SelectOption(tp,1190,1068)==1) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		g=g:Select(tp,1,1,nil)
		Duel.Equip(tp,tc,g:GetFirst())
	end
end
--ew
function cm.conw(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(20000205)>0 then Duel.Hint(24,0,aux.Stringid(m,0)) end
	return false
end