--女神之令-夕
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	--①：检索 (同调召唤成功 或 送去墓地)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--②：展示魔陷适用效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1,id+1)
	e3:SetCost(s.effcost)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
end

-- === 效果① ===
function s.matfilter(c)
	return c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(s.matfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end

function s.thfilter(c)
	return c:IsSetCard(0x611) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- === 效果② ===
function s.fgfilter(c)

	return c:IsRace(RACE_WARRIOR+RACE_SPELLCASTER)  
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

function s.revfilter(c,tp)
	if not (c:IsSetCard(0x611) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()) then return false end
	-- 预检：如果是魔法卡，必须我方有满足条件的怪兽，且对方手卡数>0
	if c:IsType(TYPE_SPELL) then
		return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 
			and Duel.IsExistingMatchingCard(s.fgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	end
	return true
end

function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.revfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.revfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_SPELL) then
		e:SetLabel(1) -- 魔法
	else
		e:SetLabel(2) -- 陷阱
	end
	Duel.ShuffleHand(tp)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ty=e:GetLabel()
	if ty==2 then
		e:SetCategory(CATEGORY_LVCHANGE)
	else
		e:SetCategory(0)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local ty=e:GetLabel()
	local c=e:GetHandler()
	
	if ty==1 then
		-- ●魔法：尽可能把自己的场上·墓地的战士族·魔法师族而光属性的怪兽的数量的对方的手卡确认。
		local ct=Duel.GetMatchingGroupCount(s.fgfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
		local opp_hand=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		if ct>0 and #opp_hand>0 then
			local count = math.min(ct, #opp_hand)
			-- 随机选择对方手卡进行确认
			local sg=opp_hand:RandomSelect(tp,count)
			Duel.ConfirmCards(tp,sg)
			if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Recover(tp,500,REASON_EFFECT)
			end
			Duel.ShuffleHand(1-tp)
		end
		
	elseif ty==2 then
		-- ●陷阱：这个回合，对方场上怪兽下降自己场上对应怪兽数量的数值
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(s.lvval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.lvval(e,c)
	local tp=e:GetHandlerPlayer()
	local ct=Duel.GetMatchingGroupCount(s.fgfilter_field,tp,LOCATION_MZONE,0,nil)
	return -ct
end

function s.fgfilter_field(c)
	return c:IsRace(RACE_WARRIOR|RACE_SPELLCASTER) and c:IsFaceup()
end