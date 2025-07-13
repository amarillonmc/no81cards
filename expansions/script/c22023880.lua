--人理之诗 坏劫的天轮
function c22023880.initial_effect(c)
	aux.AddCodeList(c,22023870)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c22023880.ffilter,3,true)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,22023880)
	e1:SetTarget(c22023880.eqtg)
	e1:SetOperation(c22023880.eqop)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--race
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22023880,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MONSTER))
	e4:SetCondition(c22023880.condition)
	e4:SetValue(RACE_DRAGON)
	c:RegisterEffect(e4)
end
function c22023880.condition(e)
	return e:GetHandler():GetEquipTarget()
end
function c22023880.filter(c)
	return c:IsFaceup() and c:IsCode(22023870)
end
function c22023880.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22023880.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and e:GetHandler():CheckUniqueOnField(tp)
		and Duel.IsExistingTarget(c22023880.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22023880.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function c22023880.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsControler(1-tp) or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c22023880.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
end
function c22023880.eqlimit(e,c)
	return c==e:GetLabelObject()
end