--神会掷骰子吗
function c49966681.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TOSS_DICE_NEGATE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c49966681.diceop)
	c:RegisterEffect(e2)
	 local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49966681,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c49966681.spcon)
	e4:SetTarget(c49966681.sptg)
	e4:SetOperation(c49966681.spop)
	c:RegisterEffect(e4)
end
function c49966681.diceop(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
	if c49966681[0]~=cid and Duel.SelectYesNo(tp,aux.Stringid(49966681,0)) then
		Duel.Hint(HINT_CARD,0,49966681)
		local dc={Duel.GetDiceResult()}
		local ac=1
		local ct=bit.band(ev,0xff)+bit.rshift(ev,16)
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(49966681,1))
			local val,idx=Duel.AnnounceNumber(tp,table.unpack(dc,1,ct))
			ac=idx+1
		end
		if dc[ac]==1 then dc[ac]=2 elseif dc[ac]==2 then dc[ac]=3 elseif dc[ac]==3 then dc[ac]=4
		elseif dc[ac]==4 then dc[ac]=5  elseif dc[ac]==5 then dc[ac]=6 end
		Duel.SetDiceResult(table.unpack(dc))
		c49966681[0]=cid
	end
end
function c49966681.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP)
end
function c49966681.spfilter(c,e,tp)
	return c.toss_dice and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49966681.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49966681.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c49966681.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c49966681.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end