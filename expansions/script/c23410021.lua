--意外之喜
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,23410013)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+20000000)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=1
	if Duel.IsPlayerAffectedByEffect(tp,23410013) then
		--Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	local dnum=0
	if Duel.GetLP(1-tp)>=4000 then dnum=dnum+1 end
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)>=10 then dnum=dnum+1 end
	if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)<Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil) then dnum=dnum+1 end
	if chk==0 then return Duel.GetDecktopGroup(1-tp,num):FilterCount(Card.IsAbleToRemove,nil)==num and Duel.IsPlayerCanDraw(tp,dnum) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,num,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local num=1
	if Duel.IsPlayerAffectedByEffect(tp,23410013) then
		Duel.Hint(HINT_CARD,0,23410017)
		num=num+2
	end
	local dnum=0
	if Duel.GetLP(1-tp)>=4000 then dnum=dnum+1 end
	if Duel.GetMatchingGroupCount(Card.IsFacedown,tp,0,LOCATION_REMOVED,nil)>=10 then dnum=dnum+1 end
	if Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)<Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil) then dnum=dnum+1 end

	if Duel.GetDecktopGroup(1-tp,num):FilterCount(Card.IsAbleToRemove,nil)~=num then return end
	local g=Duel.GetDecktopGroup(1-tp,num)
	if Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)~=0 and Duel.Draw(tp,dnum,REASON_EFFECT)~=0 then
		local tnum=#Duel.GetOperatedGroup()
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,tnum,tnum,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end
function cm.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsCode(23410013) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end