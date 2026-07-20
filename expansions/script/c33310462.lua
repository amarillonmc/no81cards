--织巢之血 幻指护父
local s,id=GetID()

s.VHisc_WEAVENEST=true
s.VHisc_HUANZHI=true
local CARD_GALLERY=33310470
local CARD_RYOSHU=33310451
local EFFECT_RYOSHU_QUICK=0x53360001

function s.initial_effect(c)
	--连接召唤手续
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,99,s.lcheck)
	--①：每次玩家受到伤害时攻击力上升
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--②：把对方怪兽作为永续魔法放置
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(s.placecon)
	e2:SetCost(s.placecost)
	e2:SetTarget(s.placetg)
	e2:SetOperation(s.placeop)
	c:RegisterEffect(e2)
	--③：给予良秀攻击力上升效果
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.grantcon)
	e3:SetTarget(s.atktg)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--③：给予良秀对方回合发动效果的标记
	local ge=Effect.CreateEffect(c)
	ge:SetType(EFFECT_TYPE_SINGLE)
	ge:SetCode(EFFECT_RYOSHU_QUICK)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(s.grantcon)
	e4:SetTarget(s.granttg)
	e4:SetLabelObject(ge)
	c:RegisterEffect(e4)
end

--连接素材
function s.matfilter(c)
	return c.VHisc_WEAVENEST or c.VHisc_HUANZHI
end

function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(s.matfilter,1,nil)
end

--①
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

--②
function s.placecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()>=3000
end

function s.placecost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
end

function s.placefilter(c,e)
	return not c:IsType(TYPE_TOKEN) and not c:IsImmuneToEffect(e)
end

function s.placetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.placefilter,tp,0,LOCATION_MZONE,1,nil,e) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thfilter(c)
	return c:IsCode(CARD_GALLERY) and c:IsAbleToHand()
end

function s.placeop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	if ft<=0 then return end
	local g=Duel.GetMatchingGroup(s.placefilter,tp,0,LOCATION_MZONE,nil,e)
	local ct=math.min(ft,#g)
	if ct<=0 then return end
	local sg=g
	if #g>ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		sg=g:Select(tp,ct,ct,nil)
	end
	local pg=Group.CreateGroup()
	for tc in aux.Next(sg) do
		if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_MSCHANGE)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_ADD_CODE)
			e2:SetValue(CARD_GALLERY)
			tc:RegisterEffect(e2)
			pg:AddCard(tc)
		end
	end
	if #pg==0 then return end
	if Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end

--③
function s.grantcon(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end

function s.gravefilter(c)
	return c:IsCode(id) and c:IsReason(REASON_DESTROY) and not c:IsDisabled()
end

function s.granttg(e,c)
	if not c:IsFaceup() or not c:IsCode(CARD_RYOSHU) then return false end
	local h=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.gravefilter,h:GetControler(),LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst()
	while tc do
		if tc~=h and tc:GetFieldID()<h:GetFieldID() then return false end
		tc=g:GetNext()
	end
	c:RegisterFlagEffect(33310451,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	return true
end

function s.atktg(e,c)
	if not c:IsFaceup() or not c:IsCode(CARD_RYOSHU) then return false end
	local h=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.gravefilter,h:GetControler(),LOCATION_GRAVE,0,nil)
	local tc=g:GetFirst()
	while tc do
		if tc~=h and tc:GetFieldID()<h:GetFieldID() then return false end
		tc=g:GetNext()
	end
	return true
end