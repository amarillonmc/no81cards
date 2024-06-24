function c10105699.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetLabel(ccode)
	e0:SetCondition(c10105699.spcon)
	e0:SetOperation(c10105699.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
    	--Activate
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10105699,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCost(c10105699.cost)
	e1:SetTarget(c10105699.target)
	e1:SetOperation(c10105699.activate)
	c:RegisterEffect(e1)
     --atl 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(function(e)
	return e:GetHandler():GetOverlayCount()*300 end) 
	c:RegisterEffect(e2)
      --Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10105699,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,101056990)
	e3:SetCondition(c10105699.negcon)
	e3:SetCost(c10105699.negcost)
	e3:SetTarget(c10105699.negtg)
	e3:SetOperation(c10105699.negop)
	c:RegisterEffect(e3)
end
function c10105699.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x30) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(0)
end
function c10105699.fselect(g,tp,sc)
	local lv=0
	local tc=g:GetFirst()
	while tc do
		lv=lv+tc:GetLevel()
		tc=g:GetNext()
	end
	return lv>=12 and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c10105699.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c10105699.ovfilter,tp,LOCATION_GRAVE,0,nil)
	return Duel.GetFlagEffect(tp,m)==0 and g:CheckSubGroup(c10105699.fselect,3,6,tp,c)
end
function c10105699.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c10105699.ovfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tg=g:SelectSubGroup(tp,c10105699.fselect,false,3,6,tp,c)
	Duel.Hint(HINT_CARD,tp,m)
	Duel.HintSelection(tg)
	c:SetMaterial(tg)
	Duel.Overlay(c,tg)
	e:SetLabel(ct)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c10105699.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c10105699.eqfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c10105699.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x30) and not c:IsType(TYPE_XYZ)
end
function c10105699.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and not e:GetHandler():IsLocation(LOCATION_SZONE) then ct=ct-1 end
	if chk==0 then return ct>0
		and Duel.IsExistingTarget(c10105699.eqfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c10105699.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c10105699.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,c10105699.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c10105699.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local hc=g:GetFirst()
	if hc==tc then hc=g:GetNext() end
	if hc:IsControler(tp) and tc:IsFaceup() and tc:IsRelateToEffect(e)
		and tc:IsControler(1-tp) and tc:IsLocation(LOCATION_MZONE)
		and tc:IsAbleToChangeControler() and Duel.Equip(tp,tc,hc,false) then
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(hc)
		e1:SetValue(c10105699.eqlimit)
		tc:RegisterEffect(e1,true)
	end
end
function c10105699.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c10105699.desrepval(e,re,r,rp)
	return r&(REASON_BATTLE|REASON_EFFECT)~=0
end
function c10105699.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and Duel.IsChainNegatable(ev)
end
function c10105699.negfilter(c)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c10105699.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10105699.negfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c10105699.negfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c10105699.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10105699.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end