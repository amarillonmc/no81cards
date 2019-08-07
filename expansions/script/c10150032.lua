--落日之炎
function c10150032.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,10150032+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c10150032.condition)
	e1:SetTarget(c10150032.target)
	e1:SetOperation(c10150032.activate)
	c:RegisterEffect(e1)   
end
function c10150032.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3b) or aux.IsMaterialListSetCard(c,0x3b))
end
function c10150032.cfilter2(c)
	return c:IsFaceup() and c:IsCode(74677422)
end
function c10150032.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c10150032.cfilter,tp,LOCATION_MZONE,0,1,nil) and rp~=tp
end
function c10150032.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0 end
	e:SetLabel(0)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(c10150032.cfilter2,tp,LOCATION_MZONE,0,1,nil) then
	   e:SetLabel(100)
	   Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
	end
end
function c10150032.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if e:GetLabel()==100 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(10150032,0)) then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	  local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	  Duel.HintSelection(g)
	  Duel.Destroy(g,REASON_EFFECT)
	  e:SetLabel(0)
	end
	Duel.ChangeChainOperation(ev,c10150032.repop)
end
function c10150032.repop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if ct>0 then
	   Duel.Damage(tp,ct*800,REASON_EFFECT) 
	end
end

