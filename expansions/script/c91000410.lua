--武装战姬 凝光
local m=91000410
local cm=c91000410
function c91000410.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,m*2)
	e4:SetCondition(cm.con4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)  
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCost(aux.bfgcost)
	e5:SetCountLimit(1,m*3)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.activate)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(91000410,ACTIVITY_SPSUMMON,cm.counterfilter)
end
function cm.counterfilter(c)
	return  c:IsLevel(10)
end
function cm.counterfilter1(e,c)
	return  not c:IsLevel(10)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.GetCustomActivityCount(91000410,tp,ACTIVITY_SPSUMMON)==0 end
 local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.counterfilter1)
	Duel.RegisterEffect(e1,tp)
end
function cm.tgfilter2(c)
	return c:IsSetCard(0x9d2) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and cm.tgfilter(chkc) and chkc:IsControler(tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
	   
		return
	end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
		local sc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.Equip(tp,tc,sc)   
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_EQUIP_LIMIT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local tc=c:GetEquipTarget()
if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.costfilter(c)
	return c:IsSetCard(0x9d2) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end

function cm.tgfilter(c)
	return c:IsSetCard(0x9d2) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function cm.thfilter2(c)
	return  c:IsSetCard(0x9d2)  and c:IsType(TYPE_MONSTER)and not c:IsForbidden()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return cm.tgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,LOCATION_MZONE)>1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
	local tc2=g:GetFirst()
	if tc:IsRelateToEffect(e)  and tc2:IsFaceup() then
		if not Duel.Equip(tp,tc2,tc,false) then return end
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		tc2:RegisterEffect(e1)
		 if Duel.SelectYesNo(tp,aux.Stringid(m,0)) and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0  then   
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		local sc=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		Duel.Equip(tp,sc,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit2)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
		end 
   end
end
	
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.eqlimit2(e,c)
	return e:GetLabelObject()==c
end
	
