-- 不良少女的校园生活
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLP(tp)<=4000 then return true end
		return Duel.CheckLPCost(tp,2000)
	end
	if Duel.GetLP(tp)>4000 then
		Duel.PayLPCost(tp,2000)
	end
end
function s.counterfilter(c,tp)
	return c:IsFaceup() and c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(tp,0x624,1,c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.counterfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.counterfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
	Duel.SelectTarget(tp,s.counterfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanHaveCounter(0x624) then
		if tc:AddCounter(0x624,1) then
			Duel.RegisterFlagEffect(tp,60002148,0,0,1)
		end
	end
	if Duel.GetLP(tp)<=4000 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end