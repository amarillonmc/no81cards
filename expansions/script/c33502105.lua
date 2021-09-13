--自然色彩 岚紫罗兰
Duel.LoadScript("c33502100.lua")
local m=33502105
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1,e2,e9=Suyuz.tograve(c,CATEGORY_DRAW+CATEGORY_RELEASE,m,cm.op)
	--HZ
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(Suyuz.gaincon(m))
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.hop)
	c:RegisterEffect(e3)
	if not BZo_p then
		BZo_p={}
		BZo_p["Effects"]={}
	end
	BZo_p["Effects"]["c33502105"]=cm.disop
end
--e1
function cm.op(e,tp)
	local c=e:GetHandler()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(cm.disop)
	e1:SetLabel(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabel()
	if te==re or not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated()) then return end
	local tep=re:GetHandlerPlayer()
	if not (Duel.IsExistingMatchingCard(cm.splimit0,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) and Duel.IsExistingMatchingCard(cm.darw,tp,LOCATION_DECK,0,1,nil))  then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.splimit0,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		local tc=g:GetFirst()
		if Duel.Release(tc,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1)then
		Duel.Draw(tp,1,REASON_EFFECT)
		local sg=Duel.GetOperatedGroup()
		local sumg=sg:GetFirst()
			if(sumg:IsSummonable(true,nil) or sumg:IsMSetable(true,nil)) and sumg:IsRace(RACE_PLANT) and Duel.SelectYesNo(tp,aux.Stringid(m,4))then
				 Duel.ConfirmCards(1-tp,sumg)
				 if sumg then
					 Duel.Summon(tp,sumg,true,nil)
				 end
			end
		end
	end
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_PLANT)
end
function cm.splimit0(c)
	return c:IsRace(RACE_PLANT) and c:IsReleasable()
end
function cm.darw(c)
	return  c:IsAbleToHand() 
end
--e3
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=Duel.GetMatchingGroupCount(cm.splimit0,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*500
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(cm.efilter)
		tc:RegisterEffect(e1,true)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(atk)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e4)
	end
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end