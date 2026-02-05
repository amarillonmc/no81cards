-- 菜月昴
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337400)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetValue(17337400)
	c:RegisterEffect(e0)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3f50),2,4,s.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(s.self_leave_con)
	e2:SetOperation(s.reg_delayed_sp) 
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCondition(s.other_leave_con)
	e3:SetOperation(s.reg_delayed_sp)
	c:RegisterEffect(e3)
end
function s.lcheck(g,lc)
	return g:IsExists(Card.IsFusionCode,1,nil,17337400)
end
function s.thfilter(c)
	return (c:IsSetCard(0x3f50) or aux.IsCodeListed(c,17337400)) and c:IsAbleToHand() and c:IsFaceup()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and s.thfilter(chkc) end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if chk==0 then return ct>0 and Duel.IsExistingTarget(s.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) 
		and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if ct>0 and Duel.Draw(tp,ct,REASON_EFFECT)==ct then
		Duel.ShuffleHand(tp)
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
			Duel.ShuffleHand(tp)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,ct,ct,nil)
			if #g>0 then
				Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
			end
		end
	end
end
function s.mira_filter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and (c:IsSetCard(0x3f50) or aux.IsCodeListed(c,17337400))
		and c:GetReasonPlayer()==1-tp -
end
function s.self_leave_con(e,tp,eg,ep,ev,re,r,rp)
	return s.mira_filter(e:GetHandler(),tp)
end
function s.other_leave_con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.mira_filter,1,e:GetHandler(),tp)
end
function s.reg_delayed_sp(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+100)~=0 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(s.sp_final_action)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e2,tp)
end
function s.sp_final_action(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id+100)~=0 then 
		e:Reset()
		return 
	end	
	local c=e:GetOwner() 
	if (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.RegisterFlagEffect(tp,id+100,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_CARD,0,id)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	e:Reset()
end