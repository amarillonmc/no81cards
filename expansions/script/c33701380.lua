--动物朋友 豺狗
local m=33701380
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(cm.potg)
	e2:SetOperation(cm.poop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	if not aux.Monster_Friend_Time_Check then
		aux.Monster_Friend_Time_Check=true
		Monster_Friend_Time={}
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCondition(cm.checkcon)
		e1:SetOperation(cm.checkop)
		Duel.RegisterEffect(e1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_TURN_END)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.check(table,value)
	for i,v in ipairs(table) do
		if v==value then
			return true
		end
	end
	return false
end
function cm.checkcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local code1,code2=rc:GetCode()
	return not cm.check(Monster_Friend_Time,code1) and not cm.check(Monster_Friend_Time,code2) and rc:IsSetCard(0x442) and re:IsActiveType(TYPE_MONSTER)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local code1,code2=rc:GetCode()
	if code1 then
		table.insert(Monster_Friend_Time,code1)
	end
	if code2 then
		table.insert(Monster_Friend_Time,code2)
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	Monster_Friend_Time={}
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return #Monster_Friend_Time>2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.potg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function cm.poop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		if #Monster_Friend_Time>2 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CHANGE_DAMAGE)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(1,0)
			e2:SetValue(cm.val)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
		if #Monster_Friend_Time>6 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			c:RegisterEffect(e4)
		end
		if #Monster_Friend_Time>9 then
			local e5=Effect.CreateEffect(c)
			e5:SetDescription(aux.Stringid(m,1))
			e5:SetCategory(CATEGORY_TOGRAVE)
			e5:SetType(EFFECT_TYPE_IGNITION)
			e5:SetCode(EVENT_FREE_CHAIN)
			e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e5:SetRange(LOCATION_MZONE)
			e5:SetCountLimit(1)
			e5:SetTarget(cm.tgtg)
			e5:SetOperation(cm.tgop)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e5)
		end
	end
end
function cm.val(e,re,dam,r,rp,rc)
	return dam/2
end
function cm.tgfilter(c)
	return c:IsAbleToGrave()
end
function cm.count(c)
	return c:IsFaceup() and c:IsSetCard(0x442)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.tgfilter(chkc) end
	local ct=Duel.GetMatchingGroupCount(cm.count,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		return ct>0 and Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end