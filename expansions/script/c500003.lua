--大小姐女仆 纱路
function c500003.initial_effect(c)
	--race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetValue(RACE_FAIRY)
	c:RegisterEffect(e1) 
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c500003.tg)
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	--yyyy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(500003,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c500003.target)
	e4:SetOperation(c500003.operation)
	c:RegisterEffect(e4)   
end
function c500003.filter1(c)
	return (c:IsSetCard(0xffac) or c:IsSetCard(0xffad)) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c500003.filter2(c)
	return c:IsReleasable() and c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsCode(500003)
end
function c500003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c500003.filter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c500003.filter2,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(500003,1),aux.Stringid(500003,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(500003,1))
	else op=Duel.SelectOption(tp,aux.Stringid(500003,2))+1 end
	e:SetLabel(op)
	if op~=0 then
	   Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,0,LOCATION_DECK)
	end
end
function c500003.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	   local tc=Duel.SelectMatchingCard(tp,c500003.filter1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	   if tc then
		  Duel.SSet(tp,tc)
		  Duel.ConfirmCards(1-tp,tc)
	   end
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	   local g=Duel.SelectMatchingCard(tp,c500003.filter2,tp,LOCATION_DECK,0,1,1,nil)
	   if g:GetCount()>0 then
		  Duel.SendtoGrave(g,REASON_EFFECT+REASON_RELEASE)
	   end
	end
end
function c500003.tg(e,c)
	return c:IsSetCard(0xffac) or c:IsSetCard(0xffad)
end