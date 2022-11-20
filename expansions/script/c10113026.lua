--悄悄靠近的死神
function c10113026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10113026+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10113026.cost)
	e1:SetTarget(c10113026.target)
	e1:SetOperation(c10113026.activate)
	c:RegisterEffect(e1)	
end
function c10113026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500)
	else Duel.PayLPCost(tp,1500) end
end
function c10113026.filter(c)
	return c:IsFaceup() and c:IsAbleToGrave()
end
function c10113026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c10113026.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10113026.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c10113026.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c10113026.limit(g:GetFirst()))
end
function c10113026.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c10113026.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetCode(EFFECT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e1)
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_SINGLE)
	   e2:SetCode(EFFECT_DISABLE_EFFECT)
	   e2:SetReset(RESET_EVENT+0x1fe0000)
	   tc:RegisterEffect(e2)
	end
end