local m=53796038
local cm=_G["c"..m]
cm.name="艾笛卡"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_WIND),2,2)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.linklimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.zonelimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.atfilter)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	--e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(cm.regop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.thcon)
	e6:SetTarget(cm.thtg)
	e6:SetOperation(cm.thop)
	c:RegisterEffect(e6)
end
function cm.zonelimit(e)
	return 0x7f007f & ~e:GetHandler():GetLinkedZone()
end
function cm.xylabel(c,tp)
	local x,y=c:GetSequence(),0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_PZONE) then y=0
		elseif c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		else x,y=-1,-5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_PZONE) then x,y=4-x,4
		elseif c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		else x,y=5,9 end
	end
	return x,y
end
function cm.gradient(y,x)
	if y>0 and x==0 then return 1000 end
	if y<0 and x==0 then return 1100 end
	if y>0 and x~=0 then return y/x end
	if y<0 and x~=0 then return y/x+100 end
	if y==0 and x>0 then return 0 end
	if y==0 and x<0 then return 100 end
	return 65536
end
function cm.line(tc,c,tp,...)
	local x1,y1=cm.xylabel(c,tp)
	local x2,y2=cm.xylabel(tc,tp)
	for _,k in ipairs({...}) do if cm.gradient(y2-y1,x2-x1)==k then return true end end
	return false
end
function cm.atfilter(e,c)
	local t1,t2,t3,t4={101,1100,99,100,0,-1,1000,1},{0x001,0x002,0x004,0x008,0x020,0x040,0x080,0x100},{},{}
	local l=e:GetHandler():GetLinkMarker()
	if l==0 then return false end
	for i=1,8 do if l&t2[i]==t2[i] then table.insert(t3,i) end end
	for i=1,#t3 do
		local n=t3[i]
		table.insert(t4,t1[n])
	end
	return cm.line(c,e:GetHandler(),e:GetHandlerPlayer(),table.unpack(t4)) and not c:IsAttribute(ATTRIBUTE_WIND)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsReason(REASON_DESTROY) then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0) end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and cm.thfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,true) and Duel.IsExistingTarget(cm.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,SUMMON_TYPE_LINK,tp,tp,false,true,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
