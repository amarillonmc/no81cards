--魔王剑-刻刻帝
local m=33400343
local cm=_G["c"..m]
function cm.initial_effect(c)
 c:EnableCounterPermit(0x34f)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
  --activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,m+10000)
	e5:SetCost(cm.cost2)
	e5:SetTarget(cm.tg)
	e5:SetOperation(cm.tgop2)
	c:RegisterEffect(e5)
 --back
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(cm.backon)
	e9:SetOperation(cm.backop)
	c:RegisterEffect(e9)
end
function cm.refilter(c,tp,re)
	local flag=true
	local value={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)}
	if #value>0 then
		for k,re in ipairs(value) do
			local val=re:GetTarget()
			if val and val(re,c,tp) then
				flag=false
			end
		end 
	end
	return  c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP)  and flag)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp)
	if g:GetCount()>0  then  
		local ck=0 
		local tc=g:GetFirst()
		Duel.Release(tc,REASON_COST)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
	return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil)
	end
end
function cm.cfilter(c)
	return c:IsSetCard(0x3340,0x3341) and c:IsAbleToGraveAsCost()
end
function cm.thfilter2(c,tp)
	return c:IsCode(33400113) 
		and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp))
end
function cm.thfilter(c)
	return c:IsSetCard(0x3340,0x6340)  and c:IsAbleToHand()
end
function cm.tgop2(e,tp,eg,ep,ev,re,r,rp)
	local key=1
		local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_HAND+LOCATION_MZONE,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,5)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)  
			key=0
			 if Duel.IsExistingMatchingCard(cm.thfilter2,tp,0,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,1,nil,1-tp) and Duel.SelectYesNo(1-tp,aux.Stringid(m,6)) then
				Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPERATECARD)
				local g3=Duel.SelectMatchingCard(1-tp,cm.thfilter2,1-tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,1-tp)
				local tc=g3:GetFirst()
				if tc then
					local b1=tc:IsAbleToHand()
					local b2=tc:GetActivateEffect():IsActivatable(1-tp)
					if b1 and (not b2 or Duel.SelectOption(1-tp,1190,1150)==0) then
						Duel.SendtoHand(tc,nil,REASON_EFFECT)
						Duel.ConfirmCards(tp,tc)
					else
						Duel.MoveToField(tc,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
						local te=tc:GetActivateEffect()
						local tep=tc:GetControler()
						local cost=te:GetCost()
						if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					end
					Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
				end		 
			end
		end
	if key==1 then 
	   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		 local tdg1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
		Duel.SendtoDeck(tdg1,nil,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
		 local tdg1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,3,nil)
		Duel.SendtoDeck(tdg1,nil,2,REASON_EFFECT)
		  e:GetHandler():AddCounter(0x34f,4)
		 if  Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		end
	end
end 

function cm.backon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return m-10 and c:GetOriginalCode()==m
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(m-10)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(m-10,0,0)
end

