--fate·奥德修斯
function c9951316.initial_effect(c)
	  --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xba5),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9951316)
	e1:SetLabel(0)
	e1:SetCost(c9951316.cost)
	e1:SetTarget(c9951316.target)
	e1:SetOperation(c9951316.operation)
	c:RegisterEffect(e1)
--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(9951316,1))
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetCode(EVENT_BATTLE_DESTROYING)
	e9:SetCondition(c9951316.decon)
	e9:SetTarget(c9951316.detg)
	e9:SetOperation(c9951316.deop)
	c:RegisterEffect(e9)
--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9951316,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9951316.condition)
	e2:SetTarget(c9951316.target2)
	e2:SetOperation(c9951316.operation2)
	c:RegisterEffect(e2)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9951316.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9951316.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951316,0))
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951316,1))
end
function c9951316.cfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c9951316.thfilter(c,code1,code2)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(9951316,code1,code2)
end
function c9951316.costcheck(g,tp)
	local code1=g:GetFirst():GetCode()
	local code2=g:GetNext():GetCode()
	local tg=Duel.GetMatchingGroup(c9951316.thfilter,tp,LOCATION_DECK,0,nil,code1,code2)
	return tg:GetClassCount(Card.GetCode)>=2
end
function c9951316.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c9951316.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c9951316.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return g:CheckSubGroup(c9951316.costcheck,2,2,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c9951316.costcheck,false,2,2,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c9951316.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local code1=g:GetFirst():GetCode()
	local code2=g:GetNext():GetCode()
	local tg=Duel.GetMatchingGroup(c9951316.thfilter,tp,LOCATION_DECK,0,nil,code1,code2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=tg:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if sg then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
Duel.Hint(HINT_SOUND,0,aux.Stringid(9951316,2))
end
function c9951316.decon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRelateToBattle() and c:GetBattleTarget():IsType(TYPE_MONSTER)
end
function c9951316.defilter(c)
	return c:IsFaceup()
end
function c9951316.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c9951316.defilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9951316.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9951316.defilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
Duel.Hint(HINT_MUSIC,0,aux.Stringid(9951316,0))
end
function c9951316.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c9951316.filter(c)
	return c:IsSetCard(0xba5) and c:IsAbleToHand()
end
function c9951316.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9951316.filter,tp,LOCATION_DECK,0,3,nil) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c9951316.operation2(e,tp,eg,ep,ev,re,r,rp)
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount>aux.DrawReplaceMax or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9951316.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			sg:RemoveCard(tc)
		end
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
