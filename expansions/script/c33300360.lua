--秘湮伪界 狂兽
local m=33300360
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.sumcon)
	e1:SetOperation(cm.sumop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--TO GRAVE
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+100)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_GRAVE_ACTION)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.postg)
	e4:SetOperation(cm.posop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
end
function cm.rfilter(c)
	return c:IsFaceup() and c:IsSSetable() and c:IsType(TYPE_CONTINUOUS)
end
function cm.sumcon(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph~=PHASE_DAMAGE and ph~=PHASE_DAMAGE_CAL and e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.check(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.check,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.check,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
function cm.filter(c)
	if not c:IsType(TYPE_FIELD) then
		return c:IsSSetable(true) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	else
		return c:IsSSetable(true)
	end
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_GRAVE,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0  end
	ft=math.min(ft,2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_GRAVE,1,ft,nil)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g=g:Filter(Card.IsRelateToEffect,nil,e)
	for tc in aux.Next(g) do
		if tc:IsType(TYPE_FIELD) then
			local fc=Duel.GetFieldCard(1-tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.SSet(1-tp,tc)
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(m,5))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		else
			if Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then
				Duel.SSet(1-tp,tc)
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,5))
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
			end
		end
	end
end
