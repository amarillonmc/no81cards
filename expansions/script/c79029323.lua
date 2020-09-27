--黑·瑟谣浮收藏-至极弓道
function c79029323.initial_effect(c)
	aux.AddCodeList(c,0xa906)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,2,c79029323.ovfilter,aux.Stringid(79029323,0))
	c:EnableReviveLimit()
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029030)
	c:RegisterEffect(e2) 
	--ov
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79029323.descon)
	e1:SetOperation(c79029323.op)
	c:RegisterEffect(e1)   
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c79029323.tgcost)
	e2:SetTarget(c79029323.tgtg)
	e2:SetOperation(c79029323.tgop)
	c:RegisterEffect(e2) 
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetCondition(c79029323.atkcon)
	e3:SetCost(c79029323.atkcost)
	e3:SetOperation(c79029323.atkop)
	c:RegisterEffect(e3)		 
end
function c79029323.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE) and c:IsType(TYPE_LINK)
end
function c79029323.fil(c)
	return c:IsSetCard(0xa906) and c:IsCanOverlay()
end
function c79029323.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.IsExistingMatchingCard(c79029323.fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
end
function c79029323.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c79029323.fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,99,nil)
	Duel.Overlay(e:GetHandler(),g)
end
function c79029323.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029323.tgfil(c,e,tp)
	return e:GetHandler():GetColumnGroup():IsContains(c)
end
function c79029323.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029323.tgfil,tp,0,LOCATION_ONFIELD,1,nil,e,tp) end
	local g=Duel.GetMatchingGroup(c79029323.tgfil,tp,0,LOCATION_ONFIELD,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),tp,0)
	Duel.SetChainLimit(c79029323.chlimit)
end
function c79029323.chlimit(e,ep,tp)
	return tp==ep
end
function c79029323.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RULE)
	Debug.Message("小姐有仁慈之心，我没有。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029323,3))
	if c:IsRelateToEffect(e) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(79029323,1)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	Duel.MoveSequence(c,nseq)
	Debug.Message("这个位置......不错。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029323,2))
	end
end
function c79029323.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetAttack()>0 and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,79029030)
end
function c79029323.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(79029323)==0 end
	c:RegisterFlagEffect(79029323,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c79029323.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsRelateToBattle() and c:IsFaceup() and bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(bc:GetAttack())
		c:RegisterEffect(e1)
	Debug.Message("才这点人。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029323,4))
	end
end














