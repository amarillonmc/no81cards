--神星的圣骑士 托勒密星团M7
function c40008718.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_LIGHT),2)
	c:EnableReviveLimit()   
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40008718,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,40008718+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c40008718.thtg)
	e1:SetOperation(c40008718.thop)
	c:RegisterEffect(e1) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c40008718.valcheck)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	--remove overlay replace
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008718,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40008719)
	e2:SetCondition(c40008718.rcon)
	e2:SetOperation(c40008718.rop)
	c:RegisterEffect(e2)
end
function c40008718.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c40008718.thfilter(c)
	return c:IsAbleToHand()
end
function c40008718.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and c40008718.thfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(40008718)==0
		and Duel.IsExistingTarget(c40008718.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local b1=Duel.IsExistingTarget(c40008718.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingTarget(c40008718.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(40008718,2),aux.Stringid(40008718,3))
	else
		op=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=nil
	if op==0 then
		g=Duel.SelectTarget(tp,c40008718.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	elseif op==1 then
		g=Duel.SelectTarget(tp,c40008718.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	else
		g=Duel.SelectTarget(tp,c40008718.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	if e:GetLabel()==1 then
	   Duel.SetChainLimit(c40008718.chlimit)
	end
end
function c40008718.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c40008718.chlimit(e,ep,tp)
	return tp==ep
end
function c40008718.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0x53)
end
function c40008718.rop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(40008718,4))
end
