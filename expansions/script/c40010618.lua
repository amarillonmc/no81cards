--魔宝龙 道拉珠艾尔德
local m=40010618
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,40010618)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,40010618,aux.FilterBoolFunction(Card.IsAttack,100),1,true,true)
	--discard deck & draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,m+1)
	e2:SetCost(cm.atkcost)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)	
	--act limit & def position
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(cm.actg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_TRIGGER)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function cm.dcfilter(c)
	return c:IsLevelAbove(1) and c:IsLocation(LOCATION_GRAVE)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	--local ct=g:FilterCount(cm.dcfilter,nil)
		--g:GetClassCount(Card.GetLevel)>=2
	if g:GetClassCount(Card.GetLevel)>=2 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost()
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetLevel)>=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=g:SelectSubGroup(tp,aux.dlvcheck,false,4,4)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:GetAttack()~=100
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.atkfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function cm.c2filter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(cm.atkfilter,tp,0,LOCATION_MZONE,nil)
	local tc1=g1:GetFirst()
	while tc1 do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(100)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1)
		tc1=g1:GetNext()
		if Duel.IsExistingMatchingCard(cm.c2filter,tp,0,LOCATION_MZONE,1,nil) then
			Duel.BreakEffect()
			local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			local tc2=g2:GetFirst()
			local atk=0
			while tc2 do
				local batk=tc2:GetBaseAttack()
				local catk=tc2:GetAttack()
				atk=math.abs(catk-batk)+atk
				tc2=g2:GetNext()
			end
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
function cm.actg(e,c)
	return c:IsFaceup() and c:GetAttack()==100
end