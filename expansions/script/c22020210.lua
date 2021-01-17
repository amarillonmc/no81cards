--人理之灵 卫宫士郎
function c22020210.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22020210)
	e1:SetCondition(c22020210.hspcon)
	e1:SetOperation(c22020210.hspop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020210,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,22020211)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c22020210.lvcost)
	e2:SetOperation(c22020210.lvop)
	c:RegisterEffect(e2)
end
c22020210.effect_canequip_hogu=true
function c22020210.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.CheckLPCost(tp,1000)
end
function c22020210.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,1000)
end
function c22020210.costfilter(c,lv)
	return c:IsLevelAbove(1) and c:IsSetCard(0x2ff1) and c:IsAbleToGraveAsCost()
end
function c22020210.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return Duel.IsExistingMatchingCard(c22020210.costfilter,tp,LOCATION_DECK,0,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22020210.costfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c22020210.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetValue(22020220)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end