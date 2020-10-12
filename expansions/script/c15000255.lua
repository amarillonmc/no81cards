local m=15000255
local cm=_G["c"..m]
cm.name="永寂之幻象：艾伊诺兹"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon
	aux.AddLinkProcedure(c,cm.mfilter,1,1)
	--when LinkSummon
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCategory(CATEGORY_SEARCH)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.stcon)
	e1:SetTarget(cm.sttg)  
	e1:SetOperation(cm.stop)  
	c:RegisterEffect(e1)
	--atk  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetRange(LOCATION_MZONE)  
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(cm.atkcon)  
	e2:SetValue(cm.value)  
	c:RegisterEffect(e2)
	--adjust  
	local e5=Effect.CreateEffect(c)  
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e5:SetCode(EVENT_ADJUST)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetOperation(cm.adjustop)  
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)  
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e6:SetCode(EVENT_TO_GRAVE)  
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCondition(cm.adjust2con)
	e6:SetOperation(cm.adjust2op)  
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
	e9:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e9)
end
function cm.mfilter(c)
	return c:IsLinkSetCard(0xf37) and not c:IsLinkCode(15000255)
end
function cm.stcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.stfilter(c)  
	return c:IsSetCard(0xaf37) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)  
end  
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local tp=e:GetHandler():GetControler() 
	if chk==0 then return Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end  
end  
function cm.stop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,cm.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
	if g:GetCount()~=0 then 
		Duel.SSet(tp,g)
	end
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsSetCard(0xf37) and c:IsType(TYPE_XYZ)  
end
function cm.value(e,c)  
	local g=e:GetHandler():GetOverlayGroup()
	local ag=Group.Filter(g,Card.IsType,nil,TYPE_LINK)
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetLink()
		x=x+y
		tc=ag:GetNext()
	end
	return x*200
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsSetCard(0xf37) and e:GetHandler():IsType(TYPE_XYZ) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end
function cm.adjust2con(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_OVERLAY)  
end
function cm.adjust2op(e,tp,eg,ep,ev,re,r,rp) 
	local tp=e:GetHandler():GetControler() 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_XYZ)
	local tc=g:GetFirst()
	while tc do
		tc:ResetFlagEffect(m)
		tc=g:GetNext()
	end
	Duel.Readjust()
end