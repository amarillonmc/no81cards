--气泡方块的见习法师与搭档 亚鲁鲁·娜嘉&卡邦可
---@param c Card
function c71403022.initial_effect(c)
	if not (yume and yume.PPT_loaded) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71403001,0)
		yume.import_flag=false
	end
	--syn summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_PENDULUM),aux.NonTuner(aux.FilterBoolFunction(Card.IsSynchroType,TYPE_PENDULUM)),1,1)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--pos limit
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_FIELD)
	ep1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	ep1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetTargetRange(0,LOCATION_MZONE)
	ep1:SetCondition(yume.PPTOtherScaleCheck)
	c:RegisterEffect(ep1)
	--change pos(p effect)
	local ep2=Effect.CreateEffect(c)
	ep2:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	ep2:SetType(EFFECT_TYPE_IGNITION)
	ep2:SetCode(EVENT_FREE_CHAIN)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(71403022,0))
	ep2:SetCountLimit(1,71503022)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403022.tgp2)
	ep2:SetOperation(c71403022.opp2)
	c:RegisterEffect(ep2)
	--monster movement effect
	yume.RegPPTPuyopuyoExMoveEffect(c,71403022)
	--sp summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403022,5))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_BATTLE_START+TIMING_END_PHASE)
	e2:SetCountLimit(1,71513022)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetTarget(c71403022.tg2)
	e2:SetOperation(c71403022.op2)
	c:RegisterEffect(e2)
end
function c71403022.filterptg2(c,e)
	return c:IsCanChangePosition() and c:IsCanBeEffectTarget(e)
end
function c71403022.filterp2(c)
	return c:IsCanTurnSet() or not c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c71403022.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition()
		and Duel.IsExistingMatchingCard(c71403022.filterp2,tp,LOCATION_MZONE,LOCATION_MZONE,1,chkc)
	end
	local g1=Duel.GetMatchingGroup(c71403022.filterptg2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	local g2=Duel.GetMatchingGroup(c71403022.filterp2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g3=g1&g2
	if chk==0 then return #g1>0 and #g2>0 and not (#g1==#g3 and #g2==#g3 and #g1==1) end
	local excard=nil
	if #g2==#g3 and #g3==1 then excard=g3:GetFirst() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=g1:Select(tp,1,1,excard)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g2-g1,1,0,0)
end
function c71403022.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c71403022.filterp2,tp,LOCATION_MZONE,LOCATION_MZONE,tc)
	if tc:IsRelateToEffect(e) then
		local b2=tc:IsCanChangePosition()
		local op=-1
		if b2 then
			op=Duel.SelectOption(tp,aux.Stringid(71403019,2),aux.Stringid(71403019,3))
		else
			op=Duel.SelectOption(tp,aux.Stringid(71403019,2))
		end
		local op_flag=false
		if op==0 then
			op_flag=Duel.Destroy(sg,REASON_EFFECT)>0
		else
			op_flag=Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0
		end
		if op_flag and g:GetCount()>0 then
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			if sc:IsPosition(POS_FACEUP_DEFENSE) and sc:IsCanTurnSet() then
				local pos=Duel.SelectPosition(tp,sc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
				Duel.ChangePosition(sc,pos)
			else
				Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
			end
		end
	end
end
function c71403022.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x715) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c71403022.filter2sp(c,e,tp)
	return c:IsSetCard(0x715) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c71403022.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c71403022.filter2,tp,LOCATION_EXTRA+LOCATION_ONFIELD,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c71403022.filter2sp),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	local g1=Duel.GetMatchingGroup(c71403022.filter2,tp,LOCATION_EXTRA+LOCATION_ONFIELD,0,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c71403022.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local desg=Duel.SelectMatchingCard(tp,c71403022.filter2,tp,LOCATION_EXTRA+LOCATION_ONFIELD,0,1,1,nil,tp)
	if Duel.Destroy(desg,REASON_EFFECT)>0 then
		local sp_group=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71403022.filter2sp),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		if sp_group:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local setg=sp_group:Select(tp,1,1,nil)
			if setg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SpecialSummon(setg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
				Duel.ConfirmCards(1-tp,setg)
			end
		end
	end
end