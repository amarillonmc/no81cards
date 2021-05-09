--DD询问
function c16200000.initial_effect(c)
	aux.AddCodeList(c,16200003)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16200000,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,16200000)
	e2:SetCondition(c16200000.tkcon)
	e2:SetTarget(c16200000.tktg)
	e2:SetOperation(c16200000.tkop)
	c:RegisterEffect(e2)
	--Tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16200000,1))
	e3:SetCategory(CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c16200000.thcost)
	e3:SetCountLimit(1,16200000+100)
	e3:SetTarget(c16200000.thtg)
	e3:SetOperation(c16200000.thop)
	c:RegisterEffect(e3)
	--GetControl
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16200000,2))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c16200000.chcost)
	e4:SetCountLimit(1,16200000+1001)
	e4:SetTarget(c16200000.chtg)
	e4:SetOperation(c16200000.chop)
	c:RegisterEffect(e4)
	--sum limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetTarget(c16200000.splimit)
	c:RegisterEffect(e5)
end
function c16200000.splimit(e,c,tp,sumtp,sumpos)
	return c:GetOriginalCode()~=16200003
end
function c16200000.cfilter(c,tp)
	return c:IsCode(16200003)
		and c:IsControler(tp) and c:IsReleasable()
end
function c16200000.tgfilter(c,e,tp)
	return aux.IsCodeListed(c,16200003) and c:IsAbleToHand()
end
function c16200000.cfilter1(c)
	return c:IsCode(16200003)
end
function c16200000.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c16200000.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c16200000.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,16200003,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK)
		end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c16200000.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,16200003,0,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) then
			local token=Duel.CreateToken(tp,16200003)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	Duel.SpecialSummonComplete()
end
function c16200000.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c16200000.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c16200000.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c16200000.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c16200000.cfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,c16200000.cfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c16200000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16200000.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c16200000.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c16200000.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c16200000.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16200000.chfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c16200000.chfilter(c)
	return c:IsControlerCanBeChanged()
end
function c16200000.chop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c16200000.chfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	Duel.GetControl(tc,tp,PHASE_END,1)
end