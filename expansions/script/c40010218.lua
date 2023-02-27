--链环傀儡 欧米茄·超机神
local m=40010218
local cm=_G["c"..m]
cm.named_with_linkjoker=1
cm.named_with_Glendios=1
function cm.linkjoker(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_linkjoker or (Duel.IsPlayerAffectedByEffect(c:GetControler(),40010218) and m.named_with_Reverse and c:IsLocation(LOCATION_MZONE+LOCATION_HAND)))
end
function cm.Reverse(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Reverse
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,3)   
	--release replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(m)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)

	--atk & def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.tg)
	e2:SetValue(4000)
	c:RegisterEffect(e2)
	 --pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(cm.poscost)
	e3:SetTarget(cm.postg)
	e3:SetOperation(cm.posop)
	c:RegisterEffect(e3)  
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetOperation(cm.winop)
	c:RegisterEffect(e4)
end
function cm.matfilter(c)
	return cm.linkjoker(c) or cm.Reverse(c)
end
function cm.tg(e,c)
	return cm.Reverse(c)
end
function cm.costfilter(c)
	return cm.Reverse(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.spfilter(c,e,tp)
	return cm.Reverse(c) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and ((c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE)) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and not cm.linkjoker(c)
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.posfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.posfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		if Duel.SpecialSummon(g1,0,tp,tp,true,false,POS_FACEUP)~=0 and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		   Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK)
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
	Duel.RegisterFlagEffect(tp,40010160,RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,2,Duel.GetTurnCount())
	Duel.RegisterFlagEffect(tp,40010218,RESET_PHASE+PHASE_STANDBY,EFFECT_FLAG_OATH,2,Duel.GetTurnCount())
end
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and Duel.GetTurnPlayer()==tc:GetControler() and tc:GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,40010160)==0
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end
function cm.winop(e,tp,eg,ep,ev,re,r,rp)
	--local WIN_REASON_DISASTER_LEO=0x18
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY 
		and Duel.GetLP(tp)<=1000 and Duel.GetMatchingGroupCount(Card.IsFacedown,0,0,LOCATION_MZONE,nil)>=5 then
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,1))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,1))
		Duel.Win(tp,nil)
	end
end

