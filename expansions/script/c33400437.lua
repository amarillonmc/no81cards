--AST 鸢一折纸 炽热霞光
local m=33400437
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --link summon
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)
	c:EnableReviveLimit()
	  --atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con1)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1) 
--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetCondition(cm.con2)
	e2:SetValue(cm.atkval2)
	c:RegisterEffect(e2) 
 --negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
--
   local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con4)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(cm.immtg)
	e4:SetValue(cm.efilter2)
	c:RegisterEffect(e4)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x9343)
end

function cm.cfilter(c)
	return c:IsFaceup()  and c:IsSetCard(0x9343,0x6343) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.cfilter1(c)
	return c:IsFaceup()   and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil) 
	return g:GetCount()>0
end
function cm.atkval(e,c) 
	return 500*Duel.GetMatchingGroupCount(cm.cfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
end

function cm.con2(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil) 
	return g:GetCount()>1
end
function cm.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x6343)  and c:IsType(TYPE_SPELL+TYPE_EQUIP)
end
function cm.atkval2(e,c) 
	return Duel.GetMatchingGroupCount(cm.cfilter2,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
end

function cm.con3(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil) 
	return g:GetCount()>2
end
function cm.tgfilter(c)
	return aux.disfilter1(c) and (c:IsSetCard(0x341) or (Duel.IsExistingMatchingCard(cm.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
			Duel.IsExistingMatchingCard(cm.cccfilter2,tp,LOCATION_MZONE,0,1,nil))) 
end
function cm.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function cm.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsOnField() and aux.disfilter1(chkc)  end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE+CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		end   
	end
end

function cm.con4(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil) 
local eg=e:GetHandler():GetEquipGroup()
	return g:GetCount()>3 and eg:IsExists(Card.IsSetCard,1,nil,0x6343)
end
function cm.immtg(e,c)
	return c:IsSetCard(0x9343,0x6343) and c:IsFaceup()
end
function cm.efilter2(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and (re:GetHandler():IsSetCard(0x341) or (Duel.IsExistingMatchingCard(cm.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
			Duel.IsExistingMatchingCard(cm.cccfilter2,tp,LOCATION_MZONE,0,1,nil)) )
end