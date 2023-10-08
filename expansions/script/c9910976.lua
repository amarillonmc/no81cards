--永夏的消逝
function c9910976.initial_effect(c)
	c:SetUniqueOnField(1,0,9910976)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910976,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(c9910976.thcon)
	e2:SetTarget(c9910976.thtg)
	e2:SetOperation(c9910976.thop)
	c:RegisterEffect(e2)
	--change effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c9910976.chcon)
	e3:SetOperation(c9910976.chop)
	c:RegisterEffect(e3)
	--turn skip
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9910976,1))
	e4:SetCategory(CATEGORY_TOEXTRA)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c9910976.skipcon)
	e4:SetTarget(c9910976.skiptg)
	e4:SetOperation(c9910976.skipop)
	c:RegisterEffect(e4)
	if not c9910976.global_check then
		c9910976.global_check=true
		c9910976[0]=0
		c9910976[1]=0
		c9910976[2]=0
		c9910976[3]=0
		c9910976[4]=0
		c9910976[5]=0
		c9910976[6]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c9910976.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c9910976.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9910976.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW and c9910976[0]==0 then
		c9910976[0]=1
		c9910976[6]=c9910976[6]+1
	elseif Duel.GetCurrentPhase()==PHASE_STANDBY and c9910976[1]==0 then
		c9910976[1]=1
		c9910976[6]=c9910976[6]+1
	elseif Duel.GetCurrentPhase()==PHASE_MAIN1 and c9910976[2]==0 then
		c9910976[2]=1
		c9910976[6]=c9910976[6]+1
	elseif Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<PHASE_BATTLE and c9910976[3]==0 then
		c9910976[3]=1
		c9910976[6]=c9910976[6]+1
	elseif Duel.GetCurrentPhase()==PHASE_MAIN2 and c9910976[4]==0 then
		c9910976[4]=1
		c9910976[6]=c9910976[6]+1
	elseif Duel.GetCurrentPhase()==PHASE_END and c9910976[5]==0 then
		c9910976[5]=1
		c9910976[6]=c9910976[6]+1
	end
end
function c9910976.clearop(e,tp,eg,ep,ev,re,r,rp)
	c9910976[0]=0
	c9910976[1]=0
	c9910976[2]=0
	c9910976[3]=0
	c9910976[4]=0
	c9910976[5]=0
	c9910976[6]=0
end
function c9910976.thcon(e,tp,eg,ep,ev,re,r,rp)
	return c9910976[6]>=1
end
function c9910976.thfilter1(c,xg)
	return c:IsFaceup() and c:IsSetCard(0x5954) and c:IsAbleToHand()
		and Duel.IsExistingTarget(Card.IsAbleToHand,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,xg)
end
function c9910976.thfilter2(c,xg)
	return c~=xg and c:IsAbleToHand()
end
function c9910976.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local xg=nil
	if not e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) then xg=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c9910976.thfilter1,tp,LOCATION_MZONE,0,1,xg,xg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g1=Duel.SelectTarget(tp,c9910976.thfilter1,tp,LOCATION_MZONE,0,1,1,xg,xg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g2=Duel.SelectTarget(tp,c9910976.thfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1:GetFirst(),xg)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c9910976.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c9910976.lvfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(4)
end
function c9910976.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and c9910976[6]>=3
		and Duel.IsExistingMatchingCard(c9910976.lvfilter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():GetFlagEffect(9910976)<=0
end
function c9910976.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,c) then
		c:RegisterFlagEffect(9910976,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		return Duel.ChangeChainOperation(ev,c9910976.repop)
	end
end
function c9910976.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910976)
	local g=Duel.GetMatchingGroup(c9910976.lvfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetLevel)
		local tc
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=tg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			tc=sg:GetFirst()
		else
			Duel.HintSelection(tg)
			tc=tg:GetFirst()
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if tc:IsCanAddCounter(0x6954,1) and Duel.SelectYesNo(1-tp,aux.Stringid(9910976,3)) then
			tc:AddCounter(0x6954,1)
		end
	end
end
function c9910976.skipcon(e,tp,eg,ep,ev,re,r,rp)
	return c9910976[6]>=6
end
function c9910976.skiptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_MZONE)
end
function c9910976.exfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtra()
end
function c9910976.skipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9910976.exfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_EXTRA) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		local rct=1
		if Duel.GetTurnPlayer()==1-tp then rct=2 end
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,rct)
		Duel.RegisterEffect(e1,tp)
	end
end
