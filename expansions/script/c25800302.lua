--舰娘-4阶3
local m=25800302
local cm=_G["c"..m]
function cm.initial_effect(c)
			--xyz summon
	c:EnableReviveLimit()   
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCondition(cm.sprcon)
	e0:SetOperation(cm.sprop)
	c:RegisterEffect(e0)
	--be material from grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.gmattg)
	e1:SetOperation(cm.gmatop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetCondition(cm.spcon)
	c:RegisterEffect(e2) 
end
function cm.sprfilter(c,tp,g,sc)   
	return (c:GetOriginalAttribute()&ATTRIBUTE_WATER~=0 and c:GetOriginalLevel()==4 and c:IsLocation(LOCATION_SZONE)) 
	 or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_WATER)) 
end 
function cm.spgckfil(g,e,tp) 
	return Duel.GetLocationCountFromEx(tp,tp,g,nil)
end  
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(cm.spgckfil,2,2,e,tp)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c) 
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g:SelectSubGroup(tp,cm.spgckfil,false,2,2,e,tp)
	c:SetMaterial(g1) 
	Duel.Overlay(c,g1)
end
----
function cm.gmattgfilter(c,sc)
	return c:IsCanOverlay() and (c:IsAttribute(ATTRIBUTE_WATER) or c:IsSetCard(0x211))
end
function cm.gmattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.gmattgfilter,tp,LOCATION_GRAVE,0,1,nil,c) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,cm.gmattgfilter,tp,LOCATION_GRAVE,0,1,2,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
end
function cm.gmatop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetsRelateToChain():Filter(aux.NOT(Card.IsImmuneToEffect),nil,e)
	if c:IsRelateToChain() and #g>0 then
		Duel.Overlay(c,g)
	end
end
----
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x6212)
end