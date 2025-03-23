--黑森林·白森林
function c61701019.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCost(c61701019.excost)
	e0:SetDescription(aux.Stringid(61701019,0))
	c:RegisterEffect(e0)
	--act in set turn
	local e2=e0:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_DRAW_PHASE)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,61701019)
	e1:SetCost(c61701019.cost)
	e1:SetTarget(c61701019.target)
	e1:SetOperation(c61701019.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(1152)
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,61701020)
	e3:SetCondition(c61701019.spcon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c61701019.sptg)
	e3:SetOperation(c61701019.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c61701019.spcon2)
	c:RegisterEffect(e4)
end
function c61701019.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c61701019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c61701019.cfilter(c,chk)
	return (chk~=2 and (c:IsType(TYPE_TUNER) or c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK)) and c:IsLocation(LOCATION_HAND) or chk~=1 and not c:IsType(TYPE_TUNER) and c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToRemoveAsCost()
end
function c61701019.gcheck(sg,tp)
	return aux.gfcheck(sg,c61701019.cfilter,1,2)
		and Duel.IsExistingMatchingCard(c61701019.chkfilter,tp,LOCATION_EXTRA,0,1,nil,sg,tp)
end
function c61701019.chkfilter(c,g,tp)
	return c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c61701019.thfilter,tp,LOCATION_DECK,0,1,nil,g,c) and g:GetSum(Card.GetLevel)==c:GetLevel() and not g:IsContains(c) and c:IsType(TYPE_SYNCHRO)
end
function c61701019.thfilter(c,g,ec)
	return c:IsLevel(ec:GetLevel()) and c:IsAbleToHand() and (g:IsExists(Card.IsAttack,1,nil,c:GetAttack()) or g:IsExists(Card.IsDefense,1,nil,c:GetDefense()))
end
function c61701019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c61701019.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,0)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return g:CheckSubGroup(c61701019.gcheck,2,2,tp) end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c61701019.gcheck,false,2,2,tp)
	Duel.SetTargetCard(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c61701019.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(c61701019.splimit)
		Duel.RegisterEffect(e1,tp)
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	--confirm
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cc=Duel.SelectMatchingCard(tp,c61701019.chkfilter,tp,LOCATION_EXTRA,0,1,1,nil,g,tp):GetFirst()
	if not cc then return end
	Duel.ConfirmCards(1-tp,cc)
	--search
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c61701019.thfilter,tp,LOCATION_DECK,0,1,1,nil,g,cc):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c61701019.splimit(e,c)
	return c:IsType(TYPE_SYNCHRO) or c:IsRace(RACE_ILLUSION+RACE_SPELLCASTER)
end
function c61701019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsReason,1,nil,REASON_COST) and not eg:IsContains(e:GetHandler()) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
end
function c61701019.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsRace(RACE_WINDBEAST) and rc:IsAttribute(ATTRIBUTE_DARK) and rp==tp
end
function c61701019.tdfilter(c,e,tp)
	return c:IsType(TYPE_XYZ+TYPE_LINK) and c:IsFaceup() and c:IsAbleToExtra()
		and Duel.IsExistingMatchingCard(c61701019.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c61701019.spfilter(c,e,tp,tc)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (tc:IsType(TYPE_LINK) and c:IsRank(tc:GetLink()) or tc:IsType(TYPE_XYZ) and c:IsLink(tc:GetOverlayCount()+1)) and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c61701019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c61701019.tdfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c61701019.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c61701019.tdfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if Duel.SendtoDeck(tc,nil,SEQ_DECKTOP,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_EXTRA) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c61701019.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc):GetFirst()
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(61701019,1))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOperation(c61701019.regop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c61701019.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1,true)
end
