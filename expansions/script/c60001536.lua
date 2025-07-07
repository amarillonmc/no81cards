--裁决的安纳提玛·罗德欧
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(3)
	e2:SetCondition(cm.descon)
	e2:SetTarget(cm.destg)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--evolve eff
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.econ)
	ee1:SetValue(cm.eval)
	c:RegisterEffect(ee1)
	local ee2=ee1:Clone()
	ee2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee2)
	local ee3=Effect.CreateEffect(c)
	ee3:SetDescription(aux.Stringid(m,2))
	ee3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	ee3:SetType(EFFECT_TYPE_QUICK_O)
	ee3:SetCode(EVENT_FREE_CHAIN)
	ee3:SetRange(LOCATION_MZONE)
	ee3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_NO_TURN_RESET)
	ee3:SetCountLimit(1)
	ee3:SetCondition(cm.econ2)
	ee3:SetTarget(cm.tg)
	ee3:SetOperation(cm.op)
	c:RegisterEffect(ee3)
end
function cm.spfil(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL) and c:IsCanHaveCounter(0x625) and Duel.IsCanAddCounter(c:GetControler(),0x625,1,c)
end
function cm.spcon(e,c)
	local g=Duel.GetMatchingGroup(cm.spfil,tp,LOCATION_GRAVE,0,nil)
	if c==nil then return true end
	return g:GetClassCount(Card.GetCode)>=3
end
function cm.efil(c)
	return c:IsCanHaveCounter(0x625) and Duel.IsCanAddCounter(c:GetControler(),0x625,1,c) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:CheckActivateEffect(false,false,false)~=nil
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.efil,tp,LOCATION_DECK,0,3,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>2 and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<3 or not Duel.IsExistingMatchingCard(cm.efil,tp,LOCATION_DECK,0,3,nil) 
		or not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) then return end
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local sg=Duel.SelectMatchingCard(tp,cm.efil,tp,LOCATION_DECK,0,3,3,nil)
		if #sg>2 then
			for tc in aux.Next(sg) do
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local te=tc:GetActivateEffect()
				te:UseCountLimit(tp,1,true)
				cm.ActivateCard(tc,tp,e)
			end
		end
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
function cm.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_SZONE) and c:IsReason(REASON_EFFECT)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and e:GetHandler():IsCanAddCounter(0x624,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if not c:IsRelateToEffect(e) then return end
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		c:AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,0,0,1)
	end
end
function cm.econ(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.econ2(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=3
end
function cm.eval(e,c)
	return e:GetHandler():GetCounter(0x624)*400
end
function cm.filter(c,e,tp)
	return c:IsCanHaveCounter(0x624) and Duel.IsCanAddCounter(c:GetControler(),0x624,1,c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_MONSTER)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT) and Duel.IsExistingMatchingCard(cm.cfil,tp,LOCATION_MZONE,0,1,nil) then
			local num=0
			if Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT) then
				num=num+1
				if Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) and Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT) then
					num=num+1
					if Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) and Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_EFFECT) then
						num=num+1
					end
				end
			end
			if num==0 then return end
			for i=1,num do
				if Duel.IsExistingMatchingCard(cm.cfil,tp,LOCATION_MZONE,0,1,nil) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
					local tc=Duel.SelectMatchingCard(tp,cm.cfil,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
					tc:AddCounter(0x624,1)
					Duel.RegisterFlagEffect(tp,60002148,0,0,1)
				end
			end
		end
	end
end
function cm.cfil(c)
	return c:IsFaceup() and c:IsCanAddCounter(0x624,1) and c:IsType(TYPE_MONSTER)
end







