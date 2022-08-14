--传说之魂 无心
local m=33350011
local cm=_G["c"..m]
function c33350011.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,cm.mfilter,1,6,cm.xyzop,aux.Stringid(m,0))
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.effcon)
	e1:SetTarget(cm.efftg)
	e1:SetOperation(cm.effop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(cm.imcon)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_ATKCHANGE+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCost(cm.effcost)
	e3:SetTarget(cm.drtg)
	e3:SetOperation(cm.drop)
	c:RegisterEffect(e3)
end
cm.setname="TaleSouls"
function cm.mfilter(c,xyzc)
	return c.setname=="TaleSouls" and c:IsLevel(1)
end
function cm.spfilter(c)
	return c:IsCode(33350007) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.xyzop(c)
	return Duel.IsExistingMatchingCard(cm.spfilter,c:GetControler(),LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil) and c:IsFaceup() and c:IsCode(33350010)
end
--叠放要求
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e)) and  c.setname=="TaleSouls"
end
function cm.gselect(g,mat)
	g:Merge(mat)
	return aux.dncheck(g) and g:GetClassCount(Card.GetOriginalCodeRule)==#g
end
function cm.tgfilter(c)
	return c:IsCanOverlay() and  c.setname=="TaleSouls"
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mat=c:GetOverlayGroup()
	if chk==0 then local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,nil)
		g:Merge(mat)
		return g:GetClassCount(Card.GetOriginalCodeRule)>5 and g:GetClassCount(Card.GetCode)>5 end
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=e:GetHandler():GetOverlayCount()
	local mat=e:GetHandler():GetOverlayGroup()
	local g=Duel.GetMatchingGroup(cm.ofilter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,nil,e)
	g:Merge(mat)
	if g:GetClassCount(Card.GetCode)<6 or g:GetClassCount(Card.GetOriginalCodeRule)<6 then
		Duel.SendtoGrave(c,REASON_EFFECT)
	else
		g=g-mat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tg1=g:SelectSubGroup(tp,cm.gselect,false,6,6,mat)
		Duel.Overlay(c,tg1)
		if e:GetHandler():GetOverlayCount()~=6  then
			Duel.SendtoGrave(c,REASON_EFFECT)
			end
	end
  
end
--效果1
function cm.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function cm.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
--效果2
function cm.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-c:GetControler(),500)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-c:GetControler(),800)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-500)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e2)
	end
	Duel.BreakEffect()
	Duel.Recover(1-c:GetControler(),500,REASON_EFFECT)
	Duel.Damage(1-c:GetControler(),800,REASON_EFFECT)
end
