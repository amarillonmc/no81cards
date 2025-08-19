--祭 铜 斗 士  费 那 提 斯
local m=22348225
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--summon with s/t
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e0:SetTargetRange(LOCATION_SZONE,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPELL))
	e0:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348225,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c22348225.setcon)
	e1:SetTarget(c22348225.settg)
	e1:SetOperation(c22348225.setop)
	c:RegisterEffect(e1)
		--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c22348225.tdcon)
	e2:SetCost(c22348225.tdcost)
	e2:SetTarget(c22348225.tdtg)
	e2:SetOperation(c22348225.tdop)
	c:RegisterEffect(e2)
	
end
function c22348225.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA)
end
function c22348225.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c22348225.tdfilter(c)
	return not c:IsCode(22348225) and c:IsSetCard(0x708) and c:IsAbleToHand()
end
function c22348225.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c22348225.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348225.tdfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c22348225.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c22348225.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c22348225.setfilter(c,e,tp)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c22348225.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg1=Group.CreateGroup()
	local sg2=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c22348225.setfilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(c22348225.setfilter,tp,LOCATION_MZONE,0,nil)
	local b1=(g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22348225,3)))
	local b2=(g2:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(22348225,3)))
	if not b1 and not b2 then return end
	if b1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	sg1=g1:Select(tp,1,1,nil)
	end
	if b2 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	sg2=g2:Select(1-tp,1,1,nil)
	end
	local tc1=sg1:GetFirst()
	local tc2=sg2:GetFirst()
			 if tc1 then
			  Duel.MoveToField(tc1,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			  local ttc1=tc1:GetCode()
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			  tc1:RegisterEffect(e1)
			  local e2=Effect.CreateEffect(e:GetHandler())
			  e2:SetType(EFFECT_TYPE_FIELD)
			  e2:SetRange(LOCATION_SZONE)
			  e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			  e2:SetTargetRange(1,1)
			  e2:SetLabelObject(tc1)
			  e2:SetTarget(c22348225.spsmlimit)
			  tc1:RegisterEffect(e2)
			  local e3=Effect.CreateEffect(e:GetHandler())
			  e3:SetType(EFFECT_TYPE_FIELD)
			  e3:SetRange(LOCATION_SZONE)
			  e3:SetCode(EFFECT_CANNOT_ACTIVATE)
			  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			  e3:SetTargetRange(1,1)
			  e3:SetLabelObject(tc1)
			  e3:SetValue(c22348225.aclimit)
			  tc1:RegisterEffect(e3)
			 end
			 if tc2 then
			  Duel.MoveToField(tc2,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			  local ttc2=tc2:GetCode()
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetCode(EFFECT_CHANGE_TYPE)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			  e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			  tc2:RegisterEffect(e1)
			  local e2=Effect.CreateEffect(e:GetHandler())
			  e2:SetType(EFFECT_TYPE_FIELD)
			  e2:SetRange(LOCATION_SZONE)
			  e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			  e2:SetTargetRange(1,1)
			  e2:SetLabelObject(tc2)
			  e2:SetTarget(c22348225.spsmlimit)
			  tc2:RegisterEffect(e2)
			  local e3=Effect.CreateEffect(e:GetHandler())
			  e3:SetType(EFFECT_TYPE_FIELD)
			  e3:SetRange(LOCATION_SZONE)
			  e3:SetCode(EFFECT_CANNOT_ACTIVATE)
			  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			  e3:SetTargetRange(1,1)
			  e3:SetLabelObject(tc2)
			  e3:SetValue(c22348225.aclimit)
			  tc2:RegisterEffect(e3)
			 end
end
function c22348225.spsmlimit(e,c,tp,sumtp,sumpos)
	local tc=e:GetLabelObject()
	local ttc=tc:GetCode()
	return c:IsCode(ttc)
end
function c22348225.aclimit(e,re,tp)
	local tc=e:GetLabelObject()
	local ttc=tc:GetCode()
	return re:GetHandler():IsCode(ttc)
end



	
