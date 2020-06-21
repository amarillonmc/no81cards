--光之国·杰斯提斯
function c9950787.initial_effect(c)
	 --special summon (self)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950787,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9950787)
	e2:SetCost(c9950787.cost)
	e2:SetTarget(c9950787.sptg)
	e2:SetOperation(c9950787.spop)
	c:RegisterEffect(e2)
 --atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950787,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9950787.atkcon)
	e2:SetCost(c9950787.atkcost)
	e2:SetOperation(c9950787.atkop)
	c:RegisterEffect(e2)
 --search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950787,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c9950787.srcon)
	e3:SetTarget(c9950787.srtg)
	e3:SetOperation(c9950787.srop)
	c:RegisterEffect(e3)
--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950787.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950787.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUUND,0,aux.Stringid(9950787,0))
end
function c9950787.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c9950787.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950787.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Destroy(tp,c9950787.cfilter,1,1,REASON_COST+REASON_DESTROY,e:GetHandler())
end
function c9950787.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9950787.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c9950787.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()
		and (Duel.GetAttacker():IsControler(tp) and Duel.GetAttacker():IsRace(RACE_WARRIOR)
		or Duel.GetAttackTarget():IsControler(tp) and Duel.GetAttackTarget():IsRace(RACE_WARRIOR))
end
function c9950787.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(9950787)==0
		and Duel.CheckLPCost(tp,100) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,4000)/100)
	local t={}
	for i=1,m do
		t[i]=i*100
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
	e:GetHandler():RegisterFlagEffect(9950787,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c9950787.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttacker()
	if c:IsControler(1-tp) then c=Duel.GetAttackTarget() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(e:GetLabel())
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950787,1))
end
function c9950787.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c9950787.srfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9bd1) and c:IsAbleToHand()
end
function c9950787.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950787.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950787.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950787.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
