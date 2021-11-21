--链环傀儡 逆之根源
local m=40010156
local cm=_G["c"..m]
cm.named_with_linkjoker=1
cm.named_with_Reverse=1
function cm.linkjoker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_linkjoker
end
function cm.Reverse(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Reverse
end
function cm.initial_effect(c)
		c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,2)
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	--e1:SetCost(cm.poscost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
	--direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.dacon)
	e3:SetTarget(cm.datg)
	c:RegisterEffect(e3)



end
function cm.matfilter(c)
	return cm.linkjoker(c) or cm.Reverse(c)
end
function cm.spfilter(c,e,tp)
	return cm.Reverse(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and ((c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE)) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and not cm.linkjoker(c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	local g2=Duel.GetMatchingGroup(cm.posfilter,tp,0,LOCATION_MZONE,nil)
	if g1:GetCount()>0 then
		if Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP)>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
			local sg=g2:Select(tp,1,1,nil)  
			local tc=sg:GetFirst()
			Duel.BreakEffect()
			Duel.HintSelection(sg)  
			Duel.ChangePosition(sg,POS_FACEDOWN_ATTACK)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
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
		end
	end
end
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and Duel.GetTurnPlayer()==tc:GetControler() and tc:GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,40010160)==0
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end
function cm.atkfilter2(c)
	return c:IsFaceup() and cm.Reverse(c)
end
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(cm.atkfilter2,c:GetControler(),LOCATION_MZONE,0,c)
	return g:GetSum(Card.GetBaseAttack)
end
function cm.dacon(e)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function cm.datg(e,c)
	return cm.linkjoker(c) or cm.Reverse(c)
end
