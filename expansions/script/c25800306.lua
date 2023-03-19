--舰娘-4阶2
local m=25800306
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
	 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.ovtg)
	e1:SetOperation(cm.ovop)
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
function cm.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e)) and c:IsSetCard(0x211)
end
function cm.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(cm.ofilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,cm.ofilter,tp,LOCATION_DECK,0,1,1,nil,e)
		local tc=g:GetFirst()
		if tc then
			Duel.Overlay(c,tc)
		end
		Duel.ShuffleDeck(tp)
	end
end
----
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x6212)
end