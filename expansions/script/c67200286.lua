--封缄的堕冥者 赫露菲优特鲁
function c67200286.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum
	aux.EnablePendulumAttribute(c,false)
	--Synchro meterial
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),aux.NonTuner(Card.IsSetCard,0x674),1,99)
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(100)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage & control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200286,1))
	e4:SetCategory(CATEGORY_CONTROL+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,67200286)
	e4:SetCondition(c67200286.discon)
	e4:SetTarget(c67200286.distg)
	e4:SetOperation(c67200286.disop)
	c:RegisterEffect(e4)	
end
--
function c67200286.disfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSetCard(0x674)
end
function c67200286.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c67200286.disfilter,1,nil,tp)
end
function c67200286.filter(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack()) and c:IsControlerCanBeChanged()
end
function c67200286.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c67200286.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200286.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c67200286.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local atk=math.abs(tc:GetAttack()-tc:GetBaseAttack())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,1-tp,atk)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c67200286.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=math.abs(tc:GetAttack()-tc:GetBaseAttack())
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Damage(1-tp,atk,REASON_EFFECT)~=0 then
		Duel.GetControl(tc,tp)
	end
end
