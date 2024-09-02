--阿巴阿巴歪头栗子果
function c21185697.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_ATKCHANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,21185697)
	e1:SetTarget(c21185697.tg)
	e1:SetOperation(c21185697.op)
	c:RegisterEffect(e1)
end
function c21185697.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToExtra,tp,LOCATION_MZONE,LOCATION_MZONE,nil):Filter(Card.IsFaceup,nil)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,c,0,0,#g*2000)
end
function c21185697.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToExtra,tp,LOCATION_MZONE,LOCATION_MZONE,nil):Filter(Card.IsFaceup,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
	local op=Duel.GetOperatedGroup():GetCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)	
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(op*2000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	end
end