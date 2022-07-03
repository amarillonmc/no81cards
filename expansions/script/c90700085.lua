local m=90700085
local cm=_G["c"..m]
cm.name="神碑之薪火"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetOperation(cm.op)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) then Duel.Draw(tp,1,REASON_EFFECT) end
	Duel.SendtoGrave(c,REASON_EFFECT)

	Duel.CreateToken(tp,92107604)
	local c92107604=_G["c92107604"]
	c92107604.initial_effect=cm.initial_effect_92107604

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(cm.fieldop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.actlimit)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.setlimit)
	Duel.RegisterEffect(e3,tp)

	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0)
	g:ForEach(
		function (tc)
			if tc:IsSetCard(0x17f) and tc:IsType(TYPE_QUICKPLAY) then
				local eset={tc:GetActivateEffect()}
				for _,te in pairs(eset) do
					local ne=Effect.CreateEffect(tc)
					ne:SetDescription(te:GetDescription())
					ne:SetCategory(te:GetCategory())
					ne:SetProperty(te:GetProperty())
					ne:SetType(EFFECT_TYPE_ACTIVATE)
					ne:SetCode(te:GetCode())
					if te:GetCondition() then
						ne:SetCondition(te:GetCondition())
					end
					if te:GetCost() then
						ne:SetCost(te:GetCost())
					end				 
					ne:SetTarget(te:GetTarget())
					ne:SetOperation(te:GetOperation())
					tc:RegisterEffect(ne)
					te:Reset()
				end
			end
		end
	)
end
function cm.filter(c,e)
	return c:IsSetCard(0x17f) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and g:GetClassCount(Card.GetCode)>=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Group.CreateGroup()
	while #tg<3 do
		local tc=g:Select(tp,1,1,nil):GetFirst()
		tg:AddCard(tc)
		g:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function cm.initial_effect_92107604(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x17f))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(92107604,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c92107604.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(c92107604.operation)
	c:RegisterEffect(e3)
end
function cm.fieldop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local c=Duel.GetFieldGroup(tp,LOCATION_FZONE,0):GetFirst()
	if c and c:IsCode(92107604) then return end
	local field=Duel.CreateToken(tp,92107604)
	Duel.MoveToField(field,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end