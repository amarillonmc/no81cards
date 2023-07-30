--创造物扫描
local m=60002262
local cm=_G["c"..m]
function cm.initial_effect(c)
	Art_g=Group.CreateGroup()
	Art_g:KeepAlive()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x6a9) and tc:IsType(TYPE_MONSTER) then
			Art_g:AddCard(tc)
		end
		tc=eg:GetNext()
	end
end  
function cm.thfilter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x6a9) and c:IsAbleToDeck() and c:IsCanBeEffectTarget(e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_GRAVE,0,nil,e)
		if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		Duel.SetTargetCard(g1)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local sg=g:Filter(Card.IsRelateToEffect,nil,e)
		if sg and sg:GetCount()==2 then
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			if Art_g:GetClassCount(Card.GetCode)>=6 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
end