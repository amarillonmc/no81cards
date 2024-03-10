--净界遗歌 嫉妒之利维坦
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
if not cm.jjygtwo then
	cm.jjygtwo=true
	local cm_special_summon=Duel.SpecialSummon
	Duel.SpecialSummon=function (c,way,tp1,tp2,tf1,tf2,pos,...)
		--local tp=c:GetOwner()
		if Duel.GetFlagEffect(tp,m)~=0 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_DECK,0,1,nil) and (c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_EXTRA)) then
			local ac=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_DECK,0,1,1,nil)
			--Duel.ResetFlagEffect(tp,m)
			Duel.Hint(HINT_CARD,0,m)
			--local x=
			--Debug.Message(x)
			return cm_special_summon(ac,way,tp1,tp2,tf1,tf2,pos,...)
		else
			--local x=
			--Debug.Message(x)
			return cm_special_summon(c,way,tp1,tp2,tf1,tf2,pos,...)
		end
	end
	local cm_special_summon_step=Duel.SpecialSummonStep
	Duel.SpecialSummonStep=function (c,way,tp1,tp2,tf1,tf2,pos,...)
		local tp=c:GetOwner()
		if Duel.GetFlagEffect(tp,m)~=0 and Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_DECK,0,1,nil) and (c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_EXTRA)) then
			local ac=Duel.SelectMatchingCard(tp,cm.fil,tp,LOCATION_DECK,0,1,1,nil)
			
			--Duel.ResetFlagEffect(tp,m)
			Duel.Hint(HINT_CARD,0,m)
			return cm_special_summon_step(ac,way,tp1,tp2,tf1,tf2,pos,...)
		else
			return cm_special_summon_step(c,way,tp1,tp2,tf1,tf2,pos,...)
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
