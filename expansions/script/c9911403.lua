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
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetOperation(c9911403.atkop)
	c:RegisterEffect(e2)
	if c9911403.counter==nil then
		c9911403.counter=true
		c9911403[0]=0
		c9911403[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c9911403.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_RELEASE)
		e3:SetOperation(c9911403.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c9911403.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c9911403[0]=0
	c9911403[1]=0
end
function c9911403.cfilter(c,tp)
	return c:GetFlagEffectLabel(9911404) and c:GetFlagEffectLabel(9911404)>0 and c:GetSummonPlayer()==tp
end
function c9911403.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsPreviousLocation(LOCATION_MZONE) or (tc:IsPreviousLocation(LOCATION_HAND) and tc:IsType(TYPE_MONSTER)) then
			local p=tc:GetPreviousControler()
			local sc=Duel.GetMatchingGroup(c9911403.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,p):GetFirst()
			if sc then
				local flag=sc:GetFlagEffectLabel(9911404)
				if c9911403[p]<flag then c9911403[p]=c9911403[p]+1 end
				sc:SetFlagEffectLabel(9911404,flag+1)
			end
		end
		tc=eg:GetNext()
	end
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
			c:RegisterFlagEffect(9911404,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
			g:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetLabel(e:GetLabel())
			e1:SetLabelObject(g)
			e1:SetCondition(c9911403.thcon)
			e1:SetOperation(c9911403.thop)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c9911403.thfilter(c,fid)
	return c:GetFlagEffectLabel(9911403)==fid and c:IsAbleToHand()
end
function c9911403.thcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c9911403.thfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c9911403.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c9911403.thfilter,nil,e:GetLabel())
	g:DeleteGroup()
	if #sg>0 and c9911403[tp]>=3 then
		Duel.Hint(HINT_CARD,0,9911403)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c9911403.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c9911403.value1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c9911403.value2)
	Duel.RegisterEffect(e2,tp)
end
function c9911403.value1(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*200
end
function c9911403.value2(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFacedown,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*(-200)
end
