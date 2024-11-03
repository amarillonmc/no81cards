--气泡方块使 Z
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403005.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--scale
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_SINGLE)
	ep1:SetCode(EFFECT_CHANGE_LSCALE)
	ep1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCondition(yume.PPTOtherScaleCheck)
	ep1:SetValue(13)
	c:RegisterEffect(ep1)
	local ep1a=ep1:Clone()
	ep1a:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(ep1a)
	--change pos
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_POSITION+CATEGORY_TOEXTRA)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(71403005,0))
	ep2:SetCountLimit(1,71503005)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403005.tgp2)
	ep2:SetOperation(c71403005.opp2)
	c:RegisterEffect(ep2)
	--monster movement effect
	yume.RegPPTTetrisBasicMoveEffect(c,71403005)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403005,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,71513005)
	e2:SetCondition(yume.PPTMainPhaseCon)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetTarget(c71403005.tg2)
	e2:SetOperation(c71403005.op2)
	c:RegisterEffect(e2)
	yume.PPTCounter()
end
function c71403005.filterp2a(c)
	return c:GetSequence()>4 and c:IsFaceup() and c:IsSetCard(0x715) and c:IsCanChangePosition()
end
function c71403005.filterp2b(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM)
end
function c71403005.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71403005.filterp2a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71403005.filterp2a,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c71403005.filterp2b,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c71403005.filterp2a,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
end
function c71403005.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c71403005.filterp2b,tp,LOCATION_GRAVE,0,1,nil)
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71403001,1))
		local g=Duel.SelectMatchingCard(tp,c71403005.filterp2b,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoExtraP(g,nil,REASON_EFFECT)
		end
	end
end
function c71403005.filter2des(c,tp,tc)
	return Duel.IsExistingMatchingCard(c71403005.filter2,tp,LOCATION_ONFIELD,0,1,Group.FromCards(c,tc))
end
function c71403005.filter2(c)
	return c:IsSetCard(0x715) and c:IsFaceup() and c:GetFlagEffect(71403005)==0
end
function c71403005.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=c and c71403005.filter2des(chkc,c) end
	if chk==0 then
		return c:GetSequence()<5 and Duel.IsExistingTarget(c71403005.filter2des,tp,LOCATION_ONFIELD,0,1,c,tp,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c71403005.filter2des,tp,LOCATION_ONFIELD,0,1,1,c,tp,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c71403005.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and c:GetSequence()<5 and tc:IsRelateToEffect(e)) then return end
	local dg=Group.FromCards(c,tc)
	if Duel.Destroy(dg,REASON_EFFECT)==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c71403005.filter2,tp,LOCATION_PZONE,0,1,1,nil)
		if g:GetCount()>0 then
			oc=g:GetFirst()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(71403005,2))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			oc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			oc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_CANNOT_DISEFFECT)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(c71403005.efilter)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			oc:RegisterEffect(e3)
			oc:RegisterFlagEffect(71403005,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c71403005.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end