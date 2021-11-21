--星云领主龙
local m=40010150
local cm=_G["c"..m]
cm.named_with_linkjoker=1
function cm.linkjoker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_linkjoker
end
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()  
	  --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition1)

	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition2)
	e2:SetCost(cm.cost)
	c:RegisterEffect(e2) 
end
function cm.cfilter1(c)
	return c:GetSequence()>=5
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)==5 and not Duel.IsExistingMatchingCard(cm.cfilter1,tp,0,LOCATION_MZONE,1,nil)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)>1 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,ct,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,ct,ct,REASON_COST+REASON_DISCARD,nil)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_HAND,nil,e,1-tp)
	if g1:GetCount()>0 then
		if Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 then
			local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
			if ft2>0 then
				if Duel.IsPlayerAffectedByEffect(1-tp,59822133) then ft2=1 end
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(1-tp,cm.filter,tp,0,LOCATION_HAND,ft2,ft2,nil,e,1-tp)
				if g:GetCount()>0 then
					local tc=g:GetFirst()
					while tc do
						Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEDOWN_ATTACK)
						tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetDescription(aux.Stringid(m,1))
						e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e1:SetCode(EVENT_PHASE+PHASE_END)
						e1:SetCountLimit(1)
						e1:SetReset(RESET_PHASE+RESETS_STANDARD-RESET_TURN_SET)
						e1:SetCondition(cm.flipcon)
						e1:SetOperation(cm.flipop)
						e1:SetLabelObject(tc)
						Duel.RegisterEffect(e1,tp)
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
						--e2:SetCondition(cm.rcon)
						e2:SetReset(RESET_EVENT+RESETS_STANDARD)
						Duel.RegisterEffect(e2,tp)
						local e3=Effect.CreateEffect(e:GetHandler())
						e3:SetType(EFFECT_TYPE_SINGLE)
						e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
						e3:SetReset(RESET_EVENT+RESETS_STANDARD)
						Duel.RegisterEffect(e3,tp)
						tc=g:GetNext()
					end
				end
			end
		end
	end
	Duel.SpecialSummonComplete()
end
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and Duel.GetTurnPlayer()==tc:GetControler() and tc:GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,40010160)==0
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end