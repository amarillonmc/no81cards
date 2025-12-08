--医疗天使 心夏
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.StrinovaPUS(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetRange(LOCATION_MZONE+LOCATION_SZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_XMATERIAL)
	e2:SetCountLimit(1,m+10000000)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2)
	
	MTC.StrinovaChangeZone(c,cm.czop)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)~=0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if #cg==0 or c:IsControler(1-tp) then return end
	local pzone=LOCATION_MZONE
	if c:IsLocation(LOCATION_MZONE) then pzone=LOCATION_SZONE end
	if Duel.SendtoGrave(cg,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,pzone)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) and Duel.MoveToField(c,tp,tp,pzone,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetCountLimit(1)
		e2:SetValue(cm.indct)
		c:RegisterEffect(e2)
	end
end
function cm.indct(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.SelectYesNo(tp,aux.Stringid(m,2)) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.czop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end












