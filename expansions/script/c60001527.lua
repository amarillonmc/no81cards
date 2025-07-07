--神圣猎鹰
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	--eup
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.incon)
	ee1:SetValue(800)
	c:RegisterEffect(ee1)
	local ee2=ee1:Clone()
	ee2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee2)

	local ee3=Effect.CreateEffect(c)
	ee3:SetDescription(aux.Stringid(m,0))
	ee3:SetCategory(CATEGORY_DRAW)
	ee3:SetType(EFFECT_TYPE_QUICK_O)
	ee3:SetCode(EVENT_FREE_CHAIN)
	ee3:SetRange(LOCATION_MZONE)
	ee3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	ee3:SetCountLimit(1)
	ee3:SetCondition(cm.incon)
	ee3:SetTarget(cm.etg)
	ee3:SetOperation(cm.eop)
	c:RegisterEffect(ee3)
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanAddCounter(tp,0x624,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x624)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc and c:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)~=0 then
		c:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
	end
end
function cm.efil(c)
	return c:IsCanHaveCounter(0x625) and Duel.IsCanAddCounter(c:GetControler(),0x625,1,c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:CheckActivateEffect(false,false,false)~=nil
end
function cm.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.efil,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 or not Duel.IsPlayerCanDraw(tp,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.efil,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		cm.ActivateCard(tc,tp,e)
	end
end
function cm.ActivateCard(c,tp,oe)
	local e=c:GetActivateEffect()
	local cos,tg,op=e:GetCost(),e:GetTarget(),e:GetOperation()
	if e and (not cos or cos(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
		oe:SetProperty(e:GetProperty())
		local code=c:GetOriginalCode()
		Duel.Hint(HINT_CARD,tp,code)
		Duel.Hint(HINT_CARD,1-tp,code)
		e:UseCountLimit(tp,1,true)
		c:CreateEffectRelation(e)
		if cos then cos(e,p,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g~=0 then
			local tg=g:GetFirst()
			while tg do
				tg:CreateEffectRelation(e)
				tg=g:GetNext()
			end
		end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
		c:ReleaseEffectRelation(e)
		if g then
			tg=g:GetFirst()
			while tg do
				tg:ReleaseEffectRelation(e)
				tg=g:GetNext()
			end
		end
	end
end