--龙门·特种干员-雪雉
function c79029115.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit()
	--to extra
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(c79029115.lztg)
	e1:SetOperation(c79029115.lzop)
	e1:SetCondition(c79029115.condition)
	e1:SetCountLimit(1,79029115)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE+LOCATION_OVERLAY)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c79029115.target)
	c:RegisterEffect(e2) 
	local e3=e2:Clone()
	e3:SetCode(EFFECT_DISABLE_EFFECT)  
	c:RegisterEffect(e3)   
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e5) 
	--draw and to deck
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(56209279,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c79029115.spcon)
	e6:SetTarget(c79029115.sptg)
	e6:SetOperation(c79029115.spop)
	c:RegisterEffect(e6)  
end
function c79029115.target(e,c)
	return c:IsRace(RACE_INSECT) or c:IsRace(RACE_REPTILE)
end
function c79029115.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0)
	and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c79029115.drfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c79029115.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_EXTRA)
end
function c79029115.lzop(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c79029115.drfilter,tp,0,LOCATION_EXTRA,1,nil)
	local a=g:RandomSelect(tp,1)
	Duel.Remove(a,POS_FACEDOWN,REASON_EFFECT)
	Duel.SendtoDeck(a,tp,2,REASON_EFFECT)
	e:GetHandler():RegisterFlagEffect(79029115,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c79029115.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not e:GetHandler():IsDisabled() and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c79029115.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,4) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(4)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,4)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,3)
end
function c79029115.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==4 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
		if g:GetCount()==0 then return end
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(p,3,3,nil)
		Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		Duel.SortDecktop(p,p,3)
		for i=1,3 do
			local mg=Duel.GetDecktopGroup(p,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
	end
end











