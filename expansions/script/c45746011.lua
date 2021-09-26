--幻影旅团·11 窝金
local m=45746011
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)  
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return Duel.IsExistingMatchingCard(cm.f1,tp,LOCATION_REMOVED,0,1,nil,ft)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.f1,tp,LOCATION_REMOVED,0,1,1,nil,ft)
		Duel.SendtoGrave(g,REASON_COST)
	end)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():IsFaceup()
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToGrave() end
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) then
			Duel.SendtoGrave(c,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 end
	end)
	e3:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			if Duel.IsExistingMatchingCard(cm.cf2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
				return Duel.IsExistingMatchingCard(cm.cof3,tp,LOCATION_REMOVED,0,1,nil)and e:GetHandler():GetFlagEffect(m)<=1
			else
				return Duel.IsExistingMatchingCard(cm.cof3,tp,LOCATION_REMOVED,0,1,nil)and e:GetHandler():GetFlagEffect(m)==0
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.cof3,tp,LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end)
	e3:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsOnField() end
		if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end)
	c:RegisterEffect(e3)
end
function cm.f1(c,ft)
	return c:IsFaceup() and c:IsSetCard(0x5880) and c:IsAbleToGraveAsCost() and ft>0
end
function cm.cof3(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x5880) and c:IsType(TYPE_MONSTER)
end
function cm.cf2(c)
	return c:IsFaceup() and c:IsCode(45746031)
end