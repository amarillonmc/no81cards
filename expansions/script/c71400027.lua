--啊，擦伤啦☆
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400027.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_CONTROL)
	e1:SetDescription(aux.Stringid(71400027,0))
	e1:SetCondition(c71400027.con1)
	e1:SetOperation(c71400027.op1)
	e1:SetOperation(c71400027.tg1)
	c:RegisterEffect(e1)
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetDescription(aux.Stringid(71400027,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71400027.tg2)
	e2:SetOperation(c71400027.op2)
	e2:SetCondition(c71400027.con2)
	c:RegisterEffect(e2)
end
function c71400027.con1(e,tp,eg,ep,ev,re,r,rp)
	return yume.IsYumeFieldOnField(tp) and rp==1-tp and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
end
function c71400027.filter1(c)
	if c:IsType(TYPE_LINK) then return false end
	local num=0
	local xyz=0
	if c:IsType(TYPE_XYZ) then
		xyz=1
		num=c:GetRank()
	else
		num=c:GetLevel()
	end
	return c:IsFaceup() and c:IsSetCard(0x714) and Duel.IsExistingMatchingCard(c71400027.filter1a,0,LOCATION_MZONE,LOCATION_MZONE,1,c,num,xyz)
end
function c71400027.filter1a(c,num,xyz)
	if c:IsType(TYPE_LINK) or not (c:IsFaceup() and c:IsSetCard(0x714)) then return false end
	local num2=0
	local xyz2=0
	if c:IsType(TYPE_XYZ) then
		xyz2=1
		num2=c:GetRank()
	else
		num2=c:GetLevel()
	end
	return xyz2==xyz and num2==num
end
function c71400027.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.IsChainDisablable(ev) then
		Duel.NegateEffect(ev)
		if rc:IsRelateToEffect(re) then
			Duel.SetLP(tp,Duel.GetLP(tp)-math.ceil(rc:GetBaseAttack()/2))
			if not rc:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsExistingMatchingCard(c71400027.filter1,0,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
				Duel.BreakEffect()
				Duel.GetControl(rc,tp)
			end
		end
	end
end
function c71400027.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=re:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if g:FilterCount(c71400027.filter1,nil)==g:GetCount() then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
		if rc:IsRelateToEffect(re) and not rc:IsStatus(STATUS_BATTLE_DESTROYED) then
			Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
		end
	end
end
function c71400027.con2(e,tp,eg,ep,ev,re,r,rp)
	return yume.IsYumeFieldOnField(tp) and Duel.IsExistingMatchingCard(c71400027.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c71400027.filter2(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c71400027.filter2o(c,e)
	return c:IsFaceup() and c:IsAbleToChangeControler() and not c:IsImmuneToEffect(e)
end
function c71400027.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400027.filter2,tp,0,LOCATION_MZONE,1,nil) and ft>0 end
	local g=Duel.GetMatchingGroup(c71400027.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),1-tp,0)
end
function c71400027.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,1-tp,LOCATION_REASON_CONTROL)
	local g=Duel.GetMatchingGroup(c71400027.filter2o,tp,0,LOCATION_MZONE,nil,e)
	local ct=g:GetCount()
	if ct>ft then ct=ft end
	if ct<1 then return end
	if ct<g:GetCount() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		g=g:Select(tp,ct,ct,nil)
	end
	Duel.GetControl(g,tp)
	if g:GetCount()<1 then return end
	local tc=g:GetFirst()
	local atk=0
	while tc do
		local tatk=tc:GetBaseAttack()
		if tatk>0 then atk=atk+tatk end
		tc=g:GetNext()
	end
	Duel.SetLP(tp,Duel.GetLP(tp)-math.ceil(atk/2))
	Duel.BreakEffect()
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end