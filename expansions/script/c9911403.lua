--浮光之圣泉 桑茨普茵
function c9911403.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911403)
	e1:SetCost(c9911403.spcost)
	e1:SetTarget(c9911403.sptg)
	e1:SetOperation(c9911403.spop)
	c:RegisterEffect(e1)
	--atk up or atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c9911403.value1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c9911403.value2)
	c:RegisterEffect(e3)
end
function c9911403.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==3 end
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(9911403,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
	end
	g:KeepAlive()
	e:SetLabel(fid)
	e:SetLabelObject(g)
end
function c9911403.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9911403.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local g=e:GetLabelObject()
		if #g>0 then
			g:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(e:GetLabel(),0)
			e1:SetLabelObject(g)
			e1:SetCondition(c9911403.thcon)
			e1:SetOperation(c9911403.thop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EVENT_RELEASE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c9911403.addcount)
			e2:SetOwnerPlayer(tp)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetLabelObject(e1)
			c:RegisterEffect(e2)
		end
	end
end
function c9911403.addcount(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	for tc in aux.Next(eg) do
		if tc:GetPreviousControler()==e:GetOwnerPlayer()
			and (tc:IsPreviousLocation(LOCATION_MZONE) or (tc:IsPreviousLocation(LOCATION_HAND) and tc:IsType(TYPE_MONSTER))) then
			ct=ct+1
		end
	end
	local te=e:GetLabelObject()
	if ct==0 or not te then return end
	local laba,labb=te:GetLabel()
	te:SetLabel(laba,labb+ct)
end
function c9911403.thfilter1(c,fid)
	return c:GetFlagEffectLabel(9911403)==fid
end
function c9911403.thcon(e,tp,eg,ep,ev,re,r,rp)
	local laba,labb=e:GetLabel()
	local g=e:GetLabelObject()
	if not g:IsExists(c9911403.thfilter1,1,nil,laba) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9911403.thfilter2(c,fid)
	return c:GetFlagEffectLabel(9911403)==fid and c:IsAbleToHand()
end
function c9911403.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9911403)
	local laba,labb=e:GetLabel()
	local g=e:GetLabelObject()
	local tg=g:Filter(c9911403.thfilter2,nil,laba)
	g:DeleteGroup()
	if #tg>0 and labb>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=tg:Select(tp,1,labb,nil)
		Duel.HintSelection(sg)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c9911403.value1(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*150
end
function c9911403.value2(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*(-150)
end
