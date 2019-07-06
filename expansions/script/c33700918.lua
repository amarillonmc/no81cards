--梦想愿现 ～Wish Into Reality～
function c33700918.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--th
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e,tp) return Duel.GetTurnPlayer()==tp end)
	e3:SetTarget(c33700918.thtg)
	e3:SetOperation(c33700918.thop)
	c:RegisterEffect(e3)
	if c33700918.counter==nil then
		c33700918.counter=true
		c33700918[0]={}
		c33700918[1]={}
		c33700918[2]={}
		c33700918[3]={}
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c33700918.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_TO_HAND)
		e3:SetOperation(c33700918.addcount)
		Duel.RegisterEffect(e3,0)
		local e4=e3:Clone()
		e4:SetCode(EVENT_TO_GRAVE)
		e4:SetOperation(c33700918.addcount2)
		Duel.RegisterEffect(e4,0)
	end
end
function c33700918.thfilter(c)
	for _,code in ipairs(c33700918[c:GetControler()+2]) do
		if code==c:GetCode() and c:IsAbleToHand() then return true end
	end
	return false
end
function c33700918.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c33700918.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33700918.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c33700918.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c33700918.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c33700918.resetcount(e,tp,eg,ep,ev,re,r,rp)
		c33700918[0]={}
		c33700918[1]={}
		c33700918[2]={}
		c33700918[3]={}
end
function c33700918.cfilter(c)
	return not c:IsReason(REASON_DRAW)
end
function c33700918.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(c33700918.cfilter,nil)
	if #tg<=0 then return end
	for tc in aux.Next(tg) do
		table.insert(c33700918[tc:GetControler()],tc:GetCode())
	end
end
function c33700918.addcount2(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		for _,code in ipairs(c33700918[tc:GetControler()]) do
			if code==tc:GetCode() then
				table.insert(c33700918[tc:GetControler()+2],tc:GetCode())
			end
		end
	end
end
