--净界遗歌 色孽之阿斯莫德
local cm,m,o=GetID()
function cm.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
if not cm.jjygfive then
	cm.jjygfive=true
	cm._special_summon=Duel.SpecialSummon
	Duel.SpecialSummon=function (c,way,tp1,tp2,tf1,tf2,pos,...)
		if Duel.GetFlagEffect(tp,m)~=0 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_DECK,0,1,nil) and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) then
			local ac=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_DECK,0,1,1,nil)
			cm._special_summon(ac,way,tp1,tp2,tf1,tf2,pos,...)
			Duel.ResetFlagEffect(tp,m)
			Duel.Hint(HINT_CARD,0,m)
		else
			cm._special_summon(c,way,tp1,tp2,tf1,tf2,pos,...)
		end
	end
	cm._special_summon_step=Duel.SpecialSummonStep
	Duel.SpecialSummonStep=function (c,way,tp1,tp2,tf1,tf2,pos,...)
		if Duel.GetFlagEffect(tp,m)~=0 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_DECK,0,1,nil) and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) then
			local ac=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_DECK,0,1,1,nil)
			cm._special_summon_step(ac,way,tp1,tp2,tf1,tf2,pos,...)
			Duel.ResetFlagEffect(tp,m)
			Duel.Hint(HINT_CARD,0,m)
		else
			cm._special_summon_step(c,way,tp1,tp2,tf1,tf2,pos,...)
		end
	end
end
function cm.fil(c)
	return c:IsCode(m) and c:IsPosition(POS_FACEUP_DEFENSE)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoDeck(e:GetHandler(),1-tp,2,REASON_COST)
	e:GetHandler():ReverseInDeck()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(1-tp,m,RESET_PHASE+PHASE_END,0,1)
end
