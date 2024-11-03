--天龙座的游戏-九艺
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit() 
	--spsummon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.tgcon)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetCondition(s.tgcon2)
	c:RegisterEffect(e4)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,id+o*2)
	e3:SetCondition(s.mtcon)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)

end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local op1,op2=true
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE+LOCATION_REMOVED,0)==0 then
		op1=false 
	end
	if Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0)==0 then
		op2=false 
	end
	if op1 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
		if op2 and Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
			local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,2,nil)
			g:Merge(g2)
		end 
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,2,nil)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end 
end
--02
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,11640015)
end
function s.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,11640015) and Duel.GetFlagEffect(tp,11640015)<2
end
function s.cfilter(c,e)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave()
end
function s.cfilter2(c)
	return c:IsAbleToGrave() and c:IsLocation(LOCATION_HAND)
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,c)
	local sc=g:GetFirst()
	local tg=Group.FromCards(c,sc)  
	Duel.ConfirmCards(1-tp,tg)
	Duel.ShuffleHand(tp)
	sc:CreateEffectRelation(e)  
	e:SetLabelObject(sc) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_HAND+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if Duel.GetTurnPlayer()==1-tp  then
		Duel.RegisterFlagEffect(tp,11640015,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.tgfilter(c)
	return c:IsSetCard(0x3224) and c:IsFaceup()
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	local ld=math.abs(c:GetLevel()-sc:GetLevel())   
	local mg=Group.FromCards(c,sc)
	local lv=1
	if ld>0 then
		lv=ld
	end
	if ld<=5 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	elseif ld>5 and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
	if Duel.IsPlayerAffectedByEffect(tp,11640016) and Duel.GetFlagEffect(tp,11640016)<2 and Duel.SelectYesNo(tp,aux.Stringid(11640015,0)) then
		Duel.Hint(HINT_CARD,0,11640015)
		Duel.RegisterFlagEffect(tp,11640016,RESET_PHASE+PHASE_END,0,1)
	else
		local tg=mg:FilterSelect(tp,s.cfilter2,1,1,nil):GetFirst()
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsNonAttribute,ATTRIBUTE_LIGHT))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
--
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	while rc do
		if rc:GetFlagEffect(id)==0 then
			--untargetable
			local e1=Effect.CreateEffect(rc)
			e1:SetDescription(aux.Stringid(id,6))
			e1:SetCategory(CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_IGNITION)
			e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetTarget(s.tg)
			e1:SetOperation(s.op)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e1,true)
			rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
		end  
		rc=eg:GetNext()
	end   
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField()  end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end