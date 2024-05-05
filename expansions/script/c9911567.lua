--掩映紫炎蔷薇的音色
function c9911567.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911567,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,9911567)
	e1:SetTarget(c9911567.lvtg)
	e1:SetOperation(c9911567.lvop)
	c:RegisterEffect(e1)
	--turn set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911567,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,9911568)
	e2:SetCost(c9911567.poscost)
	e2:SetTarget(c9911567.postg)
	e2:SetOperation(c9911567.posop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9911569)
	e3:SetCondition(c9911567.drcon)
	e3:SetTarget(c9911567.drtg)
	e3:SetOperation(c9911567.drop)
	c:RegisterEffect(e3)
	if not c9911567.global_check then
		c9911567.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BECOME_TARGET)
		ge1:SetOperation(c9911567.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetOperation(c9911567.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c9911567.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tg=eg:Filter(Card.IsOnField,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911567,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911567,5))
		end
	end
end
function c9911567.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c9911567.ctgfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #tg>0 then
		for tc in aux.Next(tg) do
			tc:RegisterFlagEffect(9911567,RESET_EVENT+0x1fc0000,EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911567,5))
		end
	end
end
function c9911567.ctgfilter(c)
	return c:GetOwnerTargetCount()>0 and c:GetFlagEffect(9911567)==0
end
function c9911567.filter(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c9911567.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9911567.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911567.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9911567.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9911567.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9911567,2))
		local lv=Duel.AnnounceNumber(tp,1,2,3)
		local sel=0
		if tc:GetLevel()<=lv then
			sel=Duel.SelectOption(tp,aux.Stringid(9911567,3))
		else
			sel=Duel.SelectOption(tp,aux.Stringid(9911567,3),aux.Stringid(9911567,4))
		end
		if sel==1 then
			lv=-lv
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_PZONE)
		e1:SetTarget(c9911567.desreptg)
		e1:SetValue(c9911567.desrepval)
		e1:SetOperation(c9911567.desrepop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c9911567.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField()
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c9911567.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c9911567.repfilter,1,nil,tp) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	return true
end
function c9911567.desrepval(e,c)
	return c9911567.repfilter(c,e:GetHandlerPlayer())
end
function c9911567.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	g:AddCard(c)
	Duel.Hint(HINT_CARD,0,9911567)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c9911567.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9911567.posfilter(c,mc)
	local g=Group.FromCards(c)
	g:Merge(c:GetColumnGroup())
	return c:IsCanTurnSet() and g:IsExists(function(c) return c:GetFlagEffect(9911567)>0 end,1,mc)
end
function c9911567.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911567.posfilter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c9911567.posfilter,tp,0,LOCATION_MZONE,nil,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c9911567.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9911567.posfilter,tp,0,LOCATION_MZONE,nil,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
end
function c9911567.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetCount()>1 and eg:IsContains(e:GetHandler())
end
function c9911567.cfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsCanBeEffectTarget(e)
end
function c9911567.fselect(g,tp)
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	return num>0 and Duel.IsPlayerCanDraw(tp,num)
end
function c9911567.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=eg:Filter(c9911567.cfilter,nil,e)
	if chk==0 then return #g>1 and g:CheckSubGroup(c9911567.fselect,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=g:SelectSubGroup(tp,c9911567.fselect,false,2,2,tp)
	Duel.SetTargetCard(g1)
	local lv1=g1:GetFirst():GetLevel()
	local lv2=g1:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,num)
end
function c9911567.cfilter2(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c9911567.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c9911567.cfilter2,nil,e)
	if #g~=2 then return end
	local lv1=g:GetFirst():GetLevel()
	local lv2=g:GetNext():GetLevel()
	local num=math.floor(math.abs(lv1-lv2)/2)
	if num<1 then return end
	Duel.Draw(tp,num,REASON_EFFECT)
end
