--将军带领你们走向胜利！
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,65133150,65133153)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCost(s.cost)
	c:RegisterEffect(e2)
end
function s.costfilter(c)
	return c:IsSetCard(0x838) or c:IsRace(RACE_MACHINE)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,s.costfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function s.cfilter(c)
	return c:IsSetCard(0x838) and c:IsFaceup()
end
function s.cfilter2(c)
	return c:IsCode(65133150) and c:IsFaceup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b={}
	b[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,65133153,0x838,TYPES_TOKEN,2500,500,6,RACE_MACHINE,ATTRIBUTE_LIGHT)
	b[2]=Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil)
	b[3]=true
	b[4]=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	b[5]=true 
	if chk==0 then return true end	
	local ct=1
	if Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil) then
		ct=3
	end
	local num=0
	local optable=0
	while num<ct do
		local op=aux.SelectFromOptions(tp,
			{b[1],aux.Stringid(id,2)},
			{b[2],aux.Stringid(id,3)},
			{b[3],aux.Stringid(id,4)},
			{b[4],aux.Stringid(id,5)},
			{b[5],aux.Stringid(id,6)})
		if op then
			b[op]=false
			num=num+1
			optable=optable+2^op
			if op==1 then
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
			elseif op==2 then
				Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_REMOVED)
			elseif op==4 then
				Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
			end
		end
		if not (b[1] or b[2] or b[3] or b[4] or b[5]) or num==ct or not Duel.SelectYesNo(tp,aux.Stringid(id,7)) then
			break
		end
	end
	e:SetLabel(optable)
end
function s.thfilter1(c)
	return c:IsCode(65133150) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(s.thfilter2,c:GetControler(),LOCATION_DECK+LOCATION_REMOVED,0,1,c) and c:IsFaceupEx()
end
function s.thfilter2(c)
	return c:IsSetCard(0x838) and c:IsAbleToHand() and c:IsFaceupEx()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local optable=e:GetLabel()
	for i=1,5 do
		if optable&2^i>0 then
			if i==1 then
			if Duel.IsPlayerCanSpecialSummonMonster(tp,65133153,0x838,TYPES_TOKEN,2500,500,6,RACE_MACHINE,ATTRIBUTE_LIGHT) then
				local token1=Duel.CreateToken(tp,65133153)
				local token2=Duel.CreateToken(tp,65133153)
				Duel.SpecialSummon(Group.FromCards(token1,token2),0,tp,tp,false,false,POS_FACEUP)
			end
			elseif i==2 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter1),tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
				if #g1>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
					local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter2),tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,g1)
					g1:Merge(g2)
					Duel.SendtoHand(g1,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g1)
				end
			elseif i==3 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
				e1:SetTargetRange(LOCATION_MZONE,0)
				e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x838))
				e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			elseif i==4 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if #g>0 then
					Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
				end
			elseif i==5 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetCondition(s.setcon)
				e1:SetOperation(s.setop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.setfilter_recycle(c)
	return c:IsCode(id) and c:IsSSetable()
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter_recycle),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
