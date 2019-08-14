--爱莎-魔女装着
function c60150804.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c60150804.spcon)
	e2:SetOperation(c60150804.spop)
	c:RegisterEffect(e2)
	--素材
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c60150804.efcon)
	e3:SetOperation(c60150804.efop)
	c:RegisterEffect(e3)
end
function c60150804.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x3b23) and c:IsAbleToRemoveAsCost()
end
function c60150804.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60150804.spfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c60150804.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c60150804.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c60150804.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c60150804.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c60150804.atkcon)
	e1:SetTarget(c60150804.target)
	e1:SetOperation(c60150804.atkop)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_LEAVE)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_TYPE)
		e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2)
	end
end
function c60150804.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x3b23) and e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60150804.filter(c)
	return c:IsAbleToRemove() or c:IsAbleToGrave()
end
function c60150804.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c60150804.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c60150804.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE+CATEGORY_TOGRAVE,g,1,0,0)
end
function c60150804.atkop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,60150804)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c60150804.filter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60150804,0))
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsAbleToRemove() and tc:IsAbleToGrave() then
			if Duel.SelectYesNo(tp,aux.Stringid(60150804,1)) then
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
				local g2=Duel.GetOperatedGroup()
				local ct=g2:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
				if ct==1 then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		elseif not tc:IsAbleToRemove() and tc:IsAbleToGrave() then
			Duel.SendtoGrave(tc,REASON_EFFECT)
			local g2=Duel.GetOperatedGroup()
			local ct=g2:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)
			if ct==1 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		elseif tc:IsAbleToRemove() and not tc:IsAbleToGrave() then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end