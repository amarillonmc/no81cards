--幻殇·双子·光暗之龙
function c11180032.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,c11180032.sfilter1,aux.NonTuner(c11180032.sfilter2),5)
	c:EnableReviveLimit()
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,11180032+EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(c11180032.sprcon)
	e0:SetTarget(c11180032.sprtg)
	e0:SetOperation(c11180032.sprop)
	c:RegisterEffect(e0)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c11180032.lpcon1)
	e1:SetOperation(c11180032.lpop1)
	c:RegisterEffect(e1)
	--sp_summon effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c11180032.regcon)
	e2:SetOperation(c11180032.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11180032.lpcon2)
	e3:SetOperation(c11180032.lpop2)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,11180032+3000)
	e4:SetCondition(c11180032.spcon)
	e4:SetTarget(c11180032.sptg)
	e4:SetOperation(c11180032.spop)
	c:RegisterEffect(e4)
end
function c11180032.sfilter1(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSynchroType(TYPE_SYNCHRO)
end
function c11180032.sfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSynchroType(TYPE_SYNCHRO)
end
function c11180032.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3450,0x6450) and c:IsAbleToDeckAsCost()
end
function c11180032.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11180032.sprfilter,tp,LOCATION_REMOVED,0,2,nil)
end
function c11180032.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c11180032.sprfilter,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:CancelableSelect(tp,2,2,nil)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c11180032.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c11180032.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetOwner():IsSetCard(0x3450,0x6450)
end
function c11180032.spfilter(c,e,tp)
	local b1=c:IsSetCard(0x3450) and c:IsType(TYPE_MONSTER) and c:IsFaceupEx()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (not c:IsLocation(LOCATION_EXTRA) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
	local b2=c:IsSetCard(0x3450,0x6450) and c:IsType(0x6) and c:IsFaceupEx() and c:IsAbleToHand()
	return b1 or b2
end
function c11180032.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11180032.spfilter,tp,0x70,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x70)
end
function c11180032.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c11180032.spfilter),tp,0x70,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc:IsType(0x1) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		elseif tc:IsType(0x6) then
			Duel.SendtoHand(tc,nil,0x40)
		end
	end
end
function c11180032.cfilter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsFaceup()
end
function c11180032.lpcon1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c11180032.cfilter,1,nil,1-tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and not Duel.IsChainSolving()
end
function c11180032.lpop1(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c11180032.cfilter,nil,1-tp)
	local rnum=lg:GetSum(Card.GetAttack)+lg:GetSum(Card.GetDefense)
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
end
function c11180032.regcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return eg:IsExists(c11180032.cfilter,1,nil,1-tp)
		and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and Duel.IsChainSolving()
end
function c11180032.regop(e,tp,eg,ep,ev,re,r,rp)
	local lg=eg:Filter(c11180032.cfilter,nil,1-tp)
	local g=e:GetLabelObject()
	if g==nil or #g==0 then
		lg:KeepAlive()
		e:SetLabelObject(lg)
	else
		g:Merge(lg)
	end
	Duel.RegisterFlagEffect(tp,60643554,RESET_CHAIN,0,1)
end
function c11180032.lpcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,60643554)>0
end
function c11180032.lpop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,60643554)
	local lg=e:GetLabelObject():GetLabelObject()
	lg=lg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	local rnum=lg:GetSum(Card.GetAttack)+lg:GetSum(Card.GetDefense)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e:GetLabelObject():SetLabelObject(g)
	lg:DeleteGroup()
	if Duel.Recover(tp,rnum,REASON_EFFECT)<1 then return end
end