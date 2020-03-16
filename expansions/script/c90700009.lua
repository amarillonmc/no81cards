local m=90700009
local cm=_G["c"..m]
cm.name="霜火律令"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(90700009,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,90700009)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cm.con)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,90700002)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.fieldfilter(c)
	return c:IsSetCard(0x5ac0) and c:IsPosition(POS_FACEUP) and c:IsAbleToHand() and not c:IsLocation(LOCATION_FZONE)
end
function cm.gravemtfilter(c)
	return c:IsSetCard(0x5ac0) and c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP) and not c:IsForbidden()
end
function cm.gravespfilter(c,e,tp)
	return c:IsSetCard(0x5ac0) and c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.fieldfilter,tp,LOCATION_SZONE+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.fieldfilter,tp,LOCATION_SZONE+LOCATION_MZONE,0,nil)
	local num=g:GetCount()
	if num>0 then
		local thnum=Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		local mtnum=Duel.GetMatchingGroupCount(cm.gravemtfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		local spnum=Duel.GetMatchingGroupCount(cm.gravespfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		local mtlnum=Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)
		local splnum=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD)
		local mtcon=mtnum>0 and mtlnum>0
		local spcon=spnum>0 and splnum>0
		while thnum>0 and (mtcon or spcon) and Duel.SelectYesNo(tp,aux.Stringid(90700009,1)) do
			local op
			if mtcon and spcon then
				op=Duel.SelectOption(tp,aux.Stringid(90700009,2),aux.Stringid(90700009,3))
			else
				if mtcon then
					op=0
				end
				if spcon then
					op=1
				end
			end
			if op==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
				local g=Duel.SelectMatchingCard(tp,cm.gravemtfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
				local tc=g:GetFirst()	
				local m=_G["c"..tc:GetCode()]
				local te=m.act
				local op=te:GetOperation()
				te:SetLabel(1)
				local etg=Group.CreateGroup()
				etg:AddCard(tc)
				op(te,tp,etg,ep,ev,re,r,rp)
				te:SetLabel(0)
			end
			if op==1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.gravespfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
				end
			end
			thnum=thnum-1
			mtnum=Duel.GetMatchingGroupCount(cm.gravemtfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
			spnum=Duel.GetMatchingGroupCount(cm.gravespfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
			mtlnum=Duel.GetLocationCount(tp,LOCATION_SZONE,tp,LOCATION_REASON_TOFIELD)
			splnum=Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD)
			mtcon=mtnum>0 and mtlnum>0
			spcon=spnum>0 and splnum>0
		end
	end
end