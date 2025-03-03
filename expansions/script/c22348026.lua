--金 属 化 武 神
local m=22348026
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348026,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,22348026+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22348026.spcon)
	e1:SetOperation(c22348026.spop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348026,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22348027)
	e2:SetCondition(c22348026.con)
	e2:SetTarget(c22348026.target)
	e2:SetOperation(c22348026.operation)
	c:RegisterEffect(e2)
	--0p
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348026,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22348027)
	e3:SetCost(aux.bfgcost)
	e3:SetCondition(c22348026.stcon)
	e3:SetTarget(c22348026.sttg)
	e3:SetOperation(c22348026.stop)
	c:RegisterEffect(e3)
	
end

function c22348026.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsCanRemoveCounter(tp,1,0,0x1613,2,REASON_COST)
end
function c22348026.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,1,0,0x1613,2,REASON_COST)
end
function c22348026.con(e,tp,eg,ep,ev,re,r,rp)  
	return re and re:GetHandler():IsSetCard(0x613)
end  
function c22348026.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c22348026.filter2(c)
	return c:IsSetCard(0x613) and c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function c22348026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c22348026.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22348026.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c22348026.filter2,tp,LOCATION_DECK,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c22348026.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
end

function c22348026.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348026.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,nil,REASON_EFFECT)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
	end
end
function c22348026.stcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c22348026.stfilter(c,tp)
	return c:IsSetCard(0x613) and c:CheckActivateEffect(false,true,false)~=nil and (c:GetType()==0x20002 or c:GetType()==0x20004 or c:GetType()==0x80002)
end
function c22348026.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22348026.stfilter),tp,LOCATION_GRAVE,0,1,nil,tp) end
end
function c22348026.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348026.stfilter),tp,LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and tc:GetType()==0x80002 then
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	end
end