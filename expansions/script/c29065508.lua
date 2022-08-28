--方舟骑士-陈
c29065508.named_with_Arknight=1
function c29065508.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,6,3,c29065508.ovfilter,aux.Stringid(29065508,0),3,c29065508.xyzop)
	c:EnableReviveLimit()
	--Double attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29065508,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,29065508)
	e2:SetCost(c29065508.descost)
	e2:SetTarget(c29065508.destg)
	e2:SetOperation(c29065508.desop)
	c:RegisterEffect(e2)
end
function c29065508.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function c29065508.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x10ae,2,REASON_COST) and Duel.GetFlagEffect(tp,29065508)==0 end
	Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
	Duel.RegisterFlagEffect(tp,29065508,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c29065508.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29065508.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29065508.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end