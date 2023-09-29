local m=53755001
local cm=_G["c"..m]
cm.name="SRT兔子小队 宫子"
cm.Rabbit_Team_Number_1=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.RabbitTeam(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(cm.accost)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
end
function cm.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3 end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	Duel.SetTargetCard(g)
end
function cm.acfilter(c,tp)
	return c:IsSetCard(0x5536) and c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp,true)
end
function cm.desfil(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function cm.checkfil(c,atk)
	return c:IsFacedown() or c:GetBaseAttack()>=atk
end
function cm.desfilter(c,tp)
	local g=c:GetColumnGroup():Filter(cm.desfil,nil,tp)
	return c:IsFaceup() and #g>0 and not g:IsExists(cm.checkfil,1,nil,c:GetBaseAttack())
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=g:GetCount()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=ct then return end
	if ct>0 and g:FilterCount(cm.acfilter,nil,tp)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local sc=g:FilterSelect(tp,cm.acfilter,1,1,nil,tp):GetFirst()
		Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=sc:GetActivateEffect()
		local tep=sc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(sc,73734821,te,0,tp,tp,Duel.GetCurrentChain())
		g:RemoveCard(sc)
		ct=ct-1
	end
	if ct>0 then
		for exc in aux.Next(g) do Duel.MoveSequence(exc,0) end
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),1)
		end
		if Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
