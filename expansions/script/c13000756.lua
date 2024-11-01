--奇迹之力
local m=13000756
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,2,cm.ovfilter,aux.Stringid(m,0))
	--change effect 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.chcon)
	e2:SetTarget(cm.chtg)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
	--SpecialSummon success 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	--e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetLabelObject(e2)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
end
function cm.mfilter(c,xyzc)
	return c:IsXyzType(TYPE_XYZ)
end
function cm.xyzcheck(g)
	return g:GetClassCount(Card.GetRank)>1
end
function cm.ovfilter(c)
	local tp=c:GetControler()
	if Duel.GetTurnPlayer()~=tp or Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)<6 then return false end
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
--check
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) or Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.setfilter1(c)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_MZONE) or not c:IsForbidden())
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local hg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local fg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local g=Group.__add(hg,fg)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	if g:IsExists(Card.IsCode,1,nil,ac) and Duel.IsExistingMatchingCard(cm.setfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter1),tp,LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,1,1,nil):GetFirst()
		if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
			local e2=e:GetLabelObject():Clone()
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	else
		if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)		   
		end
	end
	Duel.ShuffleHand(1-tp)
end
--set
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS 
		and re:GetHandlerPlayer()~=e:GetHandlerPlayer() and Duel.IsChainNegatable(ev)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.BreakEffect()
	local lo=Duel.GetMatchingGroup(nil,tp,LOCATION_DECK,0,nil)
	local lg=Group.CreateGroup()--lo:Filter(aux.dncheck,nil)
	for tc in aux.Next(lo) do
		local io2=lg:Filter(Card.IsCode,nil,tc:GetCode())
		if #io2==0 then
			lg:AddCard(tc)
		end
	end
	if lg:GetCount()>2 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	local g=lg:RandomSelect(tp,3)
	Duel.ConfirmCards(tp,g)
	Duel.ConfirmCards(1-tp,g)
	if g:IsExists(Card.IsCode,1,nil,ac) and Duel.IsExistingMatchingCard(cm.setfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp,0) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.setfilter1),tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp,0):GetFirst()
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)  
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(m,1))
			e2:SetCategory(CATEGORY_NEGATE)
			e2:SetType(EFFECT_TYPE_QUICK_F)
			e2:SetCode(EVENT_CHAINING)
			e2:SetRange(LOCATION_SZONE)
			e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e2:SetCountLimit(1)
			e2:SetCondition(cm.chcon)
			e2:SetTarget(cm.chtg)
			e2:SetOperation(cm.chop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
		Duel.ShuffleDeck(tp)
	end
end
end
function cm.setfilter2(c,tp,ft)
	if c:IsFacedown() then return false end
	local p=c:GetOwner()
	if p~=tp then ft=0 end
	local r=LOCATION_REASON_TOFIELD
	if not c:IsControler(p) then
		if not c:IsAbleToChangeControler() then return false end
		r=LOCATION_REASON_CONTROL
	end
	return Duel.GetLocationCount(p,LOCATION_SZONE,tp,r)>ft
end








