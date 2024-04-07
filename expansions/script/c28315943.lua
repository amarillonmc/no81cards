--闪耀的六出花 大崎甘奈
function c28315943.initial_effect(c)
	aux.AddCodeList(c,28335405)
	--alstroemeria spsummon-hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,28315943+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c28315943.hspcon)
	c:RegisterEffect(e1)
	--alstroemeria spsummon-grave
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c28315943.gspcon)
	e2:SetOperation(c28315943.gspop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,28315943)
	e3:SetTarget(c28315943.thtg)
	e3:SetOperation(c28315943.thop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,28315943)
	e4:SetTarget(c28315943.rectg)
	e4:SetOperation(c28315943.recop)
	c:RegisterEffect(e4)
end
function c28315943.hspcon(e,c)
	if c==nil then return true end
   return Duel.GetLP(e:GetHandlerPlayer())>=9000 and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0
end
function c28315943.alfilter(c)
	return c:IsSetCard(0x287) and c:IsFaceup()
end
function c28315943.gspcon(e,c)
	if c==nil then return true end
	local p=e:GetHandlerPlayer()
	return Duel.GetLP(p)>=9000 and Duel.GetLocationCount(p,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c28315943.alfilter,p,LOCATION_MZONE,0,1,nil)
end
function c28315943.chkfilter(c)
	return c:IsCode(28335405) and not c:IsPublic()
end
function c28315943.gspop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.IsExistingMatchingCard(c28315943.chkfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(28315943,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,c28315943.chkfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	else
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-2000)
	end
end
function c28315943.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28315943.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28315943.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28315943.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c28315943.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsAttribute(ATTRIBUTE_EARTH) then
			Duel.BreakEffect()
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end
function c28315943.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28315943.hkfilter(c)
	return c:IsSetCard(0x286) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c28315943.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Recover(tp,1000,REASON_EFFECT)>0 and Duel.GetLP(tp)>=10000 then
		local b1=Duel.IsExistingMatchingCard(c28315943.hkfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsPlayerCanDraw(tp,1)
		if not (b1 or b2) then return end
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(28315943,0)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(28315943,1)
			opval[off]=1
			off=off+1
		end
		if true then
			ops[off]=aux.Stringid(28315943,2)
			opval[off]=2
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel~=2 then Duel.BreakEffect() end
		if sel==0 then
			local lp=Duel.GetLP(tp)
			Duel.SetLP(tp,lp-2000)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c28315943.hkfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		elseif sel==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
