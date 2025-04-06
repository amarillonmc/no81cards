--幻子域逮捕者 协议「四」
local m=22348456
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,c22348456.lcheck)
	c:EnableReviveLimit()
	--so
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22348456.socon)
	e1:SetOperation(c22348456.soop)
	c:RegisterEffect(e1)
	--bm
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c22348456.bmcon)
	e2:SetCost(c22348456.bmcost)
	e2:SetTarget(c22348456.bmtg)
	e2:SetOperation(c22348456.bmop)
	c:RegisterEffect(e2)
end
function c22348456.lcheck(g)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end
function c22348456.socon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c22348456.soop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	tc:CancelToGrave()
end
function c22348456.bmcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c22348456.bmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c22348456.bmfilter1(c)
	return c:IsFaceup() and c:IsType(0x7) and c:IsAbleToGraveAsCost()
end
function c22348456.bmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c22348456.bmfilter1,tp,LOCATION_ONFIELD,0,1,nil) and eg:GetFirst():IsType(TYPE_MONSTER) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348456.bmfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c22348456.bmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=re:GetHandler()
	local pc=e:GetLabelObject()
	if tc:IsRelateToEffect(re) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL)
		tc:RegisterEffect(e1)
		if pc:IsType(TYPE_SPELL) then
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(22348456,0))
			e2:SetCategory(CATEGORY_DRAW)
			e2:SetType(EFFECT_TYPE_ACTIVATE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetCode(EVENT_FREE_CHAIN)
			e2:SetTarget(c22348456.drtg)
			e2:SetOperation(c22348456.drop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e2)
		end
		if pc:IsType(TYPE_TRAP) then
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(22348456,1))
			e3:SetCategory(CATEGORY_DESTROY)
			e3:SetType(EFFECT_TYPE_ACTIVATE)
			e3:SetCode(EVENT_FREE_CHAIN)
			e3:SetTarget(c22348456.detg)
			e3:SetOperation(c22348456.deop)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e3)
		end
		if pc:IsType(TYPE_MONSTER) then
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(22348456,2))
			e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e4:SetType(EFFECT_TYPE_ACTIVATE)
			e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e4:SetCode(EVENT_FREE_CHAIN)
			e4:SetTarget(c22348456.sptg)
			e4:SetOperation(c22348456.spop)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			tc:RegisterEffect(e4)
		end
	end
end
function c22348456.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348456.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c22348456.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c22348456.deop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD):Select(tp,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c22348456.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348456.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end









