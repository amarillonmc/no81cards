local m=31407016
local cm=_G["c"..m]
cm.name="睿智龙 空间切裂"
if not pcall(function() require("expansions/script/c31407000") end) then require("expansions/script/c31407000") end
function cm.initial_effect(c)
	Seine_Metafor.Syn_Big_Proc(c,1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(cm.immcon)
	e2:SetValue(cm.efilter)
	c:RegisterEffect(e2)
end
function cm.immcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function cm.efilter(e,te)
	return e:GetOwnerPlayer()~=te:GetOwnerPlayer()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,1-tp,0,LOCATION_HAND,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		local num=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(1-tp)
		if num>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
			local tc=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
			if tc and Duel.SendtoDeck(tc,1-tp,SEQ_DECKTOP,REASON_EFFECT) then
				tc:ReverseInDeck()
			end
		end
	end
end