--逆卷之炎
function c10150002.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)	
	--d
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150002,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10150002)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10150002.target)
	e2:SetOperation(c10150002.operation)
	e2:SetLabel(LOCATION_MZONE)
	c:RegisterEffect(e2)  
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(10150002,1))
	e3:SetLabel(LOCATION_GRAVE)
	c:RegisterEffect(e3)   
end
function c10150002.damfilter(c,loc)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and ((c:GetBaseAttack()>0 and loc==LOCATION_MZONE) or (c:GetBaseDefense()>0 and loc==LOCATION_GRAVE))
end
function c10150002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=e:GetLabel()
	if chkc==0 then return chkc:IsLocation(loc) and chkc:IsControler(tp) and c10150002.damfilter(chkc,loc) end
	if chk==0 then return Duel.IsExistingTarget(c10150002.damfilter,tp,loc,0,1,nil,loc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c10150002.damfilter,tp,loc,0,1,1,nil,loc)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	local dam=g:GetFirst():GetBaseAttack()
	if loc==LOCATION_GRAVE then dam=g:GetFirst():GetBaseDefense() end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.floor(dam/2))
end
function c10150002.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local loc=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and (tc:IsLocation(LOCATION_HAND) or ((tc:IsLocation(LOCATION_EXTRA)) and tc:IsFacedown())) then
	  local dam=tc:GetBaseAttack()
	  local p=1-tp
	  if loc==LOCATION_GRAVE then dam=tc:GetBaseDefense() p=tp end
	  Duel.Damage(p,math.floor(dam/2),REASON_EFFECT)
	end
end

