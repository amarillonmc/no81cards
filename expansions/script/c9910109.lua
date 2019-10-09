--战车道少女·逸见艾丽卡
function c9910109.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910109)
	e1:SetCost(c9910109.spcost)
	e1:SetTarget(c9910109.sptg)
	e1:SetOperation(c9910109.spop)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c9910109.aclimit)
	c:RegisterEffect(e2)
end
function c9910109.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c9910109.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetDecktopGroup(1-tp,4)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsAbleToDeck()
		and rg:GetCount()>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==4 end
end
function c9910109.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x952) and tc:IsType(TYPE_MONSTER) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		if not tc:IsForbidden() then
			Duel.DisableShuffleCheck()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	else
		local rg=Duel.GetDecktopGroup(1-tp,4)
		if rg:GetCount()>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==4 then
			Duel.DisableShuffleCheck()
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end
end
function c9910109.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
