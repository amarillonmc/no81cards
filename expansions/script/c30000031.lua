--终焉邪魂 恶邪女
function c30000031.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c30000031.lcheck)
	c:EnableReviveLimit()
	--link module
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000031,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c30000031.cost)
	e1:SetCountLimit(1)
	e1:SetCondition(c30000031.spcon1)
	e1:SetTarget(c30000031.lktg)
	e1:SetOperation(c30000031.lkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c30000031.spcon2)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c30000031.indcon)
	e3:SetOperation(c30000031.indop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,30000032)
	e4:SetTarget(c30000031.tg3)
	e4:SetOperation(c30000031.op3)
	c:RegisterEffect(e4)
end

function c30000031.lcheck(g)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_DARK)
end

function c30000031.tg3fil(c)
	return c:IsAbleToHand() and c:IsSetCard(0x920) and c:IsFaceup() and not c:IsCode(30000031)
end
function c30000031.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ba=Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0
	if chk==0 then return Duel.IsExistingMatchingCard(c30000031.tg3fil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and (Duel.IsPlayerCanDraw(tp) or not ba) end
	local m=0
	if ba then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		m=1
	else
		e:SetCategory(CATEGORY_TOHAND)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_REMOVED)
	e:SetLabel(m)
end

function c30000031.op3(e,tp,eg,ep,ev,re,r,rp)
	local m=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,c30000031.tg3fil,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local code=tc:GetCode()
		if Duel.SendtoHand(g,tp,REASON_EFFECT)~=0 then
		   Duel.ConfirmCards(1-tp,g)
			if m==1 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
end
end

function c30000031.filter2(c)
	return  c:IsAbleToRemoveAsCost() and not c:IsCode(30000031)
end

function c30000031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000031.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000031.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c30000031.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,30000010)
end
function c30000031.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,30000010)
end

function c30000031.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c30000031.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end

function c30000031.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK and e:GetHandler():GetReasonCard():IsAttribute(ATTRIBUTE_DARK)
end
function c30000031.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(30000031,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetOwnerPlayer(tp)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end