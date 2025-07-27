--超龙机兵王 炽神
local m=21196530
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not cm._ then
		cm._=true
		cm._appeared = {[0] = false,[1] = false}
		cm_cardtype = {[0] = {},	[1] = {}	}
		cm_cardtype2 = {[0] = {},	[1] = {}	}
		local e10=Effect.CreateEffect(c)
		e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e10:SetCode(EVENT_PHASE+PHASE_END)
		e10:SetCountLimit(1)
		e10:SetOperation(cm.op10)
		Duel.RegisterEffect(e10,0)
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e11:SetCode(EVENT_ADJUST)
		e11:SetCondition(cm.con11)
		e11:SetOperation(cm.op11)
		Duel.RegisterEffect(e11,0)
		local e12=Effect.CreateEffect(c)
		e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e12:SetCode(EVENT_ADJUST)
		e12:SetCountLimit(1)
		e12:SetRange(0xff)
		e12:SetOperation(cm.op12)
		c:RegisterEffect(e12)
	end
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA+LOCATION_HAND)
	e0:SetCondition(cm.con0)
	e0:SetTarget(cm.tg0)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	cm.special=e0
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(0,LOCATION_HAND)
	e3:SetTarget(cm.tg3)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_ATKCHANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
function cm.op10(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	cm._appeared[0] = false
	cm._appeared[1] = false
	Duel.AdjustAll()
	for k = 0,1 do
		if #cm_cardtype[k]>0 and not cm._appeared[k] then
			for i = 1,#cm_cardtype[k] do
				local tc=cm_cardtype[k][i]
				tc:SetCardData(CARDDATA_TYPE,cm_cardtype2[k][i])
				if tc:IsLocation(LOCATION_MZONE) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_TYPE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1)
					Duel.Readjust()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CHANGE_LEVEL)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_ADD_ATTRIBUTE)
					e1:SetRange(LOCATION_MZONE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(ATTRIBUTE_DARK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_ADD_RACE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(RACE_FIEND)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_BASE_ATTACK)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(1000)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_BASE_DEFENSE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(1000)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
					tc:RegisterEffect(e1)					
				end
			end
		cm_cardtype[k] = {}
		cm_cardtype2[k] = {}
		end
	end
end
function cm.w(c)
	return c:GetOriginalCode()==m and c:IsFaceup()
end
function cm.con11(e,tp,eg,ep,ev,re,r,rp)
	return (not cm._appeared[0] and Duel.IsExistingMatchingCard(cm.w,0,LOCATION_ONFIELD,0,1,nil)) or (not cm._appeared[1] and Duel.IsExistingMatchingCard(cm.w,1,LOCATION_ONFIELD,0,1,nil))
end
function cm.op11(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.w,0,LOCATION_ONFIELD,0,1,nil) then cm._appeared[0] = true end
	if Duel.IsExistingMatchingCard(cm.w,1,LOCATION_ONFIELD,0,1,nil) then cm._appeared[1] = true end
end
function cm.op12(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	for p = 0,1 do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCondition(cm.op12_con1)
		e1:SetOperation(cm.op12_op1)
		Duel.RegisterEffect(e1,p)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_FIELD)
		e2:SetLabel(p)
		e2:SetCondition(cm.op12_con2)
		e2:SetValue(cm.op12_val2)
		Duel.RegisterEffect(e2,p)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_ADJUST)
		e3:SetCondition(cm.op12_con3)
		e3:SetOperation(cm.op12_op3)
		Duel.RegisterEffect(e3,p)
	end
end
function cm.op12_con1(e,tp,eg,ep,ev,re,r,rp)
	return cm._appeared[tp] and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_SZONE,1,nil)
end
function cm.op12_op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_SZONE,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE)
	end
end
function cm.op12_con2(e)
	return cm._appeared[e:GetLabel()]
end
function cm.op12_val2(e)
	local tp=e:GetLabel()
	if tp==0 then
		return 0x1f000000
	else
		return 0x00001f00
	end
end
function cm.e(c)
	return c:GetFlagEffect(m)==0 and c:GetOriginalType()&(TYPE_SPELL|TYPE_TRAP)>0
end
function cm.op12_con3(e,tp,eg,ep,ev,re,r,rp)
	return cm._appeared[tp] and Duel.GetMatchingGroupCount(cm.e,tp,0,0xff,nil)>0
end
function cm.op12_op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.e,tp,0,0xff,nil)
	for tc in aux.Next(g) do
		cm_cardtype[tp][#cm_cardtype[tp]+1] = tc
		cm_cardtype2[tp][#cm_cardtype2[tp]+1] = tc:GetOriginalType()
		tc:SetCardData(CARDDATA_TYPE,TYPE_NORMAL+TYPE_MONSTER)
		tc:SetCardData(CARDDATA_LEVEL,1)
		tc:SetCardData(CARDDATA_RACE,RACE_FIEND)
		tc:SetCardData(CARDDATA_ATTRIBUTE,ATTRIBUTE_DARK)
		tc:SetCardData(CARDDATA_ATTACK,1000)
		tc:SetCardData(CARDDATA_DEFENSE,1000)
	end
end
function cm.q(c)
	return not (c:IsFaceup() and c:IsSetCard(0x6919)) and c:IsAbleToGraveAsCost()
end
function cm.con0(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	return #g>0 and Duel.GetMZoneCount(tp,g)
end
function cm.tg0(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,#g,#g,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	Duel.SendtoGrave(g,REASON_SPSUMMON+REASON_MATERIAL)
end
function cm.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	return #g>0 and Duel.GetMZoneCount(tp,g)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.q,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(3,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,#g,#g,nil)
	if Duel.SendtoGrave(sg,REASON_SPSUMMON+REASON_MATERIAL)>0 and Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_MZONE,POS_FACEUP,true) then
		return false
	else
		return false
	end	
end
function cm.r(c)
	return c:IsFaceup() and c:IsSetCard(0x6919)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.r,tp,LOCATION_MZONE,0,1,nil)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,4)>0 then
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.tg3(e,c)
	return c:IsType(TYPE_MONSTER)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,1-tp,LOCATION_REMOVED)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
	if #g>0 and Duel.SendtoDeck(g,tp,2,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
	local x=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA):GetCount()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(x*1000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e3)	
	end
end