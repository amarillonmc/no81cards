--嗔怒的爆热冲击弹
local s,id,o=GetID()
function s.initial_effect(c)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e5:SetCondition(s.condition)
	e5:SetTarget(s.rtg)
	e5:SetOperation(s.rop)
	c:RegisterEffect(e5)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(89490004)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) and #g>0 and g:GetFirst():IsAbleToRemove(tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
end
function s.rop(e,tp,eg,ep,ev,re,r,rp)
	local type=1<<e:GetLabel()
	local res=0
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil))
		local sg=g:Filter(Card.IsType,nil,type)
		res=Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	if res>0 then Duel.BreakEffect() end
	local g0=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g0)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:Filter(Card.IsType,nil,type)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
	if res>0 then Duel.BreakEffect() end
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if ct>5 then ct=5 end
	if ct>1 then
		local tbl={}
		for i=1,ct do
			table.insert(tbl,i)
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(94392192,3))
		ct=Duel.AnnounceNumber(tp,table.unpack(tbl))
	end
	Duel.ConfirmDecktop(1-tp,ct)
	local g=Duel.GetDecktopGroup(1-tp,ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.RevealSelectDeckSequence(true)
	local sg=g:Filter(Card.IsType,nil,type)
	Duel.RevealSelectDeckSequence(false)
	if #sg>0 then
		Duel.DisableShuffleCheck(true)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
