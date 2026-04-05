--秒出警
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(s.con0)
	e0:SetTarget(s.target)
	e0:SetOperation(s.prop)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(2,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.con)
	e1:SetTarget(s.target2)
	e1:SetOperation(s.prop2)
	c:RegisterEffect(e1)
end

function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function s.con0(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,1-tp) and rp==1-tp
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x606) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	
	local a = false
	local ct=Duel.GetCurrentChain()
	if ct>=2 then 
		local te,tep=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		a = tep==1-tp and e:IsHasType(EFFECT_TYPE_ACTIVATE)
	end
	
	local num = 1
	
	if a and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		num = 2
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,num,num,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function s.efilter(c,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x606) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
		and Duel.GetMatchingGroupCount(s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)>0 and c:IsFaceupEx()
end
function s.eqfilter(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c)
end
function s.filter01(c,ec)
	return c:IsCode(21000763) and c:IsFaceup()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsSetCard(0x606) and p==tp and rp==1-tp and Duel.IsExistingMatchingCard(s.filter01,tp,LOCATION_MZONE,0,1,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,g2:GetCount(),0,0)
end
function s.prop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.IsExistingMatchingCard(s.efilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local g0=Duel.SelectMatchingCard(tp,s.efilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,tp)
		if g0:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
			local g1 = Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g0:GetFirst())
			if g1:GetCount()>0 then
				Duel.Equip(tp,g0:GetFirst(),g1:GetFirst())
			end
		end
	end
end
function s.spfilter1(c,e,tp)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end