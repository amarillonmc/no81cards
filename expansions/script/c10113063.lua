--决斗大师
function c10113063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,10113063+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c10113063.target)
	e1:SetOperation(c10113063.operation)
	c:RegisterEffect(e1)	
end
function c10113063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.Hint(HINT_CARD,0,ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c10113063.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac,c=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM),e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
		e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,ac))
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
		Duel.RegisterEffect(e2,tp)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_DISABLE_FLIP_SUMMON)
		Duel.RegisterEffect(e3,tp)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_CHAINING)
		e4:SetOperation(c10113063.chainop)
		e4:SetLabel(ac)
		Duel.RegisterEffect(e4,tp)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_PREDRAW)
		e5:SetOperation(c10113063.drop)
		e5:SetLabel(ac)
		Duel.RegisterEffect(e5,tp)
end
function c10113063.thfilter(c,code)
	return c:IsAbleToHand() and c:IsCode(code)
end
function c10113063.drop(e,tp,eg,ep,ev,re,r,rp)
	local dt=Duel.GetDrawCount(tp)
	if Duel.GetLP(1-tp)-Duel.GetLP(tp)>=3000 and Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,10113063)==0 and Duel.IsExistingMatchingCard(c10113063.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) and Duel.SelectYesNo(tp,aux.Stringid(10113063,0)) and dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_CARD,0,70903634)
		Duel.Hint(HINT_CARD,0,7902349)
		Duel.Hint(HINT_CARD,0,8124921)
		Duel.Hint(HINT_CARD,0,44519536)
		Duel.Hint(HINT_CARD,0,4392470)
		local tc=Duel.GetFirstMatchingCard(c10113063.thfilter,tp,LOCATION_DECK,0,nil,e:GetLabel())
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(10113063,2))
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(10113063,1))
		Duel.RegisterFlagEffect(tp,10113063,0,0,0)
	end
end
function c10113063.chainlm(e,rp,tp)
	return tp==rp
end
function c10113063.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsCode(e:GetLabel()) then
		Duel.SetChainLimit(c10113063.chainlm)
	end
end