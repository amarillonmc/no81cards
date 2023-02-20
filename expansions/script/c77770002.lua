--混沌NO.142857 百万航行者 超大变形
function c77770002.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c77770002.mfilter,7,6,c77770002.ovfilter,aux.Stringid(77770002,0),7,c77770002.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c77770002.atkval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77770002,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,77770002)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c77770002.cost)
	e2:SetTarget(c77770002.target)
	e2:SetOperation(c77770002.operation)
	c:RegisterEffect(e2)
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c77770002.splimit)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c77770002.efilter)
	c:RegisterEffect(e4)
end
aux.xyz_number[77770002]=142857
function c77770002.splimit(e,se,sp,st)
	return not se or  not se:IsHasType(EFFECT_TYPE_ACTIONS)
end

function c77770002.ovfilter(c)
	return c:IsFaceup() and c:IsCode(89990016) and c:GetOverlayCount()==7
end
function c77770002.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,77770002)==0 end
	Duel.RegisterFlagEffect(tp,77770002,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c77770002.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c77770002.atkval(e,c)
	return c:GetOverlayCount()*1500
end
function c77770002.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77770002.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77770002.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and tc:GetBaseAttack()>=0 and tc:IsPreviousLocation(LOCATION_MZONE) and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetBaseAttack())
		c:RegisterEffect(e1)
	end
end
