local m=15000708
local cm=_G["c"..m]
cm.name="盖理的诗歌"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,15000708+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return g:GetClassCount(Card.GetRace)>=4
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then return g:FilterCount(Card.IsAbleToGrave,nil)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.filter2(c,e,tp,mc)
	return c:IsSetCard(0x3f38) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	g=g:Filter(Card.IsAbleToGrave,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:Select(tp,1,99,nil)
	if tg:GetCount()~=0 and Duel.SendtoGrave(tg,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local ag=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		local tc=ag:GetFirst()
		if tc then
			if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())  
				e1:SetType(EFFECT_TYPE_SINGLE)  
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)  
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)  
				e1:SetValue(LOCATION_DECKBOT)  
				tc:RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
			end
		end
	end
end