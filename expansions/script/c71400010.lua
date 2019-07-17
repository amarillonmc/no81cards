--梦之书中的脑女
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400010.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,yume.YumeCheck(c),4,2)
	c:EnableReviveLimit()
	--summon limit
	yume.AddYumeSummonLimit(c,1)
	--get all
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetDescription(aux.Stringid(71400010,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,71400010)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c71400010.cost)
	e1:SetTarget(c71400010.target1)
	e1:SetOperation(c71400010.operation1)
	c:RegisterEffect(e1)
	--lose one
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetDescription(aux.Stringid(71400010,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c71400010.target2)
	e2:SetOperation(c71400010.operation2)
	e2:SetCondition(c71400010.condition2)
	c:RegisterEffect(e2)
end
function c71400010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71400010.filter1(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c71400010.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400010.filter1,tp,0,LOCATION_MZONE,1,nil) and ft>0 end
	local g=Duel.GetMatchingGroup(c71400010.filter1,tp,0,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),1-tp,LOCATION_MZONE)
end
function c71400010.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)
	local g=Duel.GetMatchingGroup(c71400010.filter1,tp,0,LOCATION_MZONE,c)
	local ct=g:GetCount()
	if ct>ft then ct=ft end
	if ct<1 then return end
	if ct<g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		g=g:Select(tp,ct,ct,nil)
	end
	Duel.GetControl(g,tp)
	local og=Duel.GetOperatedGroup()
	if og:GetCount()<1 then return end
	local tc=og:GetFirst()
	local atk=0
	while tc do
		local tatk=tc:GetAttack()
		if tatk>0 then atk=atk+tatk end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(0x714)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2,true)
		tc=og:GetNext()
	end
	Duel.BreakEffect()
	Duel.SetLP(tp,Duel.GetLP(tp)-atk/2)
end
function c71400010.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function c71400010.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()==tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,tp,LOCATION_MZONE)
end
function c71400010.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,1-tp)
	end
end