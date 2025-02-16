--天塌地陷紫金锤
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,TYPE_MONSTER) or Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK+LOCATION_EXTRA,1,nil) or Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local ct=0
	local dg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local tg=g:GetMaxGroup(Card.GetAttack)
	if tg and #tg>0 then ct=ct+1 dg:Merge(tg) end
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tg2=g2:GetMaxGroup(Card.GetAttack)
	if tg2 and #tg2>0 then ct=ct+1 dg:Merge(tg2) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,ct,PLAYER_ALL,LOCATION_MZONE+LOCATION_DECK+LOCATION_EXTRA)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for p=tp,1-tp,1-2*tp do
		local g=Duel.GetMatchingGroup(Card.IsType,p,LOCATION_DECK,0,nil,TYPE_MONSTER)
		if #g>0 then
			local tg=g:GetMaxGroup(Card.GetAttack)
			if #tg>1 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
				local sg=tg:Select(p,1,1,nil)
				Duel.ConfirmCards(1-p,sg)
				dg:Merge(sg)
			else
				Duel.ConfirmCards(1-p,tg)
				dg:Merge(tg)
			end
		end
		local g=Duel.GetMatchingGroup(Card.IsType,p,LOCATION_EXTRA,0,nil,TYPE_MONSTER)
		if #g>0 then
			local tg=g:GetMaxGroup(Card.GetAttack)
			if #tg>1 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
				local sg=tg:Select(p,1,1,nil)
				Duel.ConfirmCards(1-p,sg)
				dg:Merge(sg)
			else
				Duel.ConfirmCards(1-p,tg)
				dg:Merge(tg)
			end
		end
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		if #g>0 then
			local tg=g:GetMaxGroup(Card.GetAttack)
			if #tg>1 then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DESTROY)
				local sg=tg:Select(p,1,1,nil)
				Duel.HintSelection(sg)
				dg:Merge(sg)
			else
				Duel.HintSelection(tg)
				dg:Merge(tg)
			end
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end