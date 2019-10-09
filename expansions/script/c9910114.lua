--战车道少女·大吉岭
function c9910114.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910114)
	e1:SetCost(c9910114.spcost)
	e1:SetTarget(c9910114.sptg)
	e1:SetOperation(c9910114.spop)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c9910114.poscon)
	e2:SetTarget(c9910114.postg)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c9910114.poscon)
	e3:SetValue(c9910114.aclimit)
	c:RegisterEffect(e3)
end
function c9910114.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c9910114.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and e:GetHandler():IsAbleToDeck()
		and Duel.IsPlayerCanDraw(tp,1) end
end
function c9910114.spop(e,tp,eg,ep,ev,re,r,rp)
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
		Duel.Recover(1-tp,1000,REASON_EFFECT)
		if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
		Duel.BreakEffect()
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end
end
function c9910114.poscon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsDefensePos()
end
function c9910114.postg(e,c)
	return c:IsFaceup()
end
function c9910114.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
		and (re:GetActivateLocation()~=LOCATION_MZONE or (not re:GetHandler():IsDefensePos()))
end
