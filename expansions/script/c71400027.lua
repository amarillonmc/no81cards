--梦路脑坏
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400027.initial_effect(c)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400027,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1f0)
	e1:SetCost(c71400027.cost1)
	e1:SetTarget(c71400027.tg1)
	e1:SetOperation(c71400027.op1)
	c:RegisterEffect(e1)
	--ac in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(yume.nonYumeCon)
	c:RegisterEffect(e0)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400027,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c71400027.tg2)
	e2:SetOperation(c71400027.op2)
	c:RegisterEffect(e2)
end
function c71400027.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c71400027.filter1(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and not c:IsType(TYPE_TOKEN) and c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToChangeControler()
end
function c71400027.xyzfilter(c,e,tp)
	return c:IsSetCard(0x3715) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c71400027.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c71400027.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400027.filter1,tp,0,LOCATION_MZONE,2,nil) and Duel.IsExistingMatchingCard(c71400027.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c71400027.filter1,tp,0,LOCATION_MZONE,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400027.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xyzg=Duel.GetMatchingGroup(c71400027.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local sg=xyzg:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	Debug.ShowHint(1)
	if sc and Duel.SpecialSummonStep(sc,0,tp,tp,true,false,POS_FACEUP) then
		local fid=c:GetFieldID()
		sc:RegisterFlagEffect(71400027,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(sc)
		e1:SetCondition(c71400027.tdcon)
		e1:SetOperation(c71400027.tdop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(0)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()==2 then
			local tc=g:GetFirst()
			while tc do
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc=g:GetNext()
			end
			Duel.Overlay(sc,g)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c71400027.aclimit)
	Duel.RegisterEffect(e3,tp)
end
function c71400027.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x714) and re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end
function c71400027.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(71400027)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c71400027.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c71400027.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_FZONE) and chkc:IsControler(tp) and c71400027.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400027.filter2,tp,LOCATION_FZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c71400027.filter2,tp,LOCATION_FZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71400027.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xb714) and c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c71400027.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)==1 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	end
end