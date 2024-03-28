--幽玄龙景＊荧惑守心
local cm,m=GetID()
function cm.initial_effect(c)
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--spirit return
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(cm.SpiritReturnReg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e3:SetCost(cm.sumcost)
	e3:SetTarget(cm.sumtg)
	e3:SetOperation(cm.sumop)
	c:RegisterEffect(e3)
	cm.hand_effect=e3
end
function cm.filter(c)
	return c:IsAbleToDeck() or c:IsAbleToHand()
end
function cm.SpiritReturnReg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c):GetFirst()
	if not tc then return end
	if tc:IsAbleToHand() and (not tc:IsAbleToDeck() or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0) then Duel.SendtoHand(tc,nil,REASON_RULE) else Duel.SendtoDeck(tc,nil,2,REASON_RULE) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(1104)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0xd6e0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(Auxiliary.SpiritReturnConditionForced)
	e1:SetTarget(Auxiliary.SpiritReturnTargetForced)
	e1:SetOperation(Auxiliary.SpiritReturnOperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCondition(Auxiliary.SpiritReturnConditionOptional)
	e2:SetTarget(Auxiliary.SpiritReturnTargetOptional)
	c:RegisterEffect(e2)
end
function cm.cpfilter(c,tp)
	return c:GetOriginalType()&TYPE_LINK==0 and Duel.IsExistingMatchingCard(cm.cpfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp,c)
end
function cm.cpfilter2(c,tp,tc)
	local fg=Group.CreateGroup()
	if c:IsFacedown() then fg:AddCard(tc) end
	if tc:IsFacedown() then fg:AddCard(c) end
	return c:GetOriginalType()&TYPE_LINK==0 and c:GetPosition()~=tc:GetPosition() and Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,fg) and not fg:IsExists(function(c) return c:IsFaceup() and not c:IsCanTurnSet() end,1,nil)
end
function cm.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc2=Duel.SelectMatchingCard(tp,cm.cpfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,tc):GetFirst()
	local pos=tc:GetPosition()
	Duel.ChangePosition(tc,tc2:GetPosition())
	Duel.ChangePosition(tc2,pos)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smfilter(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil)
		local s2=tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end