--幻叙的噤默 罗兰
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e0=e2:Clone()
	e0:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e0)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end

function s.thfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsFaceupEx()
end
function s.atkval(e)
	return Duel.GetMatchingGroupCount(s.thfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)*500
end


function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	local count=0
	--[[if g then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:Select(tp,0,math.min(g:GetCount(),8),nil)
		count=Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end]]
	
	local ac=Duel.CreateToken(tp,65806050)
	Duel.SendtoExtraP(ac,tp,REASON_RULE)
	Duel.ConfirmCards(1-tp,ac)
	if ac:GetOriginalCode() then
		ac:SetEntityCode(ac:GetOriginalCode(),true)
		ac:ReplaceEffect(ac:GetOriginalCode(),0,0)
	end
	
	local g1=Group.CreateGroup()
	local tc=nil
	for i=65806005,65806045,5 do
		--Duel.Hint(HINT_CARD,0,i)
		tc=Duel.CreateToken(tp,i)
		if tc then
			g1:Merge(Group.FromCards(tc))
		end
	end
	Duel.Remove(g1,POS_FACEDOWN,REASON_RULE)
	Duel.ConfirmCards(1-tp,g1)
	local tc1=g1:GetFirst()
	while tc1 do 
		if tc1:GetOriginalCode() then
			tc1:SetEntityCode(tc1:GetOriginalCode(),true)
			tc1:ReplaceEffect(tc1:GetOriginalCode(),0,0)
		end
		tc1=g1:GetNext()
	end
	local g2=g1:RandomSelect(tp,count+1)
	g1:Sub(g2)
	Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_RULE)
	Duel.ShuffleDeck(tp)
	Duel.SendtoHand(g2,tp,REASON_RULE)
	Duel.ConfirmCards(1-tp,g2)
	Duel.ShuffleHand(tp)
end