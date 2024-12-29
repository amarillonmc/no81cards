--魔棋的白兵卒
function c51931011.initial_effect(c)
	--activate cost
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_ACTIVATE_COST)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(0xff)
	e0:SetTargetRange(1,1)
	e0:SetTarget(c51931011.actarget)
	e0:SetCost(c51931011.costchk)
	e0:SetOperation(c51931011.costop)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51931011)
	e1:SetTarget(c51931011.sptg)
	e1:SetOperation(c51931011.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,51931011)
	e2:SetTarget(c51931011.drtg)
	e2:SetOperation(c51931011.drop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(51931011,ACTIVITY_SPSUMMON,c51931011.counterfilter)
end
function c51931011.counterfilter(c)
	return not (c:IsLevelAbove(1) and c:IsSummonLocation(LOCATION_EXTRA))
end
function c51931011.actarget(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function c51931011.costchk(e,te_or_c,tp)
	return Duel.GetCustomActivityCount(51931011,tp,ACTIVITY_SPSUMMON)==0
end
function c51931011.costop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c51931011.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51931011.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLevelAbove(1) and c:IsLocation(LOCATION_EXTRA)
end
function c51931011.tfilter(c,tp)
	local type1=c:GetType()&0x7
	return c:IsSetCard(0x6258) and c:IsFaceup() and Duel.IsExistingMatchingCard(c51931011.tgfilter,tp,LOCATION_DECK,0,1,nil,type1)
end
function c51931011.tgfilter(c,type1)
	return not c:IsType(type1) and c:IsSetCard(0x6258) and c:IsAbleToGrave()
end
function c51931011.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c51931011.tfilter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c51931011.tfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c51931011.tfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c51931011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c,tc=e:GetHandler(),Duel.GetFirstTarget()
	local type1=tc:GetType()&0x7
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tgc=Duel.SelectMatchingCard(tp,c51931011.tgfilter,tp,LOCATION_DECK,0,1,1,nil,type1):GetFirst()
		if tgc and Duel.SendtoGrave(tgc,REASON_EFFECT)~=0 and tgc:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c51931011.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c51931011.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
