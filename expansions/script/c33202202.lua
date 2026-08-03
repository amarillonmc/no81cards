--纸影剧团 冰海狂鲨
local s,id=GetID()
function s.initial_effect(c)
	--相同纵列有对方卡存在时，盖放回合也能发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetCondition(s.setcon0)
	c:RegisterEffect(e0)
	--①：把对方场上的卡盖放并变成陷阱怪兽
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--②：从手卡丢弃并盖放手卡的「纸影剧」
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCondition(s.setcon)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.columnfilter(c,p)
	return c:IsControler(p)
end
function s.hasopponentcolumn(c)
	local tp=c:GetControler()
	return c:GetColumnGroup():IsExists(s.columnfilter,1,nil,1-tp)
end
function s.colfilter(c,tc)
	return c~=tc
end
function s.setcon0(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:GetColumnGroup():IsExists(s.colfilter,1,nil,c)
end
function s.turnsetfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.turnset(c)
	if c:IsLocation(LOCATION_MZONE) then
		return Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)>0
	end
	return Duel.ChangePosition(c,POS_FACEDOWN)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT|TYPE_TRAP,1500,1000,4,RACE_FISH,ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(s.turnsetfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	e:SetLabel(s.hasopponentcolumn(c) and 1 or 0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_SZONE)
end
function s.ownsetfilter(c,sc)
	return c~=sc and c:IsFaceup() and c:IsSetCard(0x6328) and c:IsType(TYPE_MONSTER) and c:IsCanTurnSet()
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,s.turnsetfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if not tc or not s.turnset(tc) then return end
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT|TYPE_TRAP,1500,1000,4,RACE_FISH,ATTRIBUTE_WATER) then return end
	c:AddMonsterAttribute(TYPE_EFFECT|TYPE_TRAP,ATTRIBUTE_WATER,RACE_FISH,4,1500,1000)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	if e:GetLabel()~=1 or not Duel.IsExistingMatchingCard(s.ownsetfilter,tp,LOCATION_MZONE,0,1,c,c) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then return end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sg=Duel.SelectMatchingCard(tp,s.ownsetfilter,tp,LOCATION_MZONE,0,1,1,c,c)
	local sc=sg:GetFirst()
	if sc then
		s.turnset(sc)
	end
end
function s.setcon(e,tp)
	return Duel.GetTurnPlayer()~=tp
end
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST|REASON_DISCARD)
end
function s.handsetfilter(c)
	return c:IsSetCard(0x6328) and not c:IsCode(id) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.handsetfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.handsetfilter,tp,LOCATION_HAND,0,1,1,nil)
	if #g>0 and Duel.SSet(tp,g)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end