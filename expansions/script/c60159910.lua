--能量转移
function c60159910.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c60159910.target)
	e1:SetOperation(c60159910.activate)
	c:RegisterEffect(e1)
end
function c60159910.filter(c)
	return c:IsAbleToChangeControler() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetOriginalType()&TYPE_MONSTER==0
end
function c60159910.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c60159910.filter(chkc) end
	if e:GetHandler():IsLocation(LOCATION_HAND) then
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>1 
			and Duel.IsExistingTarget(c60159910.filter,tp,0,LOCATION_ONFIELD,1,nil) 
		end
	else
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
			and Duel.IsExistingTarget(c60159910.filter,tp,0,LOCATION_ONFIELD,1,nil) 
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c60159910.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c60159910.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsRelateToEffect(e) then
		tc:CancelToGrave()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	end
end