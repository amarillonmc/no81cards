--气泡方块使 亚鲁鲁
if not c71403001 then dofile("expansions/script/c71403001.lua") end
---@param c Card
function c71403021.initial_effect(c)
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
	ep2:SetCategory(CATEGORY_POSITION+CATEGORY_TOGRAVE)
	ep2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	ep2:SetCode(EVENT_SUMMON_SUCCESS)
	ep2:SetRange(LOCATION_PZONE)
	ep2:SetDescription(aux.Stringid(71403021,0))
	ep2:SetCountLimit(1,71503021)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403021.tgp2)
	ep2:SetOperation(c71403021.opp2)
	c:RegisterEffect(ep2)
	local ep2a=ep2:Clone()
	ep2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(ep2a)
	--set from deck
	--monster movement effect
	yume.RegPPTPuyopuyoBasicMoveEffect(c,71403021)
	yume.PPTCounter()
	--Destroyed and added to Extra from Main Monster Zone
	yume.RegPPTPuyopuyoBasicExtraFlag(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403021,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA)
	e2:SetCountLimit(1,71513021)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetCondition(yume.RegPPTPuyopuyoBasicExtraCon)
	e2:SetTarget(c71403021.tg2)
	e2:SetOperation(c71403021.op2)
	c:RegisterEffect(e2)
end
function c71403021.filterp2a(c,e)
	return c:GetSequence()<5 and c:IsFaceup() and c:IsSetCard(0x715) and c:IsCanBeEffectTarget(e)
end
function c71403021.filterp2b(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c71403021.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
		and c71403021.filterp2a(chkc,e)
		and Duel.IsExistingMatchingCard(c71403021.filterp2b,tp,LOCATION_MZONE,LOCATION_MZONE,1,chkc)
	end
	local g1=Duel.GetMatchingGroup(c71403021.filterp2a,tp,LOCATION_MZONE,0,nil,e)
	local g2=Duel.GetMatchingGroup(c71403021.filterp2b,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g3=g1&g2
	if chk==0 then return #g1>0 and #g2>0 and not (#g1==#g3 and #g2==#g3 and #g1==1) end
	local excard=nil
	if #g2==#g3 and #g3==1 then excard=g3:GetFirst() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=g1:Select(tp,1,1,excard)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g+1,0,0)
end
function c71403021.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c71403021.filterp2b,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc)
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
			op_flag=Duel.Destroy(tc,REASON_EFFECT)>0
		else
			op_flag=Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0
		end
		if op_flag and g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE)
		end
	end
end
function c71403021.filter2a(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM)
end
function c71403021.filter2b(c,tp)
	return Duel.GetMZoneCount(tp,c,tp)>0
end
function c71403021.filter2c(c,e,tp)
	return c:IsSetCard(0x715) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c71403021.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c71403021.filter2a,tp,LOCATION_HAND,0,1,nil)
		or Duel.IsExistingMatchingCard(c71403021.filter2b,tp,LOCATION_ONFIELD,0,1,nil,tp))
		and Duel.IsExistingMatchingCard(c71403021.filter2c,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
end
function c71403021.filter2second(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c71403021.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp,nil,tp)
	local des_field_group=Duel.GetMatchingGroup(c71403021.filter2b,tp,LOCATION_ONFIELD,0,nil,tp)
	local hand_group=Duel.GetMatchingGroup(c71403021.filter2a,tp,LOCATION_HAND,0,nil)
	if not (hand_group or des_field_group) then return end
	local op_flag=false
	local b1=hand_group:GetCount()>0 and ft>0
	local b2=des_field_group:GetCount()>0
	local op=-1
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(71403001,10),aux.Stringid(71403001,11))
	elseif b1 then
		op=0
	elseif b2 then
		op=1
	end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71403001,1))
		local sc=hand_group:Select(tp,1,1,nil):GetFirst()
		op_flag=Duel.SendtoExtraP(sc,nil,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_EXTRA) and sc:IsFaceup()
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=des_field_group:Select(tp,1,1,nil)
		op_flag=Duel.Destroy(sg,REASON_EFFECT)>0
	end
	if not op_flag then return end
	local deck_group=Duel.GetMatchingGroup(c71403021.filter2c,tp,LOCATION_DECK,0,nil,e,tp)
	if deck_group:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local setg=deck_group:Select(tp,1,1,nil)
		if setg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(setg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,setg)
		end
	end
end