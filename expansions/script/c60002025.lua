local m=60002025
local cm=_G["c"..m]
cm.name="Once Upon A Rainy Day"
function cm.initial_effect(c)
	c:EnableCounterPermit(0x6620)
	 --atc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,60002025+EFFECT_COUNT_CODE_DUEL)
	e0:SetTarget(cm.regtg)
	e0:SetOperation(cm.bgmop)
	c:RegisterEffect(e0)
	--cannot be destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot set/activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.setlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetValue(cm.actlimit)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.tg)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.tg)
	e5:SetOperation(cm.op)
	c:RegisterEffect(e5)
	--open
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_MOVE)
	e6:SetCondition(cm.regcon)
	e6:SetTarget(cm.regtg)
	e6:SetOperation(cm.bgmop)
	e6:SetLabelObject(e0)
	c:RegisterEffect(e6)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=e:GetLabelObject()
	return c:IsLocation(LOCATION_FZONE) and c:IsFaceup() and c:GetReason()~=33555456
end
function cm.regtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local c=e:GetHandler()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(cm.gycon)
	e1:SetOperation(cm.gyop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function cm.gycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==4 then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function cm.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,0))
	local x=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)*1000+Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)*100+Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,LOCATION_GRAVE)*10+Duel.GetFieldGroupCount(tp,LOCATION_DECK,LOCATION_DECK)
	e:GetHandler():AddCounter(0x6620,x,false)
end 
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local x=e:GetHandler():GetCounter(0x6620)/2
	local count=math.ceil(x)
Debug.Message(count)
	if count>=1 then Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,count) end
	if count<=100 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp, LOCATION_DECK) end
	if count<=1000 then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp, LOCATION_GRAVE) end
	if count<=10000 then Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) end
end
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetCounter(0x6620)/2
	local count=math.ceil(x)
	if x==0 then Duel.SetLP(1-tp,0) end
	if e:GetHandler():RemoveCounter(tp,0x6620,count,REASON_EFFECT) then
		if count>=1 then Duel.Recover(tp,count,REASON_EFFECT) end
		if count<=100 and Duel.GetMZoneCount(tp)>=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
			if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		end
		if count<=1000 and Duel.GetMZoneCount(tp)>=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
			if tc then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		end
		if count<=10000 then Duel.Draw(tp,1,REASON_EFFECT) end
		if count>=100000 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetRange(LOCATION_FZONE)
			e2:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
			e2:SetTargetRange(1,0)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e:GetHandler():RegisterEffect(e2)
		end
	end
end