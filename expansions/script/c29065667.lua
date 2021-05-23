--星光的赞歌
function c29065667.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,29065667+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c29065667.target)
	e1:SetOperation(c29065667.operation)
	c:RegisterEffect(e1)
end
function c29065667.spfil(c,e,tp)
	return c:IsSetCard(0x87aa) and c:IsFaceup() and  c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c29065667.rmfil(c)
	return c:IsSetCard(0x87aa) and c:IsAbleToRemove()	
end
function c29065667.thfil(c)
	return c:IsSetCard(0x87aa) and c:IsAbleToHand()
end
function c29065667.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c29065667.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b2=Duel.IsExistingTarget(c29065667.rmfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c29065667.thfil,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
	op=Duel.SelectOption(tp,aux.Stringid(29065667,0),aux.Stringid(29065667,1)) 
	elseif b1 then
	op=Duel.SelectOption(tp,aux.Stringid(29065667,0))
	else
	op=Duel.SelectOption(tp,aux.Stringid(29065667,1))+1
	end
	e:SetLabel(op)
	if op==0 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
	else
	tc=Duel.SelectTarget(tp,c29065667.rmfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)	
	end
end
function c29065667.operation(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local g1=Duel.GetMatchingGroup(c29065667.spfil,tp,LOCATION_EXTRA,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c29065667.thfil,tp,LOCATION_DECK,0,nil)
	if op==0 then 
	if g1:GetCount()<=0 then return end
	sg=g1:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	else
	tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c29065667.retop)
		Duel.RegisterEffect(e1,tp)
	end	
	if g2:GetCount()<=0 then return end
	dg=g2:Select(tp,1,1,nil)
	Duel.SendtoHand(dg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,dg) 
	end
end
function c29065667.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end








