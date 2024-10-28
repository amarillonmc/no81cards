--岭岩圣所
function c9911675.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c9911675.chainop)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,9911674)
	e3:SetCost(c9911675.thcost)
	e3:SetTarget(c9911675.thtg)
	e3:SetOperation(c9911675.thop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,9911675)
	e4:SetTarget(c9911675.reptg)
	e4:SetValue(c9911675.repval)
	e4:SetOperation(c9911675.repop)
	c:RegisterEffect(e4)
end
function c9911675.chainop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimit(c9911675.chainlm)
end
function c9911675.lmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5957) and c:GetSequence()<5
end
function c9911675.chainlm(e,rp,tp)
	return tp==rp or not Duel.IsExistingMatchingCard(c9911675.lmfilter,rp,LOCATION_SZONE,0,1,nil)
end
function c9911675.costfilter(c)
	return c:IsSetCard(0x5957) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c9911675.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,c9911675.costfilter,1,REASON_COST,true,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c9911675.costfilter,1,1,REASON_COST,true,nil)
	Duel.Release(g,REASON_COST)
end
function c9911675.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
		and Duel.GetDecktopGroup(tp,3):FilterCount(Card.IsAbleToHand,nil)>0 end
	Duel.SetTargetPlayer(tp)
end
function c9911675.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c9911675.thop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	local tg=g:Filter(c9911675.thfilter,nil)
	if #tg>0 and Duel.SelectYesNo(p,aux.Stringid(9911675,0)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=tg:Select(p,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-p,sg)
	end
	Duel.ShuffleDeck(p)
end
function c9911675.dfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and not c:IsReason(REASON_REPLACE)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c9911675.repfilter(c)
	return c:IsLevel(3) and c:IsAbleToGrave()
end
function c9911675.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c9911675.dfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c9911675.repfilter,tp,LOCATION_DECK,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c9911675.repval(e,c)
	return c9911675.dfilter(c,e:GetHandlerPlayer())
end
function c9911675.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9911675.repfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_CARD,0,9911675)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_REPLACE)
end
