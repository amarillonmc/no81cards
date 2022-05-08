--乱色猎人
local m=60001143
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c60001129") end) then require("script/c60001129") end
cm.isColorSong=true  --乱色狂歌
function cm.initial_effect(c)
--e1
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCost(cm.cost)
	e0:SetOperation(cm.activate)
	c:RegisterEffect(e0)
	--cannot be destroyed
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--cannot set/activate
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_SSET)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,0)
	e8:SetTarget(cm.setlimit)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_FZONE)
	e9:SetTargetRange(1,0)
	e9:SetValue(cm.actlimit)
	c:RegisterEffect(e9)
--e2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
--e3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,m+1000)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	Color_Song.AddCount(c)
end
--e1
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(cm.tgop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,4)
	c:SetTurnCounter(0)
	c:RegisterEffect(e1)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==1 then Duel.SendtoGrave(c,REASON_RULE) end
end
function cm.tgf1(c)
	return c.isColorSong and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Color_Song.Record_Op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgf1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoGrave(sg,REASON_EFFECT)>0 then
			Duel.BreakEffect()
			Color_Song.AddC(tp)
		end
	end
	Color_Song.UseEffect(e,tp)
end
function cm.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return end
	if not Duel.IsPlayerCanDraw(tp,1) or not Duel.IsPlayerCanDraw(1-tp,1) then return false end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return te and tc.isColorSong and tc:IsLocation(LOCATION_ONFIELD) and p==tp and rp==1-tp
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.op2op)
end
function cm.op2op(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if tc1 then Duel.SendtoGrave(tc1,REASON_RULE) end
	local tc2=Duel.SelectMatchingCard(1-tp,nil,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if tc2 then Duel.SendtoGrave(tc2,REASON_RULE) end
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)>0 then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetCondition(cm.op3con)
		e2:SetValue(RACE_ZOMBIE)
		c:RegisterEffect(e2)
	end
end
function cm.op3conf(c)
	return c:IsFacedown() and c:GetFlagEffect(m)~=0
end
function cm.op3con(e)
	return Duel.IsExistingMatchingCard(cm.op3conf,0,LOCATION_FZONE,0,1,nil)
end