--凝神之光羽 远牙
function c76029000.initial_effect(c)
	--to grave 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,76029000)
	e1:SetCost(c76029000.tgcost)
	e1:SetTarget(c76029000.tgtg)
	e1:SetOperation(c76029000.tgop)
	c:RegisterEffect(e1)
	--to hand and summon 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,16029000) 
	e2:SetCondition(c76029000.thscon)
	e2:SetCost(c76029000.thscost)
	e2:SetTarget(c76029000.thstg)
	e2:SetOperation(c76029000.thsop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,16029000) 
	e3:SetCost(c76029000.thscost)
	e3:SetTarget(c76029000.thstg)
	e3:SetOperation(c76029000.thsop)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
end
function c76029000.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c76029000.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c76029000.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetLabelObject(tc)
	e1:SetCondition(c76029000.xtgcon)
	e1:SetOperation(c76029000.xtgop)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029002,3))
	Debug.Message("“远牙”查丝汀娜，由我来做你们的对手。")
	end 
end
function c76029000.xtgcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetLabelObject() and e:GetLabelObject():IsAbleToGrave()
end
function c76029000.xtgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029002,4))
	Debug.Message("瞄准你了。")
	Duel.Hint(HINT_CARD,0,76029000)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
	e:Reset()
end
function c76029000.thscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c76029000.thscost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.CheckLPCost(tp,1500) end 
	Duel.PayLPCost(tp,1500) 
end
function c76029000.thstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c76029000.sumfilter(c)
	return c:IsSummonable(true,nil) and (c:IsRace(RACE_WINDBEAST) or c:IsRace(RACE_BEASTWARRIOR))
end
function c76029000.thsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029002,5))
	Debug.Message("嗯。随时能上。")
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND)
		and Duel.IsExistingMatchingCard(c76029000.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(76029000,2)) then
		Duel.BreakEffect()
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SOUND,0,aux.Stringid(76029002,6))
		Debug.Message("整装。列队。......出发！")
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sg=Duel.SelectMatchingCard(tp,c76029000.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Summon(tp,sg:GetFirst(),true,nil)
		end
	end
end







