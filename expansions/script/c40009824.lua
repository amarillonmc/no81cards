--阿蒙的赤眼
local m=40009824
local cm=_G["c"..m]
cm.named_with_Amon=1
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)  
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)   
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)  
	--decrease tribute
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DECREASE_TRIBUTE)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_SZONE+LOCATION_EXTRA+LOCATION_OVERLAY+LOCATION_PZONE,0)
	e6:SetCountLimit(1,m+1)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
	e6:SetValue(0x1)
	c:RegisterEffect(e6) 
end
function cm.Amon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Amon
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and cm.Amon(c)
end
function cm.tdfilter(c)
	return c:IsAbleToGrave()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and cm.thfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.tdfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_HAND)
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoExtraP(tc,tp,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
		local g1=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
		if g1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg1=g1:Select(1-tp,1,1,nil)
			if Duel.SendtoGrave(sg1,REASON_EFFECT)~=0 then
			local val1=Duel.GetMatchingGroupCount(cm.filter1,tp,LOCATION_EXTRA,0,nil)
			local val2=math.floor(val1/3)
				if val2>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
					Duel.BreakEffect()
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
					e1:SetValue(val2*500)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
					c:RegisterEffect(e1)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_UPDATE_DEFENSE)
					c:RegisterEffect(e2)
				end
				if Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_EXTRA,0,15,nil) then
					local g2=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
					if g2:GetCount()>0 then
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
						local sg2=g2:Select(1-tp,2,2,nil)
						if g2:GetCount()>0 then
							Duel.SendtoGrave(sg2,REASON_EFFECT)
						end
					end
				end
			end
		end
	end
end