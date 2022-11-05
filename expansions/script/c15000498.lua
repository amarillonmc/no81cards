local m=15000498
local cm=_G["c"..m]
cm.name="星拟龙·坍缩子龙 RK12"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,15000498)
	e2:SetCondition(cm.XyzConditionAlter)
	e2:SetOperation(cm.XyzOperationAlter)
	c:RegisterEffect(e2)
	--win
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.winop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--material
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.mttg)
	e5:SetOperation(cm.mtop)
	c:RegisterEffect(e5)
	--SearchCard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCountLimit(1)
	e6:SetCondition(aux.bdocon)
	e6:SetTarget(cm.thtg2)
	e6:SetOperation(cm.thop2)
	c:RegisterEffect(e6)
end
cm.rkdn={15000497}
function cm.xyzfilter(c)
	return c:IsFaceup() and c:IsCode(15000497)
end
function cm.XyzAlterFilter(c,alterf,xyzc,e,tp)
	return alterf(c) and c:IsCanBeXyzMaterial(xyzc) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0 and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.XyzConditionAlter(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				if mg:IsExists(cm.XyzAlterFilter,1,nil,cm.xyzfilter,c,e,tp,nil) then
					return true
				end
end
function cm.XyzOperationAlter(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				if not Duel.SelectEffectYesNo(tp,c,aux.Stringid(m,0)) then return end
				local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				local b2=mg:IsExists(cm.XyzAlterFilter,1,nil,cm.xyzfilter,c,e,tp,nil)
				local g=nil
				if b2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,cm.XyzAlterFilter,1,1,nil,cm.xyzfilter,c,e,tp,nil)
				end
				local mg2=g:GetFirst():GetOverlayGroup()
				if mg2:GetCount()~=0 then
					Duel.Overlay(c,mg2)
				end
				c:SetMaterial(g)
				Duel.Overlay(c,g)
				Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end
function cm.wincheck(g)
	return aux.dncheck(g) and #g>=7 and g:FilterCount(Card.IsSetCard,nil,0x3f34)==#g
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	if #g>=7 and g:CheckSubGroup(cm.wincheck,7,#g) then
		Duel.Win(tp,0xf3)
	end
end
function cm.mtfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Overlay(c,g)
	end
end
function cm.filter(c)
	return c:IsSetCard(0xf34) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end