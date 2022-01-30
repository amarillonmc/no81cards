--奉神天使 
local m=20000350
local cm=_G["c"..m]
fs=fs or {}
function fs.sum(c,code,cef,op)
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,code)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if Duel.Draw(p,d,REASON_EFFECT)~=0 then
			local tc=Duel.GetOperatedGroup():GetFirst()
			Duel.ConfirmCards(1-tp,tc)
			Duel.BreakEffect()
			if not (tc:IsSetCard(0x5fd2) or tc:GetType()==0x100004) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
			Duel.ShuffleHand(tp)
		end
	end)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1,code+100)
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end)
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetFieldGroup(tp,LOCATION_DECK,0) end
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,0)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ShuffleDeck(tp)
		local g=Duel.GetMatchingGroup(function(c)return c:IsSetCard(0x5fd2) and c:IsSummonable(true,nil)end,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.Summon(tp,tc,true,nil)
		end
	end)
	tc:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return re:GetHandler():IsSetCard(0x5fd2) and re:GetHandler():GetType()==0x100004 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsExistingMatchingCard(cef,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
		and e:GetHandler():GetFlagEffect(m)==0 and Duel.SelectYesNo(tp,aux.Stringid(code,0)) then
			e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
			local g=Duel.SelectMatchingCard(tp,cef,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
			local fc=g:GetFirst()
			if #g>0 then
				op(e,tp,eg,ep,ev,re,r,rp,g,fc)
			end
		end
	end)
	tc:RegisterEffect(e4)
	return e1
end
function fs.counter(c,cat,cod,pro,cond,tgf,tg,op,cod2)
	local tc=c
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(cat)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(cod)
	if pro then
		e1:SetProperty(pro)
	end
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 
		and not Duel.IsExistingMatchingCard(function(c)return c:IsFacedown()or not c:IsRace(RACE_FAIRY)end,tp,LOCATION_MZONE,0,1,nil) and cond
	end)
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLP(tp)>=1000  end
		Duel.PayLPCost(tp,1000)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return tgf(e,tp,eg,ep,ev,re,r,rp) end
		tg(e,tp,eg,ep,ev,re,r,rp)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
	end)
	tc:RegisterEffect(e1)
	if cod then
		local e2=e1:Clone()
		e2:SetCode(cod2)
		tc:RegisterEffect(e2)
	end
	return e1
end