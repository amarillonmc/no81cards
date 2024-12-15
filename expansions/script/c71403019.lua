--气泡方块使 林檎
---@param c Card
if not c71403001 then dofile("expansions/script/c71403001.lua") end
function c71403019.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	--scale
	local ep1=Effect.CreateEffect(c)
	ep1:SetType(EFFECT_TYPE_SINGLE)
	ep1:SetCode(EFFECT_CHANGE_LSCALE)
	ep1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ep1:SetRange(LOCATION_PZONE)
	ep1:SetCondition(yume.PPTOtherScaleCheck)
	ep1:SetValue(0)
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
	ep2:SetDescription(aux.Stringid(71403019,0))
	ep2:SetCountLimit(1,71503019)
	ep2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	ep2:SetCost(yume.PPTLimitCost)
	ep2:SetTarget(c71403019.tgp2)
	ep2:SetOperation(c71403019.opp2)
	c:RegisterEffect(ep2)
	local ep2a=ep2:Clone()
	ep2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(ep2a)
	--set from deck
	--monster movement effect
	yume.RegPPTPuyopuyoBasicMoveEffect(c,71403019)
	yume.PPTCounter()
	--Destroyed and added to Extra from Main Monster Zone
	yume.RegPPTPuyopuyoBasicExtraFlag(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71403019,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOEXTRA)
	e2:SetCountLimit(1,71513019)
	e2:SetCost(yume.PPTLimitCost)
	e2:SetCondition(yume.RegPPTPuyopuyoBasicExtraCon)
	e2:SetTarget(c71403019.tg2)
	e2:SetOperation(c71403019.op2)
	c:RegisterEffect(e2)
end
function c71403019.filterp2a(c)
	return c:GetSequence()>4 and c:IsFaceup() and c:IsSetCard(0x715)
end
function c71403019.filterp2b(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function c71403019.tgp2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71403019.filterp2a(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71403019.filterp2a,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c71403019.filterp2b,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c71403019.filterp2a,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c71403019.opp2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
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
		local g=Duel.GetMatchingGroup(c71403019.filterp2b,tp,LOCATION_DECK,0,1,nil)
		if op_flag and g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function c71403019.filter2a(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_PENDULUM)
end
function c71403019.filter2b(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
end
function c71403019.filter2bfield(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c71403019.filter2stzone(c)
	return not c:IsLocation(LOCATION_FZONE)
end
function c71403019.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local deck_flag=Duel.IsExistingMatchingCard(c71403019.filter2b,tp,LOCATION_DECK,0,1,nil)
		if not deck_flag then return false end
		local hand_flag=Duel.IsExistingMatchingCard(c71403019.filter2a,tp,LOCATION_HAND,0,1,nil)
		local field_any_flag=Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,0,1,nil)
		if not (hand_flag or field_any_flag) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if not e:GetHandler():IsLocation(LOCATION_SZONE) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			ft=ft-1
		end
		if ft>0 then return true end
		local deck_field_flag=Duel.IsExistingMatchingCard(c71403019.filter2bfield,tp,LOCATION_DECK,0,1,nil)
		local field_stzone_flag=Duel.IsExistingMatchingCard(c71403019.filter2stzone,tp,LOCATION_SZONE,0,1,nil)
		return (deck_flag and field_stzone_flag or deck_field_flag and field_any_flag)
	end
end
function c71403019.filter2second(c)
	return c:IsSetCard(0x715) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c71403019.op2(e,tp,eg,ep,ev,re,r,rp)
	local deck_group=Duel.GetMatchingGroup(c71403019.filter2b,tp,LOCATION_DECK,0,nil)
	local des_field_group=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,nil)
	local hand_group=Duel.GetMatchingGroup(c71403019.filter2a,tp,LOCATION_HAND,0,nil)
	if not (hand_group or des_field_group) then return end
	local op_flag=false
	if deck_group:GetCount()==0 then
		local b1=hand_group:GetCount()>0
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
	else
		local deck_field_group=deck_group:Filter(Card.IsType,nil,TYPE_FIELD)
		local des_stzone_group=des_field_group:Filter(c71403019.filter2stzone,nil)
		local stzone_count_flag=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		local b1=hand_group:GetCount()>0
			and (stzone_count_flag or deck_field_group:GetCount()>0)
		local b2=des_field_group:GetCount()>0 and (stzone_count_flag
			or des_stzone_group:GetCount()>0 or deck_field_group:GetCount()>0)
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
			local sg=nil
			if stzone_count_flag or deck_field_group:GetCount()>0 then
				sg=des_field_group:Select(tp,1,1,nil)
			else
				sg=des_stzone_group:Select(tp,1,1,nil)
			end
			op_flag=Duel.Destroy(sg,REASON_EFFECT)>0
		end
	end
	if not op_flag then return end
	--second check
	deck_group=Duel.GetMatchingGroup(c71403019.filter2second,tp,LOCATION_DECK,0,nil)
	if deck_group:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local setg=deck_group:Select(tp,1,1,nil)
		if setg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SSet(tp,setg)
		end
	end
end