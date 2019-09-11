--狂气的月兔 铃仙·优昙华院·因幡
function c11200021.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c11200021.mfilter,nil,2,2)
--
	if not c11200021.global_check then
		c11200021.global_check=true
		local e0=Effect.GlobalEffect()
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAINING)
		e0:SetCondition(c11200021.con0)
		e0:SetOperation(c11200021.op0)
		Duel.RegisterEffect(e0,0)
	end
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200021,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DAMAGE+CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(0)
	e1:SetCost(c11200021.cost1)
	e1:SetTarget(c11200021.tg1)
	e1:SetOperation(c11200021.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200021,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11200021)
	e2:SetCondition(c11200021.con2)
	e2:SetCost(c11200021.cost2)
	e2:SetTarget(c11200021.tg2)
	e2:SetOperation(c11200021.op2)
	c:RegisterEffect(e2)
--
end
--
c11200021.xig_ihs_0x132=1
--
function c11200021.mfilter(c)
	return c:IsCode(11200019)
end
--
function c11200021.con0(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER)
		and not (rc.xig_ihs_0x132 or rc:IsCode(11200019))
end
--
function c11200021.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,11200021,RESET_PHASE+PHASE_END,0,1)
end
--
function c11200021.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c11200021.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
			and c:GetOverlayCount()>0
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	local mg=Duel.GetOperatedGroup()
	mg:KeepAlive()
	e:SetLabelObject(mg)
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
--
function c11200021.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=e:GetLabelObject()
	local dc=Duel.TossDice(tp,1)
	local type1=0
	local type2=0
	local type3=0
	local tc=mg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) then type1=1 end
		if tc:IsType(TYPE_SPELL) then type2=1 end
		if tc:IsType(TYPE_TRAP) then type3=1 end
		tc=mg:GetNext()
	end
	if type1==1 then
		local e1_1=Effect.CreateEffect(c)
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetCode(EFFECT_UPDATE_ATTACK)
		e1_1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1_1:SetValue(dc*300)
		c:RegisterEffect(e1_1)
	end
	if type2==1 then Duel.Draw(tp,1,REASON_EFFECT) end
	if type3==1 then Duel.Damage(1-tp,dc*300,REASON_EFFECT) end
end
--
function c11200021.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,11200021)<1
end
--
function c11200021.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	local g=Group.CreateGroup()
	g:AddCard(c)
	Duel.HintSelection(g)
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
--
function c11200021.tfilter2(c)
	return c:IsAbleToHand() and (c.xig_ihs_0x132 or c:IsCode(11200019))
end
function c11200021.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11200021.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
--
function c11200021.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11200021.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
