--机械装甲陆
local m=91000406
local cm=c91000406
function c91000406.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.sprcon)
	e1:SetTarget(cm.sprtg)
	e1:SetOperation(cm.sprop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m+100)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)  
	--local e5=Effect.CreateEffect(c)
	--e5:SetCategory(CATEGORY_EQUIP)
	--e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	--e5:SetProperty(EFFECT_FLAG_DELAY)
	--e5:SetCode(EVENT_DESTROYED)
	--e5:SetRange(LOCATION_GRAVE)
	--e5:SetCountLimit(1,m*5)
	--e5:SetCondition(cm.condition)
	--e5:SetTarget(cm.tg5)
   -- e5:SetOperation(cm.op5)
	--c:RegisterEffect(e5)

end
function cm.cfilter(c,tp,f)
	return f(c) and Duel.GetMZoneCount(tp,c)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.cfiltern,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp,Card.IsAbleToGraveAsCost)
end
function cm.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.cfiltern,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp,Card.IsAbleToGraveAsCost)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.counterfilter1)
	Duel.RegisterEffect(e1,tp)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup()  and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,c,tc) then return end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(1)
		c:RegisterEffect(e3)
	end

end
function cm.counterfilter1(e,c)
	return  not (c:IsLevel(10) or c:IsRank(10)) and c:IsLocation(LOCATION_EXTRA)
end
function cm.thfilter2(c)
	return  c:IsSetCard(0x9d2)and not c:IsForbidden()
end
function cm.spfilter(c)
	return c:IsSetCard(0x9d2) and c:IsAbleToGrave() 
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g1,REASON_EFFECT)
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(tp) and c:IsSetCard(0x9d2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,e:GetHandler(),tp) 
end
function cm.thfilter2(c)
	return  c:IsSetCard(0x9d2)
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)end   
Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)   
end

