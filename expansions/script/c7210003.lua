--神裁天幕 秩序
function c7210003.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c7210003.matfilter1,c7210003.matfilter2,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7210003,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,7210003)
	e1:SetCondition(function(e) 
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA) end) 
	e1:SetTarget(c7210003.cttg)
	e1:SetOperation(c7210003.ctop)
	c:RegisterEffect(e1)
	--counter and destroy
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(7210003,0))
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,17210003)
	e2:SetTarget(c7210003.cdtg)
	e2:SetOperation(c7210003.cdop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7210003,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c7210003.decon)
	e3:SetCost(c7210003.decost)
	e3:SetTarget(c7210003.detg)
	e3:SetOperation(c7210003.deop)
	c:RegisterEffect(e3)
end
function c7210003.matfilter1(c)
	return (c:IsFusionType(TYPE_FUSION) or c:IsFusionType(TYPE_SYNCHRO) or c:IsFusionType(TYPE_LINK) or c:IsFusionType(TYPE_XYZ)) and c:IsFusionSetCard(0x6f8)
end
function c7210003.matfilter2(c)
	return c:IsFusionType(TYPE_MONSTER) and c:IsFusionSetCard(0x6f8)
end
function c7210003.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x16f8)
end
function c7210003.ctop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x16f8,1)
	end
end
function c7210003.filter(c,tp)
	return c:GetReasonPlayer()==1-tp
end
function c7210003.filter2(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetReasonPlayer()==1-tp
end
function c7210003.cdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c7210003.filter,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x16f8)
end
function c7210003.cdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x16f8,1)
		if eg:IsExists(c7210003.filter2,1,nil,tp) and Duel.IsExistingMatchingCard(aux.TURE,tp,0,LOCATION_ONFIELD,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.HintSelection(dg)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c7210003.decon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_ONFIELD)~=0
end
function c7210003.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x16f8,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x16f8,1,REASON_COST)
end
function c7210003.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(aux.TURE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TURE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c7210003.deop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
