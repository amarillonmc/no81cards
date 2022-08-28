local m=90700011
local cm=_G["c"..m]
cm.name="鬼计妖魔·德拉古拉"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.linkfilter,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90700011,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(90700011,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetTarget(cm.rectg)
	e2:SetOperation(cm.recop)
	c:RegisterEffect(e2)
	if c90700011.counter==nil then
		c90700011.counter=true
		c90700011[0]=0
		c90700011[1]=0
		c90700011[2]=0
		c90700011[3]=0
		local ec1=Effect.CreateEffect(c)
		ec1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ec1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ec1:SetOperation(cm.resetcount)
		Duel.RegisterEffect(ec1,0)
		local ec2=Effect.CreateEffect(c)
		ec2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ec2:SetCode(EVENT_FLIP)
		ec2:SetOperation(cm.addcount1)
		Duel.RegisterEffect(ec2,0)
		local ec3=Effect.CreateEffect(c)
		ec3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ec3:SetCode(EVENT_CHAINING)
		ec3:SetOperation(cm.addcount2)
		Duel.RegisterEffect(ec3,0)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetDescription(aux.Stringid(90700011,2))
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetLabel(1)
	e3:SetOperation(cm.op)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e3:SetDescription(aux.Stringid(90700011,3))
	e3:SetLabel(2)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e3:SetDescription(aux.Stringid(90700011,4))
	e3:SetLabel(3)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,1)
	e6:SetValue(cm.actlimit)
	c:RegisterEffect(e6)
end
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c90700011[0]=0
	c90700011[1]=0
	c90700011[2]=0
	c90700011[3]=0
end
function cm.addcount1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x8d) then
			local p=tc:GetControler()
			c90700011[p]=c90700011[p]+1
		end
		tc=eg:GetNext()
	end
end
function cm.addcount2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) and tc:IsPreviousPosition(POS_FACEDOWN) then
			local p=tc:GetControler()
			c90700011[p]=c90700011[p]+1
		end
		tc=eg:GetNext()
	end
end
function cm.linkfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsType(TYPE_FLIP) and not c:IsType(TYPE_LINK)
end
function cm.spfilter(c,tp)
	return c:IsReleasable() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsPosition(POS_FACEDOWN_DEFENSE) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	if g then
		Duel.Release(g,REASON_COST)
	end
end
function cm.recfilter(c)
	return c:IsSetCard(0x8d) and c:IsAbleToHand()
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.recfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.recfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	return c90700011[p+2]<c90700011[p]
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==1 then return Duel.IsExistingTarget(cm.recfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
		if e:GetLabel()==2 then return Duel.IsExistingTarget(cm.recfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
		if e:GetLabel()==3 then return Duel.IsExistingTarget(cm.recfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	end
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	if e:GetLabel()==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	if e:GetLabel()==3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	if e:GetLabel()==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	if e:GetLabel()==3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
	local p=e:GetHandlerPlayer()
	c90700011[p+2]=c90700011[p+2]+1
end
function cm.actfilter(c)
	return c:IsSetCard(0x8d) and c:GetSequence()<5
end
function cm.actlimit(e,re,tp)
	return Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_MZONE,0,1,nil) and not re:GetHandler():IsSetCard(0x8d) and e:GetHandler():GetSequence()>=5
end