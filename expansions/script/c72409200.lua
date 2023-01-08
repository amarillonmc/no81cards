--与祸津神的决战
function c72409200.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,72409200+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c72409200.cost)
	e1:SetTarget(c72409200.target)
	e1:SetOperation(c72409200.activate)
	c:RegisterEffect(e1)
end

function c72409200.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c72409200.filter(c,tp)
	return c:IsFaceup()  and c:IsSetCard(0xe729) and Duel.IsExistingMatchingCard(c72409200.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c72409200.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x6729) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden() 
end
function c72409200.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c72409200.filter(chkc,tp) end
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingTarget(c72409200.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c72409200.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c72409200.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	local n=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local g=Duel.GetMatchingGroup(c72409200.eqfilter,tp,LOCATION_DECK,0,nil,tc,tp)
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,n)
		  if sg:GetCount()>0 then
		   local tg=Group.GetFirst(sg)
				while tg do
				Duel.Equip(tp,tg,tc)
				tg=Group.GetNext(sg)
				end
			end
				local e1=Effect.CreateEffect(e:GetOwner())
				e1:SetDescription(aux.Stringid(72409200,1))
				e1:SetCategory(CATEGORY_REMOVE)
				e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetTarget(c72409200.target2)
				e1:SetCountLimit(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetOperation(c72409200.operation2)
				e1:SetValue(1)
				tc:RegisterEffect(e1)
	end
end
function c72409200.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetOwner(),1,0,0)
end
function c72409200.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
--  e:Reset()
end