--纸影剧团 掠食螳螂
local s,id=GetID()
function s.initial_effect(c)
	--相同纵列有对方卡存在时，盖放回合也能发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetCondition(s.actcon)
	c:RegisterEffect(e0)
	--①：变成陷阱怪兽并使「纸影剧」怪兽攻击力上升
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--②：丢弃并从卡组盖放「纸影剧」卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
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
s.listed_series={0x6328}
function s.columnfilter(c,p)
	return c:IsControler(p)
end
function s.getopponentcolumn(c)
	local tp=c:GetControler()
	return c:GetColumnGroup():Filter(s.columnfilter,nil,1-tp)
end
function s.actcon(e)
	return #s.getopponentcolumn(e:GetHandler())>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT|TYPE_TRAP,1800,0,4,RACE_INSECT,ATTRIBUTE_WIND) end
	local dg=s.getopponentcolumn(c)
	if #dg>0 then
		dg:KeepAlive()
		e:SetLabelObject(dg)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,#dg,1-tp,LOCATION_ONFIELD)
	else
		e:SetLabelObject(nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_SZONE)
end
function s.atkfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x6328)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=e:GetLabelObject()
	e:SetLabelObject(nil)
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER|TYPE_EFFECT|TYPE_TRAP,1800,0,4,RACE_INSECT,ATTRIBUTE_WIND) then
		if dg then
			dg:DeleteGroup()
		end
		return
	end
	c:AddMonsterAttribute(TYPE_EFFECT|TYPE_TRAP,ATTRIBUTE_WIND,RACE_INSECT,4,1800,0)
	if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)==0 then
		if dg then
			dg:DeleteGroup()
		end
		return
	end
	Duel.SpecialSummonComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atkfilter)
	e1:SetValue(1000)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	if dg then
		local g=dg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Destroy(g,REASON_EFFECT)
		end
		dg:DeleteGroup()
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
function s.setfilter(c)
	return c:IsSetCard(0x6328) and not c:IsCode(id) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end